// driver POST.tsv VALIDATE.tsv: per unit, the C driver's reading with --deferred-bodies under main (#1644's cand2 build,
// main's code), against the best measured reading. The driver reads a unit apart, on its rule's lanes, only where the rule
// gives 4 lanes or more (BUSTER_CHECK_DEFERRED_COMPILE_LANES), and otherwise in source order. Its reading is cand2+rule:8
// against source order in the same process (VALIDATE.tsv) where the rule gives 4 or more, and source order (0%) where
// not. The best is the least, against source order in the same process, of source order, deferred on one lane and every
// forced lane count of POST.tsv (main2 and post1 on 2, 3, 4 and 8 lanes); medians over the rounds. The gap is the
// driver's reading against the best, in points of the best's time. Both files are the deferred-post-lanes-447-2026-11-07
// record's tables (runs-post.tsv, runs-validate2.tsv).
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define UNITS 128
#define CONFIGS 16
#define ROUNDS 16

typedef struct
{
    char name[96];
    char config[CONFIGS][32];
    double vs_source[CONFIGS][ROUNDS];
    unsigned count[CONFIGS];
    unsigned configs;
    double one_vs_source[64];
    unsigned ones;
    unsigned active;
} Unit;

static Unit units[UNITS];
static unsigned unit_count;

static int compare(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

static double median(double* values, unsigned count)
{
    qsort(values, count, sizeof(double), compare);
    return count == 0 ? 1e9 : count % 2 ? values[count / 2] : (values[count / 2 - 1] + values[count / 2]) / 2;
}

static void read_runs(const char* path)
{
    FILE* file = fopen(path, "r");
    char line[4096];
    while (file != NULL && fgets(line, sizeof line, file) != NULL)
    {
        char* fields[64];
        unsigned n = 0;
        line[strcspn(line, "\n")] = 0;
        for (char* p = line; n < 64;)
        {
            fields[n] = p;
            n += 1;
            char* tab = strchr(p, '\t');
            if (tab == NULL)
            {
                break;
            }
            *tab = 0;
            p = tab + 1;
        }
        if (n < 36 || strcmp(fields[3], "ok") != 0)
        {
            continue;
        }
        unsigned u = 0;
        while (u < unit_count && strcmp(units[u].name, fields[1]) != 0)
        {
            u += 1;
        }
        if (u == unit_count)
        {
            unit_count += 1;
            snprintf(units[u].name, sizeof units[u].name, "%s", fields[1]);
        }
        Unit* unit = units + u;
        unsigned c = 0;
        while (c < unit->configs && strcmp(unit->config[c], fields[2]) != 0)
        {
            c += 1;
        }
        if (c == unit->configs)
        {
            unit->configs += 1;
            snprintf(unit->config[c], sizeof unit->config[c], "%s", fields[2]);
        }
        if (unit->count[c] < ROUNDS)
        {
            unit->vs_source[c][unit->count[c]] = strtod(fields[22], NULL);
            unit->count[c] += 1;
        }
        if (unit->ones < 64)
        {
            unit->one_vs_source[unit->ones] = strtod(fields[23], NULL);
            unit->ones += 1;
        }
        if (strcmp(fields[2], "cand2+rule:8") == 0)
        {
            unit->active = (unsigned)strtoul(fields[11], NULL, 10);
        }
    }
}

int main(int argc, char** argv)
{
    if (argc != 3)
    {
        fprintf(stderr, "usage: driver POST.tsv VALIDATE.tsv\n");
        return 1;
    }
    read_runs(argv[1]);
    read_runs(argv[2]);
    double forgone = 0;
    unsigned behind = 0;
    printf("%-30s %5s %9s %9s %9s %-16s %7s\n", "unit", "rule", "driver%", "one%", "best%", "best", "gap");
    for (unsigned u = 0; u < unit_count; u += 1)
    {
        Unit* unit = units + u;
        double best = 0;
        const char* best_name = "source";
        const double one = median(unit->one_vs_source, unit->ones);
        if (one < best)
        {
            best = one;
            best_name = "deferred 1";
        }
        double rule = 1e9;
        for (unsigned c = 0; c < unit->configs; c += 1)
        {
            const double value = median(unit->vs_source[c], unit->count[c]);
            if (strcmp(unit->config[c], "cand2+rule:8") == 0)
            {
                rule = value;
            }
            if (strstr(unit->config[c], "every") != NULL && value < best)
            {
                best = value;
                best_name = unit->config[c];
            }
        }
        const double driver = unit->active >= 4 ? rule : 0;
        const double gap = (100 + driver) / (100 + best) * 100 - 100;
        forgone += gap;
        behind += gap > 1;
        printf("%-30s %5u %+9.2f %+9.2f %+9.2f %-16s %7.2f\n", unit->name, unit->active, driver, one, best, best_name, gap);
    }
    printf("units=%u behind>1=%u forgone=%.1f\n", unit_count, behind, forgone);
    return 0;
}
