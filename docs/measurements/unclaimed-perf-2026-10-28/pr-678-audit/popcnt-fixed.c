#include <stdint.h>
#include <stdbool.h>
#include "/home/david/Documents/Codex/2026-10-28/solv/work/compat-678/src/buster/compiler/host_isa.h"
unsigned count(unsigned long long a)
{
 return (unsigned)_mm_popcnt_u64(a);
}
