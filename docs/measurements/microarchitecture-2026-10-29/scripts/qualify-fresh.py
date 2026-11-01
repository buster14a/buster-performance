#!/usr/bin/env python3
"""Audit a fresh #875 metric capture against independent controls.

The campaign's collector already qualifies each record from its own retained
perf data. This reader adds the acceptance checks that need a separate
invocation: raw privilege domains, an independent workload-time receipt, and
the exact formulas the historical capture could not establish.
"""
import argparse
import csv
from decimal import Decimal
import json
from pathlib import Path
import statistics

from metric_qualification import Inventory, canonical, qualify

DURATION_METRICS = (
    'lpm_br_cond_retired', 'lpm_br_far_retired', 'lpm_br_fused_retired',
    'lpm_br_taken_retired', 'lpm_br_total_insn_fe_resteers',
    'lpm_br_total_retired', 'lpm_cs_rate', 'lpm_itlb_l2_reqs',
    'lpm_l3_accesses', 'lpm_ldst_total_ld', 'lpm_ldst_total_st',
)
PRIVILEGE_METRICS = (
    'lpm_cycles_user', 'lpm_cycles_kernel', 'lpm_cycles_guest', 'lpm_cycles_total',
)
EXPECTED = DURATION_METRICS + PRIVILEGE_METRICS
WORKLOADS = ('preprocess', 'syntax', 'compile')
# The formula's max() operand is an amd_l3 event the kernel refuses per thread;
# it needs system-wide/uncore support and must not be forced into process scope.
EXPECTED_UNAVAILABLE = {'lpm_l3_accesses': 'l3_lookup_state.all_coherent_accesses_to_l3'}

p = argparse.ArgumentParser()
p.add_argument('--campaign', required=True)
p.add_argument('--controls', required=True)
p.add_argument('--out', required=True)
a = p.parse_args()
campaign = Path(a.campaign).resolve()
controls = Path(a.controls).resolve()
out = Path(a.out).resolve()
out.mkdir(parents=True, exist_ok=False)

inventory = Inventory(json.loads((campaign / 'perf-list.json').read_text()))
records = {}
for line in (campaign / 'measurements.jsonl').read_text().splitlines():
    row = json.loads(line)
    if row.get('kind') == 'metric':
        records[(row['workload'], row['variant'])] = row

controls_by_workload = {}
for line in (controls / 'raw-privilege.jsonl').read_text().splitlines():
    row = json.loads(line)
    controls_by_workload.setdefault(row['workload'], []).append(row)


def parse_control_row(text):
    rows = {}
    for line in text.splitlines():
        if not line.strip() or ';' not in line:
            continue
        fields = line.split(';')
        if len(fields) < 3 or not fields[2].strip():
            continue
        rows[canonical(fields[2])] = Decimal(fields[0].strip())
    return rows


def raw_share(workload):
    shares = []
    for row in controls_by_workload.get(workload, []):
        if row['raw']['status'] != 0:
            continue
        values = parse_control_row(row['raw']['stderr'])
        user, kernel, guest = (values.get('cpu-cycles:uH'), values.get('cpu-cycles:kHh'),
                               values.get('cpu-cycles:G'))
        if user is None or kernel is None or guest is None:
            continue
        total = user + kernel + guest
        if total <= 0:
            continue
        shares.append({'user': user / total, 'kernel': kernel / total,
                       'guest': guest / total, 'user_raw': user, 'kernel_raw': kernel,
                       'guest_raw': guest, 'total': total})
    if not shares:
        return None
    return {key: statistics.median(float(item[key]) for item in shares)
            for key in ('user', 'kernel', 'guest')} | {
        'user_raw': statistics.median(float(item['user_raw']) for item in shares),
        'kernel_raw': statistics.median(float(item['kernel_raw']) for item in shares),
        'repetitions': len(shares)}


def operand_values(result):
    return {canonical(row['event']): Decimal(row['count']) for row in result['operands']}


failures = []
rows = []
results = {}
for workload in WORKLOADS:
    raw = raw_share(workload)
    if raw is None:
        failures.append(f'{workload}: no usable raw privilege control')
    elif raw['user_raw'] <= 0 or raw['kernel_raw'] <= 0:
        failures.append(f'{workload}: raw privilege control lacks a positive domain')
    elif raw['user_raw'] == raw['kernel_raw']:
        failures.append(f'{workload}: raw privilege domains are identical')
    for metric in EXPECTED:
        key = (workload, metric)
        if key not in records:
            failures.append(f'{workload}/{metric}: missing capture')
            continue
        result = qualify(records[key], inventory)
        results[key] = result
        if metric in EXPECTED_UNAVAILABLE:
            if result['eligible'] or result['value'] is not None:
                failures.append(f'{workload}/{metric}: unexpectedly qualified')
            elif result['qualification'] not in ('unavailable', 'unsupported'):
                failures.append(f'{workload}/{metric}: {result["qualification"]}: {result["reason"]}')
            rows.append({'workload': workload, 'metric': metric,
                         'qualification': result['qualification'], 'value': '',
                         'unit': '', 'minimum_duty': '', 'time_sanity_seconds': '',
                         'reason': result['reason']})
            continue
        if not result['eligible'] or result['value'] is None:
            failures.append(f'{workload}/{metric}: {result["qualification"]}: {result["reason"]}')
            rows.append({'workload': workload, 'metric': metric,
                         'qualification': result['qualification'], 'value': '',
                         'unit': '', 'minimum_duty': '', 'time_sanity_seconds': '',
                         'reason': result['reason']})
            continue
        values = operand_values(result)
        if metric in DURATION_METRICS:
            duration_row = next((row for row in result['operands'] if canonical(row['event']) == 'duration_time'), None)
            duration = values.get('duration_time')
            if duration_row is not None and duration_row.get('duration_source') == 'perf-elapsed':
                elapsed_row = next((row for row in result['operands'] if row['event'] == 'elapsed'), None)
                duration = Decimal(elapsed_row['count']) if elapsed_row is not None else None
            elif duration is not None:
                duration /= Decimal(1000000000)
            if duration is None or duration <= 0:
                failures.append(f'{workload}/{metric}: no positive captured duration')
            receipt = records[key].get('time_sanity_seconds')
            if receipt is None or Decimal(receipt) <= 0:
                failures.append(f'{workload}/{metric}: missing independent time control')
            elif not Decimal('0.5') <= duration / Decimal(receipt) <= Decimal('2'):
                failures.append(f'{workload}/{metric}: captured duration disagrees with control')
        else:
            user, kernel, guest = (values.get('cpu-cycles:uH'), values.get('cpu-cycles:kHh'),
                                   values.get('cpu-cycles:G'))
            if None in (user, kernel, guest) or user + kernel + guest <= 0:
                failures.append(f'{workload}/{metric}: missing privilege operands')
            if metric == 'lpm_cycles_total':
                if Decimal(result['value']) != user + kernel + guest:
                    failures.append(f'{workload}/{metric}: total does not equal operand sum')
            else:
                total = user + kernel + guest
                share = values['cpu-cycles:uH' if metric == 'lpm_cycles_user' else
                               'cpu-cycles:kHh' if metric == 'lpm_cycles_kernel' else
                               'cpu-cycles:G'] / total
                if raw is not None:
                    expected = raw['user' if metric == 'lpm_cycles_user' else
                                   'kernel' if metric == 'lpm_cycles_kernel' else 'guest']
                    if abs(float(share) - expected) > 0.10:
                        failures.append(f'{workload}/{metric}: share {float(share):.4f} '
                                        f'disagrees with control {expected:.4f}')
        rows.append({'workload': workload, 'metric': metric,
                     'qualification': result['qualification'], 'value': result['value'],
                     'unit': result['unit'],
                     'minimum_duty': result['minimum_counter_duty_percent'],
                     'time_sanity_seconds': records[key].get('time_sanity_seconds', ''),
                     'reason': result['reason']})

# Effective attributes are the evidence that the requested privilege domains
# survived collection; the display modifiers alone are not.
for workload in WORKLOADS:
    examples = {'lpm_cycles_user': 'cpu-cycles:uH', 'lpm_cycles_kernel': 'cpu-cycles:kHh',
                'lpm_cycles_guest': 'cpu-cycles:G'}
    for metric, operand in examples.items():
        result = results.get((workload, metric))
        if result is None or not result.get('eligible'):
            continue
        attributes = None
        for row in result.get('operands', []):
            if canonical(row['event']) == operand and 'effective_attributes' in row:
                attributes = row['effective_attributes']
        if attributes is None:
            failures.append(f'{workload}/{metric}: no effective attributes for {operand}')
            continue
        if metric == 'lpm_cycles_user' and (attributes['exclude_user'] != 0 or attributes['exclude_kernel'] != 1):
            failures.append(f'{workload}/{metric}: user domain was overridden')
        if metric == 'lpm_cycles_kernel' and (attributes['exclude_user'] != 1 or attributes['exclude_kernel'] != 0):
            failures.append(f'{workload}/{metric}: kernel domain was overridden')
        if metric == 'lpm_cycles_guest' and attributes['exclude_guest'] != 0:
            failures.append(f'{workload}/{metric}: guest domain was overridden')

with (out / 'fresh-qualification.csv').open('w', newline='') as f:
    writer = csv.DictWriter(f, fieldnames=('workload', 'metric', 'qualification', 'value',
                                           'unit', 'minimum_duty', 'time_sanity_seconds',
                                           'reason'))
    writer.writeheader()
    writer.writerows(rows)
summary = {
    'records': len(rows),
    'eligible': sum(1 for row in rows if row['qualification'] in ('valid', 'genuine-zero', 'rounded-to-zero')),
    'failures': failures,
    'raw_privilege_controls': {workload: raw_share(workload) for workload in WORKLOADS},
    'duration_metrics': list(DURATION_METRICS),
    'privilege_metrics': list(PRIVILEGE_METRICS),
}
(out / 'fresh-summary.json').write_text(json.dumps(summary, indent=2) + '\n')
if failures:
    print('\n'.join(failures))
    raise SystemExit(f'{len(failures)} acceptance checks failed')
print('fresh qualification: PASS', flush=True)
