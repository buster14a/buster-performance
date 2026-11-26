#include <stdio.h>
#include <string.h>

#define COPY_SIZE(N) \
    struct __attribute__((packed)) Copy##N { \
        unsigned long words[(N) / 8]; \
        unsigned char tail[(N) % 8]; \
    }; \
    void copy_local_##N(struct Copy##N*, unsigned long); \
    void copy_cold_##N(struct Copy##N*, const struct Copy##N*); \
    static unsigned long bench_##N(int cold) \
    { \
        static struct Copy##N sources[64], results[64]; \
        unsigned long sum = 0; \
        for (unsigned i = 0; i < 64; ++i) { \
            for (unsigned j = 0; j < (N) / 8; ++j) { \
                sources[i].words[j] = i * 100 + j; \
            } \
        } \
        for (unsigned long i = 0; i < 20000000; ++i) { \
            unsigned slot = i % 64; \
            if (cold) { \
                copy_cold_##N(&results[slot], &sources[slot]); \
            } else { \
                copy_local_##N(&results[slot], i); \
            } \
            sum += results[slot].words[(N) / 8 - 1]; \
        } \
        return sum; \
    }
COPY_SIZE(64)
COPY_SIZE(128)
COPY_SIZE(256)

int main(int argc, char** argv)
{
    if (argc != 2) return 2;
    const char* workload = argv[1];
    size_t prefix = strcspn(workload, "-");
    if (workload[prefix] != '-') return 2;
    const int cold = strcmp(workload + prefix + 1, "cold") == 0;
    unsigned long sum;
    if (prefix == 2 && strncmp(workload, "64", 2) == 0) sum = bench_64(cold);
    else if (prefix == 3 && strncmp(workload, "128", 3) == 0) sum = bench_128(cold);
    else if (prefix == 3 && strncmp(workload, "256", 3) == 0) sum = bench_256(cold);
    else return 2;
    printf("%lu\n", sum);
    return 0;
}
