// Compare two independent original-source compilations down to the grammar and traversal columns.
#include "buster/compiler/c_preprocessor_benchmark.c"
#include "buster/compiler/c_parser.c"
_Thread_local char oracle_temporary_buffer[BUSTER_TEST_TEMPORARY_BYTES];

int main(int argc,char** argv)
{
    Arena arena=arena_reserve(UINT64_C(1)<<31);
    PPOptions options;
    const char *input,*out;
    bool markers;
    if (!pp_parse_options(argc-1,argv+1,&options,&arena,&input,&out,&markers)) return 2;
    options.defer_history=true;
    options.collect_diagnostics=true;
    static Preprocessor pp[2]; static InternTable names[2]; static Parser p[2];
    bool parsed[2]={0};
    for (uint32_t mode=0; mode<2; mode++)
    {
        if (!intern_initialize(&names[mode]) || !pp_initialize(&pp[mode],&options,&names[mode]) ||
            !parse_initialize(&p[mode],&(ParseOptions){.sizes=true},options.language)) return 3;
        if (mode) parse_begin_source_forest(&p[mode],&pp[mode]);
        if (!pp_run_input(&pp[mode],input)) return 4;
        pp[mode].source_range=NULL; pp[mode].source_forest=NULL;
        parsed[mode]=parse_translation_unit(&p[mode],&pp[mode]);
    }
    const uint32_t count=p[0].tokens.count;
    if (parsed[0]!=parsed[1] || p[0].tokens.count!=p[1].tokens.count || p[0].tokens.pragma_count!=p[1].tokens.pragma_count) return 5;
    uint32_t bad=0;
    for (uint32_t i=0;i<count;i++)
    {
        bool diff=p[0].tokens.kinds[i]!=p[1].tokens.kinds[i] || p[0].tokens.flags[i]!=p[1].tokens.flags[i] ||
                  p[0].tokens.names[i]!=p[1].tokens.names[i] || parse_source_index(&p[0].tokens,i)!=parse_source_index(&p[1].tokens,i);
        if (parsed[0]) diff |= p[0].tree.roles[i]!=p[1].tree.roles[i] || p[0].tree.depths[i]!=p[1].tree.depths[i] ||
                  p[0].tree.parents[i]!=p[1].tree.parents[i] || p[0].postorder[i]!=p[1].postorder[i] ||
                  p[0].positions[i]!=p[1].positions[i] || p[0].ends[i]!=p[1].ends[i] || p[0].sizes[i]!=p[1].sizes[i] ||
                  p[0].first_children[i]!=p[1].first_children[i] || p[0].next_siblings[i]!=p[1].next_siblings[i];
        if (diff && bad<4) fprintf(stderr,"different-row\t%u\n",i);
        bad+=diff;
    }
    for (uint32_t k=0;k<p[0].tokens.pragma_count;k++)
        bad+=p[0].tokens.pragma_sources[k]!=p[1].tokens.pragma_sources[k] || p[0].tokens.pragma_positions[k]!=p[1].tokens.pragma_positions[k];
    printf("rows=%u\tpragmas=%u\tdifferent=%u\tparsed=%u\n",count,p[0].tokens.pragma_count,bad,parsed[0]);
    return bad!=0;
}
