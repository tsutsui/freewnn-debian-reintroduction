#!/usr/bin/env python3
from __future__ import annotations
import argparse
from pathlib import Path
import sys

def lines(path: Path) -> list[str]:
    return [x.strip() for x in path.read_text(encoding='utf-8').splitlines()
            if x.strip() and not x.lstrip().startswith('#')]

def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument('repo', type=Path)
    ap.add_argument('expected', type=Path)
    ns = ap.parse_args()
    actual_file = ns.repo / 'debian/patches/series'
    if not actual_file.is_file():
        print(f'ERROR: missing {actual_file}', file=sys.stderr); return 1
    actual, expected = lines(actual_file), lines(ns.expected)
    bad = actual != expected
    if bad:
        print('ERROR: patch series differs from the pinned v2 design', file=sys.stderr)
        for i in range(max(len(actual), len(expected))):
            a = actual[i] if i < len(actual) else '<missing>'
            e = expected[i] if i < len(expected) else '<none>'
            if a != e: print(f'{i+1:02d}: expected {e}, got {a}', file=sys.stderr)
        return 1
    patch_dir = ns.repo / 'debian/patches'
    extras = sorted(p.name for p in patch_dir.glob('*.patch') if p.name not in set(expected))
    missing = sorted(name for name in expected if not (patch_dir / name).is_file())
    if extras or missing:
        print(f'ERROR: extra patches={extras}; missing patches={missing}', file=sys.stderr); return 1
    print(f'OK: exact {len(expected)}-patch series and file set')
    return 0
if __name__ == '__main__': raise SystemExit(main())
