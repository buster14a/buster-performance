import sys
def load(f):
    d={}; total=0
    for line in open(f):
        p=line.rstrip('\n').split('\t')
        if line.endswith('events\n'): total=int(line.split()[0]); continue
        if len(p)==2: d[p[1]]=float(p[0])
    return d,total
groups=[
 ('page faults',['asm_exc_page_fault']),
 ('the exit (teardown, the helper)',['do_exit']),
 ('execve',['__x64_sys_execve']),
 ('mprotect',['__x64_sys_mprotect']),
 ('mmap',['ksys_mmap_pgoff']),
 ('munmap',['__x64_sys_munmap']),
 ('madvise',['__x64_sys_madvise']),
 ('openat',['__x64_sys_openat']),
 ('newfstatat, fstat, access, readlinkat',['__x64_sys_newfstatat','__x64_sys_newfstat','__x64_sys_access','__x64_sys_readlinkat','__x64_sys_statx']),
 ('read, pread64',['__x64_sys_read','__x64_sys_pread64']),
 ('close',['__x64_sys_close','__x64_sys_close_range']),
 ('getdents64',['__x64_sys_getdents64']),
 ('pwrite64, ftruncate, write',['__x64_sys_pwrite64','__x64_sys_ftruncate','__x64_sys_write']),
 ('clone3, fork, wait',['__x64_sys_clone','__x64_sys_clone3','__x64_sys_wait4','ret_from_fork_asm','__x64_sys_vfork']),
 ('timer and other interrupts',['asm_sysvec_apic_timer_interrupt','asm_common_interrupt','asm_sysvec_reschedule_ipi','asm_sysvec_call_function_single','asm_sysvec_irq_work']),
]
def table(kind,tokens,trees,base=None):
    data={t:load(f'rows-{t}-{kind}.tsv') for t in trees}
    h=load(f'rows-{base}-{kind}.tsv') if base else ({},0)
    print(f'== {kind}: kernel cycles a token'+(' less the harness' if base else ''))
    print(f'{"row":40s}'+''.join(f'{t:>10s}' for t in trees))
    named={t:0 for t in trees}
    for name,syms in groups:
        vals=[]
        for t in trees:
            v=(sum(data[t][0].get(s,0) for s in syms)-sum(h[0].get(s,0) for s in syms))/tokens
            vals.append(v); named[t]+=v
        print(f'{name:40s}'+''.join(f'{v:10.2f}' for v in vals))
    print(f'{"all named":40s}'+''.join(f'{named[t]:10.2f}' for t in trees))
    print(f'{"all kernel cycles on the CPU":40s}'+''.join(f'{(data[t][1]-h[1])/tokens:10.2f}' for t in trees))
table('sqlite',716136*20,['main','head','full'])
table('musl',5039639,['main','head','full'],base='true')
d,t=load('rows-true-musl.tsv'); print('harness alone: %.1f cycles a token (%.2f M a unit)'%(t/5039639,t/1336/1e6))
