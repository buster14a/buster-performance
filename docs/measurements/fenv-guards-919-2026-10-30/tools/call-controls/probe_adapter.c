// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original evidence-only source adapter. It does not modify the shipping tree.
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#define INPUT_LIMIT (UINT64_C(4) * 1024 * 1024)

static const char helper_header[] =
    "static void check_action_fp_environment(const TypeTable* table, const CheckAction* action, CheckActionResult* result)\n{";

static const char declarations[] =
    "// Evidence-only #919 entry/call-route counters; this executable is never timed.\n"
    "#if BUSTER_IN_UNIT(BUSTER_UNIT_CHECKER)\n"
    "static uint64_t buster919_fenv_counts[5];\n"
    "static __attribute__((destructor)) void buster919_fenv_report(void)\n"
    "{\n"
    "    uint64_t values[5];\n"
    "    for (uint32_t i = 0; i < 5; i += 1)\n"
    "    {\n"
    "        values[i] = __atomic_load_n(buster919_fenv_counts + i, __ATOMIC_RELAXED);\n"
    "    }\n"
    "    fprintf(stderr, \"buster919-fenv total=%llu access_on=%llu access_off=%llu diagnostic=%llu compute=%llu builtin=%llu\\n\",\n"
    "            (unsigned long long)(values[0] + values[1]), (unsigned long long)values[0], (unsigned long long)values[1],\n"
    "            (unsigned long long)values[2], (unsigned long long)values[3], (unsigned long long)values[4]);\n"
    "}\n"
    "#endif\n\n";

static const char entry[] =
    "\n#if BUSTER_IN_UNIT(BUSTER_UNIT_CHECKER)\n"
    "    __atomic_fetch_add(buster919_fenv_counts + ((action->fp_environment & BUSTER_CHECK_FP_ENV_ACCESS) != 0 ? 0 : 1), UINT64_C(1), __ATOMIC_RELAXED);\n"
    "    if (result->diagnostic != CHECK_DIAG_NONE)\n"
    "    {\n"
    "        __atomic_fetch_add(buster919_fenv_counts + 2, UINT64_C(1), __ATOMIC_RELAXED);\n"
    "    }\n"
    "#endif\n";

static char* read_source(const char* path)
{
    FILE* file = fopen(path, "rb");
    bool valid = file != NULL && fseek(file, 0, SEEK_END) == 0;
    const long length = valid ? ftell(file) : -1;
    valid = valid && length > 0 && (uint64_t)length <= INPUT_LIMIT;
    char* text = valid ? malloc((size_t)length + 1) : NULL;
    valid = valid && text != NULL && fseek(file, 0, SEEK_SET) == 0 && fread(text, 1, (size_t)length, file) == (size_t)length;
    if (file != NULL)
    {
        valid = fclose(file) == 0 && valid;
    }
    if (valid)
    {
        text[length] = 0;
        valid = memchr(text, 0, (size_t)length) == NULL;
    }
    if (!valid)
    {
        free(text);
        text = NULL;
    }
    return text;
}

static bool replace_once(char** text, const char* needle, const char* replacement)
{
    const size_t needle_length = strlen(needle);
    char* position = *text != NULL ? strstr(*text, needle) : NULL;
    bool valid = position != NULL && strstr(position + needle_length, needle) == NULL;
    if (valid)
    {
        const size_t before = (size_t)(position - *text);
        const size_t replacement_length = strlen(replacement);
        const size_t after = strlen(position + needle_length);
        const size_t size = before + replacement_length + after + 1;
        char* output = malloc(size);
        valid = size <= INPUT_LIMIT && output != NULL;
        if (valid)
        {
            memcpy(output, *text, before);
            memcpy(output + before, replacement, replacement_length);
            memcpy(output + before + replacement_length, position + needle_length, after + 1);
            free(*text);
            *text = output;
        }
        else
        {
            free(output);
        }
    }
    return valid;
}

static bool distinct_file(const char* input, const char* output)
{
    struct stat first;
    struct stat second;
    const bool same_inode = stat(input, &first) == 0 && stat(output, &second) == 0 &&
                            first.st_dev == second.st_dev && first.st_ino == second.st_ino;
    return strcmp(input, output) != 0 && !same_inode;
}

static bool write_source(const char* path, const char* text)
{
    FILE* file = fopen(path, "wb");
    const size_t length = strlen(text);
    bool valid = file != NULL && fwrite(text, 1, length, file) == length;
    if (file != NULL)
    {
        valid = fclose(file) == 0 && valid;
    }
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = argc == 5;
    char* actions = valid ? read_source(argv[1]) : NULL;
    char* checker = valid ? read_source(argv[2]) : NULL;
    valid = valid && actions != NULL && checker != NULL && distinct_file(argv[1], argv[3]) && distinct_file(argv[1], argv[4]) &&
            distinct_file(argv[2], argv[3]) && distinct_file(argv[2], argv[4]) && distinct_file(argv[3], argv[4]);
    valid = valid && strstr(actions, "buster919_fenv_counts") == NULL && strstr(checker, "buster919_fenv_counts") == NULL;
    char* header = NULL;
    if (valid)
    {
        const size_t size = sizeof(declarations) + sizeof(helper_header) + sizeof(entry);
        header = malloc(size);
        valid = header != NULL;
        if (valid)
        {
            const int count = snprintf(header, size, "%s%s%s", declarations, helper_header, entry);
            valid = count > 0 && (size_t)count < size;
        }
    }
    valid = valid && replace_once(&actions, helper_header, header);
    valid = valid && replace_once(&actions, "check_action_fp_environment(table, action, result);",
        "\n#if BUSTER_IN_UNIT(BUSTER_UNIT_CHECKER)\n"
        "        __atomic_fetch_add(buster919_fenv_counts + 3, UINT64_C(1), __ATOMIC_RELAXED);\n"
        "#endif\n"
        "        check_action_fp_environment(table, action, result);");
    valid = valid && replace_once(&checker, "check_action_fp_environment(types, &action, &result);",
        "\n#if BUSTER_IN_UNIT(BUSTER_UNIT_CHECKER)\n"
        "            __atomic_fetch_add(buster919_fenv_counts + 4, UINT64_C(1), __ATOMIC_RELAXED);\n"
        "#endif\n"
        "            check_action_fp_environment(types, &action, &result);");
    valid = valid && write_source(argv[3], actions) && write_source(argv[4], checker);
    fprintf(valid ? stdout : stderr, "%s\n", valid ? "#919 evidence adapter: one entry and two call routes instrumented" :
            "#919 evidence adapter: FAILED (usage: probe_adapter INPUT_ACTIONS INPUT_CHECKER OUTPUT_ACTIONS OUTPUT_CHECKER; markers must be unique and outputs distinct)");
    free(header);
    free(actions);
    free(checker);
    return valid ? 0 : 1;
}
