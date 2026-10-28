// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original probe replacing the benchmark only in an isolated workflow fixture.
#define _GNU_SOURCE
#include <sched.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int topology(unsigned cpu, const char* field)
{
    char path[256];
    snprintf(path, sizeof(path), "/sys/devices/system/cpu/cpu%u/topology/%s", cpu, field);
    FILE* file = fopen(path, "r");
    int value = -1;
    if (file != NULL)
    {
        if (fscanf(file, "%d", &value) != 1) { value = -1; }
        fclose(file);
    }
    return value;
}

int main(int argc, char** argv)
{
    cpu_set_t allowed;
    CPU_ZERO(&allowed);
    int result = sched_getaffinity(0, sizeof(allowed), &allowed) == 0 ? 0 : 1;
    unsigned cpus[8], count = 0, lanes = 0, writer[2] = {0};
    int pairs = 0;
    for (unsigned cpu = 0; cpu < CPU_SETSIZE; cpu += 1)
    {
        if (CPU_ISSET(cpu, &allowed))
        {
            if (count < 8) { cpus[count] = cpu; }
            count += 1;
        }
    }
    for (int i = 0; i + 1 < argc; i += 1)
    {
        if (strcmp(argv[i], "--lanes") == 0) { lanes = (unsigned)strtoul(argv[i + 1], NULL, 10); }
        if (strcmp(argv[i], "--cpus") == 0)
        {
            char trailing;
            pairs = sscanf(argv[i + 1], "%u,%u%c", writer, writer + 1, &trailing);
        }
    }
    result |= count == 0 || count > 8 || lanes != count;
    for (unsigned i = 0; i < count && i < 8; i += 1)
    {
        const int core = topology(cpus[i], "core_id");
        const int socket = topology(cpus[i], "physical_package_id");
        result |= core < 0 || socket < 0;
        for (unsigned j = 0; j < i; j += 1)
        {
            result |= core == topology(cpus[j], "core_id") && socket == topology(cpus[j], "physical_package_id");
        }
    }
    if (count > 1)
    {
        result |= pairs != 2 || writer[0] == writer[1] || writer[0] >= CPU_SETSIZE || writer[1] >= CPU_SETSIZE;
        if (writer[0] < CPU_SETSIZE && writer[1] < CPU_SETSIZE)
        {
            result |= !CPU_ISSET(writer[0], &allowed) || !CPU_ISSET(writer[1], &allowed);
        }
    }
    else { result |= pairs != 0; }
    printf("workflow fixture: allowed=%u lanes=%u writer-arguments=%d result=%d\n", count, lanes, pairs, result);
    return result;
}
