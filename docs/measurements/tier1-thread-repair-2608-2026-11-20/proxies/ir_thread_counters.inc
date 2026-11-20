// TEMPORARY (#2608 measurement, never committed): the threading pass's work, summed over a process and appended to
// the file BUSTER_THREAD_COUNTERS names at its exit. BUSTER_THREAD_MODE=main turns the repair off.
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>

#define IR_THREAD_COUNTERS(X) \
    X(calls) X(attempts) X(cfgs) X(cfg_blocks) X(cfg_instructions) X(candidates) X(scan1) X(scan1_instructions) \
    X(escaping) X(repairable) X(decided) X(untested) X(selected) X(analyses) X(analysis_blocks) X(scan2) X(scan2_instructions) \
    X(walks) X(walk_steps) X(walk_budget) X(header_walks) X(header_steps) X(headers) X(retreating) X(backward) X(header_missed) X(false_refusal) X(changed_rounds) X(blocks) X(copies) X(redirects) X(merges) \
    X(merges_tested) X(merges_truth) X(merges_truth_untested) X(rewrite_instructions) X(deferred_roles) X(deferred_repair) X(deferred_copy_phi) \
    X(ns_total) X(ns_cfg) X(ns_repairs) X(ns_rewrite)

enum
{
#define IR_THREAD_ENUM(n) IR_THREAD_K_##n,
    IR_THREAD_COUNTERS(IR_THREAD_ENUM)
#undef IR_THREAD_ENUM
    IR_THREAD_K_COUNT,
};

static const char* const ir_thread_counter_names[IR_THREAD_K_COUNT] = {
#define IR_THREAD_NAME(n) #n,
    IR_THREAD_COUNTERS(IR_THREAD_NAME)
#undef IR_THREAD_NAME
};

static uint64_t ir_thread_counters[IR_THREAD_K_COUNT];
static uint32_t ir_thread_mode_main;
static uint32_t ir_thread_mode_nocopy;

#define IR_THREAD_COUNT(k, n) __atomic_fetch_add(&ir_thread_counters[IR_THREAD_K_##k], (uint64_t)(n), __ATOMIC_RELAXED)

static uint64_t ir_thread_now(void)
{
    struct timespec t;
    clock_gettime(CLOCK_THREAD_CPUTIME_ID, &t);
    return (uint64_t)t.tv_sec * 1000000000u + (uint64_t)t.tv_nsec;
}

__attribute__((constructor)) static void ir_thread_counters_start(void)
{
    const char* mode = getenv("BUSTER_THREAD_MODE");
    ir_thread_mode_main = mode != NULL && strcmp(mode, "main") == 0;
    ir_thread_mode_nocopy = mode != NULL && strcmp(mode, "nocopy") == 0;
}

__attribute__((destructor)) static void ir_thread_counters_print(void)
{
    const char* path = getenv("BUSTER_THREAD_COUNTERS");
    if (path != NULL)
    {
        char text[4096];
        int length = 0;
        for (uint32_t k = 0; k < IR_THREAD_K_COUNT; k += 1)
        {
            length += snprintf(text + length, sizeof(text) - (uint64_t)length, "%s=%llu\n", ir_thread_counter_names[k], (unsigned long long)ir_thread_counters[k]);
        }
        const int fd = open(path, O_WRONLY | O_CREAT | O_APPEND, 0644);
        if (fd >= 0)
        {
            ssize_t written = write(fd, text, (size_t)length);
            (void)written;
            close(fd);
        }
    }
}
