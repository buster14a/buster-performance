// Pass A of the front prototype: one pass over a text's bytes, 64 a step, that finds what a C lexer otherwise finds a
// byte at a time: which bytes are a comment's, which are a literal's after its opening quote, and which '#' start a
// directive line. Its answers are masks, a word a block, which the lexer's pass reads in place of branching on a '/'
// or a quote.
//
// A block's masks are arithmetic on seven compare masks:
//   - A block comment is set by "/*" and reset by the '/' of "*/", whatever came before: an add carries the set
//     through the bytes up to the reset (the propagate word is every byte but a reset's), across blocks by the add's
//     carry. A line comment the same way, set by "//" outside a block comment and reset by a newline.
//   - A string is the parity of the unescaped quotes outside comments (a carry-less multiply by all ones), and an
//     escaped byte is one after an odd run of backslashes (two adds, by the parity of a run's start).
//   - The three are computed as if the others' opening bytes were never inside them, and then checked: an opening that
//     starts a comment inside a line comment or a literal, a newline inside a literal, a backslash outside literals,
//     a string and a character constant in one block, a "*/" that shares its star or its slash with a "/*". A block where a check fails is read by the scalar machine
//     (scan_block_slow) from the block's first byte, with the state the blocks before it carried.
#ifndef FRONT_SCAN_H
#define FRONT_SCAN_H

#include <immintrin.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>

typedef struct Scan Scan;
struct Scan
{
    uint64_t* masks;         // two words a block: its bytes that are a comment's, and those that are a literal's after
                             // its opening quote
    uint32_t* directives;    // the '#' that start directive lines
    uint32_t directive_count;
    uint64_t blocks;
    uint64_t slow_blocks;
    uint64_t rare_blocks;
};

// A byte's line (1-based) is not the scan's work: few places ask (a __LINE__, a diagnostic), and each counts the
// newlines from the place before it (scan_lines), 64 bytes a step.
static inline uint64_t scan_lines(const uint8_t* s, uint64_t from, uint64_t to)
{
    const __m512i v_newline = _mm512_set1_epi8('\n');
    uint64_t count = 0;
    uint64_t at = from;
    while (at + 64u <= to)
    {
        count += (uint64_t)__builtin_popcountll(_mm512_cmpeq_epi8_mask(_mm512_loadu_si512((const void*)(s + at)), v_newline));
        at += 64u;
    }
    if (at < to)
    {
        count += (uint64_t)__builtin_popcountll(_mm512_cmpeq_epi8_mask(_mm512_loadu_si512((const void*)(s + at)), v_newline) & _bzhi_u64(~UINT64_C(0), (uint32_t)(to - at)));
    }
    return count;
}

typedef struct ScanState ScanState;
struct ScanState
{
    uint64_t in_block;       // the block's first byte is inside a block comment
    uint64_t in_line;        // ... a line comment
    uint64_t in_string;      // ... a string, after its opening quote
    uint64_t in_char;        // ... a character constant (only the scalar machine leaves a block so)
    uint64_t escaped;        // the block's first byte follows an odd run of backslashes
    uint64_t close_pending;  // the byte before the block is a '*' and the block's first is the '/' that closes
    uint64_t open_top;       // the byte before the block is the '/' of a "/*" that started a comment
};

// Whether the '#' at `at` is its line's first byte that is no blank and no comment's (1) or not (0): the comment masks
// of the blocks up to its own are written, from the byte `lower` on. Where every byte from `lower` to it is a blank or
// a comment's, and `lower` is not the text's first byte, the answer is another scan's to give (2): the bytes before
// `lower` are its.
static int scan_line_start_from(const uint8_t* s, const uint64_t* masks, uint64_t at, uint64_t lower)
{
    int start = 2;
    uint64_t q = at;
    while (start == 2 && q > lower)
    {
        q -= 1;
        const uint8_t c = s[q];
        if (((masks[2u * (q >> 6)] >> (q & 63u)) & 1u) != 0 || c == ' ' || c == '\t' || c == '\r' || c == '\f' || c == '\v') { continue; }
        start = c == '\n';
    }
    if (start == 2 && lower == 0) { start = 1; }
    return start;
}

static bool scan_line_start(const uint8_t* s, const uint64_t* masks, uint64_t at)
{
    return scan_line_start_from(s, masks, at, 0) == 1;
}

// One block by the scalar machine, from the state `st` (which it leaves for the next block).
typedef struct ScanSlow ScanSlow;
struct ScanSlow
{
    ScanState state;
    uint64_t comment;
    uint64_t tail;
    uint64_t hashes;
};

static __attribute__((noinline)) ScanSlow scan_block_slow(const uint8_t* s, uint64_t block, ScanState entry)
{
    ScanState* const st = &entry;
    const uint8_t* const p = s + block * 64u;
    enum { CODE, BLOCK, LINE, STRING, CHARACTER } mode = st->in_block != 0 ? BLOCK : st->in_line != 0 ? LINE : st->in_string != 0 ? STRING : st->in_char != 0 ? CHARACTER : CODE;
    uint64_t comment = 0;
    uint64_t tail = 0;
    uint64_t hashes = 0;
    uint64_t close_pending = 0;
    uint64_t open_top = 0;
    uint64_t escaped = 0;
    uint32_t i = 0;
    bool skip_star = st->open_top != 0;
    if (mode == BLOCK && st->close_pending != 0 && !skip_star)
    {
        comment |= 1u;
        mode = CODE;
        i = 1;
    }
    // (A backslash before a newline escapes nothing: the newline cuts the literal.)
    if ((mode == STRING || mode == CHARACTER) && st->escaped != 0 && p[0] != '\n')
    {
        tail |= 1u;
        i = 1;
    }
    while (i < 64u)
    {
        const uint8_t c = p[i];
        const uint8_t d = p[i + 1u];
        const uint64_t bit = UINT64_C(1) << i;
        if (mode == CODE)
        {
            if (c == '/' && d == '*')
            {
                comment |= bit;
                mode = BLOCK;
                if (i == 63u) { open_top = 1; }
                else { comment |= bit << 1; i += 1u; }
            }
            else if (c == '/' && d == '/') { comment |= bit; mode = LINE; }
            else if (c == '"') { mode = STRING; }
            else if (c == '\'') { mode = CHARACTER; }
            else if (c == '#') { hashes |= bit; }
        }
        else if (mode == BLOCK)
        {
            comment |= bit;
            if (c == '*' && d == '/' && !(skip_star && i == 0))
            {
                if (i == 63u) { close_pending = 1; }
                else { comment |= bit << 1; i += 1u; mode = CODE; }
            }
        }
        else if (mode == LINE)
        {
            if (c == '\n' && p[(int32_t)i - 1] != '\\') { mode = CODE; }
            else { comment |= bit; }
        }
        else
        {
            const uint8_t quote = mode == STRING ? '"' : '\'';
            if (c == '\\' && d != '\n')
            {
                tail |= bit;
                if (i == 63u) { escaped = 1; }
                else { tail |= bit << 1; i += 1u; }
            }
            else if (c == quote) { tail |= bit; mode = CODE; }
            else if (c == '\n') { mode = CODE; }
            else { tail |= bit; }
        }
        skip_star = false;
        i += 1u;
    }
    st->in_block = mode == BLOCK;
    st->in_line = mode == LINE;
    st->in_string = mode == STRING;
    st->in_char = mode == CHARACTER;
    st->escaped = escaped;
    st->close_pending = close_pending;
    st->open_top = open_top;
    return (ScanSlow){ .state = entry, .comment = comment, .tail = tail, .hashes = hashes };
}

// The bytes a block's rare part is for, by a lookup of each byte's low seven bits: a byte of 128 or more may pass for
// one of them, which only sends its block to the rare part, where every mask is a compare's.
_Alignas(64) static const uint8_t scan_rare[128] = {
    ['"'] = 1, ['\''] = 1, ['\\'] = 1, ['#'] = 1,
};

// The rare state between blocks, one word: a block that starts with none of it set, and has no rare byte outside its
// block comments, needs none of the rare masks.
#define SCAN_ST_LINE     0x01u
#define SCAN_ST_STRING   0x02u
#define SCAN_ST_CHAR     0x04u
#define SCAN_ST_ESCAPED  0x08u
#define SCAN_ST_OPEN_TOP 0x10u   // the byte before the block is the '/' of a "/*" that started a comment

// What the blocks before a block leave it.
typedef struct ScanCarry ScanCarry;
struct ScanCarry
{
    uint64_t in_block;        // the block's first byte is inside a block comment
    uint64_t close_pending;   // the byte before the block is a '*' and the block's first is a '/'
    uint64_t rare_state;      // SCAN_ST_*
    uint32_t directive_count;
    uint64_t rare_blocks;
    uint64_t lower;           // the first byte of this scan's own blocks: what is before it is another scan's
    uint32_t pending;         // a '#' whose line starts before `lower`: at most one, before every directive found
    uint32_t pending_at;
};

// A '#' outside comments and literals, at `at`: a directive line's start, none, or one for the stitch to decide.
static inline void scan_hash(const uint8_t* s, uint64_t size, const uint64_t* masks, uint32_t* directives, ScanCarry* carry, uint64_t at)
{
    if (at < size)
    {
        const int start = scan_line_start_from(s, masks, at, carry->lower);
        if (start == 1)
        {
            directives[carry->directive_count] = (uint32_t)at;
            carry->directive_count += 1u;
        }
        else if (start == 2)
        {
            carry->pending = 1;
            carry->pending_at = (uint32_t)at;
        }
    }
}

// A block's common masks: its block comments by the add, and what sends it to the rare part.
typedef struct ScanCommon ScanCommon;
struct ScanCommon
{
    uint64_t in_block;       // the bytes inside block comments
    uint64_t real_opens;     // the '/' that started one
    uint64_t close_stars;    // the '*' of a "*/"
    uint64_t line_opens;     // the '/' of a "//" outside block comments
    uint64_t block_out;      // the comment goes on after the block
    uint64_t unusual;        // not 0: the block is the rare part's
    uint64_t conflict;       // a "*/" that shares its '/' or its '*' with a "/*" of this block
};

static inline __attribute__((always_inline)) ScanCommon scan_common(__m512i v, __m512i v_next, __m512i v_slash, __m512i v_star, __m512i v_rare_lo, __m512i v_rare_hi,
                                                                    uint64_t in_block_carry, uint64_t close_pending)
{
    const uint64_t slash = _mm512_cmpeq_epi8_mask(v, v_slash);
    const uint64_t star = _mm512_cmpeq_epi8_mask(v, v_star);
    const uint64_t slash_next = _mm512_cmpeq_epi8_mask(v_next, v_slash);
    const uint64_t star_next = _mm512_cmpeq_epi8_mask(v_next, v_star);
    const __m512i rare_bytes = _mm512_permutex2var_epi8(v_rare_lo, v, v_rare_hi);
    const uint64_t rare = _mm512_test_epi8_mask(rare_bytes, rare_bytes);
    // Block comments: set at the '/' of "/*", reset at the '/' of "*/".
    const uint64_t opens = slash & star_next;
    const uint64_t close_stars = star & slash_next;
    const uint64_t closes = (close_stars << 1) | close_pending;
    const uint64_t propagate = ~closes;
    const uint64_t partial = propagate + opens;
    const uint64_t sum = partial + in_block_carry;
    const uint64_t flipped = sum ^ propagate;
    const uint64_t in_block = flipped | opens;
    const uint64_t conflict = opens & (closes | (close_stars >> 1));
    const uint64_t line_opens = slash & slash_next & ~in_block;
    return (ScanCommon){
        .in_block = in_block,
        .real_opens = opens & ~(flipped ^ opens),
        .close_stars = close_stars,
        .line_opens = line_opens,
        // (The add's carry by compares: of the two words, and of the carry into a word of ones.)
        .block_out = (uint64_t)(partial < opens) | ((uint64_t)(partial == ~UINT64_C(0)) & in_block_carry),
        .unusual = (rare & ~in_block) | line_opens | conflict,
        .conflict = conflict,
    };
}

// Blocks from `first` on, until one whose checks fail (returned, with the state before it in `carry`) or the text's
// end (`blocks` returned). No call is made here: a block the scalar machine reads ends the loop.
//
// A block's work is in two parts. Every block: four compares (its '/' and '*', and the same of the bytes one further
// on, so that no bit crosses a block's end by a carry), one lookup for the rare bytes, and the block comments' add.
// Only a block with a quote, an apostrophe, a backslash or a '#' outside block comments, with a "//" there, or one
// that starts inside a string or a line comment, goes on to the line comments' add, the escapes and the strings'
// parity. The common blocks run in a loop of their own, which a rare block ends: what that loop carries is two bits
// (whether a block comment goes on, and whether the last byte is the '*' of a "*/"), and what the rare part needs
// stays out of its registers.
static __attribute__((noinline)) uint64_t scan_blocks(const uint8_t* s, uint64_t size, uint64_t first, uint64_t blocks, uint64_t* masks, uint32_t* directives,
                                                      ScanCarry* carry)
{
    const __m512i v_rare_lo = _mm512_load_si512((const void*)scan_rare);
    const __m512i v_rare_hi = _mm512_load_si512((const void*)(scan_rare + 64));
    const __m512i v_slash = _mm512_set1_epi8('/');
    const __m512i v_star = _mm512_set1_epi8('*');
    uint64_t in_block_carry = carry->in_block;
    uint64_t close_pending = carry->close_pending;
    uint64_t rare_state = carry->rare_state;
    uint64_t b = first;
    bool failed = false;

    while (b < blocks && !failed)
    {
        // The common blocks.
        if (rare_state == 0)
        {
            const uint8_t* p = s + b * 64u;
            uint64_t* m = masks + 2u * b;
            uint64_t left = blocks - b;
            uint64_t open_top = 0;
            while (left != 0)
            {
                const ScanCommon c = scan_common(_mm512_loadu_si512((const void*)p), _mm512_loadu_si512((const void*)(p + 1)), v_slash, v_star, v_rare_lo, v_rare_hi,
                                                 in_block_carry, close_pending);
                open_top = c.real_opens >> 63;
                if (__builtin_expect((c.unusual | open_top) != 0, 0))
                {
                    if (c.unusual != 0) { break; }
                    // A comment opened by the block's last byte: the next block is the rare part's.
                    m[0] = c.in_block;
                    m[1] = 0;
                    in_block_carry = c.block_out;
                    close_pending = c.close_stars >> 63;
                    rare_state = SCAN_ST_OPEN_TOP;
                    p += 64;
                    m += 2;
                    left -= 1;
                    break;
                }
                m[0] = c.in_block;
                m[1] = 0;
                in_block_carry = c.block_out;
                close_pending = c.close_stars >> 63;
                p += 64;
                m += 2;
                left -= 1;
            }
            b = blocks - left;
            if (left == 0) { break; }
        }

        // The rare part of block b.
        {
            const uint8_t* const p = s + b * 64u;
            const __m512i v = _mm512_loadu_si512((const void*)p);
            const ScanCommon c = scan_common(v, _mm512_loadu_si512((const void*)(p + 1)), v_slash, v_star, v_rare_lo, v_rare_hi, in_block_carry, close_pending);
            carry->rare_blocks += 1;
            const uint64_t odd_bits = UINT64_C(0xAAAAAAAAAAAAAAAA);
            const uint64_t quote = _mm512_cmpeq_epi8_mask(v, _mm512_set1_epi8('"'));
            const uint64_t apostrophe = _mm512_cmpeq_epi8_mask(v, _mm512_set1_epi8('\''));
            const uint64_t backslash = _mm512_cmpeq_epi8_mask(v, _mm512_set1_epi8('\\'));
            const uint64_t hash = _mm512_cmpeq_epi8_mask(v, _mm512_set1_epi8('#'));
            const uint64_t newline = _mm512_cmpeq_epi8_mask(v, _mm512_set1_epi8('\n'));
            const uint64_t st_in_line = rare_state & SCAN_ST_LINE;
            const uint64_t st_in_string = (rare_state / SCAN_ST_STRING) & 1u;
            const uint64_t st_escaped = (rare_state / SCAN_ST_ESCAPED) & 1u;
            const uint64_t backslash_top = p[-1] == '\\';
            // ... or a "*/" that shares its '*' with the "/*" whose '/' is the last byte of the block before.
            uint64_t conflict = c.conflict | (((rare_state / SCAN_ST_OPEN_TOP) & 1u) & c.close_stars);

            // Line comments: set at a "//" outside a block comment, reset at a newline.
            const uint64_t line_propagate = ~newline;
            unsigned long long line_sum = 0;
            const uint64_t line_out = _addcarry_u64((unsigned char)st_in_line, line_propagate, c.line_opens, &line_sum);
            const uint64_t line_flipped = line_sum ^ line_propagate;
            const uint64_t in_line = (line_flipped | c.line_opens) & ~newline;
            const uint64_t real_line_opens = c.line_opens & ~(line_flipped ^ c.line_opens);
            conflict |= c.real_opens & in_line;
            conflict |= newline & line_flipped & ((backslash << 1) | backslash_top);
            const uint64_t comment = c.in_block | in_line;

            // Escaped bytes: the one after each run of backslashes (outside comments) of odd length. A run's start
            // added to the run carries to the byte after it, and that byte is escaped where its place's parity is not
            // its start's: the runs that start at even places and those that start at odd ones, an add each. The run
            // that reaches the block's last byte carries out of the add of its starts' parity, and is odd where that
            // parity is. (The idea of finding odd runs by adds is Langdale and Lemire's, "Parsing Gigabytes of JSON
            // per Second", 2019.)
            const uint64_t slashes = backslash & ~comment;
            const uint64_t runs = slashes & ~st_escaped;
            const uint64_t run_starts = runs & ~(runs << 1);
            const uint64_t after_even = (runs + (run_starts & ~odd_bits)) & ~runs;
            unsigned long long odd_sum = 0;
            const uint64_t escaped_out = _addcarry_u64(0, runs, run_starts & odd_bits, &odd_sum);
            const uint64_t after_odd = odd_sum & ~runs;
            const uint64_t escaped = (after_even & odd_bits) | (after_odd & ~odd_bits) | st_escaped;

            // Strings: the parity of the quotes outside comments.
            const uint64_t quotes = quote & ~comment & ~escaped;
            const uint64_t parity = (uint64_t)_mm_cvtsi128_si64(_mm_clmulepi64_si128(_mm_set_epi64x(0, (long long)quotes), _mm_set1_epi8((char)0xff), 0));
            const uint64_t in_string = parity ^ (UINT64_C(0) - st_in_string);
            conflict |= (c.real_opens | real_line_opens) & in_string;
            conflict |= newline & in_string;
            // Character constants: the parity of the apostrophes outside strings, in a block that has no string (one
            // with both is the scalar machine's: a quote may be a constant's character, an apostrophe a string's).
            const uint64_t st_in_char = (rare_state / SCAN_ST_CHAR) & 1u;
            const uint64_t apostrophes = apostrophe & ~comment & ~escaped & ~in_string;
            uint64_t in_char = 0;
            if ((apostrophes | st_in_char) != 0)
            {
                conflict |= quotes | st_in_string;
                const uint64_t char_parity = (uint64_t)_mm_cvtsi128_si64(_mm_clmulepi64_si128(_mm_set_epi64x(0, (long long)apostrophes), _mm_set1_epi8((char)0xff), 0));
                in_char = char_parity ^ (UINT64_C(0) - st_in_char);
                conflict |= (c.real_opens | real_line_opens | newline) & in_char;
            }
            // A backslash outside comments and literals escapes nothing: the escapes above took it for one.
            conflict |= slashes & ~in_string & ~in_char;
            if (conflict != 0)
            {
                failed = true;
            }
            else
            {
                uint64_t hashes = hash & ~comment & ~in_string & ~in_char;
                masks[2u * b] = comment;
                masks[2u * b + 1u] = (in_string ^ quotes) | (in_char ^ apostrophes);
                while (hashes != 0)
                {
                    scan_hash(s, size, masks, directives, carry, b * 64u + (uint64_t)__builtin_ctzll(hashes));
                    hashes &= hashes - 1u;
                }
                in_block_carry = c.block_out;
                close_pending = c.close_stars >> 63;
                rare_state = ((c.real_opens >> 63) * SCAN_ST_OPEN_TOP) | line_out | ((in_string >> 63) * SCAN_ST_STRING) | ((in_char >> 63) * SCAN_ST_CHAR) |
                             (escaped_out * SCAN_ST_ESCAPED);
                b += 1;
            }
        }
    }
    carry->in_block = in_block_carry;
    carry->close_pending = close_pending;
    carry->rare_state = rare_state;
    return b;
}

static inline ScanState scan_state_of(const ScanCarry* carry)
{
    return (ScanState){ .in_block = carry->in_block, .in_line = carry->rare_state & SCAN_ST_LINE, .in_string = (carry->rare_state / SCAN_ST_STRING) & 1u,
                        .in_char = (carry->rare_state / SCAN_ST_CHAR) & 1u, .escaped = (carry->rare_state / SCAN_ST_ESCAPED) & 1u,
                        .close_pending = carry->close_pending, .open_top = (carry->rare_state / SCAN_ST_OPEN_TOP) & 1u };
}

static inline void scan_carry_set(ScanCarry* carry, const ScanState* state)
{
    carry->in_block = state->in_block;
    carry->rare_state = state->in_line | (state->in_string * SCAN_ST_STRING) | (state->in_char * SCAN_ST_CHAR) | (state->escaped * SCAN_ST_ESCAPED) |
                        (state->open_top * SCAN_ST_OPEN_TOP);
    carry->close_pending = state->close_pending;
}

// The blocks [first, last) of the text, from the state `carry` (which is left as the block `last` finds it): their
// masks, and their directive lines to `directives`. Returns the blocks the scalar machine read.
static __attribute__((noinline)) uint64_t scan_range(const uint8_t* s, uint64_t size, uint64_t first, uint64_t last, uint64_t* masks, uint32_t* directives, ScanCarry* carry)
{
    uint64_t slow_blocks = 0;
    uint64_t b = first;
    while (b < last)
    {
        b = scan_blocks(s, size, b, last, masks, directives, carry);
        if (b < last)
        {
            // The block whose checks failed, by the scalar machine.
            const ScanSlow slow = scan_block_slow(s, b, scan_state_of(carry));
            masks[2u * b] = slow.comment;
            masks[2u * b + 1u] = slow.tail;
            scan_carry_set(carry, &slow.state);
            uint64_t hashes = slow.hashes;
            while (hashes != 0)
            {
                scan_hash(s, size, masks, directives, carry, b * 64u + (uint64_t)__builtin_ctzll(hashes));
                hashes &= hashes - 1u;
            }
            slow_blocks += 1;
            b += 1;
        }
    }
    return slow_blocks;
}

// The text's `size` bytes, with at least 64 readable bytes before it and 192 after it (newlines).
static __attribute__((noinline)) void scan_text(const uint8_t* s, uint64_t size, Scan* out)
{
    const uint64_t blocks = (size + 63u) / 64u;
    ScanCarry carry = { 0 };
    out->slow_blocks = scan_range(s, size, 0, blocks, out->masks, out->directives, &carry);
    out->directive_count = carry.directive_count;
    out->blocks = blocks;
    out->rare_blocks = carry.rare_blocks;
}

// A scan that starts at the block `block` (not the text's first) before the scan of the blocks before it has ended:
// the state it guesses those blocks leave. The last line start at or before the block's first byte is outside every
// line comment and literal (its newline is no splice's), so it is in a block comment or in none; which, by the nearer
// of the last "/*" and the last "*/" before it. That is a guess (either pair may be a literal's or a line comment's
// bytes): whoever joins the scans compares it with the state the blocks before really left, and scans again from that
// where they differ. From the line's start to the block, the scalar machine.
static ScanCarry scan_entry_guess(const uint8_t* s, uint64_t block)
{
    const uint64_t position = block * 64u;
    uint64_t line = position;
    while (line > 0 && !(s[line - 1u] == '\n' && s[line - 2u] != '\\')) { line -= 1u; }
    bool in_block = false;
    bool found = false;
    const uint64_t bound = line > 65536u ? line - 65536u : 0;
    for (uint64_t q = line; q >= bound + 2u && !found; q -= 1u)
    {
        if (s[q - 2u] == '*' && s[q - 1u] == '/') { found = true; }
        else if (s[q - 2u] == '/' && s[q - 1u] == '*') { found = true; in_block = true; }
    }
    ScanState state = { .in_block = in_block };
    for (uint64_t b = line >> 6; b < block; b += 1)
    {
        if (b == line >> 6 && (line & 63u) != 0)
        {
            // The block's bytes before the line: blanks, or a comment's.
            uint8_t bytes[66];
            memcpy(bytes, s + b * 64u - 1u, 66);
            memset(bytes, in_block ? 'x' : ' ', 1u + (line & 63u));
            state = scan_block_slow(bytes + 1, 0, state).state;
        }
        else
        {
            state = scan_block_slow(s, b, state).state;
        }
    }
    ScanCarry carry = { 0 };
    scan_carry_set(&carry, &state);
    carry.lower = position;
    return carry;
}

// A part of a text's scan that a lane does by itself: its blocks, the state it started from and left, and its
// directive lines.
typedef struct ScanChunk ScanChunk;
struct ScanChunk
{
    uint64_t first;          // its blocks: [first, last)
    uint64_t last;
    ScanCarry entry;
    ScanCarry exit;
    uint32_t* directives;
    uint32_t directive_count;
    uint64_t slow_blocks;
};

// One chunk's scan: its masks to the text's (no other chunk writes its blocks' words), its directive lines to its own
// list. A chunk that is not the text's first starts from a guess.
static void scan_chunk(const uint8_t* s, uint64_t size, uint64_t* masks, ScanChunk* chunk)
{
    ScanCarry carry = { 0 };
    if (chunk->first != 0) { carry = scan_entry_guess(s, chunk->first); }
    chunk->entry = carry;
    chunk->slow_blocks = scan_range(s, size, chunk->first, chunk->last, masks, chunk->directives, &carry);
    chunk->exit = carry;
    chunk->directive_count = carry.directive_count;
}

// The chunks' scans joined, in order: each guess against what the chunk before left (a chunk whose guess was wrong is
// scanned again from that), the '#' a chunk left open, and the directive lines in one list. `out` has the text's masks.
static void scan_join(const uint8_t* s, uint64_t size, ScanChunk* chunks, uint32_t chunk_count, Scan* out, uint32_t* rescans, uint32_t* decided)
{
    uint32_t total = 0;
    uint64_t slow_blocks = 0;
    uint64_t rare_blocks = 0;
    for (uint32_t c = 0; c < chunk_count; c += 1)
    {
        ScanChunk* const chunk = chunks + c;
        if (c != 0)
        {
            const ScanChunk* const before = chunk - 1;
            if (before->exit.in_block != chunk->entry.in_block || before->exit.close_pending != chunk->entry.close_pending || before->exit.rare_state != chunk->entry.rare_state)
            {
                ScanCarry carry = { .in_block = before->exit.in_block, .close_pending = before->exit.close_pending, .rare_state = before->exit.rare_state, .lower = chunk->first * 64u };
                chunk->entry = carry;
                chunk->slow_blocks = scan_range(s, size, chunk->first, chunk->last, out->masks, chunk->directives, &carry);
                chunk->exit = carry;
                chunk->directive_count = carry.directive_count;
                *rescans += 1u;
            }
            if (chunk->exit.pending != 0)
            {
                *decided += 1u;
                if (scan_line_start(s, out->masks, chunk->exit.pending_at))
                {
                    out->directives[total] = chunk->exit.pending_at;
                    total += 1u;
                }
            }
        }
        memcpy(out->directives + total, chunk->directives, (size_t)chunk->directive_count * 4u);
        total += chunk->directive_count;
        slow_blocks += chunk->slow_blocks;
        rare_blocks += chunk->exit.rare_blocks;
    }
    out->directive_count = total;
    out->blocks = (size + 63u) / 64u;
    out->slow_blocks = slow_blocks;
    out->rare_blocks = rare_blocks;
}

#endif
