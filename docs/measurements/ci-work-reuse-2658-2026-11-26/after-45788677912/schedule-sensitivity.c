// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Scratch diagnostic, pinned to the pre-offset collector and scheduler.
// Recollect training samples, independently derive post-suite offsets, then score held-out observations.
#define POST_SUITE_INCLUDED
#include "post-suite.c"
#include <sys/stat.h>

typedef struct Training Training;
struct Training
{
    CostsTable rows[BUSTER_COSTS_ROWS];
    CostsSpeeds speeds;
};

// Match the collector's explicit fallback: fewer than five overlapping headings leaves raw samples unscaled.
static uint64_t training_normalize(const CostsSpeeds* speeds, const char* model, uint64_t tenths)
{
    uint64_t factor = 0;
    for (uint32_t i = 0; i < speeds->count; i += 1)
    {
        factor = strcmp(speeds->models[i].key, model) == 0 ? speeds->factors[i] : factor;
    }
    return factor != 0 ? (tenths * speeds->slowest + factor / 2) / factor : tenths;
}

static uint32_t run_of(const char* path)
{
    static const char* const runs[] = { "45778920528", "45779273785", "45779319802", "45788677912" };
    uint32_t result = 4;
    for (uint32_t i = 0; i < 4; i += 1)
    {
        result = strncmp(filename(path), runs[i], 11) == 0 ? i : result;
    }
    return result;
}

static uint64_t first_offset(const CostsLog* logs, const uint64_t* post, uint32_t count,
                             const CostsSpeeds* speeds, uint32_t row)
{
    uint64_t first[76] = { 0 };
    uint64_t other[76] = { 0 };
    uint32_t first_count = 0;
    uint32_t other_count = 0;
    for (uint32_t i = 0; i < count; i += 1)
    {
        if (logs[i].row == row)
        {
            const uint64_t normalized = training_normalize(speeds, logs[i].cpu, post[i] / 100);
            if (logs[i].shard == 1)
            {
                first[first_count++] = normalized;
            }
            else
            {
                other[other_count++] = normalized;
            }
        }
    }
    if (first_count == 0 || other_count != 3 * first_count)
    {
        costs_fatal("incomplete row for post-suite offset");
    }
    const uint64_t a = costs_quantile(first, first_count, 50);
    const uint64_t b = costs_quantile(other, other_count, 50);
    return a > b ? (a - b) * 100 : 0;
}

static void directory_make(const char* path)
{
    if (mkdir(path, 0777) != 0 && errno != EEXIST)
    {
        costs_fatal("could not create sensitivity directory");
    }
}

static Training train(const CostsList* list, CostsLog* logs, char** names, uint64_t* post,
                      uint32_t count, uint32_t mask, const char* output_path, const char* label)
{
    CostsLog selected[76] = { 0 };
    const char* selected_names[76] = { 0 };
    uint64_t selected_post[76] = { 0 };
    uint32_t selected_count = 0;
    for (uint32_t i = 0; i < count; i += 1)
    {
        const uint32_t run = run_of(names[i]);
        if (run >= 4)
        {
            costs_fatal("unrecognized run");
        }
        if ((mask & (1u << run)) != 0)
        {
            selected[selected_count] = logs[i];
            selected_names[selected_count] = names[i];
            selected_post[selected_count] = post[i];
            selected_count += 1;
        }
    }
    Training training = { 0 };
    training.speeds = costs_speeds(selected, selected_count);
    CostsBuffer tables[BUSTER_COSTS_ROWS] = { 0 };
    CostsBuffer report = { 0 };
    if (!costs_collect_rows(list, selected, selected_names, selected_count, tables, &report))
    {
        fprintf(stderr, "%s", report.data != NULL ? report.data : "");
        costs_fatal("could not recollect training tables");
    }
    char folder[4096];
    snprintf(folder, sizeof(folder), "%s/%s", output_path, label);
    directory_make(folder);
    FILE* factors = output(folder, "cpu-factors.tsv");
    fprintf(factors, "cpu\tfactor\tslowest\n");
    for (uint32_t i = 0; i < training.speeds.count; i += 1)
    {
        fprintf(factors, "%s\t%llu\t%llu\n", training.speeds.models[i].key,
                (unsigned long long)training.speeds.factors[i], (unsigned long long)training.speeds.slowest);
    }
    fclose(factors);
    for (uint32_t row = BUSTER_COSTS_VECTOR * BUSTER_COSTS_SANITIZERS; row < BUSTER_COSTS_ROWS; row += 1)
    {
        CostsTable* table = training.rows + row;
        *table = costs_table_parse(list, (CostsText){ tables[row].data, tables[row].length });
        if (table->error != NULL || table->duplicates != 0 || table->extra != 0 ||
            table->samples_min == 0 || table->jobs != 4)
        {
            costs_fatal("invalid collected table");
        }
        table->first_milliseconds = first_offset(selected, selected_post, selected_count, &training.speeds, row);
        table->first_given = true;
        CostsBuffer with_offset = { 0 };
        costs_table_write(table, list, &with_offset);
        char name[128];
        char row_name[64];
        costs_row_name(row, row_name, sizeof(row_name));
        snprintf(name, sizeof(name), "%s.costs", row_name);
        FILE* file = output(folder, name);
        fwrite(with_offset.data, 1, with_offset.length, file);
        fclose(file);
        free(with_offset.data);
    }
    for (uint32_t row = 0; row < BUSTER_COSTS_ROWS; row += 1)
    {
        free(tables[row].data);
    }
    free(report.data);
    return training;
}

static void score(const CostsList* list, const Training* training, const CostsTable* current,
                  CostsLog* logs, char** names, const uint64_t* post, uint32_t count, uint32_t eval_run,
                  const char* output_path, const char* label, const char* relation, FILE* report)
{
    static const char* const runs[] = { "45778920528", "45779273785", "45779319802", "45788677912" };
    CostsLog evaluation[20] = { 0 };
    uint64_t evaluation_post[20] = { 0 };
    uint32_t eval_count = 0;
    for (uint32_t i = 0; i < count; i += 1)
    {
        if (run_of(names[i]) == eval_run)
        {
            evaluation[eval_count] = logs[i];
            evaluation_post[eval_count] = post[i];
            eval_count += 1;
        }
    }
    const uint64_t memory = costs_logs_memory(evaluation, eval_count);
    for (uint32_t row = BUSTER_COSTS_VECTOR * BUSTER_COSTS_SANITIZERS; row < BUSTER_COSTS_ROWS; row += 1)
    {
        uint64_t* milliseconds = costs_allocate(list->count, sizeof(uint64_t));
        uint64_t* peaks = costs_allocate(list->count, sizeof(uint64_t));
        uint32_t* seen = costs_allocate(list->count, sizeof(uint32_t));
        uint32_t shards = 0;
        for (uint32_t i = 0; i < eval_count; i += 1)
        {
            if (evaluation[i].row == row)
            {
                shards += 1;
                for (uint32_t s = 0; s < evaluation[i].sample_count; s += 1)
                {
                    const CostsSample* sample = evaluation[i].samples + s;
                    milliseconds[sample->command] = 100 * training_normalize(&training->speeds, evaluation[i].cpu, sample->tenths);
                    peaks[sample->command] = sample->peak;
                    seen[sample->command] += sample->complete;
                }
            }
        }
        if (shards != 4)
        {
            costs_fatal("evaluation does not have four shards");
        }
        for (uint32_t c = 0; c < list->count; c += 1)
        {
            if (seen[c] != 1)
            {
                costs_fatal("evaluation does not have exactly one complete sample of each heading");
            }
        }
        const uint64_t score_first = first_offset(evaluation, evaluation_post, eval_count, &training->speeds, row);
        uint64_t current_longest = 0;
        const char* const cases[] = { "current-pr", "training-no-offset", "training-with-offset" };
        for (uint32_t which = 0; which < 3; which += 1)
        {
            const CostsTable* deal = which == 0 ? current + row : training->rows + row;
            const uint64_t deal_first = which == 2 ? deal->first_milliseconds : 0;
            uint64_t times[4] = { 0 };
            CostsBuffer listing = { 0 };
            const CostsPlan plan = costs_plan(list, deal->milliseconds, deal->peaks, deal->jobs, deal->runner_memory,
                                             deal_first, milliseconds, peaks, 4, 4, memory, score_first, times,
                                             eval_run == 3 && (strcmp(label, "baseline-three") == 0 || strcmp(label, "all-four") == 0) ? &listing : NULL);
            current_longest = which == 0 ? plan.longest : current_longest;
            char row_name[64];
            costs_row_name(row, row_name, sizeof(row_name));
            fprintf(report, "%s\t%s\t%s\t%s\t%s\t%.1f\t%.1f\t%.3f\t%.3f\t%.6f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\n",
                    label, runs[eval_run], relation, row_name, cases[which], (double)deal_first / 1000.0,
                    (double)score_first / 1000.0, (double)plan.longest / 1000.0, (double)plan.total / 4000.0,
                    (double)plan.total / 60000.0, (double)times[0] / 1000.0, (double)times[1] / 1000.0,
                    (double)times[2] / 1000.0, (double)times[3] / 1000.0,
                    current_longest != 0 ? 100.0 * ((double)plan.longest / (double)current_longest - 1.0) : 0.0);
            if (listing.length != 0)
            {
                char name[256];
                snprintf(name, sizeof(name), "%s-%s-%s-after-plan.txt", label, row_name, cases[which]);
                FILE* file = output(output_path, name);
                fwrite(listing.data, 1, listing.length, file);
                fclose(file);
            }
            free(listing.data);
        }
        free(milliseconds);
        free(peaks);
        free(seen);
    }
}

int main(int argc, char** argv)
{
    (void)post_main;
    if (argc != 6)
    {
        costs_fatal("usage: sensitivity TESTS BASELINE_LOGS AFTER_LOGS CURRENT_COSTS OUTPUT");
    }
    CostsText inventory = { 0 };
    CostsList list = { 0 };
    if (!costs_load_list(argv[1], &inventory, &list))
    {
        costs_fatal("inventory unavailable");
    }
    glob_t paths = { 0 };
    char pattern[4096];
    snprintf(pattern, sizeof(pattern), "%s/*.log", argv[2]);
    if (glob(pattern, 0, NULL, &paths) != 0)
    {
        costs_fatal("baseline logs unavailable");
    }
    snprintf(pattern, sizeof(pattern), "%s/*.log", argv[3]);
    if (glob(pattern, GLOB_APPEND, NULL, &paths) != 0 || paths.gl_pathc != 76)
    {
        costs_fatal("expected 60 baseline and 16 after logs");
    }
    const uint32_t count = (uint32_t)paths.gl_pathc;
    CostsLog* logs = costs_allocate(count, sizeof(CostsLog));
    uint64_t* post = costs_allocate(count, sizeof(uint64_t));
    if (!costs_load_logs(&list, paths.gl_pathv, count, logs))
    {
        costs_fatal("log parsing failed");
    }
    for (uint32_t i = 0; i < count; i += 1)
    {
        const Post parsed = post_read(paths.gl_pathv[i]);
        if (parsed.summaries != 1 || parsed.cleanups != 1 || parsed.summary < 0 ||
            parsed.cleanup < parsed.summary || parsed.errors != 0)
        {
            costs_fatal("invalid post-suite interval");
        }
        post[i] = (uint64_t)(parsed.cleanup - parsed.summary);
    }
    CostsTable current[BUSTER_COSTS_ROWS] = { 0 };
    for (uint32_t row = BUSTER_COSTS_VECTOR * BUSTER_COSTS_SANITIZERS; row < BUSTER_COSTS_ROWS; row += 1)
    {
        char row_name[64];
        costs_row_name(row, row_name, sizeof(row_name));
        snprintf(pattern, sizeof(pattern), "%s/%s.costs", argv[4], row_name);
        CostsText text = { 0 };
        if (!costs_read(pattern, &text))
        {
            costs_fatal("current table unavailable");
        }
        current[row] = costs_table_parse(&list, text);
        free(text.data);
        if (current[row].error != NULL || current[row].samples_min != 3 || current[row].samples_max != 3)
        {
            costs_fatal("current table is not the pinned three-run table");
        }
    }
    directory_make(argv[5]);
    FILE* report = output(argv[5], "sensitivity.tsv");
    fprintf(report, "training\tevaluation_run\trelation\trow\tdeal\ttraining_first_s\tevaluation_first_s\tlongest_s\tmean_s\trunner_minutes\tshard1_s\tshard2_s\tshard3_s\tshard4_s\tlongest_change_vs_current_pct\n");
    const uint32_t masks[] = { 7, 6, 5, 3, 15, 14, 13, 11, 7 };
    const char* const labels[] = {
        "baseline-three", "baseline-without-45778920528", "baseline-without-45779273785",
        "baseline-without-45779319802", "all-four", "all-without-45778920528",
        "all-without-45779273785", "all-without-45779319802", "all-without-45788677912",
    };
    for (uint32_t t = 0; t < 9; t += 1)
    {
        Training training = train(&list, logs, paths.gl_pathv, post, count, masks[t], argv[5], labels[t]);
        if (t == 0)
        {
            for (uint32_t row = 4; row < BUSTER_COSTS_ROWS; row += 1)
            {
                for (uint32_t c = 0; c < list.count; c += 1)
                {
                    if (training.rows[row].milliseconds[c] != current[row].milliseconds[c] ||
                        training.rows[row].peaks[c] != current[row].peaks[c])
                    {
                        costs_fatal("recollected baseline differs from current pinned weights or peaks");
                    }
                }
            }
        }
        for (uint32_t eval = 0; eval < 4; eval += 1)
        {
            const bool selected = t == 0 || t == 4 || (masks[t] & (1u << eval)) == 0;
            const bool baseline_holdout = t >= 1 && t <= 3 && eval == 3;
            if (selected && !baseline_holdout)
            {
                score(&list, &training, current, logs, paths.gl_pathv, post, count, eval, argv[5], labels[t],
                      (masks[t] & (1u << eval)) == 0 ? "held-out" : "in-sample", report);
            }
        }
        for (uint32_t row = 4; row < BUSTER_COSTS_ROWS; row += 1)
        {
            costs_table_free(training.rows + row);
        }
        costs_speeds_free(&training.speeds);
    }
    fclose(report);
    fprintf(stderr, "sensitivity: 76 complete logs, 9 training subsets, baseline weight/peak A/A match: PASS\n");
    return 0;
}
