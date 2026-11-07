#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and THIRD_PARTY_NOTICES.md.
"""Test the production launch boundary without acquiring host hardware."""
import os
from pathlib import Path
import subprocess
import sys
import tempfile


def main():
    binary = str(Path(sys.argv[1]).resolve())
    with tempfile.TemporaryDirectory(prefix='wait-observe-cli-') as tmp:
        for args in ([], ['--wait-guard', '--lanes', '1'], ['--wait-sample', '--lanes', '1']):
            result = subprocess.run([binary, *args], stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=False)
            assert result.returncode != 0, f'unguarded or incomplete invocation was accepted: {args}'
        pidfile = Path(tmp) / 'compiler.pid'
        child = subprocess.Popen([binary, '--wait-exec', str(pidfile), sys.executable, '-c', 'import os; print(os.getpid())'],
                                 stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        out, err = child.communicate(timeout=10)
        assert child.returncode == 0, err
        assert int(pidfile.read_text()) == child.pid == int(out), 'launcher PID changed across exec'
    print('wait-observe CLI boundary: 4 checks, 0 failures; acceptance=no')


if __name__ == '__main__':
    main()
