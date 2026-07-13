#!/usr/bin/env python3
from __future__ import annotations
import argparse, json, sys
from pathlib import Path

def expected(path: Path)->list[str]:
    return [x.strip() for x in path.read_text(encoding='utf-8').splitlines() if x.strip() and not x.startswith('#')]

def main()->int:
    ap=argparse.ArgumentParser(); ap.add_argument('json_file',type=Path); ap.add_argument('expected',type=Path)
    ns=ap.parse_args(); data=json.loads(ns.json_file.read_text(encoding='utf-8'))
    if data.get('conclusion')!='success': print('ERROR: workflow conclusion is not success',file=sys.stderr); return 1
    steps={}
    for job in data.get('jobs') or []:
        for step in job.get('steps') or []: steps[step.get('name')]=step.get('conclusion')
    missing=[]
    for name in expected(ns.expected):
        if steps.get(name)!='success': missing.append(f'{name}={steps.get(name,"missing")}')
    if missing: print('ERROR: required Actions steps not successful: '+', '.join(missing),file=sys.stderr); return 1
    print('OK: all required GitHub Actions steps executed successfully')
    return 0
if __name__=='__main__': raise SystemExit(main())
