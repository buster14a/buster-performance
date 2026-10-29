#!/usr/bin/env python3
"""Recollect multiplexed groups one named CPU event at a time."""
import argparse
import json
import os
from pathlib import Path
import shlex
import subprocess
import tempfile

p = argparse.ArgumentParser()
p.add_argument('--compiler', required=True)
p.add_argument('--corpus', required=True)
p.add_argument('--out', required=True)
p.add_argument('--repetitions', type=int, default=2)
a = p.parse_args()
out = Path(a.out).resolve()
commands = json.loads((out / 'commands.json').read_text())
records = [json.loads(x) for x in (out / 'measurements.jsonl').read_text().splitlines()]
low = set()
for record in records:
    if record['kind'] != 'counter':
        continue
    for line in record['perf_stat'].splitlines():
        fields = line.split(';')
        if len(fields) < 5 or not fields[2]:
            continue
        try:
            if float(fields[4]) < 99.0:
                low.update(record['variant'])
        except ValueError:
            low.update(record['variant'])
os.environ['CORES_TITLE'] = 'Buster multiplexed-counter recovery'
os.environ['CORES_LINK'] = 'https://github.com/buster14a/buster'
os.environ['SOURCE_DATE_EPOCH'] = '1792454400'
os.environ['LC_ALL'] = 'C'
os.environ.pop('CPATH', None)
os.environ.pop('C_INCLUDE_PATH', None)
with tempfile.TemporaryDirectory(prefix='buster-recover-') as tmp, (out / 'recovery.jsonl').open('w') as log:
    for event in sorted(low):
        for rep in range(a.repetitions):
            for workload, command in commands.items():
                command = command.replace('<COMPILER>', str(Path(a.compiler).resolve()))
                command = command.replace('<CORPUS>', str(Path(a.corpus).resolve())).replace('<SCRATCH>', tmp)
                perf = Path(tmp) / 'perf.csv'
                error = Path(tmp) / 'stderr.txt'
                argv = ['perf', 'stat', '--no-big-num', '-x', ';', '-o', str(perf),
                        '-e', f'cycles:u,instructions:u,{event}:u', '--', *shlex.split(command)]
                wrapper = ['cores', '-n', '1', '--', 'bash', '-c',
                           'exec taskset -c "${CORES_CPUS%%,*}" "$@"', 'pin', *argv]
                with error.open('wb') as err:
                    result = subprocess.run(wrapper, stdout=subprocess.DEVNULL, stderr=err, check=False)
                row = {'event': event, 'repetition': rep, 'workload': workload, 'status': result.returncode,
                       'perf_stat': perf.read_text() if perf.exists() else '',
                       'stderr': error.read_text(errors='replace')}
                log.write(json.dumps(row) + '\n')
                log.flush()
print('recovered', len(low), 'events')
