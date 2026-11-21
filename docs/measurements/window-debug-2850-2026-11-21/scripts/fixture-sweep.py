import argparse, collections, concurrent.futures, hashlib, json, os, pathlib, subprocess, tempfile, time
parser=argparse.ArgumentParser()
parser.add_argument('tree', type=pathlib.Path);parser.add_argument('log', type=pathlib.Path);parser.add_argument('group', choices=['files','inline','targeted'])
args=parser.parse_args()
tree=args.tree.resolve(); log=args.log.resolve();log.mkdir(exist_ok=True,parents=True)
cc=tree/'build/compiler'
if args.group=='files':
    paths=[tree/p for p in subprocess.check_output(['git','-C',str(tree),'ls-files','tests/*.c'],text=True).splitlines()]
elif args.group=='inline':
    paths=sorted((tree.parent/'gates/inline').glob('*.c'))
else:
    candidates=sorted((tree.parent/'gates/inline').glob('*.c'))
    paths=[p for p in candidates if __import__('re').search(rb'\breturn\s*(?:-\s*)?(?:0[xX][\da-fA-F]+|\d+)\s*(?:;|[+*-]\s*\d+\s*;)',p.read_bytes())]
print(f'{len(paths)} source files; {cc}',flush=True)
def compare(job):
    idx,path,mode,policy=job
    with tempfile.TemporaryDirectory(prefix='unit-',dir=log) as folder:
        obj=pathlib.Path(folder)/'unit.o'
        flags=['-g']+({'default':[], 'wall':['-Wall','-Wextra'], 'everything':['-Weverything']}[policy])
        cmd=[str(cc),mode,'--lanes','1','-fdiagnostics-color=never',*flags,str(path)]
        if mode=='-c': cmd+=['-o',str(obj)]
        def get(opt):
            if obj.exists():obj.unlink()
            try:r=subprocess.run([*cmd,*opt],capture_output=True,cwd=tree,timeout=90)
            except subprocess.TimeoutExpired:return ('timeout',b'',b'',None)
            return r.returncode,r.stdout,r.stderr,hashlib.sha256(obj.read_bytes()).hexdigest() if obj.exists() else None
        a=get([]);b=get(['--node-window'])
        bad=a!=b
        if bad:
            target=log/f'failure-{idx}';target.mkdir(exist_ok=True)
            (target/'source').write_text(str(path)+'\n')
            for which,s in [('ordinary',a),('window',b)]:
                (target/(which+'.out')).write_bytes(s[1]);(target/(which+'.err')).write_bytes(s[2]);(target/(which+'.status')).write_text(str([s[0],s[3]]))
        return idx,path,mode,policy,a[0],b[0],bad,a[3] is not None
modes=['-c'];policies=['default','wall','everything']
jobs=[(len(modes)*len(policies)*i+2*j+k,p,m,w) for i,p in enumerate(paths) for j,m in enumerate(modes) for k,w in enumerate(policies)]
s=collections.Counter()
with (log/'results.tsv').open('w',buffering=1) as out, concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
    for idx,path,mode,policy,a,b,bad,obj in pool.map(compare,jobs):
        print(idx,path,mode,policy,a,b,int(bad),int(obj),sep='\t',file=out);s['pairs']+=1;s['differences']+=bad;s['objects']+=obj;s[f'ordinary_rc_{a}']+=1
        if bad:print('diff',idx,path,mode,policy,flush=True)
        if s['pairs']%1000==0:print(dict(s),flush=True)
(log/'summary.json').write_text(json.dumps(s,indent=2)+'\n');print(dict(s),flush=True)
