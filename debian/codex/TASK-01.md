# Task 1 — rebuild the logical quilt patch series

Work on the branch already checked out. Do not create, switch, push, or
rewrite branches.

Read and obey:

- `/AGENTS.md`
- `debian/codex/PATCH-DESIGN.md`

## Goal

Replace the imported historical Debian patch series with the exact logical
series specified in `PATCH-DESIGN.md`.

Do not modernize general Debian packaging in this task.

## Audit before edits

1. Display current branch and HEAD.
2. Verify all three `reference/*` tags.
3. Compare imported `-8` patch files with
   `reference/debian-packaging-2015`.
4. Record every `-5` versus `-8` packaging difference relevant to patches.
5. Verify every source commit named in the design.
6. Verify the non-`debian/` tree is the a023 import before applying patches.

Stop and report rather than downloading or inventing replacement content
if an authoritative ref or expected source hunk is absent.

## Implementation

- Rebuild `debian/patches/series` exactly as specified.
- Construct one logical patch per approved purpose.
- Split mixed commits according to the mapping.
- Exclude generated `configure`.
- Preserve all approved GCC/C23 source changes.
- Apply the old Debian patch dispositions exactly.
- Add useful DEP-3 headers.
- Keep the changelog at `UNRELEASED`.
- Do not change `Maintainer`.

Update `debian/README.source` with:

- removed Debian `-8` base
- a023 tarball/import
- historical packaging VCS
- GCC compatibility reference
- old patch disposition
- split-commit mapping
- generated-configure policy
- test procedure
- unresolved work

## Required verification

Run the repository deterministic tool:

```sh
debian/codex/tools/verify-task01.sh
```

Also inspect its detailed comparison output. Do not mark the task complete
with unexplained source differences.

## Output

Write a draft PR body to:

```text
.work/reports/task01-pr.md
```

It must include:

- old patch disposition table
- final series
- mixed-commit split table
- commands run
- passed checks
- failed/skipped checks
- blockers and human decisions
- explicit statement that this is not upload-ready and has no adopter
