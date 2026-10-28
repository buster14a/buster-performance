// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Compile the actual policy with one representable canonical row, with/without its KNOWN marker.
// Test definition and extern-declaration modes; no production source is modified.
#define _POSIX_C_SOURCE 200809L
#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>

static bool write_text(const char* path, const char* text)
{
    FILE* file = fopen(path, "w");
    bool passed = file != NULL;
    if (file != NULL)
    {
        passed = fputs(text, file) >= 0 && fflush(file) == 0 && !ferror(file);
        passed &= fclose(file) == 0;
    }
    return passed;
}

static bool diagnostic_matches(const char* path, bool missing_marker)
{
    FILE* file = fopen(path, "r");
    bool passed = file != NULL;
    if (file != NULL)
    {
        char bytes[32768];
        const size_t count = fread(bytes, 1, sizeof(bytes) - 1, file);
        bytes[count] = 0;
        passed = !ferror(file) && feof(file);
        passed &= missing_marker ? strstr(bytes, "explicit target row must be classified: NOP") != NULL : count == 0;
        passed &= fclose(file) == 0;
    }
    return passed;
}

static int compile_case(char* compiler, char* include_root, char* overlay, char* fixture, char* diagnostic, bool declarations)
{
    int result = -1;
    const pid_t child = fork();
    if (child == 0)
    {
        const int output = open(diagnostic, O_WRONLY | O_CREAT | O_TRUNC, 0600);
        if (output < 0 || dup2(output, STDOUT_FILENO) < 0 || dup2(output, STDERR_FILENO) < 0)
        {
            _exit(126);
        }
        close(output);
        char* arguments[] = {
            compiler,
            "-std=gnu17",
            "-march=native",
            "-fsyntax-only",
            "-Wall",
            "-Wextra",
            "-Werror",
            "-I", overlay,
            "-I", include_root,
            declarations ? "-DBUSTER_X86_TARGET_DATA_ELSEWHERE=1" : "-DBUSTER_X86_TARGET_DATA=static",
            fixture,
            NULL,
        };
        execv(compiler, arguments);
        _exit(127);
    }
    if (child > 0)
    {
        int status = 0;
        pid_t waited;
        do
        {
            waited = waitpid(child, &status, 0);
        } while (waited < 0 && errno == EINTR);
        if (waited == child && WIFEXITED(status))
        {
            result = WEXITSTATUS(status);
        }
    }
    return result;
}

int main(int argc, char** argv)
{
    bool passed = argc == 4;
    char include_root[4096];
    char fixture[4096];
    if (passed)
    {
        passed = snprintf(include_root, sizeof(include_root), "%s/src", argv[2]) < (int)sizeof(include_root);
        passed &= snprintf(fixture, sizeof(fixture), "%s/fixture.c", argv[3]) < (int)sizeof(fixture);
        passed &= mkdir(argv[3], 0700) == 0;
    }
    if (passed)
    {
        passed = write_text(fixture,
            "#include <stdio.h>\n#include <stdint.h>\n#include <stdbool.h>\n#include <string.h>\n#include <stdlib.h>\n"
            "#pragma clang diagnostic ignored \"-Wunused-function\"\n"
            "#pragma clang diagnostic ignored \"-Wunterminated-string-initialization\"\n"
            "#include \"buster/compiler/x86_64_encoder.c\"\n"
            "#include \"buster/compiler/x86_target_forms.c\"\n"
            "int main(void) { return 0; }\n");
    }
    for (unsigned declarations = 0; passed && declarations < 2; declarations += 1)
    {
        for (unsigned missing = 0; passed && missing < 2; missing += 1)
        {
            char overlay[4096];
            char buster[4096];
            char directory[4096];
            char rows[4096];
            char diagnostic[4096];
            passed = snprintf(overlay, sizeof(overlay), "%s/%s-%s", argv[3], declarations ? "extern" : "definition", missing ? "missing" : "known") < (int)sizeof(overlay);
            passed &= snprintf(buster, sizeof(buster), "%s/buster", overlay) < (int)sizeof(buster);
            passed &= snprintf(directory, sizeof(directory), "%s/buster/compiler", overlay) < (int)sizeof(directory);
            passed &= snprintf(rows, sizeof(rows), "%s/x86_target_rows.c", directory) < (int)sizeof(rows);
            passed &= snprintf(diagnostic, sizeof(diagnostic), "%s/diagnostics.log", overlay) < (int)sizeof(diagnostic);
            if (passed)
            {
                passed = mkdir(overlay, 0700) == 0 && mkdir(buster, 0700) == 0 && mkdir(directory, 0700) == 0;
                passed &= write_text(rows, missing ?
                    "BUSTER_X86_TARGET_REQUIREMENT(NOP, BUSTER_X86_FEATURE(SSE2))\n" :
                    "BUSTER_X86_TARGET_REQUIREMENT(NOP, BUSTER_X86_TARGET_KNOWN | BUSTER_X86_FEATURE(SSE2))\n");
            }
            if (passed)
            {
                const int status = compile_case(argv[1], include_root, overlay, fixture, diagnostic, declarations != 0);
                passed = status == (missing ? 1 : 0) && diagnostic_matches(diagnostic, missing != 0);
                printf("known-row guard: %s %s status=%d: %s\n", declarations ? "extern" : "definition", missing ? "missing" : "known", status, passed ? "pass" : "FAIL");
            }
        }
    }
    passed &= fflush(stdout) == 0 && !ferror(stdout);
    if (!passed)
    {
        fprintf(stderr, "known-row guard controls failed (arguments: clang source-root new-output-directory)\n");
    }
    return passed ? 0 : 1;
}
