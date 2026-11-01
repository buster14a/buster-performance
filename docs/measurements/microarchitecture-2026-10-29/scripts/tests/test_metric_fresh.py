"""Checks for the fresh-capture controls; they do not run perf or hardware."""
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

SCRIPTS = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(SCRIPTS))
from metric_workloads import describe_workloads, workload_commands


class FreshControlTests(unittest.TestCase):
    def test_help(self):
        for script in ('fresh-control.py', 'qualify-fresh.py'):
            with self.subTest(script=script):
                result = subprocess.run([sys.executable, str(SCRIPTS / script), '--help'],
                                        stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                        text=True, check=False)
                self.assertEqual(result.returncode, 0, result.stderr)

    def test_workloads_are_shared_and_frozen(self):
        with tempfile.TemporaryDirectory() as temporary:
            temporary = Path(temporary)
            commands = workload_commands('/compiler', '/corpus', temporary / 'sqlite.o')
            self.assertEqual(set(commands), {'preprocess', 'syntax', 'compile'})
            self.assertIn('-march=znver5', commands['compile'])
            self.assertIn('-std=gnu17', commands['compile'])
            self.assertEqual(commands['compile'][-1], '/corpus/sqlite/sqlite3.c')
            self.assertEqual(commands['preprocess'][1:3], ['-E', '-P'])
            self.assertEqual(commands['syntax'][1], '-fsyntax-only')
            described = describe_workloads(commands, '/compiler', '/corpus', temporary)
            self.assertIn('<COMPILER>', described['compile'])
            self.assertIn('<CORPUS>', described['compile'])
            self.assertIn('<SCRATCH>', described['compile'])


if __name__ == '__main__':
    unittest.main()
