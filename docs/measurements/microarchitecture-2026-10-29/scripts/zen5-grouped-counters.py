#!/usr/bin/env python3
"""Recover 9700X counter coverage in small groups; one lock per perf run."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile

p = argparse.ArgumentParser()
p.add_argument('--compiler', required=True)
p.add_argument('--corpus', required=True)
p.add_argument('--event-probes', required=True)
p.add_argument('--out', required=True)
p.add_argument('--repetitions', type=int, default=2)
p.add_argument('--group-size', type=int, default=3)
a = p.parse_args()
compiler = str(Path(a.compiler).resolve())
corpus = Path(a.corpus).resolve()
out = Path(a.out).resolve()
out.mkdir(exist_ok=True, parents=True)
os.environ.update({'EXCLUSIVE_OWNER': 'codex-microarch-20261029',
                   'EXCLUSIVE_TITLE': 'Buster 9700X counter recovery',
                   'EXCLUSIVE_LINK': 'https://github.com/buster14a/buster-performance/pull/120',
                   'LC_ALL': 'C', 'SOURCE_DATE_EPOCH': '1792454400'})
os.environ.pop('CPATH', None)
os.environ.pop('C_INCLUDE_PATH', None)
lock = str(Path.home() / 'buster-fast-bench/exclusive.sh')
base = ['--predefines', str(corpus / 'provenance/gnu17-pinned-predefines.txt'),
        '--clang-features', '-march=znver5', '-std=gnu17', '-nostdinc',
        '-isystem', str(corpus / 'headers/usr/lib/clang/23/include'),
        '-isystem', str(corpus / 'headers/usr/local/include'),
        '-isystem', str(corpus / 'headers/usr/include'), '-I' + str(corpus / 'sqlite')]
source = str(corpus / 'sqlite/sqlite3.c')
events = [x['event'] for x in json.loads(Path(a.event_probes).read_text()) if x['available']]
recovery = out / 'recovery.jsonl'
raw_path = out / 'grouped-recovery.jsonl'

def stat_lines(data):
    lines = []
    for line in data.splitlines():
        parts = line.split(';')
        if len(parts) < 5 or not parts[2]:
            continue
        try:
            val, duty = float(parts[0]), float(parts[4])
        except ValueError:
            continue
        lines.append((line, val, duty))
    return lines

def valid(row):
    lines = stat_lines(row['perf_stat'])
    return row['status'] == 0 and len(lines) == 3 and min(x[2] for x in lines) >= 99 and lines[0][1] > 0 and lines[1][1] > 0

completed = set()
if recovery.exists():
    for line in recovery.read_text().splitlines():
        row = json.loads(line)
        if valid(row):
            completed.add((row['event'], row['repetition'], row['workload']))

with tempfile.TemporaryDirectory(prefix='buster-grouped-') as tmp, recovery.open('a') as recovered, raw_path.open('a') as raw:
    tmp = Path(tmp)
    obj = str(tmp / 'sqlite.o')
    workloads = {'preprocess': [compiler, '-E', '-P', *base, '-o', '/dev/null', source],
                 'syntax': [compiler, '-fsyntax-only', *base, source],
                 'compile': [compiler, '-c', *base, '-o', obj, source]}

    def run_group(names, repetition, workload):
        stat = tmp / 'stat.csv'
        error = tmp / 'stderr'
        stat.unlink(missing_ok=True)
        perf = ['perf', 'stat', '--no-big-num', '-x', ';', '-o', str(stat),
                '-e', ','.join(['cycles:u', 'instructions:u'] + [name + ':u' for name in names]),
                '--', *workloads[workload]]
        with error.open('wb') as err:
            result = subprocess.run([lock, 'timeout', '30', 'taskset', '-c', '2', *perf],
                                    stdout=subprocess.DEVNULL, stderr=err, check=False)
        stderr = '\n'.join(line for line in error.read_text(errors='replace').splitlines()
                           if not line.startswith(('exclusive.sh: ', '  title: ', '  link: ', '  pull request: ')))
        data = stat.read_text() if stat.exists() else ''
        entry = {'events': names, 'repetition': repetition, 'workload': workload,
                 'status': result.returncode, 'perf_stat': data, 'stderr': stderr}
        serialized = json.dumps(entry, sort_keys=True)
        group_id = hashlib.sha256(serialized.encode()).hexdigest()
        entry['group_id'] = group_id
        raw.write(json.dumps(entry) + '\n')
        raw.flush()
        ls = stat_lines(data)
        ok = result.returncode == 0 and len(ls) == len(names) + 2 and min(x[2] for x in ls) >= 99 and ls[0][1] > 0 and ls[1][1] > 0
        if ok:
            for idx, name in enumerate(names):
                row = {'event': name, 'repetition': repetition, 'workload': workload,
                       'status': 0, 'perf_stat': '\n'.join((ls[0][0], ls[1][0], ls[idx + 2][0])) + '\n',
                       'stderr': stderr, 'collection_method': 'grouped-' + str(len(names)), 'group_id': group_id}
                recovered.write(json.dumps(row) + '\n')
                recovered.flush()
                completed.add((name, repetition, workload))
        elif len(names) > 1:
            for name in names:
                run_group([name], repetition, workload)
        else:
            row = {'event': names[0], 'repetition': repetition, 'workload': workload,
                   'status': result.returncode, 'perf_stat': data, 'stderr': stderr,
                   'collection_method': 'isolated-failed-duty', 'group_id': group_id}
            recovered.write(json.dumps(row) + '\n')
            recovered.flush()
        return ok

    for rep in range(a.repetitions):
        for workload in workloads:
            missing = [event for event in events if (event, rep, workload) not in completed]
            for start in range(0, len(missing), a.group_size):
                run_group(missing[start:start + a.group_size], rep, workload)
                if start % (a.group_size * 10) == 0:
                    print(f'{workload} repetition {rep} recovered through {start + len(missing[start:start+a.group_size])}/{len(missing)} missing events', flush=True)
print('finished all recovery attempts', flush=True)
