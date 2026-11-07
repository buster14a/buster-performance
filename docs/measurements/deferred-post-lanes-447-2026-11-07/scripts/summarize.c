// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// summarize: reads bench.sh's logs of benchmark-checker-deferred (#447's campaign) and writes, as tab-separated
// tables on standard output:
//
//   runs     one row per process: round, unit, configuration, the unit's tokens and bodies, the lanes the reader ran
//            the bodies on and copied the reader on, the absolute medians (ns) of the parse, source order's reading,
//            the deferred reader on one lane and on the configuration's lanes, its change against one lane in the
//            same process and against source order (percent, from the unrounded nanoseconds), with --rss each
//            reading's peak and growth (KiB), and the one-lane and the configuration's readings' lanes' span, merge and
//            rest (the phases after the merge), in ns/token;
//   summary  one row per unit and configuration: the rounds, the lanes, and the median, lowest and highest over the
//            rounds of the change against one lane and of the absolute reading on the configuration's lanes;
//   choice   one row per unit: the rule's lanes and median change on 8 permitted lanes, every forced count's median
//            change (1 lane is 0 by definition), the best of them, and the rule's distance from the best in points,
//            beside the forced best's spread over its rounds. Where the rule takes one lane, its two deferred readings
//            are the same work, and its change is the noise of two such readings (`rule_one_lane` yes). Then source
//            order's reading against one lane (in the rule's processes) and the C driver's choice: with
//            --deferred-bodies, check_input_deferred_compile reads a unit whose bodies the rule gives fewer than
//            BUSTER_CHECK_DEFERRED_COMPILE_LANES (4) lanes in source order ("too few lanes"), and the rest by the
//            rule; its change against one lane, the best of every choice (source order, one lane, each forced count,
//            the rule), and the driver's distance from it in points.
//
//   pair     with --pair X,Y, one row per unit that has both configurations: their lanes, the medians over the rounds
//            of each one's change against one lane in its own process, the median, lowest and highest of their
//            difference (Y's minus X's, in points, per round), and each one's absolute median reading on its lanes.
//
//   summarize [--table runs|summary|choice|pair] [--pair X,Y] LOG...
//
// A process whose exit status isn't 0 or whose output lacks a line is counted and reported on standard error, never
// dropped silently: its row says so in `status`.
//
// Original project work, no imported code. Build: clang -std=gnu17 -O2 -Wall -Wextra -Werror summarize.c -o summarize

#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SUMMARIZE_MAX_RUNS 8192u
#define SUMMARIZE_MAX_TEXT 256u
#define SUMMARIZE_MAX_ROUNDS 64u
#define SUMMARIZE_LINE_BYTES 65536u

typedef struct Run Run;
struct Run
{
    uint32_t round;
    char unit[SUMMARIZE_MAX_TEXT];
    char config[SUMMARIZE_MAX_TEXT];
    uint64_t tokens;
    uint64_t bodies;
    uint64_t body_tokens;
    uint64_t largest_body;
    uint64_t second_body;
    uint64_t top_tokens;
    uint64_t lane_tokens;
    uint64_t active;
    uint64_t copies;
    uint64_t copy;
    uint64_t dispatch;
    uint64_t wake;
    // The ns/token phases of the one-lane reading [0] and the configuration's [1]: the lanes' span, the merge and the
    // rest (the phases after the merge).
    double span[2];
    double merge[2];
    double rest[2];
    uint64_t parse;
    uint64_t source_order;
    uint64_t deferred_one;
    uint64_t deferred_many;
    uint64_t passes;
    bool resident;
    uint64_t peak[3];
    uint64_t growth[3];
    bool header;
    bool lanes_line;
    bool absolute;
    int status;
    bool ended;
};

static Run runs[SUMMARIZE_MAX_RUNS];
static uint32_t run_count;

// The unsigned value after `key` (e.g. "tokens=") in `line`, or `fallback` if absent.
static uint64_t field(const char* line, const char* key, uint64_t fallback)
{
    const char* at = strstr(line, key);
    uint64_t result = fallback;
    if (at != 0)
    {
        result = strtoull(at + strlen(key), 0, 10);
    }
    return result;
}

static bool read_log(const char* path)
{
    FILE* file = fopen(path, "r");
    static char line[SUMMARIZE_LINE_BYTES];
    Run* run = 0;
    uint32_t lanes_lines = 0;
    bool valid = file != 0;
    while (valid && fgets(line, sizeof(line), file) != 0)
    {
        if (strncmp(line, "== round ", 9) == 0)
        {
            valid = run_count < SUMMARIZE_MAX_RUNS;
            run = valid ? runs + run_count : 0;
            run_count += valid;
            if (run != 0)
            {
                *run = (Run){ .status = -1 };
                char unit[SUMMARIZE_MAX_TEXT];
                char config[SUMMARIZE_MAX_TEXT];
                valid = sscanf(line, "== round %" SCNu32 " unit %255s config %255s", &run->round, unit, config) == 3;
                snprintf(run->unit, sizeof(run->unit), "%s", unit);
                snprintf(run->config, sizeof(run->config), "%s", config);
            }
            lanes_lines = 0;
        }
        else if (run != 0 && strncmp(line, "checker-deferred: file=", 23) == 0)
        {
            run->header = strstr(line, "merged=yes") != 0;
            run->tokens = field(line, " tokens=", 0);
            run->bodies = field(line, " bodies=", 0);
            run->body_tokens = field(line, " body_tokens=", 0);
            run->largest_body = field(line, " largest_body=", 0);
            run->second_body = field(line, " second_body=", 0);
            run->top_tokens = field(line, " top_tokens=", 0);
            run->lane_tokens = field(line, " lane_tokens=", 0);
        }
        else if (run != 0 && strncmp(line, "checker-deferred:   lanes=", 26) == 0 && strstr(line, " active=") != 0)
        {
            // The second such line is the reading on the configuration's lanes.
            lanes_lines += 1;
            if (lanes_lines <= 2)
            {
                const char* at = strstr(line, " lanes_span=");
                run->span[lanes_lines - 1] = at != 0 ? strtod(at + 12, 0) : 0.0;
                at = strstr(line, " merge=");
                run->merge[lanes_lines - 1] = at != 0 ? strtod(at + 7, 0) : 0.0;
                at = strstr(line, " rest=");
                run->rest[lanes_lines - 1] = at != 0 ? strtod(at + 6, 0) : 0.0;
            }
            if (lanes_lines == 2)
            {
                run->active = field(line, " active=", 0);
                run->copies = field(line, " copies=", 0);
                run->copy = field(line, " copy=", 0);
                run->dispatch = field(line, " dispatch=", 0);
                run->wake = field(line, " wake=", 0);
                run->lanes_line = true;
            }
        }
        else if (run != 0 && strncmp(line, "checker-deferred:   absolute:", 29) == 0)
        {
            run->parse = field(line, " parse=", 0);
            run->source_order = field(line, " source_order=", 0);
            run->deferred_one = field(line, " deferred_1=", 0);
            // The last deferred_N= on the line (deferred_1 when N is 1).
            const char* last = 0;
            for (const char* at = strstr(line, " deferred_"); at != 0; at = strstr(at + 1, " deferred_"))
            {
                last = at;
            }
            const char* equals = last != 0 ? strchr(last, '=') : 0;
            run->deferred_many = equals != 0 ? strtoull(equals + 1, 0, 10) : 0;
            run->passes = field(line, "medians of ", 0);
            run->absolute = run->source_order != 0 && run->deferred_one != 0 && run->deferred_many != 0;
        }
        else if (run != 0 && strncmp(line, "checker-deferred:   resident: source_order", 42) == 0)
        {
            const char* at = line;
            for (uint32_t i = 0; i < 3 && at != 0; i += 1)
            {
                at = strstr(at, "peak=");
                run->peak[i] = at != 0 ? strtoull(at + 5, 0, 10) : 0;
                at = at != 0 ? strstr(at, "growth=") : 0;
                run->growth[i] = at != 0 ? strtoull(at + 7, 0, 10) : 0;
                at = at != 0 ? at + 7 : 0;
            }
            run->resident = at != 0;
        }
        else if (run != 0 && strncmp(line, "exit=", 5) == 0)
        {
            run->status = atoi(line + 5);
            run->ended = true;
        }
    }
    if (file != 0)
    {
        fclose(file);
    }
    return valid;
}

static bool run_complete(const Run* run)
{
    return run->ended && run->status == 0 && run->header && run->lanes_line && run->absolute;
}

static double change(uint64_t value, uint64_t base)
{
    return base != 0 ? ((double)value / (double)base - 1.0) * 100.0 : 0.0;
}

static int compare_double(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

// The median of `count` values (the lower of the middle two for an even count), with their lowest and highest.
static void spread(double* values, uint32_t count, double* median, double* low, double* high)
{
    qsort(values, count, sizeof(double), compare_double);
    *median = count != 0 ? values[(count - 1) / 2] : 0.0;
    *low = count != 0 ? values[0] : 0.0;
    *high = count != 0 ? values[count - 1] : 0.0;
}

static void print_runs(void)
{
    printf("round\tunit\tconfig\tstatus\ttokens\tbodies\tbody_tokens\tlargest_body\tsecond_body\ttop_tokens\tlane_tokens\tactive\tcopies\tcopy_ns\tdispatch_ns\twake_ns\tpasses\tparse_ns\tsource_order_ns\t"
           "deferred_1_ns\tdeferred_n_ns\tn_vs_1_pct\tn_vs_source_pct\tone_vs_source_pct\tsource_peak_kib\tsource_growth_kib\tone_peak_kib\t"
           "one_growth_kib\tn_peak_kib\tn_growth_kib\tone_span\tone_merge\tone_rest\tn_span\tn_merge\tn_rest\n");
    for (uint32_t i = 0; i < run_count; i += 1)
    {
        const Run* r = runs + i;
        const bool complete = run_complete(r);
        printf("%u\t%s\t%s\t%s\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64
               "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%.3f\t%.3f\t%.3f",
               r->round, r->unit, r->config, complete ? "ok" : "incomplete", r->tokens, r->bodies, r->body_tokens, r->largest_body, r->second_body, r->top_tokens, r->lane_tokens, r->active,
               r->copies, r->copy, r->dispatch, r->wake, r->passes, r->parse, r->source_order, r->deferred_one, r->deferred_many, change(r->deferred_many, r->deferred_one),
               change(r->deferred_many, r->source_order), change(r->deferred_one, r->source_order));
        if (r->resident)
        {
            printf("\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64, r->peak[0], r->growth[0], r->peak[1], r->growth[1], r->peak[2],
                   r->growth[2]);
        }
        else
        {
            printf("\t-\t-\t-\t-\t-\t-");
        }
        printf("\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\n", r->span[0], r->merge[0], r->rest[0], r->span[1], r->merge[1], r->rest[1]);
    }
}

// The complete runs of `unit` and `config`, into `selected`; how many.
static uint32_t select_runs(const char* unit, const char* config, const Run** selected)
{
    uint32_t count = 0;
    for (uint32_t i = 0; i < run_count && count < SUMMARIZE_MAX_ROUNDS; i += 1)
    {
        if (run_complete(runs + i) && strcmp(runs[i].unit, unit) == 0 && strcmp(runs[i].config, config) == 0)
        {
            selected[count] = runs + i;
            count += 1;
        }
    }
    return count;
}

typedef struct Summary Summary;
struct Summary
{
    uint32_t rounds;
    uint64_t active_low;
    uint64_t active_high;
    double change;
    double change_low;
    double change_high;
    double many;
    double many_low;
    double many_high;
    double one;
    double source;
    double source_change;
    double dispatch;
};

static Summary summarize(const char* unit, const char* config)
{
    const Run* selected[SUMMARIZE_MAX_ROUNDS];
    const uint32_t count = select_runs(unit, config, selected);
    double changes[SUMMARIZE_MAX_ROUNDS];
    double many[SUMMARIZE_MAX_ROUNDS];
    double one[SUMMARIZE_MAX_ROUNDS];
    double source[SUMMARIZE_MAX_ROUNDS];
    double source_changes[SUMMARIZE_MAX_ROUNDS];
    double dispatch[SUMMARIZE_MAX_ROUNDS];
    Summary result = { .rounds = count, .active_low = UINT64_MAX };
    for (uint32_t i = 0; i < count; i += 1)
    {
        changes[i] = change(selected[i]->deferred_many, selected[i]->deferred_one);
        many[i] = (double)selected[i]->deferred_many;
        one[i] = (double)selected[i]->deferred_one;
        source[i] = (double)selected[i]->source_order;
        source_changes[i] = change(selected[i]->source_order, selected[i]->deferred_one);
        dispatch[i] = (double)selected[i]->dispatch;
        result.active_low = selected[i]->active < result.active_low ? selected[i]->active : result.active_low;
        result.active_high = selected[i]->active > result.active_high ? selected[i]->active : result.active_high;
    }
    double ignored[2];
    spread(changes, count, &result.change, &result.change_low, &result.change_high);
    spread(many, count, &result.many, &result.many_low, &result.many_high);
    spread(one, count, &result.one, ignored, ignored + 1);
    spread(source, count, &result.source, ignored, ignored + 1);
    spread(source_changes, count, &result.source_change, ignored, ignored + 1);
    spread(dispatch, count, &result.dispatch, ignored, ignored + 1);
    result.active_low = count != 0 ? result.active_low : 0;
    return result;
}

// The distinct units, then configurations, in first-seen order.
static uint32_t distinct(bool units, const char** names, uint32_t capacity)
{
    uint32_t count = 0;
    for (uint32_t i = 0; i < run_count; i += 1)
    {
        const char* name = units ? runs[i].unit : runs[i].config;
        bool seen = false;
        for (uint32_t j = 0; j < count && !seen; j += 1)
        {
            seen = strcmp(names[j], name) == 0;
        }
        if (!seen && count < capacity)
        {
            names[count] = name;
            count += 1;
        }
    }
    return count;
}

static void print_summary(void)
{
    const char* units[1024];
    const char* configs[64];
    const uint32_t unit_count = distinct(true, units, 1024);
    const uint32_t config_count = distinct(false, configs, 64);
    printf("unit\tconfig\trounds\tactive\tn_vs_1_median_pct\tn_vs_1_low_pct\tn_vs_1_high_pct\tdeferred_n_median_ns\tdeferred_n_low_ns\tdeferred_n_high_ns\t"
           "deferred_1_median_ns\tsource_order_median_ns\tsource_vs_1_median_pct\tdispatch_median_ns\n");
    for (uint32_t u = 0; u < unit_count; u += 1)
    {
        for (uint32_t c = 0; c < config_count; c += 1)
        {
            const Summary s = summarize(units[u], configs[c]);
            if (s.rounds != 0)
            {
                printf("%s\t%s\t%u\t", units[u], configs[c], s.rounds);
                if (s.active_low == s.active_high)
                {
                    printf("%" PRIu64, s.active_low);
                }
                else
                {
                    printf("%" PRIu64 "-%" PRIu64, s.active_low, s.active_high);
                }
                printf("\t%.2f\t%.2f\t%.2f\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\t%.2f\t%.0f\n", s.change, s.change_low, s.change_high, s.many, s.many_low, s.many_high, s.one, s.source,
                       s.source_change, s.dispatch);
            }
        }
    }
}

static void print_pair(const char* x, const char* y)
{
    const char* units[1024];
    const uint32_t unit_count = distinct(true, units, 1024);
    printf("unit\tx_lanes\ty_lanes\tx_vs_1_pct\ty_vs_1_pct\tdiff_median_points\tdiff_low_points\tdiff_high_points\tx_median_ns\ty_median_ns\trounds\n");
    for (uint32_t u = 0; u < unit_count; u += 1)
    {
        const Summary sx = summarize(units[u], x);
        const Summary sy = summarize(units[u], y);
        if (sx.rounds != 0 && sy.rounds != 0)
        {
            const Run* rx[SUMMARIZE_MAX_ROUNDS];
            const Run* ry[SUMMARIZE_MAX_ROUNDS];
            const uint32_t nx = select_runs(units[u], x, rx);
            const uint32_t ny = select_runs(units[u], y, ry);
            double diffs[SUMMARIZE_MAX_ROUNDS];
            uint32_t count = 0;
            for (uint32_t i = 0; i < nx; i += 1)
            {
                for (uint32_t j = 0; j < ny; j += 1)
                {
                    if (rx[i]->round == ry[j]->round && count < SUMMARIZE_MAX_ROUNDS)
                    {
                        diffs[count] = change(ry[j]->deferred_many, ry[j]->deferred_one) - change(rx[i]->deferred_many, rx[i]->deferred_one);
                        count += 1;
                    }
                }
            }
            double median = 0.0;
            double low = 0.0;
            double high = 0.0;
            spread(diffs, count, &median, &low, &high);
            printf("%s\t%" PRIu64 "\t%" PRIu64 "\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.0f\t%.0f\t%u\n", units[u], sx.active_high, sy.active_high, sx.change, sy.change, median,
                   low, high, sx.many, sy.many, count);
        }
    }
}

static void print_choice(void)
{
    const char* units[1024];
    const uint32_t unit_count = distinct(true, units, 1024);
    static const char* const forced[] = { "every:2", "every:3", "every:4", "every:8" };
    printf("unit\trule_lanes\trule_one_lane\trule_vs_1_pct\trule_low_pct\trule_high_pct\tevery2_pct\tevery3_pct\tevery4_pct\tevery8_pct\tbest_forced\tbest_pct\tbest_low_pct\t"
           "best_high_pct\trule_minus_best_points\tsource_vs_1_pct\tdriver_choice\tdriver_vs_1_pct\tbest_choice\tbest_choice_pct\tdriver_minus_best_points\n");
    for (uint32_t u = 0; u < unit_count; u += 1)
    {
        const Summary rule = summarize(units[u], "rule:8");
        if (rule.rounds != 0)
        {
            double best = 0.0;
            double best_low = 0.0;
            double best_high = 0.0;
            const char* best_name = "1";
            printf("%s\t%" PRIu64 "\t%s\t%.2f\t%.2f\t%.2f", units[u], rule.active_high, rule.active_high == 1 ? "yes" : "no", rule.change, rule.change_low, rule.change_high);
            for (uint32_t f = 0; f < 4; f += 1)
            {
                const Summary s = summarize(units[u], forced[f]);
                if (s.rounds != 0)
                {
                    printf("\t%.2f", s.change);
                }
                else
                {
                    printf("\t-");
                }
                if (s.rounds != 0 && s.change < best)
                {
                    best = s.change;
                    best_low = s.change_low;
                    best_high = s.change_high;
                    best_name = forced[f] + 6;
                }
            }
            printf("\t%s\t%.2f\t%.2f\t%.2f\t%.2f", best_name, best, best_low, best_high, rule.change - best);
            // The driver's choice and the best of every choice, the rule's and source order's among them.
            const bool driver_source = rule.active_high < 4;
            const double driver = driver_source ? rule.source_change : rule.change;
            const char* choice_name = best_name;
            double choice = best;
            if (rule.change < choice)
            {
                choice = rule.change;
                choice_name = "rule";
            }
            if (rule.source_change < choice)
            {
                choice = rule.source_change;
                choice_name = "source";
            }
            printf("\t%.2f\t%s\t%.2f\t%s\t%.2f\t%.2f\n", rule.source_change, driver_source ? "source" : "rule", driver, choice_name, choice, driver - choice);
        }
    }
}

int main(int argc, char** argv)
{
    const char* table = "runs";
    const char* pair = 0;
    bool valid = argc >= 2;
    int first = 1;
    while (valid && first + 1 < argc && (strcmp(argv[first], "--table") == 0 || strcmp(argv[first], "--pair") == 0))
    {
        table = strcmp(argv[first], "--table") == 0 ? argv[first + 1] : table;
        pair = strcmp(argv[first], "--pair") == 0 ? argv[first + 1] : pair;
        first += 2;
    }
    for (int i = first; valid && i < argc; i += 1)
    {
        valid = read_log(argv[i]);
        if (!valid)
        {
            fprintf(stderr, "summarize: can't read %s, or it has more than %u runs\n", argv[i], SUMMARIZE_MAX_RUNS);
        }
    }
    uint32_t incomplete = 0;
    for (uint32_t i = 0; valid && i < run_count; i += 1)
    {
        if (!run_complete(runs + i))
        {
            incomplete += 1;
            fprintf(stderr, "summarize: incomplete run: round %u unit %s config %s status %d\n", runs[i].round, runs[i].unit, runs[i].config, runs[i].status);
        }
    }
    if (valid && strcmp(table, "runs") == 0)
    {
        print_runs();
    }
    else if (valid && strcmp(table, "summary") == 0)
    {
        print_summary();
    }
    else if (valid && strcmp(table, "choice") == 0)
    {
        print_choice();
    }
    else if (valid && strcmp(table, "pair") == 0 && pair != 0 && strchr(pair, ',') != 0)
    {
        char x[SUMMARIZE_MAX_TEXT];
        snprintf(x, sizeof(x), "%s", pair);
        *strchr(x, ',') = 0;
        print_pair(x, strchr(pair, ',') + 1);
    }
    else
    {
        valid = false;
        fprintf(stderr, "usage: summarize [--table runs|summary|choice|pair] [--pair X,Y] LOG...\n");
    }
    if (valid)
    {
        fprintf(stderr, "summarize: %u runs, %u incomplete\n", run_count, incomplete);
    }
    return valid ? 0 : 1;
}
