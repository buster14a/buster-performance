// The front prototype on several cores (buster#2850's direct path, redesigned): front.c's work, the main file's text to
// the direct path's token stream, split so that lanes do it at once, and checked token for token against the same
// recording of c_direct's own compile.
//
// What is ordered, and what is not:
//   - Pass A (scan.h) runs on chunks of the text at once. A chunk that is not the first guesses the state the bytes
//     before it leave (scan_entry_guess); the join compares each guess with what the chunk before really left, scans
//     again where they differ, and decides the one '#' a chunk could not (its line starts in another chunk).
//   - The directives' and the macros' own work is the recording's here, as in front.c: an event's tokens are copied
//     from it. What a design has to keep in order (the directive spine) is not timed by this prototype; its bindings
//     are (they are made by one lane, before the lanes that read them start).
//   - The text between directive lines is cut into tasks at directive lines. A task's lane lexes its windows from the
//     masks, looks its names up in one shared table at the task's version (table_v.h), converts its numbers, and
//     writes its tokens to its own arena. A name's first occurrence makes its slot by a compare-and-exchange.
//   - The join gives each task its place in the stream by a prefix sum of the tasks' counts, and the lanes copy.
#define _GNU_SOURCE
#include "oracle.h"
#include "scan.h"
#include "lex.h"
#include "table_v.h"
#include <pthread.h>
#include <sched.h>
#include <time.h>
#include <x86intrin.h>

#define WF_SLOW 0x10u   // a window token for the scalar lexer, beside a slot's SLOT_EVENT flags

typedef struct Task Task;
struct Task
{
    uint64_t begin;          // the text it reads: [begin, end)
    uint64_t end;
    uint32_t event_begin;    // the recording's events it takes: [event_begin, event_end)
    uint32_t event_end;
    uint32_t lane;           // whose arena has its tokens
    uint32_t offset;
    uint32_t count;
    uint32_t final;          // their place in the stream
};

typedef struct Par Par;

typedef struct Lane Lane;
struct Lane
{
    Par* par;
    uint32_t index;
    Window win;
    uint8_t* out_kind;       // the lane's arena
    uint32_t* out_data;
    uint32_t out_count;
    uint32_t task_out;       // out_count at its task's start
    uint32_t out_base;       // the stream's index of its task's first token (the recording's, for its pools' indexes)
    uint32_t event;          // the next of the recording's events
    uint32_t version;        // the bindings made before the text it reads
    uint64_t windows;
    uint64_t window_tokens;
    uint64_t names;
    uint64_t listed_names;
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
    uint64_t tasks;
    uint64_t ticks[4];       // its work in each phase
    const char* failure;
    uint64_t failure_at;
    pthread_t thread;
    int cpu;
} __attribute__((aligned(64)));

struct Par
{
    const Oracle* o;
    Table table;
    Scan scan;               // the joined masks and directive lines
    ScanChunk* chunks;
    uint32_t chunk_count;
    Task* tasks;
    uint32_t task_count;
    uint32_t task_cap;
    uint32_t tasks_wanted;
    Lane* lanes;
    uint32_t lane_count;
    uint8_t* out_kind;       // the stream
    uint32_t* out_data;
    uint32_t out_count;
    uint32_t first_main_bind;
    uint32_t rescans;
    uint32_t pending_directives;
    bool warm;
    _Alignas(64) uint32_t phase;
    _Alignas(64) uint32_t next_chunk;
    _Alignas(64) uint32_t next_task;
    _Alignas(64) uint32_t next_copy;
    _Alignas(64) uint32_t done[4];
    _Alignas(64) uint32_t generation;
    _Alignas(64) uint32_t quit;
};

// ---------------------------------------------------------------------------------------------------------------------
// The names' table from the oracle: keywords, the built-in macros, and the bindings by their numbers.

static void par_bind(Par* p, uint32_t number)
{
    const Oracle* const o = p->o;
    Table* const t = &p->table;
    const OracleBind* const b = o->binds + number;
    Slot* const slot = table_name(t, o->text + b->name, b->name_length);
    SlotView view = slot_base_view(slot);
    if (b->undef == 0)
    {
        view.flags = SLOT_MACRO;
        const uint32_t k = b->kind;
        if (b->mode == 1u && (k == K_IDENT || (k >= 64u && k <= 121u)))
        {
            const Slot* const replacement = table_name(t, o->text + b->replacement, b->replacement_length);
            view.kind = (uint8_t)k;
            view.data = replacement->id;
            view.placed = 0;
            if (k == K_IDENT) { view.flags |= SLOT_CHECK; }
            view.replacement = table_slot_reference(t, replacement);
        }
        else if (b->mode == 1u)
        {
            // Any other one-token body, in place too: a number, a punctuator, a literal (its data is the recording's
            // pool index).
            view.kind = (uint8_t)k;
            view.data = b->data;
            view.placed = 0;
        }
        else if (b->mode == 4u) { view.flags |= SLOT_DELETE; }
        else if (b->mode == 5u) { view.flags |= SLOT_DELETE_IF_PAREN; }
        else { view.flags |= SLOT_STOP | (b->is_func != 0 ? SLOT_FUNC : 0u); }
    }
    table_bind(t, slot, number, view);
}

// The table as the compile has it when the main file starts (the predefines' and the command line's macros).
static void par_table_setup(Par* p)
{
    const Oracle* const o = p->o;
    table_reset(&p->table);
    for (uint32_t id = 1; id <= o->ident_count; id += 1)
    {
        const OracleIdent* const e = o->idents + id;
        const bool builtin = e->pp_kw != 0 && e->macro_bit != 0;
        if (e->kw_kind == 0 && !builtin) { continue; }
        table_set_base(&p->table, o->text + e->name, e->length, e->kw_kind, e->kw_kind == K_KW_FOR || e->kw_kind == K_KW_WHILE, builtin);
    }
    uint32_t b = 0;
    while (b < o->bind_count && o->binds[b].directive == 0)
    {
        par_bind(p, b);
        b += 1u;
    }
    p->first_main_bind = b;
}

// ---------------------------------------------------------------------------------------------------------------------
// Numbers (front.c's).

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

static inline __attribute__((always_inline)) bool number_fast(const uint8_t* p, uint32_t len, uint8_t* kind, uint32_t* value)
{
    uint64_t w0;
    uint64_t w1;
    memcpy(&w0, p, 8);
    memcpy(&w1, p + 8, 8);
    const uint32_t decimal_len = len <= 8u ? len : 8u;
    const uint64_t padded = (w0 ^ UINT64_C(0x3030303030303030)) << ((8u - decimal_len) * 8u);
    const __m128i digits = _mm_cvtsi64_si128((long long)padded);
    const __m128i pairs = _mm_maddubs_epi16(digits, _mm_set1_epi16(0x010a));
    const __m128i groups = _mm_madd_epi16(pairs, _mm_set1_epi32(0x00010064));
    const uint64_t both = (uint64_t)_mm_cvtsi128_si64(groups);
    const uint32_t decimal = (uint32_t)both * 10000u + (uint32_t)(both >> 32);
    const uint32_t decimal_ok = (uint32_t)(len <= 8u) & (uint32_t)(_mm_cmpgt_epu8_mask(digits, _mm_set1_epi8(9)) == 0) & ((uint32_t)((w0 & 0xffu) != '0') | (uint32_t)(len == 1u));
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
// A window's names and numbers, then its tokens to the lane's arena.

// front.c's names, at the lane's version: a slot gives the token what its name is without a binding or with its first
// one, by a compare of the version with the binding's; a name bound more than once is set aside with the misses.
static __attribute__((noinline)) void lane_names(Lane* l)
{
    Window* const w = &l->win;
    Table* const t = &l->par->table;
    Slot* const slots = t->slots;
    uint8_t* const restrict region = w->kinds;
    const uint8_t* const text = l->par->o->src + w->base;
    const uint32_t base = (uint32_t)w->base;
    const uint32_t n = w->count;
    const uint32_t version = l->version;
    const __m512i v_ident = _mm512_set1_epi8(K_IDENT);
    uint64_t names = 0;
    uint64_t listed = 0;
    for (uint32_t c = 0; c < n; c += 64u)
    {
        const __m512i chunk = _mm512_loadu_si512((const void*)(region + WIN_KINDS_AT + c));
        uint64_t m = _mm512_cmpeq_epi8_mask(chunk, v_ident) & _bzhi_u64(~UINT64_C(0), n - c < 64u ? n - c : 64u);
        uint32_t aside[64];
        uint32_t aside_count = 0;
        names += (uint64_t)__builtin_popcountll(m);
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
            const uint32_t bits = slot->bits;
            aside[aside_count] = i;
            aside_count += missed | (uint32_t)(len - 1u >= 16u) | (bits >> 7);
            // Without a binding or with the first one, by the version: a select of two words, no branch.
            const uint32_t active = (uint32_t)(version >= slot->from);
            const uint32_t on = 0u - active;
            const uint32_t placed = 0u - ((bits >> active) & 1u);
            const uint32_t plain = (slot->data & on) | (slot->id & ~on);
            const uint32_t data = (plain & ~placed) | ((PLACED_MAIN | (base + start)) & placed);
            region[WIN_KINDS_AT + i] = (uint8_t)((slot->kind & on) | (slot->base_kind & ~on));
            memcpy(region + WIN_DATA_AT + 4u * (size_t)i, &data, 4);
            region[WIN_FLAGS_AT + i] = (uint8_t)(slot->flags & on & SLOT_EVENT);
        }
        for (uint32_t a = 0; a < aside_count; a += 1)
        {
            const uint32_t i = aside[a];
            const uint32_t start = w->starts[i];
            const uint8_t* const p = text + start;
            uint32_t len = w->lens[i];
            if (len == 0) { len = 255u; while (ref_is_ident(p[len])) { len += 1u; } }
            const Slot* const slot = table_find(t, p, len);
            const SlotView view = slot_view(t, slot, version);
            listed += (slot->bits >> 7) & 1u;
            w->kinds[i] = view.kind;
            w->data[i] = view.placed != 0 ? (PLACED_MAIN | (base + start)) : view.data;
            w->flags[i] = view.flags & SLOT_EVENT;
        }
    }
    l->names += names;
    l->listed_names += listed;
}

static __attribute__((noinline)) void lane_numbers(Lane* l)
{
    Window* const w = &l->win;
    uint8_t* const restrict kinds = w->kinds;
    uint8_t* const restrict flags = w->flags;
    uint32_t* const restrict data = w->data;
    const uint8_t* const restrict lens = w->lens;
    const uint16_t* const restrict starts = w->starts;
    const uint8_t* const text = l->par->o->src + w->base;
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
    l->numbers += numbers;
}

static inline void lane_copy(Lane* l, uint32_t t0, uint32_t t1)
{
    const Window* const w = &l->win;
    uint8_t* const out_kind = l->out_kind + l->out_count;
    uint32_t* const out_data = l->out_data + l->out_count;
    const uint32_t count = t1 - t0;
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
    l->out_count += count;
}

static __attribute__((noinline, cold)) void lane_fail(Lane* l, const char* what, uint64_t at)
{
    if (l->failure == NULL)
    {
        l->failure = what;
        l->failure_at = at;
    }
}

// The recording's event that stops the text at `at`: its tokens to the arena, and the lane's version after its
// bindings. Returns where the text goes on.
static __attribute__((noinline)) uint64_t lane_event(Lane* l, uint64_t at, bool* bound)
{
    const Oracle* const o = l->par->o;
    while (l->event < o->event_count && o->events[l->event].resume <= at)
    {
        const OracleEvent* const passed = o->events + l->event;
        if (passed->out_end != passed->out_begin || passed->bind_end != passed->bind_begin) { lane_fail(l, "passed an event that made tokens or bindings", passed->stop); }
        l->events_passed += 1u;
        l->event += 1u;
    }
    if (l->event >= o->event_count || o->events[l->event].stop > at)
    {
        lane_fail(l, "stopped where the recording has no event", at);
        return UINT64_MAX;
    }
    const OracleEvent* const e = o->events + l->event;
    l->event += 1u;
    l->events_used += 1u;
    const uint32_t count = e->out_end - e->out_begin;
    if (__builtin_expect(count <= 16u, 1))
    {
        _mm_storeu_si128((__m128i*)(void*)(l->out_kind + l->out_count), _mm_loadu_si128((const __m128i*)(const void*)(o->kinds + e->out_begin)));
        _mm512_storeu_si512((void*)(l->out_data + l->out_count), _mm512_loadu_si512((const void*)(o->data + e->out_begin)));
    }
    else
    {
        memcpy(l->out_kind + l->out_count, o->kinds + e->out_begin, count);
        memcpy(l->out_data + l->out_count, o->data + e->out_begin, (size_t)count * 4u);
    }
    l->out_count += count;
    l->replayed += count;
    *bound = e->bind_end != e->bind_begin;
    l->version = e->bind_end;
    return e->resume;
}

static __attribute__((noinline)) uint64_t lane_slow_token(Lane* l, uint32_t t)
{
    const Oracle* const o = l->par->o;
    const Window* const w = &l->win;
    const uint64_t at = w->base + w->starts[t];
    const uint8_t c = o->src[at];
    l->slow_tokens += 1u;
    if (c == '\\' && o->src[at + 1u] == '\n')
    {
        return at + 2u;
    }
    RefTok tok = ref_lex(o->src, o->src_size, at);
    uint8_t kind = (uint8_t)tok.kind;
    uint32_t data = 0;
    if (tok.kind == K_INT || tok.kind == K_FLOAT)
    {
        const Number number = number_slow(o->src + at, tok.end - tok.start);
        l->numbers_slow += 1u;
        kind = number.kind;
        data = (uint32_t)number.value;
        if (kind == K_INT_I64 || kind == K_INT_U64)
        {
            // The pool's index is the recording's: the value is checked against the pool's.
            const uint32_t index = o->data[l->out_base + (l->out_count - l->task_out)];
            if (index >= o->num_count || o->nums[index] != number.value) { lane_fail(l, "a 64-bit literal's value differs", at); }
            data = index;
        }
    }
    else if (tok.kind == K_BAD || tok.kind == K_IDENT)
    {
        lane_fail(l, "a token the prototype doesn't lex", at);
        return UINT64_MAX;
    }
    l->out_kind[l->out_count] = kind;
    l->out_data[l->out_count] = data;
    l->out_count += 1u;
    return tok.end;
}

static inline uint32_t lane_seek(const Window* w, uint32_t t, uint64_t at)
{
    const uint64_t relative = at - w->base;
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

static __attribute__((noinline)) uint64_t lane_emit(Lane* l)
{
    Window* const w = &l->win;
    const Oracle* const o = l->par->o;
    Table* const table = &l->par->table;
    const uint32_t n = w->count;
    uint32_t t = 0;
    uint64_t next = w->end;
    while (t < n)
    {
        uint32_t flagged = n;
        for (uint32_t c = t & ~UINT32_C(63); c < n && flagged == n; c += 64u)
        {
            uint64_t m = _mm512_test_epi8_mask(_mm512_loadu_si512((const void*)(w->flags + c)), _mm512_loadu_si512((const void*)(w->flags + c)));
            m &= _bzhi_u64(~UINT64_C(0), n - c < 64u ? n - c : 64u);
            if (c < t) { m &= ~UINT64_C(0) << (t - c); }
            if (m != 0) { flagged = c + (uint32_t)__builtin_ctzll(m); }
        }
        lane_copy(l, t, flagged);
        if (flagged == n) { break; }
        const uint32_t flags = w->flags[flagged];
        const uint64_t at = w->base + w->starts[flagged];
        t = flagged + 1u;
        if ((flags & SLOT_DELETE) != 0)
        {
            l->deleted_names += 1u;
            continue;
        }
        if ((flags & (SLOT_DELETE_IF_PAREN | SLOT_FUNC)) != 0)
        {
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
                l->plain_function_names += 1u;
                continue;
            }
            if ((flags & SLOT_DELETE_IF_PAREN) != 0)
            {
                l->deleted_names += 1u;
                continue;
            }
        }
        else if ((flags & SLOT_CHECK) != 0)
        {
            // A one-token macro whose token is a name: its own token unless that name is a macro's at this version.
            const Slot* const slot = table_find(table, o->src + at, w->lens[flagged]);
            const SlotView view = slot_view(table, slot, l->version);
            const SlotView replacement = slot_view(table, table_slot_at(table, view.replacement), l->version);
            l->checked_names += 1u;
            if ((replacement.flags & SLOT_MACRO) == 0 && replacement.placed == 0)
            {
                w->flags[flagged] = 0;
                t = flagged;
                continue;
            }
        }
        else if ((flags & WF_SLOW) != 0)
        {
            const uint64_t after = lane_slow_token(l, flagged);
            if (after == UINT64_MAX) { return UINT64_MAX; }
            if (after >= w->end) { next = after; t = n; break; }
            t = lane_seek(w, t, after);
            continue;
        }
        bool bound = false;
        const uint64_t resume = lane_event(l, at, &bound);
        if (resume == UINT64_MAX) { return UINT64_MAX; }
        if (bound || resume >= w->end)
        {
            next = resume;
            t = n;
            break;
        }
        l->resumed_in_window += 1u;
        t = lane_seek(w, t, resume);
    }
    return next;
}

// One task: its text's windows from directive line to directive line, to the lane's arena.
static __attribute__((noinline)) void lane_task(Lane* l, Task* task, bool last)
{
    Par* const p = l->par;
    const Oracle* const o = p->o;
    const uint8_t* const s = o->src;
    const uint64_t size = o->src_size;
    const uint32_t* const directives = p->scan.directives;
    const uint32_t directive_count = p->scan.directive_count;
    l->event = task->event_begin;
    l->version = task->event_begin < o->event_count ? o->events[task->event_begin].bind_begin : o->bind_count;
    l->task_out = l->out_count;
    l->out_base = task->begin == 0 ? 0u : o->events[task->event_begin].out_begin;
    uint32_t d = 0;
    {
        uint32_t high = directive_count;
        while (d < high)
        {
            const uint32_t middle = d + (high - d) / 2u;
            if (directives[middle] < task->begin) { d = middle + 1u; }
            else { high = middle; }
        }
    }
    uint64_t at = task->begin;
    const uint64_t end = task->end;
    while (at < end && l->failure == NULL)
    {
        while (d < directive_count && directives[d] < at) { d += 1u; }
        uint64_t limit = d < directive_count ? directives[d] : size;
        if (limit > end) { limit = end; }
        if (at < limit)
        {
            lex_window(s, p->scan.masks, at, limit, &l->win);
            l->windows += 1u;
            l->window_tokens += l->win.count;
            if (l->win.count == 0 && l->win.end == at && limit - at >= 64u)
            {
                lane_fail(l, "a token longer than a window", at);
                break;
            }
            lane_numbers(l);
            lane_names(l);
            at = lane_emit(l);
        }
        else
        {
            bool bound = false;
            at = lane_event(l, limit, &bound);
        }
    }
    if (l->failure == NULL && last && l->event < o->event_count)
    {
        // Events after the last of the text's tokens that made nothing are passed; one that made tokens ends the
        // stream.
        bool bound = false;
        const OracleEvent* const e = o->events + l->event;
        if (e->out_end != e->out_begin || e->bind_end != e->bind_begin) { (void)lane_event(l, e->stop, &bound); }
    }
    if (l->failure == NULL && !last)
    {
        // What is left of the task's events made nothing: the text's own tokens passed them.
        for (uint32_t e = l->event; e < task->event_end; e += 1)
        {
            if (o->events[e].out_end != o->events[e].out_begin || o->events[e].bind_end != o->events[e].bind_begin) { lane_fail(l, "a task ended before an event of its own", o->events[e].stop); }
        }
    }
    task->lane = l->index;
    task->offset = l->task_out;
    task->count = l->out_count - l->task_out;
    l->tasks += 1u;
}

// ---------------------------------------------------------------------------------------------------------------------
// The phases.

// The tasks: the text cut at directive lines the recording has an event at, by the text between events.
static void par_cut(Par* p)
{
    const Oracle* const o = p->o;
    const uint32_t* const directives = p->scan.directives;
    const uint32_t directive_count = p->scan.directive_count;
    uint64_t total = 0;
    uint64_t previous = 0;
    for (uint32_t e = 0; e < o->event_count; e += 1)
    {
        total += o->events[e].stop - previous;
        previous = o->events[e].resume;
    }
    total += o->src_size - previous;
    const uint64_t target = total / p->tasks_wanted + 1u;
    uint32_t count = 0;
    p->tasks[0] = (Task){ .begin = 0, .event_begin = 0 };
    uint64_t active = 0;
    uint32_t d = 0;
    previous = 0;
    for (uint32_t e = 0; e < o->event_count; e += 1)
    {
        const OracleEvent* const event = o->events + e;
        if (e != 0 && active >= target && count + 1u < p->task_cap)
        {
            while (d < directive_count && directives[d] < event->stop) { d += 1u; }
            if (d < directive_count && directives[d] == event->stop)
            {
                p->tasks[count].end = event->stop;
                p->tasks[count].event_end = e;
                count += 1u;
                p->tasks[count] = (Task){ .begin = event->stop, .event_begin = e };
                active = 0;
            }
        }
        active += event->stop - previous;
        previous = event->resume;
    }
    p->tasks[count].end = o->src_size;
    p->tasks[count].event_end = o->event_count;
    p->task_count = count + 1u;
}

static inline void par_wait_phase(const Par* p, uint32_t phase)
{
    while (__atomic_load_n(&p->phase, __ATOMIC_ACQUIRE) < phase) { _mm_pause(); }
}

static void lane_scan_phase(Par* p, Lane* l)
{
    const uint64_t t0 = __rdtsc();
    for (;;)
    {
        const uint32_t c = __atomic_fetch_add(&p->next_chunk, 1u, __ATOMIC_RELAXED);
        if (c >= p->chunk_count) { break; }
        scan_chunk(p->o->src, p->o->src_size, p->scan.masks, p->chunks + c);
    }
    l->ticks[1] += __rdtsc() - t0;
}

static void lane_task_phase(Par* p, Lane* l)
{
    const uint64_t t0 = __rdtsc();
    for (;;)
    {
        const uint32_t t = __atomic_fetch_add(&p->next_task, 1u, __ATOMIC_RELAXED);
        if (t >= p->task_count) { break; }
        lane_task(l, p->tasks + t, t + 1u == p->task_count);
    }
    l->ticks[2] += __rdtsc() - t0;
}

static void lane_copy_phase(Par* p, Lane* l)
{
    const uint64_t t0 = __rdtsc();
    for (;;)
    {
        const uint32_t t = __atomic_fetch_add(&p->next_copy, 1u, __ATOMIC_RELAXED);
        if (t >= p->task_count) { break; }
        const Task* const task = p->tasks + t;
        const Lane* const from = p->lanes + task->lane;
        memcpy(p->out_kind + task->final, from->out_kind + task->offset, task->count);
        memcpy(p->out_data + task->final, from->out_data + task->offset, (size_t)task->count * 4u);
    }
    l->ticks[3] += __rdtsc() - t0;
}

static void lane_phases(Par* p, Lane* l)
{
    par_wait_phase(p, 1);
    lane_scan_phase(p, l);
    __atomic_fetch_add(&p->done[1], 1u, __ATOMIC_RELEASE);
    par_wait_phase(p, 2);
    lane_task_phase(p, l);
    __atomic_fetch_add(&p->done[2], 1u, __ATOMIC_RELEASE);
    par_wait_phase(p, 3);
    lane_copy_phase(p, l);
    __atomic_fetch_add(&p->done[3], 1u, __ATOMIC_RELEASE);
}

static void* lane_thread(void* argument)
{
    Lane* const l = (Lane*)argument;
    Par* const p = l->par;
    if (!p->warm)
    {
        lane_phases(p, l);
        return NULL;
    }
    uint32_t seen = 0;
    for (;;)
    {
        uint32_t generation = __atomic_load_n(&p->generation, __ATOMIC_ACQUIRE);
        while (generation == seen && __atomic_load_n(&p->quit, __ATOMIC_ACQUIRE) == 0)
        {
            _mm_pause();
            generation = __atomic_load_n(&p->generation, __ATOMIC_ACQUIRE);
        }
        if (generation == seen) { break; }
        seen = generation;
        lane_phases(p, l);
    }
    return NULL;
}

static void par_start_threads(Par* p)
{
    for (uint32_t i = 1; i < p->lane_count; i += 1)
    {
        Lane* const l = p->lanes + i;
        pthread_attr_t attributes;
        pthread_attr_init(&attributes);
        if (l->cpu >= 0)
        {
            cpu_set_t set;
            CPU_ZERO(&set);
            CPU_SET(l->cpu, &set);
            pthread_attr_setaffinity_np(&attributes, sizeof(set), &set);
        }
        if (pthread_create(&l->thread, &attributes, lane_thread, l) != 0) { fprintf(stderr, "front_par: no thread\n"); exit(2); }
        pthread_attr_destroy(&attributes);
    }
}

static inline void par_wait_done(const Par* p, uint32_t phase)
{
    while (__atomic_load_n(&p->done[phase], __ATOMIC_ACQUIRE) != p->lane_count - 1u) { _mm_pause(); }
}

// One whole run. `stamps` gets the TSC at its start, after the scans, after the join and the cut, after the tasks,
// and at its end.
static bool par_run(Par* p, uint64_t* stamps)
{
    const Oracle* const o = p->o;
    Lane* const main_lane = p->lanes;
    stamps[0] = __rdtsc();
    __atomic_store_n(&p->phase, 1u, __ATOMIC_RELEASE);
    if (!p->warm) { par_start_threads(p); }
    // The main file's bindings, by one lane (the spine's part of the table).
    {
        const uint64_t t0 = __rdtsc();
        for (uint32_t b = p->first_main_bind; b < o->bind_count; b += 1) { par_bind(p, b); }
        main_lane->ticks[0] += __rdtsc() - t0;
    }
    lane_scan_phase(p, main_lane);
    par_wait_done(p, 1);
    stamps[1] = __rdtsc();
    scan_join(o->src, o->src_size, p->chunks, p->chunk_count, &p->scan, &p->rescans, &p->pending_directives);
    par_cut(p);
    stamps[2] = __rdtsc();
    __atomic_store_n(&p->phase, 2u, __ATOMIC_RELEASE);
    lane_task_phase(p, main_lane);
    par_wait_done(p, 2);
    stamps[3] = __rdtsc();
    uint32_t total = 0;
    for (uint32_t t = 0; t < p->task_count; t += 1)
    {
        p->tasks[t].final = total;
        total += p->tasks[t].count;
    }
    p->out_count = total;
    __atomic_store_n(&p->phase, 3u, __ATOMIC_RELEASE);
    lane_copy_phase(p, main_lane);
    par_wait_done(p, 3);
    if (!p->warm)
    {
        for (uint32_t i = 1; i < p->lane_count; i += 1) { pthread_join(p->lanes[i].thread, NULL); }
    }
    stamps[4] = __rdtsc();
    bool ok = true;
    for (uint32_t i = 0; i < p->lane_count; i += 1) { ok = ok && p->lanes[i].failure == NULL; }
    return ok;
}

// ---------------------------------------------------------------------------------------------------------------------
// The check against the recording, and the driver.

static bool par_check(Par* p)
{
    const Oracle* const o = p->o;
    Table* const names = &p->table;
    if (p->out_count != o->count)
    {
        fprintf(stderr, "check: %u tokens, the recording has %u\n", p->out_count, o->count);
    }
    uint32_t misplaced = 0;
    for (uint32_t t = 1; t < p->task_count; t += 1)
    {
        if (p->tasks[t].final != o->events[p->tasks[t].event_begin].out_begin) { misplaced += 1u; }
    }
    if (misplaced != 0) { fprintf(stderr, "check: %u tasks' places differ from the recording's\n", misplaced); }
    const uint32_t n = p->out_count < o->count ? p->out_count : o->count;
    uint32_t* map = (uint32_t*)calloc((size_t)o->ident_count + 2u, 4);
    uint64_t kinds_differ = 0, names_differ = 0, values_differ = 0, unchecked = 0, checked_names = 0, checked_values = 0;
    for (uint32_t i = 0; i < n; i += 1)
    {
        const uint8_t k = o->kinds[i];
        if (p->out_kind[i] != k)
        {
            if (kinds_differ < 8) { fprintf(stderr, "check: token %u: kind %u, the recording's %u (text offset %u)\n", i, (unsigned)p->out_kind[i], (unsigned)k, o->tok_start[i]); }
            kinds_differ += 1u;
            continue;
        }
        if (o->prov[i] == PROV_NONE) { continue; }
        const uint32_t mine = p->out_data[i];
        const uint32_t theirs = o->data[i];
        if (k == K_IDENT || (k >= 64u && k <= 121u))
        {
            if ((theirs & UINT32_C(0x80000000)) != 0)
            {
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
    return p->out_count == o->count && misplaced == 0 && kinds_differ == 0 && names_differ == 0 && values_differ == 0;
}

static int compare_u64(const void* a, const void* b)
{
    const uint64_t x = *(const uint64_t*)a;
    const uint64_t y = *(const uint64_t*)b;
    return x < y ? -1 : x > y;
}

static uint64_t now_ns(void)
{
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC_RAW, &ts);
    return (uint64_t)ts.tv_sec * UINT64_C(1000000000) + (uint64_t)ts.tv_nsec;
}

int main(int argc, char** argv)
{
    if (argc < 5) { fprintf(stderr, "usage: front_par DUMP SOURCE ROUNDS LANES [--warm] [--cpus A,B,...] [--tasks N] [--chunks N]\n"); return 2; }
    static Oracle o;
    if (!oracle_load(&o, argv[1], argv[2])) { fprintf(stderr, "front_par: the recording doesn't fit the source\n"); return 1; }
    const uint32_t rounds = (uint32_t)atoi(argv[3]);
    const uint32_t lanes = (uint32_t)atoi(argv[4]);
    static Par p;
    p.o = &o;
    p.lane_count = lanes;
    p.tasks_wanted = lanes * 16u;
    p.chunk_count = lanes == 1u ? 1u : lanes * 4u;
    int cpus[256];
    for (uint32_t i = 0; i < 256u; i += 1) { cpus[i] = -1; }
    for (int i = 5; i < argc; i += 1)
    {
        if (strcmp(argv[i], "--warm") == 0) { p.warm = true; }
        else if (strcmp(argv[i], "--tasks") == 0 && i + 1 < argc) { p.tasks_wanted = (uint32_t)atoi(argv[i + 1]); i += 1; }
        else if (strcmp(argv[i], "--chunks") == 0 && i + 1 < argc) { p.chunk_count = (uint32_t)atoi(argv[i + 1]); i += 1; }
        else if (strcmp(argv[i], "--cpus") == 0 && i + 1 < argc)
        {
            uint32_t count = 0;
            for (char* q = argv[i + 1]; *q != 0 && count < 256u;)
            {
                cpus[count] = (int)strtol(q, &q, 10);
                count += 1u;
                if (*q == ',') { q += 1; }
            }
            i += 1;
        }
    }
    if (p.tasks_wanted == 0) { p.tasks_wanted = 1; }
    if (p.chunk_count == 0) { p.chunk_count = 1; }
    if (cpus[0] >= 0)
    {
        cpu_set_t set;
        CPU_ZERO(&set);
        CPU_SET(cpus[0], &set);
        sched_setaffinity(0, sizeof(set), &set);
    }
    table_init(&p.table, o.bind_count);
    const uint64_t blocks = (o.src_size + 63u) / 64u;
    p.scan.masks = (uint64_t*)aligned_alloc(64, (2u * blocks + 16u) * 8u);
    memset(p.scan.masks, 0, (2u * blocks + 16u) * 8u);
    p.scan.directives = (uint32_t*)calloc(o.src_size / 2u + 16u, 4);
    p.chunks = (ScanChunk*)calloc(p.chunk_count, sizeof(ScanChunk));
    for (uint32_t c = 0; c < p.chunk_count; c += 1)
    {
        p.chunks[c].first = blocks * c / p.chunk_count;
        p.chunks[c].last = blocks * (c + 1u) / p.chunk_count;
        p.chunks[c].directives = (uint32_t*)calloc((p.chunks[c].last - p.chunks[c].first) * 32u + 16u, 4);
    }
    p.task_cap = p.tasks_wanted + 16u;
    p.tasks = (Task*)calloc(p.task_cap, sizeof(Task));
    const uint32_t out_cap = o.count + 4096u;
    p.out_kind = (uint8_t*)aligned_alloc(64, ((size_t)out_cap + 127u) & ~(size_t)63u);
    p.out_data = (uint32_t*)aligned_alloc(64, (((size_t)out_cap + 64u) * 4u + 63u) & ~(size_t)63u);
    memset(p.out_kind, 0, ((size_t)out_cap + 127u) & ~(size_t)63u);
    memset(p.out_data, 0, (((size_t)out_cap + 64u) * 4u + 63u) & ~(size_t)63u);
    p.lanes = (Lane*)aligned_alloc(64, sizeof(Lane) * lanes);
    memset(p.lanes, 0, sizeof(Lane) * lanes);
    for (uint32_t i = 0; i < lanes; i += 1)
    {
        Lane* const l = p.lanes + i;
        l->par = &p;
        l->index = i;
        l->cpu = cpus[i];
        uint8_t* const region = (uint8_t*)aligned_alloc(64, WIN_REGION_BYTES);
        memset(region, 0, WIN_REGION_BYTES);
        l->win.kinds = region + WIN_KINDS_AT;
        l->win.lens = region + WIN_LENS_AT;
        l->win.flags = region + WIN_FLAGS_AT;
        l->win.starts = (uint16_t*)(void*)(region + WIN_STARTS_AT);
        l->win.data = (uint32_t*)(void*)(region + WIN_DATA_AT);
        l->out_kind = (uint8_t*)aligned_alloc(64, ((size_t)out_cap + 127u) & ~(size_t)63u);
        l->out_data = (uint32_t*)aligned_alloc(64, (((size_t)out_cap + 64u) * 4u + 63u) & ~(size_t)63u);
        memset(l->out_kind, 0, ((size_t)out_cap + 127u) & ~(size_t)63u);
        memset(l->out_data, 0, (((size_t)out_cap + 64u) * 4u + 63u) & ~(size_t)63u);
    }
    if (p.warm) { par_start_threads(&p); }

    uint64_t* wall = (uint64_t*)calloc(rounds, 8);
    uint64_t* ticks = (uint64_t*)calloc(rounds, 8);
    uint64_t* parts[5];
    for (uint32_t i = 0; i < 5u; i += 1) { parts[i] = (uint64_t*)calloc(rounds, 8); }
    uint64_t* work[4];
    for (uint32_t i = 0; i < 4u; i += 1) { work[i] = (uint64_t*)calloc(rounds, 8); }
    bool ok = true;
    for (uint32_t r = 0; r < rounds && ok; r += 1)
    {
        par_table_setup(&p);
        p.rescans = 0;
        p.pending_directives = 0;
        p.next_chunk = 0;
        p.next_task = 0;
        p.next_copy = 0;
        memset(p.done, 0, sizeof(p.done));
        __atomic_store_n(&p.phase, 0u, __ATOMIC_RELEASE);
        for (uint32_t i = 0; i < lanes; i += 1)
        {
            Lane* const l = p.lanes + i;
            l->out_count = 0;
            l->windows = l->window_tokens = l->names = l->listed_names = l->numbers = l->numbers_slow = l->slow_tokens = l->deleted_names = l->checked_names = 0;
            l->plain_function_names = l->events_used = l->events_passed = l->replayed = l->resumed_in_window = l->tasks = 0;
            memset(l->ticks, 0, sizeof(l->ticks));
            l->failure = NULL;
        }
        if (p.warm) { __atomic_fetch_add(&p.generation, 1u, __ATOMIC_RELEASE); }
        uint64_t stamps[5];
        const uint64_t n0 = now_ns();
        ok = par_run(&p, stamps);
        const uint64_t n1 = now_ns();
        wall[r] = n1 - n0;
        ticks[r] = stamps[4] - stamps[0];
        for (uint32_t i = 0; i < 4u; i += 1) { parts[i][r] = stamps[i + 1u] - stamps[i]; }
        for (uint32_t i = 0; i < 4u; i += 1)
        {
            uint64_t sum = 0;
            for (uint32_t j = 0; j < lanes; j += 1) { sum += p.lanes[j].ticks[i]; }
            work[i][r] = sum;
        }
    }
    if (p.warm)
    {
        __atomic_store_n(&p.quit, 1u, __ATOMIC_RELEASE);
        for (uint32_t i = 1; i < lanes; i += 1) { pthread_join(p.lanes[i].thread, NULL); }
    }
    for (uint32_t i = 0; i < lanes; i += 1)
    {
        const Lane* const l = p.lanes + i;
        if (l->failure != NULL) { fprintf(stderr, "front_par: lane %u: %s at text offset %llu: %.60s\n", i, l->failure, (unsigned long long)l->failure_at, o.src + l->failure_at); }
    }
    Lane sum = { 0 };
    uint64_t most_tasks = 0;
    for (uint32_t i = 0; i < lanes; i += 1)
    {
        const Lane* const l = p.lanes + i;
        sum.windows += l->windows; sum.window_tokens += l->window_tokens; sum.names += l->names; sum.listed_names += l->listed_names; sum.numbers += l->numbers;
        sum.numbers_slow += l->numbers_slow; sum.slow_tokens += l->slow_tokens; sum.deleted_names += l->deleted_names; sum.checked_names += l->checked_names;
        sum.events_used += l->events_used; sum.events_passed += l->events_passed; sum.replayed += l->replayed; sum.resumed_in_window += l->resumed_in_window;
        if (l->tasks > most_tasks) { most_tasks = l->tasks; }
    }
    uint32_t distinct = 0;
    for (uint32_t i = 0; i < TABLE_SLOTS; i += 1) { distinct += p.table.slots[i].k0 != 0; }
    printf("source %zu bytes, %u stream tokens, %u events in the recording; %u lanes%s, %u scan chunks, %u tasks (the busiest lane took %llu)\n", o.src_size, o.count, o.event_count,
           lanes, p.warm ? " (threads kept between rounds)" : " (threads made in each round)", p.chunk_count, p.task_count, (unsigned long long)most_tasks);
    printf("pass A: %llu blocks, %llu with rare bytes, %llu by the scalar machine, %u directive lines; %u chunks scanned again (a wrong guess), %u '#' decided at the join\n",
           (unsigned long long)p.scan.blocks, (unsigned long long)p.scan.rare_blocks, (unsigned long long)p.scan.slow_blocks, p.scan.directive_count, p.rescans, p.pending_directives);
    printf("pass B: %llu windows, %llu raw tokens, %llu names (%llu by a name's list of bindings, %u names in the table), %llu numbers (%llu by the scalar path), %llu scalar tokens\n",
           (unsigned long long)sum.windows, (unsigned long long)sum.window_tokens, (unsigned long long)sum.names, (unsigned long long)sum.listed_names, distinct,
           (unsigned long long)sum.numbers, (unsigned long long)sum.numbers_slow, (unsigned long long)sum.slow_tokens);
    printf("events: %llu taken from the recording (%llu tokens), %llu passed in the text's own tokens, %llu resumed inside their window; %llu names deleted, %llu checked; %u bindings made in the run\n",
           (unsigned long long)sum.events_used, (unsigned long long)sum.replayed, (unsigned long long)sum.events_passed, (unsigned long long)sum.resumed_in_window,
           (unsigned long long)sum.deleted_names, (unsigned long long)sum.checked_names, o.bind_count - p.first_main_bind);
    const bool same = ok && par_check(&p);
    qsort(wall, rounds, 8, compare_u64);
    qsort(ticks, rounds, 8, compare_u64);
    for (uint32_t i = 0; i < 4u; i += 1) { qsort(parts[i], rounds, 8, compare_u64); qsort(work[i], rounds, 8, compare_u64); }
    const uint32_t mid = rounds / 2u;
    printf("rounds %u, lanes %u: the whole front's wall time, medians: %llu ns (%.3f GB/s of source), %llu TSC ticks; least %llu ns\n", rounds, lanes, (unsigned long long)wall[mid],
           (double)o.src_size / (double)wall[mid], (unsigned long long)ticks[mid], (unsigned long long)wall[0]);
    printf("its parts, TSC ticks, medians: bindings and scans %llu, the scans' join and the cut %llu, tasks %llu, the stream's prefix sum and copies %llu\n",
           (unsigned long long)parts[0][mid], (unsigned long long)parts[1][mid], (unsigned long long)parts[2][mid], (unsigned long long)parts[3][mid]);
    printf("the lanes' work summed, TSC ticks, medians: bindings %llu, scans %llu, tasks %llu, copies %llu\n", (unsigned long long)work[0][mid], (unsigned long long)work[1][mid],
           (unsigned long long)work[2][mid], (unsigned long long)work[3][mid]);
    printf("%s\n", same ? "SAME as the recording" : "DIFFERS from the recording");
    return same ? 0 : 1;
}
