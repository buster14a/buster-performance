// The temporary check behind raw/local/fields.txt (buster#2536, step 2.2c.4, part 1), which was in
// c_checker_driver.c while the record was made and is not in the PR. Called with BUSTER_DEBUG_PROVISIONAL_FIELDS set,
// just before check_driver_provisional_check, it makes the provisional selection again as main made it (after the loop,
// over the program the tail left) and prints each CheckProgram field whose bytes differ from the one made before the
// loop and filled in after it (provisional-field NAME), each body record and region that differs, and each array of
// the selection's own whose contents differ (provisional-array NAME).
static void check_driver_provisional_fields(const CheckProgramSelection* provisional, const CheckProgram* program, const CheckDataPrepared* data, Arena* output,
                                            Arena* scratch)
{
    if (getenv("BUSTER_DEBUG_PROVISIONAL_FIELDS") != NULL)
    {
        const CheckProgramCensus* census = &program->census_pass;
        const uint64_t scratch_mark = scratch->length;
        CheckProgram candidates = *program;
        CheckProgramBody* copies = BUSTER_ARENA_PUSH_ARRAY(scratch, CheckProgramBody, (uint64_t)program->body_count + 1);
        uint32_t total = 0;
        for (uint32_t b = 0; b < program->body_count; b += 1)
        {
            copies[b] = program->bodies[b];
            copies[b].reference_first = census->first[b];
            copies[b].reference_count = census->counts[b];
            total += census->counts[b];
        }
        candidates.bodies = copies;
        candidates.references = census->references;
        candidates.reference_count = total;
        candidates.builtin_nodes = program->census_pass_builtins;
        candidates.builtin_count = program->census_pass_builtin_count;
        CheckProgramSelection old;
        const bool made = check_program_select_mode(&old, &candidates, data, C_LOWERING_REACHABLE, false, false, output, scratch);
        const CheckProgram* a = &old.program;
        const CheckProgram* b = &provisional->program;
#define BUSTER_DEBUG_FIELD(f) if (memcmp(&a->f, &b->f, sizeof(a->f)) != 0) { fprintf(stderr, "provisional-field\t%s\n", #f); }
        // One line for every field of CheckProgram, in its order (input, stream, ..., census_pass_ranges): 147 of them.
        BUSTER_DEBUG_FIELD(input);
        // ...
        BUSTER_DEBUG_FIELD(census_pass_ranges);
#undef BUSTER_DEBUG_FIELD
        for (uint32_t i = 0; made && a->body_count == b->body_count && i < a->body_count; i += 1)
        {
            if (memcmp(a->bodies + i, b->bodies + i, sizeof(CheckProgramBody)) != 0)
            {
                fprintf(stderr, "provisional-field\tbody %u\n", i);
            }
        }
        for (uint32_t i = 0; made && i < a->region_count; i += 1)
        {
            if (memcmp(a->regions + i, b->regions + i, sizeof(CheckProgramRegion)) != 0)
            {
                fprintf(stderr, "provisional-field\tregion %u\n", i);
            }
        }
#define BUSTER_DEBUG_ARRAY(f, n) if (made && a->f != NULL && b->f != NULL && memcmp(a->f, b->f, (uint64_t)(n) * sizeof(*a->f)) != 0) { fprintf(stderr, "provisional-array\t%s\n", #f); } \
    else if (made && (a->f == NULL) != (b->f == NULL)) { fprintf(stderr, "provisional-array-null\t%s\n", #f); }
        BUSTER_DEBUG_ARRAY(object_symbols, a->object_count);
        BUSTER_DEBUG_ARRAY(symbol_objects, a->symbol_count);
        BUSTER_DEBUG_ARRAY(body_eager, a->body_count);
        BUSTER_DEBUG_ARRAY(references, a->reference_count);
        BUSTER_DEBUG_ARRAY(builtin_nodes, a->builtin_count);
        BUSTER_DEBUG_ARRAY(body_targets, a->body_count);
        BUSTER_DEBUG_ARRAY(body_options, a->body_count);
        BUSTER_DEBUG_ARRAY(alias_states, a->alias_count);
        BUSTER_DEBUG_ARRAY(target_symbols, a->target_version_count + a->target_group_count);
        BUSTER_DEBUG_ARRAY(cpu_symbols, a->cpu_version_count + a->cpu_group_count);
        BUSTER_DEBUG_ARRAY(clone_symbols, a->clone_option_count);
#undef BUSTER_DEBUG_ARRAY
        fprintf(stderr, "provisional-fields\tmade\t%d\n", (int)made);
        arena_pop_to(scratch, scratch_mark);
    }
}
