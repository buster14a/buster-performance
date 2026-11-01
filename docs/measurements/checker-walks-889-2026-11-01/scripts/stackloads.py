#!/usr/bin/env python3
import subprocess, sys, re, bisect

def disasm(binary, funcs):
    insns = {}
    syms = []
    commands = []
    if funcs == ['ALL']:
        commands.append(['objdump','-d','--no-show-raw-insn',binary])
    else:
        for f in funcs:
            commands.append(['objdump','-d','--no-show-raw-insn','--disassemble='+f,binary])
    for cmd in commands:
        r = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if r.returncode != 0:
            raise SystemExit(r.stderr)
        out = r.stdout.decode('utf-8', 'replace')
        cur = None
        for line in out.splitlines():
            m = re.match(r'^([0-9a-f]+) <([^>]+)>:', line)
            if m:
                cur = m.group(2)
                syms.append((int(m.group(1),16), cur))
                continue
            m = re.match(r'^\s*([0-9a-f]+):\s+(.*)$', line)
            if m and cur:
                insns[int(m.group(1),16)] = (cur, m.group(2).strip())
    syms.sort()
    return insns, syms

def split_ops(s):
    parts=[]; depth=0; start=0
    for i,c in enumerate(s):
        if c=='(': depth+=1
        elif c==')': depth-=1
        elif c==',' and depth==0:
            parts.append(s[start:i].strip()); start=i+1
    parts.append(s[start:].strip())
    return parts

def is_stack_addr(a):
    return 0x7ff000000000 <= a < 0x800000000000

def load_kind(text):
    # AT&T: mnemonic src[, dst]; a load's source is memory.
    m = re.match(r'^([a-z0-9]+)\s+(.*)$', text)
    if not m: return None
    mn, rest = m.group(1), m.group(2)
    if not (mn.startswith('mov')):
        return None
    ops = split_ops(rest)
    if len(ops) < 2: return None
    src, dst = ops[0], ops[-1]
    mm = re.search(r'\(([^)]*)\)', src)
    if not mm: return None
    base = mm.group(1).split(',')[0].strip()
    if base in ('%rsp','%rbp','%esp','%ebp','%rip') or not base.startswith('%'):
        return None
    # destination size
    if re.fullmatch(r'%(r(ax|bx|cx|dx|si|di|bp|sp)|r\d+)', dst):
        width = 64
    elif re.fullmatch(r'%(e(ax|bx|cx|dx|si|di|bp|sp)|r\d+d)', dst):
        width = 32
    elif re.fullmatch(r'%(a|b|c|d|si|di|bp|sp)l?', dst) or re.fullmatch(r'%r\d+b', dst):
        width = 8
    elif re.fullmatch(r'%[a-z0-9]+', dst):
        width = 0
    else:
        width = 0
    return width

def main():
    perf, binary, symfs = sys.argv[1], sys.argv[2], sys.argv[3]
    funcs = sys.argv[4:]
    insns, syms = disasm(binary, funcs)
    sym_starts=[s for s,_ in syms]
    def symof(ip):
        i=bisect.bisect_right(sym_starts, ip)-1
        if i<0: return None
        start,name=syms[i]
        return name if ip-start < 0x100000 else None
    cmd=['perf','script','-i',perf,'-F','comm,addr,ip','--symfs',symfs]
    p=subprocess.run(cmd,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    total=0; stack=0; loads64=0; loads_any=0; per_func={}; per_func_total={}; mapped=0; movs=0
    load_ips={}
    for line in p.stdout.decode('utf-8', 'replace').splitlines():
        f=line.split()
        if len(f)<3 or f[0]!='compiler': continue
        try: addr=int(f[1],16); ip=int(f[2],16)
        except ValueError: continue
        total+=1
        if is_stack_addr(addr): stack+=1
        rec=insns.get(ip)
        if not rec: continue
        func,text=rec
        per_func_total[func]=per_func_total.get(func,0)+1
        if not is_stack_addr(addr): continue
        mapped+=1
        kind=load_kind(text)
        if kind is not None: movs+=1
        if kind is None: continue
        loads_any+=1
        if kind==64:
            loads64+=1
            d=per_func.setdefault(func,[0,0])
            d[0]+=1
            load_ips[ip]=load_ips.get(ip,0)+1
    print(f'total compiler samples {total}')
    print(f'stack-address samples {stack} ({100.0*stack/total:.2f}%), mapped {mapped}, movs {movs}')
    print(f'stack load samples (any width, base not rsp/rbp) {loads_any} ({100.0*loads_any/total:.2f}%)')
    print(f'stack 64-bit load samples {loads64} ({100.0*loads64/total:.2f}%)')
    for func,(n,_) in sorted(per_func.items(), key=lambda kv:-kv[1][0]):
        ft=per_func_total.get(func,0)
        print(f'  {func}: {n}/{ft} ({100.0*n/ft:.2f}% of its sampled ops)')
    for ip,n in sorted(load_ips.items(), key=lambda kv:-kv[1])[:15]:
        print(f'  {n:5d} {ip:x} {insns[ip][0]} {insns[ip][1]}')

main()
