# Task 2 — prepare the Debian unstable reintroduction candidate

Work on the branch already checked out. It is stacked on Task 1.
Do not create, switch, push, or rewrite branches.

Read and obey:

- `/AGENTS.md`
- `debian/codex/PATCH-DESIGN.md`
- `debian/README.source`

## Goal

Prepare a buildable, reviewable technical candidate for Debian unstable.
This is not an upload, ITP, RFP submission, or maintainer commitment.

## Packaging requirements

- Version: `1.1.1~a023-1`
- Distribution: `UNRELEASED`
- Preserve t64 binary package names and the `-8` transition state.
- Modernize only what current Debian unstable needs to build.
- Run autoreconf during Debian build.
- Do not patch generated `configure`.
- Retain existing language functionality.
- Do not redesign package split without a documented blocker.
- Do not set the repository owner as Maintainer.
- Mark Maintainer/adopter selection as an upload blocker.
- Do not guess about init/systemd policy; record a blocker if a choice is
  required.

## CI and testing

Create `.github/workflows/debian-sid-build.yml` using a Debian sid
environment.

It must:

- install build dependencies from `debian/control`
- apply the quilt series without fuzz
- run autoreconf through the package build
- build source and binary packages
- run lintian
- run blhc
- install generated Wnn runtime/development packages as needed
- compile, link, and execute a public-header `libwnn-dev` smoke test
- run dictionary generation under available C and UTF-8 locales
- fail if a quilt patch changes generated `configure`

Add deterministic local helper scripts under `debian/tests/` or
`debian/scripts/` where appropriate. Do not add an autopkgtest that is
not actually deterministic.

A jserver runtime test is optional only when it can avoid privileged
ports, external network access, and persistent system state. Otherwise
document why it remains missing.

Do not claim Mule 1.1 testing unless it was really performed.

## Documentation

Create or update:

- `debian/README.source`
- `debian/ADOPTION.md`
- `debian/RFP-draft.txt`

`ADOPTION.md` must state:

- completed technical work
- exact tests
- remaining Debian maintainer work
- expected low but nonzero maintenance burden
- repository owner may assist with upstream C portability and Mule
  compatibility
- repository owner does not commit to Debian maintenance or uploads

`RFP-draft.txt` is only a draft and must not be submitted.

## Cleanup

Before completion:

- remove root `AGENTS.md`
- remove `debian/codex/`
- preserve durable information in normal Debian documentation
- never add `.work/` or credentials

The task prompt has already been loaded, so removing these temporary files
at the end is expected.

## Verification

Use the normal build and test commands available in the repository.
The wrapper will later install the updated build dependencies and run the
external deterministic Task 2 verifier.

## Output

Write a draft stacked PR body to:

```text
.work/reports/task02-pr.md
```

Include:

- packaging changes
- CI design
- commands run
- tests passed
- tests failed/skipped
- remaining human decisions
- explicit no-maintainer/no-upload statement
