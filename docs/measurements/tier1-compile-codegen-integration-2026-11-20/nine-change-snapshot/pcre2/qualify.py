from pathlib import Path
from collections import defaultdict
import subprocess,csv,hashlib,os,statistics,struct
d=Path(__file__).resolve().parent;w=d.parents[1]
cc=Path('/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang')
def run(cmd,**kw):return subprocess.run(list(map(str,cmd)),check=True,**kw)
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
def text(p):
    a=p.read_bytes();sh=struct.unpack_from('<Q',a,40)[0];sz,n,i=struct.unpack_from('<HHH',a,58);off=struct.unpack_from('<Q',a,sh+sz*i+24)[0]
    return sum(struct.unpack_from('<Q',a,sh+sz*j+32)[0] for j in range(n) if a[off+struct.unpack_from('<I',a,sh+sz*j)[0]:].startswith(b'.text\0'))
def table(name,header,rows):
    with (d/name).open('w') as f:
        out=csv.writer(f,delimiter='\t',lineterminator='\n');out.writerow(header);out.writerows(rows)
variants=['clang','control','candidate'];data={}
for v in variants:
    assert(d/(v+'-static.status')).read_text().strip()=='0';b=d/(v+'-static');objects=sorted(p for p in b.glob('CMakeFiles/**/*.o') if 'CompilerIdC' not in p.parts)
    data[v]={str(p.relative_to(b)):(text(p),sha(p)) for p in objects}
keys=sorted(data['clang']);assert len(keys)>=90 and all(sorted(s)==keys for s in data.values())
table('objects.tsv',['target_object',*[a+'_'+b for a in variants for b in ['text_bytes','object_sha256']]],[[k,*[x for v in variants for x in data[v][k]]] for k in keys])
out=d/'match-programs';out.mkdir(exist_ok=True);expected=None;programs={};cases=[]
for width in [8,16,32]:
    driver=out/f'driver{width}.o';run([cc,'-O2','-DPCRE2_CODE_UNIT_WIDTH='+str(width),'-I',d/'clang-static','-c',d/'match.c','-o',driver])
    for pad in [0,32,64,128]:
        po=out/f'pad{pad}.o';run([cc,'-x','assembler','-c','-','-o',po],input=(f'.text\n.balign 256\n.space {pad},0x90\n.section .note.GNU-stack,"",@progbits\n').encode())
        for v in variants:
            exe=out/f'match-{v}-{width}-{pad}';run([cc,'-no-pie',driver,po,d/(v+'-static')/f'libpcre2-{width}.a','-o',exe])
            result=run([exe,24],capture_output=True,text=True).stdout.strip()
            if expected is None:expected=result
            assert result==expected,(width,pad,v,result,expected)
            nm=run(['nm','-S','--defined-only',exe],capture_output=True,text=True).stdout.splitlines()
            a,size,*_=next(line.split() for line in nm if line.rstrip().endswith(' pcre2_match_'+str(width)))
            programs[width,pad,v]=exe;cases.append([width,pad,v,hex(int(a,16)),int(size,16),sha(exe),result])
table('runtime-programs.tsv',['width','linker_padding','variant','match_address','match_bytes','exe_sha256','expected'],cases)
raw=d/'runtime-raw';raw.mkdir(exist_ok=True);metrics=['cycles:u','instructions:u','branches:u','branch-misses:u','task-clock'];rows=[]
settings=[(width,pad) for width in [8,16,32] for pad in [0,32,64,128]]
for rep in range(7):
    for pos in range(len(settings)):
        width,pad=settings[(pos+5*rep)%len(settings)]
        vs=['control','candidate'] if (pos+rep)%2==0 else ['candidate','control']
        for v in vs:
            path=raw/f'{rep}-{width}-{pad}-{v}.stat'
            result=run(['perf','stat','--no-big-num','-x',';','-e',','.join(metrics),'-o',path,'--',programs[width,pad,v],24],capture_output=True,text=True,env=dict(os.environ,LC_ALL='C')).stdout.strip()
            assert result==expected
            vals={a[2]:float(a[0]) for l in path.read_text().splitlines() if len(a:=l.split(';'))>2}
            rows.append([rep,width,pad,v,*[vals[k] for k in metrics],result])
table('runtime-counters.tsv',['round','width','linker_padding','variant',*metrics,'result'],rows)
stats=[]
for width,pad in settings:
    for j,m in enumerate(metrics):
        times={v:[r[4+j] for r in rows if r[0] and r[1:4]==[width,pad,v]] for v in ['control','candidate']}
        changes=[(b/a-1)*100 for a,b in zip(times['control'],times['candidate']) if a]
        stats.append([width,pad,m,len(changes),statistics.median(times['control']),statistics.median(times['candidate']),statistics.median(changes),min(changes),max(changes)])
table('runtime-summary.tsv',['width','linker_padding','metric','pairs','control_median','candidate_median','paired_pct','min_pct','max_pct'],stats)
print('units',len(keys),'match checks',expected,'layouts',len(cases),'observations',len(rows))
