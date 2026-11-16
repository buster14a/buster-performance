// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// parts.c: perf's samples by part of Tier 0's row (buster#2874's census, its items 1 and 3).
//
//   parts RULES CHAINS COLUMN... [--top N] [--list PART] [--functions] [--markdown]
//
// CHAINS is `llvm-symbolizer -a -p -i -s --no-demangle --obj=compiler` over every sampled address: an address's line,
// `0xADDRESS: FUNCTION at FILE:LINE:COLUMN`, then a line ` (inlined by) FUNCTION at ...` for each function it was
// inlined into, the outermost (the symbol) last. A Release compiler inlines Tier 0's passes into one function of 58 KB,
// so a symbol says nothing of the pass; the chain does.
//
// RULES gives the functions that name a part, a line each: CLASS|PART|SUBPART|PATTERN. PATTERN is a function's name, or
// a prefix ending in `*`; a name's `.buster_split` (the alias the build's parallel parts name a function by) and `.cold`
// are dropped first. CLASS is `part` for one of the issue's parts, `rest` for what else is in the row, `out` for a
// family a compile runs outside the row (the lowering, the stream's validation), `far` for the rest of the compile, and
// anything else (`libc`) a class of its own. A sample's part is its innermost function with a rule that isn't `far` (so
// that a helper inlined into a pass is the pass's, a pass inlined into its driver is its own, and the lowering inlined
// into the emission's driver is the lowering's); without one, its innermost function with a `far` rule (so that a front
// end's helper inlined into the row's code stays the row's); without one, it is unmatched and listed. An exact name is
// taken before a prefix, and a longer prefix before a shorter.
// A PATTERN that starts with `^` is a symbol's alone: it names a part only where the function is the chain's outermost, so
// that a helper compiled out of line has a part without taking its callers' samples where it is inlined. `#` starts a
// comment.
//
// A COLUMN is NAME=IPS[-IPS][:DIVISOR]: brips's file (ADDRESS WAY PERIODS SAMPLES), less a second one's where given
// (the same runs without the timed passes: what is left is the passes'), divided by DIVISOR (runs times entries, for
// counts an entry). The report has a line a part and a sub-part with each column's count, then the row's total and the
// share of it in the issue's parts, then the unmatched samples by symbol. --list PART prints that part's samples by
// chain; --functions a line a (part, innermost function); --markdown the parts and their sub-parts as a table's rows, the
// row's parts first with each part's total, two decimals a count.
#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define PARTS_COLUMNS_MOST 12
#define PARTS_RULES_MOST 1024
#define PARTS_GROUPS_MOST 256
#define PARTS_FRAMES_MOST 48
#define PARTS_LINE_MOST 8192

typedef struct PartsRule PartsRule;
struct PartsRule
{
    char pattern[96];
    uint32_t length;
    bool prefix;
    // The rule is for a chain's outermost function alone (`^`).
    bool symbol;
    uint32_t group;
};

// A (class, part, sub-part).
typedef struct PartsGroup PartsGroup;
struct PartsGroup
{
    char class[8];
    char part[64];
    char subpart[96];
    double values[PARTS_COLUMNS_MOST];
};

typedef struct PartsAddress PartsAddress;
struct PartsAddress
{
    uint64_t address;
    uint32_t first;
    uint32_t count;
    bool used;
};

typedef struct PartsTally PartsTally;
struct PartsTally
{
    char* key;
    double values[PARTS_COLUMNS_MOST];
};

static PartsRule parts_rules[PARTS_RULES_MOST];
static uint32_t parts_rule_count;
static PartsGroup parts_groups[PARTS_GROUPS_MOST];
static uint32_t parts_group_count;
static char** parts_names;
static uint32_t parts_name_count;
static uint32_t parts_name_capacity;
static uint32_t* parts_frames;
static uint64_t parts_frame_count;
static uint64_t parts_frame_capacity;
static PartsAddress* parts_addresses;
static uint64_t parts_address_capacity;
static uint64_t parts_address_count;
static PartsTally* parts_tallies;
static uint32_t parts_tally_count;
static uint32_t parts_tally_capacity;

static void* parts_must(void* pointer)
{
    if (pointer == NULL)
    {
        fprintf(stderr, "parts: no memory\n");
        exit(1);
    }
    return pointer;
}

// A function's name without the build's suffixes.
static void parts_clean(char* name)
{
    static const char* const suffixes[] = { ".buster_split", ".cold" };
    for (uint32_t s = 0; s < sizeof(suffixes) / sizeof(suffixes[0]); s += 1)
    {
        char* found = strstr(name, suffixes[s]);
        if (found != NULL)
        {
            *found = 0;
        }
    }
}

static uint32_t parts_intern(const char* name)
{
    // The names are a few thousand: a linear search from the newest is enough, since a chain repeats its neighbours'.
    uint32_t found = UINT32_MAX;
    for (uint32_t i = parts_name_count; i > 0 && found == UINT32_MAX; i -= 1)
    {
        found = strcmp(parts_names[i - 1], name) == 0 ? i - 1 : found;
    }
    if (found == UINT32_MAX)
    {
        if (parts_name_count == parts_name_capacity)
        {
            parts_name_capacity = parts_name_capacity == 0 ? 4096 : parts_name_capacity * 2;
            parts_names = parts_must(realloc(parts_names, parts_name_capacity * sizeof(char*)));
        }
        parts_names[parts_name_count] = parts_must(strdup(name));
        found = parts_name_count++;
    }
    return found;
}

static uint64_t parts_hash(uint64_t address)
{
    const uint64_t h = address * UINT64_C(0x9e3779b97f4a7c15);
    return h ^ (h >> 31);
}

static PartsAddress* parts_address(uint64_t address, bool add)
{
    if (add && (parts_address_count + 1) * 2 > parts_address_capacity)
    {
        PartsAddress* old = parts_addresses;
        const uint64_t old_capacity = parts_address_capacity;
        parts_address_capacity = old_capacity == 0 ? 1u << 16 : old_capacity * 2;
        parts_addresses = parts_must(calloc(parts_address_capacity, sizeof(PartsAddress)));
        for (uint64_t i = 0; i < old_capacity; i += 1)
        {
            if (old[i].used)
            {
                uint64_t at = parts_hash(old[i].address) & (parts_address_capacity - 1);
                while (parts_addresses[at].used)
                {
                    at = (at + 1) & (parts_address_capacity - 1);
                }
                parts_addresses[at] = old[i];
            }
        }
        free(old);
    }
    PartsAddress* result = NULL;
    if (parts_address_capacity != 0)
    {
        uint64_t at = parts_hash(address) & (parts_address_capacity - 1);
        while (parts_addresses[at].used && parts_addresses[at].address != address)
        {
            at = (at + 1) & (parts_address_capacity - 1);
        }
        if (parts_addresses[at].used)
        {
            result = &parts_addresses[at];
        }
        else if (add)
        {
            parts_addresses[at].used = true;
            parts_addresses[at].address = address;
            parts_addresses[at].first = (uint32_t)parts_frame_count;
            parts_addresses[at].count = 0;
            parts_address_count += 1;
            result = &parts_addresses[at];
        }
    }
    return result;
}

static void parts_push_frame(PartsAddress* address, uint32_t name)
{
    if (parts_frame_count == parts_frame_capacity)
    {
        parts_frame_capacity = parts_frame_capacity == 0 ? 1u << 16 : parts_frame_capacity * 2;
        parts_frames = parts_must(realloc(parts_frames, parts_frame_capacity * sizeof(uint32_t)));
    }
    parts_frames[parts_frame_count++] = name;
    address->count += 1;
}

static uint32_t parts_group(const char* class, const char* part, const char* subpart)
{
    uint32_t found = UINT32_MAX;
    for (uint32_t g = 0; g < parts_group_count && found == UINT32_MAX; g += 1)
    {
        found = strcmp(parts_groups[g].class, class) == 0 && strcmp(parts_groups[g].part, part) == 0 && strcmp(parts_groups[g].subpart, subpart) == 0 ? g : found;
    }
    if (found == UINT32_MAX && parts_group_count < PARTS_GROUPS_MOST)
    {
        PartsGroup* group = &parts_groups[parts_group_count];
        snprintf(group->class, sizeof(group->class), "%s", class);
        snprintf(group->part, sizeof(group->part), "%s", part);
        snprintf(group->subpart, sizeof(group->subpart), "%s", subpart);
        found = parts_group_count++;
    }
    return found;
}

// The rule a name takes: an exact one, else its longest prefix; among the rules that aren't `far` (`near`), or the `far`
// ones.
static uint32_t parts_match(const char* name, bool near, bool outermost)
{
    uint32_t best = UINT32_MAX;
    uint32_t best_length = 0;
    bool exact = false;
    const uint32_t length = (uint32_t)strlen(name);
    for (uint32_t r = 0; r < parts_rule_count && !exact; r += 1)
    {
        const PartsRule* rule = &parts_rules[r];
        const bool rule_near = strcmp(parts_groups[rule->group].class, "far") != 0;
        if (rule_near == near && (!rule->symbol || outermost))
        {
            if (!rule->prefix && rule->length == length && memcmp(rule->pattern, name, length) == 0)
            {
                best = r;
                exact = true;
            }
            else if (rule->prefix && rule->length <= length && memcmp(rule->pattern, name, rule->length) == 0 && (best == UINT32_MAX || rule->length > best_length))
            {
                best = r;
                best_length = rule->length;
            }
        }
    }
    return best;
}

static void parts_tally(const char* key, uint32_t column, double value)
{
    uint32_t found = UINT32_MAX;
    for (uint32_t i = 0; i < parts_tally_count && found == UINT32_MAX; i += 1)
    {
        found = strcmp(parts_tallies[i].key, key) == 0 ? i : found;
    }
    if (found == UINT32_MAX)
    {
        if (parts_tally_count == parts_tally_capacity)
        {
            parts_tally_capacity = parts_tally_capacity == 0 ? 1024 : parts_tally_capacity * 2;
            parts_tallies = parts_must(realloc(parts_tallies, parts_tally_capacity * sizeof(PartsTally)));
        }
        memset(&parts_tallies[parts_tally_count], 0, sizeof(PartsTally));
        parts_tallies[parts_tally_count].key = parts_must(strdup(key));
        found = parts_tally_count++;
    }
    parts_tallies[found].values[column] += value;
}

static int parts_tally_compare(const void* a, const void* b)
{
    const PartsTally* x = a;
    const PartsTally* y = b;
    double sx = 0;
    double sy = 0;
    for (uint32_t c = 0; c < PARTS_COLUMNS_MOST; c += 1)
    {
        sx += x->values[c] < 0 ? -x->values[c] : x->values[c];
        sy += y->values[c] < 0 ? -y->values[c] : y->values[c];
    }
    return x->values[0] > y->values[0] ? -1 : x->values[0] < y->values[0] ? 1 : sx > sy ? -1 : sx < sy ? 1 : strcmp(x->key, y->key);
}

int main(int argc, char** argv)
{
    static char line[PARTS_LINE_MOST];
    const char* column_names[PARTS_COLUMNS_MOST];
    const char* column_files[PARTS_COLUMNS_MOST];
    const char* column_less[PARTS_COLUMNS_MOST];
    double divisors[PARTS_COLUMNS_MOST];
    uint32_t columns = 0;
    uint32_t top = 30;
    const char* list = NULL;
    bool functions = false;
    bool markdown = false;
    bool valid = argc >= 4;
    for (int i = 3; valid && i < argc; i += 1)
    {
        if (strcmp(argv[i], "--top") == 0 && i + 1 < argc)
        {
            top = (uint32_t)strtoul(argv[++i], NULL, 10);
        }
        else if (strcmp(argv[i], "--list") == 0 && i + 1 < argc)
        {
            list = argv[++i];
        }
        else if (strcmp(argv[i], "--functions") == 0)
        {
            functions = true;
        }
        else if (strcmp(argv[i], "--markdown") == 0)
        {
            markdown = true;
        }
        else
        {
            char* equals = strchr(argv[i], '=');
            valid = equals != NULL && columns < PARTS_COLUMNS_MOST;
            if (valid)
            {
                *equals = 0;
                column_names[columns] = argv[i];
                char* file = equals + 1;
                char* colon = strrchr(file, ':');
                divisors[columns] = 1;
                if (colon != NULL)
                {
                    *colon = 0;
                    divisors[columns] = strtod(colon + 1, NULL);
                }
                // A second file follows "-" only where the name before it ends in ".ips", so that a path's own hyphens stay.
                char* less = strstr(file, ".ips-");
                column_less[columns] = NULL;
                if (less != NULL)
                {
                    less[4] = 0;
                    column_less[columns] = less + 5;
                }
                column_files[columns] = file;
                valid = divisors[columns] > 0;
                columns += 1;
            }
        }
    }
    valid = valid && columns != 0;
    FILE* rules = valid ? fopen(argv[1], "r") : NULL;
    FILE* chains = valid ? fopen(argv[2], "r") : NULL;
    valid = valid && rules != NULL && chains != NULL;
    while (valid && fgets(line, sizeof(line), rules) != NULL)
    {
        char* hash = strchr(line, '#');
        if (hash != NULL)
        {
            *hash = 0;
        }
        char* fields[4] = { 0 };
        uint32_t count = 0;
        char* cursor = line;
        while (count < 4 && cursor != NULL)
        {
            fields[count++] = cursor;
            cursor = strchr(cursor, '|');
            if (cursor != NULL)
            {
                *cursor++ = 0;
            }
        }
        if (count == 4 && parts_rule_count < PARTS_RULES_MOST)
        {
            char* pattern = fields[3];
            pattern[strcspn(pattern, " \t\r\n")] = 0;
            PartsRule* rule = &parts_rules[parts_rule_count];
            rule->symbol = pattern[0] == '^';
            pattern += rule->symbol ? 1 : 0;
            rule->length = (uint32_t)strlen(pattern);
            rule->prefix = rule->length != 0 && pattern[rule->length - 1] == '*';
            rule->length -= rule->prefix ? 1 : 0;
            snprintf(rule->pattern, sizeof(rule->pattern), "%.*s", (int)rule->length, pattern);
            rule->group = parts_group(fields[0], fields[1], fields[2]);
            valid = rule->group != UINT32_MAX && rule->length != 0;
            parts_rule_count += 1;
        }
    }
    // The chains.
    PartsAddress* current = NULL;
    while (valid && fgets(line, sizeof(line), chains) != NULL)
    {
        char* name = NULL;
        if (line[0] == '0' && line[1] == 'x')
        {
            char* end = NULL;
            const uint64_t address = strtoull(line, &end, 16);
            current = parts_address(address, true);
            current->first = (uint32_t)parts_frame_count;
            current->count = 0;
            name = end != NULL && end[0] == ':' ? end + 2 : NULL;
        }
        else if (strncmp(line, " (inlined by) ", 14) == 0)
        {
            name = line + 14;
        }
        if (name != NULL && current != NULL)
        {
            char* at = strstr(name, " at ");
            if (at != NULL)
            {
                *at = 0;
            }
            name[strcspn(name, "\r\n")] = 0;
            parts_clean(name);
            parts_push_frame(current, parts_intern(name));
        }
    }
    // The groups the samples add: unmatched ones.
    const uint32_t unmatched = valid ? parts_group("?", "unmatched", "") : 0;
    double totals[PARTS_COLUMNS_MOST] = { 0 };
    double row_totals[PARTS_COLUMNS_MOST] = { 0 };
    double part_totals[PARTS_COLUMNS_MOST] = { 0 };
    double libc[PARTS_COLUMNS_MOST] = { 0 };
    double libc_lost[PARTS_COLUMNS_MOST] = { 0 };
    for (uint32_t c = 0; valid && c < columns; c += 1)
    {
        for (uint32_t side = 0; side < 2; side += 1)
        {
            const char* path = side == 0 ? column_files[c] : column_less[c];
            if (path == NULL)
            {
                continue;
            }
            FILE* file = fopen(path, "r");
            if (file == NULL)
            {
                fprintf(stderr, "parts: can't read %s\n", path);
                valid = false;
                continue;
            }
            uint64_t address = 0;
            uint64_t periods = 0;
            uint64_t samples = 0;
            unsigned way = 0;
            while (fscanf(file, "%" SCNx64 " %u %" SCNu64 " %" SCNu64, &address, &way, &periods, &samples) == 4)
            {
                const double value = (side == 0 ? 1.0 : -1.0) * (double)periods / divisors[c];
                const PartsAddress* known = parts_address(address, false);
                uint32_t group = unmatched;
                uint32_t inner = UINT32_MAX;
                char chain[PARTS_LINE_MOST];
                chain[0] = 0;
                if (known != NULL && known->count != 0)
                {
                    uint32_t rule = UINT32_MAX;
                    for (uint32_t pass = 0; pass < 2 && rule == UINT32_MAX; pass += 1)
                    {
                        for (uint32_t f = 0; f < known->count && rule == UINT32_MAX; f += 1)
                        {
                            rule = parts_match(parts_names[parts_frames[known->first + f]], pass == 0, f + 1 == known->count);
                            inner = rule != UINT32_MAX ? parts_frames[known->first + f] : inner;
                        }
                    }
                    group = rule != UINT32_MAX ? parts_rules[rule].group : unmatched;
                    uint32_t used = 0;
                    for (uint32_t f = 0; f < known->count && f < PARTS_FRAMES_MOST; f += 1)
                    {
                        used += (uint32_t)snprintf(chain + used, sizeof(chain) - used, "%s%s", f == 0 ? "" : " < ", parts_names[parts_frames[known->first + f]]);
                        used = used >= sizeof(chain) ? (uint32_t)sizeof(chain) - 1 : used;
                    }
                }
                else
                {
                    snprintf(chain, sizeof(chain), "(no chain for %" PRIx64 ")", address);
                }
                PartsGroup* target = &parts_groups[group];
                target->values[c] += value;
                totals[c] += value;
                const bool row = strcmp(target->class, "part") == 0 || strcmp(target->class, "rest") == 0;
                row_totals[c] += row ? value : 0;
                part_totals[c] += strcmp(target->class, "part") == 0 ? value : 0;
                libc[c] += row && way != 0 ? value : 0;
                libc_lost[c] += way == 2 ? value : 0;
                if (group == unmatched)
                {
                    // By symbol: the chain's outermost function.
                    const char* symbol = known != NULL && known->count != 0 ? parts_names[parts_frames[known->first + known->count - 1]] : chain;
                    parts_tally(symbol, c, value);
                }
                else if (list != NULL && strcmp(target->part, list) == 0)
                {
                    parts_tally(chain, c, value);
                }
                else if (functions && row)
                {
                    char key[256];
                    snprintf(key, sizeof(key), "%s | %s | %s", target->part, target->subpart, inner != UINT32_MAX ? parts_names[inner] : "?");
                    parts_tally(key, c, value);
                }
            }
            fclose(file);
        }
    }
    if (!valid)
    {
        fprintf(stderr, "usage: parts RULES CHAINS NAME=IPS[-IPS][:DIVISOR]... [--top N] [--list PART] [--functions] [--markdown]\n");
        return 1;
    }
    if (markdown)
    {
        // A part's line with its total, then its sub-parts'; the row's parts, its rest, then what is outside it.
        printf("| part |");
        for (uint32_t c = 0; c < columns; c += 1)
        {
            printf(" %s |", column_names[c]);
        }
        printf("\n| --- |");
        for (uint32_t c = 0; c < columns; c += 1)
        {
            printf(" ---: |");
        }
        printf("\n");
        for (uint32_t g = 0; g < parts_group_count; g += 1)
        {
            bool first = true;
            for (uint32_t h = 0; h < g && first; h += 1)
            {
                first = !(strcmp(parts_groups[h].class, parts_groups[g].class) == 0 && strcmp(parts_groups[h].part, parts_groups[g].part) == 0);
            }
            double sums[PARTS_COLUMNS_MOST] = { 0 };
            bool any = false;
            uint32_t members = 0;
            for (uint32_t h = g; first && h < parts_group_count; h += 1)
            {
                if (strcmp(parts_groups[h].class, parts_groups[g].class) == 0 && strcmp(parts_groups[h].part, parts_groups[g].part) == 0)
                {
                    bool member = false;
                    for (uint32_t c = 0; c < columns; c += 1)
                    {
                        sums[c] += parts_groups[h].values[c];
                        member = member || parts_groups[h].values[c] != 0;
                    }
                    any = any || member;
                    members += member ? 1 : 0;
                }
            }
            if (first && any)
            {
                printf("| **%s** |", parts_groups[g].part);
                for (uint32_t c = 0; c < columns; c += 1)
                {
                    printf(" **%.2f** |", sums[c]);
                }
                printf("\n");
                for (uint32_t h = g; members > 1 && h < parts_group_count; h += 1)
                {
                    const PartsGroup* group = &parts_groups[h];
                    bool member = false;
                    for (uint32_t c = 0; c < columns; c += 1)
                    {
                        member = member || group->values[c] != 0;
                    }
                    if (member && strcmp(group->class, parts_groups[g].class) == 0 && strcmp(group->part, parts_groups[g].part) == 0)
                    {
                        printf("| … %s |", group->subpart);
                        for (uint32_t c = 0; c < columns; c += 1)
                        {
                            printf(" %.2f |", group->values[c]);
                        }
                        printf("\n");
                    }
                }
            }
        }
        const char* const names[] = { "**the row**", "**the issue's eight parts**", "**their share of the row, %**", "**every sample**" };
        for (uint32_t s = 0; s < 4; s += 1)
        {
            printf("| %s |", names[s]);
            for (uint32_t c = 0; c < columns; c += 1)
            {
                const double value = s == 0 ? row_totals[c] : s == 1 ? part_totals[c] : s == 2 ? (row_totals[c] != 0 ? 100.0 * part_totals[c] / row_totals[c] : 0) : totals[c];
                printf(" **%.2f** |", value);
            }
            printf("\n");
        }
        return 0;
    }
    printf("%-6s %-34s %-44s", "class", "part", "sub-part");
    for (uint32_t c = 0; c < columns; c += 1)
    {
        printf(" %14s", column_names[c]);
    }
    printf("\n");
    for (uint32_t g = 0; g < parts_group_count; g += 1)
    {
        const PartsGroup* group = &parts_groups[g];
        bool any = false;
        for (uint32_t c = 0; c < columns; c += 1)
        {
            any = any || group->values[c] != 0;
        }
        if (any)
        {
            printf("%-6s %-34s %-44s", group->class, group->part, group->subpart);
            for (uint32_t c = 0; c < columns; c += 1)
            {
                printf(" %14.4f", group->values[c]);
            }
            printf("\n");
        }
    }
    // A part's total over its sub-parts.
    printf("\n%-6s %-34s %-44s", "class", "part", "(all its sub-parts)");
    for (uint32_t c = 0; c < columns; c += 1)
    {
        printf(" %14s", column_names[c]);
    }
    printf("\n");
    for (uint32_t g = 0; g < parts_group_count; g += 1)
    {
        bool first = true;
        for (uint32_t h = 0; h < g && first; h += 1)
        {
            first = !(strcmp(parts_groups[h].class, parts_groups[g].class) == 0 && strcmp(parts_groups[h].part, parts_groups[g].part) == 0);
        }
        if (first)
        {
            double sums[PARTS_COLUMNS_MOST] = { 0 };
            bool any = false;
            for (uint32_t h = g; h < parts_group_count; h += 1)
            {
                if (strcmp(parts_groups[h].class, parts_groups[g].class) == 0 && strcmp(parts_groups[h].part, parts_groups[g].part) == 0)
                {
                    for (uint32_t c = 0; c < columns; c += 1)
                    {
                        sums[c] += parts_groups[h].values[c];
                        any = any || parts_groups[h].values[c] != 0;
                    }
                }
            }
            if (any)
            {
                printf("%-6s %-34s %-44s", parts_groups[g].class, parts_groups[g].part, "");
                for (uint32_t c = 0; c < columns; c += 1)
                {
                    printf(" %14.4f", sums[c]);
                }
                printf("\n");
            }
        }
    }
    const char* const summary_names[] = { "every sample", "the row (part and rest)", "the row's parts", "the parts' share of the row, %", "the row's samples charged from libc", "libc samples with no caller in the stack" };
    for (uint32_t s = 0; s < 6; s += 1)
    {
        printf("%-86s", summary_names[s]);
        for (uint32_t c = 0; c < columns; c += 1)
        {
            const double value = s == 0 ? totals[c] : s == 1 ? row_totals[c] : s == 2 ? part_totals[c] : s == 3 ? (row_totals[c] != 0 ? 100.0 * part_totals[c] / row_totals[c] : 0) : s == 4 ? libc[c] : libc_lost[c];
            printf(" %14.4f", value);
        }
        printf("\n");
    }
    if (parts_tally_count != 0)
    {
        qsort(parts_tallies, parts_tally_count, sizeof(PartsTally), parts_tally_compare);
        printf("\n%s, the first %u of %u by %s:\n", list != NULL ? "the part's chains (and the unmatched samples' symbols)" : functions ? "the row's functions (and the unmatched samples' symbols)" : "unmatched samples by symbol", top, parts_tally_count, column_names[0]);
        for (uint32_t i = 0; i < parts_tally_count && i < top; i += 1)
        {
            for (uint32_t c = 0; c < columns; c += 1)
            {
                printf(" %14.4f", parts_tallies[i].values[c]);
            }
            printf("  %s\n", parts_tallies[i].key);
        }
    }
    return 0;
}
