// Original recovery measurement helper. Generates deterministic C fixtures and measures one whole compiler process.
#define _GNU_SOURCE
#include <errno.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static uint32_t next_value(uint32_t* state)
{
    uint32_t value = *state;
    value ^= value << 13;
    value ^= value >> 17;
    value ^= value << 5;
    *state = value;
    return value;
}

static int generate(const char* path, uint32_t rows, unsigned form)
{
    FILE* file = fopen(path, "w");
    int result = file == NULL;
    uint32_t random = 1;
    if (file != NULL)
    {
        if (form < 2)
        {
            fputs("struct R{int a;unsigned char b;long c;short d;};\n", file);
            fputs(form == 1 ? "int f(unsigned i){static const struct R table[]={\n" : "const struct R table[]={\n", file);
            for (uint32_t row = 0; row < rows; row += 1)
            {
                int32_t a = (int32_t)(next_value(&random) % 200001) - 100000;
                uint32_t b = next_value(&random) % 256;
                int64_t c = (int64_t)next_value(&random) * 256 - (INT64_C(1) << 39);
                int32_t d = (int32_t)(next_value(&random) % 60001) - 30000;
                fprintf(file, "{%" PRId32 ",%" PRIu32 ",%" PRId64 "L,%" PRId32 "},\n", a, b, c, d);
            }
            fputs(form == 1 ? "};return table[i].a+table[i].d;}\n" : "};int f(unsigned i){return table[i].a+table[i].d;}\n", file);
        }
        else if (form == 2)
        {
            fputs("const unsigned table[]={\n", file);
            for (uint32_t row = 0; row < rows; row += 1)
            {
                fprintf(file, "%" PRIu32 ",\n", next_value(&random) % 1000);
            }
            fputs("};unsigned f(unsigned i){return table[i];}\n", file);
        }
        else
        {
            fputs("struct R{int a;double b;};const struct R table[]={\n", file);
            for (uint32_t row = 0; row < rows; row += 1)
            {
                const uint32_t a = next_value(&random) % 1000;
                const uint32_t b = next_value(&random) % 1000;
                fprintf(file, "{%" PRIu32 ",%" PRIu32 ".25},\n", a, b);
            }
            fputs("};int f(unsigned i){return table[i].a+(int)table[i].b;}\n", file);
        }
        result = ferror(file) != 0;
        result |= fclose(file) != 0;
    }
    return result;
}

static int measure(char** argv)
{
    struct timespec start;
    struct timespec stop;
    struct rusage usage = { 0 };
    clock_gettime(CLOCK_MONOTONIC, &start);
    const pid_t child = fork();
    if (child == 0)
    {
        execl(argv[2], argv[2], "-c", "-o", "/dev/null", argv[3], (char*)NULL);
        _exit(127);
    }
    int status = 0;
    pid_t waited = -1;
    do
    {
        waited = child < 0 ? -1 : wait4(child, &status, 0, &usage);
    } while (waited < 0 && errno == EINTR);
    clock_gettime(CLOCK_MONOTONIC, &stop);
    const int result = child < 0 || waited != child || !WIFEXITED(status) ? 128 : WEXITSTATUS(status);
    const int64_t elapsed = (int64_t)(stop.tv_sec - start.tv_sec) * 1000000 + (stop.tv_nsec - start.tv_nsec) / 1000;
    printf("%s\t%s\t%s\t%" PRId64 "\t%ld\t%ld\t%ld\t%d\n", argv[3], argv[4], argv[5], elapsed,
           usage.ru_maxrss, usage.ru_minflt, usage.ru_majflt, result);
    return result;
}

int main(int argc, char** argv)
{
    int result = 2;
    if (argc == 5 && strcmp(argv[1], "generate") == 0)
    {
        result = generate(argv[2], (uint32_t)strtoul(argv[3], NULL, 10), (unsigned)strtoul(argv[4], NULL, 10));
    }
    else if (argc == 6 && strcmp(argv[1], "run") == 0)
    {
        result = measure(argv);
    }
    return result;
}
