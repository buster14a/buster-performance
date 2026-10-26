#!/usr/bin/env bash
# #451 review: mutants of pp_window_cut and pp_directive_places, each compiled into a program of its own with the
# windows check's tests of them, taken from TREE's sources (c_preprocessor_windows_test.c: the cut against a byte at a
# time on its random lines and its fixtures, the guard page's among them; the places against their bit-at-a-time twin).
# The *_none programs are the unchanged code. A mutant must report failures or fault (status 139). Run in an empty
# directory: mutants.sh TREE
set -u
python3 - "$1" <<'PY'
import os, sys
src = open(os.path.join(sys.argv[1], "src/buster/compiler/c_preprocessor.c")).read()
test = open(os.path.join(sys.argv[1], "src/buster/compiler/c_preprocessor_windows_test.c")).read()
def extract(text, start, end_marker="\n}\n"):
    i = text.index(start)
    j = text.index(end_marker, i) + len(end_marker)
    return text[i:j]
head = """#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>
#include <immintrin.h>
#define BUSTER_PP_WINDOW_TAIL_BYTES (16u << 10)
#define BUSTER_ARRAY_LENGTH(a) (sizeof(a) / sizeof((a)[0]))
#define BUSTER_UNLIKELY(x) __builtin_expect(!!(x), 0)
"""
cut = extract(src, "static uint64_t pp_window_cut(")
oracle = extract(test, "static uint64_t pp_window_test_cut(")
rnd = extract(test, "static uint64_t pp_window_test_random(")
loop = extract(test, "static uint64_t pp_window_test_line_ends(").replace("!pp_test_quiet", "0")
fixture_struct = extract(test, "typedef struct PPWindowCutFixture PPWindowCutFixture;", "\n};\n")
fixtures = extract(test, "static uint64_t pp_window_test_cut_fixtures(").replace("!pp_test_quiet", "0")
scalar = extract(src, "static uint32_t pp_directive_places_scalar(")
places = extract(src, "static uint32_t pp_directive_places(")
places_test = extract(test, "static uint64_t pp_window_test_places(").replace("!pp_test_quiet", "0")
cut_mutants = {
    "cut_none": [],
    "cut_no_early_exit": [(" && (last == UINT64_MAX || end - 1 - last > longest_tail))", ")")],
    "cut_no_double": [("return last == UINT64_MAX || (tail > longest_tail && before == UINT64_MAX) ? at", "return last == UINT64_MAX ? at : before == UINT64_MAX ? end")],
    "cut_tail_ge": [("tail > longest_tail && last - before < tail", "tail >= longest_tail && last - before < tail")],
}
place_mutants = {
    "places_none": [],
    "places_group_inverted": [("_mm512_test_epi64_mask(eight, eight) != 0 &&", "_mm512_test_epi64_mask(eight, eight) == 0 &&")],
    "places_group_size": [("const uint32_t size = word_count - group < 8 ? word_count - group : 8;", "const uint32_t size = 8;")],
    "places_mask_plus_one": [("_bzhi_u32(0xFFFF, here)", "_bzhi_u32(0xFFFF, here + 1)")],
    "places_no_fallback": [("if (BUSTER_UNLIKELY(here > 16))", "if (0)")],
}
for name, reps in cut_mutants.items():
    body = cut
    for old, new in reps:
        assert body.count(old) == 1, (name, old)
        body = body.replace(old, new)
    open(f"{name}.c", "w").write(head + body + oracle + rnd + loop + fixture_struct + "\n" + fixtures + """
int main(void)
{
    uint64_t random = 0x116116116ull ^ 1;
    uint64_t checks = 0;
    const uint64_t fixture_failures = pp_window_test_cut_fixtures(&checks);
    const uint64_t failures = pp_window_test_line_ends(&random, &checks);
    printf("%s: %llu fixture and %llu random failures, %llu checks\\n", MUTANT, (unsigned long long)fixture_failures, (unsigned long long)failures, (unsigned long long)checks);
    return 0;
}
""")
for name, reps in place_mutants.items():
    body = places
    for old, new in reps:
        assert body.count(old) == 1, (name, old)
        body = body.replace(old, new)
    open(f"{name}.c", "w").write(head + scalar + body + rnd + places_test + """
int main(void)
{
    uint64_t random = 0x116116116ull ^ 1;
    uint64_t checks = 0;
    const uint64_t failures = pp_window_test_places(&random, &checks);
    printf("%s: %llu failures, %llu checks\\n", MUTANT, (unsigned long long)failures, (unsigned long long)checks);
    return 0;
}
""")
PY
for m in cut_none cut_no_early_exit cut_no_double cut_tail_ge places_none places_group_inverted places_group_size places_mask_plus_one places_no_fallback; do clang -O1 -march=native -DMUTANT="\"$m\"" -w $m.c -o $m && { ./$m > out-$m.txt 2>&1; echo "$m exit $? $(tail -1 out-$m.txt)"; }; done
