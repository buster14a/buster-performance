// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// lanes.c: the second path of buster#2850's step 0. The same sweeps as sweeps.c's (T, C, the templates' choice and X),
// over the same dumps and with the same answers, on the layout the issue proposes: a record's facts as byte columns,
// its operands as byte distances back in the postorder, T's and C's rules as in-register lookups over blocks of 64
// records, the template by one load on a 16-byte key, and the entries written without a branch a record.
// sweeps.c (the first path, included unchanged through census.c) is its twin: every fact, context, target and
// template is compared with the first path's, and the emitted entries with the stream's.
//
// The rules are learned from the dump, as the first path's tables are. For each answer and operator, an operator's
// rule is a constant, a copy of one input (the greatest of two classes and int's is an input), or a table: census.c's
// search gives the fewest inputs that decide the answer; the operators that read the same inputs share a shape; a
// shape's inputs, the operator among them, are each recoded to a few bits and index one table of at most 256 bytes.
// A kernel evaluates an answer's copies and shapes for the 64 records of a block and keeps each record's own by its
// operator. What the first path's tables refuse (a key in conflict) is given to this path as a byte a record, since a
// learned table's conflicts are the learning's, not the layout's. What the layout itself can't take (an operand more
// than 64 records away, a rule of more than 8 index bits) is filled from the truth, counted, and refuses its
// expression.
//
// The kernel reads the rules in one of two ways. As built, T and C walk the learned rules' lists: every lookup's
// table and inputs are found through the lists at run time. `lanes DUMP --bake FILE` writes the same rules as
// straight-line code with the tables as constants, and a build with -DLANES_BAKED='"FILE"' compiles that in: what a
// compiler whose rules are fixed when it is built would run. A baked kernel is checked against the rules learned
// from the dump at hand, and refuses another's.
//
// X writes the entries in six steps (lanes_expand): the few records that need care are listed, an entry's place is a
// sum of 16 records at a time, and every record's row is written with no branch.
#define CENSUS_MAIN census_main
#include "census.c"
#include <immintrin.h>
#include <time.h>

#define LANES_PAD 192u
#define LANES_FACTS 7u
#define LANES_SHAPES_MOST 40u
#define LANES_SHAPE_INPUTS_MOST 8u
#define LANES_NO_ROW 0xffu
#define LANES_CLASS_NONE 14u

// Why the layout leaves a record to the scalar path.
#define LANES_LAYOUT_FAR 1u
#define LANES_LAYOUT_WIDE 2u

static uint8_t lanes_dense_class(uint8_t class)
{
    return class == 255 ? (uint8_t)LANES_CLASS_NONE : class;
}

// A column of `count` bytes, zeroed, with room before and after it for a block's loads. Each column starts at a place
// of its own modulo 4 KB (192 bytes past the one before): columns that all began at one page offset would put a
// block's lines of every column in one set of the first-level cache, more lines than its ways, and each record's
// bytes 4 KB apart, which the load-store unit takes for aliases (buster's docs/node-machine.md, "T's records as
// columns").
static uint32_t lanes_columns_made;

static uint8_t* lanes_column(uint64_t count)
{
    const uint64_t bytes = (count + 2 * LANES_PAD + 4096 + 127) & ~UINT64_C(63);
    uint8_t* column = must(aligned_alloc(4096, (bytes + 4095) & ~UINT64_C(4095)));
    memset(column, 0, bytes);
    const uint64_t stagger = (uint64_t)(lanes_columns_made * 3 % 64) * 64;
    lanes_columns_made += 1;
    return column + LANES_PAD + stagger;
}

// One shape of an answer: the inputs its operators' rules read, each recoded to its field of the index, and the
// answers at the indexes. Input 0 is the operator, as its dense code (the unit's operators numbered from 0): every
// input is under 64, so that a recode is one vpermb.
typedef struct LanesShape LanesShape;
struct LanesShape
{
    uint8_t recodes[LANES_SHAPE_INPUTS_MOST][64];
    uint8_t table[256];
    uint8_t inputs[LANES_SHAPE_INPUTS_MOST];
    uint32_t count;
    uint32_t bits;
    uint32_t rows;
    uint32_t operators;
} __attribute__((aligned(64)));

// An answer's rules, an operator at a time. `select` has the rule's kind at the operator's dense code: a constant
// (`constants` has it), a copy of one input (the few inputs an answer copies are `copies`), or a shape's table.
#define LANES_COPIES_MOST 8u
#define LANES_SELECT_CONSTANT 0u
#define LANES_SELECT_COPY 1u
#define LANES_SELECT_SHAPE 0x40u
#define LANES_SELECT_NONE 0xffu
typedef struct LanesAnswer LanesAnswer;
struct LanesAnswer
{
    uint8_t select[64];
    uint8_t constants[64];
    LanesShape shapes[LANES_SHAPES_MOST];
    uint8_t copies[LANES_COPIES_MOST];
    uint32_t copy_count;
    uint32_t shape_count;
    // The inputs the copies and the shapes read, and each operator's.
    uint64_t used;
    uint64_t reads[64];
    uint32_t wide_operators;
    uint32_t constant_operators;
    uint32_t copy_operators;
    uint32_t table_operators;
};

static void lanes_recode(CensusMap* map, uint8_t* columns, const uint32_t* answers, uint32_t count, uint32_t size, uint8_t codes[][256], uint32_t* bits)
{
    uint32_t* order = must(malloc(((uint64_t)count + 1) * sizeof(uint32_t)));
    for (uint32_t which = 0; which < size; which += 1)
    {
        uint32_t counts[256] = { 0 };
        for (uint32_t m = 0; m < count; m += 1)
        {
            counts[columns[(uint64_t)m * size + which]] += 1;
        }
        uint32_t values[256];
        uint32_t value_count = 0;
        for (uint32_t v = 0; v < 256; v += 1)
        {
            if (counts[v] != 0)
            {
                values[value_count++] = v;
            }
        }
        for (uint32_t i = 0; i < value_count; i += 1)
        {
            for (uint32_t j = i + 1; j < value_count; j += 1)
            {
                if (counts[values[j]] > counts[values[i]])
                {
                    const uint32_t swap = values[i];
                    values[i] = values[j];
                    values[j] = swap;
                }
            }
        }
        uint32_t starts[257];
        uint32_t at = 0;
        for (uint32_t v = 0; v < 256; v += 1)
        {
            starts[v] = at;
            at += counts[v];
        }
        starts[256] = at;
        uint32_t next[256];
        memcpy(next, starts, sizeof(next));
        for (uint32_t m = 0; m < count; m += 1)
        {
            order[next[columns[(uint64_t)m * size + which]]++] = m;
        }
        map->epoch += 1;
        const uint32_t epoch = map->epoch;
        uint32_t code_count = 0;
        memset(codes[which], 0, 256);
        for (uint32_t i = 0; i < value_count; i += 1)
        {
            const uint32_t v = values[i];
            uint32_t chosen = code_count;
            for (uint32_t code = 0; code < code_count && chosen == code_count; code += 1)
            {
                bool agrees = true;
                for (uint32_t k = starts[v]; agrees && k < starts[v + 1]; k += 1)
                {
                    const uint32_t m = order[k];
                    uint64_t key = code;
                    for (uint32_t j = 0; j < size; j += 1)
                    {
                        key = j != which ? key << 8 | columns[(uint64_t)m * size + j] : key;
                    }
                    uint64_t slot = (mix(0x52, key) * UINT64_C(0xd6e8feb86659fd93)) >> map->shift;
                    while (map->epochs[slot] == epoch && map->keys[slot] != key)
                    {
                        slot = (slot + 1) & map->mask;
                    }
                    agrees = map->epochs[slot] != epoch || map->values[slot] == answers[m];
                }
                chosen = agrees ? code : chosen;
            }
            code_count += chosen == code_count;
            codes[which][v] = (uint8_t)chosen;
            for (uint32_t k = starts[v]; k < starts[v + 1]; k += 1)
            {
                const uint32_t m = order[k];
                uint64_t key = chosen;
                for (uint32_t j = 0; j < size; j += 1)
                {
                    key = j != which ? key << 8 | columns[(uint64_t)m * size + j] : key;
                }
                uint64_t slot = (mix(0x52, key) * UINT64_C(0xd6e8feb86659fd93)) >> map->shift;
                while (map->epochs[slot] == epoch && map->keys[slot] != key)
                {
                    slot = (slot + 1) & map->mask;
                }
                if (map->epochs[slot] != epoch)
                {
                    map->epochs[slot] = epoch;
                    map->keys[slot] = key;
                    map->values[slot] = answers[m];
                }
            }
        }
        for (uint32_t m = 0; m < count; m += 1)
        {
            columns[(uint64_t)m * size + which] = codes[which][columns[(uint64_t)m * size + which]];
        }
        bits[which] = census_bits_of(code_count);
    }
    free(order);
}

// A shape from the samples of `operators` (a mask) that read the inputs `set`: whether it fits 8 index bits.
static bool lanes_shape_learn(LanesShape* shape, const CensusTable* table, CensusMap* map, const uint32_t* members, const uint32_t* starts, const uint64_t* operators,
                              const uint8_t* set, uint32_t size, uint32_t output, const uint8_t* dense)
{
    memset(shape, 0, sizeof(*shape));
    memset(shape->table, LANES_NO_ROW, sizeof(shape->table));
    uint32_t count = 0;
    for (uint32_t op = 0; op < OPS; op += 1)
    {
        if ((operators[op / 64] >> (op % 64) & 1) != 0)
        {
            count += starts[op + 1] - starts[op];
            shape->operators += 1;
        }
    }
    const uint32_t width = size + 1;
    uint8_t* columns = must(malloc((uint64_t)(count + 1) * width));
    uint32_t* answers = must(malloc((uint64_t)(count + 1) * sizeof(uint32_t)));
    uint32_t at = 0;
    bool small = true;
    for (uint32_t op = 0; op < OPS; op += 1)
    {
        if ((operators[op / 64] >> (op % 64) & 1) != 0)
        {
            for (uint32_t m = starts[op]; m < starts[op + 1]; m += 1)
            {
                const uint8_t* inputs = table->inputs + (uint64_t)members[m] * table->input_count;
                columns[(uint64_t)at * width] = dense[op];
                for (uint32_t i = 0; i < size; i += 1)
                {
                    columns[(uint64_t)at * width + 1 + i] = inputs[set[i]];
                    small = small && inputs[set[i]] < 64;
                }
                answers[at] = table->outputs[(uint64_t)members[m] * table->output_count + output];
                at += 1;
            }
        }
    }
    static uint8_t codes[LANES_SHAPE_INPUTS_MOST][256];
    uint32_t bits[LANES_SHAPE_INPUTS_MOST] = { 0 };
    lanes_recode(map, columns, answers, count, width, codes, bits);
    uint32_t total = 0;
    uint32_t shifts[LANES_SHAPE_INPUTS_MOST];
    for (uint32_t i = 0; i < width; i += 1)
    {
        shifts[i] = total;
        total += bits[i];
    }
    const bool fits = total <= 8 && small;
    if (fits)
    {
        shape->count = width;
        shape->bits = total;
        for (uint32_t i = 0; i < width; i += 1)
        {
            shape->inputs[i] = i == 0 ? 0 : set[i - 1];
            for (uint32_t v = 0; v < 64; v += 1)
            {
                shape->recodes[i][v] = (uint8_t)(codes[i][v] << shifts[i]);
            }
        }
        for (uint32_t m = 0; m < count; m += 1)
        {
            uint32_t index = 0;
            for (uint32_t i = 0; i < width; i += 1)
            {
                index |= (uint32_t)columns[(uint64_t)m * width + i] << shifts[i];
            }
            if (shape->table[index] == LANES_NO_ROW)
            {
                shape->table[index] = (uint8_t)answers[m];
                shape->rows += 1;
            }
            else if (shape->table[index] != (uint8_t)answers[m])
            {
                fprintf(stderr, "lanes: a shape's rows disagree\n");
                exit(1);
            }
        }
    }
    free(columns);
    free(answers);
    return fits;
}

// The rules of answer `output` of `table`: each operator's fewest inputs (census.c's search), the operators of one set
// as one shape, and an operator alone where its set's shape doesn't fit.
static void lanes_answer_learn(LanesAnswer* answer, const CensusTable* table, uint32_t output, const uint8_t* dense)
{
    memset(answer, 0, sizeof(*answer));
    memset(answer->select, LANES_SELECT_NONE, sizeof(answer->select));
    uint32_t starts[OPS + 1] = { 0 };
    for (uint64_t s = 0; s < table->count; s += 1)
    {
        starts[table->groups[s] + 1] += 1;
    }
    for (uint32_t op = 0; op < OPS; op += 1)
    {
        starts[op + 1] += starts[op];
    }
    uint32_t* members = must(malloc((table->count + 1) * sizeof(uint32_t)));
    uint32_t next[OPS];
    memcpy(next, starts, sizeof(next));
    for (uint64_t s = 0; s < table->count; s += 1)
    {
        members[next[table->groups[s]]++] = (uint32_t)s;
    }
    CensusMap map;
    census_map_make(&map, table->count + 1);
    // Each operator's set. An operator with none has a constant; one whose answer is an input in every sample copies it.
    static CensusFinding findings[OPS];
    uint64_t masks[OPS] = { 0 };
    uint64_t copyable[OPS] = { 0 };
    bool taken[OPS] = { false };
    for (uint32_t op = 0; op < OPS; op += 1)
    {
        const uint32_t member_count = starts[op + 1] - starts[op];
        if (member_count != 0)
        {
            const uint32_t* group = members + starts[op];
            findings[op] = census_find(table, &map, group, member_count, output);
            for (uint32_t i = 0; i < findings[op].size; i += 1)
            {
                masks[op] |= UINT64_C(1) << findings[op].set[i];
            }
            const uint32_t first_answer = table->outputs[(uint64_t)group[0] * table->output_count + output];
            bool constant = true;
            for (uint32_t m = 0; constant && m < member_count; m += 1)
            {
                constant = table->outputs[(uint64_t)group[m] * table->output_count + output] == first_answer;
            }
            if (constant)
            {
                answer->select[dense[op]] = LANES_SELECT_CONSTANT;
                answer->constants[dense[op]] = (uint8_t)first_answer;
                answer->constant_operators += 1;
                taken[op] = true;
            }
            for (uint32_t i = 0; !constant && i < table->input_count; i += 1)
            {
                bool same = (table->withheld[output] >> i & 1) == 0;
                for (uint32_t m = 0; same && m < member_count; m += 1)
                {
                    same = table->inputs[(uint64_t)group[m] * table->input_count + i] == table->outputs[(uint64_t)group[m] * table->output_count + output];
                }
                copyable[op] |= same ? UINT64_C(1) << i : 0;
            }
        }
    }
    // The copies: the input most of the copying operators can copy, then the next for those left.
    bool more = true;
    while (more && answer->copy_count < LANES_COPIES_MOST)
    {
        uint32_t best = 0;
        uint32_t best_count = 0;
        for (uint32_t i = 0; i < table->input_count; i += 1)
        {
            uint32_t operators = 0;
            for (uint32_t op = 0; op < OPS; op += 1)
            {
                operators += !taken[op] && (copyable[op] >> i & 1) != 0;
            }
            if (operators > best_count)
            {
                best = i;
                best_count = operators;
            }
        }
        more = best_count != 0;
        if (more)
        {
            for (uint32_t op = 0; op < OPS; op += 1)
            {
                if (!taken[op] && (copyable[op] >> best & 1) != 0)
                {
                    answer->select[dense[op]] = (uint8_t)(LANES_SELECT_COPY + answer->copy_count);
                    answer->reads[dense[op]] = UINT64_C(1) << best;
                    answer->copy_operators += 1;
                    taken[op] = true;
                }
            }
            answer->copies[answer->copy_count] = (uint8_t)best;
            answer->copy_count += 1;
            answer->used |= UINT64_C(1) << best;
        }
    }
    // The tables: the operators of one set as one shape, and an operator alone where its set's shape doesn't fit.
    for (uint32_t op = 0; op < OPS; op += 1)
    {
        if (starts[op + 1] != starts[op] && !taken[op])
        {
            uint64_t operators[2] = { 0, 0 };
            for (uint32_t other = op; other < OPS; other += 1)
            {
                if (starts[other + 1] != starts[other] && !taken[other] && masks[other] == masks[op])
                {
                    operators[other / 64] |= UINT64_C(1) << (other % 64);
                }
            }
            uint8_t set[CENSUS_INPUTS_MOST];
            uint32_t size = 0;
            for (uint32_t i = 0; i < table->input_count; i += 1)
            {
                if ((masks[op] >> i & 1) != 0)
                {
                    set[size++] = (uint8_t)i;
                }
            }
            bool fits = size + 1 <= LANES_SHAPE_INPUTS_MOST && answer->shape_count < LANES_SHAPES_MOST &&
                        lanes_shape_learn(&answer->shapes[answer->shape_count], table, &map, members, starts, operators, set, size, output, dense);
            if (fits)
            {
                for (uint32_t other = op; other < OPS; other += 1)
                {
                    if ((operators[other / 64] >> (other % 64) & 1) != 0)
                    {
                        answer->select[dense[other]] = (uint8_t)(LANES_SELECT_SHAPE + answer->shape_count);
                        answer->reads[dense[other]] = masks[op];
                        answer->table_operators += 1;
                        taken[other] = true;
                    }
                }
                answer->shape_count += 1;
            }
            else
            {
                // The operator alone.
                uint64_t alone[2] = { 0, 0 };
                alone[op / 64] |= UINT64_C(1) << (op % 64);
                fits = size + 1 <= LANES_SHAPE_INPUTS_MOST && answer->shape_count < LANES_SHAPES_MOST &&
                       lanes_shape_learn(&answer->shapes[answer->shape_count], table, &map, members, starts, alone, set, size, output, dense);
                taken[op] = true;
                if (fits)
                {
                    answer->select[dense[op]] = (uint8_t)(LANES_SELECT_SHAPE + answer->shape_count);
                    answer->reads[dense[op]] = masks[op];
                    answer->table_operators += 1;
                    answer->shape_count += 1;
                }
                else
                {
                    answer->wide_operators += 1;
                }
            }
        }
    }
    for (uint32_t s = 0; s < answer->shape_count; s += 1)
    {
        for (uint32_t i = 1; i < answer->shapes[s].count; i += 1)
        {
            answer->used |= UINT64_C(1) << answer->shapes[s].inputs[i];
        }
    }
    free(members);
    free(map.keys);
    free(map.values);
    free(map.counts);
    free(map.epochs);
    free(map.conflicted);
}

// A table's answers as one list of steps, the same for every block: each answer's copies, then its shapes.
typedef struct LanesCopy LanesCopy;
struct LanesCopy
{
    uint8_t answer;
    uint8_t select;
    uint8_t input;
};

typedef struct LanesStep LanesStep;
struct LanesStep
{
    const LanesShape* shape;
    uint8_t answer;
    uint8_t select;
};

#define LANES_ANSWERS_MOST 8u
#define LANES_PROGRAM_COPIES_MOST 32u
#define LANES_PROGRAM_STEPS_MOST 64u
typedef struct LanesProgram LanesProgram;
struct LanesProgram
{
    const LanesAnswer* answers;
    uint32_t answer_count;
    uint32_t copy_firsts[LANES_ANSWERS_MOST + 1];
    uint32_t step_firsts[LANES_ANSWERS_MOST + 1];
    LanesCopy copies[LANES_PROGRAM_COPIES_MOST];
    LanesStep steps[LANES_PROGRAM_STEPS_MOST];
    uint64_t used;
};

static void lanes_program_make(LanesProgram* program, const LanesAnswer* answers, uint32_t count)
{
    memset(program, 0, sizeof(*program));
    program->answers = answers;
    program->answer_count = count;
    uint32_t copies = 0;
    uint32_t steps = 0;
    for (uint32_t a = 0; a < count; a += 1)
    {
        program->copy_firsts[a] = copies;
        program->step_firsts[a] = steps;
        if (copies + answers[a].copy_count > LANES_PROGRAM_COPIES_MOST || steps + answers[a].shape_count > LANES_PROGRAM_STEPS_MOST)
        {
            fprintf(stderr, "lanes: a table's rules are more than its program holds\n");
            exit(1);
        }
        for (uint32_t c = 0; c < answers[a].copy_count; c += 1)
        {
            program->copies[copies++] = (LanesCopy){ .answer = (uint8_t)a, .select = (uint8_t)(LANES_SELECT_COPY + c), .input = answers[a].copies[c] };
        }
        for (uint32_t s = 0; s < answers[a].shape_count; s += 1)
        {
            program->steps[steps++] = (LanesStep){ .shape = &answers[a].shapes[s], .answer = (uint8_t)a, .select = (uint8_t)(LANES_SELECT_SHAPE + s) };
        }
        program->used |= answers[a].used;
    }
    program->copy_firsts[count] = copies;
    program->step_firsts[count] = steps;
}

// A block's part of a program: each copy's and each shape's records, and the operator's part of a shape's index.
typedef struct LanesBlock LanesBlock;
struct LanesBlock
{
    __m512i index[LANES_PROGRAM_STEPS_MOST];
    __mmask64 step_lanes[LANES_PROGRAM_STEPS_MOST];
    __mmask64 copy_lanes[LANES_PROGRAM_COPIES_MOST];
    __mmask64 none;
};

// A shape's answers at `index`: its table's bytes, by as many lookups as its index bits ask.
static inline __m512i lanes_lookup(const LanesShape* shape, __m512i index)
{
    __m512i value;
    if (shape->bits <= 6)
    {
        value = _mm512_permutexvar_epi8(index, _mm512_load_si512(shape->table));
    }
    else
    {
        value = _mm512_permutex2var_epi8(_mm512_load_si512(shape->table), index, _mm512_load_si512(shape->table + 64));
        if (shape->bits > 7)
        {
            const __m512i high = _mm512_permutex2var_epi8(_mm512_load_si512(shape->table + 128), index, _mm512_load_si512(shape->table + 192));
            value = _mm512_mask_blend_epi8(_mm512_movepi8_mask(index), value, high);
        }
    }
    return value;
}

// A block's part of `program`, by its records' operators: the constants go into values[answer] now, for the `wanted`
// records; block->none has the wanted records one of whose answers has no rule.
static inline __attribute__((unused)) void lanes_block_prepare(const LanesProgram* program, __m512i operators, __mmask64 wanted, __m512i* values, LanesBlock* block)
{
    __m512i select[LANES_ANSWERS_MOST];
    __mmask64 none = 0;
    for (uint32_t a = 0; a < program->answer_count; a += 1)
    {
        const LanesAnswer* answer = &program->answers[a];
        select[a] = _mm512_permutexvar_epi8(operators, _mm512_load_si512(answer->select));
        none |= _mm512_cmpeq_epi8_mask(select[a], _mm512_set1_epi8((char)LANES_SELECT_NONE));
        const __mmask64 constant = wanted & _mm512_testn_epi8_mask(select[a], select[a]);
        values[a] = _mm512_mask_mov_epi8(values[a], constant, _mm512_permutexvar_epi8(operators, _mm512_load_si512(answer->constants)));
    }
    const uint32_t copies = program->copy_firsts[program->answer_count];
    for (uint32_t c = 0; c < copies; c += 1)
    {
        block->copy_lanes[c] = wanted & _mm512_cmpeq_epi8_mask(select[program->copies[c].answer], _mm512_set1_epi8((char)program->copies[c].select));
    }
    const uint32_t steps = program->step_firsts[program->answer_count];
    for (uint32_t s = 0; s < steps; s += 1)
    {
        block->step_lanes[s] = wanted & _mm512_cmpeq_epi8_mask(select[program->steps[s].answer], _mm512_set1_epi8((char)program->steps[s].select));
        block->index[s] = _mm512_permutexvar_epi8(operators, _mm512_load_si512(program->steps[s].shape->recodes[0]));
    }
    block->none = wanted & none;
}

// Answer `a` of the block's records in `lanes`, from the block's inputs: `value` with those records' answers.
static inline __attribute__((unused)) __m512i lanes_block_answer(const LanesProgram* program, const LanesBlock* block, uint32_t a, __m512i value, __mmask64 lanes, const __m512i* inputs)
{
    for (uint32_t c = program->copy_firsts[a]; c < program->copy_firsts[a + 1]; c += 1)
    {
        value = _mm512_mask_mov_epi8(value, block->copy_lanes[c] & lanes, inputs[program->copies[c].input]);
    }
    for (uint32_t s = program->step_firsts[a]; s < program->step_firsts[a + 1]; s += 1)
    {
        const LanesShape* shape = program->steps[s].shape;
        __m512i index = block->index[s];
        for (uint32_t i = 1; i < shape->count; i += 1)
        {
            index = _mm512_or_si512(index, _mm512_permutexvar_epi8(inputs[shape->inputs[i]], _mm512_load_si512(shape->recodes[i])));
        }
        value = _mm512_mask_mov_epi8(value, block->step_lanes[s] & lanes, lanes_lookup(shape, index));
    }
    return value;
}

// A program's print: every rule's bytes hashed, so that a baked kernel is checked against the rules it was baked from.
static uint64_t lanes_print_bytes(uint64_t print, const void* bytes, uint64_t count)
{
    const uint8_t* at = bytes;
    for (uint64_t i = 0; i < count; i += 1)
    {
        print = (print ^ at[i]) * UINT64_C(0x100000001b3);
    }
    return print;
}

static uint64_t lanes_program_print(const LanesProgram* program)
{
    uint64_t print = UINT64_C(0xcbf29ce484222325);
    for (uint32_t a = 0; a < program->answer_count; a += 1)
    {
        const LanesAnswer* answer = &program->answers[a];
        print = lanes_print_bytes(print, answer->select, 64);
        print = lanes_print_bytes(print, answer->constants, 64);
        print = lanes_print_bytes(print, answer->copies, answer->copy_count);
        print = lanes_print_bytes(print, &answer->shape_count, sizeof(answer->shape_count));
        for (uint32_t s = 0; s < answer->shape_count; s += 1)
        {
            const LanesShape* shape = &answer->shapes[s];
            print = lanes_print_bytes(print, &shape->count, sizeof(shape->count));
            print = lanes_print_bytes(print, &shape->bits, sizeof(shape->bits));
            print = lanes_print_bytes(print, shape->inputs, shape->count);
            print = lanes_print_bytes(print, shape->recodes, (uint64_t)shape->count * 64);
            print = lanes_print_bytes(print, shape->table, 256);
        }
    }
    return print;
}

static void lanes_bake_bytes(FILE* file, const uint8_t* bytes, uint32_t count)
{
    for (uint32_t i = 0; i < count; i += 1)
    {
        fprintf(file, "%s%u,", i % 32 == 0 ? "\n    " : " ", bytes[i]);
    }
}

// A program as straight-line code: the tables as constants, then `prepare` (a block's part of the program, as
// lanes_block_prepare) and one function an answer (as lanes_block_answer). `name` is "t" or "c".
static void lanes_bake_program(FILE* file, const char* name, const LanesProgram* program)
{
    fprintf(file, "#define BAKED_%s_PRINT UINT64_C(0x%llx)\n", name, (unsigned long long)lanes_program_print(program));
    fprintf(file, "#define BAKED_%s_USED UINT64_C(0x%llx)\n", name, (unsigned long long)program->used);
    uint8_t none[64] = { 0 };
    for (uint32_t a = 0; a < program->answer_count; a += 1)
    {
        const LanesAnswer* answer = &program->answers[a];
        fprintf(file, "static const uint8_t baked_%s_select_%u[64] __attribute__((aligned(64))) = {", name, a);
        lanes_bake_bytes(file, answer->select, 64);
        fprintf(file, "\n};\nstatic const uint8_t baked_%s_constants_%u[64] __attribute__((aligned(64))) = {", name, a);
        lanes_bake_bytes(file, answer->constants, 64);
        fprintf(file, "\n};\n");
        for (uint32_t dense = 0; dense < 64; dense += 1)
        {
            none[dense] |= answer->select[dense] == LANES_SELECT_NONE ? 0xff : 0;
        }
        for (uint32_t s = 0; s < answer->shape_count; s += 1)
        {
            const LanesShape* shape = &answer->shapes[s];
            fprintf(file, "static const uint8_t baked_%s_recodes_%u_%u[%u][64] __attribute__((aligned(64))) = {", name, a, s, shape->count);
            for (uint32_t i = 0; i < shape->count; i += 1)
            {
                fprintf(file, "\n    {");
                lanes_bake_bytes(file, shape->recodes[i], 64);
                fprintf(file, "\n    },");
            }
            fprintf(file, "\n};\nstatic const uint8_t baked_%s_table_%u_%u[256] __attribute__((aligned(64))) = {", name, a, s);
            lanes_bake_bytes(file, shape->table, 256);
            fprintf(file, "\n};\n");
        }
    }
    fprintf(file, "static const uint8_t baked_%s_none[64] __attribute__((aligned(64))) = {", name);
    lanes_bake_bytes(file, none, 64);
    fprintf(file, "\n};\n");
    fprintf(file, "static inline void baked_%s_prepare(__m512i operators, __mmask64 wanted, __m512i* values, LanesBlock* block)\n{\n", name);
    for (uint32_t a = 0; a < program->answer_count; a += 1)
    {
        const LanesAnswer* answer = &program->answers[a];
        if (answer->copy_count == 0 && answer->shape_count == 0)
        {
            // Constants alone: an operator with no rule gets one too, and goes to the scalar path all the same.
            fprintf(file, "    values[%u] = _mm512_mask_mov_epi8(values[%u], wanted, _mm512_permutexvar_epi8(operators, _mm512_load_si512(baked_%s_constants_%u)));\n", a, a,
                    name, a);
        }
        else
        {
            fprintf(file, "    {\n        const __m512i select = _mm512_permutexvar_epi8(operators, _mm512_load_si512(baked_%s_select_%u));\n", name, a);
            fprintf(file, "        values[%u] = _mm512_mask_mov_epi8(values[%u], wanted & _mm512_testn_epi8_mask(select, select), _mm512_permutexvar_epi8(operators, "
                          "_mm512_load_si512(baked_%s_constants_%u)));\n",
                    a, a, name, a);
            for (uint32_t c = 0; c < answer->copy_count; c += 1)
            {
                fprintf(file, "        block->copy_lanes[%u] = wanted & _mm512_cmpeq_epi8_mask(select, _mm512_set1_epi8((char)%u));\n", program->copy_firsts[a] + c,
                        LANES_SELECT_COPY + c);
            }
            for (uint32_t s = 0; s < answer->shape_count; s += 1)
            {
                fprintf(file, "        block->step_lanes[%u] = wanted & _mm512_cmpeq_epi8_mask(select, _mm512_set1_epi8((char)%u));\n", program->step_firsts[a] + s,
                        LANES_SELECT_SHAPE + s);
                fprintf(file, "        block->index[%u] = _mm512_permutexvar_epi8(operators, _mm512_load_si512(baked_%s_recodes_%u_%u[0]));\n", program->step_firsts[a] + s, name,
                        a, s);
            }
            fprintf(file, "    }\n");
        }
    }
    fprintf(file, "    block->none = wanted & _mm512_movepi8_mask(_mm512_permutexvar_epi8(operators, _mm512_load_si512(baked_%s_none)));\n}\n", name);
    for (uint32_t a = 0; a < program->answer_count; a += 1)
    {
        const LanesAnswer* answer = &program->answers[a];
        fprintf(file, "static inline __m512i baked_%s_answer_%u(const LanesBlock* block, __m512i value, __mmask64 lanes, const __m512i* inputs)\n{\n", name, a);
        fprintf(file, "    (void)block;\n    (void)lanes;\n    (void)inputs;\n");
        for (uint32_t c = 0; c < answer->copy_count; c += 1)
        {
            fprintf(file, "    value = _mm512_mask_mov_epi8(value, block->copy_lanes[%u] & lanes, inputs[%u]);\n", program->copy_firsts[a] + c, answer->copies[c]);
        }
        for (uint32_t s = 0; s < answer->shape_count; s += 1)
        {
            const LanesShape* shape = &answer->shapes[s];
            const uint32_t step = program->step_firsts[a] + s;
            fprintf(file, "    {\n        __m512i index = block->index[%u];\n", step);
            for (uint32_t i = 1; i < shape->count; i += 1)
            {
                fprintf(file, "        index = _mm512_or_si512(index, _mm512_permutexvar_epi8(inputs[%u], _mm512_load_si512(baked_%s_recodes_%u_%u[%u])));\n", shape->inputs[i],
                        name, a, s, i);
            }
            if (shape->bits <= 6)
            {
                fprintf(file, "        const __m512i answer = _mm512_permutexvar_epi8(index, _mm512_load_si512(baked_%s_table_%u_%u));\n", name, a, s);
            }
            else
            {
                fprintf(file, "        __m512i answer = _mm512_permutex2var_epi8(_mm512_load_si512(baked_%s_table_%u_%u), index, _mm512_load_si512(baked_%s_table_%u_%u + 64));\n",
                        name, a, s, name, a, s);
                if (shape->bits > 7)
                {
                    fprintf(file, "        answer = _mm512_mask_blend_epi8(_mm512_movepi8_mask(index), answer, _mm512_permutex2var_epi8(_mm512_load_si512(baked_%s_table_%u_%u + "
                                  "128), index, _mm512_load_si512(baked_%s_table_%u_%u + 192)));\n",
                            name, a, s, name, a, s);
                }
            }
            fprintf(file, "        value = _mm512_mask_mov_epi8(value, block->step_lanes[%u] & lanes, answer);\n    }\n", step);
        }
        fprintf(file, "    return value;\n}\n");
    }
}

#ifdef LANES_BAKED
#include LANES_BAKED
#endif

// T's inputs, as census.c numbers them.
#define LANES_T_INPUTS 29u
#define LANES_T_COUNT 0u
#define LANES_T_TYPE0 1u
#define LANES_T_TYPE1 3u
#define LANES_T_OPERAND 5u
#define LANES_T_GREATEST01 26u
#define LANES_T_GREATEST0 27u
#define LANES_T_GREATEST1C 28u

// A unit's records as byte columns.
typedef struct Lanes Lanes;
struct Lanes
{
    uint32_t count;
    uint32_t blocks;
    // The operators: as the dump has them, and numbered from 0 in the order the unit shows them.
    uint8_t* operators;
    uint8_t* operators_dense;
    uint8_t dense_of_operator[256];
    uint32_t operator_values;
    uint8_t* operand_counts;
    uint8_t* facts[LANES_FACTS];
    uint8_t* typed;
    uint8_t* by_table;
    uint8_t* children[3];
    uint8_t* graph[2];
    uint8_t* given_types[4];
    uint8_t* types[4];
    uint8_t* layout;
    LanesAnswer* type_answers;
    LanesProgram type_program;
    // T's readiness: by an operator's dense code, the operands its rules read (bits 0 to 2 the evaluated operands,
    // 3 and 4 the first two operands whose types they read), and the operands' facts the rules read at all.
    uint8_t type_needs[64] __attribute__((aligned(64)));
    uint8_t type_fetch[3 * LANES_FACTS][3];
    uint32_t type_fetch_count;
    uint64_t far_records;
    uint64_t wide_records;
    uint64_t type_rounds;
    uint64_t type_blocks;
    // C: each record's parent as a distance forward (0 for a root), its place among the parent's operands, and its
    // context and target: given for a root and for an operand whose parent's operands a prototype gives.
    uint8_t* up;
    uint8_t* index;
    uint8_t* context;
    uint8_t* context_dense;
    uint8_t* target_class;
    uint8_t* target_facts;
    uint8_t* context_given;
    uint8_t* refused;
    uint8_t* context_layout;
    uint8_t dense_of_context[256];
    uint8_t context_of_dense[64] __attribute__((aligned(64)));
    uint32_t context_values;
    LanesAnswer* context_answers;
    LanesProgram context_program;
    uint64_t context_rounds;
    uint64_t context_blocks;
    uint64_t context_scalar;
    // X: a store's destination's kind, the 16-byte key of each record's template (a block's 64 keys in 16 rows of
    // four: record i's at row i mod 16, place i / 16), the templates' table, and each record's template, its entry
    // count and whether it writes before or between its operands.
    uint8_t* counts_whole;
    uint8_t* given_store;
    uint8_t* store;
    uint8_t* store_operator;
    uint64_t* hashes;
    uint8_t* rows;
    struct LanesSlot* slots;
    uint64_t slot_mask;
    uint32_t slot_shift;
    uint64_t slot_keys;
    uint64_t slot_conflicts;
    uint32_t* spans;
    // X's places: each record's root, each record's first entry's place, the room before a record's entries that
    // the runs of the records around it take (few records have any), and a window's records that X takes apart
    // from the others: those that write before or between their operands and those no root is taken with.
    uint32_t* root_of;
    uint64_t* places;
    uint32_t* longs;
    uint8_t* gaps;
    uint32_t* special;
    uint32_t* barred;
    uint8_t* span8;
    uint64_t early_records;
    uint64_t gap_overflows;
    uint64_t steps[8];
    Clock rows_clock;
    // A record's template as its table gives it: its number in 24 bits, its entry count in 5, whether it writes
    // before or between its operands, and whether the table had none. A record's marks: bit 0 for a root, the others
    // for a record the first path's tables refuse or the layout leaves to the scalar path; `marks_made` as made.
    uint32_t* chosen;
    uint32_t* chosen_kept;
    bool keep;
    uint8_t* marks;
    uint8_t* marks_made;
    uint64_t ticks[5];
    // With `split`, each pass's cycles, instructions and mispredicted branches too: three system calls a mark, so the
    // split is read apart from the whole's time.
    bool split;
    Clock parts[5];
};

// A bucket of the templates' table, one cache line: four keys' hashes (never 0: 0 is an empty place) and their
// templates as the records carry them, with the missed mark fifth, which a hash none of the four equals takes. A key
// is a record's 16 key bytes and its operator, hashed 8 records at a time where the keys are made; two keys of one
// hash would be one key to the table, and a bucket of more than four keys has no place for the fifth: the table's
// making checks for both.
typedef struct LanesSlot LanesSlot;
struct LanesSlot
{
    uint64_t checks[4];
    uint32_t values[8];
} __attribute__((aligned(64)));

#define LANES_HASH_FIRST UINT64_C(0x9e3779b97f4a7c15)
#define LANES_HASH_SECOND UINT64_C(0xc2b2ae3d27d4eb4f)

#define LANES_CHOSEN_TEMPLATE 0xffffffu
#define LANES_CHOSEN_TOTAL_SHIFT 24u
#define LANES_CHOSEN_EARLY (UINT32_C(1) << 29)
#define LANES_CHOSEN_MISSED (UINT32_C(1) << 30)
#define LANES_MARK_ROOT 1u
#define LANES_MARK_REFUSED 2u
#define LANES_MARK_LAYOUT 4u
#define LANES_CHOSEN_TOTAL (UINT32_C(31) << LANES_CHOSEN_TOTAL_SHIFT)

// A key's hash: its two halves one after the other, the operator in the second's top bits (above a key's last byte,
// which is 0 or 1), each multiplied and folded down. A sum of two products isn't enough: two keys that differ in
// their top bytes alone differ in the products' top bits alone, and musl has two whose differences cancel there.
static inline uint64_t lanes_key_hash(uint64_t low, uint64_t high, uint32_t op)
{
    uint64_t hash = low * LANES_HASH_FIRST;
    hash ^= hash >> 32;
    hash = (hash ^ (high | (uint64_t)op << 57)) * LANES_HASH_SECOND;
    hash ^= hash >> 32;
    return (hash * LANES_HASH_FIRST) | 1;
}

// T's inputs of record `g`, from the unit's truth: what the kernel computes from the columns.
static void lanes_type_inputs(const Unit* unit, uint32_t g, uint8_t* inputs)
{
    memset(inputs, 0, LANES_T_INPUTS);
    const uint32_t count = unit->operand_count[g];
    inputs[LANES_T_COUNT] = (uint8_t)(count > 63 ? 63 : count);
    uint8_t types[4];
    const uint32_t packed = operand_types_of(unit, unit->facts_truth, g);
    memcpy(types, &packed, 4);
    inputs[LANES_T_TYPE0] = lanes_dense_class(types[0]);
    inputs[LANES_T_TYPE0 + 1] = types[1];
    inputs[LANES_T_TYPE1] = lanes_dense_class(types[2]);
    inputs[LANES_T_TYPE1 + 1] = types[3];
    const uint32_t operands[3] = { unit->child0[g], unit->child1[g], unit->child2[g] };
    for (uint32_t k = 0; k < 3; k += 1)
    {
        uint8_t* facts = inputs + LANES_T_OPERAND + k * LANES_FACTS;
        memcpy(facts, &unit->facts_truth[operands[k]], LANES_FACTS);
        facts[0] = operands[k] != unit->zero ? lanes_dense_class(facts[0]) : 0;
    }
    inputs[LANES_T_GREATEST01] = census_greatest(inputs[LANES_T_TYPE0], inputs[LANES_T_TYPE1]);
    inputs[LANES_T_GREATEST0] = census_greatest(inputs[LANES_T_TYPE0], 0);
    inputs[LANES_T_GREATEST1C] = census_greatest(inputs[LANES_T_TYPE1], inputs[LANES_T_OPERAND + 2 * LANES_FACTS]);
}

// C's inputs, as census.c numbers them: the parent's operand count and context, the operand's index and operator, the
// parent's facts, its first two operands' and the operand's own, then the derived ones.
#define LANES_C_INPUTS 38u
#define LANES_C_COUNT 0u
#define LANES_C_CONTEXT 1u
#define LANES_C_INDEX 2u
#define LANES_C_OPERATOR 3u
#define LANES_C_PARENT 4u
#define LANES_C_FIRST 11u
#define LANES_C_SECOND 18u
#define LANES_C_OWN 25u
#define LANES_C_EQUAL_PARENT 32u
#define LANES_C_GREATEST 33u
#define LANES_C_EQUAL_GREATEST 34u
#define LANES_C_OWN_CONTEXT 35u
#define LANES_C_WANTED_PARENT 36u
#define LANES_C_WANTED_GREATEST 37u
#define LANES_C_ANSWERS 3u

static void lanes_dense_facts(const Unit* unit, uint32_t g, uint8_t* facts)
{
    memcpy(facts, &unit->facts_truth[g], LANES_FACTS);
    facts[0] = g != unit->zero ? lanes_dense_class(facts[0]) : 0;
}

// C's inputs of operand `c`, the `index`th of record `g`, from the unit's truth.
static void lanes_context_inputs(const Lanes* lanes, const Unit* unit, uint32_t g, uint32_t index, uint32_t c, uint8_t* inputs)
{
    memset(inputs, 0, LANES_C_INPUTS);
    const uint32_t count = unit->operand_count[g];
    inputs[LANES_C_COUNT] = (uint8_t)(count > 63 ? 63 : count);
    inputs[LANES_C_CONTEXT] = lanes->dense_of_context[unit->context_truth[g]];
    inputs[LANES_C_INDEX] = (uint8_t)(index > 3 ? 3 : index);
    inputs[LANES_C_OPERATOR] = lanes->dense_of_operator[unit->op[c] < OPS ? unit->op[c] : 0];
    lanes_dense_facts(unit, g, inputs + LANES_C_PARENT);
    lanes_dense_facts(unit, unit->child0[g], inputs + LANES_C_FIRST);
    lanes_dense_facts(unit, unit->child1[g], inputs + LANES_C_SECOND);
    lanes_dense_facts(unit, c, inputs + LANES_C_OWN);
    inputs[LANES_C_EQUAL_PARENT] = inputs[LANES_C_OWN] == inputs[LANES_C_PARENT];
    inputs[LANES_C_GREATEST] = census_greatest(inputs[LANES_C_FIRST], inputs[LANES_C_SECOND]);
    inputs[LANES_C_EQUAL_GREATEST] = inputs[LANES_C_OWN] == inputs[LANES_C_GREATEST];
    inputs[LANES_C_OWN_CONTEXT] = lanes->dense_of_context[unit->context_truth[c]];
    // The class a conversion is to, unless the operand has it: the parent's, or the greatest.
    inputs[LANES_C_WANTED_PARENT] = inputs[LANES_C_EQUAL_PARENT] ? LANES_CLASS_NONE : inputs[LANES_C_PARENT];
    inputs[LANES_C_WANTED_GREATEST] = inputs[LANES_C_EQUAL_GREATEST] ? LANES_CLASS_NONE : inputs[LANES_C_GREATEST];
}

// The columns of `unit`, the facts of the records a lookup gives filled in, and T's and C's rules learned from its
// truth. `tables` are the first path's: an operand whose key they refuse is refused here.
static void lanes_make(Lanes* lanes, const Unit* unit, const Tables* tables)
{
    memset(lanes, 0, sizeof(*lanes));
    const uint32_t count = unit->count;
    lanes->count = count;
    lanes->blocks = (count + 63) / 64;
    lanes->operators = lanes_column(count);
    lanes->operators_dense = lanes_column(count);
    lanes->operand_counts = lanes_column(count);
    bool operator_seen[256] = { false };
    operator_seen[0] = true;
    for (uint32_t g = 0; g < count; g += 1)
    {
        operator_seen[unit->op[g] < OPS ? unit->op[g] : 0] = true;
    }
    for (uint32_t op = 0; op < 256; op += 1)
    {
        if (operator_seen[op])
        {
            if (lanes->operator_values == 64)
            {
                fprintf(stderr, "lanes: more than 64 operators\n");
                exit(1);
            }
            lanes->dense_of_operator[op] = (uint8_t)lanes->operator_values;
            lanes->operator_values += 1;
        }
    }
    lanes->typed = lanes_column(count);
    lanes->by_table = lanes_column(count);
    lanes->layout = lanes_column(count);
    for (uint32_t f = 0; f < LANES_FACTS; f += 1)
    {
        lanes->facts[f] = lanes_column(count);
    }
    for (uint32_t k = 0; k < 3; k += 1)
    {
        lanes->children[k] = lanes_column(count);
    }
    for (uint32_t k = 0; k < 2; k += 1)
    {
        lanes->graph[k] = lanes_column(count);
    }
    for (uint32_t k = 0; k < 4; k += 1)
    {
        lanes->given_types[k] = lanes_column(count);
        lanes->types[k] = lanes_column(count);
    }
    CensusTable samples = { .name = "T", .input_count = LANES_T_INPUTS, .output_count = LANES_FACTS, .derived_first = LANES_T_GREATEST01 };
    for (uint32_t g = 0; g < count; g += 1)
    {
        const uint8_t op = unit->op[g];
        const uint32_t operand_count = unit->operand_count[g];
        lanes->operators[g] = op < OPS ? op : 0;
        lanes->operators_dense[g] = lanes->dense_of_operator[op < OPS ? op : 0];
        lanes->operand_counts[g] = (uint8_t)(operand_count > 63 ? 63 : operand_count);
        const bool by_table = unit->by_table[g] && op < OPS;
        lanes->by_table[g] = by_table ? 0xff : 0;
        lanes->typed[g] = by_table ? 0 : 0xff;
        uint8_t facts[LANES_FACTS];
        memcpy(facts, &unit->facts_truth[g], LANES_FACTS);
        facts[0] = lanes_dense_class(facts[0]);
        for (uint32_t f = 0; f < LANES_FACTS; f += 1)
        {
            lanes->facts[f][g] = by_table ? 0 : facts[f];
        }
        const uint32_t operands[3] = { unit->child0[g], unit->child1[g], unit->child2[g] };
        for (uint32_t k = 0; k < 3; k += 1)
        {
            const uint32_t distance = operands[k] != unit->zero ? g - operands[k] : 0;
            lanes->children[k][g] = (uint8_t)(distance <= 64 ? distance : 0);
            lanes->layout[g] |= distance > 64 ? LANES_LAYOUT_FAR : 0;
        }
        const uint32_t graph[2] = { unit->graph0[g], unit->graph1[g] };
        uint8_t given[4];
        memcpy(given, &unit->operand_types[g], 4);
        given[0] = lanes_dense_class(given[0]);
        given[2] = lanes_dense_class(given[2]);
        for (uint32_t k = 0; k < 2; k += 1)
        {
            const uint32_t distance = graph[k] != NONE ? g - graph[k] : 0;
            lanes->graph[k][g] = (uint8_t)(distance <= 64 ? distance : 0);
            lanes->layout[g] |= distance > 64 ? LANES_LAYOUT_FAR : 0;
            lanes->given_types[2 * k][g] = given[2 * k];
            lanes->given_types[2 * k + 1][g] = given[2 * k + 1];
        }
        if (by_table)
        {
            uint8_t inputs[CENSUS_INPUTS_MOST] = { 0 };
            uint32_t outputs[CENSUS_OUTPUTS_MOST] = { 0 };
            lanes_type_inputs(unit, g, inputs);
            for (uint32_t f = 0; f < LANES_FACTS; f += 1)
            {
                outputs[f] = facts[f];
            }
            census_add(&samples, op, inputs, outputs);
        }
    }
    lanes->type_answers = must(aligned_alloc(64, LANES_FACTS * sizeof(LanesAnswer)));
    for (uint32_t f = 0; f < LANES_FACTS; f += 1)
    {
        lanes_answer_learn(&lanes->type_answers[f], &samples, f, lanes->dense_of_operator);
    }
    lanes_program_make(&lanes->type_program, lanes->type_answers, LANES_FACTS);
    for (uint32_t dense = 0; dense < 64; dense += 1)
    {
        uint64_t reads = 0;
        for (uint32_t f = 0; f < LANES_FACTS; f += 1)
        {
            reads |= lanes->type_answers[f].reads[dense];
        }
        uint8_t needs = 0;
        for (uint32_t k = 0; k < 3; k += 1)
        {
            needs |= (reads >> (LANES_T_OPERAND + k * LANES_FACTS) & ((UINT64_C(1) << LANES_FACTS) - 1)) != 0 ? (uint8_t)(1u << k) : 0;
        }
        needs |= (reads >> LANES_T_GREATEST1C & 1) != 0 ? 4 | 16 : 0;
        needs |= (reads & (UINT64_C(3) << LANES_T_TYPE0 | UINT64_C(1) << LANES_T_GREATEST01 | UINT64_C(1) << LANES_T_GREATEST0)) != 0 ? 8 : 0;
        needs |= (reads & (UINT64_C(3) << LANES_T_TYPE1 | UINT64_C(1) << LANES_T_GREATEST01)) != 0 ? 16 : 0;
        lanes->type_needs[dense] = needs;
    }
    for (uint32_t k = 0; k < 3; k += 1)
    {
        for (uint32_t f = 0; f < LANES_FACTS; f += 1)
        {
            const uint32_t input = LANES_T_OPERAND + k * LANES_FACTS + f;
            if ((lanes->type_program.used >> input & 1) != 0 || ((lanes->type_program.used >> LANES_T_GREATEST1C & 1) != 0 && k == 2 && f == 0))
            {
                lanes->type_fetch[lanes->type_fetch_count][0] = (uint8_t)input;
                lanes->type_fetch[lanes->type_fetch_count][1] = (uint8_t)k;
                lanes->type_fetch[lanes->type_fetch_count][2] = (uint8_t)f;
                lanes->type_fetch_count += 1;
            }
        }
    }
    free(samples.inputs);
    free(samples.outputs);
    free(samples.groups);

    // C's columns. The contexts' values are few: a dense code each, so that a context is an input as any other.
    lanes->up = lanes_column(count);
    lanes->index = lanes_column(count);
    lanes->context = lanes_column(count);
    lanes->context_dense = lanes_column(count);
    lanes->target_class = lanes_column(count);
    lanes->target_facts = lanes_column(count);
    lanes->context_given = lanes_column(count);
    lanes->refused = lanes_column(count);
    lanes->context_layout = lanes_column(count);
    bool seen[256] = { false };
    for (uint32_t g = 0; g < count; g += 1)
    {
        seen[unit->context_truth[g]] = true;
    }
    for (uint32_t v = 0; v < 256; v += 1)
    {
        if (seen[v])
        {
            if (lanes->context_values == 64)
            {
                fprintf(stderr, "lanes: more than 64 contexts\n");
                exit(1);
            }
            lanes->dense_of_context[v] = (uint8_t)lanes->context_values;
            lanes->context_of_dense[lanes->context_values] = (uint8_t)v;
            lanes->context_values += 1;
        }
    }
    CensusTable operands = { .name = "C", .input_count = LANES_C_INPUTS, .output_count = LANES_C_ANSWERS, .derived_first = LANES_C_EQUAL_PARENT };
    operands.withheld[0] = UINT64_C(1) << LANES_C_OWN_CONTEXT;
    for (uint32_t g = 0; g < count; g += 1)
    {
        const uint8_t op = unit->op[g];
        const bool given = unit->parent[g] == NONE || operands_given[unit->op[unit->parent[g]]] || unit->op[unit->parent[g]] >= OPS;
        lanes->context_given[g] = given ? 0xff : 0;
        if (given)
        {
            lanes->context[g] = unit->context_truth[g];
            lanes->context_dense[g] = lanes->dense_of_context[unit->context_truth[g]];
            lanes->target_class[g] = lanes_dense_class((uint8_t)unit->target_truth[g]);
            lanes->target_facts[g] = (uint8_t)(unit->target_truth[g] >> 8);
        }
        if (unit->parent[g] != NONE)
        {
            const uint32_t distance = unit->parent[g] - g;
            lanes->up[g] = (uint8_t)(distance <= 64 ? distance : 0);
            lanes->context_layout[g] |= distance > 64 ? LANES_LAYOUT_FAR : 0;
        }
        if (unit->operand_count[g] != 0)
        {
            uint32_t index = 0;
            for (uint32_t c = unit->first_child[g]; c != NONE; c = unit->next_sibling[c])
            {
                lanes->index[c] = (uint8_t)(index > 3 ? 3 : index);
                // An operand of a record whose own operands are out of reach reads them, and is out of reach too.
                lanes->context_layout[c] |= (lanes->layout[g] & LANES_LAYOUT_FAR) != 0 ? LANES_LAYOUT_FAR : 0;
                if (!operands_given[op] && op < OPS)
                {
                    uint64_t answer;
                    const bool found = table_find(&tables->context, context_key(unit, unit->code_truth, unit->context_truth, g, index, c), &answer);
                    lanes->refused[c] = found ? 0 : 0xff;
                    if (!found)
                    {
                        // The first path leaves the truth where its table has no answer, and so does this one.
                        lanes->context_given[c] = 0xff;
                        lanes->context[c] = unit->context_truth[c];
                        lanes->context_dense[c] = lanes->dense_of_context[unit->context_truth[c]];
                        lanes->target_class[c] = lanes_dense_class((uint8_t)unit->target_truth[c]);
                        lanes->target_facts[c] = (uint8_t)(unit->target_truth[c] >> 8);
                    }
                    if (found)
                    {
                        uint8_t inputs[CENSUS_INPUTS_MOST] = { 0 };
                        uint32_t outputs[CENSUS_OUTPUTS_MOST] = { 0 };
                        lanes_context_inputs(lanes, unit, g, index, c, inputs);
                        outputs[0] = lanes->dense_of_context[unit->context_truth[c]];
                        outputs[1] = lanes_dense_class((uint8_t)unit->target_truth[c]);
                        outputs[2] = unit->target_truth[c] >> 8;
                        census_add(&operands, op, inputs, outputs);
                    }
                }
                index += 1;
            }
        }
    }
    lanes->context_answers = must(aligned_alloc(64, LANES_C_ANSWERS * sizeof(LanesAnswer)));
    for (uint32_t a = 0; a < LANES_C_ANSWERS; a += 1)
    {
        lanes_answer_learn(&lanes->context_answers[a], &operands, a, lanes->dense_of_operator);
    }
    lanes_program_make(&lanes->context_program, lanes->context_answers, LANES_C_ANSWERS);
    free(operands.inputs);
    free(operands.outputs);
    free(operands.groups);

    // X's columns, and the templates' table learned from the truth's keys as the first path's is.
    lanes->counts_whole = lanes_column(count);
    lanes->given_store = lanes_column(count);
    lanes->store = lanes_column(count);
    lanes->marks = lanes_column(count);
    lanes->marks_made = lanes_column(count);
    lanes->root_of = must(calloc((uint64_t)count + 1, sizeof(uint32_t)));
    lanes->places = must(aligned_alloc(64, (((uint64_t)count + 64) * sizeof(uint64_t) + 63) & ~UINT64_C(63)));
    lanes->longs = must(aligned_alloc(64, (((uint64_t)count + 64) * sizeof(uint32_t) + 63) & ~UINT64_C(63)));
    lanes->gaps = lanes_column(count);
    lanes->special = must(aligned_alloc(64, (((uint64_t)count + 64) * sizeof(uint32_t) + 63) & ~UINT64_C(63)));
    lanes->barred = must(aligned_alloc(64, (((uint64_t)count + 64) * sizeof(uint32_t) + 63) & ~UINT64_C(63)));
    lanes->span8 = lanes_column(count);
    for (uint32_t r = 0; r < unit->root_count; r += 1)
    {
        for (uint32_t g = unit->root_first[r]; g <= unit->roots[r]; g += 1)
        {
            lanes->root_of[g] = r;
        }
    }
    lanes->hashes = must(aligned_alloc(64, ((uint64_t)lanes->blocks + 2) * 64 * sizeof(uint64_t)));
    memset(lanes->hashes, 0, ((uint64_t)lanes->blocks + 2) * 64 * sizeof(uint64_t));
    lanes->chosen = must(aligned_alloc(64, (((uint64_t)count + 64) * sizeof(uint32_t) + 63) & ~UINT64_C(63)));
    memset(lanes->chosen, 0, ((uint64_t)count + 64) * sizeof(uint32_t));
    lanes->chosen_kept = must(calloc((uint64_t)count + 64, sizeof(uint32_t)));
    // A record's subtree's records, for the place of an early root's entries.
    lanes->spans = must(calloc((uint64_t)count + 1, sizeof(uint32_t)));
    uint32_t widest = 0;
    for (uint32_t g = 0; g < count; g += 1)
    {
        uint32_t span = 1;
        for (uint32_t c = unit->first_child[g]; c != NONE; c = unit->next_sibling[c])
        {
            span += lanes->spans[c];
        }
        lanes->spans[g] = span;
        lanes->span8[g] = (uint8_t)(span < 255 ? span : 255);
        widest = span > widest ? span : widest;
    }
    lanes->store_operator = must(aligned_alloc(64, 128));
    memset(lanes->store_operator, 0, 128);
    for (uint32_t op = OP_PRE_INCREMENT; op <= OP_BIT_XOR_ASSIGN; op += 1)
    {
        lanes->store_operator[op] = 0xff;
    }
    lanes->store_operator[OP_ASSIGN] = 0xff;
    for (uint32_t g = 0; g < count; g += 1)
    {
        lanes->marks_made[g] = (uint8_t)((lanes->refused[g] != 0 ? LANES_MARK_REFUSED : 0) | ((lanes->layout[g] | lanes->context_layout[g]) != 0 ? LANES_MARK_LAYOUT : 0));
    }
    for (uint32_t r = 0; r < unit->root_count; r += 1)
    {
        lanes->marks_made[unit->roots[r]] |= LANES_MARK_ROOT;
    }
    memcpy(lanes->marks, lanes->marks_made, count);
    // The table's keys with their hashes: a hash two keys share is refused here, since the table tells keys apart by
    // their hashes alone.
    typedef struct Learned Learned;
    struct Learned
    {
        uint64_t low;
        uint64_t high;
        uint64_t hash;
        uint32_t op;
        uint32_t value;
        bool used;
    };
    uint32_t log2 = 8;
    while ((UINT64_C(1) << log2) < (uint64_t)count * 2)
    {
        log2 += 1;
    }
    const uint64_t learned_mask = (UINT64_C(1) << log2) - 1;
    Learned* learned = must(calloc(learned_mask + 1, sizeof(Learned)));
    for (uint32_t g = 0; g < count; g += 1)
    {
        const uint8_t op = unit->op[g] < OPS ? unit->op[g] : 0;
        const uint32_t whole = unit->operand_count[g];
        lanes->counts_whole[g] = (uint8_t)whole;
        lanes->given_store[g] = unit->store[g];
        // The key from the truth, in this path's bytes.
        uint8_t key[16] = { 0 };
        key[0] = unit->context_truth[g];
        key[1] = lanes_dense_class((uint8_t)unit->target_truth[g]);
        key[2] = (uint8_t)(unit->target_truth[g] >> 8);
        key[3] = store_of(unit, unit->facts_truth, g);
        key[4] = (uint8_t)whole;
        if (unit->op[g] != OP_VALUE)
        {
            const uint32_t packed = operand_types_of(unit, unit->facts_truth, g);
            memcpy(key + 5, &packed, 4);
            key[5] = lanes_dense_class(key[5]);
            key[7] = lanes_dense_class(key[7]);
        }
        memcpy(key + 9, &unit->facts_truth[g], LANES_FACTS);
        key[9] = lanes_dense_class(key[9]);
        if (key[15] > 1 || op > 127)
        {
            fprintf(stderr, "lanes: a key's last byte or its operator is past the hash's room\n");
            exit(1);
        }
        uint64_t low;
        uint64_t high;
        memcpy(&low, key, 8);
        memcpy(&high, key + 8, 8);
        const uint64_t hash = lanes_key_hash(low, high, op);
        const uint32_t value = unit->refused[g] == 0 ? unit->template_truth[g] : (uint32_t)NO_TEMPLATE;
        uint64_t slot = hash >> (64 - log2);
        while (learned[slot].used && learned[slot].hash != hash)
        {
            slot = (slot + 1) & learned_mask;
        }
        if (!learned[slot].used)
        {
            learned[slot] = (Learned){ .low = low, .high = high, .hash = hash, .op = op, .value = value, .used = true };
            lanes->slot_keys += 1;
        }
        else
        {
            if (learned[slot].low != low || learned[slot].high != high || learned[slot].op != op)
            {
                fprintf(stderr, "lanes: two keys of one hash: %016llx %016llx op %u and %016llx %016llx op %u, hash %016llx\n", (unsigned long long)learned[slot].low,
                        (unsigned long long)learned[slot].high, learned[slot].op, (unsigned long long)low, (unsigned long long)high, op, (unsigned long long)hash);
                exit(1);
            }
            if (learned[slot].value != value)
            {
                lanes->slot_conflicts += learned[slot].value != (uint32_t)NO_TEMPLATE || value != (uint32_t)NO_TEMPLATE;
                learned[slot].value = (uint32_t)NO_TEMPLATE;
            }
        }
    }
    // The table in the fewest buckets that hold every key, from a third full on: a bucket's values are its keys'
    // templates with their entry counts and whether they write early, or the missed mark.
    uint32_t compact_log2 = 4;
    while ((UINT64_C(4) << compact_log2) < lanes->slot_keys * 3)
    {
        compact_log2 += 1;
    }
    bool placed = false;
    while (!placed)
    {
        lanes->slot_mask = (UINT64_C(1) << compact_log2) - 1;
        lanes->slot_shift = 64 - compact_log2;
        lanes->slots = must(aligned_alloc(64, (lanes->slot_mask + 1) * sizeof(LanesSlot)));
        memset(lanes->slots, 0, (lanes->slot_mask + 1) * sizeof(LanesSlot));
        for (uint64_t i = 0; i <= lanes->slot_mask; i += 1)
        {
            for (uint32_t place = 0; place < 8; place += 1)
            {
                lanes->slots[i].values[place] = LANES_CHOSEN_MISSED;
            }
        }
        placed = true;
        for (uint64_t i = 0; placed && i <= learned_mask; i += 1)
        {
            if (learned[i].used)
            {
                LanesSlot* bucket = &lanes->slots[learned[i].hash >> lanes->slot_shift];
                uint32_t place = 0;
                while (place < 4 && bucket->checks[place] != 0)
                {
                    place += 1;
                }
                placed = place < 4;
                if (placed)
                {
                    const uint32_t value = learned[i].value;
                    bucket->checks[place] = learned[i].hash;
                    bucket->values[place] = value == (uint32_t)NO_TEMPLATE ? LANES_CHOSEN_MISSED :
                                            value | (uint32_t)unit->templates[value].total << LANES_CHOSEN_TOTAL_SHIFT | (unit->templates[value].early ? LANES_CHOSEN_EARLY : 0);
                }
            }
        }
        if (!placed)
        {
            free(lanes->slots);
            compact_log2 += 1;
        }
    }
    free(learned);
    // The templates' first eight kinds and classes as one row of 16 bytes, for X's one load a record.
    lanes->rows = must(aligned_alloc(64, (((uint64_t)unit->template_count + 4) * 16 + 63) & ~UINT64_C(63)));
    for (uint32_t t = 0; t < unit->template_count; t += 1)
    {
        memcpy(lanes->rows + (uint64_t)t * 16, unit->templates[t].kinds, 8);
        memcpy(lanes->rows + (uint64_t)t * 16 + 8, unit->templates[t].classes, 8);
    }
}

// Record `g`'s facts from the truth: the scalar path of a record the layout doesn't take.
static void lanes_type_scalar(Lanes* lanes, const Unit* unit, uint32_t g, uint8_t why)
{
    uint8_t facts[LANES_FACTS];
    memcpy(facts, &unit->facts_truth[g], LANES_FACTS);
    facts[0] = lanes_dense_class(facts[0]);
    for (uint32_t f = 0; f < LANES_FACTS; f += 1)
    {
        lanes->facts[f][g] = facts[f];
    }
    lanes->typed[g] = 0xff;
    lanes->layout[g] |= why;
    lanes->marks[g] |= LANES_MARK_LAYOUT;
    lanes->far_records += (why & LANES_LAYOUT_FAR) != 0;
    lanes->wide_records += (why & LANES_LAYOUT_WIDE) != 0;
}

// T over blocks [first, end): each table-typed record's facts from its operands', in rounds. A block's part of the
// program is prepared once, by its operators; a round types the records whose rules' operands are typed, and a block
// is done when none is left.
static __attribute__((noinline)) void lanes_types(Lanes* lanes, const Unit* unit, uint32_t first, uint32_t end)
{
    const LanesProgram* program = &lanes->type_program;
    (void)program;
    const __m512i lane = _mm512_set_epi8(63, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40, 39, 38, 37, 36, 35, 34, 33, 32, 31,
                                         30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0);
    const __m512i here = _mm512_add_epi8(lane, _mm512_set1_epi8(64));
    const __m512i int_class = _mm512_set1_epi8(CENSUS_CLASS_INT);
    const __m512i needs_of = _mm512_load_si512(lanes->type_needs);
#ifdef LANES_BAKED
    const bool third = (BAKED_t_USED >> LANES_T_GREATEST1C & 1) != 0;
#else
    const bool third = (program->used >> LANES_T_GREATEST1C & 1) != 0;
    const uint32_t fetch_count = lanes->type_fetch_count;
#endif
    uint64_t rounds = 0;
    for (uint32_t block = first; block < end; block += 1)
    {
        const uint64_t base = (uint64_t)block * 64;
        const __m512i operators = _mm512_load_si512(lanes->operators + base);
        __m512i before[LANES_FACTS];
        __m512i facts[LANES_FACTS];
        for (uint32_t f = 0; f < LANES_FACTS; f += 1)
        {
            before[f] = _mm512_load_si512(lanes->facts[f] + base - 64);
            facts[f] = _mm512_load_si512(lanes->facts[f] + base);
        }
        __m512i graph_places[2];
        __mmask64 graph_has[2];
        __m512i given[4];
        for (uint32_t k = 0; k < 2; k += 1)
        {
            const __m512i distance = _mm512_load_si512(lanes->graph[k] + base);
            graph_places[k] = _mm512_sub_epi8(here, distance);
            graph_has[k] = _mm512_test_epi8_mask(distance, distance);
            given[2 * k] = _mm512_load_si512(lanes->given_types[2 * k] + base);
            given[2 * k + 1] = _mm512_load_si512(lanes->given_types[2 * k + 1] + base);
        }
        __m512i typed = _mm512_load_si512(lanes->typed + base);
        const __mmask64 by_table = _mm512_movepi8_mask(_mm512_load_si512(lanes->by_table + base));
        __mmask64 pending = by_table & ~_mm512_movepi8_mask(typed);
        if (pending != 0)
        {
            const __m512i typed_before = _mm512_load_si512(lanes->typed + base - 64);
            const __m512i dense = _mm512_load_si512(lanes->operators_dense + base);
            const __m512i needs = _mm512_permutexvar_epi8(dense, needs_of);
            __m512i places[3];
            __mmask64 has[3];
            // The operands a record waits for: those its operator's rules read.
            __mmask64 waits[5];
            for (uint32_t k = 0; k < 3; k += 1)
            {
                const __m512i distance = _mm512_load_si512(lanes->children[k] + base);
                places[k] = _mm512_sub_epi8(here, distance);
                has[k] = _mm512_test_epi8_mask(distance, distance);
                waits[k] = has[k] & _mm512_test_epi8_mask(needs, _mm512_set1_epi8((char)(1u << k)));
            }
            for (uint32_t k = 0; k < 2; k += 1)
            {
                waits[3 + k] = graph_has[k] & _mm512_test_epi8_mask(needs, _mm512_set1_epi8((char)(8u << k)));
            }
            LanesBlock state;
#ifdef LANES_BAKED
            baked_t_prepare(dense, pending, facts, &state);
#else
            lanes_block_prepare(program, dense, pending, facts, &state);
#endif
            __m512i inputs[LANES_T_INPUTS];
            inputs[LANES_T_COUNT] = _mm512_load_si512(lanes->operand_counts + base);
            while (pending != 0)
            {
                // The records whose rules' operands are all typed.
                __mmask64 ready = pending;
                for (uint32_t k = 0; k < 3; k += 1)
                {
                    ready &= ~waits[k] | _mm512_movepi8_mask(_mm512_permutex2var_epi8(typed_before, places[k], typed));
                }
                for (uint32_t k = 0; k < 2; k += 1)
                {
                    ready &= ~waits[3 + k] | _mm512_movepi8_mask(_mm512_permutex2var_epi8(typed_before, graph_places[k], typed));
                }
                // The inputs the unit's rules read.
                for (uint32_t k = 0; k < 2; k += 1)
                {
                    for (uint32_t f = 0; f < 2; f += 1)
                    {
                        const __m512i type = _mm512_mask_permutex2var_epi8(before[f], graph_has[k], graph_places[k], facts[f]);
                        inputs[LANES_T_TYPE0 + 2 * k + f] = _mm512_mask_mov_epi8(given[2 * k + f], graph_has[k], type);
                    }
                }
#ifdef LANES_BAKED
                baked_t_fetch(inputs, has, before, places, facts);
#else
                for (uint32_t i = 0; i < fetch_count; i += 1)
                {
                    const uint32_t k = lanes->type_fetch[i][1];
                    const uint32_t f = lanes->type_fetch[i][2];
                    inputs[lanes->type_fetch[i][0]] = _mm512_maskz_permutex2var_epi8(has[k], before[f], places[k], facts[f]);
                }
#endif
                inputs[LANES_T_GREATEST01] = _mm512_max_epu8(_mm512_max_epu8(inputs[LANES_T_TYPE0], inputs[LANES_T_TYPE1]), int_class);
                inputs[LANES_T_GREATEST0] = _mm512_max_epu8(inputs[LANES_T_TYPE0], int_class);
                if (third)
                {
                    inputs[LANES_T_GREATEST1C] = _mm512_max_epu8(_mm512_max_epu8(inputs[LANES_T_TYPE1], inputs[LANES_T_OPERAND + 2 * LANES_FACTS]), int_class);
                }
                // A ready record one of whose answers has no rule, or no record ready (an operand out of reach):
                // the first such record takes the scalar path, and the round starts again.
                const __mmask64 scalar = ready != 0 ? ready & state.none : pending;
                if (scalar != 0)
                {
                    const uint32_t g = (uint32_t)(base + (uint64_t)__builtin_ctzll(scalar));
                    for (uint32_t f = 0; f < LANES_FACTS; f += 1)
                    {
                        _mm512_store_si512(lanes->facts[f] + base, facts[f]);
                    }
                    _mm512_store_si512(lanes->typed + base, typed);
                    lanes_type_scalar(lanes, unit, g, ready != 0 ? LANES_LAYOUT_WIDE : LANES_LAYOUT_FAR);
                    for (uint32_t f = 0; f < LANES_FACTS; f += 1)
                    {
                        facts[f] = _mm512_load_si512(lanes->facts[f] + base);
                    }
                    typed = _mm512_load_si512(lanes->typed + base);
                    pending = by_table & ~_mm512_movepi8_mask(typed);
                }
                else
                {
#ifdef LANES_BAKED
                    facts[0] = baked_t_answer_0(&state, facts[0], ready, inputs);
                    facts[1] = baked_t_answer_1(&state, facts[1], ready, inputs);
                    facts[2] = baked_t_answer_2(&state, facts[2], ready, inputs);
                    facts[3] = baked_t_answer_3(&state, facts[3], ready, inputs);
                    facts[4] = baked_t_answer_4(&state, facts[4], ready, inputs);
                    facts[5] = baked_t_answer_5(&state, facts[5], ready, inputs);
                    facts[6] = baked_t_answer_6(&state, facts[6], ready, inputs);
#else
                    for (uint32_t a = 0; a < LANES_FACTS; a += 1)
                    {
                        facts[a] = lanes_block_answer(program, &state, a, facts[a], ready, inputs);
                    }
#endif
                    typed = _mm512_mask_mov_epi8(typed, ready, _mm512_set1_epi8((char)0xff));
                    pending &= ~ready;
                }
                rounds += 1;
            }
            for (uint32_t f = 0; f < LANES_FACTS; f += 1)
            {
                _mm512_store_si512(lanes->facts[f] + base, facts[f]);
            }
            _mm512_store_si512(lanes->typed + base, typed);
        }
        // A store's destination's kind, as the lowering's key has it: none for no store, the given one where the
        // destination isn't the record's evaluated operand, 0xff for a destination that is no object's value.
        {
            const __m512i destination = _mm512_mask_permutex2var_epi8(_mm512_load_si512(lanes->operators + base - 64), graph_has[0], graph_places[0], operators);
            const __mmask64 value = graph_has[0] & _mm512_testn_epi8_mask(destination, destination);
            const __m512i object = _mm512_maskz_permutex2var_epi8(value, before[5], graph_places[0], facts[5]);
            const __mmask64 no_object = _mm512_testn_epi8_mask(object, _mm512_set1_epi8(3));
            __m512i store = _mm512_mask_mov_epi8(_mm512_and_si512(object, _mm512_set1_epi8(0x0b)), no_object, _mm512_set1_epi8((char)0xff));
            store = _mm512_mask_mov_epi8(_mm512_load_si512(lanes->given_store + base), graph_has[0], store);
            const __mmask64 stores = _mm512_movepi8_mask(_mm512_permutex2var_epi8(_mm512_load_si512(lanes->store_operator), operators, _mm512_load_si512(lanes->store_operator + 64)));
            _mm512_store_si512(lanes->store + base, _mm512_maskz_mov_epi8(stores, store));
        }
        // Every record's first two operands' types, for the template's key: a leaf's are none.
        const __mmask64 with_operands = _mm512_test_epi8_mask(operators, operators);
        for (uint32_t k = 0; k < 2; k += 1)
        {
            for (uint32_t f = 0; f < 2; f += 1)
            {
                __m512i type = _mm512_mask_permutex2var_epi8(before[f], graph_has[k], graph_places[k], facts[f]);
                type = _mm512_mask_mov_epi8(given[2 * k + f], graph_has[k], type);
                _mm512_store_si512(lanes->types[2 * k + f] + base, _mm512_maskz_mov_epi8(with_operands, type));
            }
        }
    }
    lanes->type_rounds += rounds;
    lanes->type_blocks += end - first;
}

// Record `g`'s context and target from the truth: the scalar path of an operand the layout doesn't take.
static void lanes_context_scalar(Lanes* lanes, const Unit* unit, uint32_t g, uint8_t why)
{
    lanes->context[g] = unit->context_truth[g];
    lanes->context_dense[g] = lanes->dense_of_context[unit->context_truth[g]];
    lanes->target_class[g] = lanes_dense_class((uint8_t)unit->target_truth[g]);
    lanes->target_facts[g] = (uint8_t)(unit->target_truth[g] >> 8);
    lanes->context_layout[g] |= why;
    lanes->marks[g] |= LANES_MARK_LAYOUT;
    lanes->context_scalar += 1;
}

// A column's bytes at `places` in three blocks: `places` counts from the block before's first byte.
static inline __m512i lanes_reach(__m512i before, __m512i block, __m512i after, __m512i places)
{
    const __m512i low = _mm512_permutex2var_epi8(before, places, block);
    const __m512i high = _mm512_permutex2var_epi8(block, _mm512_sub_epi8(places, _mm512_set1_epi8(64)), after);
    return _mm512_mask_blend_epi8(_mm512_cmpge_epu8_mask(places, _mm512_set1_epi8((char)128)), low, high);
}

// C over blocks [first, end), the last first: each operand's context from its parent's and their facts, in rounds
// until no context of the block changes, then its target. A block's part of the program is prepared once, by its
// parents' operators.
static __attribute__((noinline)) void lanes_contexts(Lanes* lanes, const Unit* unit, uint32_t first, uint32_t end)
{
    const LanesProgram* program = &lanes->context_program;
    const __m512i lane = _mm512_set_epi8(63, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40, 39, 38, 37, 36, 35, 34, 33, 32, 31,
                                         30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0);
    const __m512i here = _mm512_add_epi8(lane, _mm512_set1_epi8(64));
    const __m512i int_class = _mm512_set1_epi8(CENSUS_CLASS_INT);
    const __m512i one = _mm512_set1_epi8(1);
    const __m512i no_class = _mm512_set1_epi8((char)LANES_CLASS_NONE);
    const __m512i context_of_dense = _mm512_load_si512(lanes->context_of_dense);
    const uint64_t facts_mask = (UINT64_C(1) << LANES_FACTS) - 1;
    // What the unit's rules read, and what the derived inputs read.
#ifdef LANES_BAKED
    uint64_t need = BAKED_c_USED;
#else
    uint64_t need = program->used;
#endif
    const bool equal_parent = (need >> LANES_C_EQUAL_PARENT & 1) != 0 || (need >> LANES_C_WANTED_PARENT & 1) != 0;
    const bool greatest = (need >> LANES_C_GREATEST & 1) != 0 || (need >> LANES_C_EQUAL_GREATEST & 1) != 0 || (need >> LANES_C_WANTED_GREATEST & 1) != 0;
    need |= equal_parent ? UINT64_C(1) << LANES_C_PARENT : 0;
    need |= greatest ? UINT64_C(1) << LANES_C_FIRST | UINT64_C(1) << LANES_C_SECOND : 0;
    const bool firsts_read = (need >> LANES_C_FIRST & facts_mask) != 0;
    const bool seconds_read = (need >> LANES_C_SECOND & facts_mask) != 0;
    const bool contexts = program->copy_firsts[1] != program->copy_firsts[0] || program->step_firsts[1] != program->step_firsts[0];
    uint64_t rounds = 0;
    for (uint32_t block = end; block-- > first;)
    {
        const uint64_t base = (uint64_t)block * 64;
        const __m512i up = _mm512_load_si512(lanes->up + base);
        const __mmask64 has_parent = _mm512_test_epi8_mask(up, up);
        const __mmask64 given = _mm512_movepi8_mask(_mm512_load_si512(lanes->context_given + base));
        const __m512i layout = _mm512_load_si512(lanes->context_layout + base);
        const __mmask64 out_of_reach = ~given & _mm512_test_epi8_mask(layout, layout);
        const __mmask64 live = has_parent & ~given & ~out_of_reach;
        __mmask64 none = 0;
        if (live != 0)
        {
            // The parent's columns are in this block or the next.
            const __m512i parent = _mm512_add_epi8(lane, up);
            const __m512i dense_operators = _mm512_load_si512(lanes->operators_dense + base);
            const __m512i parents = _mm512_permutex2var_epi8(dense_operators, parent, _mm512_load_si512(lanes->operators_dense + base + 64));
            __m512i values[LANES_C_ANSWERS];
            values[0] = _mm512_load_si512(lanes->context_dense + base);
            values[1] = _mm512_load_si512(lanes->target_class + base);
            values[2] = _mm512_load_si512(lanes->target_facts + base);
            LanesBlock state;
#ifdef LANES_BAKED
            baked_c_prepare(parents, live, values, &state);
#else
            lanes_block_prepare(program, parents, live, values, &state);
#endif
            none = state.none;
            __m512i inputs[LANES_C_INPUTS];
            if ((need >> LANES_C_COUNT & 1) != 0)
            {
                inputs[LANES_C_COUNT] = _mm512_permutex2var_epi8(_mm512_load_si512(lanes->operand_counts + base), parent, _mm512_load_si512(lanes->operand_counts + base + 64));
            }
            inputs[LANES_C_INDEX] = _mm512_load_si512(lanes->index + base);
            inputs[LANES_C_OPERATOR] = dense_operators;
            // The parent's first two operands are before the parent by its own distances: before or after this record.
            __m512i first_place = _mm512_setzero_si512();
            __m512i second_place = _mm512_setzero_si512();
            __mmask64 has_first = 0;
            __mmask64 has_second = 0;
            if (firsts_read)
            {
                const __m512i distance = _mm512_permutex2var_epi8(_mm512_load_si512(lanes->children[0] + base), parent, _mm512_load_si512(lanes->children[0] + base + 64));
                has_first = _mm512_test_epi8_mask(distance, distance);
                first_place = _mm512_sub_epi8(_mm512_add_epi8(here, up), distance);
            }
            if (seconds_read)
            {
                const __m512i distance = _mm512_permutex2var_epi8(_mm512_load_si512(lanes->children[1] + base), parent, _mm512_load_si512(lanes->children[1] + base + 64));
                has_second = _mm512_test_epi8_mask(distance, distance);
                second_place = _mm512_sub_epi8(_mm512_add_epi8(here, up), distance);
            }
            for (uint32_t f = 0; f < LANES_FACTS; f += 1)
            {
                const __m512i facts = _mm512_load_si512(lanes->facts[f] + base);
                inputs[LANES_C_OWN + f] = facts;
                const bool parent_read = (need >> (LANES_C_PARENT + f) & 1) != 0;
                const bool first_read = (need >> (LANES_C_FIRST + f) & 1) != 0;
                const bool second_read = (need >> (LANES_C_SECOND + f) & 1) != 0;
                if (parent_read || first_read || second_read)
                {
                    const __m512i after = _mm512_load_si512(lanes->facts[f] + base + 64);
                    if (parent_read)
                    {
                        inputs[LANES_C_PARENT + f] = _mm512_permutex2var_epi8(facts, parent, after);
                    }
                    if (first_read || second_read)
                    {
                        const __m512i before = _mm512_load_si512(lanes->facts[f] + base - 64);
                        if (first_read)
                        {
                            inputs[LANES_C_FIRST + f] = _mm512_maskz_mov_epi8(has_first, lanes_reach(before, facts, after, first_place));
                        }
                        if (second_read)
                        {
                            inputs[LANES_C_SECOND + f] = _mm512_maskz_mov_epi8(has_second, lanes_reach(before, facts, after, second_place));
                        }
                    }
                }
            }
            if (equal_parent)
            {
                const __mmask64 equal = _mm512_cmpeq_epi8_mask(inputs[LANES_C_OWN], inputs[LANES_C_PARENT]);
                inputs[LANES_C_EQUAL_PARENT] = _mm512_maskz_mov_epi8(equal, one);
                inputs[LANES_C_WANTED_PARENT] = _mm512_mask_mov_epi8(inputs[LANES_C_PARENT], equal, no_class);
            }
            if (greatest)
            {
                inputs[LANES_C_GREATEST] = _mm512_max_epu8(_mm512_max_epu8(inputs[LANES_C_FIRST], inputs[LANES_C_SECOND]), int_class);
                const __mmask64 equal = _mm512_cmpeq_epi8_mask(inputs[LANES_C_OWN], inputs[LANES_C_GREATEST]);
                inputs[LANES_C_EQUAL_GREATEST] = _mm512_maskz_mov_epi8(equal, one);
                inputs[LANES_C_WANTED_GREATEST] = _mm512_mask_mov_epi8(inputs[LANES_C_GREATEST], equal, no_class);
            }
            // The contexts: a rule that reads the parent's context is evaluated again while a context of the block
            // changes.
            const __m512i dense_after = _mm512_load_si512(lanes->context_dense + base + 64);
            __m512i dense = values[0];
            bool changed = contexts;
            while (changed)
            {
                inputs[LANES_C_CONTEXT] = _mm512_permutex2var_epi8(dense, parent, dense_after);
#ifdef LANES_BAKED
                const __m512i next = baked_c_answer_0(&state, dense, ~UINT64_C(0), inputs);
#else
                const __m512i next = lanes_block_answer(program, &state, 0, dense, ~UINT64_C(0), inputs);
#endif
                changed = (_mm512_cmpneq_epi8_mask(next, dense) & ~none) != 0;
                dense = next;
                rounds += 1;
            }
            // The targets, with every context of the block final.
            inputs[LANES_C_CONTEXT] = _mm512_permutex2var_epi8(dense, parent, dense_after);
            inputs[LANES_C_OWN_CONTEXT] = dense;
#ifdef LANES_BAKED
            values[1] = baked_c_answer_1(&state, values[1], ~UINT64_C(0), inputs);
            values[2] = baked_c_answer_2(&state, values[2], ~UINT64_C(0), inputs);
#else
            for (uint32_t a = 1; a < LANES_C_ANSWERS; a += 1)
            {
                values[a] = lanes_block_answer(program, &state, a, values[a], ~UINT64_C(0), inputs);
            }
#endif
            const __mmask64 taken = live & ~none;
            _mm512_mask_storeu_epi8(lanes->context_dense + base, taken, dense);
            _mm512_mask_storeu_epi8(lanes->context + base, taken, _mm512_permutexvar_epi8(dense, context_of_dense));
            _mm512_mask_storeu_epi8(lanes->target_class + base, taken, values[1]);
            _mm512_mask_storeu_epi8(lanes->target_facts + base, taken, values[2]);
        }
        // The operands out of the layout's reach, and those with no rule.
        __mmask64 scalar = out_of_reach | (live & none);
        while (scalar != 0)
        {
            const uint32_t g = (uint32_t)(base + (uint64_t)__builtin_ctzll(scalar));
            lanes_context_scalar(lanes, unit, g, (live & none) >> (g - base) & 1 ? LANES_LAYOUT_WIDE : 0);
            scalar &= scalar - 1;
        }
    }
    lanes->context_rounds += rounds;
    lanes->context_blocks += end - first;
}

// The order the hashes of a block are stored in: its place j holds the block's record 16 (j mod 8 / 2) + 2 (j / 8) +
// j mod 2, since the keys' halves come out of the interleaving eight records at a time in that order.
static const uint8_t lanes_hash_order[64] __attribute__((aligned(64))) = {
    0,  1,  16, 17, 32, 33, 48, 49, 2,  3,  18, 19, 34, 35, 50, 51, 4,  5,  20, 21, 36, 37, 52, 53, 6,  7,  22, 23, 38, 39, 54, 55,
    8,  9,  24, 25, 40, 41, 56, 57, 10, 11, 26, 27, 42, 43, 58, 59, 12, 13, 28, 29, 44, 45, 60, 61, 14, 15, 30, 31, 46, 47, 62, 63,
};

// The templates' keys' hashes of blocks [first, end): the 16 columns of a record's key interleaved into its two
// halves, eight records to a vector, and hashed there with the record's operator.
static __attribute__((noinline)) void lanes_keys(Lanes* lanes, uint32_t first, uint32_t end)
{
    const __m512i multiplier_first = _mm512_set1_epi64((long long)LANES_HASH_FIRST);
    const __m512i multiplier_second = _mm512_set1_epi64((long long)LANES_HASH_SECOND);
    const __m512i order = _mm512_load_si512(lanes_hash_order);
    const __m512i low_bit = _mm512_set1_epi64(1);
    for (uint32_t block = first; block < end; block += 1)
    {
        const uint64_t base = (uint64_t)block * 64;
        __m512i v[16];
        v[0] = _mm512_load_si512(lanes->context + base);
        v[1] = _mm512_load_si512(lanes->target_class + base);
        v[2] = _mm512_load_si512(lanes->target_facts + base);
        v[3] = _mm512_load_si512(lanes->store + base);
        v[4] = _mm512_load_si512(lanes->counts_whole + base);
        for (uint32_t k = 0; k < 4; k += 1)
        {
            v[5 + k] = _mm512_load_si512(lanes->types[k] + base);
        }
        for (uint32_t f = 0; f < LANES_FACTS; f += 1)
        {
            v[9 + f] = _mm512_load_si512(lanes->facts[f] + base);
        }
        __m512i w[16];
        __m512i d[16];
        __m512i q[16];
        for (uint32_t j = 0; j < 8; j += 1)
        {
            w[2 * j] = _mm512_unpacklo_epi8(v[2 * j], v[2 * j + 1]);
            w[2 * j + 1] = _mm512_unpackhi_epi8(v[2 * j], v[2 * j + 1]);
        }
        for (uint32_t j = 0; j < 4; j += 1)
        {
            d[4 * j] = _mm512_unpacklo_epi16(w[4 * j], w[4 * j + 2]);
            d[4 * j + 1] = _mm512_unpackhi_epi16(w[4 * j], w[4 * j + 2]);
            d[4 * j + 2] = _mm512_unpacklo_epi16(w[4 * j + 1], w[4 * j + 3]);
            d[4 * j + 3] = _mm512_unpackhi_epi16(w[4 * j + 1], w[4 * j + 3]);
        }
        for (uint32_t j = 0; j < 2; j += 1)
        {
            for (uint32_t i = 0; i < 4; i += 1)
            {
                q[8 * j + 2 * i] = _mm512_unpacklo_epi32(d[8 * j + i], d[8 * j + 4 + i]);
                q[8 * j + 2 * i + 1] = _mm512_unpackhi_epi32(d[8 * j + i], d[8 * j + 4 + i]);
            }
        }
        // The operators in the hashes' order, a byte to a quadword.
        uint8_t ordered[64] __attribute__((aligned(64)));
        _mm512_store_si512(ordered, _mm512_permutexvar_epi8(order, _mm512_load_si512(lanes->operators + base)));
        uint64_t* hashes = lanes->hashes + base;
        for (uint32_t i = 0; i < 8; i += 1)
        {
            const __m512i operators = _mm512_slli_epi64(_mm512_cvtepu8_epi64(_mm_loadl_epi64((const __m128i*)(ordered + 8 * i))), 57);
            __m512i hash = _mm512_mullo_epi64(q[i], multiplier_first);
            hash = _mm512_xor_si512(hash, _mm512_srli_epi64(hash, 32));
            hash = _mm512_mullo_epi64(_mm512_xor_si512(hash, _mm512_or_si512(q[8 + i], operators)), multiplier_second);
            hash = _mm512_xor_si512(hash, _mm512_srli_epi64(hash, 32));
            _mm512_store_si512(hashes + 8 * i, _mm512_or_si512(_mm512_mullo_epi64(hash, multiplier_first), low_bit));
        }
    }
}

// The template of each record of blocks [first, end): its key's hash's bucket, the four hashes there compared at once,
// and the value at the one that is equal, or the fifth, the missed mark. No branch a record.
static __attribute__((noinline)) void lanes_choose(Lanes* lanes, uint32_t first, uint32_t end)
{
    const LanesSlot* slots = lanes->slots;
    const uint32_t shift = lanes->slot_shift;
    uint32_t* chosen = lanes->chosen;
    for (uint32_t block = first; block < end; block += 1)
    {
        const uint64_t base = (uint64_t)block * 64;
        const uint64_t* hashes = lanes->hashes + base;
        for (uint32_t j = 0; j < 64; j += 1)
        {
            const uint64_t hash = hashes[j];
            const LanesSlot* bucket = &slots[hash >> shift];
            const uint32_t equal = _mm256_cmpeq_epi64_mask(_mm256_load_si256((const __m256i*)bucket->checks), _mm256_set1_epi64x((long long)hash));
            chosen[base + lanes_hash_order[j]] = bucket->values[_tzcnt_u32(equal | 16)];
        }
    }
}

// The lanes of the 16 records from `group` on that are in [first, end).
static inline __mmask16 lanes_group(uint32_t group, uint32_t first, uint32_t end)
{
    const uint32_t low = first > group ? first - group : 0;
    const uint32_t high = end - group >= 16 ? 16 : end - group;
    return (__mmask16)(((1u << high) - 1) & ~((1u << low) - 1));
}

// The three records a record's early runs come before: its tree's first, the one after its first operand's tree and
// the one after its second's. With no such operand the run is next to the one after it, so the record is the same.
// From the byte columns the sweeps read: an operand's distance (none where it is out of reach, and then the record's
// root isn't taken) and the tree's length, whole where a byte doesn't hold it.
static inline void lanes_run_records(const Lanes* lanes, uint32_t record, uint32_t* before)
{
    const uint32_t distance0 = lanes->children[0][record];
    const uint32_t distance1 = lanes->children[1][record];
    const uint32_t span = lanes->span8[record];
    before[0] = record + 1 - (__builtin_expect(span == 255, 0) ? lanes->spans[record] : span);
    before[1] = distance0 != 0 ? record - distance0 + 1 : record;
    before[2] = distance1 != 0 ? record - distance1 + 1 : before[1];
}

// `length` entries of a template from `offset` on, at `at`, and no entry more.
static inline void lanes_copy_run(const Unit* unit, const Template* t, uint64_t payload, uint32_t offset, uint32_t length, uint64_t at)
{
    const __mmask32 bytes = (__mmask32)((UINT64_C(1) << length) - 1);
    _mm256_mask_storeu_epi8(unit->out_kinds + at, bytes, _mm256_maskz_loadu_epi8(bytes, t->kinds + offset));
    _mm256_mask_storeu_epi8(unit->out_classes + at, bytes, _mm256_maskz_loadu_epi8(bytes, t->classes + offset));
    for (uint32_t i = 0; i < length; i += 8)
    {
        const __mmask8 values = (__mmask8)(bytes >> i);
        _mm512_mask_storeu_epi64(unit->out_values + at + i, values, _mm512_maskz_loadu_epi64(values, unit->pool + payload + offset + i));
    }
}

// LANES_ROWS_VARIANT builds the rows' loop of X as one of a few experiments, for what bounds it.
#ifdef LANES_ROWS_VARIANT
static uint64_t lanes_sink __attribute__((unused));
#endif

// Every record's row at its place, four entries' room at once, with no branch: a record's place and its row's are
// one word, and the few records with more entries get the rest after.
static __attribute__((noinline)) void lanes_rows(const uint64_t* places, const uint32_t* payloads, const uint8_t* rows, const uint64_t* pool, uint8_t* out_kinds,
                                                 uint8_t* out_classes, uint64_t* out_values, uint32_t first, uint32_t end)
{
    for (uint32_t g = first; g < end; g += 1)
    {
        const uint64_t place = places[g];
        const uint64_t at = place >> 32;
        const uint64_t payload = payloads[g];
        const __m128i row = _mm_load_si128((const __m128i*)(rows + (uint32_t)place));
#ifndef LANES_ROWS_VARIANT
        _mm_storel_epi64((__m128i*)(out_kinds + at), row);
        _mm_storeh_pd((double*)(out_classes + at), _mm_castsi128_pd(row));
        _mm256_storeu_si256((__m256i*)(out_values + at), _mm256_loadu_si256((const __m256i*)(pool + payload)));
#elif LANES_ROWS_VARIANT == 1
        // An experiment (the entries are the same): the values as two stores of two.
        _mm_storel_epi64((__m128i*)(out_kinds + at), row);
        _mm_storeh_pd((double*)(out_classes + at), _mm_castsi128_pd(row));
        _mm_storeu_si128((__m128i*)(out_values + at), _mm_loadu_si128((const __m128i*)(pool + payload)));
        _mm_storeu_si128((__m128i*)(out_values + at + 2), _mm_loadu_si128((const __m128i*)(pool + payload + 2)));
#elif LANES_ROWS_VARIANT == 2
        // Experiments from here on, for the time alone (the entries are wrong): the values alone.
        lanes_sink += (uint64_t)_mm_cvtsi128_si64(row);
        _mm256_storeu_si256((__m256i*)(out_values + at), _mm256_loadu_si256((const __m256i*)(pool + payload)));
#elif LANES_ROWS_VARIANT == 3
        // The kinds and the classes alone.
        lanes_sink += payload;
        _mm_storel_epi64((__m128i*)(out_kinds + at), row);
        _mm_storeh_pd((double*)(out_classes + at), _mm_castsi128_pd(row));
#elif LANES_ROWS_VARIANT == 4
        // The values' store alone, of nothing read.
        lanes_sink += (uint64_t)_mm_cvtsi128_si64(row) + payload;
        _mm256_storeu_si256((__m256i*)(out_values + at), _mm256_setzero_si256());
#elif LANES_ROWS_VARIANT == 5
        // The reads alone.
        lanes_sink += (uint64_t)_mm_cvtsi128_si64(row) + at + (uint64_t)_mm256_extract_epi64(_mm256_loadu_si256((const __m256i*)(pool + payload)), 0);
#elif LANES_ROWS_VARIANT == 7 || LANES_ROWS_VARIANT == 8 || LANES_ROWS_VARIANT == 9
        // An experiment (the entries are the same): the streams' lines asked for ahead.
        _mm_storel_epi64((__m128i*)(out_kinds + at), row);
        _mm_storeh_pd((double*)(out_classes + at), _mm_castsi128_pd(row));
        _mm256_storeu_si256((__m256i*)(out_values + at), _mm256_loadu_si256((const __m256i*)(pool + payload)));
        __builtin_prefetch((const char*)(pool + payload) + (LANES_ROWS_VARIANT == 9 ? 1024 : 384), 0, 3);
        __builtin_prefetch((const char*)(out_values + at) + (LANES_ROWS_VARIANT == 9 ? 1024 : 384), 1, 3);
#if LANES_ROWS_VARIANT >= 8
        __builtin_prefetch((const char*)(places + g) + 512, 0, 3);
        __builtin_prefetch((const char*)(out_kinds + at) + 256, 1, 3);
        __builtin_prefetch((const char*)(out_classes + at) + 256, 1, 3);
#endif
#endif
    }
}

// X for roots [first_root, end_root), whose records are [first, end). An entry's place is a sum down the postorder:
// a record's entries follow the entries of the records before it. Two kinds of record change the sums, and both are
// few, so they are listed and taken one at a time:
//  - A record that writes before or between its operands. Its runs' room moves from its own entries to the room
//    before the records the runs come before (`gaps`); only its last run and its conversion stay its own.
//  - A record no root is taken with (no template, or a mark): its root's records get no room at all.
// Then the places are one sum of 16 records at a time, and every record's row is written at its place with no
// branch: four entries' room, which leaves what is past a record's fourth entry alone. The few records with more
// entries get those next, and the listed records' runs are written into their gaps last, the last record first: of
// the runs that share a gap, the outermost record's is first. Returns the entries' end.
static __attribute__((noinline)) uint64_t lanes_expand(Lanes* lanes, Unit* unit, const Template* templates, uint32_t first_root, uint32_t end_root, uint64_t out)
{
    const uint32_t first = unit->root_first[first_root];
    const uint32_t end = unit->roots[end_root - 1] + 1;
    const uint32_t first_group = first & ~15u;
    uint32_t* const chosen = lanes->chosen;
    uint8_t* const gaps = lanes->gaps;
    uint64_t* const places = lanes->places;
    uint32_t* const longs = lanes->longs;
    const uint8_t* const marks = lanes->marks;
    uint32_t* const special = lanes->special;
    const __m512i lane = _mm512_set_epi32(15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0);
    const uint64_t tick0 = __rdtsc();
    memset(unit->root_taken + first_root, 1, end_root - first_root);
    // The listed records: those that write early, and those no root is taken with.
    uint32_t* const barred = lanes->barred;
    uint64_t special_count = 0;
    uint64_t barred_count = 0;
    uint64_t long_count = 0;
    for (uint32_t group = first_group; group < end; group += 16)
    {
        const __mmask16 valid = lanes_group(group, first, end);
        const __m512i values = _mm512_load_si512(chosen + group);
        const __m128i mark = _mm_load_si128((const __m128i*)(marks + group));
        const __m512i records = _mm512_add_epi32(_mm512_set1_epi32((int)group), lane);
        const __mmask16 writes_early = valid & _mm512_test_epi32_mask(values, _mm512_set1_epi32((int)LANES_CHOSEN_EARLY));
        const __mmask16 bars = valid & (_mm512_test_epi32_mask(values, _mm512_set1_epi32((int)LANES_CHOSEN_MISSED)) |
                                        _mm_test_epi8_mask(mark, _mm_set1_epi8((char)(LANES_MARK_REFUSED | LANES_MARK_LAYOUT))));
        _mm512_storeu_si512(special + special_count, _mm512_maskz_compress_epi32(writes_early, records));
        special_count += (uint32_t)_mm_popcnt_u32(writes_early);
        _mm512_storeu_si512(barred + barred_count, _mm512_maskz_compress_epi32(bars, records));
        barred_count += (uint32_t)_mm_popcnt_u32(bars);
        const __mmask16 holds_more = valid & _mm512_cmpgt_epu32_mask(_mm512_and_si512(values, _mm512_set1_epi32((int)LANES_CHOSEN_TOTAL)),
                                                                     _mm512_set1_epi32((int)(4u << LANES_CHOSEN_TOTAL_SHIFT)));
        _mm512_storeu_si512(longs + long_count, _mm512_maskz_compress_epi32(holds_more, records));
        long_count += (uint32_t)_mm_popcnt_u32(holds_more);
    }
    const uint64_t tick1 = __rdtsc();
    // The early runs' room.
    for (uint64_t i = 0; i < special_count; i += 1)
    {
        const uint32_t record = special[i];
        const uint32_t value = chosen[record];
        const Template* t = templates + (value & LANES_CHOSEN_TEMPLATE);
        uint32_t before[3];
        lanes_run_records(lanes, record, before);
        uint32_t most = 0;
        for (uint32_t run = 0; run < 3; run += 1)
        {
            const uint32_t room = (uint32_t)gaps[before[run]] + t->runs[run];
            gaps[before[run]] = (uint8_t)room;
            most = room > most ? room : most;
        }
        const uint32_t tail = (uint32_t)t->runs[3] + t->converted;
        // A gap past a byte: the root goes to the first path.
        if (__builtin_expect(most > 255, 0))
        {
            lanes->gap_overflows += 1;
            barred[barred_count] = record;
            barred_count += 1;
        }
        chosen[record] = (value & ~LANES_CHOSEN_TOTAL) | tail << LANES_CHOSEN_TOTAL_SHIFT;
    }
    // The roots that aren't taken.
    for (uint64_t i = 0; i < barred_count; i += 1)
    {
        const uint32_t r = lanes->root_of[barred[i]];
        if (unit->root_taken[r])
        {
            const uint32_t root_first = unit->root_first[r];
            const uint32_t length = unit->roots[r] + 1 - root_first;
            unit->root_taken[r] = false;
            memset(chosen + root_first, 0, (uint64_t)length * sizeof(uint32_t));
            memset(gaps + root_first, 0, length);
        }
    }
    const uint64_t tick2 = __rdtsc();
    // The places: the entries before a record and the room before its own, with the record's row's place below.
    // The sum so far goes from one group to the next through one addition.
    const __m512i zero = _mm512_setzero_si512();
    const __m512i low_half = _mm512_set_epi32(23, 7, 22, 6, 21, 5, 20, 4, 19, 3, 18, 2, 17, 1, 16, 0);
    const __m512i high_half = _mm512_set_epi32(31, 15, 30, 14, 29, 13, 28, 12, 27, 11, 26, 10, 25, 9, 24, 8);
    __m512i carry = _mm512_set1_epi32((int)(uint32_t)out);
    for (uint32_t group = first_group; group < end; group += 16)
    {
        const __mmask16 valid = lanes_group(group, first, end);
        const __m512i values = _mm512_maskz_load_epi32(valid, chosen + group);
        const __m512i totals = _mm512_and_si512(_mm512_srli_epi32(values, LANES_CHOSEN_TOTAL_SHIFT), _mm512_set1_epi32(31));
        const __m512i room = _mm512_maskz_cvtepu8_epi32(valid, _mm_load_si128((const __m128i*)(gaps + group)));
        __m512i sum = _mm512_add_epi32(totals, room);
        sum = _mm512_add_epi32(sum, _mm512_alignr_epi32(sum, zero, 15));
        sum = _mm512_add_epi32(sum, _mm512_alignr_epi32(sum, zero, 14));
        sum = _mm512_add_epi32(sum, _mm512_alignr_epi32(sum, zero, 12));
        sum = _mm512_add_epi32(sum, _mm512_alignr_epi32(sum, zero, 8));
        const __m512i position = _mm512_sub_epi32(_mm512_add_epi32(sum, carry), totals);
        const __m512i row = _mm512_slli_epi32(_mm512_and_si512(values, _mm512_set1_epi32((int)LANES_CHOSEN_TEMPLATE)), 4);
        _mm512_store_si512(places + group, _mm512_permutex2var_epi32(row, low_half, position));
        _mm512_store_si512(places + group + 8, _mm512_permutex2var_epi32(row, high_half, position));
        carry = _mm512_add_epi32(carry, _mm512_permutexvar_epi32(_mm512_set1_epi32(15), sum));
    }
    const uint64_t out_end = (out & ~UINT64_C(0xffffffff)) | (uint32_t)_mm_cvtsi128_si32(_mm512_castsi512_si128(carry));
    const uint64_t tick3 = __rdtsc();
    // The roots' places: a root starts with the room before its first record's entries.
    for (uint32_t r = first_root; r < end_root; r += 1)
    {
        const uint32_t root_first = unit->root_first[r];
        unit->root_out[r] = (out & ~UINT64_C(0xffffffff)) | ((uint32_t)(places[root_first] >> 32) - gaps[root_first]);
    }
    const Clock rows_before = lanes->split ? clock_now() : (Clock){ 0 };
    const uint64_t tick4 = __rdtsc();
    lanes_rows(places, unit->payload, lanes->rows, unit->pool, unit->out_kinds, unit->out_classes, unit->out_values, first, end);
    const uint64_t tick_rows = __rdtsc();
    if (lanes->split)
    {
        const Clock rows_after = clock_now();
        lanes->rows_clock.cycles += rows_after.cycles - rows_before.cycles;
        lanes->rows_clock.instructions += rows_after.instructions - rows_before.instructions;
        lanes->rows_clock.mispredicted += rows_after.mispredicted - rows_before.mispredicted;
    }
    // The entries past a record's fourth, up to sixteen as the first path's, and no entry more: the rows' loop left
    // them alone, and wrote what follows them. After that loop, since their lines are then at hand.
    for (uint64_t i = 0; i < long_count; i += 1)
    {
        const uint32_t record = longs[i];
        const uint32_t value = chosen[record];
        const uint32_t total = value >> LANES_CHOSEN_TOTAL_SHIFT & 31;
        const uint64_t at = places[record] >> 32;
        const uint64_t payload = unit->payload[record];
        // A record whose root isn't taken has no entries by now, and one that writes early as many as its last run.
        const uint32_t more = total > 4 ? total - 4 : 0;
        const __mmask16 values = (__mmask16)((1u << more) - 1);
        _mm512_mask_storeu_epi64(unit->out_values + at + 4, (__mmask8)values, _mm512_maskz_loadu_epi64((__mmask8)values, unit->pool + payload + 4));
        if (__builtin_expect(total > 8, 0))
        {
            const Template* t = templates + (value & LANES_CHOSEN_TEMPLATE);
            const __mmask16 bytes = (__mmask16)((1u << (total - 8)) - 1);
            _mm_mask_storeu_epi8(unit->out_kinds + at + 8, bytes, _mm_maskz_loadu_epi8(bytes, t->kinds + 8));
            _mm_mask_storeu_epi8(unit->out_classes + at + 8, bytes, _mm_maskz_loadu_epi8(bytes, t->classes + 8));
            if (total > 12)
            {
                const __mmask8 last = (__mmask8)(values >> 8);
                _mm512_mask_storeu_epi64(unit->out_values + at + 12, last, _mm512_maskz_loadu_epi64(last, unit->pool + payload + 12));
            }
        }
    }
    const uint64_t tick5 = __rdtsc();
    // The listed records' runs, the last record first: each run at its gap's start, which the run then leaves.
    uint64_t early_records = 0;
    for (uint64_t i = special_count; i-- > 0;)
    {
        const uint32_t record = special[i];
        const uint32_t value = chosen[record];
        if ((value & LANES_CHOSEN_EARLY) != 0)
        {
            const Template* t = templates + (value & LANES_CHOSEN_TEMPLATE);
            const uint64_t payload = unit->payload[record];
            uint32_t before[3];
            lanes_run_records(lanes, record, before);
            uint32_t offset = 0;
            for (uint32_t run = 0; run < 3; run += 1)
            {
                const uint32_t length = t->runs[run];
                if (length != 0)
                {
                    const uint32_t room = gaps[before[run]];
                    lanes_copy_run(unit, t, payload, offset, length, (places[before[run]] >> 32) - room);
                    gaps[before[run]] = (uint8_t)(room - length);
                    offset += length;
                }
            }
            lanes_copy_run(unit, t, payload, offset, (uint32_t)t->runs[3] + t->converted, places[record] >> 32);
            early_records += 1;
        }
    }
    const uint64_t tick6 = __rdtsc();
    lanes->steps[0] += tick1 - tick0;
    lanes->steps[1] += tick2 - tick1;
    lanes->steps[2] += tick3 - tick2;
    lanes->steps[3] += tick4 - tick3;
    lanes->steps[4] += tick_rows - tick4;
    lanes->steps[5] += tick6 - tick5;
    lanes->steps[6] += tick5 - tick_rows;
    lanes->early_records += early_records;
    return out_end;
}

// The second path over the whole unit, a window of whole expressions at a time: T, C, the keys, the templates, X.
// `window`: the records a window holds at least (0: the unit is one window). Returns the entries emitted.
static __attribute__((noinline)) uint64_t lanes_run(Lanes* lanes, Unit* unit, const Template* templates, uint32_t window)
{
    uint64_t out = 0;
    uint32_t root = 0;
    while (root < unit->root_count)
    {
        const uint32_t first = unit->root_first[root];
        uint32_t end_root = root + 1;
        while (end_root < unit->root_count && (window == 0 || unit->roots[end_root - 1] + 1 - first < window))
        {
            end_root += 1;
        }
        const uint32_t end = unit->roots[end_root - 1] + 1;
        const uint32_t first_block = first / 64;
        const uint32_t end_block = (end + 63) / 64;
        if (lanes->split)
        {
            Clock marks[6];
            marks[0] = clock_now();
            lanes_types(lanes, unit, first_block, end_block);
            marks[1] = clock_now();
            lanes_contexts(lanes, unit, first_block, end_block);
            marks[2] = clock_now();
            lanes_keys(lanes, first_block, end_block);
            marks[3] = clock_now();
            lanes_choose(lanes, first_block, end_block);
            marks[4] = clock_now();
            if (lanes->keep)
            {
                memcpy(lanes->chosen_kept + first, lanes->chosen + first, (uint64_t)(end - first) * sizeof(uint32_t));
            }
            out = lanes_expand(lanes, unit, templates, root, end_root, out);
            marks[5] = clock_now();
            for (uint32_t part = 0; part < 5; part += 1)
            {
                lanes->parts[part].ticks += marks[part + 1].ticks - marks[part].ticks;
                lanes->parts[part].cycles += marks[part + 1].cycles - marks[part].cycles;
                lanes->parts[part].instructions += marks[part + 1].instructions - marks[part].instructions;
                lanes->parts[part].mispredicted += marks[part + 1].mispredicted - marks[part].mispredicted;
            }
        }
        else
        {
            // Each pass's TSC ticks: five reads a window.
            const uint64_t t0 = __rdtsc();
            lanes_types(lanes, unit, first_block, end_block);
            const uint64_t t1 = __rdtsc();
            lanes_contexts(lanes, unit, first_block, end_block);
            const uint64_t t2 = __rdtsc();
            lanes_keys(lanes, first_block, end_block);
            const uint64_t t3 = __rdtsc();
            lanes_choose(lanes, first_block, end_block);
            if (lanes->keep)
            {
                memcpy(lanes->chosen_kept + first, lanes->chosen + first, (uint64_t)(end - first) * sizeof(uint32_t));
            }
            const uint64_t t4 = __rdtsc();
            out = lanes_expand(lanes, unit, templates, root, end_root, out);
            const uint64_t t5 = __rdtsc();
            lanes->ticks[0] += t1 - t0;
            lanes->ticks[1] += t2 - t1;
            lanes->ticks[2] += t3 - t2;
            lanes->ticks[3] += t4 - t3;
            lanes->ticks[4] += t5 - t4;
        }
        root = end_root;
    }
    return out;
}

// The columns as before a run: the table-typed records untyped, the scalar path's marks and the counts cleared.
static void lanes_reset(Lanes* lanes)
{
    for (uint32_t g = 0; g < lanes->count; g += 1)
    {
        const bool by_table = lanes->by_table[g] != 0;
        lanes->typed[g] = by_table ? 0 : 0xff;
        for (uint32_t f = 0; by_table && f < LANES_FACTS; f += 1)
        {
            lanes->facts[f][g] = 0;
        }
        lanes->layout[g] &= LANES_LAYOUT_FAR;
        if (lanes->context_given[g] == 0)
        {
            lanes->context[g] = 0;
            lanes->context_dense[g] = 0;
            lanes->target_class[g] = 0;
            lanes->target_facts[g] = 0;
        }
        lanes->context_layout[g] &= LANES_LAYOUT_FAR;
    }
    memcpy(lanes->marks, lanes->marks_made, lanes->count);
    memset(lanes->chosen, 0, ((uint64_t)lanes->count + 64) * sizeof(uint32_t));
    lanes->far_records = 0;
    lanes->wide_records = 0;
    lanes->type_rounds = 0;
    lanes->type_blocks = 0;
    lanes->context_rounds = 0;
    lanes->context_blocks = 0;
    lanes->context_scalar = 0;
    lanes->early_records = 0;
    lanes->gap_overflows = 0;
    memset(lanes->steps, 0, sizeof(lanes->steps));
    memset(&lanes->rows_clock, 0, sizeof(lanes->rows_clock));
    memset(lanes->ticks, 0, sizeof(lanes->ticks));
    memset(lanes->parts, 0, sizeof(lanes->parts));
}

static uint64_t lanes_milliseconds(void)
{
    struct timespec now;
    clock_gettime(CLOCK_MONOTONIC, &now);
    return (uint64_t)now.tv_sec * 1000 + (uint64_t)now.tv_nsec / 1000000;
}

int main(int argc, char** argv)
{
    const char* path = NULL;
    uint32_t passes = 9;
    uint32_t window = 4096;
    uint32_t after_scalar = 0;
    uint32_t first_passes = 0;
    bool split = false;
    uint64_t raw = 0;
    const char* bake = NULL;
    for (int i = 1; i < argc; i += 1)
    {
        if (strcmp(argv[i], "--bake") == 0 && i + 1 < argc)
        {
            bake = argv[++i];
            continue;
        }
        if (strcmp(argv[i], "--raw") == 0 && i + 1 < argc)
        {
            raw = strtoull(argv[++i], NULL, 16);
            continue;
        }
        if (strcmp(argv[i], "--first-passes") == 0 && i + 1 < argc)
        {
            first_passes = (uint32_t)strtoul(argv[++i], NULL, 10);
            continue;
        }
        if (strcmp(argv[i], "--split") == 0)
        {
            split = true;
            continue;
        }
        if (strcmp(argv[i], "--passes") == 0 && i + 1 < argc)
        {
            passes = (uint32_t)strtoul(argv[++i], NULL, 10);
        }
        else if (strcmp(argv[i], "--window") == 0 && i + 1 < argc)
        {
            window = (uint32_t)strtoul(argv[++i], NULL, 10);
        }
        else if (strcmp(argv[i], "--after-scalar") == 0 && i + 1 < argc)
        {
            after_scalar = (uint32_t)strtoul(argv[++i], NULL, 10);
        }
        else
        {
            path = argv[i];
        }
    }
    first_passes = first_passes == 0 ? passes : first_passes;
    if (path == NULL || passes < 2 || passes > 9999 || first_passes < 2 || first_passes > 9999)
    {
        fprintf(stderr, "usage: lanes DUMP [--passes N] [--first-passes N] [--window RECORDS] [--after-scalar MILLISECONDS] [--split] [--raw HEX] [--bake FILE]\n");
        return 2;
    }
    for (uint32_t i = 0; i < sizeof(facts_given_ops); i += 1)
    {
        facts_given[facts_given_ops[i]] = true;
    }
    for (uint32_t i = 0; i < sizeof(operands_given_ops); i += 1)
    {
        operands_given[operands_given_ops[i]] = true;
    }
    static Unit unit;
    unit_read(&unit, path);
    static Tables tables;
    tables_learn(&tables, &unit);
    static Lanes lanes;
    lanes_make(&lanes, &unit, &tables);
    lanes.split = split;
    if (bake != NULL)
    {
        // The unit's rules as straight-line code, for a build with -DLANES_BAKED='"FILE"'.
        FILE* file = fopen(bake, "w");
        if (file == NULL)
        {
            perror(bake);
            return 1;
        }
        fprintf(file, "// The rules lanes.c learned from %s, as straight-line code: written by lanes --bake.\n", path);
        lanes_bake_program(file, "t", &lanes.type_program);
        fprintf(file, "static inline void baked_t_fetch(__m512i* inputs, const __mmask64* has, const __m512i* before, const __m512i* places, const __m512i* facts)\n{\n");
        fprintf(file, "    (void)inputs;\n    (void)has;\n    (void)before;\n    (void)places;\n    (void)facts;\n");
        for (uint32_t i = 0; i < lanes.type_fetch_count; i += 1)
        {
            fprintf(file, "    inputs[%u] = _mm512_maskz_permutex2var_epi8(has[%u], before[%u], places[%u], facts[%u]);\n", lanes.type_fetch[i][0], lanes.type_fetch[i][1],
                    lanes.type_fetch[i][2], lanes.type_fetch[i][1], lanes.type_fetch[i][2]);
        }
        fprintf(file, "}\n");
        lanes_bake_program(file, "c", &lanes.context_program);
        fclose(file);
        return 0;
    }
#ifdef LANES_BAKED
    if (lanes_program_print(&lanes.type_program) != BAKED_t_PRINT || lanes_program_print(&lanes.context_program) != BAKED_c_PRINT)
    {
        fprintf(stderr, "lanes: the baked kernel is of other rules than %s's\n", path);
        return 1;
    }
#endif
    const uint64_t n = (uint64_t)unit.count + 1;
    Work work = {
        .chosen = must(calloc(n, 4)),
        .early = must(calloc(n, 1)),
        .missed = must(calloc(n, 1)),
        .stack = must(malloc(n * 4)),
        .cursor = must(malloc(n * 4)),
        .done = must(malloc(n * 4)),
    };
    clock_counters[0] = counter_open(PERF_COUNT_HW_CPU_CYCLES);
    clock_counters[1] = counter_open(PERF_COUNT_HW_INSTRUCTIONS);
    clock_counters[2] = counter_open(PERF_COUNT_HW_BRANCH_MISSES);
    char third_name[64] = "mispredicted branches";
    if (raw != 0)
    {
        // A raw event of the processor's own in the mispredicted branches' place.
        struct perf_event_attr attr;
        memset(&attr, 0, sizeof(attr));
        attr.type = PERF_TYPE_RAW;
        attr.size = sizeof(attr);
        attr.config = raw;
        attr.exclude_kernel = 1;
        attr.exclude_hv = 1;
        close(clock_counters[2]);
        clock_counters[2] = (int)syscall(SYS_perf_event_open, &attr, 0, -1, -1, 0);
        snprintf(third_name, sizeof(third_name), "raw event 0x%llx", (unsigned long long)raw);
    }

    // The first path, an expression at a time: its taken roots and its entries are the reference.
    uint64_t (*first_samples)[4] = must(calloc(first_passes, sizeof(*first_samples)));
    uint64_t first_emitted = 0;
    for (uint32_t pass = 0; pass < first_passes; pass += 1)
    {
        const Clock before = clock_now();
        first_emitted = sweep_expressions(&unit, &tables, &work);
        const Clock after = clock_now();
        first_samples[pass][0] = after.ticks - before.ticks;
        first_samples[pass][1] = after.cycles - before.cycles;
        first_samples[pass][2] = after.instructions - before.instructions;
        first_samples[pass][3] = after.mispredicted - before.mispredicted;
    }
    uint64_t first_wrong_roots = 0;
    uint64_t first_wrong_entries = 0;
    verify(&unit, first_emitted, &first_wrong_roots, &first_wrong_entries);
    uint8_t* first_taken = must(malloc((uint64_t)unit.root_count + 1));
    memcpy(first_taken, unit.root_taken, unit.root_count);
    uint32_t* first_chosen = must(malloc(n * 4));
    memcpy(first_chosen, work.chosen, n * 4);
    uint8_t* first_missed = must(malloc(n));
    memcpy(first_missed, work.missed, n);
    uint64_t first_taken_nodes = 0;
    for (uint32_t r = 0; r < unit.root_count; r += 1)
    {
        first_taken_nodes += first_taken[r] ? unit.roots[r] - unit.root_first[r] + 1 : 0;
    }

    // The second path.
    uint64_t (*samples)[4] = must(calloc(passes, sizeof(*samples)));
    uint64_t emitted = 0;
    for (uint32_t pass = 0; pass < passes; pass += 1)
    {
        lanes_reset(&lanes);
        if (after_scalar != 0)
        {
            const uint64_t until = lanes_milliseconds() + after_scalar;
            while (lanes_milliseconds() < until)
            {
                sweep_expressions(&unit, &tables, &work);
            }
        }
        const Clock before = clock_now();
        emitted = lanes_run(&lanes, &unit, tables.templates, window);
        const Clock after = clock_now();
        samples[pass][0] = after.ticks - before.ticks;
        samples[pass][1] = after.cycles - before.cycles;
        samples[pass][2] = after.instructions - before.instructions;
        samples[pass][3] = after.mispredicted - before.mispredicted;
    }
    // One more pass, not timed, that keeps each record's template as the table gave it: X changes the listed
    // records'. What is checked below is this pass's.
    const uint64_t timed_emitted = emitted;
    const Lanes timed = lanes;
    lanes_reset(&lanes);
    // The first path wrote the same arrays, and the passes before this one too: an entry this pass didn't write would
    // read as written. So the pass writes over bytes no entry has.
    memset(unit.out_kinds, 0xa5, unit.entry_count + 64);
    memset(unit.out_classes, 0xa5, unit.entry_count + 64);
    memset(unit.out_values, 0xa5, (unit.entry_count + 64) * sizeof(uint64_t));
    lanes.keep = true;
    emitted = lanes_run(&lanes, &unit, tables.templates, window);
    lanes.keep = false;
    if (emitted != timed_emitted)
    {
        fprintf(stderr, "lanes: the check's pass emitted %llu entries, the timed ones %llu\n", (unsigned long long)emitted, (unsigned long long)timed_emitted);
        return 1;
    }
    uint64_t wrong_roots = 0;
    uint64_t wrong_entries = 0;
    verify(&unit, emitted, &wrong_roots, &wrong_entries);

    // Every record against the truth and the first path.
    uint64_t facts_wrong = 0;
    uint64_t context_wrong = 0;
    uint64_t chosen_wrong = 0;
    uint64_t refused = 0;
    uint64_t out_of_layout = 0;
    for (uint32_t g = 0; g < unit.count; g += 1)
    {
        uint8_t facts[LANES_FACTS];
        memcpy(facts, &unit.facts_truth[g], LANES_FACTS);
        facts[0] = lanes_dense_class(facts[0]);
        bool differs = lanes.typed[g] != 0xff;
        for (uint32_t f = 0; f < LANES_FACTS; f += 1)
        {
            differs = differs || lanes.facts[f][g] != facts[f];
        }
        facts_wrong += differs;
        const bool context_differs = lanes.context[g] != unit.context_truth[g] || lanes.target_class[g] != lanes_dense_class((uint8_t)unit.target_truth[g]) ||
                                     lanes.target_facts[g] != (uint8_t)(unit.target_truth[g] >> 8);
        context_wrong += context_differs && lanes.refused[g] == 0;
        refused += lanes.refused[g] != 0;
        out_of_layout += (lanes.layout[g] | lanes.context_layout[g]) != 0;
        // The template: the first path's where both found one.
        const bool found = (lanes.chosen_kept[g] & LANES_CHOSEN_MISSED) == 0;
        const bool first_found = (first_missed[g] & MISSED_TEMPLATE) == 0;
        chosen_wrong += found != first_found || (found && (lanes.chosen_kept[g] & LANES_CHOSEN_TEMPLATE) != first_chosen[g]);
    }
    uint64_t taken_roots = 0;
    uint64_t taken_nodes = 0;
    uint64_t only_first = 0;
    uint64_t only_first_nodes = 0;
    uint64_t only_second = 0;
    for (uint32_t r = 0; r < unit.root_count; r += 1)
    {
        const uint32_t size = unit.roots[r] - unit.root_first[r] + 1;
        taken_roots += unit.root_taken[r] != 0;
        taken_nodes += unit.root_taken[r] ? size : 0;
        only_first += first_taken[r] && !unit.root_taken[r];
        only_first_nodes += first_taken[r] && !unit.root_taken[r] ? size : 0;
        only_second += !first_taken[r] && unit.root_taken[r];
    }
#ifdef LANES_BAKED
    const char* const kernel = "baked";
#else
    const char* const kernel = "read from the rules";
#endif
    printf("lanes: %s\twindow=%u records\tpasses=%u\tafter-scalar=%u ms\tT's and C's kernel=%s\n", path, window, passes, after_scalar, kernel);
    printf("unit\tnodes=%u\tfull-expressions=%u\tblocks=%u\n", unit.count, unit.root_count, lanes.blocks);
    static const char* const type_names[LANES_FACTS] = { "cls", "tf", "con", "cat", "flg", "obj", "mem" };
    static const char* const context_names[LANES_C_ANSWERS] = { "ctx", "tg.cls", "tg.tf" };
    for (uint32_t table = 0; table < 2; table += 1)
    {
        const uint32_t answer_count = table == 0 ? LANES_FACTS : LANES_C_ANSWERS;
        for (uint32_t a = 0; a < answer_count; a += 1)
        {
            const LanesAnswer* answer = table == 0 ? &lanes.type_answers[a] : &lanes.context_answers[a];
            uint32_t rows = 0;
            uint32_t bits = 0;
            uint32_t inputs = 0;
            for (uint32_t s = 0; s < answer->shape_count; s += 1)
            {
                rows += answer->shapes[s].rows;
                bits = answer->shapes[s].bits > bits ? answer->shapes[s].bits : bits;
                inputs += answer->shapes[s].count;
            }
            printf("rules\t%s\t%s\toperators: constant=%u copy=%u table=%u without a rule=%u\tcopied inputs=%u\tshapes=%u\ttheir inputs=%u\trows=%u\tindex bits at most %u\n",
                   table == 0 ? "T" : "C", table == 0 ? type_names[a] : context_names[a], answer->constant_operators, answer->copy_operators, answer->table_operators,
                   answer->wide_operators, answer->copy_count, answer->shape_count, inputs, rows, bits);
        }
    }
    printf("rules\tX\tkeys=%llu\tin conflict=%llu\tslots=%llu\n", (unsigned long long)lanes.slot_keys, (unsigned long long)lanes.slot_conflicts,
           (unsigned long long)lanes.slot_mask + 1);
    printf("T\trounds a block=%.3f\tfacts differing from the truth=%llu\tby the scalar path: an operand out of reach=%llu, no rule=%llu\n",
           (double)lanes.type_rounds / (double)lanes.type_blocks, (unsigned long long)facts_wrong, (unsigned long long)lanes.far_records,
           (unsigned long long)lanes.wide_records);
    printf("C\trounds a block=%.3f\tcontexts or targets differing from the truth=%llu\trefused by the first path's tables=%llu\tby the scalar path=%llu\n",
           (double)lanes.context_rounds / (double)lanes.context_blocks, (unsigned long long)context_wrong, (unsigned long long)refused,
           (unsigned long long)lanes.context_scalar);
    printf("X\ttemplates differing from the first path's=%llu\ttaken expressions' records that write before or between their operands=%llu\trecords out of the layout's reach=%llu\n",
           (unsigned long long)chosen_wrong, (unsigned long long)lanes.early_records, (unsigned long long)out_of_layout);
    printf("taken\texpressions=%llu of %u\tnodes=%llu (%.2f%%)\tthe first path's nodes=%llu\ttaken by the first path alone: expressions=%llu nodes=%llu\tby this one alone=%llu\n",
           (unsigned long long)taken_roots, unit.root_count, (unsigned long long)taken_nodes, 100.0 * (double)taken_nodes / (double)unit.count,
           (unsigned long long)first_taken_nodes, (unsigned long long)only_first, (unsigned long long)only_first_nodes, (unsigned long long)only_second);
    printf("checked\tthe first path: emitted=%llu wrong-expressions=%llu wrong-entries=%llu\tthis path: emitted=%llu wrong-expressions=%llu wrong-entries=%llu\n",
           (unsigned long long)first_emitted, (unsigned long long)first_wrong_roots, (unsigned long long)first_wrong_entries, (unsigned long long)emitted,
           (unsigned long long)wrong_roots, (unsigned long long)wrong_entries);
    uint64_t* column = must(malloc(((uint64_t)passes + first_passes) * 8));
    double medians[2][4];
    for (uint32_t which = 0; which < 2; which += 1)
    {
        for (uint32_t m = 0; m < 4; m += 1)
        {
            uint32_t count = 0;
            for (uint32_t pass = 1; pass < (which == 0 ? first_passes : passes); pass += 1)
            {
                column[count++] = which == 0 ? first_samples[pass][m] : samples[pass][m];
            }
            qsort(column, count, 8, compare_u64);
            medians[which][m] = (double)column[count / 2];
        }
    }
    printf("time\tthe first path, an expression at a time\tper taken node: ticks %.1f cycles %.1f instructions %.1f %s %.3f\n",
           medians[0][0] / (double)first_taken_nodes, medians[0][1] / (double)first_taken_nodes, medians[0][2] / (double)first_taken_nodes, third_name,
           medians[0][3] / (double)first_taken_nodes);
    printf("time\tthis path\tper taken node: ticks %.1f cycles %.1f instructions %.1f %s %.3f\tfirst pass: cycles %.1f\n",
           medians[1][0] / (double)taken_nodes, medians[1][1] / (double)taken_nodes, medians[1][2] / (double)taken_nodes, third_name,
           medians[1][3] / (double)taken_nodes, (double)samples[0][1] / (double)taken_nodes);
    printf("steps\tX's, the last pass, ticks a taken node: listed records %.2f early runs' room and roots not taken %.2f places %.2f roots %.2f rows %.2f "
           "entries past the fourth %.2f early runs %.2f\n",
           (double)timed.steps[0] / (double)taken_nodes, (double)timed.steps[1] / (double)taken_nodes, (double)timed.steps[2] / (double)taken_nodes,
           (double)timed.steps[3] / (double)taken_nodes, (double)timed.steps[4] / (double)taken_nodes, (double)timed.steps[6] / (double)taken_nodes,
           (double)timed.steps[5] / (double)taken_nodes);
    if (split)
    {
        printf("split\tX's rows\tthe last pass, a taken node: cycles %.2f instructions %.2f %s %.3f\n", (double)timed.rows_clock.cycles / (double)taken_nodes,
               (double)timed.rows_clock.instructions / (double)taken_nodes, third_name, (double)timed.rows_clock.mispredicted / (double)taken_nodes);
    }
    // The last pass's split, in TSC ticks a taken node.
    static const char* const parts[5] = { "T", "C", "keys", "templates", "X" };
    if (split)
    {
        for (uint32_t part = 0; part < 5; part += 1)
        {
            printf("split\t%s\tthe last pass, a taken node: ticks %.1f cycles %.1f instructions %.1f %s %.3f\n", parts[part],
                   (double)timed.parts[part].ticks / (double)taken_nodes, (double)timed.parts[part].cycles / (double)taken_nodes,
                   (double)timed.parts[part].instructions / (double)taken_nodes, third_name, (double)timed.parts[part].mispredicted / (double)taken_nodes);
        }
    }
    else
    {
        printf("split\tthe last pass, ticks a taken node:");
        for (uint32_t part = 0; part < 5; part += 1)
        {
            printf(" %s %.1f", parts[part], (double)timed.ticks[part] / (double)taken_nodes);
        }
        printf("\n");
    }
    return wrong_roots != 0 || facts_wrong != 0 || context_wrong != 0 || chosen_wrong != 0;
}
