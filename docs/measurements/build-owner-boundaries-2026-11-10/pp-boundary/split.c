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
    size_t comment;
    size_t body;
    size_t end;
    bool entry;
    bool needed;
    bool data;
    size_t source;
} Function;

typedef struct Source
{
    char* text;
    size_t length;
    const char* path;
    const char* name;
} Source;

static Source sources[2];
typedef struct Prototype
{
    size_t source;
    size_t start;
    size_t end;
    size_t function;
} Prototype;
static Prototype prototypes[512];
static size_t prototype_count;

static Function functions[2048];
static size_t function_count;
static size_t function_slots[8192];

static unsigned name_hash(const char* text, size_t length)
{
    unsigned hash = 2166136261u;
    for (size_t i = 0; i < length; i++) hash = (hash ^ (unsigned char)text[i]) * 16777619u;
    return hash;
}

static void scan_prototypes(size_t source)
{
    const char* text = sources[source].text;
    const size_t length = sources[source].length;
    for (size_t at = 0; at < length; )
    {
        size_t end = at;
        while (end < length && text[end] != '\n') end++;
        if (!strncmp(text + at, "static ", 7) && memchr(text + at, '(', end - at) && !memchr(text + at, '=', end - at))
        {
            size_t p = at;
            while (p < length && text[p] != '{' && text[p] != ';') p++;
            if (p < length && text[p] == ';')
            {
                for (size_t f = 0; f < function_count; f++)
                {
                    Function* function = &functions[f];
                    const char* found = strstr(text + at, function->name);
                    size_t name_length = strlen(function->name);
                    if (!function->data && !function->needed && !function->entry && found && found < text + p && found[name_length] == '(')
                    {
                        prototypes[prototype_count++] = (Prototype){ source, at, p + 1, f };
                        assert(prototype_count < sizeof(prototypes) / sizeof(prototypes[0]));
                        break;
                    }
                }
            }
        }
        at = end < length ? end + 1 : end;
    }
}

static void write_shared(FILE* file, size_t source, size_t begin, size_t end)
{
    const char* text = sources[source].text;
    size_t at = begin;
    for (size_t i = 0; i < prototype_count; i++)
    {
        const Prototype* prototype = &prototypes[i];
        if (prototype->source == source && prototype->start >= begin && prototype->end <= end)
        {
            fwrite(text + at, 1, prototype->start - at, file);
            at = prototype->end;
        }
    }
    const char* literal = source == 0 ? strstr(text + at, "#include \"c_preprocessor_literal.c\"") : 0;
    if (literal && literal < text + end)
    {
        fwrite(text + at, 1, (size_t)(literal - text) - at, file);
        at = (size_t)(literal - text) + strlen("#include \"c_preprocessor_literal.c\"");
    }
    fwrite(text + at, 1, end - at, file);
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

static void compact_top_level(const char* path)
{
    size_t length;
    char* text = read_file(path, &length);
    FILE* file = fopen(path, "wb");
    assert(file);
    unsigned braces = 0, newlines = 0;
    for (size_t i = 0; i < length; )
    {
        size_t start = i;
        if (skip_literal(text, length, &i))
        {
            fwrite(text + start, 1, i - start, file);
            newlines = 0;
        }
        else if (text[i] == '#' && (i == 0 || text[i - 1] == '\n'))
        {
            do { while (i < length && text[i] != '\n') i++; if (i < length) i++; }
            while (i > 1 && text[i - 2] == '\\' && i < length);
            fwrite(text + start, 1, i - start, file);
            newlines = 0;
        }
        else
        {
            char c = text[i++];
            if (c == '{') braces++;
            if (c == '}') { assert(braces); braces--; }
            if (c == '\n' && !braces) newlines++; else newlines = 0;
            if (newlines <= 2) fputc(c, file);
        }
    }
    fclose(file);
    free(text);
}

static void scan_functions(const char* text, size_t length, size_t source)
{
    for (size_t at = 0; at < length; )
    {
        size_t end = at;
        while (end < length && text[end] != '\n') end++;
        bool prefix = !strncmp(text + at, "static ", 7) || !strncmp(text + at, "BUSTER_PREPROCESSOR_ENTRY ", 26) || !strncmp(text + at, "BUSTER_INLINE ", 14);
        if (prefix && memchr(text + at, '(', end - at) && !memchr(text + at, '=', end - at) && !memchr(text + at, ';', end - at))
        {
            size_t p = end;
            while (p + 1 < length && text[p + 1] != '{' && text[p + 1] != '\n')
            {
                p++;
                while (p < length && text[p] != '\n' && text[p] != ';') p++;
                if (p < length && text[p] == ';') break;
            }
            if (p + 1 < length && text[p + 1] == '{') end = p;
        }
        if (prefix && end + 1 < length && text[end + 1] == '{' && memchr(text + at, '(', end - at) && !memchr(text + at, '=', end - at))
        {
            Function* f = &functions[function_count++];
            assert(function_count <= sizeof(functions) / sizeof(functions[0]));
            f->start = at;
            f->source = source;
            f->body = end + 1;
            f->entry = !strncmp(text + at, "BUSTER_PREPROCESSOR_ENTRY", 25);
            unsigned parens = 0;
            size_t identifier = at;
            size_t identifier_length = 0;
            for (size_t p = at; p < end; p++)
            {
                if (isalpha((unsigned char)text[p]) || text[p] == '_')
                {
                    size_t token = p++;
                    while (p < end && (isalnum((unsigned char)text[p]) || text[p] == '_')) p++;
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
            size_t p = end + 1;
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
        else if (!strncmp(text + at, "static const struct\n", 20))
        {
            Function* f = &functions[function_count++];
            f->start = at;
            f->source = source;
            f->data = true;
            f->body = at;
            size_t p = end + 1;
            assert(text[p] == '{');
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
            while (p < length && isspace((unsigned char)text[p])) p++;
            size_t name = p;
            while (p < length && (isalnum((unsigned char)text[p]) || text[p] == '_')) p++;
            assert(p - name < sizeof(f->name));
            memcpy(f->name, text + name, p - name);
            f->name[p - name] = 0;
            while (p < length)
            {
                if (!skip_literal(text, length, &p) && text[p++] == ';') break;
            }
            f->end = p;
            if (p < length && text[p] == '\n') f->end++;
            at = f->end;
        }
        else if (!strncmp(text + at, "static ", 7) && memchr(text + at, '=', end - at))
        {
            Function* f = &functions[function_count++];
            f->start = at;
            f->source = source;
            f->data = true;
            size_t identifier = at, identifier_length = 0;
            for (size_t p = at; p < end; p++)
            {
                if (isalpha((unsigned char)text[p]) || text[p] == '_')
                {
                    size_t token = p++;
                    while (p < end && (isalnum((unsigned char)text[p]) || text[p] == '_')) p++;
                    identifier = token;
                    identifier_length = p - token;
                    p--;
                }
                else if (text[p] == '[' || text[p] == '=')
                {
                    assert(identifier_length < sizeof(f->name));
                    memcpy(f->name, text + identifier, identifier_length);
                    f->name[identifier_length] = 0;
                    break;
                }
            }
            assert(f->name[0]);
            f->body = at;
            size_t p = at;
            while (p < length)
            {
                if (!skip_literal(text, length, &p))
                {
                    if (text[p++] == ';') break;
                }
            }
            f->end = p;
            if (p < length && text[p] == '\n') f->end++;
            size_t assertion = f->end;
            while (assertion < length && isspace((unsigned char)text[assertion])) assertion++;
            if (!strncmp(text + assertion, "_Static_assert(", 15))
            {
                p = assertion;
                while (p < length)
                {
                    if (!skip_literal(text, length, &p) && text[p++] == ';') break;
                }
                f->end = p;
                if (p < length && text[p] == '\n') f->end++;
            }
            at = f->end;
        }
        else at = end < length ? end + 1 : end;
    }
}

static void attach_comments(void)
{
    for (size_t f = 0; f < function_count; f++)
    {
        Function* function = &functions[f];
        const char* text = sources[function->source].text;
        size_t at = function->start;
        size_t comments = at;
        bool found = false;
        while (at > 0)
        {
            size_t end = at - 1;
            size_t begin = end;
            while (begin > 0 && text[begin - 1] != '\n') begin--;
            size_t content = begin;
            while (content < end && (text[content] == ' ' || text[content] == '\t')) content++;
            bool blank = content == end;
            bool comment = content + 1 < end && text[content] == '/' && text[content + 1] == '/';
            if (!blank && !comment) break;
            if (comment) { comments = begin; found = true; }
            else if (found) break;
            at = begin;
        }
        function->comment = found && comments > 0 && !function->entry ? comments : function->start;
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
                source = true;
                for (size_t f = 0; f < 2; f++)
                {
                    size_t name_length = strlen(sources[f].name);
                    if (n >= name_length && !memcmp(close - name_length, sources[f].name, name_length)) source = false;
                }
                const char literal[] = "c_preprocessor_literal.c";
                if (n >= sizeof(literal) - 1 && !memcmp(close - (sizeof(literal) - 1), literal, sizeof(literal) - 1)) source = false;
            }
        }
        else if (skip_literal(text, end, &i)) {}
        else if (isalpha((unsigned char)text[i]) || text[i] == '_')
        {
            size_t token = i++;
            while (i < end && (isalnum((unsigned char)text[i]) || text[i] == '_')) i++;
            if (source)
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
    assert(argc > 4);
    for (size_t f = 0; f < 2; f++)
    {
        Source* source = &sources[f];
        source->path = argv[f + 1];
        source->name = strrchr(source->path, '/');
        source->name = source->name ? source->name + 1 : source->path;
        source->text = read_file(source->path, &source->length);
        scan_functions(source->text, source->length, f);
    }
    attach_comments();
    for (size_t f = 0; f < function_count; f++)
    {
        unsigned slot = name_hash(functions[f].name, strlen(functions[f].name)) & 8191u;
        while (function_slots[slot]) slot = (slot + 1) & 8191u;
        function_slots[slot] = f + 1;
    }
    for (int file = 4; file < argc; file++)
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
            if (functions[f].needed) changed |= mark_tokens(sources[functions[f].source].text, functions[f].body, functions[f].end, false);
    }
    while (changed);
    for (size_t f = 0; f < 2; f++) scan_prototypes(f);
    size_t retained = 0, removed = 0;
    for (size_t f = 0; f < function_count; f++)
    {
        Function* function = &functions[f];
        size_t size = function->end - function->start;
        printf("%s\t%zu\t%s\t%s\t%s\n", function->needed ? "keep" : "move", size, function->data ? "data" : function->entry ? "entry" : "static", function->name, sources[function->source].name);
        if (function->needed) retained += size; else removed += size;
    }
    fprintf(stderr, "functions=%zu retained=%zu removed=%zu\n", function_count, retained, removed);
    if (strcmp(argv[3], "audit"))
    {
        for (size_t source = 0; source < 2; source++)
        {
        const char* text = sources[source].text;
        size_t length = sources[source].length;
        char path[4096];
        snprintf(path, sizeof(path), "%s/%s", argv[3], sources[source].name);
        FILE* interface = fopen(path, "wb"); assert(interface);
        char impl[256];
        snprintf(impl, sizeof(impl), "%.*s_impl.c", (int)strlen(sources[source].name) - 2, sources[source].name);
        snprintf(path, sizeof(path), "%s/%s", argv[3], impl);
        FILE* implementation = fopen(path, "wb"); assert(implementation);
        fputs("// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception\n// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.\n// Private preprocessor bodies; included by c_preprocessor.c in FRONTEND and standalone consumers.\n\n", implementation);
        if (source == 0)
        {
            for (size_t p = 0; p < prototype_count; p++)
            {
                const Prototype* prototype = &prototypes[p];
                fwrite(sources[prototype->source].text + prototype->start, 1, prototype->end - prototype->start, implementation);
                fputs("\n", implementation);
            }
            fputs("\n", implementation);
        }
        size_t copied = 0;
        const char* history = source == 0 ? strstr(text, "#include \"c_preprocessor_history.c\"") : 0;
        bool history_included = false;
        const char* literal = source == 0 ? strstr(text, "#include \"c_preprocessor_literal.c\"") : 0;
        bool literal_included = false;
        for (size_t f = 0; f < function_count; f++)
        {
            Function* function = &functions[f];
            if (function->source != source) continue;
            if (!function->needed)
            {
                if (history && !history_included && function->start > (size_t)(history - text))
                {
                    fputs("#include \"c_preprocessor_history_impl.c\"\n\n", implementation);
                    history_included = true;
                }
                if (literal && !literal_included && function->start > (size_t)(literal - text))
                {
                    fputs("#include \"c_preprocessor_literal.c\"\n\n", implementation);
                    literal_included = true;
                }
                write_shared(interface, source, copied, function->comment);
                if (function->entry)
                {
                    fwrite(text + function->start, 1, function->body - function->start - 1, interface);
                    fputs(";\n", interface);
                }
                fwrite(text + function->comment, 1, function->end - function->comment, implementation);
                fputs("\n", implementation);
                copied = function->end;
            }
        }
        write_shared(interface, source, copied, length);
        if (source == 0) fprintf(interface, "\n#if !defined(BUSTER_UNIT) || BUSTER_UNIT == BUSTER_UNIT_FRONTEND\n#include \"%s\"\n#else\n// Preserve semantic references to shared interfaces without emitting code or disabling unused-function diagnostics.\nstatic __attribute__((unused)) void pp_implementation_interfaces(void)\n{\n    (void)&x86_target_has_builtin;\n    (void)&dependency_prepare;\n    (void)&pp_feature;\n    (void)&pp_warning_options_diagnose;\n}\n#endif\n", impl);
        fclose(interface);
        fclose(implementation);
        snprintf(path, sizeof(path), "%s/%s", argv[3], sources[source].name);
        compact_top_level(path);
        }
    }
    for (size_t f = 0; f < 2; f++) free(sources[f].text);
    return 0;
}
