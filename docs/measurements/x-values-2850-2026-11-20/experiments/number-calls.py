#!/usr/bin/env python3
# number-calls.py TREE: an experiment's edit of TREE in place (never committed), applied to the tree before the
# numbering's test for two marked records was removed (the line it edits is that test's, as it was): counts, printed to
# stderr as the process ends, of node_rows_window_number's calls by the marked records its expression's operand has:
# none, one, two or more. The question: whether the routine is ever called for an expression with fewer than two (the
# fault `number-with-one`). number-calls/ has the three corpora's outputs and the fixtures' (test-checker's part 5): it
# is not.
import sys
tree = sys.argv[1]
p = tree + '/src/buster/compiler/c_check_node_machine_rows.c'
t = open(p).read()
old = "    const bool numbers = marks >= 2 && state->c_verdicts[e] == BUSTER_NODE_CONTEXTS_TAKEN && !node_contexts_window_any(state->window_c_masks, BUSTER_NODE_ROWS_MASK_LISTED, first, size);\n"
assert t.count(old) == 1
t = t.replace(old, "    node_rows_experiment_calls[marks < 2 ? marks : 2] += 1;\n" + old)
i = t.index("// The numbers of the expression whose operand's last record is the window's `top`")
t = t[:i] + """static uint64_t node_rows_experiment_calls[3];
__attribute__((destructor)) static void node_rows_experiment_calls_print(void)
{
    if ((node_rows_experiment_calls[0] | node_rows_experiment_calls[1] | node_rows_experiment_calls[2]) != 0)
    {
        fprintf(stderr, "experiment-number: calls with no marked record in its operand=%llu with one=%llu with two or more=%llu\\n", (unsigned long long)node_rows_experiment_calls[0],
                (unsigned long long)node_rows_experiment_calls[1], (unsigned long long)node_rows_experiment_calls[2]);
    }
}

""" + t[i:]
open(p, 'w').write(t)
