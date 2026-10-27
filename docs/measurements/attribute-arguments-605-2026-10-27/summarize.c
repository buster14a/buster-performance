// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original median reader for campaign.c's CSV; warm-up repetition zero is excluded.
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Group Group;
struct Group
{
    char name[64];
    char mode[16];
    double wall[2][512];
    double checker[2][512];
    double rss[2][512];
    unsigned count[2];
};

static int compare(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

static double median(double* values, unsigned count)
{
    qsort(values, count, sizeof(*values), compare);
    return count != 0 ? values[count / 2] : 0;
}

int main(int argc, char** argv)
{
    static Group groups[64];
    unsigned group_count = 0;
    bool valid = argc > 1;
    for (int f = 1; valid && f < argc; f += 1)
    {
        FILE* input = fopen(argv[f], "r");
        valid = input != NULL;
        char line[4096];
        while (valid && fgets(line, sizeof(line), input) != NULL)
        {
            unsigned round, repetition;
            char tree[16], name[64], mode[16];
            double wall, checker, user, system, rss;
            int status;
            const int fields = sscanf(line, "%u,%u,%15[^,],%63[^,],%15[^,],%lf,%lf,%lf,%lf,%lf,%d",
                                      &round, &repetition, tree, name, mode, &wall, &checker, &user, &system, &rss, &status);
            if (fields == 11)
            {
                valid = status == 0;
                if (repetition != 0)
                {
                    unsigned group = 0;
                    while (group < group_count && (strcmp(groups[group].name, name) != 0 || strcmp(groups[group].mode, mode) != 0))
                    {
                        group += 1;
                    }
                    valid = valid && group < sizeof(groups) / sizeof(groups[0]);
                    if (valid)
                    {
                        if (group == group_count)
                        {
                            strcpy(groups[group].name, name);
                            strcpy(groups[group].mode, mode);
                            group_count += 1;
                        }
                        const unsigned t = strcmp(tree, "head") == 0;
                        const unsigned at = groups[group].count[t]++;
                        valid = at < 512;
                        if (valid)
                        {
                            groups[group].wall[t][at] = wall;
                            groups[group].checker[t][at] = checker;
                            groups[group].rss[t][at] = rss;
                        }
                    }
                }
            }
        }
        if (input != NULL)
        {
            fclose(input);
        }
    }
    puts("case,mode,runs_per_tree,base_wall_ms,head_wall_ms,wall_change_pct,base_checker_ms,head_checker_ms,checker_change_pct,base_rss_kb,head_rss_kb");
    for (unsigned g = 0; valid && g < group_count; g += 1)
    {
        Group* group = &groups[g];
        valid = group->count[0] != 0 && group->count[0] == group->count[1];
        const double bw = median(group->wall[0], group->count[0]);
        const double hw = median(group->wall[1], group->count[1]);
        const double bc = median(group->checker[0], group->count[0]);
        const double hc = median(group->checker[1], group->count[1]);
        printf("%s,%s,%u,%.6f,%.6f,%.3f,%.3f,%.3f,%.3f,%.0f,%.0f\n", group->name, group->mode, group->count[0], bw, hw,
               bw != 0 ? 100 * (hw / bw - 1) : 0, bc, hc, bc != 0 ? 100 * (hc / bc - 1) : 0,
               median(group->rss[0], group->count[0]), median(group->rss[1], group->count[1]));
    }
    return valid ? 0 : 1;
}
