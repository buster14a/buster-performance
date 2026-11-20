#!/bin/bash
# make-switch-patch.sh OUT: the experiment's patch of the working tree's code (src and tools against main 00faef7dd)
# with the update's rows' switch (BUSTER_TESTS_SKIP=1: an update's template is the mark that lists its expression and
# the updates' sweep takes no update, as the piece before had it).
out=$1
s=${SCRATCH:-/tmp/x-update-scratch}/xux
rm -rf $s && mkdir -p $s/a $s/b || exit 1
git -C /home/user/buster-x1 archive 00faef7dd src tools | tar -x -C $s/a
cp -r /home/user/buster-x1/src $s/b/src && cp -r /home/user/buster-x1/tools $s/b/tools
python3 - "$s/b/src/buster/compiler/c_check_node_machine_rows.c" <<'PY'
import sys
p=sys.argv[1]
s=open(p).read()
def rep(old,new):
    global s
    assert s.count(old)==1, old[:60]
    s=s.replace(old,new)
rep('''// One entry of the table's row `shape`, in its slot `slot`: a row whose entries have fixed slots.
''','''// The experiment's switch (BUSTER_TESTS_SKIP=1): an update's rows off, its template the mark that lists its
// expression, as the piece before had it.
static bool node_rows_updates_off;
static __attribute__((constructor)) void node_rows_switch(void)
{
    const char* value = getenv("BUSTER_TESTS_SKIP");
    node_rows_updates_off = value != NULL && value[0] == '1';
}

// One entry of the table's row `shape`, in its slot `slot`: a row whose entries have fixed slots.
''')
rep('''    tables->templates[NODE_MACHINE_TEMPLATE_BRANCHES] = BUSTER_NODE_ROWS_LATER;
''','''    tables->templates[NODE_MACHINE_TEMPLATE_BRANCHES] = BUSTER_NODE_ROWS_LATER;
    tables->templates[NODE_MACHINE_TEMPLATE_UPDATE] = node_rows_updates_off ? BUSTER_NODE_ROWS_LATER : 0;
''')
rep('''        const __mmask64 updated = _mm512_mask_cmpeq_epi8_mask(alive, _mm512_loadu_si512(state->window_c_templates + x), _mm512_set1_epi8((char)NODE_MACHINE_TEMPLATE_UPDATE));
''','''        const __mmask64 updated = node_rows_updates_off ? 0 : _mm512_mask_cmpeq_epi8_mask(alive, _mm512_loadu_si512(state->window_c_templates + x), _mm512_set1_epi8((char)NODE_MACHINE_TEMPLATE_UPDATE));
''')
open(p,'w').write(s)
PY
[ $? = 0 ] || exit 1
(cd $s && diff -ruN a b) > "$out"
wc -c "$out"
