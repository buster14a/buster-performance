import sys
head=open('/tmp/claude-0/variants/head.c').read()
def rep(s,old,new):
    assert old in s, old[:100]
    return s.replace(old,new,1)
HELPER='''// The text after the line splices that start at `p` (fast_skip_splices's), with the newlines they hold in *lines; `p`
// where no splice starts there.
static __attribute__((noinline, cold)) const uint8_t* fast_pass_splices(const uint8_t* p, const uint8_t* end, uint32_t* lines)
{
    const uint8_t* const joined = fast_skip_splices(p, end);
    uint32_t newlines = 0;
    for (const uint8_t* c = p; c < joined; c += 1)
    {
        newlines += *c == '\\n' ? 1u : 0u;
    }
    *lines = newlines;
    return joined;
}

// The skip's event at a backslash that may start a line splice (#3577): the text after the splices, with their newlines
// in *lines. A backslash before blanks that starts none leaves the direct path.
static __attribute__((noinline, cold)) const uint8_t* fast_skip_line_splices(FastPP* pp, const uint8_t* at, const uint8_t* end, uint32_t* lines)
{
    const uint8_t* joined = fast_pass_splices(at, end, lines);
    if (joined == at)
    {
        fast_pp_bail(pp, "backslash before a blank in a skipped group");
        joined = end;
    }
    return joined;
}

// A conditional's keyword (FPP_KW_*) for the name of `length` bytes at `name`, or 0.
static __attribute__((unused)) uint32_t fast_conditional_keyword(const uint8_t* name, uint32_t length)
{
    uint32_t kw = 0;
    if (length == 2u && name[0] == 'i' && name[1] == 'f') { kw = FPP_KW_IF; }
    else if (length == 5u && memcmp(name, "ifdef", 5) == 0) { kw = FPP_KW_IFDEF; }
    else if (length == 6u && memcmp(name, "ifndef", 6) == 0) { kw = FPP_KW_IFNDEF; }
    else if (length == 5u && memcmp(name, "endif", 5) == 0) { kw = FPP_KW_ENDIF; }
    else if (length == 4u && memcmp(name, "else", 4) == 0) { kw = FPP_KW_ELSE; }
    else if (length == 4u && memcmp(name, "elif", 4) == 0) { kw = FPP_KW_ELIF; }
    else if (length == 7u && memcmp(name, "elifdef", 7) == 0) { kw = FPP_KW_ELIFDEF; }
    else if (length == 8u && memcmp(name, "elifndef", 8) == 0) { kw = FPP_KW_ELIFNDEF; }
    return kw;
}

// A skipped directive whose name a backslash follows, or whose '#' and blanks a backslash or a '/' follows (#3577): its
// name as the full pipeline reads it, past the line splices in it and the blanks, splices and block comments before it.
// Where that names another conditional than `read` (the keyword the skip read, 0 for none), or a backslash in the name
// starts no splice (a UCN's), or a comment doesn't end, the unit leaves the direct path.
static __attribute__((noinline, cold, unused)) void fast_check_skipped_name(FastPP* pp, const uint8_t* p, const uint8_t* end, uint32_t read)
{
    const uint8_t* at = p;
    bool leave = false;
    bool before = true;
    while (before && !leave && at < end)
    {
        const uint8_t* const joined = fast_skip_splices(at, end);
        if (joined != at)
        {
            at = joined;
        }
        else if ((fast_char_class[*at] & 8u) != 0)
        {
            at += 1;
        }
        else if (*at == '/' && at + 1 < end && at[1] == '*')
        {
            uint32_t comment_lines = 0;
            const uint8_t* const after = fast_skip_block_comment(at + 2, end, &comment_lines);
            leave = after == NULL;
            at = after == NULL ? end : after;
        }
        else
        {
            before = false;
        }
    }
    uint8_t name[8] = { 0 };
    uint32_t length = 0;
    bool more = true;
    while (more && !leave && at < end)
    {
        if ((fast_char_class[*at] & 1u) != 0)
        {
            name[length & 7u] = *at;
            length += 1;
            at += 1;
        }
        else if (*at == '\\\\')
        {
            const uint8_t* const joined = fast_skip_splices(at, end);
            leave = joined == at;
            at = joined;
        }
        else
        {
            more = false;
        }
    }
    if (leave || fast_conditional_keyword(name, length) != read)
    {
        fast_pp_bail(pp, "directive name across a line splice or a comment in a skipped group");
    }
}

'''
BRANCH_OLD='''            ucns = (_mm512_cmpeq_epi8_mask(_mm512_or_si512(v, v_case), v_lower_u) | _mm512_cmpeq_epi8_mask(v, v_upper_n) | backslash) & escaped;
        }'''
BRANCH_NEW='''            ucns = (_mm512_cmpeq_epi8_mask(_mm512_or_si512(v, v_case), v_lower_u) | _mm512_cmpeq_epi8_mask(v, v_upper_n) | backslash) & escaped;
            unsigned long long run = 0;
            const uint64_t run_out = _addcarry_u64(0, blank, escaped & blank, &run);
            const __mmask64 spliced = nl & (escaped | run);
            unsigned long long lead = 0;
            const uint64_t lead_on = _addcarry_u64(0, blank, (spliced << 1) & blank, &lead);
            __m512i opaque = v;
            __asm__("" : "+v"(opaque));
            const __mmask64 marks = _mm512_cmpeq_epi8_mask(opaque, v_hash) | _mm512_cmpeq_epi8_mask(opaque, v_slash) | backslash;
            const uint64_t misread = (((spliced << 1) | lead) & marks) | lead_on | run_out | (spliced >> 63);
            ucns |= misread != 0 ? escaped & (nl | blank) : 0u;
        }'''
LIT_OLD='''                        if (*s == '\\\\' && s + 1 < end)
                        {
                            if (s[1] == '\\n') { line += 1u; }
                            s += 2;
                        }'''
LIT_NEW='''                        if (*s == '\\\\' && s + 1 < end && (fast_char_class[s[1]] & 8u) != 0)
                        {
                            uint32_t splice_lines = 0;
                            const uint8_t* const joined = fast_pass_splices(s, end, &splice_lines);
                            line += splice_lines;
                            s = joined != s ? joined : s + 2;
                        }
                        else if (*s == '\\\\' && s + 1 < end)
                        {
                            if (s[1] == '\\n') { line += 1u; }
                            s += 2;
                        }'''
H4_DISPATCH_OLD='''            else if (!decided && ucn)
            {'''
H4_DISPATCH_NEW='''            else if (!decided && ucn && at[1] != '\\n' && (fast_char_class[at[1]] & 8u) == 0)
            {'''
H4_COMMENT_OLD='''                else
                {
                    next = fast_skip_line_comment(at + 2, end, &comment_lines);
                }'''
H4_COMMENT_NEW='''                else if (at[1] == '/')
                {
                    next = fast_skip_line_comment(at + 2, end, &comment_lines);
                }
                else
                {
                    next = fast_skip_line_splices(pp, at, end, &comment_lines);
                }'''
DY_OLD='''                    else if (len == 8u && memcmp(next, "elifndef", 8) == 0) { kw = FPP_KW_ELIFNDEF; }
                    next += len;'''
DY_NEW='''                    else if (len == 8u && memcmp(next, "elifndef", 8) == 0) { kw = FPP_KW_ELIFNDEF; }
                    if (__builtin_expect(next + len < end && next[len] == '\\\\', 0))
                    {
                        fast_check_skipped_name(pp, next, end, kw);
                    }
                    next += len;'''
UNNAMED_OLD='''                        nested_else |= level & (UINT64_C(0) - (uint64_t)(kw == FPP_KW_ELSE));
                    }
                }
            }'''
UNNAMED_NEW='''                        nested_else |= level & (UINT64_C(0) - (uint64_t)(kw == FPP_KW_ELSE));
                    }
                }
                else if (__builtin_expect(next < end && (*next == '\\\\' || *next == '/'), 0))
                {
                    fast_check_skipped_name(pp, next, end, 0);
                }
            }'''
DX_OLD='''                    const uint32_t len = fast_scan_ident_len(next, end);
                    uint8_t kw = 0;'''
DX_NEW='''                    const uint32_t len = fast_scan_directive_name(pp, next, end);
                    uint8_t kw = 0;'''
DX_FN='''// fast_scan_ident_len for a skipped directive's name (#3577): where a backslash follows the name, fast_check_skipped_name
// reads it past the splice.
static __attribute__((noinline)) uint32_t fast_scan_directive_name(FastPP* pp, const uint8_t* p, const uint8_t* end)
{
    const uint32_t len = fast_scan_ident_len(p, end);
    if (__builtin_expect(p + len < end && p[len] == '\\\\', 0))
    {
        fast_check_skipped_name(pp, p, end, fast_conditional_keyword(p, len));
    }
    return len;
}

'''
ANCHOR_LEX="// Lex ONE raw preprocessing token"
ANCHOR_SKIP="// ---------------------------------------------------------------------------------------------------------------------\n// The text of a conditional group that is not taken"
def make(parts):
    s=head
    s=rep(s,ANCHOR_LEX,HELPER+ANCHOR_LEX)
    s=rep(s,BRANCH_OLD,BRANCH_NEW)
    s=rep(s,LIT_OLD,LIT_NEW)
    if 'H4' in parts:
        s=rep(s,H4_DISPATCH_OLD,H4_DISPATCH_NEW); s=rep(s,H4_COMMENT_OLD,H4_COMMENT_NEW)
    if 'DY' in parts:
        s=rep(s,DY_OLD,DY_NEW); s=rep(s,UNNAMED_OLD,UNNAMED_NEW)
    if 'DX' in parts:
        s=rep(s,DX_OLD,DX_NEW); s=rep(s,UNNAMED_OLD,UNNAMED_NEW); s=rep(s,ANCHOR_SKIP,DX_FN+ANCHOR_SKIP)
    if 'DU' in parts:
        s=rep(s,UNNAMED_OLD,UNNAMED_NEW)
    return s
name=sys.argv[1]; parts=sys.argv[2:]
open('/tmp/claude-0/variants/'+name+'.c','w').write(make(parts))
