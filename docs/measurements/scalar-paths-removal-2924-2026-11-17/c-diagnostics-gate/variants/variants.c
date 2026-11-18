// Experiment: the insertion path's variants, timed in one executable (env DIAG_VARIANT).
#include "unit_body.h"
static __attribute__((noinline, aligned(64))) void variant_a(DiagnosticOrder* items, uint32_t count)
{
    diagnostic_sort_scalar(items, count);
}
static __attribute__((noinline, aligned(64))) void variant_b(DiagnosticOrder* items, uint32_t count)
{
    for (uint32_t i = 1; i < count; i += 1)
    {
        const DiagnosticOrder value = items[i];
        const unsigned __int128 key = (unsigned __int128)value.source << 64 | value.sequence;
        uint32_t at = i;
        while (at != 0 && key < ((unsigned __int128)items[at - 1].source << 64 | items[at - 1].sequence))
        {
            items[at] = items[at - 1];
            at -= 1;
        }
        items[at] = value;
    }
}
static __attribute__((noinline, aligned(64))) void variant_c(DiagnosticOrder* items, uint32_t count, DiagnosticOrder* scratch)
{
    diagnostic_sort(items, count, scratch);
}
int main(void)
{
    static const uint32_t counts[] = { 32, 64, 128, 256, 320, 384 };
    static DiagnosticOrder input[4096], items[4096], scratch[4096];
    uint64_t seed = 153;
    for (uint32_t c = 0; c < 6; c += 1)
    {
        const uint32_t count = counts[c];
        for (uint32_t i = 0; i < count; i += 1)
        {
            input[i] = (DiagnosticOrder){ .source = diagnostic_test_random(&seed), .sequence = diagnostic_test_random(&seed), .record = i };
        }
        uint64_t best[3] = { UINT64_MAX, UINT64_MAX, UINT64_MAX };
        for (uint32_t pass = 0; pass < 31; pass += 1)
        {
            for (uint32_t v = 0; v < 3; v += 1)
            {
                const uint64_t start = diagnostic_benchmark_nanoseconds();
                for (uint32_t r = 0; r < 64; r += 1)
                {
                    memcpy(items, input, count * sizeof(DiagnosticOrder));
                    if (v == 0) variant_a(items, count); else if (v == 1) variant_b(items, count); else variant_c(items, count, scratch);
                }
                const uint64_t t = diagnostic_benchmark_nanoseconds() - start;
                best[v] = t < best[v] ? t : best[v];
            }
        }
        printf("%4u: insertion %.2f  int128 %.2f  diagnostic_sort %.2f ns/key\n", count, best[0] / 64.0 / count, best[1] / 64.0 / count, best[2] / 64.0 / count);
    }
    return 0;
}
