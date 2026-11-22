from pathlib import Path
import argparse,hashlib,subprocess
parser=argparse.ArgumentParser()
parser.add_argument('--full',action='store_true')
parser.add_argument('--vector',action='store_true')
parser.add_argument('--masks',action='store_true')
parser.add_argument('--cache',action='store_true')
opt=parser.parse_args()
here=Path(__file__).resolve().parent
dest=here/('edges-cache' if opt.cache else 'edges-masks' if opt.masks else 'edges-vector' if opt.vector else 'edges');dest.mkdir(exist_ok=True)
tool='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
pad=''.join(f'/* filler {i:04d} '+('a'*64)+' */\n' for i in range(1400))
big=('int bad@and@@uncompilable; "fake #else"; /* foo */\n' * 900)
text_header='#define SUM(a,b) ((a)+(b))\n#define FLAG 1\nint answer;\n'
large=pad+'#define DEEP_SENTINEL 1\n'+big+pad
programs={
 'retained-bodies': ([], text_header+'#define CAT(a,b) a##b\n#define STR(x) #x\n#define PLUS(x,y) SUM(x,y)\n#include "inc.h"\n'+pad+'#define BOUNDARY_ONE 1\n'+pad+'#define BOUNDARY_TWO 2\n'+pad+'#define NEXT(x) PLUS(x,HEADER)\nint CAT(f,oo)=4;\nint main(void){return !(foo==4 && NEXT(5)==22 && STR(hello world)[5]==32); }\n',0),
 'angled-name': ([], text_header+pad+'#define BEFORE_INCLUDE 1\n'+pad+'#include <hdr/*bar.h>\nint main(void){return EXPORT!=8;}\n',0),
 'fragment-includes': ([],text_header+'#define FROM_MAIN 20\n'+pad+'#define BETWEEN 0\n#include "bridge.h"\n'+pad+'#define AFTER 0\nint main(void){return SHARED_VALUE!=37;}\n',0),
 'terminal-arm': ([], '#if 1\nint active;\n'+' '*(1<<20)+'\n#else\n#error wrong arm\n#endif\nint main(void){return 0;}\n',0),
 'active-headers': ([], text_header + '#include "inc.h"\nint main(void) { return SUM(HEADER,FLAG) != 18; }\n',0),
 'macro-argument': ([], text_header+'int main(void) { return SUM(2,\n#if 0\n'+large+'\n#else\n4\n#endif\n) != 6; }\n',0),
 'visible-trees': ([], text_header+'#if 0\n'+large+'\n#elif FLAG\nint main(void) { return 0; }\n#else\n#error wrong\n#endif\n',0),
 'masked-lookalikes': ([], text_header+'#if 0\n'+pad+'#if 1\n\'#\' "#endif" /*\n#endif\n*/\n// #endif\n# endif\nint cooked;\n'+pad+'#else\nint main(void) {return 0;}\n#endif\n',0),
 'splice-conditional': ([], text_header+'#if 0\n'+pad+'#if 1\n#en\\\ndif\n'+pad+'#else\nint main(void) {return 0;}\n#endif\n',0),
 'digraph': ([], text_header+'#if 0\n'+pad+'#if 1\n%:endif\n'+pad+'%:else\nint main(void) {return 0;}\n%:endif\n',0),
 'trigraph': (['-trigraphs'], text_header+'#if 0\n'+pad+'#if 1\n??=endif\n'+pad+'??=else\nint main(void) {return 0;}\n??=endif\n',0),
 'cross-position': ([], text_header+pad+'#define ACTIVE 31\n#line 104 "virtual-name.c"\nint line=__LINE__;\nint main(void){return line!=104 || ACTIVE!=31;}\n',0),
 'fallback-raw': ([],text_header+'#if 0\n'+pad+'#if 1\nR"tag(a /*)tag"\n#endif\n'+pad+'#else\nint main(void){return 0;}\n#endif\n',0),
 'nested-invalid': ([],text_header+'#if 0\n'+pad+'#if 0\n#else\n#elif 1\n#endif\n'+pad+'#else\nint out;\n#endif\n',1),
 'mapped-warning': ([],text_header+'#if 0\n'+large+'\n#else\n#line 321 "after.c"\n#warning cursor warns here\nint main(void){return 0;}\n#endif\n',0),
 'escaped-quote': ([],text_header+'#if 0\n'+pad+'#if 1\n"\\\\" /* hidden #endif */\n#endif\n'+pad+'#else\nint main(void){return 0;}\n#endif\n',0),
}
(dest/'hdr').mkdir(exist_ok=True)
(dest/'hdr'/'*bar.h').write_text('#define EXPORT 8\n')
(dest/'bridge.h').write_text('#include "inc.h"\n#define SHARED_VALUE (FROM_MAIN+HEADER)\n')
(dest/'inc.h').write_text('#ifndef INC_H\n#define INC_H\n#define HEADER 17\n#endif\n')
binaries=([here.parent/('pp-live-group-cache' if opt.cache else 'pp-live-group-vector' if opt.vector else 'pp-live-group-cursor')/'build/compiler',here.parent/'main-fbef-clean/build/compiler'] if opt.full else [here/('debug-cache' if opt.cache else 'debug-masks' if opt.masks else 'debug-vector' if opt.vector else 'debug-pp'),here/'debug-base'])
if not opt.full:
 binaries=[here/'pilot-driver',here.parent/'pp-live-group-study/debug-base']
else:
 binaries=[here.parent/'active-source-producer/build/compiler',here.parent/'main-fbef-clean/build/compiler']
modes=[['-E'],['-E','-P'],['-Wall','-Wextra','-E'],['-Weverything','-E']] if opt.full else [[],['-P']]
if opt.full:modes.append(['-c'])
result=[]
for name,(flags,body,status) in programs.items():
 src=dest/(name+'.c'); src.write_text(body if name == 'terminal-arm' else body+('\n#define TEST_PAD 1\n'+pad)*10+'\n')
 clang=subprocess.run([tool,'-I',str(dest),*flags,'-c',str(src),'-o',str(dest/'clang.o')],capture_output=True)
 if (clang.returncode!=0)!=bool(status): print(name,clang.stderr[:300]);raise SystemExit('unexpected clang status')
 for j,mode in enumerate(modes):
  records=[]
  for tag,exe in zip(('candidate','baseline'),binaries):
   obj=dest/(tag+'.o')
   cmd=[str(exe),*mode,'-I',str(dest),*flags,str(src)]
   if '-c' in mode:cmd+=['-o',str(obj)]
   r=subprocess.run(cmd,capture_output=True)
   (dest/f'{name}-{j}-{tag}.err').write_bytes(r.stderr)
   records.append((r.returncode,r.stdout,r.stderr,obj.read_bytes() if '-c' in mode and not r.returncode else b''))
   if opt.full and '-c' in mode and r.returncode==0 and name!='nested-invalid':
    a=subprocess.run([tool,'-no-pie',str(obj),'-o',str(dest/'run')],capture_output=True)
    assert not a.returncode,(name,tag,a.stderr)
    assert subprocess.run([str(dest/'run')]).returncode==0,(name,tag)
  a,b=records; equal=a==b and ((a[0]!=0)==bool(status))
  result.append(equal)
  if not equal:
   print(name,j,flags,'status',a[0],b[0],'stdout',len(a[1]),len(b[1]), 'stderr',a[2][:270],b[2][:270],flush=True)
   for tag,x in zip(('candidate','baseline'),records): (dest/f'{name}-{j}-{tag}.out').write_bytes(x[1])
print(f'{sum(result)}/{len(result)} marker, output, diagnostic, object and exit comparisons' if opt.full else f'{sum(result)}/{len(result)} marker, output, diagnostic and exit comparisons')
raise SystemExit(0 if all(result) else 1)
