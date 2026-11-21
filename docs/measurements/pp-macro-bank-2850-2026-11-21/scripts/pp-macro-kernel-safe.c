#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    uint64_t* bitmap;
    uint32_t values[64];
    uint64_t tested;
    uint32_t width;
} BankVisit;
static BankVisit* bank_visits;
static size_t bank_count;
static size_t bank_capacity;
static uint64_t* bank_live;
static uint32_t bank_epoch;
static size_t bank_words;

static void pp_bank_capture(uint32_t epoch, const uint64_t* bitmap, uint32_t names, const uint32_t* values, uint32_t width, uint64_t tested)
{
    size_t words = (names + 63u) / 64;
    if (bank_live == NULL || epoch != bank_epoch || words > bank_words) {
        bank_words = words;
        bank_live = calloc(words + 2, sizeof(*bank_live));
        if (bank_live == NULL) abort();
        memcpy(bank_live, bitmap, words * sizeof(*bitmap));
        bank_epoch = epoch;
    }
    if (bank_count == bank_capacity) {
        bank_capacity = bank_capacity ? bank_capacity * 2 : 1024;
        bank_visits = realloc(bank_visits, bank_capacity * sizeof(*bank_visits));
        if (bank_visits == NULL) abort();
    }
    BankVisit* v = &bank_visits[bank_count++];
    v->width = width;
    v->tested = tested;
    v->bitmap = bank_live;
    memset(v->values, 0, sizeof(v->values));
    memcpy(v->values, values, width * sizeof(*values));
}
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
static uint64_t __attribute__((noinline)) bank_replay(bool filter)
{
    uint64_t hash = 0;
    Preprocessor pp = {0};
    for (size_t i=0; i<bank_count; i++) {
        BankVisit* v = &bank_visits[i];
        uint64_t selected = v->tested;
        if (filter && v->width == 64) {
            pp.is_macro = v->bitmap;
            selected = pp_file_low_bank(&pp, v->values, selected);
        }
        uint64_t active = 0;
        for (uint64_t bits = selected; bits; bits &= bits - 1) {
            uint32_t lane = (uint32_t)__builtin_ctzll(bits);
            uint32_t name = v->values[lane];
            if ((v->bitmap[name / 64] >> (name % 64)) & 1) active |= (uint64_t)1 << lane;
        }
        hash = (hash << 5 | hash >> 59) ^ active;
    }
    return hash;
}

static void bank_measure(void)
{
    const uint64_t reference = bank_replay(false);
    for (uint32_t pass=0;pass<14;pass++) {
        for (uint32_t pos=0;pos<2;pos++) {
            const bool filter = (pos ^ pass) & 1;
            const uint64_t start = __rdtsc();
            const uint64_t hash = bank_replay(filter);
            const uint64_t ticks = __rdtsc()-start;
            if (hash != reference) abort();
            printf("lookup %u %u %zu %lu %lu\n",pass,filter,bank_count,ticks,hash);
        }
    }
    for (size_t i=bank_count;i>0;i--) {
        if (i==1 || bank_visits[i-1].bitmap!=bank_visits[i-2].bitmap) free(bank_visits[i-1].bitmap);
    }
    free(bank_visits);bank_visits=NULL;bank_live=NULL;bank_count=0;bank_capacity=0;bank_epoch=0;
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

        bank_measure();
        const uint64_t x=raw_ns();pp_release(&pp);intern_release(&names);uint64_t y=raw_ns();
        setup+=b-a;run+=c-b;release+=y-x;
    }
    arena_release(&arena);
    printf("front %lu %lu %lu %lu %lu %lu\n",tokens,rows,observed,setup,run,release);return 0;
}
