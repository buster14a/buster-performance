import subprocess
root='/home/user/buster-tf'
p=root+'/src/buster/compiler/x86_target_forms.c'
orig=open(p).read()
M=[
 ('rest-bf16','const __m512i unavailable_rest = _mm512_set1_epi32((int)~BUSTER_X86_TARGET_REST(available));','const __m512i unavailable_rest = _mm512_set1_epi32((int)(~BUSTER_X86_TARGET_REST(available) & ~1u));'),
 ('marked','_mm512_and_si512(required, unavailable_unmarked)','_mm512_and_si512(required, _mm512_set1_epi32((int)~x86_target_compact_features(available)))'),
 ('first-block-only','            blocks &= blocks - 1;\n        }\n    }','            blocks = 0;\n        }\n    }'),
 ('rest-collision','BUSTER_X86_TARGET_REST_BIT(value, CLFLUSH, 30))','BUSTER_X86_TARGET_REST_BIT(value, CLFLUSH, 29))'),
 ('known','const __mmask16 supported = _mm512_mask_testn_epi32_mask(_mm512_cmpneq_epi32_mask(required, zero), missing, missing);','const __mmask16 supported = _mm512_mask_testn_epi32_mask(active, missing, missing);'),
 ('block-bit','? UINT64_C(1) << (X86_FORM_##name / 16 % 64) : 0)','? UINT64_C(1) << (X86_FORM_##name / 16 % 63) : 0)'),
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
