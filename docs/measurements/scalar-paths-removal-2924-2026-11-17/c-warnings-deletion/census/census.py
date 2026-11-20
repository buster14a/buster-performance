# census.py TREE: the warnings area's scalar arms counted (#2924 C12c-2, experiment only). Each helper's entry counts its
# arm (0 the scalar twin's, 1 and up the vector path's); BUSTER_WCENSUS=FILE appends every non-zero count to FILE at exit.
import sys, re, os
T = sys.argv[1]
C = os.path.join(T, 'src/buster/compiler')
SITES = [  # (file, function, arm expression)
    ('c_check_common_warnings.c', 'check_common_next_token', 'vector ? 1 : 0'),
    ('c_check_common_warnings.c', 'check_common_next_op', 'vector ? 1 : 0'),
    ('c_check_common_candidates.c', 'check_common_next_candidate', 'vector ? 1 : 0'),
    ('c_check_common_candidates.c', 'check_common_candidates_build', 'scalar ? 0 : 1'),
    ('c_check_common_warnings.c', 'check_common_next_root', 'vector ? (roots != NULL ? 2 : 1) : 0'),
    ('c_check_common_warnings.c', 'check_common_next_reach', 'vector ? 1 : 0'),
    ('c_check_common_warnings.c', 'check_common_next_unevaluated', 'vector ? 1 : 0'),
    ('c_check_common_warnings.c', 'check_common_parents', 'scalar ? 0 : 1'),
    ('c_check_common_warnings.c', 'check_common_chosen_depths', 'vector ? 1 : 0'),
    ('c_check_common_warnings.c', 'check_common_chosen_spans', 'vector ? 1 : 0'),
    ('c_check_common_warnings.c', 'check_common_self_candidate', 'vector ? 1 : 0'),
    ('c_check_common_warnings.c', 'check_common_facts', 'parser->options.scalar ? 0 : 1'),
    ('c_check_warning_graph.c', 'check_interrupt_first_use', 'scalar ? 0 : 1'),
    ('c_check_warning_graph.c', 'check_interrupt_evaluated_calls', 'reader->parser->options.scalar ? 0 : 1'),
    ('c_check_warning_graph.c', 'check_input_interrupt_calls', 'reader->parser->options.scalar ? 0 : 1'),
    ('c_check_warning_graph.c', 'check_warning_graph_side_effects', 'parser->options.scalar ? 0 : 1'),
    ('c_check_warning_graph.c', 'check_warning_graph_constant_queries', 'reader->parser->options.scalar ? 0 : 1'),
    ('c_check_warning_graph.c', 'check_warning_graph_generics', 'reader->parser->options.scalar ? 0 : 1'),
    ('c_check_warning_graph.c', 'check_input_warning_graph', 'parser->options.scalar ? 0 : 1'),
    ('c_check_warning_undefined.c', 'check_warning_undefined_declaring', 'scalar ? 0 : 1'),
    ('c_check_warning_undefined.c', 'check_warning_undefined_internal', 'parser->options.scalar ? 0 : 1'),
    ('c_check_typo.c', 'check_typo_distance', '(vector ? 2 : 0) + (a_length != 0 && a_length <= 64 ? 1 : 0)'),
    ('c_check_typo.c', 'check_typo_prefilter', 'vector ? 1 : 0'),
    ('c_check_typo.c', 'check_typo_builtins_before', 'reader->parser->options.scalar ? 0 : 1'),
    ('c_check_return_flow.c', 'check_program_return_facts', 'scalar ? 0 : 1'),
    ('c_check_common_warnings.c', 'check_common_expansion_point', 'parser->options.scalar ? 0 : 1'),
    ('c_check_common_warnings.c', 'check_common_rejected_initializer_commas', 'parser->options.scalar ? 0 : 1'),
    ('c_check_common_warnings.c', 'check_driver_common_warnings', 'parser->options.scalar ? 0 : 1'),
    ('c_check_common_warnings.c', 'check_common_unselected_roots_indexed', 'parser->options.scalar ? 0 : 1'),
]
PRELUDE = r'''
#ifndef BUSTER_WCENSUS_DEFINED
#define BUSTER_WCENSUS_DEFINED 1
#include <stdio.h>
#include <stdlib.h>
static uint64_t check_wcensus[%d][4];
static const char* const check_wcensus_names[%d] = { %s };
#define BUSTER_WCENSUS(id, arm) __atomic_fetch_add(&check_wcensus[(id)][(arm) & 3], 1, __ATOMIC_RELAXED)
static void check_wcensus_print(void)
{
    FILE* file = fopen(getenv("BUSTER_WCENSUS"), "a");
    for (uint32_t i = 0; file != NULL && i < %d; i += 1)
    {
        if (check_wcensus[i][0] + check_wcensus[i][1] + check_wcensus[i][2] + check_wcensus[i][3] != 0)
        {
            fprintf(file, "wcensus %%s %%llu %%llu %%llu %%llu\n", check_wcensus_names[i], (unsigned long long)check_wcensus[i][0],
                    (unsigned long long)check_wcensus[i][1], (unsigned long long)check_wcensus[i][2], (unsigned long long)check_wcensus[i][3]);
        }
    }
    if (file != NULL)
    {
        fclose(file);
    }
}
__attribute__((constructor)) static void check_wcensus_register(void)
{
    const char* on = getenv("BUSTER_WCENSUS");
    if (on != NULL && *on != 0)
    {
        atexit(check_wcensus_print);
    }
}
#endif
'''
names = ', '.join('"%s"' % s[1] for s in SITES)
prelude = PRELUDE % (len(SITES), len(SITES), names, len(SITES))
files = {}
for i, (f, fn, arm) in enumerate(SITES):
    p = os.path.join(C, f)
    s = files.get(p) or open(p).read()
    lines = s.split('\n')
    k = None
    for j, l in enumerate(lines):
        if re.match(r'^(static |BUSTER_\w+ )*[A-Za-z_][\w \*]*?\b' + fn + r'\(', l):
            m = j
            while lines[m] != '{' and not lines[m].rstrip().endswith(';'):
                m += 1
            if lines[m] == '{':
                k = m
                break
    assert k is not None, fn
    lines.insert(k + 1, '    BUSTER_WCENSUS(%d, %s);' % (i, arm))
    files[p] = '\n'.join(lines)
for p, s in files.items():
    # the prelude goes before the file's first line that isn't a comment or blank
    lines = s.split('\n')
    j = 0
    while j < len(lines) and (lines[j].startswith('//') or lines[j].strip() == ''):
        j += 1
    lines.insert(j, prelude)
    open(p, 'w').write('\n'.join(lines))
    print(p, 'patched')
