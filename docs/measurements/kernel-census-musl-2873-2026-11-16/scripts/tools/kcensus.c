// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
//
// kcensus: the kernel's cycles of recorded compiles by cause, and their faults by mapping and stage
// (buster14a/buster#2873, items 1 and 2). It reads, for each compile, its `--time-stages` report with the census patch's
// `time-lap` lines (CLOCK_MONOTONIC nanoseconds) and `perf script --ns` of its recording (kernel.sh: kernel cycles with
// kernel call chains and the first user frame; every minor fault with its address and page size; mmap and task events),
// and writes tables of sums over all of them.
//
//   kcensus [--names FILE] OUT STAGES SCRIPT [STAGES SCRIPT]...
//   kcensus --units [--names FILE] OUT SCRIPT
//
// With --units, SCRIPT is one recording of many compiles run one after another, each a process under its own waitall
// (#2873's musl census, a unit a process): a compile starts at its waitall's fork, and none has laps. A compile's start
// is then its exec to its first reservation of 64 GiB or more (the driver's first arena, which the stage clock
// precedes), its stage `run` until its process's exit record, and `exit` after it. OUT-units.tsv has each compile's own
// kernel cycles and faults, in the recording's order. Without --names, each fault in a reservation (a PROT_NONE
// mapping) is named by the reservation's order in its compile, `an arena: reservation N`.
//
// SCRIPT is a file of perf script's text, or `-` for standard input (once). --names gives mappings names: lines
// `START LENGTH NAME` (hexadecimal, as a reservation's mmap returned them; the compiles run without address-space
// randomization, so a mapping's place is the same in each), from maps.sh's strace. OUT is a prefix: OUT-causes.tsv,
// OUT-stages.tsv, OUT-faults.tsv (every fault of every compile), OUT-mappings.tsv (every mapping of every compile) and
// OUT-summary.txt.
//
// The compile's processes are the one whose command becomes `compiler` at its exec and the processes it starts (the exit
// helper). A sample's phase is `start` before the stage clock's start, the stage its time falls in, then `exit` after the
// last lap; every sample of the helper is `exit`. Its cause is the innermost way into the kernel on its stack (a fault
// inside a system call is a fault; a timer interrupt inside a fault is the interrupt), then perf's own work (the
// recording's: its events' output, its mmap records) and the stage clock's own (its marks' getrusage and /proc reads, its
// report) are set apart wherever they are on the stack. A fault's samples are those on its way through handle_mm_fault:
// the minor-fault event is written as handle_mm_fault ends, so a sample belongs to the next fault event of its thread.

#define _GNU_SOURCE
#include <ctype.h>
#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define KCENSUS_FRAMES 128
#define KCENSUS_NAME 192
#define KCENSUS_LINE 8192
#define KCENSUS_KEY 1024
#define KCENSUS_MAX_PIDS 16
#define KCENSUS_MAX_LAPS (1u << 17)

typedef struct Lap Lap;
struct Lap
{
    uint64_t end;
    char stage[64];
};

typedef struct Mapping Mapping;
struct Mapping
{
    uint64_t time;
    uint64_t start;
    uint64_t length;
    uint32_t pid;
    uint32_t ordinal;
    char prot[8];
    char name[KCENSUS_NAME];
    // Totals over its faults.
    uint64_t faults;
    uint64_t bytes;
    uint64_t cycles;
};

typedef struct Fault Fault;
struct Fault
{
    uint64_t time;
    uint64_t address;
    uint64_t ip;
    uint64_t page_bytes;
    uint64_t cycles;
    uint32_t samples;
    uint32_t pid;
    uint32_t tid;
    int32_t mapping;
    // Its reservation's label (--names), or null: then its mapping record's name.
    const char* label;
    bool kernel_ip;
    char ip_symbol[KCENSUS_NAME];
    char ip_dso[KCENSUS_NAME];
    // From a recording with the faults' call chains (faults.sh): the first frame of the stack that is not the C
    // library's (memset and the like), or empty.
    char caller[KCENSUS_NAME];
    char stage[64];
    // The kind its samples' stacks name most (do_huge_pmd_anonymous_page and the like), or empty.
    char kind[32];
};

typedef struct Sample Sample;
struct Sample
{
    uint64_t time;
    uint64_t period;
    uint32_t pid;
    uint32_t tid;
    uint32_t frames;
    // Whether the process had its compiler's image (after its exec) when sampled.
    bool compiler;
    char frame[KCENSUS_FRAMES][KCENSUS_NAME];
    bool user_frame[KCENSUS_FRAMES];
};

// A sum by a string key: an open-addressing table that grows.
typedef struct SumEntry SumEntry;
struct SumEntry
{
    char* key;
    uint64_t cycles;
    uint64_t samples;
    uint64_t count;
    uint64_t bytes;
};

typedef struct Sums Sums;
struct Sums
{
    SumEntry* entries;
    uint64_t capacity;
    uint64_t used;
};

typedef struct Op Op;
struct Op
{
    uint64_t time;
    uint64_t address;
    uint64_t period;
    uint32_t pid;
    bool store;
};

typedef struct Compile Compile;
struct Compile
{
    uint64_t lap_start;
    uint32_t lap_count;
    Lap* laps;
    uint32_t pids[KCENSUS_MAX_PIDS];
    uint32_t pid_count;
    uint32_t main_pid;
    // waitall's process, which forks the compile's and waits for it and its helper; the fork's time and the compile's
    // last process's exit.
    uint32_t parent_pid;
    uint64_t fork_time;
    uint64_t compile_end;
    // The compiler process's own exit record (--units: what follows it is the exit).
    uint64_t main_exit_time;
    // This compile's own kernel cycles (less perf's and the stage clock's) and its faults, for OUT-units.tsv.
    uint64_t own_cycles;
    uint64_t fault_bytes;
    Mapping* mappings;
    uint32_t mapping_count;
    uint32_t mapping_capacity;
    Fault* faults;
    uint32_t fault_count;
    uint32_t fault_capacity;
    Sample* samples;
    uint32_t sample_count;
    uint32_t sample_capacity;
    uint64_t exec_time;
    uint64_t end_time;
    // IBS op samples of the compile's processes that loaded or stored (reads.sh).
    Op* ops;
    uint32_t op_count;
    uint32_t op_capacity;
};

typedef struct Name Name;
struct Name
{
    uint32_t ordinal;
    uint64_t start;
    uint64_t length;
    char name[KCENSUS_NAME];
    // When the compile being read made it: the time of its own mmap record, the first of its process's records, in
    // order, that starts where it does (adjacent reservations merge into one area in the records, which still start at
    // the new one).
    uint64_t time;
    bool seen;
};

static Name* kcensus_names;
static uint32_t kcensus_name_count;

// The compile's large memsets and memmoves (memsets.sh, under gdb, the same addresses), in their order: a fault inside
// one of them is its caller's first touch.
typedef struct Fill Fill;
struct Fill
{
    uint64_t start;
    uint64_t length;
    char caller[KCENSUS_NAME];
};

static Fill* kcensus_fills;
static uint32_t kcensus_fill_count;

static void read_fills(const char* path)
{
    FILE* file = fopen(path, "r");
    char line[KCENSUS_LINE];
    uint32_t capacity = 0;
    while (file != NULL && fgets(line, sizeof(line), file) != NULL)
    {
        char kind[16];
        unsigned long long start = 0;
        unsigned long long length = 0;
        char caller[KCENSUS_NAME];
        if (sscanf(line, "%15[a-z]\t%llx\t%llx\t%191[^ \t\n]", kind, &start, &length, caller) == 4)
        {
            if (kcensus_fill_count == capacity)
            {
                capacity = capacity == 0 ? 256 : capacity * 2;
                kcensus_fills = realloc(kcensus_fills, capacity * sizeof(Fill));
            }
            Fill* fill = &kcensus_fills[kcensus_fill_count];
            fill->start = start;
            fill->length = length;
            snprintf(fill->caller, sizeof(fill->caller), "%s", caller);
            char* split = strstr(fill->caller, ".buster_split");
            if (split != NULL)
            {
                *split = 0;
            }
            kcensus_fill_count += 1;
        }
    }
    if (file != NULL)
    {
        fclose(file);
    }
}

static const char* fill_caller(uint64_t address)
{
    const char* caller = NULL;
    for (uint32_t i = 0; i < kcensus_fill_count && caller == NULL; i += 1)
    {
        caller = address >= kcensus_fills[i].start && address - kcensus_fills[i].start < kcensus_fills[i].length ? kcensus_fills[i].caller : NULL;
    }
    return caller;
}

static uint64_t hash_text(const char* text)
{
    uint64_t hash = 1469598103934665603ull;
    for (const char* at = text; *at != 0; at += 1)
    {
        hash = (hash ^ (uint8_t)*at) * 1099511628211ull;
    }
    return hash;
}

static SumEntry* sums_find(Sums* sums, const char* key)
{
    if (sums->used * 2 >= sums->capacity)
    {
        const uint64_t capacity = sums->capacity == 0 ? 1024 : sums->capacity * 2;
        SumEntry* entries = calloc(capacity, sizeof(SumEntry));
        for (uint64_t i = 0; i < sums->capacity; i += 1)
        {
            if (sums->entries[i].key != NULL)
            {
                uint64_t slot = hash_text(sums->entries[i].key) & (capacity - 1);
                while (entries[slot].key != NULL)
                {
                    slot = (slot + 1) & (capacity - 1);
                }
                entries[slot] = sums->entries[i];
            }
        }
        free(sums->entries);
        sums->entries = entries;
        sums->capacity = capacity;
    }
    uint64_t slot = hash_text(key) & (sums->capacity - 1);
    while (sums->entries[slot].key != NULL && strcmp(sums->entries[slot].key, key) != 0)
    {
        slot = (slot + 1) & (sums->capacity - 1);
    }
    if (sums->entries[slot].key == NULL)
    {
        sums->entries[slot].key = strdup(key);
        sums->used += 1;
    }
    return &sums->entries[slot];
}

static int sum_entry_compare(const void* a, const void* b)
{
    const SumEntry* x = a;
    const SumEntry* y = b;
    int result = (x->key == NULL) - (y->key == NULL);
    if (result == 0 && x->key != NULL)
    {
        result = (x->cycles < y->cycles) - (x->cycles > y->cycles);
        result = result != 0 ? result : strcmp(x->key, y->key);
    }
    return result;
}

static void sums_write(Sums* sums, const char* path, const char* header, double scale, uint32_t compiles)
{
    FILE* file = fopen(path, "w");
    if (file != NULL)
    {
        qsort(sums->entries, sums->capacity, sizeof(SumEntry), sum_entry_compare);
        uint64_t total = 0;
        for (uint64_t i = 0; i < sums->capacity && sums->entries[i].key != NULL; i += 1)
        {
            total += sums->entries[i].cycles;
        }
        fprintf(file, "%s\tcycles-a-compile\tshare\tsamples\tcount-a-compile\tbytes-a-compile\n", header);
        for (uint64_t i = 0; i < sums->capacity && sums->entries[i].key != NULL; i += 1)
        {
            const SumEntry* entry = &sums->entries[i];
            fprintf(file, "%s\t%.0f\t%.4f\t%" PRIu64 "\t%.1f\t%.0f\n", entry->key, (double)entry->cycles * scale / compiles,
                    total != 0 ? (double)entry->cycles / (double)total : 0.0, entry->samples, (double)entry->count / compiles,
                    (double)entry->bytes / compiles);
        }
        fclose(file);
        // The table is sorted now: the entries' order no longer follows their hashes.
        Sums sorted = { 0 };
        for (uint64_t i = 0; i < sums->capacity && sums->entries[i].key != NULL; i += 1)
        {
            SumEntry* entry = sums_find(&sorted, sums->entries[i].key);
            entry->cycles = sums->entries[i].cycles;
            entry->samples = sums->entries[i].samples;
            entry->count = sums->entries[i].count;
            entry->bytes = sums->entries[i].bytes;
            free(sums->entries[i].key);
        }
        free(sums->entries);
        *sums = sorted;
    }
}

static void sums_add(Sums* sums, const char* key, uint64_t cycles, uint64_t samples, uint64_t count, uint64_t bytes)
{
    SumEntry* entry = sums_find(sums, key);
    entry->cycles += cycles;
    entry->samples += samples;
    entry->count += count;
    entry->bytes += bytes;
}

// "4549079.833169766" as nanoseconds.
static uint64_t parse_time(const char* text)
{
    uint64_t seconds = 0;
    uint64_t fraction = 0;
    uint32_t digits = 0;
    const char* at = text;
    while (isdigit((unsigned char)*at))
    {
        seconds = seconds * 10 + (uint64_t)(*at - '0');
        at += 1;
    }
    if (*at == '.')
    {
        at += 1;
        while (isdigit((unsigned char)*at))
        {
            fraction = digits < 9 ? fraction * 10 + (uint64_t)(*at - '0') : fraction;
            digits += 1;
            at += 1;
        }
    }
    while (digits < 9)
    {
        fraction *= 10;
        digits += 1;
    }
    return seconds * 1000000000ull + fraction;
}

static bool read_laps(const char* path, Compile* compile)
{
    FILE* file = fopen(path, "r");
    char line[KCENSUS_LINE];
    compile->laps = calloc(KCENSUS_MAX_LAPS, sizeof(Lap));
    while (file != NULL && fgets(line, sizeof(line), file) != NULL)
    {
        char stage[64];
        unsigned long long nanoseconds = 0;
        if (strncmp(line, "time-lap-start\t", 15) == 0)
        {
            compile->lap_start = strtoull(line + 15, NULL, 10);
        }
        else if (sscanf(line, "time-lap\t%63s\t%llu", stage, &nanoseconds) == 2 && compile->lap_count < KCENSUS_MAX_LAPS)
        {
            Lap* lap = &compile->laps[compile->lap_count];
            lap->end = nanoseconds;
            snprintf(lap->stage, sizeof(lap->stage), "%s", stage);
            compile->lap_count += 1;
        }
    }
    if (file != NULL)
    {
        fclose(file);
    }
    return file != NULL && compile->lap_start != 0 && compile->lap_count != 0;
}

// The stage at `time`, by the laps: `start` before the clock's start, `exit` after the last lap.
static const char* stage_at(const Compile* compile, uint64_t time)
{
    const char* stage = "start";
    if (compile->lap_count == 0)
    {
        stage = time < compile->lap_start ? "start" : compile->main_exit_time != 0 && time >= compile->main_exit_time ? "exit" : "run";
    }
    else if (time >= compile->lap_start)
    {
        uint32_t low = 0;
        uint32_t high = compile->lap_count;
        while (low < high)
        {
            const uint32_t middle = low + (high - low) / 2;
            if (compile->laps[middle].end < time)
            {
                low = middle + 1;
            }
            else
            {
                high = middle;
            }
        }
        stage = low < compile->lap_count ? compile->laps[low].stage : "exit";
    }
    return stage;
}

static bool compile_has_pid(const Compile* compile, uint32_t pid)
{
    bool found = false;
    for (uint32_t i = 0; i < compile->pid_count; i += 1)
    {
        found |= compile->pids[i] == pid;
    }
    return found;
}

static void compile_add_pid(Compile* compile, uint32_t pid)
{
    if (!compile_has_pid(compile, pid) && compile->pid_count < KCENSUS_MAX_PIDS)
    {
        compile->pids[compile->pid_count] = pid;
        compile->pid_count += 1;
    }
}

// The next whitespace-separated token at *at, copied to `token`; returns false at the line's end.
static bool next_token(const char** at, char* token, size_t size)
{
    const char* text = *at;
    while (*text == ' ' || *text == '\t' || *text == '\n')
    {
        text += 1;
    }
    size_t length = 0;
    while (text[length] != 0 && text[length] != ' ' && text[length] != '\t' && text[length] != '\n')
    {
        length += 1;
    }
    const size_t copied = length < size - 1 ? length : size - 1;
    memcpy(token, text, copied);
    token[copied] = 0;
    *at = text + length;
    return length != 0;
}

// A MMAP2 record: `COMM PID/TID TIME: PERF_RECORD_MMAP2 PID/TID: [0xSTART(0xLENGTH) @ ...]: PROT NAME`.
static void parse_mmap(Compile* compile, const char* line, uint64_t time)
{
    const char* record = strstr(line, "PERF_RECORD_MMAP2 ");
    unsigned pid = 0;
    unsigned long long start = 0;
    unsigned long long length = 0;
    const char* bracket = record != NULL ? strchr(record, '[') : NULL;
    const char* close = bracket != NULL ? strstr(bracket, "]: ") : NULL;
    if (record != NULL && sscanf(record + 18, "%u/", &pid) == 1 && bracket != NULL && close != NULL &&
        sscanf(bracket, "[0x%llx(0x%llx)", &start, &length) == 2 && compile_has_pid(compile, pid))
    {
        if (compile->mapping_count == compile->mapping_capacity)
        {
            compile->mapping_capacity = compile->mapping_capacity == 0 ? 1024 : compile->mapping_capacity * 2;
            compile->mappings = realloc(compile->mappings, compile->mapping_capacity * sizeof(Mapping));
        }
        Mapping* mapping = &compile->mappings[compile->mapping_count];
        memset(mapping, 0, sizeof(*mapping));
        mapping->time = time;
        mapping->start = start;
        mapping->length = length;
        mapping->pid = pid;
        mapping->ordinal = compile->mapping_count;
        const char* at = close + 3;
        next_token(&at, mapping->prot, sizeof(mapping->prot));
        while (*at == ' ')
        {
            at += 1;
        }
        char file[KCENSUS_NAME];
        snprintf(file, sizeof(file), "%s", at);
        file[strcspn(file, "\n")] = 0;
        const char* base = strrchr(file, '/');
        const bool path = file[0] == '/' && file[1] != '/';
        const bool executable = path && strcmp(base + 1, "compiler") == 0;
        // The executable is not position-independent: its segments, and its .bss after them, are below 256 MB.
        if (executable)
        {
            snprintf(mapping->name, sizeof(mapping->name), "the executable: %s", strcmp(mapping->prot, "r-xp") == 0 ? "text" :
                                                                                 strcmp(mapping->prot, "rw-p") == 0 ? "data" : "read-only data");
        }
        else if (path)
        {
            snprintf(mapping->name, sizeof(mapping->name), "file %s", base + 1);
        }
        else if (strcmp(file, "//anon") == 0 && start < (256ull << 20))
        {
            snprintf(mapping->name, sizeof(mapping->name), "the executable: .bss");
        }
        else if (file[0] == '[')
        {
            snprintf(mapping->name, sizeof(mapping->name), "%s", file);
        }
        else
        {
            snprintf(mapping->name, sizeof(mapping->name), "anonymous, unnamed");
        }
        compile->mapping_count += 1;
    }
}

// The reservations' times in the compile just read: each label's own mmap record, in order.
static uint32_t names_time(const Compile* compile)
{
    uint32_t next = 0;
    for (uint32_t i = 0; i < kcensus_name_count; i += 1)
    {
        kcensus_names[i].seen = false;
    }
    for (uint32_t m = 0; m < compile->mapping_count && next < kcensus_name_count; m += 1)
    {
        const Mapping* mapping = &compile->mappings[m];
        if (mapping->pid == compile->main_pid && mapping->start == kcensus_names[next].start)
        {
            kcensus_names[next].time = mapping->time;
            kcensus_names[next].seen = true;
            next += 1;
        }
    }
    return next;
}

// --units without --names: the compile's reservations (its PROT_NONE mappings, in order) as names, each clipped to
// where the next older reservation above it starts (perf's record of a reservation merged with its neighbour above
// covers both), and the compile's start set by its first reservation of 64 GiB or more.
static void names_auto(Compile* compile)
{
    kcensus_name_count = 0;
    uint32_t capacity = 0;
    for (uint32_t m = 0; m < compile->mapping_count; m += 1)
    {
        const Mapping* mapping = &compile->mappings[m];
        const bool reservation = mapping->pid == compile->main_pid && mapping->time >= compile->exec_time && strcmp(mapping->prot, "---p") == 0;
        if (reservation)
        {
            uint64_t length = mapping->length;
            for (uint32_t i = 0; i < kcensus_name_count; i += 1)
            {
                const uint64_t above = kcensus_names[i].start;
                length = above > mapping->start && above - mapping->start < length ? above - mapping->start : length;
            }
            if (kcensus_name_count == capacity)
            {
                capacity = capacity == 0 ? 64 : capacity * 2;
                kcensus_names = realloc(kcensus_names, capacity * sizeof(Name));
            }
            Name* name = &kcensus_names[kcensus_name_count];
            name->ordinal = kcensus_name_count;
            name->start = mapping->start;
            name->length = length;
            name->time = mapping->time;
            name->seen = true;
            snprintf(name->name, sizeof(name->name), "an arena: reservation %u", kcensus_name_count + 1);
            kcensus_name_count += 1;
            if (compile->lap_start == 0 && mapping->length >= (1ull << 36))
            {
                compile->lap_start = mapping->time;
            }
        }
    }
    if (compile->lap_start == 0)
    {
        compile->lap_start = compile->exec_time;
    }
}

static const char* label_of(uint64_t address, uint64_t time)
{
    const char* label = NULL;
    uint64_t latest = 0;
    for (uint32_t i = 0; i < kcensus_name_count; i += 1)
    {
        const Name* name = &kcensus_names[i];
        const bool covers = name->seen && address >= name->start && address - name->start < name->length && name->time <= time && name->time >= latest;
        label = covers ? name->name : label;
        latest = covers ? name->time : latest;
    }
    return label;
}

static int32_t mapping_of(const Compile* compile, uint32_t pid, uint64_t address, uint64_t time)
{
    // The helper shares the address space: its faults are in the compiler's mappings.
    int32_t found = -1;
    for (uint32_t i = 0; i < compile->mapping_count; i += 1)
    {
        const Mapping* mapping = &compile->mappings[i];
        const bool covers = address >= mapping->start && address - mapping->start < mapping->length && mapping->time <= time;
        found = covers ? (int32_t)i : found;
    }
    (void)pid;
    return found;
}

// `        compiler 123/123 4549079.833169766:          1 minor-faults/...:     ADDR SYM (DSO) IP SYM (DSO) SIZE`
static void parse_fault(Compile* compile, const char* line, uint32_t pid, uint32_t tid, uint64_t time)
{
    const char* event = strstr(line, "minor-faults");
    const char* colon = event != NULL ? strstr(event, "/:") : NULL;
    const char* at = colon != NULL ? colon + 2 : NULL;
    char address[64];
    char address_symbol[KCENSUS_NAME];
    char address_dso[KCENSUS_NAME];
    char ip[64];
    char ip_symbol[KCENSUS_NAME];
    char ip_dso[KCENSUS_NAME];
    char size[32];
    // With call chains perf writes the instruction as the chain's first frame and the page size on a line after it:
    // then the line ends after the address's DSO, and read_script fills them in.
    const bool head = at != NULL && next_token(&at, address, sizeof(address)) && next_token(&at, address_symbol, sizeof(address_symbol)) &&
                      next_token(&at, address_dso, sizeof(address_dso));
    const bool whole = head && next_token(&at, ip, sizeof(ip)) && next_token(&at, ip_symbol, sizeof(ip_symbol)) && next_token(&at, ip_dso, sizeof(ip_dso)) &&
                       next_token(&at, size, sizeof(size));
    if (!whole)
    {
        snprintf(ip, sizeof(ip), "0");
        snprintf(ip_symbol, sizeof(ip_symbol), "?");
        snprintf(ip_dso, sizeof(ip_dso), "?");
        snprintf(size, sizeof(size), "?");
    }
    if (head)
    {
        if (compile->fault_count == compile->fault_capacity)
        {
            compile->fault_capacity = compile->fault_capacity == 0 ? 16384 : compile->fault_capacity * 2;
            compile->faults = realloc(compile->faults, compile->fault_capacity * sizeof(Fault));
        }
        Fault* fault = &compile->faults[compile->fault_count];
        memset(fault, 0, sizeof(*fault));
        fault->time = time;
        fault->pid = pid;
        fault->tid = tid;
        fault->address = strtoull(address, NULL, 16);
        fault->ip = strtoull(ip, NULL, 16);
        fault->kernel_ip = fault->ip >= 0xffff800000000000ull;
        fault->page_bytes = strcmp(size, "2M") == 0 ? (2ull << 20) : strcmp(size, "4K") == 0 ? 4096 : strcmp(size, "1G") == 0 ? (1ull << 30) : 0;
        snprintf(fault->ip_symbol, sizeof(fault->ip_symbol), "%s", ip_symbol);
        snprintf(fault->ip_dso, sizeof(fault->ip_dso), "%s", ip_dso);
        fault->mapping = mapping_of(compile, pid, fault->address, time);
        compile->fault_count += 1;
    }
}

static bool frame_is(const Sample* sample, uint32_t i, const char* name)
{
    return !sample->user_frame[i] && strcmp(sample->frame[i], name) == 0;
}

static bool frame_starts(const Sample* sample, uint32_t i, const char* prefix)
{
    return !sample->user_frame[i] && strncmp(sample->frame[i], prefix, strlen(prefix)) == 0;
}

static bool has_frame(const Sample* sample, const char* name)
{
    bool found = false;
    for (uint32_t i = 0; i < sample->frames && !found; i += 1)
    {
        found = frame_is(sample, i, name);
    }
    return found;
}

static bool has_frame_prefix(const Sample* sample, const char* prefix)
{
    bool found = false;
    for (uint32_t i = 0; i < sample->frames && !found; i += 1)
    {
        found = frame_starts(sample, i, prefix);
    }
    return found;
}

static bool has_user_frame_prefix(const Sample* sample, const char* prefix)
{
    bool found = false;
    for (uint32_t i = 0; i < sample->frames && !found; i += 1)
    {
        found = sample->user_frame[i] && strncmp(sample->frame[i], prefix, strlen(prefix)) == 0;
    }
    return found;
}

// The kernel function names of the entries into the kernel, innermost first wins.
typedef enum Entry
{
    ENTRY_NONE,
    ENTRY_FAULT,
    ENTRY_SYSCALL,
    ENTRY_TIMER,
    ENTRY_SYSVEC,
    ENTRY_IRQ,
    ENTRY_NMI,
    ENTRY_EXCEPTION,
    ENTRY_FORK,
} Entry;

static Entry frame_entry(const Sample* sample, uint32_t i)
{
    Entry entry = ENTRY_NONE;
    if (frame_is(sample, i, "asm_exc_page_fault") || frame_is(sample, i, "exc_page_fault"))
    {
        entry = ENTRY_FAULT;
    }
    else if (frame_starts(sample, i, "entry_SYSCALL_64") || frame_is(sample, i, "do_syscall_64"))
    {
        entry = ENTRY_SYSCALL;
    }
    else if (frame_is(sample, i, "asm_sysvec_apic_timer_interrupt") || frame_is(sample, i, "sysvec_apic_timer_interrupt"))
    {
        entry = ENTRY_TIMER;
    }
    else if (frame_starts(sample, i, "asm_sysvec_") || frame_starts(sample, i, "sysvec_"))
    {
        entry = ENTRY_SYSVEC;
    }
    else if (frame_is(sample, i, "asm_common_interrupt") || frame_is(sample, i, "common_interrupt"))
    {
        entry = ENTRY_IRQ;
    }
    else if (frame_is(sample, i, "asm_exc_nmi") || frame_is(sample, i, "exc_nmi"))
    {
        entry = ENTRY_NMI;
    }
    else if (frame_starts(sample, i, "asm_exc_") || frame_starts(sample, i, "exc_"))
    {
        entry = ENTRY_EXCEPTION;
    }
    else if (frame_starts(sample, i, "ret_from_fork"))
    {
        entry = ENTRY_FORK;
    }
    return entry;
}

typedef struct Pattern Pattern;
struct Pattern
{
    const char* frame;
    const char* name;
};

// Inner functions that name a system call where no __x64_sys_ frame does (inlined or tail-called).
static const Pattern kcensus_syscalls[] = {
    { "ksys_mmap_pgoff", "mmap" },
    { "vm_mmap_pgoff", "mmap" },
    { "__vm_munmap", "munmap" },
    { "do_mprotect_pkey", "mprotect" },
    { "do_madvise", "madvise" },
    { "ksys_read", "read" },
    { "ksys_pread64", "pread64" },
    { "ksys_write", "write" },
    { "ksys_pwrite64", "pwrite64" },
    { "do_sys_openat2", "openat" },
    { "vfs_fstatat", "newfstatat" },
    { "vfs_fstat", "fstat" },
    { "do_statx", "statx" },
    { "do_group_exit", "exit_group" },
    { "do_exit", "exit" },
    { "kernel_clone", "clone" },
    { "do_execveat_common.isra.0", "execve" },
    { "iterate_dir", "getdents64" },
    { "close_fd", "close" },
    { "do_brk_flags", "brk" },
    { "getrusage", "getrusage" },
    { "do_prlimit", "prlimit64" },
};

// A fault's kind by the handler on its stack.
static const Pattern kcensus_fault_kinds[] = {
    { "do_huge_pmd_anonymous_page", "anon-2m" },
    { "do_anonymous_page", "anon-4k" },
    { "do_huge_pmd_wp_page", "write-after-read-2m" },
    { "do_wp_page", "write-after-read-4k" },
    { "do_cow_fault", "file-copy" },
    { "do_read_fault", "file-read" },
    { "do_shared_fault", "file-shared" },
    { "filemap_map_pages", "file-read" },
    { "filemap_fault", "file-read" },
};

// What a sample's leaf is doing, the leaf-most match.
static const Pattern kcensus_parts[] = {
    { "clear_page", "clear" },
    { "clear_huge_page", "clear" },
    { "folio_zero_user", "clear" },
    { "clear_subpage", "clear" },
    { "process_huge_page", "clear" },
    { "clear_user", "clear" },
    { "rep_stos_alternative", "clear" },
    { "copy_page", "copy" },
    { "copy_folio_from_iter", "copy" },
    { "copy_page_from_iter", "copy" },
    { "copy_page_to_iter", "copy" },
    { "_copy_to_iter", "copy" },
    { "_copy_from_iter", "copy" },
    { "rep_movs_alternative", "copy" },
    { "copy_user", "copy" },
    { "_copy_to_user", "copy" },
    { "_copy_from_user", "copy" },
    { "memcpy", "copy" },
    { "mem_cgroup", "memcg" },
    { "__mem_cgroup", "memcg" },
    { "charge_memcg", "memcg" },
    { "try_charge", "memcg" },
    { "memcg", "memcg" },
    { "__memcg", "memcg" },
    { "refill_stock", "memcg" },
    { "obj_cgroup", "memcg" },
    { "get_page_from_freelist", "allocate" },
    { "__alloc_pages", "allocate" },
    { "__alloc_frozen_pages", "allocate" },
    { "alloc_pages", "allocate" },
    { "vma_alloc_folio", "allocate" },
    { "__folio_alloc", "allocate" },
    { "folio_alloc", "allocate" },
    { "rmqueue", "allocate" },
    { "__rmqueue", "allocate" },
    { "prep_new_page", "allocate" },
    { "post_alloc_hook", "allocate" },
    { "prep_compound_page", "allocate" },
    { "free_unref", "free" },
    { "free_pages", "free" },
    { "__free_pages", "free" },
    { "free_pcppages_bulk", "free" },
    { "free_frozen_pages", "free" },
    { "folios_put", "free" },
    { "__folio_put", "free" },
    { "release_pages", "free" },
    { "free_pages_and_swap_cache", "free" },
    { "__tlb_batch_free", "free" },
    { "tlb_finish_mmu", "free" },
    { "tlb_flush", "tlb" },
    { "flush_tlb", "tlb" },
    { "native_flush_tlb", "tlb" },
    { "zap_", "unmap" },
    { "unmap_", "unmap" },
    { "free_pgtables", "page-tables" },
    { "free_pgd_range", "page-tables" },
    { "__pte_alloc", "page-tables" },
    { "pte_alloc", "page-tables" },
    { "__pmd_alloc", "page-tables" },
    { "pgtable_trans_huge", "page-tables" },
    { "set_pmd_at", "page-tables" },
    { "folio_add_lru", "lru" },
    { "lru_add", "lru" },
    { "folio_batch_move_lru", "lru" },
    { "__folio_batch_add_and_move", "lru" },
    { "folio_add_new_anon_rmap", "rmap" },
    { "__folio_add", "rmap" },
    { "filemap_map_pages", "file-map" },
    { "next_uptodate_folio", "file-map" },
    { "filemap_", "file-map" },
    { "set_pte_range", "file-map" },
    { "xas_", "file-map" },
    { "lock_vma", "lock" },
    { "lock_mm_and_find_vma", "lock" },
    { "_raw_spin", "lock" },
    { "down_", "lock" },
    { "up_", "lock" },
    { "mas_", "vma-tree" },
    { "mt_", "vma-tree" },
    { "vma_", "vma" },
    { "__vma", "vma" },
    { "vms_", "vma" },
    { "do_vmi", "vma" },
};

// perf's own work on a recorded compile's stack: its events' output and records (not in an unrecorded compile).
static const char* const kcensus_perf_frames[] = {
    "__perf_sw_event",
    "___perf_sw_event",
    "perf_swevent_event",
    "perf_event_mmap",
    "perf_event_mmap_output",
    "perf_event_output_forward",
    "perf_prepare_sample",
    "perf_callchain",
    "perf_event_task_output",
    "perf_event_comm",
    "perf_event_exec",
    "perf_event_fork",
    "perf_event_task",
    "perf_iterate_sb",
    "perf_event_init_task",
    "inherit_task_group.isra.0",
    "perf_event_exit_task",
    "perf_event_namespaces",
    "__perf_event_overflow",
    "perf_event_nmi_handler",
    "x86_pmu_handle_irq",
    "amd_pmu_v2_handle_irq",
    "amd_pmu_handle_irq",
};

static const char* syscall_name(const Sample* sample, char* buffer, size_t size)
{
    const char* name = NULL;
    // Outermost first: the system call the user made, not one the kernel calls on its way.
    for (uint32_t i = sample->frames; i > 0 && name == NULL; i -= 1)
    {
        const uint32_t f = i - 1;
        if (frame_starts(sample, f, "__x64_sys_") || frame_starts(sample, f, "__do_sys_"))
        {
            const char* text = sample->frame[f] + (frame_starts(sample, f, "__x64_sys_") ? 10 : 9);
            snprintf(buffer, size, "%s", text);
            name = buffer;
        }
    }
    for (uint32_t i = sample->frames; i > 0 && name == NULL; i -= 1)
    {
        for (uint32_t p = 0; p < sizeof(kcensus_syscalls) / sizeof(kcensus_syscalls[0]) && name == NULL; p += 1)
        {
            name = frame_is(sample, i - 1, kcensus_syscalls[p].frame) ? kcensus_syscalls[p].name : NULL;
        }
    }
    if (name == NULL && (has_frame(sample, "syscall_exit_to_user_mode") || has_frame_prefix(sample, "exit_to_user_mode")))
    {
        name = "return-to-user";
    }
    return name != NULL ? name : "unknown";
}

static const char* sample_part(const Sample* sample, uint32_t through)
{
    const char* part = NULL;
    for (uint32_t i = 0; i < through && part == NULL; i += 1)
    {
        for (uint32_t p = 0; p < sizeof(kcensus_parts) / sizeof(kcensus_parts[0]) && part == NULL; p += 1)
        {
            part = frame_starts(sample, i, kcensus_parts[p].frame) ? kcensus_parts[p].name : NULL;
        }
    }
    return part != NULL ? part : "other";
}

static const char* fault_kind(const Sample* sample)
{
    const char* kind = NULL;
    for (uint32_t i = 0; i < sample->frames && kind == NULL; i += 1)
    {
        for (uint32_t p = 0; p < sizeof(kcensus_fault_kinds) / sizeof(kcensus_fault_kinds[0]) && kind == NULL; p += 1)
        {
            kind = frame_is(sample, i, kcensus_fault_kinds[p].frame) ? kcensus_fault_kinds[p].name : NULL;
        }
    }
    return kind;
}

static bool sample_is_perf(const Sample* sample)
{
    bool found = false;
    for (uint32_t i = 0; i < sample->frames && !found; i += 1)
    {
        for (uint32_t p = 0; p < sizeof(kcensus_perf_frames) / sizeof(kcensus_perf_frames[0]) && !found; p += 1)
        {
            found = frame_is(sample, i, kcensus_perf_frames[p]);
        }
    }
    return found;
}

// The stage clock's own work (--time-stages, which the recorded compiles need and the totals' don't run): its marks'
// getrusage and /proc/self/status reads, and its report.
static bool sample_is_clock(const Sample* sample)
{
    return has_user_frame_prefix(sample, "check_clock_") || has_frame(sample, "proc_pid_status") || has_frame_prefix(sample, "__do_sys_getrusage") ||
           has_frame(sample, "getrusage") || has_frame(sample, "__x64_sys_getrusage");
}

typedef struct Totals Totals;
struct Totals
{
    Sums causes;
    Sums stages;
    Sums fault_mappings;
    Sums fault_parts;
    Sums fault_touchers;
    Sums ops;
    uint64_t cycles;
    uint64_t perf_cycles;
    uint64_t clock_cycles;
    uint64_t compile_cycles;
    uint64_t faults;
    uint64_t fault_bytes;
};

// The fault a fault-path sample belongs to: the first fault event of its thread at or after it (the event is written as
// handle_mm_fault ends), or for a sample past handle_mm_fault on the way out, the last one before it.
static int32_t fault_of_sample(const Compile* compile, const Sample* sample, uint32_t* cursor)
{
    while (*cursor < compile->fault_count && compile->faults[*cursor].time < sample->time)
    {
        *cursor += 1;
    }
    const bool handling = has_frame(sample, "handle_mm_fault") || has_frame(sample, "__handle_mm_fault") || has_frame(sample, "lock_mm_and_find_vma") ||
                          has_frame(sample, "lock_vma_under_rcu");
    int32_t found = -1;
    if (handling)
    {
        for (uint32_t i = *cursor; i < compile->fault_count && found < 0; i += 1)
        {
            found = compile->faults[i].tid == sample->tid ? (int32_t)i : -1;
        }
    }
    else
    {
        for (uint32_t i = *cursor; i > 0 && found < 0; i -= 1)
        {
            found = compile->faults[i - 1].tid == sample->tid ? (int32_t)(i - 1) : -1;
        }
    }
    return found;
}

static void classify(Compile* compile, Totals* totals, FILE* samples_out, uint32_t compile_index)
{
    uint32_t cursor = 0;
    for (uint32_t s = 0; s < compile->sample_count; s += 1)
    {
        const Sample* sample = &compile->samples[s];
        const bool main_process = sample->pid == compile->main_pid;
        const bool helper = compile_has_pid(compile, sample->pid) && !main_process;
        const bool parent = sample->pid == compile->parent_pid && compile->parent_pid != 0;
        // The parent's part: its fork of the compile, then its wait and reaping; before the fork, the harness's own
        // commands (taskset, setarch, waitall's start), on the same process.
        // Before its exec the process is waitall's child; after its exit record perf names it by its number alone, so
        // the exec's time, not the command's name, says whose it is.
        const bool before_exec = sample->time < compile->exec_time;
        const char* stage = main_process && before_exec ? "start" :
                            main_process                      ? stage_at(compile, sample->time) :
                            helper                            ? "exit" :
                            parent && sample->time >= compile->fork_time && sample->time <= compile->compile_end ? "the parent's fork" :
                            parent && sample->time > compile->compile_end ? "the parent's wait" :
                            parent                            ? "the harness" :
                                                                "other tasks";
        const char* phase = strcmp(stage, "start") == 0 ? "start" :
                            strcmp(stage, "exit") == 0  ? "exit" :
                            main_process                ? "compile" :
                                                          stage;
        if (main_process && before_exec)
        {
            phase = "start";
        }
        // The innermost entry.
        Entry entry = ENTRY_NONE;
        uint32_t entry_frame = sample->frames;
        for (uint32_t i = 0; i < sample->frames && entry == ENTRY_NONE; i += 1)
        {
            entry = frame_entry(sample, i);
            entry_frame = entry != ENTRY_NONE ? i : entry_frame;
        }
        char buffer[KCENSUS_NAME];
        const char* cause = "unattributed";
        const char* detail = "";
        const char* part = sample_part(sample, entry_frame);
        if (sample_is_perf(sample))
        {
            cause = "perf's own";
            detail = "the recording";
            totals->perf_cycles += sample->period;
        }
        else if (sample_is_clock(sample))
        {
            cause = "the stage clock's own";
            detail = "--time-stages";
            totals->clock_cycles += sample->period;
        }
        else if (entry == ENTRY_FAULT)
        {
            cause = "page fault";
            const int32_t f = fault_of_sample(compile, sample, &cursor);
            const char* kind = fault_kind(sample);
            if (f >= 0)
            {
                Fault* fault = &compile->faults[f];
                fault->cycles += sample->period;
                fault->samples += 1;
                if (kind != NULL && fault->kind[0] == 0)
                {
                    snprintf(fault->kind, sizeof(fault->kind), "%s", kind);
                }
            }
            detail = kind != NULL ? kind : "entry and return";
        }
        else if (entry == ENTRY_SYSCALL)
        {
            cause = "system call";
            detail = syscall_name(sample, buffer, sizeof(buffer));
            // What the call was for, where its stack says.
            const bool populate = has_frame(sample, "__mm_populate") || has_frame(sample, "populate_vma_page_range");
            const bool object = has_frame_prefix(sample, "shmem_") || has_frame(sample, "do_truncate") || has_frame_prefix(sample, "btrfs_");
            if (strcmp(detail, "mmap") == 0)
            {
                detail = populate ? "mmap: a source or header file, populated" : "mmap: a reservation";
            }
            else if (strcmp(detail, "openat") == 0 || strcmp(detail, "close") == 0)
            {
                detail = object ? (strcmp(detail, "openat") == 0 ? "openat: the object" : "close: the object") :
                                  (strcmp(detail, "openat") == 0 ? "openat: the include search" : "close: the include search");
            }
            else if (strcmp(detail, "pwrite64") == 0 || strcmp(detail, "write") == 0)
            {
                detail = object ? "pwrite64: the object" : detail;
            }
        }
        else if (entry == ENTRY_TIMER)
        {
            cause = "interrupt";
            detail = "timer";
        }
        else if (entry == ENTRY_SYSVEC)
        {
            cause = "interrupt";
            detail = sample->frame[entry_frame];
        }
        else if (entry == ENTRY_IRQ)
        {
            cause = "interrupt";
            detail = "device";
        }
        else if (entry == ENTRY_NMI)
        {
            cause = "perf's own";
            detail = "nmi";
            totals->perf_cycles += sample->period;
        }
        else if (entry == ENTRY_EXCEPTION)
        {
            cause = "exception";
            detail = sample->frame[entry_frame];
        }
        else if (entry == ENTRY_FORK)
        {
            cause = "a new task's start";
            detail = "ret_from_fork";
        }
        else if (sample->frames > 0 && sample->user_frame[0])
        {
            // No kernel frame: the counter's interrupt came as the kernel returned to the user (its skid). A fault of
            // this thread just before it is the way in it most likely returns from.
            const int32_t f = fault_of_sample(compile, sample, &cursor);
            const bool recent = f >= 0 && sample->time - compile->faults[f].time < 20000 && compile->faults[f].time <= sample->time;
            cause = recent ? "page fault" : "return to the user";
            detail = recent ? "entry and return" : "a sample past the kernel's end";
            if (recent)
            {
                compile->faults[f].cycles += sample->period;
                compile->faults[f].samples += 1;
            }
        }
        // The address space's teardown, wherever it runs (the helper's exit, the process's own, an exec's old one).
        if (strcmp(cause, "system call") == 0 && has_frame(sample, "exit_mmap"))
        {
            cause = "the address space's teardown";
            detail = helper ? "in the exit helper" : "in the process";
        }
        totals->cycles += sample->period;
        const bool own = strcmp(cause, "perf's own") == 0 || strcmp(cause, "the stage clock's own") == 0;
        totals->compile_cycles += own || !(main_process || helper) ? 0 : sample->period;
        compile->own_cycles += own || !(main_process || helper) ? 0 : sample->period;
        char key[KCENSUS_KEY];
        snprintf(key, sizeof(key), "%s\t%s\t%s\t%s", phase, cause, detail, part);
        sums_add(&totals->causes, key, sample->period, 1, 0, 0);
        snprintf(key, sizeof(key), "%s\t%s\t%s", stage, cause, strcmp(cause, "page fault") == 0 || strcmp(cause, "system call") == 0 ? detail : "");
        sums_add(&totals->stages, key, sample->period, 1, 0, 0);
        if (samples_out != NULL)
        {
            fprintf(samples_out, "%u\t%" PRIu64 "\t%u\t%s\t%s\t%s\t%s\t%" PRIu64 "\t%s\n", compile_index, sample->time, sample->pid, stage, cause, detail, part,
                    sample->period, sample->frames > 0 ? sample->frame[0] : "");
        }
    }
}

static void account_faults(Compile* compile, Totals* totals, FILE* faults_out, FILE* mappings_out, uint32_t compile_index)
{
    for (uint32_t i = 0; i < compile->fault_count; i += 1)
    {
        Fault* fault = &compile->faults[i];
        const bool helper = fault->pid != compile->main_pid;
        if (fault->time < compile->exec_time)
        {
            snprintf(fault->stage, sizeof(fault->stage), "start");
        }
        if (fault->time >= compile->exec_time)
        {
            snprintf(fault->stage, sizeof(fault->stage), "%s", helper ? "exit" : stage_at(compile, fault->time));
        }
        const Mapping* mapping = fault->mapping >= 0 ? &compile->mappings[fault->mapping] : NULL;
        fault->label = label_of(fault->address, fault->time);
        const bool library = strncmp(fault->ip_symbol, "__mem", 5) == 0;
        const char* filler = library ? fill_caller(fault->address) : NULL;
        if (filler != NULL)
        {
            snprintf(fault->caller, sizeof(fault->caller), "%s", filler);
        }
        const char* name = fault->label != NULL ? fault->label : mapping != NULL ? mapping->name : "no mapping";
        if (mapping != NULL)
        {
            compile->mappings[fault->mapping].faults += 1;
            compile->mappings[fault->mapping].bytes += fault->page_bytes;
            compile->mappings[fault->mapping].cycles += fault->cycles;
        }
        char key[KCENSUS_KEY];
        // A fault's kind by its page and mapping where no sample of it names its handler.
        const bool file = (mapping != NULL && (strncmp(mapping->name, "file ", 5) == 0 || strncmp(mapping->name, "the executable: ", 16) == 0) &&
                           strcmp(mapping->name, "the executable: .bss") != 0) ||
                          (fault->label != NULL && strstr(fault->label, "(mapped)") != NULL);
        const char* derived = fault->page_bytes == (2ull << 20) ? "anon-2m" : file ? "file" : "anon-4k";
        const char* kind = fault->kind[0] != 0 ? fault->kind : derived;
        snprintf(key, sizeof(key), "%s\t%s\t%s", name, fault->page_bytes == (2ull << 20) ? "2M" : fault->page_bytes == 4096 ? "4K" : "?", fault->stage);
        sums_add(&totals->fault_mappings, key, fault->cycles, fault->samples, 1, fault->page_bytes);
        snprintf(key, sizeof(key), "%s\t%s", fault->page_bytes == (2ull << 20) ? "2M" : "4K", kind);
        sums_add(&totals->fault_parts, key, fault->cycles, fault->samples, 1, fault->page_bytes);
        snprintf(key, sizeof(key), "%s\t%s\t%s\t%s", name, fault->kernel_ip ? "(kernel)" : "", fault->ip_symbol, fault->caller[0] != 0 ? fault->caller : "");
        sums_add(&totals->fault_touchers, key, fault->cycles, fault->samples, 1, fault->page_bytes);
        totals->faults += 1;
        totals->fault_bytes += fault->page_bytes;
        compile->fault_bytes += fault->page_bytes;
        if (faults_out != NULL)
        {
            fprintf(faults_out, "%u\t%" PRIu64 "\t%u\t%s\t%#" PRIx64 "\t%" PRIu64 "\t%d\t%s\t%#" PRIx64 "\t%s\t%s\t%s\t%" PRIu64 "\t%u\t%s\n", compile_index,
                    fault->time, fault->pid, fault->stage, fault->address, fault->page_bytes, fault->mapping, name, fault->ip, fault->ip_symbol, fault->ip_dso,
                    kind, fault->cycles, fault->samples, fault->caller);
        }
    }
    for (uint32_t i = 0; i < compile->op_count; i += 1)
    {
        const Op* op = &compile->ops[i];
        const char* label = label_of(op->address, op->time);
        const int32_t m = label == NULL ? mapping_of(compile, op->pid, op->address, op->time) : -1;
        const char* name = label != NULL ? label : m >= 0 ? compile->mappings[m].name : "no mapping";
        const char* stage = op->pid != compile->main_pid ? "exit" : stage_at(compile, op->time);
        char key[KCENSUS_KEY];
        snprintf(key, sizeof(key), "%s\t%s\t%s", name, stage, op->store ? "store" : "load");
        // An op stands for its period's ops: `count` is the estimate, `samples` the samples.
        sums_add(&totals->ops, key, 0, 1, op->period, 0);
    }
    for (uint32_t i = 0; mappings_out != NULL && i < compile->mapping_count; i += 1)
    {
        const Mapping* mapping = &compile->mappings[i];
        const bool helper = mapping->pid != compile->main_pid;
        fprintf(mappings_out, "%u\t%u\t%" PRIu64 "\t%s\t%#" PRIx64 "\t%#" PRIx64 "\t%s\t%s\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\n", compile_index, mapping->ordinal,
                mapping->time, helper ? "exit" : stage_at(compile, mapping->time), mapping->start, mapping->length, mapping->prot, mapping->name, mapping->faults,
                mapping->bytes, mapping->cycles);
    }
}

// The C library's functions in the static executable, which touch pages for their callers.
static bool is_library(const char* symbol)
{
    static const char* const prefixes[] = {
        "__mem", "mem", "__str", "str", "__libc", "_int_", "malloc", "calloc", "realloc", "free", "_IO", "__wmem", "[unknown]",
    };
    bool found = false;
    for (uint32_t i = 0; i < sizeof(prefixes) / sizeof(prefixes[0]) && !found; i += 1)
    {
        found = strncmp(symbol, prefixes[i], strlen(prefixes[i])) == 0;
    }
    return found;
}

// Reads one compile's recording. With `units`, the file holds many compiles one after another: the read stops at the
// next compile's waitall fork, leaves that line in `pending` for the next call, and sets *more.
static bool read_script(FILE* file, Compile* compile, char* pending, bool units, bool* more)
{
    char line[KCENSUS_LINE];
    Sample* current = NULL;
    Fault* current_fault = NULL;
    bool keep_current = false;
    bool ok = file != NULL;
    *more = false;
    while (ok)
    {
        if (pending != NULL && pending[0] != 0)
        {
            snprintf(line, sizeof(line), "%s", pending);
            pending[0] = 0;
        }
        else if (fgets(line, sizeof(line), file) == NULL)
        {
            break;
        }
        if (line[0] == '\t' && current_fault != NULL)
        {
            // A fault's frame: the first user frame that is no C library function names who touched the page.
            const char* at = line;
            char address[64];
            char symbol[KCENSUS_NAME];
            next_token(&at, address, sizeof(address));
            next_token(&at, symbol, sizeof(symbol));
            const uint64_t value = strtoull(address, NULL, 16);
            const bool user = value < 0xffff800000000000ull;
            if (current_fault->ip == 0)
            {
                char dso[KCENSUS_NAME];
                next_token(&at, dso, sizeof(dso));
                current_fault->ip = value;
                current_fault->kernel_ip = !user;
                const char* plus = strchr(symbol, '+');
                const size_t length = plus != NULL ? (size_t)(plus - symbol) : strlen(symbol);
                snprintf(current_fault->ip_symbol, sizeof(current_fault->ip_symbol), "%.*s", (int)length, symbol);
                snprintf(current_fault->ip_dso, sizeof(current_fault->ip_dso), "%s", dso);
            }
            if (user && current_fault->caller[0] == 0 && !is_library(symbol))
            {
                const char* plus = strchr(symbol, '+');
                const size_t length = plus != NULL ? (size_t)(plus - symbol) : strlen(symbol);
                snprintf(current_fault->caller, sizeof(current_fault->caller), "%.*s", (int)length, symbol);
            }
            continue;
        }
        if (current_fault != NULL && current_fault->page_bytes == 0 && strchr(line, ':') == NULL)
        {
            // The page size line after a fault's chain: ` 4K`.
            char size[32];
            const char* at = line;
            next_token(&at, size, sizeof(size));
            current_fault->page_bytes = strcmp(size, "2M") == 0 ? (2ull << 20) : strcmp(size, "4K") == 0 ? 4096 : strcmp(size, "1G") == 0 ? (1ull << 30) : 0;
            current_fault = NULL;
            continue;
        }
        current_fault = NULL;
        if (line[0] == '\t' && current != NULL)
        {
            // A frame: `\tADDRESS SYMBOL (DSO)`.
            if (current->frames < KCENSUS_FRAMES)
            {
                const char* at = line;
                char address[64];
                char symbol[KCENSUS_NAME];
                char dso[KCENSUS_NAME];
                next_token(&at, address, sizeof(address));
                next_token(&at, symbol, sizeof(symbol));
                next_token(&at, dso, sizeof(dso));
                const uint64_t value = strtoull(address, NULL, 16);
                const bool user = value < 0xffff800000000000ull;
                const char* plus = strchr(symbol, '+');
                const size_t length = plus != NULL ? (size_t)(plus - symbol) : strlen(symbol);
                snprintf(current->frame[current->frames], KCENSUS_NAME, "%.*s", (int)length, symbol);
                current->user_frame[current->frames] = user;
                current->frames += 1;
            }
            continue;
        }
        if (current != NULL)
        {
            // The sample's end: its data page size line, or anything that isn't a frame.
            compile->sample_count += keep_current ? 1 : 0;
            current = NULL;
            if (strstr(line, "N/A") != NULL && strchr(line, ':') == NULL)
            {
                continue;
            }
        }
        const char* at = line;
        char comm[KCENSUS_NAME];
        char ids[64];
        char time_text[64];
        if (!next_token(&at, comm, sizeof(comm)) || !next_token(&at, ids, sizeof(ids)) || !next_token(&at, time_text, sizeof(time_text)))
        {
            continue;
        }
        unsigned pid = 0;
        unsigned tid = 0;
        sscanf(ids, "%u/%u", &pid, &tid);
        const uint64_t time = parse_time(time_text);
        if (strstr(line, "PERF_RECORD_COMM exec: compiler:") != NULL && compile->main_pid == 0)
        {
            compile->main_pid = pid;
            compile->exec_time = time;
            compile_add_pid(compile, pid);
        }
        else if (strstr(line, "PERF_RECORD_COMM") != NULL)
        {
            // Another exec: nothing to keep.
        }
        else if (strstr(line, "PERF_RECORD_FORK(") != NULL)
        {
            unsigned child = 0;
            unsigned child_tid = 0;
            unsigned parent = 0;
            const char* fork = strstr(line, "PERF_RECORD_FORK(");
            const bool parsed = sscanf(fork, "PERF_RECORD_FORK(%u:%u):(%u:", &child, &child_tid, &parent) == 3;
            if (parsed && units && compile->parent_pid != 0 && parent != compile->parent_pid && strcmp(comm, "waitall") == 0)
            {
                // The next compile's waitall.
                snprintf(pending, KCENSUS_LINE, "%s", line);
                *more = true;
                break;
            }
            if (parsed && compile_has_pid(compile, parent))
            {
                compile_add_pid(compile, child);
            }
            else if (parsed && compile->parent_pid == 0 && strcmp(comm, "waitall") == 0)
            {
                // waitall's child, which execs the compiler.
                compile->parent_pid = parent;
                compile->fork_time = time;
                compile_add_pid(compile, child);
            }
        }
        else if (strstr(line, "PERF_RECORD_EXIT(") != NULL)
        {
            compile->compile_end = compile_has_pid(compile, pid) && time > compile->compile_end ? time : compile->compile_end;
            compile->main_exit_time = pid == compile->main_pid && compile->main_pid != 0 && compile->main_exit_time == 0 ? time : compile->main_exit_time;
            compile->end_time = pid == compile->parent_pid && time > compile->end_time ? time : compile->end_time;
        }
        else if (strstr(line, "PERF_RECORD_MMAP2 ") != NULL)
        {
            parse_mmap(compile, line, time);
        }
        else if (strstr(line, "minor-faults") != NULL)
        {
            if (compile_has_pid(compile, pid))
            {
                const uint32_t before = compile->fault_count;
                parse_fault(compile, line, pid, tid, time);
                current_fault = compile->fault_count > before ? &compile->faults[before] : NULL;
            }
        }
        else if (strstr(line, "ibs_op") != NULL)
        {
            // `COMM PID/TID TIME: PERIOD ibs_op/...: ADDRESS DATA_SOURCE |OP LOAD|... IP SYMBOL`
            const bool load = strstr(line, "|OP LOAD") != NULL;
            const bool store = strstr(line, "|OP STORE") != NULL;
            char period[64];
            char event[KCENSUS_NAME];
            char address[64];
            next_token(&at, period, sizeof(period));
            next_token(&at, event, sizeof(event));
            next_token(&at, address, sizeof(address));
            const uint64_t value = strtoull(address, NULL, 16);
            if ((load || store) && value != 0 && compile_has_pid(compile, pid))
            {
                if (compile->op_count == compile->op_capacity)
                {
                    compile->op_capacity = compile->op_capacity == 0 ? 65536 : compile->op_capacity * 2;
                    compile->ops = realloc(compile->ops, compile->op_capacity * sizeof(Op));
                }
                Op* op = &compile->ops[compile->op_count];
                op->time = time;
                op->address = value;
                op->period = strtoull(period, NULL, 10);
                op->pid = pid;
                op->store = store;
                compile->op_count += 1;
            }
        }
        else if (strstr(line, "cpu/cycles") != NULL)
        {
            if (compile->sample_count == compile->sample_capacity)
            {
                compile->sample_capacity = compile->sample_capacity == 0 ? 4096 : compile->sample_capacity * 2;
                compile->samples = realloc(compile->samples, (size_t)compile->sample_capacity * sizeof(Sample));
            }
            current = &compile->samples[compile->sample_count];
            current->time = time;
            current->pid = pid;
            current->tid = tid;
            current->frames = 0;
            current->compiler = strcmp(comm, "compiler") == 0;
            char period[64];
            next_token(&at, period, sizeof(period));
            current->period = strtoull(period, NULL, 10);
            // Every sample of the CPU: the compile's processes', its parent's and any other task's.
            keep_current = true;
        }
    }
    if (current != NULL)
    {
        compile->sample_count += keep_current ? 1 : 0;
    }
    return ok;
}

static void read_names(const char* path)
{
    FILE* file = fopen(path, "r");
    char line[KCENSUS_LINE];
    uint32_t capacity = 0;
    while (file != NULL && fgets(line, sizeof(line), file) != NULL)
    {
        unsigned ordinal = 0;
        unsigned long long start = 0;
        unsigned long long length = 0;
        int consumed = 0;
        if (sscanf(line, "%u %llx %llx %n", &ordinal, &start, &length, &consumed) == 3)
        {
            if (kcensus_name_count == capacity)
            {
                capacity = capacity == 0 ? 256 : capacity * 2;
                kcensus_names = realloc(kcensus_names, capacity * sizeof(Name));
            }
            Name* name = &kcensus_names[kcensus_name_count];
            name->ordinal = ordinal;
            name->seen = false;
            name->time = 0;
            name->start = start;
            name->length = length;
            snprintf(name->name, sizeof(name->name), "%s", line + consumed);
            name->name[strcspn(name->name, "\n")] = 0;
            kcensus_name_count += 1;
        }
    }
    if (file != NULL)
    {
        fclose(file);
    }
}

int main(int argc, char** argv)
{
    int status = 0;
    int at = 1;
    bool units = false;
    if (at < argc && strcmp(argv[at], "--units") == 0)
    {
        units = true;
        at += 1;
    }
    while (at + 1 < argc && strncmp(argv[at], "--", 2) == 0)
    {
        if (strcmp(argv[at], "--names") == 0)
        {
            read_names(argv[at + 1]);
        }
        else if (strcmp(argv[at], "--fills") == 0)
        {
            read_fills(argv[at + 1]);
        }
        at += 2;
    }
    const bool named = kcensus_name_count != 0;
    if ((!units && (argc - at < 3 || (argc - at - 1) % 2 != 0)) || (units && argc - at != 2))
    {
        fprintf(stderr, "usage: kcensus [--names FILE] [--fills FILE] OUT STAGES SCRIPT [STAGES SCRIPT]...\n"
                        "       kcensus --units [--names FILE] [--fills FILE] OUT SCRIPT\n");
        status = 2;
    }
    if (status == 0)
    {
        const char* out = argv[at];
        char path[4096];
        snprintf(path, sizeof(path), "%s-samples.tsv", out);
        FILE* samples_out = fopen(path, "w");
        snprintf(path, sizeof(path), "%s-faults.tsv", out);
        FILE* faults_out = fopen(path, "w");
        snprintf(path, sizeof(path), "%s-mappings.tsv", out);
        FILE* mappings_out = fopen(path, "w");
        fprintf(samples_out, "compile\ttime\tpid\tstage\tcause\tdetail\tpart\tperiod\tleaf\n");
        fprintf(faults_out, "compile\ttime\tpid\tstage\taddress\tpage-bytes\tmapping\tname\tip\tip-symbol\tip-dso\tkind\tcycles\tsamples\tcaller\n");
        fprintf(mappings_out, "compile\tordinal\ttime\tstage\tstart\tlength\tprot\tname\tfaults\tbytes\tcycles\n");
        Totals totals = { 0 };
        uint32_t compiles = 0;
        snprintf(path, sizeof(path), "%s-units.tsv", out);
        FILE* units_out = units ? fopen(path, "w") : NULL;
        if (units_out != NULL)
        {
            fprintf(units_out, "compile\tpid\town-kernel-cycles\tfaults\tfault-bytes\n");
        }
        FILE* units_file = units ? (strcmp(argv[at + 1], "-") == 0 ? stdin : fopen(argv[at + 1], "r")) : NULL;
        char* pending = calloc(KCENSUS_LINE, 1);
        bool more = units && units_file != NULL;
        status = units && units_file == NULL ? 1 : status;
        for (int i = at + 1; status == 0 && (units ? more : i + 1 < argc); i += units ? 0 : 2)
        {
            Compile compile = { 0 };
            bool laps = units;
            bool script = false;
            if (units)
            {
                script = read_script(units_file, &compile, pending, true, &more);
                if (compile.main_pid == 0)
                {
                    // Nothing more than the recording's tail: not a compile.
                    free(compile.mappings);
                    free(compile.faults);
                    free(compile.samples);
                    free(compile.ops);
                    continue;
                }
                if (!named)
                {
                    names_auto(&compile);
                }
            }
            else
            {
                laps = read_laps(argv[i], &compile);
                FILE* file = strcmp(argv[i + 1], "-") == 0 ? stdin : fopen(argv[i + 1], "r");
                bool unused = false;
                script = read_script(file, &compile, NULL, false, &unused);
                if (file != NULL && file != stdin)
                {
                    fclose(file);
                }
            }
            if (!laps || !script || compile.main_pid == 0)
            {
                fprintf(stderr, "kcensus: %s: no laps, no recording or no compiler process\n", units ? argv[at + 1] : argv[i]);
                status = 1;
            }
            else
            {
                const uint32_t timed = named ? names_time(&compile) : kcensus_name_count;
                if (kcensus_name_count != 0 && timed != kcensus_name_count)
                {
                    fprintf(stderr, "kcensus: %s: %u of the %u named mappings found in its records\n", units ? argv[at + 1] : argv[i + 1], timed,
                            kcensus_name_count);
                }
                classify(&compile, &totals, samples_out, compiles);
                account_faults(&compile, &totals, faults_out, mappings_out, compiles);
                if (units_out != NULL)
                {
                    fprintf(units_out, "%u\t%u\t%" PRIu64 "\t%u\t%" PRIu64 "\n", compiles, compile.main_pid, compile.own_cycles, compile.fault_count,
                            compile.fault_bytes);
                }
                compiles += 1;
            }
            free(compile.laps);
            free(compile.mappings);
            free(compile.faults);
            free(compile.samples);
            free(compile.ops);
        }
        fclose(samples_out);
        fclose(faults_out);
        fclose(mappings_out);
        if (units_out != NULL)
        {
            fclose(units_out);
        }
        if (units_file != NULL && units_file != stdin)
        {
            fclose(units_file);
        }
        free(pending);
        if (status == 0 && compiles > 0)
        {
            snprintf(path, sizeof(path), "%s-causes.tsv", out);
            sums_write(&totals.causes, path, "phase\tcause\tdetail\tpart", 1.0, compiles);
            snprintf(path, sizeof(path), "%s-stages.tsv", out);
            sums_write(&totals.stages, path, "stage\tcause\tdetail", 1.0, compiles);
            snprintf(path, sizeof(path), "%s-fault-mappings.tsv", out);
            sums_write(&totals.fault_mappings, path, "mapping\tpage\tstage", 1.0, compiles);
            snprintf(path, sizeof(path), "%s-fault-kinds.tsv", out);
            sums_write(&totals.fault_parts, path, "page\tkind", 1.0, compiles);
            snprintf(path, sizeof(path), "%s-fault-touchers.tsv", out);
            sums_write(&totals.fault_touchers, path, "mapping\tkernel\tip-symbol\tcaller", 1.0, compiles);
            snprintf(path, sizeof(path), "%s-ops.tsv", out);
            sums_write(&totals.ops, path, "mapping\tstage\top", 1.0, compiles);
            snprintf(path, sizeof(path), "%s-summary.txt", out);
            FILE* summary = fopen(path, "w");
            fprintf(summary, "compiles\t%u\n", compiles);
            fprintf(summary, "sampled kernel cycles a compile\t%.0f\n", (double)totals.cycles / compiles);
            fprintf(summary, "perf's own a compile\t%.0f\n", (double)totals.perf_cycles / compiles);
            fprintf(summary, "the stage clock's own a compile\t%.0f\n", (double)totals.clock_cycles / compiles);
            fprintf(summary, "the compile's a compile\t%.0f\n", (double)totals.compile_cycles / compiles);
            fprintf(summary, "faults a compile\t%.1f\n", (double)totals.faults / compiles);
            fprintf(summary, "fault bytes a compile\t%.0f\n", (double)totals.fault_bytes / compiles);
            fclose(summary);
        }
    }
    return status;
}
