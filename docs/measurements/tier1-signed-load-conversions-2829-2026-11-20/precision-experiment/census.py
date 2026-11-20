from pathlib import Path
import collections,csv,re,subprocess
w=Path(__file__).resolve().parents[1]
# Count adjacent machine instructions with an optional dependency-breaking zero on the destination.
groups={'musl-math':sorted((w/'neg-evidence/libm/control').glob('*.o')),'buster':sorted((w/'integration-evidence/nine-control-own-stage2').glob('unit-*.o')),'sqlite':[w/'profiles/combined-release.o']}
with (w/'cast-evidence/adjacent.tsv').open('w') as f:
    t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['corpus','object','function','kind','load','consumer'])
    for corpus,files in groups.items():
        for obj in files:
            out=subprocess.run(['objdump','-d','--no-show-raw-insn','-Mintel',str(obj)],capture_output=True,text=True,check=True).stdout
            previous=[];name=''
            for line in out.splitlines():
                if match:=re.fullmatch(r'[0-9a-f]+ <(.*)>:',line):
                    name=match[1];previous=[];continue
                match=re.match(r'\s*[a-f0-9]+:\s+(\w+)\s+(.+)',line)
                if not match:previous=[];continue
                op,operands=match.groups();operands=operands.split('#')[0].strip()
                parts=operands.split(',')
                source=parts[1].strip() if len(parts)==2 else None
                if source and (op in ['cvtss2sd','cvtsd2ss','cvttsd2si','cvttss2si','movd','movq','ucomisd','ucomiss','comisd','comiss']):
                    for pop,pargs in reversed(previous[-2:]):
                        args=pargs.split(',')
                        if pop in ['mov','movss','movsd','vmovss','vmovsd','vmovd','vmovq','movq','movd'] and len(args)==2 and '[' in args[1] and args[0]==source:
                            kind='bitcast' if op in ('movd','movq') else 'resize' if op in ('cvtss2sd','cvtsd2ss') else 'compare' if 'comis' in op else 'to-int'
                            t.writerow([corpus,obj.name,name,kind,pop+' '+pargs,op+' '+operands]);break
                        # The other instruction can only be the destination zeroing idiom.
                        if not (pop in ['xorps','xorpd','pxor'] and len(args)==2 and args[0]==args[1] and args[0]!=source):break
                previous.append((op,operands))
