// Original summary of the retained #643 raw observations. No timings are generated here.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <glob.h>

static int compare(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

static double median(double* values, unsigned count)
{
    qsort(values, count, sizeof(*values), compare);
    return count % 2 ? values[count / 2] : (values[count / 2 - 1] + values[count / 2]) / 2;
}

int main(int argc, char** argv)
{
    const char* root = argc == 2 ? argv[1] : ".";
    static const char* variants[] = { "main", "head", "again" };
    static const char* inputs[] = { "sqlite", "mainc" };
    char path[2048];
    char line[16384];
    for (unsigned input = 0; input < 2; input += 1)
    {
        for (unsigned variant = 0; variant < 3; variant += 1)
        {
            snprintf(path, sizeof(path), "%s/%s-%s-*.txt", root, inputs[input], variants[variant]);
            glob_t files = { 0 };
            glob(path, 0, 0, &files);
            double total[32], phase[32], directives[32], combined[32], instructions[32];
            unsigned n = 0;
            for (unsigned f = 0; f < files.gl_pathc; f += 1)
            {
                FILE* file = fopen(files.gl_pathv[f], "r");
                double wall = 0, instr = 0, dir = 0, loop = 0;
                while (fgets(line, sizeof(line), file))
                {
                    sscanf(line, " deferred %lf ms %*lf cycles/input token %*lf cycles/output token %lf instructions/input token", &wall, &instr);
                    sscanf(line, " read %*lf ms lex %*lf ms refine %*lf ms directives %lf ms main loop/setup %lf ms", &dir, &loop);
                }
                fclose(file);
                if (wall > 0 && instr > 0 && loop > 0)
                {
                    total[n] = wall;
                    phase[n] = loop;
                    directives[n] = dir;
                    combined[n] = dir + loop;
                    instructions[n] = instr;
                    n += 1;
                }
            }
            globfree(&files);
            const double med_total = median(total, n);
            const double med_loop = median(phase, n);
            const double med_dir = median(directives, n);
            const double med_instr = median(instructions, n);
            const double med_combined = median(combined, n);
            printf("%s %s: %u kernel observations, total %.3f [%.3f,%.3f] ms; loop %.3f [%.3f,%.3f] ms; directives %.3f ms; budget %.3f [%.3f,%.3f] ms; instructions/input %.2f\n",
                   inputs[input], variants[variant], n, med_total, total[0], total[n - 1], med_loop, phase[0], phase[n - 1], med_dir, med_combined, combined[0], combined[n - 1], med_instr);
        }
    }
    snprintf(path, sizeof(path), "%s/drivers.txt", root);
    FILE* file = fopen(path, "r");
    static double wall[3][3][1024], cycles[3][3][1024], instructions[3][3][1024], rss[3][3][1024];
    unsigned counts[3][3] = { 0 };
    unsigned failures = 0;
    while (fgets(line, sizeof(line), file))
    {
        unsigned run, list, placement, copy;
        char variant[64];
        double w, user, system, peak, minor, major, cyc, instr;
        int status;
        const int fields = sscanf(line, "run %u list %u %63s placement %u copy %u: %lf ms wall, %lf ms user, %lf ms system, %lf KB peak, %lf minor faults, %lf major, %lf user cycles, %lf instructions, status %d",
                                  &run, &list, variant, &placement, &copy, &w, &user, &system, &peak, &minor, &major, &cyc, &instr, &status);
        if (fields == 14 && list >= 1 && list <= 3)
        {
            unsigned v = 0;
            while (v < 3 && strcmp(variant, variants[v]))
            {
                v += 1;
            }
            if (v < 3)
            {
                const unsigned i = counts[list - 1][v]++;
                wall[list - 1][v][i] = w;
                cycles[list - 1][v][i] = cyc / 1e6;
                instructions[list - 1][v][i] = instr / 1e6;
                rss[list - 1][v][i] = peak;
                failures += status != 0;
            }
        }
    }
    fclose(file);
    for (unsigned list = 0; list < 3; list += 1)
    {
        for (unsigned v = 0; v < 3; v += 1)
        {
            const unsigned n = counts[list][v];
            const double w = median(wall[list][v], n);
            const double c = median(cycles[list][v], n);
            const double i = median(instructions[list][v], n);
            const double r = median(rss[list][v], n);
            printf("driver list%u %s: %u processes, wall %.3f [%.3f,%.3f] ms; cycles %.3f M; instructions %.3f M; peak %.0f KiB [%.0f,%.0f]\n",
                   list + 1, variants[v], n, w, wall[list][v][0], wall[list][v][n - 1], c, i, r, rss[list][v][0], rss[list][v][n - 1]);
        }
    }
    printf("driver failures: %u\n", failures);
    return failures != 0;
}
