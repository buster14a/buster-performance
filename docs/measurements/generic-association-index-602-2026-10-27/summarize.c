#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Samples Samples;
struct Samples
{
    double wall[32];
    double instructions[32];
    double rss[32];
    unsigned count;
};

static double median(const double* values, unsigned count)
{
    double ordered[32];
    for (unsigned i = 0; i < count; i += 1)
    {
        unsigned j = i;
        while (j != 0 && ordered[j - 1] > values[i])
        {
            ordered[j] = ordered[j - 1];
            j -= 1;
        }
        ordered[j] = values[i];
    }
    return count % 2 != 0 ? ordered[count / 2] : (ordered[count / 2 - 1] + ordered[count / 2]) / 2;
}

static double boundary(const double* values, unsigned count, int maximum)
{
    double result = values[0];
    for (unsigned i = 1; i < count; i += 1)
    {
        if (maximum ? values[i] > result : values[i] < result)
        {
            result = values[i];
        }
    }
    return result;
}

int main(int argc, char** argv)
{
    const char* variants[] = { "base", "head", "scalar" };
    const char* families[] = { "pointer_expression", "pointer_constant", "record_expression", "record_constant", "sqlite" };
    const unsigned sizes[] = { 256, 512, 1024, 2048, 4096, 8192, 10000 };
    Samples samples[3][5][7] = { 0 };
    FILE* file = argc == 2 ? fopen(argv[1], "r") : NULL;
    int valid = file != NULL;
    char line[4096];
    while (valid && fgets(line, sizeof(line), file) != NULL)
    {
        unsigned round, count;
        char variant[32], family[64];
        double wall;
        uint64_t instructions, enabled, running;
        long rss;
        int status;
        const int fields = sscanf(line, "%u,%31[^,],%63[^,],%u,%lf,%" SCNu64 ",%ld,%" SCNu64 ",%" SCNu64 ",%d",
                                  &round, variant, family, &count, &wall, &instructions, &rss, &enabled, &running, &status);
        if (fields == 10)
        {
            unsigned v = 0, f = 0, c = 0;
            while (v < 3 && strcmp(variants[v], variant) != 0)
            {
                v += 1;
            }
            while (f < 5 && strcmp(families[f], family) != 0)
            {
                f += 1;
            }
            while (c < 7 && sizes[c] != count)
            {
                c += 1;
            }
            c = count == 0 ? 0 : c;
            valid = v < 3 && f < 5 && c < 7 && status == 0 && enabled == running && running != 0 && round != 0;
            if (valid)
            {
                Samples* set = &samples[v][f][c];
                valid = set->count < 32;
                if (valid)
                {
                    const unsigned index = set->count++;
                    set->wall[index] = wall;
                    set->instructions[index] = (double)instructions;
                    set->rss[index] = (double)rss;
                }
            }
        }
        else
        {
            valid = line[0] < '0' || line[0] > '9';
        }
    }
    if (file != NULL)
    {
        fclose(file);
    }
    puts("| Family | A | Baseline ms | Indexed ms | Scalar ms | Speedup | Instructions reduction | Baseline/indexed RSS KiB |");
    puts("|---|---:|---:|---:|---:|---:|---:|---:|");
    for (unsigned f = 0; valid && f < 5; f += 1)
    {
        for (unsigned c = 0; valid && c < (f == 4 ? 1u : 7u); c += 1)
        {
            const Samples* base = &samples[0][f][c];
            const Samples* head = &samples[1][f][c];
            const Samples* scalar = &samples[2][f][c];
            valid = base->count == 6 && head->count == 6 && scalar->count == 6;
            if (valid)
            {
                const double b = median(base->wall, base->count);
                const double h = median(head->wall, head->count);
                const double s = median(scalar->wall, scalar->count);
                const double bi = median(base->instructions, base->count);
                const double hi = median(head->instructions, head->count);
                printf("| %s | %u | %.3f | %.3f | %.3f | %.2fx | %.2f%% | %.0f / %.0f |\n", families[f], f == 4 ? 0 : sizes[c],
                       b, h, s, b / h, 100 * (1 - hi / bi), median(base->rss, base->count), median(head->rss, head->count));
            }
        }
    }
    puts("\n| Family (A = 10,000, except SQLite) | Baseline wall range ms | Indexed wall range ms | Baseline instructions | Indexed instructions |");
    puts("|---|---:|---:|---:|---:|");
    for (unsigned f = 0; valid && f < 5; f += 1)
    {
        const unsigned c = f == 4 ? 0 : 6;
        const Samples* base = &samples[0][f][c];
        const Samples* head = &samples[1][f][c];
        printf("| %s | %.3f–%.3f | %.3f–%.3f | %.0f | %.0f |\n", families[f],
               boundary(base->wall, base->count, 0), boundary(base->wall, base->count, 1),
               boundary(head->wall, head->count, 0), boundary(head->wall, head->count, 1),
               median(base->instructions, base->count), median(head->instructions, head->count));
    }
    if (!valid)
    {
        fputs("incomplete or invalid measurement data\n", stderr);
    }
    return valid ? 0 : 1;
}
