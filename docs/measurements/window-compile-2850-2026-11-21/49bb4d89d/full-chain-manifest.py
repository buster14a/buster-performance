from pathlib import Path
import hashlib,sys
out=Path(sys.argv[1])
files=sorted(Path.cwd().glob('*.o'))
if len(files)!=int(sys.argv[2]):raise SystemExit(f'expected {sys.argv[2]} objects, emitted {len(files)}')
with out.open('w') as w:
 for p in files:w.write(f'{p.name}\t{p.stat().st_size}\t{hashlib.sha256(p.read_bytes()).hexdigest()}\n')
