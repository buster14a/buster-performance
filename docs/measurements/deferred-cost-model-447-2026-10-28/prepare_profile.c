// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original offline adapter generator. Its two exact edits expose timestamps the
// existing deferred benchmark already takes; production files remain untouched.
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static bool adapt(const char* source, const char* destination, const char* const* before, const char* const* after, size_t replacements)
{
    FILE* input = fopen(source, "rb");
    bool valid = input != NULL && fseek(input, 0, SEEK_END) == 0;
    const long bytes = valid ? ftell(input) : -1;
    valid = valid && bytes >= 0 && fseek(input, 0, SEEK_SET) == 0;
    char* text = valid ? malloc((size_t)bytes + 1) : NULL;
    valid = text != NULL && fread(text, 1, (size_t)bytes, input) == (size_t)bytes;
    if (input != NULL) fclose(input);
    if (valid) text[bytes] = 0;
    FILE* output = valid ? fopen(destination, "wb") : NULL;
    valid = valid && output != NULL;
    char* at = text;
    for (size_t r = 0; valid && r < replacements; r += 1)
    {
        char* match = strstr(at, before[r]);
        valid = match != NULL && strstr(match + strlen(before[r]), before[r]) == NULL;
        if (valid)
        {
            valid = fwrite(at, 1, (size_t)(match - at), output) == (size_t)(match - at) && fputs(after[r], output) >= 0;
            at = match + strlen(before[r]);
        }
    }
    if (valid) valid = fputs(at, output) >= 0;
    if (output != NULL) valid = fclose(output) == 0 && valid;
    free(text);
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = argc == 5;
    const char* const main_before[] = {
        "#define BUSTER_ELSEWHERE inline __attribute__((noinline))",
        "#define BUSTER_X86_TARGET_DATA_ELSEWHERE",
        "#include \"buster/compiler/c_check_deferred.c\"",
        "int main(int argc, char** argv)",
    };
    const char* const main_after[] = {
        "#define BUSTER_ELSEWHERE",
        "// Offline adapter owns the unchanged target data.",
        "#include \"deferred-profile-copy.c\"",
        "static __attribute__((unused)) int main(int argc, char** argv)",
    };
    const char* const deferred_before[] = {
        "struct CheckDeferredResult\n{",
        "    const uint64_t walk_end = deferred->timing ? check_deferred_now() : 0;",
    };
    const char* const deferred_after[] = {
        "struct CheckDeferredResult\n{\n    uint64_t offline_walk_ns;",
        "    const uint64_t walk_end = deferred->timing ? check_deferred_now() : 0;\n    result->offline_walk_ns = walk_end - walk_begin;",
    };
    valid = valid && adapt(argv[1], argv[2], main_before, main_after, 4) && adapt(argv[3], argv[4], deferred_before, deferred_after, 2);
    if (!valid) fprintf(stderr, "profile preparation failed: expected exact frozen anchors\n");
    return valid ? 0 : 1;
}
