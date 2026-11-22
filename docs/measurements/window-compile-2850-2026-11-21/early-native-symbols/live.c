#include "buster/compiler/c_preprocessor_benchmark.c"
#include "buster/compiler/c_parser.c"
_Thread_local char oracle_temporary_buffer[BUSTER_TEST_TEMPORARY_BYTES];
#define LIVE_LIMIT (4u << 20)

typedef struct LiveForest
{
    ParseTokens tokens;
    ParseTree tree;
    ParseMeanings names;
    Arena scratch;
    Arena rows;
    uint8_t* tags;
    uint32_t input, converted, scanned, parsed, frontier, windows, live_windows, live_parsed, callbacks, known_ids;
    int32_t depth;
    bool body, pending_pack, refused;
} LiveForest;

static void live_names(LiveForest* live, Preprocessor* pp)
{
    for (uint32_t i = 0; i < BUSTER_PARSE_PREDECLARED_TYPEDEFS; i += 1)
    {
        const char* name = parse_predeclared_typedefs[i];
        const uint32_t id = intern_find(pp->table,(const uint8_t*)name,strlen(name));
        if (id != 0 && id >= live->known_ids) live->names.meanings[id] = PARSE_MEANING_TYPEDEF;
    }
    parse_custom_attribute_names(&live->names, pp->table);
    live->known_ids = pp->table->count;
    live->names.table = pp->table;
    live->names.capacity = pp->table->count;
}

static bool live_prefix_snapshot(LiveForest* live, Preprocessor* pp, uint32_t end)
{
    const char* base = getenv("BUSTER_PREFIX_PATH");
    if (base == NULL || end == 0) return true;
    const bool full = pp->context_count == 0;
    const uint32_t windows[] = {8, 16, 24, 36, 48, 64, 76};
    bool capture = full;
    for (uint32_t k=0; k<BUSTER_ARRAY_LENGTH(windows); k++) capture |= live->windows == windows[k];
    if (!capture) return true;
    char path[2048];
    snprintf(path,sizeof(path),"%s.%06u.i",base,end);
    FILE* out=fopen(path,"wb");
    if (!out) return false;
    const uint32_t limit=pp->output.count;
    const uint32_t prefix=full ? limit : live->tokens.sources[end-1]+1;
    if (prefix>limit) {fclose(out); return false;}
    pp->output.count=prefix;
    const bool written=pp_print(pp,out,false);
    pp->output.count=limit;
    const bool closed=fclose(out)==0;
    printf("snapshot\t%u\t%u\t%u\t%u\t%u\t%s\n", end,prefix,limit,pp->context_count,live->windows,path);
    return written && closed;
}

static bool live_parse(LiveForest* live, Preprocessor* pp, uint32_t end)
{
    const uint32_t begin = live->parsed;
    if (begin == end) return true;
    ParseTree tree = { .parents=live->tree.parents+begin, .roles=live->tree.roles+begin, .depths=live->tree.depths+begin };
    ParseDiagnostic diag[8]; uint32_t nd = 0;
    live_names(live,pp);
    const ParseScalarResult parsed = parse_scalar_with_scope(live->tokens.kinds+begin,live->tokens.names+begin,live->tokens.flags+begin,
        end-begin,pp->options.language,&live->names,&tree,&live->scratch,diag,8,&nd,NULL,live->tags);
    if (parsed.errors || parsed.out_of_memory)
    {
        fprintf(stderr,"live-decline\tbegin=%u\tend=%u\terrors=%u\tfirst=%u\n",begin,end,parsed.errors,nd?diag[0].token:0);
        return false;
    }
    for (uint32_t i=0;i<end-begin;i++)
        if (tree.parents[i] != BUSTER_PARSE_ROOT) tree.parents[i] += begin;
    live->parsed = end;
    live->windows += 1;
    if (pp->context_count != 0) { live->live_windows += 1; live->live_parsed = end; }
    return live_prefix_snapshot(live, pp, end);
}

static void live_receive(void* object, Preprocessor* pp, uint32_t begin, uint32_t end)
{
    LiveForest* live = object;
    if (live->refused) return;
    live->callbacks += 1;
    if (live->input != begin || pp->table->count + 1 >= LIVE_LIMIT) {live->refused=true; return;}
    live->input = end;
    PPTokens output=pp->output;
    output.count=end;
    ParseTokens* tokens=&live->tokens;
    uint32_t written=tokens->count;
    for (uint32_t j=live->converted;j<end;)
    {
        if (written + 66 >= LIVE_LIMIT) { live->refused=true; return; }
        const uint32_t first=written;
        if (output.kinds[j]==C_TOKEN_HASH && (output.flags[j]&BUSTER_PP_START_OF_LINE)!=0)
        {
            uint32_t stop=j;
            if (!parse_pragma_at(&output,j,&stop) && pp->context_count!=0) break;
        }
        const uint32_t next=parse_convert_token(&output,j,tokens,&written);
        if (written==first)
        {
            if (pp_token_is_name(pp,&output,j+2,next-1,"pack")) live->pending_pack=true;
        }
        else if (live->pending_pack) { tokens->flags[first]|=BUSTER_PARSE_AFTER_PRAGMA_PACK; live->pending_pack=false; }
        j=next;
        live->converted=j;
    }
    tokens->count=written;
    parse_tokens_pad(tokens);
    for (uint32_t i=live->scanned;i<written;i++)
    {
        const uint8_t k=tokens->kinds[i];
        if (k==PARSE_KIND_L_BRACE || k==PARSE_KIND_L_PAREN || k==PARSE_KIND_L_SQUARE)
        {
            if (live->depth==0 && k==PARSE_KIND_L_BRACE) live->body=i!=0 && tokens->kinds[i-1]==PARSE_KIND_R_PAREN;
            live->depth+=1;
        }
        if (k==PARSE_KIND_R_BRACE || k==PARSE_KIND_R_PAREN || k==PARSE_KIND_R_SQUARE) live->depth-=1;
        if (live->depth<0) { live->refused=true; return; }
        if (live->depth==0 && (k==PARSE_KIND_SEMI || (k==PARSE_KIND_R_BRACE && live->body)))
            live->frontier=i+1;
    }
    live->scanned=written;
    if (live->frontier>live->parsed && !live_parse(live,pp,live->frontier)) live->refused=true;
}

int main(int argc, char** argv)
{
    Arena arena=arena_reserve(1ull<<30);
    PPOptions o; const char *input,*out; bool markers;
    if (!pp_parse_options(argc-1,argv+1,&o,&arena,&input,&out,&markers)) return 2;
    o.defer_history=true; o.collect_diagnostics=true;
    static Preprocessor pp; static InternTable ids; static Parser parser; static LiveForest live;
    if (!intern_initialize(&ids) || !pp_initialize(&pp,&o,&ids) || !parse_initialize(&parser,&(ParseOptions){0},o.language)) return 3;
    live.rows=arena_reserve(UINT64_C(1)<<30); live.scratch=arena_reserve(UINT64_C(1)<<32);
#define LIVE_COL(field, Type) do { Type* storage=BUSTER_ARENA_PUSH_ARRAY(&live.rows,Type,LIVE_LIMIT+2*BUSTER_PARSE_TOKEN_PADDING); if (!storage) return 4; live.field=storage+BUSTER_PARSE_TOKEN_PADDING; } while(0)
    LIVE_COL(tokens.kinds,uint8_t); LIVE_COL(tokens.names,uint32_t); LIVE_COL(tokens.flags,uint8_t); LIVE_COL(tokens.sources,uint32_t);
    LIVE_COL(tokens.pragma_sources,uint32_t); LIVE_COL(tokens.pragma_positions,uint32_t);
    LIVE_COL(tree.roles,uint8_t); LIVE_COL(tree.depths,uint32_t); LIVE_COL(tree.parents,uint32_t);
    LIVE_COL(tags,uint8_t); LIVE_COL(names.meanings,uint8_t);
#undef LIVE_COL
    pp.source_forest=&live; pp.source_range=live_receive;
    const bool processed=pp_run(&pp,input);
    if (!processed) {pp_diagnostic_publish(&pp);return 5;}
    if (!live.refused && live.converted < pp.output.count) { live.input=live.converted; live_receive(&live,&pp,live.input,pp.output.count); }
    if (!live.refused && !live_parse(&live,&pp,live.tokens.count)) live.refused=true;
    pp.source_range=NULL;
    if (!parse_translation_unit(&parser,&pp)) {parse_print_diagnostics(&parser,&pp);return 6;}
    printf("pp=%u\tparser=%u\tprojected=%u\tbefore-pp-end=%u\tlive-windows=%u\twindows=%u\tcallbacks=%u\trefused=%u\n",
           pp.output.count,parser.tokens.count,live.parsed,live.live_parsed,live.live_windows,live.windows,live.callbacks,live.refused);
    uint32_t bad=0;
    for(uint32_t i=0;i<live.parsed && i<parser.tokens.count;i++)
    {
        if(parser.tokens.kinds[i]!=live.tokens.kinds[i] || parser.tokens.names[i]!=live.tokens.names[i] ||
           parser.tokens.flags[i]!=live.tokens.flags[i] || parse_source_index(&parser.tokens,i)!=live.tokens.sources[i] ||
           parser.tree.depths[i]!=live.tree.depths[i] || parser.tree.parents[i]!=live.tree.parents[i] || parser.tree.roles[i]!=live.tree.roles[i])
        {
            if (bad<10) fprintf(stderr,"tree-difference\t%u\t%u,%u\t%u,%u\t%u,%u\t%u,%u\t%u,%u\n",i,parser.tokens.flags[i],live.tokens.flags[i],
                parser.tree.roles[i],live.tree.roles[i],parser.tree.depths[i],live.tree.depths[i],parser.tree.parents[i],live.tree.parents[i],
                parser.tokens.names[i],live.tokens.names[i]);
            bad+=1;
        }
    }
    printf("different-tree-or-input-rows=%u\n",bad);
    return bad || live.refused || live.parsed!=parser.tokens.count ? 7 : 0;
}
