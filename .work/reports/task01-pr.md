# Rebuild the logical quilt patch series

## Summary

This replaces the imported Debian `-8` patch stack with the 25 logical
patches fixed by `debian/codex/PATCH-DESIGN.md`. It keeps the working tree at
the a023 import when quilt is unapplied, excludes generated `configure`, and
documents the source and packaging provenance in `debian/README.source`.

## Old patch disposition

| Historical patch | Disposition |
|---|---|
| `newlayout` | Dropped; it is empty. |
| `makerules.mk.in` | Replaced by `1000-debian-filesystem-layout.patch`. |
| `man` | Split into `1001-fix-manpage-sections.patch` and `1002-escape-hyphen-in-atod-manpage.patch`. |
| `hardening-flags` | Dropped; a023 already propagates CPPFLAGS/LDFLAGS. |
| `hurd_support.patch` | Refreshed as `0050-define-MAXPATHLEN-fallback.patch`. |
| `fix-parallel-build.patch` | Dropped; a023 contains the corrected dependency. |
| `egrep-a.patch` | Superseded by `0005-build-dictionaries-in-C-locale.patch`. |
| `implicit_functions.diff` | Replaced by the logical configure, declaration, and prototype patches. |

## Final series

```text
0001-configure-check-standard-headers.patch
0002-configure-fix-termcap-tests.patch
0003-configure-fix-libwrap-test.patch
0004-configure-use-default-source.patch
0005-build-dictionaries-in-C-locale.patch
0010-use-system-libc-declarations.patch
0011-fix-bundled-getopt-declarations.patch
0012-remove-redundant-project-declarations.patch
0020-fix-sort-callback-interface.patch
0021-fix-qsort-comparator-signatures.patch
0022-fix-jlib-handler-callback-prototypes.patch
0023-fix-internal-callback-prototypes.patch
0024-fix-romkan-callback-prototypes.patch
0025-fix-byte-buffer-pointer-types.patch
0030-fix-signal-handler-signatures.patch
0031-make-jserver-out-variadic.patch
0032-make-atof-error-format-variadic.patch
0040-fix-wnn-sStrncpy-conversion.patch
0041-fix-jishoop-ENDPTR-comparison.patch
0042-fix-b-index-result-comparison.patch
0043-use-int-for-romkan-buffer-index.patch
0050-define-MAXPATHLEN-fallback.patch
1000-debian-filesystem-layout.patch
1001-fix-manpage-sections.patch
1002-escape-hyphen-in-atod-manpage.patch
```

## Mixed-commit split

| Commit | Logical patches |
|---|---|
| `a85b88729c2fa7d0a2ec542d737c5e19061c8a47` | sort interface -> `0020`; jlib handlers -> `0022` |
| `17578cf34877cad67c465335afbf499b88cecce1` | getopt -> `0011`; redundant declarations -> `0012` |
| `915ecd5efe7a9ab09fc073c8131687184a45dfa4` | sort interface -> `0020`; qsort comparators -> `0021`; jlib handlers -> `0022`; internal callbacks -> `0023`; byte buffers -> `0025` |
| `9618769b8e758f537db180a9389c7ce10c536163` | redundant declarations -> `0012`; internal helpers -> `0023`; signals -> `0030`; variadic `out()` -> `0031` |
| `3cc4bf1f5fd9178741dd904612f2110a9470e86b` | byte-buffer signedness -> `0025`; functional conversion fix -> `0040` |

The GCC reference also contains redundant jutil declarations removed by
`4cf1f77f2e20b8540aaf8e9478ba6e440dff2a78`; these are in `0012`, matching
that patch's approved purpose and the mandatory final-tree comparison.

## Audit and commands run

```text
git branch --show-current
git rev-parse HEAD
git show-ref --tags | rg 'refs/tags/reference/...'
git diff reference/debian-packaging-2015 -- debian/patches
git diff reference/debian-packaging-2015 debian/1.1.1_a021+cvs20130302-8 -- debian
git cat-file -e <commit>^{commit}
git merge-base --is-ancestor reference/a023-base <commit>
git merge-base --is-ancestor <commit> reference/gcc15-main-20260711
git diff --name-status reference/a023-base HEAD -- . ':(exclude)debian/**'
python3 debian/codex/tools/check-patch-series.py
python3 debian/codex/tools/compare-patched-tree.py . .work/compare-reference-1
git diff --check
debian/codex/tools/verify-task01.sh
QUILT_PATCHES=debian/patches quilt pop -a
dpkg-parsechangelog -S Distribution
grep '^Maintainer:' debian/control
```

## Passed checks

* All three authoritative reference tags exist and resolve to the expected
  a023, historical packaging, and GCC compatibility histories.
* Every design-named source commit exists between a023 and the GCC reference.
* The imported patch set matches Debian `-8`; the patch-relevant `-5` to `-8`
  delta is recorded in `debian/README.source`.
* The unapplied non-`debian/` tree matches `reference/a023-base` (excluding
  the supplied `AGENTS.md` instruction file).
* Exact 25-patch name and order check passed.
* All patches apply in order; generated `configure` is absent from patches.
* Detailed fully-patched-tree comparison passed with only design-approved
  differences.
* `git diff --check` passed.
* `autoreconf -fi` and configure completed in the deterministic verifier.
* Changelog distribution is `UNRELEASED`; Maintainer remains Debian QA Group.

## Failed or skipped checks

* `debian/codex/tools/verify-task01.sh` did not reach its success marker. Its
  out-of-tree build failed in `Wnn/jd` because the authoritative
  `Wnn/jd/Makefile.in` includes `@top_srcdir@/makerule.mk`, while configure
  writes `makerule.mk` in the out-of-tree build root. The error was:
  `No rule to make target '../../../makerule.mk'`.
* No check was skipped intentionally.

## Blockers and human decisions

The deterministic build failure needs a human decision: fix the verifier to
use a supported build layout, or authorize a separate source/build-system
change. Task 1's fixed patch design and allowed-difference list do not permit
adding such a patch here. No alternate source content was downloaded or
invented.

This candidate is **not upload-ready and has no adopter**. It does not claim
maintainer commitment, legal approval, Debian acceptance, or completed policy
and copyright review.
