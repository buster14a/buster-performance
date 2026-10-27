// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original diagnostic: retain this process's mapping counters at normal exit, after compiler arena cleanup.
#include <stdio.h>
#include <stdlib.h>

__attribute__((destructor)) static void rss_probe(void)
{
    const char* path = getenv("BUSTER_RSS_RECORD");
    FILE* input = path != NULL ? fopen("/proc/self/smaps", "r") : NULL;
    FILE* output = input != NULL ? fopen(path, "w") : NULL;
    char line[2048];
    while (output != NULL && fgets(line, sizeof(line), input) != NULL)
    {
        fputs(line, output);
    }
    if (input != NULL)
    {
        fclose(input);
    }
    if (output != NULL)
    {
        fclose(output);
    }
}
