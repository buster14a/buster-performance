#include "buster/compiler/c_lexer.c"
#include "buster/compiler/lane.c"
#include "buster/compiler/c_intern.c"
#include "buster/compiler/c_refine.c"
#include "buster/compiler/c_predefines.c"
#include "buster/compiler/c_preprocessor.c"
#include "buster/compiler/c_parser.c"

static uint64_t clock_ns(void) {
    struct timespec now;clock_gettime(CLOCK_MONOTONIC_RAW,&now);
    return (uint64_t)now.tv_sec*1000000000ull+now.tv_nsec;
}
static uint64_t grammar_hash(const ParseTokens* s) {
    uint64_t x=23;
    for(uint32_t i=0;i<s->count;i++) {
        uint64_t row=s->names[i]+((uint64_t)s->kinds[i]<<32)+((uint64_t)s->flags[i]<<40);
        x=(x<<7 | x>>57)^row;
    }
    return x;
}
int main(int argc,char** argv) {
    int split=1;while(split<argc && strcmp(argv[split],"--"))split++;
    if(split+2!=argc)return 2;
    const char* path=argv[split+1];argv[split]=argv[split+1];
    Arena args=arena_reserve(UINT64_C(1)<<30);PPOptions opts;const char *in,*out;bool markers;
    if(!pp_parse_options(split,argv+1,&opts,&args,&in,&out,&markers))return 2;
    opts.defer_history=true;opts.semantic_pragmas=true;
    static Preprocessor pp;static InternTable names;static Parser parser;
    ParseOptions config={.tree_only=true};
    uint64_t start=clock_ns();
    if(!intern_initialize(&names)||!pp_initialize(&pp,&opts,&names)||!parse_initialize(&parser,&config,opts.language))return 3;
#ifdef PP_GRAMMAR
    parse_grammar_begin(&parser,&pp);
#endif
    uint64_t prep=clock_ns();
    if(!pp_run(&pp,path))return 4;
    uint64_t output=clock_ns();
#ifdef PP_GRAMMAR
    const bool offered=pp.grammar_owner==&parser && !parser.grammar_failed && parser.grammar_stream.kinds && parser.grammar_stream.count==pp.output.count;
#else
    const bool offered=false;
#endif
    if(!parse_translation_unit(&parser,&pp)||parser.fatal||parser.errors)return 5;
    uint64_t parsed=clock_ns();
    const uint32_t rows=parser.tokens.count, tokens=pp.output.count;
    if(getenv("BUSTER_TEST_SCOPE_KERNEL")) {
        const uint64_t expected=grammar_hash(&parser.tokens);
        for(uint32_t r=0;r<14;r++) for(uint32_t j=0;j<4;j++) {
            const uint32_t arms[4]={0,2,1,3};
            uint32_t mode=arms[(r & 1) ? (r+3-j)%4 : (r+j)%4];
            uint64_t a=__rdtsc();bool possible=true;
#ifdef PP_SCOPE
            if(mode==1 || mode==2)possible=parse_tokens_and_scope(&pp.output,&parser.tokens,true);
            else
#endif
            parse_tokens_from_output(&pp.output,&parser.tokens);
            uint64_t b=__rdtsc();
            parse_mark_pragma_packs(&pp,&parser.tokens);
#ifdef PP_SCOPE
            if(mode==3)possible=parse_grammar_has_scope(&parser.tokens);
#endif
            if(((mode!=2 && mode!=3) || possible) && !parse_clang_scope_numbers(&parser,&pp))return 6;
            uint64_t c=__rdtsc();
            uint64_t hash=grammar_hash(&parser.tokens),d=__rdtsc();
            if(hash!=expected)return 7;
            printf("scope-kernel %u %u %u %u %lu %lu %lu %lu\n",r,mode,rows,possible,b-a,c-b,d-c,hash);
        }
    }
    uint64_t finish=clock_ns();parse_release(&parser);pp_release(&pp);intern_release(&names);arena_release(&args);uint64_t done=clock_ns();
    printf("stream-front %u %u %u %lu %lu %lu %lu\n",tokens,rows,offered,prep-start,output-prep,parsed-output,done-finish);
    return 0;
}
