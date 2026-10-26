# #451 review's screening switches in one binary (BUSTER_451_MAIN, read once per windowed file), so that no build's
# layout differs: bit 0, main's window rule (dd982dfb's pp_window_has_line_end: a window with a line end that isn't a
# splice's is lexed to its end, one without doubles unlexed) in place of pp_window_cut; bit 1, the directives' places a
# bit at a time (pp_directive_places_scalar, main's loop) in place of pp_directive_places. Applied to 94ae0608. Not for
# commit.
import sys
root = sys.argv[1]
p = root + "/src/buster/compiler/c_preprocessor.c"
t = open(p).read()
def sub(old, new):
    global t
    assert t.count(old) == 1, (old[:80], t.count(old))
    t = t.replace(old, new)
sub("// pp_directive_table for a file prepared a window at a time,", """static uint32_t pp_451_main(void)
{
    const char* text = getenv("BUSTER_451_MAIN");
    return text != 0 ? (uint32_t)strtoul(text, 0, 0) : 0;
}

// pp_directive_table for a file prepared a window at a time,""")
sub("static uint64_t pp_window_cut(const uint8_t* bytes, uint64_t at, uint64_t end, uint64_t longest_tail)\n{", """static bool pp_window_has_line_end(const uint8_t* bytes, uint64_t at, uint64_t end)
{
    bool result = false;
    // Bit 0 of each: the byte before the chunk is a backslash, or a '\\r' after one.
    uint64_t backslash_before = 0;
    uint64_t spliced_return_before = 0;
    for (uint64_t i = at; !result && i < end; i += 64)
    {
        const __mmask64 valid = end - i >= 64 ? ~0ull : _bzhi_u64(~0ull, (uint32_t)(end - i));
        const __m512i chunk = _mm512_maskz_loadu_epi8(valid, bytes + i);
        const uint64_t newlines = _mm512_mask_cmpeq_epi8_mask(valid, chunk, _mm512_set1_epi8('\\n'));
        const uint64_t returns = _mm512_mask_cmpeq_epi8_mask(valid, chunk, _mm512_set1_epi8('\\r'));
        const uint64_t backslashes = _mm512_mask_cmpeq_epi8_mask(valid, chunk, _mm512_set1_epi8('\\\\'));
        const uint64_t after_backslash = (backslashes << 1) | backslash_before;
        const uint64_t spliced_returns = returns & after_backslash;
        const uint64_t spliced_newlines = newlines & (after_backslash | (spliced_returns << 1) | spliced_return_before);
        result = ((newlines & ~spliced_newlines) | (returns & ~spliced_returns)) != 0;
        backslash_before = backslashes >> 63;
        spliced_return_before = spliced_returns >> 63;
    }
    return result;
}

static uint64_t pp_window_cut(const uint8_t* bytes, uint64_t at, uint64_t end, uint64_t longest_tail)
{""")
sub("""    const uint64_t length = data->length;
    const uint64_t capacity = BUSTER_C_TOKENIZER_CAPACITY(length);
    data->kinds = arena_push(&columns[0], capacity, 64);""", """    const uint64_t length = data->length;
    const bool main_cut = (pp_451_main() & 1) != 0;
    const uint64_t capacity = BUSTER_C_TOKENIZER_CAPACITY(length);
    data->kinds = arena_push(&columns[0], capacity, 64);""")
sub("""        const uint64_t cut = last ? end : pp_window_cut(data->bytes, at, end, BUSTER_PP_WINDOW_TAIL_BYTES);""",
    """        const uint64_t cut = last       ? end
                             : main_cut ? (pp_window_has_line_end(data->bytes, at, end) ? end : at)
                                        : pp_window_cut(data->bytes, at, end, BUSTER_PP_WINDOW_TAIL_BYTES);""")
sub("""        pp_directive_places(directives, (data->token_count + 63) / 64, data->directive_hash);""", """        if ((pp_451_main() & 2) != 0)
        {
            pp_directive_places_scalar(directives, (data->token_count + 63) / 64, data->directive_hash);
        }
        else
        {
            pp_directive_places(directives, (data->token_count + 63) / 64, data->directive_hash);
        }""")
open(p, "w").write(t)
print("patched")
