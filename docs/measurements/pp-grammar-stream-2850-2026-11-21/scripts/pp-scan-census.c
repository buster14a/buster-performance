#include "buster/compiler/c_lexer.c"
#include "buster/compiler/lane.c"
#include "buster/compiler/c_intern.c"
#include "buster/compiler/c_refine.c"
#include "buster/compiler/c_predefines.c"
#include "c_preprocessor.c"
int main(int argc,char**argv) {
    int split=1;while(split<argc && strcmp(argv[split],"--"))split++;
    if(split+1>=argc)return 2;argv[split]=argv[split+1];
    Arena args=arena_reserve(UINT64_C(1)<<30);PPOptions opts;const char *in,*out;bool markers;
    if(!pp_parse_options(split,argv+1,&opts,&args,&in,&out,&markers))return 2;
    opts.defer_history=true;opts.semantic_pragmas=true;
    for(int i=split+1;i<argc;i++){
        static Preprocessor pp;static InternTable names;
        pp=(Preprocessor){0};names=(InternTable){0};memset(&scan_census,0,sizeof(scan_census));
        if(!intern_initialize(&names)||!pp_initialize(&pp,&opts,&names)||!pp_run(&pp,argv[i]))return 3;
        printf("scan-census %s %u %lu %lu %lu %lu %lu %lu %lu %lu %lu\n",argv[i],pp.output.count,scan_census.file_scans,scan_census.collector,
            scan_census.collector_file,scan_census.matched,scan_census.matched_tokens,scan_census.matched_separators,scan_census.matched_none,scan_census.direct_ticks,scan_census.repeat_ticks);
        pp_release(&pp);intern_release(&names);
    }
    arena_release(&args);return 0;
}
