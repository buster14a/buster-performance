// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original synthetic receipts and independent acceptance/refusal fixtures.
#define BUSTER_THROUGHPUT_NO_MAIN
#include "throughput_summary.c"

static unsigned checks;
static unsigned failures;

static void test_expect(bool condition, const char* description)
{
    checks += 1;
    if (!condition)
    {
        failures += 1;
        fprintf(stderr, "FAIL fixture: %s\n", description);
    }
}

static void fixture_row(FILE* output, uint32_t round, uint32_t worker, const char* mutation)
{
    const uint32_t jobs = worker_counts[worker];
    const uint32_t tasks = jobs * 4;
    const bool changed = round == 0 && worker == 0;
    const bool failed = changed && strcmp(mutation, "failed-child") == 0;
    const uint64_t done = BUSTER_THROUGHPUT_BYTES * (tasks - (failed ? 1 : 0));
    const double wall = 4.0 / (1.0 + round * 0.1);
    const double user = tasks * 0.1;
    const double system = tasks * 0.01;
    const double coverage = changed && strcmp(mutation, "coverage-zero") == 0 ? 0 : changed && strcmp(mutation, "coverage-partial") == 0 ? 99.9 : 100;
    fprintf(output, "{\"label\":\"suite-throughput-r%u-j%u\",\"stage\":\"compile\",\"binary\":\"./compiler-native\",\"jobs\":%u,\"tasks\":%u,\"lanes\":1,\"scalar\":false,\"timing\":false,\"failures\":%u,",
            round, jobs, jobs, changed && strcmp(mutation, "tasks") == 0 ? tasks + 1 : tasks, failed ? 1 : 0);
    fprintf(output, "\"%s\":%.9f,\"user_s\":%.6f,\"system_s\":%.6f,\"maxrss_per_process_kb\":%u,\"minor_faults\":%u,\"major_faults\":0,\"voluntary_cs\":%u,\"involuntary_cs\":%u,",
            changed && strcmp(mutation, "missing-field") == 0 ? "wrong_wall" : "wall_s", wall, user, system, 100000 + tasks - 1, 10 * tasks + tasks * (tasks - 1) / 2, tasks, tasks * 2);
    fprintf(output, "\"input_bytes_per_task\":%" PRIu64 ",\"completed_bytes\":%" PRIu64 ",\"output_bytes\":%u,\"MB_per_s\":%.6f,\"CPU_seconds_per_MB\":%.9f,\"CPU_utilization\":%.5f,\"cpus\":[",
            BUSTER_THROUGHPUT_BYTES + (changed && strcmp(mutation, "source-bytes") == 0 ? 1 : 0), done,
            (tasks - (failed ? 1 : 0)) * 128 + (changed && strcmp(mutation, "output-bytes") == 0 ? 1 : 0), done / 1e6 / wall,
            (user + system) / (tasks * BUSTER_THROUGHPUT_BYTES / 1e6), (user + system) / wall);
    for (uint32_t cpu = 0; cpu < jobs; cpu += 1) fprintf(output, "%s%u", cpu != 0 ? "," : "", jobs == 1 ? 2 : strcmp(mutation, "duplicate-cpu") == 0 && worker == 1 && round == 0 ? 0 : cpu);
    fprintf(output, "],\"counter_errors\":%u,\"counter_min_running_pct\":%.5f,\"cycles_u\":%" PRIu64 ",\"instructions_u\":%" PRIu64 ",\"branches_u\":%" PRIu64 ",\"branch_misses_u\":%u,\"retired_ops_u\":%" PRIu64 ",\"raw_event\":\"\",\"raw_event_count\":0",
            changed && strcmp(mutation, "counter-error") == 0 ? 1 : 0, coverage,
            changed && strcmp(mutation, "zero-cycles") == 0 ? UINT64_C(0) : tasks * UINT64_C(80000000), tasks * UINT64_C(120000000), tasks * UINT64_C(10000000), tasks * 100,
            tasks * UINT64_C(200000000));
    if (changed && strcmp(mutation, "duplicate-key") == 0) fprintf(output, ",\"jobs\":1");
    fprintf(output, "}\n");
}

static bool fixture_children(const char* root, bool failed)
{
    bool valid = mkdir(root, 0755) == 0;
    for (uint32_t round = 0; valid && round < 5; round += 1)
    {
        for (uint32_t worker = 0; valid && worker < 5; worker += 1)
        {
            char folder[PATH_MAX];
            char path[PATH_MAX];
            const uint32_t jobs = worker_counts[worker];
            const uint32_t tasks = jobs * 4;
            const int folder_bytes = snprintf(folder, sizeof(folder), "%s/suite-throughput-r%u-j%u", root, round, jobs);
            const int path_bytes = snprintf(path, sizeof(path), "%s/children.tsv", folder);
            valid = folder_bytes > 0 && (size_t)folder_bytes < sizeof(folder) && path_bytes > 0 && (size_t)path_bytes < sizeof(path) && mkdir(folder, 0755) == 0;
            FILE* output = valid ? fopen(path, "wx") : NULL;
            valid = output != NULL && fputs(child_header, output) >= 0;
            for (uint32_t task = 0; valid && task < tasks; task += 1)
            {
                const bool failure = failed && round == 0 && worker == 0 && task == 0;
                valid = fprintf(output, "%u\t%u\t%u\t%u\t0.100000\t0.010000\t%u\t%u\t0\t1\t2\t%u\n", task, 1000 + task, jobs == 1 ? 2 : task % jobs,
                                failure ? 1 : 0, 100000 + task, 10 + task, failure ? 0 : 128) > 0;
            }
            if (output != NULL) valid = fclose(output) == 0 && valid;
        }
    }
    return valid;
}

int main(void)
{
    char root[] = "fixtures-672-XXXXXX";
    const bool ready = mkdtemp(root) != NULL;
    test_expect(ready, "private fixture root can be created without overwriting existing evidence");
    char good_children[PATH_MAX];
    char failed_children[PATH_MAX];
    snprintf(good_children, sizeof(good_children), "%s/good-children", root);
    snprintf(failed_children, sizeof(failed_children), "%s/failed-children", root);
    const bool children_ready = ready && fixture_children(good_children, false) && fixture_children(failed_children, true);
    test_expect(children_ready, "all original child rows are retained for positive and failed-child fixtures");
    const char* const cases[] = { "good", "missing-row", "duplicate-row", "failed-child", "coverage-zero", "coverage-partial", "counter-error", "zero-cycles", "duplicate-key", "missing-field", "duplicate-cpu", "tasks", "source-bytes", "output-bytes", "missing-children" };
    const int expected[] = { 0, 1, 1, 3, 2, 2, 2, 2, 1, 1, 3, 3, 3, 3, 3 };
    for (uint32_t c = 0; children_ready && c < sizeof(cases) / sizeof(cases[0]); c += 1)
    {
        char path[PATH_MAX];
        char report[PATH_MAX];
        char error[PATH_MAX];
        snprintf(path, sizeof(path), "%s/%s.jsonl", root, cases[c]);
        snprintf(report, sizeof(report), "%s/%s.report.tsv", root, cases[c]);
        snprintf(error, sizeof(error), "%s/%s.errors.txt", root, cases[c]);
        FILE* input = fopen(path, "wx");
        bool written = input != NULL;
        for (uint32_t round = 0; written && round < 5; round += 1)
        {
            for (uint32_t worker = 0; worker < 5; worker += 1)
            {
                if (round != 0 || worker != 0 || strcmp(cases[c], "missing-row") != 0) fixture_row(input, round, worker, cases[c]);
            }
        }
        if (written && strcmp(cases[c], "duplicate-row") == 0) fixture_row(input, 0, 0, "good");
        if (input != NULL) written = fclose(input) == 0 && written;
        FILE* out = fopen(report, "wx");
        FILE* err = fopen(error, "wx");
        test_expect(written && out != NULL && err != NULL, "fixture files are created");
        const char* child_root = strcmp(cases[c], "failed-child") == 0 ? failed_children : strcmp(cases[c], "missing-children") == 0 ? "absent-fixture-child-root" : good_children;
        const int result = written && out != NULL && err != NULL ? validate_file(path, child_root, 128, out, err) : -1;
        if (out != NULL) fclose(out);
        if (err != NULL) fclose(err);
        test_expect(result == expected[c], cases[c]);
        printf("fixture %s exit=%d expected=%d\n", cases[c], result, expected[c]);
    }
    const double values[5] = { 5, 1, 4, 2, 3 };
    FILE* output = tmpfile();
    bool median = output != NULL;
    if (median)
    {
        triple(output, values, 5);
        rewind(output);
        char text[128] = { 0 };
        median = fread(text, 1, sizeof(text) - 1, output) == strlen("3 [1, 5]") && strcmp(text, "3 [1, 5]") == 0;
        fclose(output);
    }
    test_expect(median, "five unsorted values produce exact independent median/minimum/maximum");
    uint64_t integer = 0;
    double decimal = 0;
    test_expect(!integer_text("18446744073709551616", &integer) && !integer_text("1e2", &integer) && !decimal_text("NaN", &decimal), "overflow/fractional-integer/nonfinite data are rejected");
    printf("throughput-summary-test: checks=%u failures=%u retained=%s\n", checks, failures, root);
    return failures == 0 ? 0 : 1;
}
