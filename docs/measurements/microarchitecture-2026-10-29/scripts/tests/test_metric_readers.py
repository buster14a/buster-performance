"""Frozen whole-capture and public exporter entry-point regressions."""
import csv
from decimal import Decimal
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from metric_qualification import Inventory, archived_capture, qualify
from test_metric_qualification import BRANCH, USER, TOTAL, LOAD

SCRIPTS = Path(__file__).resolve().parents[1]
CAPTURE = SCRIPTS.parent / 'zen5' / 'current'


class ReaderTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.raw = (CAPTURE / 'measurements.jsonl').read_bytes()
        cls.inv = (CAPTURE / 'perf-list.json').read_bytes()
        cls.inventory = Inventory(json.loads(cls.inv))
        cls.records = [json.loads(line) for line in cls.raw.splitlines()]
        cls.rows = {(r['workload'], r['variant']): r for r in cls.records if r.get('kind') == 'metric'}

    def test_immutable_capture_and_exact_fixtures(self):
        self.assertTrue(archived_capture(self.raw, self.inv))
        for record in (BRANCH, USER, TOTAL):
            self.assertEqual(record, self.rows[record['workload'], record['variant']])
        self.assertIn(LOAD['perf_stat'], self.rows['compile', 'lpm_ldst_total_ld']['perf_stat'])

    def test_all_workloads_reject_privilege_and_duration_failures(self):
        for workload in ('preprocess', 'syntax', 'compile'):
            for name in ('lpm_cycles_user', 'lpm_cycles_kernel', 'lpm_cycles_guest', 'lpm_cycles_total', 'lpm_ldst_total_ld'):
                with self.subTest(workload=workload, name=name):
                    result = qualify(self.rows[workload, name], self.inventory, historical=True)
                    self.assertEqual(result['qualification'], 'semantically-invalid', result)
                    self.assertFalse(result['eligible'])
                    self.assertIsNone(result['value'])

    def test_no_blanket_topdown_invalidation(self):
        selected = [(key, row) for key, row in self.rows.items() if any(term in key[1] for term in ('backend_bound', 'frontend_bound', 'retiring', 'bad_speculation', 'smt_contention'))]
        self.assertEqual(len(selected), 39)
        for key, row in selected:
            result = qualify(row, self.inventory, historical=True)
            self.assertTrue(result['eligible'], (key, result))
            self.assertGreaterEqual(Decimal(result['value']), 0)
            self.assertLessEqual(Decimal(result['value']), 100)

    def test_export_is_qualified_and_never_overwrites(self):
        before = hashlib.sha256(self.raw).hexdigest()
        with tempfile.TemporaryDirectory() as temporary:
            destination = Path(temporary) / 'export'
            command = [sys.executable, str(SCRIPTS / 'export.py'), str(CAPTURE), '--out', str(destination)]
            subprocess.run(command, check=True, capture_output=True)
            with (destination / 'metrics-summary.csv').open() as source:
                rows = list(csv.DictReader(source))
            self.assertEqual(len(rows), 441)
            by_key = {(r['workload'], r['metric']): r for r in rows}
            for name in ('lpm_cycles_user', 'lpm_cycles_total', 'lpm_ldst_total_ld'):
                row = by_key['compile', name]
                self.assertEqual(row['eligible'], 'False')
                self.assertEqual(row['value'], '')
                self.assertEqual(row['process_status'], '0')
            row = by_key['compile', 'branch_misprediction_rate']
            self.assertEqual(row['reported_value'], '0.0')
            self.assertEqual(row['eligible'], 'True')
            self.assertGreater(Decimal(row['value']), Decimal('0.016'))
            second = subprocess.run(command, capture_output=True)
            self.assertNotEqual(second.returncode, 0)
        self.assertEqual(hashlib.sha256((CAPTURE / 'measurements.jsonl').read_bytes()).hexdigest(), before)

    def test_audit_is_additive_and_identity_bound(self):
        with tempfile.TemporaryDirectory() as temporary:
            destination = Path(temporary) / 'audit'
            command = [sys.executable, str(SCRIPTS / 'qualify-metrics.py'), str(CAPTURE), '--out', str(destination)]
            subprocess.run(command, check=True, capture_output=True)
            summary = json.loads((destination / 'summary.json').read_text())
            self.assertEqual(summary['metric_records'], 441)
            self.assertEqual(summary['topdown_records_individually_audited'], 39)
            self.assertEqual(sum(summary['classifications'].values()), 441)
            provenance = json.loads((destination / 'provenance.json').read_text())
            self.assertTrue(provenance['historical_scope_verified'])
            self.assertEqual(provenance['measurements_sha256'], hashlib.sha256(self.raw).hexdigest())
            self.assertNotEqual(subprocess.run(command, capture_output=True).returncode, 0)

    def test_unknown_capture_never_inherits_scope_from_its_path(self):
        with tempfile.TemporaryDirectory() as temporary:
            source = Path(temporary) / 'zen5' / 'current'
            source.mkdir(parents=True)
            (source / 'measurements.jsonl').write_bytes(self.raw + b'\n')
            (source / 'perf-list.json').write_bytes(self.inv)
            destination = Path(temporary) / 'export'
            subprocess.run([sys.executable, str(SCRIPTS / 'export.py'), str(source), '--out', str(destination)], check=True, capture_output=True)
            with (destination / 'metrics-summary.csv').open() as output:
                self.assertTrue(all(row['eligible'] == 'False' and row['value'] == '' for row in csv.DictReader(output)))

    def test_campaign_requires_explicit_subset(self):
        result = subprocess.run([sys.executable, str(SCRIPTS / 'campaign.py'), '--compiler', '/not-used', '--corpus', '/not-used', '--out', '/not-used', '--metrics-only'], capture_output=True, text=True)
        self.assertEqual(result.returncode, 2)
        self.assertIn('--metrics-only requires', result.stderr)


if __name__ == '__main__':
    unittest.main()
