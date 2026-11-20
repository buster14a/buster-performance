from pathlib import Path
import csv,os,subprocess,hashlib,re
d=Path(__file__).resolve().parent;w=d.parents[1];settings={'default':{},'sorter':{'BUSTER_2831_ONLY':'1244'},'sorter-kept':{'BUSTER_2831_ONLY':'1244','BUSTER_2831_KEEP_VM_ORDER':'1'},'full64':{},'full64-kept':{'BUSTER_2831_KEEP_VM_ORDER':'1'},'full32':{'BUSTER_2831_WIDTH':'32'},'full32-kept':{'BUSTER_2831_WIDTH':'32','BUSTER_2831_KEEP_VM_ORDER':'1'},'full16':{'BUSTER_2831_WIDTH':'16'},'full16-kept':{'BUSTER_2831_WIDTH':'16','BUSTER_2831_KEEP_VM_ORDER':'1'}}
rows=[]
for v,opts in settings.items():
 obj=d/(v+'.o');env=dict(os.environ,LC_ALL='C',SOURCE_DATE_EPOCH='1792454400',BUSTER_2831_DUMP='1',BUSTER_2831_WIDTH='64',BUSTER_2831_META='1');env.update(opts);a=['--tier1','-O2','-march=znver5','--lanes','1','-w','--tier1-report','-DSQLITE_THREADSAFE=0','-DSQLITE_OMIT_LOAD_EXTENSION']
 if v!='default':a+=['--tier1-passes=+vectorize']
 with (d/(v+'.log')).open('wb') as log:
  subprocess.run([w/'width-profile/build/compiler',*a,'-c','inputs/sqlite3.c','-o',obj],env=env,cwd=w/'compile-evidence',stdout=log,stderr=log,check=True)
 lines=(d/(v+'.log')).read_text().splitlines();cs=[l.split('\t')[2:] for l in lines if l.startswith('VM_EMIT\t0\t')];assert len(cs)==1
 nm=next(l for l in subprocess.check_output(['nm','-S','--defined-only',obj],text=True).splitlines() if l.endswith(' sqlite3VdbeExec'));vmbytes=int(nm.split()[1],16)
 asm=subprocess.check_output(['objdump','-d','-Mintel','--no-show-raw-insn','--disassemble=sqlite3VdbeExec',obj],text=True);(d/(v+'.asm')).write_text(asm);ops={}
 for l in asm.splitlines():
  m=re.match(r'^\s*[0-9a-f]+:\s+(\S+)\s*(.*)$',l)
  if m:
   op,args=m.groups();ops[op]=ops.get(op,0)+1
 table=lambda f,head,records: f.write_text('\t'.join(head)+'\n'+''.join('\t'.join(map(str,row))+'\n' for row in records))
 table(d/(v+'-ops.tsv'),['opcode','static_instructions'],sorted(ops.items()));rows.append([v,hashlib.file_digest(obj.open('rb'),'sha256').hexdigest(),vmbytes,sum(ops.values()),*cs[0]]);print(rows[-1],flush=True)
table(d/'body.tsv',['variant','object_sha256','VM_bytes','VM_static_instructions','machine_records','spill_stores','spill_loads','call_stores','call_loads','rematerializations','edge_moves','frame_bytes'],rows)
