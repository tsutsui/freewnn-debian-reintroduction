# Repository instructions for Codex

## Mission

Prepare a reviewable technical candidate for reintroducing FreeWnn into
Debian unstable. This repository is not an ITP, and its owner is not
volunteering to become the Debian package maintainer.

## Binding design documents

Before modifying anything, read:

- `debian/codex/PATCH-DESIGN.md`
- the task file supplied as the current prompt

The patch design is fixed. Do not replace it with a simpler large patch.

## Authoritative refs

Never rewrite, delete, move, or force-update:

- `reference/a023-base`
- `reference/gcc15-main-20260711`
- `reference/debian-packaging-2015`
- `upstream/latest`
- `pristine-tar`
- `debian/latest`

## Restrictions

- Work only on the branch already checked out by the wrapper script.
- Do not commit, push, or open pull requests; wrapper scripts do that.
- Do not use `sudo`.
- Do not install packages.
- Do not download alternate FreeWnn source trees.
- Do not copy changes from unlisted third-party repositories.
- Do not add generated `configure` to quilt patches.
- Do not use casts merely to suppress warnings.
- Keep `debian/changelog` at `UNRELEASED`.
- Do not set the repository owner as `Maintainer`.
- Do not claim upload readiness, adopter commitment, legal approval, or
  Debian acceptance.
- Put temporary output under `.work/`.
- Stop rather than guess when a named ref, source hunk, package history,
  semantic behavior, license fact, or policy choice differs from the
  specification.

## Verification

Use the deterministic tools under `debian/codex/tools/` while they exist.
A task is not complete merely because compilation succeeded.

## Task reports

Write the pull-request body requested by each task to:

- Task 1: `.work/reports/task01-pr.md`
- Task 2: `.work/reports/task02-pr.md`
