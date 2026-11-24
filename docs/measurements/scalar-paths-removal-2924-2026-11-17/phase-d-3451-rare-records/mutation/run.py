import subprocess, json
root='/home/user/buster-main'
p=root+'/src/buster/compiler/x86_semantics.c'
orig=open(p).read()
M=json.load(open('/tmp/claude-0/mut-rare/m2.json'))
for name,a,b in M:
    assert orig.count(a)==1, name
    open(p,'w').write(orig.replace(a,b))
    r=subprocess.run('./build.sh --config Release > /tmp/claude-0/mut-rare/build.log 2>&1',shell=True,cwd=root)
    if r.returncode!=0:
        verdict='NOT-BUILT'
    else:
        out=subprocess.run('./build/compiler test-x86-semantics 2>&1',shell=True,cwd=root,capture_output=True,text=True).stdout
        bad=[l for l in out.splitlines() if ('failures' in l and ' 0 failures' not in l) or 'frozen' in l]
        verdict=('KILLED: '+' | '.join(bad)[:260]) if bad or 'x86 semantics: ok' not in out else 'SURVIVED'
    open(p,'w').write(orig)
    print(name, verdict, flush=True)
subprocess.run('./build.sh --config Release > /dev/null 2>&1',shell=True,cwd=root)
print('restored', subprocess.run('git diff --quiet src && echo clean || echo DIRTY',shell=True,cwd=root,capture_output=True,text=True).stdout.strip(), flush=True)
