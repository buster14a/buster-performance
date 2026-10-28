// Original #653 first-unit/reused-cache receipt summary. Project-default contribution terms.
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static double field(const char* line, const char* key)
{
    const char* at = strstr(line, key);
    return at != 0 ? strtod(at + strlen(key), 0) : -1;
}

static int compare_double(const void* a, const void* b)
{
    const double left = *(const double*)a;
    const double right = *(const double*)b;
    return (left > right) - (left < right);
}

static double median(double* values, unsigned count)
{
    qsort(values, count, sizeof(*values), compare_double);
    return count % 2 ? values[count / 2] : (values[count / 2 - 1] + values[count / 2]) / 2;
}

int main(int argc, char** argv)
{
    bool success = argc > 1;
    puts("path\tunits\tfirst_work_ms\twarm_work_ms\tfirst_total_ms\twarm_total_ms\tfirst_file_opens\tlast_file_opens\tfirst_listings\tlast_listings\tfirst_entries\tfirst_skips\tdigest\tdiagnostic_digest");
    for (int arg = 1; arg < argc; arg += 1)
    {
        FILE* file = fopen(argv[arg], "r");
        bool valid = file != 0;
        unsigned count = 0;
        double work[1000];
        double total[1000];
        double first_work = 0;
        double first_total = 0;
        double first_opens = 0;
        double last_opens = 0;
        double first_listings = 0;
        double last_listings = 0;
        double first_entries = 0;
        double first_skips = 0;
        char digest[17] = { 0 };
        char diagnostic[17] = { 0 };
        char line[4096];
        while (file != 0 && fgets(line, sizeof(line), file) != 0)
        {
            if (line[0] == '{' && strstr(line, "\"unit\":") != 0)
            {
                valid = valid && count < 1000 && field(line, "\"unit\":") == count && field(line, "\"ok\":") == 1;
                const char* next_digest = strstr(line, "\"digest\":\"");
                const char* next_diagnostic = strstr(line, "\"diagnostic_digest\":\"");
                valid = valid && next_digest != 0 && next_diagnostic != 0;
                if (valid)
                {
                    next_digest += strlen("\"digest\":\"");
                    next_diagnostic += strlen("\"diagnostic_digest\":\"");
                    if (count == 0)
                    {
                        memcpy(digest, next_digest, 16);
                        memcpy(diagnostic, next_diagnostic, 16);
                    }
                    valid = memcmp(digest, next_digest, 16) == 0 && memcmp(diagnostic, next_diagnostic, 16) == 0;
                    work[count] = field(line, "\"work_ns\":") / 1e6;
                    total[count] = field(line, "\"total_ns\":") / 1e6;
                    last_opens = field(line, "\"file_opens\":");
                    last_listings = field(line, "\"listing_opens\":");
                    if (count == 0)
                    {
                        first_work = work[0];
                        first_total = total[0];
                        first_opens = last_opens;
                        first_listings = last_listings;
                        first_entries = field(line, "\"listing_entries\":");
                        first_skips = field(line, "\"directory_skips\":");
                    }
                    count += 1;
                }
            }
        }
        if (file != 0)
        {
            valid = fclose(file) == 0 && valid;
        }
        valid = valid && count > 1;
        if (valid)
        {
            printf("%s\t%u\t%.6f\t%.6f\t%.6f\t%.6f\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\t%s\t%s\n", argv[arg], count,
                   first_work, median(work + 1, count - 1), first_total, median(total + 1, count - 1), first_opens, last_opens,
                   first_listings, last_listings, first_entries, first_skips, digest, diagnostic);
        }
        else
        {
            fprintf(stderr, "invalid cache receipt: %s\n", argv[arg]);
        }
        success = success && valid;
    }
    return success ? 0 : 1;
}
