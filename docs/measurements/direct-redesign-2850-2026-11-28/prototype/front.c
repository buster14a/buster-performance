// The front prototype (buster#2850's direct path, redesigned): the main file's text to the direct path's token stream,
// without what directives and macro expansions compute. Those are taken from a recording of c_direct's own compile
// (oracle.h): wherever the text stops being its own tokens (a directive line, a macro's name) the recording says which
// tokens follow and where the text goes on. Everything else is done here and checked against the recording, token for
// token: the comments' and literals' masks (scan.h), the raw tokens (lex.h), the names (table.h), the numbers, the
// one-token and empty macros, and the stream's arrays.
#define _GNU_SOURCE
#include "oracle.h"
#include "scan.h"
#include "lex.h"
#include "table.h"
#include <linux/perf_event.h>
#include <sys/ioctl.h>
#include <sys/syscall.h>
#include <time.h>
#include <x86intrin.h>

#define WF_SLOW 0x10u   // a window token for the scalar lexer, beside a slot's SLOT_EVENT flags

typedef struct Front Front;
struct Front
{
    const Oracle* o;
    Table table;
    Scan scan;
    Window win;
    uint8_t* out_kind;
    uint32_t* out_data;
    uint32_t out_count;
    uint32_t out_cap;
    uint32_t event;          // the next of the oracle's events
    uint32_t bind;           // the next of its bindings
    // Counts of one pass.
    uint64_t windows;
    uint64_t window_tokens;
    uint64_t names;
    uint64_t long_names;
    uint64_t numbers;
    uint64_t numbers_slow;
    uint64_t slow_tokens;
    uint64_t deleted_names;
    uint64_t checked_names;
    uint64_t plain_function_names;
    uint64_t events_used;
    uint64_t events_passed;
    uint64_t replayed;
    uint64_t resumed_in_window;
    uint64_t binds_applied;
    const char* failure;
    uint64_t failure_at;
};

// ---------------------------------------------------------------------------------------------------------------------
// The names' table from the oracle: keywords, the built-in macros, and the bindings in order.

static void front_bind(Front* f, const OracleBind* b)
{
    const Oracle* const o = f->o;
    Table* const t = &f->table;
    Slot* slot = table_name(t, o->text + b->name, b->name_length);
    if (b->undef != 0)
    {
        slot->flags = 0;
        slot->kind = slot->base_kind;
        slot->data = slot->placed != 0 ? 0u : slot->id;
        return;
    }
    slot->flags = SLOT_MACRO;
    slot->kind = slot->base_kind;
    slot->data = slot->placed != 0 ? 0u : slot->id;
    const uint32_t k = b->kind;
    if (b->mode == 1u && (k == K_IDENT || (k >= 64u && k <= 121u)))
    {
        const Slot* const replacement = table_name(t, o->text + b->replacement, b->replacement_length);
        slot->kind = (uint8_t)k;
        slot->data = replacement->id;
        slot->placed = 0;
        if (k == K_IDENT) { slot->flags |= SLOT_CHECK; }
        t->replacement[slot->id] = table_slot_reference(t, replacement);
    }
    else if (b->mode == 1u)
    {
        // Any other one-token body, in place too: a number, a punctuator, a literal (its data is the recording's
        // pool index).
        slot->kind = (uint8_t)k;
        slot->data = b->data;
        slot->placed = 0;
    }
    else if (b->mode == 4u) { slot->flags |= SLOT_DELETE; }
    else if (b->mode == 5u) { slot->flags |= SLOT_DELETE_IF_PAREN; }
    else { slot->flags |= SLOT_STOP | (b->is_func != 0 ? SLOT_FUNC : 0u); }
}

static void front_table_setup(Front* f)
{
    const Oracle* const o = f->o;
    table_reset(&f->table);
    for (uint32_t id = 1; id <= o->ident_count; id += 1)
    {
        const OracleIdent* const e = o->idents + id;
        const bool builtin = e->pp_kw != 0 && e->macro_bit != 0;
        if (e->kw_kind == 0 && !builtin) { continue; }
        Slot* slot = table_name(&f->table, o->text + e->name, e->length);
        if (e->kw_kind != 0)
        {
            slot->kind = e->kw_kind;
            slot->base_kind = e->kw_kind;
            if (e->kw_kind == K_KW_FOR || e->kw_kind == K_KW_WHILE) { slot->placed = ~UINT32_C(0); slot->data = 0; }
        }
        if (builtin) { slot->flags = SLOT_MACRO | SLOT_STOP; }
    }
    f->bind = 0;
    while (f->bind < o->bind_count && o->binds[f->bind].directive == 0)
    {
        front_bind(f, o->binds + f->bind);
        f->bind += 1u;
    }
}

// ---------------------------------------------------------------------------------------------------------------------
// Numbers. A run of digits and letters as c_direct's fast_lex_number and fast_pp_emit_soa make it: its kind, and its
// value (a floating literal's value is not made here).

typedef struct Number Number;
struct Number
{
    uint8_t kind;
    uint64_t value;
};

static __attribute__((noinline)) Number number_slow(const uint8_t* p, uint32_t len)
{
    Number r = { .kind = K_BAD, .value = 0 };
    const bool is_hex = len >= 2u && p[0] == '0' && (p[1] | 0x20u) == 'x';
    const bool is_bin = len >= 2u && p[0] == '0' && (p[1] | 0x20u) == 'b';
    bool is_float = false;
    for (uint32_t i = (is_hex || is_bin) ? 2u : 0u; i < len; i += 1)
    {
        const uint8_t c = p[i];
        if (c == '.' || (!is_hex && (c | 0x20u) == 'e') || (is_hex && (c | 0x20u) == 'p')) { is_float = true; }
    }
    if (is_float)
    {
        const uint8_t last = p[len - 1u] | 0x20u;
        r.kind = last == 'f' ? K_FLOAT32 : last == 'l' ? K_FLOAT80 : K_FLOAT;
        return r;
    }
    uint32_t end = len;
    bool is_unsigned = false;
    uint32_t longs = 0;
    while (end > 0)
    {
        const uint8_t c = p[end - 1u] | 0x20u;
        if (c == 'u') { is_unsigned = true; end -= 1u; }
        else if (c == 'l') { longs += 1u; end -= 1u; }
        else { break; }
    }
    uint64_t value = 0;
    bool based = false;
    bool valid = true;
    if (is_hex)
    {
        based = true;
        for (uint32_t i = 2; i < end; i += 1)
        {
            const uint8_t c = p[i];
            const uint32_t d = c >= '0' && c <= '9' ? (uint32_t)(c - '0') : (c | 0x20u) >= 'a' && (c | 0x20u) <= 'f' ? (uint32_t)((c | 0x20u) - 'a' + 10) : 16u;
            valid = valid && d < 16u;
            value = (value << 4) | d;
        }
    }
    else if (is_bin)
    {
        based = true;
        for (uint32_t i = 2; i < end; i += 1) { valid = valid && (p[i] == '0' || p[i] == '1'); value = (value << 1) | (uint64_t)(p[i] - '0'); }
    }
    else if (end > 1u && p[0] == '0')
    {
        based = true;
        for (uint32_t i = 1; i < end; i += 1) { valid = valid && p[i] >= '0' && p[i] <= '7'; value = (value << 3) | (uint64_t)(p[i] - '0'); }
    }
    else
    {
        for (uint32_t i = 0; i < end; i += 1) { valid = valid && p[i] >= '0' && p[i] <= '9'; value = value * 10u + (uint64_t)(p[i] - '0'); }
    }
    if (!valid) { return r; }
    r.value = value;
    if (!is_unsigned && longs == 0 && value <= (uint64_t)INT32_MAX) { r.kind = K_INT; }
    else if (longs == 0 && (is_unsigned || based) && value <= UINT32_MAX) { r.kind = K_INT_U32; }
    else if (!is_unsigned && value <= (uint64_t)INT64_MAX) { r.kind = K_INT_I64; }
    else { r.kind = K_INT_U64; }
    return r;
}

// One to eight decimal digits with no leading zero (or a lone digit), or "0x" and one to eight hexadecimal digits:
// their value, and true. Both readings are made and one is taken: which kind a number is isn't a branch. Sixteen bytes
// are readable at `p`.
static inline __attribute__((always_inline)) bool number_fast(const uint8_t* p, uint32_t len, uint8_t* kind, uint32_t* value)
{
    uint64_t w0;
    uint64_t w1;
    memcpy(&w0, p, 8);
    memcpy(&w1, p + 8, 8);
    // Decimal: the digits left-padded with zeroes, then adjacent pairs and groups of four reduced.
    const uint32_t decimal_len = len <= 8u ? len : 8u;
    const uint64_t padded = (w0 ^ UINT64_C(0x3030303030303030)) << ((8u - decimal_len) * 8u);
    const __m128i digits = _mm_cvtsi64_si128((long long)padded);
    const __m128i pairs = _mm_maddubs_epi16(digits, _mm_set1_epi16(0x010a));
    const __m128i groups = _mm_madd_epi16(pairs, _mm_set1_epi32(0x00010064));
    const uint64_t both = (uint64_t)_mm_cvtsi128_si64(groups);
    const uint32_t decimal = (uint32_t)both * 10000u + (uint32_t)(both >> 32);
    const uint32_t decimal_ok = (uint32_t)(len <= 8u) & (uint32_t)(_mm_cmpgt_epu8_mask(digits, _mm_set1_epi8(9)) == 0) & ((uint32_t)((w0 & 0xffu) != '0') | (uint32_t)(len == 1u));
    // Hexadecimal: the digits after "0x", left-padded with zero nibbles, both letter cases.
    const uint32_t hex_len = len - 3u <= 7u ? len : 10u;
    const uint64_t text = (w0 >> 16) | (w1 << 48);
    const uint64_t raw = text << ((10u - hex_len) * 8u);
    const __m128i bytes = _mm_cvtsi64_si128((long long)raw);
    const __m128i digit = _mm_sub_epi8(bytes, _mm_set1_epi8('0'));
    const __m128i letter = _mm_sub_epi8(_mm_or_si128(bytes, _mm_set1_epi8(0x20)), _mm_set1_epi8('a'));
    const __mmask16 live = (__mmask16)((0xffu << (10u - hex_len)) & 0xffu);
    const __mmask16 alpha = _mm_cmpgt_epu8_mask(digit, _mm_set1_epi8(9)) & live;
    const __m128i nibbles = _mm_maskz_mov_epi8(live, _mm_mask_add_epi8(digit, alpha, letter, _mm_set1_epi8(10)));
    const __m128i hex_pairs = _mm_maddubs_epi16(nibbles, _mm_set1_epi16(0x0110));
    const __m128i halves = _mm_madd_epi16(hex_pairs, _mm_set1_epi32(0x00010100));
    const uint64_t hex_both = (uint64_t)_mm_cvtsi128_si64(halves);
    const uint32_t hex = ((uint32_t)hex_both << 16) | (uint32_t)(hex_both >> 32);
    const uint32_t hex_ok = (uint32_t)(len - 3u <= 7u) & (uint32_t)((w0 & 0xdfffu) == 0x5830u) & (uint32_t)(_mm_mask_cmpgt_epu8_mask(alpha, letter, _mm_set1_epi8(5)) == 0);
    *value = decimal_ok != 0 ? decimal : hex;
    *kind = (uint8_t)(((decimal_ok != 0) | (hex <= (uint32_t)INT32_MAX)) ? K_INT : K_INT_U32);
    return (decimal_ok | hex_ok) != 0;
}

// ---------------------------------------------------------------------------------------------------------------------
// A window's names and numbers, then its tokens to the stream.

// The names: each one's slot gives the token's kind and data, and its flags say where the stream's own tokens stop.
//
// The loop over a chunk's names makes no call and has no branch on a name: a name of up to 16 bytes is two masked
// words, its bucket's two slots are compared as words, and the slot that holds it gives the token's three stores. A
// name the bucket doesn't hold (its first occurrence, or a third name of a bucket) and a longer name are set aside by
// an unconditional store of their place and a conditional step, and done after the chunk by the full lookup. The
// window's arrays are one region and the table's slots a pointer of this function's own: a loop with a call in it, or
// with a store of a byte through a pointer it has to load again, keeps its state on the stack.
static __attribute__((noinline)) void front_names(Front* f)
{
    Window* const w = &f->win;
    Table* const t = &f->table;
    Slot* const slots = t->slots;
    uint8_t* const restrict region = w->kinds;
    const uint8_t* const text = f->o->src + w->base;
    const uint32_t base = (uint32_t)w->base;
    const uint32_t n = w->count;
    const __m512i v_ident = _mm512_set1_epi8(K_IDENT);
    uint64_t names = 0;
    for (uint32_t c = 0; c < n; c += 64u)
    {
        const __m512i chunk = _mm512_loadu_si512((const void*)(region + WIN_KINDS_AT + c));
        uint64_t m = _mm512_cmpeq_epi8_mask(chunk, v_ident) & _bzhi_u64(~UINT64_C(0), n - c < 64u ? n - c : 64u);
        uint32_t aside[64];
        uint32_t aside_count = 0;
        names += (uint64_t)__builtin_popcountll(m);
        // Two loops a chunk: the names' keys and buckets, each bucket's line asked for; then the compares and the
        // stores. The lines arrive while the first loop goes on with the chunk's other names: a lookup that waits for
        // its line holds its place in the reorder buffer, and only a handful fit there.
        uint64_t keys0[64];
        uint64_t keys1[64];
        const Slot* pairs[64];
        uint32_t places[64];
        uint32_t count = 0;
        while (m != 0)
        {
            const uint32_t i = c + (uint32_t)__builtin_ctzll(m);
            m &= m - 1u;
            uint16_t start;
            memcpy(&start, region + WIN_STARTS_AT + 2u * (size_t)i, 2);
            const uint32_t len = region[WIN_LENS_AT + i];
            const uint8_t* const p = text + start;
            uint64_t w0;
            uint64_t w1;
            memcpy(&w0, p, 8);
            memcpy(&w1, p + 8, 8);
            const uint64_t k0 = _bzhi_u64(w0, len * 8u);
            const uint64_t k1 = _bzhi_u64(w1, (len > 8u ? len - 8u : 0u) * 8u);
            const Slot* const pair = slots + 2u * (table_hash(k0, k1) >> (64u - TABLE_BUCKET_BITS));
            _mm_prefetch((const char*)pair, _MM_HINT_T0);
            keys0[count] = k0;
            keys1[count] = k1;
            pairs[count] = pair;
            places[count] = i;
            count += 1u;
        }
        for (uint32_t j = 0; j < count; j += 1)
        {
            const uint32_t i = places[j];
            const uint64_t k0 = keys0[j];
            const uint64_t k1 = keys1[j];
            const Slot* const pair = pairs[j];
            uint16_t start;
            memcpy(&start, region + WIN_STARTS_AT + 2u * (size_t)i, 2);
            const uint32_t len = region[WIN_LENS_AT + i];
            const uint64_t miss0 = (pair[0].k0 ^ k0) | (pair[0].k1 ^ k1);
            const uint64_t miss1 = (pair[1].k0 ^ k0) | (pair[1].k1 ^ k1);
            const Slot* const slot = pair + (miss0 != 0);
            const uint32_t missed = (uint32_t)(((miss0 | (UINT64_C(0) - miss0)) & (miss1 | (UINT64_C(0) - miss1))) >> 63);
            aside[aside_count] = i;
            aside_count += missed | (uint32_t)(len - 1u >= 16u);
            const uint32_t data = slot->data | (slot->placed & (PLACED_MAIN | (base + start)));
            region[WIN_KINDS_AT + i] = slot->kind;
            memcpy(region + WIN_DATA_AT + 4u * (size_t)i, &data, 4);
            region[WIN_FLAGS_AT + i] = slot->flags & SLOT_EVENT;
        }
        for (uint32_t a = 0; a < aside_count; a += 1)
        {
            const uint32_t i = aside[a];
            const uint32_t start = w->starts[i];
            const uint8_t* const p = text + start;
            uint32_t len = w->lens[i];
            if (len == 0) { len = 255u; while (ref_is_ident(p[len])) { len += 1u; } }
            const Slot* const slot = table_find(t, p, len);
            w->kinds[i] = slot->kind;
            w->data[i] = slot->data | (slot->placed & (PLACED_MAIN | (base + start)));
            w->flags[i] = slot->flags & SLOT_EVENT;
        }
    }
    f->names += names;
}

// The numbers' values, and the tokens the scalar lexer takes: the ones the block lexer marked, and a number that goes
// on past its run.
static __attribute__((noinline)) void front_numbers(Front* f)
{
    Window* const w = &f->win;
    uint8_t* const restrict kinds = w->kinds;
    uint8_t* const restrict flags = w->flags;
    uint32_t* const restrict data = w->data;
    const uint8_t* const restrict lens = w->lens;
    const uint16_t* const restrict starts = w->starts;
    const uint8_t* const text = f->o->src + w->base;
    const uint32_t n = w->count;
    const __m512i v_number = _mm512_set1_epi8(K_INT);
    uint64_t numbers = 0;
    for (uint32_t c = 0; c < n; c += 64u)
    {
        const __m512i chunk = _mm512_loadu_si512((const void*)(kinds + c));
        const uint64_t live = _bzhi_u64(~UINT64_C(0), n - c < 64u ? n - c : 64u);
        uint64_t m = _mm512_cmpeq_epi8_mask(chunk, v_number) & live;
        uint64_t scalars = _mm512_testn_epi8_mask(chunk, chunk) & live;
        _mm512_storeu_si512((void*)(flags + c), _mm512_setzero_si512());
        numbers += (uint64_t)__builtin_popcountll(m);
        while (m != 0)
        {
            const uint32_t i = c + (uint32_t)__builtin_ctzll(m);
            m &= m - 1u;
            const uint8_t* const p = text + starts[i];
            const uint32_t len = lens[i];
            const uint8_t after = p[len];
            const uint8_t last = p[len - 1u] | 0x20u;
            uint8_t kind = K_INT;
            uint32_t value = 0;
            if (__builtin_expect(len == 0 || after == '.' || ((after == '+' || after == '-') && (last == 'e' || last == 'p')), 0))
            {
                flags[i] = WF_SLOW;
            }
            else if (__builtin_expect(number_fast(p, len, &kind, &value), 1))
            {
                kinds[i] = kind;
                data[i] = value;
            }
            else
            {
                flags[i] = WF_SLOW;
            }
        }
        while (scalars != 0)
        {
            flags[c + (uint32_t)__builtin_ctzll(scalars)] = WF_SLOW;
            scalars &= scalars - 1u;
        }
    }
    f->numbers += numbers;
}

// The window's tokens [t0, t1) to the stream.
static inline void front_copy(Front* f, uint32_t t0, uint32_t t1)
{
    const Window* const w = &f->win;
    uint8_t* const out_kind = f->out_kind + f->out_count;
    uint32_t* const out_data = f->out_data + f->out_count;
    const uint32_t count = t1 - t0;
    // Sixty-four tokens whatever the count (what is past it is written again by what follows), and only a longer run
    // loops: most runs are shorter, and a loop by their length is a mispredicted branch each.
    const uint8_t* const kinds = w->kinds + t0;
    const uint32_t* const data = w->data + t0;
    _mm512_storeu_si512((void*)out_kind, _mm512_loadu_si512((const void*)kinds));
    _mm512_storeu_si512((void*)out_data, _mm512_loadu_si512((const void*)data));
    _mm512_storeu_si512((void*)(out_data + 16), _mm512_loadu_si512((const void*)(data + 16)));
    _mm512_storeu_si512((void*)(out_data + 32), _mm512_loadu_si512((const void*)(data + 32)));
    _mm512_storeu_si512((void*)(out_data + 48), _mm512_loadu_si512((const void*)(data + 48)));
    if (__builtin_expect(count > 64u, 0))
    {
        for (uint32_t i = 64; i < count; i += 64u)
        {
            _mm512_storeu_si512((void*)(out_kind + i), _mm512_loadu_si512((const void*)(kinds + i)));
            _mm512_storeu_si512((void*)(out_data + i), _mm512_loadu_si512((const void*)(data + i)));
            _mm512_storeu_si512((void*)(out_data + i + 16), _mm512_loadu_si512((const void*)(data + i + 16)));
            _mm512_storeu_si512((void*)(out_data + i + 32), _mm512_loadu_si512((const void*)(data + i + 32)));
            _mm512_storeu_si512((void*)(out_data + i + 48), _mm512_loadu_si512((const void*)(data + i + 48)));
        }
    }
    f->out_count += count;
}

static __attribute__((noinline, cold)) void front_fail(Front* f, const char* what, uint64_t at)
{
    if (f->failure == NULL)
    {
        f->failure = what;
        f->failure_at = at;
    }
}

// The oracle's event that stops the text at `at`: its tokens to the stream, its bindings to the table. Returns where
// the text goes on (UINT64_MAX where the oracle has no event there).
static __attribute__((noinline)) uint64_t front_event(Front* f, uint64_t at, bool* bound)
{
    const Oracle* const o = f->o;
    while (f->event < o->event_count && o->events[f->event].resume <= at)
    {
        // An event the text's own tokens passed: it made no token and no binding (an empty macro's name).
        const OracleEvent* const passed = o->events + f->event;
        if (passed->out_end != passed->out_begin || passed->bind_end != passed->bind_begin) { front_fail(f, "passed an event that made tokens or bindings", passed->stop); }
        f->events_passed += 1u;
        f->event += 1u;
    }
    // (The event may start before `at`: with names that went without a token, an empty macro's.)
    if (f->event >= o->event_count || o->events[f->event].stop > at)
    {
        front_fail(f, "stopped where the recording has no event", at);
        return UINT64_MAX;
    }
    const OracleEvent* const e = o->events + f->event;
    f->event += 1u;
    f->events_used += 1u;
    const uint32_t count = e->out_end - e->out_begin;
    if (__builtin_expect(count <= 16u, 1))
    {
        _mm_storeu_si128((__m128i*)(void*)(f->out_kind + f->out_count), _mm_loadu_si128((const __m128i*)(const void*)(o->kinds + e->out_begin)));
        _mm512_storeu_si512((void*)(f->out_data + f->out_count), _mm512_loadu_si512((const void*)(o->data + e->out_begin)));
    }
    else
    {
        memcpy(f->out_kind + f->out_count, o->kinds + e->out_begin, count);
        memcpy(f->out_data + f->out_count, o->data + e->out_begin, (size_t)count * 4u);
    }
    f->out_count += count;
    f->replayed += count;
    *bound = e->bind_end != e->bind_begin;
    for (uint32_t b = e->bind_begin; b < e->bind_end; b += 1)
    {
        front_bind(f, o->binds + b);
        f->binds_applied += 1u;
    }
    return e->resume;
}

// One token by the scalar lexer at the window's token `t`, to the stream. Returns the text offset after it (the
// window's tokens that start before it are its bytes), or UINT64_MAX for a failure.
static __attribute__((noinline)) uint64_t front_slow_token(Front* f, uint32_t t)
{
    const Oracle* const o = f->o;
    const Window* const w = &f->win;
    const uint64_t at = w->base + w->starts[t];
    const uint8_t c = o->src[at];
    f->slow_tokens += 1u;
    if (c == '\\' && o->src[at + 1u] == '\n')
    {
        // A line splice between tokens: a blank.
        return at + 2u;
    }
    RefTok tok = ref_lex(o->src, o->src_size, at);
    uint8_t kind = (uint8_t)tok.kind;
    uint32_t data = 0;
    if (tok.kind == K_INT || tok.kind == K_FLOAT)
    {
        const Number number = number_slow(o->src + at, tok.end - tok.start);
        f->numbers_slow += 1u;
        kind = number.kind;
        data = (uint32_t)number.value;
        if (kind == K_INT_I64 || kind == K_INT_U64)
        {
            // The pool's index is the recording's: the value is checked against the pool's.
            const uint32_t index = o->data[f->out_count];
            if (index >= o->num_count || o->nums[index] != number.value) { front_fail(f, "a 64-bit literal's value differs", at); }
            data = index;
        }
    }
    else if (tok.kind == K_BAD || tok.kind == K_IDENT)
    {
        front_fail(f, "a token the prototype doesn't lex", at);
        return UINT64_MAX;
    }
    f->out_kind[f->out_count] = kind;
    f->out_data[f->out_count] = data;
    f->out_count += 1u;
    return tok.end;
}

// The first of the window's tokens from `t` on that starts at or after the text offset `at`.
static inline uint32_t front_seek(const Window* w, uint32_t t, uint64_t at)
{
    const uint64_t relative = at - w->base;
    // Thirty-two starts a compare: the tokens a macro's call passes are a handful.
    const __m512i v_relative = _mm512_set1_epi16((short)relative);
    uint32_t found = w->count;
    while (t < w->count && found == w->count)
    {
        const uint32_t m = _mm512_cmpge_epu16_mask(_mm512_loadu_si512((const void*)(w->starts + t)), v_relative);
        if (m != 0) { found = t + (uint32_t)__builtin_ctz(m); }
        t += 32u;
    }
    return found < w->count ? found : w->count;
}

// The window's tokens to the stream, from its first one: runs of plain tokens in bulk, and what a flagged token asks
// for. Returns where the text goes on.
static __attribute__((noinline)) uint64_t front_emit(Front* f)
{
    Window* const w = &f->win;
    const Oracle* const o = f->o;
    const uint32_t n = w->count;
    uint32_t t = 0;
    uint64_t next = w->end;
    while (t < n)
    {
        // The next flagged token.
        uint32_t flagged = n;
        for (uint32_t c = t & ~UINT32_C(63); c < n && flagged == n; c += 64u)
        {
            uint64_t m = _mm512_test_epi8_mask(_mm512_loadu_si512((const void*)(w->flags + c)), _mm512_loadu_si512((const void*)(w->flags + c)));
            m &= _bzhi_u64(~UINT64_C(0), n - c < 64u ? n - c : 64u);
            if (c < t) { m &= ~UINT64_C(0) << (t - c); }
            if (m != 0) { flagged = c + (uint32_t)__builtin_ctzll(m); }
        }
        front_copy(f, t, flagged);
        if (flagged == n) { break; }
        const uint32_t flags = w->flags[flagged];
        const uint64_t at = w->base + w->starts[flagged];
        t = flagged + 1u;
        if ((flags & SLOT_DELETE) != 0)
        {
            f->deleted_names += 1u;
            continue;
        }
        if ((flags & (SLOT_DELETE_IF_PAREN | SLOT_FUNC)) != 0)
        {
            // A function-like macro's name is one only where its '(' follows: the window's next token, or the text's
            // next one past the window. Without it the name is an identifier, the stream's own token.
            bool paren;
            if (t < n) { paren = w->kinds[t] == K_LPAREN; }
            else
            {
                uint64_t q = at + w->lens[flagged];
                while (q < o->src_size && oracle_gap_byte(o, q)) { q += 1u; }
                paren = o->src[q] == '(';
            }
            if (!paren)
            {
                w->flags[flagged] = 0;
                t = flagged;
                f->plain_function_names += 1u;
                continue;
            }
            if ((flags & SLOT_DELETE_IF_PAREN) != 0)
            {
                // An identity macro: the name goes, and its `(x)` is the window's next tokens.
                f->deleted_names += 1u;
                continue;
            }
        }
        else if ((flags & SLOT_CHECK) != 0)
        {
            // A one-token macro whose token is a name: its own token unless that name is a macro's now.
            const Slot* const slot = table_find(&f->table, o->src + at, w->lens[flagged]);
            const Slot* const replacement = table_slot_at(&f->table, f->table.replacement[slot->id]);
            f->checked_names += 1u;
            if ((replacement->flags & SLOT_MACRO) == 0 && replacement->placed == 0)
            {
                w->flags[flagged] = 0;
                t = flagged;
                continue;
            }
        }
        else if ((flags & WF_SLOW) != 0)
        {
            const uint64_t after = front_slow_token(f, flagged);
            if (after == UINT64_MAX) { return UINT64_MAX; }
            if (after >= w->end) { next = after; t = n; break; }
            t = front_seek(w, t, after);
            continue;
        }
        // The stream's own tokens stop here.
        bool bound = false;
        const uint64_t resume = front_event(f, at, &bound);
        if (resume == UINT64_MAX) { return UINT64_MAX; }
        if (bound || resume >= w->end)
        {
            next = resume;
            t = n;
            break;
        }
        f->resumed_in_window += 1u;
        t = front_seek(w, t, resume);
    }
    return next;
}

// The whole text: pass A, then windows from event to event.
static __attribute__((noinline)) bool front_run(Front* f)
{
    const Oracle* const o = f->o;
    const uint8_t* const s = o->src;
    const uint64_t size = o->src_size;
    f->out_count = 0;
    f->event = 0;
    f->failure = NULL;
    scan_text(s, size, &f->scan);
    const uint32_t* const directives = f->scan.directives;
    const uint32_t directive_count = f->scan.directive_count;
    uint32_t d = 0;
    uint64_t at = 0;
    while (at < size && f->failure == NULL)
    {
        // The text up to the next directive line is one run of windows.
        while (d < directive_count && directives[d] < at) { d += 1u; }
        const uint64_t limit = d < directive_count ? directives[d] : size;
        if (at < limit)
        {
            lex_window(s, f->scan.masks, at, limit, &f->win);
            f->windows += 1u;
            f->window_tokens += f->win.count;
            if (f->win.count == 0 && f->win.end == at && limit - at >= 64u)
            {
                front_fail(f, "a token longer than a window", at);
                break;
            }
            // The numbers first: a name's slot may make its token a number's (a one-token macro's body).
            front_numbers(f);
            front_names(f);
            at = front_emit(f);
        }
        else
        {
            // The directive line: the recording's event.
            bool bound = false;
            at = front_event(f, limit, &bound);
        }
    }
    // Events after the last of the text's tokens that made nothing are passed; one that made tokens ends the stream.
    if (f->failure == NULL && f->event < o->event_count)
    {
        bool bound = false;
        const OracleEvent* const e = o->events + f->event;
        if (e->out_end != e->out_begin || e->bind_end != e->bind_begin) { (void)front_event(f, e->stop, &bound); }
    }
    return f->failure == NULL;
}

// ---------------------------------------------------------------------------------------------------------------------
// The check against the recording, and the driver.

static bool front_check(const Front* f, Table* names)
{
    const Oracle* const o = f->o;
    if (f->out_count != o->count)
    {
        fprintf(stderr, "check: %u tokens, the recording has %u\n", f->out_count, o->count);
    }
    const uint32_t n = f->out_count < o->count ? f->out_count : o->count;
    uint32_t* map = (uint32_t*)calloc((size_t)o->ident_count + 2u, 4);
    uint64_t kinds_differ = 0, names_differ = 0, values_differ = 0, unchecked = 0, checked_names = 0, checked_values = 0;
    for (uint32_t i = 0; i < n; i += 1)
    {
        const uint8_t k = o->kinds[i];
        if (f->out_kind[i] != k)
        {
            if (kinds_differ < 8) { fprintf(stderr, "check: token %u: kind %u, the recording's %u (text offset %u)\n", i, (unsigned)f->out_kind[i], (unsigned)k, o->tok_start[i]); }
            kinds_differ += 1u;
            continue;
        }
        if (o->prov[i] == PROV_NONE) { continue; }
        const uint32_t mine = f->out_data[i];
        const uint32_t theirs = o->data[i];
        if (k == K_IDENT || (k >= 64u && k <= 121u))
        {
            if ((theirs & UINT32_C(0x80000000)) != 0)
            {
                // A `for` or `while`: its place.
                checked_values += 1u;
                if (mine != theirs) { values_differ += 1u; if (values_differ < 8) { fprintf(stderr, "check: token %u: place %x, the recording's %x\n", i, mine, theirs); } }
                continue;
            }
            if (theirs == 0 || theirs > o->ident_count) { unchecked += 1u; continue; }
            if (map[theirs] == 0) { map[theirs] = table_name(names, o->text + o->idents[theirs].name, o->idents[theirs].length)->id; }
            checked_names += 1u;
            if (map[theirs] != mine)
            {
                if (names_differ < 8) { fprintf(stderr, "check: token %u: name %u, the recording's %.*s is %u\n", i, mine, (int)o->idents[theirs].length, o->text + o->idents[theirs].name, map[theirs]); }
                names_differ += 1u;
            }
        }
        else if (k == K_INT || k == K_INT_U32 || k == K_INT_I64 || k == K_INT_U64)
        {
            checked_values += 1u;
            if (mine != theirs) { values_differ += 1u; if (values_differ < 8) { fprintf(stderr, "check: token %u: value %u, the recording's %u (text offset %u)\n", i, mine, theirs, o->tok_start[i]); } }
        }
        else if (k == K_CHAR || k == K_STR || k == K_FLOAT || k == K_FLOAT32 || k == K_FLOAT80)
        {
            unchecked += 1u;
        }
    }
    free(map);
    printf("check: %u tokens; kinds differ %llu; names checked %llu, differ %llu; values checked %llu, differ %llu; literals' data not made here %llu\n", n,
           (unsigned long long)kinds_differ, (unsigned long long)checked_names, (unsigned long long)names_differ, (unsigned long long)checked_values,
           (unsigned long long)values_differ, (unsigned long long)unchecked);
    return f->out_count == o->count && kinds_differ == 0 && names_differ == 0 && values_differ == 0;
}

static int counter_open(uint32_t type, uint64_t config)
{
    struct perf_event_attr attr;
    memset(&attr, 0, sizeof(attr));
    attr.type = type;
    attr.size = sizeof(attr);
    attr.config = config;
    attr.exclude_kernel = 1;
    attr.exclude_hv = 1;
    return (int)syscall(SYS_perf_event_open, &attr, 0, -1, -1, 0);
}

static uint64_t counter_read(int fd)
{
    uint64_t value = 0;
    if (fd >= 0 && read(fd, &value, sizeof(value)) != (ssize_t)sizeof(value)) { value = 0; }
    return value;
}

static int compare_u64(const void* a, const void* b)
{
    const uint64_t x = *(const uint64_t*)a;
    const uint64_t y = *(const uint64_t*)b;
    return x < y ? -1 : x > y;
}

int main(int argc, char** argv)
{
    if (argc < 3) { fprintf(stderr, "usage: front DUMP SOURCE [ROUNDS]\n"); return 2; }
    static Oracle o;
    if (!oracle_load(&o, argv[1], argv[2])) { fprintf(stderr, "front: the recording doesn't fit the source\n"); return 1; }
    const uint32_t rounds = argc >= 4 ? (uint32_t)atoi(argv[3]) : 1u;
    static Front f;
    f.o = &o;
    table_init(&f.table);
    const uint64_t blocks = (o.src_size + 63u) / 64u;
    f.scan.masks = (uint64_t*)aligned_alloc(64, (2u * blocks + 16u) * 8u);
    memset(f.scan.masks, 0, (2u * blocks + 16u) * 8u);
    f.scan.directives = (uint32_t*)calloc(o.src_size / 2u + 16u, 4);
    uint8_t* const region = (uint8_t*)aligned_alloc(64, WIN_REGION_BYTES);
    memset(region, 0, WIN_REGION_BYTES);
    f.win.kinds = region + WIN_KINDS_AT;
    f.win.lens = region + WIN_LENS_AT;
    f.win.flags = region + WIN_FLAGS_AT;
    f.win.starts = (uint16_t*)(void*)(region + WIN_STARTS_AT);
    f.win.data = (uint32_t*)(void*)(region + WIN_DATA_AT);
    f.out_cap = o.count + 4096u;
    f.out_kind = (uint8_t*)aligned_alloc(64, ((size_t)f.out_cap + 127u) & ~(size_t)63u);
    f.out_data = (uint32_t*)aligned_alloc(64, (((size_t)f.out_cap + 64u) * 4u + 63u) & ~(size_t)63u);

    const int fd_cycles = counter_open(PERF_TYPE_HARDWARE, PERF_COUNT_HW_CPU_CYCLES);
    const int fd_instructions = counter_open(PERF_TYPE_HARDWARE, PERF_COUNT_HW_INSTRUCTIONS);
    const int fd_misses = counter_open(PERF_TYPE_HARDWARE, PERF_COUNT_HW_BRANCH_MISSES);
    uint64_t* cycles = (uint64_t*)calloc(rounds, 8);
    uint64_t* instructions = (uint64_t*)calloc(rounds, 8);
    uint64_t* misses = (uint64_t*)calloc(rounds, 8);
    uint64_t* ticks = (uint64_t*)calloc(rounds, 8);
    uint64_t* scan_ticks = (uint64_t*)calloc(rounds, 8);
    uint64_t* scan_cycles = (uint64_t*)calloc(rounds, 8);
    bool ok = true;
    for (uint32_t r = 0; r < rounds && ok; r += 1)
    {
        // The table as the compile has it when the main file starts (the predefines' and the command line's macros).
        front_table_setup(&f);
        f.windows = f.window_tokens = f.names = f.long_names = f.numbers = f.numbers_slow = f.slow_tokens = f.deleted_names = f.checked_names = f.plain_function_names = 0;
        f.events_used = f.events_passed = f.replayed = f.resumed_in_window = f.binds_applied = 0;
        // Pass A alone, for its share.
        const uint64_t s0 = __rdtsc();
        const uint64_t sc0 = counter_read(fd_cycles);
        scan_text(o.src, o.src_size, &f.scan);
        const uint64_t sc1 = counter_read(fd_cycles);
        const uint64_t s1 = __rdtsc();
        scan_ticks[r] = s1 - s0;
        scan_cycles[r] = sc1 - sc0;
        const uint64_t c0 = counter_read(fd_cycles);
        const uint64_t i0 = counter_read(fd_instructions);
        const uint64_t m0 = counter_read(fd_misses);
        const uint64_t t0 = __rdtsc();
        ok = front_run(&f);
        const uint64_t t1 = __rdtsc();
        const uint64_t c1 = counter_read(fd_cycles);
        const uint64_t i1 = counter_read(fd_instructions);
        const uint64_t m1 = counter_read(fd_misses);
        ticks[r] = t1 - t0;
        cycles[r] = c1 - c0;
        instructions[r] = i1 - i0;
        misses[r] = m1 - m0;
    }
    if (!ok)
    {
        fprintf(stderr, "front: %s at text offset %llu (stream token %u): %.60s\n", f.failure, (unsigned long long)f.failure_at, f.out_count, o.src + f.failure_at);
    }
    printf("source %zu bytes, %u stream tokens, %u events in the recording\n", o.src_size, o.count, o.event_count);
    printf("pass A: %llu blocks, %llu with rare bytes, %llu by the scalar machine, %u directive lines\n", (unsigned long long)f.scan.blocks,
           (unsigned long long)f.scan.rare_blocks, (unsigned long long)f.scan.slow_blocks, f.scan.directive_count);
    printf("pass B: %llu windows, %llu raw tokens, %llu names (%llu long, %llu past their bucket or new, %u distinct), %llu numbers (%llu by the scalar path), %llu scalar tokens\n",
           (unsigned long long)f.windows, (unsigned long long)f.window_tokens, (unsigned long long)f.names, (unsigned long long)f.long_names,
           (unsigned long long)f.table.misses, f.table.count, (unsigned long long)f.numbers, (unsigned long long)f.numbers_slow, (unsigned long long)f.slow_tokens);
    printf("events: %llu taken from the recording (%llu tokens, %llu bindings), %llu passed in the text's own tokens, %llu resumed inside their window; %llu names deleted, %llu checked\n",
           (unsigned long long)f.events_used, (unsigned long long)f.replayed, (unsigned long long)f.binds_applied, (unsigned long long)f.events_passed,
           (unsigned long long)f.resumed_in_window, (unsigned long long)f.deleted_names, (unsigned long long)f.checked_names);
    static Table names;
    names = f.table;
    const bool same = ok && front_check(&f, &names);
    qsort(ticks, rounds, 8, compare_u64);
    qsort(cycles, rounds, 8, compare_u64);
    qsort(instructions, rounds, 8, compare_u64);
    qsort(misses, rounds, 8, compare_u64);
    qsort(scan_ticks, rounds, 8, compare_u64);
    qsort(scan_cycles, rounds, 8, compare_u64);
    const uint32_t mid = rounds / 2u;
    printf("rounds %u: the whole front (pass A, pass B, the events' replay), medians: %llu TSC ticks (%.3f a byte), %llu cycles (%.3f a byte), %llu instructions, %llu mispredicted branches\n",
           rounds, (unsigned long long)ticks[mid], (double)ticks[mid] / (double)o.src_size, (unsigned long long)cycles[mid], (double)cycles[mid] / (double)o.src_size,
           (unsigned long long)instructions[mid], (unsigned long long)misses[mid]);
    printf("pass A alone, medians: %llu TSC ticks, %llu cycles\n", (unsigned long long)scan_ticks[mid], (unsigned long long)scan_cycles[mid]);
    printf("%s\n", same ? "SAME as the recording" : "DIFFERS from the recording");
    return same ? 0 : 1;
}
