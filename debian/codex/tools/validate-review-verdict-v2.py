#!/usr/bin/env python3
from __future__ import annotations
import argparse, re
from pathlib import Path
COUNT=re.compile(r'^[A-Z0-9 ]+ RESULT: (PASS|FAIL) — Critical=(\d+) High=(\d+) Medium=(\d+) Low=(\d+)$')

def main()->int:
    ap=argparse.ArgumentParser(); ap.add_argument('kind',choices=('task1','task2')); ap.add_argument('report',type=Path)
    ns=ap.parse_args(); lines=ns.report.read_text(encoding='utf-8').splitlines()
    while lines and not lines[-1].strip(): lines.pop()
    n=3 if ns.kind=='task1' else 4
    prefixes=(['TASK1 ARTIFACT RESULT:','TASK1 PROCEDURE RESULT:','FINAL RESULT:'] if ns.kind=='task1' else
              ['TASK2 ARTIFACT RESULT:','TASK2 PROCEDURE RESULT:','GITHUB ACTIONS RESULT:','FINAL RESULT:'])
    if len(lines)<n or any(not line.startswith(pref) for line,pref in zip(lines[-n:],prefixes)):
        print('ERROR: review did not end with the mandatory verdict block')
        print('FINAL RESULT: FAIL'); return 1
    tail=lines[-n:]
    valid=True
    for line in tail[:-1]:
        if 'Critical=' in line:
            m=COUNT.fullmatch(line)
            if not m:
                valid=False
                continue
            result=m.group(1); counts=[int(x) for x in m.groups()[1:]]
            if result=='PASS' and any(counts): valid=False
            if result=='FAIL' and not any(counts): valid=False
    expected_final='PASS' if all('RESULT: PASS' in x for x in tail[:-1]) else 'FAIL'
    if tail[-1] != f'FINAL RESULT: {expected_final}': valid=False
    if not valid:
        print('ERROR: review verdict block is internally inconsistent')
        print('FINAL RESULT: FAIL')
        return 1
    for line in tail: print(line)
    return 0 if expected_final=='PASS' else 1
if __name__=='__main__': raise SystemExit(main())
