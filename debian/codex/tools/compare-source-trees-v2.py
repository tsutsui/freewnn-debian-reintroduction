#!/usr/bin/env python3
from __future__ import annotations
import argparse, hashlib, os, stat, sys
from pathlib import Path
IGNORE_TOP={'.git','.pc','.work','debian','autom4te.cache'}
IGNORE_FILES={'configure'}

def manifest(root: Path) -> dict[str,str]:
    out={}
    for p in sorted(root.rglob('*')):
        rel=p.relative_to(root); key=rel.as_posix()
        if not rel.parts or rel.parts[0] in IGNORE_TOP or any(x in IGNORE_TOP for x in rel.parts): continue
        if key in IGNORE_FILES or p.is_dir(): continue
        mode=stat.S_IMODE(p.lstat().st_mode)
        if p.is_symlink(): value=f'L:{mode:o}:{os.readlink(p)}'
        else: value=f'F:{mode:o}:{hashlib.sha256(p.read_bytes()).hexdigest()}'
        out[key]=value
    return out

def main()->int:
    ap=argparse.ArgumentParser(); ap.add_argument('candidate',type=Path); ap.add_argument('reference',type=Path)
    ns=ap.parse_args(); a=manifest(ns.candidate); b=manifest(ns.reference); bad=False
    for key in sorted(set(a)|set(b)):
        if a.get(key)!=b.get(key):
            bad=True; print(f'DIFF {key}: candidate={a.get(key,"<missing>")} reference={b.get(key,"<missing>")}')
    if bad: print('ERROR: source trees differ',file=sys.stderr); return 1
    print('OK: source trees match exactly, excluding generated configure and packaging metadata')
    return 0
if __name__=='__main__': raise SystemExit(main())
