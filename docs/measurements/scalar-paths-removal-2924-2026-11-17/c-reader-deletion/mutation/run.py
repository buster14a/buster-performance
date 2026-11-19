# The reader's mutants (#2924 C12c-1), each built in the archived tree of the deletion and run against test-checker (its
# four parts, with the source fixtures' digests) and test-checker-driver's first part. One mutant at a time: applied,
# built, tested, reverted; a mutant whose pattern isn't found once stops the run.
import subprocess, os, sys
T = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'tree')
C = os.path.join(T, 'src/buster/compiler')
MUTANTS = [
    ('m1', 'c_check_input.c', 'count += reader->value_counts[child];', 'count += 1;'),
    ('m2', 'c_check_input.c', 'const bool sparse = (classes & BUSTER_CHECK_EXPRESSION_SPARSE) != 0;', 'const bool sparse = (classes & BUSTER_CHECK_EXPRESSION_SPARSE) != 0 && token % 7 != 3;'),
    ('m3', 'c_check_control_input.c', 'if (source_position <= position && position - source_position < size)', 'if (source_position <= position && position - source_position <= size)'),
    ('m4', 'c_check_control_input.c', 'entries += (uint64_t)__builtin_popcountll(selected & valid);', 'entries += (uint64_t)__builtin_popcountll(selected & valid & (valid >> 1));'),
    ('m5', 'c_check_intrinsic_input.c', 'result &= ~check_input_scan_nonzero(deferred_tokens, first, count);', 'result &= ~(check_input_scan_nonzero(deferred_tokens, first, count) << 1);'),
    ('m6', 'c_check_x86_input.c', 'uint32_t present = check_input_scan_below(reader->selected_tokens, first, count, BUSTER_CHECK_NONE);', 'uint32_t present = check_input_scan_below(reader->selected_tokens, first, count, BUSTER_CHECK_NONE) & 0x7fff;'),
    ('m7', 'c_check_input.c', 'next = marked != 0 ? line + (uint32_t)__builtin_ctzll(marked) : stop;', 'next = marked != 0 ? line + (uint32_t)__builtin_ctzll(marked & (marked - 1 | (marked >> 63 << 63))) : stop;'),
    ('m8', 'c_check_asm_input.c', 'halves[first / 16] = marked;', 'halves[first / 16] = marked & 0x7fff;'),
    ('m9', 'c_check_expression_input.c', 'values.count += reader->value_counts[child];', 'values.count += reader->value_counts[child] != 0;'),
    ('m10', 'c_check_literal_table_input.c', 'valid = (numbers | commas | minus) == lanes && (numbers & ~(comma_before | minus_before)) == 0 &&', 'valid = (numbers | commas | minus) == lanes && (numbers & ~(comma_before | minus_before | number_before)) == 0 &&'),
]
log = open(os.path.join(os.path.dirname(T), 'results.txt'), 'a')
def run(cmd, cwd, out):
    with open(out, 'w') as f:
        return subprocess.call(cmd, cwd=cwd, stdout=f, stderr=subprocess.STDOUT, shell=True)
only = sys.argv[1:]
for name, f, old, new in MUTANTS:
    if only and name not in only:
        continue
    p = os.path.join(C, f)
    s = open(p).read()
    assert s.count(old) == 1, (name, s.count(old))
    open(p, 'w').write(s.replace(old, new))
    try:
        d = os.path.join(os.path.dirname(T), name)
        os.makedirs(d, exist_ok=True)
        b = run('./build.sh', T, os.path.join(d, 'build.log'))
        if b != 0:
            print(name, 'build failed', file=log, flush=True)
            continue
        fails = []
        procs = [subprocess.Popen(f'timeout -k 5 1200 ./build/compiler test-checker --part {k}/4 > {d}/checker-{k}.log 2>&1', cwd=T, shell=True) for k in (1, 2, 3, 4)]
        codes = [q.wait() for q in procs]
        fails += [f'checker {k + 1}' for k, c in enumerate(codes) if c != 0]
        if not fails:
            c = run('timeout -k 5 1800 ./build/compiler test-checker-driver --executable ./build/compiler --part 1/4', T, os.path.join(d, 'driver.log'))
            fails += ['driver 1'] if c != 0 else []
        print(name, 'killed by ' + ', '.join(fails) if fails else 'SURVIVED', file=log, flush=True)
    finally:
        open(p, 'w').write(s)
print('done', file=log, flush=True)
