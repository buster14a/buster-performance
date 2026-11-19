# EXPERIMENT ONLY (#2924 C12c's gate): the hand edits after knob2.py, from its residue list (knob2.residue).
# Run from src/buster/compiler of the rewritten copy. Each edit names its file, a pattern, its replacement and how many
# times it must apply.
import re, sys

EDITS = [
    # c_bindings_sort's vectorized argument: the bindings module's twin (foreign, the front end's: 22).
    ('*', r'(c_bindings_sort\([^;]*?)!scalar\b(?!_)', r'\1!(scalar_raw || buster_scalar_area(22))', 15),
    ('*', r'(c_bindings_sort\([^;]*?)!\((\w+(?:->|\.)(?:\w+\.)*scalar) \|\| buster_scalar_area\(\d+\)\)', r'\1!(\2 || buster_scalar_area(22))', 7),
    ('*', r'(c_bindings_sort\([^;]*?)!BUSTER_SCALAR_PATH\(scalar\)', r'\1!(scalar_raw || buster_scalar_area(22))', None),
    ('*', r'(c_bindings_sort\([^;]*?)!BUSTER_SCALAR_PATH\(\((\w+(?:->|\.)(?:\w+(?:->|\.))*scalar) \|\| buster_scalar_area\(\d+\)\)\)', r'\1!(\2 || buster_scalar_area(22))', None),
    # The parser's bindings' resolution (22) and the unwind tables' writer (28).
    ('c_check_lazy.c', r'parse_bindings_resolve\(&bindings, BUSTER_SCALAR_PATH\(scalar\),', r'parse_bindings_resolve(&bindings, scalar_raw || buster_scalar_area(22),', 1),
    ('c_check_program_emit.c', r'unwind_write\(run\.frames, kept, &tables, BUSTER_SCALAR_PATH\(scalar\)\)', r'unwind_write(run.frames, kept, &tables, scalar_raw || buster_scalar_area(28))', 2),
    # The type table's lookups' twins (c_types.c, 22).
    ('*', r'\bscalar(\s*\?\s*type_lookup_\w+_scalar\()', r'(scalar_raw || buster_scalar_area(22))\1', 4),
    ('c_check_actions.c', r'\(action->scalar \|\| buster_scalar_area\(14\)\)(\s*\?\s*type_lookup_member_scalar\()', r'(action->scalar || buster_scalar_area(22))\1', 1),
    # The builtins' fold twin (c_builtin.c, 22).
    ('c_check_builtin.c', r'if \(BUSTER_SCALAR_PATH\(scalar\)\)(\s*\{\s*cbuiltin_fold_scalar\()', r'if (BUSTER_SCALAR_PATH(scalar_raw || buster_scalar_area(22)))\1', 1),
    # The builtins' lowering twins (27).
    ('c_check_program_lower.c', r'BUSTER_SCALAR_PATH\(\(writer->scalar \|\| buster_scalar_area\(16\)\)\)(\s*\?\s*cbuiltin_\w*lower_scalar\()', r'BUSTER_SCALAR_PATH((writer->scalar || buster_scalar_area(27)))\1', 4),
    # Tier 0's twins (28).
    ('c_check_program_emit.c', r'\(run->scalar \|\| buster_scalar_area\(18\)\)(\s*\?\s*tier0_compile_scalar\()', r'(run->scalar || buster_scalar_area(28))\1', 1),
    ('c_check_program_lower.c', r'\(shared->scalar \|\| buster_scalar_area\(16\)\)(\s*\?\s*tier0_validate_scalar\()', r'(shared->scalar || buster_scalar_area(28))\1', 1),
    # The IR's promotion twins (28).
    ('c_check_tier1.c', r'ssa_ir_promote_verified_input\(unssa, !scalar,', r'ssa_ir_promote_verified_input(unssa, !(scalar_raw || buster_scalar_area(28)),', 2),
    ('c_check_tier1.c', r'\bscalar(\s*\?\s*ssa_ir_promote_scalar\()', r'(scalar_raw || buster_scalar_area(28))\1', 1),
    # Tier 1's emit options leave the checker: the command's flag (emission keeps it).
    ('c_check_tier1.c', r'\.vector = !scalar,', r'.vector = !scalar_raw,', 1),
    # The assembler's options (28).
    ('c_check_program_asm.c', r'\.vectorized = !scalar,', r'.vectorized = !(scalar_raw || buster_scalar_area(28)),', 1),
    # The corpus source's configuration and its receipt's label: raw (a store that leaves, and a key).
    ('c_check_source_prepare.c', r'requested && \(\(request\.scalar \|\| buster_scalar_area\(10\)\) \|\| \(source->options\.scalar \|\| buster_scalar_area\(10\)\)\)',
     r'requested && (request.scalar || source->options.scalar)', 1),
    ('c_check_source_prepare.c', r'\(source->scalar \|\| buster_scalar_area\(10\)\) \? "scalar"', r'source->scalar ? "scalar"', 1),
]

def main():
    import glob
    stage = sorted(f for f in glob.glob('c_check*.c') if not f.endswith(('_test.c', '_benchmark.c')))
    failed = 0
    for target, pattern, replacement, expected in EDITS:
        files = stage if target == '*' else [target]
        total = 0
        for f in files:
            text = open(f).read()
            new, n = re.subn(pattern, replacement, text)
            if n:
                open(f, 'w').write(new)
                total += n
        status = 'ok' if expected is None or total == expected else 'MISMATCH'
        failed += expected is not None and total != expected
        print(f'{status} {total}/{expected} {target} {pattern[:70]}')
    sys.exit(1 if failed else 0)

if __name__ == '__main__':
    main()
