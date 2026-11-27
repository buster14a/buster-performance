import sys
sys.path.insert(0,'/tmp/claude-0/variants')
head=open('/tmp/claude-0/variants/head.c').read()
def rep(s,old,new):
    assert old in s, old[:100]
    return s.replace(old,new,1)
HELPER=r'''// The text after the line splices that start at `p` (fast_skip_splices's), with the newlines they hold in *lines; `p`
// where no splice starts there.
static __attribute__((noinline, cold)) const uint8_t* fast_pass_splices(const uint8_t* p, const uint8_t* end, uint32_t* lines)
{
    const uint8_t* const joined = fast_skip_splices(p, end);
    uint32_t newlines = 0;
    for (const uint8_t* c = p; c < joined; c += 1)
    {
        newlines += *c == '\n' ? 1u : 0u;
    }
    *lines = newlines;
    return joined;
}

// A conditional's keyword (FPP_KW_*) for the name of `length` bytes at `name`, or 0.
static uint32_t fast_conditional_keyword(const uint8_t* name, uint32_t length)
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

// A backslash at `at` right after a skipped directive's name, or after its '#' and blanks (#3577): where it starts a
// line splice, the name goes on past it. Where the name the full pipeline reads then is another conditional than the one
// the skip read (`#el\` + newline + `se` is an #else, `#endif\` + newline + `x` no directive), or a backslash in the
// name starts no splice (a UCN's), the unit leaves the direct path. Text before `at` that isn't a '#', blanks and a name
// is no directive's, and is left as it is.
static __attribute__((noinline, cold)) void fast_check_spliced_directive(FastPP* pp, const uint8_t* base, const uint8_t* at, const uint8_t* end)
{
    const uint8_t* name = at;
    while (name > base && (fast_char_class[name[-1]] & 1u) != 0)
    {
        name -= 1;
    }
    const uint8_t* after_hash = name;
    while (after_hash > base && (fast_char_class[after_hash[-1]] & 8u) != 0)
    {
        after_hash -= 1;
    }
    if (after_hash > base && after_hash[-1] == '#')
    {
        const uint32_t read = fast_conditional_keyword(name, (uint32_t)(at - name));
        const uint8_t* p = name;
        bool leave = false;
        bool before = true;
        while (before && !leave && p < end)
        {
            const uint8_t* const joined = fast_skip_splices(p, end);
            before = joined != p || (fast_char_class[*p] & 8u) != 0;
            p = joined != p ? joined : p + (before ? 1 : 0);
        }
        uint8_t spelled[8] = { 0 };
        uint32_t length = 0;
        bool more = true;
        while (more && !leave && p < end)
        {
            if ((fast_char_class[*p] & 1u) != 0)
            {
                spelled[length & 7u] = *p;
                length += 1;
                p += 1;
            }
            else if (*p == '\\')
            {
                const uint8_t* const joined = fast_skip_splices(p, end);
                leave = joined == p;
                p = joined;
            }
            else
            {
                more = false;
            }
        }
        if (leave || fast_conditional_keyword(spelled, length) != read)
        {
            fast_pp_bail(pp, "directive name across a line splice in a skipped group");
        }
    }
}

// The skip's event at a backslash that may start a line splice (#3577): the text after the splices, with their newlines
// in *lines. A backslash before blanks that starts none leaves the direct path.
static __attribute__((noinline, cold)) const uint8_t* fast_skip_line_splices(FastPP* pp, const uint8_t* base, const uint8_t* at, const uint8_t* end,
                                                                             uint32_t* lines)
{
    fast_check_spliced_directive(pp, base, at, end);
    const uint8_t* joined = fast_pass_splices(at, end, lines);
    if (joined == at)
    {
        fast_pp_bail(pp, "backslash before a blank in a skipped group");
        joined = end;
    }
    return joined;
}

'''
BRANCH_OLD='''            ucns = (_mm512_cmpeq_epi8_mask(_mm512_or_si512(v, v_case), v_lower_u) | _mm512_cmpeq_epi8_mask(v, v_upper_n) | backslash) & escaped;
        }'''
BRANCH_NEW='''            ucns = (_mm512_cmpeq_epi8_mask(_mm512_or_si512(v, v_case), v_lower_u) | _mm512_cmpeq_epi8_mask(v, v_upper_n) | backslash) & escaped;
            const __mmask64 heads = escaped & (nl | blank);
            unsigned long long run = 0;
            const uint64_t run_out = _addcarry_u64(0, blank, escaped & blank, &run);
            const __mmask64 spliced = nl & (escaped | run);
            unsigned long long lead = 0;
            const uint64_t lead_on = _addcarry_u64(0, blank, (spliced << 1) & blank, &lead);
            __m512i opaque = v;
            __asm__("" : "+v"(opaque));
            const __mmask64 marks = _mm512_cmpeq_epi8_mask(opaque, v_hash) | _mm512_cmpeq_epi8_mask(opaque, v_slash) | backslash;
            const uint64_t misread = (((spliced << 1) | lead) & marks) | lead_on | run_out | (spliced >> 63) | (heads & 2u);
            ucns |= misread != 0 ? heads : 0u;
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
LIT_OLD=LIT_OLD.replace('\\\\\\\\','\\\\').replace("'\\\\n'","'\\n'")
LIT_NEW=LIT_NEW.replace('\\\\\\\\','\\\\').replace("'\\\\n'","'\\n'")
H4_DISPATCH_OLD='''            else if (!decided && ucn)
            {'''
H4_DISPATCH_NEW='''            else if (!decided && ucn && at[1] != '\\n' && (fast_char_class[at[1]] & 8u) == 0)
            {'''.replace("'\\\\n'","'\\n'")
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
                    next = fast_skip_line_splices(pp, f->base, at, end, &comment_lines);
                }'''
POST_OLD='''    if (found_kw == 0 && !pp->bailout)
    {
        fast_pp_bail(pp, "unterminated #if");
    }'''
POST_NEW='''    if (found_kw == 0 && !pp->bailout)
    {
        fast_pp_bail(pp, "unterminated #if");
    }
    if (__builtin_expect(found_kw != 0 && p < end && *p == '\\\\', 0))
    {
        fast_check_spliced_directive(pp, f->base, p, end);
    }'''.replace('\\\\\\\\','\\\\')
CALLER_OLD='''            else if (kw == FPP_KW_ELIF || kw == FPP_KW_ELIFDEF || kw == FPP_KW_ELIFNDEF)
            {
                if (cf->is_guard) { f->guard_state = 3u; cf->is_guard = 0; }'''
CALLER_NEW='''            else if (kw == FPP_KW_ELIF || kw == FPP_KW_ELIFDEF || kw == FPP_KW_ELIFNDEF)
            {
                if (__builtin_expect(f->ptr < f->end && *f->ptr == '\\\\', 0))
                {
                    fast_check_spliced_directive(pp, f->base, f->ptr, f->end);
                    if (pp->bailout) { break; }
                }
                if (cf->is_guard) { f->guard_state = 3u; cf->is_guard = 0; }'''.replace('\\\\\\\\','\\\\')
ANCHOR_LEX="// Lex ONE raw preprocessing token"
def make(parts):
    s=head
    s=rep(s,ANCHOR_LEX,HELPER+ANCHOR_LEX)
    s=rep(s,BRANCH_OLD,BRANCH_NEW)
    s=rep(s,LIT_OLD,LIT_NEW)
    s=rep(s,H4_DISPATCH_OLD,H4_DISPATCH_NEW); s=rep(s,H4_COMMENT_OLD,H4_COMMENT_NEW)
    if 'POST' in parts: s=rep(s,POST_OLD,POST_NEW)
    if 'CALLER' in parts: s=rep(s,CALLER_OLD,CALLER_NEW)
    return s
name=sys.argv[1]; parts=sys.argv[2:]
s=make(parts)
open('/tmp/claude-0/variants/'+name+'.c','w').write(s)
