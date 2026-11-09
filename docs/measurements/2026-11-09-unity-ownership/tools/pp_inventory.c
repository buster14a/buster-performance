// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and README.md.

#include <dirent.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
int main(void)
{
    const char* arches[] = { "x86-64", "znver5" };
    puts("unit\tmode\tbaseline_preprocessed_bytes\tfinal_preprocessed_bytes\tremoved_bytes");
    for (unsigned arch = 0; arch < 2; arch += 1)
    {
        int64_t before = 0;
        int64_t after = 0;
        unsigned count = 0;
        DIR* directory = opendir("../baseline-pp");
        for (struct dirent* entry = readdir(directory); entry != 0; entry = readdir(directory))
        {
            if (strstr(entry->d_name, arches[arch]) == 0 || strstr(entry->d_name, ".i") == 0) { continue; }
            char path[4096];
            struct stat first;
            struct stat last;
            snprintf(path, sizeof(path), "../baseline-pp/%s", entry->d_name);
            if (stat(path, &first) != 0) { return 1; }
            snprintf(path, sizeof(path), "../final-pp/%s", entry->d_name);
            if (stat(path, &last) != 0) { return 2; }
            before += first.st_size;
            after += last.st_size;
            count += 1;
            printf("%s\t%s\t%lld\t%lld\t%lld\n", entry->d_name, arches[arch], (long long)first.st_size, (long long)last.st_size, (long long)(first.st_size - last.st_size));
        }
        closedir(directory);
        printf("TOTAL_%u\t%s\t%lld\t%lld\t%lld\n", count, arches[arch], (long long)before, (long long)after, (long long)(before - after));
    }
    return 0;
}
