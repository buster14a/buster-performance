# #451 part 2's screening switches (BUSTER_451_VARIANT, read per call): 1, the directives' places taken out of the
# windowed scan's words with vpcompressb, 16 at a time per word, not a bit at a time; 2, pp_finish_directives prefetching
# the kind, value and line word of the directive 16 ahead. Applied after subphases.py. Not for commit.
import sys
root = sys.argv[1]
p = root + "/src/buster/compiler/c_preprocessor.c"
t = open(p).read()
def sub(old, new):
    global t
    assert t.count(old) == 1, (old[:80], t.count(old))
    t = t.replace(old, new)
sub("static bool pp_sub_windowed;", """static bool pp_sub_windowed;
static uint32_t pp_451_variant(void)
{
    const char* text = getenv("BUSTER_451_VARIANT");
    return text != 0 ? (uint32_t)strtoul(text, 0, 0) : 0;
}""")
sub("""    for (uint32_t d = 0; d < data->directive_count; d += 1)
    {
        const uint32_t hash = data->directive_hash[d];
        const uint32_t end = pp_next_line(lines, data->token_count, hash);""", """    const bool prefetch = (pp_451_variant() & 2) != 0;
    for (uint32_t d = 0; d < data->directive_count; d += 1)
    {
        if (prefetch && d + 16 < data->directive_count)
        {
            const uint32_t ahead = data->directive_hash[d + 16];
            _mm_prefetch((const char*)(data->kinds + ahead + 1), _MM_HINT_T0);
            _mm_prefetch((const char*)(data->values + ahead + 1), _MM_HINT_T0);
            _mm_prefetch((const char*)(lines + (ahead + 1) / 64), _MM_HINT_T0);
        }
        const uint32_t hash = data->directive_hash[d];
        const uint32_t end = pp_next_line(lines, data->token_count, hash);""")
sub("""    const uint32_t word_count = (data->token_count + 63) / 64;
    uint32_t directive = 0;
    for (uint32_t w = 0; result && w < word_count; w += 1)
    {
        for (uint64_t bits = directives[w]; bits != 0; bits &= bits - 1)
        {
            data->directive_hash[directive] = 64 * w + (uint32_t)__builtin_ctzll(bits);
            directive += 1;
        }
    }""", """    const uint32_t word_count = (data->token_count + 63) / 64;
    uint32_t directive = 0;
    if ((pp_451_variant() & 1) != 0)
    {
        const __m512i iota = _mm512_set_epi8(63, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40, 39, 38, 37, 36, 35,
                                             34, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5,
                                             4, 3, 2, 1, 0);
        for (uint32_t w = 0; result && w < word_count; w += 1)
        {
            const uint64_t bits = directives[w];
            const uint32_t count = (uint32_t)__builtin_popcountll(bits);
            const __m512i places = _mm512_maskz_compress_epi8(bits, iota);
            const __m512i base = _mm512_set1_epi32((int)(64 * w));
            _mm512_mask_storeu_epi32(data->directive_hash + directive, (__mmask16)_bzhi_u32(0xFFFF, count),
                                     _mm512_add_epi32(_mm512_cvtepu8_epi32(_mm512_castsi512_si128(places)), base));
            for (uint32_t part = 1; BUSTER_UNLIKELY(part < 4 && count > 16 * part); part += 1)
            {
                const __m512i lanes = _mm512_cvtepu8_epi32(_mm_loadu_si128((const __m128i*)((const uint8_t*)&places + 16 * part)));
                _mm512_mask_storeu_epi32(data->directive_hash + directive + 16 * part, (__mmask16)_bzhi_u32(0xFFFF, count - 16 * part), _mm512_add_epi32(lanes, base));
            }
            directive += count;
        }
    }
    else
    {
        for (uint32_t w = 0; result && w < word_count; w += 1)
        {
            for (uint64_t bits = directives[w]; bits != 0; bits &= bits - 1)
            {
                data->directive_hash[directive] = 64 * w + (uint32_t)__builtin_ctzll(bits);
                directive += 1;
            }
        }
    }""")
open(p, "w").write(t)
print("patched")
