// Temporary #937 harness: one worker-budget lease's acquire and release costs, driving the compiler's guardian protocol
// exactly as worker_budget_acquire/release do, but without the compiler's other work around it.
//
// Build: clang -O2 -o lease_cost lease_cost.c
// Run:   lease_cost BINARY TOKENS ITERATIONS
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <spawn.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

typedef struct Sample
{
    uint64_t acquire;
    uint64_t release;
    uint64_t total;
} Sample;

static uint64_t now_ns(void)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC_RAW, &t);
    return (uint64_t)t.tv_sec * UINT64_C(1000000000) + (uint64_t)t.tv_nsec;
}

static bool read_all(int fd, void* data, size_t count)
{
    size_t done = 0;
    bool valid = true;
    while (valid && done < count)
    {
        const ssize_t got = read(fd, (char*)data + done, count - done);
        valid = got > 0 || (got < 0 && errno == EINTR);
        done += got > 0 ? (size_t)got : 0;
    }
    return valid;
}

static bool write_all(int fd, const void* data, size_t count)
{
    size_t done = 0;
    bool valid = true;
    while (valid && done < count)
    {
        const ssize_t put = write(fd, (const char*)data + done, count - done);
        valid = put > 0 || (put < 0 && errno == EINTR);
        done += put > 0 ? (size_t)put : 0;
    }
    return valid;
}

static int compare_u64(const void* left, const void* right)
{
    const uint64_t a = *(const uint64_t*)left;
    const uint64_t b = *(const uint64_t*)right;
    return a < b ? -1 : a > b;
}

static uint64_t median(uint64_t* values, uint32_t count)
{
    qsort(values, count, sizeof(*values), compare_u64);
    return values[count / 2];
}

// Copies one sample's report to standard output and returns it.
static Sample measure(const char* binary, uint32_t tokens)
{
    Sample sample = { 0 };
    int jobs[2] = { -1, -1 };
    int control[2] = { -1, -1 };
    int reply[2] = { -1, -1 };
    uint8_t* token_bytes = malloc(tokens);
    for (uint32_t i = 0; i < tokens; i += 1)
    {
        token_bytes[i] = (uint8_t)('+' + (i & 7));
    }
    const bool opened = pipe(jobs) == 0 && pipe(control) == 0 && pipe(reply) == 0 && write_all(jobs[1], token_bytes, tokens);
    char read_text[16], write_text[16], control_text[16], reply_text[16], maximum_text[16];
    snprintf(read_text, sizeof(read_text), "%d", jobs[0]);
    snprintf(write_text, sizeof(write_text), "%d", jobs[1]);
    snprintf(control_text, sizeof(control_text), "%d", control[0]);
    snprintf(reply_text, sizeof(reply_text), "%d", reply[1]);
    snprintf(maximum_text, sizeof(maximum_text), "%u", tokens);
    char* arguments[] = { (char*)binary, "--buster-worker-budget-guardian", read_text, write_text, control_text, reply_text, maximum_text, NULL };
    posix_spawn_file_actions_t actions;
    posix_spawn_file_actions_init(&actions);
    for (uint32_t i = 0; i < 4; i += 1)
    {
        const int fd = i == 0 ? jobs[0] : i == 1 ? jobs[1] : i == 2 ? control[0] : reply[1];
        posix_spawn_file_actions_adddup2(&actions, fd, fd);
    }
    pid_t child = -1;
    const uint64_t acquire_begin = now_ns();
    const bool spawned = opened && posix_spawn(&child, binary, &actions, NULL, arguments, environ) == 0;
    posix_spawn_file_actions_destroy(&actions);
    if (control[0] >= 0)
    {
        close(control[0]);
    }
    if (reply[1] >= 0)
    {
        close(reply[1]);
    }
    uint32_t granted = 0;
    const bool got_grant = spawned && read_all(reply[0], &granted, sizeof(granted));
    const uint64_t acquire_end = now_ns();
    bool released = true;
    if (spawned)
    {
        close(control[1]);
        control[1] = -1;
    }
    uint8_t acknowledged = 0;
    const bool got_ack = spawned && read_all(reply[0], &acknowledged, 1);
    int status = 0;
    pid_t waited = -1;
    if (spawned)
    {
        do
        {
            waited = waitpid(child, &status, 0);
        }
        while (waited < 0 && errno == EINTR);
    }
    const uint64_t release_end = now_ns();
    // The guardian wrote all N bytes back before its acknowledgement.
    uint8_t* returned = malloc(tokens);
    const bool got_tokens = spawned && read_all(jobs[0], returned, tokens) && memcmp(returned, token_bytes, tokens) == 0;
    released = spawned && got_grant && got_ack && acknowledged == 1 && waited == child && WIFEXITED(status) && WEXITSTATUS(status) == 0 && got_tokens;
    sample.acquire = acquire_end - acquire_begin;
    sample.release = release_end - acquire_end;
    sample.total = release_end - acquire_begin;
    if (control[1] >= 0)
    {
        close(control[1]);
    }
    if (jobs[0] >= 0)
    {
        close(jobs[0]);
    }
    if (jobs[1] >= 0)
    {
        close(jobs[1]);
    }
    if (reply[0] >= 0)
    {
        close(reply[0]);
    }
    free(token_bytes);
    free(returned);
    if (!released)
    {
        fprintf(stderr, "lease_cost: lease did not return cleanly (granted=%u acknowledged=%u)\n", granted, acknowledged);
        exit(1);
    }
    return sample;
}

int main(int argc, char** argv)
{
    if (argc != 4)
    {
        fprintf(stderr, "usage: %s BINARY TOKENS ITERATIONS\n", argv[0]);
        return 2;
    }
    const uint32_t tokens = (uint32_t)strtoul(argv[2], NULL, 10);
    const uint32_t iterations = (uint32_t)strtoul(argv[3], NULL, 10);
    if (tokens == 0 || tokens >= 64 || iterations == 0)
    {
        fprintf(stderr, "lease_cost: tokens must be 1 to 63 and iterations positive\n");
        return 2;
    }
    Sample* samples = calloc(iterations, sizeof(*samples));
    uint64_t* acquires = calloc(iterations, sizeof(*acquires));
    uint64_t* releases = calloc(iterations, sizeof(*releases));
    uint64_t* totals = calloc(iterations, sizeof(*totals));
    for (uint32_t i = 0; i < iterations; i += 1)
    {
        samples[i] = measure(argv[1], tokens);
        acquires[i] = samples[i].acquire;
        releases[i] = samples[i].release;
        totals[i] = samples[i].total;
        printf("lease\t%u\tacquire_ns=%llu\trelease_ns=%llu\ttotal_ns=%llu\n", i, (unsigned long long)samples[i].acquire,
               (unsigned long long)samples[i].release, (unsigned long long)samples[i].total);
    }
    printf("median\ttokens=%u\tsamples=%u\tacquire_ns=%llu\trelease_ns=%llu\ttotal_ns=%llu\n", tokens, iterations, (unsigned long long)median(acquires, iterations),
           (unsigned long long)median(releases, iterations), (unsigned long long)median(totals, iterations));
    free(samples);
    free(acquires);
    free(releases);
    free(totals);
    return 0;
}
