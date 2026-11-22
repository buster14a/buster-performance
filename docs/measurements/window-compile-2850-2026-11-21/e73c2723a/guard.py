from common import *
import csv,re,subprocess
tree=CC.parent.parent;folder=D/'guard';folder.mkdir(exist_ok=True);cl=Path('/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang')
code=(tree/'src/buster/compiler/c_check_program_lower.c').read_text();begin=code.index('static __mmask16 check_lower_plain_reserve_types');end=code.index('\n}',begin)+2;fn=code[begin:end];typ=(tree/'src/buster/compiler/c_types.c').read_text()
defines='\n'.join(next(l for l in typ.splitlines() if l.startswith('#define '+k+' ')) for k in ('BUSTER_TYPE_INDEX_SHIFT','BUSTER_TYPE_KIND_VECTOR','BUSTER_TYPE_KIND_ATOMIC','BUSTER_TYPE_KIND_ALIGNED','BUSTER_TYPE_KIND_WRAPPERS'))
prefix='''#include <immintrin.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/mman.h>
#include <sys/resource.h>
#include <unistd.h>
typedef struct { struct { uint32_t count; uint8_t *kind; } types; } TypeTable;
'''
tests=r'''
int main(void)
{
    struct rlimit limit = { 0, 0 };
    setrlimit(RLIMIT_CORE, &limit);
    long page = sysconf(_SC_PAGESIZE);
    uint8_t *memory = mmap(0, 2 * page, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (memory == MAP_FAILED || mprotect(memory + page, page, PROT_NONE) != 0) return 2;
    uint32_t seed = 2850;
    size_t checks = 0;
    for (uint32_t n = 4; n < 68; n += 1)
    {
        uint8_t *kinds = memory + page - n;
        TypeTable types = { .types = { n, kinds } };
        for (uint32_t j = 0; j < n; j += 1) kinds[j] = j == 0 ? 0 : (j * 7 + n) % 20;
        for (uint32_t trial = 0; trial < 64; trial += 1)
        {
            uint32_t ids[16];
            for (uint32_t j = 0; j < 16; j += 1)
            {
                seed = seed * 1664525 + 1013904223;
                uint32_t index = j < 3 ? n - 1 - j : seed % n;
                ids[j] = index == 0 ? 0 : (index << 3) | (seed & 7);
            }
            for (unsigned width = 1; width <= 16; width += 1)
            {
                uint16_t mask = (1u << width) - 1, expected = 0;
                for (unsigned j = 0; j < width; j += 1)
                {
                    uint8_t kind = kinds[ids[j] >> 3];
                    if (kind < 12 || (kind > 14 && kind < 18)) expected |= (uint16_t)(1u << j);
                }
                uint16_t got = check_lower_plain_reserve_types(&types, mask, _mm512_loadu_epi32(ids));
                if (got != expected)
                {
                    fprintf(stderr,"count=%u trial=%u width=%u got=%u expected=%u\n",n,trial,width,got,expected);
                    return 1;
                }
                checks += 1;
            }
        }
    }
    printf("%zu guard-page and mask comparisons\n",checks);
    return 0;
}
'''
with (folder/'outcomes.tsv').open('w') as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['case','exit','oracle-output'])
 for label,body,expect in [('production',fn,0),('unbounded-last-word',fn.replace('_mm512_min_epu32(index, _mm512_set1_epi32((int)(types->types.count - 4)))','index'),-11),('unmasked-return',fn.replace('return plain;', 'return plain | ~active;'),1)]:
  path=folder/(label+'.c');path.write_text(prefix+defines+'\n'+body+'\n'+tests);exe=folder/label
  subprocess.run([cl,'-std=gnu23','-march=native','-O3',path,'-o',exe],check=True);r=subprocess.run([exe],capture_output=True);(folder/(label+'.stdout')).write_bytes(r.stdout);(folder/(label+'.stderr')).write_bytes(r.stderr);t.writerow([label,r.returncode,(r.stdout+r.stderr).decode().strip()]);assert r.returncode==expect,(label,r.returncode)
