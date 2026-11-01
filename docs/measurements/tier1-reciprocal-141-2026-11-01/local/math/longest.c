// longest.c: the records of the reciprocal's sequences by params.h's model, for the divisors whose remainders take the
// most, which set buster#1001's BUSTER_TIER1_SELECT_FIXED_RECORDS (13). Build: cc -O2 -o longest longest.c
#include "params.h"
static bool fits(uint64_t v, uint32_t w) { return w == 4 || (uint64_t)(int64_t)(int32_t)v == v; }
static uint32_t records(uint64_t d, uint32_t w, bool s, bool rem) {
    Reciprocal r = reciprocal(d, w, s);
    bool kept = rem || r.add; uint32_t n = kept ? 1 : 0; // dividend in rax: copied when kept
    n += (!s && r.pre) ? 3 : 2;                          // rax holds it: no move before the pre-shift
    if (!s && r.add) n += 4 + (r.post > 1); else if (!s) n += r.post != 0;
    else { n += r.add + (r.post != 0) + 3; bool neg = ((d & mask_of(w)) >> (w*8-1)) & 1; n += neg && !rem; }
    if (rem) { uint64_t a = s ? magnitude(d, w) : d & mask_of(w); n += (fits(a, w) ? 1 : 2) + 2; }
    return n + 1;
}
int main(void) {
    const uint64_t c[] = { 7, 0x100000001ull, 0x7fffffffffffffffull, 0x5555555555555555ull, 1000000000000000003ull, 0x8000000000000001ull, 0xffffffffffffffffull, 0xfffffffffffffffeull, 0xfffffffffffffffdull, 1000000007ull, 0x80000001ull, 0xffffffffull, 0xfffffffdull, 0xffffffff00000001ull, 0x3333333333333333ull, 0x7ffffffffffffffdull, 0x0123456789abcdefull, 0x80000003ull, 0x00000000c0000001ull };
    for (unsigned i = 0; i < sizeof c / sizeof c[0]; i++) for (unsigned w = 4; w <= 8; w += 4) for (unsigned s = 0; s < 2; s++) {
        if (!eligible(c[i], w, s)) continue;
        Reciprocal r = reciprocal(c[i], w, s);
        unsigned n = records(c[i], w, s, true);
        if (n >= 12) printf("d=%016llx w=%u s=%u add=%d pre=%u post=%u rem_records=%u div_records=%u\n", (unsigned long long)c[i], w, s, r.add, r.pre, r.post, n, records(c[i], w, s, false));
    }
}
