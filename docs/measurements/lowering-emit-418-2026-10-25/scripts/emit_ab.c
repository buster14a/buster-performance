// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// A measurement harness for PR #418's review, not part of the repository: the same file compiled into main's tree and
// the pull request's, so that `ab` compares their -c paths after checking on the same work.
//
//   build/compiler benchmark-emit-ab [--passes N] [preprocessor options] file...
//
// Each file is checked as the driver checks it (the vector path), and its static data and checked program prepared,
// outside the time. Then each of --passes (21) passes times the driver's selection (check_program_select) and
// everything -c does after it: lowering, Tier 0, branch sizing, encoding and the link's code (check_program_emit), the
// static data's publication and the object's bytes (object_build), with the arenas put back after each run. Every
// timed run must lower its warm-up's counts and object bytes. It prints each file's median and counts, then the sum of
// the medians over the files both lower. Include after c_check_source_benchmark.c.

typedef struct EmitAbRun EmitAbRun;
struct EmitAbRun
{
    uint32_t functions;
    uint32_t objects;
    uint64_t object_bytes;
};

static bool emit_ab_run(EmitAbRun* run, const CheckProgram* full, const CheckDataPrepared* data, const Parser* parser, Preprocessor* pp,
                        TypeTable* types, const char* file, Arena* output, Arena* scratch, Arena* code_output, Arena* bytes)
{
    const uint64_t output_mark = output->length;
    const uint64_t scratch_mark = scratch->length;
    const uint64_t code_mark = code_output->length;
    const uint64_t byte_mark = bytes->length;
    CheckProgramSelection selected = { 0 };
    CheckProgramCode code = { .status = CHECK_PROGRAM_RESOURCE, .token = BUSTER_CHECK_NONE };
    CheckDataResult emission = { .status = CHECK_DATA_RESOURCE };
    bool valid = check_program_select(&selected, full, data, false, output, scratch);
    valid = valid && check_program_emit(&code, &selected.program, parser, pp->table, selected.data.capacity, false, code_output, bytes, scratch, NULL, false);
    valid = valid && check_data_publish(&selected.data, types, selected.program.stream, selected.program.object_symbols, selected.program.object_count,
                                        &code.link, 0, bytes, scratch, &emission);
    ObjectUnits units = { 0 };
    ObjectSymbols symbols = { 0 };
    valid = valid && link_check(&code.link) == LINK_ERROR_NONE && object_prepare(&units, &code.link, 1, scratch) && object_map_symbols(&symbols, &code.link, scratch);
    if (valid)
    {
        const Object object = object_build(&code.link, &units, &symbols, 0, (ObjectOptions){ 0 }, (String8){ .pointer = (char*)file, .length = strlen(file) }, scratch);
        valid = object.error == OBJECT_ERROR_NONE;
        run->object_bytes = object.size;
    }
    run->functions = selected.selected_functions;
    run->objects = selected.selected_objects;
    arena_pop_to(bytes, byte_mark);
    arena_pop_to(code_output, code_mark);
    arena_pop_to(scratch, scratch_mark);
    arena_pop_to(output, output_mark);
    return valid;
}

static bool emit_ab_file(const char* file, char** options, uint32_t option_count, uint64_t passes, uint64_t* files, uint64_t* total_ns, uint64_t* failures)
{
    static InternTable identifiers;
    static Preprocessor pp;
    static Parser parser;
    Arena option_arena = arena_reserve(UINT64_C(1) << 24);
    char** own = BUSTER_ARENA_PUSH_ARRAY(&option_arena, char*, (uint64_t)option_count + 2);
    bool valid = own != 0;
    for (uint32_t i = 0; valid && i < option_count; i += 1)
    {
        own[i] = options[i];
    }
    PPOptions pp_options;
    const char* input = 0;
    const char* output_file = 0;
    bool markers = false;
    if (valid)
    {
        own[option_count] = (char*)file;
    }
    valid = valid && pp_parse_options((int)option_count + 1, own, &pp_options, &option_arena, &input, &output_file, &markers) && output_file == 0 && input != 0;
    pp_options.semantic_pragmas = true;
    CheckCorpusPath path = { 0 };
    valid = valid && intern_initialize(&identifiers) && pp_initialize(&pp, &pp_options, &identifiers) && pp_run(&pp, input);
    const bool accepted = valid && check_corpus_check_policy(&path, &parser, &pp, false, pp_options.quiet);
    CheckDataPrepared data = { 0 };
    CheckProgram program = { 0 };
    bool prepared = accepted && check_data_prepare(&data, &path.input, &path.stream, &path.initializers, &path.types, &path.output_arena, &path.scratch);
    const CheckProgramOptions program_options = {
        .initializers = &path.initializers,
        .asms = &path.asms,
        .identifiers = pp.table,
        .initializer_references = data.references,
        .initializer_reference_count = data.reference_count,
    };
    prepared = prepared && check_program(&program, &parser, &path.input, &path.stream, &path.types, program_options, &path.output_arena, &path.scratch);
    Arena code_output = arena_reserve(UINT64_C(1) << 34);
    Arena bytes = arena_reserve(UINT64_C(1) << 34);
    prepared = prepared && code_output.base != 0 && bytes.base != 0;
    EmitAbRun warm = { 0 };
    const bool lowered = prepared && emit_ab_run(&warm, &program, &data, &parser, &pp, &path.types, input, &path.output_arena, &path.scratch, &code_output, &bytes);
    static uint64_t nanoseconds[BUSTER_CHECK_SOURCE_MAX_PASSES];
    bool measured = lowered;
    for (uint32_t pass = 0; measured && pass < passes; pass += 1)
    {
        EmitAbRun run = { 0 };
        const uint64_t begin = check_source_time();
        const bool ran = emit_ab_run(&run, &program, &data, &parser, &pp, &path.types, input, &path.output_arena, &path.scratch, &code_output, &bytes);
        nanoseconds[pass] = check_source_time() - begin;
        measured = ran && run.functions == warm.functions && run.objects == warm.objects && run.object_bytes == warm.object_bytes;
    }
    *failures += lowered && !measured;
    if (measured)
    {
        const uint64_t median = check_source_median(nanoseconds, (uint32_t)passes);
        printf("emit-ab: file=%s functions=%u objects=%u object_bytes=%" PRIu64 " ns=%" PRIu64 "\n", file, warm.functions, warm.objects, warm.object_bytes, median);
        *files += 1;
        *total_ns += median;
    }
    else
    {
        printf("emit-ab: file=%s skipped=\"%s\"\n", file, !accepted ? "rejected" : !prepared ? "not prepared" : !lowered ? "not lowered" : "a timed run differed");
    }
    arena_release(&bytes);
    arena_release(&code_output);
    check_corpus_close(&path);
    parse_release(&parser);
    pp_release(&pp);
    intern_release(&identifiers);
    arena_release(&option_arena);
    return valid;
}

static int run_emit_ab_benchmark(int count, char** arguments)
{
    uint64_t passes = 21;
    char** options = calloc((size_t)count + 1, sizeof(char*));
    char** files = calloc((size_t)count + 1, sizeof(char*));
    uint32_t option_count = 0;
    uint32_t file_count = 0;
    bool valid = options != 0 && files != 0;
    for (int i = 0; valid && i < count; i += 1)
    {
        if (strcmp(arguments[i], "--passes") == 0)
        {
            valid = i + 1 < count && check_corpus_number(arguments[++i], &passes);
        }
        else if (arguments[i][0] != '-')
        {
            files[file_count++] = arguments[i];
        }
        else
        {
            options[option_count++] = arguments[i];
            if (pp_option_takes_value(arguments[i]))
            {
                valid = i + 1 < count;
                options[option_count++] = valid ? arguments[++i] : 0;
            }
        }
    }
    valid = valid && file_count != 0 && passes != 0 && passes <= BUSTER_CHECK_SOURCE_MAX_PASSES;
    uint64_t measured = 0;
    uint64_t total = 0;
    uint64_t failures = 0;
    for (uint32_t i = 0; valid && i < file_count; i += 1)
    {
        valid = emit_ab_file(files[i], options, option_count, passes, &measured, &total, &failures);
    }
    printf("emit-ab: totals files=%" PRIu64 " ns=%" PRIu64 " passes=%" PRIu64 " failures=%" PRIu64 "\n", measured, total, passes, failures);
    free(files);
    free(options);
    return valid && failures == 0 ? 0 : 1;
}
