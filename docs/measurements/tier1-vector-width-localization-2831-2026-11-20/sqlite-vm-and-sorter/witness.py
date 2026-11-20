from pathlib import Path
import csv,os,re,subprocess
p=Path(__file__).resolve().parent;w=p.parents[1];runs=[];oracles={(int(r['rows']),r['store']):r['expected'] for r in csv.DictReader((p/'oracles.tsv').open(),delimiter='\t')};env=dict(os.environ,LC_ALL='C',SQLITE_TMPDIR='/dev/shm',DEBUGINFOD_URLS='');root=p/'witness';root.mkdir(exist_ok=True)
for cap,reg in [('all16','xmm'),('all32','ymm'),('all64','zmm')]:
 exe=p/'programs'/('sort-'+cap+'-0');asm=subprocess.check_output(['objdump','-d','--no-show-raw-insn','-Mintel','--disassemble=sqlite3VdbeExec',exe],text=True);sites=re.findall(r'^\s*([0-9a-f]+):\s+(?:\{evex\}\s+)?(v?pmulld)\s+('+reg+r'2,'+reg+r'2,'+reg+r'0)\s*$',asm,re.M);assert len(sites)==1,(cap,sites)
 pc,op,args=sites[0];script=root/(cap+'.gdb');script.write_text(f'set pagination off\nset confirm off\nset debuginfod enabled off\nset disable-randomization off\nset $hits = 0\nbreak *0x{pc}\ncommands\nsilent\nset $hits = $hits+1\ncontinue\nend\nrun\nprintf "vector_multiply_hits=%d inferior_exit=%d\\n", $hits, $_exitcode\n')
 for n in [4096,32768,131072]:
  for mode in ['memory','spill']:
   q=subprocess.run(['gdb','-q','-nx','-batch','-x',script,'--args',exe,mode,p/'input.db',str(n)],env=env,check=True,capture_output=True,text=True,timeout=45);text=q.stdout+q.stderr;(root/f'{cap}-{n}-{mode}.log').write_text(text);m=re.search(r'vector_multiply_hits=(\d+) inferior_exit=(\d+)',text);assert m and int(m[1])==0 and int(m[2])==0 and oracles[n,mode] in text;runs.append([cap,n,mode,'0x'+pc,op+' '+args,m[1],m[2],oracles[n,mode]])
with (p/'machine-witness.tsv').open('w') as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['vector_setting','rows','temp_store','VM_vector_multiply_address','instruction','breakpoint_hits','exit_status','expected_result']);t.writerows(runs)
source=(w/'compile-evidence/inputs/sqlite3.c').read_text();begin=source.index('static int vdbeSorterTreeDepth(int nPMA){');end=source.index('\n}',begin)+2;print('tested function is copied from the pinned SQLite source')
c=root/'depth.c';c.write_text('#include <stdio.h>\n#include <limits.h>\n#include <stdint.h>\ntypedef int64_t i64;\n#define SORTER_MAX_MERGE_COUNT 16\n'+source[begin:end]+'''
int main(void){
  unsigned values[]={0,1,15,16,17,255,256,257,4095,4096,4097,65535,65536,65537,1048575,1048576,1048577,16777215,16777216,16777217,268435455,268435456,268435457,INT_MAX};
  puts("nPMA\\tdepth\\tscalar_multiply_iterations");
  for(unsigned i=0;i<sizeof(values)/sizeof(*values);i++){int depth=vdbeSorterTreeDepth((int)values[i]);printf("%u\\t%d\\t%d\\n",values[i],depth,depth>0?depth-1:0);if(depth>7)return 1;}
  return 0;
}
''');cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang';subprocess.run([cc,'-O0',c,'-o',root/'depth'],check=True);(p/'tree-depth-bounds.tsv').write_bytes(subprocess.check_output([root/'depth']))
