#include <immintrin.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

typedef uint32_t Kernel(const uint64_t*, uint32_t, uint32_t*);
extern Kernel base;
extern Kernel head;
static uint64_t words[513];
static uint32_t out[513 * 64];
static uint32_t expected[513 * 64];
static uint64_t random_state = 451;

static uint64_t next(void)
{
    random_state ^= random_state << 13;
    random_state ^= random_state >> 7;
    random_state ^= random_state << 17;
    return random_state;
}

static uint64_t ticks(void)
{
    _mm_lfence();
    const uint64_t value = __rdtsc();
    _mm_lfence();
    return value;
}

static uint64_t measure(Kernel* kernel, unsigned n, unsigned repeats)
{
    const uint64_t begin = ticks();
    for (unsigned i = 0; i < repeats; i += 1)
    {
        kernel(words, n, out);
    }
    return ticks() - begin;
}

int main(void)
{
    const unsigned sizes[] = { 1, 8, 9, 512 };
    puts("words\tbits\tround\tbase_ticks\thead_ticks\tcontrol_ticks\trepeats");
    for (unsigned s = 0; s < sizeof(sizes) / sizeof(sizes[0]); s += 1)
    {
        const unsigned n = sizes[s];
        const unsigned repeats = 6000 / n + 40;
        for (unsigned bits = 0; bits <= 64; bits += 1)
        {
            for (unsigned w = 0; w < n; w += 1)
            {
                uint64_t mask = 0;
                while ((unsigned)__builtin_popcountll(mask) != bits)
                {
                    mask |= UINT64_C(1) << (next() % 64);
                }
                words[w] = mask;
            }
            const uint32_t count = base(words, n, expected);
            if (count != n * bits || head(words, n, out) != count || memcmp(out, expected, count * sizeof(*out)) != 0)
            {
                return 1;
            }
            for (unsigned round = 0; round < 9; round += 1)
            {
                uint64_t base_ticks;
                uint64_t head_ticks;
                if (round % 2 != 0)
                {
                    head_ticks = measure(head, n, repeats);
                    base_ticks = measure(base, n, repeats);
                }
                else
                {
                    base_ticks = measure(base, n, repeats);
                    head_ticks = measure(head, n, repeats);
                }
                const uint64_t control = measure(base, n, repeats);
                printf("%u\t%u\t%u\t%lu\t%lu\t%lu\t%u\n", n, bits, round, base_ticks, head_ticks, control, repeats);
            }
        }
    }
    return 0;
}
