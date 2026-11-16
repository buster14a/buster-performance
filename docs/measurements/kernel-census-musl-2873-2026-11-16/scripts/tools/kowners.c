// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
//
// kowners: fresh memory by owner (buster14a/buster#2873, item 2), from kcensus's tables: each owner's faults, bytes first
// touched and the kernel's cycles for them (FAULT-MAPPINGS, kcensus's OUT-fault-mappings.tsv of the cycles' recordings),
// the stages that first touch it, and from IBS op samples (OPS, OUT-ops.tsv of reads.sh's recordings) the loads and
// stores that land in it in those stages and in the stages after the last of them: what of it is read again.
//
//   kowners FAULT-MAPPINGS OPS [RELABEL]
//
// OPS may be `-` for none. RELABEL, a file of `NAME<TAB>LABEL` lines, renames owners before they are summed (the musl
// census names a unit's reservations by their order, `an arena: reservation N`, and the census's order names them).
//
// Writes a line an owner, the most cycles first: owner, faults, MB, cycles (M), cycles a MB, the first-touching stages
// (each with its MB), loads and stores (estimated millions, a sample standing for its period's ops) in the first-touching
// stages, then in the stages after the last of them, and the last stage with a load.

#define _GNU_SOURCE
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define KOWNERS_LINE 4096
#define KOWNERS_OWNERS 256
#define KOWNERS_NAME 192

// The stages in the order a compile runs them; the emission's stages, which run a function at a time in turn, are one.
// `run` is all of a compile without laps (kcensus --units) between its start and its exit.
static const char* const kowners_stages[] = {
    "start", "setup", "lanes-start", "preprocess", "parse", "type-table", "check-input", "check-expressions", "check-declarations", "static-data",
    "check-program", "select", "backend-setup", "lower", "tier0", "emit-setup", "lanes", "branch-sizing", "encode", "unwind", "code-atoms",
    "debug", "publish-data", "object-build", "object-write", "runtime", "executable", "write", "release", "run", "exit",
};

#define KOWNERS_STAGES (sizeof(kowners_stages) / sizeof(kowners_stages[0]))

static uint32_t stage_index(const char* name)
{
    uint32_t found = KOWNERS_STAGES;
    for (uint32_t i = 0; i < KOWNERS_STAGES && found == KOWNERS_STAGES; i += 1)
    {
        found = strcmp(kowners_stages[i], name) == 0 ? i : found;
    }
    // The emission's stages as one: tier0 to code-atoms.
    const uint32_t tier0 = 14;
    const uint32_t atoms = 20;
    return found >= tier0 && found <= atoms ? tier0 : found;
}

typedef struct Owner Owner;
struct Owner
{
    char name[KOWNERS_NAME];
    double faults;
    double bytes;
    double cycles;
    double stage_bytes[KOWNERS_STAGES];
    double loads[KOWNERS_STAGES];
    double stores[KOWNERS_STAGES];
};

static Owner kowners[KOWNERS_OWNERS];
static uint32_t kowner_count;

typedef struct Relabel Relabel;
struct Relabel
{
    char name[KOWNERS_NAME];
    char label[KOWNERS_NAME];
};

static Relabel kowners_relabels[KOWNERS_OWNERS];
static uint32_t kowners_relabel_count;

static const char* relabel(const char* name)
{
    const char* label = name;
    for (uint32_t i = 0; i < kowners_relabel_count && label == name; i += 1)
    {
        label = strcmp(kowners_relabels[i].name, name) == 0 ? kowners_relabels[i].label : name;
    }
    return label;
}

static Owner* owner_of(const char* raw)
{
    const char* name = relabel(raw);
    Owner* owner = NULL;
    for (uint32_t i = 0; i < kowner_count && owner == NULL; i += 1)
    {
        owner = strcmp(kowners[i].name, name) == 0 ? &kowners[i] : NULL;
    }
    if (owner == NULL && kowner_count < KOWNERS_OWNERS)
    {
        owner = &kowners[kowner_count];
        memset(owner, 0, sizeof(*owner));
        snprintf(owner->name, sizeof(owner->name), "%s", name);
        kowner_count += 1;
    }
    return owner;
}

// The tab-separated fields of `line`, in place.
static uint32_t split(char* line, char** fields, uint32_t most)
{
    uint32_t count = 0;
    char* at = line;
    while (at != NULL && count < most)
    {
        fields[count] = at;
        count += 1;
        char* tab = strchr(at, '\t');
        if (tab != NULL)
        {
            *tab = 0;
            at = tab + 1;
        }
        else
        {
            at[strcspn(at, "\n")] = 0;
            at = NULL;
        }
    }
    return count;
}

static int compare_owners(const void* a, const void* b)
{
    const Owner* x = a;
    const Owner* y = b;
    return (x->cycles < y->cycles) - (x->cycles > y->cycles);
}

int main(int argc, char** argv)
{
    const bool usable = argc == 3 || argc == 4;
    FILE* faults = usable ? fopen(argv[1], "r") : NULL;
    const bool no_ops = usable && strcmp(argv[2], "-") == 0;
    FILE* ops = usable && !no_ops ? fopen(argv[2], "r") : NULL;
    FILE* relabels = argc == 4 ? fopen(argv[3], "r") : NULL;
    char line[KOWNERS_LINE];
    char* fields[16];
    while (relabels != NULL && fgets(line, sizeof(line), relabels) != NULL && kowners_relabel_count < KOWNERS_OWNERS)
    {
        if (split(line, fields, 16) >= 2)
        {
            snprintf(kowners_relabels[kowners_relabel_count].name, KOWNERS_NAME, "%s", fields[0]);
            snprintf(kowners_relabels[kowners_relabel_count].label, KOWNERS_NAME, "%s", fields[1]);
            kowners_relabel_count += 1;
        }
    }
    if (relabels != NULL)
    {
        fclose(relabels);
    }
    // FAULT-MAPPINGS: mapping, page, stage, cycles-a-compile, share, samples, count-a-compile, bytes-a-compile.
    bool header = true;
    while (faults != NULL && fgets(line, sizeof(line), faults) != NULL)
    {
        const uint32_t count = split(line, fields, 16);
        if (!header && count >= 8)
        {
            Owner* owner = owner_of(fields[0]);
            const uint32_t stage = stage_index(fields[2]);
            if (owner != NULL && stage < KOWNERS_STAGES)
            {
                owner->cycles += strtod(fields[3], NULL);
                owner->faults += strtod(fields[6], NULL);
                owner->bytes += strtod(fields[7], NULL);
                owner->stage_bytes[stage] += strtod(fields[7], NULL);
            }
        }
        header = false;
    }
    // OPS: mapping, stage, op, cycles-a-compile, share, samples, count-a-compile, bytes-a-compile.
    header = true;
    while (ops != NULL && fgets(line, sizeof(line), ops) != NULL)
    {
        const uint32_t count = split(line, fields, 16);
        if (!header && count >= 8)
        {
            Owner* owner = owner_of(fields[0]);
            const uint32_t stage = stage_index(fields[1]);
            if (owner != NULL && stage < KOWNERS_STAGES)
            {
                const double estimate = strtod(fields[6], NULL);
                if (strcmp(fields[2], "store") == 0)
                {
                    owner->stores[stage] += estimate;
                }
                else
                {
                    owner->loads[stage] += estimate;
                }
            }
        }
        header = false;
    }
    if (faults != NULL && (ops != NULL || no_ops))
    {
        qsort(kowners, kowner_count, sizeof(Owner), compare_owners);
        printf("owner\tfaults\tMB\tcycles-M\tcycles-a-MB\tfirst-touching stages (MB)\tloads-M there\tstores-M there\tloads-M after\tstores-M after\tlast stage loading\n");
        for (uint32_t i = 0; i < kowner_count; i += 1)
        {
            const Owner* owner = &kowners[i];
            char stages[1024] = "";
            size_t used = 0;
            uint32_t last_touch = 0;
            uint32_t last_load = KOWNERS_STAGES;
            double loads_there = 0;
            double stores_there = 0;
            double loads_after = 0;
            double stores_after = 0;
            for (uint32_t s = 0; s < KOWNERS_STAGES; s += 1)
            {
                if (owner->stage_bytes[s] >= 4096)
                {
                    used += (size_t)snprintf(stages + used, sizeof(stages) - used, "%s%s %.1f", used != 0 ? ", " : "", kowners_stages[s],
                                             owner->stage_bytes[s] / 1048576.0);
                    last_touch = s;
                }
                last_load = owner->loads[s] > 0 ? s : last_load;
            }
            for (uint32_t s = 0; s < KOWNERS_STAGES; s += 1)
            {
                const bool there = owner->stage_bytes[s] >= 4096;
                loads_there += there ? owner->loads[s] : 0;
                stores_there += there ? owner->stores[s] : 0;
                loads_after += s > last_touch ? owner->loads[s] : 0;
                stores_after += s > last_touch ? owner->stores[s] : 0;
            }
            printf("%s\t%.0f\t%.1f\t%.2f\t%.0f\t%s\t%.1f\t%.1f\t%.1f\t%.1f\t%s\n", owner->name, owner->faults, owner->bytes / 1048576.0, owner->cycles / 1e6,
                   owner->bytes > 0 ? owner->cycles / (owner->bytes / 1048576.0) : 0.0, stages, loads_there / 1e6, stores_there / 1e6, loads_after / 1e6,
                   stores_after / 1e6, last_load < KOWNERS_STAGES ? kowners_stages[last_load] : "-");
        }
    }
    if (faults != NULL)
    {
        fclose(faults);
    }
    if (ops != NULL)
    {
        fclose(ops);
    }
    return faults != NULL && (ops != NULL || no_ops) ? 0 : 2;
}
