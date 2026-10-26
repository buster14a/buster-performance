# #451 part 2's screening: TSC ticks of the directive tables' pieces for files of at least 256 KB, in both paths,
# printed at exit per call. W: the windowed path (scans, page lines, extraction, finish, guard); H: the whole path
# (scans, finish, guard). Not for commit.
import sys
root = sys.argv[1]
p = root + "/src/buster/compiler/c_preprocessor.c"
t = open(p).read()
def sub(old, new, count=1):
    global t
    assert t.count(old) == count, (old[:80], t.count(old))
    t = t.replace(old, new)
sub("static bool pp_finish_directives(bool vectorized, Arena* arena, PPFileData* data, const uint64_t* lines)\n{",
"""static bool pp_sub_windowed;\nstatic uint64_t pp_sub_ticks[16];
static uint64_t pp_sub_calls[16];
static const char* const pp_sub_names[16] = { "W scan", "W pages", "W extract", "W finish", "W guard", "H scans", "H finish", "H guard", "W finish kinds", "W finish pair", "H finish kinds", "H finish pair" };
static uint64_t pp_sub_samples[16][128];
static uint32_t pp_sub_sample_count[16];
static uint64_t pp_sub_pass_mark[16];
// Closes a pass of the big file: each counter's ticks since the last pass become a sample.
static void pp_sub_pass(void)
{
    for (int i = 0; i < 16; i += 1)
    {
        if (pp_sub_sample_count[i] < 128)
        {
            pp_sub_samples[i][pp_sub_sample_count[i]++] = pp_sub_ticks[i] - pp_sub_pass_mark[i];
        }
        pp_sub_pass_mark[i] = pp_sub_ticks[i];
    }
}
static int pp_sub_compare(const void* a, const void* b)
{
    const uint64_t x = *(const uint64_t*)a;
    const uint64_t y = *(const uint64_t*)b;
    return x < y ? -1 : x > y;
}
static __attribute__((destructor)) void pp_sub_report(void)
{
    if (pp_sub_sample_count[0] != 0 || pp_sub_sample_count[5] != 0)
    {
        struct timespec a, b;
        clock_gettime(CLOCK_MONOTONIC_RAW, &a);
        const uint64_t t0 = __rdtsc();
        do { clock_gettime(CLOCK_MONOTONIC_RAW, &b); } while ((b.tv_sec - a.tv_sec) * 1000000000ll + (b.tv_nsec - a.tv_nsec) < 20000000);
        const double ghz = (double)(__rdtsc() - t0) / (double)((b.tv_sec - a.tv_sec) * 1000000000ll + (b.tv_nsec - a.tv_nsec));
        for (int i = 0; i < 16; i += 1)
        {
            const uint32_t n = pp_sub_sample_count[i];
            if (n != 0 && pp_sub_calls[i] != 0)
            {
                // The passes after the warm-up.
                qsort(pp_sub_samples[i] + 1, n - 1, sizeof(uint64_t), pp_sub_compare);
                const uint64_t median = n > 1 ? pp_sub_samples[i][1 + (n - 1) / 2] : pp_sub_samples[i][0];
                const bool bytes = i >= 12;
                fprintf(stderr, "subphase %-16s %3u passes, median %10.3f %s (warm-up %.3f), %llu calls\\n", pp_sub_names[i], n - 1,
                        bytes ? (double)median : (double)median / ghz / 1000.0, bytes ? "bytes" : "us", bytes ? (double)pp_sub_samples[i][0] : (double)pp_sub_samples[i][0] / ghz / 1000.0,
                        (unsigned long long)pp_sub_calls[i]);
            }
        }
        fprintf(stderr, "subphase tsc %.4f GHz\\n", ghz);
    }
}
static bool pp_finish_directives(bool vectorized, Arena* arena, PPFileData* data, const uint64_t* lines)
{
    const bool big = data->length >= (256u << 10);
    const uint64_t sub_start = __rdtsc();""")
sub("""        elifdef |= kind == PP_DIRECTIVE_ELIFDEF || kind == PP_DIRECTIVE_ELIFNDEF;
    }
    Scratch scratch = scratch_begin(0);""", """        elifdef |= kind == PP_DIRECTIVE_ELIFDEF || kind == PP_DIRECTIVE_ELIFNDEF;
    }
    const uint64_t sub_kinds = __rdtsc();
    Scratch scratch = scratch_begin(0);""")
sub("""    result = result && (!(notable || elifdef) || pp_note_directives(arena, data));
    return result;
}""", """    result = result && (!(notable || elifdef) || pp_note_directives(arena, data));
    if (big)
    {
        const uint64_t now = __rdtsc();
        const int which = pp_sub_windowed ? 8 : 10;
        pp_sub_ticks[which] += sub_kinds - sub_start;
        pp_sub_calls[which] += 1;
        pp_sub_ticks[which + 1] += now - sub_kinds;
        pp_sub_calls[which + 1] += 1;
    }
    return result;
}""")
# The windowed path marks its data so finish knows which path called it.
sub("""static bool pp_directive_table_windowed(Arena* arena, PPFileData* data, const uint64_t* lines, const uint64_t* directives, uint32_t count)
{
    bool result = pp_directive_arrays(arena, data, count);""", """static bool pp_directive_table_windowed(Arena* arena, PPFileData* data, const uint64_t* lines, const uint64_t* directives, uint32_t count)
{
    const uint64_t s0 = __rdtsc();
    bool result = pp_directive_arrays(arena, data, count);""")
sub("""    result = result && pp_finish_directives(true, arena, data, lines);
    data->guard = result ? pp_find_guard(data, &data->guard_opener) : 0;
    return result;
}""", """    const uint64_t s1 = __rdtsc();
    pp_sub_windowed = true;
    result = result && pp_finish_directives(true, arena, data, lines);
    pp_sub_windowed = false;
    const uint64_t s2 = __rdtsc();
    data->guard = result ? pp_find_guard(data, &data->guard_opener) : 0;
    const uint64_t s3 = __rdtsc();
    pp_sub_ticks[2] += s1 - s0; pp_sub_calls[2] += 1;
    pp_sub_ticks[3] += s2 - s1; pp_sub_calls[3] += 1;
    pp_sub_ticks[4] += s3 - s2; pp_sub_calls[4] += 1;
    return result;
}""")
sub("""static bool pp_directive_table(bool vectorized, Arena* arena, PPFileData* data)
{
    Scratch scratch = scratch_begin(0);""", """static bool pp_directive_table(bool vectorized, Arena* arena, PPFileData* data)
{
    const bool big = data->length >= (256u << 10);
    const uint64_t s0 = __rdtsc();
    uint64_t s1 = s0;
    uint64_t s2 = s0;
    Scratch scratch = scratch_begin(0);""")
sub("""            pp_scan_directives_scalar(data->kinds, data->token_count, data->directive_hash, lines);
        }
        result = pp_finish_directives(vectorized, arena, data, lines);
    }
    scratch_end(scratch);
    data->guard = result ? pp_find_guard(data, &data->guard_opener) : 0;
    return result;
}""", """            pp_scan_directives_scalar(data->kinds, data->token_count, data->directive_hash, lines);
        }
        s1 = __rdtsc();
        result = pp_finish_directives(vectorized, arena, data, lines);
        s2 = __rdtsc();
    }
    scratch_end(scratch);
    data->guard = result ? pp_find_guard(data, &data->guard_opener) : 0;
    const uint64_t s3 = __rdtsc();
    if (big)
    {
        pp_sub_ticks[5] += s1 - s0; pp_sub_calls[5] += 1;
        pp_sub_ticks[6] += s2 - s1; pp_sub_calls[6] += 1;
        pp_sub_ticks[7] += s3 - s2; pp_sub_calls[7] += 1;
    }
    return result;
}""")
sub("""        directives += result == PP_PREPARE_DONE ? pp_scan_directives_window(data->kinds, (uint32_t)begin, (uint32_t)refined, directive_words, directive_words + word_room) : 0;
        if (result == PP_PREPARE_DONE && pages != 0 && at > lined)
        {
            pp_count_page_lines(data, lined, at, pages, &lines);
            lined = at;
        }""", """        const uint64_t w0 = __rdtsc();
        directives += result == PP_PREPARE_DONE ? pp_scan_directives_window(data->kinds, (uint32_t)begin, (uint32_t)refined, directive_words, directive_words + word_room) : 0;
        const uint64_t w1 = __rdtsc();
        if (result == PP_PREPARE_DONE && pages != 0 && at > lined)
        {
            pp_count_page_lines(data, lined, at, pages, &lines);
            lined = at;
        }
        const uint64_t w2 = __rdtsc();
        pp_sub_ticks[0] += w1 - w0; pp_sub_calls[0] += 1;
        pp_sub_ticks[1] += w2 - w1; pp_sub_calls[1] += 1;""")
sub("""static void pp_release(Preprocessor* pp)
{""", """static void pp_release(Preprocessor* pp)
{
    pp_sub_pass();""")
lexed_end = "cut" if "const uint64_t cut = last ? end : pp_window_cut" in t else "end"
sub("""        int64_t kept = last ? lexed : 0;""", """        pp_sub_ticks[12] += lexed > 0 ? %s - at : 0;
        pp_sub_calls[12] += 1;
        int64_t kept = last ? lexed : 0;""" % lexed_end)
sub("""        data->token_count = (uint32_t)count;
        const uint64_t kept = count + BUSTER_C_TOKENIZER_OUTPUT_SLACK;""", """        data->token_count = (uint32_t)count;
        pp_sub_ticks[13] += length;
        pp_sub_calls[13] += 1;
        const uint64_t kept = count + BUSTER_C_TOKENIZER_OUTPUT_SLACK;""")
sub('"W finish kinds", "W finish pair", "H finish kinds", "H finish pair" };', '"W finish kinds", "W finish pair", "H finish kinds", "H finish pair", "W lexed bytes", "W file bytes" };')
open(p, "w").write(t)
print("patched", lexed_end)
