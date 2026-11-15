// analyze.c: the statistics of the 1216 runtime record, from time.sh's runs.txt on standard input.
//   cc -O2 -o analyze analyze.c -lm && ./analyze < runs/runs.txt
// For each program (lua, st) and metric (user cycles, task-clock, user instructions): the median of each cell's runs (a
// layout, a revision and a script); a Lua layout's total is the sum of its five scripts' medians. head against base by
// layout as 100 ln(head / base): their mean over the independent layouts, its standard error and 95% t interval, their
// median, standard deviation and range, and how many layouts head is slower at; for Lua by script too. The run-to-run
// spread within a layout is the median over cells of their runs' coefficient of variation. Runs that failed or lack a
// count are reported and left out.
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ANALYZE_LAYOUTS 64
#define ANALYZE_SCRIPTS 8
#define ANALYZE_RUNS 32

typedef enum Metric
{
    METRIC_CYCLES,
    METRIC_TASK_CLOCK,
    METRIC_INSTRUCTIONS,
    METRIC_COUNT,
} Metric;

static const char* const metric_names[METRIC_COUNT] = {
    "cycles",
    "task-clock",
    "instructions",
};

typedef struct Cell
{
    double values[METRIC_COUNT][ANALYZE_RUNS];
    int count;
} Cell;

typedef struct Program
{
    const char* name;
    const char* layout_name;
    int layouts[ANALYZE_LAYOUTS];
    int layout_count;
    char scripts[ANALYZE_SCRIPTS][32];
    int script_count;
    Cell cells[ANALYZE_LAYOUTS][2][ANALYZE_SCRIPTS];
} Program;

static Program programs[2] = {
    { .name = "lua", .layout_name = "order" },
    { .name = "st", .layout_name = "shift" },
};

static int compare_double(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

static double median(const double* values, int count)
{
    double sorted[ANALYZE_LAYOUTS];
    memcpy(sorted, values, (size_t)count * sizeof(double));
    qsort(sorted, (size_t)count, sizeof(double), compare_double);
    return count % 2 == 1 ? sorted[count / 2] : (sorted[count / 2 - 1] + sorted[count / 2]) / 2;
}

static double mean(const double* values, int count)
{
    double sum = 0;
    for (int i = 0; i < count; i += 1)
    {
        sum += values[i];
    }
    return sum / count;
}

static double deviation(const double* values, int count)
{
    double result = 0;
    if (count > 1)
    {
        const double m = mean(values, count);
        double sum = 0;
        for (int i = 0; i < count; i += 1)
        {
            sum += (values[i] - m) * (values[i] - m);
        }
        result = sqrt(sum / (count - 1));
    }
    return result;
}

// The two-sided 95% quantile of Student's t distribution with `df` degrees of freedom.
static double t_975(int df)
{
    static const double table[41] = {
        0,     12.706, 4.303, 3.182, 2.776, 2.571, 2.447, 2.365, 2.306, 2.262, 2.228, 2.201, 2.179, 2.160,
        2.145, 2.131,  2.120, 2.110, 2.101, 2.093, 2.086, 2.080, 2.074, 2.069, 2.064, 2.060, 2.056, 2.052,
        2.048, 2.045,  2.042, 2.040, 2.037, 2.035, 2.032, 2.030, 2.028, 2.026, 2.024, 2.023, 2.021,
    };
    double result = 1.960;
    if (df >= 1 && df <= 40)
    {
        result = table[df];
    }
    else if (df > 40 && df <= 60)
    {
        result = 2.000;
    }
    else if (df > 60 && df <= 120)
    {
        result = 1.980;
    }
    return result;
}

static int layout_index(Program* program, int layout)
{
    int result = -1;
    for (int i = 0; i < program->layout_count && result < 0; i += 1)
    {
        if (program->layouts[i] == layout)
        {
            result = i;
        }
    }
    if (result < 0 && program->layout_count < ANALYZE_LAYOUTS)
    {
        result = program->layout_count;
        program->layouts[result] = layout;
        program->layout_count += 1;
    }
    return result;
}

static int script_index(Program* program, const char* script)
{
    int result = -1;
    for (int i = 0; i < program->script_count && result < 0; i += 1)
    {
        if (strcmp(program->scripts[i], script) == 0)
        {
            result = i;
        }
    }
    if (result < 0 && program->script_count < ANALYZE_SCRIPTS && strlen(script) < sizeof(program->scripts[0]))
    {
        result = program->script_count;
        strcpy(program->scripts[result], script);
        program->script_count += 1;
    }
    return result;
}

static double cell_median(const Cell* cell, Metric metric)
{
    return cell->count > 0 ? median(cell->values[metric], cell->count) : NAN;
}

// A layout's value for one revision: the script's median, or with script -1 the sum of every script's.
static double layout_value(const Program* program, int layout, int revision, int script, Metric metric)
{
    double result = 0;
    if (script >= 0)
    {
        result = cell_median(&program->cells[layout][revision][script], metric);
    }
    else
    {
        for (int s = 0; s < program->script_count; s += 1)
        {
            result += cell_median(&program->cells[layout][revision][s], metric);
        }
    }
    return result;
}

static void report_ratios(const char* label, const double* ratios, int count)
{
    const double m = mean(ratios, count);
    const double sd = deviation(ratios, count);
    const double se = count > 1 ? sd / sqrt(count) : NAN;
    const double t = t_975(count - 1);
    int slower = 0;
    double low = ratios[0];
    double high = ratios[0];
    for (int i = 0; i < count; i += 1)
    {
        slower += ratios[i] > 0;
        low = ratios[i] < low ? ratios[i] : low;
        high = ratios[i] > high ? ratios[i] : high;
    }
    printf("  %-24s mean %+6.2f%% (se %.2f, 95%% t interval %+.2f..%+.2f), median %+6.2f%%, sd %.2f, head slower at %d/%d, range %+.2f..%+.2f\n",
           label, m, se, m - t * se, m + t * se, median(ratios, count), sd, slower, count, low, high);
}

static void report_program(const Program* program)
{
    int fewest = ANALYZE_RUNS;
    int most = 0;
    for (int l = 0; l < program->layout_count; l += 1)
    {
        for (int v = 0; v < 2; v += 1)
        {
            for (int s = 0; s < program->script_count; s += 1)
            {
                const int count = program->cells[l][v][s].count;
                fewest = count < fewest ? count : fewest;
                most = count > most ? count : most;
            }
        }
    }
    printf("%s: %d layouts (%ss), %d scripts, %d to %d runs per cell\n", program->name, program->layout_count, program->layout_name,
           program->script_count, fewest, most);
    printf("  %-6s %12s %12s %8s %9s %9s %8s %12s %12s %8s\n", program->layout_name, "base Mcyc", "head Mcyc", "100ln", "base ms", "head ms", "100ln",
           "base Minstr", "head Minstr", "100ln");
    for (int l = 0; l < program->layout_count; l += 1)
    {
        printf("  %-6d", program->layouts[l]);
        for (int m = 0; m < METRIC_COUNT; m += 1)
        {
            const double scale = m == METRIC_TASK_CLOCK ? 1.0 : 1e-6;
            const double base = layout_value(program, l, 0, -1, (Metric)m);
            const double head = layout_value(program, l, 1, -1, (Metric)m);
            printf(m == METRIC_TASK_CLOCK ? " %9.2f %9.2f %+8.2f" : " %12.1f %12.1f %+8.2f", base * scale, head * scale, 100 * log(head / base));
        }
        printf("\n");
    }
    for (int m = 0; m < METRIC_COUNT; m += 1)
    {
        double ratios[ANALYZE_LAYOUTS];
        double bases[ANALYZE_LAYOUTS];
        double heads[ANALYZE_LAYOUTS];
        for (int l = 0; l < program->layout_count; l += 1)
        {
            bases[l] = layout_value(program, l, 0, -1, (Metric)m);
            heads[l] = layout_value(program, l, 1, -1, (Metric)m);
            ratios[l] = 100 * log(heads[l] / bases[l]);
        }
        const double scale = m == METRIC_TASK_CLOCK ? 1.0 : 1e-6;
        double sorted_bases[ANALYZE_LAYOUTS];
        double sorted_heads[ANALYZE_LAYOUTS];
        memcpy(sorted_bases, bases, (size_t)program->layout_count * sizeof(double));
        memcpy(sorted_heads, heads, (size_t)program->layout_count * sizeof(double));
        qsort(sorted_bases, (size_t)program->layout_count, sizeof(double), compare_double);
        qsort(sorted_heads, (size_t)program->layout_count, sizeof(double), compare_double);
        const int last = program->layout_count - 1;
        printf("%s %s over layouts: base median %.2f (sd %.2f, %.2f..%.2f), head median %.2f (sd %.2f, %.2f..%.2f), usual layout base %.2f head %.2f\n",
               program->name, metric_names[m], median(bases, program->layout_count) * scale, deviation(bases, program->layout_count) * scale,
               sorted_bases[0] * scale, sorted_bases[last] * scale, median(heads, program->layout_count) * scale,
               deviation(heads, program->layout_count) * scale, sorted_heads[0] * scale, sorted_heads[last] * scale, bases[0] * scale, heads[0] * scale);
        report_ratios("head / base, total", ratios, program->layout_count);
        if (program->script_count > 1 && m != METRIC_INSTRUCTIONS)
        {
            for (int s = 0; s < program->script_count; s += 1)
            {
                for (int l = 0; l < program->layout_count; l += 1)
                {
                    ratios[l] = 100 * log(layout_value(program, l, 1, s, (Metric)m) / layout_value(program, l, 0, s, (Metric)m));
                }
                char label[64];
                snprintf(label, sizeof(label), "head / base, %s", program->scripts[s]);
                report_ratios(label, ratios, program->layout_count);
            }
        }
    }
    for (int m = 0; m < METRIC_COUNT; m += 1)
    {
        static double spreads[ANALYZE_LAYOUTS * 2 * ANALYZE_SCRIPTS];
        int count = 0;
        for (int l = 0; l < program->layout_count; l += 1)
        {
            for (int v = 0; v < 2; v += 1)
            {
                for (int s = 0; s < program->script_count; s += 1)
                {
                    const Cell* cell = &program->cells[l][v][s];
                    if (cell->count > 1)
                    {
                        spreads[count] = 100 * deviation(cell->values[m], cell->count) / mean(cell->values[m], cell->count);
                        count += 1;
                    }
                }
            }
        }
        if (count > 0)
        {
            qsort(spreads, (size_t)count, sizeof(double), compare_double);
            printf("%s %s run to run within a cell: median cv %.2f%%, largest %.2f%% (%d cells)\n", program->name, metric_names[m],
                   count % 2 == 1 ? spreads[count / 2] : (spreads[count / 2 - 1] + spreads[count / 2]) / 2, spreads[count - 1], count);
        }
    }
}

int main(void)
{
    char line[1024];
    int failed = 0;
    int incomplete = 0;
    int unplaced = 0;
    int runs = 0;
    while (fgets(line, sizeof(line), stdin) != NULL)
    {
        char name[16];
        char revision[16];
        char script[32];
        int layout = 0;
        int round = 0;
        int consumed = 0;
        if (sscanf(line, "%15s %d %d %15s %31s%n", name, &layout, &round, revision, script, &consumed) == 5)
        {
            double values[METRIC_COUNT] = { NAN, NAN, NAN };
            int status = -1;
            for (char* token = strtok(line + consumed, " \n"); token != NULL; token = strtok(NULL, " \n"))
            {
                char* equals = strchr(token, '=');
                if (equals != NULL)
                {
                    *equals = 0;
                    if (strcmp(token, "status") == 0)
                    {
                        status = atoi(equals + 1);
                    }
                    for (int m = 0; m < METRIC_COUNT; m += 1)
                    {
                        if (strcmp(token, metric_names[m]) == 0)
                        {
                            values[m] = strtod(equals + 1, NULL);
                        }
                    }
                }
            }
            Program* program = strcmp(name, "lua") == 0 ? &programs[0] : strcmp(name, "st") == 0 ? &programs[1] : NULL;
            const int v = strcmp(revision, "base") == 0 ? 0 : strcmp(revision, "head") == 0 ? 1 : -1;
            if (status != 0)
            {
                failed += 1;
            }
            else if (isnan(values[0]) || isnan(values[1]) || isnan(values[2]))
            {
                incomplete += 1;
            }
            else
            {
                const int l = program != NULL ? layout_index(program, layout) : -1;
                const int s = program != NULL ? script_index(program, script) : -1;
                Cell* cell = l >= 0 && s >= 0 && v >= 0 ? &program->cells[l][v][s] : NULL;
                if (cell != NULL && cell->count < ANALYZE_RUNS)
                {
                    for (int m = 0; m < METRIC_COUNT; m += 1)
                    {
                        cell->values[m][cell->count] = values[m];
                    }
                    cell->count += 1;
                    runs += 1;
                }
                else
                {
                    unplaced += 1;
                }
            }
        }
    }
    printf("runs %d, failed %d, without every count %d, unplaced %d\n", runs, failed, incomplete, unplaced);
    for (int p = 0; p < 2; p += 1)
    {
        if (programs[p].layout_count > 0)
        {
            report_program(&programs[p]);
        }
    }
    return failed != 0 || incomplete != 0 || unplaced != 0;
}
