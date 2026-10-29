// thprace: what first writes into fresh anonymous memory cost when several threads make them at once, on this host
// (#764). Each round maps fresh memory, pins one thread per CPU of --cpus, lets every thread spin for --spin ms (the
// powersave CPUs reach their clock) and releases them together at a barrier; each thread then times its own writes.
//
//   thprace [--cpus LIST] [--rounds N] [--spin MS] [--keep] MODE...
//
// With --keep, a mode's rounds keep their memory until the mode ends, so that each round's huge pages come from the
// allocator's free lists rather than the pages the round before freed on the same CPU, which the CPU cleared last and
// may still have in its caches (a race's losers still free theirs).
//
// MODE is one of:
//   distinct       every thread writes a byte into a fresh 2 MB huge-page region of its own, all at once (with one CPU in
//                  --cpus, one thread alone)
//   same           every thread writes a byte (each in a 4 KB page of its own) into one fresh region, all at once
//   same-zero      the same, after the first thread read the region (the huge zero page is mapped there)
//   distinct-zero  distinct, after the first thread read every region
//   base-same      base pages (MADV_NOHUGEPAGE): every thread writes 16 pages of its own of one fresh 2 MB range
//   base-same-zero the same, after the first thread read all 512 pages (each maps the zero page)
//
// For each mode it prints the medians over the rounds of each thread's time (from the release to its last write) and
// of the slowest thread's, the slowest round, and per round the kernel's counters: /proc/vmstat's thp_fault_alloc,
// pgalloc_normal (pages allocated, a huge page's 512 among them), thp_fault_fallback and thp_split_pmd, and
// /proc/interrupts' TLB shootdowns and function call interrupts, summed over the CPUs.
#define _GNU_SOURCE
#include <errno.h>
#include <pthread.h>
#include <sched.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <time.h>

#define THPRACE_MAX_THREADS 16
#define THPRACE_MAX_ROUNDS 512
#define THPRACE_HUGE (UINT64_C(2) << 20)
#define THPRACE_PAGE (UINT64_C(4) << 10)

typedef enum Mode
{
    MODE_DISTINCT,
    MODE_SAME,
    MODE_SAME_ZERO,
    MODE_DISTINCT_ZERO,
    MODE_BASE_SAME,
    MODE_BASE_SAME_ZERO,
    MODE_COUNT,
} Mode;

static const char* const mode_names[MODE_COUNT] = { "distinct", "same", "same-zero", "distinct-zero", "base-same", "base-same-zero" };

typedef struct Shared
{
    Mode mode;
    uint32_t threads;
    uint32_t cpus[THPRACE_MAX_THREADS];
    uint64_t spin_ns;
    uint8_t* regions;
    // The rounds' barrier, by counts that only grow: the first thread sets `ready` to a round's number + 1 once its
    // memory is mapped and `release` once every worker arrived; the workers count their arrivals and their ends.
    uint32_t ready;
    uint32_t release;
    uint32_t arrived;
    uint32_t finished;
    bool stop;
    uint64_t done_ns[THPRACE_MAX_THREADS];
} Shared;

static uint64_t now_ns(void)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC_RAW, &t);
    return (uint64_t)t.tv_sec * 1000000000u + (uint64_t)t.tv_nsec;
}

static bool pin(uint32_t cpu)
{
    cpu_set_t set;
    CPU_ZERO(&set);
    CPU_SET(cpu, &set);
    return sched_setaffinity(0, sizeof(set), &set) == 0;
}

static void spin_for(uint64_t nanoseconds)
{
    const uint64_t end = now_ns() + nanoseconds;
    while (now_ns() < end)
    {
        __builtin_ia32_pause();
    }
}

// The writes thread `index` makes in a round of `mode`.
static void writes(Shared* shared, uint32_t index)
{
    uint8_t* regions = shared->regions;
    switch (shared->mode)
    {
        case MODE_DISTINCT:
        case MODE_DISTINCT_ZERO:
            ((volatile uint8_t*)regions)[(uint64_t)index * THPRACE_HUGE + 64] = 1;
            break;
        case MODE_SAME:
        case MODE_SAME_ZERO:
            ((volatile uint8_t*)regions)[(uint64_t)index * THPRACE_PAGE + 64] = 1;
            break;
        case MODE_BASE_SAME:
        case MODE_BASE_SAME_ZERO:
            for (uint32_t k = 0; k < 16; k += 1)
            {
                ((volatile uint8_t*)regions)[((uint64_t)k * shared->threads + index) * THPRACE_PAGE + 64] = 1;
            }
            break;
        default:
            break;
    }
}

// Waits until `*count` reaches `value` or the run stops: whether it reached it.
static bool wait_for(Shared* shared, const uint32_t* count, uint32_t value)
{
    while (__atomic_load_n(count, __ATOMIC_ACQUIRE) < value && !__atomic_load_n(&shared->stop, __ATOMIC_ACQUIRE))
    {
        __builtin_ia32_pause();
    }
    return __atomic_load_n(count, __ATOMIC_ACQUIRE) >= value;
}

static void* worker(void* argument)
{
    Shared* shared = argument;
    static uint32_t next = 1;
    const uint32_t index = __atomic_fetch_add(&next, 1, __ATOMIC_ACQ_REL);
    pin(shared->cpus[index]);
    for (uint32_t round = 0; wait_for(shared, &shared->ready, round + 1); round += 1)
    {
        __atomic_fetch_add(&shared->arrived, 1, __ATOMIC_ACQ_REL);
        spin_for(shared->spin_ns);
        if (!wait_for(shared, &shared->release, round + 1))
        {
            break;
        }
        writes(shared, index);
        shared->done_ns[index] = now_ns();
        __atomic_fetch_add(&shared->finished, 1, __ATOMIC_ACQ_REL);
    }
    return 0;
}

static long vmstat(const char* name)
{
    FILE* file = fopen("/proc/vmstat", "r");
    char key[128];
    long value = -1;
    long v;
    while (file != NULL && fscanf(file, "%127s %ld", key, &v) == 2)
    {
        if (strcmp(key, name) == 0)
        {
            value = v;
        }
    }
    if (file != NULL)
    {
        fclose(file);
    }
    return value;
}

// The sum over the CPUs of /proc/interrupts' row `name` (TLB, CAL).
static long interrupts(const char* name)
{
    FILE* file = fopen("/proc/interrupts", "r");
    char line[8192];
    long total = -1;
    while (file != NULL && fgets(line, sizeof(line), file) != NULL)
    {
        char* p = line;
        while (*p == ' ')
        {
            p += 1;
        }
        const size_t length = strlen(name);
        if (strncmp(p, name, length) == 0 && p[length] == ':')
        {
            total = 0;
            p += length + 1;
            for (;;)
            {
                char* end = 0;
                const long value = strtol(p, &end, 10);
                if (end == p)
                {
                    break;
                }
                total += value;
                p = end;
            }
        }
    }
    if (file != NULL)
    {
        fclose(file);
    }
    return total;
}

static int compare_u64(const void* a, const void* b)
{
    const uint64_t x = *(const uint64_t*)a;
    const uint64_t y = *(const uint64_t*)b;
    return x < y ? -1 : x > y;
}

static uint64_t median(uint64_t* values, uint32_t count)
{
    qsort(values, count, sizeof(uint64_t), compare_u64);
    return count == 0 ? 0 : values[count / 2];
}

int main(int argc, char** argv)
{
    static Shared shared;
    uint32_t cpus[THPRACE_MAX_THREADS] = { 2, 0, 1, 3, 4, 5, 6, 7 };
    uint32_t threads = 8;
    uint32_t rounds = 64;
    uint64_t spin_ms = 3;
    bool keep = false;
    Mode modes[MODE_COUNT];
    uint32_t mode_count = 0;
    bool valid = true;
    for (int i = 1; valid && i < argc; i += 1)
    {
        if (strcmp(argv[i], "--cpus") == 0 && i + 1 < argc)
        {
            threads = 0;
            for (char* p = argv[++i]; *p != 0 && threads < THPRACE_MAX_THREADS;)
            {
                char* end = 0;
                cpus[threads++] = (uint32_t)strtoul(p, &end, 10);
                valid &= end != p;
                p = *end == ',' ? end + 1 : end;
                if (end == p && *end != 0)
                {
                    valid = false;
                    break;
                }
            }
        }
        else if (strcmp(argv[i], "--rounds") == 0 && i + 1 < argc)
        {
            rounds = (uint32_t)strtoul(argv[++i], 0, 10);
            valid &= rounds >= 1 && rounds <= THPRACE_MAX_ROUNDS;
        }
        else if (strcmp(argv[i], "--spin") == 0 && i + 1 < argc)
        {
            spin_ms = strtoull(argv[++i], 0, 10);
        }
        else if (strcmp(argv[i], "--keep") == 0)
        {
            keep = true;
        }
        else
        {
            bool found = false;
            for (uint32_t m = 0; m < MODE_COUNT; m += 1)
            {
                if (strcmp(argv[i], mode_names[m]) == 0 && mode_count < MODE_COUNT)
                {
                    modes[mode_count++] = (Mode)m;
                    found = true;
                }
            }
            valid &= found;
        }
    }
    if (!valid || mode_count == 0 || threads == 0)
    {
        fprintf(stderr, "usage: thprace [--cpus LIST] [--rounds N] [--spin MS] [--keep] MODE...\n");
        return 1;
    }
    shared.threads = threads;
    memcpy(shared.cpus, cpus, sizeof(cpus));
    shared.spin_ns = spin_ms * 1000000u;
    if (!pin(cpus[0]))
    {
        fprintf(stderr, "thprace: can't pin to CPU %u: %s\n", cpus[0], strerror(errno));
        return 1;
    }
    pthread_t workers[THPRACE_MAX_THREADS];
    for (uint32_t i = 1; i < threads; i += 1)
    {
        if (pthread_create(&workers[i], 0, worker, &shared) != 0)
        {
            fprintf(stderr, "thprace: can't start a thread\n");
            return 1;
        }
    }
    printf("thprace: threads=%u cpus=", threads);
    for (uint32_t i = 0; i < threads; i += 1)
    {
        printf(i == 0 ? "%u" : ",%u", cpus[i]);
    }
    printf(" rounds=%u spin=%llu ms%s\n", rounds, (unsigned long long)spin_ms, keep ? " keep" : "");
    int status = 0;
    uint32_t total_rounds = 0;
    for (uint32_t m = 0; m < mode_count; m += 1)
    {
        const Mode mode = modes[m];
        shared.mode = mode;
        const bool base = mode == MODE_BASE_SAME || mode == MODE_BASE_SAME_ZERO;
        static uint64_t per_thread[THPRACE_MAX_ROUNDS * THPRACE_MAX_THREADS];
        static uint64_t slowest[THPRACE_MAX_ROUNDS];
        static uint64_t first[THPRACE_MAX_ROUNDS];
        static uint8_t* kept[THPRACE_MAX_ROUNDS];
        uint32_t samples = 0;
        uint64_t worst = 0;
        long counters[6] = { 0 };
        const char* const names[4] = { "thp_fault_alloc", "pgalloc_normal", "thp_fault_fallback", "thp_split_pmd" };
        for (uint32_t round = 0; round < rounds; round += 1)
        {
            // Fresh memory: a region per thread (and room to align them), advised before anything touches it.
            const uint64_t bytes = (uint64_t)(threads + 1) * THPRACE_HUGE;
            uint8_t* raw = mmap(0, bytes + THPRACE_HUGE, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
            if (raw == MAP_FAILED)
            {
                fprintf(stderr, "thprace: mmap failed: %s\n", strerror(errno));
                return 1;
            }
            uint8_t* regions = (uint8_t*)(((uintptr_t)raw + THPRACE_HUGE - 1) & ~(uintptr_t)(THPRACE_HUGE - 1));
            madvise(regions, bytes, base ? MADV_NOHUGEPAGE : MADV_HUGEPAGE);
            volatile uint64_t sink = 0;
            if (mode == MODE_SAME_ZERO)
            {
                sink += ((volatile uint8_t*)regions)[64];
            }
            else if (mode == MODE_DISTINCT_ZERO)
            {
                for (uint32_t i = 0; i < threads; i += 1)
                {
                    sink += ((volatile uint8_t*)regions)[(uint64_t)i * THPRACE_HUGE + 64];
                }
            }
            else if (mode == MODE_BASE_SAME_ZERO)
            {
                for (uint64_t offset = 0; offset < THPRACE_HUGE; offset += THPRACE_PAGE)
                {
                    sink += ((volatile uint8_t*)regions)[offset + 64];
                }
            }
            (void)sink;
            shared.regions = regions;
            long before[6];
            for (uint32_t c = 0; c < 4; c += 1)
            {
                before[c] = vmstat(names[c]);
            }
            before[4] = interrupts("TLB");
            before[5] = interrupts("CAL");
            // Every worker arrives and spins; the first thread spins as long, then releases them.
            const uint32_t workers_count = threads - 1;
            __atomic_store_n(&shared.ready, total_rounds + 1, __ATOMIC_RELEASE);
            while (__atomic_load_n(&shared.arrived, __ATOMIC_ACQUIRE) < (total_rounds + 1) * workers_count)
            {
                __builtin_ia32_pause();
            }
            // The workers spin for as long from their arrival; one more millisecond lets the last of them finish.
            spin_for(shared.spin_ns + 1000000);
            const uint64_t released = now_ns();
            __atomic_store_n(&shared.release, total_rounds + 1, __ATOMIC_RELEASE);
            writes(&shared, 0);
            shared.done_ns[0] = now_ns();
            while (__atomic_load_n(&shared.finished, __ATOMIC_ACQUIRE) < (total_rounds + 1) * workers_count)
            {
                __builtin_ia32_pause();
            }
            total_rounds += 1;
            long after[6];
            for (uint32_t c = 0; c < 4; c += 1)
            {
                after[c] = vmstat(names[c]);
            }
            after[4] = interrupts("TLB");
            after[5] = interrupts("CAL");
            for (uint32_t c = 0; c < 6; c += 1)
            {
                counters[c] += after[c] - before[c];
            }
            uint64_t round_worst = 0;
            for (uint32_t i = 0; i < threads; i += 1)
            {
                const uint64_t t = shared.done_ns[i] - released;
                per_thread[samples++] = t;
                round_worst = t > round_worst ? t : round_worst;
            }
            first[round] = shared.done_ns[0] - released;
            slowest[round] = round_worst;
            worst = round_worst > worst ? round_worst : worst;
            if (keep)
            {
                kept[round] = raw;
            }
            else
            {
                munmap(raw, bytes + THPRACE_HUGE);
            }
        }
        for (uint32_t round = 0; keep && round < rounds; round += 1)
        {
            munmap(kept[round], (uint64_t)(threads + 2) * THPRACE_HUGE);
        }
        const uint64_t thread_median = median(per_thread, samples);
        const uint64_t slowest_median = median(slowest, rounds);
        const uint64_t first_median = median(first, rounds);
        printf("%-15s thread=%7.1f us first=%7.1f us slowest=%7.1f us worst=%7.1f us | per round: thp_fault_alloc=%.2f pgalloc_normal=%.1f "
               "thp_fault_fallback=%.2f thp_split_pmd=%.2f TLB=%.2f CAL=%.2f\n",
               mode_names[mode], thread_median / 1e3, first_median / 1e3, slowest_median / 1e3, worst / 1e3, (double)counters[0] / rounds,
               (double)counters[1] / rounds, (double)counters[2] / rounds, (double)counters[3] / rounds, (double)counters[4] / rounds,
               (double)counters[5] / rounds);
        fflush(stdout);
    }
    __atomic_store_n(&shared.stop, true, __ATOMIC_RELEASE);
    for (uint32_t i = 1; i < threads; i += 1)
    {
        pthread_join(workers[i], 0);
    }
    return status;
}
