"""Run the archived generator with explicit abnormal-exit handling; share concurrent requests for the same seed."""
import contextlib
import hashlib
import io
import json
from pathlib import Path
import sys
import os
import fcntl
original=Path(sys.argv.pop(1))
source=original.read_text()
needle="    if 'window rows expressions=' not in output:\n"
assert source.count(needle)==1
source=source.replace(needle,'''    if r.returncode not in (0, 1) or ('window rows expressions=' not in output and r.returncode != 1):
        bad = os.path.join(out, 'abnormal-%d-%d.c' % (seed, i))
        open(bad, 'w').write(text)
        raise RuntimeError('%s: abnormal status %d: %s' % (bad, r.returncode, output[-500:]))
'''+needle)
# A completed seed may be consumed by the table-driven campaign as well as its initiating process.
destination=Path(sys.argv[4]);destination.mkdir(parents=True,exist_ok=True)
key=[hashlib.file_digest(open(sys.argv[1],'rb'),'sha256').hexdigest(),hashlib.sha256(source.encode()).hexdigest(),sys.argv[2:4]+sys.argv[5:],{k:v for k,v in os.environ.items() if k.startswith('FUZZ_')}]
with (destination/'run.lock').open('w') as lock:
    fcntl.flock(lock,fcntl.LOCK_EX)
    finished=destination/'verified-result.json'
    saved=json.loads(finished.read_text()) if finished.exists() else None
    if saved and saved['key']==key:
        print(saved['output'],end='')
    else:
        buffer=io.StringIO()
        with contextlib.redirect_stdout(buffer):
            exec(compile(source,str(original),'exec'), {'__name__':'__main__','__file__':str(original)})
        output=buffer.getvalue()
        temporary=destination/'verified-result.tmp'
        temporary.write_text(json.dumps({'key':key,'output':output})+'\n')
        temporary.replace(finished)
        print(output,end='')
