"""Collection tests use a fake perf runner; they are not PMU measurements."""
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from metric_collect import collect_metric
from test_metric_qualification import BRANCH, USER, INVENTORY, live


class CollectionTests(unittest.TestCase):
    def fake(self, record, scope='user', status=0, evlist_status=0):
        def run(argv, **kwargs):
            self.assertFalse(kwargs.get('shell', False))
            self.assertEqual(kwargs['env']['LC_ALL'], 'C')
            if argv[:3] == ['perf', 'stat', 'record']:
                Path(argv[argv.index('-o') + 1]).write_bytes(b'fake stat capture for unit test')
                return subprocess.CompletedProcess(argv, status, '', live(record, scope)['perf_stat'])
            self.assertEqual(argv[:3], ['perf', 'evlist', '-v'])
            return subprocess.CompletedProcess(argv, evlist_status, live(record, scope)['perf_evlist'], '')
        return run

    def test_capture_is_bound_and_precise(self):
        with tempfile.TemporaryDirectory() as temporary, patch('metric_collect.subprocess.run', side_effect=self.fake(BRANCH)) as run:
            out = Path(temporary) / 'one'
            row = collect_metric(INVENTORY, BRANCH['variant'], ['/compiler', 'input.c'], out)
            self.assertTrue(row['qualification']['eligible'], row)
            self.assertEqual(row['qualification']['qualification'], 'valid')
            self.assertEqual(run.call_count, 2)
            self.assertEqual(len(row['stat_data_sha256']), 64)
            self.assertTrue((out / 'stat.data').is_file())
            self.assertTrue((out / 'evlist.txt').is_file())
            self.assertEqual(json.loads((out / 'record.json').read_text()), row)

    def test_privilege_formula_never_gets_all_user(self):
        with tempfile.TemporaryDirectory() as temporary, patch('metric_collect.subprocess.run', side_effect=self.fake(USER, 'formula')):
            row = collect_metric(INVENTORY, USER['variant'], ['/compiler'], Path(temporary) / 'one')
            self.assertNotIn('--all-user', row['perf_argv'])
            self.assertTrue(row['qualification']['eligible'], row)

    def test_failed_workload_never_exports_a_value(self):
        with tempfile.TemporaryDirectory() as temporary, patch('metric_collect.subprocess.run', side_effect=self.fake(BRANCH, status=7)):
            row = collect_metric(INVENTORY, BRANCH['variant'], ['/compiler'], Path(temporary) / 'one')
            self.assertEqual(row['qualification']['qualification'], 'failed')
            self.assertIsNone(row['qualification']['value'])

    def test_evlist_failure_uses_verbose_attributes(self):
        with tempfile.TemporaryDirectory() as temporary, patch('metric_collect.subprocess.run', side_effect=self.fake(BRANCH, evlist_status=2)):
            row = collect_metric(INVENTORY, BRANCH['variant'], ['/compiler'], Path(temporary) / 'one')
            self.assertTrue(row['qualification']['eligible'], row)
            self.assertEqual(row['qualification']['scope_evidence'], 'perf-verbose-attrs')

    def test_unknown_metric_is_not_launched(self):
        with tempfile.TemporaryDirectory() as temporary, patch('metric_collect.subprocess.run') as run:
            row = collect_metric(INVENTORY, 'unknown', ['/compiler'], Path(temporary) / 'one')
            run.assert_not_called()
            self.assertEqual(row['qualification']['qualification'], 'unsupported')

    def test_old_capture_is_not_reused(self):
        with tempfile.TemporaryDirectory() as temporary, patch('metric_collect.subprocess.run') as run:
            with self.assertRaises(FileExistsError):
                collect_metric(INVENTORY, BRANCH['variant'], ['/compiler'], Path(temporary))
            run.assert_not_called()

    def test_os_error_is_failure(self):
        with tempfile.TemporaryDirectory() as temporary, patch('metric_collect.subprocess.run', side_effect=FileNotFoundError('perf')):
            row = collect_metric(INVENTORY, BRANCH['variant'], ['/compiler'], Path(temporary) / 'one')
            self.assertEqual(row['status'], -1)
            self.assertFalse(row['qualification']['eligible'])

    def test_independent_time_control_status_and_no_overwrite(self):
        cc = shutil.which('cc')
        if not cc:
            self.skipTest('C compiler not installed')
        with tempfile.TemporaryDirectory() as temporary:
            temporary = Path(temporary)
            exe = temporary / 'control'
            source = Path(__file__).resolve().parents[1] / 'metric-time-control.c'
            subprocess.run([cc, '-std=c17', '-O2', '-Wall', '-Wextra', '-Werror', str(source), '-o', str(exe)], check=True)
            receipt = temporary / 'receipt.json'
            good = subprocess.run([str(exe), str(receipt), '--', '/bin/true'], capture_output=True)
            self.assertEqual(good.returncode, 0)
            result = json.loads(receipt.read_text())
            self.assertEqual(result['status'], 0)
            self.assertGreater(result['elapsed_seconds'], 0)
            again = subprocess.run([str(exe), str(receipt), '--', '/bin/true'], capture_output=True)
            self.assertNotEqual(again.returncode, 0)
            bad = subprocess.run([str(exe), str(temporary / 'failure.json'), '--', '/bin/false'], capture_output=True)
            self.assertEqual(bad.returncode, 1)
            missing = subprocess.run([str(exe), str(temporary / 'missing.json'), '--', '/not/a/program'], capture_output=True)
            self.assertEqual(missing.returncode, 127)


if __name__ == '__main__':
    unittest.main()
