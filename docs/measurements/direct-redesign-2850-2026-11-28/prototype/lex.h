// Pass B's lexer: a window of a text's raw tokens, 64 bytes a step, from pass A's masks. Nothing is decided on a '/'
// or a quote here: a comment's bytes are blanks and a literal is one token, from its opening quote to the last byte
// of its tail. What is left to a scalar lexer is marked (a token of kind 0): a punctuator of three characters or one
// cut by a block's end, a '.' before a digit or a '.', a backslash, a byte that is no C character.
#ifndef FRONT_LEX_H
#define FRONT_LEX_H

#include "ref.h"
#include <immintrin.h>

#define WIN_CAPACITY 2048u
#define WIN_SPAN (65536u - 192u)
#define WIN_SCALAR 0u

#define LC_SPACE 0x01u
#define LC_RUN   0x02u
#define LC_QUOTE 0x04u
#define LC_DOT   0x08u
#define LC_HARD  0x10u

// A byte's token kind where one byte decides it (an identifier's or a number's first byte, a literal's opening quote,
// a punctuator's only byte).
_Alignas(64) static const uint8_t lex_kind[128] = {
    ['!'] = K_BANG, ['"'] = K_STR, ['$'] = K_IDENT, ['%'] = K_PERCENT, ['&'] = K_AMP, ['\''] = K_CHAR, ['('] = K_LPAREN, [')'] = K_RPAREN,
    ['*'] = K_STAR, ['+'] = K_PLUS, [','] = K_COMMA, ['-'] = K_MINUS, ['.'] = K_DOT, ['/'] = K_SLASH,
    ['0'] = K_INT, ['1'] = K_INT, ['2'] = K_INT, ['3'] = K_INT, ['4'] = K_INT, ['5'] = K_INT, ['6'] = K_INT, ['7'] = K_INT, ['8'] = K_INT, ['9'] = K_INT,
    [':'] = K_COLON, [';'] = K_SEMI, ['<'] = K_LT, ['='] = K_ASSIGN, ['>'] = K_GT, ['?'] = K_QUESTION,
    ['A'] = K_IDENT, ['B'] = K_IDENT, ['C'] = K_IDENT, ['D'] = K_IDENT, ['E'] = K_IDENT, ['F'] = K_IDENT, ['G'] = K_IDENT, ['H'] = K_IDENT, ['I'] = K_IDENT,
    ['J'] = K_IDENT, ['K'] = K_IDENT, ['L'] = K_IDENT, ['M'] = K_IDENT, ['N'] = K_IDENT, ['O'] = K_IDENT, ['P'] = K_IDENT, ['Q'] = K_IDENT, ['R'] = K_IDENT,
    ['S'] = K_IDENT, ['T'] = K_IDENT, ['U'] = K_IDENT, ['V'] = K_IDENT, ['W'] = K_IDENT, ['X'] = K_IDENT, ['Y'] = K_IDENT, ['Z'] = K_IDENT,
    ['['] = K_LBRACKET, [']'] = K_RBRACKET, ['^'] = K_CARET, ['_'] = K_IDENT,
    ['a'] = K_IDENT, ['b'] = K_IDENT, ['c'] = K_IDENT, ['d'] = K_IDENT, ['e'] = K_IDENT, ['f'] = K_IDENT, ['g'] = K_IDENT, ['h'] = K_IDENT, ['i'] = K_IDENT,
    ['j'] = K_IDENT, ['k'] = K_IDENT, ['l'] = K_IDENT, ['m'] = K_IDENT, ['n'] = K_IDENT, ['o'] = K_IDENT, ['p'] = K_IDENT, ['q'] = K_IDENT, ['r'] = K_IDENT,
    ['s'] = K_IDENT, ['t'] = K_IDENT, ['u'] = K_IDENT, ['v'] = K_IDENT, ['w'] = K_IDENT, ['x'] = K_IDENT, ['y'] = K_IDENT, ['z'] = K_IDENT,
    ['{'] = K_LBRACE, ['|'] = K_PIPE, ['}'] = K_RBRACE, ['~'] = K_TILDE,
};

#define LEX_RUN_ROW LC_RUN, LC_RUN, LC_RUN, LC_RUN, LC_RUN, LC_RUN, LC_RUN, LC_RUN
_Alignas(64) static const uint8_t lex_class[128] = {
    // 0x00: controls are hard, but the blanks.
    LC_HARD, LC_HARD, LC_HARD, LC_HARD, LC_HARD, LC_HARD, LC_HARD, LC_HARD, LC_HARD, LC_SPACE, LC_SPACE, LC_SPACE, LC_SPACE, LC_SPACE, LC_HARD, LC_HARD,
    LC_HARD, LC_HARD, LC_HARD, LC_HARD, LC_HARD, LC_HARD, LC_HARD, LC_HARD, LC_HARD, LC_HARD, LC_HARD, LC_HARD, LC_HARD, LC_HARD, LC_HARD, LC_HARD,
    // 0x20: space ! " # $ % & ' ( ) * + , - . /
    LC_SPACE, 0, LC_QUOTE, LC_HARD, LC_RUN, 0, 0, LC_QUOTE, 0, 0, 0, 0, 0, 0, LC_DOT, 0,
    // 0x30: digits : ; < = > ?
    LEX_RUN_ROW, LC_RUN, LC_RUN, 0, 0, 0, 0, 0, 0,
    // 0x40: @ A-O
    LC_HARD, LC_RUN, LC_RUN, LC_RUN, LC_RUN, LC_RUN, LC_RUN, LC_RUN, LEX_RUN_ROW,
    // 0x50: P-Z [ \ ] ^ _
    LEX_RUN_ROW, LC_RUN, LC_RUN, LC_RUN, 0, LC_HARD, 0, 0, LC_RUN,
    // 0x60: ` a-o
    LC_HARD, LC_RUN, LC_RUN, LC_RUN, LC_RUN, LC_RUN, LC_RUN, LC_RUN, LEX_RUN_ROW,
    // 0x70: p-z { | } ~ DEL
    LEX_RUN_ROW, LC_RUN, LC_RUN, LC_RUN, 0, 0, 0, 0, LC_HARD,
};

// The class of the byte after each byte: the second character's class in a two-character punctuator (the low three
// bits), whether it goes on with an identifier's or a number's run (8), whether it makes a '.' before it a number's
// or an ellipsis's (16: a digit or a '.'), and whether it is a quote (32).
#define LN_RUN   0x08u
#define LN_DOT   0x10u
#define LN_QUOTE 0x20u
_Alignas(64) static const uint8_t lex_next_class[128] = {
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    // space ! " # $ % & ' ( ) * + , - . /
    0, 0, LN_QUOTE, 0, LN_RUN, 0, 5, LN_QUOTE, 0, 0, 0, 4, 0, 3, LN_DOT, 0,
    // digits : ; < = > ?
    LN_RUN | LN_DOT, LN_RUN | LN_DOT, LN_RUN | LN_DOT, LN_RUN | LN_DOT, LN_RUN | LN_DOT, LN_RUN | LN_DOT, LN_RUN | LN_DOT, LN_RUN | LN_DOT, LN_RUN | LN_DOT, LN_RUN | LN_DOT,
    0, 0, 7, 1, 2, 0,
    0, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN,
    LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, 0, 0, 0, 0, LN_RUN,
    0, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN,
    LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, LN_RUN, 0, 6, 0, 0, 0,
};

// The punctuators of two characters: the first character's class times eight, and the pair's kind by the two classes.
_Alignas(64) static const uint8_t lex_pair_first[128] = {
    ['-'] = 1 << 3, ['+'] = 2 << 3, ['*'] = 3 << 3, ['%'] = 4 << 3, ['&'] = 5 << 3, ['|'] = 6 << 3, ['^'] = 7 << 3,
    ['<'] = 8 << 3, ['>'] = 9 << 3, ['='] = 10 << 3, ['!'] = 11 << 3, ['/'] = 12 << 3,
};
_Alignas(64) static const uint8_t lex_pair_kind[128] = {
    [(1 << 3) | 2] = K_ARROW, [(1 << 3) | 3] = K_DEC, [(1 << 3) | 1] = K_SUB_ASSIGN,
    [(2 << 3) | 4] = K_INC, [(2 << 3) | 1] = K_ADD_ASSIGN,
    [(3 << 3) | 1] = K_MUL_ASSIGN,
    [(4 << 3) | 1] = K_MOD_ASSIGN,
    [(5 << 3) | 5] = K_LAND, [(5 << 3) | 1] = K_AND_ASSIGN,
    [(6 << 3) | 6] = K_LOR, [(6 << 3) | 1] = K_OR_ASSIGN,
    [(7 << 3) | 1] = K_XOR_ASSIGN,
    [(8 << 3) | 7] = K_LSHIFT, [(8 << 3) | 1] = K_LE,
    [(9 << 3) | 2] = K_RSHIFT, [(9 << 3) | 1] = K_GE,
    [(10 << 3) | 1] = K_EQ,
    [(11 << 3) | 1] = K_NE,
    [(12 << 3) | 1] = K_DIV_ASSIGN,
};

_Alignas(64) static const uint8_t lex_iota[64] = {
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
    32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63,
};
_Alignas(64) static const uint8_t lex_iota1[64] = {
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32,
    33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64,
};

// The window's arrays are one region, so that one register addresses them all: kinds, lengths and flags a byte a
// token, then the starts (two bytes) and the data (four), each with room for 128 tokens past the capacity.
#define WIN_ROOM (WIN_CAPACITY + 128u)
#define WIN_KINDS_AT 0u
#define WIN_LENS_AT WIN_ROOM
#define WIN_FLAGS_AT (2u * WIN_ROOM)
#define WIN_STARTS_AT (4u * WIN_ROOM)
#define WIN_DATA_AT (8u * WIN_ROOM)
#define WIN_REGION_BYTES (12u * WIN_ROOM)

// A window of raw tokens: each one's kind, its first byte's offset from the window's base (the 64-byte block the
// window's first byte is in) and its length (0 where a byte doesn't hold it).
typedef struct Window Window;
struct Window
{
    uint8_t* kinds;          // capacity + 64 each: the loop stores whole vectors
    uint8_t* lens;
    uint16_t* starts;
    uint32_t* data;          // what the names' and the numbers' loops make of the tokens
    uint8_t* flags;
    uint64_t base;           // the text offset the starts count from
    uint32_t count;
    uint64_t end;            // the first byte past what the window covers
};

// Lexes the text's bytes [from, limit) into `w`, from the masks `masks` (two words a block: comment bytes, literal
// tails). `from` is a token's first byte or a blank. The window ends at `limit`, when it is full, or 64 KB from its
// base, and never inside a token.
static __attribute__((noinline)) void lex_window(const uint8_t* s, const uint64_t* masks, uint64_t from, uint64_t limit, Window* w)
{
    uint8_t* const wk = w->kinds;
    uint8_t* const wl = w->lens;
    uint16_t* const ws = w->starts;
    const __m512i v_kind_lo = _mm512_load_si512((const void*)lex_kind);
    const __m512i v_kind_hi = _mm512_load_si512((const void*)(lex_kind + 64));
    const __m512i v_class_lo = _mm512_load_si512((const void*)lex_class);
    const __m512i v_class_hi = _mm512_load_si512((const void*)(lex_class + 64));
    const __m512i v_next_lo = _mm512_load_si512((const void*)lex_next_class);
    const __m512i v_next_hi = _mm512_load_si512((const void*)(lex_next_class + 64));
    const __m512i v_first_lo = _mm512_load_si512((const void*)lex_pair_first);
    const __m512i v_first_hi = _mm512_load_si512((const void*)(lex_pair_first + 64));
    const __m512i v_pair_lo = _mm512_load_si512((const void*)lex_pair_kind);
    const __m512i v_pair_hi = _mm512_load_si512((const void*)(lex_pair_kind + 64));
    const __m512i v_iota = _mm512_load_si512((const void*)lex_iota);
    const __m512i v_iota1 = _mm512_load_si512((const void*)lex_iota1);
    const __m512i v_sign = _mm512_set1_epi8((char)0x80);
    const __m512i v_space = _mm512_set1_epi8((char)LC_SPACE);
    const __m512i v_run = _mm512_set1_epi8((char)LC_RUN);
    const __m512i v_quote = _mm512_set1_epi8((char)LC_QUOTE);
    const __m512i v_hard = _mm512_set1_epi8((char)LC_HARD);
    const __m512i v_dot = _mm512_set1_epi8((char)LC_DOT);
    const __m512i v_next_run = _mm512_set1_epi8((char)LN_RUN);
    const __m512i v_next_dot = _mm512_set1_epi8((char)LN_DOT);
    const __m512i v_seven = _mm512_set1_epi8(7);
    const uint64_t even_bits = UINT64_C(0x5555555555555555);
    const uint64_t top_bit = UINT64_C(1) << 63;
    const uint32_t spare = WIN_CAPACITY + 63u;
    const uint64_t base = from & ~UINT64_C(63);
    const uint64_t span_end = base + WIN_SPAN;
    uint64_t block = base;
    uint64_t live = ~UINT64_C(0) << (from & 63u);
    uint32_t n = 0;
    uint64_t run_carry = 0;       // the block's first byte goes on with the run of the byte before
    uint64_t open_in = 0;         // the last token that started hasn't ended
    uint32_t open_index = spare;  // ... its place in the window
    uint64_t open_start = from;   // ... and its first byte

    while (block < limit && n + 64u <= WIN_CAPACITY && block < span_end)
    {
        const __m512i v = _mm512_loadu_si512((const void*)(s + block));
        const __m512i v1 = _mm512_loadu_si512((const void*)(s + block + 1u));
        const uint64_t ascii = _mm512_testn_epi8_mask(v, v_sign);
        const __m512i kinds_raw = _mm512_maskz_permutex2var_epi8(ascii, v_kind_lo, v, v_kind_hi);
        const __m512i classes = _mm512_maskz_permutex2var_epi8(ascii, v_class_lo, v, v_class_hi);
        const __m512i next_classes = _mm512_maskz_permutex2var_epi8(_mm512_testn_epi8_mask(v1, v_sign), v_next_lo, v1, v_next_hi);
        const __m512i first = _mm512_maskz_permutex2var_epi8(ascii, v_first_lo, v, v_first_hi);
        const __m512i pair_kinds = _mm512_permutex2var_epi8(v_pair_lo, _mm512_ternarylogic_epi32(first, next_classes, v_seven, 0xf8), v_pair_hi);
        const uint64_t comment = masks[2u * (block >> 6)];
        const uint64_t tail = masks[2u * (block >> 6) + 1u];
        const uint64_t tail_after = masks[2u * (block >> 6) + 3u] & 1u;
        if (limit - block < 64u) { live &= ~(~UINT64_C(0) << (limit - block)); }
        const uint64_t keep = ~comment & live;
        const uint64_t code = keep & ~tail;
        const uint64_t solid = (_mm512_testn_epi8_mask(classes, v_space) & code) | (tail & live);
        const uint64_t runs = _mm512_test_epi8_mask(classes, v_run) & code;
        const uint64_t quotes = _mm512_test_epi8_mask(classes, v_quote) & code;
        const uint64_t hard = (_mm512_test_epi8_mask(classes, v_hard) | ~ascii) & code;
        const uint64_t run_goes_on = runs & _mm512_test_epi8_mask(next_classes, v_next_run);
        const uint64_t punct = solid & code & ~runs & ~quotes;
        const uint64_t candidates = _mm512_test_epi8_mask(pair_kinds, pair_kinds) & punct;
        const uint64_t dots = _mm512_test_epi8_mask(classes, v_dot) & _mm512_test_epi8_mask(next_classes, v_next_dot) & code;
        uint64_t pairs = candidates;
        uint64_t scalars = hard | dots;
        if (__builtin_expect((candidates & ((candidates >> 1) | top_bit)) != 0, 0))
        {
            // A taken pair uses up the next candidate's first character: of each run of candidates, the ones at even
            // places from its start. A pair before a candidate (the third character may go on with it) and a pair at
            // the block's last byte are the scalar lexer's.
            const uint64_t candidate_starts = candidates & ~(candidates << 1);
            const uint64_t from_even = candidates & ~(candidates + (candidate_starts & even_bits));
            pairs = (from_even & even_bits) | (candidates & ~from_even & ~even_bits);
            scalars |= pairs & ((candidates >> 1) | top_bit);
        }
        const uint64_t tok_starts = solid & code & ~((runs & ((runs << 1) | run_carry)) | (pairs << 1));
        const uint64_t tail_last = tail & live & ~((tail >> 1) | (tail_after << 63));
        const uint64_t tok_ends = (solid & code & ~quotes & ~(run_goes_on | pairs)) | tail_last;
        const uint64_t own_ends = tok_ends & (tok_ends - open_in);
        // The token that came from the blocks before ends here, and its length is known (or it goes on: the length so
        // far, written again by the block that ends it).
        const uint64_t carried_len = block + _tzcnt_u64(tok_ends) + 1u - open_start;
        wl[open_in != 0 ? open_index : spare] = (uint8_t)(carried_len <= 255u ? carried_len : 0u);

        const uint32_t m_count = (uint32_t)__builtin_popcountll(tok_starts);
        const __m512i comp_kinds = _mm512_maskz_compress_epi8(tok_starts, _mm512_mask_blend_epi8(pairs, kinds_raw, pair_kinds));
        const __m512i comp_pos = _mm512_maskz_compress_epi8(tok_starts, v_iota);
        const __m512i comp_ends = _mm512_maskz_compress_epi8(own_ends, v_iota1);
        _mm512_storeu_si512((void*)(wk + n), comp_kinds);
        _mm512_storeu_si512((void*)(wl + n), _mm512_sub_epi8(comp_ends, comp_pos));
        const __m512i v_offset = _mm512_set1_epi16((short)(block - base));
        _mm512_storeu_si512((void*)(ws + n), _mm512_add_epi16(v_offset, _mm512_cvtepu8_epi16(_mm512_castsi512_si256(comp_pos))));
        if (__builtin_expect(m_count > 32u, 0))
        {
            _mm512_storeu_si512((void*)(ws + n + 32u), _mm512_add_epi16(v_offset, _mm512_cvtepu8_epi16(_mm512_extracti64x4_epi64(comp_pos, 1))));
        }
        if (__builtin_expect(scalars != 0, 0))
        {
            uint64_t rest = scalars & tok_starts;
            while (rest != 0)
            {
                const uint32_t bit = (uint32_t)__builtin_ctzll(rest);
                const uint32_t idx = n + (uint32_t)__builtin_popcountll(tok_starts & _bzhi_u64(~UINT64_C(0), bit));
                wk[idx] = WIN_SCALAR;
                wl[idx] = 1u;
                rest &= rest - 1u;
            }
        }
        // What crosses into the next block: whether the last byte's run goes on, and the last token that started, if
        // it hasn't ended (a run that goes on, a literal whose tail does).
        const uint64_t open_out = (run_goes_on >> 63) | ((((quotes | (tail & live)) >> 63) & tail_after));
        open_start = tok_starts != 0 ? block + 63u - _lzcnt_u64(tok_starts) : open_start;
        open_index = tok_starts != 0 ? n + m_count - 1u : open_index;
        run_carry = run_goes_on >> 63;
        open_in = open_out;
        n += m_count;
        block += 64u;
        live = ~UINT64_C(0);
    }
    uint64_t end = block < limit ? block : limit;
    // A window never ends inside a token: one that goes on is lexed again by the next window.
    if (open_in != 0 && n != 0)
    {
        n -= 1u;
        end = open_start;
    }
    w->base = base;
    w->count = n;
    w->end = end;
}

#endif
