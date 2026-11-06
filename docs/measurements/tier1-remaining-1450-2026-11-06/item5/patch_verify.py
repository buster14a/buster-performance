#!/usr/bin/env python3
# Temporary measurement patch for #1450 item 5 (not committed), round 2: exact user-mode instruction counts per Tier 1
# stage and, nested in whichever stage calls it, the IR verifier (ir_verify_path, which every verification goes
# through). Each boundary enters a bucket and charges the instructions since the last boundary to the bucket it leaves.
# Bucket 0 is everything outside check_tier1_compile. Run from the repository root of a clean checkout.
import sys
ir_path = 'src/buster/compiler/ir.c'
t1_path = 'src/buster/compiler/c_check_tier1.c'
helpers = r'''
#include <linux/perf_event.h>
#include <sys/syscall.h>
#include <unistd.h>
static __thread int tmp_stage_fd = -2;
static __thread uint64_t tmp_stage_last;
static __thread uint32_t tmp_stage_active;
static uint64_t tmp_stage_counts[16];
static const char* const tmp_stage_names[16] = { "outside", "lower", "inline", "promote", "wide+truth", "optimize", "analysis", "select", "emit", "publish", "verify" };
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
static void tmp_stage_enter(uint32_t stage)
{
    const uint64_t now = tmp_stage_read();
    __atomic_fetch_add(&tmp_stage_counts[tmp_stage_active], now - tmp_stage_last, __ATOMIC_RELAXED);
    tmp_stage_last = now;
    tmp_stage_active = stage;
}
static __attribute__((destructor)) void tmp_stage_print(void)
{
    if (tmp_stage_counts[1] != 0)
    {
        for (uint32_t i = 1; i < 11; i += 1)
        {
            fprintf(stderr, "tier1-stage\t%s\t%llu\n", tmp_stage_names[i], (unsigned long long)tmp_stage_counts[i]);
        }
    }
}
'''
s = open(ir_path).read()
definition = 'static __attribute__((noinline, aligned(64))) IrCheck ir_verify_path(const IrFunction* f, Arena* scratch, const IrDominance* dominance, bool vector)\n'
assert s.count(definition) == 1
s = s.replace(definition, helpers + definition.replace('ir_verify_path(', 'ir_verify_path_impl('))
after = 'static IrCheck ir_verify_scalar(const IrFunction* f, Arena* scratch, const IrDominance* dominance);\n'
assert s.count(after) == 1
wrapper = definition + '''{
    const uint32_t previous = tmp_stage_active;
    tmp_stage_enter(10);
    const IrCheck result = ir_verify_path_impl(f, scratch, dominance, vector);
    tmp_stage_enter(previous);
    return result;
}

'''
s = s.replace(after, wrapper + after)
open(ir_path, 'w').write(s)
s = open(t1_path).read()
def insert_before(s, anchor, text):
    assert s.count(anchor) == 1, anchor
    return s.replace(anchor, text + anchor)
s = s.replace("    *counts = (CheckTier1Counts){ 0 };\n", "    *counts = (CheckTier1Counts){ 0 };\n    tmp_stage_enter(1);\n", 1)
s = insert_before(s, "    // The calls of the unit's always_inline functions expanded", "    tmp_stage_enter(2);\n")
s = insert_before(s, "    IrFunction promoted = { 0 };\n", "    tmp_stage_enter(3);\n")
s = insert_before(s, "    // The 128-bit integers' halves (#141, ir_wide.c), which the optimizer then takes", "    tmp_stage_enter(4);\n")
s = insert_before(s, "    IrOptimizeResult optimized = { 0 };\n", "    tmp_stage_enter(5);\n")
s = insert_before(s, "    // #866's congruence solver's result, if it ran", "    tmp_stage_enter(6);\n")
s = insert_before(s, "    Tier1SelectPlan plan = { 0 };\n", "    tmp_stage_enter(7);\n")
s = insert_before(s, "    Tier1EmitResult emitted = { 0 };\n", "    tmp_stage_enter(8);\n")
s = insert_before(s, "    // The code in `output`, as Tier 0's is", "    tmp_stage_enter(9);\n")
s = insert_before(s, "    return outcome;\n}\n\nstatic void check_tier1_print_refusal", "    tmp_stage_enter(0);\n")
open(t1_path, 'w').write(s)
print("patched")
