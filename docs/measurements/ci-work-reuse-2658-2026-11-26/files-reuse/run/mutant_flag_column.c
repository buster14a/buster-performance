// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Harness-only plumbing. These reduced structs, representative token numbers and
// small intern implementation are stubs; this does not build the production driver.
// The extractor appends the current production comparison/bitmap helpers and controls.
#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define BUSTER_ARRAY_LENGTH(a) (sizeof(a)/sizeof((a)[0]))
#define BUSTER_PP_NONE UINT32_MAX
#define C_TOKEN_RAW_IDENTIFIER 5
#define C_TOKEN_NUMERIC_CONSTANT 7
#define BUSTER_PP_KIND_KEYWORD 64
#define BUSTER_PP_KIND_PRAGMA_END 200
#define C_NAME_INT 1
static bool pp_test_quiet;
typedef uint32_t IdentId;
typedef struct InternTable { uint32_t count; char names[16][64]; } InternTable;
static bool intern_initialize(InternTable* t) { memset(t,0,sizeof(*t)); strcpy(t->names[1],"int"); strcpy(t->names[2],"long"); t->count=3; return true; }
static void intern_release(InternTable* t) { (void)t; }
static const uint8_t* intern_bytes(const InternTable* t, IdentId id) { return (const uint8_t*)t->names[id]; }
static uint32_t intern_length(const InternTable* t, IdentId id) { return (uint32_t)strlen(t->names[id]); }
static IdentId intern_find_or_add(InternTable* t,const uint8_t* text,uint32_t n) { for(uint32_t i=1;i<t->count;i++) if(strlen(t->names[i])==n && memcmp(t->names[i],text,n)==0) return i; if(t->count==16 || n>=64) return 0; uint32_t id=t->count++; memcpy(t->names[id],text,n); t->names[id][n]=0; return id; }
typedef struct FilesTestUnit { uint8_t* kinds; uint8_t* flags; uint32_t* values; uint32_t* locations; uint32_t count; uint32_t errors; uint32_t warnings; bool ran; } FilesTestUnit;
typedef struct FilesTestWork { const char* name; } FilesTestWork;
typedef struct PPFileData { uint32_t record; bool prepared; } PPFileData;
static bool files_test_same_id(const InternTable* x, const InternTable* y, bool opaque, IdentId a, IdentId b)
{
    const bool result = opaque ? a < x->count && b < y->count && intern_length(x, a) == intern_length(y, b) &&
                                     memcmp(intern_bytes(x, a), intern_bytes(y, b), intern_length(x, a)) == 0
                               : a == b;
    return result;
}

static bool files_test_same_value(const InternTable* x, const InternTable* y, bool opaque, uint8_t kind, uint32_t a, uint32_t b)
{
    const bool named = kind == C_TOKEN_RAW_IDENTIFIER || (kind >= BUSTER_PP_KIND_KEYWORD && kind < BUSTER_PP_KIND_PRAGMA_END);
    return named ? files_test_same_id(x, y, opaque, a, b) : a == b;
}

static bool files_test_same_stream(const FilesTestUnit* a, const FilesTestUnit* b, const InternTable* x, const InternTable* y, bool opaque, uint32_t* at)
{
    const uint32_t count = a->count;
    const uint32_t other_count = b->count;
    const bool columns = !opaque && count == other_count && (count == 0 ||
                         (memcmp(a->kinds, b->kinds, count) == 0 && true &&
                          memcmp(a->values, b->values, (uint64_t)count * sizeof(uint32_t)) == 0 &&
                          memcmp(a->locations, b->locations, (uint64_t)count * sizeof(uint32_t)) == 0));
    uint32_t i = columns ? count : 0;
    while (i < count && i < other_count && a->kinds[i] == b->kinds[i] && a->flags[i] == b->flags[i] && a->locations[i] == b->locations[i] &&
           files_test_same_value(x, y, opaque, a->kinds[i], a->values[i], b->values[i]))
    {
        i += 1;
    }
    *at = i;
    return a->ran == b->ran && a->errors == b->errors && a->warnings == b->warnings && i == count && i == other_count;
}

static bool files_test_same_text(const FilesTestWork* work, const char* unit, const char* what, const char* how, const char* a, size_t a_length, const char* b,
                                 size_t b_length)
{
    const bool result = a_length == b_length && (a_length == 0 || memcmp(a, b, a_length) == 0);
    if (!result && !pp_test_quiet)
    {
        size_t at = 0;
        while (at < a_length && at < b_length && a[at] == b[at])
        {
            at += 1;
        }
        printf("%s: %s's %s differs %s at byte %zu of %zu/%zu\n", work->name, unit, what, how, at, b_length, a_length);
    }
    return result;
}

static bool files_test_mark_used(const PPFileData* datas, uint32_t data_count, uint32_t record_count, uint8_t** used, uint32_t* used_count)
{
    bool result = true;
    if (record_count > *used_count)
    {
        uint8_t* grown = realloc(*used, (size_t)record_count);
        result = grown != 0;
        if (result)
        {
            memset(grown + *used_count, 0, (size_t)record_count - *used_count);
            *used = grown;
            *used_count = record_count;
        }
    }
    uint8_t* marked = *used;
    for (uint32_t d = 0; result && d < data_count; d += 1)
    {
        const uint32_t record = datas[d].record;
        if (record < record_count && datas[d].prepared)
        {
            marked[record] = 1;
        }
    }
    return result;
}

static uint32_t files_test_unused(const PPFileData* records, const uint8_t* used, uint32_t count)
{
    uint32_t unused = 0;
    for (uint32_t r = 0; r < count; r += 1)
    {
        unused += records[r].prepared && used[r] == 0;
    }
    return unused;
}

static bool files_test_comparisons(void)
{
    enum { tokens = 65 };
    uint8_t kinds[2][tokens];
    uint8_t flags[2][tokens];
    uint32_t values[2][tokens];
    uint32_t locations[2][tokens];
    InternTable tables[2] = { 0 };
    bool result = intern_initialize(&tables[0]) && intern_initialize(&tables[1]);
    const char alpha[] = "files_compare_alpha";
    const char beta[] = "files_compare_beta";
    IdentId ids[2][2] = { 0 };
    if (result)
    {
        ids[0][0] = intern_find_or_add(&tables[0], (const uint8_t*)alpha, sizeof(alpha) - 1);
        ids[0][1] = intern_find_or_add(&tables[0], (const uint8_t*)beta, sizeof(beta) - 1);
        ids[1][1] = intern_find_or_add(&tables[1], (const uint8_t*)beta, sizeof(beta) - 1);
        ids[1][0] = intern_find_or_add(&tables[1], (const uint8_t*)alpha, sizeof(alpha) - 1);
        result = ids[0][0] != 0 && ids[0][1] != 0 && ids[1][0] != 0 && ids[1][1] != 0 && ids[0][0] != ids[1][0];
    }
    const FilesTestUnit a = {
        .kinds = kinds[0],
        .flags = flags[0],
        .values = values[0],
        .locations = locations[0],
        .count = tokens,
        .errors = 2,
        .warnings = 3,
        .ran = true,
    };
    FilesTestUnit b = a;
    b.kinds = kinds[1];
    b.flags = flags[1];
    b.values = values[1];
    b.locations = locations[1];
    const uint32_t places[] = { 0, 1, 2, 15, 16, 63, 64 };
    for (uint32_t opaque = 0; result && opaque < 2; opaque += 1)
    {
        for (uint32_t t = 0; t < tokens; t += 1)
        {
            kinds[0][t] = kinds[1][t] = t % 3 == 0 ? C_TOKEN_RAW_IDENTIFIER : t % 3 == 1 ? BUSTER_PP_KIND_KEYWORD : C_TOKEN_NUMERIC_CONSTANT;
            flags[0][t] = flags[1][t] = (uint8_t)(t & 1);
            values[0][t] = t % 3 == 0 ? ids[0][0] : t % 3 == 1 ? C_NAME_INT : 1000 + t;
            values[1][t] = t % 3 == 0 ? ids[opaque][0] : values[0][t];
            locations[0][t] = locations[1][t] = 2000 + t;
        }
        uint32_t at = 0;
        result = files_test_same_stream(&a, &b, &tables[0], &tables[opaque], opaque != 0, &at) && at == tokens;
        for (uint32_t p = 0; p < BUSTER_ARRAY_LENGTH(places); p += 1)
        {
            const uint32_t t = places[p];
            kinds[1][t] ^= 1;
            result &= !files_test_same_stream(&a, &b, &tables[0], &tables[opaque], opaque != 0, &at) && at == t;
            kinds[1][t] ^= 1;
            flags[1][t] ^= 1;
            result &= !files_test_same_stream(&a, &b, &tables[0], &tables[opaque], opaque != 0, &at) && at == t;
            flags[1][t] ^= 1;
            const uint32_t value = values[1][t];
            values[1][t] = t % 3 == 0 ? ids[opaque][1] : value + 1;
            result &= !files_test_same_stream(&a, &b, &tables[0], &tables[opaque], opaque != 0, &at) && at == t;
            values[1][t] = value;
            locations[1][t] ^= 1;
            result &= !files_test_same_stream(&a, &b, &tables[0], &tables[opaque], opaque != 0, &at) && at == t;
            locations[1][t] ^= 1;
        }
        flags[1][1] ^= 1;
        locations[1][64] ^= 1;
        result &= !files_test_same_stream(&a, &b, &tables[0], &tables[opaque], opaque != 0, &at) && at == 1;
        flags[1][1] ^= 1;
        locations[1][64] ^= 1;
        b.ran = false;
        result &= !files_test_same_stream(&a, &b, &tables[0], &tables[opaque], opaque != 0, &at) && at == tokens;
        b.ran = true;
        b.errors += 1;
        result &= !files_test_same_stream(&a, &b, &tables[0], &tables[opaque], opaque != 0, &at) && at == tokens;
        b.errors -= 1;
        b.warnings += 1;
        result &= !files_test_same_stream(&a, &b, &tables[0], &tables[opaque], opaque != 0, &at) && at == tokens;
        b.warnings -= 1;
        b.count -= 1;
        result &= !files_test_same_stream(&a, &b, &tables[0], &tables[opaque], opaque != 0, &at) && at == tokens - 1;
        b.count += 1;
    }
    const FilesTestUnit empty = { 0 };
    uint32_t at = 1;
    result &= files_test_same_stream(&empty, &empty, &tables[0], &tables[0], false, &at) && at == 0;
    intern_release(&tables[1]);
    intern_release(&tables[0]);
    const FilesTestWork work = { .name = "comparison controls" };
    const char diagnostic[] = "original diagnostic\n";
    char changed[sizeof(diagnostic)];
    memcpy(changed, diagnostic, sizeof(diagnostic));
    const bool quiet = pp_test_quiet;
    pp_test_quiet = true;
    result &= files_test_same_text(&work, "unit", "diagnostics", "control", diagnostic, sizeof(diagnostic) - 1, changed, sizeof(changed) - 1);
    changed[0] ^= 1;
    result &= !files_test_same_text(&work, "unit", "diagnostics", "control", diagnostic, sizeof(diagnostic) - 1, changed, sizeof(changed) - 1);
    changed[0] ^= 1;
    result &= !files_test_same_text(&work, "unit", "diagnostics", "control", diagnostic, sizeof(diagnostic) - 1, changed, sizeof(changed) - 2);
    pp_test_quiet = quiet;
    const PPFileData records[] = {
        { .prepared = true },
        { .prepared = true },
        { .prepared = false },
        { .prepared = true },
        { .prepared = true },
    };
    const PPFileData first[] = {
        {
            .record = 0,
            .prepared = true,
        },
        {
            .record = 1,
            .prepared = false,
        },
        {
            .record = BUSTER_PP_NONE,
            .prepared = true,
        },
    };
    const PPFileData later[] = {
        {
            .record = 3,
            .prepared = true,
        },
        {
            .record = 4,
            .prepared = true,
        },
    };
    uint8_t* used = 0;
    uint32_t used_count = 0;
    const bool marked = files_test_mark_used(first, BUSTER_ARRAY_LENGTH(first), 3, &used, &used_count) &&
                        files_test_mark_used(later, BUSTER_ARRAY_LENGTH(later), BUSTER_ARRAY_LENGTH(records), &used, &used_count);
    result &= marked;
    if (marked)
    {
        result &= used_count == BUSTER_ARRAY_LENGTH(records) && files_test_unused(records, used, used_count) == 1;
        used[0] = 0;
        result &= files_test_unused(records, used, used_count) == 2;
        used[0] = 1;
        used[1] = 1;
        result &= files_test_unused(records, used, used_count) == 0;
    }
    free(used);
    if (!result)
    {
        printf("comparisons: a stream, diagnostic or used-file corruption escaped its check\n");
    }
    return result;
}

int main(void) { return files_test_comparisons() ? 0 : 1; }
