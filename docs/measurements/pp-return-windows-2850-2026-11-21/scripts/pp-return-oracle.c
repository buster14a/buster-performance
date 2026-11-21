#include "buster/compiler/c_lexer.c"
#include "buster/compiler/lane.c"
#include "buster/compiler/c_intern.c"
#include "buster/compiler/c_refine.c"
#include "buster/compiler/c_predefines.c"
#include "buster/compiler/c_preprocessor.c"
#include "buster/compiler/c_parser.c"

static uint32_t oracle_value(Preprocessor* pp, uint32_t t, bool name, bool* ok)
{
    const PPTokens* p = &pp->output;
    if (name) return p->values[t];
    if (p->kinds[t] == BUSTER_PP_KIND_INTEGER)
    {
        *ok = p->values[t] <= INT32_MAX;
        return p->values[t];
    }
    *ok = p->kinds[t] == C_TOKEN_NUMERIC_CONSTANT && p->values[t] - p->locations[t] <= 10;
    if (!*ok) return 0;
    uint8_t buffer[32];const uint8_t* spelling;
    const uint32_t n = pp_spelling(pp,p->kinds[t],p->values[t],p->locations[t],buffer,&spelling);
    *ok = n > 0 && n <= 10 && (n==1 || spelling[0]!='0');
    for (uint32_t i=0;i<n;i++) *ok &= spelling[i]>='0' && spelling[i]<='9';
    if (!*ok) return 0;
    char copy[32];memcpy(copy,spelling,n);copy[n]=0;
    const uint64_t val=strtoull(copy,NULL,10);
    *ok=val<=INT32_MAX;
    return (uint32_t)val;
}

int main(int argc,char** argv)
{
    int split=1;while(split<argc && strcmp(argv[split],"--"))split++;
    if(split+1>=argc) return 2;argv[split]=argv[split+1];
    Arena arena=arena_reserve(UINT64_C(1)<<30); PPOptions opts;const char *in,*out;bool markers;
    if (!pp_parse_options(split,argv+1,&opts,&arena,&in,&out,&markers)) return 2;
    for (int f=split+1;f<argc;f++)
    {
        static Preprocessor pp;static InternTable names;static Parser parser;
        ParseOptions po={.sizes=true};
        if (!intern_initialize(&names)||!pp_initialize(&pp,&opts,&names)||!parse_initialize(&parser,&po,opts.language)||!pp_run(&pp,argv[f])) return 3;
        if (!parse_translation_unit(&parser,&pp)) return 4;
        uint32_t rows=0,literals=0,identifiers=0,returns=0;
        for(uint32_t i=0;i+2<parser.tokens.count;i++)
        {
            if(parser.tokens.kinds[i]!=PARSE_KIND_RETURN||parser.tree.roles[i]!=PARSE_ROLE_RETURN) continue;
            returns++;
            if (parser.tokens.kinds[i+2]!=PARSE_KIND_SEMI || parser.tokens.sources[i]+1!=parser.tokens.sources[i+1] || parser.tokens.sources[i]+2!=parser.tokens.sources[i+2])continue;
            const bool name=parser.tokens.kinds[i+1]==PARSE_KIND_IDENTIFIER;
            if (!name&&parser.tokens.kinds[i+1]!=PARSE_KIND_NUMBER)continue;
            const uint32_t t=parser.tokens.sources[i];
            bool ok=true;const uint32_t v=oracle_value(&pp,t+1,name,&ok);
            if (!ok)continue;
            if(parser.tree.parents[i+1]!=i || (name && parser.tokens.names[i+1]!=v))
            {
                fprintf(stderr,"%s unexpected grammar link at %u (parent %u, return %u)\n",argv[f],t,parser.tree.parents[i+1],i);return 7;
            }
#ifdef PROBE_RETURN
            if(rows>=pp.return_window.count||pp.return_window.rows[rows].statement!=t||pp.return_window.rows[rows].value!=v||pp.return_window.rows[rows].name!=name)
            {
                fprintf(stderr,"%s window mismatch at row %u, expected PP %u value %u name %u, actual PP %u value %u name %u, total=%u\n",argv[f],rows,t,v,name,
                    rows<pp.return_window.count?pp.return_window.rows[rows].statement:0,rows<pp.return_window.count?pp.return_window.rows[rows].value:0,
                    rows<pp.return_window.count?pp.return_window.rows[rows].name:0,pp.return_window.count);return 6;
            }
#endif
            const uint32_t record[3]={t,v,name};if(fwrite(record,sizeof(record),1,stdout)!=1)return 8;
            identifiers+=name;literals+=!name;rows++;
        }
#ifdef PROBE_RETURN
        if(pp.return_window.failed || rows!=pp.return_window.count)
        {
            fprintf(stderr,"%s produced %u rows / expected %u rows; first extra at PP %u\n",argv[f],pp.return_window.count,rows,rows<pp.return_window.count?pp.return_window.rows[rows].statement:0);return 5;
        }
        fprintf(stderr,"%s %u %u %u %u %u %u %u %u\n",argv[f],pp.output.count,returns,literals,identifiers,pp.return_window.observed,pp.return_window.ranges,pp.return_window.blocks,pp.return_window.capacity);
#else
        fprintf(stderr,"%s %u %u %u %u\n", argv[f],pp.output.count,returns,literals,identifiers);
#endif
        parse_release(&parser);pp_release(&pp);intern_release(&names);
    }
    arena_release(&arena);return fflush(stdout)!=0;
}
