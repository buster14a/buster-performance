#!/usr/bin/env python3
"""Compare a reference and a research compiler on the frozen physical SQLite source."""
import argparse
import hashlib
import os
from pathlib import Path
import subprocess
import tempfile

p = argparse.ArgumentParser(description=__doc__)
p.add_argument('reference', type=Path)
p.add_argument('candidate', type=Path)
p.add_argument('sqlite', type=Path, help='directory containing SQLite 3.53.2 sqlite3.c and headers')
p.add_argument('mode', choices=['ordinary', 'direct-calls', 'sealed-calls', 'continue-types'])
p.add_argument('--audit-file', type=Path)
a = p.parse_args()
source = a.sqlite.resolve() / 'sqlite3.c'
def digest(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()
if digest(source) != '0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d':
    p.error('SQLite input differs from the frozen source')
flags = ['--lanes', '1', '-c', '-DSQLITE_OMIT_LOAD_EXTENSION', '-DSQLITE_THREADSAFE=0', '-DSQLITE_ENABLE_MEMSYS5', '-DSQLITE_ENABLE_RTREE', '-I'+str(source.parent), str(source)]
base = {k:v for k,v in os.environ.items() if not k.startswith('BUSTER_')}
env = {}
if a.mode != 'ordinary':
    env.update(BUSTER_PARSE_LIVE_FOREST='1', BUSTER_LIVE_CHECKED_INPUT='1')
if a.mode == 'direct-calls':
    env.update(BUSTER_LIVE_NATIVE_PROGRAMS='1', BUSTER_LIVE_OWN_PROGRAMS='1')
elif a.mode in ('sealed-calls','continue-types'):
    env.update(BUSTER_PRE_EOF_NATIVE_WINDOW='24', BUSTER_LIVE_ORDINARY_HANDOFF='1')
    env.update({'BUSTER_PRE_EOF_SEAL_BODIES' if a.mode=='sealed-calls' else 'BUSTER_PRE_EOF_CONTINUE_TYPES':'1'})
    if a.mode == 'continue-types':
        env['BUSTER_LIVE_RESOLVE_WINDOWS']='1'
with tempfile.TemporaryDirectory() as tmp:
    d = Path(tmp)
    def run(label, exe, extra):
        obj = d/(label+'.o')
        r = subprocess.run([exe.resolve(), *flags, '-o', obj], env=base|extra, capture_output=True)
        if r.returncode or not obj.exists():
            raise SystemExit(f'{label} exited {r.returncode}: {r.stderr.decode(errors="replace")}')
        return digest(obj),r.stdout,r.stderr
    ref = run('reference',a.reference,{})
    candidate = run('candidate',a.candidate,env)
    if ref != candidate:
        raise SystemExit('ordinary and candidate object or diagnostic streams differ')
    print('SHA-256',candidate[0],'SQLite bytes',source.stat().st_size,'stdout bytes',len(ref[1]),'stderr bytes',len(ref[2]))
    if a.audit_file:
        audit = run('audit',a.candidate,env|{'BUSTER_PARSE_LIVE_AUDIT':'1','BUSTER_CONTROL_SOURCE_AUDIT':'1','BUSTER_CONTROL_EARLY_AUDIT':'1'})
        if audit[:2] != ref[:2]:
            raise SystemExit('audit changed the object or standard output')
        a.audit_file.write_bytes(audit[2])
