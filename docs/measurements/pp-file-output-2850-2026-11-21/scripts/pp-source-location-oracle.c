// Verification-only driver. Writes initialized columns and exact ordinal counts in a fixed order.
#include "buster/compiler/c_lexer.c"
#include "buster/compiler/lane.c"
#include "buster/compiler/c_intern.c"
#include "buster/compiler/c_refine.c"
#include "buster/compiler/c_predefines.c"
#include "buster/compiler/c_preprocessor.c"
#include "buster/compiler/c_parser.c"

static void dump_column(const void* memory, size_t size)
{
    if (size != 0 && fwrite(memory, 1, size, stdout) != size)
        exit(3);
}

int main(int argc, char** argv)
{
    int split = 1;
    while (split < argc && strcmp(argv[split], "--") != 0)
        ++split;
    if (split + 1 >= argc)
        return 2;
    argv[split] = argv[split + 1];
    Arena arena = arena_reserve(UINT64_C(1) << 30);
    PPOptions options;
    const char *input, *output;
    bool markers;
    if (!pp_parse_options(split, argv + 1, &options, &arena, &input, &output, &markers))
        return 2;
    const ParseOptions parse_options = { .sizes = true };
    for (int f = split + 1; f < argc; f++)
    {
        static Preprocessor pp;
        static InternTable table;
        static Parser parser;
        if (!intern_initialize(&table) || !pp_initialize(&pp, &options, &table) || !parse_initialize(&parser, &parse_options, options.language))
            return 4;
        const bool preprocessed = pp_run(&pp, argv[f]);
        const bool parsed = preprocessed && parse_translation_unit(&parser, &pp);
        if (!parsed || parser.errors || parser.fatal)
        {
            fprintf(stderr, "could not parse %s: errors=%u fatal=%u\n",argv[f], parser.errors, (unsigned)parser.fatal);
            return 1;
        }
        const uint32_t n=parser.tokens.count, p=pp.output.count, k=parser.tokens.pragma_count;
        const uint64_t counts[] = {p, n, k, parser.statistics.fallback_items, parser.statistics.fallback_tokens, parser.statistics.flagged_tokens,
            parser.statistics.whole, pp.history_run_count};
        dump_column(counts, sizeof(counts));
        dump_column(pp.output.kinds,p); dump_column(pp.output.flags,p); dump_column(pp.output.values,4ul*p); {
#ifdef LOCATION_VIEW
            uint32_t t=0;
            if (pp.location_mode >= 3)
            {
                uint32_t buf[64];
                for (uint32_t i=0;i<pp.location_run_count;i++)
                {
                    const PPFileLocationRun* r=&pp.location_runs[i];
                    if(r->output<t || r->output+r->count>p) return 7;
                    dump_column(pp.output.locations+t,4ul*(r->output-t));
                    for(uint32_t j=0;j<r->count;j+=64)
                    {
                        for(uint32_t l=0;l<64;l++)buf[l]=r->base+r->starts[j+l];
                        dump_column(buf,sizeof(buf));
                    }
                    t=r->output+r->count;
                }
            }
            dump_column(pp.output.locations+t,4ul*(p-t));
#else
            dump_column(pp.output.locations,4ul*p);
#endif
        }
        dump_column(pp.history_runs, pp.history_run_count*sizeof(PPHistoryRun));
        dump_column(parser.tokens.kinds,n); dump_column(parser.tokens.flags,n); dump_column(parser.tokens.names,4ul*n); dump_column(parser.tokens.sources,4ul*n);
        dump_column(parser.tokens.pragma_sources,4ul*k); dump_column(parser.tokens.pragma_positions,4ul*k);
        dump_column(parser.tree.roles,n); dump_column(parser.tree.depths,4ul*n); dump_column(parser.tree.parents,4ul*n);
        dump_column(parser.postorder,4ul*n); dump_column(parser.positions,4ul*n); dump_column(parser.ends,4ul*n);
        dump_column(parser.first_children,4ul*n); dump_column(parser.next_siblings,4ul*n); dump_column(parser.sizes,4ul*n);
        fprintf(stderr,"%s %u %u %u\n",argv[f],p,n,k);
        parse_release(&parser);pp_release(&pp);intern_release(&table);
    }
    arena_release(&arena);
    return fflush(stdout)!=0;
}
