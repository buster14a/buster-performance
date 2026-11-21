"""Build a standalone counter over the exact production candidate's source scan.

Ranks neither this process nor its execution time. Its counters cover source-byte
extents submitted to the primary scan, lexical checks, and leading directive probes.
"""
from pathlib import Path
import argparse,subprocess,tempfile,re
arg=argparse.ArgumentParser();arg.add_argument('sourcefile',type=Path);arg.add_argument('corpora',nargs='+',type=Path);a=arg.parse_args()
src=a.sourcefile.read_text()
f=src[src.index('static bool pp_plain_source_range('):src.index('static PPPrepareStatus pp_prepare_structural_primary(')]
f=f.replace('        const uint32_t left = end - base;', '        const uint32_t left = end - base; scan_checked += left < 64 ? left : 64;')
f=f.replace("const uint8_t* d = memchr(bytes + p, 'd', end - p - 6);", "const uint8_t* d = memchr(bytes + p, 'd', end - p - 6); name_probe += d != NULL ? (uint64_t)(d - bytes - p + 1) : end - p - 6;")
begin=src.index('    uint32_t count = 0, previous_hash')
end=src.index('    if (count == 0)',begin) if '    if (count == 0)' in src[begin:] else src.index('    uint8_t* masked =',begin)
if '    uint8_t* masked =' in src[begin:end]: end=src.index('    uint8_t* masked =',begin)
s=src[begin:end]
s=re.sub(r'    data->plan_ticks.*?;\n','',s);s=re.sub(r'    data->checked_source_bytes.*?;\n','',s)
s=s.replace('spans != NULL && base < length','base < length').replace('prepare->refine_flags','flags')
s=s.replace('previous_hash = hash;', 'previous_hash = hash; line_probe += end - hash; prefix_probe += hash - line + (line != 0);')
s=s.replace('spans[count++] = (PPDeferredSpan){ .before = previous_hash, .begin = first, .end = line, .after = hash };','count += 1; accepted += line - first;')
s=s.replace('        const __m512i row = ', '        primary += length - base < 64 ? length - base : 64;\n        const __m512i row = ')
head='''#define _GNU_SOURCE
#include <immintrin.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#define C_TOKENIZER_RAW_STRINGS 1
#define C_TOKENIZER_TRIGRAPHS 2
static uint64_t scan_checked,line_probe,prefix_probe,name_probe,primary,accepted;
'''
main='''int main(int argc,char**argv){FILE*f=fopen(argv[1],"rb");fseek(f,0,SEEK_END);uint32_t length=ftell(f);rewind(f);uint8_t*bytes=malloc((size_t)length+1);if(fread(bytes,1,length,f)!=length){return 1;}fclose(f);uint32_t flags=C_TOKENIZER_RAW_STRINGS;uint32_t min_span=4096;uint64_t checked_bytes=0;
'''
tail='''printf("primary=%llu lexical=%llu directive_line=%llu directive_prefix=%llu condition_name=%llu accepted_bytes=%llu ranges=%u range_table_capacity_bytes=%llu retained_range_records_bytes=%llu\\n",
 (unsigned long long)primary,(unsigned long long)scan_checked,(unsigned long long)line_probe,(unsigned long long)prefix_probe,(unsigned long long)name_probe,(unsigned long long)accepted,count,(unsigned long long)(length/4096+1)*24,(unsigned long long)count*24);return 0;}
'''
with tempfile.TemporaryDirectory() as tmp:
 root=Path(tmp);(root/'scan.c').write_text(head+f+main+s+tail)
 subprocess.run(['cc','-O2','-march=native',str(root/'scan.c'),'-o',str(root/'scan')],check=True)
 for corpus in a.corpora:
  print(corpus.name,subprocess.check_output([str(root/'scan'),str(corpus)],text=True).strip())
