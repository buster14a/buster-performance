// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// fit: the deferred reader's lane rule against a grid of forced lane counts (#447). Reads summarize's runs table (its
// default table, from bench.sh's logs) and takes, for each unit, the median over its rounds of the change of every
// forced count (`every:K` configurations: the reader on K lanes, or as many as its bodies, against one lane in the
// same process). Lane counts between two measured ones are interpolated linearly, as #683's campaign A2 did between 4
// and 8; one lane is 0 by definition.
//
// A rule gives a unit 1 + (excess - c) / (a + top / b) lanes where its excess, the bodies' tokens beyond the larger of
// the largest body's and twice the second largest's, is above c (one lane otherwise), and no more than 8 or its
// bodies: c_check_deferred.c's check_deferred_rule_of with BUSTER_CHECK_DEFERRED_LANE_TOKENS a and
// BUSTER_CHECK_DEFERRED_LANE_TOP_TOKENS b, and c a threshold the first extra lane must clear (main's rule: a 1024,
// b 4, c 0; b 0 here means no top-level term). For each rule of the grid it gives the worst unit's change against one
// lane, the units within one point of their best (the best of one lane and every measured count), the units more than
// one point slower than one lane, and the gains forgone summed over the units (each unit's change by the rule minus its
// best), over all units and over each named group (by the unit's prefix: cts/, sqlite, syn/, musl/).
//
//   fit [--top N] [--fit-groups PREFIX,...] [--units [--rule A B C|lane]] RUNS.tsv
//
// Each rule is also scored as the C driver applies it (check_input_deferred_compile with --deferred-bodies): a unit the
// rule gives fewer than 4 lanes (BUSTER_CHECK_DEFERRED_COMPILE_LANES) reads in source order, whose change against one
// lane is the median over all the unit's processes; `driver forgone` sums each unit's distance from the best of source
// order, one lane and every measured count.
//
// --fit-groups ranks the rules on those groups' units alone and reports the others as held out. --top N prints the N
// best rules by gains forgone among those whose worst unit is at most +1.0% (then all of them, by worst unit), and
// main's rule, and each rule's lanes per unit with --units.
//
// Original project work, no imported code. Build: clang -std=gnu17 -O2 -Wall -Wextra -Werror fit.c -o fit

#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define FIT_MAX_UNITS 512u
#define FIT_MAX_ROUNDS 64u
#define FIT_LANES 8u
#define FIT_LINE_BYTES 16384u
#define FIT_TEXT 256u

typedef struct Unit Unit;
struct Unit
{
    char name[FIT_TEXT];
    uint64_t bodies;
    uint64_t body_tokens;
    uint64_t largest;
    uint64_t second;
    uint64_t top;
    // Per lane count (index = lanes), the changes of its rounds, and their median.
    double samples[FIT_LANES + 1][FIT_MAX_ROUNDS];
    uint32_t counts[FIT_LANES + 1];
    double change[FIT_LANES + 1];
    bool measured[FIT_LANES + 1];
    double best;
    double source_samples[FIT_MAX_ROUNDS * 8];
    uint32_t source_count;
    double source;
    double best_all;
    bool held_out;
};

static Unit units[FIT_MAX_UNITS];
static uint32_t unit_count;

static int compare_double(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

// The tab-separated field `index` of `line` (0-based), copied into `out`.
static void column(const char* line, uint32_t index, char* out, uint64_t capacity)
{
    const char* at = line;
    for (uint32_t i = 0; i < index && at != 0; i += 1)
    {
        at = strchr(at, '\t');
        at = at != 0 ? at + 1 : 0;
    }
    uint64_t length = 0;
    while (at != 0 && at[length] != 0 && at[length] != '\t' && at[length] != '\n' && length + 1 < capacity)
    {
        length += 1;
    }
    if (at != 0)
    {
        memcpy(out, at, length);
    }
    out[length] = 0;
}

// The index of the column named `name` in the header line, or UINT32_MAX.
static uint32_t header_index(const char* header, const char* name)
{
    uint32_t result = UINT32_MAX;
    char field[FIT_TEXT];
    for (uint32_t i = 0; i < 64 && result == UINT32_MAX; i += 1)
    {
        column(header, i, field, sizeof(field));
        result = strcmp(field, name) == 0 ? i : result;
    }
    return result;
}

static Unit* unit_named(const char* name)
{
    Unit* result = 0;
    for (uint32_t i = 0; i < unit_count && result == 0; i += 1)
    {
        result = strcmp(units[i].name, name) == 0 ? units + i : 0;
    }
    if (result == 0 && unit_count < FIT_MAX_UNITS)
    {
        result = units + unit_count;
        unit_count += 1;
        snprintf(result->name, sizeof(result->name), "%s", name);
    }
    return result;
}

static bool read_runs(const char* path)
{
    FILE* file = fopen(path, "r");
    static char line[FIT_LINE_BYTES];
    static char header[FIT_LINE_BYTES];
    bool valid = file != 0 && fgets(header, sizeof(header), file) != 0;
    const char* names[] = { "unit", "config", "status", "bodies", "body_tokens", "largest_body", "second_body", "top_tokens", "active", "n_vs_1_pct",
                            "source_order_ns", "deferred_1_ns" };
    uint32_t at[12];
    for (uint32_t i = 0; valid && i < 12; i += 1)
    {
        at[i] = header_index(header, names[i]);
        valid = at[i] != UINT32_MAX;
    }
    while (valid && fgets(line, sizeof(line), file) != 0)
    {
        char field[12][FIT_TEXT];
        for (uint32_t i = 0; i < 12; i += 1)
        {
            column(line, at[i], field[i], FIT_TEXT);
        }
        const bool forced = strncmp(field[1], "every:", 6) == 0;
        const double source = strtod(field[10], 0);
        const double one = strtod(field[11], 0);
        if (strcmp(field[2], "ok") == 0 && one > 0.0 && strncmp(field[1], "rss", 3) != 0)
        {
            Unit* unit = unit_named(field[0]);
            if (unit != 0 && unit->source_count < FIT_MAX_ROUNDS * 8)
            {
                unit->source_samples[unit->source_count] = (source / one - 1.0) * 100.0;
                unit->source_count += 1;
            }
        }
        if (forced && strcmp(field[2], "ok") == 0)
        {
            Unit* unit = unit_named(field[0]);
            const uint64_t active = strtoull(field[8], 0, 10);
            valid = unit != 0 && active >= 1 && active <= FIT_LANES;
            if (valid)
            {
                unit->bodies = strtoull(field[3], 0, 10);
                unit->body_tokens = strtoull(field[4], 0, 10);
                unit->largest = strtoull(field[5], 0, 10);
                unit->second = strtoull(field[6], 0, 10);
                unit->top = strtoull(field[7], 0, 10);
                if (unit->counts[active] < FIT_MAX_ROUNDS)
                {
                    unit->samples[active][unit->counts[active]] = strtod(field[9], 0);
                    unit->counts[active] += 1;
                }
            }
        }
    }
    if (file != 0)
    {
        fclose(file);
    }
    return valid;
}

// Each unit's median change per measured lane count, the interpolated ones between them, and its best.
static void prepare(void)
{
    for (uint32_t u = 0; u < unit_count; u += 1)
    {
        Unit* unit = units + u;
        unit->change[1] = 0.0;
        unit->measured[1] = true;
        for (uint32_t l = 2; l <= FIT_LANES; l += 1)
        {
            if (unit->counts[l] != 0)
            {
                qsort(unit->samples[l], unit->counts[l], sizeof(double), compare_double);
                unit->change[l] = unit->samples[l][(unit->counts[l] - 1) / 2];
                unit->measured[l] = true;
            }
        }
        // Between two measured counts, linearly.
        for (uint32_t l = 2; l <= FIT_LANES; l += 1)
        {
            if (!unit->measured[l])
            {
                uint32_t below = l - 1;
                while (below > 1 && !unit->measured[below])
                {
                    below -= 1;
                }
                uint32_t above = l + 1;
                while (above <= FIT_LANES && !unit->measured[above])
                {
                    above += 1;
                }
                const bool bracketed = above <= FIT_LANES;
                unit->change[l] = bracketed ? unit->change[below] + (unit->change[above] - unit->change[below]) * (double)(l - below) / (double)(above - below) :
                                              unit->change[below];
            }
        }
        unit->best = 0.0;
        for (uint32_t l = 2; l <= FIT_LANES; l += 1)
        {
            unit->best = unit->measured[l] && unit->change[l] < unit->best ? unit->change[l] : unit->best;
        }
        qsort(unit->source_samples, unit->source_count, sizeof(double), compare_double);
        unit->source = unit->source_count != 0 ? unit->source_samples[(unit->source_count - 1) / 2] : 0.0;
        unit->best_all = unit->source < unit->best ? unit->source : unit->best;
    }
}

typedef struct Rule Rule;
struct Rule
{
    uint64_t a;
    uint64_t b;
    uint64_t c;
};

static uint32_t rule_lanes(const Rule* rule, const Unit* unit)
{
    const uint64_t second = unit->second * 2;
    const uint64_t path = unit->largest > second ? unit->largest : second;
    const uint64_t excess = unit->body_tokens > path ? unit->body_tokens - path : 0;
    const uint64_t lane_tokens = rule->a + (rule->b != 0 ? unit->top / rule->b : 0);
    // c UINT64_MAX: the threshold is the lane's own tokens, so that the rule is max(1, excess / lane_tokens).
    const uint64_t threshold = rule->c == UINT64_MAX ? lane_tokens : rule->c;
    const uint64_t paid = excess > threshold ? 1 + (excess - threshold) / lane_tokens : 1;
    const uint64_t most = unit->bodies < FIT_LANES ? unit->bodies : FIT_LANES;
    return (uint32_t)(paid < most ? paid : most);
}

typedef struct Score Score;
struct Score
{
    double worst;
    double forgone;
    uint32_t within;
    uint32_t slower;
    uint32_t units;
    double driver_forgone;
    uint32_t driver_deferred;
};

// The rule's score on the units that are (held_out true) or aren't held out.
static Score score(const Rule* rule, bool held_out)
{
    Score result = { .worst = -1e9 };
    for (uint32_t u = 0; u < unit_count; u += 1)
    {
        const Unit* unit = units + u;
        if (unit->held_out == held_out)
        {
            const double change = unit->change[rule_lanes(rule, unit)];
            result.worst = change > result.worst ? change : result.worst;
            result.forgone += change - unit->best;
            result.within += change - unit->best <= 1.0;
            result.slower += change > 1.0;
            result.units += 1;
            const uint32_t lanes = rule_lanes(rule, unit);
            const double driver = lanes < 4 ? unit->source : change;
            result.driver_forgone += driver - unit->best_all;
            result.driver_deferred += lanes >= 4;
        }
    }
    return result;
}

static void print_rule(const Rule* rule, bool any_held_out)
{
    const Score fitted = score(rule, false);
    char threshold[32];
    snprintf(threshold, sizeof(threshold), rule->c == UINT64_MAX ? "lane" : "%" PRIu64, rule->c);
    printf("a=%-6" PRIu64 " b=%-3" PRIu64 " c=%-6s worst=%+6.2f%% within=%3u/%-3u slower=%-3u forgone=%7.2f driver: deferred=%-3u forgone=%7.2f", rule->a,
           rule->b, threshold, fitted.worst, fitted.within, fitted.units, fitted.slower, fitted.forgone, fitted.driver_deferred, fitted.driver_forgone);
    if (any_held_out)
    {
        const Score held = score(rule, true);
        printf("  held out: worst=%+6.2f%% within=%3u/%-3u slower=%-3u forgone=%7.2f", held.worst, held.within, held.units, held.slower, held.forgone);
    }
    printf("\n");
}

static void print_units(const Rule* rule)
{
    printf("  %-34s %6s %7s %6s %6s %7s  %5s %7s  %s\n", "unit", "bodies", "tokens", "large", "second", "top", "lanes", "change", "changes on 2..8 (interpolated in brackets), best");
    for (uint32_t u = 0; u < unit_count; u += 1)
    {
        const Unit* unit = units + u;
        const uint32_t lanes = rule_lanes(rule, unit);
        printf("  %-34s %6" PRIu64 " %7" PRIu64 " %6" PRIu64 " %6" PRIu64 " %7" PRIu64 "  %5u %+7.2f ", unit->name, unit->bodies, unit->body_tokens, unit->largest,
               unit->second, unit->top, lanes, unit->change[lanes]);
        for (uint32_t l = 2; l <= FIT_LANES; l += 1)
        {
            printf(unit->measured[l] ? " %+6.2f" : " [%+5.1f]", unit->change[l]);
        }
        printf("  best %+6.2f source %+6.2f%s\n", unit->best, unit->source, unit->held_out ? " (held out)" : "");
    }
}

int main(int argc, char** argv)
{
    uint32_t top = 15;
    const char* groups = 0;
    const char* path = 0;
    bool show_units = false;
    Rule chosen = { 0, 0, 0 };
    bool have_chosen = false;
    bool valid = true;
    for (int i = 1; valid && i < argc; i += 1)
    {
        if (strcmp(argv[i], "--top") == 0 && i + 1 < argc)
        {
            top = (uint32_t)strtoul(argv[++i], 0, 10);
        }
        else if (strcmp(argv[i], "--fit-groups") == 0 && i + 1 < argc)
        {
            groups = argv[++i];
        }
        else if (strcmp(argv[i], "--units") == 0)
        {
            show_units = true;
        }
        else if (strcmp(argv[i], "--rule") == 0 && i + 3 < argc)
        {
            chosen = (Rule){ strtoull(argv[i + 1], 0, 10), strtoull(argv[i + 2], 0, 10), strcmp(argv[i + 3], "lane") == 0 ? UINT64_MAX : strtoull(argv[i + 3], 0, 10) };
            have_chosen = true;
            i += 3;
        }
        else
        {
            path = argv[i];
        }
    }
    valid = path != 0 && read_runs(path);
    if (!valid)
    {
        fprintf(stderr, "usage: fit [--top N] [--fit-groups PREFIX,...] [--units] RUNS.tsv\n");
    }
    bool any_held_out = false;
    if (valid)
    {
        prepare();
        for (uint32_t u = 0; groups != 0 && u < unit_count; u += 1)
        {
            bool in = false;
            char list[FIT_TEXT];
            snprintf(list, sizeof(list), "%s", groups);
            for (char* prefix = strtok(list, ","); prefix != 0; prefix = strtok(0, ","))
            {
                in |= strncmp(units[u].name, prefix, strlen(prefix)) == 0;
            }
            units[u].held_out = !in;
            any_held_out |= !in;
        }
        static const uint64_t as[] = { 256, 512, 768, 1024, 1536, 2048, 2560, 3072, 4096, 5120, 6144, 8192, 12288 };
        static const uint64_t bs[] = { 0, 1, 2, 3, 4, 6, 8, 16 };
        static const uint64_t cs[] = { 0, 512, 1024, 2048, 3072, 4096, 6144, 8192, 12288, 16384, UINT64_MAX };
        static Rule rules[sizeof(as) / sizeof(as[0]) * sizeof(bs) / sizeof(bs[0]) * sizeof(cs) / sizeof(cs[0])];
        static Score scores[sizeof(rules) / sizeof(rules[0])];
        uint32_t count = 0;
        for (uint32_t i = 0; i < sizeof(as) / sizeof(as[0]); i += 1)
        {
            for (uint32_t j = 0; j < sizeof(bs) / sizeof(bs[0]); j += 1)
            {
                for (uint32_t k = 0; k < sizeof(cs) / sizeof(cs[0]); k += 1)
                {
                    rules[count] = (Rule){ as[i], bs[j], cs[k] };
                    scores[count] = score(rules + count, false);
                    count += 1;
                }
            }
        }
        printf("units: %u (%s)\n", unit_count, groups != 0 ? groups : "all fitted");
        printf("main's rule:\n  ");
        const Rule main_rule = { 1024, 4, 0 };
        print_rule(&main_rule, any_held_out);
        // The best by gains forgone among the rules whose worst unit is at most +1.0%, then by worst unit.
        printf("best rules (worst unit at most +1.0%%, by gains forgone):\n");
        bool printed[sizeof(rules) / sizeof(rules[0])] = { false };
        for (uint32_t n = 0; n < top; n += 1)
        {
            uint32_t pick = UINT32_MAX;
            for (uint32_t r = 0; r < count; r += 1)
            {
                const bool eligible = !printed[r] && scores[r].worst <= 1.0;
                const bool better = pick == UINT32_MAX || scores[r].forgone < scores[pick].forgone - 1e-9 ||
                                    (scores[r].forgone <= scores[pick].forgone + 1e-9 && scores[r].worst < scores[pick].worst);
                pick = eligible && better ? r : pick;
            }
            if (pick != UINT32_MAX)
            {
                printed[pick] = true;
                printf("  ");
                print_rule(rules + pick, any_held_out);
            }
        }
        if (show_units)
        {
            printf("main's rule per unit:\n");
            print_units(&main_rule);
            uint32_t pick = UINT32_MAX;
            for (uint32_t r = 0; r < count; r += 1)
            {
                const bool better = pick == UINT32_MAX || scores[r].forgone < scores[pick].forgone - 1e-9 ||
                                    (scores[r].forgone <= scores[pick].forgone + 1e-9 && scores[r].worst < scores[pick].worst);
                pick = scores[r].worst <= 1.0 && better ? r : pick;
            }
            pick = have_chosen ? UINT32_MAX : pick;
            if (have_chosen)
            {
                printf("the chosen rule per unit:\n  ");
                print_rule(&chosen, any_held_out);
                print_units(&chosen);
            }
            if (pick != UINT32_MAX)
            {
                printf("the best rule per unit (a=%" PRIu64 " b=%" PRIu64 " c=%" PRIu64 "):\n", rules[pick].a, rules[pick].b, rules[pick].c);
                print_units(rules + pick);
            }
        }
    }
    return valid ? 0 : 1;
}
