// Experiment (#2959): the radix sort's rate by where its two arrays sit. One buffer, 64-byte aligned; `items` at
// offset A and `scratch` at A + 98,304 (4,096 records) + DELTA; best of 31 passes of 32 sorts at 384 and 4,096 records.
#include "unit_body.h"
static __attribute__((noinline, aligned(64))) void radix(DiagnosticOrder* items, uint32_t count, DiagnosticOrder* scratch)
{
    diagnostic_sort(items, count, scratch);
}
int main(void)
{
    static _Alignas(4096) uint8_t buffer[1 << 20];
    static DiagnosticOrder input[4096];
    static const uint32_t starts[] = { 0, 8, 16, 32, 40, 64 };
    static const int32_t deltas[] = { 0, 8, 64, 192, 1024, 2048, 2056, -8 };
    uint64_t seed = 153;
    for (uint32_t i = 0; i < 4096; i += 1)
    {
        input[i] = (DiagnosticOrder){ .source = diagnostic_test_random(&seed), .sequence = diagnostic_test_random(&seed), .record = i };
    }
    for (uint32_t s = 0; s < 6; s += 1)
    {
        for (uint32_t d = 0; d < 8; d += 1)
        {
            DiagnosticOrder* items = (DiagnosticOrder*)(buffer + starts[s]);
            DiagnosticOrder* scratch = (DiagnosticOrder*)(buffer + starts[s] + 98304 + 8192 + deltas[d]);
            double rate[2];
            const uint32_t counts[2] = { 384, 4096 };
            for (uint32_t c = 0; c < 2; c += 1)
            {
                uint64_t best = UINT64_MAX;
                for (uint32_t pass = 0; pass < 31; pass += 1)
                {
                    const uint64_t start = diagnostic_benchmark_nanoseconds();
                    for (uint32_t r = 0; r < 32; r += 1)
                    {
                        memcpy(items, input, counts[c] * sizeof(DiagnosticOrder));
                        radix(items, counts[c], scratch);
                    }
                    const uint64_t t = diagnostic_benchmark_nanoseconds() - start;
                    best = t < best ? t : best;
                }
                rate[c] = best / 32.0 / counts[c];
            }
            printf("items +%2u, scratch at +8192%+5d past items' end: 384 %.2f, 4096 %.2f ns/key\n", starts[s], deltas[d], rate[0], rate[1]);
        }
    }
    return 0;
}
