// phases LOG CONFIG: per unit, from a log of bench.sh's runs (the deferred-post-lanes-447-2026-11-07 record's
// logs/post.log), the medians over the rounds of CONFIG's runs (e.g. post1+every:2) of the deferred reader's phases on
// one lane and on the configuration's lanes, in microseconds (ns/token times the unit's tokens), beside the unit's shape.
// One line a unit, whitespace-separated, in the order the log first names them:
//
//   unit tokens bodies body_tokens largest second top history_reads
//   one_us delta_us delta_pct walk1 walk2 pass1 pass2 span1 span2 merge1 merge2 rest1 rest2 copy1 copy2 moved slowdown
//   saving 1
//
// one_us is the reading on one lane; delta_us and delta_pct the configuration's lanes against it. walk is the bodies'
// walks summed over the lanes, pass the merge's pass, span the lanes' span, merge the whole merge, rest the phases after
// it, copy a lane's copy of the reader (ns/lane, in microseconds). For two lanes: moved is the body tokens a woken lane
// reads when the first lane reads the larger of the largest body and half of them; slowdown is how much slower a woken
// lane walks a token than the first lane, 1 + (walk2 - walk1) / (moved * walk1 / body_tokens); saving is the walks' time
// on one lane times moved / body_tokens (what an even second lane saves). The last column is 1, a constant for lsq.
//
//   cc -O2 -o phases phases.c && ./phases post.log post1+every:2 > phases-2.txt
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define UNITS 128
#define ROUNDS 8
#define FIELDS 18

typedef struct
{
    char name[96];
    double tokens, bodies, body_tokens, largest, second, top, history;
    double values[FIELDS][ROUNDS];
    unsigned rounds;
} Unit;

enum
{
    ONE,
    DELTA,
    PCT,
    WALK1,
    WALK2,
    PASS1,
    PASS2,
    SPAN1,
    SPAN2,
    MERGE1,
    MERGE2,
    REST1,
    REST2,
    COPY1,
    COPY2,
};

static Unit units[UNITS];
static unsigned unit_count;

static int compare(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

static double median(const double* values, unsigned count)
{
    double sorted[ROUNDS];
    memcpy(sorted, values, count * sizeof(double));
    qsort(sorted, count, sizeof(double), compare);
    return count == 0 ? 0 : count % 2 ? sorted[count / 2] : (sorted[count / 2 - 1] + sorted[count / 2]) / 2;
}

// The value of `key=` among the line's whitespace-separated fields, or 0.
static double field(const char* line, const char* key)
{
    const size_t length = strlen(key);
    double result = 0;
    for (const char* p = line; *p != 0; p += 1)
    {
        if ((p == line || p[-1] == ' ') && strncmp(p, key, length) == 0 && p[length] == '=')
        {
            result = strtod(p + length + 1, NULL);
            break;
        }
    }
    return result;
}

int main(int argc, char** argv)
{
    FILE* file = argc == 3 ? fopen(argv[1], "r") : NULL;
    if (file == NULL)
    {
        fprintf(stderr, "usage: phases LOG CONFIG\n");
        return 1;
    }
    char line[8192];
    char unit_name[96] = "";
    char config[64] = "";
    double tokens = 0;
    double row[FIELDS] = { 0 };
    Unit header = { { 0 } };
    while (fgets(line, sizeof line, file) != NULL)
    {
        line[strcspn(line, "\n")] = 0;
        char round[16];
        if (sscanf(line, "== round %15s unit %95s config %63s", round, unit_name, config) == 3)
        {
            memset(row, 0, sizeof row);
            continue;
        }
        if (strcmp(config, argv[2]) != 0)
        {
            continue;
        }
        if (strstr(line, "checker-deferred: file=") != NULL)
        {
            tokens = field(line, "tokens");
            header.tokens = tokens;
            header.bodies = field(line, "bodies");
            header.body_tokens = field(line, "body_tokens");
            header.largest = field(line, "largest_body");
            header.second = field(line, "second_body");
            header.top = field(line, "top_tokens");
            header.history = field(line, "history_reads");
        }
        else if (strstr(line, "merge's parts:") != NULL)
        {
            const int one = strstr(line, "lanes=1 ") != NULL;
            row[one ? PASS1 : PASS2] = field(line, "pass") * tokens / 1000;
        }
        else if (strstr(line, " active=") != NULL && strstr(line, "lanes_span=") != NULL)
        {
            const int one = strstr(line, "lanes=1 ") != NULL;
            row[one ? WALK1 : WALK2] = field(line, "walks") * tokens / 1000;
            row[one ? SPAN1 : SPAN2] = field(line, "lanes_span") * tokens / 1000;
            row[one ? MERGE1 : MERGE2] = field(line, "merge") * tokens / 1000;
            row[one ? REST1 : REST2] = field(line, "rest") * tokens / 1000;
            row[one ? COPY1 : COPY2] = field(line, "copy") / 1000;
        }
        else if (strstr(line, "absolute:") != NULL)
        {
            // deferred_1= and the configuration's deferred_N=, the fourth and fifth fields.
            const char* one = strstr(line, "deferred_1=");
            const char* many = one != NULL ? strstr(one + 11, "deferred_") : NULL;
            const char* equals = many != NULL ? strchr(many, '=') : NULL;
            if (one != NULL && equals != NULL)
            {
                const double a = strtod(one + 11, NULL);
                const double b = strtod(equals + 1, NULL);
                row[ONE] = a / 1000;
                row[DELTA] = (b - a) / 1000;
                row[PCT] = 100 * (b - a) / a;
                unsigned u = 0;
                while (u < unit_count && strcmp(units[u].name, unit_name) != 0)
                {
                    u += 1;
                }
                if (u == unit_count && unit_count < UNITS)
                {
                    unit_count += 1;
                    units[u] = header;
                    snprintf(units[u].name, sizeof units[u].name, "%s", unit_name);
                }
                Unit* unit = units + u;
                if (u < UNITS && unit->rounds < ROUNDS)
                {
                    for (unsigned f = 0; f < FIELDS; f += 1)
                    {
                        unit->values[f][unit->rounds] = row[f];
                    }
                    unit->rounds += 1;
                }
            }
        }
    }
    for (unsigned u = 0; u < unit_count; u += 1)
    {
        const Unit* unit = units + u;
        double m[FIELDS];
        for (unsigned f = 0; f < FIELDS; f += 1)
        {
            m[f] = median(unit->values[f], unit->rounds);
        }
        const double half = (double)(((unsigned long)unit->body_tokens + 1) / 2);
        const double first = unit->largest > half ? unit->largest : half;
        const double moved = unit->body_tokens - first;
        const double per_token = unit->body_tokens > 0 ? m[WALK1] / unit->body_tokens : 0;
        const double slowdown = moved > 0 && per_token > 0 ? 1 + (m[WALK2] - m[WALK1]) / (moved * per_token) : 0;
        printf("%s %.0f %.0f %.0f %.0f %.0f %.0f %.0f", unit->name, unit->tokens, unit->bodies, unit->body_tokens, unit->largest, unit->second,
               unit->top, unit->history);
        for (unsigned f = 0; f <= COPY2; f += 1)
        {
            printf(" %.2f", m[f]);
        }
        printf(" %.0f %.3f %.2f 1\n", moved, slowdown, m[WALK1] * moved / (unit->body_tokens > 0 ? unit->body_tokens : 1));
    }
    return 0;
}
