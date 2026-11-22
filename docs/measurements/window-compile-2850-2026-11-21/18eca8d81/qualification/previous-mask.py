from pathlib import Path
import array,csv,hashlib,subprocess
s=Path(__file__).resolve().parent;w=s.parent;d=s/'previous-mask';d.mkdir(exist_ok=True)
bins={'baseline':w/'main-fbef-clean/build/compiler','rejected':w/'tile-parents-study/rejected-compiler','corrected':w/'seed-parser-windows/build/compiler'}
with (s/'previous-mask.tsv').open('w',buffering=1) as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['nesting','grammar-tokens','rejected-parent-differences','corrected-parent-differences','baseline-elf','rejected-elf','corrected-elf'])
 for nest in [0,63,254,255,259,519]:
  source=d/('permanent-'+str(nest)+'.c');source.write_text('int x;\n'*3072+'int f(int x){return '+'('*nest+'x'+')'*nest+';}\n')
  observed={}
  for label,binary in bins.items():
   opt='baseline' if label=='baseline' else 'candidate';tmpl=s/'source-depths'/(opt+'-sqlite.gdb');base=s/'source-depths'/(opt+'-sqlite.bin')
   gdb=d/(label+'-'+str(nest)+'.gdb');raw=d/(label+'-'+str(nest)+'.bin');gdb.write_text('\n'.join('   pass' if label=='rejected' and 'boundary-records' in line else line for line in tmpl.read_text().replace(str(base),str(raw)).splitlines())+'\n');obj=d/'unit.o';obj.unlink(missing_ok=True)
   r=subprocess.run(['gdb','-q','--batch','-x',gdb,'--args',binary,'--lanes','1','-c',source,'-o',obj],capture_output=True,timeout=45)
   (d/(label+'-'+str(nest)+'.log')).write_bytes(r.stdout+r.stderr)
   v=array.array('I',Path(str(raw)+'.parents').read_bytes());o=hashlib.sha256(obj.read_bytes()).hexdigest() if obj.exists() else '-'
   observed[label]=(v,o)
  ref,old,fixed=[observed[x] for x in bins];assert len(ref[0])==len(old[0])==len(fixed[0]);a=sum(x!=y for x,y in zip(ref[0],old[0]));b=sum(x!=y for x,y in zip(ref[0],fixed[0]))
  assert b==0 and fixed[1]==ref[1]!='-' and (a!=0)==(nest<255),(nest,b,a,ref[1],fixed[1]);t.writerow([nest,len(ref[0]),a,b,ref[1],old[1],fixed[1]])
