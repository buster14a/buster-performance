#include "buster/compiler/c_lexer.c"
#include "buster/compiler/lane.c"
#include "buster/compiler/c_intern.c"
#include "buster/compiler/c_refine.c"
#include "buster/compiler/c_predefines.c"
#include "buster/compiler/c_preprocessor.c"

int main(int argc,char** argv)
{
    int split=1;
    while(split<argc && strcmp(argv[split],"--"))++split;
    if(split+1>=argc)return 2;
    argv[split]=argv[split+1];
    Arena arena=arena_reserve(UINT64_C(1)<<30);
    PPOptions opts;const char *in,*out;bool markers;
    if(!pp_parse_options(split,argv+1,&opts,&arena,&in,&out,&markers))return 2;
    for(int f=split+1;f<argc;f++)
    {
        static Preprocessor pp;static InternTable names;
        if(!intern_initialize(&names)||!pp_initialize(&pp,&opts,&names)||!pp_run(&pp,argv[f]))return 3;
        off_t start=ftello(stdout);
        if(!pp_print(&pp,stdout,false) || fflush(stdout)) return 4;
        fprintf(stderr,"%s %u %lu\n",argv[f],pp.output.count,(uint64_t)(ftello(stdout)-start));
        pp_release(&pp);intern_release(&names);
    }
    arena_release(&arena);return 0;
}
