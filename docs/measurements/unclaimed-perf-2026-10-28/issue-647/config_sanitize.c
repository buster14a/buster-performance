#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#define BUSTER_LANE_CPU_MASK_WORDS 16
#define BUSTER_ARRAY_LENGTH(x) (sizeof(x)/sizeof((x)[0]))
typedef struct StreamTestTally { uint64_t checks, failures; } StreamTestTally;
static bool stream_test_expect(StreamTestTally* t, bool ok, const char* what, const char* detail)
{
 t->checks+=1; t->failures+=!ok;
 if(!ok) printf("%s %s\n",what,detail!=0?detail:"");
 return ok;
}
typedef struct StreamBenchmarkCpus StreamBenchmarkCpus;
struct StreamBenchmarkCpus
{
    uint32_t allowed_count;
    uint32_t lanes;
    uint32_t writer[2];
    bool writer_available;
};

static bool stream_benchmark_cpu_allowed(const uint64_t* allowed, uint32_t cpu)
{
    return cpu < BUSTER_LANE_CPU_MASK_WORDS * 64 && (allowed[cpu / 64] >> (cpu % 64) & 1) != 0;
}

// --cpus is exactly two bounded decimal CPU IDs. Reject a missing second number, trailing text and overflow.
static bool stream_benchmark_parse_cpus(const char* text, uint32_t* cpus)
{
    bool result = true;
    for (uint32_t part = 0; result && part < 2; part += 1)
    {
        uint32_t cpu = 0;
        const char* begin = text;
        while (result && *text >= '0' && *text <= '9')
        {
            cpu = cpu * 10 + (uint32_t)(*text - '0');
            text += 1;
            result = cpu < BUSTER_LANE_CPU_MASK_WORDS * 64;
        }
        result = result && text != begin && *text == (part == 0 ? ',' : 0);
        cpus[part] = cpu;
        text += result && part == 0;
    }
    return result;
}

// Select only within the inherited affinity. Explicit writer CPUs may not widen a taskset/cpuset placement.
// The CI caller chooses one CPU per physical core; the benchmark itself counts the allowed logical CPUs.
static StreamBenchmarkCpus stream_benchmark_cpus(const uint64_t* allowed, uint32_t requested, const uint32_t* writer)
{
    StreamBenchmarkCpus result = { .writer = { BUSTER_LANE_CPU_MASK_WORDS * 64, BUSTER_LANE_CPU_MASK_WORDS * 64 } };
    for (uint32_t word = 0; word < BUSTER_LANE_CPU_MASK_WORDS; word += 1)
    {
        for (uint64_t bits = allowed[word]; bits != 0; bits &= bits - 1)
        {
            if (result.allowed_count < 2)
            {
                result.writer[result.allowed_count] = word * 64 + (uint32_t)__builtin_ctzll(bits);
            }
            result.allowed_count += 1;
        }
    }
    result.lanes = requested < result.allowed_count ? requested : result.allowed_count;
    if (writer != 0)
    {
        result.writer[0] = writer[0];
        result.writer[1] = writer[1];
    }
    result.writer_available = result.writer[0] != result.writer[1] && stream_benchmark_cpu_allowed(allowed, result.writer[0]) &&
                              stream_benchmark_cpu_allowed(allowed, result.writer[1]);
    return result;
}


#include "/home/david/Documents/Codex/2026-10-28/solv/work/issue-647/src/buster/compiler/streaming_benchmark_test.c"
int main(void)
{
 StreamTestTally tally={0}; stream_benchmark_test_cpus(&tally); printf("CPU fixtures: %llu checks, %llu failures\n",(unsigned long long)tally.checks,(unsigned long long)tally.failures); return tally.failures!=0;
}
