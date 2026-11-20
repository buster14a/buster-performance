#!/usr/bin/env python3
"""CMake compiler launcher. Checksum tools use the upstream reference compiler."""
from pathlib import Path
import json,os,subprocess,sys,time
variant=sys.argv[1];cc=sys.argv[2];args=sys.argv[3:]
w=Path(__file__).resolve().parents[2];cwd=Path.cwd();i=args.index('-o');out=Path(args[i+1])
project=out.parts[1].removesuffix('.dir') if len(out.parts)>1 else ''
use=variant!='clang' and project not in ('md5sum','md5cmp','strtest')
compiler=w/('eighteen-'+variant)/'build/compiler' if use else cc
start=time.monotonic_ns()
r=subprocess.run([compiler,*(['--tier1','--lanes','1','-w'] if use else []),*args],capture_output=True)
sys.stdout.buffer.write(r.stdout);sys.stderr.buffer.write(r.stderr)
d=cwd/'compile-ledger';d.mkdir(exist_ok=True)
src=next(x for x in args if x.endswith('.c'));file=d/('--'.join(out.parts)+'.json')
file.write_text(json.dumps(dict(project=project,source=src,output=str(out),compiler='buster' if use else 'clang',exit=r.returncode,elapsed_ms=(time.monotonic_ns()-start)/1e6,flags=args,diagnostic=(r.stdout+r.stderr).decode(errors='replace')[-2500:]))+'\n')
raise SystemExit(r.returncode)
