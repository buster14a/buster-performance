#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and THIRD_PARTY_NOTICES.md.
"""Fake compiler used only by the separately compiled synthetic launcher."""
import os
from pathlib import Path
import signal
import sys
import time

Path(os.environ['WAIT_E2E_STARTED']).write_text(str(os.getpid()))
if os.environ.get('BUSTER_WAIT_TRACE') != '1' or os.environ.get('SOURCE_DATE_EPOCH') != '0' or any(os.environ.get(k) is not None for k in ('CPATH', 'BUSTER_TEST_149')):
    sys.exit(11)
mode = os.environ.get('WAIT_E2E_MODE', '')
if mode == 'nonzero': sys.exit(7)
if mode == 'signal': os.kill(os.getpid(), signal.SIGTERM)
if mode == 'timeout': time.sleep(30)
if mode == 'orphan':
    child = os.fork()
    if child == 0:
        os.setsid()
        signal.signal(signal.SIGTERM, signal.SIG_IGN)
        Path(os.environ['WAIT_E2E_ORPHAN_PID']).write_text(str(os.getpid()))
        time.sleep(60)
        os._exit(0)
    while not Path(os.environ['WAIT_E2E_ORPHAN_PID']).exists(): time.sleep(0.001)
if mode == 'mutate-input': Path(os.environ['WAIT_E2E_INPUT']).write_text('changed input\n')
if mode == 'mutate-binary':
    with Path(__file__).open('a') as f: f.write('\n# changed after launch\n')
for name, text in [('alpha.o', 'alpha object\n'), ('beta.o', 'beta object\n')]:
    if mode == 'missing' and name == 'beta.o': continue
    if mode == 'changed' and name == 'beta.o': text = 'changed object\n'
    if mode == 'symlink' and name == 'beta.o':
        os.symlink('alpha.o', name)
    else:
        Path(name).write_text(text)

lanes = int(sys.argv[sys.argv.index('--lanes') + 1])
cpus = [int(x) for x in sys.argv[sys.argv.index('--lane-cpus') + 1].split(',')]
print(f'time-process\tlanes-asked\t{lanes}', file=sys.stderr)
print(f'time-process\tlanes\t{lanes}', file=sys.stderr)
for i, cpu in enumerate(cpus): print(f'lane-pin\tindex={i}\texpected={cpu}\tobserved={cpu}\tstatus=0', file=sys.stderr)
stages = ('setup lanes-start preprocess parse type-table check-input check-expressions check-declarations static-data check-program select backend-setup lower tier0 emit-setup lanes branch-sizing encode unwind code-atoms debug publish-data object-build object-write runtime executable write release').split()
for name in stages:
    print(f'time-stage\t{name}\t{0.001 if name in ("setup", "lanes") else 0.0:.3f}\t0.0\t0.0\t0\t0', file=sys.stderr)
print('time-stage\tlower.prepare\t0.000\t0.0', file=sys.stderr)
print('time-stage\ttotal\t0.002\t100.0', file=sys.stderr)
for lane, cpu in enumerate(cpus):
    tid = os.getpid() if lane == 0 else os.getpid() + lane
    if mode == 'validator-refusal' and lane == 0: tid += 99
    print(f'wait-diagnostic\tlane={lane}\ttid={tid}\texpected-cpu={cpu}\tobserved-cpu={cpu}\tcpu-status=0\tscope=start-through-flow\tend-policy=forced-join', file=sys.stderr)
    for kind in ('initial-spin','mwaitx','fallback-spin','barrier-futex','other-futex'):
        for outcome in ('completed','eagain','eintr','other'):
            print(f'wait-diagnostic-metric\tlane={lane}\tkind={kind}\toutcome={outcome}\tcalls=0\tclock-errors=0\telapsed-ns=0\tmax-ns=0\tbuckets=0,0,0,0,0,0,0,0', file=sys.stderr)
    print(f'wait-diagnostic-calibration\tlane={lane}\tpairs=1000\tfailures=0\tmin-ns=1\tmax-ns=3\ttotal-ns=2000', file=sys.stderr)
