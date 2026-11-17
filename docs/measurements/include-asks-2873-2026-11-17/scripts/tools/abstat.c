// abstat DIRECTORY A B: reads ab.sh's counts (DIRECTORY/NAME-ROUND.csv, perf stat -x,: value,unit,event,...) of A and B
// and prints, for each event, each one's median and quartiles over the rounds, and the paired differences B - A by
// round: their median and quartiles, and how many are below zero.
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ROUNDS 4096
#define EVENTS 8

static int compare(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

static double quantile(double* sorted, int count, double q)
{
    const double at = q * (count - 1);
    const int low = (int)at;
    const int high = low + 1 < count ? low + 1 : low;
    return sorted[low] + (sorted[high] - sorted[low]) * (at - low);
}

static int read_counts(const char* directory, const char* name, int round, char events[EVENTS][64], double* values)
{
    char path[1024];
    snprintf(path, sizeof(path), "%s/%s-%d.csv", directory, name, round);
    FILE* file = fopen(path, "r");
    int count = 0;
    char line[512];
    while (file != 0 && fgets(line, sizeof(line), file) != 0 && count < EVENTS)
    {
        char* first = strchr(line, ',');
        char* second = first != 0 ? strchr(first + 1, ',') : 0;
        char* third = second != 0 ? strchr(second + 1, ',') : 0;
        if (line[0] != '#' && third != 0 && line[0] >= '0' && line[0] <= '9')
        {
            *third = 0;
            values[count] = strtod(line, 0);
            snprintf(events[count], 64, "%s", second + 1);
            count += 1;
        }
    }
    if (file != 0)
    {
        fclose(file);
    }
    return count;
}

int main(int argc, char** argv)
{
    int status = 1;
    if (argc == 4)
    {
        static double a[EVENTS][ROUNDS];
        static double b[EVENTS][ROUNDS];
        static double d[EVENTS][ROUNDS];
        char events[EVENTS][64] = { { 0 } };
        int rounds = 0;
        int event_count = 0;
        int reading = 1;
        while (reading && rounds < ROUNDS)
        {
            double av[EVENTS];
            double bv[EVENTS];
            const int ac = read_counts(argv[1], argv[2], rounds, events, av);
            const int bc = read_counts(argv[1], argv[3], rounds, events, bv);
            reading = ac != 0 && ac == bc;
            for (int e = 0; reading && e < ac; e += 1)
            {
                a[e][rounds] = av[e];
                b[e][rounds] = bv[e];
                d[e][rounds] = bv[e] - av[e];
            }
            event_count = reading ? ac : event_count;
            rounds += reading;
        }
        printf("%s: %d rounds, %s then %s\n", argv[1], rounds, argv[2], argv[3]);
        printf("%-18s %14s %14s %14s %24s %24s %8s\n", "event", argv[2], argv[3], "paired B-A", "quartiles", "percent of A", "B<A");
        for (int e = 0; rounds != 0 && e < event_count; e += 1)
        {
            int below = 0;
            for (int r = 0; r < rounds; r += 1)
            {
                below += d[e][r] < 0;
            }
            qsort(a[e], (size_t)rounds, sizeof(double), compare);
            qsort(b[e], (size_t)rounds, sizeof(double), compare);
            qsort(d[e], (size_t)rounds, sizeof(double), compare);
            const double am = quantile(a[e], rounds, 0.5);
            const double scale = am >= 1e6 ? 1e6 : 1;
            const char* unit = am >= 1e6 ? " M" : "";
            char quartiles[64];
            char percent[64];
            snprintf(quartiles, sizeof(quartiles), "[%.3f, %.3f]%s", quantile(d[e], rounds, 0.25) / scale, quantile(d[e], rounds, 0.75) / scale, unit);
            snprintf(percent, sizeof(percent), "%+.2f%% [%+.2f, %+.2f]", 100 * quantile(d[e], rounds, 0.5) / am, 100 * quantile(d[e], rounds, 0.25) / am, 100 * quantile(d[e], rounds, 0.75) / am);
            printf("%-18s %12.3f%s %12.3f%s %12.3f%s %24s %24s %5d/%d\n", events[e], am / scale, unit, quantile(b[e], rounds, 0.5) / scale, unit, quantile(d[e], rounds, 0.5) / scale, unit,
                   quartiles, percent, below, rounds);
        }
        status = rounds != 0 ? 0 : 1;
    }
    else
    {
        fprintf(stderr, "usage: abstat DIRECTORY A B\n");
    }
    return status;
}
