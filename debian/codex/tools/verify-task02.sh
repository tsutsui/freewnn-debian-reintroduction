#!/bin/sh
set -eu

REPO=${1:-$(git rev-parse --show-toplevel)}
cd "$REPO"

git diff --check

[ ! -e AGENTS.md ] || {
    echo "ERROR: temporary AGENTS.md remains" >&2
    exit 1
}
[ ! -d debian/codex ] || {
    echo "ERROR: temporary debian/codex remains" >&2
    exit 1
}

[ -f debian/ADOPTION.md ] || {
    echo "ERROR: missing debian/ADOPTION.md" >&2
    exit 1
}
[ -f debian/RFP-draft.txt ] || {
    echo "ERROR: missing debian/RFP-draft.txt" >&2
    exit 1
}
[ -f .github/workflows/debian-sid-build.yml ] || {
    echo "ERROR: missing Debian sid workflow" >&2
    exit 1
}

first=$(head -1 debian/changelog)
echo "$first" | grep -F 'freewnn (1.1.1~a023-1) UNRELEASED;' >/dev/null || {
    echo "ERROR: unexpected changelog first line: $first" >&2
    exit 1
}

for package in libcwnn0t64 libkwnn0t64 libwnn0t64; do
    grep -F "Package: $package" debian/control >/dev/null || {
        echo "ERROR: missing t64 package: $package" >&2
        exit 1
    }
done

if grep -R -n -E '^(---|\+\+\+) (a/|b/)?configure([[:space:]]|$)' \
    debian/patches/*.patch; then
    echo "ERROR: a quilt patch appears to modify generated configure" >&2
    exit 1
fi

grep -Ei 'lintian' .github/workflows/debian-sid-build.yml >/dev/null
grep -Ei 'blhc' .github/workflows/debian-sid-build.yml >/dev/null
grep -Ei 'debian:sid|unstable' .github/workflows/debian-sid-build.yml >/dev/null
grep -Ei 'libwnn|smoke' .github/workflows/debian-sid-build.yml >/dev/null

TMP="$REPO/.work/task02-build"
rm -rf "$TMP"
mkdir -p "$TMP/src"
rsync -a \
    --exclude=.git \
    --exclude=.work \
    "$REPO/" "$TMP/src/"

(
    cd "$TMP/src"
    dpkg-checkbuilddeps
    dpkg-buildpackage -us -uc -b 2>&1 | tee "$TMP/build.log"
)

changes=$(find "$TMP" -maxdepth 1 -name '*.changes' -print | head -1)
[ -n "$changes" ] || {
    echo "ERROR: no .changes generated" >&2
    exit 1
}

lintian "$changes"
blhc "$TMP/build.log"

echo "OK: Task 2 deterministic verification passed"
