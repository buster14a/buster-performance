"""Compare every physical source graph operand, token and opcode with the independently exported reference."""
import csv
import hashlib
import json
import re
import shlex
import subprocess
import sys
from pathlib import Path

work=Path(__file__).resolve().parent.parent
study,tree,layout=sys.argv[1:4]
d=work/study
t=work/tree
unit=next(x for x in json.loads((t/'build/compile_commands.json').read_text()) if x['file'].endswith('/main_unit_checker.c'))
args=shlex.split(unit['command'])
dump=subprocess.check_output(args[:args.index('-Xclang')]+['-Xclang','-fdump-record-layouts','-fsyntax-only',unit['file']],cwd=unit['directory'],text=True)
def offset(struct, field):
    decl=re.search(r'^\s*0 \| struct '+struct+r'\n(.*?)\[sizeof=',dump,re.M|re.S)[1]
    return int(re.search(r'^\s*(\d+) \|   \S[^\n]*?\b'+field+r'$',decl,re.M)[1])
fields=['count','ops','tokens','operand0','operand1','operand2','near_edges']
if layout=='all':fields.append('near_first')
offsets={field:offset('CheckGraph',field) for field in fields}
gdbcode="""set pagination off
set debuginfod enabled off
set confirm off
set disable-randomization off
python
import gdb,os,struct,hashlib,json
from array import array
class Capture(gdb.Breakpoint):
    def stop(self):
        addr=int(gdb.parse_and_eval('$rsi'))
        cap=gdb.selected_inferior().read_memory
        offsets=OFFSETS
        def field(k,size):return int.from_bytes(cap(addr+offsets[k],size).tobytes(),'little')
        n=field('count',4)
        columns={}
        for k in ('ops','tokens','operand0','operand1','operand2'):
            v=array('I');v.frombytes(cap(field(k,8),n*4).tobytes());columns[k]=v
        near=field('near_edges',8)
        secondary=primary=0
        if near:
            packed=cap(near,n).tobytes()
            for i,b in enumerate(packed):
                if LAYOUT in ('exceptions','all') and b&127==127:
                    secondary+=1
                else:
                    columns['operand1'][i]=i-(b&127) if b&127 else 0xffffffff
                    columns['operand2'][i]=i-1 if b&128 else 0xffffffff
        if LAYOUT=='all' and field('near_first',8):
            for i,b in enumerate(cap(field('near_first',8),n).tobytes()):
                if b==255:primary+=1
                else:columns['operand0'][i]=i-b if b else 0xffffffff
        print('GRAPH-WIRE '+json.dumps({'nodes':n,'near':bool(near),'primary_wide':primary,'other_wide':secondary,'sha256':{k:hashlib.sha256(v).hexdigest() for k,v in columns.items()}}))
        return False
Capture('*check_graph_run')
end
run
""".replace('OFFSETS',repr(offsets)).replace('LAYOUT',repr(layout))
(d/'graph-wire.gdb').write_text(gdbcode)
shell=(work/'ordinary-graph-count/root-coverage.sh').read_text().replace('main-fbef-clean',tree).replace('root-coverage.gdb','graph-wire.gdb').replace('coverage-','graph-wire-').replace('coverage.o','graph-wire.o')
(d/'graph-wire.sh').write_text(shell)
subprocess.run(['bash',str(d/'graph-wire.sh')],check=True)
with (d/'graph-wire.tsv').open('w') as out:
    wr=csv.writer(out,delimiter='\t',lineterminator='\n')
    wr.writerow(['corpus','nodes','column','same','source_sha256','decoded_sha256','compact','primary_exceptions','other_exceptions'])
    for name in ('sqlite','main'):
        log=(d/f'graph-wire-{name}.log').read_text()
        rows=[json.loads(m) for m in re.findall(r'^GRAPH-WIRE (.*)$',log,re.M)]
        assert len(rows)==1 and 'exited normally' in log,(name,len(rows))
        result=rows[0]
        for key,digest in result['sha256'].items():
            ref=hashlib.sha256((work/'body-resident-study'/name/(key+'.bin')).read_bytes()).hexdigest()
            wr.writerow([name,result['nodes'],key,int(ref==digest),ref,digest,int(result['near']),result['primary_wide'],result['other_wide']])
            assert ref==digest,(name,key,result['nodes'],ref,digest)
        print(name,result['nodes'],result['near'],result['primary_wide'],result['other_wide'],flush=True)
