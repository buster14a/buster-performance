#include "buster/compiler/c_preprocessor_benchmark.c"
_Thread_local char oracle_temporary_buffer[BUSTER_TEST_TEMPORARY_BYTES];

int main(int argc, char** argv)
{
    Arena arena = arena_reserve(1ull << 30);
    const char *input, *output;
    bool markers;
    PPOptions options;
    static InternTable table;
    static Preprocessor pp;
    if (!pp_parse_options(argc - 1, argv + 1, &options, &arena, &input, &output, &markers)) return 2;
    options.defer_history = getenv("PP_RECORD_HISTORY") == NULL;
    options.timing = getenv("PP_STAGE_TIMING") != NULL;
    const uint64_t begin = pp_benchmark_nanoseconds();
    if (!intern_initialize(&table) || !pp_initialize(&pp, &options, &table) || !pp_run(&pp, input)) return 1;
    const uint64_t elapsed = pp_benchmark_nanoseconds() - begin;
    printf("%lu %u %lu %u %u %u\n",(unsigned long)elapsed, pp.output.count,(unsigned long)pp.input_tokens,table.count,pp.history_count,pp.history_run_count);
    const char* serialized=getenv("PP_ROWS");
    if (serialized != NULL)
    {
        FILE* f=fopen(serialized, "wb");
        if (!f) return 5;
        for (uint32_t i=0; i<pp.output.count; i+=1)
        {
            const uint8_t kind=pp.output.kinds[i];
            const uint32_t val=pp.output.values[i];
            const bool named=kind==C_TOKEN_RAW_IDENTIFIER || (kind>=BUSTER_PP_KIND_KEYWORD && kind<BUSTER_PP_KIND_PRAGMA_END);
            const uint32_t value=named ? intern_length(&table,val) : val;
            const uint8_t dialect[2]={ kind, pp.output.flags[i] };
            if (fwrite(dialect,1,2,f)!=2 || fwrite(pp.output.locations+i,4,1,f)!=1 || fwrite(&value,4,1,f)!=1 ||
                (named && fwrite(intern_bytes(&table,val),1,value,f)!=value)) return 5;
        }
        if (fclose(f)!=0) return 5;
    }
    const char* path = getenv("PP_PRINT");
    if (path != NULL)
    {
        FILE* file = fopen(path, "w");
        if (file == NULL || !pp_print(&pp, file, false) || fclose(file) != 0) return 4;
    }
    if (getenv("PP_DUMP_FORM") != NULL)
    {
        const PPFileData* data = &pp.datas[pp.files[pp.main_file].data];
        fprintf(stderr, "raw %u bytes %u idkind %u\n", data->token_count, data->length, C_TOKEN_RAW_IDENTIFIER);
        for (uint32_t i = 0; i < pp.range_count; i += 1)
            if (pp.ranges[i].file == pp.main_file) fprintf(stderr, "range %u base %u length %u\n", i, pp.ranges[i].base, pp.ranges[i].length);
        FILE* f = fopen("primary.raw", "wb");
        if (!f || fwrite(data->kinds,1,data->token_count,f)!=data->token_count ||
            fwrite(data->starts,4,data->token_count,f)!=data->token_count || fwrite(data->values,4,data->token_count,f)!=data->token_count || fclose(f)) return 3;
        f = fopen("output.rows", "wb");
        if (!f || fwrite(pp.output.kinds,1,pp.output.count,f)!=pp.output.count || fwrite(pp.output.flags,1,pp.output.count,f)!=pp.output.count ||
            fwrite(pp.output.locations,4,pp.output.count,f)!=pp.output.count || fwrite(pp.output.values,4,pp.output.count,f)!=pp.output.count || fclose(f)) return 3;
    }
    pp_release(&pp);
    intern_release(&table);
    arena_release(&arena);
    return 0;
}
