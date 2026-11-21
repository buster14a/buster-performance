#include "c_lexer.c"
#include "buster/compiler/lane.c"
#include "buster/compiler/c_intern.c"
#include "buster/compiler/c_refine.c"
#include "buster/compiler/c_predefines.c"
#include "buster/compiler/c_preprocessor.c"

static void save(const void *bytes, size_t size)
{
    if (size && fwrite(bytes, 1, size, stdout) != size) exit(3);
}

int main(int argc, char **argv)
{
    Arena arena = arena_reserve(UINT64_C(1) << 30);
    PPOptions options;
    const char *input, *output;
    bool markers;
    if (!pp_parse_options(argc - 1, argv + 1, &options, &arena, &input, &output, &markers)) return 2;
    static Preprocessor pp;
    static InternTable table;
    if (!intern_initialize(&table) || !pp_initialize(&pp, &options, &table)) return 4;
    bool ok = pp_run(&pp, input);
    uint32_t n = pp.output.count;
    uint32_t counts[] = {ok, n, pp.history_count, pp.substitution_count, pp.generated_count,
                         pp.history_source_count, pp.history_run_count, pp.data_count};
    save(counts, sizeof(counts));
    save(pp.output.kinds,n); save(pp.output.flags,n); save(pp.output.values,4ul*n); save(pp.output.locations,4ul*n);
    save(pp.history,sizeof(*pp.history)*pp.history_count);
    save(pp.substitutions,sizeof(*pp.substitutions)*pp.substitution_count);
    save(pp.generated,sizeof(*pp.generated)*pp.generated_count);
    save(pp.history_sources,sizeof(*pp.history_sources)*pp.history_source_count);
    save(pp.history_runs,sizeof(*pp.history_runs)*pp.history_run_count);
    for (uint32_t f = 0; f < pp.data_count; ++f) {
        const PPFileData *d = &pp.datas[f];
        uint32_t num[] = {d->prepared,d->token_count,d->raw_error_count,d->guard,d->directive_count,d->unterminated_comment};
        save(num,sizeof(num));
        if (d->prepared) {
            uint32_t k=d->token_count;
            save(d->kinds,k); save(d->starts,4ul*k); save(d->values,4ul*k);
            save(d->space, ((uint64_t)k+63)/64*8);
            for (uint32_t r=0; r<d->raw_error_count; ++r) {
                save(&d->raw_errors[r].token, sizeof(d->raw_errors[r].token));
                save(&d->raw_errors[r].offset, sizeof(d->raw_errors[r].offset));
                save(&d->raw_errors[r].kind, sizeof(d->raw_errors[r].kind));
            }
            save(d->directive_hash,4ul*d->directive_count); save(d->directive_end,4ul*d->directive_count);
            save(d->directive_kind,d->directive_count); save(d->directive_next,4ul*d->directive_count);
        }
    }
    fprintf(stderr,"%u output tokens, %u macro expansions, %u substitutions, %u generated, %u sources, %u runs, %u files, accepted=%d\n",
            n,pp.history_count, pp.substitution_count, pp.generated_count, pp.history_source_count, pp.history_run_count, pp.data_count, ok);
    return 0;
}
