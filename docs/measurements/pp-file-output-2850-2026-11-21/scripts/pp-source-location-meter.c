#include "buster/compiler/c_lexer.c"
#include "buster/compiler/lane.c"
#include "buster/compiler/c_intern.c"
#include "buster/compiler/c_refine.c"
#include "buster/compiler/c_predefines.c"
#include "buster/compiler/c_preprocessor.c"

static uint64_t ns(void)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC_RAW, &t);
    return UINT64_C(1000000000)*t.tv_sec+t.tv_nsec;
}

static uint64_t digest(const uint32_t* data, uint32_t count, uint32_t base)
{
    __m512i sum = _mm512_setzero_si512();
    for (uint32_t t = 0; t < count; t += 16)
    {
        const uint32_t live = count - t < 16 ? count - t : 16;
        const __mmask16 mask = (__mmask16)_bzhi_u32(UINT32_MAX, live);
        const __m512i values = _mm512_maskz_add_epi32(mask, _mm512_maskz_loadu_epi32(mask, data+t), _mm512_set1_epi32(base));
        sum = _mm512_add_epi64(sum, _mm512_cvtepu32_epi64(_mm512_castsi512_si256(values)));
        sum = _mm512_add_epi64(sum, _mm512_cvtepu32_epi64(_mm512_extracti64x4_epi64(values,1)));
    }
    return (uint64_t)_mm512_reduce_add_epi64(sum);
}

int main(int argc,char** argv)
{
    int split=1;while(split<argc && strcmp(argv[split],"--"))split++;
    if(split+1>=argc)return 2;argv[split]=argv[split+1];
    Arena arena=arena_reserve(UINT64_C(1)<<30);PPOptions opts;const char *in,*out;bool markers;
    if(!pp_parse_options(split,argv+1,&opts,&arena,&in,&out,&markers))return 2;
    const bool consume = getenv("BUSTER_LOCATION_CONSUME") != NULL;
    for(int f=split+1;f<argc;f++)
    {
        static Preprocessor pp;static InternTable names;
        const uint64_t setup=ns();
        if(!intern_initialize(&names)||!pp_initialize(&pp,&opts,&names))return 3;
        const uint64_t start=ns();
        if(!pp_run(&pp,argv[f]))return 4;
        const uint64_t end=ns();
        uint32_t runs=0,covered=0;uint64_t checksum=0;
        for (int pass=0; consume && pass<8; pass++)
        {
            uint32_t p=0;checksum=0;const uint64_t previous=ns();
#ifdef LOCATION_VIEW
            if (pp.location_mode >= 3)
            {
                for(uint32_t i=0;i<pp.location_run_count;i++)
                {
                    const PPFileLocationRun* r=&pp.location_runs[i];
                    if(r->output<p || r->output+r->count>pp.output.count)return 5;
                    checksum+=digest(pp.output.locations+p,r->output-p,0);
                    checksum+=digest(r->starts,r->count,r->base);
                    p=r->output+r->count;
                }
            }
#endif
            checksum+=digest(pp.output.locations+p,pp.output.count-p,0);
            printf("consume %d %u %lu %lu\n",pass,pp.output.count,checksum,ns()-previous);
        }
#ifdef LOCATION_VIEW
        runs=pp.location_run_count;covered=pp.location_rows;
#endif
        const uint32_t count=pp.output.count;const uint64_t release=ns();pp_release(&pp);intern_release(&names);
        printf("front %u %u %u %lu %lu %lu\n",count,runs,covered,start-setup,end-start,ns()-release);
    }
    arena_release(&arena);return 0;
}
