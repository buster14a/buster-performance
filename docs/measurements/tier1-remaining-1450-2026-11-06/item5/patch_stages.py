#!/usr/bin/env python3
# Temporary measurement patch for #1450 item 5 (not committed): exact user-mode instruction counts per Tier 1
# stage, from a per-thread perf_event_open counter read at each boundary of check_tier1_compile. Bucket 0 is
# everything outside it (front end, Tier 0, encoding, writing). Printed on stderr at exit.
import sys
path = sys.argv[1]
s = open(path).read()
helpers = r'''
#include <linux/perf_event.h>
#include <sys/syscall.h>
#include <unistd.h>
static __thread int tmp_stage_fd = -2;
static __thread uint64_t tmp_stage_last;
static uint64_t tmp_stage_counts[16];
static const char* const tmp_stage_names[16] = { "outside", "lower", "inline", "promote", "wide+truth", "optimize", "analysis", "select", "emit", "publish" };
static uint64_t tmp_stage_read(void)
{
    if (tmp_stage_fd == -2)
    {
        struct perf_event_attr attr;
        memset(&attr, 0, sizeof(attr));
        attr.size = sizeof(attr);
        attr.type = PERF_TYPE_HARDWARE;
        attr.config = PERF_COUNT_HW_INSTRUCTIONS;
        attr.exclude_kernel = 1;
        attr.exclude_hv = 1;
        tmp_stage_fd = (int)syscall(SYS_perf_event_open, &attr, 0, -1, -1, 0);
    }
    uint64_t value = 0;
    if (tmp_stage_fd >= 0 && read(tmp_stage_fd, &value, sizeof(value)) != (ssize_t)sizeof(value))
    {
        value = 0;
    }
    return value;
}
static void tmp_stage_mark(uint32_t stage)
{
    const uint64_t now = tmp_stage_read();
    __atomic_fetch_add(&tmp_stage_counts[stage], now - tmp_stage_last, __ATOMIC_RELAXED);
    tmp_stage_last = now;
}
static __attribute__((destructor)) void tmp_stage_print(void)
{
    if (tmp_stage_counts[1] != 0)
    {
        for (uint32_t i = 1; i < 10; i += 1)
        {
            fprintf(stderr, "tier1-stage\t%s\t%llu\n", tmp_stage_names[i], (unsigned long long)tmp_stage_counts[i]);
        }
    }
}
'''
def insert_before(s, anchor, text, count=1):
    assert s.count(anchor) == count, (anchor, s.count(anchor))
    return s.replace(anchor, text + anchor)
anchor = '#include "ir_wide.c"\n'
assert s.count(anchor) == 1
s = s.replace(anchor, anchor + helpers)
s = s.replace("    *counts = (CheckTier1Counts){ 0 };\n", "    *counts = (CheckTier1Counts){ 0 };\n    tmp_stage_mark(0);\n", 1)
s = insert_before(s, "    // The calls of the unit's always_inline functions expanded", "    tmp_stage_mark(1);\n")
s = insert_before(s, "    IrFunction promoted = { 0 };\n", "    tmp_stage_mark(2);\n")
s = insert_before(s, "    // The 128-bit integers' halves (#141, ir_wide.c), which the optimizer then takes", "    tmp_stage_mark(3);\n")
s = insert_before(s, "    IrOptimizeResult optimized = { 0 };\n", "    tmp_stage_mark(4);\n")
s = insert_before(s, "    // #866's congruence solver's result, if it ran", "    tmp_stage_mark(5);\n")
s = insert_before(s, "    Tier1SelectPlan plan = { 0 };\n", "    tmp_stage_mark(6);\n")
s = insert_before(s, "    Tier1EmitResult emitted = { 0 };\n", "    tmp_stage_mark(7);\n")
s = insert_before(s, "    // The code in `output`, as Tier 0's is", "    tmp_stage_mark(8);\n")
s = insert_before(s, "    return outcome;\n}\n\nstatic void check_tier1_print_refusal", "    tmp_stage_mark(9);\n")
open(path, 'w').write(s)
print("patched", path)
