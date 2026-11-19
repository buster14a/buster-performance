# EXPERIMENT ONLY (#2924 C12c's gate): the hand edits after knob3.py, from its residue list (knob3.residue) and
# leaks.py's list of gated values that still leave their area. Run from src/buster/compiler of the rewritten copy.
# Each edit names its file, a pattern, its replacement and how many times it must apply.
import re, sys, glob

EDITS = [
    # c_bindings_sort's vectorized argument inside a larger expression (the bindings' twin, foreign 22).
    ('c_check_data.c', r'c_bindings_sort\(keys, temporary, count, !scalar && count', r'c_bindings_sort(keys, temporary, count, !(scalar_raw || buster_scalar_area(22)) && count', 1),
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
    # The IR's promotion twin (28).
    ('c_check_tier1.c', r'\bscalar(\s*\?\s*ssa_ir_promote_scalar\()', r'(scalar_raw || buster_scalar_area(28))\1', 1),
    # Tier 1's emit options leave the checker: the command's flag (emission keeps it).
    ('c_check_tier1.c', r'\.vector = !scalar,', r'.vector = !scalar_raw,', 1),
    # The assembler's options (28; its relaxation is C11b's).
    ('c_check_program_asm.c', r'\.vectorized = !BUSTER_SCALAR_PATH\(scalar\)', r'.vectorized = !(scalar_raw || buster_scalar_area(28))', 6),
    ('c_check_program_asm.c', r'\.vectorized = !scalar,', r'.vectorized = !(scalar_raw || buster_scalar_area(28)),', 1),
    # The executable's writer and the binder (28; a link, not -c).
    ('c_checker_driver.c', r'\.exact = BUSTER_SCALAR_PATH\(scalar\),', r'.exact = scalar_raw || buster_scalar_area(28),', 1),
    ('c_checker_driver.c', r'\.path = BUSTER_SCALAR_PATH\(scalar\) \? BIND_PATH_EXACT', r'.path = BUSTER_SCALAR_PATH(scalar_raw || buster_scalar_area(28)) ? BIND_PATH_EXACT', 1),
    # The corpus source's configuration and its receipt's label: raw (a store that leaves, and a key).
    ('c_check_source_prepare.c', r'requested && \(\(request\.scalar \|\| buster_scalar_area\(10\)\) \|\| \(source->options\.scalar \|\| buster_scalar_area\(10\)\)\)',
     r'requested && (request.scalar || source->options.scalar)', 1),
    ('c_check_source_prepare.c', r'\(source->scalar \|\| buster_scalar_area\(10\)\) \? "scalar"', r'source->scalar ? "scalar"', 1),
    # Gated locals named vector handed to another area's functions: the raw flag (the callee gates it, knob3's requests).
    ('c_check_common_warnings.c', r'CheckUnseqStorage unsequenced = \{ \.vector = vector \};', r'CheckUnseqStorage unsequenced = { .vector = !parser->options.scalar };', 1),
    ('c_check_common_warnings.c', r'check_unseq_marks\(graph, parents, vector,', r'check_unseq_marks(graph, parents, !parser->options.scalar,', 1),
    ('c_check_common_warnings.c', r'check_unseq_plans\(input, program, parents, unsequenced_marks, vector,', r'check_unseq_plans(input, program, parents, unsequenced_marks, !parser->options.scalar,', 1),
    ('c_check_attribute_checks_input.c', r'(check_sparse_next\(input->body_declarations, (?:0|opening \+ 1), count, )vector\)', r'\1!parser->options.scalar)', 2),
    ('c_check_binding.c', r'(check_sparse_next\(input->body_declarations, (?:0|opening \+ 1), count, )vector\)', r'\1!parser->options.scalar)', 2),
    ('c_check_common_warnings.c', r'(c_bindings_sort\([^;]*?), vector, varying\)', r'\1, !(parser->options.scalar || buster_scalar_area(22)), varying)', 7),
    # Their locals have no other reader left.
    ('c_check_attribute_checks_input.c', r'(const bool vector = !\(parser->options\.scalar \|\| buster_scalar_area\(10\)\);)', r'\1 (void)vector;', 1),
    ('c_check_binding.c', r'(const bool vector = valid && BUSTER_VECTOR_PATH\(!\(parser->options\.scalar \|\| buster_scalar_area\(11\)\)\);)', r'\1 (void)vector;', 1),
    # The knob itself: a load, a shift and a mask of a global the executable's constructor sets.
    ('host_isa.h', r'static __attribute__\(\(unused\)\) unsigned buster_scalar_area_bits\(void\)\n\{.*?\n\}\nstatic __attribute__\(\(unused\)\) int buster_scalar_area\(unsigned area\)\n\{\n.*?\n\}\n',
     '__attribute__((weak)) unsigned buster_scalar_area_mask = 0;\n'
     'static __attribute__((constructor, unused)) void buster_scalar_area_initialize(void)\n'
     '{\n'
     '    char path[4096];\n'
     '    const ssize_t length = readlink("/proc/self/exe", path, sizeof(path) - 1);\n'
     '    unsigned bits = 0;\n'
     '    if (length > 0)\n'
     '    {\n'
     '        path[length] = 0;\n'
     '        const char* at = strstr(path, "-areas");\n'
     '        bits = at != 0 ? (unsigned)strtoul(at + 6, 0, 0) : 0;\n'
     '    }\n'
     '    buster_scalar_area_mask = bits;\n'
     '}\n'
     '#define buster_scalar_area(area) ((int)((buster_scalar_area_mask >> (area)) & 1u))\n', 1),
]

def main():
    stage = sorted(f for f in glob.glob('c_check*.c') if not f.endswith(('_test.c', '_benchmark.c')))
    failed = 0
    for target, pattern, replacement, expected in EDITS:
        files = stage if target == '*' else [target]
        total = 0
        for f in files:
            text = open(f).read()
            new, n = re.subn(pattern, replacement, text, flags=re.S)
            if n:
                open(f, 'w').write(new)
                total += n
        status = 'ok' if expected is None or total == expected else 'MISMATCH'
        failed += expected is not None and total != expected
        print(f'{status} {total}/{expected} {target} {pattern[:70]}')
    sys.exit(1 if failed else 0)

if __name__ == '__main__':
    main()
