# Codex instructions for FreeWnn Debian reintroduction v2

- Follow the active task under `debian/codex/`.
- Do not create, switch, commit, push, merge, or rewrite branches.
- Do not add `.work/`, credentials, archives, or build products.
- Do not patch generated `configure`; edit `configure.in` only when the pinned upstream history does so.
- Do not hide failures with warning suppression, an older C language mode, disabled clients, `|| true`, or status-losing pipelines.
- `-std=gnu23` is only for the external upstream/Task 1 portability verifier. Do not add `-std=gnu23` or `-std=gnu2x` to Debian packaging, CI, or package smoke tests.
- Task 2 must not modify upstream source or `debian/patches/`. A source or patch-stack failure returns to upstream or Task 1.
- Do not claim Debian acceptance, licensing approval, adopter commitment, upload readiness, or tests not actually executed.
