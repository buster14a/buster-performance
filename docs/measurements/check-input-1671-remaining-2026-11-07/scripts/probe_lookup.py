#!/usr/bin/env python3
# usage: probe_lookup.py SOURCE_ROOT: patch src/buster/compiler/c_builtin_intrinsic_catalog.c in place to count
# builtin_intrinsic_lookup's calls by their return address, printed at exit ("probe-lookup: ADDRESS COUNT"), which
# addr2line -f -i maps to the caller (#1671's study; built with debug information).
import sys, pathlib
p = pathlib.Path(sys.argv[1]) / "src/buster/compiler/c_builtin_intrinsic_catalog.c"
s = p.read_text()
a = """static __attribute__((unused)) const BuiltinIntrinsicInfo* builtin_intrinsic_lookup(const char* name, uint32_t length)
{"""
b = """static uint64_t probe_lookup_counts[64]; static void* probe_lookup_callers[64];
static void probe_lookup_report(void)
{
    for (uint32_t i = 0; i < 64; i += 1) if (probe_lookup_counts[i] != 0) fprintf(stderr, "probe-lookup: %p %llu\\n", probe_lookup_callers[i], (unsigned long long)probe_lookup_counts[i]);
}
static __attribute__((unused, noinline)) const BuiltinIntrinsicInfo* builtin_intrinsic_lookup(const char* name, uint32_t length)
{
    static int registered; if (!registered) { registered = 1; atexit(probe_lookup_report); }
    void* caller = __builtin_return_address(0);
    for (uint32_t i = 0; i < 64; i += 1) { if (probe_lookup_callers[i] == caller || probe_lookup_callers[i] == NULL) { probe_lookup_callers[i] = caller; probe_lookup_counts[i] += 1; break; } }"""
assert s.count(a) == 1
p.write_text(s.replace(a, b))
print("patched", p)
