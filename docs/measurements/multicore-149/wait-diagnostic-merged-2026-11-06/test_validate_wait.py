#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
import importlib.util
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('validate_wait', HERE / 'validate-wait.py')
v = importlib.util.module_from_spec(spec)
spec.loader.exec_module(v)


def trace(n):
    lines = ['warning: unrelated diagnostic']
    for lane in range(n):
        cpu = lane + 2
        lines.append(f'lane-pin\tindex={lane}\texpected={cpu}\tobserved={cpu}\tstatus=0')
    for lane in range(n):
        cpu = lane + 2
        lines.append(f'wait-diagnostic\tlane={lane}\ttid={1000+lane}\texpected-cpu={cpu}\tobserved-cpu={cpu}\tcpu-status=0\tscope=start-through-flow\tend-policy=forced-join')
        for kind in v.KINDS:
            for outcome in v.OUTCOMES:
                active = kind == 'barrier-futex' and outcome == 'eintr'
                calls, elapsed, maximum, buckets = (1, 25, 25, '1,0,0,0,0,0,0,0') if active else (0, 0, 0, '0,0,0,0,0,0,0,0')
                lines.append(f'wait-diagnostic-metric\tlane={lane}\tkind={kind}\toutcome={outcome}\tcalls={calls}\tclock-errors=0\telapsed-ns={elapsed}\tmax-ns={maximum}\tbuckets={buckets}')
        lines.append(f'wait-diagnostic-calibration\tlane={lane}\tpairs=1000\tfailures=0\tmin-ns=1\tmax-ns=3\ttotal-ns=2000')
    return ('\n'.join(lines) + '\n').encode()


class DiagnosticTests(unittest.TestCase):
    def test_one_through_eight_lanes(self):
        for n in range(1, 9):
            with self.subTest(lanes=n):
                self.assertEqual(len(v.validate(trace(n), list(range(2, n+2)), 1000, b'0\n')), n)

    def test_fail_closed_mutations(self):
        data = trace(2)
        cases = [
            (b'lane-pin\tindex=0', b'lane-pinindex=0'),
            (b'lane-pin\tindex=0', b' lane-pin\tindex=0'),
            (b'index=0\texpected=2', b'index=+0\texpected=2'),
            (b'index=0\texpected=2', b'index=00\texpected=2'),
            (b'observed=2\tstatus=0', b'observed=3\tstatus=0'),
            (b'index=1\texpected=3', b'index=2\texpected=3'),
            (b'tid=1001', b'tid=1000'),
            (b'tid=1000', b'tid=999'),
            (b'tid=1000', b'tid=0'),
            (b'cpu-status=0', b'cpu-status=-1'),
            (b'end-policy=forced-join', b'end-policy=park'),
            (b'kind=barrier-futex\toutcome=eintr', b'kind=barrier-futex\toutcome=unknown'),
            (b'calls=1\tclock-errors=0', b'calls=1\tclock-errors=1'),
            (b'calls=1\tclock-errors=0', b'calls=2\tclock-errors=0'),
            (b'elapsed-ns=25\tmax-ns=25', b'elapsed-ns=24\tmax-ns=25'),
            (b'elapsed-ns=25\tmax-ns=25\tbuckets=1,0,0,0,0,0,0,0', b'elapsed-ns=25\tmax-ns=25\tbuckets=0,0,0,0,0,0,0,1'),
            (b'elapsed-ns=25\tmax-ns=25\tbuckets=1,0,0,0,0,0,0,0', b'elapsed-ns=1001\tmax-ns=1001\tbuckets=1,0,0,0,0,0,0,0'),
            (b'calls=1\tclock-errors=0\telapsed-ns=25\tmax-ns=25\tbuckets=1,0,0,0,0,0,0,0', b'calls=2\tclock-errors=0\telapsed-ns=10000\tmax-ns=10000\tbuckets=0,1,1,0,0,0,0,0'),
            (b'calls=1\tclock-errors=0\telapsed-ns=25\tmax-ns=25\tbuckets=1,0,0,0,0,0,0,0', b'calls=2\tclock-errors=0\telapsed-ns=2000\tmax-ns=1000\tbuckets=1,1,0,0,0,0,0,0'),
            (b'pairs=1000\tfailures=0', b'pairs=1000\tfailures=1'),
            (b'total-ns=2000', b'total-ns=999'),
            (b'outcome=eagain\tcalls=0', b'outcome=eagain\tcalls=18446744073709551616'),
        ]
        for old, new in cases:
            with self.subTest(old=old, new=new):
                mutated = data.replace(old, new, 1)
                self.assertNotEqual(data, mutated)
                with self.assertRaises(ValueError): v.validate(mutated, [2, 3], 1000, b'0')
        for predicate in (b'lane-pin\tindex=1\t', b'wait-diagnostic\tlane=1\t', b'wait-diagnostic-calibration\tlane=1\t', b'kind=other-futex\toutcome=other'):
            with self.subTest(missing=predicate):
                mutated = b''.join(line for line in data.splitlines(keepends=True) if predicate not in line)
                with self.assertRaises(ValueError): v.validate(mutated, [2, 3], 1000, b'0')
        for predicate in (b'lane-pin\tindex=1\t', b'wait-diagnostic\tlane=1\t', b'wait-diagnostic-calibration\tlane=1\t', b'kind=other-futex\toutcome=other'):
            with self.subTest(duplicate=predicate):
                row = next(line for line in data.splitlines(keepends=True) if predicate in line)
                with self.assertRaises(ValueError): v.validate(data + row, [2, 3], 1000, b'0')
        with self.assertRaises(ValueError): v.validate(data, [2, 3], 1000, b'1\n')
        with self.assertRaises(ValueError): v.validate(data[:-1], [2, 3], 1000, b'0')
        with self.assertRaises(ValueError): v.validate(data + b'wait-diagnostic-unknown\n', [2, 3], 1000, b'0')

    def test_histogram_boundaries(self):
        base = trace(1)
        old = b'calls=1\tclock-errors=0\telapsed-ns=25\tmax-ns=25\tbuckets=1,0,0,0,0,0,0,0'
        for index, lower in enumerate((0,) + v.BOUNDARIES):
            values = [lower]
            if index < len(v.BOUNDARIES): values.append(v.BOUNDARIES[index] - 1)
            for value in values:
                buckets = ['0'] * 8; buckets[index] = '1'
                new = f'calls=1\tclock-errors=0\telapsed-ns={value}\tmax-ns={value}\tbuckets={",".join(buckets)}'.encode()
                with self.subTest(bucket=index, value=value):
                    self.assertNotEqual(base, base.replace(old, new, 1))
                    self.assertEqual(len(v.validate(base.replace(old, new, 1), [2], 1000, b'0')), 1)

    def test_cpu_and_pid_inputs(self):
        for bad in ('', '2,2', '-1', '+1', '01', '2, 3', ',2', ','.join(map(str, range(9))), '4294967296'):
            with self.subTest(bad=bad), self.assertRaises(ValueError): v.parse_cpus(bad)
        self.assertEqual(v.parse_cpus('2,3'), [2, 3])
        with self.assertRaises(ValueError): v.validate(trace(2), [2, 3], 1001, b'0')
        self.assertEqual(v.validate(trace(2), [2, 3], 1000, b'0', [1000, 1001]), {0: 1000, 1: 1001})
        with self.assertRaises(ValueError): v.validate(trace(2), [2, 3], 1000, b'0', [1000, 1002])
        with self.assertRaises(ValueError): v.validate(trace(2), [2, 3], 1000, b'0', [1000])

    def test_cli_under_optimized_python(self):
        with tempfile.TemporaryDirectory() as name:
            p = Path(name); (p/'trace').write_bytes(trace(2)); (p/'status').write_bytes(b'0\n')
            cmd = [sys.executable, '-O', str(HERE/'validate-wait.py'), '--cpus', '2,3', '--pid', '1000', '--status-file', str(p/'status'), str(p/'trace')]
            self.assertEqual(subprocess.run(cmd, capture_output=True).returncode, 0)
            (p/'status').write_bytes(b'1\n')
            self.assertNotEqual(subprocess.run(cmd, capture_output=True).returncode, 0)


if __name__ == '__main__':
    unittest.main()
