"""Distinguish a preflight refusal from a failed workload, without trusting tags."""
import sys
from pathlib import Path
import unittest
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from metric_qualification import Inventory, qualify
from test_metric_qualification import BRANCH, ENTRIES, INVENTORY, metric


class AdmissionEdges(unittest.TestCase):
    def test_never_launched_unsupported_is_not_failed(self):
        row = {'variant': 'unknown', 'status': None, 'collector_schema': 'buster-perf-metric-v1',
               'qualification': {'eligible': True, 'value': '123'}}
        result = qualify(row, INVENTORY)
        self.assertEqual(result['qualification'], 'unsupported')
        self.assertFalse(result['eligible'])
        self.assertIsNone(result['value'])

    def test_supported_formula_with_no_success_stays_failed(self):
        row = dict(BRANCH, status=None, collector_schema='buster-perf-metric-v1')
        self.assertEqual(qualify(row, INVENTORY)['qualification'], 'failed')

    def test_unsupported_grammar_without_conflicting_definitions(self):
        entries = [entry for entry in ENTRIES if entry.get('MetricName') != BRANCH['variant']]
        for expression in ('__import__("os").system("false")', '0 if has_event(x) else 1', 'ex_ret_brn ** 2', '#target_cpu', '1'):
            with self.subTest(expression=expression):
                inventory = Inventory([*entries, metric(BRANCH['variant'], expression, '1per_branch')])
                result = qualify(BRANCH, inventory, historical=True)
                self.assertEqual(result['qualification'], 'unsupported')
                self.assertNotIn('conflicting', result['reason'])
                self.assertFalse(result['eligible'])
