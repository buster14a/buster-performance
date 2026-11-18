#!/usr/bin/env python3
# mutants.py: the faults of the loop's quiet rule (buster#2850, the tests on the window, second half), one at a time, in a
# COPY of the tree (/home/user/mut9/tree, or tree<i> for a shard): each is a text of the new code replaced by a faulty
# one, the Debug compiler built, and the node machine's tests run (test-checker part 5 of 8). A fault the tests don't
# fail is a survivor. Every text is checked to be unique before any build, and the file is restored after each fault.
#   mutants.py check        : every fault's texts are unique, applies and reverts
#   mutants.py run [NAME..] : the campaign (all the faults, or those named); results in /home/user/mut9/results*.txt
#   MUT_SHARD=i/n           : the faults whose place in the list is i modulo n, in the tree's copy tree<i>
import subprocess, sys, os, shutil, time

ROOT = '/home/user/mut9'
SHARD, SHARDS = [int(x) for x in os.environ.get('MUT_SHARD', '0/1').split('/')]
TREE = ROOT + ('/tree' if SHARDS == 1 else '/tree%d' % SHARD)
SRC = TREE + '/src/buster/compiler/'
C = 'c_check_node_census.c'
F = 'c_check_node_machine_facts.c'
R = 'c_check_node_machine_reads.c'

K = 'BUSTER_NODE_TESTS_KIND_'
Q = 'BUSTER_NODE_TESTS_QUIET_'
MUTANTS = [
    ('b-pointer-as-signed', C, '__m128i kind_bytes = _mm_maskz_set1_epi8(pointer, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_POINTER));', '__m128i kind_bytes = _mm_maskz_set1_epi8(pointer, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_SIGNED));'),
    ('b-signed-as-unsigned', C, 'kind_bytes = _mm_mask_set1_epi8(kind_bytes, integer, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_SIGNED));', 'kind_bytes = _mm_mask_set1_epi8(kind_bytes, integer, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_UNSIGNED));'),
    ('b-unsigned-as-signed', C, 'kind_bytes = _mm_mask_set1_epi8(kind_bytes, unsigned_type, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_UNSIGNED));', 'kind_bytes = _mm_mask_set1_epi8(kind_bytes, unsigned_type, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_SIGNED));'),
    ('b-zero-as-tiny', C, 'kind_bytes = _mm_mask_set1_epi8(kind_bytes, valued, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_ZERO));', 'kind_bytes = _mm_mask_set1_epi8(kind_bytes, valued, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_TINY));'),
    ('b-tiny-as-small', C, 'kind_bytes = _mm_mask_set1_epi8(kind_bytes, past_zero, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_TINY));', 'kind_bytes = _mm_mask_set1_epi8(kind_bytes, past_zero, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_SMALL));'),
    ('b-small-as-tiny', C, 'kind_bytes = _mm_mask_set1_epi8(kind_bytes, past_tiny, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_SMALL));', 'kind_bytes = _mm_mask_set1_epi8(kind_bytes, past_tiny, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_TINY));'),
    ('b-constant-as-small', C, 'kind_bytes = _mm_mask_set1_epi8(kind_bytes, past_small, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_CONSTANT));', 'kind_bytes = _mm_mask_set1_epi8(kind_bytes, past_small, (char)BUSTER_NODE_TESTS_KIND_BITS(BUSTER_NODE_TESTS_KIND_SMALL));'),
    ('b-kind-no-own-bit', C, '#define BUSTER_NODE_TESTS_KIND_BITS(kind) ((uint8_t)((kind) << BUSTER_NODE_TESTS_KIND_SHIFT | ((kind) >= BUSTER_NODE_TESTS_KIND_SIGNED ? BUSTER_NODE_TESTS_KIND_OWN : 0u)))', '#define BUSTER_NODE_TESTS_KIND_BITS(kind) ((uint8_t)((kind) << BUSTER_NODE_TESTS_KIND_SHIFT | ((kind) > BUSTER_NODE_TESTS_KIND_CONSTANT ? BUSTER_NODE_TESTS_KIND_OWN : 0u)))'),
    ('b-kind-own-bit-pointer', C, '#define BUSTER_NODE_TESTS_KIND_BITS(kind) ((uint8_t)((kind) << BUSTER_NODE_TESTS_KIND_SHIFT | ((kind) >= BUSTER_NODE_TESTS_KIND_SIGNED ? BUSTER_NODE_TESTS_KIND_OWN : 0u)))', '#define BUSTER_NODE_TESTS_KIND_BITS(kind) ((uint8_t)((kind) << BUSTER_NODE_TESTS_KIND_SHIFT | BUSTER_NODE_TESTS_KIND_OWN))'),
    ('b-kinds-not-in-values', C, '            value_bytes = _mm_or_si128(value_bytes, kind_bytes);\n', '            value_bytes = _mm_or_si128(value_bytes, _mm_andnot_si128(kind_bytes, kind_bytes));\n'),
    ('l-pair-no-shift', C, '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), _mm512_srli_epi16(kind_left, BUSTER_NODE_TESTS_KIND_SHIFT), kind_right, 0xca);', '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), _mm512_srli_epi16(kind_left, 0), kind_right, 0xca);'),
    ('l-pair-no-right', C, '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), _mm512_srli_epi16(kind_left, BUSTER_NODE_TESTS_KIND_SHIFT), kind_right, 0xca);', '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), _mm512_srli_epi16(kind_left, BUSTER_NODE_TESTS_KIND_SHIFT), _mm512_andnot_si512(kind_right, kind_right), 0xca);'),
    ('l-pair-no-left', C, '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), _mm512_srli_epi16(kind_left, BUSTER_NODE_TESTS_KIND_SHIFT), kind_right, 0xca);', '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), _mm512_srli_epi16(_mm512_andnot_si512(kind_left, kind_left), BUSTER_NODE_TESTS_KIND_SHIFT), kind_right, 0xca);'),
    ('l-pair-right-is-left', C, '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), _mm512_srli_epi16(kind_left, BUSTER_NODE_TESTS_KIND_SHIFT), kind_right, 0xca);', '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), _mm512_srli_epi16(kind_left, BUSTER_NODE_TESTS_KIND_SHIFT), _mm512_or_si512(_mm512_andnot_si512(kind_right, kind_right), kind_left), 0xca);'),
    ('l-pair-swapped', C, '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), _mm512_srli_epi16(kind_left, BUSTER_NODE_TESTS_KIND_SHIFT), kind_right, 0xca);', '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), _mm512_srli_epi16(kind_right, BUSTER_NODE_TESTS_KIND_SHIFT), kind_left, 0xca);'),
    ('l-pair-or', C, '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), _mm512_srli_epi16(kind_left, BUSTER_NODE_TESTS_KIND_SHIFT), kind_right, 0xca);', '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), _mm512_srli_epi16(kind_left, BUSTER_NODE_TESTS_KIND_SHIFT), kind_right, 0xfe);'),
    ('l-own-bit-any', C, 'const __m512i own_bit = _mm512_or_si512(values, _mm512_set1_epi8((char)~BUSTER_NODE_TESTS_KIND_OWN));', 'const __m512i own_bit = _mm512_or_si512(values, _mm512_set1_epi8((char)0xff));'),
    ('l-own-bit-of-left', C, 'const __m512i own_bit = _mm512_or_si512(values, _mm512_set1_epi8((char)~BUSTER_NODE_TESTS_KIND_OWN));', 'const __m512i own_bit = _mm512_or_si512(kind_left, _mm512_set1_epi8((char)~BUSTER_NODE_TESTS_KIND_OWN));'),
    ('l-previous-values-lost', C, '        previous_values = values;\n', '        previous_values = _mm512_setzero_si512();\n'),
    ('l-left-near-right', C, 'const __m512i kind_left = node_tests_window_operands(at_left, near_left, previous_values, values);', 'const __m512i kind_left = node_tests_window_operands(at_left, near_right, previous_values, values);'),
    ('l-right-near-left', C, 'const __m512i kind_right = node_tests_window_operands(at_right, near_right, previous_values, values);', 'const __m512i kind_right = node_tests_window_operands(at_right, near_left, previous_values, values);'),
    ('l-left-at-right', C, 'const __m512i kind_left = node_tests_window_operands(at_left, near_left, previous_values, values);', 'const __m512i kind_left = node_tests_window_operands(at_right, near_left, previous_values, values);'),
    ('l-kinds-of-previous', C, 'const __m512i kind_right = node_tests_window_operands(at_right, near_right, previous_values, values);', 'const __m512i kind_right = node_tests_window_operands(at_right, near_right, previous_values, previous_values);'),
    ('p-ordered-left-no-zero', C, 'small_left || (zero_left && signed_right)) &&', 'small_left || (zero_left && signed_right && false)) &&'),
]

def read(path):
    return open(path).read()

def check():
    ok = True
    names = set()
    for name, f, old, new in MUTANTS:
        s = read(SRC + f)
        if name in names:
            print('DUPLICATE NAME', name); ok = False
        names.add(name)
        if s.count(old) != 1:
            print(name, 'old text occurs', s.count(old)); ok = False
        if old == new or s.replace(old, new) == s:
            print(name, 'changes nothing'); ok = False
        if new != '' and s.count(new) != 0:
            print(name, 'new text is there already', s.count(new)); ok = False
    print(len(MUTANTS), 'faults;', 'all unique' if ok else 'PROBLEMS')
    return ok

def run(only):
    if not check():
        sys.exit(1)
    results = open(ROOT + '/results%s.txt' % ('' if SHARDS == 1 else '-%d' % SHARD), 'a')
    for place, (name, f, old, new) in enumerate(MUTANTS):
        if (only and name not in only) or place % SHARDS != SHARD:
            continue
        path = SRC + f
        saved = ROOT + '/saved%d.c' % SHARD
        shutil.copyfile(path, saved)
        s = read(path)
        open(path, 'w').write(s.replace(old, new))
        start = time.time()
        build = subprocess.run(['./build.sh', '--config', 'Debug'], cwd=TREE, capture_output=True, text=True)
        built = build.returncode == 0
        verdict = 'NOT BUILT'
        detail = ''
        if built:
            try:
                test = subprocess.run(['./build/compiler', 'test-checker', '--seed', '133', '--part', '5/8'], cwd=TREE, capture_output=True, text=True, timeout=900)
                failed = test.returncode != 0
                lines = [l for l in (test.stderr + test.stdout).splitlines() if 'test-checker' in l and 'retained' not in l]
                detail = ' | '.join(l[:150] for l in lines[:2])
                verdict = 'caught' if failed else 'SURVIVED'
            except subprocess.TimeoutExpired:
                verdict = 'caught (timeout)'
        else:
            detail = (build.stderr + build.stdout)[-300:].replace('\n', ' ')
        shutil.copyfile(saved, path)
        line = f'{name}: {verdict} ({time.time() - start:.0f} s) {detail}'
        print(line, flush=True)
        results.write(line + '\n'); results.flush()
    subprocess.run(['./build.sh', '--config', 'Debug'], cwd=TREE, capture_output=True, text=True)
    print('campaign done', flush=True)
    results.write('campaign done\n'); results.flush()

if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == 'check':
        sys.exit(0 if check() else 1)
    run(sys.argv[2:] if len(sys.argv) > 2 else [])
