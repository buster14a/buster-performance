import collections,concurrent.futures,hashlib,json,pathlib,subprocess,sys
if len(sys.argv) != 5:
    sys.exit("usage: sweep.py BUSTER_CHECKOUT COMPILER EXTRACTED_PROGRAMS SCRATCH")
root=pathlib.Path(sys.argv[1]).resolve()
compiler=str(pathlib.Path(sys.argv[2]).resolve())
extracted=pathlib.Path(sys.argv[3]).resolve()
work=pathlib.Path(sys.argv[4]).resolve()
work.mkdir(parents=True,exist_ok=True)
policies={'default':[], 'wall':['-Wall','-Wextra'],'everything':['-Weverything','-Wno-c++-compat']}
inline=[str(p) for p in sorted(extracted.glob('*.c'))]
fixtures=[str(root/p) for p in subprocess.check_output(['git','-C',str(root),'ls-files','tests/*.c'],text=True).splitlines()]
def one(args):
    f,mode=args
    results=[]
    for opt in ([],['--node-window-conditions']):
        r=subprocess.run([compiler,*opt,'-fsyntax-only',*policies[mode],f],capture_output=True,timeout=60)
        results.append((r.returncode,r.stdout,r.stderr))
    a,b=results
    if (a!=b or a[0] not in (0,1)):
        digest=hashlib.sha256(f.encode()).hexdigest()[:16]+'-'+mode
        for name,res in zip(('off','on'),results):
            (work/(digest+'-'+name)).write_bytes(res[1]+res[2])
    return ((mode,a[0],b[0],a==b),f)
counts=collections.Counter()
with concurrent.futures.ThreadPoolExecutor(2) as pool, (work/'differences.tsv').open('w') as log:
    for k,f in pool.map(one,((f,m) for m in policies for f in [*fixtures,*inline])):
        counts[k]+=1
        if not k[-1] or k[1] not in (0,1):print(*k,f,sep='\t',file=log,flush=True)
print('files',len(fixtures),'inline',len(inline),'counts',sorted(counts.items()),flush=True)
