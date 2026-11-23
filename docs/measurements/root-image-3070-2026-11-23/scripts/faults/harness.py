#!/usr/bin/env python3
# The arena helpers' fault round: lane.c (or a mutated copy of it) with test-lanes' check of arena_clear and arena_rewind,
# as a program of its own. usage: harness.py
import subprocess, re, os, sys
sys.path.insert(0, '/home/user/work/faults')
from mutants import MUTANTS
ROOT = '/home/user/buster'
lane = open(ROOT + '/src/buster/compiler/lane.c').read()
test = open(ROOT + '/src/buster/compiler/lane_test.c').read()
begin = test.index('static void lane_test_arena_clear(LaneTestTally* tally)')
end = test.index('static bool lane_test_arenas(void)')
check = test[begin:end]
harness = r'''
#include <stdlib.h>
#include <sys/mman.h>
#include "%s"
typedef struct LaneTestTally LaneTestTally;
struct LaneTestTally { uint64_t checks; uint64_t failures; };
#define BUSTER_LANE_TEST_LARGE_ARENA (64ull << 30)
static void lane_test_expect(LaneTestTally* tally, bool condition, const char* what)
{
    tally->checks += 1;
    if (!condition) { tally->failures += 1; printf("  failed: %%s\n", what); }
}
static bool lane_test_resident(const uint8_t* address)
{
    unsigned char vector = 0;
    return mincore((void*)address, BUSTER_ARENA_PAGE_BYTES, &vector) == 0 && (vector & 1) != 0;
}
static bool lane_test_zero(const uint8_t* bytes, uint64_t count)
{
    bool zero = true;
    for (uint64_t i = 0; i < count; i += 1) { zero = zero && bytes[i] == 0; }
    return zero;
}
%s
int main(void)
{
    LaneTestTally tally = { 0 };
    lane_test_arena_clear(&tally);
    printf("%%llu checks, %%llu failed\n", (unsigned long long)tally.checks, (unsigned long long)tally.failures);
    return tally.failures != 0 || tally.checks == 0;
}
'''
def run(name, source):
    open('lane_copy.c', 'w').write(source)
    open('harness.c', 'w').write(harness % (os.path.abspath('lane_copy.c'), check))
    flags = subprocess.run([ROOT + '/build.sh', 'print-host-flags'], cwd=ROOT, stdout=subprocess.PIPE).stdout.decode().split('\0')
    flags = [f for f in flags if f]
    c = subprocess.run(['clang', '-O1', '-g', '-I' + ROOT + '/src', '-fwrapv', '-funsigned-char', '-fno-strict-aliasing', '-Wno-unused-function'] + flags + ['-o', 'harness', 'harness.c', '-lpthread'],
                       stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    if c.returncode != 0:
        print(name, 'NOT-BUILT', c.stdout.decode()[-600:]); return
    r = subprocess.run(['./harness'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=120)
    out = r.stdout.decode().strip().splitlines()
    print('%s\t%s\t%s' % (name, 'KILLED' if r.returncode != 0 else 'SURVIVED' if name != 'unchanged' else 'passes', '; '.join(out[-3:])))
run('unchanged', lane)
for name, f, old, new in MUTANTS:
    if not f.endswith('lane.c'): continue
    assert lane.count(old) == 1, name
    run(name, lane.replace(old, new))
