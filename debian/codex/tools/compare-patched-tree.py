#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
from pathlib import Path
import sys

ALLOWED = (
    "makerule.mk.in",
    "Wnn/include/msg.h",
    "Wnn/jserver/de_header.h",
    "Wnn/man/",
    "cWnn/man/",
    "kWnn/man/",
)

EXCLUDED = (
    "debian/",
    ".git/",
    ".work/",
    ".pc/",
    "autom4te.cache/",
)

EXACT_EXCLUDED = {
    "configure",
    "AGENTS.md",
}


def digest(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for block in iter(lambda: f.read(1024 * 1024), b""):
            h.update(block)
    return h.hexdigest()


def tree(root: Path) -> dict[str, str]:
    result: dict[str, str] = {}
    for path in sorted(root.rglob("*")):
        if not path.is_file() and not path.is_symlink():
            continue
        rel = path.relative_to(root).as_posix()
        if rel in EXACT_EXCLUDED or any(rel.startswith(p) for p in EXCLUDED):
            continue
        if path.is_symlink():
            result[rel] = "SYMLINK:" + str(path.readlink())
        else:
            result[rel] = digest(path)
    return result


def allowed(path: str) -> bool:
    return path in ALLOWED or any(
        prefix.endswith("/") and path.startswith(prefix) for prefix in ALLOWED
    )


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument("candidate", type=Path)
    p.add_argument("reference", type=Path)
    args = p.parse_args()

    cand = tree(args.candidate)
    ref = tree(args.reference)
    paths = sorted(set(cand) | set(ref))
    bad = []
    allowed_diff = []

    for path in paths:
        if cand.get(path) == ref.get(path):
            continue
        entry = (
            path,
            "candidate-only" if path not in ref
            else "reference-only" if path not in cand
            else "different",
        )
        if allowed(path):
            allowed_diff.append(entry)
        else:
            bad.append(entry)

    print("Allowed differences:")
    for path, kind in allowed_diff:
        print(f"  {kind}: {path}")

    if bad:
        print("UNEXPECTED differences:", file=sys.stderr)
        for path, kind in bad:
            print(f"  {kind}: {path}", file=sys.stderr)
        return 1

    print("OK: no unexpected difference from GCC compatibility reference")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
