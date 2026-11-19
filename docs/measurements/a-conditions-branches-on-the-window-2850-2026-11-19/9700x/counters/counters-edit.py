#!/usr/bin/env python3
# counters-edit.py TREE: an experiment's counters around C on the window's loop (not for a pull request): user
# instructions, cycles, and the loads and stores the core dispatches (AMD's LS Dispatch, PMCx029), read as one group
# before and after each of the loop's two runs of a chunk, and around nothing once a chunk (the reads' own share). The
# sums are printed when the process ends.
import sys
p = sys.argv[1] + '/src/buster/compiler/c_check_node_machine_window.c'
t = open(p).read()
def rep(old, new, count=1):
    global t
    assert t.count(old) == count, (t.count(old), old[:90])
    t = t.replace(old, new)
rep("""static void node_contexts_tables(NodeContextsTables* tables)
{
""", """// EXPERIMENT: counters around the loop.
#include <linux/perf_event.h>
#include <sys/syscall.h>
static int node_loop_x_group = -1;
static uint64_t node_loop_x_sums[3][4];
static uint64_t node_loop_x_blocks;
static uint64_t node_loop_x_chunks;
static uint64_t node_loop_x_records;

static int node_loop_x_open(uint32_t type, uint64_t config, int group)
{
    struct perf_event_attr attributes;
    memset(&attributes, 0, sizeof(attributes));
    attributes.type = type;
    attributes.size = sizeof(attributes);
    attributes.config = config;
    attributes.exclude_kernel = 1;
    attributes.exclude_hv = 1;
    attributes.read_format = PERF_FORMAT_GROUP;
    return (int)syscall(SYS_perf_event_open, &attributes, 0, -1, group, 0);
}

__attribute__((constructor)) static void node_loop_x_begin(void)
{
    node_loop_x_group = node_loop_x_open(PERF_TYPE_HARDWARE, PERF_COUNT_HW_INSTRUCTIONS, -1);
    if (node_loop_x_group >= 0)
    {
        const int cycles = node_loop_x_open(PERF_TYPE_HARDWARE, PERF_COUNT_HW_CPU_CYCLES, node_loop_x_group);
        const int loads = node_loop_x_open(PERF_TYPE_RAW, 0x0129, node_loop_x_group);
        const int stores = node_loop_x_open(PERF_TYPE_RAW, 0x0229, node_loop_x_group);
        if (cycles < 0 || loads < 0 || stores < 0)
        {
            fprintf(stderr, "node-loop-x: a counter did not open (%d %d %d)\\n", cycles, loads, stores);
            node_loop_x_group = -1;
        }
    }
}

static inline __attribute__((always_inline)) void node_loop_x_read(uint64_t values[5])
{
    memset(values, 0, 5 * sizeof(uint64_t));
    if (node_loop_x_group >= 0 && read(node_loop_x_group, values, 5 * sizeof(uint64_t)) != (ssize_t)(5 * sizeof(uint64_t)))
    {
        memset(values, 0, 5 * sizeof(uint64_t));
    }
}

__attribute__((destructor)) static void node_loop_x_end(void)
{
    static const char* const names[3] = { "first-run", "second-run", "no-run" };
    for (uint32_t run = 0; node_loop_x_blocks != 0 && run < 3; run += 1)
    {
        fprintf(stderr, "node-loop-x: %s chunks=%" PRIu64 " blocks=%" PRIu64 " records=%" PRIu64 " instructions=%" PRIu64 " cycles=%" PRIu64 " loads=%" PRIu64 " stores=%" PRIu64 "\\n",
                names[run], node_loop_x_chunks, node_loop_x_blocks, node_loop_x_records, node_loop_x_sums[run][0], node_loop_x_sums[run][1], node_loop_x_sums[run][2],
                node_loop_x_sums[run][3]);
    }
}

static void node_contexts_tables(NodeContextsTables* tables)
{
""")
rep("""    const uint64_t t0 = __rdtsc();
    NodeContextsLoopCounts loop_counts = { 0 };
    node_contexts_window_loop(state, front, count, &loop_counts);
    const uint64_t t1 = __rdtsc();
""", """    uint64_t x[6][5];
    node_loop_x_read(x[4]);
    node_loop_x_read(x[5]);
    const uint64_t t0 = __rdtsc();
    NodeContextsLoopCounts loop_counts = { 0 };
    node_loop_x_read(x[0]);
    node_contexts_window_loop(state, front, count, &loop_counts);
    node_loop_x_read(x[1]);
    const uint64_t t1 = __rdtsc();
""")
rep("""    NodeContextsLoopCounts again = { 0 };
    node_contexts_window_loop(state, front, count, &again);
    const uint64_t t4 = __rdtsc();
""", """    NodeContextsLoopCounts again = { 0 };
    node_loop_x_read(x[2]);
    node_contexts_window_loop(state, front, count, &again);
    node_loop_x_read(x[3]);
    const uint64_t t4 = __rdtsc();
    for (uint32_t i = 0; i < 4; i += 1)
    {
        node_loop_x_sums[0][i] += x[1][i + 1] - x[0][i + 1];
        node_loop_x_sums[1][i] += x[3][i + 1] - x[2][i + 1];
        node_loop_x_sums[2][i] += x[5][i + 1] - x[4][i + 1];
    }
    node_loop_x_blocks += (count + 63) / 64;
    node_loop_x_chunks += 1;
    node_loop_x_records += count;
""")
open(p, 'w').write(t)
