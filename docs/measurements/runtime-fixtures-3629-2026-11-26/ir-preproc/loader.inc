// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
typedef struct IrParseTestCase IrParseTestCase;
struct IrParseTestCase
{
    String8 source;
    const char* identifier;
    IrParseError error;
    bool limit_or_syntax;
    uint64_t offset;
    uint32_t line;
    uint32_t column;
};

// Ordinary parser contracts are raw .ir files and six-field catalogs: ID, FILE, ERROR, REJECTED, LINE and COLUMN.
// A named diagnostic records the first REJECTED token's byte offset as well as its independently specified place.
// Other suites use '-' and zero coordinates. Every row and file stays in `source` until its original loop finishes.
static bool ir_parse_test_decimal(const char* text, uint32_t* value)
{
    uint64_t number = 0;
    bool valid = text[0] != 0;
    for (const char* at = text; valid && *at != 0; at += 1)
    {
        valid = *at >= '0' && *at <= '9';
        if (valid)
        {
            number = number * 10 + (uint32_t)(*at - '0');
            valid = number <= UINT32_MAX;
        }
    }
    *value = valid ? (uint32_t)number : 0;
    return valid;
}

static IrParseTestCase* ir_parse_test_cases_load(IrParseTest* test, const char* suite, Arena* source, uint32_t* count)
{
    *count = 0;
    char relative[128];
    snprintf(relative, sizeof(relative), "ir/%s", suite);
    char directory[PATH_MAX] = { 0 };
    char path[PATH_MAX] = { 0 };
    char problem[PATH_MAX + 512] = { 0 };
    IrParseTestCase* cases = arena_push(source, sizeof(*cases) * BUSTER_IR_PARSE_TEST_CASES, 8);
    char* files[BUSTER_IR_PARSE_TEST_CASES];
    String8 catalog = { 0 };
    bool valid = cases != NULL && test_fixture_path(directory, sizeof(directory), ir_parse_test_fixture_root, relative) &&
                 test_fixture_path(path, sizeof(path), directory, "catalog.tsv") && ir_parse_test_read(path, source, &catalog);
    if (!valid)
    {
        snprintf(problem, sizeof(problem), "can't load %s's parser cases", suite);
    }
    else if (catalog.length == 0 || catalog.pointer[catalog.length - 1] != '\n')
    {
        snprintf(problem, sizeof(problem), "%s doesn't end with a newline", path);
        valid = false;
    }
    const bool diagnostics = strcmp(suite, "diagnostics") == 0;
    const bool overflow = strcmp(suite, "overflow") == 0;
    const bool reachable = strcmp(suite, "reachable") == 0;
    char* cursor = catalog.pointer;
    uint32_t line = 0;
    while (valid && cursor < catalog.pointer + catalog.length)
    {
        char* end = memchr(cursor, '\n', (size_t)(catalog.pointer + catalog.length - cursor));
        *end = 0;
        line += 1;
        const bool nul = memchr(cursor, 0, (size_t)(end - cursor)) != NULL;
        if (line == 1)
        {
            valid = !nul && strcmp(cursor, "buster-fixtures v1 ir-parser-cases") == 0;
        }
        else if (nul || cursor[0] != '#')
        {
            char* fields[6] = { cursor, NULL, NULL, NULL, NULL, NULL };
            uint32_t fields_count = 1;
            for (char* tab = nul ? NULL : strchr(cursor, '\t'); tab != NULL && fields_count <= 6; tab = strchr(tab + 1, '\t'))
            {
                *tab = 0;
                if (fields_count < 6)
                {
                    fields[fields_count] = tab + 1;
                }
                fields_count += 1;
            }
            const size_t file_length = fields_count == 6 ? strlen(fields[1]) : 0;
            valid = !nul && fields_count == 6 && ir_parse_test_word(fields[0]) && ir_parse_test_word(fields[1]) && file_length > 3 &&
                    strcmp(fields[1] + file_length - 3, ".ir") == 0 && *count < BUSTER_IR_PARSE_TEST_CASES;
            for (uint32_t i = 0; valid && i < *count; i += 1)
            {
                valid = strcmp(cases[i].identifier, fields[0]) != 0 && strcmp(files[i], fields[1]) != 0;
            }
            IrParseTestCase* row = valid ? &cases[*count] : NULL;
            if (valid)
            {
                *row = (IrParseTestCase){ .identifier = fields[0] };
                static const char* const errors[] = { "ok", "end", "syntax", "limit", "memory", "verify" };
                uint32_t error = 0;
                while (error < BUSTER_ARRAY_LENGTH(errors) && strcmp(fields[2], errors[error]) != 0)
                {
                    error += 1;
                }
                row->limit_or_syntax = strcmp(fields[2], "limit-or-syntax") == 0;
                row->error = error < BUSTER_ARRAY_LENGTH(errors) ? (IrParseError)error : IR_PARSE_LIMIT;
                valid = (error < BUSTER_ARRAY_LENGTH(errors) || row->limit_or_syntax) && ir_parse_test_decimal(fields[4], &row->line) &&
                        ir_parse_test_decimal(fields[5], &row->column);
                if (valid)
                {
                    valid = diagnostics ? row->error == IR_PARSE_SYNTAX && !row->limit_or_syntax && fields[3][0] != 0 && strcmp(fields[3], "-") != 0 && row->line != 0 && row->column != 0 :
                                          strcmp(fields[3], "-") == 0 && row->line == 0 && row->column == 0;
                }
                if (valid && !diagnostics)
                {
                    valid = overflow ? row->limit_or_syntax : !row->limit_or_syntax && (reachable ? row->error == IR_PARSE_OK || row->error == IR_PARSE_VERIFY :
                                                                                               row->error != IR_PARSE_OK && row->error != IR_PARSE_MEMORY);
                }
            }
            if (valid)
            {
                valid = test_fixture_path(path, sizeof(path), directory, fields[1]) && ir_parse_test_read(path, source, &row->source);
            }
            if (valid && diagnostics)
            {
                const char* rejected = memmem(row->source.pointer, row->source.length, fields[3], strlen(fields[3]));
                valid = rejected != NULL;
                row->offset = valid ? (uint64_t)(rejected - row->source.pointer) : 0;
            }
            if (valid)
            {
                files[*count] = fields[1];
                *count += 1;
            }
        }
        if (!valid)
        {
            snprintf(problem, sizeof(problem), "%s/catalog.tsv line %u: malformed metadata, duplicate ID/file or unreadable case", directory, line);
        }
        cursor = end + 1;
    }
    if (valid && *count == 0)
    {
        snprintf(problem, sizeof(problem), "%s/catalog.tsv names no case", directory);
        valid = false;
    }
    // Unlike the top-level canonical directory, a contract suite contains only its catalog and named input files.
    DIR* listing = valid ? opendir(directory) : NULL;
    if (valid && listing == NULL)
    {
        snprintf(problem, sizeof(problem), "can't list %s", directory);
        valid = false;
    }
    for (struct dirent* entry = valid ? readdir(listing) : NULL; valid && entry != NULL; entry = readdir(listing))
    {
        const char* name = entry->d_name;
        bool named = strcmp(name, ".") == 0 || strcmp(name, "..") == 0 || strcmp(name, "catalog.tsv") == 0;
        for (uint32_t i = 0; !named && i < *count; i += 1)
        {
            named = strcmp(files[i], name) == 0;
        }
        if (!named)
        {
            snprintf(problem, sizeof(problem), "%s/%s is in no catalog line", directory, name);
            valid = false;
        }
    }
    if (listing != NULL)
    {
        closedir(listing);
    }
    ir_parse_test_expect(test, valid, problem);
    *count = valid ? *count : 0;
    fprintf(stderr, "IR parser: %u %s fixtures from %s\n", *count, suite, directory);
    return valid ? cases : NULL;
}

