// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// post: scores lane policies on the post-merge-rounds experiment of #447. Reads summarize's runs table of two builds'
// forced lane counts (configurations `main2+every:K`, the post-merge rounds on the bodies' lanes, and `post1+every:K`,
// the post-merge rounds on the calling thread alone), and for each unit takes the median over its rounds of each
// build's change on K lanes against one lane in the same process (one lane runs the same code in both builds: 0 by
// definition). Lane counts between two measured ones are interpolated linearly; a unit's best is the least change of
// either build on any lane count, one lane among them.
//
// A policy is a rule of the bodies' lanes and the fewest lanes P from which the post-merge rounds take them: a unit the
// rule gives L lanes reads as main2 on L if L >= P and as post1 on L otherwise. The rule gives
// 1 + (excess - c) / (a + top / b) lanes where the excess, the bodies' tokens beyond the larger of the largest body's
// and twice the second largest's, is above c (one lane otherwise), or with c `lane` max(1, excess / (a + top / b)); no
// more than 8 or the bodies. For each P it prints the best policies of a grid (the worst unit's change against one
// lane, the units within a point of their best, the gains forgone against each unit's best, summed), main's policy
// (P 2, a 3,072, b 3, c lane: #1567's) and the chosen one (P 4, a 3,072, b 3, c 0) with its per-unit gaps; then each
// unit's medians in microseconds of the whole reading's, the lanes' span's, the merge's and the rest's change against
// one lane, by build and forced count.
//
//   post RUNS.tsv
//
// Original project work, no imported code. Build: clang -std=gnu17 -O2 -Wall -Wextra -Werror post.c -o post

#include <inttypes.h>
#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define POST_MAX_UNITS 256u
#define POST_MAX_SAMPLES 16u
#define POST_LANES 8u
#define POST_TEXT 256u
#define POST_LINE_BYTES 16384u
#define POST_FIELDS 15u
#define POST_KINDS 5u

// The measures of a configuration: the change in percent, then the whole reading's, the span's, the merge's and the
// rest's change against one lane in microseconds.
typedef struct Samples Samples;
struct Samples
{
    double values[POST_KINDS][POST_MAX_SAMPLES];
    uint32_t count;
};

typedef struct Unit Unit;
struct Unit
{
    char name[POST_TEXT];
    uint64_t tokens;
    uint64_t bodies;
    uint64_t body_tokens;
    uint64_t largest;
    uint64_t second;
    uint64_t top;
    // [build][lanes]: build 0 main2, 1 post1.
    Samples samples[2][POST_LANES + 1];
    double change[2][POST_LANES + 1];
    bool measured[2][POST_LANES + 1];
    double best;
};

static Unit units[POST_MAX_UNITS];
static uint32_t unit_count;

static int compare_double(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

static double median(const double* values, uint32_t count)
{
    double ordered[POST_MAX_SAMPLES];
    memcpy(ordered, values, count * sizeof(double));
    qsort(ordered, count, sizeof(double), compare_double);
    return count == 0 ? NAN : count % 2 == 1 ? ordered[count / 2] : (ordered[count / 2 - 1] + ordered[count / 2]) / 2.0;
}

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

static uint32_t header_index(const char* header, const char* name)
{
    uint32_t result = UINT32_MAX;
    char field[POST_TEXT];
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
    if (result == 0 && unit_count < POST_MAX_UNITS)
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
    static char line[POST_LINE_BYTES];
    static char header[POST_LINE_BYTES];
    bool valid = file != 0 && fgets(header, sizeof(header), file) != 0;
    static const char* const names[POST_FIELDS] = { "unit",   "config",   "status",   "tokens", "bodies",  "body_tokens", "largest_body", "second_body",
                                                    "top_tokens", "active", "n_vs_1_pct", "deferred_1_ns", "deferred_n_ns", "one_span", "n_span" };
    uint32_t at[POST_FIELDS + 4];
    for (uint32_t i = 0; valid && i < POST_FIELDS; i += 1)
    {
        at[i] = header_index(header, names[i]);
        valid = at[i] != UINT32_MAX;
    }
    static const char* const extra[4] = { "one_merge", "n_merge", "one_rest", "n_rest" };
    for (uint32_t i = 0; valid && i < 4; i += 1)
    {
        at[POST_FIELDS + i] = header_index(header, extra[i]);
        valid = at[POST_FIELDS + i] != UINT32_MAX;
    }
    while (valid && fgets(line, sizeof(line), file) != 0)
    {
        char f[POST_FIELDS + 4][POST_TEXT];
        for (uint32_t i = 0; i < POST_FIELDS + 4; i += 1)
        {
            column(line, at[i], f[i], POST_TEXT);
        }
        const uint32_t build = strncmp(f[1], "main2+every:", 12) == 0 ? 0 : strncmp(f[1], "post1+every:", 12) == 0 ? 1 : 2;
        const uint64_t lanes = strtoull(f[9], 0, 10);
        // A unit of one body reads one lane however many it is given: registered, with no samples (its change is 0).
        if (build < 2 && strcmp(f[2], "ok") == 0 && lanes >= 1 && lanes <= POST_LANES)
        {
            Unit* unit = unit_named(f[0]);
            valid = unit != 0;
            if (valid)
            {
                unit->tokens = strtoull(f[3], 0, 10);
                unit->bodies = strtoull(f[4], 0, 10);
                unit->body_tokens = strtoull(f[5], 0, 10);
                unit->largest = strtoull(f[6], 0, 10);
                unit->second = strtoull(f[7], 0, 10);
                unit->top = strtoull(f[8], 0, 10);
                Samples* s = &unit->samples[build][lanes];
                if (lanes >= 2 && s->count < POST_MAX_SAMPLES)
                {
                    const double per = (double)unit->tokens / 1000.0;
                    s->values[0][s->count] = strtod(f[10], 0);
                    s->values[1][s->count] = (strtod(f[12], 0) - strtod(f[11], 0)) / 1000.0;
                    s->values[2][s->count] = (strtod(f[14], 0) - strtod(f[13], 0)) * per;
                    s->values[3][s->count] = (strtod(f[16], 0) - strtod(f[15], 0)) * per;
                    s->values[4][s->count] = (strtod(f[18], 0) - strtod(f[17], 0)) * per;
                    s->count += 1;
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

static void prepare(void)
{
    for (uint32_t u = 0; u < unit_count; u += 1)
    {
        Unit* unit = units + u;
        unit->best = 0.0;
        for (uint32_t b = 0; b < 2; b += 1)
        {
            unit->change[b][1] = 0.0;
            unit->measured[b][1] = true;
            for (uint32_t l = 2; l <= POST_LANES; l += 1)
            {
                const Samples* s = &unit->samples[b][l];
                unit->measured[b][l] = s->count != 0;
                unit->change[b][l] = s->count != 0 ? median(s->values[0], s->count) : 0.0;
            }
            for (uint32_t l = 2; l <= POST_LANES; l += 1)
            {
                if (!unit->measured[b][l])
                {
                    uint32_t below = l - 1;
                    while (below > 1 && !unit->measured[b][below])
                    {
                        below -= 1;
                    }
                    uint32_t above = l + 1;
                    while (above <= POST_LANES && !unit->measured[b][above])
                    {
                        above += 1;
                    }
                    unit->change[b][l] = above <= POST_LANES ?
                                         unit->change[b][below] + (unit->change[b][above] - unit->change[b][below]) * (double)(l - below) / (double)(above - below) :
                                         unit->change[b][below];
                }
                unit->best = unit->change[b][l] < unit->best ? unit->change[b][l] : unit->best;
            }
        }
    }
}

typedef struct Policy Policy;
struct Policy
{
    uint64_t a;
    uint64_t b;
    uint64_t c;
    uint32_t post;
};

static uint32_t policy_lanes(const Policy* policy, const Unit* unit)
{
    const uint64_t second = unit->second * 2;
    const uint64_t path = unit->largest > second ? unit->largest : second;
    const uint64_t excess = unit->body_tokens > path ? unit->body_tokens - path : 0;
    const uint64_t lane_tokens = policy->a + (policy->b != 0 ? unit->top / policy->b : 0);
    uint64_t paid = 1;
    if (policy->c == UINT64_MAX)
    {
        paid = excess / lane_tokens > 1 ? excess / lane_tokens : 1;
    }
    else
    {
        paid = excess > policy->c ? 1 + (excess - policy->c) / lane_tokens : 1;
    }
    const uint64_t most = unit->bodies < POST_LANES ? unit->bodies : POST_LANES;
    return (uint32_t)(paid < most ? paid : most);
}

static double policy_change(const Policy* policy, const Unit* unit)
{
    const uint32_t lanes = policy_lanes(policy, unit);
    return unit->change[lanes >= policy->post ? 0 : 1][lanes];
}

typedef struct Score Score;
struct Score
{
    double worst;
    double forgone;
    uint32_t within;
    uint32_t slower;
};

static Score score(const Policy* policy)
{
    Score result = { .worst = -1e9 };
    for (uint32_t u = 0; u < unit_count; u += 1)
    {
        const double change = policy_change(policy, units + u);
        result.worst = change > result.worst ? change : result.worst;
        result.forgone += change - units[u].best;
        result.within += change - units[u].best <= 1.0;
        result.slower += change > 1.0;
    }
    return result;
}

static void print_policy(const char* label, const Policy* policy)
{
    const Score s = score(policy);
    char threshold[32];
    snprintf(threshold, sizeof(threshold), policy->c == UINT64_MAX ? "lane" : "%" PRIu64, policy->c);
    printf("  %-8s post-merge lanes from %u, a=%-5" PRIu64 " b=%-2" PRIu64 " c=%-5s worst=%+6.2f%% within=%2u/%u slower=%u forgone=%6.1f\n", label, policy->post, policy->a,
           policy->b, threshold, s.worst, s.within, unit_count, s.slower, s.forgone);
}

int main(int argc, char** argv)
{
    bool valid = argc == 2 && read_runs(argv[1]) && unit_count != 0;
    if (valid)
    {
        prepare();
        printf("units: %u; each unit's best is the least change of either build on any lane count, one lane among them\n", unit_count);
        const Policy main_policy = { 3072, 3, UINT64_MAX, 2 };
        const Policy chosen = { 3072, 3, 0, 4 };
        print_policy("main", &main_policy);
        print_policy("chosen", &chosen);
        static const uint64_t as[] = { 1024, 1536, 2048, 2560, 3072, 4096, 5120, 6144, 8192, 12288 };
        static const uint64_t bs[] = { 0, 1, 2, 3, 4, 6, 8 };
        static const uint64_t cs[] = { 0, 1024, 2048, 3072, 4096, 6144, 8192, UINT64_MAX };
        static const uint32_t posts[] = { 2, 3, 4, 5, 6, 9 };
        for (uint32_t p = 0; p < sizeof(posts) / sizeof(posts[0]); p += 1)
        {
            Policy best[3];
            Score scores[3];
            uint32_t kept = 0;
            for (uint32_t i = 0; i < sizeof(as) / sizeof(as[0]); i += 1)
            {
                for (uint32_t j = 0; j < sizeof(bs) / sizeof(bs[0]); j += 1)
                {
                    for (uint32_t k = 0; k < sizeof(cs) / sizeof(cs[0]); k += 1)
                    {
                        const Policy policy = { as[i], bs[j], cs[k], posts[p] };
                        const Score s = score(&policy);
                        // Keep the three of least gains forgone among those whose worst unit is at most +1.0%.
                        uint32_t at = kept;
                        while (s.worst <= 1.0 && at > 0 && s.forgone < scores[at - 1].forgone - 1e-9)
                        {
                            at -= 1;
                        }
                        if (s.worst <= 1.0 && at < 3)
                        {
                            const uint32_t last = kept < 3 ? kept : 2;
                            for (uint32_t m = last; m > at; m -= 1)
                            {
                                best[m] = best[m - 1];
                                scores[m] = scores[m - 1];
                            }
                            best[at] = policy;
                            scores[at] = s;
                            kept += kept < 3;
                        }
                    }
                }
            }
            printf("post-merge lanes from %u (9: never):\n", posts[p]);
            for (uint32_t m = 0; m < kept; m += 1)
            {
                print_policy(m == 0 ? "best" : "", best + m);
            }
        }
        printf("the chosen policy's units more than a point from their best:\n");
        for (uint32_t u = 0; u < unit_count; u += 1)
        {
            const Unit* unit = units + u;
            const uint32_t lanes = policy_lanes(&chosen, unit);
            const double change = policy_change(&chosen, unit);
            if (change - unit->best > 1.0)
            {
                printf("  %-28s body tokens %6" PRIu64 ": %u lanes (%s) %+6.2f%%, best %+6.2f%%, gap %.2f points\n", unit->name, unit->body_tokens, lanes,
                       lanes >= chosen.post ? "main2" : "post1", change, unit->best, change - unit->best);
            }
        }
        printf("medians against one lane, microseconds (whole, span, merge, rest), by build and forced lanes:\n");
        static const char* const builds[2] = { "main2", "post1" };
        for (uint32_t u = 0; u < unit_count; u += 1)
        {
            for (uint32_t b = 0; b < 2; b += 1)
            {
                printf("  %-28s %s", units[u].name, builds[b]);
                for (uint32_t l = 2; l <= POST_LANES; l += 1)
                {
                    const Samples* s = &units[u].samples[b][l];
                    if (s->count != 0)
                    {
                        printf("  %u: %+.1f %+.1f %+.1f %+.1f", l, median(s->values[1], s->count), median(s->values[2], s->count), median(s->values[3], s->count),
                               median(s->values[4], s->count));
                    }
                }
                printf("\n");
            }
        }
    }
    else
    {
        fprintf(stderr, "usage: post RUNS.tsv (summarize's runs table of the post experiment's log)\n");
    }
    return valid ? 0 : 1;
}
