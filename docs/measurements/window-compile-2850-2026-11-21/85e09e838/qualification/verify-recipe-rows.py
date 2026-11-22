from pathlib import Path
import csv,hashlib,subprocess
s=Path(__file__).resolve().parent;w=s.parent;d=s/'recipe-repair'
tracked=subprocess.check_output(['git','-C',w/'buster','show','a137ff13c:src/buster/compiler/c_check_input.c'],text=True)
func=tracked.split('static void check_input_named_prefixes(',1)[1].split('// Read a complete scalar',1)[0]
prior=(w/'packed-declaration-study/prefix-oracle.c').read_text();a=prior.index('static void check_input_named_prefixes(');b=prior.index('static uint8_t scalar(',a)
code=prior[:a]+'static void check_input_named_prefixes('+func+'''
int main(int argc,char **argv){
 if(argc!=5)return 1;uint32_t n=(uint32_t)strtoul(argv[3],NULL,10);
 unsigned char* k=malloc(n),*r=malloc(n),*out=malloc(n);if(!k || !r || !out)return 2;
 FILE*kinds=fopen(argv[1],"rb"),*roles=fopen(argv[2],"rb"),*dst=fopen(argv[4],"wb");if(!kinds || !roles || !dst)return 3;
 if(fread(k,1,n,kinds)!=n || fread(r,1,n,roles)!=n)return 4;
 Parser parser={.tokens={.kinds=k,.count=n},.tree={.roles=r}};check_input_named_prefixes(&parser,out);return fwrite(out,1,n,dst)!=n;
}
'''
p=d/'verified-producer.c';p.write_text(code);exe=d/'verified-producer'
clang='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang';subprocess.run([clang,'-march=native','-O2',p,'-o',exe],check=True)
with (s/'recipe-repairs.tsv').open() as f:r=list(csv.DictReader(f,delimiter='\t'))
with (s/'recipe-production-parity.tsv').open('w') as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['source','role-phase','extracted-producer-commit','input-tokens','observed-sha256','scalar-sha256','matched'])
 for row in r:
  name=row['source'];n=int(row['tokens'])
  for phase,roles in [('early',d/(name+'.raw-roles')),('final',s/'source-depths'/('candidate-'+name+'.bin.roles'))]:
   output=d/(name+'.'+phase+'.recipes')
   subprocess.run([exe,d/(name+'.kinds'),roles,str(n),output],check=True);actual=hashlib.sha256(output.read_bytes()).hexdigest();expected=row[phase+'-recipe-sha256'];t.writerow([name,phase,'a137ff13c',n,actual,expected,int(actual==expected)]);assert actual==expected,(name,phase)
