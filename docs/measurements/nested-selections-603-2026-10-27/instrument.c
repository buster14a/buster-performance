// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. Original opt-in work-count instrumentation for #603.
// instrument base|head SOURCE_TREE. Apply to a separate source copy; timings use uninstrumented builds.
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static bool replace(const char* root, const char* file, const char* before, const char* after)
{
    char path[4096];
    snprintf(path, sizeof(path), "%s/src/buster/compiler/%s", root, file);
    FILE* input = fopen(path, "rb");
    bool valid = input != NULL && fseek(input, 0, SEEK_END) == 0;
    const long length = valid ? ftell(input) : -1;
    valid &= length >= 0 && fseek(input, 0, SEEK_SET) == 0;
    char* bytes = valid ? malloc((size_t)length + 1) : NULL;
    valid &= bytes != NULL;
    if (valid)
    {
        valid = fread(bytes, 1, (size_t)length, input) == (size_t)length;
        bytes[length] = 0;
    }
    if (input != NULL)
    {
        fclose(input);
    }
    char* found = valid ? strstr(bytes, before) : NULL;
    valid = valid && found != NULL && strstr(found + strlen(before), before) == NULL;
    FILE* output = valid ? fopen(path, "wb") : NULL;
    valid &= output != NULL;
    if (valid)
    {
        const size_t prefix = (size_t)(found - bytes);
        const char* tail = found + strlen(before);
        valid = fwrite(bytes, 1, prefix, output) == prefix && fputs(after, output) >= 0 && fputs(tail, output) >= 0;
    }
    if (output != NULL)
    {
        valid &= fclose(output) == 0;
    }
    if (!valid)
    {
        fprintf(stderr, "instrument: unmatched or failed edit in %s: %.100s\n", path, before);
    }
    free(bytes);
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = argc == 3 && (strcmp(argv[1], "base") == 0 || strcmp(argv[1], "head") == 0);
    const bool head = valid && strcmp(argv[1], "head") == 0;
    const char* root = valid ? argv[2] : "";
    valid = valid && replace(root, "c_check_input.c", "#define CHECK_INPUT_SOURCE_SELECTION 0x80000000u",
        "static uint64_t nested_root_queries, nested_root_visits, nested_warning_visits, nested_index_nodes;\n#define CHECK_INPUT_SOURCE_SELECTION 0x80000000u");
    valid = valid && replace(root, "c_check_input.c", "    *input = (CheckInput){ 0 };\n    // Plain char",
        "    *input = (CheckInput){ 0 };\n    nested_root_queries = nested_root_visits = nested_warning_visits = nested_index_nodes = 0;\n    // Plain char");
    valid = valid && replace(root, "c_check_input.c", "    arena_pop_to(scratch, mark);\n    return valid;\n}\n\nstatic bool check_input(",
        "    arena_pop_to(scratch, mark);\n    if (getenv(\"BUSTER_603_WORK\") != NULL)\n    {\n        fprintf(stderr, \"603-work tokens=%u root_queries=%llu root_visits=%llu warning_visits=%llu index_nodes=%llu\\n\", count, (unsigned long long)nested_root_queries, (unsigned long long)nested_root_visits, (unsigned long long)nested_warning_visits, (unsigned long long)nested_index_nodes);\n    }\n    return valid;\n}\n\nstatic bool check_input(");
    if (head)
    {
        valid = valid && replace(root, "c_check_input.c", "static uint32_t check_input_range_root(const CheckInputReader* reader, uint32_t first, uint32_t end)\n{",
            "static uint32_t check_input_range_root(const CheckInputReader* reader, uint32_t first, uint32_t end)\n{\n    nested_root_queries += 1;");
        valid = valid && replace(root, "c_check_warning_input.c", "    uint8_t* warnings = reader->output->constant_warnings;",
            "    nested_warning_visits += finish - begin;\n    uint8_t* warnings = reader->output->constant_warnings;");
        valid = valid && replace(root, "c_check_warning_input.c", "                const CheckInputWarningInterval interval = stack[--depth];",
            "                const CheckInputWarningInterval interval = stack[--depth];\n                nested_index_nodes += 1;");
        valid = valid && replace(root, "c_check_warning_input.c", "            for (uint32_t token = first; token < end; token += 1)\n            {",
            "            for (uint32_t token = first; token < end; token += 1)\n            {\n                nested_warning_visits += 1;");
    }
    else
    {
        valid = valid && replace(root, "c_check_select.c", "static uint32_t check_input_selection_root(const Parser* parser, uint32_t first, uint32_t end)\n{",
            "static uint32_t check_input_selection_root(const Parser* parser, uint32_t first, uint32_t end)\n{\n    nested_root_queries += 1;");
        valid = valid && replace(root, "c_check_select.c", "    for (uint32_t token = first; token < end; token += 1)\n    {\n        const uint32_t parent = parser->tree.parents[token];",
            "    for (uint32_t token = first; token < end; token += 1)\n    {\n        nested_root_visits += 1;\n        const uint32_t parent = parser->tree.parents[token];");
        valid = valid && replace(root, "c_check_constant.c", "static uint32_t check_constant_range_root(const CheckConstantInput* input, uint32_t first, uint32_t end)\n{",
            "static uint32_t check_constant_range_root(const CheckConstantInput* input, uint32_t first, uint32_t end)\n{\n    nested_root_queries += 1;");
        valid = valid && replace(root, "c_check_constant.c", "    for (uint32_t token = first; !input->raw && token < end; token += 1)\n    {",
            "    for (uint32_t token = first; !input->raw && token < end; token += 1)\n    {\n        nested_root_visits += 1;");
        valid = valid && replace(root, "c_check_constant.c", "        for (uint32_t token = first; token < end; token += 1)\n        {\n            const bool independent",
            "        for (uint32_t token = first; token < end; token += 1)\n        {\n            nested_warning_visits += 1;\n            const bool independent");
        valid = valid && replace(root, "c_check_constant.c", "        for (uint32_t token = first; token < end; token += 1)\n        {\n            if (reader->constant_contexts",
            "        for (uint32_t token = first; token < end; token += 1)\n        {\n            nested_warning_visits += 1;\n            if (reader->constant_contexts");
    }
    return valid ? 0 : 1;
}
