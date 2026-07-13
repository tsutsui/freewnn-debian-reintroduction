#!/usr/bin/env bash
set -Eeuo pipefail
SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)
source "$SCRIPT_DIR/../scripts/common/lib.sh"
workbook_init "$0"
init_component TASK1_VERIFY
for cmd in git python3 patch "$CC_BIN" autoreconf make tar pkg-config; do require_cmd "$cmd" || fail_final "missing command: $cmd"; done
cd "$REPO_DIR"; ensure_work_dirs; ensure_work_not_tracked || fail_final '.work is tracked'
rm -f .work/evidence/task01-v2.env .work/logs/task01-series-v2.log .work/logs/task01-patch-policy-v2.log \
 .work/logs/task01-unapplied-source-v2.log .work/logs/task01-apply-*.log .work/logs/task01-tree-compare-v2.log \
 .work/logs/task01-build-*-v2.log .work/logs/task01-diff-check-v2.log

python3 "$WORKBOOK_DIR/tools/check-patch-series-v2.py" "$REPO_DIR" "$WORKBOOK_DIR/expected/task01-series-v2.txt" \
    >.work/logs/task01-series-v2.log 2>&1 || fail_final 'exact patch series check failed'
python3 "$WORKBOOK_DIR/tools/check-patch-policy-v2.py" "$REPO_DIR" \
    "$WORKBOOK_DIR/expected/task01-series-v2.txt" "$WORKBOOK_DIR/expected/upstream-patches-v2.txt" \
    "$WORKBOOK_DIR/expected/new-upstream-commits-v2.txt" "$WORKBOOK_DIR/expected/superseded-upstream-commits-v2.txt" \
    >.work/logs/task01-patch-policy-v2.log 2>&1 || fail_final 'patch policy or attribution check failed'

if ! git diff --quiet "$UPSTREAM_BASE_SHA" -- . \
    ':(exclude)debian/**' ':(exclude).github/**' ':(exclude).gitignore' ':(exclude)AGENTS.md'; then
    git diff "$UPSTREAM_BASE_SHA" -- . ':(exclude)debian/**' ':(exclude).github/**' ':(exclude).gitignore' ':(exclude)AGENTS.md' \
        >.work/logs/task01-unapplied-source-v2.log
    fail_final 'working source tree is not the unapplied a023 base'
fi
untracked=$(git ls-files --others --exclude-standard | grep -Ev '^(\.work/|AGENTS\.md$|debian/codex/)' || true)
[[ -z "$untracked" ]] || fail_final "unexpected untracked paths: $untracked"

TMP="$REPO_DIR/.work/task01-v2"; rm -rf "$TMP"; mkdir -p "$TMP/base" "$TMP/reference"
git archive "$UPSTREAM_BASE_SHA" | tar -xf - -C "$TMP/base"
git archive "$UPSTREAM_REFERENCE" | tar -xf - -C "$TMP/reference"
apply_set() {
    local target=$1 list=$2 name
    mkdir -p "$target/debian/patches"
    cp debian/patches/*.patch "$target/debian/patches/"
    : >"$REPO_DIR/.work/logs/task01-apply-$(basename "$list").log"
    while read -r name; do
        [[ -n "$name" ]] || continue
        patch --batch --fuzz=0 --no-backup-if-mismatch -d "$target" -p1 \
            <"debian/patches/$name" >>"$REPO_DIR/.work/logs/task01-apply-$(basename "$list").log" 2>&1 || return 1
    done <"$list"
}
cp -a "$TMP/base" "$TMP/upstream-candidate"
apply_set "$TMP/upstream-candidate" "$WORKBOOK_DIR/expected/upstream-patches-v2.txt" || fail_final 'upstream patch subset did not apply with fuzz zero'
python3 "$WORKBOOK_DIR/tools/compare-source-trees-v2.py" "$TMP/upstream-candidate" "$TMP/reference" \
    >.work/logs/task01-tree-compare-v2.log 2>&1 || fail_final 'upstream patch subset differs from pinned upstream tip'
cp -a "$TMP/base" "$TMP/full-candidate"
apply_set "$TMP/full-candidate" "$WORKBOOK_DIR/expected/task01-series-v2.txt" || fail_final 'full patch series did not apply with fuzz zero'

run_profile() {
    local profile=$1; shift
    local src="$TMP/build-$profile" log="$REPO_DIR/.work/logs/task01-build-$profile-v2.log"
    rm -rf "$src"; cp -a "$TMP/full-candidate" "$src"
    (cd "$src" && autoreconf -fi && CC="$CC_BIN" CFLAGS="-O2 -g $C_STD_FLAG" ./configure "$@" && make -j"$MAKE_JOBS") >"$log" 2>&1
}
run_profile default || fail_final 'default GNU C23 build failed'
run_profile full-client --enable-client=yes --enable-debug || fail_final 'full-client GNU C23 build failed'
run_profile debian-profile --prefix=/usr --mandir=/usr/share/man --enable-client=yes --enable-debug \
    --disable-traditional-layout --disable-client-utmp --disable-client-setgid || fail_final 'Debian-profile GNU C23 build failed'
term_libs=$(pkg-config --libs ncurses 2>/dev/null || printf '%s' '-lncurses -ltinfo')
run_profile explicit-term-libs --enable-client=yes --enable-debug --with-term-libs="$term_libs" || fail_final 'explicit terminal-library build failed'
git diff --check >.work/logs/task01-diff-check-v2.log 2>&1 || fail_final 'git diff --check failed'

expected_count=$(grep -cvE '^($|#)' "$WORKBOOK_DIR/expected/task01-series-v2.txt")
cat >.work/evidence/task01-v2.env <<EOF
VERIFIER_SHA256=$(sha256_file "$WORKBOOK_DIR/tools/verify-task01-v2.sh")
VERIFIED_BRANCH=$(git branch --show-current)
VERIFIED_TREE_SHA=$(git write-tree)
UPSTREAM_TIP_SHA=$UPSTREAM_TIP_SHA
COMPILER=$CC_BIN
COMPILER_VERSION=$("$CC_BIN" --version | sed -n '1p')
C_STD_FLAG=$C_STD_FLAG
EXPECTED_PATCHES=$expected_count
SERIES=PASS
PATCH_POLICY=PASS
UNAPPLIED_SOURCE_BASE=PASS
UPSTREAM_TREE_COMPARISON=PASS
DEFAULT_PROFILE=PASS
FULL_CLIENT_PROFILE=PASS
DEBIAN_PROFILE=PASS
EXPLICIT_TERM_LIBS_PROFILE=PASS
GENERATED_CONFIGURE_PATCH=ABSENT
FINAL_RESULT=PASS
EOF
pass_final
