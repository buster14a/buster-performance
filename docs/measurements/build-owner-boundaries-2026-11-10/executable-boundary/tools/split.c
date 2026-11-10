// Original one-off source-boundary audit and extraction helper.
#define _POSIX_C_SOURCE 200809L
#include <assert.h>
#include <ctype.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Function
{
    char name[128];
    size_t start;
    size_t body;
    size_t end;
    bool entry;
    bool needed;
} Function;

static Function functions[2048];
static size_t function_count;
static size_t function_slots[8192];

static unsigned name_hash(const char* text, size_t length)
{
    unsigned hash = 2166136261u;
    for (size_t i = 0; i < length; i++) hash = (hash ^ (unsigned char)text[i]) * 16777619u;
    return hash;
}

static char* read_file(const char* path, size_t* length)
{
    FILE* file = fopen(path, "rb");
    if (!file) { perror(path); exit(1); }
    assert(fseek(file, 0, SEEK_END) == 0);
    long size = ftell(file);
    assert(size >= 0);
    rewind(file);
    char* text = malloc((size_t)size + 1);
    assert(text);
    assert(fread(text, 1, (size_t)size, file) == (size_t)size);
    text[size] = 0;
    fclose(file);
    *length = (size_t)size;
    return text;
}

// Skip a string, character literal or comment; its opening byte is at *at.
static bool skip_literal(const char* text, size_t length, size_t* at)
{
    bool skipped = false;
    size_t i = *at;
    if (text[i] == '"' || text[i] == '\'')
    {
        char quote = text[i++];
        while (i < length && text[i] != quote)
        {
            i += text[i] == '\\' && i + 1 < length ? 2 : 1;
        }
        if (i < length) i++;
        skipped = true;
    }
    else if (text[i] == '/' && i + 1 < length && text[i + 1] == '/')
    {
        while (i < length && text[i] != '\n') i++;
        skipped = true;
    }
    else if (text[i] == '/' && i + 1 < length && text[i + 1] == '*')
    {
        i += 2;
        while (i + 1 < length && !(text[i] == '*' && text[i + 1] == '/')) i++;
        i += i + 1 < length ? 2 : 0;
        skipped = true;
    }
    if (skipped) *at = i;
    return skipped;
}

static void scan_functions(const char* text, size_t length)
{
    for (size_t at = 0; at < length; )
    {
        size_t end = at;
        while (end < length && text[end] != '\n') end++;
        bool prefix = !strncmp(text + at, "static ", 7) || !strncmp(text + at, "BUSTER_LINKER_ENTRY ", 20) || !strncmp(text + at, "BUSTER_INLINE ", 14);
        size_t header_end = at;
        unsigned header_parens = 0;
        bool function = false;
        if (prefix)
        {
            while (header_end < length)
            {
                if (skip_literal(text, length, &header_end)) continue;
                char c = text[header_end];
                if (c == '(') header_parens++;
                if (c == ')') { assert(header_parens); header_parens--; }
                if (header_parens == 0 && (c == ';' || c == '=')) break;
                if (header_parens == 0 && c == '{') { function = true; break; }
                header_end++;
            }
        }
        if (function)
        {
            Function* f = &functions[function_count++];
            assert(function_count <= sizeof(functions) / sizeof(functions[0]));
            f->start = at;
            f->body = header_end;
            f->entry = !strncmp(text + at, "BUSTER_LINKER_ENTRY", 19);
            unsigned parens = 0;
            size_t identifier = at;
            size_t identifier_length = 0;
            for (size_t p = at; p < header_end; p++)
            {
                if (isalpha((unsigned char)text[p]) || text[p] == '_')
                {
                    size_t token = p++;
                    while (p < header_end && (isalnum((unsigned char)text[p]) || text[p] == '_')) p++;
                    if (parens == 0) { identifier = token; identifier_length = p - token; }
                    p--;
                }
                else if (text[p] == '(')
                {
                    if (parens == 0 && identifier_length && (identifier_length != 13 || strncmp(text + identifier, "__attribute__", 13)))
                    {
                        assert(identifier_length < sizeof(f->name));
                        memcpy(f->name, text + identifier, identifier_length);
                        f->name[identifier_length] = 0;
                    }
                    parens++;
                }
                else if (text[p] == ')') parens--;
            }
            assert(f->name[0]);
            size_t p = header_end;
            unsigned braces = 0;
            do
            {
                if (!skip_literal(text, length, &p))
                {
                    if (text[p] == '{') braces++;
                    if (text[p] == '}') braces--;
                    p++;
                }
            }
            while (p < length && braces);
            assert(braces == 0);
            f->end = p;
            if (p < length && text[p] == '\n') f->end++;
            at = f->end;
        }
        else at = end < length ? end + 1 : end;
    }
}

static bool mark_tokens(const char* text, size_t start, size_t end, bool origins)
{
    bool changed = false;
    bool source = !origins;
    for (size_t i = start; i < end; )
    {
        if (origins && text[i] == '#' && (i == start || text[i - 1] == '\n'))
        {
            size_t line = i;
            while (i < end && text[i] != '\n') i++;
            const char* quote = memchr(text + line, '"', i - line);
            if (quote)
            {
                const char* close = memchr(quote + 1, '"', (size_t)(text + i - quote - 1));
                assert(close);
                size_t n = (size_t)(close - quote - 1);
                const char suffix[] = "/executable.c";
                source = n < sizeof(suffix) - 1 || memcmp(close - (sizeof(suffix) - 1), suffix, sizeof(suffix) - 1);
            }
        }
        else if (skip_literal(text, end, &i)) {}
        else if (isalpha((unsigned char)text[i]) || text[i] == '_')
        {
            size_t token = i++;
            while (i < end && (isalnum((unsigned char)text[i]) || text[i] == '_')) i++;
            bool member = token > start && (text[token - 1] == '.' || text[token - 1] == '>');
            size_t next = i;
            while (next < end && isspace((unsigned char)text[next])) next++;
            bool reference = !origins || (next < end && text[next] == '(') || (token > start && text[token - 1] == '&');
            if (source && !member && reference)
            {
                unsigned slot = name_hash(text + token, i - token) & 8191u;
                while (function_slots[slot])
                {
                    Function* function = &functions[function_slots[slot] - 1];
                    if (strlen(function->name) == i - token && !memcmp(function->name, text + token, i - token))
                    {
                        if (!function->entry && !function->needed)
                        {
                            function->needed = true;
                            changed = true;
                        }
                        break;
                    }
                    slot = (slot + 1) & 8191u;
                }
            }
        }
        else i++;
    }
    return changed;
}

int main(int argc, char** argv)
{
    assert(argc > 3);
    size_t length;
    char* text = read_file(argv[1], &length);
    scan_functions(text, length);
    for (size_t f = 0; f < function_count; f++)
    {
        unsigned slot = name_hash(functions[f].name, strlen(functions[f].name)) & 8191u;
        while (function_slots[slot]) slot = (slot + 1) & 8191u;
        function_slots[slot] = f + 1;
    }
    for (int file = 3; file < argc; file++)
    {
        size_t size;
        char* input = read_file(argv[file], &size);
        mark_tokens(input, 0, size, true);
        free(input);
    }
    bool changed;
    do
    {
        changed = false;
        for (size_t f = 0; f < function_count; f++)
            if (functions[f].needed) changed |= mark_tokens(text, functions[f].body, functions[f].end, false);
    }
    while (changed);
    size_t retained = 0, removed = 0;
    for (size_t f = 0; f < function_count; f++)
    {
        Function* function = &functions[f];
        size_t size = function->end - function->start;
        printf("%s\t%zu\t%s\t%s\n", function->needed ? "keep" : "move", size, function->entry ? "entry" : "static", function->name);
        if (function->needed) retained += size; else removed += size;
    }
    fprintf(stderr, "functions=%zu retained=%zu removed=%zu\n", function_count, retained, removed);
    if (strcmp(argv[2], "audit"))
    {
        char path[4096];
        snprintf(path, sizeof(path), "%s/interface.c", argv[2]);
        FILE* interface = fopen(path, "wb"); assert(interface);
        snprintf(path, sizeof(path), "%s/implementation.c", argv[2]);
        FILE* implementation = fopen(path, "wb"); assert(implementation);
        fputs("// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception\n// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.\n// Private executable bodies; included by executable.c in DYNAMIC, EXECUTABLE and standalone consumers.\n\n", implementation);
        size_t copied = 0;
        for (size_t f = 0; f < function_count; f++)
        {
            Function* function = &functions[f];
            if (!function->needed)
            {
                fwrite(text + copied, 1, function->start - copied, interface);
                fwrite(text + function->start, 1, function->body - function->start - 1, interface);
                fputs(";\n", interface);
                fwrite(text + function->start, 1, function->end - function->start, implementation);
                fputs("\n", implementation);
                copied = function->end;
            }
        }
        fwrite(text + copied, 1, length - copied, interface);
        fputs("\n#if !defined(BUSTER_UNIT) || BUSTER_IN_UNIT(BUSTER_UNIT_DYNAMIC) || BUSTER_IN_UNIT(BUSTER_UNIT_EXECUTABLE)\n#include \"executable_impl.c\"\n#endif\n", interface);
        fclose(interface);
        fclose(implementation);
    }
    free(text);
    return 0;
}
