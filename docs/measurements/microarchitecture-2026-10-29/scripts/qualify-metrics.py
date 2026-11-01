#!/usr/bin/env python3
"""Write an additive, identity-bound qualification; never rewrite raw evidence."""
import argparse
import collections
import csv
import hashlib
import json
from pathlib import Path

from metric_qualification import ARCHIVE_COMMIT, Inventory, archived_capture, blob_sha, qualify

FIELDS = ['source_line', 'workload', 'metric', 'repetition', 'process_status',
          'eligible', 'qualification', 'reason', 'value', 'unit', 'raw_formula_value',
          'reported_value', 'reported_unit_and_name', 'minimum_counter_duty_percent',
          'scope', 'scope_evidence', 'formula_sha256', 'formula_closure_sha256', 'record_sha256']


def audit(directory, destination):
    directory, destination = Path(directory), Path(destination)
    measurement_bytes = (directory / 'measurements.jsonl').read_bytes()
    inventory_bytes = (directory / 'perf-list.json').read_bytes()
    historical = archived_capture(measurement_bytes, inventory_bytes)
    inventory = Inventory(json.loads(inventory_bytes))
    # Existing outputs must never be silently rewritten, especially in an archive.
    destination.mkdir(parents=True, exist_ok=False)
    provenance = {
        'schema': 'buster-perf-metric-qualification-v1',
        'archive_commit': ARCHIVE_COMMIT if historical else None,
        'measurements_git_blob': blob_sha(measurement_bytes),
        'inventory_git_blob': blob_sha(inventory_bytes),
        'measurements_sha256': hashlib.sha256(measurement_bytes).hexdigest(),
        'inventory_sha256': hashlib.sha256(inventory_bytes).hexdigest(),
        'historical_scope_verified': historical,
        'implementation_sha256': hashlib.sha256(Path(__file__).with_name('metric_qualification.py').read_bytes()).hexdigest(),
        'historical_effective_attributes': 'not retained; scope established only by byte-bound collector revision' if historical else None,
        'hardware_recollection': 'not performed by this offline audit',
    }
    (destination / 'provenance.json').write_text(json.dumps(provenance, indent=2) + '\n')
    counts = collections.Counter()
    affected = set()
    topdown = []
    count = 0
    with (destination / 'metrics-qualification.jsonl').open('w') as out, (destination / 'metrics-qualification.csv').open('w', newline='') as csv_out:
        writer = csv.DictWriter(csv_out, FIELDS, extrasaction='ignore', lineterminator='\n')
        writer.writeheader()
        for number, line in enumerate(measurement_bytes.splitlines(), 1):
            if not line.strip():
                continue
            row = json.loads(line)
            if row.get('kind') != 'metric':
                continue
            result = qualify(row, inventory, historical=historical)
            result.update(source_line=number, workload=row.get('workload'), repetition=row.get('repetition'),
                          process_status=row.get('status'), record_sha256=hashlib.sha256(line).hexdigest())
            out.write(json.dumps(result, sort_keys=True, allow_nan=False) + '\n')
            writer.writerow(result)
            counts[result['qualification']] += 1
            count += 1
            # Repairable from raw operands needs no recollection. Existing unavailable
            # or underscheduled coverage is not silently added to a semantic rerun.
            if result['qualification'] == 'semantically-invalid':
                affected.add(result['metric'])
            definition = inventory.metrics.get(result['metric'], {})
            if result['metric'] in ('retiring', 'bad_speculation', 'frontend_bound', 'backend_bound', 'smt_contention') or any(word in definition.get('MetricGroup', '') for word in ('Pipeline', 'retiring', 'frontend_bound', 'backend_bound', 'bad_speculation')):
                topdown.append({key: result.get(key) for key in FIELDS})
    with (destination / 'topdown-qualification.csv').open('w', newline='') as out:
        writer = csv.DictWriter(out, FIELDS, lineterminator='\n')
        writer.writeheader()
        writer.writerows(topdown)
    (destination / 'affected-metrics.txt').write_text(''.join(name + '\n' for name in sorted(affected)))
    summary = {'metric_records': count, 'classifications': dict(sorted(counts.items())),
               'semantically_invalid_formulas_for_review': sorted(affected),
               'topdown_records_individually_audited': len(topdown)}
    (destination / 'summary.json').write_text(json.dumps(summary, indent=2) + '\n')
    print(json.dumps(summary, sort_keys=True))
    return summary


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('directory', type=Path)
    parser.add_argument('--out', required=True, type=Path, help='new directory; existing destinations are refused')
    args = parser.parse_args()
    audit(args.directory, args.out)
