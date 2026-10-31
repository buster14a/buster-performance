#!/usr/bin/env python3
"""Collect portable Buster/AMD perf evidence. See the accompanying README."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shlex
import subprocess
import tempfile
import time

from metric_collect import collect_metric
from metric_qualification import Inventory

p = argparse.ArgumentParser()
p.add_argument('--compiler', required=True)
p.add_argument('--corpus', required=True)
p.add_argument('--out', required=True)
p.add_argument('--local-cores', action='store_true')
p.add_argument('--repetitions', type=int, default=2)
p.add_argument('--stage-repetitions', type=int, default=5)
p.add_argument('--profile-runs', type=int, default=20)
p.add_argument('--max-events', type=int, default=0, help='smoke-test limit; 0 means all per-thread CPU events')
p.add_argument('--max-metrics', type=int, default=0, help='smoke-test limit; 0 means all per-thread core metrics')
p.add_argument('--no-profiles', action='store_true')
p.add_argument('--metrics-only', action='store_true', help='skip counters, stages and profiles; requires explicit --metric selections')
p.add_argument('--metric', action='append', default=[], help='exact formula to collect; repeat to select affected formulas')
p.add_argument('--metric-time-control', help='compiled metric-time-control.c; required to qualify duration-based formulas')
a = p.parse_args()
if a.metrics_only and not a.metric:
    p.error('--metrics-only requires at least one explicit --metric')
out = Path(a.out).resolve()
out.mkdir(parents=True, exist_ok=False)
compiler = str(Path(a.compiler).resolve())
corpus = Path(a.corpus).resolve()
os.environ['LC_ALL'] = 'C'
os.environ['SOURCE_DATE_EPOCH'] = '1792454400'
os.environ.pop('CPATH', None)
os.environ.pop('C_INCLUDE_PATH', None)
os.environ['CORES_TITLE'] = 'Buster microarchitecture counter sweep'
os.environ['CORES_LINK'] = 'https://github.com/buster14a/buster'


def output(command):
    r = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, check=False)
    return {'command': command, 'status': r.returncode, 'output': r.stdout}


def sha256(path):
    h = hashlib.sha256()
    with open(path, 'rb') as f:
        for b in iter(lambda: f.read(1024 * 1024), b''):
            h.update(b)
    return h.hexdigest()


def wrapped(command, affinity_path):
    if a.local_cores:
        # Each invocation acquires/releases the machine's shared core pool.
        shell = 'printf "%s\\n" "$CORES_CPUS" > "$1"; shift; exec taskset -c "${CORES_CPUS%%,*}" "$@"'
        return ['cores', '-n', '1', '--', 'bash', '-c', shell, 'pin', str(affinity_path), *command]
    affinity_path.write_text('2\n')
    return ['taskset', '-c', '2', *command]


def execute(command, stat_path=None, stdout_path=None, stderr_path=None):
    affinity = out / '_affinity.txt'
    if stat_path is not None:
        command = ['perf', 'stat', '--no-big-num', '-x', ';', '-o', str(stat_path), *command]
    start = time.monotonic_ns()
    with open(stdout_path or os.devnull, 'wb') as so, open(stderr_path or os.devnull, 'wb') as se:
        r = subprocess.run(wrapped(command, affinity), stdout=so, stderr=se, check=False)
    return {'status': r.returncode, 'wall_ms': (time.monotonic_ns() - start) / 1e6,
            'affinity': affinity.read_text().strip() if affinity.exists() else None}


inventory_run = output(['perf', 'list', '--json'])
if inventory_run['status']:
    raise SystemExit('perf list --json failed: ' + inventory_run['output'])
inventory = json.loads(inventory_run['output'])
metric_inventory = Inventory(inventory)
(out / 'perf-list.json').write_text(json.dumps(inventory, indent=2) + '\n')
(out / 'perf-list-details.txt').write_text(output(['perf', 'list', '--details'])['output'])
metadata = {
    'cpu': output(['lscpu', '-J']), 'kernel': output(['uname', '-srmo']),
    'perf': output(['perf', '--version']), 'clang': output(['clang', '--version']),
    'compiler_sha256': sha256(compiler),
    'sqlite3_c_sha256': sha256(corpus / 'sqlite/sqlite3.c'),
    'corpus_manifest_sha256': sha256(corpus / 'MANIFESTS.sha256'),
    'predefines_sha256': sha256(corpus / 'provenance/gnu17-pinned-predefines.txt'),
    'perf_event_paranoid': Path('/proc/sys/kernel/perf_event_paranoid').read_text().strip(),
    'thp': Path('/sys/kernel/mm/transparent_hugepage/enabled').read_text().strip(),
    'profile_runs': a.profile_runs, 'counter_repetitions': a.repetitions,
    'stage_repetitions': a.stage_repetitions,
    'local_cores': a.local_cores,
    'metric_policy': 'buster-perf-metric-v1',
    'metrics_only': a.metrics_only, 'selected_metrics': a.metric,
    'inventory_sha256': sha256(out / 'perf-list.json'),
    'campaign_sha256': sha256(__file__),
    'metric_qualification_sha256': sha256(Path(__file__).with_name('metric_qualification.py')),
}
(out / 'environment.json').write_text(json.dumps(metadata, indent=2) + '\n')

base = ['--predefines', str(corpus / 'provenance/gnu17-pinned-predefines.txt'),
        '--clang-features', '-march=znver5', '-std=gnu17', '-nostdinc',
        '-isystem', str(corpus / 'headers/usr/lib/clang/23/include'),
        '-isystem', str(corpus / 'headers/usr/local/include'),
        '-isystem', str(corpus / 'headers/usr/include'), '-I' + str(corpus / 'sqlite')]
source = str(corpus / 'sqlite/sqlite3.c')
with tempfile.TemporaryDirectory(prefix='buster-microarch-') as scratch:
    scratch = Path(scratch)
    object_file = str(scratch / 'sqlite.o')
    workloads = {
        'preprocess': [compiler, '-E', '-P', *base, '-o', '/dev/null', source],
        'syntax': [compiler, '-fsyntax-only', *base, source],
        'compile': [compiler, '-c', *base, '-o', object_file, source],
    }
    descriptions = {k: shlex.join(v).replace(compiler, '<COMPILER>').replace(str(corpus), '<CORPUS>').replace(str(scratch), '<SCRATCH>') for k, v in workloads.items()}
    (out / 'commands.json').write_text(json.dumps(descriptions, indent=2) + '\n')
    events = sorted({e['EventName'] for e in inventory if e.get('Unit') == 'cpu'
                     and e.get('EventName') and '/' not in e['EventName']})
    metrics = sorted({e['MetricName'] for e in inventory if e.get('Unit') == 'default_core' and e.get('MetricName')})
    if a.metric:
        unknown = sorted(set(a.metric) - set(metrics))
        if unknown:
            raise SystemExit('metrics absent from captured inventory: ' + ', '.join(unknown))
        metrics = sorted(set(a.metric))
    if a.metrics_only:
        events = []
    if a.max_events:
        events = events[:a.max_events]
    if a.max_metrics:
        metrics = metrics[:a.max_metrics]
    supported, probes = [], []
    for event in events:
        r = output(['perf', 'stat', '-x', ';', '-e', event + ':u', '--', 'true'])
        ok = r['status'] == 0 and '<not supported>' not in r['output'] and '<not counted>' not in r['output']
        probes.append({'event': event, 'available': ok, 'status': r['status'], 'output': r['output']})
        if ok:
            supported.append(event)
    (out / 'event-probes.json').write_text(json.dumps(probes, indent=2) + '\n')
    print('inventory:', len(events), 'thread CPU events,', len(supported), 'passed probe;', len(metrics), 'core metrics', flush=True)
    temp_stat = scratch / 'stat.csv'
    temp_stderr = scratch / 'stderr.txt'
    records = out / 'measurements.jsonl'
    with records.open('w') as log:
        def record(kind, workload, variant, repetition, args, events_arg=None):
            result = execute(args, temp_stat, stderr_path=temp_stderr)
            row = {'kind': kind, 'workload': workload, 'variant': variant, 'repetition': repetition, **result,
                   'perf_stat': temp_stat.read_text() if temp_stat.exists() else '',
                   'workload_stderr': temp_stderr.read_text(errors='replace')}
            log.write(json.dumps(row) + '\n')
            log.flush()
            if row['status']:
                print('failed', kind, workload, variant, repetition, row['status'], flush=True)
            return row
        # Process-level anchors: include user and kernel for system time and faults.
        for rep in range(0 if a.metrics_only else a.stage_repetitions):
            for workload, cmd in workloads.items():
                record('baseline', workload, 'process', rep,
                       ['-e', 'task-clock,cycles,instructions,branches,branch-misses,page-faults,minor-faults,major-faults,context-switches,cpu-migrations', '--', *cmd])
                if workload != 'preprocess':
                    stage_cmd = cmd[:1] + ['--time-stages'] + cmd[1:]
                    record('stages', workload, 'time-stages', rep,
                           ['-e', 'task-clock', '--', *stage_cmd])
        # Independent small groups keep the six core PMCs from excessive multiplexing.
        groups = [supported[i:i + 4] for i in range(0, len(supported), 4)]
        for index, group in enumerate(groups):
            for rep in range(a.repetitions):
                for workload, cmd in workloads.items():
                    ev = ','.join(['cycles:u', 'instructions:u'] + [e + ':u' for e in group])
                    record('counter', workload, group, rep, ['-e', ev, '--', *cmd])
            if index % 10 == 0:
                print('counter group', index + 1, 'of', len(groups), flush=True)
        # Explicit privilege formulas keep their modifiers. Unsupported domains
        # are recorded as unsupported, not silently coerced to per-process user.
        affinity = out / '_affinity.txt'
        for index, metric in enumerate(metrics):
            for workload, cmd in workloads.items():
                capture = out / 'metric-captures' / f'{index:04d}-{workload}'
                row = collect_metric(metric_inventory, metric, cmd, capture,
                                     wrap=lambda command: wrapped(command, affinity),
                                     time_control=a.metric_time_control)
                row.update(workload=workload, repetition=0,
                           inventory_sha256=metadata['inventory_sha256'],
                           environment_sha256=sha256(out / 'environment.json'),
                           affinity=affinity.read_text().strip() if row.get('perf_argv') and affinity.exists() else None)
                (capture / 'record.json').write_text(json.dumps(row, indent=2, allow_nan=False) + '\n')
                log.write(json.dumps(row, allow_nan=False) + '\n')
                log.flush()
                if not row['qualification']['eligible']:
                    print('unqualified metric', workload, metric, row['qualification']['qualification'], row['qualification']['reason'], flush=True)
            if index % 25 == 0:
                print('metric', index + 1, 'of', len(metrics), flush=True)
    if not a.no_profiles and not a.metrics_only:
        profiles = out / 'profiles'
        profiles.mkdir(exist_ok=True)
        for workload, cmd in workloads.items():
            # A fresh process per iteration; perf inherits children and covers the entire driver.
            shell = 'for ((i=0;i<$1;i++)); do "${@:2}" >/dev/null 2>/dev/null || exit $?; done'
            data = profiles / (workload + '.data')
            run_cmd = ['perf', 'record', '-q', '-e', 'cycles:u', '-F', '997', '--call-graph', 'dwarf,8192',
                       '-o', str(data), '--', 'bash', '-c', shell, 'repeat', str(a.profile_runs), *cmd]
            status = execute(run_cmd, stderr_path=profiles / (workload + '-record.stderr'))
            (profiles / (workload + '-record.json')).write_text(json.dumps(status, indent=2) + '\n')
            if status['status'] == 0 and data.exists():
                for child in ('no-children', 'children'):
                    report = output(['perf', 'report', '--stdio', '--' + child, '--sort', 'comm,dso,symbol',
                                     '--percent-limit', '0.25', '-i', str(data)])
                    (profiles / (workload + '-' + child + '.txt')).write_text(report['output'])
                z = subprocess.run(['zstd', '-q', '-f', '--rm', str(data)], check=False)
                if z.returncode:
                    print('zstd failed for', workload, flush=True)
            else:
                print('sampling failed for', workload, flush=True)
    if (out / '_affinity.txt').exists():
        (out / '_affinity.txt').unlink()
print('done:', out, flush=True)
