#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and THIRD_PARTY_NOTICES.md.
"""End-to-end fixture; only the separately compiled WAIT_OBSERVE_E2E_TEST binary is used."""
import hashlib
import os
from pathlib import Path
import shutil
import signal
import subprocess
import tempfile
import time
import unittest

HERE = Path(__file__).resolve().parent
LAUNCHER = HERE / 'wait-observe-e2e'
PRODUCTION = HERE / 'wait-observe-production'
REV = '2dc50258e8b33393474b64032a5cbe9f17c63def'
CONTROL = '51b54dd02986a28f294c0d5b2539e93739acb8962851127316da7953d4f8b09b'
HEADER = 'lanes\tinstrumented\tcpu_mask\twall_ns\tuser_us\tsystem_us\twait4_peak_kb\tminor_faults\tmajor_faults\tvoluntary_switches\tinvoluntary_switches\twait_status\tinterrupted\tobjects\tverified\n'
GUARD = 'lock-guard\tstart-realtime-ns=1\tend-realtime-ns=2\tmonotonic-ns=100\tstatus=0\tinterrupted=0\tdescendants-clean=1\n'
WINDOW = 'guard-monotonic-ns=100\nwrapper-wall-ns-including-wait=200\nwrapper-status=0\nwrapper-interrupted=0\nlock-hold-upper-bound-valid=1\n'


def sha(path): return hashlib.sha256(path.read_bytes()).hexdigest()


def put(path, text):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text)


def env_receipt(env):
    out = 'compiler-environment:\nLC_ALL=C\nLANG=C\nTZ=UTC\nSOURCE_DATE_EPOCH=0\n'
    out += 'cleared=MAKEFLAGS,MFLAGS,CPATH,C_INCLUDE_PATH,CPLUS_INCLUDE_PATH,OBJC_INCLUDE_PATH,LIBRARY_PATH,COMPILER_PATH,GCC_EXEC_PREFIX,BUSTER_CLANG_RESOURCE_DIR,BUSTER_TEST_*\n'
    out += 'LD_PRELOAD=absent\nLD_LIBRARY_PATH=absent\n'
    for name in ('BUSTER_HUGE_PAGES', 'CORES', 'PATH'):
        out += f'{name}={env.get(name) or "unset"}\n'
    return out


def fixture(root):
    control = root/'control'; diagnostic = root/'diagnostic'; qualified = root/'qualified'; case = qualified/'case'; reference = qualified/'reference'
    (control/'build').mkdir(parents=True); (diagnostic/'build').mkdir(parents=True); case.mkdir(parents=True); reference.mkdir()
    control_exe = control/'build/compiler'; control_exe.write_text('#!/bin/sh\nexit 0\n'); control_exe.chmod(0o755)
    diag_exe = diagnostic/'build/compiler'; shutil.copyfile(HERE/'fake-compiler.py', diag_exe); diag_exe.chmod(0o755)
    lock = root/'fake-lock'; shutil.copyfile(HERE/'fake-lock.py', lock); lock.chmod(0o755)
    validator = root/'validator.py'; shutil.copyfile(HERE/'validate-wait.py', validator)
    files = []
    for name in ('alpha.c', 'beta.c'):
        p=root/'inputs'/name; put(p, 'int fixture;\n'); files.append(p)
    put(case/'args.txt', '-c\n' + ''.join(str(p)+'\n' for p in files))
    put(case/'outputs.txt', 'alpha.o\nbeta.o\n')
    put(case/'sources.sha256', ''.join(f'{sha(p)}  {p}\n' for p in files))
    put(case/'provenance.txt', 'synthetic fixture\n')
    for name in ('alpha', 'beta'): put(reference/f'{name}.o', f'{name} object\n')
    objects = ''.join(f'{sha(reference/name)}  {name}\n' for name in ('alpha.o','beta.o'))
    put(reference/'objects.sha256', objects)
    env = os.environ.copy()
    for name in ('LD_PRELOAD', 'LD_LIBRARY_PATH', 'BUSTER_HUGE_PAGES', 'CORES'):
        env.pop(name, None)
    env.update(WAIT_E2E_LOCK_PATH=str(root/'mock.lock'), WAIT_E2E_OWNER_PATH=str(root/'owner'), WAIT_E2E_IDENTITIES=str(root/'expected.sha256'),
               WAIT_E2E_INPUT=str(files[0]), WAIT_E2E_ORPHAN_PID=str(root/'orphan.pid'), WAIT_E2E_STARTED=str(root/'compiler.started'), CPATH='should-be-cleared', BUSTER_TEST_149='should-be-cleared')
    env.update(LC_ALL='C.UTF-8', LANG='C.UTF-8', TZ='Europe/Madrid', SOURCE_DATE_EPOCH='42')
    put(root/'expected.sha256', ''.join(f'{sha(p)}  {p}\n' for p in (control_exe, diag_exe, validator)))
    identity = f'compiler-source={control}\ncompiler-revision={REV}\ncompiler-source-state=clean\nsha256sum:\n{CONTROL}  {control_exe}\n'
    policy = 'synthetic policy\n'; environment = env_receipt(env)
    for name, content in [('identity.before.txt',identity),('identity.after.txt',identity),('host-policy.before.txt',policy),('host-policy.after.txt',policy),('environment.txt',environment),('environment.after.txt',environment),('summary.tsv','synthetic summary\n'),('case-status.txt','case-status=qualified\nparent-issue-status=not-established-by-one-case\n')]: put(qualified/name, content)
    def sample(name, lanes, instrumented=False, cpu2=False):
        sub=qualified/name; sub.mkdir(exist_ok=True)
        put(sub/'sample.tsv', HEADER+f'{lanes}\t{int(instrumented)}\t{4 if cpu2 else 255}\t1\t1\t1\t1\t1\t0\t0\t0\t0\t0\t2\t1\n')
        if name != 'reference': put(sub/'objects.sha256', objects)
        for filename, content in [('identity.before.txt',identity),('identity.after.txt',identity),('host-policy.before.txt',policy),('host-policy.after.txt',policy),('environment.txt',environment),('environment.after.txt',environment)]: put(sub/filename, content)
        if instrumented: put(sub/'stages.tsv','synthetic stage\n')
        put(qualified/f'{name}.lock.stdout',GUARD);put(qualified/f'{name}.lock-window.txt',WINDOW)
    sample('reference',1)
    for slot in range(9): sample(f'warmup-{slot}', slot+1 if slot<8 else 1, cpu2=(slot==8))
    for rnd in range(1,8):
        for slot in range(9): sample(f'run-{rnd:03}-{slot}',slot+1 if slot<8 else 1,cpu2=(slot==8))
    for slot in range(9): sample(f'diagnostic-{slot}',slot+1 if slot<8 else 1,instrumented=True,cpu2=(slot==8))
    command = [str(LAUNCHER),'--qualified',str(qualified),'--control-source',str(control),'--diagnostic-source',str(diagnostic),'--lock',str(lock),'--validator',str(validator),'--lanes','2']
    return env, command, files, diag_exe, qualified


class EndToEnd(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not LAUNCHER.is_file() or not PRODUCTION.is_file(): raise RuntimeError('build synthetic and production launchers first')
        assert b'WAIT_E2E_' not in PRODUCTION.read_bytes(), 'test seam leaked into production build'

    def test_full_controller_guard_and_failures(self):
        modes = ('ok','nonzero','signal','timeout','orphan','validator-refusal','missing','changed','symlink','mutate-input','mutate-binary','lock-refusal','missing-guard','failed-guard','late-grant','stale-sample','missing-reference-guard','missing-case-sample','smoke-success')
        for mode in modes:
            with self.subTest(mode=mode), tempfile.TemporaryDirectory(prefix='wait-observe-e2e-') as name:
                root=Path(name); env, command, files, diag_exe, qualified = fixture(root);env['WAIT_E2E_MODE']=mode
                if mode == 'missing-reference-guard': (qualified/'reference.lock.stdout').unlink()
                if mode == 'missing-case-sample': (qualified/'run-007-8'/'sample.tsv').unlink()
                if mode == 'smoke-success':
                    put(qualified/'case-status.txt','case-status=failed\nparent-issue-status=not-established\n'); command.append('--smoke')
                out=root/'observation'; command += ['--output',str(out)]
                try:
                    result=subprocess.run(command,env=env,capture_output=True,text=True,timeout=15)
                except subprocess.TimeoutExpired as exc:
                    self.fail(f'{mode}: controller did not terminate: {exc}')
                expected = 0 if mode in ('ok','smoke-success') else 1
                status_path=out/'observation-status.txt'
                status=status_path.read_text() if status_path.exists() else ''
                self.assertEqual(result.returncode,expected, f'{mode}: stdout={result.stdout} stderr={result.stderr} status={status}')
                if mode == 'ok': self.assertIn('observation-status=validated\n',status)
                elif mode == 'smoke-success': self.assertIn('observation-status=smoke-passed\n',status); self.assertNotIn('observation-status=validated\n',status)
                else: self.assertNotIn('observation-status=validated\n',status); self.assertIn('observation-status=failed\n',status)
                launched = mode in ('ok','smoke-success','nonzero','signal','timeout','orphan','validator-refusal','missing','changed','symlink','mutate-input','mutate-binary')
                self.assertEqual((root/'compiler.started').exists(), launched, f'{mode}: unexpected compiler launch boundary')
                if mode == 'validator-refusal':
                    self.assertIn('wrong owner PID', (out/'sample'/'validation.txt').read_text())
                if mode in ('missing','changed','symlink','mutate-input','mutate-binary'):
                    self.assertIn('PASS lanes=', (out/'sample'/'validation.txt').read_text())
                if mode == 'orphan':
                    self.assertTrue((root/'orphan.pid').exists(), 'orphan fixture never started')
                    pid=int((root/'orphan.pid').read_text())
                    try: os.kill(pid,0)
                    except ProcessLookupError: pass
                    else: self.fail(f'orphan {pid} remained after guard completion')
                if mode in ('validator-refusal','missing','changed','symlink','mutate-input','mutate-binary','nonzero','signal','timeout','orphan'):
                    self.assertTrue((out/'sample'/'process.txt').exists(), f'{mode}: process receipt not retained')


if __name__ == '__main__': unittest.main(verbosity=2)
