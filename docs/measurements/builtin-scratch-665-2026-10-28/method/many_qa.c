// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original per-body/per-lane pool lifetime control, sharing only the checked process/output helpers.
#define main qa_command_main
#include "qa.c"
#undef main

int main(int argc, char** argv)
{
    int status = argc == 7 ? 0 : 1;
    FILE* receipt = NULL;
    if (status == 0)
    {
        char path[4096];
        snprintf(path, sizeof(path), "%s/many-qa.log", argv[5]);
        receipt = fopen(path, "w");
        status = receipt != NULL ? status : 1;
    }
    const char* roles[] = { "clang", "base", "single", "lanes", "scalar" };
    char reference[4096];
    char single[4096];
    for (unsigned role = 0; status == 0 && role < 5; role += 1)
    {
        char object[4096];
        char executable[4096];
        char output[4096];
        char compile_log[4096];
        char link_log[4096];
        snprintf(object, sizeof(object), "%s/many-%s.o", argv[5], roles[role]);
        snprintf(executable, sizeof(executable), "%s/many-%s.exe", argv[5], roles[role]);
        snprintf(output, sizeof(output), "%s/many-%s.txt", argv[5], roles[role]);
        snprintf(compile_log, sizeof(compile_log), "%s/many-%s.compile.log", argv[5], roles[role]);
        snprintf(link_log, sizeof(link_log), "%s/many-%s.link.log", argv[5], roles[role]);
        char* clang[] = { "clang", "-std=gnu17", "-O0", "-fwrapv", "-c", argv[3], "-o", object, NULL };
        char* native[16] = { 0 };
        unsigned arguments = 0;
        native[arguments++] = role == 1 ? argv[1] : argv[2];
        native[arguments++] = "--lanes";
        native[arguments++] = role >= 3 ? argv[6] : "1";
        native[arguments++] = "--verify";
        native[arguments++] = "--time-stages";
        if (role == 4)
        {
            native[arguments++] = "--scalar";
        }
        native[arguments++] = "-std=gnu17";
        native[arguments++] = "-c";
        native[arguments++] = argv[3];
        native[arguments++] = "-o";
        native[arguments++] = object;
        status = run(receipt, role == 0 ? clang : native, compile_log) == 0 ? status : 1;
        if (status == 0)
        {
            char* link[] = { "clang", "-O0", argv[4], object, "-o", executable, NULL };
            status = run(receipt, link, link_log) == 0 ? status : 1;
        }
        if (status == 0)
        {
            char* execute[] = { executable, NULL };
            status = run(receipt, execute, output) == 0 && runtime_valid(output) ? status : 1;
        }
        if (status == 0 && role == 0)
        {
            snprintf(reference, sizeof(reference), "%s", output);
        }
        if (status == 0 && role == 2)
        {
            snprintf(single, sizeof(single), "%s", object);
        }
        if (status == 0 && role != 0)
        {
            const bool same = equal(reference, output);
            fprintf(receipt, "runtime_equal=%u inputs=143 role=%s\n", same, roles[role]);
            status = same ? status : 1;
        }
        if (status == 0 && role >= 3)
        {
            const bool same = equal(single, object);
            fprintf(receipt, "object_equal=%u role=single,%s requested_lanes=%s\n", same, roles[role], argv[6]);
            status = same ? status : 1;
        }
    }
    if (receipt != NULL)
    {
        fprintf(receipt, "many_body_qa_status=%d\n", status);
        fclose(receipt);
    }
    return status;
}
