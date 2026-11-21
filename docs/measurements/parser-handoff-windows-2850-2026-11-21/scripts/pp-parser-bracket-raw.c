#include "buster/compiler/c_lexer.c"
#include "buster/compiler/lane.c"
#include "buster/compiler/c_intern.c"
#include "buster/compiler/c_refine.c"
#include "buster/compiler/c_predefines.c"
#include "buster/compiler/c_preprocessor.c"
#include "buster/compiler/c_parser.c"

static uint32_t random_state = 133;
static uint32_t random32(void)
{
    uint32_t x = random_state;
    x ^= x << 13;
    x ^= x >> 17;
    random_state = x ^ (x << 5);
    return random_state;
}
int main(void)
{
    uint8_t kinds[1152];
    uint32_t depth[1152], enclosing[1152], stack_words[1536];
    ParseBracketBlock blocks[20];
    uint32_t* stack = stack_words + 192;
    parse_tables_initialize();
    uint32_t bad = 0, total = 0;
    for (uint32_t scenario = 0; scenario < 40; ++scenario)
    {
        for (uint32_t count = 0; count <= 512; ++count)
        {
            memset(kinds, PARSE_KIND_END, sizeof(kinds));
            memset(depth, 0x00, sizeof(depth));
            memset(stack_words, 0xff, sizeof(stack_words));
            memset(enclosing, 0x00, sizeof(enclosing));
            memset(blocks, 0x00, sizeof(blocks));
            for (uint32_t i = 0; i < count; ++i)
            {
                unsigned r = random32() % 3;
                if (scenario == 0) r = 0;
                if (scenario == 1) r = 1;
                if (scenario == 2) r = i < count/2 ? 0 : 1;
                if (scenario == 3) r = i % 64 < 40 ? 1 : 0;
                if (scenario == 4) r = i/64 % 2 ? 1 : 0;
                if (scenario >= 5 && scenario < 20) r = i%64 < scenario*3 ? 1 : random32()%3;
                kinds[i] = r == 0 ? PARSE_KIND_L_PAREN : r == 1 ? PARSE_KIND_R_PAREN : PARSE_KIND_SEMI;
            }
#ifdef PROBE_BRACKET
            const bool accepted = parse_brackets_avx512(kinds,parse_kind_deltas,count,enclosing,stack,blocks);
            ParseKernels kernels = {.bracket_blocks=blocks};
            for (uint32_t i=0;i<count;i++) depth[i]=parse_bracket_depth(&kernels,i);
#else
            const bool accepted = parse_brackets_avx512(kinds,parse_kind_deltas,count,depth,enclosing,stack,blocks);
#endif
            bad += !accepted;total++;
            if (!fwrite(&accepted,sizeof(accepted),1,stdout) ||
                fwrite(depth,sizeof(*depth),count,stdout)!=count || fwrite(enclosing,sizeof(*enclosing),count,stdout)!=count) return 2;
            for (uint32_t i = 0; i < count; i += 64)
            {
                const ParseBracketBlock* b = &blocks[i/64];
                if (fwrite(b->opener_lanes,1,64,stdout)!=64 || fwrite(b->relative_depths,1,64,stdout)!=64 ||
                    fwrite(&b->open,sizeof(b->open),1,stdout)!=1) return 2;
            }
        }
    }
    fprintf(stderr,"%u inputs, %u unmatched; each live bracket depth and enclosing plus existing block masks and byte columns\n",total,bad);
    return fflush(stdout) != 0;
}
