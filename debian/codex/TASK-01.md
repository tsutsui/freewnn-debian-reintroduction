# Task 1 v2 — rebuild the logical quilt series from pinned tip 597e838f

Work only on the checked-out Task 1 v2 branch. Do not create, switch, commit,
push, merge, or rewrite branches.

Read and obey `/AGENTS.md`, `debian/codex/PATCH-DESIGN.md`, `SERIES-v2.txt`,
`UPSTREAM-PATCHES-v2.txt`, `NEW-UPSTREAM-COMMITS-v2.txt`,
`SUPERSEDED-UPSTREAM-COMMITS-v2.txt`, and `debian/README.source`.

Inputs:

- base `reference/a023-base`
- authoritative upstream tip `reference/gcc15-full-client-597e838f`
- previous Task 1 branch only as evidence/seed

Rebuild `debian/patches/series` using exactly the 35 names in `SERIES-v2.txt`.
Preserve approved v1 logical boundaries, replace rewritten source SHAs, and
incorporate all thirteen commits listed in `NEW-UPSTREAM-COMMITS-v2.txt`.

Required properties:

- `UPSTREAM-PATCHES-v2.txt` applied to a023 equals the authoritative tip except generated `configure`;
- generated `configure` is absent from quilt;
- all four build profiles pass with the system default `gcc` in GNU C23 mode (`-std=gnu23`);
- all DEP-3 fields and source attribution are accurate and use current SHAs;
- the working upstream source remains unapplied a023;
- no Task 2 packaging work is mixed into Task 1.

Do not invent fixes not present in the pinned upstream reference. Do not
restore obsolete `resetterm()` calls, use stale rewritten SHAs, or work around
terminal-library selection with Debian-only linker flags.

Write a draft PR body to `.work/reports/task01-v2-pr.md`, including exact patch
series, new commit mapping, four build profiles, and explicit limitations. Do
not commit or push. The external verifier is authoritative.
