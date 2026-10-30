# Data-only private staging glue. Never execute a staged program or archived code.
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import shutil
import stat
import subprocess
import sys
import tarfile
import traceback
from datetime import datetime, timezone

ROOT = Path(sys.argv[1])
PAYLOAD_SHA = sys.argv[2]
OLD = Path('/home/david/buster-fast-bench/codex-pr914-acceptance-20261030')
EXPECTED = {
    '/usr/bin/perf': 'a6da58ffc54b3c9bfe8d0d046ade1dbc70e8f5121932e35de916ad39162f7d4f',
    '/usr/lib/libdw.so.1': '14a4563f6fce1ce85c449ee79f0d877984ecb16c71b18103b72b2b4f57dc8786',
    '/usr/lib/libelf.so.1': '13d3e3cb54d6120d87a0569ac67be05c029f8cd2e4bf44e75936b2721c8e08af',
    '/usr/lib/libc.so.6': '02c8c3d06180beee9c7d0392aa85736c7d19f274a81e7f8f0b3d9e28e0641524',
    '/usr/lib/ld-linux-x86-64.so.2': 'f5e11cc62f8f2c24dff532982559f4303dba3b17e7450551372a88c8e7ea8757',
    '/usr/bin/taskset': '8bf4947cca932588598aa0b2413f520df438f6964057edff09a112518decc75d',
    '/usr/bin/sha256sum': 'e0a612dbb527eccb83bdb1b5aacfc23a99e40054e1f60e63ce6be779eefc2ea6',
    '/usr/bin/timeout': '629cb6e82df4bb47188eec340f2ceb5f45def2e7b1aac1bd7443beecdcb42a6a',
    '/home/david/buster-fast-bench/exclusive.sh': 'f3f4559861fa74e0790fde88fe68645b8ba8e170fb24313dc9f38b2f6feff083',
    str(OLD / 'base/compiler'): 'e0bbf2ced14fc4bb38c2073887b0fac5f8bf694789f8c9d71b726db8f292f7bf',
    str(OLD / 'head/compiler'): '67d5039a94d367f1d8f9b61ace82fb0b9b0ad699d5360bb4979367c247d85c75',
}
TOOLS = {
    'tools/profile914': '5ea2ab425351468c58b6f135098ca7d1cda1881331fa6be6d0e8e6b3c06da7a0',
    'tools/attribution914': 'e1bc2b42ee0668ff5077f46bd4e13acbf0f2428913e07da8fbb39f42c88e8038',
    'tools/reuse_exec.so': '534d7636ea4ae41142c535b5646e2b8d864e2615b53a99a9548e4b7485b4fbc2',
}
STAGING_TOOLS = ['/usr/bin/python3', '/usr/bin/zstd', '/usr/bin/bash', '/usr/bin/dd', '/usr/bin/mkdir', '/usr/bin/env']

def now():
    return datetime.now(timezone.utc).isoformat()

def digest(path):
    h = hashlib.sha256()
    with open(path, 'rb') as f:
        for block in iter(lambda: f.read(1024 * 1024), b''):
            h.update(block)
    return h.hexdigest()

def safe_name(name):
    p = PurePosixPath(name)
    assert not p.is_absolute() and '..' not in p.parts and '\\' not in name
    assert not any(ord(c) < 32 for c in name)
    return '' if str(p) == '.' else str(p)

def current_guard():
    assert os.environ.get('BUSTER_9700X_HELD') == '1'
    assert os.environ.get('EXCLUSIVE_OWNER') == 'codex-reviewer-914-input-binding'
    assert os.environ.get('EXCLUSIVE_TITLE') == '#914 private authenticated staging only'
    assert os.environ.get('EXCLUSIVE_LINK') == 'https://github.com/buster14a/buster/issues/893#issuecomment-6528493597'
    assert shutil.which('cores') is None, 'cores appeared; stop for documented grant/order review'
    assert {2, 3} <= os.sched_getaffinity(0)
    online = Path('/sys/devices/system/cpu/online').read_text().strip()
    def members(text):
        out = set()
        for part in text.split(','):
            lo, _, hi = part.partition('-')
            out.update(range(int(lo), int(hi or lo) + 1))
        return out
    assert {2, 3} <= members(online)
    assert Path('/sys/devices/system/cpu/cpu2/topology/core_id').read_text() != Path('/sys/devices/system/cpu/cpu3/topology/core_id').read_text()
    cpu = Path('/proc/cpuinfo').read_text().split('\n\n', 1)[0]
    assert re.search(r'^model name\s*:\s*AMD Ryzen 7 9700X 8-Core Processor$', cpu, re.M)
    flags = set(re.search(r'^flags\s*:\s*(.*)$', cpu, re.M)[1].split())
    assert {'avx', 'avx2', 'bmi1', 'bmi2', 'f16c', 'fma', 'movbe', 'xsave', 'abm'} <= flags
    assert Path('/lib64/ld-linux-x86-64.so.2').resolve() == Path('/usr/lib/ld-linux-x86-64.so.2')
    observed = {name: digest(name) for name in EXPECTED}
    assert observed == EXPECTED, 'target dependency/source hash changed'
    return {'at': now(), 'hashes': observed, 'staging_tool_hashes': {p: digest(p) for p in STAGING_TOOLS}, 'python_version': sys.version, 'allowed': sorted(os.sched_getaffinity(0)), 'online': online, 'kernel': os.uname().release, 'cores_on_PATH': False, 'PATH': os.environ.get('PATH')}

record = {'started_at': now(), 'root': str(ROOT), 'controller_execution': False, 'measurement': False}
meta = None
try:
    assert ROOT.parent.resolve() == Path('/home/david/buster-fast-bench')
    assert re.fullmatch(r'codex-pr914-input-binding-[A-Za-z0-9-]+', ROOT.name)
    assert ROOT.is_dir() and not ROOT.is_symlink() and ROOT.resolve() == ROOT
    assert stat.S_IMODE(ROOT.stat().st_mode) == 0o700 and ROOT.stat().st_uid == os.getuid()
    assert {p.name for p in ROOT.iterdir()} == {'stage-code.py'}
    record['before'] = current_guard()
    meta = ROOT / 'stage-meta'
    meta.mkdir(mode=0o700)
    (meta / 'before.json').write_text(json.dumps(record['before'], indent=2) + '\n')
    payload = ROOT / '.stage-payload.tar'
    with payload.open('xb') as f:
        for block in iter(lambda: sys.stdin.buffer.read(1024 * 1024), b''):
            f.write(block)
    assert digest(payload) == PAYLOAD_SHA
    record['payload_sha256'] = PAYLOAD_SHA
    with tarfile.open(payload, 'r:') as t:
        entries = t.getmembers()
        names = [safe_name(m.name) for m in entries]
        assert len(names) == len(set(names)) == 909
        assert all(m.isfile() and m.mode == 0o600 and not m.pax_headers for m in entries)
        assert all(n and not n.startswith('stage-meta/') and not n.startswith('.') and n != 'stage-code.py' for n in names)
        # Validate the entire outer archive before any extraction. Use only xb
        # regular-file copies; never materialize archive links or special nodes.
        for m, name in zip(entries, names):
            target = ROOT / name
            target.parent.mkdir(mode=0o700, parents=True, exist_ok=True)
            assert target.parent.resolve().is_relative_to(ROOT)
            source = t.extractfile(m)
            assert source is not None
            with source, target.open('xb') as out:
                shutil.copyfileobj(source, out, 1024 * 1024)
    manifest = ROOT / 'provenance/PAYLOAD-SHA256SUMS'
    covered = set()
    for line in manifest.read_text().splitlines():
        h, name = line.split('  ', 1)
        assert re.fullmatch('[0-9a-f]{64}', h) and name not in covered
        assert safe_name(name) == name and name in names and digest(ROOT / name) == h
        covered.add(name)
    assert covered == set(names) - {'provenance/PAYLOAD-SHA256SUMS'}
    original = ROOT / 'dependencies/preprocessor-391e729af658-ci.tar.zst'
    assert digest(original) == 'ceb39bf938cd7a7469bbb53646c3318d0cbfdac4d37b6d05b183c4fd0b9898c2'
    # Reauthenticate original member metadata as inert data; no original
    # archive member is executed or installed. Local derivation was checked
    # before extraction, and all new consumed bytes are checked below again.
    with (meta / 'archive-zstd.stderr').open('wb') as err:
        process = subprocess.Popen(['/usr/bin/zstd', '--decompress', '--stdout', str(original)], stdout=subprocess.PIPE, stderr=err)
        original_names = set()
        with tarfile.open(fileobj=process.stdout, mode='r|') as t:
            for m in t:
                name = safe_name(m.name)
                assert name not in original_names and (m.isfile() or m.isdir()) and not m.mode & 0o7000
                original_names.add(name)
        while process.stdout.read(1024 * 1024):
            pass
        process.stdout.close()
        assert process.wait() == 0
    assert len(original_names) == 13663
    assert digest(ROOT / 'inputs/manifests/headers-bundle.sha256') == 'e307b836448ef20e603a617a4b5023831c72ff5f307f614c50f4f8833088717c'
    assert digest(ROOT / 'inputs/manifests/sqlite.sha256') == '9179b7ad7db7366d12a214b562e478ac703e7ec0376f38f4516756bcf7ee0047'
    consumed = {}
    for sub, manifest_name, count in [('headers', 'headers-bundle', 781), ('sqlite', 'sqlite', 4)]:
        wanted = set()
        for line in (ROOT / ('inputs/manifests/' + manifest_name + '.sha256')).read_text().splitlines():
            h, relative = line.split('  ', 1)
            relative = relative.removeprefix('./')
            assert safe_name(relative) == relative and relative not in wanted
            path = ROOT / 'inputs' / sub / relative
            assert digest(path) == h
            wanted.add(relative)
            consumed[str(path.relative_to(ROOT))] = h
        actual = {str(p.relative_to(ROOT / 'inputs' / sub)) for p in (ROOT / 'inputs' / sub).rglob('*') if p.is_file()}
        assert actual == wanted and len(wanted) == count
    assert digest(ROOT / 'inputs/provenance/gnu17-pinned-predefines.txt') == 'a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33'
    assert digest(ROOT / 'inputs/sqlite/sqlite3.c') == '0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d'
    for arm in ['base', 'head']:
        source = OLD / arm / 'compiler'
        assert stat.S_ISREG(source.lstat().st_mode) and source.stat().st_nlink == 1
        target = ROOT / 'bin' / arm / 'compiler'
        target.parent.mkdir(mode=0o700, parents=True)
        with source.open('rb') as src, target.open('xb') as out:
            shutil.copyfileobj(src, out, 1024 * 1024)
        assert digest(target) == EXPECTED[str(source)]
    for name, h in TOOLS.items():
        assert digest(ROOT / name) == h
    # Hash checks precede every execute-bit restoration. All other staged
    # payloads are data; in particular the adapter stays read-only.
    executable = ['tools/profile914', 'tools/attribution914', 'bin/base/compiler', 'bin/head/compiler']
    for name in names:
        os.chmod(ROOT / name, 0o400)
    for name in executable:
        target = ROOT / name
        expected = TOOLS.get(name) or EXPECTED[str(OLD / name.split('/')[1] / 'compiler')]
        assert digest(target) == expected and target.stat().st_nlink == 1
        os.chmod(target, 0o500)
    for path in sorted((ROOT / 'inputs').rglob('*'), key=lambda p: len(p.parts), reverse=True):
        mode = path.lstat().st_mode
        assert stat.S_ISDIR(mode) or (stat.S_ISREG(mode) and path.stat().st_nlink == 1)
        os.chmod(path, 0o500 if path.is_dir() else 0o400)
    os.chmod(ROOT / 'inputs', 0o500)
    assert all(not p.lstat().st_mode & 0o222 for p in [ROOT / 'inputs', *(ROOT / 'inputs').rglob('*')])
    assert all(digest(ROOT / name) == h for name, h in consumed.items())
    assert not (ROOT / 'results').exists()
    record['after'] = current_guard()
    assert record['after']['hashes'] == record['before']['hashes']
    assert record['after']['staging_tool_hashes'] == record['before']['staging_tool_hashes']
    os.chmod(payload, 0o400)
    os.chmod(ROOT / 'stage-code.py', 0o400)
    inventory = []
    for path in sorted(ROOT.rglob('*')):
        if path.is_file() and not path.is_symlink():
            inventory.append({'path': str(path.relative_to(ROOT)), 'sha256': digest(path), 'mode': oct(stat.S_IMODE(path.stat().st_mode)), 'bytes': path.stat().st_size, 'nlink': path.stat().st_nlink})
    (meta / 'inventory.json').write_text(json.dumps(inventory, indent=2) + '\n')
    (meta / 'consumed-input-hashes.json').write_text(json.dumps(consumed, indent=2) + '\n')
    record.update({'status': 'PRIVATE_STAGE_COMPLETE_NO_PROGRAM_EXECUTION', 'finished_at': now(), 'payload_files': len(names), 'manifest_verified': len(covered), 'consumed_header_files': 781, 'consumed_sqlite_files': 4, 'all_consumed_rehashed_after_readonly_modes': True, 'executables_hash_verified_before_mode_restore': executable, 'results_directory_initially_absent': True, 'inventory_count': len(inventory), 'inventory_excludes_later_receipts': ['stage-meta/inventory.json', 'stage-meta/consumed-input-hashes.json', 'stage-meta/stage-result.json', 'stage-meta/FINAL-SHA256SUMS']})
    (meta / 'stage-result.json').write_text(json.dumps(record, indent=2) + '\n')
    final = meta / 'FINAL-SHA256SUMS'
    final.write_text(''.join(digest(p) + '  ' + str(p.relative_to(ROOT)) + '\n' for p in sorted(ROOT.rglob('*')) if p.is_file() and p != final))
    print(json.dumps({**record, 'final_manifest_sha256': digest(final)}))
except BaseException:
    record.update({'status': 'FAILED_PARTIAL_RETAINED_NO_RETRY', 'finished_at': now(), 'error': traceback.format_exc()})
    if meta is not None:
        (meta / 'stage-result.json').write_text(json.dumps(record, indent=2) + '\n')
    print(json.dumps(record), file=sys.stderr)
    raise
