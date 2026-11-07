// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// #442's measurement harness, not part of the repository: buster-performance's lowering-emit-418-2026-10-25 emit_ab.c
// with each run split by stage, compiled into every tree compared so that they run the same work.
//
//   build/compiler benchmark-emit-ab [--passes N] [preprocessor options] file...
//
// Each file is checked as the driver checks it (the vector path), and its static data and checked program prepared,
// outside the time. Then each of --passes (21) passes times the driver's selection (check_program_select), the
// emission (check_program_emit: lowering, Tier 0, branch sizing, encoding and the link's code), the static data's
// publication (check_data_publish) and the object (link_check, object_prepare, object_map_symbols and object_build),
// with the arenas put back after each run. The stages are read from the TSC, the whole from CLOCK_MONOTONIC_RAW around
// them. Every timed run must lower its warm-up's counts and object bytes. It prints each file's medians and counts,
// then the sums of the medians over the files it lowers. EMIT_AB_EMIT_TAIL is the tree's check_program_emit arguments
// after `scratch`. Include after c_check_source_benchmark.c.

#ifndef EMIT_AB_EMIT_TAIL
#define EMIT_AB_EMIT_TAIL NULL, NULL, false
#endif

enum
{
    EMIT_AB_SELECT,
    EMIT_AB_EMIT,
    EMIT_AB_PUBLISH,
    EMIT_AB_OBJECT,
    EMIT_AB_STAGES,
};

typedef struct EmitAbRun EmitAbRun;
struct EmitAbRun
{
    uint32_t functions;
    uint32_t objects;
    uint32_t symbols;
    uint64_t object_bytes;
    uint64_t ticks[EMIT_AB_STAGES];
};

static __attribute__((noinline)) bool emit_ab_run(EmitAbRun* run, const CheckProgram* full, const CheckDataPrepared* data, const Parser* parser, Preprocessor* pp,
                        TypeTable* types, const char* file, Arena* output, Arena* scratch, Arena* code_output, Arena* bytes)
{
    const uint64_t output_mark = output->length;
    const uint64_t scratch_mark = scratch->length;
    const uint64_t code_mark = code_output->length;
    const uint64_t byte_mark = bytes->length;
    CheckProgramSelection selected = { 0 };
    CheckProgramCode code = { .status = CHECK_PROGRAM_RESOURCE, .token = BUSTER_CHECK_NONE };
    CheckDataResult emission = { .status = CHECK_DATA_RESOURCE };
    uint64_t t0 = __builtin_ia32_rdtsc();
    bool valid = check_program_select(&selected, full, data, false, output, scratch);
    uint64_t t1 = __builtin_ia32_rdtsc();
    valid = valid && check_program_emit(&code, &selected.program, parser, pp->table, selected.data.capacity, false, code_output, bytes, scratch, EMIT_AB_EMIT_TAIL);
    uint64_t t2 = __builtin_ia32_rdtsc();
    valid = valid && check_data_publish(&selected.data, types, selected.program.stream, selected.program.object_symbols, selected.program.object_count,
                                        &code.link, 0, bytes, scratch, &emission);
    uint64_t t3 = __builtin_ia32_rdtsc();
    ObjectUnits units = { 0 };
    ObjectSymbols symbols = { 0 };
    valid = valid && link_check(&code.link) == LINK_ERROR_NONE && object_prepare(&units, &code.link, 1, scratch) && object_map_symbols(&symbols, &code.link, scratch);
    if (valid)
    {
        const Object object = object_build(&code.link, &units, &symbols, 0, (ObjectOptions){ 0 }, (String8){ .pointer = (char*)file, .length = strlen(file) }, scratch);
        valid = object.error == OBJECT_ERROR_NONE;
        run->object_bytes = object.size;
    }
    uint64_t t4 = __builtin_ia32_rdtsc();
    run->ticks[EMIT_AB_SELECT] = t1 - t0;
    run->ticks[EMIT_AB_EMIT] = t2 - t1;
    run->ticks[EMIT_AB_PUBLISH] = t3 - t2;
    run->ticks[EMIT_AB_OBJECT] = t4 - t3;
    run->functions = selected.selected_functions;
    run->objects = selected.selected_objects;
    run->symbols = selected.program.symbol_count;
    arena_pop_to(bytes, byte_mark);
    arena_pop_to(code_output, code_mark);
    arena_pop_to(scratch, scratch_mark);
    arena_pop_to(output, output_mark);
    return valid;
}

static double emit_ab_ns_per_tick;

static void emit_ab_calibrate(void)
{
    const uint64_t n0 = check_source_time();
    const uint64_t t0 = __builtin_ia32_rdtsc();
    uint64_t n1 = n0;
    while (n1 - n0 < UINT64_C(200000000))
    {
        n1 = check_source_time();
    }
    const uint64_t t1 = __builtin_ia32_rdtsc();
    emit_ab_ns_per_tick = (double)(n1 - n0) / (double)(t1 - t0);
}

static bool emit_ab_file(const char* file, char** options, uint32_t option_count, uint64_t passes, uint64_t* files, uint64_t* total_ns, double* stage_ns,
                         uint64_t* total_min_ns, double* stage_min_ns, uint64_t* failures)
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
    static uint64_t ticks[EMIT_AB_STAGES][BUSTER_CHECK_SOURCE_MAX_PASSES];
    bool measured = lowered;
    for (uint32_t pass = 0; measured && pass < passes; pass += 1)
    {
        EmitAbRun run = { 0 };
        const uint64_t begin = check_source_time();
        const bool ran = emit_ab_run(&run, &program, &data, &parser, &pp, &path.types, input, &path.output_arena, &path.scratch, &code_output, &bytes);
        nanoseconds[pass] = check_source_time() - begin;
        for (uint32_t stage = 0; stage < EMIT_AB_STAGES; stage += 1)
        {
            ticks[stage][pass] = run.ticks[stage];
        }
        measured = ran && run.functions == warm.functions && run.objects == warm.objects && run.object_bytes == warm.object_bytes;
    }
    *failures += lowered && !measured;
    if (measured)
    {
        const uint64_t median = check_source_median(nanoseconds, (uint32_t)passes);
        double stages[EMIT_AB_STAGES];
        for (uint32_t stage = 0; stage < EMIT_AB_STAGES; stage += 1)
        {
            stages[stage] = (double)check_source_median(ticks[stage], (uint32_t)passes) * emit_ab_ns_per_tick;
            stage_ns[stage] += stages[stage];
        }
        uint64_t minimum = nanoseconds[0];
        double least[EMIT_AB_STAGES];
        for (uint32_t stage = 0; stage < EMIT_AB_STAGES; stage += 1)
        {
            uint64_t m = ticks[stage][0];
            for (uint32_t pass = 1; pass < passes; pass += 1)
            {
                m = ticks[stage][pass] < m ? ticks[stage][pass] : m;
            }
            least[stage] = (double)m * emit_ab_ns_per_tick;
            stage_min_ns[stage] += least[stage];
        }
        for (uint32_t pass = 1; pass < passes; pass += 1)
        {
            minimum = nanoseconds[pass] < minimum ? nanoseconds[pass] : minimum;
        }
        *total_min_ns += minimum;
        printf("emit-ab: file=%s tokens=%u functions=%u objects=%u symbols=%u object_bytes=%" PRIu64 " ns=%" PRIu64 " select=%.0f emit=%.0f publish=%.0f object=%.0f"
               " min_ns=%" PRIu64 " min_select=%.0f min_emit=%.0f min_publish=%.0f min_object=%.0f\n",
               file, path.input.token_count, warm.functions, warm.objects, warm.symbols, warm.object_bytes, median, stages[0], stages[1], stages[2], stages[3],
               minimum, least[0], least[1], least[2], least[3]);
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
    emit_ab_calibrate();
    uint64_t measured = 0;
    uint64_t total = 0;
    double stages[EMIT_AB_STAGES] = { 0 };
    uint64_t total_min = 0;
    double stages_min[EMIT_AB_STAGES] = { 0 };
    uint64_t failures = 0;
    for (uint32_t i = 0; valid && i < file_count; i += 1)
    {
        valid = emit_ab_file(files[i], options, option_count, passes, &measured, &total, stages, &total_min, stages_min, &failures);
    }
    printf("emit-ab: totals files=%" PRIu64 " ns=%" PRIu64 " select=%.0f emit=%.0f publish=%.0f object=%.0f min_ns=%" PRIu64
           " min_select=%.0f min_emit=%.0f min_publish=%.0f min_object=%.0f passes=%" PRIu64 " failures=%" PRIu64 "\n", measured,
           total, stages[0], stages[1], stages[2], stages[3], total_min, stages_min[0], stages_min[1], stages_min[2], stages_min[3], passes, failures);
    free(files);
    free(options);
    return valid && failures == 0 ? 0 : 1;
}
