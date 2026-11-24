#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
bool old_side_initialize(void);
bool new_side_initialize(void);
void old_side_effects(const void*, uint64_t, uint64_t*, uint64_t*, uint16_t*);
void new_side_effects(const void*, uint64_t, uint64_t*, uint64_t*, uint16_t*);
int main(void)
{
    if (!old_side_initialize() || !new_side_initialize()) return 2;
    const uint32_t n = 1u << 21;
    uint8_t* data = calloc(n, 16);
    uint64_t x = 88172645463325252ull;
    for (uint32_t i = 0; i < n * 16; i += 1) { x ^= x << 13; x ^= x >> 7; x ^= x << 17; data[i] = (uint8_t)(x >> 24); }
    // Form numbers across every copy (the number field's 15 bits).
    for (uint32_t i = 0; i < n; i += 1) { uint16_t form = (uint16_t)((data[16 * i + 12] | data[16 * i + 13] << 8) & 0x7fff); data[16 * i + 12] = (uint8_t)form; data[16 * i + 13] = (uint8_t)(form >> 8); }
    uint64_t* r0 = malloc(n * 8ull); uint64_t* w0 = malloc(n * 8ull); uint64_t* r1 = malloc(n * 8ull); uint64_t* w1 = malloc(n * 8ull);
    uint16_t* o0 = calloc(n, 2); uint16_t* o1 = calloc(n, 2);
    static uint32_t differ[0x8000];
    for (uint32_t opm = 0; opm < 2; opm += 1)
    {
        old_side_effects(data, n, r0, w0, opm ? o0 : 0);
        new_side_effects(data, n, r1, w1, opm ? o1 : 0);
        for (uint32_t i = 0; i < n; i += 1)
        {
            if (r0[i] != r1[i] || w0[i] != w1[i] || o0[i] != o1[i]) differ[(data[16 * i + 12] | data[16 * i + 13] << 8)] += 1;
        }
    }
    uint32_t forms = 0, records = 0;
    for (uint32_t f = 0; f < 0x8000; f += 1) if (differ[f]) { printf("form %u differs in %u records\n", f, differ[f]); forms += 1; records += differ[f]; }
    printf("forms differing %u, records %u\n", forms, records);
    return 0;
}
