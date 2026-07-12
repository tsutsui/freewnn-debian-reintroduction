Implemented Task 1’s exact 25-patch logical quilt series and left the stack unapplied.

Completed:

- Audited branch, HEAD, authoritative tags, historical `-5`/`-8` differences, source commits, and a023 tree.
- Added DEP-3 metadata and preserved the approved GCC/C23 changes.
- Excluded generated `configure`.
- Updated [debian/README.source](/home/tsutsui/src/freewnn-debian-reintroduction/debian/README.source).
- Kept the changelog `UNRELEASED` and Maintainer as Debian QA Group.
- Wrote the draft PR body at [.work/reports/task01-pr.md](/home/tsutsui/src/freewnn-debian-reintroduction/.work/reports/task01-pr.md).
- Exact-series check, `git diff --check`, quilt application, and detailed GCC-reference comparison passed.

Remaining blocker: `verify-task01.sh` fails during its out-of-tree build because authoritative `Wnn/jd/Makefile.in` looks for `makerule.mk` in the source tree, while the verifier generates it in the build tree. Resolving that requires changing the verifier or authorizing an additional build-system patch; neither is permitted by Task 1’s fixed design.

This candidate is not upload-ready and has no adopter.