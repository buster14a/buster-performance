// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Read-only report from archived GitHub metadata; use Buster's original bounded JSON reader.
#define _GNU_SOURCE
#include <time.h>
#include "admission_json.h"

static Json read_json(const char* path)
{
    FILE* file = fopen(path, "r");
    if (file == NULL) ci_die("cannot open %s", path);
    Buffer body = {0};
    char bytes[8192];
    size_t count;
    while ((count = fread(bytes, 1, sizeof(bytes), file)) != 0) buffer_add(&body, bytes, count);
    if (ferror(file) || fclose(file) != 0) ci_die("cannot read %s", path);
    Json result = json_parse(body.data);
    free(body.data);
    return result;
}

static int64_t seconds(const char* value)
{
    struct tm utc = {0};
    char* end = strptime(value, "%Y-%m-%dT%H:%M:%SZ", &utc);
    if (end == NULL || *end != 0) ci_die("invalid timestamp: %s", value);
    return (int64_t)timegm(&utc);
}

static void sibling(char* out, size_t size, const char* source, const char* kind, uint64_t id)
{
    const char* slash = strrchr(source, '/');
    size_t prefix = slash != NULL ? (size_t)(slash + 1 - source) : 0;
    int count = snprintf(out, size, "%.*s%s-%" PRIu64 ".json", (int)prefix, source, kind, id);
    if (count < 0 || (size_t)count >= size) ci_die("path too long");
}

int main(int argc, char** argv)
{
    if (argc < 2) ci_die("usage: report before/run-ID.json ...");
    puts("run\tpr\thead\tcreated_at\tjob_started_at\thost_verified_at\tcompleted_at\tevent_to_job_s\tjob_wall_s\tjob_to_host_s\tqualification_after_host_s\tcurrent_head_review_approval");
    for (int at = 1; at < argc; ++at)
    {
        Json run = read_json(argv[at]);
        uint64_t id = json_number(&run, 0, "id");
        size_t prs = json_get(&run, 0, "pull_requests");
        uint64_t pr = prs < run.count && prs + 1 < run.rows[prs].next ? json_number(&run, prs + 1, "number") : 0;
        const char* head = json_field(&run, 0, "head_sha");
        const char* created = json_field(&run, 0, "created_at");
        char path[1024];
        if (pr == 0)
        {
            sibling(path, sizeof(path), argv[at], "associations", id);
            Json associations = read_json(path);
            for (size_t row = 1; row < associations.rows[0].next; row = associations.rows[row].next)
            {
                size_t source = json_get(&associations, row, "head");
                if (strcmp(json_field(&associations, source, "sha"), head) == 0)
                {
                    if (pr != 0) ci_die("ambiguous historical PR association");
                    pr = json_number(&associations, row, "number");
                }
            }
            json_free(&associations);
            if (pr == 0) ci_die("missing historical PR association");
        }
        sibling(path, sizeof(path), argv[at], "jobs", id);
        Json jobs = read_json(path);
        size_t array = json_get(&jobs, 0, "jobs");
        size_t hardware = SIZE_MAX;
        if (array >= jobs.count) ci_die("missing jobs");
        for (size_t row = array + 1; row < jobs.rows[array].next; row = jobs.rows[row].next)
        {
            if (strcmp(json_field(&jobs, row, "name"), "Build and execute on Ryzen 7 9700X") == 0)
            {
                if (hardware != SIZE_MAX) ci_die("ambiguous hardware job");
                hardware = row;
            }
        }
        if (hardware == SIZE_MAX || strcmp(json_field(&jobs, hardware, "conclusion"), "success") != 0 || strcmp(json_field(&jobs, hardware, "runner_name"), "buster-zen5-9700x") != 0) ci_die("run is not a successful physical qualification");
        const char* start = json_field(&jobs, hardware, "started_at");
        const char* completed = json_field(&jobs, hardware, "completed_at");
        const char* host = "";
        size_t steps = json_get(&jobs, hardware, "steps");
        for (size_t row = steps + 1; row < jobs.rows[steps].next; row = jobs.rows[row].next)
        {
            if (strcmp(json_field(&jobs, row, "name"), "Verify host and bootstrap compiler") == 0) host = json_field(&jobs, row, "started_at");
        }
        unsigned approvals = 0;
        if (pr != 0)
        {
            sibling(path, sizeof(path), argv[at], "reviews", pr);
            Json reviews = read_json(path);
            for (size_t row = 1; row < reviews.rows[0].next; row = reviews.rows[row].next)
            {
                if (strcmp(json_field(&reviews, row, "state"), "APPROVED") == 0 && strcmp(json_field(&reviews, row, "commit_id"), head) == 0) ++approvals;
            }
            json_free(&reviews);
        }
        // Historical observations all lack a formal current-head APPROVED review. Do not manufacture latency.
        // Conversation probe approvals are archived separately, with their exact comment time and identity.
        printf("%" PRIu64 "\t%" PRIu64 "\t%s\t%s\t%s\t%s\t%s\t%" PRId64 "\t%" PRId64 "\t%" PRId64 "\t%" PRId64 "\t%s\n", id, pr, head, created, start, host, completed, seconds(start) - seconds(created), seconds(completed) - seconds(start), seconds(host) - seconds(start), seconds(completed) - seconds(host), approvals == 0 ? "unavailable" : "inspect_archived_reviews");
        json_free(&jobs);
        json_free(&run);
    }
    return 0;
}
