from pathlib import Path
import json,re,shlex,subprocess
st=Path(__file__).resolve().parent;w=st.parent;src=w/'pending-native-windows'
c=next(x for x in json.loads((src/'build/compile_commands.json').read_text()) if x['file'].endswith('main_unit_checker.c'));args=shlex.split(c['command']);args=[a for a in args[:args.index('-Xclang')] if not a.startswith('-DCMAKE_INTDIR')]
defs=subprocess.check_output([*args,'-Xclang','-fdump-record-layouts','-fsyntax-only',c['file']],cwd=c['directory'],stderr=subprocess.PIPE,text=True)
def offs(name,key):
 l=re.search(r'^\s*0 \| struct '+name+r'\n(.*?)\[sizeof=',defs,re.S|re.M)[1];return int(re.search(r'^\s*(\d+) \|   \S[^\n]*?\b'+key+r'$',l,re.M)[1])
assert offs('CheckInput','graph')==0
g=Path(w/'discard-bits-study/root-coverage.gdb').read_text();a=g.index("        p=int(");b=g.index("        return False",a)
fields=[('tokens','CheckInput','token_count'),('nodes','CheckGraph','count'),('roots','CheckInput','window_count'),('rows','CheckInput','window_row_count'),('prior','CheckInput','window_nodes')]
g=g[:a]+"        p=int(gdb.parse_and_eval('$rsi'))\n        print('pending-coverage "+' '.join(f'{label}=%d' for label,_,_ in fields)+"' % ("+', '.join(f'read(p,{offs(n,k)},4)' for _,n,k in fields)+"))\n"+g[b:];(st/'root-coverage.gdb').write_text(g)
s=(w/'discard-calls-study/root-coverage.sh').read_text().replace('discard-call-events','pending-native-windows');(st/'root-coverage.sh').write_text(s)
subprocess.run(['bash',str(st/'root-coverage.sh')],check=True)
for c in ['sqlite','main']: print(next(l for l in (st/('coverage-'+c+'.log')).read_text().splitlines() if l.startswith('pending-coverage')))
