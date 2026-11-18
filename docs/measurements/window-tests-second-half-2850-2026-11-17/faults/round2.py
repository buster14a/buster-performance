#!/usr/bin/env python3
# mutants.py: the faults of the loop's quiet rule (buster#2850, the tests on the window, second half), one at a time, in a
# COPY of the tree (/home/user/mut8/tree, or tree<i> for a shard): each is a text of the new code replaced by a faulty
# one, the Debug compiler built, and the node machine's tests run (test-checker part 5 of 8). A fault the tests don't
# fail is a survivor. Every text is checked to be unique before any build, and the file is restored after each fault.
#   mutants.py check        : every fault's texts are unique, applies and reverts
#   mutants.py run [NAME..] : the campaign (all the faults, or those named); results in /home/user/mut8/results*.txt
#   MUT_SHARD=i/n           : the faults whose place in the list is i modulo n, in the tree's copy tree<i>
import subprocess, sys, os, shutil, time

ROOT = '/home/user/mut8'
SHARD, SHARDS = [int(x) for x in os.environ.get('MUT_SHARD', '0/1').split('/')]
TREE = ROOT + ('/tree' if SHARDS == 1 else '/tree%d' % SHARD)
SRC = TREE + '/src/buster/compiler/'
C = 'c_check_node_census.c'
F = 'c_check_node_machine_facts.c'
R = 'c_check_node_machine_reads.c'

K = 'BUSTER_NODE_TESTS_KIND_'
Q = 'BUSTER_NODE_TESTS_QUIET_'
MUTANTS = [
    ('t-pairs-not-made', C, '    node_tests_quiet_pairs(s->own_quiet_pairs);\n', '    node_tests_quiet_pairs(s->own_quiet_pairs);\n    memset(s->own_quiet_pairs, 0, sizeof(s->own_quiet_pairs));\n'),
    ('p-both-left-only', C, 'const bool both = integer_left && integer_right;', 'const bool both = integer_left && (integer_right || true);'),
    ('p-equal-any-left', C, 'const bool equal = (!constant_left || constant_right || zero_left || small_left) &&', 'const bool equal = (!constant_left || constant_right || zero_left || small_left || true) &&'),
    ('p-equal-any-right', C, '&& (!constant_right || constant_left || zero_right || small_right);\n        const bool ordered', '&& (!constant_right || constant_left || zero_right || small_right || true);\n        const bool ordered'),
    ('p-ordered-left-unsigned', C, 'small_left || (zero_left && signed_right)) &&', 'small_left || (zero_left && (signed_right || true))) &&'),
    ('p-ordered-right-unsigned', C, 'small_right || (zero_right && signed_left));', 'small_right || (zero_right && (signed_left || true)));'),
    ('p-ordered-left-no-zero', C, 'small_left || (zero_left && signed_right)) &&', 'small_left || (zero_left && signed_right && false)) &&'),
    ('p-ordered-right-no-zero', C, 'small_right || (zero_right && signed_left));', 'small_right || (zero_right && signed_left && false));'),
    ('p-shift-any-shifted', C, 'const bool shifted = (!constant_right || tiny_right) && (!constant_left || zero_left || small_left);', 'const bool shifted = (!constant_right || tiny_right) && (!constant_left || zero_left || small_left || true);'),
    ('p-divided-any', C, 'const bool divided = !constant_right || small_right;', 'const bool divided = !constant_right || small_right || true;'),
    ('p-class-equality-any', C, '((both && equal) || null ? BUSTER_NODE_TESTS_QUIET_EQUALITY : 0) |', '((both && (equal || true)) || null ? BUSTER_NODE_TESTS_QUIET_EQUALITY : 0) |'),
    ('p-class-equality-no-null', C, '((both && equal) || null ? BUSTER_NODE_TESTS_QUIET_EQUALITY : 0) |', '((both && equal) || (null && false) ? BUSTER_NODE_TESTS_QUIET_EQUALITY : 0) |'),
    ('p-class-relational-any', C, '(both && ordered ? BUSTER_NODE_TESTS_QUIET_RELATIONAL : 0) |', '(both && (ordered || true) ? BUSTER_NODE_TESTS_QUIET_RELATIONAL : 0) |'),
    ('p-class-shift-any', C, '(both && shifted ? BUSTER_NODE_TESTS_QUIET_SHIFT : 0) |', '(both && (shifted || true) ? BUSTER_NODE_TESTS_QUIET_SHIFT : 0) |'),
    ('p-class-division-any', C, '(both && divided ? BUSTER_NODE_TESTS_QUIET_DIVISION : 0) |', '(both && (divided || true) ? BUSTER_NODE_TESTS_QUIET_DIVISION : 0) |'),
    ('p-class-assign-any', C, '(both && stored ? BUSTER_NODE_TESTS_QUIET_ASSIGN : 0) |', '(both && (stored || true) ? BUSTER_NODE_TESTS_QUIET_ASSIGN : 0) |'),
    ('p-class-convert-any', C, '(converted ? BUSTER_NODE_TESTS_QUIET_CONVERT : 0));', '(converted || integer_left ? BUSTER_NODE_TESTS_QUIET_CONVERT : 0));'),
    ('l-pair-no-right', C, '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), plain_left, plain_right, 0xca);', '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), plain_left, _mm512_andnot_si512(plain_right, plain_right), 0xca);'),
    ('l-pair-no-left', C, '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), plain_left, plain_right, 0xca);', '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), _mm512_andnot_si512(plain_left, plain_left), plain_right, 0xca);'),
    ('l-pair-left-as-right', C, '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), plain_left, plain_right, 0xca);', '_mm512_ternarylogic_epi64(_mm512_set1_epi8(BUSTER_NODE_TESTS_KINDS - 1), plain_left, _mm512_or_si512(_mm512_andnot_si512(plain_right, plain_right), plain_left), 0xca);'),
    ('l-class-any', C, 'const __mmask64 quiet_class = _mm512_test_epi8_mask(_mm512_and_si512(paired, own_bit), quiets);', 'const __mmask64 quiet_class = _mm512_test_epi8_mask(_mm512_and_si512(paired, own_bit), _mm512_or_si512(quiets, _mm512_set1_epi8((char)0xff)));'),
    ('l-class-no-pair', C, 'const __mmask64 quiet_class = _mm512_test_epi8_mask(_mm512_and_si512(paired, own_bit), quiets);', 'const __mmask64 quiet_class = _mm512_test_epi8_mask(_mm512_or_si512(_mm512_and_si512(paired, own_bit), _mm512_set1_epi8((char)0xff)), quiets);'),
    ('p-integer-left-pointer', C, 'const bool integer_left = left >= BUSTER_NODE_TESTS_KIND_SIGNED;', 'const bool integer_left = left >= BUSTER_NODE_TESTS_KIND_POINTER;'),
    ('p-integer-right-pointer', C, 'const bool integer_right = right >= BUSTER_NODE_TESTS_KIND_SIGNED;', 'const bool integer_right = right >= BUSTER_NODE_TESTS_KIND_POINTER;'),
    ('p-zero-left-tiny', C, 'const bool zero_left = left == BUSTER_NODE_TESTS_KIND_ZERO;', 'const bool zero_left = left == BUSTER_NODE_TESTS_KIND_ZERO || left == BUSTER_NODE_TESTS_KIND_TINY;'),
    ('p-zero-right-tiny', C, 'const bool zero_right = right == BUSTER_NODE_TESTS_KIND_ZERO;', 'const bool zero_right = right == BUSTER_NODE_TESTS_KIND_ZERO || right == BUSTER_NODE_TESTS_KIND_TINY;'),
    ('p-tiny-right-no-zero', C, 'const bool tiny_right = right == BUSTER_NODE_TESTS_KIND_ZERO || right == BUSTER_NODE_TESTS_KIND_TINY;', 'const bool tiny_right = right == BUSTER_NODE_TESTS_KIND_TINY;'),
    ('p-null-any-constant', C, 'const bool null = (left == BUSTER_NODE_TESTS_KIND_POINTER && zero_right) || (right == BUSTER_NODE_TESTS_KIND_POINTER && zero_left);', 'const bool null = (left == BUSTER_NODE_TESTS_KIND_POINTER && constant_right) || (right == BUSTER_NODE_TESTS_KIND_POINTER && constant_left);'),
    ('p-equal-no-zero', C, 'const bool equal = (!constant_left || constant_right || zero_left || small_left) &&', 'const bool equal = (!constant_left || constant_right || small_left) &&'),
    ('p-stored-no-zero', C, 'const bool stored = zero_right || small_right;', 'const bool stored = small_right;'),
    ('p-converted-no-zero', C, 'const bool converted = zero_left || small_left;', 'const bool converted = small_left;'),
    ('b-pointer-as-signed', C, 'plain_bytes = _mm_maskz_set1_epi8(pointer, (char)BUSTER_NODE_TESTS_PLAIN(BUSTER_NODE_TESTS_KIND_POINTER));', 'plain_bytes = _mm_maskz_set1_epi8(pointer, (char)BUSTER_NODE_TESTS_PLAIN(BUSTER_NODE_TESTS_KIND_SIGNED));'),
    ('b-past-small-126', C, 'const __mmask16 past_small = _mm512_mask_cmpge_epu32_mask(valued, value, _mm512_set1_epi32(127));', 'const __mmask16 past_small = _mm512_mask_cmpge_epu32_mask(valued, value, _mm512_set1_epi32(126));'),
    ('b-plain-own-bit-pointer', C, '#define BUSTER_NODE_TESTS_PLAIN(kind) ((uint8_t)((kind) | (kind) << 3 | ((kind) >= BUSTER_NODE_TESTS_KIND_SIGNED ? BUSTER_NODE_TESTS_PLAIN_OWN : 0u)))', '#define BUSTER_NODE_TESTS_PLAIN(kind) ((uint8_t)((kind) | (kind) << 3 | BUSTER_NODE_TESTS_PLAIN_OWN))'),
    ('f-from-with-operand-s', F, '(uint64_t)node_facts_exponent(standing, payload, records[a].exponent) << 16);', '(uint64_t)records[a].exponent << 16 | (uint64_t)0);'),
    ('p-unary-any', C, '(integer_left ? BUSTER_NODE_TESTS_QUIET_UNARY : 0) |', '(integer_left || true ? BUSTER_NODE_TESTS_QUIET_UNARY : 0) |'),
    ('p-unary-both', C, '(integer_left ? BUSTER_NODE_TESTS_QUIET_UNARY : 0) |', '(both ? BUSTER_NODE_TESTS_QUIET_UNARY : 0) |'),
    ('p-binary-first-only', C, 'pairs[pair] = (uint8_t)((both ? BUSTER_NODE_TESTS_QUIET_BINARY : 0) |', 'pairs[pair] = (uint8_t)((integer_left ? BUSTER_NODE_TESTS_QUIET_BINARY : 0) |'),
    ('p-convert-never', C, '(converted ? BUSTER_NODE_TESTS_QUIET_CONVERT : 0));', '(converted && false ? BUSTER_NODE_TESTS_QUIET_CONVERT : 0));'),
    ('b-pointer-any-six', C, 'const __mmask16 pointer = _mm512_mask_cmpeq_epi32_mask(placed, six, _mm512_set1_epi32(0x08));', 'const __mmask16 pointer = _mm512_mask_test_epi32_mask(placed, six, _mm512_set1_epi32(0x08));'),
    ('b-pointer-never', C, 'const __mmask16 pointer = _mm512_mask_cmpeq_epi32_mask(placed, six, _mm512_set1_epi32(0x08));', 'const __mmask16 pointer = _mm512_mask_cmpeq_epi32_mask(placed, six, _mm512_set1_epi32(0x3f));'),
    ('f-from-none', F, '    node_facts_store(record, 24, (uint64_t)standing | 0x100u | (uint64_t)records[a].exponent << 16);', '    node_facts_store(record, 24, (uint64_t)standing | 0x100u | (uint64_t)0 << 16 | (uint64_t)0);'),
    ('f-small-0xfffe', F, '    return (uint32_t)(payload < 0xffffu ? payload : 0xfffeu) + 1u;', '    return (uint32_t)(payload < 0xffffu ? payload : 0xfffdu) + 1u;'),
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
