import subprocess
root='/home/user/buster-tf'
p=root+'/src/buster/compiler/x86_target_forms.c'
orig=open(p).read()
M=[
 ('marked-2','_mm512_and_si512(required, unavailable_unmarked)','_mm512_and_si512(required, _mm512_or_si512(unavailable_unmarked, _mm512_set1_epi32((int)BUSTER_X86_TARGET_COMPACT_EXTENDED)))'),
]
for name,a,b in M:
    assert orig.count(a)==1, name
    open(p,'w').write(orig.replace(a,b))
    r=subprocess.run('./build.sh --config Release > /tmp/claude-0/tf-mut-build.log 2>&1',shell=True,cwd=root)
    if r.returncode!=0:
        v='NOT-BUILT'
    else:
        o=subprocess.run('timeout 600 ./build/compiler test-x86-target 2>&1',shell=True,cwd=root,capture_output=True,text=True)
        bad=[l for l in o.stdout.splitlines() if 'fail' in l.lower() and 'pass' not in l.lower()]
        v=('KILLED exit %d: ' % o.returncode + ' | '.join(bad)[:200]) if o.returncode!=0 or bad else 'SURVIVED'
    open(p,'w').write(orig)
    print(name, v, flush=True)
subprocess.run('./build.sh --config Release > /dev/null 2>&1',shell=True,cwd=root)
print('restored', subprocess.run('git diff --quiet src && echo clean || echo DIRTY',shell=True,cwd=root,capture_output=True,text=True).stdout.strip(), flush=True)
