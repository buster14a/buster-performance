#!/usr/bin/env python3
# start-two-after.py TREE: an experiment's edit of TREE in place (never committed): in the values' sweep
# (c_check_node_machine_rows.c), the first marked records of a block found with an expression's start two records after
# the end before it, beside the code's own (one record after), and counts printed to stderr as the process ends: the
# blocks, those where the two differ, and the marked records that are two after an end. The question: whether a
# program separates the two starts, which the first round's fixture did not (the fault `seconds-starts-two-on`).
# start-two-after/ has the three corpora's outputs: they do, a call with no argument right after a condition.
import sys
tree = sys.argv[1]
p = tree + '/src/buster/compiler/c_check_node_machine_rows.c'
t = open(p).read()
old = "        const uint64_t first_marks = marks & ~(marks - ((ends << 1) | 1));\n"
assert t.count(old) == 1
t = t.replace(old, old + """        {
            const uint64_t other = marks & ~(marks - ((ends << 2) | 1));
            static uint64_t experiment_blocks, experiment_differ, experiment_after;
            experiment_blocks += 1;
            experiment_differ += other != first_marks;
            experiment_after += (uint64_t)_mm_popcnt_u64(marks & (ends << 2));
            if (other != first_marks && experiment_differ < 6)
            {
                fprintf(stderr, "experiment-start: block=%u token=%u marks=%#llx ends=%#llx first=%#llx other=%#llx\\n", block, front->tokens[x], (unsigned long long)marks, (unsigned long long)ends,
                        (unsigned long long)first_marks, (unsigned long long)other);
            }
            node_rows_experiment[0] = experiment_blocks; node_rows_experiment[1] = experiment_differ; node_rows_experiment[2] = experiment_after;
        }
""")
i = t.index("// The entries' values of a chunk's `count` records")
t = t[:i] + """static uint64_t node_rows_experiment[3];
__attribute__((destructor)) static void node_rows_experiment_print(void)
{
    if (node_rows_experiment[0] != 0)
    {
        fprintf(stderr, "experiment-starts: blocks=%llu differ=%llu marks-two-after-an-end=%llu\\n", (unsigned long long)node_rows_experiment[0], (unsigned long long)node_rows_experiment[1],
                (unsigned long long)node_rows_experiment[2]);
    }
}

""" + t[i:]
open(p, 'w').write(t)
