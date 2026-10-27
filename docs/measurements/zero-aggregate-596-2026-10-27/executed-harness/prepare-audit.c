// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Reconstruct a measurement-only overlay from an exact compiler tree, without changing that tree.
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static char* read_file(const char* path)
{
    FILE* file = fopen(path, "rb");
    char* result = NULL;
    if (file != NULL && fseek(file, 0, SEEK_END) == 0)
    {
        const long size = ftell(file);
        if (size >= 0 && fseek(file, 0, SEEK_SET) == 0)
        {
            result = malloc((size_t)size + 1);
            if (result != NULL)
            {
                if (fread(result, 1, (size_t)size, file) != (size_t)size)
                {
                    free(result);
                    result = NULL;
                }
                else
                {
                    result[size] = 0;
                }
            }
        }
    }
    if (file != NULL)
    {
        fclose(file);
    }
    return result;
}

static bool insert(char** contents, const char* needle, const char* prefix, const char* suffix, bool required)
{
    char* at = *contents != NULL ? strstr(*contents, needle) : NULL;
    bool valid = at != NULL || !required;
    if (at != NULL)
    {
        const size_t begin = (size_t)(at - *contents);
        const size_t size = strlen(*contents) + strlen(prefix) + strlen(suffix) + 1;
        char* changed = malloc(size);
        valid = changed != NULL && strstr(at + strlen(needle), needle) == NULL;
        if (valid)
        {
            memcpy(changed, *contents, begin);
            snprintf(changed + begin, size - begin, "%s%s%s%s", prefix, needle, suffix, at + strlen(needle));
            free(*contents);
            *contents = changed;
        }
        else
        {
            free(changed);
        }
    }
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = argc == 3;
    const char* names[] = { "main.c", "c_check_data.c" };
    for (unsigned i = 0; valid && i < 2; i += 1)
    {
        char path[2048];
        snprintf(path, sizeof(path), "%s/src/buster/compiler/%s", argv[1], names[i]);
        char* contents = read_file(path);
        valid = contents != NULL;
        if (valid && i == 0)
        {
            valid = insert(&contents, "#include \"buster/compiler/c_check_data.c\"",
                "#include \"audit.h\"\n#define arena_push audit_arena_push\n#define arena_push_array audit_arena_push_array\n#define memset audit_memset\n#define memcpy audit_memcpy\n",
                "\n#undef arena_push\n#undef arena_push_array\n#undef memset\n#undef memcpy", true);
        }
        else if (valid)
        {
            valid = insert(&contents, "for (uint32_t byte = 0; byte < plan->size; byte += 1)", "audit_scanned += plan->size;\n        ", "", true) &&
                    insert(&contents, "for (uint64_t byte = 0; plan->bytes != 0 && byte < plan->size; byte += 1)",
                           "audit_scanned += plan->bytes != NULL ? plan->size : 0;\n        ", "", false) &&
                    insert(&contents, "static bool check_data_nonzero_bits(const uint8_t* bytes, uint64_t begin, uint64_t end, bool scalar)\n{",
                           "", "\n    audit_scanned += end > begin ? (end + 7) / 8 - begin / 8 : 0;", false);
        }
        snprintf(path, sizeof(path), "%s/buster/compiler/%s", argv[2], names[i]);
        FILE* output = valid ? fopen(path, "wb") : NULL;
        valid = output != NULL && fwrite(contents, 1, strlen(contents), output) == strlen(contents);
        if (output != NULL)
        {
            valid = fclose(output) == 0 && valid;
        }
        free(contents);
    }
    return valid ? 0 : 1;
}
