// Temporary measurement probes for #530. Never committed.
#ifndef PROBE530_INCLUDED
#define PROBE530_INCLUDED
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <x86intrin.h>

#define PROBE530_SLOTS 160
static uint64_t probe530_ticks[PROBE530_SLOTS];
static uint64_t probe530_counts[PROBE530_SLOTS];
static const char* probe530_names[PROBE530_SLOTS];
static uint64_t probe530_values[PROBE530_SLOTS];
static const char* probe530_value_names[PROBE530_SLOTS];
static int probe530_registered;
static const char* probe530_op_names[100] = {
"op00",
"op01",
"op02",
"op03",
"op04",
"op05",
"op06",
"op07",
"op08",
"op09",
"op10",
"op11",
"op12",
"op13",
"op14",
"op15",
"op16",
"op17",
"op18",
"op19",
"op20",
"op21",
"op22",
"op23",
"op24",
"op25",
"op26",
"op27",
"op28",
"op29",
"op30",
"op31",
"op32",
"op33",
"op34",
"op35",
"op36",
"op37",
"op38",
"op39",
"op40",
"op41",
"op42",
"op43",
"op44",
"op45",
"op46",
"op47",
"op48",
"op49",
"op50",
"op51",
"op52",
"op53",
"op54",
"op55",
"op56",
"op57",
"op58",
"op59",
"op60",
"op61",
"op62",
"op63",
"op64",
"op65",
"op66",
"op67",
"op68",
"op69",
"op70",
"op71",
"op72",
"op73",
"op74",
"op75",
"op76",
"op77",
"op78",
"op79",
"op80",
"op81",
"op82",
"op83",
"op84",
"op85",
"op86",
"op87",
"op88",
"op89",
"op90",
"op91",
"op92",
"op93",
"op94",
"op95",
"op96",
"op97",
"op98",
"op99"
};

static void probe530_report(void)
{
    if (getenv("PROBE530") == NULL)
    {
        return;
    }
    for (int i = 0; i < PROBE530_SLOTS; i += 1)
    {
        if (probe530_names[i] != NULL)
        {
            fprintf(stderr, "probe %-28s %12.3f Mticks %10llu calls\n", probe530_names[i], (double)probe530_ticks[i] / 1e6, (unsigned long long)probe530_counts[i]);
        }
    }
    for (int i = 0; i < PROBE530_SLOTS; i += 1)
    {
        if (probe530_value_names[i] != NULL)
        {
            fprintf(stderr, "count %-28s %12llu\n", probe530_value_names[i], (unsigned long long)probe530_values[i]);
        }
    }
}

static inline uint64_t probe530_now(void)
{
    if (!probe530_registered)
    {
        probe530_registered = 1;
        atexit(probe530_report);
    }
    return __rdtsc();
}

#define PROBE530_BEGIN(variable) uint64_t variable = probe530_now()
#define PROBE530_LAP(variable, slot, name) do { const uint64_t probe530_t = probe530_now(); probe530_ticks[slot] += probe530_t - (variable); probe530_counts[slot] += 1; probe530_names[slot] = (name); (variable) = probe530_t; } while (0)
#define PROBE530_COUNT(slot, name, amount) do { probe530_values[slot] += (amount); probe530_value_names[slot] = (name); } while (0)
#endif
