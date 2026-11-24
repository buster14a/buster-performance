// Run from the measurement directory: cc -std=c11 -O2 summary.c -o /tmp/verifier-shares && /tmp/verifier-shares
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const char* const original[] = {
    "ir_check_rows", "ir_check_dominance", "ir_cfg_validated", "ir_check_graph", "tier1_liveness_validate_plan", "ir_check_shape",
};

static const char* const extra[] = {
    "ir_check_joins", "ir_verify", "ir_verify_path", "ir_verify_cfg", "ir_prepare_cfg", "ir_verify_dominance",
    "ir_check_dominance_view", "ir_check_operands", "ir_dominance_batch", "ir_lowered_ordered", "ir_check_batch",
    "ir_check_instruction", "ir_check_row_fields", "ir_extra_before", "ir_check_join", "ir_switch_unique",
    "ir_optimize_check_reachable", "ir_verified_build", "ssa_ir_verify_output",
};

enum { SYMBOLS = sizeof original / sizeof *original, SIX = SYMBOLS, EXPANDED, COLUMNS };

static FILE* open_run(const char* mode, const char* label, const char* workload, int round, const char* extension)
{
    char path[160];
    snprintf(path, sizeof path, "raw/%s-%s-%s-%d.%s", mode, label, workload, round, extension);
    FILE* stream = fopen(path, "r");
    if (stream == NULL)
    {
        perror(path);
        exit(EXIT_FAILURE);
    }
    return stream;
}

static void read_profile(const char* label, const char* workload, int round, double shares[COLUMNS])
{
    FILE* stream = open_run("profile", label, workload, round, "report");
    char line[4096];
    uint64_t total = 0;
    uint64_t periods[COLUMNS] = { 0 };
    while (fgets(line, sizeof line, stream))
    {
        uint64_t period;
        char symbol[256];
        if (sscanf(line, "# Event count (approx.): %" SCNu64, &period) == 1)
        {
            total = period;
        }
        else if (sscanf(line, " %*f%% %*u %" SCNu64 " [.] %255s", &period, symbol) == 2)
        {
            char* suffix = strstr(symbol, ".buster_split");
            if (suffix != NULL)
            {
                *suffix = '\0';
            }
            for (size_t i = 0; i < SYMBOLS; ++i)
            {
                if (strcmp(symbol, original[i]) == 0)
                {
                    periods[i] += period;
                    periods[SIX] += period;
                }
            }
            for (size_t i = 0; i < sizeof extra / sizeof *extra; ++i)
            {
                if (strcmp(symbol, extra[i]) == 0)
                {
                    periods[EXPANDED] += period;
                }
            }
        }
    }
    fclose(stream);
    if (total == 0 || periods[SIX] == 0)
    {
        fputs("Missing profile total or verifier samples\n", stderr);
        exit(EXIT_FAILURE);
    }
    periods[EXPANDED] += periods[SIX];
    for (size_t i = 0; i < COLUMNS; ++i)
    {
        shares[i] = 100.0 * periods[i] / total;
    }
}

static uint64_t middle(uint64_t a, uint64_t b, uint64_t c)
{
    uint64_t low = a < b ? a : b;
    uint64_t high = a > b ? a : b;
    return c < low ? low : c > high ? high : c;
}

static void counters(const char* label, const char* workload)
{
    const char* const names[] = { "cycles:u", "instructions:u" };
    uint64_t values[2][3] = { { 0 } };
    for (int run = 0; run < 3; ++run)
    {
        FILE* stream = open_run("stat", label, workload, 11 + run, "stat");
        char line[512], event[64];
        uint64_t value;
        while (fgets(line, sizeof line, stream))
        {
            if (sscanf(line, "%" SCNu64 ",,%63[^,]", &value, event) == 2)
            {
                for (size_t i = 0; i < 2; ++i)
                {
                    if (strcmp(event, names[i]) == 0)
                    {
                        values[i][run] = value;
                    }
                }
            }
        }
        fclose(stream);
    }
    for (size_t i = 0; i < 2; ++i)
    {
        const uint64_t* v = values[i];
        if (!v[0] || !v[1] || !v[2])
        {
            fputs("Missing performance counter\n", stderr);
            exit(EXIT_FAILURE);
        }
        printf("%s %s %s median %" PRIu64 "\n", workload, label, names[i], middle(v[0], v[1], v[2]));
    }
}

int main(void)
{
    const char* const workloads[] = { "sqlite", "lua" };
    const char* const labels[] = { "base", "final", "control" };
    for (size_t w = 0; w < 2; ++w)
    {
        for (size_t l = 0; l < 3; ++l)
        {
            if (l < 2)
            {
                double draws[2][COLUMNS];
                read_profile(labels[l], workloads[w], 11, draws[0]);
                read_profile(labels[l], workloads[w], 12, draws[1]);
                for (size_t i = 0; i < COLUMNS; ++i)
                {
                    const char* name = i < SYMBOLS ? original[i] : i == SIX ? "six" : "expanded";
                    printf("%s %s %s %.2f %.2f median %.2f\n", workloads[w], labels[l], name,
                           draws[0][i], draws[1][i], (draws[0][i] + draws[1][i]) / 2);
                }
            }
            counters(labels[l], workloads[w]);
        }
    }
    return 0;
}
