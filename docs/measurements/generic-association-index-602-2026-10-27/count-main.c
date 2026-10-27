// Count-only source adapter. It preprocesses and parses the source, runs the real declaration/expression readers,
// then validates their graph. The prefix makes module entry points local. Instrumented builds are never timed.
int main(int argc, char** argv)
{
    FILE* file = argc > 1 ? fopen(argv[1], "rb") : NULL;
    bool valid = file != NULL && fseek(file, 0, SEEK_END) == 0;
    const long length = valid ? ftell(file) : -1;
    valid &= length >= 0 && length < UINT32_MAX;
    uint8_t* source = valid ? malloc((size_t)length) : NULL;
    valid &= source != NULL;
    if (valid)
    {
        rewind(file);
        valid = fread(source, 1, (size_t)length, file) == (size_t)length;
    }
    if (file != NULL)
    {
        fclose(file);
    }
    static InternTable identifiers;
    static Preprocessor pp;
    static Parser parser;
    const PPOptions options = {
        .language = { .standard = 2017, .gnu = true },
        .no_standard_includes = true,
        .semantic_pragmas = true,
    };
    const bool scalar = argc > 2 && strcmp(argv[2], "scalar") == 0;
    const ParseOptions parse_options = { .scalar = scalar };
    valid = valid && intern_initialize(&identifiers) && pp_initialize(&pp, &options, &identifiers) &&
            parse_initialize(&parser, &parse_options, options.language) && pp_run_source(&pp, argv[1], source, (uint32_t)length);
    Arena types = { 0 };
    Arena index = { 0 };
    Arena input_arena = arena_reserve(UINT64_C(1) << 30);
    Arena output_arena = arena_reserve(UINT64_C(1) << 30);
    Arena scratch = arena_reserve(UINT64_C(1) << 30);
    TypeTable table = { 0 };
    if (valid)
    {
        parse_translation_unit(&parser, &pp);
        const ParseTestOutcome parsed = parse_test_outcome(&parser, &pp);
        valid = parsed.parsed;
        const TypeCapacity capacity = {
            .types = parser.tokens.count * 2 + BUSTER_TYPE_BUILTIN_COUNT,
            .parameters = parser.tokens.count * 2,
            .tags = parser.tokens.count,
            .members = parser.tokens.count,
        };
        types = arena_reserve(type_capacity_bytes(capacity));
        index = arena_reserve(type_index_capacity_bytes(capacity));
        valid = valid && type_initialize(&table, &types, &index, capacity);
    }
    CheckInput input = { 0 };
    CheckStream stream = { 0 };
    const CheckOptions check_options = { .scalar = scalar };
    valid = valid && check_input(&input, &parser, &pp, &table, &input_arena, &scratch) && !input.resource && input.report_count == 0 &&
            check_graph_run(&table, &input.graph, &output_arena, &scratch, &check_options, &stream) && stream.report_count == 0;
    arena_release(&scratch);
    arena_release(&output_arena);
    arena_release(&input_arena);
    arena_release(&index);
    arena_release(&types);
    parse_release(&parser);
    pp_release(&pp);
    intern_release(&identifiers);
    free(source);
    return valid ? 0 : 1;
}
