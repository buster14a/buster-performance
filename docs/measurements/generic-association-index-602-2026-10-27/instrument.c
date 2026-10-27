#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static char* replace(char* source, const char* needle, const char* replacement, size_t start)
{
    char* found = strstr(source + start, needle);
    char* result = NULL;
    if (found != NULL)
    {
        const size_t before = (size_t)(found - source);
        const size_t removed = strlen(needle);
        const size_t added = strlen(replacement);
        const size_t length = strlen(source);
        result = malloc(length - removed + added + 1);
        if (result != NULL)
        {
            memcpy(result, source, before);
            memcpy(result + before, replacement, added);
            memcpy(result + before + added, found + removed, length - before - removed + 1);
        }
    }
    free(source);
    return result;
}

int main(int argc, char** argv)
{
    int valid = argc == 3;
    const int baseline = valid && strcmp(argv[1], "base") == 0;
    for (unsigned reader = 0; valid && reader < 2; reader += 1)
    {
        char path[4096];
        snprintf(path, sizeof(path), "%s/src/buster/compiler/%s", argv[2], reader == 0 ? "c_check_select.c" : "c_check_constant.c");
        FILE* file = fopen(path, "rb");
        valid = file != NULL && fseek(file, 0, SEEK_END) == 0;
        long length = valid ? ftell(file) : -1;
        valid &= length >= 0;
        char* source = valid ? malloc((size_t)length + 1) : NULL;
        valid &= source != NULL;
        if (valid)
        {
            rewind(file);
            valid = fread(source, 1, (size_t)length, file) == (size_t)length;
            source[length] = 0;
        }
        if (file != NULL)
        {
            fclose(file);
        }
        if (valid && baseline)
        {
            source = replace(source, "uint32_t seen_count = 0;", "uint32_t seen_count = 0; uint64_t generic_duplicate_queries = 0, generic_control_queries = 0;", 0);
            valid = source != NULL;
            if (valid)
            {
                source = replace(source, "const TypeAnswer answer = type_compatible_at(reader->types, type, seen[prior],",
                                 "generic_duplicate_queries += 1; const TypeAnswer answer = type_compatible_at(reader->types, type, seen[prior],", 0);
                valid = source != NULL;
            }
            if (valid)
            {
                source = replace(source, "const TypeAnswer answer = type_compatible_at(reader->types, type, control_type,",
                                 "generic_control_queries += 1; const TypeAnswer answer = type_compatible_at(reader->types, type, control_type,", 0);
                valid = source != NULL;
            }
        }
        if (valid)
        {
            const char* function = strstr(source, reader == 0 ? "static bool check_input_selection_generic(" : "static bool check_constant_selection(");
            valid = function != NULL;
            if (valid)
            {
                char report[1024];
                snprintf(report, sizeof(report),
                         "if (control_type != 0) { fprintf(stderr, \"generic-counts,%s,%%llu,%%llu\\n\", (unsigned long long)%s, (unsigned long long)%s); }\n"
                         "    arena_pop_to(reader->scratch, mark);", reader == 0 ? "expression" : "constant",
                         baseline ? "generic_duplicate_queries" : "seen.duplicate_queries",
                         baseline ? "generic_control_queries" : "seen.control_queries");
                source = replace(source, "arena_pop_to(reader->scratch, mark);", report, (size_t)(function - source));
                valid = source != NULL;
            }
        }
        if (valid)
        {
            file = fopen(path, "wb");
            valid = file != NULL && fwrite(source, 1, strlen(source), file) == strlen(source);
            if (file != NULL)
            {
                valid &= fclose(file) == 0;
            }
        }
        free(source);
    }
    return valid ? 0 : 1;
}
