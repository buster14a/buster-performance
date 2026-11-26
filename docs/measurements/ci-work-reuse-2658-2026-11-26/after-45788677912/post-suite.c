// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Exact suite-summary to cleanup-marker durations; baseline CPU factors stay frozen.
#define main costs_cli_main
#include "tools/ci/costs.c"
#undef main
#include <glob.h>

typedef struct Post Post;
struct Post
{
    int64_t summary;
    int64_t cleanup;
    uint32_t summaries;
    uint32_t cleanups;
    uint32_t errors;
};

static Post post_read(const char* path)
{
    CostsText text = { 0 };
    if (!costs_read(path, &text))
    {
        costs_fatal("post-suite input unavailable");
    }
    Post post = { .summary = -1, .cleanup = -1 };
    bool reported = false;
    size_t offset = 0;
    CostsSlice line;
    while (costs_next_line(text, &offset, &line))
    {
        int64_t stamp = -1;
        const size_t skip = costs_timestamp(line, &stamp);
        const CostsSlice content = costs_after(line, skip);
        char plain[4096];
        snprintf(plain, sizeof(plain), "%.*s", (int)content.length, content.data);
        unsigned int commands = 0;
        double seconds = 0;
        reported = reported || costs_starts(content, "parallel: shard ");
        if (reported && sscanf(plain, "parallel: %u commands in %lf s,", &commands, &seconds) == 2)
        {
            post.summary = skip != 0 ? stamp : -1;
            post.summaries += 1;
        }
        if (costs_equal(content, BUSTER_COSTS_SLICE("Cleaning up orphan processes")))
        {
            post.cleanup = skip != 0 ? stamp : -1;
            post.cleanups += 1;
        }
        if (post.summaries != 0 && (costs_starts(content, "##[error]") || costs_starts(content, "::error::")))
        {
            post.errors += 1;
        }
    }
    free(text.data);
    return post;
}

static const char* filename(const char* path)
{
    const char* slash = strrchr(path, '/');
    return slash != NULL ? slash + 1 : path;
}

static uint64_t model_normalize(const CostsSpeeds* speeds, const char* model, uint64_t tenths)
{
    uint64_t factor = 0;
    for (uint32_t i = 0; i < speeds->count; i += 1)
    {
        factor = strcmp(speeds->models[i].key, model) == 0 ? speeds->factors[i] : factor;
    }
    if (factor == 0)
    {
        costs_fatal("CPU model has no frozen baseline factor");
    }
    return (tenths * speeds->slowest + factor / 2) / factor;
}

static FILE* output(const char* directory, const char* name)
{
    char path[4096];
    snprintf(path, sizeof(path), "%s/%s", directory, name);
    FILE* file = fopen(path, "w");
    if (file == NULL)
    {
        costs_fatal("could not create post-suite output");
    }
    return file;
}

static int post_main(int argc, char** argv)
{
    if (argc != 5)
    {
        costs_fatal("usage: post-suite TESTS BASELINE_LOGS AFTER_LOGS OUTPUT");
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
    const uint32_t baseline_count = (uint32_t)paths.gl_pathc;
    snprintf(pattern, sizeof(pattern), "%s/*.log", argv[3]);
    if (glob(pattern, GLOB_APPEND, NULL, &paths) != 0)
    {
        costs_fatal("after logs unavailable");
    }
    const uint32_t count = (uint32_t)paths.gl_pathc;
    CostsLog* logs = costs_allocate(count, sizeof(CostsLog));
    if (!costs_load_logs(&list, paths.gl_pathv, count, logs))
    {
        costs_fatal("logs failed parsing");
    }
    CostsSpeeds speeds = costs_speeds(logs, baseline_count);
    uint64_t* normalized = costs_allocate(count, sizeof(uint64_t));
    FILE* samples = output(argv[4], "post-suite.tsv");
    fprintf(samples, "log\trow\tshard\tcpu\tsummary_timestamp_ms\tcleanup_timestamp_ms\traw_seconds\tnormalized_seconds\tsummary_markers\tcleanup_markers\tpost_errors\n");
    bool valid = baseline_count == 60 && count == 76;
    for (uint32_t i = 0; i < count; i += 1)
    {
        const Post post = post_read(paths.gl_pathv[i]);
        valid = valid && post.summaries == 1 && post.cleanups == 1 && post.summary >= 0 &&
                post.cleanup >= post.summary && post.errors == 0 && logs[i].unknown == 0;
        for (uint32_t s = 0; s < logs[i].sample_count; s += 1)
        {
            valid = valid && logs[i].samples[s].complete;
        }
        const uint64_t ms = post.cleanup >= post.summary && post.summary >= 0 ? (uint64_t)(post.cleanup - post.summary) : 0;
        normalized[i] = model_normalize(&speeds, logs[i].cpu, ms / 100);
        char row[64];
        costs_row_name(logs[i].row, row, sizeof(row));
        fprintf(samples, "%s\t%s\t%u\t%s\t%lld\t%lld\t%.3f\t%.1f\t%u\t%u\t%u\n",
                filename(paths.gl_pathv[i]), row, logs[i].shard, logs[i].cpu,
                (long long)post.summary, (long long)post.cleanup, (double)ms / 1000.0,
                (double)normalized[i] / 10.0, post.summaries, post.cleanups, post.errors);
    }
    fclose(samples);
    FILE* summary = output(argv[4], "post-suite-summary.tsv");
    fprintf(summary, "sample_set\trow\tfirst_count\tother_count\tfirst_median_s\tother_median_s\tfirst_offset_s\n");
    const char* const sets[] = { "baseline-three-runs", "after", "45778920528", "45779273785", "45779319802" };
    for (uint32_t set = 0; set < 5; set += 1)
    {
        for (uint32_t row = BUSTER_COSTS_VECTOR * BUSTER_COSTS_SANITIZERS; row < BUSTER_COSTS_ROWS; row += 1)
        {
            uint64_t first[76] = { 0 };
            uint64_t other[76] = { 0 };
            uint32_t first_count = 0;
            uint32_t other_count = 0;
            for (uint32_t i = 0; i < count; i += 1)
            {
                const bool selected = set == 0 ? i < baseline_count : set == 1 ? i >= baseline_count :
                                      strncmp(filename(paths.gl_pathv[i]), sets[set], 11) == 0;
                if (selected && logs[i].row == row)
                {
                    if (logs[i].shard == 1)
                    {
                        first[first_count++] = normalized[i];
                    }
                    else
                    {
                        other[other_count++] = normalized[i];
                    }
                }
            }
            valid = valid && first_count == (set == 0 ? 3u : 1u) && other_count == (set == 0 ? 9u : 3u);
            const uint64_t a = costs_quantile(first, first_count, 50);
            const uint64_t b = costs_quantile(other, other_count, 50);
            char name[64];
            costs_row_name(row, name, sizeof(name));
            fprintf(summary, "%s\t%s\t%u\t%u\t%.1f\t%.1f\t%.1f\n", sets[set], name,
                    first_count, other_count, (double)a / 10.0, (double)b / 10.0, a > b ? (double)(a - b) / 10.0 : 0.0);
        }
    }
    fclose(summary);
    fprintf(stderr, "post-suite: %u logs, unique timestamped summaries and cleanup markers, complete samples, no post-suite errors: %s\n", count, valid ? "PASS" : "FAIL");
    return valid ? 0 : 1;
}

#ifndef POST_SUITE_INCLUDED
int main(int argc, char** argv)
{
    return post_main(argc, argv);
}
#endif
