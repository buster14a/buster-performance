#!/usr/bin/env python3
"""Compare each source-local checked declaration with ordinary source compilation."""
import argparse,csv,hashlib,json,lzma,os,subprocess
from pathlib import Path

args = argparse.ArgumentParser(description=__doc__)
args.add_argument('--compiler', type=Path, required=True)
args.add_argument('--lua-source', type=Path, required=True, help='Lua 5.4.8 src directory')
args.add_argument('--musl-source', type=Path, required=True, help='musl source directory, containing arch/ and src/')
args.add_argument('--musl-generated', type=Path, required=True, help='musl build obj directory, containing src/internal and include')
args.add_argument('--output', type=Path, required=True)
params = args.parse_args()
binary = params.compiler.resolve()
for group in ('lua', 'musl'):
    opts = []
    if group == 'lua':
        root = params.lua_source.resolve()
        files = sorted(root.glob('*.c'))
    else:
        root = params.musl_source.resolve()
        gen = params.musl_generated.resolve()
        opts = ['-std=c99', '-nostdinc', '-ffreestanding', '-D_XOPEN_SOURCE=700']
        for include in (root/'arch/x86_64',root/'arch/generic',gen/'src/internal',root/'src/include',root/'src/internal',gen/'include',root/'include'):
            opts.extend(('-I', str(include)))
        files = []
        seen = set()
        for path in sorted(root.glob('src/*/*.c')) + sorted(root.glob('src/*/x86_64/*.c')):
            if path.name not in seen:
                files.append(path)
                seen.add(path.name)
    if len(files) != {'lua':34,'musl':1336}[group]:
        raise SystemExit(f'{group} input count changed to {len(files)}')
    out = params.output/group
    out.mkdir(parents=True,exist_ok=True)

    def once(mode,path,obj):
     env={**os.environ,'BUSTER_CHECK_SOURCE_DECLARATIONS':'1'}
     if mode=='source':env.update(BUSTER_CHECK_BODY_ADMIT_ALL='1',BUSTER_CHECK_BODY_SOURCE_ONLY='1')
     else:env['BUSTER_CHECK_BODY_WHOLE_FINGERPRINT']='1'
     r=subprocess.run([binary,'--lanes','1','-c',*opts,path,'-o',obj],env=env,capture_output=True,timeout=120)
     rows={};summary=[];other=[]
     for line in r.stderr.decode(errors='replace').splitlines():
      if line.startswith('body-'+mode+'-row\t'):
       _,t,n,h=line.split('\t');assert int(t) not in rows;rows[int(t)]=(int(n),h)
      elif line.startswith(('body-source-summary\t','body-source-pages\t','body-source-decline\t')):summary.append(line)
      else:other.append(line)
     return r.returncode,rows,summary,other

    with (out/'files.tsv').open('w',buffering=1) as f, lzma.open(out/'rows.tsv.xz','wt') as rf:
     w=csv.writer(f,delimiter='\t');w.writerow(('path','source_status','ordinary_status','source_roots','ordinary_roots','exact_roots','source_nodes','ordinary_nodes','extra','missing','changed','object_sha256','other_diagnostics_equal'))
     rw=csv.writer(rf,delimiter='\t');rw.writerow(('source','close','source_nodes','source_digest','ordinary_nodes','ordinary_digest'))
     for i,path in enumerate(files):
      obj=out/'file.o';obj.unlink(missing_ok=True)
      a,s,summary,di=once('source',path,obj);b,g,_,dj=once('whole',path,obj)
      equal={t for t in s if s[t]==g.get(t)};extra=s.keys()-g.keys();missing=g.keys()-s.keys();changed=s.keys()&g.keys()-equal
      w.writerow((Path(path).relative_to(root),a,b,len(s),len(g),len(equal),sum(n for n,h in s.values()),sum(n for n,h in g.values()),len(extra),len(missing),len(changed),hashlib.sha256(obj.read_bytes()).hexdigest() if obj.exists() else '',int(di==dj)))
      for t in sorted(s.keys()|g.keys()):rw.writerow((Path(path).relative_to(root),t,*s.get(t,('','')),*g.get(t,('',''))))
      if a!=b or extra or missing or changed or di!=dj:
       (out/f'{i}.json').write_text(json.dumps({'path':str(Path(path).relative_to(root)),'summaries':summary,'source_diag':di,'ordinary_diag':dj,'extra':sorted(extra),'missing':sorted(missing),'changed':sorted(changed)},indent=2))
