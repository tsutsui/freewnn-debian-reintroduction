#!/bin/sh
set -eu

ROOT=$(git rev-parse --show-toplevel)
cd "$ROOT"

python3 debian/codex/tools/check-patch-series.py
git diff --check

if grep -R -n -E '^(---|\+\+\+) (a/|b/)?configure([[:space:]]|$)' \
    debian/patches/*.patch; then
    echo "ERROR: a quilt patch appears to modify generated configure" >&2
    exit 1
fi

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir "$TMP/candidate" "$TMP/reference"

rsync -a \
    --exclude=.git \
    --exclude=.work \
    "$ROOT/" "$TMP/candidate/"

(
    cd "$TMP/candidate"
    QUILT_PATCHES=debian/patches quilt pop -a >/dev/null 2>&1 || true
    QUILT_PATCHES=debian/patches quilt push -a
)

git archive reference/gcc15-main-20260711 |
    tar -xf - -C "$TMP/reference"

python3 "$ROOT/debian/codex/tools/compare-patched-tree.py" \
    "$TMP/candidate" "$TMP/reference"

(
    cd "$TMP/candidate"
    autoreconf -fi

    # FreeWnn's generated Makefiles use source-tree-relative references
    # to makerule.mk and do not support a separate VPATH build directory.
    # Build in place inside the disposable temporary source copy.
    LC_ALL=C ./configure CFLAGS="-O2 -g -std=gnu23"
    LC_ALL=C make -j2
)

echo "OK: Task 1 deterministic verification passed"
