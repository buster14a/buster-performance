"""Scope-preserving metric collection for the existing Python campaign.

Every stat.data file is retained. Its evlist supplies effective attributes from
that invocation, not a separate probe or an interpretation of the display name.
A separate workload-time receipt may reject a duration, never replace it.
"""
import hashlib
import json
import os
from pathlib import Path
import subprocess

from metric_qualification import Rejected, qualify


def collect_metric(inventory, metric, command, destination, wrap=lambda command: command, time_control=None):
    destination = Path(destination)
    destination.mkdir(parents=True, exist_ok=False)
    row = {'kind': 'metric', 'variant': metric, 'status': None, 'perf_stat': '',
           'workload_argv': list(command), 'collector_schema': 'buster-perf-metric-v2'}
    try:
        plan = inventory.plan(metric)
    except Rejected as error:
        row.update(collection_error=error.reason,
                   qualification={'eligible': False, 'value': None, 'qualification': error.state, 'reason': error.reason})
        (destination / 'record.json').write_text(json.dumps(row, indent=2) + '\n')
        return row
    row['collection_scope'] = plan['scope']
    data = destination / 'stat.data'
    argv = ['perf', 'stat', 'record', '--no-big-num', '-vvv', '-o', str(data), *plan['arguments'], '--', *command]
    row['perf_argv'] = argv
    row['executed_argv'] = wrap(argv)
    environment = dict(os.environ, LC_ALL='C')
    try:
        # A workload's own stderr stays in the retained text; no parser may infer
        # success from that text. Both exit status and mandatory operands matter.
        run = subprocess.run(row['executed_argv'], stdout=subprocess.DEVNULL, stderr=subprocess.PIPE,
                             text=True, errors='replace', env=environment, check=False)
        row.update(status=run.returncode, perf_stat=run.stderr,
                   perf_stat_sha256=hashlib.sha256(run.stderr.encode()).hexdigest())
        (destination / 'stat.stderr').write_text(run.stderr)
        if data.is_file():
            row['stat_data_sha256'] = hashlib.sha256(data.read_bytes()).hexdigest()
            evlist = subprocess.run(['perf', 'evlist', '-v', '-i', str(data)], stdout=subprocess.PIPE,
                                    stderr=subprocess.PIPE, text=True, errors='replace', env=environment, check=False)
            row.update(perf_evlist=evlist.stdout, evlist_status=evlist.returncode, evlist_stderr=evlist.stderr)
            (destination / 'evlist.txt').write_text(evlist.stdout)
        if 'duration_time' in inventory.leaves(metric) and time_control and run.returncode == 0:
            # The control executable times ONLY the workload, in a separate run;
            # Python/perf/orchestration wall time is never a formula operand.
            receipt = destination / 'time-control.json'
            control_argv = [str(Path(time_control).resolve()), str(receipt), '--', *command]
            control = subprocess.run(wrap(control_argv), stdout=subprocess.DEVNULL, stderr=subprocess.PIPE,
                                     text=True, errors='replace', env=environment, check=False)
            row.update(time_control_argv=control_argv, time_control_status=control.returncode,
                       time_control_stderr=control.stderr)
            if control.returncode == 0 and receipt.is_file():
                control_result = json.loads(receipt.read_text())
                row['time_control_receipt'] = control_result
                if control_result.get('status') == 0:
                    row['time_sanity_seconds'] = str(control_result['elapsed_seconds'])
    except (OSError, ValueError) as error:
        row.update(status=-1, collection_error=str(error))
    row['qualification'] = qualify(row, inventory)
    (destination / 'record.json').write_text(json.dumps(row, indent=2, allow_nan=False) + '\n')
    return row
