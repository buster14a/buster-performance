#include <immintrin.h>
#include <stdint.h>
#include <stdio.h>

typedef uint32_t Kernel(const uint8_t*, uint64_t, __m512i, const uint32_t*, uint32_t);
extern Kernel baseline;
extern Kernel final;
static uint8_t source[1 << 18];
static uint32_t rows[256][16] __attribute__((aligned(64)));

static uint64_t ticks(void)
{
    _mm_lfence();
    const uint64_t t = __rdtsc();
    _mm_lfence();
    return t;
}

static uint64_t measure(Kernel* kernel, uint64_t length, unsigned valid)
{
    unsigned sum = 0;
    const uint64_t begin = ticks();
    for (unsigned trial = 0; trial < 2048; trial += 1)
    {
        const uint32_t* starts = rows[trial % 256];
        sum += kernel(source, length, _mm512_loadu_si512(starts), starts, valid);
    }
    const uint64_t elapsed = ticks() - begin;
    asm volatile("" :: "r"(sum));
    return elapsed;
}

int main(void)
{
    static const char bytes[] = "A\rB\nC\vDEFGHIJKLMNOPQRST";
    for (unsigned i = 0; i < sizeof(source); i += 1)
    {
        source[i] = bytes[(i * 43u ^ (i >> 3)) % 21];
    }
    puts("lanes\tstride\tedge\tround\tbase\thead\tcontrol");
    const unsigned strides[] = { 5, 64, 127, 128, 129, 165, 4097 };
    for (unsigned lanes = 1; lanes <= 16; lanes += 1)
    {
        const unsigned valid = (1u << lanes) - 1;
        for (unsigned k = 0; k < sizeof(strides) / sizeof(*strides); k += 1)
        {
            const unsigned stride = strides[k];
            for (unsigned edge = 0; edge < 3; edge += 1)
            {
                const size_t length = edge == 2 ? (lanes - 1) * stride + 33 : sizeof(source);
                for (unsigned row = 0; row < 256; row += 1)
                {
                    const unsigned first = edge == 0 ? 1024 + row * 257 : edge == 1 ? row % 4 : 32;
                    unsigned expected = 0;
                    for (unsigned lane = 0; lane < lanes; lane += 1)
                    {
                        const unsigned start = first + lane * stride;
                        rows[row][lane] = start;
                        expected |= (unsigned)(start != 0 && (source[start - 1] == '\n' || source[start - 1] == '\r')) << lane;
                    }
                    const uint32_t* starts = rows[row];
                    const __m512i vector = _mm512_loadu_si512(starts);
                    if (baseline(source, length, vector, starts, valid) != expected || final(source, length, vector, starts, valid) != expected)
                    {
                        return 1;
                    }
                }
                for (unsigned round = 0; round < 9; round += 1)
                {
                    uint64_t b, h;
                    if (round % 2 == 0)
                    {
                        b = measure(baseline, length, valid);
                        h = measure(final, length, valid);
                    }
                    else
                    {
                        h = measure(final, length, valid);
                        b = measure(baseline, length, valid);
                    }
                    const uint64_t control = measure(baseline, length, valid);
                    printf("%u\t%u\t%u\t%u\t%lu\t%lu\t%lu\n", lanes, stride, edge, round, b, h, control);
                }
            }
        }
    }
    return 0;
}
