// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original independent event-sweep oracle for real GNU make ownership intervals.
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Event Event;
struct Event
{
    uint64_t time;
    int delta;
};

int main(int argc, char** argv)
{
    bool valid = argc == 4;
    FILE* stream = valid ? fopen(argv[1], "r") : NULL;
    valid = valid && stream != NULL;
    const unsigned limit = valid ? (unsigned)strtoul(argv[2], NULL, 10) : 0;
    const unsigned expected_mode = valid ? (unsigned)strtoul(argv[3], NULL, 10) : 0;
    Event events[64];
    uint32_t count = 0;
    char line[512];
    while (valid && fgets(line, sizeof(line), stream) != NULL)
    {
        char kind[8], label[32];
        long pid;
        unsigned long long time;
        unsigned granted, mode;
        if (sscanf(line, "%7s %31s %ld %llu %u %u", kind, label, &pid, &time, &granted, &mode) == 6 &&
            (strcmp(kind, "start") == 0 || strcmp(kind, "end") == 0))
        {
            valid = count < 64 && granted > 0 && granted <= limit && mode == expected_mode && (mode != 2 || granted == 1);
            if (valid)
            {
                const Event event = { .time = time, .delta = strcmp(kind, "start") == 0 ? (int)granted : -(int)granted };
                uint32_t at = count;
                while (at > 0 && (events[at - 1].time > event.time || (events[at - 1].time == event.time && events[at - 1].delta > event.delta)))
                {
                    events[at] = events[at - 1];
                    at -= 1;
                }
                events[at] = event;
                count += 1;
            }
        }
    }
    if (stream != NULL)
    {
        valid = !ferror(stream) && fclose(stream) == 0 && valid;
    }
    int owned = 0;
    int maximum = 0;
    for (uint32_t e = 0; valid && e < count; e += 1)
    {
        owned += events[e].delta;
        maximum = owned > maximum ? owned : maximum;
        valid = owned >= 0 && owned <= (int)limit;
    }
    valid = valid && count == 32 && owned == 0 && maximum == (int)limit;
    printf("GNU make ownership: %u events, maximum %d / %u, mode %u, %s\n", count, maximum, limit, expected_mode, valid ? "pass" : "FAIL");
    return !valid;
}
