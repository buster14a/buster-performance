#include "host_isa.h"
unsigned count(unsigned long long a)
{
 return (unsigned)_mm_popcnt_u64(a);
}
