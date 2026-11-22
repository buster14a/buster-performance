from pathlib import Path
import struct,bisect,hashlib,csv,collections
d=Path(__file__).resolve().parent
class Object:
    def __init__(self,path):
        self.path=path
        self.data=data=path.read_bytes();h=struct.unpack_from('<16sHHIQQQIHHHHHH',data)
        assert h[0][:6]==b'\x7fELF\x02\x01' and h[1:3]==(1,62)
        self.sec=secs=[struct.unpack_from('<IIQQQQIIQQ',data,h[6]+i*h[11]) for i in range(h[12])]
        def string(b,i):return b[i:b.index(0,i)].decode('utf8','surrogateescape')
        def chunk(s):return data[s[4]:s[4]+s[5]]
        secstr=chunk(secs[h[13]]);self.secname=[string(secstr,s[0]) for s in secs]
        sy=next(i for i,s in enumerate(secs) if s[1]==2);st=secs[sy];ststr=chunk(secs[st[6]])
        self.sym=[]
        for i in range(0,st[5],st[9]):
            name,kind,vis,sec,off,size=struct.unpack_from('<IBBHQQ',data,st[4]+i)
            self.sym.append((string(ststr,name),kind&15,kind>>4,sec,off,size))
        self.funcs={};self.ranges=collections.defaultdict(list)
        self.names=collections.Counter(n for n,k,b,s,o,z in self.sym if n and k in (0,1,2,6))
        self.dups=0;self.dupbytes=0
        for n,k,b,s,o,z in self.sym:
            if not z or not 0<s<len(secs) or k not in (1,2,6):continue
            if self.names[n]!=1:
                if k==2:self.dups+=1;self.dupbytes+=z
                continue
            self.ranges[s].append((o,o+z,n))
            if k==2:self.funcs[n]=(s,o,z,data[secs[s][4]+o:secs[s][4]+o+z])
        self.starts={}
        for s,ls in self.ranges.items():
            ls.sort();self.starts[s]=[q[0] for q in ls]
        self.rels=collections.defaultdict(list)
        for s in secs:
            if s[1]!=4:continue
            assert s[6]==sy
            for i in range(0,s[5],s[9]):
                off,info,add=struct.unpack_from('<QQq',data,s[4]+i)
                self.rels[s[7]].append((off,info&0xffffffff,info>>32,add))
        for ls in self.rels.values():ls.sort()
    def rels_for(self,k):
        s,o,z,_=self.funcs[k];ls=self.rels[s]
        a=bisect.bisect_left(ls,(o,));b=bisect.bisect_left(ls,(o+z,))
        return [(off-o,r,idx,add) for off,r,idx,add in ls[a:b]]
    def target(self,r,idx,add):
        n,k,b,sec,o,z=self.sym[idx]
        if n and self.names[n]==1 and k in (0,1,2,6):return ('name',n,add)
        if k!=3 or not 0<sec<len(self.sec):return None
        expected=add+(4 if r in (2,4,9,41,42) else 0)
        ls=self.ranges[sec];starts=self.starts.get(sec,[]);ix=bisect.bisect_right(starts,expected)-1
        if ix>=0:
            start,finish,name=ls[ix]
            if start<=expected<finish:return ('name',name,add-start)
        s=self.sec[sec]
        if 0<=expected<s[5] and s[2]&16:
            # Mergeable literal content has no source object name. Count this weaker class separately.
            start=s[4]+expected
            if s[2]&32 and s[9]==1:
                end=self.data.find(b'\0',start,s[4]+s[5])
                if end>=start:return ('literal-string',self.secname[sec],self.data[start:end+1],add-expected)
            elif s[9] and s[9]<=64:
                pos=expected//s[9]*s[9]
                return ('literal-constant',self.secname[sec],self.data[s[4]+pos:s[4]+pos+s[9]],add-pos)
        return None
    def raw(self,r,idx,add):
        n,k,b,sec,_,_=self.sym[idx]
        return (r,n or (self.secname[sec] if sec<len(self.sec) else ''),add)
for u in ['sqlite','main']:
    full=Object(d/'../source-typed-study'/(u+'.o'))
    with (d/(u+'-symbolic.tsv')).open('w') as f:
        t=csv.writer(f,delimiter='\t',lineterminator='\n')
        t.writerow('unit checkpoint common equal_code raw_relocations exact_named_relocations named_or_raw named_or_raw_or_literal unresolved_functions early_common_bytes named_or_raw_bytes all_resolved_bytes excluded_duplicate_symbols excluded_duplicate_bytes'.split())
        for path in sorted(d.glob(u+'.*.o'),key=lambda s:int(s.name.split('.')[1])):
            early=Object(path);common=early.funcs.keys()&full.funcs.keys();sumrow=collections.Counter()
            with path.with_suffix('.fixups.tsv').open('w') as detail:
                table=csv.writer(detail,delimiter='\t',lineterminator='\n');table.writerow('function bytes fixups published_data original_raw named named_or_raw named_or_raw_or_literal unresolved'.split())
                for k in sorted(common):
                    a,z=early.funcs[k],full.funcs[k];ls=early.rels_for(k);rs=full.rels_for(k)
                    raw=named=anysym=lit=(len(ls)==len(rs));same=a[3]==z[3];unresolved=0
                    for x,y in zip(ls,rs):
                        ax,xt,xi,xa=x;ay,yt,yi,ya=y;match=(ax,xt)==(ay,yt)
                        eq=match and early.raw(xt,xi,xa)==full.raw(yt,yi,ya)
                        ex=early.target(xt,xi,xa);ey=full.target(yt,yi,ya)
                        es=match and ex is not None and ex==ey
                        name=es and ex[0]=='name'
                        raw &= eq;named &=name;anysym &= eq or name;lit &= eq or es
                        unresolved+=not (eq or es)
                    raw &= same;named &= same;anysym &= same;lit &= same
                    table.writerow([k,a[2],len(ls),int(same),int(raw),int(named),int(anysym),int(lit),unresolved])
                    for key,val in [('same',same),('raw',raw),('named',named),('any',anysym),('lit',lit),('bytes',a[2]),('anybytes',a[2]*anysym),('litbytes',a[2]*lit)]:sumrow[key]+=val
            t.writerow([u,int(path.name.split('.')[1]),len(common),sumrow['same'],sumrow['raw'],sumrow['named'],sumrow['any'],sumrow['lit'],len(common)-sumrow['lit'],sumrow['bytes'],sumrow['anybytes'],sumrow['litbytes'],early.dups,early.dupbytes])
