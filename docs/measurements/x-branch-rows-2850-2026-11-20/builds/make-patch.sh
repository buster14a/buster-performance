#!/bin/bash
# make-patch.sh OUT [TREE]: the experiment's patch of the working tree's code for a 9700X label: the piece's nine
# files (TREE's, default /home/user/buster-x1) over main 00faef7dd's src and tools (the labels' lineage: no other
# commit of main's has touched the nine since), with the branches' rows' switch (BUSTER_TESTS_SKIP=1: the branches'
# template is the mark that lists its expression, the sweep lists no record evaluated as branches and a chunk with no
# update has no sweep, as the piece before had it).
out=$1; tree=${2:-/home/user/buster-x1}
s=/tmp/claude-0/-home-user/750b08ae-4cd9-565b-b66d-6cb5ef06cd50/scratchpad/xbx
rm -rf $s && mkdir -p $s/a $s/b || exit 1
git -C "$tree" archive 00faef7dd src tools | tar -x -C $s/a
git -C "$tree" archive 00faef7dd src tools | tar -x -C $s/b
for f in src/buster/compiler/c_check_node_census.c src/buster/compiler/c_check_node_census_test.c src/buster/compiler/c_check_node_machine_facts.c \
         src/buster/compiler/c_check_node_machine_front.c src/buster/compiler/c_check_node_machine_reader.c src/buster/compiler/c_check_node_machine_rows.c \
         src/buster/compiler/c_check_node_machine_window.c src/buster/compiler/main.c tools/ci/build_regression.c; do
    cp "$tree/$f" "$s/b/$f" || exit 1
done
python3 - "$s/b/src/buster/compiler/c_check_node_machine_rows.c" <<'PY'
import sys
p=sys.argv[1]
s=open(p).read()
def rep(old,new):
    global s
    assert s.count(old)==1, (s.count(old), old[:70])
    s=s.replace(old,new)
rep('''// One entry of the table's row `shape`, in its slot `slot`: a row whose entries have fixed slots.
''','''// The experiment's switch (BUSTER_TESTS_SKIP=1): the branches' rows off, their template the mark that lists its
// expression, as the piece before had it.
static bool node_rows_branches_off;
static __attribute__((constructor)) void node_rows_switch(void)
{
    const char* value = getenv("BUSTER_TESTS_SKIP");
    node_rows_branches_off = value != NULL && value[0] == '1';
}

// One entry of the table's row `shape`, in its slot `slot`: a row whose entries have fixed slots.
''')
rep('''    tables->templates[NODE_MACHINE_TEMPLATE_SECOND] = BUSTER_NODE_ROWS_LATER;
''','''    tables->templates[NODE_MACHINE_TEMPLATE_SECOND] = BUSTER_NODE_ROWS_LATER;
    tables->templates[NODE_MACHINE_TEMPLATE_BRANCHES] = node_rows_branches_off ? BUSTER_NODE_ROWS_LATER : 0;
''')
rep("    const bool branching = state->c_branches_now != 0;\n", "    const bool branching = !node_rows_branches_off && state->c_branches_now != 0;\n")
assert s.count("    if ((state->c_updates_now | state->c_branches_now) != 0)\n") == 2
s = s.replace("    if ((state->c_updates_now | state->c_branches_now) != 0)\n", "    if ((state->c_updates_now | (node_rows_branches_off ? 0 : state->c_branches_now)) != 0)\n")
open(p,'w').write(s)
PY
[ $? = 0 ] || exit 1
(cd $s && diff -ruN a b) > "$out"
grep -c "^+++ " "$out"; wc -c < "$out"
