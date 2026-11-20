#!/usr/bin/env python3
# object-kinds.py TREE: an experiment's edit of TREE in place (never committed): counts, printed to stderr as the
# process ends, of the window's placed records by whether they have an object and what their constant's kind is
# (none, an address's, another), over every record the tests' sweep makes a value of (c_check_node_census.c) and over
# the records each of the values' loops reads a record's value of (c_check_node_machine_rows.c: the first list, a
# store by name's destination, the constants, an update by name's destination); and a line for each record on the first
# list that has an object and no constant. The question: whether "its object's number where it has one" needs the
# constant's kind beside it. Applied to the tree before the mask was reduced to the object's test (the line it edits
# is the mask's, as it was: `~null & (~some | address)`).
import sys
tree = sys.argv[1]
def edit(path, pairs):
    t = open(tree + '/' + path).read()
    for old, new in pairs:
        assert t.count(old) == 1, (path, old[:60], t.count(old))
        t = t.replace(old, new)
    open(tree + '/' + path, 'w').write(t)
CENSUS = 'src/buster/compiler/c_check_node_census.c'
ROWS = 'src/buster/compiler/c_check_node_machine_rows.c'
t = open(tree + '/' + CENSUS).read()
line = "                const uint32_t designates = ~null & (~some | address);\n"
assert t.count(line) == 1
i = t.index(line)
j = t.rfind("\nstatic ", 0, i)
t = t[:j] + '''

static uint64_t buster_experiment_counts[4];
__attribute__((destructor)) static void buster_experiment_print(void)
{
    if (buster_experiment_counts[3] != 0)
    {
        fprintf(stderr, "experiment: placed=%" PRIu64 " with-object=%" PRIu64 " object-and-other-constant=%" PRIu64 " object-and-no-constant=%" PRIu64 "\\n",
                buster_experiment_counts[3], buster_experiment_counts[2], buster_experiment_counts[0], buster_experiment_counts[1]);
    }
}
''' + t[j:]
t = t.replace(line, line + '''                buster_experiment_counts[0] += (uint64_t)__builtin_popcount((uint32_t)placed & ~null & some & ~address & 0xffffu);
                buster_experiment_counts[1] += (uint64_t)__builtin_popcount((uint32_t)placed & ~null & ~some & 0xffffu);
                buster_experiment_counts[2] += (uint64_t)__builtin_popcount((uint32_t)placed & ~null & 0xffffu);
                buster_experiment_counts[3] += (uint64_t)__builtin_popcount((uint32_t)placed & 0xffffu);
''')
open(tree + '/' + CENSUS, 'w').write(t)
t = open(tree + '/' + ROWS).read()
i = t.index("// The entries' values of a chunk's `count` records")
t = t[:i] + '''static uint64_t buster_experiment_lists[4][8];
static void buster_experiment_class(uint32_t list, const NodeFactsRecord* record)
{
    const uint32_t kind = (record->standing >> 2) & 7u;
    buster_experiment_lists[list][(record->object != 0 ? 4u : 0u) | (kind == 0 ? 0u : kind == CHECK_CONSTANT_ADDRESS ? 1u : 2u)] += 1;
}
__attribute__((destructor)) static void buster_experiment_lists_print(void)
{
    static const char* names[4] = { "first", "stored-destination", "constant", "update-destination" };
    for (uint32_t list = 0; list < 4; list += 1)
    {
        const uint64_t* c = buster_experiment_lists[list];
        if ((c[0] | c[1] | c[2] | c[4] | c[5] | c[6]) != 0)
        {
            fprintf(stderr, "experiment-list %s: no-object: no-constant=%" PRIu64 " address=%" PRIu64 " other=%" PRIu64 "; object: no-constant=%" PRIu64 " address=%" PRIu64 " other=%" PRIu64 "\\n",
                    names[list], c[0], c[1], c[2], c[4], c[5], c[6]);
        }
    }
}

''' + t[i:]
open(tree + '/' + ROWS, 'w').write(t)
edit(ROWS, [
("""        const uint32_t x = firsts[i];
        values[cursors[x / 8] + offsets[x]] = record_values[x];
""", """        const uint32_t x = firsts[i];
        values[cursors[x / 8] + offsets[x]] = record_values[x];
        buster_experiment_class(0, state->facts.records + x);
        if (state->facts.records[x].object != 0 && ((state->facts.records[x].standing >> 2) & 7u) == 0)
        {
            fprintf(stderr, "experiment-first: token=%u own=%u conversion=%u template=%u object=%u payload=%llu value=%llu first-kind=%u\\n", front->tokens[x], state->window_x_owns[x],
                    state->window_x_conversions[x], state->window_c_templates[x], state->facts.records[x].object, (unsigned long long)state->facts.records[x].payload,
                    (unsigned long long)record_values[x], tables->kinds[0][state->window_x_owns[x]]);
        }
"""),
("""        const uint32_t x = stored[i];
        values[cursors[x / 8] + offsets[x]] = record_values[x - lefts[x]];
""", """        const uint32_t x = stored[i];
        values[cursors[x / 8] + offsets[x]] = record_values[x - lefts[x]];
        buster_experiment_class(1, state->facts.records + (x - lefts[x]));
"""),
("""        values[place] = node_rows_extend(node_rows_extend(record_values[x], own_classes[x]), entry_classes[place]);
""", """        values[place] = node_rows_extend(node_rows_extend(record_values[x], own_classes[x]), entry_classes[place]);
        buster_experiment_class(2, state->facts.records + x);
"""),
("""        values[last + ((BUSTER_NODE_ROWS_ENTRY_NOWHERE - last) & (0u - through))] = record_values[destination];
""", """        values[last + ((BUSTER_NODE_ROWS_ENTRY_NOWHERE - last) & (0u - through))] = record_values[destination];
        if (through == 0)
        {
            buster_experiment_class(3, state->facts.records + destination);
        }
"""),
])
