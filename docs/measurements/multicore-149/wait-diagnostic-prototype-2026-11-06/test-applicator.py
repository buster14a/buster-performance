#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Test the diagnostic applicator in a disposable clone of its pinned source."""
import hashlib
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

BASE = 'e1fa1575b0ee112ecac733e09eb727cbbad4df64'
EXPECTED = {
    'src/buster/compiler/lane.c': '16c2af7891966e05323c6fdf29fcebfcc2594b2c8dcb9057fee2919956221eda',
    'src/buster/compiler/lane_test.c': '70ff3dc4de3d866a60ec5ba4a70713686aa16fe05a78330eae25835fbd679929',
    'src/buster/compiler/c_check_input.c': '026d68bb2a42667810c5205ee5a66498cac7ba209d4fae867ba05fb790880a8f',
}
if len(sys.argv) != 2:
    raise SystemExit('usage: test-applicator.py PINNED_COMPILER_CHECKOUT')
source = Path(sys.argv[1]).resolve(strict=True)
artifact = Path(__file__).resolve().parent

def run(*args, ok=True):
    p = subprocess.run([str(a) for a in args], text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if (p.returncode == 0) != ok:
        raise RuntimeError(f'{args}: exit {p.returncode}\n{p.stdout}\n{p.stderr}')
    return p

with tempfile.TemporaryDirectory(prefix='buster-wait-applicator-') as name:
    temp = Path(name)
    checkout = temp / 'compiler'
    run('git', 'clone', '--quiet', '--shared', '--no-checkout', source, checkout)
    run('git', '-C', checkout, 'checkout', '--quiet', '--detach', BASE)
    run('git', '-C', checkout, 'reset', '--quiet', '--hard', 'HEAD')
    script = artifact / 'apply-diagnostic.sh'
    def clean():
        assert run('git', '-C', checkout, 'status', '--porcelain=v1', '--untracked-files=all').stdout == ''
    clean()
    run('git', '-C', checkout, '-c', 'user.name=Test fixture', '-c', 'user.email=test@example.invalid',
        '-c', 'commit.gpgSign=false', '-c', 'core.hooksPath=/dev/null', 'commit', '--quiet', '--allow-empty', '-m', 'Wrong revision fixture')
    assert 'revision does not match' in run(script, checkout, ok=False).stderr
    clean()
    run('git', '-C', checkout, 'reset', '--quiet', '--hard', BASE)
    replacement_file = checkout / 'src/buster/compiler/lane.c'
    replacement_file.write_bytes(replacement_file.read_bytes() + b'\n')
    run('git', '-C', checkout, 'add', 'src/buster/compiler/lane.c')
    run('git', '-C', checkout, '-c', 'user.name=Test fixture', '-c', 'user.email=test@example.invalid',
        '-c', 'commit.gpgSign=false', '-c', 'core.hooksPath=/dev/null', 'commit', '--quiet', '-m', 'Replacement tree fixture')
    replacement = run('git', '-C', checkout, 'rev-parse', 'HEAD').stdout.strip()
    run('git', '-C', checkout, 'reset', '--quiet', '--hard', BASE)
    run('git', '-C', checkout, 'replace', BASE, replacement)
    assert 'tree does not match' in run(script, checkout, ok=False).stderr
    run('git', '-C', checkout, 'replace', '-d', BASE)
    clean()
    (checkout / 'build').mkdir()
    assert 'fresh checkout' in run(script, checkout, ok=False).stderr
    (checkout / 'build').rmdir()
    clean()
    changed = checkout / 'src/buster/compiler/lane.c'
    original = changed.read_bytes()
    changed.write_bytes(original + b'\n')
    assert 'not clean' in run(script, checkout, ok=False).stderr
    changed.write_bytes(original)
    clean()
    for flag, unflag in (('--assume-unchanged', '--no-assume-unchanged'), ('--skip-worktree', '--no-skip-worktree')):
        run('git', '-C', checkout, 'update-index', flag, 'src/buster/compiler/lane.c')
        changed.write_bytes(original + b'\n')
        clean()  # The index flag would otherwise conceal this edit from a normal status check.
        assert 'unsupported flags' in run(script, checkout, ok=False).stderr
        changed.write_bytes(original)
        run('git', '-C', checkout, 'update-index', unflag, 'src/buster/compiler/lane.c')
        clean()
    extra = checkout / 'diagnostic-test-untracked'
    extra.write_text('untracked')
    assert 'not clean' in run(script, checkout, ok=False).stderr
    extra.unlink()
    clean()
    ignored = checkout / 'CMakeUserPresets.json'
    ignored.write_text('{}\n')
    clean()
    assert 'ignored files are present' in run(script, checkout, ok=False).stderr
    ignored.unlink()
    clean()
    tampered = temp / 'tampered'
    shutil.copytree(artifact, tampered)
    with (tampered / 'instrumentation.patch').open('a') as f:
        f.write('tampered\n')
    assert 'digest mismatch' in run(tampered / 'apply-diagnostic.sh', checkout, ok=False).stderr
    clean()
    run(script, checkout)
    for path, expected in EXPECTED.items():
        assert hashlib.sha256((checkout / path).read_bytes()).hexdigest() == expected, path
    print('PASS wrong revision/tree, hidden-index flags, existing build, tracked, untracked and ignored files, and tampered patch refused before mutation')
    print('PASS pinned clean checkout reproduces all three tested source files')
