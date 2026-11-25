# patch_count.py FILE: counters in a copy of main 20f3573e's c_direct_lex.c (FILE), printed at exit: windows, blocks,
# tokens, stops by kind, comments' and strings' lengths. Counts, not times; the object is unchanged.
import sys, re
path = sys.argv[1]
s = open(path).read()
def rep(old, new, count=1):
    global s
    n = s.count(old)
    if n != count:
        sys.exit(f"pattern found {n} times (want {count}): {old[:80]!r}")
    s = s.replace(old, new)
hdr = '''
#include <stdio.h>
enum { K_WIN, K_WIN_LINE, K_BLOCKS, K_FULL, K_TOKS, K_BIG, K_SCALARBLK, K_SCALARTOK, K_LIMITSUM,
       K_BCOMMENT, K_BCOMMENT_BYTES, K_LCOMMENT, K_LCOMMENT_BYTES, K_SLASHOP, K_DIRSTOP, K_HASHOP, K_EOLSTOP, K_PREFIXSTOP,
       K_STR, K_STR_BYTES, K_CHAR, K_SCALARSTOP, K_TAILSTOP, K_CAPSTOP, K_CARRYEND, K_WINTOKS, K_WASTED, K_EMITTED, K_READ,
       K_NOTOKBLK, K_LIMIT0, K_N };
static const char* const k_names[K_N] = { "windows", "windows_linemode", "blocks", "blocks_full", "block_tokens", "blocks_over32", "blocks_with_scalars", "scalar_tokens", "block_bytes_lexed",
  "block_comments", "block_comment_bytes", "line_comments", "line_comment_bytes", "slash_ops", "directive_stops", "hash_ops", "eol_stops", "prefix_stops",
  "strings", "string_bytes", "chars", "scalar_stops", "tail_stops", "capacity_stops", "carry_at_end", "window_tokens", "wasted_tokens", "emitted_tokens", "read_tokens",
  "blocks_no_tokens", "blocks_limit0" };
static uint64_t k_count[K_N];
__attribute__((destructor)) static void k_dump(void) { for (int i = 0; i < K_N; i++) fprintf(stderr, "count %-22s %llu\\n", k_names[i], (unsigned long long)k_count[i]); }
#define KC(i, v) (k_count[i] += (uint64_t)(v))
'''
rep('// Passes the window\'s tokens that start before the file\'s byte `offset`.', '// Passes the window\'s tokens that start before the file\'s byte `offset`.')
# insert header before fast_pp_lex_window's comment block
rep('_Alignas(64) static const uint8_t fast_iota64_plus1[64] = {', hdr + '_Alignas(64) static const uint8_t fast_iota64_plus1[64] = {')
rep('''    uint32_t open_start = 0;     // ... and its first byte's offset
''', '''    uint32_t open_start = 0;     // ... and its first byte's offset
    KC(K_WIN, 1); KC(K_WIN_LINE, line_mode); KC(K_WASTED, w->count - w->pos);
''')
rep('''        const uint32_t block_offset = (uint32_t)(p - base);
        const __m512i v = _mm512_loadu_si512((const void*)p);''', '''        const uint32_t block_offset = (uint32_t)(p - base);
        KC(K_BLOCKS, 1);
        const __m512i v = _mm512_loadu_si512((const void*)p);''')
rep('''        const uint32_t m_count = (uint32_t)__builtin_popcountll(tok_starts);
''', '''        const uint32_t m_count = (uint32_t)__builtin_popcountll(tok_starts);
        KC(K_TOKS, m_count); KC(K_BIG, m_count > 32u); KC(K_SCALARBLK, scalars != 0); KC(K_SCALARTOK, __builtin_popcountll(scalars)); KC(K_LIMITSUM, limit); KC(K_FULL, limit == 64u); KC(K_NOTOKBLK, m_count == 0); KC(K_LIMIT0, limit == 0);
''')
rep('''                const uint8_t* after = fast_skip_block_comment(p + 2, end, &unused_line);
                if (after == NULL)''', '''                const uint8_t* after = fast_skip_block_comment(p + 2, end, &unused_line);
                KC(K_BCOMMENT, 1); if (after) KC(K_BCOMMENT_BYTES, after - p);
                if (after == NULL)''')
rep('''                p = fast_skip_line_comment(p + 2, end, &unused_line);
                continue;''', '''                { const uint8_t* q0 = p; p = fast_skip_line_comment(p + 2, end, &unused_line); KC(K_LCOMMENT, 1); KC(K_LCOMMENT_BYTES, p - q0); }
                continue;''')
rep('''            wk[n] = ch1 == '=' ? FTOK_DIV_ASSIGN : FTOK_SLASH;''', '''            KC(K_SLASHOP, 1);
            wk[n] = ch1 == '=' ? FTOK_DIV_ASSIGN : FTOK_SLASH;''')
rep('''            if (bol)
            {
                stop = BUSTER_FWIN_STOP_DIRECTIVE;''', '''            if (bol)
            {
                KC(K_DIRSTOP, 1);
                stop = BUSTER_FWIN_STOP_DIRECTIVE;''')
rep('''            wk[n] = length == 2u ? FTOK_HASHHASH : FTOK_HASH;''', '''            KC(K_HASHOP, 1);
            wk[n] = length == 2u ? FTOK_HASHHASH : FTOK_HASH;''')
rep('''            // Only a line's window has the newline among these bytes.
            stop = BUSTER_FWIN_STOP_EOL;''', '''            // Only a line's window has the newline among these bytes.
            KC(K_EOLSTOP, 1);
            stop = BUSTER_FWIN_STOP_EOL;''')
rep('''                n -= 1u;
                p = run;
                stop = BUSTER_FWIN_STOP_SCALAR;''', '''                n -= 1u;
                p = run;
                KC(K_PREFIXSTOP, 1);
                stop = BUSTER_FWIN_STOP_SCALAR;''')
rep('''                wk[n] = FTOK_STR_LIT;
                ws[n] = (uint32_t)(p - base);
                wl[n] = 0;''', '''                KC(K_STR, 1); KC(K_STR_BYTES, close + 1 - p);
                wk[n] = FTOK_STR_LIT;
                ws[n] = (uint32_t)(p - base);
                wl[n] = 0;''')
rep('''                wk[n] = FTOK_CHAR_LIT;
                ws[n] = (uint32_t)(p - base);''', '''                KC(K_CHAR, 1);
                wk[n] = FTOK_CHAR_LIT;
                ws[n] = (uint32_t)(p - base);''')
rep('''        stop = BUSTER_FWIN_STOP_SCALAR;
        break;
    }

    // A window never ends inside a run''', '''        KC(K_SCALARSTOP, 1);
        stop = BUSTER_FWIN_STOP_SCALAR;
        break;
    }

    // A window never ends inside a run''')
rep('''            stop = BUSTER_FWIN_STOP_TAIL;
            break;''', '''            KC(K_TAILSTOP, 1);
            stop = BUSTER_FWIN_STOP_TAIL;
            break;''')
rep('''    if (run_carry != 0)
    {
        n = open_idx;''', '''    KC(K_CAPSTOP, stop == BUSTER_FWIN_STOP_CAPACITY); KC(K_CARRYEND, run_carry != 0);
    if (run_carry != 0)
    {
        n = open_idx;''')
rep('''    w->count = n;
    w->pos = 0;
    w->serial = f->serial;''', '''    KC(K_WINTOKS, n);
    w->count = n;
    w->pos = 0;
    w->serial = f->serial;''')
rep('''        out_count += taken;
        i += taken;''', '''        KC(K_EMITTED, taken);
        out_count += taken;
        i += taken;''')
rep('''                    f->ptr = text_end;
                    f->at_bol = false;
                    w->pos = t + 1u;
                    return;''', '''                    f->ptr = text_end;
                    f->at_bol = false;
                    w->pos = t + 1u;
                    KC(K_READ, 1);
                    return;''')
open(path, 'w').write(s)
# The line windows' blocks and tokens, one-block windows, tokens passed, and the comments' and strings' lengths.
s = open(path).read()
s = s.replace('K_NOTOKBLK, K_LIMIT0, K_N };', 'K_NOTOKBLK, K_LIMIT0, K_BLOCKS_LINE, K_TOKS_LINE, K_WIN1BLK, K_PASSED, K_BC_LE32, K_BC_LE64, K_BC_LE128, K_BC_SAMEBLK, K_BC_NEXTBLK, K_STR_LE64, K_N };')
s = s.replace('"blocks_no_tokens", "blocks_limit0" };', '"blocks_no_tokens", "blocks_limit0", "blocks_linemode", "tokens_linemode", "windows_one_block", "tokens_passed", "bcomment_le32", "bcomment_le64", "bcomment_le128", "bcomment_closes_in_block", "bcomment_closes_next_block", "string_le64" };')
s = s.replace('KC(K_NOTOKBLK, m_count == 0);', 'KC(K_NOTOKBLK, m_count == 0); KC(K_BLOCKS_LINE, line_mode); KC(K_TOKS_LINE, line_mode ? m_count : 0);')
s = s.replace('''    KC(K_WINTOKS, n);''', '''    KC(K_WINTOKS, n); { static uint64_t b0; KC(K_WIN1BLK, k_count[K_BLOCKS] - b0 <= 1); b0 = k_count[K_BLOCKS]; }''')
s = s.replace('''    w->pos = i;
    return whole;''', '''    KC(K_PASSED, i - w->pos);
    w->pos = i;
    return whole;''')
s = s.replace('KC(K_BCOMMENT, 1); if (after) KC(K_BCOMMENT_BYTES, after - p);', 'KC(K_BCOMMENT, 1); if (after) { KC(K_BCOMMENT_BYTES, after - p); KC(K_BC_LE32, after - p <= 32); KC(K_BC_LE64, after - p <= 64); KC(K_BC_LE128, after - p <= 128); KC(K_BC_SAMEBLK, after - (base + block_offset) <= 64); KC(K_BC_NEXTBLK, after - (base + block_offset) > 64 && after - (base + block_offset) <= 128); }')
s = s.replace('KC(K_STR, 1); KC(K_STR_BYTES, close + 1 - p);', 'KC(K_STR, 1); KC(K_STR_BYTES, close + 1 - p); KC(K_STR_LE64, close + 1 - p <= 64);')
open(path, 'w').write(s)
