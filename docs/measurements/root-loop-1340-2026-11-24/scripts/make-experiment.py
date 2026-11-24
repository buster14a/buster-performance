#!/usr/bin/env python3
# Writes scripts/experiment-roots.patch from the working tree: the throwaway switches (BUSTER_EXPERIMENT_ROOTS, a mask)
# that leave parts of the roots' loop out, for the 9700X's readings of what each part costs. Not for merge.
import subprocess, sys, shutil
p='src/buster/compiler/c_check_common_warnings.c'
orig=open(p).read(); t=orig
def rep(old,new):
    global t
    assert t.count(old)==1,(t.count(old),old[:70])
    t=t.replace(old,new)
rep('''typedef struct CheckCommonNote CheckCommonNote;''','''// EXPERIMENT (not for merge): BUSTER_EXPERIMENT_ROOTS's mask of what the roots' loop leaves out, read once.
// 1: every calm root is quiet (no root asks the parser or its call); 2: a call's root is quiet; 4: a marker's root is
// quiet without its place; 8: no -Wunsequenced marks; 16: the loop visits no root; 32: nor are the roots classified;
// 64: no -Wunsequenced walk of a candidate; 128: no unsequenced plans; 256: no wrapper is a sole modification's.
static uint32_t check_experiment_roots(void)
{
    static uint32_t mask;
    static bool read;
    if (!read)
    {
        const char* text = getenv("BUSTER_EXPERIMENT_ROOTS");
        mask = text != NULL ? (uint32_t)strtoul(text, NULL, 0) : 0;
        read = true;
    }
    return mask;
}

typedef struct CheckCommonNote CheckCommonNote;''')
rep('''                                  (voided || !check_common_discarded_place(parser, token));''','''                                  (voided || (check_experiment_roots() & 4) != 0 || !check_common_discarded_place(parser, token));''')
rep('''                const bool uncalled = (kind & BUSTER_CHECK_ROOT_OP_CALL) != 0 && ''','''                const bool uncalled = (kind & BUSTER_CHECK_ROOT_OP_CALL) != 0 && ((check_experiment_roots() & 2) != 0 || ''')
rep('''.wanted;
                settled |=''','''.wanted);
                settled |=''')
rep('''        const uint64_t placed = calm & (cast | marker | call);''','''        const uint64_t placed = (check_experiment_roots() & 1) != 0 ? 0 : calm & (cast | marker | call);''')
rep('''        const uint64_t quiet = calm & ((silent & ~cast) | settled) & ~candidates;''','''        const uint64_t quiet = (check_experiment_roots() & 1) != 0 ? calm & ~candidates : calm & ((silent & ~cast) | settled) & ~candidates;''')
rep('''&ignored, check_common_enabled(pp, input, CHECK_WARNING_ID_UNSEQUENCED, false),''','''&ignored, check_common_enabled(pp, input, CHECK_WARNING_ID_UNSEQUENCED, false) && (check_experiment_roots() & 8) == 0,''')
rep('''        if (!check_common_root_classes(''','''        if ((check_experiment_roots() & 32) == 0 && !check_common_root_classes(''')
rep('''        for (uint32_t node = check_common_root_order_next(graph, parents, facts->roots, &order); node < graph->count && !pp->fatal;
             node = check_common_root_order_next(graph, parents, facts->roots, &order))
        {
            // (A pending plan's key''','''        for (uint32_t node = (check_experiment_roots() & 48) != 0 ? graph->count : check_common_root_order_next(graph, parents, facts->roots, &order); node < graph->count && !pp->fatal;
             node = check_common_root_order_next(graph, parents, facts->roots, &order))
        {
            // (A pending plan's key''')
rep('''            if (unsequenced_candidate && !unsequenced_dropped && !pp->fatal)''','''            if (unsequenced_candidate && !unsequenced_dropped && !pp->fatal && (check_experiment_roots() & 64) == 0)''')
rep('''        const uint64_t* unsequenced_plans = unsequenced_marks != NULL ? check_unseq_plans(''','''        const uint64_t* unsequenced_plans = unsequenced_marks != NULL && (check_experiment_roots() & 128) == 0 ? check_unseq_plans(''')
rep('''        const uint64_t wrapped = tree ? roots & wrapper & modifies : 0;''','''        const uint64_t wrapped = tree && (check_experiment_roots() & 256) == 0 ? roots & wrapper & modifies : 0;''')
open(p,'w').write(t)
patch=subprocess.run(['git','diff','--',p],capture_output=True,text=True).stdout
open(p,'w').write(orig)
base=subprocess.run(['git','diff','--',p],capture_output=True,text=True).stdout
# the experiment alone: the diff of the experiment's file against the working file
import tempfile, os
a=tempfile.NamedTemporaryFile('w',delete=False,suffix='.c'); a.write(orig); a.close()
b=tempfile.NamedTemporaryFile('w',delete=False,suffix='.c'); b.write(t); b.close()
d=subprocess.run(['diff','-u',a.name,b.name],capture_output=True,text=True).stdout
d=d.replace(a.name,'a/'+p).replace(b.name,'b/'+p)
open(sys.argv[1],'w').write(d)
os.unlink(a.name); os.unlink(b.name)
