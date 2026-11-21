#include "buster/compiler/c_lexer.c"
#include "buster/compiler/lane.c"
#include "buster/compiler/c_intern.c"
#include "buster/compiler/c_refine.c"
#include "buster/compiler/c_predefines.c"
#include "buster/compiler/c_preprocessor.c"

static uint64_t raw_ns(void)
{
    struct timespec t;clock_gettime(CLOCK_MONOTONIC_RAW,&t);
    return UINT64_C(1000000000)*t.tv_sec+t.tv_nsec;
}
int main(int argc,char** argv)
{
    int split=1;while(split<argc && strcmp(argv[split],"--"))split++;
    if(split+1>=argc)return 2;argv[split]=argv[split+1];
    Arena arena=arena_reserve(UINT64_C(1)<<30);PPOptions opts;const char *in,*out;bool markers;
    if(!pp_parse_options(split,argv+1,&opts,&arena,&in,&out,&markers))return 2;
    uint64_t tokens=0,setup=0,run=0,release=0,rows=0,observed=0;
    const bool consume=getenv("BUSTER_TEST_PP_RETURN_CONSUME")!=NULL;
    for(int f=split+1;f<argc;f++)
    {
        static Preprocessor pp;static InternTable names;
        uint64_t a=raw_ns();
        if(!intern_initialize(&names)||!pp_initialize(&pp,&opts,&names))return 3;
        uint64_t b=raw_ns();
        if(!pp_run(&pp,argv[f]))return 4;
        uint64_t c=raw_ns();tokens+=pp.output.count;
#ifdef PP_BANK_COVERAGE
        fprintf(stderr, "visits %s %lu %lu %lu %lu banks %lu %lu %lu %lu %lu\n", argv[f],pp_bank_blocks,pp_bank_partial,pp_bank_tested,pp_bank_visited,
                pp_bank_bins[0],pp_bank_bins[1],pp_bank_bins[2],pp_bank_bins[3],pp_bank_bins[4]);
        pp_bank_blocks=pp_bank_partial=pp_bank_tested=pp_bank_visited=0;
        memset(pp_bank_bins,0,sizeof(pp_bank_bins));
#else
        (void)consume;
#endif

        const uint64_t x=raw_ns();pp_release(&pp);intern_release(&names);uint64_t y=raw_ns();
        setup+=b-a;run+=c-b;release+=y-x;
    }
    arena_release(&arena);
    printf("front %lu %lu %lu %lu %lu %lu\n",tokens,rows,observed,setup,run,release);return 0;
}
