#define _GNU_SOURCE
#include "../issue-673/src/buster/compiler/worker_budget.c"
int main(void)
{
    int descriptors[2];
    if (pipe(descriptors) != 0) return 2;
    const char bytes[] = "abc";
    if (write(descriptors[1], bytes, 3) != 3) return 2;
    char flags[128];
    snprintf(flags, sizeof(flags), " -j4 --jobserver-auth=%d,%d", descriptors[0], descriptors[1]);
    WorkerBudget budget = { .maximum = 8, .makeflags = flags };
    WorkerBudgetLease lease;
    const uint32_t active = worker_budget_acquire(&budget, 8, &lease);
    const bool returned = worker_budget_release(&lease);
    char result[3];
    const bool exact = read(descriptors[0], result, 3) == 3 && memcmp(result, bytes, 3) == 0;
    printf("active=%u returned=%u exact=%u\n", active, returned, exact);
    return active != 4 || !returned || !exact;
}
