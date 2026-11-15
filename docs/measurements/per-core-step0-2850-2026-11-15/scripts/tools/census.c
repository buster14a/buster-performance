// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// census.c: what each answer of the node machine's sweeps depends on (buster#2850's step 0, its first part). It reads
// the dumps sweeps.c reads, with sweeps.c's own reader and keys (the file is included, unchanged), and for each answer
// the sweeps' tables give, operator by operator, finds the fewest of the key's bytes that decide it:
//   - T: each of a typed node's seven fact bytes, from its operand count, its first two operands' types' class and
//     facts and its first three evaluated operands' fact bytes;
//   - C: an operand's context and its conversion's target (class and facts), from the node's operand count, context
//     and facts, the operand's index, operator and facts, and the first two operands' facts;
//   - X: a node's template (and its entry count), from its context, target, store, operand count, operand types and
//     facts.
// "Decide" is exact: a set of bytes decides an answer when no more samples fall in keys with two answers than fall
// there with every byte of the key (the baseline, which sweeps.c's tables refuse). The fewest bytes are searched
// exhaustively up to four; past that, a set no byte of which can be dropped is found by elimination in three orders,
// and reported as such. Each (operator, answer) is then one of: a constant; a copy of one key byte; for T's class,
// the greatest of its operands' types' classes and int's; or a table, with its rows (the distinct keys at that set) and its
// index bits (each byte's distinct values in the operator's samples, rounded up to bits, added). Beside the key's
// bytes a rule may read a few values that are lane arithmetic on them (the greatest of two classes and int's, whether
// two classes are equal): a rule that is such arithmetic and then a small table shows as that table, and a copy of a
// greatest class is the "greatest" rule. C's target may also read the operand's context, C's first answer. A table's
// "recoded bits" are its index bits once each input byte has gone through a recode of its own (one in-register
// lookup a byte): values of a byte that never disagree share a code.
// It also counts what the layout of buster#2850 asks about the trees: how far back a node's operands are in the
// postorder, and how many rounds a block of 64 records needs before every table-typed node in it has its operands.
//
//   census DUMP [DUMP...] [--rows] [--list TABLE OPERATOR]
//
// Several dumps are one population: a set decides an answer only if it does over all of them. --rows prints a line
// for every (table, answer, operator). --list prints one operator's distinct samples of table T, C or X instead: the
// inputs that vary over them and every answer, with counts.
#define main sweeps_main
#include "sweeps.c"
#undef main

#define CENSUS_INPUTS_MOST 40
#define CENSUS_OUTPUTS_MOST 8
#define CENSUS_EXHAUSTIVE_MOST 4
#define CENSUS_PROBES_MOST UINT64_C(6000000000)
#define CENSUS_CLASS_INT 5

typedef struct CensusTable CensusTable;
struct CensusTable
{
    const char* name;
    uint32_t input_count;
    uint32_t output_count;
    // The inputs from `derived_first` on aren't the key's bytes: each is lane arithmetic on them (a greatest class, an
    // equality), so that a rule that is such arithmetic and a small table shows as one.
    uint32_t derived_first;
    // The inputs an answer's rule may not read: an answer itself, offered to the answers after it.
    uint64_t withheld[CENSUS_OUTPUTS_MOST];
    const char* input_names[CENSUS_INPUTS_MOST];
    const char* output_names[CENSUS_OUTPUTS_MOST];
    uint64_t count;
    uint64_t capacity;
    uint8_t* inputs;
    uint32_t* outputs;
    uint8_t* groups;
};

static void census_add(CensusTable* table, uint8_t op, const uint8_t* inputs, const uint32_t* outputs)
{
    if (table->count == table->capacity)
    {
        table->capacity = table->capacity == 0 ? 65536 : table->capacity * 2;
        table->inputs = must(realloc(table->inputs, table->capacity * table->input_count));
        table->outputs = must(realloc(table->outputs, table->capacity * table->output_count * sizeof(uint32_t)));
        table->groups = must(realloc(table->groups, table->capacity));
    }
    memcpy(table->inputs + table->count * table->input_count, inputs, table->input_count);
    memcpy(table->outputs + table->count * table->output_count, outputs, table->output_count * sizeof(uint32_t));
    table->groups[table->count] = op;
    table->count += 1;
}

// A map from a key to an answer, cleared by a new epoch.
typedef struct CensusMap CensusMap;
struct CensusMap
{
    uint64_t* keys;
    uint32_t* values;
    uint32_t* counts;
    uint32_t* epochs;
    uint8_t* conflicted;
    uint64_t mask;
    uint32_t shift;
    uint32_t epoch;
    uint64_t probes;
};

static void census_map_make(CensusMap* map, uint64_t most)
{
    uint32_t log2 = 8;
    while ((UINT64_C(1) << log2) < most * 4)
    {
        log2 += 1;
    }
    map->mask = (UINT64_C(1) << log2) - 1;
    map->shift = 64 - log2;
    map->keys = must(malloc((map->mask + 1) * sizeof(uint64_t)));
    map->values = must(malloc((map->mask + 1) * sizeof(uint32_t)));
    map->counts = must(malloc((map->mask + 1) * sizeof(uint32_t)));
    map->epochs = must(calloc(map->mask + 1, sizeof(uint32_t)));
    map->conflicted = must(malloc(map->mask + 1));
    map->epoch = 0;
    map->probes = 0;
}

// The samples of `members` that fall in keys with two answers when the key is the inputs `set`, and the keys into
// *rows. Up to eight inputs are the key itself; more are hashed.
static uint64_t census_test(const CensusTable* table, CensusMap* map, const uint32_t* members, uint32_t member_count, const uint8_t* set, uint32_t size, uint32_t output,
                            uint64_t* rows)
{
    map->epoch += 1;
    map->probes += member_count;
    const uint32_t epoch = map->epoch;
    const uint32_t input_count = table->input_count;
    const uint32_t output_count = table->output_count;
    uint64_t conflicts = 0;
    uint64_t distinct = 0;
    for (uint32_t m = 0; m < member_count; m += 1)
    {
        const uint8_t* inputs = table->inputs + (uint64_t)members[m] * input_count;
        const uint32_t value = table->outputs[(uint64_t)members[m] * output_count + output];
        uint64_t key = size <= 8 ? 0 : UINT64_C(0x243f6a8885a308d3);
        for (uint32_t i = 0; i < size; i += 1)
        {
            key = size <= 8 ? key << 8 | inputs[set[i]] : mix(key, inputs[set[i]]);
        }
        uint64_t slot = (mix(0x51, key) * UINT64_C(0xd6e8feb86659fd93)) >> map->shift;
        while (map->epochs[slot] == epoch && map->keys[slot] != key)
        {
            slot = (slot + 1) & map->mask;
        }
        if (map->epochs[slot] != epoch)
        {
            map->epochs[slot] = epoch;
            map->keys[slot] = key;
            map->values[slot] = value;
            map->counts[slot] = 1;
            map->conflicted[slot] = 0;
            distinct += 1;
        }
        else
        {
            map->counts[slot] += 1;
            if (map->conflicted[slot])
            {
                conflicts += 1;
            }
            else if (map->values[slot] != value)
            {
                map->conflicted[slot] = 1;
                conflicts += map->counts[slot];
            }
        }
    }
    *rows = distinct;
    return conflicts;
}

#define CENSUS_RULE_CONSTANT 0u
#define CENSUS_RULE_COPY 1u
#define CENSUS_RULE_GREATEST 2u
#define CENSUS_RULE_TABLE 3u
#define CENSUS_RULES 4u
static const char* const census_rule_names[CENSUS_RULES] = { "constant", "copy", "greatest", "table" };

typedef struct CensusFinding CensusFinding;
struct CensusFinding
{
    uint32_t size;
    uint8_t set[CENSUS_INPUTS_MOST];
    uint64_t rows;
    uint64_t baseline;
    uint32_t bits;
    uint32_t recoded_bits;
    uint64_t recoded_rows;
    uint32_t rule;
    uint32_t copied;
    const char* greatest;
    bool exhaustive;
};

// The distinct values of input `input` over `members`.
static uint32_t census_alphabet(const CensusTable* table, const uint32_t* members, uint32_t member_count, uint32_t input)
{
    bool seen[256] = { false };
    uint32_t distinct = 0;
    for (uint32_t m = 0; m < member_count; m += 1)
    {
        const uint8_t value = table->inputs[(uint64_t)members[m] * table->input_count + input];
        distinct += !seen[value];
        seen[value] = true;
    }
    return distinct;
}

static uint32_t census_bits_of(uint32_t distinct)
{
    uint32_t bits = 0;
    while ((UINT32_C(1) << bits) < distinct)
    {
        bits += 1;
    }
    return bits;
}

// Drops from `set` every input the answer doesn't need, tried in the set's order: what is left decides it and no
// input of it can go.
static uint32_t census_eliminate(const CensusTable* table, CensusMap* map, const uint32_t* members, uint32_t member_count, uint8_t* set, uint32_t size, uint32_t output,
                                 uint64_t baseline, uint64_t* rows)
{
    uint32_t kept = size;
    uint32_t at = 0;
    while (at < kept)
    {
        uint8_t without[CENSUS_INPUTS_MOST];
        uint32_t count = 0;
        for (uint32_t i = 0; i < kept; i += 1)
        {
            if (i != at)
            {
                without[count++] = set[i];
            }
        }
        uint64_t distinct = 0;
        if (census_test(table, map, members, member_count, without, count, output, &distinct) == baseline)
        {
            memcpy(set, without, count);
            kept = count;
        }
        else
        {
            at += 1;
        }
    }
    census_test(table, map, members, member_count, set, kept, output, rows);
    return kept;
}

// The fewest inputs that decide `output` over the operator's samples `members`.
static CensusFinding census_find(const CensusTable* table, CensusMap* map, const uint32_t* members, uint32_t member_count, uint32_t output)
{
    CensusFinding finding;
    memset(&finding, 0, sizeof(finding));
    const uint32_t input_count = table->input_count;
    // The inputs that vary over the samples, one of each set of equal columns.
    uint8_t active[CENSUS_INPUTS_MOST];
    uint32_t alphabets[CENSUS_INPUTS_MOST];
    uint32_t active_count = 0;
    for (uint32_t i = 0; i < input_count; i += 1)
    {
        const uint32_t distinct = census_alphabet(table, members, member_count, i);
        bool keep = distinct > 1 && (table->withheld[output] >> i & 1) == 0;
        for (uint32_t a = 0; keep && a < active_count; a += 1)
        {
            bool same = true;
            for (uint32_t m = 0; same && m < member_count; m += 1)
            {
                const uint8_t* inputs = table->inputs + (uint64_t)members[m] * input_count;
                same = inputs[i] == inputs[active[a]];
            }
            keep = !same;
        }
        if (keep)
        {
            alphabets[active_count] = distinct;
            active[active_count++] = (uint8_t)i;
        }
    }
    uint64_t rows = 0;
    const uint64_t baseline = census_test(table, map, members, member_count, active, active_count, output, &rows);
    finding.baseline = baseline;
    bool found = false;
    finding.exhaustive = true;
    for (uint32_t size = 0; !found && size <= CENSUS_EXHAUSTIVE_MOST && size <= active_count; size += 1)
    {
        // Every set of `size` of the active inputs, in lexicographic order; the one with the fewest rows is kept.
        double sets = 1;
        for (uint32_t i = 0; i < size; i += 1)
        {
            sets = sets * (double)(active_count - i) / (double)(i + 1);
        }
        if (sets * (double)member_count > (double)CENSUS_PROBES_MOST)
        {
            finding.exhaustive = false;
            break;
        }
        uint32_t picks[CENSUS_EXHAUSTIVE_MOST];
        for (uint32_t i = 0; i < size; i += 1)
        {
            picks[i] = i;
        }
        bool more = true;
        while (more)
        {
            uint8_t set[CENSUS_EXHAUSTIVE_MOST];
            for (uint32_t i = 0; i < size; i += 1)
            {
                set[i] = active[picks[i]];
            }
            uint64_t distinct = 0;
            if (census_test(table, map, members, member_count, set, size, output, &distinct) == baseline && (!found || distinct < finding.rows))
            {
                found = true;
                finding.size = size;
                memcpy(finding.set, set, size);
                finding.rows = distinct;
            }
            // The next set.
            uint32_t at = size;
            more = false;
            while (at-- > 0 && !more)
            {
                if (picks[at] + (size - at) < active_count)
                {
                    picks[at] += 1;
                    for (uint32_t i = at + 1; i < size; i += 1)
                    {
                        picks[i] = picks[i - 1] + 1;
                    }
                    more = true;
                }
            }
        }
    }
    if (!found)
    {
        // Elimination in three orders: the key's own, its reverse, and the inputs of most values first.
        finding.exhaustive = false;
        finding.size = UINT32_MAX;
        for (uint32_t order = 0; order < 3; order += 1)
        {
            uint8_t set[CENSUS_INPUTS_MOST];
            for (uint32_t i = 0; i < active_count; i += 1)
            {
                set[i] = order == 1 ? active[active_count - 1 - i] : active[i];
            }
            if (order == 2)
            {
                for (uint32_t i = 0; i < active_count; i += 1)
                {
                    for (uint32_t j = i + 1; j < active_count; j += 1)
                    {
                        uint32_t alphabet_i = 0;
                        uint32_t alphabet_j = 0;
                        for (uint32_t a = 0; a < active_count; a += 1)
                        {
                            alphabet_i = active[a] == set[i] ? alphabets[a] : alphabet_i;
                            alphabet_j = active[a] == set[j] ? alphabets[a] : alphabet_j;
                        }
                        if (alphabet_j > alphabet_i)
                        {
                            const uint8_t swap = set[i];
                            set[i] = set[j];
                            set[j] = swap;
                        }
                    }
                }
            }
            uint64_t distinct = 0;
            const uint32_t kept = census_eliminate(table, map, members, member_count, set, active_count, output, baseline, &distinct);
            if (kept < finding.size || (kept == finding.size && distinct < finding.rows))
            {
                finding.size = kept;
                memcpy(finding.set, set, kept);
                finding.rows = distinct;
            }
        }
    }
    for (uint32_t i = 0; i < finding.size; i += 1)
    {
        finding.bits += census_bits_of(census_alphabet(table, members, member_count, finding.set[i]));
    }
    return finding;
}

// The index bits of the set `set` once each of its inputs is recoded: an input's values that never disagree at the same
// other inputs share a code (found greedily, the commonest value first, one input after another, each with the
// inputs before it already recoded, so that the codes together still decide the answer as far as the set did). A
// recode is one in-register lookup of the byte. The rows of the recoded set into *rows.
static uint32_t census_recode(const CensusTable* table, CensusMap* map, const uint32_t* members, uint32_t member_count, const uint8_t* set, uint32_t size, uint32_t output,
                              uint64_t* rows)
{
    uint32_t bits = 0;
    *rows = size == 0 ? 1 : 0;
    if (size != 0 && size <= 8)
    {
        uint8_t* columns = must(malloc((uint64_t)member_count * size));
        uint32_t* order = must(malloc((uint64_t)member_count * sizeof(uint32_t)));
        for (uint32_t m = 0; m < member_count; m += 1)
        {
            for (uint32_t i = 0; i < size; i += 1)
            {
                columns[(uint64_t)m * size + i] = table->inputs[(uint64_t)members[m] * table->input_count + set[i]];
            }
        }
        for (uint32_t which = 0; which < size; which += 1)
        {
            // The samples by this input's value, the commonest value first.
            uint32_t counts[256] = { 0 };
            for (uint32_t m = 0; m < member_count; m += 1)
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
            for (uint32_t m = 0; m < member_count; m += 1)
            {
                order[next[columns[(uint64_t)m * size + which]]++] = m;
            }
            // The map holds every (code, the other inputs) seen so far with its answer.
            map->epoch += 1;
            const uint32_t epoch = map->epoch;
            uint8_t code_of_value[256] = { 0 };
            uint32_t codes = 0;
            for (uint32_t i = 0; i < value_count; i += 1)
            {
                const uint32_t v = values[i];
                uint32_t chosen = codes;
                for (uint32_t code = 0; code < codes && chosen == codes; code += 1)
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
                        agrees = map->epochs[slot] != epoch || map->values[slot] == table->outputs[(uint64_t)members[m] * table->output_count + output];
                    }
                    chosen = agrees ? code : chosen;
                }
                codes += chosen == codes;
                code_of_value[v] = (uint8_t)chosen;
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
                        map->values[slot] = table->outputs[(uint64_t)members[m] * table->output_count + output];
                    }
                }
            }
            for (uint32_t m = 0; m < member_count; m += 1)
            {
                columns[(uint64_t)m * size + which] = code_of_value[columns[(uint64_t)m * size + which]];
            }
            bits += census_bits_of(codes);
        }
        // The rows of the recoded set.
        map->epoch += 1;
        for (uint32_t m = 0; m < member_count; m += 1)
        {
            uint64_t key = 0;
            for (uint32_t j = 0; j < size; j += 1)
            {
                key = key << 8 | columns[(uint64_t)m * size + j];
            }
            uint64_t slot = (mix(0x53, key) * UINT64_C(0xd6e8feb86659fd93)) >> map->shift;
            while (map->epochs[slot] == map->epoch && map->keys[slot] != key)
            {
                slot = (slot + 1) & map->mask;
            }
            if (map->epochs[slot] != map->epoch)
            {
                map->epochs[slot] = map->epoch;
                map->keys[slot] = key;
                *rows += 1;
            }
        }
        free(columns);
        free(order);
    }
    else if (size != 0)
    {
        // A set of more than eight inputs is left as it is.
        for (uint32_t i = 0; i < size; i += 1)
        {
            bits += census_bits_of(census_alphabet(table, members, member_count, set[i]));
        }
        census_test(table, map, members, member_count, set, size, output, rows);
    }
    return bits;
}

static int census_compare_bytes(const void* a, const void* b)
{
    return (int)*(const uint8_t*)a - (int)*(const uint8_t*)b;
}

// The shape of a table rule: its inputs as a mask.
typedef struct CensusShape CensusShape;
struct CensusShape
{
    uint64_t mask;
    uint32_t operators;
    uint64_t samples;
    uint64_t rows;
    uint64_t rows_most;
    uint32_t bits_most;
    uint64_t baseline;
    uint64_t operator_mask[2];
};

static void census_set_print(const CensusTable* table, const uint8_t* set, uint32_t size)
{
    printf("{");
    for (uint32_t i = 0; i < size; i += 1)
    {
        printf("%s%s", i != 0 ? "," : "", table->input_names[set[i]]);
    }
    printf("}");
}

// The census of one table: each answer's rule for each operator, and the answers' summaries.
static void census_table(const CensusTable* table, bool print_rows)
{
    // The samples by operator.
    uint32_t starts[OPS + 1] = { 0 };
    for (uint64_t s = 0; s < table->count; s += 1)
    {
        starts[table->groups[s] + 1] += 1;
    }
    uint32_t most = 0;
    for (uint32_t op = 0; op < OPS; op += 1)
    {
        most = starts[op + 1] > most ? starts[op + 1] : most;
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
    census_map_make(&map, most);
    printf("\n%s\tsamples=%llu\tinputs=%u\tanswers=%u\n", table->name, (unsigned long long)table->count, table->input_count, table->output_count);
    for (uint32_t output = 0; output < table->output_count; output += 1)
    {
        uint64_t rule_samples[CENSUS_RULES] = { 0 };
        uint32_t rule_operators[CENSUS_RULES] = { 0 };
        uint64_t size_samples[CENSUS_INPUTS_MOST + 1] = { 0 };
        uint64_t table_rows = 0;
        uint64_t table_rows_most = 0;
        uint64_t samples_within[3] = { 0 };
        uint64_t rows_within[3] = { 0 };
        uint64_t baseline = 0;
        uint64_t not_exhaustive = 0;
        CensusShape shapes[OPS];
        uint32_t shape_count = 0;
        for (uint32_t op = 0; op < OPS; op += 1)
        {
            const uint32_t member_count = starts[op + 1] - starts[op];
            if (member_count != 0)
            {
                const uint32_t* group = members + starts[op];
                CensusFinding finding = census_find(table, &map, group, member_count, output);
                finding.recoded_bits = census_recode(table, &map, group, member_count, finding.set, finding.size, output, &finding.recoded_rows);
                // A copy: one input the answer equals in every sample. The greatest: T's class from its operands'.
                finding.rule = finding.size == 0 ? CENSUS_RULE_CONSTANT : CENSUS_RULE_TABLE;
                for (uint32_t i = 0; finding.rule == CENSUS_RULE_TABLE && i < table->input_count; i += 1)
                {
                    bool same = (table->withheld[output] >> i & 1) == 0;
                    for (uint32_t m = 0; same && m < member_count; m += 1)
                    {
                        same = table->inputs[(uint64_t)group[m] * table->input_count + i] == table->outputs[(uint64_t)group[m] * table->output_count + output];
                    }
                    if (same)
                    {
                        finding.rule = CENSUS_RULE_COPY;
                        finding.copied = i;
                    }
                }
                if (finding.rule == CENSUS_RULE_COPY && finding.copied >= table->derived_first)
                {
                    finding.rule = CENSUS_RULE_GREATEST;
                    finding.greatest = table->input_names[finding.copied];
                }
                rule_samples[finding.rule] += member_count;
                rule_operators[finding.rule] += 1;
                size_samples[finding.size] += member_count;
                baseline += finding.baseline;
                not_exhaustive += finding.exhaustive ? 0 : member_count;
                if (finding.rule == CENSUS_RULE_TABLE)
                {
                    table_rows += finding.rows;
                    table_rows_most = finding.rows > table_rows_most ? finding.rows : table_rows_most;
                    const uint32_t within = finding.recoded_bits <= 7 ? 0 : finding.recoded_bits <= 8 ? 1 : 2;
                    samples_within[within] += member_count;
                    rows_within[within] += finding.rows;
                    uint64_t mask = 0;
                    for (uint32_t i = 0; i < finding.size; i += 1)
                    {
                        mask |= UINT64_C(1) << finding.set[i];
                    }
                    uint32_t shape = 0;
                    while (shape < shape_count && shapes[shape].mask != mask)
                    {
                        shape += 1;
                    }
                    if (shape == shape_count)
                    {
                        memset(&shapes[shape_count], 0, sizeof(CensusShape));
                        shapes[shape_count++].mask = mask;
                    }
                    shapes[shape].operators += 1;
                    shapes[shape].baseline += finding.baseline;
                    shapes[shape].operator_mask[op / 64] |= UINT64_C(1) << (op % 64);
                    shapes[shape].samples += member_count;
                    shapes[shape].rows += finding.rows;
                    shapes[shape].rows_most = finding.rows > shapes[shape].rows_most ? finding.rows : shapes[shape].rows_most;
                    shapes[shape].bits_most = finding.recoded_bits > shapes[shape].bits_most ? finding.recoded_bits : shapes[shape].bits_most;
                }
                if (print_rows)
                {
                    uint8_t sorted[CENSUS_INPUTS_MOST];
                    memcpy(sorted, finding.set, finding.size);
                    qsort(sorted, finding.size, 1, census_compare_bytes);
                    printf("row\t%s\t%s\t%s\tsamples=%u\tinputs=%u\t", table->name, table->output_names[output], op_names[op], member_count, finding.size);
                    census_set_print(table, sorted, finding.size);
                    printf("\trows=%llu\tbits=%u\trecoded-bits=%u\tin-conflict-with-the-whole-key=%llu\t%s", (unsigned long long)finding.rows, finding.bits,
                           finding.recoded_bits, (unsigned long long)finding.baseline, census_rule_names[finding.rule]);
                    if (finding.rule == CENSUS_RULE_COPY)
                    {
                        printf(" of %s", table->input_names[finding.copied]);
                    }
                    if (finding.rule == CENSUS_RULE_GREATEST)
                    {
                        printf(" %s", finding.greatest);
                    }
                    printf("%s\n", finding.exhaustive ? "" : "\tby-elimination");
                }
            }
        }
        const double all = (double)table->count;
        printf("answer\t%s\t%s", table->name, table->output_names[output]);
        for (uint32_t rule = 0; rule < CENSUS_RULES; rule += 1)
        {
            printf("\t%s: %.2f%% of the samples, %u operators", census_rule_names[rule], 100.0 * (double)rule_samples[rule] / all, rule_operators[rule]);
        }
        printf("\n");
        printf("answer\t%s\t%s\tsamples by the inputs their operator's rule reads:", table->name, table->output_names[output]);
        for (uint32_t size = 0; size <= CENSUS_INPUTS_MOST; size += 1)
        {
            if (size_samples[size] != 0)
            {
                printf(" %u: %.2f%%", size, 100.0 * (double)size_samples[size] / all);
            }
        }
        printf("\tsamples whose operator's set was found by elimination: %.2f%%\tin conflict with the whole key: %llu\n", 100.0 * (double)not_exhaustive / all,
               (unsigned long long)baseline);
        printf("answer\t%s\t%s\tthe tables: rows=%llu (the largest %llu)\tat 7 index bits or fewer once recoded: %.2f%% of the samples, %llu rows\tat 8: %.2f%%, %llu rows\tat more: %.2f%%, %llu rows\n",
               table->name, table->output_names[output], (unsigned long long)table_rows, (unsigned long long)table_rows_most, 100.0 * (double)samples_within[0] / all,
               (unsigned long long)rows_within[0], 100.0 * (double)samples_within[1] / all, (unsigned long long)rows_within[1], 100.0 * (double)samples_within[2] / all,
               (unsigned long long)rows_within[2]);
        // The shapes, the most samples first.
        for (uint32_t shown = 0; shown < 8 && shown < shape_count; shown += 1)
        {
            uint32_t best = shown;
            for (uint32_t shape = shown + 1; shape < shape_count; shape += 1)
            {
                best = shapes[shape].samples > shapes[best].samples ? shape : best;
            }
            const CensusShape swap = shapes[shown];
            shapes[shown] = shapes[best];
            shapes[best] = swap;
            uint8_t set[CENSUS_INPUTS_MOST];
            uint32_t size = 0;
            for (uint32_t i = 0; i < table->input_count; i += 1)
            {
                if ((shapes[shown].mask >> i & 1) != 0)
                {
                    set[size++] = (uint8_t)i;
                }
            }
            // The shape's operators as one table: whether their rows agree where they share a key.
            uint32_t* shared = must(malloc((table->count + 1) * sizeof(uint32_t)));
            uint32_t shared_count = 0;
            for (uint32_t op = 0; op < OPS; op += 1)
            {
                if ((shapes[shown].operator_mask[op / 64] >> (op % 64) & 1) != 0)
                {
                    memcpy(shared + shared_count, members + starts[op], (starts[op + 1] - starts[op]) * sizeof(uint32_t));
                    shared_count += starts[op + 1] - starts[op];
                }
            }
            CensusMap shared_map;
            census_map_make(&shared_map, shared_count);
            uint64_t shared_rows = 0;
            const uint64_t shared_conflicts = census_test(table, &shared_map, shared, shared_count, set, size, output, &shared_rows);
            free(shared_map.keys);
            free(shared_map.values);
            free(shared_map.counts);
            free(shared_map.epochs);
            free(shared_map.conflicted);
            free(shared);
            printf("shape\t%s\t%s\t", table->name, table->output_names[output]);
            census_set_print(table, set, size);
            printf("\tas one table: rows=%llu, %s", (unsigned long long)shared_rows,
                   shared_conflicts == shapes[shown].baseline ? "the operators agree" : "the operators differ");
            printf("\toperators=%u\tsamples=%.2f%%\trows=%llu (the largest %llu)\tindex bits once recoded at most %u\n", shapes[shown].operators, 100.0 * (double)shapes[shown].samples / all,
                   (unsigned long long)shapes[shown].rows, (unsigned long long)shapes[shown].rows_most, shapes[shown].bits_most);
        }
        if (shape_count > 8)
        {
            printf("shape\t%s\t%s\t(%u more shapes)\n", table->name, table->output_names[output], shape_count - 8);
        }
    }
    printf("work\t%s\tprobes=%llu\n", table->name, (unsigned long long)map.probes);
    free(members);
    free(map.keys);
    free(map.values);
    free(map.counts);
    free(map.epochs);
    free(map.conflicted);
}

// The unit's templates as the population's: equal templates of two units are one.
typedef struct CensusTemplates CensusTemplates;
struct CensusTemplates
{
    Template* templates;
    uint32_t count;
    uint32_t capacity;
};

static uint32_t census_template(CensusTemplates* all, const Template* candidate)
{
    uint32_t found = 0;
    while (found < all->count && memcmp(&all->templates[found], candidate, sizeof(Template)) != 0)
    {
        found += 1;
    }
    if (found == all->count)
    {
        if (all->count == all->capacity)
        {
            all->capacity = all->capacity == 0 ? 1024 : all->capacity * 2;
            all->templates = must(realloc(all->templates, all->capacity * sizeof(Template)));
        }
        all->templates[all->count++] = *candidate;
    }
    return found;
}

static void census_facts_bytes(uint8_t* bytes, uint64_t facts)
{
    memcpy(bytes, &facts, 7);
}

// The greatest of two classes and int's: the usual arithmetic conversions' class where both are arithmetic.
static uint8_t census_greatest(uint8_t a, uint8_t b)
{
    uint8_t greatest = CENSUS_CLASS_INT;
    greatest = a > greatest ? a : greatest;
    greatest = b > greatest ? b : greatest;
    return greatest;
}

// The trees' counts the layout asks about.
typedef struct CensusTrees CensusTrees;
struct CensusTrees
{
    uint64_t nodes;
    uint64_t expressions;
    uint64_t with_operands;
    uint64_t first_far[3];
    uint64_t any_far[3];
    uint64_t expressions_far[3];
    uint64_t expression_nodes_far[3];
    uint64_t last_not_before;
    uint64_t blocks;
    uint64_t rounds;
    uint64_t rounds_histogram[16];
    uint64_t height_histogram[16];
    uint64_t table_nodes;
};

static void census_trees(CensusTrees* trees, const Unit* unit)
{
    static const uint32_t limits[3] = { 32, 64, 127 };
    uint8_t* height = must(calloc((uint64_t)unit->count + 1, 1));
    uint8_t* height_block = must(calloc((uint64_t)unit->count + 1, 1));
    trees->nodes += unit->count;
    trees->expressions += unit->root_count;
    for (uint32_t r = 0; r < unit->root_count; r += 1)
    {
        bool far[3] = { false, false, false };
        uint32_t tallest = 0;
        for (uint32_t g = unit->root_first[r]; g <= unit->roots[r]; g += 1)
        {
            if (unit->operand_count[g] != 0)
            {
                trees->with_operands += 1;
                uint32_t farthest = 0;
                uint32_t last = NONE;
                uint32_t under = 0;
                uint32_t under_block = 0;
                for (uint32_t c = unit->first_child[g]; c != NONE; c = unit->next_sibling[c])
                {
                    farthest = g - c > farthest ? g - c : farthest;
                    last = c;
                    under = height[c] > under ? height[c] : under;
                    under_block = c / 64 == g / 64 && height_block[c] > under_block ? height_block[c] : under_block;
                }
                trees->last_not_before += last != g - 1;
                const uint32_t first = g - unit->first_child[g];
                for (uint32_t limit = 0; limit < 3; limit += 1)
                {
                    trees->first_far[limit] += first > limits[limit];
                    trees->any_far[limit] += farthest > limits[limit];
                    far[limit] = far[limit] || farthest > limits[limit];
                }
                // A table-typed node is typed a round after its last table-typed operand: the given nodes and the
                // leaves have their facts before the rounds.
                const uint32_t own = unit->by_table[g] ? 1 : 0;
                height[g] = (uint8_t)(own == 0 ? 0 : under >= 255 ? 255 : under + 1);
                height_block[g] = (uint8_t)(own == 0 ? 0 : under_block >= 255 ? 255 : under_block + 1);
                trees->table_nodes += own;
                tallest = height[g] > tallest ? height[g] : tallest;
            }
        }
        trees->height_histogram[tallest > 15 ? 15 : tallest] += 1;
        for (uint32_t limit = 0; limit < 3; limit += 1)
        {
            trees->expressions_far[limit] += far[limit];
            trees->expression_nodes_far[limit] += far[limit] ? unit->roots[r] - unit->root_first[r] + 1 : 0;
        }
    }
    for (uint32_t first = 0; first < unit->count; first += 64)
    {
        uint32_t rounds = 0;
        for (uint32_t g = first; g < first + 64 && g < unit->count; g += 1)
        {
            rounds = height_block[g] > rounds ? height_block[g] : rounds;
        }
        trees->blocks += 1;
        trees->rounds += rounds;
        trees->rounds_histogram[rounds > 15 ? 15 : rounds] += 1;
    }
    free(height);
    free(height_block);
}

// The distinct samples of operator `op` of `table`, as the inputs that vary over them and every answer, with counts.
static uint32_t census_listing_width;

static int census_compare_listing(const void* a, const void* b)
{
    return memcmp(a, b, census_listing_width);
}

static void census_list(const CensusTable* table, uint8_t op)
{
    uint32_t count = 0;
    for (uint64_t s = 0; s < table->count; s += 1)
    {
        count += table->groups[s] == op;
    }
    bool varies[CENSUS_INPUTS_MOST] = { false };
    const uint8_t* first = NULL;
    for (uint64_t s = 0; s < table->count; s += 1)
    {
        if (table->groups[s] == op)
        {
            const uint8_t* inputs = table->inputs + s * table->input_count;
            first = first == NULL ? inputs : first;
            for (uint32_t i = 0; i < table->input_count; i += 1)
            {
                varies[i] = varies[i] || inputs[i] != first[i];
            }
        }
    }
    const uint32_t width = table->input_count + table->output_count * 4;
    uint8_t* rows = must(malloc((uint64_t)(count + 1) * width));
    uint32_t at = 0;
    for (uint64_t s = 0; s < table->count; s += 1)
    {
        if (table->groups[s] == op)
        {
            memcpy(rows + (uint64_t)at * width, table->inputs + s * table->input_count, table->input_count);
            memcpy(rows + (uint64_t)at * width + table->input_count, table->outputs + s * table->output_count, table->output_count * 4);
            at += 1;
        }
    }
    census_listing_width = width;
    qsort(rows, count, width, census_compare_listing);
    printf("list\t%s\t%s\tsamples=%u\ncount", table->name, op_names[op], count);
    for (uint32_t i = 0; i < table->input_count; i += 1)
    {
        if (varies[i])
        {
            printf("\t%s", table->input_names[i]);
        }
    }
    for (uint32_t o = 0; o < table->output_count; o += 1)
    {
        printf("\t=%s", table->output_names[o]);
    }
    printf("\n");
    uint32_t run = 0;
    for (uint32_t r = 0; r < count; r += 1)
    {
        run += 1;
        if (r + 1 == count || memcmp(rows + (uint64_t)r * width, rows + (uint64_t)(r + 1) * width, width) != 0)
        {
            const uint8_t* row = rows + (uint64_t)r * width;
            printf("%u", run);
            for (uint32_t i = 0; i < table->input_count; i += 1)
            {
                if (varies[i])
                {
                    printf("\t%u", row[i]);
                }
            }
            for (uint32_t o = 0; o < table->output_count; o += 1)
            {
                uint32_t value;
                memcpy(&value, row + table->input_count + o * 4, 4);
                printf("\t%u", value);
            }
            printf("\n");
            run = 0;
        }
    }
    free(rows);
}

// lanes.c includes this file for its search, and names this function otherwise.
#ifndef CENSUS_MAIN
#define CENSUS_MAIN main
#endif

int CENSUS_MAIN(int argc, char** argv)
{
    bool print_rows = false;
    const char* list_table = NULL;
    const char* list_op = NULL;
    uint32_t path_count = 0;
    const char* paths[16];
    for (int i = 1; i < argc; i += 1)
    {
        if (strcmp(argv[i], "--rows") == 0)
        {
            print_rows = true;
        }
        else if (strcmp(argv[i], "--list") == 0 && i + 2 < argc)
        {
            list_table = argv[++i];
            list_op = argv[++i];
        }
        else if (path_count < 16)
        {
            paths[path_count++] = argv[i];
        }
    }
    if (path_count == 0)
    {
        fprintf(stderr, "usage: census DUMP [DUMP...] [--rows] [--list TABLE OPERATOR]\n");
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
    static const char* const fact_names[7] = { "cls", "tf", "con", "cat", "flg", "obj", "mem" };
    static char names[4][7][8];
    static const char* const prefixes[4] = { "a", "b", "c", "s" };
    for (uint32_t p = 0; p < 4; p += 1)
    {
        for (uint32_t f = 0; f < 7; f += 1)
        {
            snprintf(names[p][f], sizeof(names[p][f]), "%s.%s", prefixes[p], fact_names[f]);
        }
    }
    static char operand_names[7][8];
    for (uint32_t f = 0; f < 7; f += 1)
    {
        snprintf(operand_names[f], sizeof(operand_names[f]), "o.%s", fact_names[f]);
    }
    CensusTable type = { .name = "T", .input_count = 29, .output_count = 7, .derived_first = 26 };
    type.input_names[26] = "max(t0.cls,t1.cls,int)";
    type.input_names[27] = "max(t0.cls,int)";
    type.input_names[28] = "max(t1.cls,c.cls,int)";
    type.input_names[0] = "n";
    type.input_names[1] = "t0.cls";
    type.input_names[2] = "t0.tf";
    type.input_names[3] = "t1.cls";
    type.input_names[4] = "t1.tf";
    for (uint32_t p = 0; p < 3; p += 1)
    {
        for (uint32_t f = 0; f < 7; f += 1)
        {
            type.input_names[5 + p * 7 + f] = names[p][f];
        }
    }
    for (uint32_t f = 0; f < 7; f += 1)
    {
        type.output_names[f] = fact_names[f];
    }
    CensusTable context = { .name = "C", .input_count = 36, .output_count = 3, .derived_first = 32 };
    // The operand's context, C's first answer, is an input of its target's rules: C has it by then.
    context.input_names[35] = "o.ctx";
    context.withheld[0] = UINT64_C(1) << 35;
    context.input_names[32] = "o.cls==s.cls";
    context.input_names[33] = "max(a.cls,b.cls,int)";
    context.input_names[34] = "o.cls==max(a.cls,b.cls,int)";
    context.input_names[0] = "n";
    context.input_names[1] = "ctx";
    context.input_names[2] = "idx";
    context.input_names[3] = "o.op";
    for (uint32_t f = 0; f < 7; f += 1)
    {
        context.input_names[4 + f] = names[3][f];
        context.input_names[11 + f] = names[0][f];
        context.input_names[18 + f] = names[1][f];
        context.input_names[25 + f] = operand_names[f];
    }
    context.output_names[0] = "ctx";
    context.output_names[1] = "tg.cls";
    context.output_names[2] = "tg.tf";
    CensusTable expand = { .name = "X", .input_count = 16, .output_count = 2, .derived_first = 16 };
    expand.input_names[0] = "ctx";
    expand.input_names[1] = "tg.cls";
    expand.input_names[2] = "tg.tf";
    expand.input_names[3] = "store";
    expand.input_names[4] = "n";
    expand.input_names[5] = "t0.cls";
    expand.input_names[6] = "t0.tf";
    expand.input_names[7] = "t1.cls";
    expand.input_names[8] = "t1.tf";
    for (uint32_t f = 0; f < 7; f += 1)
    {
        expand.input_names[9 + f] = names[3][f];
    }
    expand.output_names[0] = "template";
    expand.output_names[1] = "entries";

    CensusTemplates templates = { 0 };
    CensusTrees trees;
    memset(&trees, 0, sizeof(trees));
    static bool fact_seen[7][256];
    uint64_t nodes = 0;
    printf("census:");
    for (uint32_t u = 0; u < path_count; u += 1)
    {
        printf(" %s", paths[u]);
    }
    printf("\n");
    for (uint32_t u = 0; u < path_count; u += 1)
    {
        static Unit unit;
        unit_read(&unit, paths[u]);
        nodes += unit.count;
        census_trees(&trees, &unit);
        // The unit's templates among the population's.
        uint32_t* template_of = must(malloc(((uint64_t)unit.template_count + 1) * sizeof(uint32_t)));
        for (uint32_t t = 0; t < unit.template_count; t += 1)
        {
            template_of[t] = census_template(&templates, &unit.templates[t]);
        }
        for (uint32_t g = 0; g < unit.count; g += 1)
        {
            const uint8_t op = unit.op[g];
            if (op < OPS)
            {
                uint8_t own[7];
                census_facts_bytes(own, unit.facts_truth[g]);
                for (uint32_t f = 0; f < 7; f += 1)
                {
                    fact_seen[f][own[f]] = true;
                }
                const uint32_t types = operand_types_of(&unit, unit.facts_truth, g);
                if (unit.by_table[g])
                {
                    uint8_t inputs[CENSUS_INPUTS_MOST] = { 0 };
                    uint32_t outputs[CENSUS_OUTPUTS_MOST] = { 0 };
                    inputs[0] = unit.operand_count[g];
                    memcpy(inputs + 1, &types, 4);
                    census_facts_bytes(inputs + 5, unit.facts_truth[unit.child0[g]]);
                    census_facts_bytes(inputs + 12, unit.facts_truth[unit.child1[g]]);
                    census_facts_bytes(inputs + 19, unit.facts_truth[unit.child2[g]]);
                    inputs[26] = census_greatest(inputs[1], inputs[3]);
                    inputs[27] = census_greatest(inputs[1], 0);
                    inputs[28] = census_greatest(inputs[3], inputs[19]);
                    for (uint32_t f = 0; f < 7; f += 1)
                    {
                        outputs[f] = own[f];
                    }
                    census_add(&type, op, inputs, outputs);
                }
                if (unit.operand_count[g] != 0 && !operands_given[op])
                {
                    uint32_t index = 0;
                    for (uint32_t c = unit.first_child[g]; c != NONE; c = unit.next_sibling[c])
                    {
                        uint8_t inputs[CENSUS_INPUTS_MOST] = { 0 };
                        uint32_t outputs[CENSUS_OUTPUTS_MOST] = { 0 };
                        inputs[0] = unit.operand_count[g];
                        inputs[1] = unit.context_truth[g];
                        inputs[2] = (uint8_t)(index > 3 ? 3 : index);
                        inputs[3] = unit.op[c];
                        memcpy(inputs + 4, own, 7);
                        census_facts_bytes(inputs + 11, unit.facts_truth[unit.child0[g]]);
                        census_facts_bytes(inputs + 18, unit.facts_truth[unit.child1[g]]);
                        census_facts_bytes(inputs + 25, unit.facts_truth[c]);
                        inputs[32] = inputs[25] == inputs[4];
                        inputs[33] = census_greatest(inputs[11], inputs[18]);
                        inputs[34] = inputs[25] == inputs[33];
                        inputs[35] = unit.context_truth[c];
                        outputs[0] = unit.context_truth[c];
                        outputs[1] = unit.target_truth[c] & 0xff;
                        outputs[2] = unit.target_truth[c] >> 8;
                        census_add(&context, op, inputs, outputs);
                        index += 1;
                    }
                }
                {
                    uint8_t inputs[CENSUS_INPUTS_MOST] = { 0 };
                    uint32_t outputs[CENSUS_OUTPUTS_MOST] = { 0 };
                    const uint32_t expand_types = op != OP_VALUE ? types : 0;
                    inputs[0] = unit.context_truth[g];
                    inputs[1] = (uint8_t)unit.target_truth[g];
                    inputs[2] = (uint8_t)(unit.target_truth[g] >> 8);
                    inputs[3] = store_of(&unit, unit.facts_truth, g);
                    inputs[4] = unit.operand_count[g];
                    memcpy(inputs + 5, &expand_types, 4);
                    memcpy(inputs + 9, own, 7);
                    const bool held = unit.refused[g] == 0;
                    outputs[0] = held ? template_of[unit.template_truth[g]] : UINT32_MAX;
                    outputs[1] = held ? unit.templates[unit.template_truth[g]].total : 255;
                    census_add(&expand, op, inputs, outputs);
                }
            }
        }
        free(template_of);
    }
    printf("population\tnodes=%llu\texpressions=%llu\ttemplates=%u\n", (unsigned long long)nodes, (unsigned long long)trees.expressions, templates.count);
    for (uint32_t f = 0; f < 7; f += 1)
    {
        uint32_t distinct = 0;
        for (uint32_t v = 0; v < 256; v += 1)
        {
            distinct += fact_seen[f][v];
        }
        printf("fact\t%s\tvalues=%u:", fact_names[f], distinct);
        for (uint32_t v = 0; v < 256; v += 1)
        {
            if (fact_seen[f][v])
            {
                printf(" %u", v);
            }
        }
        printf("\n");
    }
    static const uint32_t limits[3] = { 32, 64, 127 };
    printf("trees\tnodes-with-operands=%llu\twhose-last-operand-isn't-the-record-before=%llu\n", (unsigned long long)trees.with_operands,
           (unsigned long long)trees.last_not_before);
    for (uint32_t limit = 0; limit < 3; limit += 1)
    {
        printf("trees\tmore than %u records back: first operands=%llu (%.3f%% of the nodes with operands)\tany operand=%llu (%.3f%%)\texpressions with one=%llu (%.3f%%), their nodes=%llu (%.3f%% of all)\n",
               limits[limit], (unsigned long long)trees.first_far[limit], 100.0 * (double)trees.first_far[limit] / (double)trees.with_operands,
               (unsigned long long)trees.any_far[limit], 100.0 * (double)trees.any_far[limit] / (double)trees.with_operands, (unsigned long long)trees.expressions_far[limit],
               100.0 * (double)trees.expressions_far[limit] / (double)trees.expressions, (unsigned long long)trees.expression_nodes_far[limit],
               100.0 * (double)trees.expression_nodes_far[limit] / (double)trees.nodes);
    }
    printf("trees\tblocks of 64 records=%llu\trounds a block=%.3f\ttable-typed nodes=%llu\tblocks by rounds:", (unsigned long long)trees.blocks,
           (double)trees.rounds / (double)trees.blocks, (unsigned long long)trees.table_nodes);
    for (uint32_t rounds = 0; rounds < 16; rounds += 1)
    {
        if (trees.rounds_histogram[rounds] != 0)
        {
            printf(" %u%s: %.2f%%", rounds, rounds == 15 ? "+" : "", 100.0 * (double)trees.rounds_histogram[rounds] / (double)trees.blocks);
        }
    }
    printf("\ntrees\texpressions by the rounds their tallest chain of table-typed nodes takes:");
    for (uint32_t rounds = 0; rounds < 16; rounds += 1)
    {
        if (trees.height_histogram[rounds] != 0)
        {
            printf(" %u%s: %.2f%%", rounds, rounds == 15 ? "+" : "", 100.0 * (double)trees.height_histogram[rounds] / (double)trees.expressions);
        }
    }
    printf("\n");
    if (list_table != NULL)
    {
        const CensusTable* listed = list_table[0] == 'T' ? &type : list_table[0] == 'C' ? &context : &expand;
        for (uint32_t op = 0; op < OPS; op += 1)
        {
            if (strcmp(op_names[op], list_op) == 0)
            {
                census_list(listed, (uint8_t)op);
            }
        }
    }
    else
    {
        census_table(&type, print_rows);
        census_table(&context, print_rows);
        census_table(&expand, print_rows);
    }
    return 0;
}
