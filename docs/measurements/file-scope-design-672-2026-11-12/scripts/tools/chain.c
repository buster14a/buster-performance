// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// chain.c: a prototype of the passes the "attested declarations" design adds to a unit's reading, to time them on the
// 9700X over a command's real units (tools/chain_dump.py's columns): it is not the compiler's code and reads no C.
//
//   chain [--warm] [--scan | --check] DUMP.bin [REPETITIONS]
//
// For every unit, in the command's order, with one memo for the command:
//   S. with --scan, each declaration's lists made here from its tokens' kinds and spellings' classes, by a scan with
//      a stack of contexts (the dump's lists are tools/attest.py's, which --check compares these with, list for list):
//      the names it declares at file scope, the names its reading looks up, its tags' mentions, the names it spells,
//      and whether it is eligible;
//   A. each file-scope declaration's own hash, of its tokens' kinds and names (two tokens an AES round);
//   B. the chain, in source order: each declaration's semantic hash (its own, with the current hash of every name it
//      looks up, declares or mentions as a tag), the memo's probe, and its declared names' new hashes;
//   C. the reach: from the roots (a definition, a pragma, a declaration that isn't an eligible hit) to every earlier
//      declaration of a name a reached one spells and every later declaration of a name it declares;
//   D. the skipped declarations' tokens marked (a byte a token), and the unit's eligible hashes added to the memo.
// With --warm the memo is filled by a first run of the command and kept: every eligible declaration is then a hit, as
// in a second command with a memo kept from the first.
// It prints what it skipped (which tools/attest.py's emulation must agree with) and, over REPETITIONS runs of the
// whole command (default 21, the memo emptied before each), the median user cycles and instructions a run, a token,
// and each pass's share of the time. In the compiler the scan would read the parser's roles, which say what the
// stack of contexts works out here (a parameter list from a parenthesized declarator, a typedef name from a declared
// one), so S stands for that pass with more work than it would have.

#define _GNU_SOURCE
#include <fcntl.h>
#include <immintrin.h>
#include <linux/perf_event.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <unistd.h>

#define CHAIN_ELIGIBLE 1u
#define CHAIN_DEFINITION 2u
#define CHAIN_PRAGMA 4u
#define CHAIN_MEMO_SLOTS (1u << 17)
#define CHAIN_PHASES 5
#define CHAIN_DEPTH 256
// A spelling's class (chain_dump.py's) and flags.
#define CHAIN_CLASS_L_BRACE 1
#define CHAIN_CLASS_R_BRACE 2
#define CHAIN_CLASS_L_PAREN 3
#define CHAIN_CLASS_R_PAREN 4
#define CHAIN_CLASS_L_SQUARE 5
#define CHAIN_CLASS_R_SQUARE 6
#define CHAIN_CLASS_COMMA 7
#define CHAIN_CLASS_SEMI 8
#define CHAIN_CLASS_COLON 9
#define CHAIN_CLASS_ASSIGN 10
#define CHAIN_CLASS_STAR 11
#define CHAIN_CLASS_STRUCT 20
#define CHAIN_CLASS_ENUM 21
#define CHAIN_CLASS_TYPEDEF 22
#define CHAIN_CLASS_EXTERN 23
#define CHAIN_CLASS_TYPE 24
#define CHAIN_CLASS_KEYWORD 25
#define CHAIN_CLASS_NAME 26
#define CHAIN_FLAG_OPERAND_PAREN 1
#define CHAIN_FLAG_TYPE_PAREN 2
#define CHAIN_FLAG_INELIGIBLE 4
#define CHAIN_FLAG_EXTENSION 8
#define CHAIN_KIND_NAME 1
#define CHAIN_KIND_PRAGMA 5
#define CHAIN_KIND_KEYWORD 6

typedef enum ChainContext
{
    CHAIN_CONTEXT_TOP,
    CHAIN_CONTEXT_GROUP,
    CHAIN_CONTEXT_PARAMETERS,
    CHAIN_CONTEXT_STRUCT,
    CHAIN_CONTEXT_ENUM,
    CHAIN_CONTEXT_EXPRESSION,
    CHAIN_CONTEXT_TYPE,
    CHAIN_CONTEXT_SQUARE,
    CHAIN_CONTEXT_NONE,
} ChainContext;

typedef struct Declaration Declaration;
struct Declaration
{
    uint32_t first;
    uint32_t count;
    uint32_t flags;
    uint32_t offset;
    uint32_t lookups;
    uint32_t names;
    uint32_t tags;
    uint32_t spelled;
};

typedef struct Unit Unit;
struct Unit
{
    uint32_t declarations;
    uint32_t tokens;
    uint32_t list_words;
    const uint8_t* kinds;
    const uint32_t* names;
    const Declaration* table;
    const uint32_t* lists;
};

typedef struct State State;
struct State
{
    // Per name and namespace (2 * spelling for an ordinary name, + 1 for a tag): its hash, the unit that wrote it, and
    // its latest declarer's slot in that unit.
    uint64_t* name_hash;
    uint32_t* name_stamp;
    uint32_t* name_head;
    // The reach's two cursors a name: the next declarer's slot from its first one up, and from its last one down.
    uint32_t* name_rising;
    uint32_t* name_falling;
    uint32_t stamp;
    // The unit's declarers, a slot per declared name: its declaration and the slots of the name's declarers before and
    // after it.
    uint32_t* slot_declaration;
    uint32_t* slot_previous;
    uint32_t* slot_next;
    uint32_t slots;
    // Per declaration: its own hash, its semantic hash, whether the memo has it, its declared keys' range, whether the
    // unit's code reaches it.
    uint64_t* local;
    uint64_t* hash;
    uint8_t* hit;
    uint8_t* eligible;
    uint32_t* keys_first;
    uint32_t* keys;
    uint32_t key_count;
    uint8_t* reached;
    uint32_t* work;
    uint8_t* ignored;
    uint64_t* memo;
    uint32_t memo_count;
    // The scan's: the spellings' classes and flags, its own table and lists for the unit, and each spelling's last
    // declaration in each list (a stamp), which keeps a list's names distinct.
    const uint8_t* classes;
    const uint8_t* flags;
    Declaration* scan_table;
    uint32_t* scan_lists;
    uint32_t* seen_lookup;
    uint32_t* seen_name;
    uint32_t* seen_spelled;
    uint32_t scan_stamp;
    uint64_t mismatches;
    // What a run skipped and found.
    uint64_t skipped_tokens;
    uint64_t skipped_declarations;
    uint64_t hits;
    uint64_t misses;
    uint64_t ticks[CHAIN_PHASES];
};

static inline uint64_t chain_mix(uint64_t hash, uint64_t value)
{
    hash = (hash ^ value) * UINT64_C(0x9e3779b97f4a7c15);
    return hash ^ (hash >> 29);
}

// A declaration's own hash: its tokens' kinds and names, two tokens a round.
static inline uint64_t chain_local(const uint8_t* kinds, const uint32_t* names, uint32_t count)
{
    const __m128i key = _mm_set_epi64x(INT64_C(0x243f6a8885a308d3), INT64_C(0x13198a2e03707344));
    __m128i state = _mm_set_epi64x((int64_t)count, INT64_C(0x452821e638d01377));
    uint32_t i = 0;
    for (; i + 1 < count; i += 2)
    {
        const uint64_t low = names[i] | (uint64_t)kinds[i] << 32;
        const uint64_t high = names[i + 1] | (uint64_t)kinds[i + 1] << 32;
        state = _mm_aesenc_si128(_mm_xor_si128(state, _mm_set_epi64x((int64_t)high, (int64_t)low)), key);
    }
    if (i < count)
    {
        const uint64_t low = names[i] | (uint64_t)kinds[i] << 32;
        state = _mm_aesenc_si128(_mm_xor_si128(state, _mm_set_epi64x(0, (int64_t)low)), key);
    }
    state = _mm_aesenc_si128(state, key);
    state = _mm_aesenc_si128(state, key);
    return (uint64_t)_mm_cvtsi128_si64(state) ^ (uint64_t)_mm_extract_epi64(state, 1);
}

static inline uint64_t chain_get(const State* state, uint32_t key)
{
    return state->name_stamp[key] == state->stamp ? state->name_hash[key] : 0;
}

static inline void chain_declare(State* state, uint32_t key, uint64_t hash, uint32_t declaration)
{
    const bool present = state->name_stamp[key] == state->stamp;
    state->name_hash[key] = chain_mix(chain_mix(present ? state->name_hash[key] : 0, hash), key);
    state->slots += 1;
    const uint32_t slot = state->slots;
    const uint32_t before = present ? state->name_head[key] : 0;
    state->slot_declaration[slot] = declaration;
    state->slot_previous[slot] = before;
    state->slot_next[slot] = 0;
    state->slot_next[before] = slot;
    state->name_rising[key] = present ? state->name_rising[key] : slot;
    state->name_falling[key] = slot;
    state->name_head[key] = slot;
    state->name_stamp[key] = state->stamp;
    state->keys[state->key_count] = key;
    state->key_count += 1;
}

static bool chain_memo_has(const State* state, uint64_t hash)
{
    uint32_t slot = (uint32_t)(hash >> 40) & (CHAIN_MEMO_SLOTS - 1);
    bool found = false;
    while (!found && state->memo[slot] != 0)
    {
        found = state->memo[slot] == hash;
        slot = (slot + 1) & (CHAIN_MEMO_SLOTS - 1);
    }
    return found;
}

static void chain_memo_add(State* state, uint64_t hash)
{
    uint32_t slot = (uint32_t)(hash >> 40) & (CHAIN_MEMO_SLOTS - 1);
    while (state->memo[slot] != 0 && state->memo[slot] != hash)
    {
        slot = (slot + 1) & (CHAIN_MEMO_SLOTS - 1);
    }
    state->memo_count += state->memo[slot] == 0;
    state->memo[slot] = hash;
}

// The nearest context that isn't a parenthesized declarator's.
static inline uint32_t chain_base(const uint8_t* kinds, uint32_t depth)
{
    uint32_t at = depth - 1;
    while (at != 0 && kinds[at] == CHAIN_CONTEXT_GROUP)
    {
        at -= 1;
    }
    return at;
}

// S. A declaration's lists from its tokens (tools/attest.py's analyse): appended at `out`, their counts in `row`.
static uint32_t chain_scan_declaration(State* state, const Unit* unit, const Declaration* source, Declaration* row, uint32_t* out)
{
    const uint8_t* kinds = unit->kinds + source->first;
    const uint32_t* names = unit->names + source->first;
    const uint32_t count = source->count;
    uint32_t written = 0;
    *row = *source;
    row->lookups = 0;
    row->names = 0;
    row->tags = 0;
    row->spelled = 0;
    state->scan_stamp += 1;
    const uint32_t stamp = state->scan_stamp;
    bool eligible = false;
    if ((source->flags & (CHAIN_DEFINITION | CHAIN_PRAGMA)) == 0)
    {
        // Three passes' worth in one: the lookups first, in a first scan; then the names and the tags from the same scan's
        // temporaries, kept at the lists' end.
        uint32_t* lookups = out;
        uint32_t* declared = out + count;
        uint32_t* tags = out + 2 * count;
        uint32_t lookup_count = 0;
        uint32_t declared_count = 0;
        uint32_t tag_count = 0;
        uint8_t stack_kind[CHAIN_DEPTH];
        bool stack_type[CHAIN_DEPTH];
        uint32_t depth = 1;
        stack_kind[0] = CHAIN_CONTEXT_TOP;
        stack_type[0] = false;
        bool ineligible = false;
        bool is_typedef = false;
        bool is_extern = false;
        bool object_declarator = false;
        uint32_t pending = 0;
        bool tagged = false;
        bool tag_plain = false;
        bool plain = true;
        bool after_name = false;
        uint8_t last_closed = CHAIN_CONTEXT_NONE;
        bool bit_field = false;
        uint8_t previous_class = 0;
        uint8_t previous_flags = 0;
        for (uint32_t i = 0; i < count; i += 1)
        {
            const uint8_t kind = kinds[i];
            if (kind == CHAIN_KIND_PRAGMA)
            {
                ineligible = true;
                continue;
            }
            const uint32_t name = names[i];
            const uint8_t class = state->classes[name];
            const uint8_t flags = state->flags[name];
            const bool word = kind == CHAIN_KIND_NAME || kind == CHAIN_KIND_KEYWORD;
            const bool named = after_name;
            after_name = false;
            const uint32_t base = chain_base(stack_kind, depth);
            const uint8_t context = stack_kind[base];
            const bool declarator_context = (context == CHAIN_CONTEXT_TOP || context == CHAIN_CONTEXT_PARAMETERS || context == CHAIN_CONTEXT_STRUCT) && !bit_field;
            object_declarator |= named && !(class == CHAIN_CLASS_L_PAREN && declarator_context);
            ineligible |= word && (flags & CHAIN_FLAG_INELIGIBLE) != 0;
            if (tagged)
            {
                // What follows a tag's name says what its mention is.
                if (class == CHAIN_CLASS_L_BRACE || (class == CHAIN_CLASS_SEMI && depth == 1 && tag_plain))
                {
                    tags[2 * (tag_count - 1) + 1] |= 1;
                }
                tagged = false;
            }
            if (class == CHAIN_CLASS_L_BRACE)
            {
                stack_kind[depth] = pending == 2 ? CHAIN_CONTEXT_ENUM : pending == 1 ? CHAIN_CONTEXT_STRUCT : CHAIN_CONTEXT_EXPRESSION;
                stack_type[depth] = false;
                depth += depth < CHAIN_DEPTH - 1;
                pending = 0;
            }
            else if (class == CHAIN_CLASS_R_BRACE)
            {
                if (depth > 1)
                {
                    depth -= 1;
                    last_closed = stack_kind[depth];
                }
                stack_type[chain_base(stack_kind, depth)] = true;
                bit_field = false;
            }
            else if (class == CHAIN_CLASS_L_PAREN)
            {
                uint8_t opened = CHAIN_CONTEXT_EXPRESSION;
                if ((previous_flags & CHAIN_FLAG_OPERAND_PAREN) != 0)
                {
                    const bool type = (previous_flags & CHAIN_FLAG_TYPE_PAREN) != 0;
                    if (type && declarator_context)
                    {
                        stack_type[base] = true;
                    }
                    opened = type ? CHAIN_CONTEXT_TYPE : CHAIN_CONTEXT_EXPRESSION;
                }
                else if (declarator_context)
                {
                    const bool after_group = (previous_class == CHAIN_CLASS_R_PAREN || previous_class == CHAIN_CLASS_R_SQUARE) &&
                                             (last_closed == CHAIN_CONTEXT_GROUP || last_closed == CHAIN_CONTEXT_PARAMETERS || last_closed == CHAIN_CONTEXT_SQUARE);
                    opened = named || after_group ? CHAIN_CONTEXT_PARAMETERS : CHAIN_CONTEXT_GROUP;
                }
                stack_kind[depth] = opened;
                stack_type[depth] = false;
                depth += depth < CHAIN_DEPTH - 1;
                pending = 0;
            }
            else if (class == CHAIN_CLASS_R_PAREN)
            {
                if (depth > 1)
                {
                    depth -= 1;
                    last_closed = stack_kind[depth];
                }
            }
            else if (class == CHAIN_CLASS_L_SQUARE)
            {
                stack_kind[depth] = CHAIN_CONTEXT_EXPRESSION;
                stack_type[depth] = false;
                depth += depth < CHAIN_DEPTH - 1;
                pending = 0;
            }
            else if (class == CHAIN_CLASS_R_SQUARE)
            {
                depth -= depth > 1;
                last_closed = CHAIN_CONTEXT_SQUARE;
            }
            else if (word)
            {
                if (class == CHAIN_CLASS_STRUCT || class == CHAIN_CLASS_ENUM)
                {
                    pending = class == CHAIN_CLASS_ENUM ? 2 : 1;
                    if (declarator_context)
                    {
                        stack_type[base] = true;
                    }
                }
                else if (class != CHAIN_CLASS_NAME)
                {
                    if (declarator_context)
                    {
                        is_typedef |= class == CHAIN_CLASS_TYPEDEF && context == CHAIN_CONTEXT_TOP;
                        is_extern |= class == CHAIN_CLASS_EXTERN && context == CHAIN_CONTEXT_TOP;
                        if (class == CHAIN_CLASS_TYPE)
                        {
                            stack_type[base] = true;
                        }
                    }
                }
                else if (pending != 0 && (previous_class == CHAIN_CLASS_STRUCT || previous_class == CHAIN_CLASS_ENUM || previous_class == CHAIN_CLASS_R_PAREN))
                {
                    bool in_parameters = false;
                    for (uint32_t at = 0; at < depth; at += 1)
                    {
                        in_parameters |= stack_kind[at] == CHAIN_CONTEXT_PARAMETERS;
                    }
                    tags[2 * tag_count] = name;
                    tags[2 * tag_count + 1] = in_parameters ? 2 : 0;
                    tag_count += 1;
                    tagged = true;
                    tag_plain = plain;
                }
                else if (context == CHAIN_CONTEXT_ENUM)
                {
                    if (previous_class == CHAIN_CLASS_L_BRACE || previous_class == CHAIN_CLASS_COMMA)
                    {
                        declared[declared_count] = name;
                        declared_count += state->seen_name[name] != stamp;
                        state->seen_name[name] = stamp;
                    }
                    else
                    {
                        lookups[lookup_count] = name;
                        lookup_count += state->seen_lookup[name] != stamp;
                        state->seen_lookup[name] = stamp;
                    }
                }
                else if (declarator_context)
                {
                    if (!stack_type[base])
                    {
                        // A typedef name as the type specifier.
                        stack_type[base] = true;
                        lookups[lookup_count] = name;
                        lookup_count += state->seen_lookup[name] != stamp;
                        state->seen_lookup[name] = stamp;
                    }
                    else if (context == CHAIN_CONTEXT_TOP)
                    {
                        declared[declared_count] = name;
                        declared_count += state->seen_name[name] != stamp;
                        state->seen_name[name] = stamp;
                        after_name = true;
                    }
                }
                else
                {
                    lookups[lookup_count] = name;
                    lookup_count += state->seen_lookup[name] != stamp;
                    state->seen_lookup[name] = stamp;
                }
            }
            else
            {
                const uint8_t top = stack_kind[depth - 1];
                if (class == CHAIN_CLASS_COMMA && top == CHAIN_CONTEXT_PARAMETERS)
                {
                    stack_type[depth - 1] = false;
                }
                else if (class == CHAIN_CLASS_SEMI && top == CHAIN_CONTEXT_STRUCT)
                {
                    stack_type[depth - 1] = false;
                    bit_field = false;
                }
                else if (class == CHAIN_CLASS_COMMA && top == CHAIN_CONTEXT_STRUCT)
                {
                    bit_field = false;
                }
                else if (class == CHAIN_CLASS_COLON && top == CHAIN_CONTEXT_STRUCT)
                {
                    bit_field = true;
                }
                else if (class == CHAIN_CLASS_ASSIGN && top == CHAIN_CONTEXT_TOP)
                {
                    ineligible = true;
                }
                if (class == CHAIN_CLASS_STAR || class == CHAIN_CLASS_SEMI || class == CHAIN_CLASS_COMMA || class == CHAIN_CLASS_ASSIGN)
                {
                    pending = 0;
                }
            }
            plain = plain && (class == CHAIN_CLASS_STRUCT || class == CHAIN_CLASS_ENUM || (flags & CHAIN_FLAG_EXTENSION) != 0);
            previous_class = class;
            previous_flags = word ? flags : 0;
        }
        ineligible |= !is_typedef && object_declarator && !is_extern;
        eligible = !ineligible;
        // The lists, in the dump's order: lookups, names, tags.
        memmove(out + lookup_count, declared, 4ull * declared_count);
        memmove(out + lookup_count + declared_count, tags, 8ull * tag_count);
        row->lookups = lookup_count;
        row->names = declared_count;
        row->tags = tag_count;
        written = lookup_count + declared_count + 2 * tag_count;
    }
    // Every name it spells.
    uint32_t spelled = 0;
    for (uint32_t i = 0; i < count; i += 1)
    {
        const uint32_t name = names[i];
        if (kinds[i] == CHAIN_KIND_NAME && state->seen_spelled[name] != stamp)
        {
            state->seen_spelled[name] = stamp;
            out[written + spelled] = name;
            spelled += 1;
        }
    }
    row->spelled = spelled;
    row->flags = (source->flags & (CHAIN_DEFINITION | CHAIN_PRAGMA)) | (eligible ? CHAIN_ELIGIBLE : 0);
    return written + spelled;
}

static void chain_scan(State* state, const Unit* unit, bool check)
{
    const uint64_t start = __rdtsc();
    uint32_t offset = 0;
    for (uint32_t d = 0; d < unit->declarations; d += 1)
    {
        Declaration* row = &state->scan_table[d];
        const uint32_t words = chain_scan_declaration(state, unit, &unit->table[d], row, state->scan_lists + offset);
        row->offset = offset;
        offset += words;
    }
    state->ticks[4] += __rdtsc() - start;
    for (uint32_t d = 0; check && d < unit->declarations; d += 1)
    {
        const Declaration* mine = &state->scan_table[d];
        const Declaration* theirs = &unit->table[d];
        const uint32_t words = mine->lookups + mine->names + 2 * mine->tags + mine->spelled;
        const bool same = mine->flags == theirs->flags && mine->lookups == theirs->lookups && mine->names == theirs->names && mine->tags == theirs->tags &&
                          mine->spelled == theirs->spelled && memcmp(state->scan_lists + mine->offset, unit->lists + theirs->offset, 4ull * words) == 0;
        state->mismatches += !same;
    }
}

static void chain_unit(State* state, const Unit* unit, const Declaration* table, const uint32_t* lists)
{
    const uint32_t count = unit->declarations;
    uint64_t start = __rdtsc();
    // A. Each declaration's own hash.
    for (uint32_t d = 0; d < count; d += 1)
    {
        state->local[d] = chain_local(unit->kinds + table[d].first, unit->names + table[d].first, table[d].count);
    }
    uint64_t now = __rdtsc();
    state->ticks[0] += now - start;
    start = now;
    // B. The chain, in source order.
    state->stamp += 1;
    state->slots = 0;
    state->key_count = 0;
    uint64_t ambient = 0;
    for (uint32_t d = 0; d < count; d += 1)
    {
        const Declaration* declaration = &table[d];
        const uint32_t* list = lists + declaration->offset;
        const uint32_t* names = list + declaration->lookups;
        const uint32_t* tags = names + declaration->names;
        const uint32_t* spelled = tags + 2 * declaration->tags;
        uint64_t hash = chain_mix(state->local[d], ambient);
        bool eligible = (declaration->flags & CHAIN_ELIGIBLE) != 0;
        state->keys_first[d] = state->key_count;
        if ((declaration->flags & CHAIN_PRAGMA) != 0)
        {
            ambient = hash;
            hash = 0;
        }
        else if ((declaration->flags & CHAIN_DEFINITION) != 0)
        {
            // Every name the definition spells is its to change.
            for (uint32_t s = 0; s < declaration->spelled; s += 1)
            {
                hash = chain_mix(hash, chain_get(state, 2 * spelled[s]));
                hash = chain_mix(hash, chain_get(state, 2 * spelled[s] + 1));
            }
            for (uint32_t s = 0; s < declaration->spelled; s += 1)
            {
                chain_declare(state, 2 * spelled[s], hash, d);
                chain_declare(state, 2 * spelled[s] + 1, hash, d);
            }
        }
        else
        {
            for (uint32_t l = 0; l < declaration->lookups; l += 1)
            {
                hash = chain_mix(hash, chain_get(state, 2 * list[l]));
            }
            for (uint32_t n = 0; n < declaration->names; n += 1)
            {
                hash = chain_mix(hash, chain_get(state, 2 * names[n]));
            }
            for (uint32_t t = 0; t < declaration->tags; t += 1)
            {
                hash = chain_mix(hash, chain_get(state, 2 * tags[2 * t] + 1));
            }
            for (uint32_t n = 0; n < declaration->names; n += 1)
            {
                chain_declare(state, 2 * names[n], hash, d);
            }
            for (uint32_t t = 0; t < declaration->tags; t += 1)
            {
                const uint32_t key = 2 * tags[2 * t] + 1;
                const bool present = state->name_stamp[key] == state->stamp;
                const bool declares = (tags[2 * t + 1] & 1) != 0 || !present;
                // A tag first declared in a parameter list: clang warns of it.
                eligible = eligible && !((tags[2 * t + 1] & 1) == 0 && (tags[2 * t + 1] & 2) != 0 && !present);
                if (declares)
                {
                    chain_declare(state, key, hash, d);
                }
            }
        }
        state->hash[d] = hash;
        state->eligible[d] = eligible;
        state->hit[d] = eligible && chain_memo_has(state, hash);
    }
    state->keys_first[count] = state->key_count;
    now = __rdtsc();
    state->ticks[1] += now - start;
    start = now;
    // C. The reach. Nothing to do in a unit without a hit: every declaration is a root. A name's declarers are a list
    // in source order with two cursors: one rises from its first declarer as declarations that spell the name are
    // reached (all of its declarers before the last of those are reached), one falls from its last declarer as
    // declarations that declare it are reached (all of its declarers after the first of those are). Each cursor passes
    // a declarer once, so the reach is linear in the unit's lists.
    uint32_t pending = 0;
    uint32_t hits = 0;
    for (uint32_t d = 0; d < count; d += 1)
    {
        state->reached[d] = !state->hit[d];
        state->work[pending] = d;
        pending += !state->hit[d];
        hits += state->hit[d];
    }
    pending = hits != 0 ? pending : 0;
    while (pending != 0)
    {
        pending -= 1;
        const uint32_t d = state->work[pending];
        const Declaration* declaration = &table[d];
        const uint32_t* spelled = lists + declaration->offset + declaration->lookups + declaration->names + 2 * declaration->tags;
        for (uint32_t s = 0; s < declaration->spelled; s += 1)
        {
            for (uint32_t space = 0; space < 2; space += 1)
            {
                const uint32_t key = 2 * spelled[s] + space;
                if (state->name_stamp[key] == state->stamp)
                {
                    uint32_t slot = state->name_rising[key];
                    while (slot != 0 && state->slot_declaration[slot] < d)
                    {
                        const uint32_t other = state->slot_declaration[slot];
                        if (!state->reached[other])
                        {
                            state->reached[other] = 1;
                            state->work[pending] = other;
                            pending += 1;
                        }
                        slot = state->slot_next[slot];
                    }
                    state->name_rising[key] = slot;
                }
            }
        }
        for (uint32_t k = state->keys_first[d]; k < state->keys_first[d + 1]; k += 1)
        {
            const uint32_t key = state->keys[k];
            uint32_t slot = state->name_falling[key];
            while (slot != 0 && state->slot_declaration[slot] > d)
            {
                const uint32_t other = state->slot_declaration[slot];
                if (!state->reached[other])
                {
                    state->reached[other] = 1;
                    state->work[pending] = other;
                    pending += 1;
                }
                slot = state->slot_previous[slot];
            }
            state->name_falling[key] = slot;
        }
    }
    now = __rdtsc();
    state->ticks[2] += now - start;
    start = now;
    // D. The skipped declarations' tokens, and the memo.
    memset(state->ignored, 0, unit->tokens);
    for (uint32_t d = 0; d < count; d += 1)
    {
        if (!state->reached[d])
        {
            memset(state->ignored + table[d].first, 1, table[d].count);
            state->skipped_tokens += table[d].count;
            state->skipped_declarations += 1;
        }
        state->hits += state->hit[d];
        state->misses += state->eligible[d] && !state->hit[d];
    }
    for (uint32_t d = 0; d < count; d += 1)
    {
        if (state->eligible[d])
        {
            chain_memo_add(state, state->hash[d]);
        }
    }
    state->ticks[3] += __rdtsc() - start;
}

static int chain_counter(uint64_t config)
{
    struct perf_event_attr attribute = { 0 };
    attribute.type = PERF_TYPE_HARDWARE;
    attribute.size = sizeof(attribute);
    attribute.config = config;
    attribute.exclude_kernel = 1;
    attribute.exclude_hv = 1;
    attribute.disabled = 1;
    return (int)syscall(SYS_perf_event_open, &attribute, 0, -1, -1, 0);
}

static int chain_compare(const void* a, const void* b)
{
    const uint64_t x = *(const uint64_t*)a;
    const uint64_t y = *(const uint64_t*)b;
    return x < y ? -1 : x > y;
}

int main(int argc, char** argv)
{
    int result = 1;
    const bool warm = argc > 1 && strcmp(argv[1], "--warm") == 0;
    argc -= warm;
    argv += warm;
    const bool check = argc > 1 && strcmp(argv[1], "--check") == 0;
    const bool scan = check || (argc > 1 && strcmp(argv[1], "--scan") == 0);
    argc -= scan;
    argv += scan;
    const int repetitions = argc > 2 ? atoi(argv[2]) : 21;
    const int file = argc > 1 ? open(argv[1], O_RDONLY) : -1;
    struct stat status = { 0 };
    if (file < 0 || fstat(file, &status) != 0 || repetitions < 1 || repetitions > 1000)
    {
        fprintf(stderr, "usage: chain [--warm] [--scan | --check] DUMP.bin [REPETITIONS]\n");
    }
    else
    {
        const uint8_t* bytes = mmap(NULL, (size_t)status.st_size, PROT_READ, MAP_PRIVATE | MAP_POPULATE, file, 0);
        const uint32_t* header = (const uint32_t*)bytes;
        const uint32_t unit_count = header[1];
        const uint32_t spellings = header[2];
        Unit* units = calloc(unit_count, sizeof(Unit));
        const uint32_t class_bytes = (spellings + 3) & ~3u;
        const uint8_t* at = bytes + 12 + 2ull * class_bytes;
        uint32_t most_declarations = 0;
        uint32_t most_tokens = 0;
        uint32_t most_words = 0;
        uint64_t tokens = 0;
        uint64_t declarations = 0;
        uint64_t file_scope_tokens = 0;
        for (uint32_t u = 0; u < unit_count; u += 1)
        {
            const uint32_t* words = (const uint32_t*)at;
            Unit* unit = &units[u];
            unit->declarations = words[0];
            unit->tokens = words[1];
            unit->list_words = words[2];
            at += 12;
            unit->kinds = at;
            at += (unit->tokens + 3) & ~3u;
            unit->names = (const uint32_t*)at;
            at += 4ull * unit->tokens;
            unit->table = (const Declaration*)at;
            at += sizeof(Declaration) * unit->declarations;
            unit->lists = (const uint32_t*)at;
            at += 4ull * unit->list_words;
            most_declarations = unit->declarations > most_declarations ? unit->declarations : most_declarations;
            most_tokens = unit->tokens > most_tokens ? unit->tokens : most_tokens;
            most_words = unit->list_words > most_words ? unit->list_words : most_words;
            tokens += unit->tokens;
            declarations += unit->declarations;
            for (uint32_t d = 0; d < unit->declarations; d += 1)
            {
                file_scope_tokens += (unit->table[d].flags & CHAIN_DEFINITION) == 0 ? unit->table[d].count : 0;
            }
        }
        State state = { 0 };
        state.name_hash = calloc(2ull * spellings, sizeof(uint64_t));
        state.name_stamp = calloc(2ull * spellings, sizeof(uint32_t));
        state.name_head = calloc(2ull * spellings, sizeof(uint32_t));
        state.name_rising = calloc(2ull * spellings, sizeof(uint32_t));
        state.name_falling = calloc(2ull * spellings, sizeof(uint32_t));
        state.slot_next = calloc(2ull * most_words + 2, sizeof(uint32_t));
        state.slot_declaration = calloc(2ull * most_words + 2, sizeof(uint32_t));
        state.slot_previous = calloc(2ull * most_words + 2, sizeof(uint32_t));
        state.keys = calloc(2ull * most_words + 2, sizeof(uint32_t));
        state.local = calloc(most_declarations + 1, sizeof(uint64_t));
        state.hash = calloc(most_declarations + 1, sizeof(uint64_t));
        state.hit = calloc(most_declarations + 1, 1);
        state.eligible = calloc(most_declarations + 1, 1);
        state.keys_first = calloc(most_declarations + 2, sizeof(uint32_t));
        state.reached = calloc(most_declarations + 1, 1);
        state.work = calloc(most_declarations + 1, sizeof(uint32_t));
        state.ignored = calloc(most_tokens + 1, 1);
        state.memo = calloc(CHAIN_MEMO_SLOTS, sizeof(uint64_t));
        state.classes = bytes + 12;
        state.flags = bytes + 12 + class_bytes;
        state.scan_table = calloc(most_declarations + 1, sizeof(Declaration));
        state.scan_lists = calloc(4ull * most_tokens + most_words + 16, sizeof(uint32_t));
        state.seen_lookup = calloc(spellings, sizeof(uint32_t));
        state.seen_name = calloc(spellings, sizeof(uint32_t));
        state.seen_spelled = calloc(spellings, sizeof(uint32_t));
        const int cycles = chain_counter(PERF_COUNT_HW_CPU_CYCLES);
        const int instructions = chain_counter(PERF_COUNT_HW_INSTRUCTIONS);
        uint64_t* run_cycles = calloc((size_t)repetitions, sizeof(uint64_t));
        uint64_t* run_instructions = calloc((size_t)repetitions, sizeof(uint64_t));
        uint64_t ticks[CHAIN_PHASES] = { 0 };
        for (uint32_t u = 0; warm && u < unit_count; u += 1)
        {
            if (scan)
            {
                chain_scan(&state, &units[u], false);
                chain_unit(&state, &units[u], state.scan_table, state.scan_lists);
            }
            else
            {
                chain_unit(&state, &units[u], units[u].table, units[u].lists);
            }
        }
        for (int r = 0; r < repetitions; r += 1)
        {
            if (!warm)
            {
                memset(state.memo, 0, CHAIN_MEMO_SLOTS * sizeof(uint64_t));
                state.memo_count = 0;
            }
            state.skipped_tokens = 0;
            state.skipped_declarations = 0;
            state.hits = 0;
            state.misses = 0;
            memset(state.ticks, 0, sizeof(state.ticks));
            ioctl(cycles, PERF_EVENT_IOC_RESET, 0);
            ioctl(instructions, PERF_EVENT_IOC_RESET, 0);
            ioctl(cycles, PERF_EVENT_IOC_ENABLE, 0);
            ioctl(instructions, PERF_EVENT_IOC_ENABLE, 0);
            for (uint32_t u = 0; u < unit_count; u += 1)
            {
                if (scan)
                {
                    chain_scan(&state, &units[u], check);
                    chain_unit(&state, &units[u], state.scan_table, state.scan_lists);
                }
                else
                {
                    chain_unit(&state, &units[u], units[u].table, units[u].lists);
                }
            }
            ioctl(cycles, PERF_EVENT_IOC_DISABLE, 0);
            ioctl(instructions, PERF_EVENT_IOC_DISABLE, 0);
            if (read(cycles, &run_cycles[r], 8) != 8 || read(instructions, &run_instructions[r], 8) != 8)
            {
                run_cycles[r] = 0;
                run_instructions[r] = 0;
            }
            for (uint32_t p = 0; p < CHAIN_PHASES; p += 1)
            {
                ticks[p] += state.ticks[p];
            }
        }
        qsort(run_cycles, (size_t)repetitions, sizeof(uint64_t), chain_compare);
        qsort(run_instructions, (size_t)repetitions, sizeof(uint64_t), chain_compare);
        const uint64_t median_cycles = run_cycles[repetitions / 2];
        const uint64_t median_instructions = run_instructions[repetitions / 2];
        const uint64_t all_ticks = ticks[0] + ticks[1] + ticks[2] + ticks[3] + ticks[4];
        printf("units\t%u\n", unit_count);
        printf("spellings\t%u\n", spellings);
        printf("tokens\t%llu\n", (unsigned long long)tokens);
        printf("tokens outside function definitions\t%llu\n", (unsigned long long)file_scope_tokens);
        printf("declarations\t%llu\n", (unsigned long long)declarations);
        printf("declarations skipped\t%llu\n", (unsigned long long)state.skipped_declarations);
        printf("tokens skipped\t%llu\n", (unsigned long long)state.skipped_tokens);
        printf("eligible hits\t%llu\n", (unsigned long long)state.hits);
        printf("eligible misses\t%llu\n", (unsigned long long)state.misses);
        printf("memo entries\t%u\n", state.memo_count);
        printf("repetitions\t%d\n", repetitions);
        printf("user cycles a run, median (least, most)\t%llu\t%llu\t%llu\n", (unsigned long long)median_cycles, (unsigned long long)run_cycles[0],
               (unsigned long long)run_cycles[repetitions - 1]);
        printf("user instructions a run, median\t%llu\n", (unsigned long long)median_instructions);
        printf("cycles a token\t%.2f\n", (double)median_cycles / (double)tokens);
        printf("instructions a token\t%.2f\n", (double)median_instructions / (double)tokens);
        printf("cycles a declaration\t%.1f\n", (double)median_cycles / (double)declarations);
        const char* const names[CHAIN_PHASES] = { "A own hashes", "B chain and memo probes", "C reach", "D marks and memo adds", "S scan" };
        printf("memo\t%s\n", warm ? "warm" : "empty at each run's start");
        printf("lists\t%s\n", check ? "the scan's, compared with the dump's" : scan ? "the scan's" : "the dump's");
        if (check)
        {
            printf("declarations whose lists differ from the dump's, all runs\t%llu\n", (unsigned long long)state.mismatches);
        }
        for (uint32_t p = 0; p < CHAIN_PHASES; p += 1)
        {
            printf("share of the time, %s\t%.1f%%\t%.2f cycles a token\n", names[p], 100.0 * (double)ticks[p] / (double)all_ticks,
                   (double)median_cycles / (double)tokens * (double)ticks[p] / (double)all_ticks);
        }
        result = 0;
    }
    return result;
}
