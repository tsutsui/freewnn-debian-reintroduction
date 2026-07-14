# FreeWnn Debian adoption notes

This tree is a technical candidate for reintroducing FreeWnn to Debian
unstable. It is not an upload, an ITP, or a maintainer commitment.

## Completed technical work

The source is rebased on upstream 1.1.1-a023. The quilt series preserves the
reviewed upstream C portability changes as small provenance-documented
patches, retains Japanese, Chinese, and Korean functionality, preserves the
existing package split and the `libwnn0t64`, `libcwnn0t64`, and `libkwnn0t64`
transition names, and excludes generated `configure`. Debian builds regenerate
the Autoconf files with dh-autoreconf.

CI builds source and binary packages in Debian sid, rejects fuzz and patches
to generated `configure`, runs lintian, treats only blhc status bit 8 (missing hardening flags) as advisory and fails on any other blhc status bit,
installs the locally built Wnn runtime/development packages, and executes a
public-header shared-library smoke test.

The exact reusable tests are:

    dpkg-buildpackage -us -uc -S
    dpkg-buildpackage -us -uc -b
    lintian ../freewnn_*.changes
    blhc build.log
    debian/tests/libwnn-smoke

No Mule 1.1 test has been performed. A jserver runtime test is also absent:
the current package provisions users, init integration, mutable dictionaries,
and persistent state, so a suitably isolated non-privileged test depends on
the service-policy decision below.

## Remaining maintainer work and upload blockers

An adopter must be found and an appropriate `Maintainer` selected. The Debian
copyright file and current policy compliance need human review. An adopter
must also decide whether and how the existing init scripts should be retained
or integrated with systemd; this candidate intentionally does not guess that
policy. The translated format-string uses currently built with non-fatal
format-security diagnostics need a catalog-aware source audit. The remaining
legacy client cross-file declarations and callback types also need a focused
audit; their compiler diagnostics are visible but non-fatal in this candidate.
Normal sponsor, archive, and release-team review remains necessary.

Maintenance is expected to be low but nonzero: occasional C toolchain and
Autoconf changes, Debian policy transitions, service integration, and
language-specific regression review will still require attention.

The repository owner may assist with upstream C portability and Mule
compatibility. The repository owner does not commit to Debian maintenance or
uploads.
