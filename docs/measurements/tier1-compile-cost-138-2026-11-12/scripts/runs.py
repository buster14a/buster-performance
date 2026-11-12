#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# runs.py --cpus LIST --runs N --out FILE.tsv [--warmups N] [--plain] --config NAME DIRECTORY COMMAND... [--config ...]...
#
# Whole processes of several configurations, each in a directory of its own (so that one's outputs never overwrite
# another's: an object written over a longer one pays the file system's truncation, 20 ms on this host's btrfs), in each
# round's row of a Williams design (each configuration follows each other equally often), after warm-up runs. Each
# process runs under `perf stat` pinned to the CPUs: its wall time (perf's time elapsed), its threads' user and kernel cycles
# and instructions, and from wait4 its user and system time, peak resident set (perf's own is far below a compile's)
# and page faults. One line a run, then each configuration's medians with their ranges. With --plain the processes
# run without perf, for wait4's peak alone: under perf a process's peak is never below perf's own at its fork (66 MB
# here), and it read 3 MB above a direct child's. Run it inside one hold of the lock.
import os, sys, statistics, subprocess, tempfile, time

def williams(n):
    first = [0]
    low, high = 1, n - 1
    while low <= high:
        first.append(low)
        if low != high:
            first.append(high)
        low += 1
        high -= 1
    rows = [[(x + shift) % n for x in first] for shift in range(n)]
    if n % 2 == 1:
        rows += [list(reversed(row)) for row in rows]
    return rows

def main():
    args = sys.argv[1:]
    cpus, runs, out, warmups, configs, plain = None, 7, None, 1, [], False
    i = 0
    while i < len(args):
        if args[i] == '--cpus': cpus = args[i + 1]; i += 2
        elif args[i] == '--runs': runs = int(args[i + 1]); i += 2
        elif args[i] == '--warmups': warmups = int(args[i + 1]); i += 2
        elif args[i] == '--out': out = args[i + 1]; i += 2
        elif args[i] == '--plain': plain = True; i += 1
        elif args[i] == '--config':
            name, directory = args[i + 1], args[i + 2]
            j = i + 3
            while j < len(args) and args[j] != '--config':
                j += 1
            configs.append((name, directory, args[i + 3:j]))
            i = j
        else:
            sys.exit('runs.py: unknown argument ' + args[i])
    if cpus is None or out is None or not configs:
        sys.exit('usage: runs.py --cpus LIST --runs N --out FILE.tsv --config NAME DIRECTORY COMMAND...')
    events = ['duration_time', 'task-clock', 'cycles:u', 'instructions:u', 'cycles:k', 'instructions:k']
    fields = ['wall_ms', 'task_ms', 'user_cycles', 'user_instructions', 'kernel_cycles', 'kernel_instructions', 'user_ms', 'system_ms', 'peak_kib', 'minor_faults', 'major_faults']
    design = williams(len(configs))
    rows = []
    def one(phase, round_, position, c):
        name, directory, command = configs[c]
        with tempfile.NamedTemporaryFile('r', suffix='.txt') as stat:
            perf = ['taskset', '-c', cpus] + ([] if plain else ['perf', 'stat', '-o', stat.name, '-e', 'task-clock', '-e', '{cycles:u,instructions:u,cycles:k,instructions:k}', '--']) + command
            started = time.monotonic_ns()
            process = subprocess.Popen(perf, cwd=directory, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            _, status, usage = os.wait4(process.pid, 0)
            elapsed = time.monotonic_ns() - started
            process.returncode = os.waitstatus_to_exitcode(status)
            counts = {}
            for line in stat:
                parts = line.replace(',', '').split()
                if len(parts) >= 4 and parts[1:4] == ['seconds', 'time', 'elapsed']:
                    counts['duration_time'] = float(parts[0]) * 1e9
                elif len(parts) >= 3 and parts[1] == 'msec' and parts[2] in events:
                    counts[parts[2]] = parts[0]
                elif len(parts) >= 2 and parts[1] in events:
                    counts[parts[1]] = parts[0]
        wall = elapsed / 1e6 if plain else float(counts.get('duration_time', 'nan')) / 1e6
        task = float(counts.get('task-clock', 'nan'))
        values = [wall, task] + [float(counts.get(e, 'nan')) for e in events[2:]] + [usage.ru_utime * 1e3, usage.ru_stime * 1e3, usage.ru_maxrss, usage.ru_minflt, usage.ru_majflt]
        rows.append((phase, round_, position, name, process.returncode, values))
        return process.returncode
    status = 0
    for w in range(warmups):
        for c in range(len(configs)):
            status |= one('warmup', w, c, c)
    for r in range(runs):
        for position, c in enumerate(design[r % len(design)]):
            status |= one('run', r, position, c)
    with open(out, 'w') as f:
        f.write('phase\tround\tposition\tconfig\tstatus\t' + '\t'.join(fields) + '\n')
        for phase, round_, position, name, code, values in rows:
            f.write(f'{phase}\t{round_}\t{position}\t{name}\t{code}\t' + '\t'.join(f'{v:.3f}' if isinstance(v, float) else str(v) for v in values) + '\n')
        for name, _, _ in configs:
            mine = [values for phase, _, _, n, _, values in rows if phase == 'run' and n == name]
            f.write(f'median\t{len(mine)}\t-\t{name}\t-\t' + '\t'.join(f'{statistics.median(v[k] for v in mine):.3f}' for k in range(len(fields))) + '\n')
            f.write(f'low\t{len(mine)}\t-\t{name}\t-\t' + '\t'.join(f'{min(v[k] for v in mine):.3f}' for k in range(len(fields))) + '\n')
            f.write(f'high\t{len(mine)}\t-\t{name}\t-\t' + '\t'.join(f'{max(v[k] for v in mine):.3f}' for k in range(len(fields))) + '\n')
    sys.exit(1 if status != 0 else 0)

main()
