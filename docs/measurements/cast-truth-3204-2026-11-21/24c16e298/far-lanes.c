#include <immintrin.h>
#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <sanitizer/msan_interface.h>

static __attribute__((noinline)) int check_lanes(uint64_t mask)
{
    _Alignas(64) uint8_t scratch[64], output[64];
    __msan_poison(scratch, sizeof(scratch));
    for (uint64_t pending = mask; pending; pending &= pending-1) {
        unsigned lane = _tzcnt_u64(pending);
        scratch[lane] = (uint8_t)(lane + 17);
    }
    __m512i near = _mm512_set1_epi8(1);
    __m512i result = _mm512_mask_loadu_epi8(near, mask, scratch);
    _mm512_storeu_si512(output, result);
    for (unsigned i = 0; i < 64; i++)
        if (output[i] != ((mask >> i) & 1 ? i + 17 : 1)) return 1;
    return 0;
}
int main(void)
{
    uint64_t bits = 0xbe61bc88039ae0b3u;
    if (check_lanes(0) || check_lanes(UINT64_MAX)) return 1;
    for (unsigned i=0; i<64; i++) if (check_lanes(UINT64_C(1)<<i)) return 1;
    for (unsigned i=0; i<65536; i++) {
        bits ^= bits << 13;
        bits ^= bits >> 7;
        bits ^= bits << 17;
        if (check_lanes(bits)) return 1;
    }
    puts("65602 initialized-lane masks passed under Clang 23 MSan");
    return 0;
}
