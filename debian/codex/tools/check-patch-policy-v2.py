#!/usr/bin/env python3
from __future__ import annotations
import argparse, re, sys
from pathlib import Path

def read_items(path: Path) -> list[str]:
    return [x.split()[0] for x in path.read_text(encoding='utf-8').splitlines()
            if x.strip() and not x.lstrip().startswith('#')]

def changed_paths(text: str) -> set[str]:
    result=set()
    for line in text.splitlines():
        if line.startswith(('--- ', '+++ ')):
            value=line[4:].split('\t',1)[0].split(' ',1)[0]
            if value == '/dev/null': continue
            if value.startswith(('a/','b/')): value=value[2:]
            result.add(value)
    return result

def main() -> int:
    ap=argparse.ArgumentParser()
    ap.add_argument('repo', type=Path)
    ap.add_argument('series', type=Path)
    ap.add_argument('upstream', type=Path)
    ap.add_argument('new_commits', type=Path)
    ap.add_argument('superseded', type=Path)
    ns=ap.parse_args()
    names=read_items(ns.series); upstream=set(read_items(ns.upstream))
    required_new=read_items(ns.new_commits); stale=read_items(ns.superseded)
    seen={sha:[] for sha in required_new}; errors=[]
    for name in names:
        path=ns.repo/'debian/patches'/name
        text=path.read_text(encoding='utf-8', errors='replace')
        header=text.split('\n--- ',1)[0]
        for field in ('Description:', 'Origin:', 'Forwarded:', 'Last-Update:'):
            if field not in header: errors.append(f'{name}: missing {field}')
        paths=changed_paths(text)
        if 'configure' in paths: errors.append(f'{name}: modifies generated configure')
        if any(p.startswith('.work/') for p in paths): errors.append(f'{name}: modifies .work')
        if name in upstream and not re.search(r'^Origin:\s*upstream\b', header, re.M):
            errors.append(f'{name}: upstream-derived patch lacks Origin: upstream')
        for sha in required_new:
            if sha in header: seen[sha].append(name)
        for sha in stale:
            if sha in header: errors.append(f'{name}: contains superseded source SHA {sha}')
    for sha, locations in seen.items():
        if not locations: errors.append(f'new upstream commit is not attributed: {sha}')
    if errors:
        print('\n'.join('ERROR: '+e for e in errors), file=sys.stderr); return 1
    print('OK: patch policy, DEP-3 fields, current commit attribution, and configure exclusion')
    return 0
if __name__=='__main__': raise SystemExit(main())
