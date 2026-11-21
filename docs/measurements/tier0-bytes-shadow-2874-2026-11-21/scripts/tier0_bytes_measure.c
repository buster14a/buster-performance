// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// #2874's step 4, its first piece in the shadow (measure-tier0-bytes): Tier 0's back half on bytes. After Tier 0's own
// front (the labels, the values, fusion, the depths, selection, the homes and the frame), today's back half measures
// each entry in records, expands its template into records, chooses its immediates' forms, and branch sizing and the
// encoder then measure the records again and encode them. Here an entry's bytes come from its shape: the template, the
// hole block's bytes its records' registers and modes read, its immediate's value classes (x86_choice_have's) and its
// displacements' sizes. A shape's bytes are the encoder's, made at its first use from that entry's own records (expanded,
// their form chosen, encoded, as today's path makes them), with the hole block's bytes that land in an immediate or a
// displacement found by encoding the records again with marked values; every later entry of the shape copies them and
// takes its own values' bytes, with one vpermb of its hole block. Positions are a prefix sum of bytes, and branch
// sizing's own rounds run on the branches' byte positions, with no records and no x86_measure. Deferred entries (calls,
// copies, a division whose registers are taken), the prologue and the epilogue are records as today, encoded at their
// places.
//
//   build/compiler measure-tier0-bytes [--passes N] [preprocessor options] file... [--next [preprocessor options] file...]...
//
// The functions are the ones -c lowers (measure-tier0-entries' and benchmark-backend-source's). Each is compiled by
// Tier 0's front twice, untimed, and then by today's back half (measuring, emission, the forms, branch sizing and the
// encoder: the reference) and by the shadow's, each timed in TSC ticks; the two must give the same bytes and the same
// fixups (each fixup's end, kind, field and target), or the command fails. A function the piece doesn't take (the memory
// classes, vectors and masks, segment overrides, deep values, asm bodies, tail calls, eh_return, setjmp's snapshots,
// probes, interrupt and preserving frames, deferred entries with branches) is listed by why. The shapes' cache lives for
// the command: a shape's first use is counted and timed apart from the passes, which read every shape made. It is a
// measurement outside the compile path. Include after tier0_entries_measure.c.
#ifndef BUSTER_TIER0_BYTES_MEASURE_INCLUDED
#define BUSTER_TIER0_BYTES_MEASURE_INCLUDED

// The shapes' cache: slots of an open-addressed table of line indices, and the lines.
#define BUSTER_TIER0_BYTES_SLOT_BITS 15
#define BUSTER_TIER0_BYTES_SLOTS (UINT32_C(1) << BUSTER_TIER0_BYTES_SLOT_BITS)
#define BUSTER_TIER0_BYTES_LINES (UINT32_C(1) << 14)
#define BUSTER_TIER0_BYTES_NONE UINT32_MAX
// A shape's key: the template, the value classes and the displacements' sizes in its first word, then the hole block's
// bytes its records' registers and modes read.
#define BUSTER_TIER0_BYTES_KEY_WORDS 5
// The bytes a function's code may take past its end: whole 64-byte stores of a line.
#define BUSTER_TIER0_BYTES_SLACK 128
// The passes the timing takes the median of.
#define BUSTER_TIER0_BYTES_PASSES 5
// Why a function isn't taken.
#define BUSTER_TIER0_BYTES_REFUSALS 12

static const char* const tier0_bytes_refusal_names[BUSTER_TIER0_BYTES_REFUSALS] = {
    "taken",          "tier0-refuses",  "memory-classes", "vectors-or-masks", "segments", "deep-values",
    "asm-bodies",     "tail-calls",     "eh-return",      "snapshots",        "probes",   "deferred-branches",
};

// What the shadow reads of a template besides Tier 0's tables: the hole block's bytes its records' registers, modes and
// forms read (its shape's), and each record's displacement's first hole (0xff: none, its displacement is the template's).
typedef struct Tier0BytesTemplate Tier0BytesTemplate;
struct Tier0BytesTemplate
{
    uint32_t shape_holes;
    uint8_t displacement_hole[BUSTER_TIER0_TEMPLATE_RECORDS];
};

// A shape's line: its bytes with its values' bytes zero, each byte's hole in the hole block (or none), then its key,
// which bytes take a hole, its length, its branch's displacement's end and size (0: no branch) with its growth if it's
// short, and its fixup's end (0: none): three cache lines, the last read first.
typedef struct Tier0BytesLine Tier0BytesLine;
struct Tier0BytesLine
{
    _Alignas(64) uint8_t bytes[64];
    uint8_t holes[64];
    uint64_t key[BUSTER_TIER0_BYTES_KEY_WORDS];
    uint64_t mask;
    uint8_t length;
    uint8_t branch_end;
    uint8_t branch_bytes;
    uint8_t branch_growth;
    uint8_t fixup_end;
    uint8_t padding[11];
};
_Static_assert(sizeof(Tier0BytesLine) == 192, "a line is three cache lines");

// A slot of the shapes' table: its key's hash (0: empty), its line, and what pass A and pass B read of the line beside
// its bytes: its length, its branch's displacement's end and growth (0: none), its fixup's end (0: none).
typedef struct Tier0BytesSlot Tier0BytesSlot;
struct Tier0BytesSlot
{
    uint64_t hash;
    uint32_t line;
    uint8_t length;
    uint8_t branch_end;
    uint8_t branch_growth;
    uint8_t fixup_end;
};
_Static_assert(sizeof(Tier0BytesSlot) == 16, "four slots a cache line");

// A packed line: its 32 bytes with its values' bytes zero, then each byte's hole in the hole block (0xff: none). A shape
// past 32 bytes isn't taken.
typedef struct Tier0BytesPacked Tier0BytesPacked;
struct Tier0BytesPacked
{
    _Alignas(64) uint8_t bytes[32];
    uint8_t holes[32];
};

typedef struct Tier0BytesCache Tier0BytesCache;
struct Tier0BytesCache
{
    Tier0BytesSlot* slots;
    Tier0BytesPacked* packed;
    Tier0BytesLine* lines;
    uint32_t line_count;
    // The first uses: how many, and their ticks; and the shapes the cache had no room for, or whose values' bytes aren't
    // the hole block's (refused: the function is then counted as a failure).
    uint64_t first_uses;
    uint64_t first_ticks;
    uint64_t unshaped;
};

// A function's fixup in bytes: its field's end, its kind and field, its target.
typedef struct Tier0BytesFixup Tier0BytesFixup;
struct Tier0BytesFixup
{
    uint32_t end;
    uint8_t kind;
    uint8_t field;
    uint32_t target;
    // Its entry, whose growth before it moves it (the prologue's and the epilogue's: the count's place, 0 and count).
    uint32_t entry;
};

// A branch of the shadow's: its entry, its target entry (the count for the function's end), its short displacement's
// end in the entry, its growth if long, and its entry's hole block for its long shape.
typedef struct Tier0BytesBranch Tier0BytesBranch;
struct Tier0BytesBranch
{
    uint32_t entry;
    uint32_t target;
    uint8_t end;
    uint8_t growth;
    uint64_t key0;
    uint8_t holes[32];
};

// Tier 0's front for one function: its columns, its frame, its homes and references, its prologue's records, and
// whether the piece takes it.
typedef struct Tier0BytesFront Tier0BytesFront;
struct Tier0BytesFront
{
    Tier0Entries entries;
    Tier0Bits bits;
    Tier0Frame frame;
    Tier0Home* homes;
    uint32_t* references;
    uint32_t prologue;
    uint32_t refusal;
};

static Tier0BytesTemplate tier0_bytes_templates[BUSTER_TIER0_TEMPLATE_CAPACITY];
// Each template's shape holes, as a column the blocks gather from; and each choice row's info (x86_choice_row_info's) as
// a quadword, for the value classes (x86_choice_classes).
static uint32_t tier0_bytes_shape_holes[BUSTER_TIER0_TEMPLATE_CAPACITY];
static uint32_t tier0_bytes_fixup_info[BUSTER_TIER0_TEMPLATE_CAPACITY];
static uint64_t tier0_bytes_row_info[64];
// An experiment's switch (BUSTER_TIER0_BYTES_FAKE): the lookups replaced by a direct index, for the floor of the rest.
static bool tier0_bytes_fake;

// Each template's shape holes and displacements' holes, from its compiled records: a hole in a record's immediate (its
// bytes 0 to 3) or displacement (4 to 7) is a value's; any other is the shape's.
static void tier0_bytes_templates_build(void)
{
    for (uint32_t t = 0; t < tier0_template_count; t += 1)
    {
        const Tier0TemplateInfo* info = &tier0_template_infos[t];
        Tier0BytesTemplate* shape = &tier0_bytes_templates[t];
        shape->shape_holes = 0;
        for (uint32_t r = 0; r < BUSTER_TIER0_TEMPLATE_RECORDS; r += 1)
        {
            shape->displacement_hole[r] = 0xff;
        }
        for (uint32_t b = 0; b < 16u * info->length; b += 1)
        {
            const bool hole = ((info->mask >> b) & 1) != 0;
            const uint32_t field = b % 16;
            const uint32_t index = tier0_compiled[t].bytes[b] & 31;
            if (hole && field >= 8)
            {
                shape->shape_holes |= UINT32_C(1) << index;
            }
            if (hole && field == 4)
            {
                shape->displacement_hole[b / 16] = (uint8_t)index;
            }
        }
        tier0_bytes_shape_holes[t] = shape->shape_holes;
        tier0_bytes_fixup_info[t] = (uint32_t)info->fixup_kind | (uint32_t)info->fixup_field << 8;
    }
    for (uint32_t row = 0; row < 64; row += 1)
    {
        tier0_bytes_row_info[row] = x86_choice_row_info[row];
    }
}

static bool tier0_bytes_cache_begin(Tier0BytesCache* cache)
{
    memset(cache, 0, sizeof(*cache));
    cache->slots = aligned_alloc(64, sizeof(Tier0BytesSlot) * BUSTER_TIER0_BYTES_SLOTS);
    cache->packed = aligned_alloc(64, sizeof(Tier0BytesPacked) * BUSTER_TIER0_BYTES_LINES);
    cache->lines = aligned_alloc(64, sizeof(Tier0BytesLine));
    const bool valid = cache->slots != 0 && cache->packed != 0 && cache->lines != 0;
    if (valid)
    {
        memset(cache->slots, 0, sizeof(Tier0BytesSlot) * BUSTER_TIER0_BYTES_SLOTS);
    }
    return valid;
}

static void tier0_bytes_cache_end(Tier0BytesCache* cache)
{
    free(cache->slots);
    free(cache->packed);
    free(cache->lines);
}

// ---------------------------------------------------------------------------------------------------------------------
// The front: tier0_compile_entries' passes and tier0_generate's selection, homes and frame, as they run there, with the
// piece's refusals.

static void tier0_bytes_front(const Tier0Function* function, Arena* arena, Tier0BytesFront* front)
{
    memset(front, 0, sizeof(*front));
    Tier0Entries* entries = &front->entries;
    Tier0Bits* bits = &front->bits;
    const uint32_t count = function->count;
    const uint32_t blocks = (count + 63) / 64;
    bits->blocks = blocks;
    uint64_t** columns[] = { &bits->fits, &bits->count, &bits->zero, &bits->size, &bits->product, &bits->same, &bits->sib, &bits->sequential, &bits->labels, &bits->leaf,
                             &bits->home_const, &bits->one, &bits->two, &bits->rmw };
    bool pushed = tier0_push_entries(entries, arena, count);
    const uint64_t words = (uint64_t)blocks + 2;
    uint64_t* column_words = BUSTER_ARENA_PUSH_ARRAY(arena, uint64_t, words * BUSTER_ARRAY_LENGTH(columns));
    pushed = pushed && column_words != 0;
    if (column_words != 0)
    {
        memset(column_words, 0, words * BUSTER_ARRAY_LENGTH(columns) * sizeof(uint64_t));
        for (uint32_t c = 0; c < BUSTER_ARRAY_LENGTH(columns); c += 1)
        {
            *columns[c] = column_words + words * c;
        }
    }
    bits->sib_log2 = BUSTER_ARENA_PUSH_ARRAY(arena, uint8_t, (uint64_t)blocks * 64 + 64);
    uint32_t refusal = pushed && bits->sib_log2 != 0 ? 0 : 1;
    refusal = refusal == 0 && (function->x87 || function->int128) ? 2 : refusal;
    refusal = refusal == 0 && (function->vectors || function->masks) ? 3 : refusal;
    refusal = refusal == 0 && function->segments ? 4 : refusal;
    refusal = refusal == 0 && function->asm_body_count != 0 ? 6 : refusal;
    refusal = refusal == 0 && function->call_tails != 0 ? 7 : refusal;
    refusal = refusal == 0 && function->eh_return ? 8 : refusal;
    refusal = refusal == 0 && (function->returns_twice || function->calls_returns_twice) ? 9 : refusal;
    refusal = refusal == 0 && function->probe_stack ? 10 : refusal;
    Tier0Frame* frame = &front->frame;
    if (refusal == 0)
    {
        tier0_vector_labels(function, bits->labels);
        entries->labels = bits->labels;
        tier0_vector_values(function, bits);
        tier0_vector_fuse(function, bits, entries);
        tier0_vector_depths(function, bits, entries);
        frame->probe = function->probe_stack;
        Tier0Error error = tier0_frame_input_valid(function) ? TIER0_OK : TIER0_ERROR_UNSUPPORTED;
        frame->alignment_log2 = error == TIER0_OK ? (uint8_t)tier0_frame_alignment_vector(function) : 0;
        const uint32_t unsupported = error == TIER0_OK ? tier0_select_vector(function, entries, frame, &error) : count;
        refusal = error == TIER0_ERROR_DEPTH ? 5 : error != TIER0_OK || unsupported != count ? 1 : 0;
    }
    if (refusal == 0)
    {
        frame->memory = tier0_memory_function(function);
        frame->memory_slots = function->x87 || function->int128;
        frame->vectors = false;
        frame->x87_result = false;
        frame->masks = false;
        frame->mask_slots = 0;
        refusal = frame->memory ? 2 : 0;
    }
    const uint32_t locals = function->local_count;
    front->homes = BUSTER_ARENA_PUSH_ARRAY(arena, Tier0Home, locals + 1);
    front->references = BUSTER_ARENA_PUSH_ARRAY(arena, uint32_t, locals + 1);
    refusal = refusal == 0 && (front->homes == 0 || front->references == 0) ? 1 : refusal;
    if (refusal == 0)
    {
        uint32_t order[2 * BUSTER_TIER0_HOME_CANDIDATES];
        tier0_count_references_vector(function, front->references);
        refusal = entries->direct != 0 ? 6 : 0;
        frame->object_parameters = tier0_object_parameters(function);
        tier0_assign_homes(function, frame, front->homes, front->references, order, true);
        refusal = refusal == 0 && !tier0_layout_frame(function, frame, front->homes, front->references, true) ? 1 : refusal;
    }
    if (refusal == 0)
    {
        entries->tail_finish = 0;
        entries->eh_finish = 0;
        entries->snapshot_words = frame->snapshot_depths != 0 ? frame->snapshot_masks / (8 * frame->snapshot_depths) : 0;
        entries->snapshot_depths = frame->snapshot_depths;
        entries->snapshot = frame->snapshot_bytes != 0;
        refusal = entries->snapshot ? 9 : 0;
        refusal = refusal == 0 && (frame->preserved || frame->interrupt != 0) ? 8 : refusal;
        refusal = refusal == 0 && tier0_prologue_branches(frame) != 0 ? 10 : refusal;
        front->prologue = refusal == 0 ? tier0_count_prologue(function, frame, front->homes, front->references) : 0;
    }
    front->refusal = refusal;
}

// ---------------------------------------------------------------------------------------------------------------------
// The reference: tier0_generate's back half as it runs there (measuring, the output's room, emission, the forms), then
// branch sizing and the encoder as the emission runs them. Returns the code's length, or -1.

static int64_t tier0_bytes_reference(const Tier0Function* function, Tier0BytesFront* front, Arena* arena, uint8_t* bytes, uint64_t capacity, Tier0Code* code,
                                     uint32_t** fixup_ends)
{
    Tier0Entries* entries = &front->entries;
    const Tier0Frame* frame = &front->frame;
    memset(code, 0, sizeof(*code));
    Tier0Counts counts = tier0_measure_vector(function, entries, front->homes, front->prologue, frame->memory);
    const uint32_t epilogue = tier0_count_epilogue(function, frame);
    counts.branches += tier0_prologue_branches(frame);
    Tier0Choices choices;
    memset(&choices, 0, sizeof(choices));
    choices.records = BUSTER_ARENA_PUSH_ARRAY(arena, uint32_t, counts.choices + 8);
    choices.rows = BUSTER_ARENA_PUSH_ARRAY(arena, uint16_t, counts.choices + 8);
    choices.values = BUSTER_ARENA_PUSH_ARRAY(arena, int64_t, counts.choices + 8);
    choices.contexts = BUSTER_ARENA_PUSH_ARRAY(arena, uint16_t, counts.choices + 8);
    choices.forms = BUSTER_ARENA_PUSH_ARRAY(arena, uint16_t, counts.choices + 8);
    bool valid = choices.records != 0 && choices.rows != 0 && choices.values != 0 && choices.contexts != 0 && choices.forms != 0 &&
                 tier0_push_output(code, arena, entries->record_count + epilogue, counts, 0, function->count);
    int64_t length = -1;
    if (valid)
    {
        tier0_emit_vector(function, entries, frame, front->homes, front->references, code, &choices);
        x86_choose_forms(choices.rows, choices.values, choices.contexts, choices.count, choices.forms);
        tier0_apply_choices_vector(code->records, &choices);
        uint32_t* offsets = BUSTER_ARENA_PUSH_ARRAY(arena, uint32_t, (uint64_t)code->count + 1);
        *fixup_ends = BUSTER_ARENA_PUSH_ARRAY(arena, uint32_t, BUSTER_X86_ENCODER_FIXUP_CAPACITY(code->reference_count));
        valid = offsets != 0 && *fixup_ends != 0;
        const BranchSizingCheck shape = valid ? branch_sizing_validate_branches(code->records, code->count, code->branches, code->targets, code->branch_count)
                                              : (BranchSizingCheck){ .error = BRANCH_SIZING_ERROR_MEMORY };
        const BranchSizing sizing = shape.error == BRANCH_SIZING_OK ? size_branches(code->records, code->count, code->branches, code->targets, code->branch_count, offsets)
                                                                    : (BranchSizing){ .error = shape.error };
        length = sizing.error == BRANCH_SIZING_OK ? x86_encode(code->records, code->count, bytes, capacity, 0, *fixup_ends) : -1;
    }
    return length;
}

// ---------------------------------------------------------------------------------------------------------------------
// Shapes

// A displacement's size: 0 for none, 1 for 8 bits, 2 for 32.
static uint32_t tier0_bytes_displacement_size(int32_t displacement)
{
    return displacement == 0 ? 0 : displacement >= -128 && displacement <= 127 ? 1 : 2;
}

// A shape's records, as today's path makes them: the template expanded from `block` (the entry's hole block, or a copy
// with its value bytes marked), its form chosen for the entry's own values (`holes`: the constant's, or 0 for a static
// choice's, as tier0_emit_vector's requests have it) and applied with `block`'s, and its branch in its long form (its
// rel8 form's next) if `long_branch`. Returns the template's record count.
static uint32_t tier0_bytes_records(uint32_t t, const uint8_t* block, const uint8_t* holes, bool long_branch, X86Instruction* records)
{
    const Tier0TemplateInfo* info = &tier0_template_infos[t];
    const __m512i compiled = _mm512_load_si512(tier0_compiled[t].bytes);
    const __m512i bytes = _mm512_castsi256_si512(_mm256_loadu_si256((const __m256i*)block));
    _mm512_storeu_si512(records, _mm512_mask_blend_epi8(info->mask, compiled, _mm512_permutexvar_epi8(compiled, bytes)));
    if (info->choice != 0xff)
    {
        int64_t own = 0;
        int64_t marked = 0;
        memcpy(&own, holes, sizeof(own));
        memcpy(&marked, block, sizeof(marked));
        const int64_t value = info->choice_static != 0 ? 0 : own;
        const int64_t applied = info->choice_static != 0 ? 0 : marked;
        const uint16_t row = info->choice_row;
        const uint16_t context = tier0_choice_context(&records[info->choice], info->choice_live);
        uint16_t form = 0;
        x86_choose_forms(&row, &value, &context, 1, &form);
        tier0_apply_choice(&records[info->choice], form, applied);
    }
    if (long_branch && info->branch != 0xff)
    {
        records[info->branch].form = (uint16_t)(records[info->branch].form + 1);
    }
    return info->length;
}

// A shape's line, made at its first use from entry's hole block: the records encoded, then again with two sets of marked
// values (the hole block's value bytes, each displacement kept in its size), and each byte that differs mapped to the
// hole byte whose two marks it holds. Returns false where a value's byte isn't a hole byte's (the cache refuses the shape).
static bool tier0_bytes_line_build(uint32_t t, const uint8_t* holes, bool long_branch, Tier0BytesLine* line)
{
    const Tier0TemplateInfo* info = &tier0_template_infos[t];
    const Tier0BytesTemplate* shape = &tier0_bytes_templates[t];
    X86Instruction records[BUSTER_TIER0_TEMPLATE_RECORDS];
    uint8_t first[BUSTER_X86_ENCODER_CAPACITY(BUSTER_TIER0_TEMPLATE_RECORDS) + 64];
    uint8_t second[BUSTER_X86_ENCODER_CAPACITY(BUSTER_TIER0_TEMPLATE_RECORDS) + 64];
    uint8_t third[BUSTER_X86_ENCODER_CAPACITY(BUSTER_TIER0_TEMPLATE_RECORDS) + 64];
    uint32_t offsets[BUSTER_TIER0_TEMPLATE_RECORDS + 1];
    uint32_t fixups[BUSTER_X86_ENCODER_FIXUP_CAPACITY(1)];
    const uint32_t count = tier0_bytes_records(t, holes, holes, long_branch, records);
    const int64_t length = x86_encode(records, count, first, sizeof(first), offsets, fixups);
    // The marks: hole byte h is 0x40 + h, then 0x60 + h, but a displacement of 8 bits keeps its byte's mark and three
    // bytes of zero, and one of none stays 0.
    uint8_t marks[2][32];
    for (uint32_t h = 0; h < 32; h += 1)
    {
        marks[0][h] = (uint8_t)(0x40 + h);
        marks[1][h] = (uint8_t)(0x60 + h);
    }
    uint32_t shape_bytes = shape->shape_holes;
    for (uint32_t r = 0; r < count; r += 1)
    {
        const uint32_t hole = shape->displacement_hole[r];
        int32_t displacement = 0;
        if (hole != 0xff && hole + 4 <= 32)
        {
            memcpy(&displacement, holes + hole, sizeof(displacement));
        }
        const uint32_t size = hole != 0xff ? tier0_bytes_displacement_size(displacement) : 2;
        for (uint32_t set = 0; set < 2 && hole != 0xff && hole + 4 <= 32; set += 1)
        {
            for (uint32_t b = size == 2 ? 4 : size == 1 ? 1 : 0; b < 4; b += 1)
            {
                marks[set][hole + b] = 0;
            }
            if (size == 0)
            {
                marks[set][hole] = 0;
            }
        }
    }
    // The shape's own bytes keep their values in both marked sets.
    for (uint32_t h = 0; h < 32; h += 1)
    {
        if (((shape_bytes >> h) & 1) != 0)
        {
            marks[0][h] = holes[h];
            marks[1][h] = holes[h];
        }
    }
    X86Instruction marked_records[BUSTER_TIER0_TEMPLATE_RECORDS];
    tier0_bytes_records(t, marks[0], holes, long_branch, marked_records);
    uint32_t marked_fixups[BUSTER_X86_ENCODER_FIXUP_CAPACITY(1)];
    const int64_t length_a = x86_encode(marked_records, count, second, sizeof(second), 0, marked_fixups);
    tier0_bytes_records(t, marks[1], holes, long_branch, marked_records);
    const int64_t length_b = x86_encode(marked_records, count, third, sizeof(third), 0, marked_fixups);
    bool valid = length >= 0 && length <= 64 && length_a == length && length_b == length;
    memset(line, 0, sizeof(*line));
    for (int64_t b = 0; valid && b < length; b += 1)
    {
        const bool differs = second[b] != third[b];
        const uint32_t h = (uint32_t)second[b] - 0x40;
        const bool mapped = differs && second[b] >= 0x40 && second[b] < 0x60 && third[b] == (uint8_t)(0x60 + h);
        valid = !differs || mapped;
        line->bytes[b] = differs ? 0 : first[b];
        line->holes[b] = differs ? (uint8_t)h : 0;
        line->mask |= differs ? UINT64_C(1) << b : 0;
    }
    // The bytes with the entry's own values must be the encoder's: the line read back with its hole block.
    for (int64_t b = 0; valid && b < length; b += 1)
    {
        const uint8_t made = ((line->mask >> b) & 1) != 0 ? holes[line->holes[b]] : line->bytes[b];
        valid = made == first[b];
    }
    if (!valid && getenv("BUSTER_TIER0_BYTES_DEBUG") != NULL)
    {
        fprintf(stderr, "tier0-bytes: unshaped template=%u records=%u choice=%u branch=%u fixup=%u length=%" PRId64 "/%" PRId64 "/%" PRId64 " shape_holes=%08x\n", t, info->length,
                info->choice, info->branch, info->fixup, length, length_a, length_b, shape->shape_holes);
        for (int64_t b = 0; b < length && b < 64; b += 1)
        {
            fprintf(stderr, " %02x/%02x/%02x", first[b], second[b], third[b]);
        }
        fprintf(stderr, "\n holes:");
        for (uint32_t h = 0; h < 32; h += 1)
        {
            fprintf(stderr, " %02x", holes[h]);
        }
        fprintf(stderr, "\n");
        for (uint32_t r = 0; r < count; r += 1)
        {
            fprintf(stderr, " record %u: form=%u reg=%u rm=%u index=%u mode=%u imm=%d disp=%d\n", r, records[r].form, records[r].reg, records[r].rm, records[r].index,
                    records[r].mode, records[r].immediate, records[r].displacement);
        }
    }
    line->length = valid ? (uint8_t)length : 0;
    if (valid && info->branch != 0xff)
    {
        // The branch is the template's last record: its displacement ends the line, the encoder's 0 there.
        line->branch_end = (uint8_t)length;
        line->branch_bytes = long_branch ? 4 : 1;
        const uint32_t form = (records[info->branch].form & ~BUSTER_X86_FORM_FIXUP) - (long_branch ? 1u : 0u);
        line->branch_growth = (uint8_t)(form == X86_FORM_JMP_REL8 ? BUSTER_BRANCH_SIZING_JMP_GROWTH : BUSTER_BRANCH_SIZING_JCC_GROWTH);
        valid = info->branch + 1 == count;
    }
    if (valid && info->fixup != 0xff)
    {
        line->fixup_end = (uint8_t)fixups[0];
    }
    return valid;
}

// The first words of 8 entries' keys: the template, the value classes of a constant a choice reads (x86_choice_classes,
// for the dynamic choices), and the sizes of the three displacements a hole block can give (the constant's low dword,
// A's and B's), 2 bits each.
static __m512i tier0_bytes_key0(__m512i word, __m512i k, __m512i a, __m512i b)
{
    const __m512i template = _mm512_and_si512(word, _mm512_set1_epi64((int64_t)BUSTER_TIER0_WORD_TEMPLATE));
    const __mmask8 dynamic = _mm512_test_epi64_mask(word, _mm512_set1_epi64((int64_t)BUSTER_TIER0_WORD_CHOICE)) &
                             _mm512_testn_epi64_mask(word, _mm512_set1_epi64((int64_t)BUSTER_TIER0_WORD_CHOICE_STATIC));
    const __m512i row = _mm512_srli_epi64(word, BUSTER_TIER0_WORD_ROW_SHIFT);
    const __m512i info = _mm512_mask_i64gather_epi64(_mm512_setzero_si512(), dynamic, row, tier0_bytes_row_info, 8);
    const __m512i classes = _mm512_maskz_and_epi64(dynamic, x86_choice_classes(k, info), _mm512_set1_epi64(0xffff));
    const __m512i small = _mm512_set1_epi64(128);
    const __m512i span = _mm512_set1_epi64(256);
    const __m512i k32 = _mm512_srai_epi64(_mm512_slli_epi64(k, 32), 32);
    const __m512i a32 = _mm512_srai_epi64(_mm512_slli_epi64(a, 32), 32);
    const __m512i b32 = _mm512_srai_epi64(_mm512_slli_epi64(b, 32), 32);
    // A size: 0 for none, 1 for 8 bits, 2 for 32 (tier0_bytes_displacement_size's).
    const __m512i one = _mm512_set1_epi64(1);
    const __m512i two = _mm512_set1_epi64(2);
    __m512i sizes = _mm512_maskz_mov_epi64(_mm512_test_epi64_mask(k32, k32), _mm512_mask_blend_epi64(_mm512_cmplt_epu64_mask(_mm512_add_epi64(k32, small), span), two, one));
    const __m512i a_size = _mm512_maskz_mov_epi64(_mm512_test_epi64_mask(a32, a32), _mm512_mask_blend_epi64(_mm512_cmplt_epu64_mask(_mm512_add_epi64(a32, small), span), two, one));
    const __m512i b_size = _mm512_maskz_mov_epi64(_mm512_test_epi64_mask(b32, b32), _mm512_mask_blend_epi64(_mm512_cmplt_epu64_mask(_mm512_add_epi64(b32, small), span), two, one));
    sizes = _mm512_or_si512(sizes, _mm512_or_si512(_mm512_slli_epi64(a_size, 2), _mm512_slli_epi64(b_size, 4)));
    return _mm512_or_si512(template, _mm512_or_si512(_mm512_slli_epi64(classes, 16), _mm512_slli_epi64(sizes, 32)));
}

// A key's hash: its words' products with odd constants, folded.
static uint64_t tier0_bytes_hash(uint64_t key0, __m256i shaped)
{
    const __m256i products = _mm256_mullo_epi64(shaped, _mm256_setr_epi64x((int64_t)0x9e3779b97f4a7c15ull, (int64_t)0xc2b2ae3d27d4eb4full, (int64_t)0x165667b19e3779f9ull,
                                                                           (int64_t)0xd6e8feb86659fd93ull));
    const __m128i folded = _mm_xor_si128(_mm256_castsi256_si128(products), _mm256_extracti128_si256(products, 1));
    uint64_t hash = (uint64_t)_mm_cvtsi128_si64(folded) ^ (uint64_t)_mm_extract_epi64(folded, 1) ^ key0 * 0xff51afd7ed558ccdull;
    hash ^= hash >> 31;
    hash *= 0x94d049bb133111ebull;
    return hash ^ (hash >> 29);
}

// A key's slot, made at its first use (tier0_bytes_line_build) where the table has none: the probe compares the key's
// 64-bit hash, and the shadow's comparison with today's bytes checks every entry it takes. BUSTER_TIER0_BYTES_NONE where
// the cache can't take the shape (no room, a shape past 32 bytes, values' bytes that aren't the hole block's).
static uint32_t tier0_bytes_shape(Tier0BytesCache* cache, uint64_t key0, __m256i block, const uint8_t* holes, bool long_branch)
{
    const uint32_t t = (uint32_t)(key0 & BUSTER_TIER0_WORD_TEMPLATE);
    const __m256i shaped = _mm256_maskz_mov_epi8(tier0_bytes_shape_holes[t], block);
    const uint64_t hash = tier0_bytes_hash(key0, shaped) | 1;
    uint32_t at = (uint32_t)(hash >> (64 - BUSTER_TIER0_BYTES_SLOT_BITS));
    uint32_t found = BUSTER_TIER0_BYTES_NONE;
    bool searching = true;
    while (searching)
    {
        const uint64_t stored = cache->slots[at].hash;
        const bool same = stored == hash;
        found = same ? at : found;
        searching = stored != 0 && !same;
        at = searching ? (at + 1) & (BUSTER_TIER0_BYTES_SLOTS - 1) : at;
    }
    if (found == BUSTER_TIER0_BYTES_NONE)
    {
        const uint64_t start = __rdtsc();
        const uint32_t index = cache->line_count;
        Tier0BytesLine* line = cache->lines;
        const bool built = index < BUSTER_TIER0_BYTES_LINES && tier0_bytes_line_build(t, holes, long_branch, line) && line->length <= 32;
        if (built)
        {
            Tier0BytesPacked* packed = &cache->packed[index];
            for (uint32_t b = 0; b < 32; b += 1)
            {
                const bool hole = ((line->mask >> b) & 1) != 0;
                packed->bytes[b] = b < line->length ? line->bytes[b] : 0;
                packed->holes[b] = hole ? line->holes[b] : 0xff;
            }
            cache->slots[at] = (Tier0BytesSlot){
                .hash = hash,
                .line = index,
                .length = line->length,
                .branch_end = line->branch_end,
                .branch_growth = line->branch_growth,
                .fixup_end = line->fixup_end,
            };
            cache->line_count += 1;
            found = at;
        }
        else
        {
            cache->unshaped += 1;
        }
        cache->first_uses += 1;
        cache->first_ticks += __rdtsc() - start;
    }
    return found;
}

// A shape's bytes at `output`, with its values' bytes from its hole block: 32 bytes stored, a vpermb's.
static inline void tier0_bytes_expand(const Tier0BytesPacked* packed, const uint8_t* holes, uint8_t* output)
{
    const __m256i bytes = _mm256_load_si256((const __m256i*)packed->bytes);
    const __m256i indices = _mm256_load_si256((const __m256i*)packed->holes);
    const __m256i block = _mm256_loadu_si256((const __m256i*)holes);
    const __mmask32 filled = _mm256_cmpneq_epi8_mask(indices, _mm256_set1_epi8((char)0xff));
    _mm256_storeu_si256((__m256i*)output, _mm256_mask_permutexvar_epi8(bytes, filled, indices, block));
}

// ---------------------------------------------------------------------------------------------------------------------
// The shadow's back half. Returns the code's length (-1 on a failure, with `refusal` set where it's the piece's).

typedef struct Tier0BytesWork Tier0BytesWork;
struct Tier0BytesWork
{
    uint32_t* positions;
    uint32_t* growth;
    // Pass A's: each entry's hole block, its line (or none), its length, and a deferred entry's bytes' place in `side`
    // with its fixups (`side_fixups`, from `side_fixup_first`).
    uint8_t* hole_blocks;
    uint64_t* keys;
    uint64_t* metas;
    uint32_t* branch_entries;
    uint32_t* branch_targets;
    uint32_t* branch_ends;
    uint32_t* branch_growths;
    uint32_t* delta;
    int32_t* displacements;
    uint32_t* line_of;
    uint32_t* lengths;
    uint32_t* side_offset;
    uint32_t* side_fixup_first;
    uint32_t* side_fixup_end;
    uint8_t* side;
    Tier0BytesFixup* side_fixups;
    uint32_t side_fixup_count;
    Tier0BytesBranch* branches;
    uint32_t branch_count;
    Tier0BytesFixup* fixups;
    uint32_t fixup_count;
    uint8_t* tentative;
    // A deferred entry's, the prologue's and the epilogue's records, references, branches and requests.
    X86Instruction* records;
    LinkReference* links;
    uint32_t* writer_branches;
    uint32_t* writer_targets;
    Tier0Choices choices;
    uint32_t* offsets;
    uint32_t* fixup_ends;
};

#define BUSTER_TIER0_BYTES_WRITER_RECORDS 4096
// The shadow's laps (a diagnostic): the prologue, pass A, the prefix sum, pass B, the epilogue, sizing, the final copy.
#define BUSTER_TIER0_BYTES_LAPS 8
static uint64_t tier0_bytes_laps[BUSTER_TIER0_BYTES_LAPS];
static uint64_t tier0_bytes_lap_last;
static inline void tier0_bytes_lap(uint32_t lap)
{
    const uint64_t now = __rdtsc();
    tier0_bytes_laps[lap] += now - tier0_bytes_lap_last;
    tier0_bytes_lap_last = now;
}

// Records a writer made (the prologue, a deferred entry, the epilogue), their forms chosen, encoded at `at`; their
// references become fixups. Returns their length, or -1 (with `branched` where they have a branch).
static int64_t tier0_bytes_writer_encode(Tier0BytesWork* work, const Tier0Writer* writer, uint8_t* output, uint32_t at, uint32_t entry, Tier0BytesFixup* fixups,
                                         uint32_t* fixup_count, bool* branched)
{
    Tier0Choices* choices = &work->choices;
    if (choices->count != 0)
    {
        x86_choose_forms(choices->rows, choices->values, choices->contexts, choices->count, choices->forms);
        tier0_apply_choices_vector(writer->records, choices);
    }
    *branched = *branched || writer->branch_count != 0;
    const int64_t length = writer->branch_count != 0 ? -1 : x86_encode(writer->records, writer->count, output + at, BUSTER_X86_ENCODER_CAPACITY(writer->count), 0, work->fixup_ends);
    for (uint32_t k = 0; length >= 0 && k < writer->reference_count; k += 1)
    {
        const LinkReference* link = &writer->references[k];
        fixups[(*fixup_count)++] = (Tier0BytesFixup){
            .end = at + work->fixup_ends[k],
            .kind = link->kind,
            .field = link->field,
            .target = link->target,
            .entry = entry,
        };
    }
    return length;
}

static Tier0Writer tier0_bytes_writer(Tier0BytesWork* work, const Tier0Frame* frame)
{
    work->choices.count = 0;
    Tier0Writer writer = { work->records, 0, work->links, 0, work->writer_branches, work->writer_targets, 0, &work->choices, 0, frame->interrupt != 0, frame->temporaries, 0 };
    return writer;
}

static int64_t tier0_bytes_back(const Tier0Function* function, Tier0BytesFront* front, Tier0BytesCache* cache, Tier0BytesWork* work, uint8_t* output, uint32_t* refusal,
                                uint64_t* deferred_ticks)
{
    const uint32_t count = function->count;
    Tier0Entries* entries = &front->entries;
    const Tier0Frame* frame = &front->frame;
    const Tier0Home* homes = front->homes;
    const uint64_t* values = function->values;
    uint64_t* words = entries->words;
    const uint8_t* depths = entries->depths;
    const uint8_t* floating_depths = entries->floating_depths;
    uint32_t* positions = work->positions;
    uint8_t* tentative = work->tentative;
    work->branch_count = 0;
    work->fixup_count = 0;
    bool valid = true;
    bool branched = false;
    tier0_bytes_lap_last = __rdtsc();
    // The prologue.
    Tier0Writer writer = tier0_bytes_writer(work, frame);
    tier0_emit_prologue(function, frame, homes, front->references, &writer);
    const int64_t prologue = tier0_bytes_writer_encode(work, &writer, tentative, 0, 0, work->fixups, &work->fixup_count, &branched);
    valid = prologue >= 0;
    uint32_t at = valid ? (uint32_t)prologue : 0;
    tier0_bytes_lap(0);
    // The homes' cases (tier0_measure_vector's), the hole blocks (tier0_emit_vector's), each entry's bytes at its position.
    const Tier0HomeTable table = tier0_home_table(homes, function->local_count);
    const __m512i seven = _mm512_set1_epi64(7);
    const __m512i zero = _mm512_setzero_si512();
    const __m512i one = _mm512_set1_epi64(1);
    const __m512i is_register = _mm512_set1_epi64((int64_t)(0xffull << (8 * offsetof(Tier0Home, is_register))));
    const __m512i integer_low = _mm512_load_si512(tier0_integer_window);
    const __m512i integer_high = _mm512_load_si512(tier0_integer_window + 16);
    const __m512i floating_low = _mm512_load_si512(tier0_floating_window);
    const __m512i floating_high = _mm512_load_si512(tier0_floating_window + 16);
    const __m512i interleave_low = _mm512_set_epi64(11, 3, 10, 2, 9, 1, 8, 0);
    const __m512i interleave_high = _mm512_set_epi64(15, 7, 14, 6, 13, 5, 12, 4);
    const __m512i pair_low = _mm512_set_epi64(11, 10, 3, 2, 9, 8, 1, 0);
    const __m512i pair_high = _mm512_set_epi64(15, 14, 7, 6, 13, 12, 5, 4);
    __m512i previous = zero;
    // Pass A: each entry's hole block, its line found (made at its first use) or a deferred entry's records encoded aside,
    // and its length; no position yet, so that no lookup waits for the one before.
    uint8_t* hole_blocks = work->hole_blocks;
    uint32_t* lengths = work->lengths;
    uint32_t side_at = 0;
    work->side_fixup_count = 0;
    for (uint32_t first = 0; valid && first < count; first += 8)
    {
        const __mmask8 lanes = (__mmask8)tier0_lanes(first, count);
        const __m512i current = _mm512_maskz_loadu_epi64(lanes, values + first);
        __m512i word = _mm512_maskz_loadu_epi64(lanes, words + first);
        // The homes' cases.
        const __mmask8 dependent = _mm512_test_epi64_mask(word, _mm512_set1_epi64((int64_t)BUSTER_TIER0_WORD_HOME_DEPENDENT)) &
                                   _mm512_testn_epi64_mask(word, _mm512_set1_epi64((int64_t)BUSTER_TIER0_WORD_DEFERRED));
        const __m512i a_offset = _mm512_and_si512(_mm512_srli_epi64(word, BUSTER_TIER0_WORD_A_SHIFT), seven);
        const __m512i b_offset = _mm512_and_si512(_mm512_srli_epi64(word, BUSTER_TIER0_WORD_B_SHIFT), seven);
        const __mmask8 a_valid = lanes & _mm512_cmpneq_epi64_mask(a_offset, seven);
        const __mmask8 b_valid = lanes & _mm512_cmpneq_epi64_mask(b_offset, seven);
        const __m512i a_local = tier0_value_back(previous, current, a_offset);
        const __m512i b_local = tier0_value_back(previous, current, b_offset);
        const __m512i a = tier0_home_lookup(&table, a_local, a_valid);
        const __m512i b = tier0_home_lookup(&table, b_local, b_valid);
        const __mmask8 a_register = dependent & a_valid & _mm512_test_epi64_mask(a, is_register);
        const __mmask8 b_register = dependent & b_valid & _mm512_test_epi64_mask(b, is_register);
        __m512i cases = _mm512_maskz_mov_epi64(a_register, one);
        cases = _mm512_mask_add_epi64(cases, b_register, cases, _mm512_set1_epi64(2));
        const __mmask8 uniform = dependent & _mm512_test_epi64_mask(word, _mm512_set1_epi64((int64_t)BUSTER_TIER0_WORD_HOME_UNIFORM));
        const __mmask8 gathered = dependent & ~uniform;
        word = _mm512_mask_add_epi64(word, uniform, word, cases);
        if (gathered != 0)
        {
            const __m512i index = _mm512_add_epi64(_mm512_and_si512(word, _mm512_set1_epi64((int64_t)BUSTER_TIER0_WORD_TEMPLATE)), cases);
            word = _mm512_mask_i64gather_epi64(word, gathered, index, tier0_template_words, 8);
        }
        word = _mm512_mask_andnot_epi64(word, dependent, _mm512_set1_epi64((int64_t)(BUSTER_TIER0_WORD_HOME_DEPENDENT | BUSTER_TIER0_WORD_HOME_UNIFORM)), word);
        _mm512_mask_storeu_epi64(words + first, lanes, word);
        // The hole blocks, as emission makes them, each entry's 32 bytes in its place.
        const __m512i k_offset = _mm512_and_si512(_mm512_srli_epi64(word, BUSTER_TIER0_WORD_K_SHIFT), seven);
        const __m512i k_scale = _mm512_and_si512(_mm512_srli_epi64(word, BUSTER_TIER0_WORD_K_SCALE_SHIFT), seven);
        const __m512i a_offset2 = _mm512_and_si512(_mm512_srli_epi64(word, BUSTER_TIER0_WORD_A_SHIFT), seven);
        const __m512i b_offset2 = _mm512_and_si512(_mm512_srli_epi64(word, BUSTER_TIER0_WORD_B_SHIFT), seven);
        const __m512i k_value = _mm512_maskz_mov_epi64(_mm512_cmpneq_epi64_mask(k_offset, seven), tier0_value_back(previous, current, k_offset));
        const __m512i scale = _mm512_mask_mov_epi64(one, _mm512_cmpneq_epi64_mask(k_scale, seven), tier0_value_back(previous, current, k_scale));
        const __m512i k = _mm512_mullo_epi64(k_value, scale);
        const __m512i a_home = tier0_home_lookup(&table, tier0_value_back(previous, current, a_offset2), lanes & _mm512_cmpneq_epi64_mask(a_offset2, seven));
        const __m512i b_home = tier0_home_lookup(&table, tier0_value_back(previous, current, b_offset2), lanes & _mm512_cmpneq_epi64_mask(b_offset2, seven));
        const __m512i depth = _mm512_cvtepu8_epi32(_mm_maskz_loadu_epi8(lanes, depths + first));
        const __m512i floating = _mm512_cvtepu8_epi32(_mm_maskz_loadu_epi8(lanes, floating_depths + first));
        const __m512i integer_window = _mm512_permutex2var_epi32(integer_low, depth, integer_high);
        const __m512i floating_window = _mm512_permutex2var_epi32(floating_low, floating, floating_high);
        const __m512i registers = _mm512_or_si512(_mm512_cvtepu32_epi64(_mm512_castsi512_si256(integer_window)),
                                                  _mm512_slli_epi64(_mm512_cvtepu32_epi64(_mm512_castsi512_si256(floating_window)), 24));
        const __m512i ka_low = _mm512_permutex2var_epi64(k, interleave_low, a_home);
        const __m512i ka_high = _mm512_permutex2var_epi64(k, interleave_high, a_home);
        const __m512i br_low = _mm512_permutex2var_epi64(b_home, interleave_low, registers);
        const __m512i br_high = _mm512_permutex2var_epi64(b_home, interleave_high, registers);
        uint8_t* blocks = hole_blocks + (uint64_t)first * 32;
        const __m512i pair0 = _mm512_permutex2var_epi64(ka_low, pair_low, br_low);
        const __m512i pair1 = _mm512_permutex2var_epi64(ka_low, pair_high, br_low);
        const __m512i pair2 = _mm512_permutex2var_epi64(ka_high, pair_low, br_high);
        const __m512i pair3 = _mm512_permutex2var_epi64(ka_high, pair_high, br_high);
        _mm512_store_si512(blocks + 0, pair0);
        _mm512_store_si512(blocks + 64, pair1);
        _mm512_store_si512(blocks + 128, pair2);
        _mm512_store_si512(blocks + 192, pair3);
        // The 8 keys: their first words, the shaped hole blocks (each pair's two entries by their templates' shape
        // holes), and the hashes (tier0_bytes_hash's, lane by lane).
        const __m512i key0 = tier0_bytes_key0(word, k, a_home, b_home);
        _mm512_storeu_si512(work->keys + first, key0);
        const __mmask8 deferred = lanes & _mm512_test_epi64_mask(word, _mm512_set1_epi64((int64_t)BUSTER_TIER0_WORD_DEFERRED));
        const __mmask8 shaped_lanes = lanes & _mm512_testn_epi64_mask(word, _mm512_set1_epi64((int64_t)(BUSTER_TIER0_WORD_DEFERRED | BUSTER_TIER0_WORD_ABSORBED)));
        const __m256i template = _mm512_cvtepi64_epi32(_mm512_and_si512(word, _mm512_set1_epi64((int64_t)BUSTER_TIER0_WORD_TEMPLATE)));
        const __m256i masks = _mm256_mmask_i32gather_epi32(_mm256_setzero_si256(), shaped_lanes, template, (const int*)tier0_bytes_shape_holes, 4);
        const __m512i wide = _mm512_cvtepu32_epi64(masks);
        const __m512i pairs = _mm512_or_si512(_mm512_permutexvar_epi64(_mm512_setr_epi64(0, 2, 4, 6, 0, 0, 0, 0), wide),
                                              _mm512_slli_epi64(_mm512_permutexvar_epi64(_mm512_setr_epi64(1, 3, 5, 7, 0, 0, 0, 0), wide), 32));
        _Alignas(64) uint64_t pair_masks[8];
        _mm512_store_si512(pair_masks, pairs);
        const __m512i constants = _mm512_setr_epi64((int64_t)0x9e3779b97f4a7c15ull, (int64_t)0xc2b2ae3d27d4eb4full, (int64_t)0x165667b19e3779f9ull,
                                                    (int64_t)0xd6e8feb86659fd93ull, (int64_t)0x9e3779b97f4a7c15ull, (int64_t)0xc2b2ae3d27d4eb4full,
                                                    (int64_t)0x165667b19e3779f9ull, (int64_t)0xd6e8feb86659fd93ull);
        const __m512i swap_halves = _mm512_setr_epi64(2, 3, 0, 1, 6, 7, 4, 5);
        const __m512i swap_pairs = _mm512_setr_epi64(1, 0, 3, 2, 5, 4, 7, 6);
        __m512i folds[4];
        const __m512i pair_vectors[4] = { pair0, pair1, pair2, pair3 };
        for (uint32_t p = 0; p < 4; p += 1)
        {
            const __m512i products = _mm512_mullo_epi64(_mm512_maskz_mov_epi8(pair_masks[p], pair_vectors[p]), constants);
            const __m512i half = _mm512_xor_si512(products, _mm512_permutexvar_epi64(swap_halves, products));
            folds[p] = _mm512_xor_si512(half, _mm512_permutexvar_epi64(swap_pairs, half));
        }
        const __m512i low = _mm512_permutex2var_epi64(folds[0], _mm512_setr_epi64(0, 4, 8, 12, 0, 0, 0, 0), folds[1]);
        const __m512i high = _mm512_permutex2var_epi64(folds[2], _mm512_setr_epi64(0, 4, 8, 12, 0, 0, 0, 0), folds[3]);
        __m512i hash = _mm512_xor_si512(_mm512_permutex2var_epi64(low, _mm512_setr_epi64(0, 1, 2, 3, 8, 9, 10, 11), high),
                                        _mm512_mullo_epi64(key0, _mm512_set1_epi64((int64_t)0xff51afd7ed558ccdull)));
        hash = _mm512_xor_si512(hash, _mm512_srli_epi64(hash, 31));
        hash = _mm512_mullo_epi64(hash, _mm512_set1_epi64((int64_t)0x94d049bb133111ebull));
        hash = _mm512_or_si512(_mm512_xor_si512(hash, _mm512_srli_epi64(hash, 29)), one);
        // The slots: their hashes and metadata gathered, a hit where the hash is the key's.
        if (tier0_bytes_fake)
        {
            hash = _mm512_and_si512(word, _mm512_set1_epi64((int64_t)BUSTER_TIER0_WORD_TEMPLATE));
        }
        const __m512i slot = _mm512_srli_epi64(hash, 64 - BUSTER_TIER0_BYTES_SLOT_BITS);
        const __m512i stored = _mm512_mask_i64gather_epi64(zero, shaped_lanes, _mm512_slli_epi64(slot, 1), (const long long*)cache->slots, 8);
        const __mmask8 hit = shaped_lanes & _mm512_cmpeq_epi64_mask(stored, hash);
        __m512i meta = _mm512_mask_i64gather_epi64(_mm512_set1_epi64((int64_t)BUSTER_TIER0_BYTES_NONE), hit,
                                                   _mm512_add_epi64(_mm512_slli_epi64(slot, 1), one), (const long long*)cache->slots, 8);
        if (tier0_bytes_fake)
        {
            meta = _mm512_or_si512(_mm512_and_si512(word, _mm512_set1_epi64(1023)), _mm512_set1_epi64(INT64_C(4) << 32));
        }
        _Alignas(64) uint64_t lane_meta[8];
        _mm512_store_si512(lane_meta, meta);
        // The misses (a shape's first use, a probe past its first slot) and the deferred entries, a lane at a time.
        uint32_t rest = (uint32_t)((shaped_lanes & ~(tier0_bytes_fake ? shaped_lanes : hit)) | deferred);
        while (valid && rest != 0)
        {
            const uint32_t lane = (uint32_t)__builtin_ctz(rest);
            rest &= rest - 1;
            const uint32_t i = first + lane;
            if (((deferred >> lane) & 1) != 0)
            {
                const uint64_t start = __rdtsc();
                Tier0Writer writer_deferred = tier0_bytes_writer(work, frame);
                tier0_emit_deferred(function, entries, frame, homes, i, &writer_deferred);
                work->side_offset[i] = side_at;
                work->side_fixup_first[i] = work->side_fixup_count;
                const int64_t encoded = tier0_bytes_writer_encode(work, &writer_deferred, work->side, side_at, i, work->side_fixups, &work->side_fixup_count, &branched);
                work->side_fixup_end[i] = work->side_fixup_count;
                valid = encoded >= 0;
                const uint32_t length = valid ? (uint32_t)encoded : 0;
                side_at += length;
                lane_meta[lane] = (uint64_t)BUSTER_TIER0_BYTES_NONE | (uint64_t)length << 32;
                *deferred_ticks += __rdtsc() - start;
            }
            else
            {
                const __m512i pair = _mm512_load_si512(blocks + 64 * (lane >> 1));
                const __m256i block = (lane & 1) != 0 ? _mm512_extracti64x4_epi64(pair, 1) : _mm512_castsi512_si256(pair);
                uint64_t key = 0;
                memcpy(&key, (const uint8_t*)(work->keys + i), sizeof(key));
                const uint32_t found = tier0_bytes_shape(cache, key, block, blocks + 32 * lane, false);
                valid = found != BUSTER_TIER0_BYTES_NONE;
                uint64_t words2[2] = { 0, 0 };
                memcpy(words2, &cache->slots[valid ? found : 0], sizeof(words2));
                lane_meta[lane] = words2[1];
            }
        }
        // Each entry's meta (its line, its length, its branch's end and growth, its fixup's end; an absorbed entry's
        // length 0 and no line) and length.
        meta = _mm512_mask_mov_epi64(_mm512_set1_epi64((int64_t)BUSTER_TIER0_BYTES_NONE), shaped_lanes | deferred, _mm512_load_si512(lane_meta));
        _mm512_mask_storeu_epi64(work->metas + first, lanes, meta);
        _mm256_mask_storeu_epi32(lengths + first, lanes, _mm512_cvtepi64_epi32(_mm512_and_si512(_mm512_srli_epi64(meta, 32), _mm512_set1_epi64(0xff))));
        previous = current;
    }
    tier0_bytes_lap(1);
    // The positions: the lengths' prefix sum after the prologue, 16 entries at a time.
    uint32_t carry = at;
    for (uint32_t first = 0; valid && first < count; first += 16)
    {
        const __mmask16 lanes = (__mmask16)(count - first >= 16 ? 0xffffu : (1u << (count - first)) - 1);
        const __m512i length = _mm512_maskz_loadu_epi32(lanes, lengths + first);
        __m512i sum = _mm512_add_epi32(length, _mm512_maskz_permutexvar_epi32(0xfffe, _mm512_setr_epi32(0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14), length));
        sum = _mm512_add_epi32(sum, _mm512_maskz_permutexvar_epi32(0xfffc, _mm512_setr_epi32(0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13), sum));
        sum = _mm512_add_epi32(sum, _mm512_maskz_permutexvar_epi32(0xfff0, _mm512_setr_epi32(0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11), sum));
        sum = _mm512_add_epi32(sum, _mm512_maskz_permutexvar_epi32(0xff00, _mm512_setr_epi32(0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7), sum));
        _mm512_mask_storeu_epi32(positions + first, lanes, _mm512_add_epi32(_mm512_set1_epi32((int32_t)carry), _mm512_sub_epi32(sum, length)));
        carry += (uint32_t)_mm_cvtsi128_si32(_mm512_castsi512_si128(_mm512_permutexvar_epi32(_mm512_set1_epi32(15), sum)));
    }
    at = carry;
    tier0_bytes_lap(2);
    // Pass B: each shape's bytes at its entry's position (one 32-byte store; the stores after it write over what runs
    // past it), the branches compressed into their columns, then a block's fixups and deferred entries a lane at a time.
    uint32_t branch_count = 0;
    for (uint32_t first = 0; valid && first < count; first += 8)
    {
        const __mmask8 lanes = (__mmask8)tier0_lanes(first, count);
        const __m512i meta = _mm512_maskz_loadu_epi64(lanes, work->metas + first);
        const __m256i position = _mm256_maskz_loadu_epi32(lanes, positions + first);
        _Alignas(64) uint64_t lane_meta[8];
        _mm512_store_si512(lane_meta, meta);
        _Alignas(32) uint32_t lane_position[8];
        _mm256_store_si256((__m256i*)lane_position, position);
        const __mmask8 shaped = lanes & _mm512_cmpneq_epi64_mask(_mm512_and_si512(meta, _mm512_set1_epi64(0xffffffff)), _mm512_set1_epi64(BUSTER_TIER0_BYTES_NONE));
        uint32_t todo = shaped;
        while (todo != 0)
        {
            const uint32_t lane = (uint32_t)__builtin_ctz(todo);
            todo &= todo - 1;
            tier0_bytes_expand(&cache->packed[(uint32_t)lane_meta[lane]], hole_blocks + (uint64_t)(first + lane) * 32, tentative + lane_position[lane]);
        }
        const __m512i word = _mm512_maskz_loadu_epi64(lanes, words + first);
        const __m512i value = _mm512_maskz_loadu_epi64(lanes, values + first);
        const __mmask8 branch = shaped & _mm512_test_epi64_mask(meta, _mm512_set1_epi64((int64_t)(UINT64_C(0xff) << 40)));
        const __mmask8 end_branch = _mm512_test_epi64_mask(word, _mm512_set1_epi64((int64_t)BUSTER_TIER0_WORD_END));
        const __m256i target = _mm512_cvtepi64_epi32(_mm512_mask_mov_epi64(_mm512_and_si512(value, _mm512_set1_epi64(0xffffffff)), end_branch, _mm512_set1_epi64(count)));
        const __m256i index = _mm256_add_epi32(_mm256_set1_epi32((int32_t)first), _mm256_setr_epi32(0, 1, 2, 3, 4, 5, 6, 7));
        _mm256_storeu_si256((__m256i*)(work->branch_entries + branch_count), _mm256_maskz_compress_epi32(branch, index));
        _mm256_storeu_si256((__m256i*)(work->branch_targets + branch_count), _mm256_maskz_compress_epi32(branch, target));
        _mm256_storeu_si256((__m256i*)(work->branch_ends + branch_count),
                            _mm256_maskz_compress_epi32(branch, _mm512_cvtepi64_epi32(_mm512_and_si512(_mm512_srli_epi64(meta, 40), _mm512_set1_epi64(0xff)))));
        _mm256_storeu_si256((__m256i*)(work->branch_growths + branch_count),
                            _mm256_maskz_compress_epi32(branch, _mm512_cvtepi64_epi32(_mm512_and_si512(_mm512_srli_epi64(meta, 48), _mm512_set1_epi64(0xff)))));
        branch_count += (uint32_t)__builtin_popcount(branch);
        const __mmask8 fixup = shaped & _mm512_test_epi64_mask(meta, _mm512_set1_epi64((int64_t)(UINT64_C(0xff) << 56)));
        const __mmask8 deferred = lanes & _mm512_test_epi64_mask(word, _mm512_set1_epi64((int64_t)BUSTER_TIER0_WORD_DEFERRED));
        uint32_t rest = (uint32_t)(fixup | deferred);
        while (rest != 0)
        {
            const uint32_t lane = (uint32_t)__builtin_ctz(rest);
            rest &= rest - 1;
            const uint32_t i = first + lane;
            if (((deferred >> lane) & 1) != 0)
            {
                const uint32_t offset = work->side_offset[i];
                memcpy(tentative + lane_position[lane], work->side + offset, lengths[i]);
                for (uint32_t f = work->side_fixup_first[i]; f < work->side_fixup_end[i]; f += 1)
                {
                    Tier0BytesFixup moved = work->side_fixups[f];
                    moved.end = moved.end - offset + lane_position[lane];
                    work->fixups[work->fixup_count++] = moved;
                }
            }
            else
            {
                const uint32_t info = tier0_bytes_fixup_info[words[i] & BUSTER_TIER0_WORD_TEMPLATE];
                work->fixups[work->fixup_count++] = (Tier0BytesFixup){
                    .end = lane_position[lane] + (uint32_t)(lane_meta[lane] >> 56),
                    .kind = (uint8_t)info,
                    .field = (uint8_t)(info >> 8),
                    .target = (uint32_t)values[i],
                    .entry = i,
                };
            }
        }
    }
    work->branch_count = branch_count;
    tier0_bytes_lap(3);
    // The epilogue.
    positions[count] = at;
    if (valid)
    {
        writer = tier0_bytes_writer(work, frame);
        tier0_emit_epilogue(function, frame, &writer);
        const int64_t epilogue = tier0_bytes_writer_encode(work, &writer, tentative, at, count, work->fixups, &work->fixup_count, &branched);
        valid = epilogue >= 0;
        at += valid ? (uint32_t)epilogue : 0;
    }
    tier0_bytes_lap(4);
    *refusal = branched ? 11 : 0;
    int64_t length = valid ? (int64_t)at : -1;
    // Branch sizing on the branches' byte positions: D0 from every branch short, 16 at a time. Where none is out of
    // range, each rel8 is its D0. Otherwise size_branches' own rounds on columns of D0, the targets' ranks among the
    // entries and the growths; each entry's growth before it is a prefix sum of the grown branches' growths; the bytes
    // move in runs between the grown branches, each of which takes its long shape.
    uint32_t grown = 0;
    bool any = false;
    for (uint32_t k = 0; valid && k < branch_count; k += 16)
    {
        const __mmask16 lanes = (__mmask16)(branch_count - k >= 16 ? 0xffffu : (1u << (branch_count - k)) - 1);
        const __m512i entry = _mm512_maskz_loadu_epi32(lanes, work->branch_entries + k);
        const __m512i target = _mm512_maskz_loadu_epi32(lanes, work->branch_targets + k);
        const __m512i end = _mm512_maskz_loadu_epi32(lanes, work->branch_ends + k);
        const __m512i from = _mm512_mask_i32gather_epi32(_mm512_setzero_si512(), lanes, entry, positions, 4);
        const __m512i to = _mm512_mask_i32gather_epi32(_mm512_setzero_si512(), lanes, target, positions, 4);
        const __m512i displacement = _mm512_sub_epi32(to, _mm512_add_epi32(from, end));
        _mm512_mask_storeu_epi32(work->displacements + k, lanes, displacement);
        any |= _mm512_mask_cmpgt_epu32_mask(lanes, _mm512_add_epi32(displacement, _mm512_set1_epi32(128)), _mm512_set1_epi32(255)) != 0;
    }
    if (valid && !any)
    {
        for (uint32_t k = 0; k < branch_count; k += 1)
        {
            tentative[positions[work->branch_entries[k]] + work->branch_ends[k] - 1] = (uint8_t)work->displacements[k];
        }
    }
    else if (valid)
    {
        Scratch scratch = scratch_begin(0);
        BranchSizingColumns columns = branch_sizing_allocate(scratch.arena, (uint64_t)count + 1, branch_count);
        valid = columns.valid;
        const uint32_t padded = ((branch_count + BUSTER_BRANCH_SIZING_LANES - 1) & ~(uint32_t)(BUSTER_BRANCH_SIZING_LANES - 1)) + BUSTER_BRANCH_SIZING_LANES;
        bool changed = false;
        for (uint32_t k = 0; valid && k < padded; k += 1)
        {
            const bool real = k < branch_count;
            const int32_t displacement = real ? work->displacements[k] : 0;
            const bool out = real && (displacement < -128 || displacement > 127);
            columns.grow[k] = real ? work->branch_growths[k] : 0;
            columns.displacement0[k] = displacement;
            columns.displacement[k] = displacement;
            columns.growth[k] = out ? work->branch_growths[k] : 0;
            changed |= out;
        }
        uint32_t current = 0;
        if (valid)
        {
            branch_sizing_prefix_vector(branch_count, &columns, 0);
            memset(columns.prefix[1], 0, sizeof(uint32_t) * ((uint64_t)branch_count + 1));
            branch_sizing_ranks_vector((uint64_t)count + 1, work->branch_entries, work->branch_targets, branch_count, &columns);
        }
        uint32_t rounds = 1;
        bool listed = false;
        while (valid && changed)
        {
            if (rounds >= BUSTER_BRANCH_SIZING_ROUNDS && !listed)
            {
                branch_sizing_worklist(branch_count, &columns, current);
                branch_sizing_prefix_vector(branch_count, &columns, current ^ 1);
                current ^= 1;
                listed = true;
            }
            changed = branch_sizing_round_vector(branch_count, &columns, current);
            current ^= 1;
            rounds += 1;
        }
        // Each entry's growth before it: the grown branches' growths at their entries' next places, summed.
        uint32_t* growth = work->growth;
        memset(work->delta, 0, sizeof(uint32_t) * ((uint64_t)count + 2));
        for (uint32_t k = 0; valid && k < branch_count; k += 1)
        {
            work->delta[work->branch_entries[k] + 1] += columns.growth[k];
            grown += columns.growth[k] != 0 ? 1 : 0;
        }
        uint32_t sum = 0;
        for (uint32_t i = 0; valid && i <= count; i += 1)
        {
            sum += work->delta[i];
            growth[i] = sum;
        }
        uint32_t from = 0;
        for (uint32_t g = 0; valid && g <= branch_count; g += 1)
        {
            const bool last = g == branch_count;
            const bool long_branch = !last && columns.growth[g] != 0;
            if (last || long_branch)
            {
                const uint32_t entry = last ? count : work->branch_entries[g];
                const uint32_t to = last ? at : positions[entry];
                memmove(output + from + growth[entry], tentative + from, to - from);
                if (long_branch)
                {
                    const uint8_t* holes = hole_blocks + (uint64_t)entry * 32;
                    const uint32_t index = tier0_bytes_shape(cache, work->keys[entry] | UINT64_C(1) << 48, _mm256_loadu_si256((const __m256i*)holes), holes, true);
                    valid = index != BUSTER_TIER0_BYTES_NONE;
                    const Tier0BytesSlot* line = valid ? &cache->slots[index] : 0;
                    if (valid)
                    {
                        tier0_bytes_expand(&cache->packed[line->line], holes, output + positions[entry] + growth[entry]);
                        work->branch_ends[g] = line->branch_end;
                        from = positions[entry] + (line->length - work->branch_growths[g]);
                    }
                }
            }
        }
        for (uint32_t f = 0; f < work->fixup_count; f += 1)
        {
            work->fixups[f].end += growth[work->fixups[f].entry];
        }
        for (uint32_t i = 0; i <= count; i += 1)
        {
            positions[i] += growth[i];
        }
        length += growth[count];
        for (uint32_t k = 0; valid && k < branch_count; k += 1)
        {
            const bool long_branch = columns.growth[k] != 0;
            const uint32_t end = positions[work->branch_entries[k]] + work->branch_ends[k];
            const int32_t displacement = (int32_t)positions[work->branch_targets[k]] - (int32_t)end;
            if (long_branch)
            {
                memcpy(output + end - 4, &displacement, 4);
            }
            else
            {
                output[end - 1] = (uint8_t)(int8_t)displacement;
            }
        }
        scratch_end(scratch);
    }
    tier0_bytes_lap(5);
    if (valid && grown == 0)
    {
        memcpy(output, tentative, (uint64_t)length);
    }
    tier0_bytes_lap(6);
    return valid ? length : -1;
}

// ---------------------------------------------------------------------------------------------------------------------
// The command

typedef struct Tier0BytesTally Tier0BytesTally;
struct Tier0BytesTally
{
    uint64_t files;
    uint64_t left_out;
    uint64_t failures;
    uint64_t functions;
    uint64_t entries;
    uint64_t taken_functions;
    uint64_t taken_entries;
    uint64_t refused[BUSTER_TIER0_BYTES_REFUSALS];
    uint64_t refused_entries[BUSTER_TIER0_BYTES_REFUSALS];
    uint64_t mismatches;
    uint64_t bytes;
    // Ticks of the taken functions' back halves, a pass at a time.
    uint64_t reference_ticks[BUSTER_TIER0_BYTES_PASSES];
    uint64_t shadow_ticks[BUSTER_TIER0_BYTES_PASSES];
    uint64_t deferred_ticks[BUSTER_TIER0_BYTES_PASSES];
};

// One function: the front twice, each back half timed, the bytes and fixups compared; `pass` 0 compares and counts.
static bool tier0_bytes_function(Tier0BytesTally* tally, Tier0BytesCache* cache, const Tier0Function* function, Arena* arena, uint32_t pass)
{
    const uint64_t mark = arena->length;
    Tier0BytesFront front;
    tier0_bytes_front(function, arena, &front);
    bool valid = true;
    if (pass == 0)
    {
        tally->functions += 1;
        tally->entries += function->count;
    }
    if (front.refusal == 0)
    {
        const uint64_t capacity = BUSTER_X86_ENCODER_CAPACITY((uint64_t)function->count * 8 + 4096) + BUSTER_TIER0_BYTES_SLACK;
        uint8_t* reference_bytes = BUSTER_ARENA_PUSH_ARRAY(arena, uint8_t, capacity);
        Tier0Code code;
        uint32_t* fixup_ends = 0;
        const uint64_t reference_start = __rdtsc();
        const int64_t reference_length = reference_bytes != 0 ? tier0_bytes_reference(function, &front, arena, reference_bytes, capacity, &code, &fixup_ends) : -1;
        const uint64_t reference_ticks = __rdtsc() - reference_start;
        Tier0BytesFront again;
        tier0_bytes_front(function, arena, &again);
        Tier0BytesWork work;
        memset(&work, 0, sizeof(work));
        work.positions = BUSTER_ARENA_PUSH_ARRAY(arena, uint32_t, (uint64_t)function->count + 2);
        work.growth = BUSTER_ARENA_PUSH_ARRAY(arena, uint32_t, (uint64_t)function->count + 2);
        work.branches = BUSTER_ARENA_PUSH_ARRAY(arena, Tier0BytesBranch, (uint64_t)function->count + 1);
        work.fixups = BUSTER_ARENA_PUSH_ARRAY(arena, Tier0BytesFixup, (uint64_t)function->count * 4 + 64);
        work.tentative = BUSTER_ARENA_PUSH_ARRAY(arena, uint8_t, capacity);
        work.records = BUSTER_ARENA_PUSH_ARRAY(arena, X86Instruction, BUSTER_TIER0_BYTES_WRITER_RECORDS);
        work.links = BUSTER_ARENA_PUSH_ARRAY(arena, LinkReference, BUSTER_TIER0_BYTES_WRITER_RECORDS);
        work.writer_branches = BUSTER_ARENA_PUSH_ARRAY(arena, uint32_t, BUSTER_TIER0_BYTES_WRITER_RECORDS);
        work.writer_targets = BUSTER_ARENA_PUSH_ARRAY(arena, uint32_t, BUSTER_TIER0_BYTES_WRITER_RECORDS);
        work.choices.records = BUSTER_ARENA_PUSH_ARRAY(arena, uint32_t, BUSTER_TIER0_BYTES_WRITER_RECORDS);
        work.choices.rows = BUSTER_ARENA_PUSH_ARRAY(arena, uint16_t, BUSTER_TIER0_BYTES_WRITER_RECORDS);
        work.choices.values = BUSTER_ARENA_PUSH_ARRAY(arena, int64_t, BUSTER_TIER0_BYTES_WRITER_RECORDS);
        work.choices.contexts = BUSTER_ARENA_PUSH_ARRAY(arena, uint16_t, BUSTER_TIER0_BYTES_WRITER_RECORDS);
        work.choices.forms = BUSTER_ARENA_PUSH_ARRAY(arena, uint16_t, BUSTER_TIER0_BYTES_WRITER_RECORDS);
        work.offsets = BUSTER_ARENA_PUSH_ARRAY(arena, uint32_t, BUSTER_TIER0_BYTES_WRITER_RECORDS);
        work.fixup_ends = BUSTER_ARENA_PUSH_ARRAY(arena, uint32_t, BUSTER_X86_ENCODER_FIXUP_CAPACITY(BUSTER_TIER0_BYTES_WRITER_RECORDS));
        work.hole_blocks = arena_push(arena, ((uint64_t)function->count + 8) * 32, 64);
        work.line_of = BUSTER_ARENA_PUSH_ARRAY(arena, uint32_t, (uint64_t)function->count + 16);
        work.keys = BUSTER_ARENA_PUSH_ARRAY(arena, uint64_t, (uint64_t)function->count + 16);
        work.metas = BUSTER_ARENA_PUSH_ARRAY(arena, uint64_t, (uint64_t)function->count + 16);
        work.branch_entries = BUSTER_ARENA_PUSH_ARRAY(arena, uint32_t, (uint64_t)function->count + 32);
        work.branch_targets = BUSTER_ARENA_PUSH_ARRAY(arena, uint32_t, (uint64_t)function->count + 32);
        work.branch_ends = BUSTER_ARENA_PUSH_ARRAY(arena, uint32_t, (uint64_t)function->count + 32);
        work.branch_growths = BUSTER_ARENA_PUSH_ARRAY(arena, uint32_t, (uint64_t)function->count + 32);
        work.delta = BUSTER_ARENA_PUSH_ARRAY(arena, uint32_t, (uint64_t)function->count + 32);
        work.displacements = BUSTER_ARENA_PUSH_ARRAY(arena, int32_t, (uint64_t)function->count + 32);
        work.lengths = BUSTER_ARENA_PUSH_ARRAY(arena, uint32_t, (uint64_t)function->count + 16);
        work.side_offset = BUSTER_ARENA_PUSH_ARRAY(arena, uint32_t, (uint64_t)function->count + 1);
        work.side_fixup_first = BUSTER_ARENA_PUSH_ARRAY(arena, uint32_t, (uint64_t)function->count + 1);
        work.side_fixup_end = BUSTER_ARENA_PUSH_ARRAY(arena, uint32_t, (uint64_t)function->count + 1);
        work.side = BUSTER_ARENA_PUSH_ARRAY(arena, uint8_t, capacity);
        work.side_fixups = BUSTER_ARENA_PUSH_ARRAY(arena, Tier0BytesFixup, (uint64_t)function->count * 4 + 64);
        uint8_t* shadow_bytes = BUSTER_ARENA_PUSH_ARRAY(arena, uint8_t, capacity);
        const bool room = work.positions != 0 && work.growth != 0 && work.branches != 0 && work.fixups != 0 && work.tentative != 0 && work.records != 0 &&
                          work.links != 0 && work.writer_branches != 0 && work.writer_targets != 0 && work.choices.forms != 0 && work.offsets != 0 &&
                          work.fixup_ends != 0 && shadow_bytes != 0 && work.hole_blocks != 0 && work.line_of != 0 && work.lengths != 0 && work.side_offset != 0 &&
                          work.side_fixup_first != 0 && work.side_fixup_end != 0 && work.side != 0 && work.side_fixups != 0 && work.keys != 0 && work.metas != 0 &&
                          work.branch_entries != 0 && work.branch_targets != 0 && work.branch_ends != 0 && work.branch_growths != 0 && work.delta != 0 &&
                          work.displacements != 0;
        uint32_t refusal = again.refusal;
        uint64_t deferred_ticks = 0;
        const uint64_t shadow_start = __rdtsc();
        const int64_t shadow_length = room && refusal == 0 ? tier0_bytes_back(function, &again, cache, &work, shadow_bytes, &refusal, &deferred_ticks) : -1;
        const uint64_t shadow_ticks = __rdtsc() - shadow_start;
        if (refusal != 0)
        {
            if (pass == 0)
            {
                tally->refused[refusal] += 1;
                tally->refused_entries[refusal] += function->count;
            }
        }
        else
        {
            // The shadow writes a block's fixups and its deferred entries' apart: in order of their ends, as the records have them.
            for (uint32_t f = 1; f < work.fixup_count; f += 1)
            {
                const Tier0BytesFixup moved = work.fixups[f];
                uint32_t g = f;
                while (g > 0 && work.fixups[g - 1].end > moved.end)
                {
                    work.fixups[g] = work.fixups[g - 1];
                    g -= 1;
                }
                work.fixups[g] = moved;
            }
            bool same = reference_length >= 0 && shadow_length == reference_length && memcmp(reference_bytes, shadow_bytes, (uint64_t)reference_length) == 0;
            same = same && work.fixup_count == code.reference_count;
            for (uint32_t f = 0; same && f < work.fixup_count; f += 1)
            {
                const LinkReference* link = &code.references[f];
                same = work.fixups[f].end == fixup_ends[f] && work.fixups[f].kind == link->kind && work.fixups[f].field == link->field &&
                       work.fixups[f].target == link->target;
            }
            if (pass == 0 && !same)
            {
                tally->mismatches += 1;
                if (tally->mismatches <= 5)
                {
                    uint64_t at = 0;
                    while (reference_length > 0 && shadow_length > 0 && at < (uint64_t)reference_length && at < (uint64_t)shadow_length &&
                           reference_bytes[at] == shadow_bytes[at])
                    {
                        at += 1;
                    }
                    printf("tier0-bytes: mismatch function_entries=%u reference=%" PRId64 " shadow=%" PRId64 " fixups=%u/%u first_difference=%" PRIu64 "\n",
                           function->count, reference_length, shadow_length, work.fixup_count, code.reference_count, at);
                }
            }
            if (pass == 0 && (same || tier0_bytes_fake))
            {
                tally->taken_functions += 1;
                tally->taken_entries += function->count;
                tally->bytes += (uint64_t)reference_length;
                tally->refused[0] += 1;
                tally->refused_entries[0] += function->count;
            }
            if (same || tier0_bytes_fake)
            {
                tally->reference_ticks[pass] += reference_ticks;
                tally->shadow_ticks[pass] += shadow_ticks;
                tally->deferred_ticks[pass] += deferred_ticks;
            }
            valid = same || pass != 0 || tier0_bytes_fake;
        }
    }
    else if (pass == 0)
    {
        tally->refused[front.refusal] += 1;
        tally->refused_entries[front.refusal] += function->count;
    }
    arena_pop_to(arena, mark);
    return valid;
}

typedef struct Tier0BytesSources Tier0BytesSources;
struct Tier0BytesSources
{
    char** files;
    uint32_t file_count;
    char** options;
    uint32_t option_count;
};

// One file's functions, `passes` times each, as measure-tier0-entries reads them.
static bool tier0_bytes_file(Tier0BytesTally* tally, Tier0BytesCache* cache, const char* file, char** options, uint32_t option_count, Arena* lowered, Arena* scratch,
                             uint32_t passes)
{
    CheckSource prepared;
    const bool chosen = check_source_prepare(&prepared, file, options, option_count, (CheckSourceRequest){ .select = true, .emits = true });
    const bool valid = prepared.stage != CHECK_SOURCE_OPTIONS || prepared.refusal.error != CHECK_REQUEST_ACCEPTED;
    const CheckProgramSelection* selected = &prepared.selected;
    Arena bytes = arena_reserve(UINT64_C(1) << 34);
    const bool reserved = bytes.base != 0;
    const uint64_t lowered_mark = lowered->length;
    CheckProgramCode code = { .status = CHECK_PROGRAM_RESOURCE, .token = BUSTER_CHECK_NONE };
    const bool emitted = chosen && reserved && check_program_emit(&code, &selected->program, prepared.parser, prepared.pp->table, selected->data.capacity,
                                                                  BUSTER_SCALAR_PATH(prepared.scalar), lowered, &bytes, &prepared.path.scratch, NULL, NULL, false, false);
    const bool refused = chosen && reserved && !emitted && code.status == CHECK_PROGRAM_UNSUPPORTED;
    const uint32_t count = selected->program.body_count;
    uint8_t* defined = 0;
    bool added = emitted && check_program_access(&code, &selected->program, lowered, &prepared.path.scratch, &defined);
    const uint64_t mismatches_before = tally->mismatches;
    for (uint32_t pass = 0; added && pass < passes; pass += 1)
    {
        for (uint32_t b = 0; added && b < count; b += 1)
        {
            added = tier0_bytes_function(tally, cache, &code.lowered.functions[b], scratch, pass);
        }
    }
    const bool failed = valid && (check_source_failed(&prepared) || (chosen && !reserved) || (chosen && reserved && !emitted && !refused) || (emitted && !added));
    tally->failures += failed ? 1 : 0;
    tally->left_out += valid && !failed && !added ? 1 : 0;
    tally->files += added ? 1 : 0;
    if (valid && !chosen)
    {
        check_source_report(stdout, "tier0-bytes", file, &prepared);
    }
    else if (valid && !emitted)
    {
        printf("tier0-bytes: file=%s %s=\"%s\"\n", file, refused ? "unsupported" : "failed", code.reason != NULL ? code.reason : "this C type or operation");
    }
    else if (valid && !added)
    {
        printf("tier0-bytes: file=%s failed=\"%s\"\n", file, tally->mismatches != mismatches_before ? "the bytes differ" : "memory ran out");
    }
    arena_pop_to(lowered, lowered_mark);
    arena_release(&bytes);
    check_source_release(&prepared);
    return valid;
}

static int tier0_bytes_compare_u64(const void* left, const void* right)
{
    const uint64_t a = *(const uint64_t*)left;
    const uint64_t b = *(const uint64_t*)right;
    return a < b ? -1 : a > b ? 1 : 0;
}

static uint64_t tier0_bytes_median(const uint64_t* values, uint32_t count)
{
    uint64_t sorted[BUSTER_TIER0_BYTES_PASSES];
    memcpy(sorted, values, sizeof(uint64_t) * count);
    qsort(sorted, count, sizeof(uint64_t), tier0_bytes_compare_u64);
    return sorted[count / 2];
}

static int run_tier0_bytes_measure(int count, char** arguments)
{
    char** options = calloc((size_t)count + 1, sizeof(char*));
    char** files = calloc((size_t)count + 1, sizeof(char*));
    Tier0BytesSources* sources = calloc((size_t)count + 1, sizeof(Tier0BytesSources));
    uint32_t option_count = 0;
    uint32_t file_count = 0;
    uint32_t source_count = 0;
    uint64_t passes = BUSTER_TIER0_BYTES_PASSES;
    bool valid = options != 0 && files != 0 && sources != 0;
    if (valid)
    {
        sources[0] = (Tier0BytesSources){ .files = files, .options = options };
    }
    for (int i = 0; valid && i < count; i += 1)
    {
        Tier0BytesSources* current = &sources[source_count];
        if (strcmp(arguments[i], "--passes") == 0)
        {
            valid = i + 1 < count && check_corpus_number(arguments[++i], &passes) && passes >= 1 && passes <= BUSTER_TIER0_BYTES_PASSES;
        }
        else if (strcmp(arguments[i], "--next") == 0)
        {
            valid = current->file_count != 0;
            source_count += 1;
            sources[source_count] = (Tier0BytesSources){ .files = files + file_count, .options = options + option_count };
        }
        else if (arguments[i][0] != '-')
        {
            files[file_count++] = arguments[i];
            current->file_count += 1;
        }
        else if (strcmp(arguments[i], "--no-default-config") != 0)
        {
            options[option_count++] = arguments[i];
            current->option_count += 1;
            if (pp_option_takes_value(arguments[i]))
            {
                valid = i + 1 < count;
                options[option_count++] = valid ? arguments[++i] : 0;
                current->option_count += 1;
            }
        }
    }
    valid = valid && sources[source_count].file_count != 0;
    Tier0BytesTally tally;
    memset(&tally, 0, sizeof(tally));
    Tier0BytesCache cache;
    const bool began = valid && tier0_bytes_cache_begin(&cache);
    Arena scratch = arena_reserve(UINT64_C(1) << 32);
    Arena lowered = arena_reserve(UINT64_C(1) << 36);
    valid = valid && began && scratch.base != 0 && lowered.base != 0;
    if (valid)
    {
        tier0_bytes_templates_build();
        tier0_bytes_fake = getenv("BUSTER_TIER0_BYTES_FAKE") != NULL;
    }
    for (uint32_t s = 0; valid && s <= source_count; s += 1)
    {
        for (uint32_t i = 0; valid && i < sources[s].file_count; i += 1)
        {
            valid = tier0_bytes_file(&tally, &cache, sources[s].files[i], sources[s].options, sources[s].option_count, &lowered, &scratch, (uint32_t)passes);
            fflush(stdout);
        }
    }
    if (!valid && (options == 0 || files == 0 || sources == 0 || sources[source_count].file_count == 0))
    {
        fprintf(stderr, "usage: compiler measure-tier0-bytes [--passes N] [preprocessor options] file... [--next [preprocessor options] file...]...\n");
    }
    if (valid)
    {
        printf("tier0-bytes: files=%" PRIu64 " left_out=%" PRIu64 " failures=%" PRIu64 " functions=%" PRIu64 " entries=%" PRIu64 "\n", tally.files, tally.left_out,
               tally.failures, tally.functions, tally.entries);
        for (uint32_t r = 0; r < BUSTER_TIER0_BYTES_REFUSALS; r += 1)
        {
            if (tally.refused[r] != 0)
            {
                printf("tier0-bytes: %s functions=%" PRIu64 " entries=%" PRIu64 " (%.2f%% of the entries)\n", tier0_bytes_refusal_names[r], tally.refused[r],
                       tally.refused_entries[r], tally.entries != 0 ? 100.0 * (double)tally.refused_entries[r] / (double)tally.entries : 0.0);
            }
        }
        printf("tier0-bytes: mismatches=%" PRIu64 " taken_bytes=%" PRIu64 " shapes=%u first_uses=%" PRIu64 " first_ticks=%" PRIu64 " (%.1f a first use) unshaped=%" PRIu64 "\n",
               tally.mismatches, tally.bytes, cache.line_count, cache.first_uses, cache.first_ticks,
               cache.first_uses != 0 ? (double)cache.first_ticks / (double)cache.first_uses : 0.0, cache.unshaped);
        const uint32_t timed = (uint32_t)passes > 1 ? (uint32_t)passes - 1 : 1;
        const uint64_t* reference = passes > 1 ? tally.reference_ticks + 1 : tally.reference_ticks;
        const uint64_t* shadow = passes > 1 ? tally.shadow_ticks + 1 : tally.shadow_ticks;
        const uint64_t* deferred = passes > 1 ? tally.deferred_ticks + 1 : tally.deferred_ticks;
        const double entries = tally.taken_entries != 0 ? (double)tally.taken_entries : 1.0;
        const uint64_t reference_median = tier0_bytes_median(reference, timed);
        const uint64_t shadow_median = tier0_bytes_median(shadow, timed);
        const uint64_t deferred_median = tier0_bytes_median(deferred, timed);
        printf("tier0-bytes: ticks an entry (median of %u passes after the first): reference %.2f shadow %.2f (deferred entries %.2f, the rest %.2f)\n", timed,
               (double)reference_median / entries, (double)shadow_median / entries, (double)deferred_median / entries,
               (double)(shadow_median - deferred_median) / entries);
        const char* laps[BUSTER_TIER0_BYTES_LAPS] = { "prologue", "pass-a", "prefix", "pass-b", "epilogue", "sizing", "copy", "pass-a-lookups" };
        for (uint32_t l = 0; l < 8; l += 1)
        {
            printf("tier0-bytes: lap %s %.2f ticks an entry (all passes)\n", laps[l], (double)tier0_bytes_laps[l] / entries / (double)passes);
        }
        for (uint32_t p = 0; p < (uint32_t)passes; p += 1)
        {
            printf("tier0-bytes: pass %u reference=%" PRIu64 " shadow=%" PRIu64 " deferred=%" PRIu64 "\n", p, tally.reference_ticks[p], tally.shadow_ticks[p], tally.deferred_ticks[p]);
        }
    }
    const int status = valid && tally.failures == 0 && tally.mismatches == 0 && tally.taken_entries != 0 ? 0 : 1;
    if (began)
    {
        tier0_bytes_cache_end(&cache);
    }
    arena_release(&lowered);
    arena_release(&scratch);
    free(sources);
    free(files);
    free(options);
    return status;
}

#endif
