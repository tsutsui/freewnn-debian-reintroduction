#!/usr/bin/env python3
from pathlib import Path
import sys

EXPECTED = [
    "0001-configure-check-standard-headers.patch",
    "0002-configure-fix-termcap-tests.patch",
    "0003-configure-fix-libwrap-test.patch",
    "0004-configure-use-default-source.patch",
    "0005-build-dictionaries-in-C-locale.patch",
    "0010-use-system-libc-declarations.patch",
    "0011-fix-bundled-getopt-declarations.patch",
    "0012-remove-redundant-project-declarations.patch",
    "0020-fix-sort-callback-interface.patch",
    "0021-fix-qsort-comparator-signatures.patch",
    "0022-fix-jlib-handler-callback-prototypes.patch",
    "0023-fix-internal-callback-prototypes.patch",
    "0024-fix-romkan-callback-prototypes.patch",
    "0025-fix-byte-buffer-pointer-types.patch",
    "0030-fix-signal-handler-signatures.patch",
    "0031-make-jserver-out-variadic.patch",
    "0032-make-atof-error-format-variadic.patch",
    "0040-fix-wnn-sStrncpy-conversion.patch",
    "0041-fix-jishoop-ENDPTR-comparison.patch",
    "0042-fix-b-index-result-comparison.patch",
    "0043-use-int-for-romkan-buffer-index.patch",
    "0050-define-MAXPATHLEN-fallback.patch",
    "1000-debian-filesystem-layout.patch",
    "1001-fix-manpage-sections.patch",
    "1002-escape-hyphen-in-atod-manpage.patch",
]


def main() -> int:
    series = Path("debian/patches/series")
    if not series.is_file():
        print("missing debian/patches/series", file=sys.stderr)
        return 1
    actual = []
    for line in series.read_text(encoding="utf-8").splitlines():
        stripped = line.strip()
        if stripped and not stripped.startswith("#"):
            actual.append(stripped.split()[0])
    if actual != EXPECTED:
        print("patch series differs from the approved order", file=sys.stderr)
        print("EXPECTED:", *EXPECTED, sep="\n  ", file=sys.stderr)
        print("ACTUAL:", *actual, sep="\n  ", file=sys.stderr)
        return 1
    missing = [name for name in EXPECTED if not (Path("debian/patches") / name).is_file()]
    if missing:
        print("missing patch files:", *missing, sep="\n  ", file=sys.stderr)
        return 1
    print(f"OK: exact approved patch series ({len(EXPECTED)} patches)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
