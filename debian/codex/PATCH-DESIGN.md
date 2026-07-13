# FreeWnn quilt patch design v2

## Fixed references

- Imported a023 base: `fa30218caa2fe0a90a81b71b85f27814906166f4`
- Human-reviewed GNU C23/full-client portability tip: `597e838fc31b3a863a353a823fdd10132681e2e9`
- Local immutable reference: `reference/gcc15-full-client-597e838f`
- Previous Task 1 evidence only: `reference/task1-v1`

The pinned tip is 37 commits ahead of the a023 base. The formerly proposed
`e1a54441389b9166f764c93ce3d42d2458793ad7` history was rewritten after
`e509485a...`; its six replacement SHAs are listed in
`SUPERSEDED-UPSTREAM-COMMITS-v2.txt`. Superseded SHAs must not remain in DEP-3
source attribution.

## Non-negotiable rules

1. Generated `configure` is never in a quilt patch. Debian builds run autoreconf.
2. Applying exactly the patches in `UPSTREAM-PATCHES-v2.txt` to a023 must reproduce the pinned upstream tree exactly, excluding generated `configure`.
3. `0050` and `1000`-series patches are Debian supplemental patches and are not part of the upstream-tree equality point.
4. Use exactly the names and order in `SERIES-v2.txt`.
5. Do not select gnu17, disable clients, add broad warning suppression, or hide failures.
6. Every patch has DEP-3 metadata and current source-commit attribution.
7. Preserve logical boundaries; split mixed commits by hunk where required.

## New/current full-client commit mapping

- `60984c64...` -> `0026-fix-uum-key-command-callback-prototypes.patch`
- `3c7a6ad4...` -> `0027-fix-uum-code-conversion-callback-types.patch`
- `e509485a...` -> `0028-fix-uum-language-callback-tables.patch`
- `0d441d33...` -> `0029-fix-uum-terminal-helper-prototypes.patch`
- `34d97369...` -> extend `0030-fix-signal-handler-signatures.patch`
- `ad810991...` -> `0033-fix-uum-utility-callback-prototypes.patch`
- `d2da3d32...` -> `0044-fix-uum-reconnect-buffer-type.patch`
- `2666caef...`, `2ad54de0...` -> extend `0012-remove-redundant-project-declarations.patch`
- `26722b82...` -> `0034-remove-obsolete-resetterm-calls.patch`
- `f8e06ee3...` -> `0045-fix-uum-ttyfdslot-return-type.patch`
- `0315820b...` -> `0006-configure-fix-term-libs-option.patch` (`configure.in` only)
- `597e838f...` -> `0007-configure-select-uum-terminal-libraries.patch` (`configure.in` only)

## Historical Debian patch disposition

Preserve the v1 decisions: drop empty `newlayout`; replace `makerules.mk.in`
with `1000`; split `man` into `1001`/`1002`; drop obsolete hardening and
parallel-build patches unless a narrowly proven current defect exists; refresh
Hurd `MAXPATHLEN` as `0050`; supersede `egrep-a` with `0005`; replace the old
implicit-function patch with the logical modern series.

## Mandatory build matrix

Each profile uses a separate disposable in-tree source copy, the system default
`gcc` (GCC 14 on Debian 13), and `-std=gnu23`:

1. default `./configure`
2. `--enable-client=yes --enable-debug`
3. Debian profile with `/usr` layout and disabled client utmp/setgid
4. full client with explicit `--with-term-libs="$(pkg-config --libs ncurses)"`

Passing only the default profile is a Task 1 failure.
