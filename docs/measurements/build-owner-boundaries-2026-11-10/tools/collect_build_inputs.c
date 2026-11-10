// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Run from a Buster checkout with its selected toolchain and BUSTER_* settings.
// Capture the actual source/flag inventories, each source's dependency file,
// and preprocessed byte counts. This records work, never timing claims.
#define _POSIX_C_SOURCE 200809L
#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

static int run(char* const* arguments, const char* output)
{
    int result = 1;
    const pid_t child = fork();
    if (child == 0)
    {
        if (output != NULL)
        {
            const int descriptor = open(output, O_WRONLY | O_CREAT | O_TRUNC, 0666);
            if (descriptor < 0 || dup2(descriptor, STDOUT_FILENO) < 0)
            {
                _exit(126);
            }
            close(descriptor);
        }
        execvp(arguments[0], arguments);
        _exit(127);
    }
    if (child > 0)
    {
        int status = 0;
        pid_t waited;
        do
        {
            waited = waitpid(child, &status, 0);
        }
        while (waited < 0 && errno == EINTR);
        if (waited == child && WIFEXITED(status))
        {
            result = WEXITSTATUS(status);
        }
    }
    return result;
}

static uint32_t read_arguments(const char* path, char** arguments, uint32_t capacity, char** storage)
{
    uint32_t count = 0;
    struct stat info;
    FILE* file = fopen(path, "rb");
    if (file == NULL || fstat(fileno(file), &info) != 0 || info.st_size <= 0 || info.st_size > 1024 * 1024)
    {
        fprintf(stderr, "invalid argument capture: %s\n", path);
        exit(1);
    }
    *storage = malloc((size_t)info.st_size);
    if (*storage == NULL || fread(*storage, 1, (size_t)info.st_size, file) != (size_t)info.st_size ||
        (*storage)[info.st_size - 1] != '\0' || fclose(file) != 0)
    {
        fprintf(stderr, "cannot read argument capture: %s\n", path);
        exit(1);
    }
    for (size_t offset = 0; offset < (size_t)info.st_size;)
    {
        if (count == capacity || (*storage)[offset] == '\0')
        {
            fprintf(stderr, "invalid argument inventory: %s\n", path);
            exit(1);
        }
        arguments[count++] = *storage + offset;
        offset += strlen(*storage + offset) + 1;
    }
    return count;
}

int main(int argc, char** argv)
{
    int result = 0;
    if (argc != 2)
    {
        fprintf(stderr, "usage: collect-build-inputs OUTPUT_DIRECTORY\n");
        result = 2;
    }
    if (result == 0 && mkdir(argv[1], 0777) != 0 && errno != EEXIST)
    {
        perror(argv[1]);
        result = 1;
    }
    char source_path[4096];
    char flags_path[4096];
    char summary_path[4096];
    if (result == 0)
    {
        if (snprintf(source_path, sizeof(source_path), "%s/sources.argv", argv[1]) >= (int)sizeof(source_path) ||
            snprintf(flags_path, sizeof(flags_path), "%s/flags.argv", argv[1]) >= (int)sizeof(flags_path) ||
            snprintf(summary_path, sizeof(summary_path), "%s/preprocessed.tsv", argv[1]) >= (int)sizeof(summary_path))
        {
            result = 1;
        }
    }
    if (result == 0)
    {
        char* const source_command[] = { "./build.sh", "print-sources", NULL };
        char* const flags_command[] = { "./build.sh", "print-compile-flags", NULL };
        result = run(source_command, source_path);
        if (result == 0)
        {
            result = run(flags_command, flags_path);
        }
        if (result == 0)
        {
            // CMake adds this map to real native object commands. Match it here so __FILE__ strings do not
            // charge a different number of bytes merely because the two checkouts have different directory names.
            char checkout[4096];
            char prefix_map[8192];
            FILE* flags = fopen(flags_path, "ab");
            if (flags == NULL || getcwd(checkout, sizeof(checkout)) == NULL)
            {
                fprintf(stderr, "cannot capture source-prefix mapping\n");
                exit(1);
            }
            const int length = snprintf(prefix_map, sizeof(prefix_map), "-fmacro-prefix-map=%s/=", checkout);
            if (length < 0 || (size_t)length >= sizeof(prefix_map) ||
                fwrite(prefix_map, 1, (size_t)length + 1, flags) != (size_t)length + 1 || fclose(flags) != 0)
            {
                fprintf(stderr, "cannot record source-prefix mapping\n");
                exit(1);
            }
        }
    }
    if (result == 0)
    {
        char* sources[256];
        char* flags[256];
        char* source_storage = NULL;
        char* flag_storage = NULL;
        const uint32_t source_count = read_arguments(source_path, sources, 256, &source_storage);
        const uint32_t flag_count = read_arguments(flags_path, flags, 256, &flag_storage);
        FILE* summary = fopen(summary_path, "wb");
        if (summary == NULL)
        {
            perror(summary_path);
            exit(1);
        }
        fprintf(summary, "source\tunity\tpreprocessed_bytes\n");
        uint64_t total = 0;
        uint64_t unity_total = 0;
        uint32_t unity_count = 0;
        for (uint32_t i = 0; i < source_count && result == 0; i += 1)
        {
            const char* base = strrchr(sources[i], '/');
            base = base != NULL ? base + 1 : sources[i];
            char dependency_path[4096];
            char preprocessed_path[4096];
            if (snprintf(dependency_path, sizeof(dependency_path), "%s/%s.d", argv[1], base) >= (int)sizeof(dependency_path) ||
                snprintf(preprocessed_path, sizeof(preprocessed_path), "%s/%s.i", argv[1], base) >= (int)sizeof(preprocessed_path))
            {
                result = 1;
                break;
            }
            char* arguments[280];
            uint32_t count = 0;
            arguments[count++] = "clang";
            for (uint32_t j = 0; j < flag_count; j += 1)
            {
                arguments[count++] = flags[j];
            }
            arguments[count++] = "-E";
            arguments[count++] = "-P";
            arguments[count++] = "-MD";
            arguments[count++] = "-MF";
            arguments[count++] = dependency_path;
            arguments[count++] = "-MT";
            arguments[count++] = (char*)base;
            arguments[count++] = "-o";
            arguments[count++] = preprocessed_path;
            arguments[count++] = sources[i];
            arguments[count] = NULL;
            result = run(arguments, NULL);
            struct stat info;
            if (result == 0 && stat(preprocessed_path, &info) != 0)
            {
                result = 1;
            }
            if (result == 0)
            {
                const bool unity = strcmp(base, "main.c") == 0 || strncmp(base, "main_unit_", 10) == 0;
                fprintf(summary, "%s\t%u\t%lld\n", sources[i], unity, (long long)info.st_size);
                total += (uint64_t)info.st_size;
                if (unity)
                {
                    unity_total += (uint64_t)info.st_size;
                    unity_count += 1;
                }
                if (unlink(preprocessed_path) != 0)
                {
                    result = 1;
                }
            }
        }
        if (fclose(summary) != 0)
        {
            result = 1;
        }
        if (result == 0)
        {
            printf("units=%u unity_units=%u total_bytes=%llu unity_bytes=%llu\n", source_count, unity_count,
                   (unsigned long long)total, (unsigned long long)unity_total);
        }
        free(source_storage);
        free(flag_storage);
    }
    return result;
}
