from pathlib import Path
import hashlib,subprocess,struct,sys,os
p=Path(__file__).resolve().parent;os.chdir(p)
target=sys.argv[1] if len(sys.argv)>1 else 'lookahead-raw'
sql=Path('../switch-inputs/sqlite/sqlite3.c')
sqlopt=['-DSQLITE_OMIT_LOAD_EXTENSION','-DSQLITE_THREADSAFE=0','-DSQLITE_ENABLE_MEMSYS5','-DSQLITE_ENABLE_RTREE','-I../switch-inputs/sqlite']
lua=Path('../switch-inputs/inputs/lua-5.4.8/src')
mu=Path('../switch-inputs/libc/musl')
muopt=['-std=c99','-nostdinc','-ffreestanding','-D_XOPEN_SOURCE=700','-I'+str(mu/'arch/x86_64'),'-I'+str(mu/'arch/generic'),'-I../switch-inputs/musl-generated/obj/src/internal','-I'+str(mu/'src/include'),'-I'+str(mu/'src/internal'),'-I../switch-inputs/musl-generated/obj/include','-I'+str(mu/'include')]
cases=[(sql,sqlopt),(Path('macro-source/positive.c'),[]),(Path('macro-source/invalid.c'),[]),(Path('macro-source/diagnostics.c'),[])]
cases+=[(x,[]) for x in sorted(lua.glob('*.c'))]
cases+=[(x,muopt) for path in ['ctype','stdio','string','math'] for x in sorted((mu/'src'/path).glob('*.c'))[::9]]
total=[0]*8;bytes_total=0
for file,opts in cases:
 results=[subprocess.run([str(p/m/'pp-columns'),*opts,str(file)],capture_output=True) for m in ['parent-raw',target]]
 a,b=results
 if a.returncode or b.returncode or a.stdout!=b.stdout or a.stderr!=b.stderr:
  print('mismatch',file,a.returncode,b.returncode,len(a.stdout),len(b.stdout),a.stderr[:512],b.stderr[:512],flush=True);sys.exit(1)
 n=struct.unpack('<8I',a.stdout[:32])
 if not n[0] and file.name!='invalid.c':
  print('unexpected rejection',file,a.stderr[:512]);sys.exit(1)
 total=[i+j for i,j in zip(total,n)];bytes_total+=len(a.stdout)
 print(file,*n,len(a.stdout),hashlib.sha256(a.stdout).hexdigest(),flush=True)
print('equal units',len(cases),'logical-counts',total,'transcript-bytes',bytes_total,flush=True)
