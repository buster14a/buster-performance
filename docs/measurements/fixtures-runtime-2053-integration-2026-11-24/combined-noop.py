from pathlib import Path
import hashlib
import os
import subprocess
build = Path('build/cmake/vector-g0')
def snapshot():
    artifacts = [Path('build/compiler'), *[next(build.rglob('Release/src/buster/compiler/main_unit_'+part+'.c.o')) for part in ('frontend','checker')]]
    return [(str(p),p.stat().st_size,hashlib.sha256(p.read_bytes()).hexdigest()) for p in artifacts]
def no_work():
    output = subprocess.check_output(['ninja','-C',str(build),'-f','build-Release.ninja','-n','compiler'],text=True)
    print(output.strip())
    assert 'no work to do.' in output
artifacts = snapshot()
print('artifact, bytes, SHA-256', *artifacts,sep='\n')
no_work()
for name in ('tests/ir/catalog.tsv','tests/driver/warnings/default-warning/catalog.tsv','tests/checker/function-name-objects/0001.c.expected','tests/preprocessor/structure/header-diagnostic-percent.expected','tests/driver/programs/section-bounds-align/program.c'):
    path = Path(name)
    original = path.stat()
    try:
        path.touch()
        print('touched',path)
        no_work()
        assert snapshot()==artifacts
    finally:
        os.utime(path,ns=(original.st_atime_ns,original.st_mtime_ns))
no_work()
assert snapshot()==artifacts
print('all three digests identical after every data probe and restoration')
