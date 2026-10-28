// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original GNU make protocol probe. It holds the granted ownership for 20 ms and publishes bounded event records.
#define _GNU_SOURCE
#include <stdlib.h>
#include <time.h>
#include "../issue-673/src/buster/compiler/worker_budget.c"

static uint64_t probe_now(void)
{
    struct timespec value;
    clock_gettime(CLOCK_MONOTONIC, &value);
    return (uint64_t)value.tv_sec * UINT64_C(1000000000) + (uint64_t)value.tv_nsec;
}

int main(int argc, char** argv)
{
    WorkerBudget budget;
    worker_budget_initialize(&budget, getenv("MAKEFLAGS"), 8);
    WorkerBudgetLease lease = { .control = -1, .reply = -1, .child = -1 };
    const uint32_t granted = worker_budget_acquire(&budget, 8, &lease);
    const char* label = argc == 2 ? argv[1] : "manual";
    char line[256];
    int bytes = snprintf(line, sizeof(line), "start %s %ld %llu %u %u\n", label, (long)getpid(), (unsigned long long)probe_now(), granted, (unsigned)budget.mode);
    bool valid = bytes > 0 && (uint32_t)bytes < sizeof(line) && write(STDOUT_FILENO, line, (size_t)bytes) == bytes;
    const struct timespec duration = { .tv_nsec = 20000000 };
    nanosleep(&duration, NULL);
    bytes = snprintf(line, sizeof(line), "end %s %ld %llu %u %u\n", label, (long)getpid(), (unsigned long long)probe_now(), granted, (unsigned)budget.mode);
    valid = valid && bytes > 0 && (uint32_t)bytes < sizeof(line) && write(STDOUT_FILENO, line, (size_t)bytes) == bytes;
    valid = worker_budget_release(&lease) && valid;
    worker_budget_close(&budget);
    return !valid;
}
