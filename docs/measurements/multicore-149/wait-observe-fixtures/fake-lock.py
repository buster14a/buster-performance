#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and THIRD_PARTY_NOTICES.md.
"""Exclusive fd-9 fixture; only for the test-only launcher build."""
import fcntl
import os
from pathlib import Path
import subprocess
import sys
import time

mode = os.environ.get('WAIT_E2E_MODE', '')
if mode == 'lock-refusal': sys.exit(9)
if mode == 'late-grant': time.sleep(30)
if mode == 'missing-guard': sys.exit(0)
if mode == 'stale-sample':
    output = Path(sys.argv[sys.argv.index('--output') + 1])
    (output/'sample').mkdir()
    (output/'sample'/'beta.o').write_text('stale object\n')
if mode == 'failed-guard':
    print('lock-guard\tstart-realtime-ns=1\tend-realtime-ns=2\tmonotonic-ns=100\tstatus=1\tinterrupted=1\tdescendants-clean=1')
    sys.exit(0)
fd = os.open(os.environ['WAIT_E2E_LOCK_PATH'], os.O_CREAT | os.O_RDWR, 0o600)
if fd != 9:
    os.dup2(fd, 9)
    os.close(fd)
os.set_inheritable(9, True)
fcntl.flock(9, fcntl.LOCK_EX)
os.environ['BUSTER_9700X_HELD'] = '1'
Path(os.environ['WAIT_E2E_OWNER_PATH']).write_text('2026-01-01T00:00:00Z multicore-149-wait: synthetic fixture\n')
result = subprocess.run(sys.argv[1:], close_fds=False)
sys.exit(result.returncode)
