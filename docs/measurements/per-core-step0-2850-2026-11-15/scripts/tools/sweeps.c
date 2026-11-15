// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// sweeps.c: a prototype of buster#2524's node machine's three sweeps over real nodes, for what their tables decide and
// what they cost. Not the machine: it reads no source, binds no name, reads no type table and knows no C rule. Its
// input is the dump that inventory-dump.patch makes measure-lowering-templates write: every evaluated node of every
// lowered body with the lowering's own key for it (its operator, its context, its type's class and facts, its
// operands' and its conversion target's), the node that asked for it, and the typed entries the tasks wrote for it.
//
//   sweeps DUMP [--train DUMP] [--passes N] [--ops]
//
// It makes each body's nodes a postorder with operand links, each full expression's tree together, and then:
//   - T, up: each node's facts (the key's bytes 2 to 8: its type's class and facts, its constant kind, its category,
//     its flags, its object's kind, whether its member's offset is past the start) from a table keyed by its operator,
//     its evaluated operands' facts and its first two operands' types' class and facts. The operators whose type is a
//     declaration's or the type table's to give (facts_given_ops: a leaf, a cast, a member, a subscript, a
//     dereference, a call, a conversion, a builtin) take their facts as given, as the machine would take them from
//     that lookup.
//   - C, down: each operand's context (address, initialized, discard, _BitInt, popped twice) and conversion target from a table
//     keyed by the node's operator, context and facts, the operand's index, operator and facts, and the first two
//     operands' facts. A call's and a builtin's operands (operands_given_ops: the targets are the prototype's
//     parameters) take theirs as given.
//   - X: each node's key rebuilt from that state alone (compared with the lowering's own), a table from the key and
//     the operand count to a template (its entries' kinds and classes, in runs before, between and after its operands,
//     and the conversion asked of it), and the expression's entries written in evaluation order with fixed-width
//     stores: straight down the postorder when no node of the tree writes before or between its operands, by a walk
//     otherwise. The entries' values are not computed: each node's are given, in its template's order.
// A node's facts go into the keys as one 64-bit code (a given node's comes with its facts, as a declaration or the
// type table would hold it), so that a key is a multiply or two over a few small fields and its operands' codes: the
// tables are hashed where the machine's baked ones would be indexed by small codes, one 16-byte slot a key.
// The tables are learned from the dump itself (or from --train's, to see what another corpus's tables take of this
// one): a key that two nodes answer differently is a conflict, and its nodes are refused. A full expression is taken
// when every node of it is in the tables, and nothing of the truth decides that: a node whose entries no template
// holds (more than 16, a run of more than 8, an entry inside an operand's, a node popped twice) gives its key no
// template. A taken expression's emitted entries are then compared with the stream's own, entry for entry. The sweeps are timed a unit at a time (each sweep over every node, for the
// split) and an expression at a time (the machine's order), tables frozen, with cycles and instructions from
// perf_event_open where it is allowed and TSC ticks besides.
#define _GNU_SOURCE
#include <linux/perf_event.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <x86intrin.h>

#define NONE UINT32_MAX
#define OPS 69
#define KEY_BYTES 32
#define TEMPLATE_ENTRIES 16
#define RUN_MOST 8
#define CONFLICT (UINT64_C(1) << 63)
// The expansion table's answer for a key that a node no template holds gave: with a template from another node, the
// key is in conflict; alone, it is a miss. So the table alone refuses such a node, and nothing of the truth does.
#define NO_TEMPLATE UINT64_C(0x7fffffff)

static const char* const op_names[OPS] = {
    "value", "+x", "-x", "!", "~", "+", "-", "*", "/", "%", "<<", ">>", "<", "<=", ">", ">=", "==", "!=", "&", "|", "^", "&&", "||", "?:", "cast", "&x", "*x", "=", ",",
    "[]", "sizeof", "alignof", ".", "->", "call", "initialize", "convert", "condition", "++x", "--x", "x++", "x--", "+=", "-=", "*=", "/=", "%=", "<<=", ">>=", "&=", "|=",
    "^=", "select", "builtin-unary", "builtin-overflow", "statement-value", "va_arg", "vla-bound", "vla-extent", "sizeof-vla", "builtin-misc", "builtin-float",
    "builtin-query", "builtin-atomic", "__real", "__imag", "builtin-vector", "builtin-x86", "builtin-bit-cast",
};
#define OP_VALUE 0
#define OP_ASSIGN 27
#define OP_PRE_INCREMENT 38
#define OP_BIT_XOR_ASSIGN 51
// The operators whose facts are a lookup's to give: a value's, a cast's, a dereference's, a subscript's, a member's, a
// call's, an initialization's, a conversion's, a statement expression's, va_arg's, a variable-length array's and the
// builtins'.
static const uint8_t facts_given_ops[] = { 0, 24, 26, 29, 32, 33, 34, 35, 36, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 66, 67, 68 };
// The operators whose operands' targets are a prototype's to give: a call's and the builtins'.
static const uint8_t operands_given_ops[] = { 34, 53, 54, 60, 61, 62, 63, 66, 67, 68 };
static bool facts_given[256];
static bool operands_given[256];

// Why a node is refused, and what a sweep missed for it.
#define REFUSED_AGAIN 1u
#define REFUSED_PLACE 2u
#define REFUSED_LONG 4u
#define MISSED_TYPE 1u
#define MISSED_CONTEXT 2u
#define MISSED_TEMPLATE 4u
// A node's context is its pop's flags (the lowering key's byte 1) and, with this bit, that the tasks pop it twice (a
// compound literal's value wherever it is used; in musl, some dereferences at a root with their operand). The node's
// key doesn't say it, so the context carries it: a root's is given, an operand's is C's table's answer.
#define CONTEXT_AGAIN 0x80u

typedef struct DumpPop DumpPop;
struct DumpPop
{
    uint32_t node;
    uint32_t parent;
    uint32_t low;
    uint32_t high;
    uint32_t own;
    uint32_t flags;
    uint32_t category;
    uint32_t times;
    uint32_t type;
    uint32_t operands[3];
    uint8_t key[KEY_BYTES];
};

typedef struct DumpOwner DumpOwner;
struct DumpOwner
{
    uint32_t pop;
    uint32_t what;
};

// A node's entries: `runs[0]` before its first operand's, `runs[1]` after it, `runs[2]` after the second's, `runs[3]`
// after its last operand's (a leaf's only run), and `converted`, the conversion asked of its value, last. Kinds and
// classes in that order, padded for whole-row stores. `early`: whether it writes before or between its operands.
typedef struct Template Template;
struct Template
{
    uint8_t runs[4];
    uint8_t converted;
    uint8_t total;
    uint8_t early;
    uint8_t padding;
    uint8_t kinds[TEMPLATE_ENTRIES + RUN_MOST];
    uint8_t classes[TEMPLATE_ENTRIES + RUN_MOST];
};

// An open-addressed table from a 64-bit key (never 0) to a 63-bit value, one 16-byte slot a key; CONFLICT marks a key
// that was given two values.
typedef struct Slot Slot;
struct Slot
{
    uint64_t key;
    uint64_t value;
};

typedef struct Table Table;
struct Table
{
    Slot* slots;
    // While the table is learned: how many nodes gave each key. `singles`: the keys one node alone gave.
    uint32_t* counts;
    uint64_t mask;
    uint32_t shift;
    uint64_t count;
    uint64_t conflicts;
    uint64_t singles;
};

static void* must(void* pointer)
{
    if (pointer == NULL)
    {
        fprintf(stderr, "sweeps: no memory\n");
        exit(1);
    }
    return pointer;
}

static void table_make(Table* table, uint32_t log2)
{
    table->mask = (UINT64_C(1) << log2) - 1;
    table->shift = 64 - log2;
    table->slots = must(calloc(table->mask + 1, sizeof(Slot)));
    table->counts = must(calloc(table->mask + 1, sizeof(uint32_t)));
    table->count = 0;
    table->conflicts = 0;
    table->singles = 0;
}

static inline uint64_t mix(uint64_t h, uint64_t v)
{
    h ^= v;
    h *= UINT64_C(0x9e3779b97f4a7c15);
    h ^= h >> 29;
    return h;
}

// The slot of `key`: its own, or the empty one it would take.
static inline uint64_t table_slot(const Table* table, uint64_t key)
{
    uint64_t slot = (key * UINT64_C(0xd6e8feb86659fd93)) >> table->shift;
    while (table->slots[slot].key != 0 && table->slots[slot].key != key)
    {
        slot = (slot + 1) & table->mask;
    }
    return slot;
}

// Learns key -> value: a second value for a key marks it a conflict.
static void table_learn(Table* table, uint64_t key, uint64_t value)
{
    const uint64_t slot = table_slot(table, key);
    table->counts[slot] += 1;
    if (table->slots[slot].key == 0)
    {
        table->slots[slot].key = key;
        table->slots[slot].value = value;
        table->count += 1;
        if (table->count * 2 > table->mask)
        {
            fprintf(stderr, "sweeps: a table filled\n");
            exit(1);
        }
    }
    else if ((table->slots[slot].value & ~CONFLICT) != value)
    {
        table->conflicts += (table->slots[slot].value & CONFLICT) == 0;
        table->slots[slot].value |= CONFLICT;
    }
}

// The value of `key` into *value: whether the table has it without a conflict.
static inline bool table_find(const Table* table, uint64_t key, uint64_t* value)
{
    const Slot slot = table->slots[table_slot(table, key)];
    *value = slot.value;
    return slot.key == key && (slot.value & CONFLICT) == 0;
}

// The table in the fewest slots that keep it at most a quarter full, as a baked one would be.
static void table_compact(Table* table)
{
    uint32_t log2 = 6;
    while ((UINT64_C(1) << log2) < table->count * 4)
    {
        log2 += 1;
    }
    Table compact;
    table_make(&compact, log2);
    for (uint64_t i = 0; i <= table->mask; i += 1)
    {
        if (table->slots[i].key != 0)
        {
            compact.slots[table_slot(&compact, table->slots[i].key)] = table->slots[i];
            compact.singles += table->counts[i] == 1;
        }
    }
    compact.count = table->count;
    compact.conflicts = table->conflicts;
    free(table->slots);
    free(table->counts);
    free(compact.counts);
    compact.counts = NULL;
    *table = compact;
}

// A unit's nodes in postorder, each full expression's tree together, with what the dump says of each (its truth) and
// what the sweeps compute.
typedef struct Unit Unit;
struct Unit
{
    uint32_t count;
    uint32_t root_count;
    uint64_t entry_count;
    uint32_t bodies;
    // What the machine would have of a node before the sweeps: its operator, its operand links, whether the table
    // types it, and what its lookups give.
    uint8_t* op;
    uint8_t* operand_count;
    uint8_t* by_table;
    uint32_t* parent;
    uint32_t* first_child;
    uint32_t* next_sibling;
    uint32_t* child0;
    uint32_t* child1;
    uint32_t* child2;
    // The graph's first two operands where they are the node's evaluated operands (NONE otherwise: their types' class
    // and facts are then given in `operand_types`, the key's bytes 9 to 12, and a store's destination in `store`).
    uint32_t* graph0;
    uint32_t* graph1;
    uint32_t* operand_types;
    uint8_t* store;
    // Truth. `code_truth`: each node's facts' code, which a given node's lookup gives with them.
    uint64_t* facts_truth;
    uint64_t* code_truth;
    uint8_t* context_truth;
    uint16_t* target_truth;
    uint8_t (*key_truth)[KEY_BYTES];
    uint32_t* template_truth;
    uint32_t* payload;
    uint8_t* refused;
    // Computed. Node `zero` stands for a missing operand in the keys: its facts and its code are 0.
    uint64_t* facts;
    uint64_t* code;
    uint8_t* context;
    uint16_t* target;
    uint32_t zero;
    // Roots: each one's node, its tree's first node, its entries' range in the unit's truth columns, and whether those
    // are its tree's nodes' alone.
    uint32_t* roots;
    uint32_t* root_first;
    uint64_t* root_low;
    uint32_t* root_entries;
    uint8_t* root_exact;
    uint8_t* root_taken;
    // The truth's entries, the unit's bodies' one after another, and the payload pool (each node's values in its
    // template's order).
    uint8_t* kinds;
    uint8_t* classes;
    uint64_t* values;
    uint64_t* pool;
    uint64_t pool_count;
    // The entries the nodes own (their own and their conversions), those of the nodes no template holds too.
    uint64_t owned;
    // The unit's templates.
    Template* templates;
    uint32_t template_count;
    // The emitted entries.
    uint8_t* out_kinds;
    uint8_t* out_classes;
    uint64_t* out_values;
    uint64_t* root_out;
};

static uint8_t* read_file(const char* path, uint64_t* size)
{
    FILE* file = fopen(path, "rb");
    if (file == NULL)
    {
        fprintf(stderr, "sweeps: can't open %s\n", path);
        exit(1);
    }
    fseek(file, 0, SEEK_END);
    *size = (uint64_t)ftell(file);
    fseek(file, 0, SEEK_SET);
    uint8_t* bytes = must(malloc(*size + 64));
    if (fread(bytes, 1, *size, file) != *size)
    {
        fprintf(stderr, "sweeps: can't read %s\n", path);
        exit(1);
    }
    fclose(file);
    return bytes;
}

static uint64_t facts_of(const uint8_t* key)
{
    uint64_t facts = 0;
    memcpy(&facts, key + 2, 7);
    return facts;
}

// A node's facts as one code for the keys.
static inline uint64_t code_of(uint64_t facts)
{
    return mix(0x4b, facts);
}

static inline uint64_t rotate(uint64_t value, uint32_t by)
{
    return value << by | value >> (64 - by);
}

// The unit's template that equals `candidate`, added if new.
static uint32_t template_intern(Unit* unit, Table* index, const Template* candidate, uint32_t* capacity)
{
    uint64_t hash = 0x1234;
    for (uint32_t i = 0; i < sizeof(Template); i += 1)
    {
        hash = mix(hash, ((const uint8_t*)candidate)[i]);
    }
    hash |= 1;
    uint64_t slot = table_slot(index, hash);
    while (index->slots[slot].key != 0 && memcmp(&unit->templates[index->slots[slot].value], candidate, sizeof(Template)) != 0)
    {
        hash = mix(hash, 0x77) | 1;
        slot = table_slot(index, hash);
    }
    if (index->slots[slot].key == 0)
    {
        if (unit->template_count == *capacity)
        {
            *capacity *= 2;
            unit->templates = must(realloc(unit->templates, *capacity * sizeof(Template)));
        }
        unit->templates[unit->template_count] = *candidate;
        index->slots[slot].key = hash;
        index->slots[slot].value = unit->template_count;
        index->count += 1;
        unit->template_count += 1;
    }
    return (uint32_t)index->slots[slot].value;
}

// Reads `path`'s dump into a unit: the nodes in postorder with their truth, the roots, the templates and payloads.
static void unit_read(Unit* unit, const char* path)
{
    uint64_t size = 0;
    const uint8_t* bytes = read_file(path, &size);
    uint64_t pops_total = 0;
    uint64_t entries_total = 0;
    uint64_t offset = 0;
    uint32_t widest = 0;
    uint32_t bodies = 0;
    while (offset + 12 <= size)
    {
        uint32_t header[3];
        memcpy(header, bytes + offset, 12);
        if (header[0] != UINT32_C(0x59444f42))
        {
            fprintf(stderr, "sweeps: %s isn't a dump at byte %llu\n", path, (unsigned long long)offset);
            exit(1);
        }
        pops_total += header[1];
        entries_total += header[2];
        widest = header[1] > widest ? header[1] : widest;
        offset += 12 + (uint64_t)header[2] * 18 + (uint64_t)header[1] * sizeof(DumpPop);
        bodies += 1;
    }
    memset(unit, 0, sizeof(*unit));
    unit->bodies = bodies;
    const uint64_t n = pops_total + 1;
    unit->op = must(calloc(n, 1));
    unit->operand_count = must(calloc(n, 1));
    unit->by_table = must(calloc(n, 1));
    unit->parent = must(malloc(n * 4));
    unit->first_child = must(malloc(n * 4));
    unit->next_sibling = must(malloc(n * 4));
    unit->child0 = must(malloc(n * 4));
    unit->child1 = must(malloc(n * 4));
    unit->child2 = must(malloc(n * 4));
    unit->graph0 = must(malloc(n * 4));
    unit->graph1 = must(malloc(n * 4));
    unit->operand_types = must(calloc(n, 4));
    unit->store = must(calloc(n, 1));
    unit->facts_truth = must(calloc(n, 8));
    unit->code_truth = must(calloc(n, 8));
    unit->context_truth = must(calloc(n, 1));
    unit->target_truth = must(calloc(n, 2));
    unit->key_truth = must(calloc(n, KEY_BYTES));
    unit->template_truth = must(calloc(n, 4));
    unit->payload = must(calloc(n, 4));
    unit->refused = must(calloc(n, 1));
    unit->facts = must(calloc(n, 8));
    unit->code = must(calloc(n, 8));
    unit->zero = (uint32_t)pops_total;
    unit->context = must(calloc(n, 1));
    unit->target = must(calloc(n, 2));
    unit->roots = must(malloc(n * 4));
    unit->root_first = must(malloc(n * 4));
    unit->root_low = must(malloc(n * 8));
    unit->root_entries = must(malloc(n * 4));
    unit->root_exact = must(calloc(n, 1));
    unit->root_taken = must(calloc(n, 1));
    unit->root_out = must(calloc(n, 8));
    unit->kinds = must(malloc(entries_total + 64));
    unit->classes = must(malloc(entries_total + 64));
    unit->values = must(malloc((entries_total + 16) * 8));
    unit->pool = must(calloc(entries_total + pops_total * 2 + 64, 8));
    unit->out_kinds = must(calloc(entries_total + 64, 1));
    unit->out_classes = must(calloc(entries_total + 64, 1));
    unit->out_values = must(calloc(entries_total + 64, 8));
    uint32_t template_capacity = 1024;
    unit->templates = must(malloc(template_capacity * sizeof(Template)));
    Table template_index;
    table_make(&template_index, 16);
    // Per body scratch, by pop.
    const uint64_t w = (uint64_t)widest + 1;
    uint32_t* node_of = must(malloc(w * 4));
    uint32_t* order = must(malloc(w * 4));
    uint32_t* first = must(malloc(w * 4));
    uint32_t* last = must(malloc(w * 4));
    uint32_t* next = must(malloc(w * 4));
    uint32_t* stack = must(malloc(w * 4));
    uint32_t* cursor = must(malloc(w * 4));
    Template* building = must(malloc(w * sizeof(Template)));
    uint64_t (*slots)[TEMPLATE_ENTRIES] = must(malloc(w * sizeof(*slots)));
    uint8_t* stage = must(malloc(w));
    DumpPop* pops = must(malloc(w * sizeof(DumpPop)));
    offset = 0;
    uint64_t entry_base = 0;
    while (offset + 12 <= size)
    {
        uint32_t header[3];
        memcpy(header, bytes + offset, 12);
        const uint32_t pop_count = header[1];
        const uint32_t entry_count = header[2];
        const uint8_t* kinds = bytes + offset + 12;
        const uint8_t* classes = kinds + entry_count;
        const uint8_t* values = classes + entry_count;
        const uint8_t* owners = values + (uint64_t)entry_count * 8;
        const uint8_t* pop_bytes = owners + (uint64_t)entry_count * 8;
        memcpy(unit->kinds + entry_base, kinds, entry_count);
        memcpy(unit->classes + entry_base, classes, entry_count);
        memcpy(unit->values + entry_base, values, (uint64_t)entry_count * 8);
        memcpy(pops, pop_bytes, (uint64_t)pop_count * sizeof(DumpPop));
        // The first pops are the nodes; each one's operands in pop order, which is evaluation order.
        for (uint32_t p = 0; p < pop_count; p += 1)
        {
            first[p] = NONE;
            last[p] = NONE;
            next[p] = NONE;
            node_of[p] = NONE;
        }
        for (uint32_t p = 0; p < pop_count; p += 1)
        {
            const uint32_t parent = pops[p].parent;
            if (pops[p].category != NONE && parent != NONE && parent < pop_count)
            {
                if (last[parent] == NONE)
                {
                    first[parent] = p;
                }
                else
                {
                    next[last[parent]] = p;
                }
                last[parent] = p;
            }
        }
        // A postorder of each root's tree, the roots in pop order.
        const uint32_t base = unit->count;
        uint32_t placed = 0;
        for (uint32_t r = 0; r < pop_count; r += 1)
        {
            if (pops[r].category != NONE && (pops[r].parent == NONE || pops[r].parent >= pop_count))
            {
                const uint32_t tree_first = base + placed;
                uint32_t depth = 0;
                stack[0] = r;
                cursor[0] = first[r];
                while (depth != NONE)
                {
                    const uint32_t child = cursor[depth];
                    if (child != NONE)
                    {
                        cursor[depth] = next[child];
                        depth += 1;
                        stack[depth] = child;
                        cursor[depth] = first[child];
                    }
                    else
                    {
                        node_of[stack[depth]] = base + placed;
                        order[placed] = stack[depth];
                        placed += 1;
                        depth = depth == 0 ? NONE : depth - 1;
                    }
                }
                const uint32_t root = unit->root_count++;
                unit->roots[root] = base + placed - 1;
                unit->root_first[root] = tree_first;
                unit->root_low[root] = entry_base + pops[r].low;
                unit->root_entries[root] = pops[r].low == NONE ? 0 : pops[r].high - pops[r].low + 1;
            }
        }
        // The nodes' inputs and truth.
        for (uint32_t k = 0; k < placed; k += 1)
        {
            const uint32_t p = order[k];
            const uint32_t g = base + k;
            const DumpPop* pop = pops + p;
            const uint8_t op = pop->key[0];
            unit->op[g] = op;
            unit->parent[g] = pop->parent != NONE && pop->parent < pop_count ? node_of[pop->parent] : NONE;
            unit->facts_truth[g] = facts_of(pop->key);
            unit->code_truth[g] = code_of(unit->facts_truth[g]);
            unit->context_truth[g] = (uint8_t)(pop->key[1] | (pop->times > 1 ? CONTEXT_AGAIN : 0));
            unit->target_truth[g] = (uint16_t)(pop->key[13] | pop->key[14] << 8);
            memcpy(unit->key_truth[g], pop->key, KEY_BYTES);
            memcpy(&unit->operand_types[g], pop->key + 9, 4);
            unit->store[g] = pop->key[17];
            unit->refused[g] = pop->times > 1 || op >= OPS ? REFUSED_AGAIN : 0;
            // A graph operand is read as a node where it is this node's evaluated operand.
            const uint32_t a = pop->operands[0];
            const uint32_t b = pop->operands[1];
            unit->graph0[g] = a != NONE && a < pop_count && pops[a].category != NONE && pops[a].parent == p ? node_of[a] : NONE;
            unit->graph1[g] = b != NONE && b < pop_count && pops[b].category != NONE && pops[b].parent == p ? node_of[b] : NONE;
            uint32_t count = 0;
            uint32_t children[3] = { unit->zero, unit->zero, unit->zero };
            uint32_t previous = NONE;
            unit->first_child[g] = NONE;
            unit->next_sibling[g] = NONE;
            for (uint32_t c = first[p]; c != NONE; c = next[c])
            {
                const uint32_t child = node_of[c];
                if (count < 3)
                {
                    children[count] = child;
                }
                if (previous == NONE)
                {
                    unit->first_child[g] = child;
                }
                else
                {
                    unit->next_sibling[previous] = child;
                }
                previous = child;
                count += 1;
            }
            unit->operand_count[g] = count > 250 ? 250 : (uint8_t)count;
            unit->refused[g] |= count > 250 ? REFUSED_LONG : 0;
            unit->by_table[g] = count != 0 && !facts_given[op];
            unit->child0[g] = children[0];
            unit->child1[g] = children[1];
            unit->child2[g] = children[2];
            memset(&building[k], 0, sizeof(Template));
            stage[k] = 0;
        }
        // The entries, in order, each to its node's run: before, between or after its operands by where the operands'
        // ranges lie, or its conversion.
        for (uint32_t e = 0; e < entry_count; e += 1)
        {
            DumpOwner owner;
            memcpy(&owner, owners + (uint64_t)e * 8, 8);
            uint64_t value;
            memcpy(&value, values + (uint64_t)e * 8, 8);
            const uint32_t g = owner.what <= 1 && owner.pop != NONE && owner.pop < pop_count ? node_of[owner.pop] : NONE;
            if (g != NONE && g >= base)
            {
                const uint32_t k = g - base;
                const uint32_t p = owner.pop;
                Template* t = &building[k];
                unit->owned += 1;
                uint32_t run = 4;
                if (owner.what == 0)
                {
                    uint32_t before = 0;
                    uint32_t children = 0;
                    bool inside = false;
                    for (uint32_t c = first[p]; c != NONE; c = next[c])
                    {
                        children += 1;
                        before += pops[c].low != NONE && pops[c].high < e;
                        inside = inside || (pops[c].low != NONE && pops[c].low <= e && e <= pops[c].high);
                    }
                    run = before == children ? 3 : before;
                    unit->refused[g] |= inside || (before >= 3 && before != children) ? REFUSED_PLACE : 0;
                    run = run > 3 ? 3 : run;
                }
                // Runs come in order, and each holds at most a row.
                const uint32_t length = run == 4 ? t->converted : t->runs[run];
                unit->refused[g] |= run < stage[k] ? REFUSED_PLACE : 0;
                unit->refused[g] |= t->total >= TEMPLATE_ENTRIES || length >= RUN_MOST ? REFUSED_LONG : 0;
                if (unit->refused[g] == 0)
                {
                    stage[k] = (uint8_t)run;
                    if (run == 4)
                    {
                        t->converted += 1;
                    }
                    else
                    {
                        t->runs[run] += 1;
                    }
                    t->kinds[t->total] = kinds[e];
                    t->classes[t->total] = classes[e];
                    slots[k][t->total] = value;
                    t->total += 1;
                }
            }
        }
        // A root's range holds its tree's entries alone: nothing a control or a token owns, and every entry counted.
        for (uint32_t root = unit->root_count; root-- > 0 && unit->roots[root] >= base;)
        {
            uint32_t sum = 0;
            for (uint32_t g = unit->root_first[root]; g <= unit->roots[root]; g += 1)
            {
                sum += building[g - base].total;
            }
            unit->root_exact[root] = sum == unit->root_entries[root];
        }
        for (uint32_t k = 0; k < placed; k += 1)
        {
            const uint32_t g = base + k;
            building[k].early = (building[k].runs[0] | building[k].runs[1] | building[k].runs[2]) != 0;
            unit->template_truth[g] = template_intern(unit, &template_index, &building[k], &template_capacity);
            unit->payload[g] = (uint32_t)unit->pool_count;
            memcpy(unit->pool + unit->pool_count, slots[k], (uint64_t)building[k].total * 8);
            unit->pool_count += building[k].total;
        }
        unit->count += placed;
        entry_base += entry_count;
        offset += 12 + (uint64_t)entry_count * 18 + (uint64_t)pop_count * sizeof(DumpPop);
    }
    unit->entry_count = entry_base;
    free(template_index.slots);
    free(template_index.counts);
    free(node_of);
    free(order);
    free(first);
    free(last);
    free(next);
    free(stack);
    free(cursor);
    free(building);
    free(slots);
    free(stage);
    free(pops);
    free((void*)bytes);
}

// The tables, the templates the expansion's values index, and each operator's nodes and how many of them a key that
// conflicts would refuse were the operator the table's (the given ones too, for the report).
typedef struct Tables Tables;
struct Tables
{
    Table type;
    Table context;
    Table expand;
    Template* templates;
    uint32_t template_count;
    uint64_t nodes[OPS];
    uint64_t type_conflicts[OPS];
    uint64_t context_conflicts[OPS];
};

// The first two operands' types' class and facts: the sweep's own where the operand is the node's evaluated operand,
// given otherwise.
static inline uint32_t operand_types_of(const Unit* unit, const uint64_t* facts, uint32_t g)
{
    const uint32_t a = unit->graph0[g];
    const uint32_t b = unit->graph1[g];
    const uint32_t given = unit->operand_types[g];
    const uint32_t low = a != NONE ? (uint32_t)(facts[a] & 0xffff) : given & 0xffff;
    const uint32_t high = b != NONE ? (uint32_t)(facts[b] & 0xffff) : given >> 16;
    return low | high << 16;
}

static inline uint64_t type_key(const Unit* unit, const uint64_t* facts, const uint64_t* code, uint32_t g)
{
    const uint64_t key = mix(0x54, unit->op[g] | (uint64_t)unit->operand_count[g] << 8 | (uint64_t)operand_types_of(unit, facts, g) << 16);
    return (key ^ code[unit->child0[g]] ^ rotate(code[unit->child1[g]], 21) ^ rotate(code[unit->child2[g]], 42)) | 1;
}

static inline uint64_t context_key(const Unit* unit, const uint64_t* code, const uint8_t* context, uint32_t g, uint32_t index, uint32_t operand)
{
    const uint64_t key = mix(0x43, unit->op[g] | (uint64_t)unit->operand_count[g] << 8 | (uint64_t)context[g] << 16 | (uint64_t)(index > 3 ? 3 : index) << 24 |
                                       (uint64_t)unit->op[operand] << 32);
    return (key ^ rotate(code[g], 7) ^ rotate(code[unit->child0[g]], 21) ^ rotate(code[unit->child1[g]], 42) ^ rotate(code[operand], 53)) | 1;
}

// A store's destination's kind, as the lowering's key has it: 0 for no store, 0xff for a destination that is no
// object's value.
static inline uint8_t store_of(const Unit* unit, const uint64_t* facts, uint32_t g)
{
    const uint8_t op = unit->op[g];
    uint8_t store = 0;
    if (op == OP_ASSIGN || (op >= OP_PRE_INCREMENT && op <= OP_BIT_XOR_ASSIGN))
    {
        const uint32_t a = unit->graph0[g];
        const uint8_t object = a != NONE && unit->op[a] == OP_VALUE ? (uint8_t)(facts[a] >> 40) : 0;
        store = a == NONE ? unit->store[g] : (object & 3) == 0 ? 0xff : (uint8_t)(object & 0x0b);
    }
    return store;
}

// The lowering's key of node `g`, rebuilt from the sweeps' state: its operator, its context, its facts, its first two
// operands' types' class and facts, its target, and a store's destination's kind.
static inline void expand_key_bytes(const Unit* unit, const uint64_t* facts, const uint8_t* context, const uint16_t* target, uint32_t g, uint8_t* key)
{
    memset(key, 0, KEY_BYTES);
    const uint8_t op = unit->op[g];
    key[0] = op;
    key[1] = context[g] & (uint8_t)~CONTEXT_AGAIN;
    memcpy(key + 2, &facts[g], 7);
    const uint32_t types = op != OP_VALUE ? operand_types_of(unit, facts, g) : 0;
    memcpy(key + 9, &types, 4);
    key[13] = (uint8_t)target[g];
    key[14] = (uint8_t)(target[g] >> 8);
    key[17] = store_of(unit, facts, g);
}

// The same key's fields and the operand count, hashed.
static inline uint64_t expand_key(const Unit* unit, const uint64_t* facts, const uint64_t* code, const uint8_t* context, const uint16_t* target, uint32_t g)
{
    const uint8_t op = unit->op[g];
    const uint32_t types = op != OP_VALUE ? operand_types_of(unit, facts, g) : 0;
    uint64_t key = mix(0x58, op | (uint64_t)context[g] << 8 | (uint64_t)target[g] << 16 | (uint64_t)store_of(unit, facts, g) << 32 | (uint64_t)unit->operand_count[g] << 40);
    key = mix(key, types);
    return (key ^ code[g]) | 1;
}

// Learns the three tables from `unit`'s truth, and counts each operator's nodes in conflicting keys.
static void tables_learn(Tables* tables, const Unit* unit)
{
    memset(tables, 0, sizeof(*tables));
    table_make(&tables->type, 20);
    table_make(&tables->context, 20);
    table_make(&tables->expand, 20);
    // Every operator in a table of its own kind, for the report of what the keys decide.
    Table probe_type;
    table_make(&probe_type, 20);
    Table probe_context;
    table_make(&probe_context, 20);
    for (uint32_t g = 0; g < unit->count; g += 1)
    {
        const uint8_t op = unit->op[g];
        if (unit->operand_count[g] != 0)
        {
            const uint64_t key = type_key(unit, unit->facts_truth, unit->code_truth, g);
            table_learn(&probe_type, key, unit->facts_truth[g]);
            if (!facts_given[op])
            {
                table_learn(&tables->type, key, unit->facts_truth[g]);
            }
            uint32_t index = 0;
            for (uint32_t c = unit->first_child[g]; c != NONE; c = unit->next_sibling[c])
            {
                const uint64_t operand_key = context_key(unit, unit->code_truth, unit->context_truth, g, index, c);
                const uint64_t answer = unit->context_truth[c] | (uint64_t)unit->target_truth[c] << 8;
                table_learn(&probe_context, operand_key, answer);
                if (!operands_given[op])
                {
                    table_learn(&tables->context, operand_key, answer);
                }
                index += 1;
            }
        }
        table_learn(&tables->expand, expand_key(unit, unit->facts_truth, unit->code_truth, unit->context_truth, unit->target_truth, g),
                    unit->refused[g] == 0 ? unit->template_truth[g] : NO_TEMPLATE);
    }
    for (uint32_t g = 0; g < unit->count; g += 1)
    {
        const uint8_t op = unit->op[g];
        if (unit->operand_count[g] != 0 && op < OPS)
        {
            uint64_t value;
            tables->nodes[op] += 1;
            tables->type_conflicts[op] += !table_find(&probe_type, type_key(unit, unit->facts_truth, unit->code_truth, g), &value);
            uint32_t index = 0;
            bool conflict = false;
            for (uint32_t c = unit->first_child[g]; c != NONE; c = unit->next_sibling[c])
            {
                conflict = conflict || !table_find(&probe_context, context_key(unit, unit->code_truth, unit->context_truth, g, index, c), &value);
                index += 1;
            }
            tables->context_conflicts[op] += conflict;
        }
    }
    table_compact(&tables->type);
    table_compact(&tables->context);
    table_compact(&tables->expand);
    tables->templates = unit->templates;
    tables->template_count = unit->template_count;
    free(probe_type.slots);
    free(probe_type.counts);
    free(probe_context.slots);
    free(probe_context.counts);
}

// What the sweeps write besides the unit's columns.
typedef struct Work Work;
struct Work
{
    uint32_t* chosen;
    uint8_t* early;
    uint8_t* missed;
    uint32_t* stack;
    uint32_t* cursor;
    uint32_t* done;
};

// T over nodes [first, end): each one's facts, up the postorder. A miss leaves the given facts, so that the sweeps
// after it read what the refusal's path would, and marks the node.
static inline void types_range(Unit* unit, const Tables* tables, Work* work, uint32_t first, uint32_t end)
{
    uint64_t* facts = unit->facts;
    uint64_t* codes = unit->code;
    for (uint32_t g = first; g < end; g += 1)
    {
        uint64_t value = unit->facts_truth[g];
        uint64_t code = unit->code_truth[g];
        uint8_t miss = 0;
        if (unit->by_table[g])
        {
            uint64_t answer;
            const bool found = table_find(&tables->type, type_key(unit, facts, codes, g), &answer);
            value = found ? answer : value;
            code = found ? code_of(answer) : code;
            miss = found ? 0 : MISSED_TYPE;
        }
        facts[g] = value;
        codes[g] = code;
        work->missed[g] = miss;
    }
}

// C over nodes [first, end): each operand's context and target, down from the roots, whose own are given.
static inline void contexts_range(Unit* unit, const Tables* tables, Work* work, uint32_t first, uint32_t end)
{
    const uint64_t* codes = unit->code;
    uint8_t* context = unit->context;
    uint16_t* target = unit->target;
    for (uint32_t g = end; g-- > first;)
    {
        if (unit->parent[g] == NONE)
        {
            context[g] = unit->context_truth[g];
            target[g] = unit->target_truth[g];
        }
        if (unit->operand_count[g] != 0)
        {
            const bool given = operands_given[unit->op[g]];
            uint32_t index = 0;
            for (uint32_t c = unit->first_child[g]; c != NONE; c = unit->next_sibling[c])
            {
                uint64_t value = unit->context_truth[c] | (uint64_t)unit->target_truth[c] << 8;
                if (!given)
                {
                    uint64_t answer;
                    const bool found = table_find(&tables->context, context_key(unit, codes, context, g, index, c), &answer);
                    value = found ? answer : value;
                    work->missed[g] |= found ? 0 : MISSED_CONTEXT;
                }
                context[c] = (uint8_t)value;
                target[c] = (uint16_t)(value >> 8);
                index += 1;
            }
        }
    }
}

// The template of each node of [first, end), by its rebuilt key.
static inline void templates_range(Unit* unit, const Tables* tables, Work* work, uint32_t first, uint32_t end)
{
    for (uint32_t g = first; g < end; g += 1)
    {
        uint64_t value;
        const bool found = table_find(&tables->expand, expand_key(unit, unit->facts, unit->code, unit->context, unit->target, g), &value) && value != NO_TEMPLATE;
        const uint32_t chosen = found ? (uint32_t)value : 0;
        work->chosen[g] = chosen;
        work->early[g] = found ? tables->templates[chosen].early : 0;
        work->missed[g] |= found ? 0 : MISSED_TEMPLATE;
    }
}

static inline uint64_t emit_run(const Unit* unit, const Template* t, uint32_t offset, uint32_t length, uint64_t payload, uint64_t out)
{
    memcpy(unit->out_kinds + out, t->kinds + offset, RUN_MOST);
    memcpy(unit->out_classes + out, t->classes + offset, RUN_MOST);
    memcpy(unit->out_values + out, unit->pool + payload + offset, RUN_MOST * 8);
    return out + length;
}

// X for root `r`: whether it is taken, and then its entries from `out` on. Straight down the postorder when no node
// writes before or between its operands (each node's entries then follow its operands' trees'); else a walk: a node's
// first run, then each operand's tree with the node's run after it, then its conversion. Returns the entries' end.
static inline uint64_t expand_root(Unit* unit, const Tables* tables, Work* work, uint32_t r, uint64_t out)
{
    const Template* templates = tables->templates;
    const uint32_t* chosen = work->chosen;
    const uint32_t first = unit->root_first[r];
    const uint32_t root = unit->roots[r];
    uint32_t bad = 0;
    uint32_t early = 0;
    for (uint32_t g = first; g <= root; g += 1)
    {
        bad |= work->missed[g];
        early |= work->early[g];
    }
    unit->root_out[r] = out;
    unit->root_taken[r] = bad == 0;
    if (bad == 0 && early == 0)
    {
        for (uint32_t g = first; g <= root; g += 1)
        {
            const Template* t = templates + chosen[g];
            const uint64_t payload = unit->payload[g];
            memcpy(unit->out_kinds + out, t->kinds, 8);
            memcpy(unit->out_classes + out, t->classes, 8);
            memcpy(unit->out_values + out, unit->pool + payload, 64);
            if (t->total > 8)
            {
                memcpy(unit->out_kinds + out + 8, t->kinds + 8, 8);
                memcpy(unit->out_classes + out + 8, t->classes + 8, 8);
                memcpy(unit->out_values + out + 8, unit->pool + payload + 8, 64);
            }
            out += t->total;
        }
    }
    else if (bad == 0)
    {
        uint32_t* stack = work->stack;
        uint32_t* cursor = work->cursor;
        uint32_t* done = work->done;
        uint32_t depth = 0;
        stack[0] = root;
        cursor[0] = unit->first_child[root];
        done[0] = 0;
        {
            const Template* t = templates + chosen[root];
            out = emit_run(unit, t, 0, t->runs[0], unit->payload[root], out);
        }
        while (depth != NONE)
        {
            const uint32_t node = stack[depth];
            const Template* t = templates + chosen[node];
            const uint32_t child = cursor[depth];
            const uint32_t finished = done[depth];
            // The run after the operand just finished: the second after the first operand, the third after the second.
            uint32_t offset = t->runs[0];
            if (finished == 1)
            {
                out = emit_run(unit, t, offset, t->runs[1], unit->payload[node], out);
            }
            offset += t->runs[1];
            if (finished == 2)
            {
                out = emit_run(unit, t, offset, t->runs[2], unit->payload[node], out);
            }
            offset += t->runs[2];
            if (child != NONE)
            {
                // The next operand's tree, from its first run.
                cursor[depth] = unit->next_sibling[child];
                done[depth] = finished + 1;
                depth += 1;
                stack[depth] = child;
                cursor[depth] = unit->first_child[child];
                done[depth] = 0;
                const Template* c = templates + chosen[child];
                out = emit_run(unit, c, 0, c->runs[0], unit->payload[child], out);
            }
            else
            {
                out = emit_run(unit, t, offset, t->runs[3], unit->payload[node], out);
                out = emit_run(unit, t, offset + t->runs[3], t->converted, unit->payload[node], out);
                depth = depth == 0 ? NONE : depth - 1;
            }
        }
    }
    return out;
}

// A unit at a time: each sweep over every node.
static __attribute__((noinline)) void sweep_types(Unit* unit, const Tables* tables, Work* work)
{
    types_range(unit, tables, work, 0, unit->count);
}

static __attribute__((noinline)) void sweep_contexts(Unit* unit, const Tables* tables, Work* work)
{
    contexts_range(unit, tables, work, 0, unit->count);
}

static __attribute__((noinline)) void sweep_templates(Unit* unit, const Tables* tables, Work* work)
{
    templates_range(unit, tables, work, 0, unit->count);
}

static __attribute__((noinline)) uint64_t sweep_expand(Unit* unit, const Tables* tables, Work* work)
{
    uint64_t out = 0;
    for (uint32_t r = 0; r < unit->root_count; r += 1)
    {
        out = expand_root(unit, tables, work, r, out);
    }
    return out;
}

// An expression at a time, the machine's order: the three sweeps over one tree, then the next.
static __attribute__((noinline)) uint64_t sweep_expressions(Unit* unit, const Tables* tables, Work* work)
{
    uint64_t out = 0;
    for (uint32_t r = 0; r < unit->root_count; r += 1)
    {
        const uint32_t first = unit->root_first[r];
        const uint32_t end = unit->roots[r] + 1;
        types_range(unit, tables, work, first, end);
        contexts_range(unit, tables, work, first, end);
        templates_range(unit, tables, work, first, end);
        out = expand_root(unit, tables, work, r, out);
    }
    return out;
}

static int counter_open(uint64_t config)
{
    struct perf_event_attr attr;
    memset(&attr, 0, sizeof(attr));
    attr.type = PERF_TYPE_HARDWARE;
    attr.size = sizeof(attr);
    attr.config = config;
    attr.exclude_kernel = 1;
    attr.exclude_hv = 1;
    return (int)syscall(SYS_perf_event_open, &attr, 0, -1, -1, 0);
}

static uint64_t counter_read(int fd)
{
    uint64_t value = 0;
    if (fd < 0 || read(fd, &value, sizeof(value)) != sizeof(value))
    {
        value = 0;
    }
    return value;
}

typedef struct Clock Clock;
struct Clock
{
    uint64_t ticks;
    uint64_t cycles;
    uint64_t instructions;
    uint64_t mispredicted;
};

// The three counters, opened once: user cycles, instructions and mispredicted branches.
static int clock_counters[3] = { -1, -1, -1 };

static Clock clock_now(void)
{
    Clock now = {
        .cycles = counter_read(clock_counters[0]),
        .instructions = counter_read(clock_counters[1]),
        .mispredicted = counter_read(clock_counters[2]),
        .ticks = __rdtsc(),
    };
    return now;
}

static int compare_u64(const void* a, const void* b)
{
    const uint64_t x = *(const uint64_t*)a;
    const uint64_t y = *(const uint64_t*)b;
    return x < y ? -1 : x > y;
}

// The taken roots' emitted entries against the stream's own: the roots and the entries that differ.
static void verify(const Unit* unit, uint64_t emitted, uint64_t* wrong_roots, uint64_t* wrong_entries)
{
    *wrong_roots = 0;
    *wrong_entries = 0;
    for (uint32_t r = 0; r < unit->root_count; r += 1)
    {
        const uint64_t out = unit->root_out[r];
        const uint64_t next = r + 1 < unit->root_count ? unit->root_out[r + 1] : emitted;
        uint64_t wrong = 0;
        if (unit->root_taken[r])
        {
            const uint64_t low = unit->root_low[r];
            const uint32_t length = unit->root_entries[r];
            for (uint32_t e = 0; e < length; e += 1)
            {
                const bool differs = unit->out_kinds[out + e] != unit->kinds[low + e] || unit->out_classes[out + e] != unit->classes[low + e] ||
                                     unit->out_values[out + e] != unit->values[low + e];
                if (differs && *wrong_entries + wrong < 4)
                {
                    printf("wrong-entry\texpression=%u\tentry=%u of %u\temitted kind %u class %u value %llu\tthe stream's kind %u class %u value %llu\n", r, e, length,
                           unit->out_kinds[out + e], unit->out_classes[out + e], (unsigned long long)unit->out_values[out + e], unit->kinds[low + e], unit->classes[low + e],
                           (unsigned long long)unit->values[low + e]);
                }
                wrong += differs;
            }
            wrong += next - out != length;
        }
        else
        {
            wrong += next != out;
        }
        *wrong_roots += wrong != 0;
        *wrong_entries += wrong;
    }
}

int main(int argc, char** argv)
{
    const char* path = NULL;
    const char* train = NULL;
    uint32_t passes = 9;
    bool list_ops = false;
    for (int i = 1; i < argc; i += 1)
    {
        if (strcmp(argv[i], "--train") == 0 && i + 1 < argc)
        {
            train = argv[++i];
        }
        else if (strcmp(argv[i], "--passes") == 0 && i + 1 < argc)
        {
            passes = (uint32_t)strtoul(argv[++i], NULL, 10);
        }
        else if (strcmp(argv[i], "--ops") == 0)
        {
            list_ops = true;
        }
        else
        {
            path = argv[i];
        }
    }
    if (path == NULL || passes < 2 || passes > 999)
    {
        fprintf(stderr, "usage: sweeps DUMP [--train DUMP] [--passes N] [--ops]\n");
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
    static Unit trained;
    unit_read(&unit, path);
    if (train != NULL)
    {
        unit_read(&trained, train);
    }
    static Tables tables;
    tables_learn(&tables, train != NULL ? &trained : &unit);

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
    // T, C, the templates' choice, the expansion; and the four an expression at a time.
    enum { PARTS = 5 };
    uint64_t (*samples)[PARTS][4] = must(calloc(passes, sizeof(*samples)));
    uint64_t emitted = 0;
    uint64_t wrong_roots_unit = 0;
    uint64_t wrong_entries_unit = 0;
    for (uint32_t pass = 0; pass < passes; pass += 1)
    {
        Clock marks[PARTS];
        marks[0] = clock_now();
        sweep_types(&unit, &tables, &work);
        marks[1] = clock_now();
        sweep_contexts(&unit, &tables, &work);
        marks[2] = clock_now();
        sweep_templates(&unit, &tables, &work);
        marks[3] = clock_now();
        emitted = sweep_expand(&unit, &tables, &work);
        marks[4] = clock_now();
        for (uint32_t s = 0; s < 4; s += 1)
        {
            samples[pass][s][0] = marks[s + 1].ticks - marks[s].ticks;
            samples[pass][s][1] = marks[s + 1].cycles - marks[s].cycles;
            samples[pass][s][2] = marks[s + 1].instructions - marks[s].instructions;
            samples[pass][s][3] = marks[s + 1].mispredicted - marks[s].mispredicted;
        }
    }
    verify(&unit, emitted, &wrong_roots_unit, &wrong_entries_unit);
    // The sweeps' state is cleared between the two orders, so that the second owes the first nothing.
    memset(unit.facts, 0, n * 8);
    memset(unit.code, 0, n * 8);
    memset(unit.context, 0, n);
    memset(unit.target, 0, n * 2);
    memset(unit.out_kinds, 0, unit.entry_count);
    memset(unit.out_classes, 0, unit.entry_count);
    memset(unit.out_values, 0, unit.entry_count * 8);
    const uint64_t emitted_unit = emitted;
    for (uint32_t pass = 0; pass < passes; pass += 1)
    {
        const Clock before = clock_now();
        emitted = sweep_expressions(&unit, &tables, &work);
        const Clock after = clock_now();
        samples[pass][4][0] = after.ticks - before.ticks;
        samples[pass][4][1] = after.cycles - before.cycles;
        samples[pass][4][2] = after.instructions - before.instructions;
        samples[pass][4][3] = after.mispredicted - before.mispredicted;
    }
    uint64_t wrong_roots = 0;
    uint64_t wrong_entries = 0;
    verify(&unit, emitted, &wrong_roots, &wrong_entries);

    // What the tables decided, against the truth; and why each root that was not taken was not.
    uint64_t key_mismatches[KEY_BYTES] = { 0 };
    uint64_t key_wrong = 0;
    uint64_t facts_wrong = 0;
    uint64_t context_wrong = 0;
    static uint64_t wrong_by_op[OPS][2];
    uint64_t leaves = 0;
    uint64_t table_nodes = 0;
    uint64_t given_nodes = 0;
    uint64_t operand_slots = 0;
    uint64_t operand_slots_given = 0;
    uint64_t early_nodes = 0;
    uint64_t operand_slots_missed = 0;
    uint64_t misses[3] = { 0 };
    for (uint32_t g = 0; g < unit.count; g += 1)
    {
        uint8_t key[KEY_BYTES];
        expand_key_bytes(&unit, unit.facts, unit.context, unit.target, g, key);
        bool wrong = false;
        for (uint32_t b = 0; b < KEY_BYTES; b += 1)
        {
            const bool differs = key[b] != unit.key_truth[g][b];
            key_mismatches[b] += differs;
            wrong = wrong || differs;
        }
        const uint8_t op = unit.op[g] < OPS ? unit.op[g] : 0;
        key_wrong += wrong;
        facts_wrong += unit.facts[g] != unit.facts_truth[g];
        wrong_by_op[op][0] += unit.facts[g] != unit.facts_truth[g];
        const bool context_differs = unit.context[g] != unit.context_truth[g] || unit.target[g] != unit.target_truth[g];
        context_wrong += context_differs;
        wrong_by_op[unit.parent[g] != NONE && unit.op[unit.parent[g]] < OPS ? unit.op[unit.parent[g]] : 0][1] += context_differs;
        leaves += unit.operand_count[g] == 0;
        table_nodes += unit.by_table[g];
        given_nodes += unit.operand_count[g] != 0 && !unit.by_table[g];
        uint32_t index = 0;
        for (uint32_t c = unit.first_child[g]; c != NONE; c = unit.next_sibling[c])
        {
            uint64_t answer;
            operand_slots += 1;
            operand_slots_given += operands_given[unit.op[g]];
            operand_slots_missed += !operands_given[unit.op[g]] && !table_find(&tables.context, context_key(&unit, unit.code, unit.context, g, index, c), &answer);
            index += 1;
        }
        early_nodes += unit.templates[unit.template_truth[g]].early;
        misses[0] += (work.missed[g] & MISSED_TYPE) != 0;
        misses[1] += (work.missed[g] & MISSED_CONTEXT) != 0;
        misses[2] += (work.missed[g] & MISSED_TEMPLATE) != 0;
    }
    enum { REASONS = 7 };
    static const char* const reason_names[REASONS] = {
        "a node the tasks popped again",
        "an entry where a template has no run (inside an operand's entries, or between operands past the third)",
        "a node of more than 16 entries, or of a run of more than 8",
        "entries of a control or a token among the tree's",
        "a type key in conflict or unknown",
        "a context key in conflict or unknown",
        "a template key in conflict or unknown",
    };
    uint64_t reason_roots[REASONS] = { 0 };
    uint64_t reason_nodes[REASONS] = { 0 };
    static uint64_t reason_ops[REASONS][OPS];
    uint64_t taken_roots = 0;
    uint64_t taken_nodes = 0;
    uint64_t taken_entries = 0;
    uint64_t taken_early_roots = 0;
    uint64_t taken_early_nodes = 0;
    uint64_t refused = 0;
    uint64_t exact_roots = 0;
    for (uint32_t r = 0; r < unit.root_count; r += 1)
    {
        const uint32_t size = unit.roots[r] - unit.root_first[r] + 1;
        exact_roots += unit.root_exact[r];
        if (unit.root_taken[r])
        {
            taken_roots += 1;
            taken_nodes += size;
            taken_entries += unit.root_entries[r];
            bool early = false;
            for (uint32_t g = unit.root_first[r]; g <= unit.roots[r]; g += 1)
            {
                early = early || work.early[g];
            }
            taken_early_roots += early;
            taken_early_nodes += early ? size : 0;
        }
        else
        {
            // The first reason in the list's order, and the operator of the first node that has it.
            uint32_t reason = REASONS;
            uint32_t offender = unit.roots[r];
            for (uint32_t candidate = 0; candidate < REASONS && reason == REASONS; candidate += 1)
            {
                if (candidate == 3 && !unit.root_exact[r])
                {
                    reason = candidate;
                }
                for (uint32_t g = unit.root_first[r]; g <= unit.roots[r] && reason == REASONS; g += 1)
                {
                    const bool has = candidate == 0 ? (unit.refused[g] & REFUSED_AGAIN) != 0 :
                                     candidate == 1 ? (unit.refused[g] & REFUSED_PLACE) != 0 :
                                     candidate == 2 ? (unit.refused[g] & REFUSED_LONG) != 0 :
                                     candidate == 4 ? (work.missed[g] & MISSED_TYPE) != 0 :
                                     candidate == 5 ? (work.missed[g] & MISSED_CONTEXT) != 0 :
                                     candidate == 6 ? (work.missed[g] & MISSED_TEMPLATE) != 0 : false;
                    if (has)
                    {
                        reason = candidate;
                        offender = g;
                    }
                }
            }
            if (reason < REASONS)
            {
                reason_roots[reason] += 1;
                reason_nodes[reason] += size;
                reason_ops[reason][unit.op[offender] < OPS ? unit.op[offender] : 0] += 1;
            }
        }
    }
    for (uint32_t g = 0; g < unit.count; g += 1)
    {
        refused += unit.refused[g] != 0;
    }
    printf("sweeps: %s%s%s\n", path, train != NULL ? " with the tables of " : "", train != NULL ? train : "");
    printf("unit\tbodies=%u\tnodes=%u\tfull-expressions=%u\tentries=%llu\tentries-of-the-nodes=%llu\ttemplates=%u\n", unit.bodies, unit.count, unit.root_count,
           (unsigned long long)unit.entry_count, (unsigned long long)unit.owned, unit.template_count);
    printf("structure\tnodes-no-template-holds=%llu\texpressions-whose-entries-are-their-nodes'-alone=%llu of %u\tnodes-that-write-before-or-between-their-operands=%llu\n",
           (unsigned long long)refused, (unsigned long long)exact_roots, unit.root_count, (unsigned long long)early_nodes);
    printf("T\tleaves=%llu\tnodes-typed-by-the-table=%llu\tnodes-whose-facts-a-lookup-gives=%llu\tkeys=%llu\tkeys-of-one-node=%llu\tconflicting-keys=%llu\tslots=%llu\tmisses=%llu\tfacts-differing-from-the-truth=%llu\n",
           (unsigned long long)leaves, (unsigned long long)table_nodes, (unsigned long long)given_nodes, (unsigned long long)tables.type.count,
           (unsigned long long)tables.type.singles, (unsigned long long)tables.type.conflicts, (unsigned long long)tables.type.mask + 1, (unsigned long long)misses[0],
           (unsigned long long)facts_wrong);
    printf("C\toperands=%llu\toperands-given=%llu\tkeys=%llu\tkeys-of-one-operand=%llu\tconflicting-keys=%llu\tslots=%llu\toperands-missed=%llu\tnodes-with-a-miss=%llu\tnodes-whose-context-or-target-differs=%llu\n",
           (unsigned long long)operand_slots, (unsigned long long)operand_slots_given, (unsigned long long)tables.context.count, (unsigned long long)tables.context.singles,
           (unsigned long long)tables.context.conflicts, (unsigned long long)tables.context.mask + 1, (unsigned long long)operand_slots_missed, (unsigned long long)misses[1],
           (unsigned long long)context_wrong);
    printf("X\tkeys=%llu\tkeys-of-one-node=%llu\tconflicting-keys=%llu\tslots=%llu\tmisses=%llu\ttemplates=%u\trebuilt-keys-differing-from-the-lowering's=%llu\n",
           (unsigned long long)tables.expand.count, (unsigned long long)tables.expand.singles, (unsigned long long)tables.expand.conflicts,
           (unsigned long long)tables.expand.mask + 1, (unsigned long long)misses[2], tables.template_count, (unsigned long long)key_wrong);
    for (uint32_t b = 0; b < KEY_BYTES; b += 1)
    {
        if (key_mismatches[b] != 0)
        {
            printf("X\tkey-byte=%u\tdiffering=%llu\n", b, (unsigned long long)key_mismatches[b]);
        }
    }
    for (uint32_t op = 0; op < OPS; op += 1)
    {
        if (wrong_by_op[op][0] != 0 || wrong_by_op[op][1] != 0)
        {
            printf("wrong\t%s\tfacts=%llu\toperands'-contexts=%llu\n", op_names[op], (unsigned long long)wrong_by_op[op][0], (unsigned long long)wrong_by_op[op][1]);
        }
    }
    printf("taken\texpressions=%llu of %u (%.2f%%)\tnodes=%llu of %u (%.2f%%)\tentries=%llu of %llu of the nodes' (%.2f%%)\tby-the-walk: expressions=%llu nodes=%llu\n",
           (unsigned long long)taken_roots, unit.root_count, 100.0 * (double)taken_roots / (double)unit.root_count, (unsigned long long)taken_nodes, unit.count,
           100.0 * (double)taken_nodes / (double)unit.count, (unsigned long long)taken_entries, (unsigned long long)unit.owned,
           100.0 * (double)taken_entries / (double)unit.owned, (unsigned long long)taken_early_roots, (unsigned long long)taken_early_nodes);
    printf("checked\ta unit at a time: emitted=%llu wrong-expressions=%llu wrong-entries=%llu\tan expression at a time: emitted=%llu wrong-expressions=%llu wrong-entries=%llu\n",
           (unsigned long long)emitted_unit, (unsigned long long)wrong_roots_unit, (unsigned long long)wrong_entries_unit, (unsigned long long)emitted,
           (unsigned long long)wrong_roots, (unsigned long long)wrong_entries);
    for (uint32_t reason = 0; reason < REASONS; reason += 1)
    {
        if (reason_roots[reason] != 0)
        {
            printf("refused\texpressions=%llu\tnodes=%llu (%.2f%%)\t%s; first such node's operator:", (unsigned long long)reason_roots[reason],
                   (unsigned long long)reason_nodes[reason], 100.0 * (double)reason_nodes[reason] / (double)unit.count, reason_names[reason]);
            for (uint32_t shown = 0; shown < 5; shown += 1)
            {
                uint32_t best = 0;
                for (uint32_t op = 1; op < OPS; op += 1)
                {
                    best = reason_ops[reason][op] > reason_ops[reason][best] ? op : best;
                }
                if (reason_ops[reason][best] != 0)
                {
                    printf(" %s %llu", op_names[best], (unsigned long long)reason_ops[reason][best]);
                    reason_ops[reason][best] = 0;
                }
            }
            printf("\n");
        }
    }
    // Each part's median over the passes but the first.
    static const char* const names[PARTS] = { "T", "C", "templates", "expand", "expression-at-a-time" };
    uint64_t* column = must(malloc(passes * 8));
    double medians[PARTS][4];
    for (uint32_t s = 0; s < PARTS; s += 1)
    {
        for (uint32_t m = 0; m < 4; m += 1)
        {
            uint32_t count = 0;
            for (uint32_t pass = 1; pass < passes; pass += 1)
            {
                column[count++] = samples[pass][s][m];
            }
            qsort(column, count, 8, compare_u64);
            medians[s][m] = (double)column[count / 2];
        }
    }
    const double all = (double)unit.count;
    const double taken = (double)taken_nodes;
    for (uint32_t s = 0; s < PARTS; s += 1)
    {
        printf("time\t%s\tper node of the unit: ticks %.1f cycles %.1f instructions %.1f mispredicted branches %.3f\tper taken node: ticks %.1f cycles %.1f instructions %.1f\tfirst pass, per node: cycles %.1f\n",
               names[s], medians[s][0] / all, medians[s][1] / all, medians[s][2] / all, medians[s][3] / all, medians[s][0] / taken, medians[s][1] / taken,
               medians[s][2] / taken, (double)samples[0][s][1] / all);
    }
    printf("time\tunit-at-a-time\tper node of the unit: ticks %.1f cycles %.1f instructions %.1f mispredicted branches %.3f\t(%u passes; the median of all but the first)\n",
           (medians[0][0] + medians[1][0] + medians[2][0] + medians[3][0]) / all, (medians[0][1] + medians[1][1] + medians[2][1] + medians[3][1]) / all,
           (medians[0][2] + medians[1][2] + medians[2][2] + medians[3][2]) / all, (medians[0][3] + medians[1][3] + medians[2][3] + medians[3][3]) / all, passes);
    printf("time\tper entry emitted, an expression at a time: ticks %.1f cycles %.1f instructions %.1f\n", medians[4][0] / (double)emitted, medians[4][1] / (double)emitted,
           medians[4][2] / (double)emitted);
    if (list_ops)
    {
        printf("op\toperator\tnodes-with-operands\tin-conflicting-type-keys\ttyped-by\tin-conflicting-context-keys\toperands'-contexts-by\n");
        for (uint32_t op = 0; op < OPS; op += 1)
        {
            if (tables.nodes[op] != 0)
            {
                printf("op\t%s\t%llu\t%llu\t%s\t%llu\t%s\n", op_names[op], (unsigned long long)tables.nodes[op], (unsigned long long)tables.type_conflicts[op],
                       facts_given[op] ? "a lookup" : "the table", (unsigned long long)tables.context_conflicts[op], operands_given[op] ? "the prototype" : "the table");
            }
        }
    }
    return wrong_roots != 0 || wrong_roots_unit != 0;
}
