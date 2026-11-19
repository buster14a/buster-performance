// Temporary counters for one call to foreign_strings_merge on the driver thread.
static struct
{
    Arena* output;
    uint64_t output_mark;
    uint64_t scratch_marks[BUSTER_SCRATCH_ARENA_COUNT];
    uint64_t arrays, clears, copied, scratch_peak, combined_peak;
    uint64_t original, reads, translated, published, pool_size;
} strings_trace;

static void strings_trace_begin(Arena* arena)
{
    memset(&strings_trace, 0, sizeof(strings_trace));
    strings_trace.output = arena;
    strings_trace.output_mark = arena->length;
    for (uint32_t i = 0; i < BUSTER_SCRATCH_ARENA_COUNT; ++i)
    {
        strings_trace.scratch_marks[i] = thread_context.scratch[i].length;
    }
}

static void* strings_trace_array(Arena* arena, uint64_t count, uint64_t width, uint64_t align)
{
    void* result = arena_push_array(arena, count, width, align);
    if (result != NULL && strings_trace.output != NULL)
    {
        uint64_t scratch = 0;
        for (uint32_t i = 0; i < BUSTER_SCRATCH_ARENA_COUNT; ++i)
        {
            if (&thread_context.scratch[i] != strings_trace.output)
            {
                scratch += thread_context.scratch[i].length - strings_trace.scratch_marks[i];
            }
        }
        const uint64_t combined = scratch + strings_trace.output->length - strings_trace.output_mark;
        strings_trace.arrays += 1;
        if (scratch > strings_trace.scratch_peak)
        {
            strings_trace.scratch_peak = scratch;
        }
        if (combined > strings_trace.combined_peak)
        {
            strings_trace.combined_peak = combined;
        }
    }
    return result;
}

#define STRINGS_TRACE_ARRAY(arena, Type, count) ((Type*)strings_trace_array((arena), (count), sizeof(Type), _Alignof(Type)))

static void* strings_trace_clear(void* dest, int byte, size_t size)
{
    strings_trace.clears += size;
    return memset(dest, byte, size);
}

static void strings_trace_report(unsigned error, uint64_t input, unsigned applied)
{
    fprintf(stderr, "FS3042 error=%u applied=%u input=%llu planned=%llu original=%llu reads=%llu translated=%llu published=%llu arrays=%llu cleared=%llu copied=%llu scratch_peak=%llu combined_peak=%llu retained=%llu\n",
            error, applied, (unsigned long long)input, (unsigned long long)strings_trace.pool_size,
            (unsigned long long)strings_trace.original, (unsigned long long)strings_trace.reads,
            (unsigned long long)strings_trace.translated, (unsigned long long)strings_trace.published,
            (unsigned long long)strings_trace.arrays, (unsigned long long)strings_trace.clears,
            (unsigned long long)strings_trace.copied, (unsigned long long)strings_trace.scratch_peak,
            (unsigned long long)strings_trace.combined_peak,
            (unsigned long long)(strings_trace.output->length - strings_trace.output_mark));
    strings_trace.output = NULL;
}
