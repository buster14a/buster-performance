#!/usr/bin/env python3
"""Independent raw privilege and workload-time controls for a fresh capture.

The raw control counts the privilege domains with plain -e events, in a
separate invocation from every -M metric capture. The time control is the
separate C helper that times only the workload, fork to wait. Neither control
supplies a formula operand; qualify-fresh.py uses them to audit the captured
records.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import statistics
import subprocess
import tempfile
import time

from metric_workloads import describe_workloads, workload_commands

p = argparse.ArgumentParser()
p.add_argument('--compiler', required=True)
p.add_argument('--corpus', required=True)
p.add_argument('--out', required=True)
p.add_argument('--time-control', required=True, help='compiled metric-time-control.c')
p.add_argument('--repetitions', type=int, default=3)
p.add_argument('--workloads', default='preprocess,syntax,compile')
p.add_argument('--no-time-control', action='store_true', help='collect raw privilege domains only; the campaign retains per-metric time controls')
p.add_argument('--exclusive', help='shared-host exclusive.sh; each control invocation takes the lock separately')
p.add_argument('--exclusive-owner', default=os.environ.get('EXCLUSIVE_OWNER', 'buster-perf-metric'))
p.add_argument('--exclusive-title', default=os.environ.get('EXCLUSIVE_TITLE', ''))
p.add_argument('--exclusive-link', default=os.environ.get('EXCLUSIVE_LINK', ''))
a = p.parse_args()
if a.repetitions < 1:
    p.error('--repetitions must be positive')
out = Path(a.out).resolve()
out.mkdir(parents=True, exist_ok=False)
compiler = str(Path(a.compiler).resolve())
corpus = Path(a.corpus).resolve()
time_control = str(Path(a.time_control).resolve())
os.environ['LC_ALL'] = 'C'
os.environ['SOURCE_DATE_EPOCH'] = '1792454400'
os.environ.pop('CPATH', None)
os.environ.pop('C_INCLUDE_PATH', None)
if a.exclusive:
    os.environ['EXCLUSIVE_OWNER'] = a.exclusive_owner
    os.environ['EXCLUSIVE_TITLE'] = a.exclusive_title
    os.environ['EXCLUSIVE_LINK'] = a.exclusive_link


def sha256(path):
    h = hashlib.sha256()
    with open(path, 'rb') as f:
        for block in iter(lambda: f.read(1024 * 1024), b''):
            h.update(block)
    return h.hexdigest()


def wrapped(command, affinity_path):
    affinity_path.write_text('2\n')
    pinned = ['taskset', '-c', '2', *command]
    return [a.exclusive, *pinned] if a.exclusive else pinned


def run(command, affinity_path):
    start = time.monotonic_ns()
    r = subprocess.run(wrapped(command, affinity_path), stdout=subprocess.PIPE,
                       stderr=subprocess.PIPE, text=True, errors='replace', check=False)
    return {'command': command, 'status': r.returncode, 'stdout': r.stdout,
            'stderr': r.stderr, 'wall_ms': (time.monotonic_ns() - start) / 1e6,
            'affinity': affinity_path.read_text().strip()}


def output(command):
    r = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                       text=True, errors='replace', check=False)
    return {'command': command, 'status': r.returncode, 'output': r.stdout}


inventory = output(['perf', 'list', '--json'])
if inventory['status']:
    raise SystemExit('perf list --json failed: ' + inventory['output'])
(out / 'perf-list.json').write_text(inventory['output'])
environment = {
    'cpu': output(['lscpu', '-J']), 'kernel': output(['uname', '-srmo']),
    'perf': output(['perf', '--version']), 'clang': output(['clang', '--version']),
    'compiler_sha256': sha256(compiler),
    'sqlite3_c_sha256': sha256(corpus / 'sqlite/sqlite3.c'),
    'corpus_manifest_sha256': sha256(corpus / 'MANIFESTS.sha256'),
    'predefines_sha256': sha256(corpus / 'provenance/gnu17-pinned-predefines.txt'),
    'perf_event_paranoid': Path('/proc/sys/kernel/perf_event_paranoid').read_text().strip(),
    'thp': Path('/sys/kernel/mm/transparent_hugepage/enabled').read_text().strip(),
    'repetitions': a.repetitions,
    'control_policy': 'buster-perf-control-v1',
    'inventory_sha256': sha256(out / 'perf-list.json'),
    'python_sha256': sha256(Path(__file__)),
    'workload_sha256': sha256(Path(__file__).with_name('metric_workloads.py')),
}
(out / 'environment.json').write_text(json.dumps(environment, indent=2) + '\n')

affinity = out / '_affinity.txt'
rows = []
with tempfile.TemporaryDirectory(prefix='buster-control-') as scratch:
    scratch = Path(scratch)
    workloads = workload_commands(compiler, corpus, scratch / 'sqlite.o')
    selected = [name for name in a.workloads.split(',') if name]
    if not selected or any(name not in workloads for name in selected):
        raise SystemExit('unknown workload in --workloads')
    workloads = {name: workloads[name] for name in selected}
    (out / 'commands.json').write_text(json.dumps(
        describe_workloads(workloads, compiler, corpus, scratch), indent=2) + '\n')
    (out / 'raw-privilege.jsonl').open('w').close()
    with (out / 'raw-privilege.jsonl').open('a') as log:
        for workload, command in workloads.items():
            for repetition in range(a.repetitions):
                raw_command = ['perf', 'stat', '--no-big-num', '-x', ';',
                               '-e', 'cpu-cycles:uH,cpu-cycles:kHh,cpu-cycles:G',
                               '--', *command]
                raw = run(raw_command, affinity)
                row = {'kind': 'raw-privilege-control', 'workload': workload,
                       'repetition': repetition, 'raw': raw, 'time_control': None,
                       'time_receipt': None, 'affinity': affinity.read_text().strip()}
                if not a.no_time_control:
                    receipt = out / 'time-control' / f'{workload}-{repetition}.json'
                    receipt.parent.mkdir(exist_ok=True)
                    control = run([time_control, str(receipt), '--', *command], affinity)
                    row['time_control'] = control
                    if control['status'] == 0 and receipt.is_file():
                        row['time_receipt'] = json.loads(receipt.read_text())
                log.write(json.dumps(row) + '\n')
                log.flush()
                rows.append(row)
                print(workload, repetition, 'raw', raw['status'],
                      'time', row['time_control']['status'] if row['time_control'] else 'skipped',
                      flush=True)

summary = {}
for workload in workloads:
    selected = [row for row in rows if row['workload'] == workload]
    summary[workload] = {
        'raw_statuses': [row['raw']['status'] for row in selected],
        'time_statuses': [row['time_control']['status'] if row['time_control'] else None
                          for row in selected],
        'elapsed_seconds': [row['time_receipt']['elapsed_seconds']
                            for row in selected if row.get('time_receipt')],
    }
    if summary[workload]['elapsed_seconds']:
        summary[workload]['median_elapsed_seconds'] = statistics.median(
            summary[workload]['elapsed_seconds'])
(out / 'control-summary.json').write_text(json.dumps(summary, indent=2) + '\n')
if affinity.exists():
    affinity.unlink()
failed = [row for row in rows if row['raw']['status'] or
          (not a.no_time_control and (not row['time_control'] or row['time_control']['status'] or
           not row.get('time_receipt') or row['time_receipt'].get('status') != 0))]
if failed:
    raise SystemExit(f'{len(failed)} control invocations failed')
print('done:', out, flush=True)
