#include "/home/user/buster/src/buster/compiler/c_direct.c"
static BUSTER_DIRECT_HOT uint8_t fast_pp_skip_inactive_old(FastPP* pp, FastIncludeFile* f)
{
    const uint8_t* p = f->ptr;
    const uint8_t* const end = f->end;
    uint32_t line = f->line;
    bool bol = f->at_bol;
    uint32_t nested = 0;
    uint8_t found_kw = 0;

    const __m512i v_nl = _mm512_set1_epi8('\n');
    const __m512i v_hash = _mm512_set1_epi8('#');
    const __m512i v_slash = _mm512_set1_epi8('/');
    const __m512i v_dq = _mm512_set1_epi8('"');
    const __m512i v_sq = _mm512_set1_epi8('\'');

    while (p < end && !pp->bailout)
    {
        uint32_t avail = 0;
        const __m512i v = fast_load64_bounded(p, end, &avail);
        const __mmask64 valid_mask = avail == 64u ? ~UINT64_C(0) : ((UINT64_C(1) << avail) - 1u);
        const __mmask64 nls = _mm512_cmpeq_epi8_mask(v, v_nl) & valid_mask;
        const __mmask64 hashes = _mm512_cmpeq_epi8_mask(v, v_hash) & valid_mask;
        const __mmask64 slashes = _mm512_cmpeq_epi8_mask(v, v_slash) & valid_mask;
        const __mmask64 quotes = (_mm512_cmpeq_epi8_mask(v, v_dq) | _mm512_cmpeq_epi8_mask(v, v_sq)) & valid_mask;
        const __mmask64 interesting = hashes | slashes | quotes;

        if (__builtin_expect(interesting == 0, 1))
        {
            if (nls != 0)
            {
                line += (uint32_t)__builtin_popcountll(nls);
                const uint32_t last_nl = 63u - (uint32_t)__builtin_clzll(nls);
                // Check if only hspace after last_nl
                const uint8_t* after = p + last_nl + 1u;
                bol = true;
                while (after < p + avail)
                {
                    if ((fast_char_class[*after] & 8u) == 0) { bol = false; break; }
                    after += 1;
                }
            }
            else if (bol)
            {
                for (uint32_t i = 0; i < avail; i += 1)
                {
                    if ((fast_char_class[p[i]] & 8u) == 0) { bol = false; break; }
                }
            }
            p += avail;
            continue;
        }

        // Handle first interesting char in this 64-byte block
        const uint32_t pos = (uint32_t)__builtin_ctzll(interesting);
        const __mmask64 before_mask = pos == 0 ? 0u : ((UINT64_C(1) << pos) - 1u);
        const __mmask64 before_nls = nls & before_mask;
        if (before_nls != 0)
        {
            line += (uint32_t)__builtin_popcountll(before_nls);
            const uint32_t last_nl = 63u - (uint32_t)__builtin_clzll(before_nls);
            bol = true;
            for (uint32_t i = last_nl + 1u; i < pos; i += 1)
            {
                if ((fast_char_class[p[i]] & 8u) == 0) { bol = false; break; }
            }
        }
        else if (bol)
        {
            for (uint32_t i = 0; i < pos; i += 1)
            {
                if ((fast_char_class[p[i]] & 8u) == 0) { bol = false; break; }
            }
        }

        p += pos;
        const uint8_t ch = *p;
        if (ch == '#')
        {
            p += 1;
            if (bol)
            {
                p = fast_skip_hspace(p, end);
                if (p < end && (fast_char_class[*p] & 2u) != 0)
                {
                    const uint32_t len = fast_scan_ident_len(p, end);
                    uint8_t kw = 0;
                    if (len == 2u && p[0] == 'i' && p[1] == 'f') { kw = FPP_KW_IF; }
                    else if (len == 5u && memcmp(p, "ifdef", 5) == 0) { kw = FPP_KW_IFDEF; }
                    else if (len == 6u && memcmp(p, "ifndef", 6) == 0) { kw = FPP_KW_IFNDEF; }
                    else if (len == 5u && memcmp(p, "endif", 5) == 0) { kw = FPP_KW_ENDIF; }
                    else if (len == 4u && memcmp(p, "else", 4) == 0) { kw = FPP_KW_ELSE; }
                    else if (len == 4u && memcmp(p, "elif", 4) == 0) { kw = FPP_KW_ELIF; }
                    else if (len == 7u && memcmp(p, "elifdef", 7) == 0) { kw = FPP_KW_ELIFDEF; }
                    else if (len == 8u && memcmp(p, "elifndef", 8) == 0) { kw = FPP_KW_ELIFNDEF; }
                    p += len;
                    if (kw == FPP_KW_IF || kw == FPP_KW_IFDEF || kw == FPP_KW_IFNDEF)
                    {
                        nested += 1u;
                    }
                    else if (kw == FPP_KW_ENDIF)
                    {
                        if (nested == 0) { found_kw = kw; bol = false; break; }
                        nested -= 1u;
                    }
                    else if (nested == 0 && (kw == FPP_KW_ELSE || kw == FPP_KW_ELIF || kw == FPP_KW_ELIFDEF || kw == FPP_KW_ELIFNDEF))
                    {
                        found_kw = kw;
                        bol = false;
                        break;
                    }
                }
                bol = false;
            }
        }
        else if (ch == '/')
        {
            if (p + 1 < end && p[1] == '*')
            {
                p = fast_skip_block_comment(p + 2, end, &line);
                if (p == NULL) { fast_pp_bail(pp, "unterminated comment in skip"); p = end; break; }
            }
            else if (p + 1 < end && p[1] == '/')
            {
                p = fast_skip_line_comment(p + 2, end, &line);
            }
            else
            {
                p += 1;
                bol = false;
            }
        }
        else
        {
            // '"' or '\''
            const uint8_t quote = ch;
            bol = false;
            p += 1;
            while (p < end && *p != quote && *p != '\n')
            {
                if (*p == '\\' && p + 1 < end)
                {
                    if (p[1] == '\n') { line += 1u; }
                    p += 2;
                }
                else
                {
                    p += 1;
                }
            }
            if (p < end && *p == quote) { p += 1; }
        }
    }

    if (found_kw == 0 && !pp->bailout)
    {
        fast_pp_bail(pp, "unterminated #if");
    }
    f->ptr = p;
    f->line = line;
    f->at_bol = bol;
    return found_kw;
}

#include <stdio.h>
static uint64_t rng_state = 0x9e3779b97f4a7c15ull;
static uint64_t rng(void) { rng_state ^= rng_state << 13; rng_state ^= rng_state >> 7; rng_state ^= rng_state << 17; return rng_state; }
static const char* const fragments[] = {
    "#if X", "#ifdef Y", "#ifndef Z", "#endif", "#else", "#elif W", "#elifdef A", "#elifndef B", "#define M(x) x", "# if 1", "#  endif", "#",
    "/*", "*/", "/* c */", "/* # */", "// line", "//", "/", "*", "\"", "'", "\"str\"", "'c'", "\"/*\"", "\"//\"", "'\"'", "\"\\\"\"", "'\\''", "\\", "\\\n", "\\\\", "\\\r\n",
    "\n", "\n", "\n", "\n", " ", "  ", "\t", "\r", "\v", "\f", "x", "abc", "0", "don't", "a/b", "a # b", "#if", "#endif\n", "\n#endif\n", "\n#else\n", "\n#if 0\n", "\"a\\\n", "'\\\n",
    "/* multi\nline\n*/", "// c \\\n", "    ", "#error it's", "\"unterminated", "'u", "=", ";", "(", ")", "ifdef", "endif", "else",
};
int main(int argc, char** argv)
{
    const uint64_t cases = argc > 1 ? strtoull(argv[1], 0, 0) : 2000000u;
    static uint8_t buffer[8192 + 256];
    uint64_t failures = 0;
    uint64_t found = 0;
    for (uint64_t c = 0; c < cases && failures < 10; c += 1)
    {
        uint32_t len = 0;
        const uint32_t target = (uint32_t)(rng() % (c % 7 == 0 ? 4096u : 400u));
        const uint32_t mode = (uint32_t)(rng() % 4u);
        while (len < target)
        {
            if (mode == 0)
            {
                static const char alphabet[] = "#/*\"'\\\n \t\rifendls01x";
                buffer[len++] = (uint8_t)alphabet[rng() % (sizeof(alphabet) - 1u)];
            }
            else
            {
                const char* fr = fragments[rng() % (sizeof(fragments) / sizeof(fragments[0]))];
                if (mode == 3 && rng() % 3u != 0) { fr = (rng() & 1u) ? "some plain text here " : "\n"; }
                const uint32_t fl = (uint32_t)strlen(fr);
                memcpy(buffer + len, fr, fl);
                len += fl;
            }
        }
        memset(buffer + len, '#', 128);   // what must not be read as text
        for (uint32_t start_bol = 0; start_bol < 2u; start_bol += 1)
        {
            FastPP pp_a; FastPP pp_b;
            memset(&pp_a, 0, sizeof(pp_a)); memset(&pp_b, 0, sizeof(pp_b));
            FastIncludeFile fa; FastIncludeFile fb;
            memset(&fa, 0, sizeof(fa)); memset(&fb, 0, sizeof(fb));
            const uint32_t skip = (uint32_t)(rng() % 3u);
            fa.base = buffer; fa.ptr = buffer + (skip <= len ? skip : 0); fa.end = buffer + len; fa.line = 7; fa.at_bol = start_bol != 0;
            fb = fa;
            const uint8_t ra = fast_pp_skip_inactive_old(&pp_a, &fa);
            const uint8_t rb = fast_pp_skip_inactive(&pp_b, &fb);
            found += ra != 0;
            if (ra != rb || fa.ptr != fb.ptr || fa.line != fb.line || (ra != 0 && fa.at_bol != fb.at_bol) || pp_a.bailout != pp_b.bailout)
            {
                failures += 1;
                printf("MISMATCH case %llu bol %u len %u: old kw %u ptr %td line %u bol %d bail %d; new kw %u ptr %td line %u bol %d bail %d\n", (unsigned long long)c, start_bol, len,
                       ra, fa.ptr - buffer, fa.line, fa.at_bol, pp_a.bailout, rb, fb.ptr - buffer, fb.line, fb.at_bol, pp_b.bailout);
                printf("tail:"); for (uint32_t i = len > 80 ? len - 80 : 0; i < len; i += 1) { printf(buffer[i] >= 32 && buffer[i] < 127 ? "%c" : "<%02x>", buffer[i]); } printf("\n");
                printf("\n-----\n");
            }
        }
    }
    printf("%llu cases, %llu with a directive found, %llu failures\n", (unsigned long long)cases, (unsigned long long)found, (unsigned long long)failures);
    return failures != 0;
}
