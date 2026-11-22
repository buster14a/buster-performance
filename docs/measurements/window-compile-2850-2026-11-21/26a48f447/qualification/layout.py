import json,re,shlex,subprocess
from pathlib import Path
d=Path(__file__).resolve().parent;tree=d.parent/'body-local-emission'
unit=next(x for x in json.loads((tree/'build/compile_commands.json').read_text()) if x['file'].endswith('main_unit_checker.c'))
args=shlex.split(unit['command']);args=[x for x in args[:args.index('-Xclang')] if not x.startswith('-DCMAKE_INTDIR')]
layouts=subprocess.check_output([*args,'-Xclang','-fdump-record-layouts','-fsyntax-only',unit['file']],cwd=unit['directory'],stderr=subprocess.PIPE,text=True)
def layout(name):
 m=re.search(r'^\s*0 \| struct '+name+r'\n(.*?)\[sizeof=(\d+)',layouts,re.M|re.S); return m[1],int(m[2])
def off(name,var):
 return int(re.search(r'^\s*(\d+) \|   \S[^\n]*?\b'+var+r'$',layout(name)[0],re.M)[1])
r='CheckEmitRun';b='CheckEmitBody';c='EmittedCode'
assert off(r,'codes') == 96
f=(d/'count.gdb').read_text()
for value,key in [(off(r,'codes'),'CODES'),(off(r,'bodies'),'BODIES'),(layout(c)[1],'CODE_SIZE'),(off(c,'count'),'CT'),(off(c,'reference_count'),'REF_CT'),(off(c,'records'),'RECORD'),(layout(b)[1],'BODY_SIZE'),(off(b,'fixup_ends'),'ENDS'),(off(b,'resolved_fields'),'FIELDS')]:
 f=f.replace('#'+key+'#',str(value))
(d/'count-run.gdb').write_text(f)
