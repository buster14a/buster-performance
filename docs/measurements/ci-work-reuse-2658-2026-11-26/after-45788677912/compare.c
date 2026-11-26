// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Compare observed suite samples with the pinned collector's exact CPU normalization.
// Build: cc -std=c17 -O0 -Wall -Wextra -Werror -fno-strict-aliasing -I BUSTER_ROOT compare.c -o compare
// Run: compare TESTS BASELINE_LOG_DIR AFTER_LOG_DIR OUTPUT_DIR [CURRENT_COSTS_DIR [EXTRA_STEPS_TSV]]
#define main costs_cli_main
#include "tools/ci/costs.c"
#undef main
#include <glob.h>

typedef struct Extra Extra;
struct Extra
{
    uint64_t cpu_tenths;
    uint64_t in_process;
    uint64_t served;
    uint64_t children;
    double warnings;
    bool cpu;
    bool modes;
};

static const char* basename_of(const char* path)
{
    const char* slash = strrchr(path, '/');
    return slash != NULL ? slash + 1 : path;
}

static bool affected(CostsSlice title)
{
    return costs_starts(title, "Test the per-file jobs") ||
           costs_starts(title, "Test the semantic driver's diagnostics and emission against clang (part ");
}

static void extra_read(const CostsList* list, const char* path, Extra* extra)
{
    CostsText text = { 0 };
    if (!costs_read(path, &text))
    {
        costs_fatal("could not reread a log");
    }
    size_t offset = 0;
    uint32_t command = list->count;
    CostsSlice line;
    while (costs_next_line(text, &offset, &line))
    {
        int64_t stamp = 0;
        const size_t skip = costs_timestamp(line, &stamp);
        const CostsSlice content = costs_after(line, skip);
        if (costs_starts(content, "##[group]") || costs_starts(content, "::group::"))
        {
            char heading[BUSTER_COSTS_TITLE * 2];
            const size_t length = costs_unescape(costs_after(content, 9), heading, sizeof(heading));
            heading[length] = 0;
            command = list->count;
            for (uint32_t i = 0; i < list->count; i += 1)
            {
                const CostsSlice title = list->commands[i].title;
                if (length > title.length + 2 && memcmp(heading, title.data, title.length) == 0 &&
                    heading[title.length] == ':' && heading[title.length + 1] == ' ')
                {
                    double wall = 0;
                    double cpu = 0;
                    const char* timing = strstr(heading + title.length + 2, " in ");
                    if (timing != NULL && sscanf(timing + 4, "%lf s, %lf s of CPU", &wall, &cpu) == 2)
                    {
                        command = i;
                        extra[i].cpu = true;
                        extra[i].cpu_tenths = (uint64_t)(cpu * 10.0 + 0.5);
                    }
                }
            }
        }
        else if (command < list->count && costs_starts(content, "checker-driver: run modes:"))
        {
            char buffer[4096];
            snprintf(buffer, sizeof(buffer), "%.*s", (int)content.length, content.data);
            const char* end = strstr(buffer, " runs in this process");
            if (end != NULL)
            {
                const char* start = end;
                while (start > buffer && costs_digit(start[-1]))
                {
                    start -= 1;
                }
                unsigned long long in_process = 0, served = 0, children = 0, fixtures = 0;
                double warnings = 0;
                if (sscanf(start, "%llu runs in this process, %llu through the server, %llu as children; warning sweep: %llu fixtures, %lf s",
                           &in_process, &served, &children, &fixtures, &warnings) == 5)
                {
                    extra[command].modes = true;
                    extra[command].in_process = in_process;
                    extra[command].served = served;
                    extra[command].children = children;
                    extra[command].warnings = warnings;
                }
            }
        }
    }
    free(text.data);
}

static uint64_t factor_of(const CostsSpeeds* speeds, const char* cpu)
{
    uint64_t result = 0;
    for (uint32_t i = 0; i < speeds->count; i += 1)
    {
        result = strcmp(speeds->models[i].key, cpu) == 0 ? speeds->factors[i] : result;
    }
    return result;
}

static double normalize(uint64_t tenths, uint64_t factor, uint64_t slowest)
{
    return factor != 0 ? (double)((tenths * slowest + factor / 2) / factor) / 10.0 : -1;
}

static FILE* open_output(const char* directory, const char* name)
{
    char path[4096];
    snprintf(path, sizeof(path), "%s/%s", directory, name);
    FILE* file = fopen(path, "w");
    if (file == NULL)
    {
        costs_fatal("could not create an output");
    }
    return file;
}

static glob_t logs_in(const char* directory)
{
    char pattern[4096];
    snprintf(pattern, sizeof(pattern), "%s/*.log", directory);
    glob_t paths = { 0 };
    if (glob(pattern, 0, NULL, &paths) != 0)
    {
        costs_fatal("no input logs");
    }
    return paths;
}

// A sensitivity check with one fixed model-speed calibration for both deals. The raw post-change
// samples remain unchanged; these normalized arrays are inputs to the production schedule simulator,
// not replacement production tables. Vector shard-one extra steps are deliberately excluded, as in costs plan.
static bool normalized_plans(const CostsList* list, const CostsSpeeds* speeds, const CostsLog* logs, uint32_t count,
                             const char* output, const char* current_costs, const char* extra_path)
{
    const uint64_t memory = costs_logs_memory(logs, count);
    uint64_t first_extra[BUSTER_COSTS_ROWS] = { 0 };
    if (extra_path != NULL)
    {
        FILE* file = fopen(extra_path, "r");
        if (file == NULL)
        {
            costs_fatal("could not read extra-step timings");
        }
        char line[512];
        while (fgets(line, sizeof(line), file) != NULL)
        {
            char name[64];
            double raw = 0, normalized = 0;
            if (sscanf(line, "%63s\t%lf\t%lf", name, &raw, &normalized) == 3)
            {
                const uint32_t row = costs_row_named((CostsSlice){ name, strlen(name) });
                if (row < BUSTER_COSTS_ROWS && normalized >= 0)
                {
                    first_extra[row] = (uint64_t)(normalized * 1000.0 + 0.5);
                }
            }
        }
        fclose(file);
    }
    FILE* summary = open_output(output, "normalized-plans.tsv");
    fprintf(summary, "row\tdeal\tlongest_s\tmean_s\trunner_minutes\tshard1_s\tshard2_s\tshard3_s\tshard4_s\tfloor_s\n");
    bool valid = true;
    for (uint32_t row = BUSTER_COSTS_VECTOR * BUSTER_COSTS_SANITIZERS; valid && row < BUSTER_COSTS_ROWS; row += 1)
    {
        uint64_t* fresh = costs_allocate(list->count, sizeof(uint64_t));
        uint64_t* peaks = costs_allocate(list->count, sizeof(uint64_t));
        uint64_t* prior = costs_allocate(list->count, sizeof(uint64_t));
        uint64_t* prior_peaks = costs_allocate(list->count, sizeof(uint64_t));
        for (uint32_t i = 0; i < count; i += 1)
        {
            if (logs[i].row == row)
            {
                const uint64_t factor = factor_of(speeds, logs[i].cpu);
                valid = valid && factor != 0;
                for (uint32_t s = 0; factor != 0 && s < logs[i].sample_count; s += 1)
                {
                    const CostsSample* sample = logs[i].samples + s;
                    fresh[sample->command] = ((sample->tenths * speeds->slowest + factor / 2) / factor) * 100;
                    peaks[sample->command] = sample->peak;
                }
            }
        }
        char row_name[64];
        costs_row_name(row, row_name, sizeof(row_name));
        char path[4096];
        snprintf(path, sizeof(path), "%s/%s.costs", current_costs, row_name);
        uint32_t prior_jobs = 0;
        uint64_t prior_first = 0;
        uint64_t prior_memory = 0;
        valid = valid && costs_plan_costs(list, path, prior, prior_peaks, &prior_jobs, &prior_first, &prior_memory);
        const char* const names[] = {
            "current", "after-normalized", "current-plus-extra", "after-normalized-plus-extra",
            "current-aware-extra", "after-normalized-aware-extra",
        };
        for (uint32_t which = 0; valid && which < (first_extra[row] != 0 ? 6u : 2u); which += 1)
        {
            uint64_t times[4] = { 0 };
            CostsBuffer listing = { 0 };
            const bool current = (which & 1) == 0;
            const uint64_t deal_first = which >= 4 ? first_extra[row] : current ? prior_first : 0;
            const uint64_t score_first = which >= 2 ? first_extra[row] : 0;
            const CostsPlan plan = costs_plan(list, current ? prior : fresh, current ? prior_peaks : peaks,
                                             current ? prior_jobs : 4, current ? prior_memory : memory,
                                             deal_first, fresh, peaks, 4, 4, memory, score_first, times, &listing);
            fprintf(summary, "%s\t%s\t%.3f\t%.3f\t%.6f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\n",
                    row_name, names[which], (double)plan.longest / 1000.0,
                    (double)plan.total / 4000.0, (double)plan.total / 60000.0,
                    (double)times[0] / 1000.0, (double)times[1] / 1000.0,
                    (double)times[2] / 1000.0, (double)times[3] / 1000.0, (double)plan.floor / 1000.0);
            char name[128];
            snprintf(name, sizeof(name), "normalized-%s-%s-deal.txt", row_name, names[which]);
            FILE* file = open_output(output, name);
            fwrite(listing.data, 1, listing.length, file);
            fclose(file);
            free(listing.data);
        }
        free(fresh);
        free(peaks);
        free(prior);
        free(prior_peaks);
    }
    fclose(summary);
    return valid;
}

typedef struct SameTotal SameTotal;
struct SameTotal
{
    uint32_t matched;
    uint32_t unmatched;
    uint32_t samples;
    uint64_t before_wall;
    uint64_t after_wall;
    uint64_t before_cpu;
    uint64_t after_cpu;
};

// The primary measured comparison: only the same row, heading and exact CPU model.
// A heading's baseline is the nearest-rank median of its matching pre-change samples.
// Missing model matches remain explicit; normalization never fills them.
static void same_model(const CostsList* list, const CostsSpeeds* speeds,
                       const CostsLog* before, const glob_t* before_paths,
                       const CostsLog* after, const glob_t* after_paths, const char* output)
{
    Extra** baseline_extra = costs_allocate(before_paths->gl_pathc, sizeof(Extra*));
    for (uint32_t i = 0; i < before_paths->gl_pathc; i += 1)
    {
        baseline_extra[i] = costs_allocate(list->count, sizeof(Extra));
        extra_read(list, before_paths->gl_pathv[i], baseline_extra[i]);
    }
    const uint32_t models = speeds->count + 1;
    SameTotal* totals = costs_allocate((size_t)BUSTER_COSTS_ROWS * 2 * models, sizeof(SameTotal));
    uint64_t* walls = costs_allocate(before_paths->gl_pathc + 1, sizeof(uint64_t));
    uint64_t* cpus = costs_allocate(before_paths->gl_pathc + 1, sizeof(uint64_t));
    FILE* samples = open_output(output, "same-model.tsv");
    fprintf(samples, "row\tfamily\tcpu\theading\tbaseline_samples\tbaseline_median_wall_s\tafter_wall_s\twall_change_pct\tbaseline_median_cpu_s\tafter_cpu_s\tcpu_change_pct\n");
    for (uint32_t a = 0; a < after_paths->gl_pathc; a += 1)
    {
        const CostsLog* current = after + a;
        Extra* current_extra = costs_allocate(list->count, sizeof(Extra));
        extra_read(list, after_paths->gl_pathv[a], current_extra);
        uint32_t model = speeds->count;
        for (uint32_t m = 0; m < speeds->count; m += 1)
        {
            model = strcmp(current->cpu, speeds->models[m].key) == 0 ? m : model;
        }
        for (uint32_t s = 0; s < current->sample_count; s += 1)
        {
            const CostsSample* sample = current->samples + s;
            const uint32_t c = sample->command;
            if (!affected(list->commands[c].title))
            {
                continue;
            }
            const uint32_t family = costs_starts(list->commands[c].title, "Test the per-file jobs") ? 0 : 1;
            uint32_t count = 0;
            for (uint32_t b = 0; b < before_paths->gl_pathc; b += 1)
            {
                if (before[b].row == current->row && strcmp(before[b].cpu, current->cpu) == 0)
                {
                    for (uint32_t t = 0; t < before[b].sample_count; t += 1)
                    {
                        const CostsSample* other = before[b].samples + t;
                        if (other->command == c && other->complete && baseline_extra[b][c].cpu)
                        {
                            walls[count] = other->tenths / costs_held(list->commands + c, before[b].jobs);
                            cpus[count] = baseline_extra[b][c].cpu_tenths;
                            count += 1;
                        }
                    }
                }
            }
            const uint64_t current_wall = sample->tenths / costs_held(list->commands + c, current->jobs);
            const uint64_t current_cpu = current_extra[c].cpu_tenths;
            SameTotal* total = totals + ((size_t)current->row * 2 + family) * models + model;
            char row[64];
            costs_row_name(current->row, row, sizeof(row));
            fprintf(samples, "%s\t%s\t%s\t%.*s\t%u\t", row, family == 0 ? "files" : "driver",
                    current->cpu, (int)list->commands[c].title.length, list->commands[c].title.data, count);
            if (count != 0)
            {
                const uint64_t median_wall = costs_quantile(walls, count, 50);
                const uint64_t median_cpu = costs_quantile(cpus, count, 50);
                total->matched += 1;
                total->samples += count;
                total->before_wall += median_wall;
                total->after_wall += current_wall;
                total->before_cpu += median_cpu;
                total->after_cpu += current_cpu;
                fprintf(samples, "%.1f\t%.1f\t%.3f\t%.1f\t%.1f\t%.3f\n",
                        (double)median_wall / 10.0, (double)current_wall / 10.0,
                        median_wall != 0 ? 100.0 * ((double)current_wall / median_wall - 1.0) : 0.0,
                        (double)median_cpu / 10.0, (double)current_cpu / 10.0,
                        median_cpu != 0 ? 100.0 * ((double)current_cpu / median_cpu - 1.0) : 0.0);
            }
            else
            {
                total->unmatched += 1;
                fprintf(samples, "\t%.1f\t\t\t%.1f\t\n", (double)current_wall / 10.0, (double)current_cpu / 10.0);
            }
        }
        free(current_extra);
    }
    fclose(samples);
    FILE* summary = open_output(output, "same-model-summary.tsv");
    fprintf(summary, "row\tfamily\tcpu\tmatched_headings\tunmatched_headings\tbaseline_samples\tbaseline_median_wall_sum_s\tafter_wall_sum_s\twall_change_pct\tbaseline_median_cpu_sum_s\tafter_cpu_sum_s\tcpu_change_pct\n");
    for (uint32_t row = BUSTER_COSTS_VECTOR * BUSTER_COSTS_SANITIZERS; row < BUSTER_COSTS_ROWS; row += 1)
    {
        char name[64];
        costs_row_name(row, name, sizeof(name));
        for (uint32_t family = 0; family < 2; family += 1)
        {
            for (uint32_t m = 0; m < models; m += 1)
            {
                const SameTotal* total = totals + ((size_t)row * 2 + family) * models + m;
                if (total->matched + total->unmatched != 0)
                {
                    fprintf(summary, "%s\t%s\t%s\t%u\t%u\t%u\t%.1f\t%.1f\t%.3f\t%.1f\t%.1f\t%.3f\n",
                            name, family == 0 ? "files" : "driver", m < speeds->count ? speeds->models[m].key : "unseen model",
                            total->matched, total->unmatched, total->samples, (double)total->before_wall / 10.0,
                            (double)total->after_wall / 10.0, total->before_wall != 0 ? 100.0 * ((double)total->after_wall / total->before_wall - 1.0) : 0.0,
                            (double)total->before_cpu / 10.0, (double)total->after_cpu / 10.0,
                            total->before_cpu != 0 ? 100.0 * ((double)total->after_cpu / total->before_cpu - 1.0) : 0.0);
                }
            }
        }
    }
    fclose(summary);
    for (uint32_t i = 0; i < before_paths->gl_pathc; i += 1)
    {
        free(baseline_extra[i]);
    }
    free(baseline_extra);
    free(walls);
    free(cpus);
    free(totals);
}

int main(int argc, char** argv)
{
    if (argc < 5 || argc > 7)
    {
        fprintf(stderr, "usage: compare TESTS BASELINE_LOG_DIR AFTER_LOG_DIR OUTPUT_DIR [CURRENT_COSTS_DIR [EXTRA_STEPS_TSV]]\n");
        return 2;
    }
    CostsText inventory = { 0 };
    CostsList list = { 0 };
    if (!costs_load_list(argv[1], &inventory, &list))
    {
        return 2;
    }
    glob_t baseline_paths = logs_in(argv[2]);
    glob_t after_paths = logs_in(argv[3]);
    CostsLog* baseline = costs_allocate(baseline_paths.gl_pathc, sizeof(CostsLog));
    CostsLog* after = costs_allocate(after_paths.gl_pathc, sizeof(CostsLog));
    if (!costs_load_logs(&list, baseline_paths.gl_pathv, (uint32_t)baseline_paths.gl_pathc, baseline) ||
        !costs_load_logs(&list, after_paths.gl_pathv, (uint32_t)after_paths.gl_pathc, after))
    {
        return 2;
    }
    // Only the three pre-change runs train the model factors. After samples cannot fit their own improvement away.
    CostsSpeeds speeds = costs_speeds(baseline, (uint32_t)baseline_paths.gl_pathc);
    FILE* factors = open_output(argv[4], "cpu-factors.tsv");
    fprintf(factors, "cpu\tfactor\tslowest\trelative_time\n");
    for (uint32_t i = 0; i < speeds.count; i += 1)
    {
        fprintf(factors, "%s\t%llu\t%llu\t%.6f\n", speeds.models[i].key,
                (unsigned long long)speeds.factors[i], (unsigned long long)speeds.slowest,
                (double)speeds.factors[i] / (double)speeds.slowest);
    }
    fclose(factors);
    FILE* headings = open_output(argv[4], "headings.tsv");
    FILE* shards = open_output(argv[4], "shards.tsv");
    fprintf(headings, "phase\trow\tshard\tlog\tcpu\tfactor\theading\taffected\theld_cpus\twall_s\tcpu_s\tnormalized_wall_s\tnormalized_cpu_s\tpeak_mib\tin_process\tserved\tchildren\twarning_s\n");
    fprintf(shards, "phase\trow\tshard\tlog\tcpu\tfactor\tcommands\tsuite_s\tnormalized_suite_s\tjob_s_from_logs\n");
    bool valid = true;
    for (uint32_t phase = 0; phase < 2; phase += 1)
    {
        CostsLog* logs = phase == 0 ? baseline : after;
        glob_t* paths = phase == 0 ? &baseline_paths : &after_paths;
        uint32_t* seen = costs_allocate((size_t)BUSTER_COSTS_ROWS * list.count, sizeof(uint32_t));
        uint32_t row_shards[BUSTER_COSTS_ROWS] = { 0 };
        for (uint32_t i = 0; i < paths->gl_pathc; i += 1)
        {
            const char* name = basename_of(paths->gl_pathv[i]);
            const bool selected = phase != 0 || strncmp(name, "45779319802-", 12) == 0;
            const CostsLog* log = logs + i;
            if (selected && !log->build && log->row / BUSTER_COSTS_SANITIZERS == BUSTER_COSTS_VECTOR)
            {
                const uint64_t factor = factor_of(&speeds, log->cpu);
                valid = valid && factor != 0 && log->unknown == 0;
                row_shards[log->row] += 1;
                char row[64];
                costs_row_name(log->row, row, sizeof(row));
                fprintf(shards, "%s\t%s\t%u\t%s\t%s\t%llu\t%u\t%.1f\t%.1f\t%llu\n",
                        phase == 0 ? "before" : "after", row, log->shard, name, log->cpu,
                        (unsigned long long)factor, log->sample_count, (double)log->step_tenths / 10.0,
                        normalize(log->step_tenths, factor, speeds.slowest), (unsigned long long)costs_job_seconds(log));
                Extra* extra = costs_allocate(list.count, sizeof(Extra));
                extra_read(&list, paths->gl_pathv[i], extra);
                for (uint32_t s = 0; s < log->sample_count; s += 1)
                {
                    const CostsSample* sample = log->samples + s;
                    const uint32_t c = sample->command;
                    const uint32_t held = costs_held(list.commands + c, log->jobs);
                    seen[(size_t)log->row * list.count + c] += 1;
                    valid = valid && sample->complete && extra[c].cpu;
                    fprintf(headings, "%s\t%s\t%u\t%s\t%s\t%llu\t%.*s\t%u\t%u\t%.1f\t%.1f\t%.3f\t%.1f\t%llu\t",
                            phase == 0 ? "before" : "after", row, log->shard, name, log->cpu,
                            (unsigned long long)factor, (int)list.commands[c].title.length, list.commands[c].title.data,
                            (uint32_t)affected(list.commands[c].title), held, (double)sample->tenths / held / 10.0,
                            (double)extra[c].cpu_tenths / 10.0, normalize(sample->tenths, factor, speeds.slowest) / held,
                            normalize(extra[c].cpu_tenths, factor, speeds.slowest), (unsigned long long)sample->peak);
                    if (extra[c].modes)
                    {
                        fprintf(headings, "%llu\t%llu\t%llu\t%.3f",
                                (unsigned long long)extra[c].in_process, (unsigned long long)extra[c].served,
                                (unsigned long long)extra[c].children, extra[c].warnings);
                    }
                    else
                    {
                        fprintf(headings, "\t\t\t");
                    }
                    fputc('\n', headings);
                }
                free(extra);
            }
        }
        for (uint32_t row = BUSTER_COSTS_VECTOR * BUSTER_COSTS_SANITIZERS; row < BUSTER_COSTS_ROWS; row += 1)
        {
            valid = valid && row_shards[row] == 4;
            for (uint32_t c = 0; c < list.count; c += 1)
            {
                valid = valid && seen[(size_t)row * list.count + c] == 1;
            }
        }
        free(seen);
    }
    fclose(headings);
    fclose(shards);
    if (valid && argc >= 6)
    {
        valid = normalized_plans(&list, &speeds, after, (uint32_t)after_paths.gl_pathc, argv[4], argv[5], argc >= 7 ? argv[6] : NULL);
    }
    if (valid)
    {
        same_model(&list, &speeds, baseline, &baseline_paths, after, &after_paths, argv[4]);
    }
    fprintf(stderr, "compare: %u inventory headings; four complete shards per vector row before and after: %s\n", list.count, valid ? "PASS" : "FAIL");
    return valid ? 0 : 1;
}
