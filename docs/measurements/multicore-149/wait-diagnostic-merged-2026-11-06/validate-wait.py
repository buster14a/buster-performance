#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Validate diagnostic rows for one separately monitored compiler process.

This checks records and a supplied exit-status receipt, not the launcher, object
identity, complete program coverage, or the provenance of those inputs.
"""
import argparse
import bisect
import hashlib
from pathlib import Path
import re
import sys

U = r'(0|[1-9][0-9]*)'
PIN = re.compile(r'lane-pin\tindex=' + U + r'\texpected=' + U + r'\tobserved=' + U + r'\tstatus=0')
LANE = re.compile(r'wait-diagnostic\tlane=' + U + r'\ttid=' + U + r'\texpected-cpu=' + U + r'\tobserved-cpu=' + U + r'\tcpu-status=0\tscope=start-through-flow\tend-policy=forced-join')
METRIC = re.compile(r'wait-diagnostic-metric\tlane=' + U + r'\tkind=(initial-spin|mwaitx|fallback-spin|barrier-futex|other-futex)\toutcome=(completed|eagain|eintr|other)\tcalls=' + U + r'\tclock-errors=' + U + r'\telapsed-ns=' + U + r'\tmax-ns=' + U + r'\tbuckets=(' + U + r'(?:,' + U + r'){7})')
CAL = re.compile(r'wait-diagnostic-calibration\tlane=' + U + r'\tpairs=1000\tfailures=0\tmin-ns=' + U + r'\tmax-ns=' + U + r'\ttotal-ns=' + U)
KINDS = ('initial-spin', 'mwaitx', 'fallback-spin', 'barrier-futex', 'other-futex')
OUTCOMES = ('completed', 'eagain', 'eintr', 'other')
MAX64 = (1 << 64) - 1
MAX32 = (1 << 32) - 1
BOUNDARIES = (1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000)


def require(condition, message):
    if not condition:
        raise ValueError(message)


def integer(s, limit=MAX64):
    require(re.fullmatch(U, s) is not None and len(s) <= 20, 'noncanonical or oversized unsigned integer')
    n = int(s)
    require(n <= limit, 'unsigned integer out of range')
    return n


def parse_cpus(value):
    pieces = value.split(',')
    require(1 <= len(pieces) <= 8, 'expected one to eight CPUs')
    cpus = [integer(s, MAX32) for s in pieces]
    require(len(set(cpus)) == len(cpus), 'duplicate CPU')
    return cpus


def validate(data, cpus, pid, status, expected_tids=None):
    require(1 <= len(cpus) <= 8 and len(set(cpus)) == len(cpus) and all(type(c) is int and 0 <= c <= MAX32 for c in cpus), 'invalid CPU list')
    require(type(pid) is int and 0 < pid <= 2147483647, 'invalid compiler PID')
    require(status in (b'0', b'0\n'), 'compiler status is not a successful exit')
    pins, lanes, metrics, calibrations = {}, {}, {}, {}
    for raw in data.splitlines(keepends=True):
        if not raw.startswith((b'lane-pin', b'wait-diagnostic')):
            require(not raw.lstrip(b' \t').startswith((b'lane-pin', b'wait-diagnostic')), 'indented diagnostic record')
            continue
        require(raw.endswith(b'\n') and not raw.endswith(b'\r\n'), 'unterminated or CRLF diagnostic record')
        try:
            line = raw[:-1].decode('ascii')
        except UnicodeDecodeError as exc:
            raise ValueError('non-ASCII diagnostic record') from exc
        if line.startswith('lane-pin'):
            m = PIN.fullmatch(line); require(m is not None, 'malformed lane pin')
            lane, expected, observed = (integer(x, MAX32) for x in m.groups())
            require(lane < len(cpus) and lane not in pins, 'duplicate or invalid pin lane')
            require(expected == observed == cpus[lane], 'wrong pinned CPU')
            pins[lane] = observed
        elif line.startswith('wait-diagnostic-metric'):
            m = METRIC.fullmatch(line); require(m is not None, 'malformed metric')
            # Use named field splitting after full grammar validation; regex U includes captures.
            f = dict(part.split('=', 1) for part in line.split('\t')[1:])
            lane = integer(f['lane'], MAX32); key = (lane, f['kind'], f['outcome'])
            require(lane < len(cpus) and key not in metrics, 'duplicate or invalid metric lane')
            calls, errors, total, maximum = (integer(f[k]) for k in ('calls', 'clock-errors', 'elapsed-ns', 'max-ns'))
            buckets = [integer(s) for s in f['buckets'].split(',')]
            require(errors == 0 and sum(buckets) == calls, 'clock errors or inconsistent histogram')
            require(maximum <= total and total <= maximum * calls, 'inconsistent elapsed totals')
            require(calls != 0 or (total == 0 and maximum == 0), 'nonzero timing for no calls')
            if calls:
                highest = max(i for i, count in enumerate(buckets) if count)
                require(bisect.bisect_right(BOUNDARIES, maximum) == highest, 'maximum outside highest nonempty bucket')
                lower = (0,) + BOUNDARIES
                # Every observation in a finite bucket is below its next boundary;
                # the recorded maximum bounds the final, otherwise unbounded bucket.
                least = sum(count * lower[i] for i, count in enumerate(buckets))
                least += maximum - lower[highest]  # at least one observation equals maximum
                most = sum(count * min(maximum, BOUNDARIES[i] - 1 if i < len(BOUNDARIES) else maximum)
                           for i, count in enumerate(buckets))
                require(least <= total <= most, 'elapsed total outside histogram bounds')
            require(f['kind'] in ('barrier-futex', 'other-futex') or f['outcome'] == 'completed' or calls == 0, 'impossible spin or MWAITX outcome')
            metrics[key] = True
        elif line.startswith('wait-diagnostic-calibration'):
            m = CAL.fullmatch(line); require(m is not None, 'malformed or failed calibration')
            lane, minimum, maximum, total = (integer(x) for x in m.groups())
            require(lane < len(cpus) and lane not in calibrations, 'duplicate or invalid calibration lane')
            require(minimum <= maximum and minimum * 1000 <= total <= maximum * 1000, 'inconsistent calibration')
            calibrations[lane] = True
        else:
            m = LANE.fullmatch(line); require(m is not None, 'malformed lane diagnostic')
            lane, tid, expected, observed = (integer(x, MAX32) for x in m.groups())
            require(lane < len(cpus) and lane not in lanes, 'duplicate or invalid diagnostic lane')
            require(0 < tid <= 2147483647 and expected == observed == cpus[lane], 'wrong CPU or invalid TID')
            lanes[lane] = tid
    expected_lanes = set(range(len(cpus)))
    require(set(pins) == expected_lanes and set(lanes) == expected_lanes and set(calibrations) == expected_lanes, 'missing lane, pin or calibration')
    require(lanes[0] == pid and len(set(lanes.values())) == len(cpus), 'wrong owner PID or duplicate TID')
    if expected_tids is not None:
        require(len(expected_tids) == len(cpus) and all(type(t) is int and 0 < t <= 2147483647 for t in expected_tids), 'invalid expected TIDs')
        require([lanes[i] for i in range(len(cpus))] == expected_tids, 'TIDs differ from independent receipt')
    require(set(metrics) == {(i, k, o) for i in expected_lanes for k in KINDS for o in OUTCOMES}, 'missing metric rows')
    return lanes


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--cpus', required=True, help='ordered CPU list for the observed process')
    parser.add_argument('--pid', required=True, help='PID captured by the process launcher')
    parser.add_argument('--tids', help='optional ordered TIDs captured independently')
    parser.add_argument('--status-file', required=True, type=Path, help='launcher exit-status receipt (0 for success)')
    parser.add_argument('stderr', type=Path, help='complete raw diagnostic stderr')
    args = parser.parse_args()
    try:
        cpus = parse_cpus(args.cpus)
        pid = integer(args.pid, 2147483647)
        tids = [integer(s, 2147483647) for s in args.tids.split(',')] if args.tids is not None else None
        data = args.stderr.read_bytes()
        lanes = validate(data, cpus, pid, args.status_file.read_bytes(), tids)
    except (ValueError, OSError) as exc:
        print(f'wait diagnostic invalid: {exc}', file=sys.stderr)
        return 1
    print(f'PASS lanes={len(cpus)} metrics={len(cpus)*20} sha256={hashlib.sha256(data).hexdigest()} tids=' + ','.join(str(lanes[i]) for i in range(len(cpus))))
    return 0


if __name__ == '__main__':
    sys.exit(main())
