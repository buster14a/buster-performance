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
#ifdef PROBE_RETURN
        if(pp.return_window.failed)return 5;
        rows+=pp.return_window.count;observed+=pp.return_window.observed;
        if(consume)
        {
            for(uint32_t pass=0;pass<8;pass++)
            {
                pp.return_window.count=0;pp.return_window.pending_count=0;pp.return_window.pragma=false;pp.return_window.observed=0;
                const uint64_t begin=raw_ns(); const uint64_t ticks=__rdtsc();
                for(uint32_t at=0;at<pp.output.count;at+=64)
                {
                    const uint32_t live=pp.output.count-at<64?pp.output.count-at:64;
                    pp_return_block(&pp,at,live,_mm512_maskz_loadu_epi8(_bzhi_u64(UINT64_MAX,live),pp.output.kinds+at));
                }
                const uint64_t end_ticks=__rdtsc(); const uint64_t end=raw_ns();
                printf("consume %u %u %u %lu %lu\n",pass,pp.output.count,pp.return_window.count,end-begin,end_ticks-ticks);
            }
        }
#else
        (void)consume;
#endif
        const uint64_t x=raw_ns();pp_release(&pp);intern_release(&names);uint64_t y=raw_ns();
        setup+=b-a;run+=c-b;release+=y-x;
    }
    arena_release(&arena);
    printf("front %lu %lu %lu %lu %lu %lu\n",tokens,rows,observed,setup,run,release);return 0;
}
