// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original validation harness for buster issue #1384, written in this session.
// Generates source shapes, compact semantic references, and a separate driver.
// No external implementation or fixture is imported. Clang compiles references
// externally; their bounded syntax avoids its recursion on huge flat chains.
// The run subcommand records Linux wait4 peak RSS, without reporting timings.
#define _GNU_SOURCE
#include <errno.h>
#include <limits.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/resource.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#define BUSTER_MAX_SHAPE_COUNT 1000000u

static bool parse_count(const char *text, unsigned *count)
{
    char *end = NULL;
    errno = 0;
    unsigned long value = strtoul(text, &end, 10);
    bool valid = text[0] >= '0' && text[0] <= '9' && errno == 0 && end != text && *end == 0 && value >= 1 && value <= BUSTER_MAX_SHAPE_COUNT;
    if (valid)
    {
        *count = (unsigned)value;
    }
    return valid;
}

static bool known_shape(const char *shape)
{
    bool known = strcmp(shape, "or") == 0 || strcmp(shape, "and") == 0 || strcmp(shape, "statements") == 0 || strcmp(shape, "nonlocal") == 0 || strcmp(shape, "frame") == 0 || strcmp(shape, "frame_local") == 0 || strcmp(shape, "loops") == 0 || strcmp(shape, "returns") == 0;
    return known;
}

static bool generate_shape(FILE *file, const char *shape, unsigned count)
{
    fprintf(file, "/* Original generated #1384 fixture: %s, n=%u. */\n", shape, count);
    fputs("extern int g(int);\nextern void h(int);\nextern void h_bytes(const unsigned char *, unsigned);\n", file);
    if (strcmp(shape, "frame_local") == 0)
    {
        fputs("extern void take(char *);\n", file);
    }
    fputs("\nint f(int a)\n{\n", file);
    if (strcmp(shape, "or") == 0 || strcmp(shape, "and") == 0)
    {
        bool conjunction = strcmp(shape, "and") == 0;
        const char *comparison = conjunction ? "!=" : "==";
        const char *operator = conjunction ? " &&\n" : " ||\n";
        fputs("    return ", file);
        for (unsigned index = 0; index < count; ++index)
        {
            fprintf(file, "%sa %s %u", index == 0 ? "" : "           ", comparison, index);
            fputs(index + 1 == count ? ";\n" : operator, file);
        }
    }
    else if (strcmp(shape, "statements") == 0)
    {
        fputs("    int r = 0;\n", file);
        for (unsigned index = 0; index < count; ++index)
        {
            fprintf(file, "    r = r || g(a + %u);\n", index);
        }
        fputs("    return r;\n", file);
    }
    else if (strcmp(shape, "nonlocal") == 0)
    {
        for (unsigned index = 0; index < count; ++index)
        {
            fprintf(file, "    {\n        int t = g(a + %u);\n        if (a > %u)\n        {\n            h(t);\n        }\n    }\n", index, index);
        }
        fputs("    return a;\n", file);
    }
    else if (strcmp(shape, "frame") == 0)
    {
        for (unsigned index = 0; index < count; ++index)
        {
            fprintf(file, "    {\n        unsigned char bytes[32] = {0};\n        bytes[0] = (unsigned char)((unsigned)a + %uu);\n        bytes[31] = (unsigned char)%uu;\n        h_bytes(bytes, 32u);\n        if (a == %u)\n        {\n            return (int)bytes[0];\n        }\n    }\n", index, index, index);
        }
        fputs("    return a;\n", file);
    }
    else if (strcmp(shape, "frame_local") == 0)
    {
        for (unsigned index = 0; index < count; ++index)
        {
            fprintf(file, "    {\n        char buf[32];\n        if (a == %u)\n        {\n            take(buf);\n        }\n    }\n", index);
        }
        fputs("    return a;\n", file);
    }
    else if (strcmp(shape, "loops") == 0)
    {
        fputs("    unsigned sum = 0;\n", file);
        for (unsigned index = 0; index < count; ++index)
        {
            fprintf(file, "    for (int i = 0; i < (int)((unsigned)a & 7u); ++i)\n    {\n        sum += (unsigned)(i + a + %u);\n    }\n", index);
        }
        fputs("    return (int)(sum & 0x7fffffffu);\n", file);
    }
    else if (strcmp(shape, "returns") == 0)
    {
        for (unsigned index = 0; index < count; ++index)
        {
            fprintf(file, "    if (a == %u)\n    {\n        return %u;\n    }\n", index, index * 7);
        }
        fputs("    return -1;\n", file);
    }
    fputs("}\n", file);
    return ferror(file) == 0;
}

static bool generate_reference(FILE *file, const char *shape, unsigned count)
{
    fprintf(file, "/* Original compact #1384 semantic reference: %s, n=%u. */\n", shape, count);
    fputs("extern int g(int);\nextern void h(int);\nextern void h_bytes(const unsigned char *, unsigned);\n", file);
    if (strcmp(shape, "frame_local") == 0)
    {
        fputs("extern void take(char *);\n", file);
    }
    fputs("\nint f(int a)\n{\n", file);
    if (strcmp(shape, "or") == 0)
    {
        fprintf(file, "    return (unsigned)a < %uu;\n", count);
    }
    else if (strcmp(shape, "and") == 0)
    {
        fprintf(file, "    return (unsigned)a >= %uu;\n", count);
    }
    else if (strcmp(shape, "statements") == 0)
    {
        fputs("    int r = 0;\n", file);
        fprintf(file, "    for (int i = 0; i < %u && !r; ++i)\n", count);
        fputs("    {\n        r = g(a + i) != 0;\n    }\n    return r;\n", file);
    }
    else if (strcmp(shape, "nonlocal") == 0)
    {
        fprintf(file, "    for (int i = 0; i < %u; ++i)\n", count);
        fputs("    {\n        int t = g(a + i);\n        if (a > i)\n        {\n            h(t);\n        }\n    }\n    return a;\n", file);
    }
    else if (strcmp(shape, "frame") == 0)
    {
        fprintf(file, "    for (unsigned i = 0; i < %uu; ++i)\n", count);
        fputs("    {\n        unsigned char bytes[32] = {0};\n        bytes[0] = (unsigned char)((unsigned)a + i);\n        bytes[31] = (unsigned char)i;\n        h_bytes(bytes, 32u);\n        if (a == (int)i)\n        {\n            return (int)bytes[0];\n        }\n    }\n    return a;\n", file);
    }
    else if (strcmp(shape, "frame_local") == 0)
    {
        fprintf(file, "    for (int i = 0; i < %u; ++i)\n", count);
        fputs("    {\n        char buf[32];\n        if (a == i)\n        {\n            take(buf);\n        }\n    }\n    return a;\n", file);
    }
    else if (strcmp(shape, "loops") == 0)
    {
        // Sum i + a + scope over k iterations and count scopes. The wide sum
        // stays below 2^64 for the accepted count/input bounds. Conversion to
        // unsigned reproduces the fixture's defined modulo-2^32 additions.
        fprintf(file, "    const unsigned long long n = %uu;\n", count);
        fputs("    const unsigned long long k = (unsigned)a & 7u;\n"
              "    const unsigned long long row = k * (unsigned)a + k * (k + 1u) / 2u - k;\n"
              "    const unsigned sum = (unsigned)(n * row + k * n * (n - 1u) / 2u);\n"
              "    return (int)(sum & 0x7fffffffu);\n", file);
    }
    else if (strcmp(shape, "returns") == 0)
    {
        fputs("    int result = -1;\n", file);
        fprintf(file, "    if ((unsigned)a < %uu)\n", count);
        fputs("    {\n        result = a * 7;\n    }\n    return result;\n", file);
    }
    fputs("}\n", file);
    return ferror(file) == 0;
}

static bool generate_driver(FILE *file, unsigned count)
{
    // Each invocation resets the observable hash. All hash arithmetic is unsigned.
    // The count cap and input bounds keep every generated signed addition in range.
    fputs("/* Original #1384 semantic driver; compile separately from f. */\n"
          "#include <inttypes.h>\n#include <stdint.h>\n#include <stdio.h>\n\n"
          "extern int f(int);\n"
          "static uint64_t trace_hash;\n"
          "static uint64_t g_calls;\n"
          "static uint64_t h_calls;\n"
          "static uint64_t byte_calls;\n\n"
          "static void record(unsigned tag, unsigned value)\n"
          "{\n"
          "    trace_hash = (trace_hash ^ ((uint64_t)tag << 32) ^ value) * UINT64_C(1099511628211);\n"
          "}\n\n"
          "int g(int a)\n"
          "{\n"
          "    unsigned value = (unsigned)a;\n"
          "    ++g_calls;\n"
          "    record(1u, value);\n"
          "    int result = 0;\n"
          "    if ((value & 4095u) == 4093u)\n"
          "    {\n"
          "        result = (int)((value ^ (value >> 8)) & 16383u) + 1;\n"
          "    }\n"
          "    return result;\n"
          "}\n\n"
          "void h(int value)\n"
          "{\n"
          "    ++h_calls;\n"
          "    record(2u, (unsigned)value);\n"
          "}\n\n"
          "void h_bytes(const unsigned char *bytes, unsigned count)\n"
          "{\n"
          "    ++byte_calls;\n"
          "    record(3u, count);\n"
          "    for (unsigned index = 0; index < count; ++index)\n"
          "    {\n"
          "        record(4u, bytes[index]);\n"
          "    }\n"
          "}\n\n"
          "int main(void)\n"
          "{\n", file);
    fprintf(file, "    const int inputs[] = {-2, -1, 0, 1, 2, 15, 16, 127, 511, 4092, 4093, %u, %u, %u, %u};\n", count / 2, count - 1, count, count + 1);
    fputs("    for (unsigned index = 0; index < sizeof(inputs) / sizeof(inputs[0]); ++index)\n"
          "    {\n"
          "        trace_hash = UINT64_C(14695981039346656037);\n"
          "        g_calls = 0;\n"
          "        h_calls = 0;\n"
          "        byte_calls = 0;\n"
          "        int result = f(inputs[index]);\n"
          "        printf(\"a=%d result=%d g=%\" PRIu64 \" h=%\" PRIu64 \" bytes=%\" PRIu64 \" hash=%016\" PRIx64 \"\\n\", inputs[index], result, g_calls, h_calls, byte_calls, trace_hash);\n"
          "    }\n"
          "    return ferror(stdout) == 0 ? 0 : 1;\n"
          "}\n", file);
    return ferror(file) == 0;
}

static bool generate_frame_stub(FILE *file)
{
    // Preserve the driver's existing observations while never reading the
    // original #3521 fixture's indeterminate local bytes or their addresses.
    fputs("/* Original #1384 frame-local stub: no read of indeterminate bytes. */\n"
          "void h(int);\n\n"
          "void take(char *p)\n"
          "{\n"
          "    (void)p;\n"
          "    h(1384);\n"
          "}\n", file);
    return ferror(file) == 0;
}

static void json_string(FILE *file, const char *text)
{
    fputc('"', file);
    for (size_t index = 0; text[index] != 0; ++index)
    {
        unsigned char byte = (unsigned char)text[index];
        if (byte == '"' || byte == '\\')
        {
            fputc('\\', file);
            fputc(byte, file);
        }
        else if (byte < 32 || byte >= 127)
        {
            fprintf(file, "\\u%04x", (unsigned)byte);
        }
        else
        {
            fputc(byte, file);
        }
    }
    fputc('"', file);
}

static int run_child(FILE *file, char **arguments)
{
    int result = 125;
    fflush(NULL);
    pid_t child = fork();
    if (child == 0)
    {
        execvp(arguments[0], arguments);
        perror(arguments[0]);
        _exit(127);
    }
    else if (child < 0)
    {
        perror("fork");
    }
    else
    {
        int status = 0;
        struct rusage usage = {0};
        pid_t waited;
        do
        {
            waited = wait4(child, &status, 0, &usage);
        } while (waited < 0 && errno == EINTR);
        if (waited == child)
        {
            int signal_number = WIFSIGNALED(status) ? WTERMSIG(status) : 0;
            int exit_status = WIFEXITED(status) ? WEXITSTATUS(status) : -1;
            fputs("{\"argv\":[", file);
            for (unsigned index = 0; arguments[index] != NULL; ++index)
            {
                if (index != 0)
                {
                    fputc(',', file);
                }
                json_string(file, arguments[index]);
            }
            fprintf(file, "],\"exit_status\":%d,\"signal\":%d,\"max_rss_kib\":%ld}\n", exit_status, signal_number, usage.ru_maxrss);
            result = signal_number != 0 ? 128 + signal_number : exit_status;
        }
        else
        {
            perror("wait4");
        }
    }
    if (ferror(file) != 0)
    {
        perror("write log");
        result = 125;
    }
    return result;
}

static void usage(const char *program)
{
    fprintf(stderr, "Usage:\n  %s generate SHAPE N PATH\n  %s reference SHAPE N PATH\n  %s driver N PATH\n  %s frame-stub PATH\n  %s run LOG COMMAND [ARG...]\nShapes: or, and, statements, nonlocal, frame, frame_local, loops, returns\nN must be 1..%u. Driver, fixture and reference must use the same N.\n", program, program, program, program, program, BUSTER_MAX_SHAPE_COUNT);
}

int main(int argc, char **argv)
{
    int result = 2;
    unsigned count = 0;
    bool generate = argc == 5 && strcmp(argv[1], "generate") == 0 && known_shape(argv[2]) && parse_count(argv[3], &count);
    bool reference = argc == 5 && strcmp(argv[1], "reference") == 0 && known_shape(argv[2]) && parse_count(argv[3], &count);
    bool driver = argc == 4 && strcmp(argv[1], "driver") == 0 && parse_count(argv[2], &count);
    bool frame_stub = argc == 3 && strcmp(argv[1], "frame-stub") == 0;
    bool run = argc >= 4 && strcmp(argv[1], "run") == 0;
    if (generate || reference || driver || frame_stub || run)
    {
        const char *path = generate || reference ? argv[4] : (driver ? argv[3] : argv[2]);
        FILE *file = fopen(path, "w");
        if (file == NULL)
        {
            perror(path);
        }
        else
        {
            if (generate)
            {
                result = generate_shape(file, argv[2], count) ? 0 : 1;
            }
            else if (reference)
            {
                result = generate_reference(file, argv[2], count) ? 0 : 1;
            }
            else if (driver)
            {
                result = generate_driver(file, count) ? 0 : 1;
            }
            else if (frame_stub)
            {
                result = generate_frame_stub(file) ? 0 : 1;
            }
            else
            {
                result = run_child(file, argv + 3);
            }
            if (fclose(file) != 0)
            {
                perror(path);
                result = 125;
            }
        }
    }
    else
    {
        usage(argv[0]);
    }
    return result;
}
