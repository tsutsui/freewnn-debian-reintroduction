# Task 2 v2 — prepare the Debian unstable reintroduction candidate

Work only on the checked-out Task 2 v2 branch stacked on the reviewed Task 1
commit. Do not create, switch, commit, push, merge, or rewrite branches.

## Hard phase boundary

Task 2 must not modify `debian/patches/`, generated `configure`, or any upstream
source outside `debian/`. If a build exposes an upstream or Task 1 defect, stop
and end with `BLOCKED: UPSTREAM_OR_TASK1`; do not repair it here.

Requirements: version `1.1.1~a023-1`, `UNRELEASED`, existing t64 names/package
split, autoreconf during Debian builds, Debian QA Group Maintainer pending an
adopter, and explicit service/adoption/upload blockers.

## Compiler-mode boundary

GNU C23 forcing belongs only to the external upstream and Task 1 portability
verification. Debian source/binary package builds, GitHub Actions package
builds, and `libwnn-smoke` must use the distribution default C language mode.
Do not add `-std=gnu23`, `-std=gnu2x`, `-std=c23`, or `-std=c2x` to
`debian/rules`, `DEB_CFLAGS_*`, workflow environment/commands, or test helpers.
Do not inherit the workbook's `C_STD_FLAG` into package builds. This boundary is
required so the source package remains backportable to distributions whose
compiler default is older than GNU C23.

Create a Debian sid workflow triggered by pull requests/pushes and by
`workflow_dispatch`, whose step names exactly match `TASK02-ACTIONS-STEPS-v2.txt`. It must execute source build, binary build,
lintian, blhc, package extraction/installation, public-header compile/link/run,
and substantive C-versus-UTF-8 dictionary comparison.

Create executable helpers:

- `debian/tests/libwnn-smoke ROOT CC`: compile, link, and execute against the extracted package root;
- `debian/tests/dictionary-locales`: perform clean C and UTF-8 builds and compare substantive output content, not names/sizes alone. Use canonical text or narrowly documented normalization if volatile binary metadata exists.

Do not claim any test passed unless it ran in the final successful execution.
Update normal Debian documentation and adoption/RFP drafts. Before completion,
remove root `AGENTS.md` and tracked `debian/codex/`; never add `.work/`.

Write `.work/reports/task02-v2-pr.md` with exact passed/failed/skipped checks and
no-maintainer/no-upload statement. Do not commit or push.
