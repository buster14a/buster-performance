from pathlib import Path
import struct, sys, subprocess, hashlib, csv, re
d=Path(__file__).resolve().parent
binary=(d/'../main-fbef-clean/build/compiler').resolve()
def funcs(path):
    data=path.read_bytes()
    head=struct.unpack_from('<16sHHIQQQIHHHHHH',data)
    assert head[0][:6] == b'\x7fELF\x02\x01' and head[1:3]==(1,62)
    at=head[6]; secs=[struct.unpack_from('<IIQQQQIIQQ',data,at+i*head[11]) for i in range(head[12])]
    def body(s): return data[s[4]:s[4]+s[5]]
    def string(buf,i): return buf[i:buf.index(0,i)].decode('utf8','surrogateescape')
    sstr=body(secs[head[13]])
    names=[string(sstr,s[0]) for s in secs]; sy=next(i for i,s in enumerate(secs) if s[1]==2);st=secs[sy];strings=body(secs[st[6]])
    sym=[struct.unpack_from('<IBBHQQ',data,st[4]+n) for n in range(0,st[5],st[9])]
    relocs={}
    for j,x in enumerate(secs):
        if x[1]!=4:continue
        assert x[6]==sy
        out=relocs.setdefault(x[7],[])
        for n in range(0,x[5],x[9]):
            offset,info,addend=struct.unpack_from('<QQq',data,x[4]+n)
            target=sym[info>>32]
            name=string(strings,target[0]) or (names[target[3]] if target[3]<len(names) else '')
            out.append((offset,info & 0xffffffff,name,addend))
    from bisect import bisect_left
    for out in relocs.values():out.sort()
    from collections import Counter
    multiplicity=Counter(string(strings,name) for name,kind,_,sec,_,size in sym if kind&15==2 and size and 0<sec<len(secs))
    result={}
    for name,kind,_,sec,offset,size in sym:
        if kind&15!=2 or not size or sec==0 or sec>=len(secs):continue
        key=string(strings,name)
        if multiplicity[key]!=1:continue
        seg=secs[sec]
        payload=data[seg[4]+offset:seg[4]+offset+size]
        rs=relocs.get(sec,[]);lo=bisect_left(rs,(offset,));hi=bisect_left(rs,(offset+size,))
        result[key]=(payload,tuple((a-offset,*rest) for a,*rest in rs[lo:hi]))
    return result
def sha(b):return hashlib.sha256(b).hexdigest()
for unit in ['sqlite','main']:
    inputs=sorted(d.glob(unit+'.*.i'),key=lambda s:int(s.name.split('.')[1]))
    if not inputs:continue
    with (d/(unit+'-prefixes.tsv')).open('w') as f:
        t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow('input parser_tokens exit bytes functions common exact_code exact_code_and_reloc_keys early_code_bytes common_code_bytes exact_code_bytes full_same_code_bytes'.split())
        full=None
        for path in reversed(inputs):
            obj=path.with_suffix('.o');obj.unlink(missing_ok=True)
            options=['-march=native','-fwrapv','-funsigned-char'] if unit=='main' else []
            # An expanded source enters the compiler through its real .i support, including its frozen target options.
            r=subprocess.run([binary,'--lanes','1','-c',*options,str(path),'-o',obj],capture_output=True)
            path.with_suffix('.stderr').write_bytes(r.stderr);path.with_suffix('.stdout').write_bytes(r.stdout)
            available=funcs(obj) if r.returncode==0 and obj.exists() else {}
            if full is None:full=available
            common=available.keys()&full.keys()
            equal={k for k in common if available[k][0]==full[k][0]}
            strictly={k for k in equal if available[k][1]==full[k][1]}
            with path.with_suffix('.symbols.tsv').open('w') as out:
                sw=csv.writer(out,delimiter='\t',lineterminator='\n');sw.writerow(['name','bytes','relocs','reference','code','relocation_keys','code_sha256'])
                for k in sorted(available):sw.writerow([k,len(available[k][0]),len(available[k][1]),int(k in common),int(k in equal),int(k in strictly),sha(available[k][0])])
            t.writerow([path.name,int(path.name.split('.')[1]),r.returncode,path.stat().st_size,len(available),len(common),len(equal),len(strictly),sum(len(v[0]) for v in available.values()),sum(len(available[k][0]) for k in common),sum(len(available[k][0]) for k in equal),sum(len(available[k][0]) for k in strictly)]);f.flush()
    original=(d/'../source-typed-study'/(unit+'.o')).resolve()
    reference=funcs(original)
    with (d/(unit+'-source-comparison.tsv')).open('w') as out:
        t=csv.writer(out,delimiter='\t',lineterminator='\n');t.writerow(['checkpoint','input','native_reference_funcs','prefix_funcs','common','equal_code','equal_code_and_reloc_keys','equal_key_bytes','primary_elf_sha256'])
        for path in inputs:
            obj=path.with_suffix('.o')
            if not obj.exists():continue
            observed=funcs(obj);common=observed.keys()&reference.keys()
            same={k for k in common if observed[k][0]==reference[k][0]}
            strict={k for k in same if observed[k][1]==reference[k][1]}
            t.writerow([int(path.name.split('.')[1]),path.name,len(reference),len(observed),len(common),len(same),len(strict),sum(len(observed[k][0]) for k in strict),sha(original.read_bytes())])
