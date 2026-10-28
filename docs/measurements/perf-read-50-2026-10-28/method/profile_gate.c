// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. Original fail-closed profile acceptance tooling.
//
// Preserve an immutable task-owned snapshot and every reader stream. Acceptance requires independent binary
// validation, complete report/event populations, successful child status, empty diagnostic streams, zero ordering
// errors and observed event coverage. Scheduling duty has its own unavailable state when the format omits it.
#define _GNU_SOURCE
#include "perf_data.h"
#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <limits.h>
#include <signal.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#define PROFILE_INPUT_LIMIT (UINT64_C(1) << 30)
#define PROFILE_OUTPUT_LIMIT (UINT64_C(1) << 26)

typedef struct ReaderResult ReaderResult;
struct ReaderResult
{
    bool started;
    bool exited;
    bool completed;
    bool timed_out;
    int code;
    int signal;
    uint64_t output_bytes;
    uint64_t error_bytes;
};

static volatile sig_atomic_t profile_interrupted;

static void profile_signal(int number)
{
    profile_interrupted = number;
}

static bool profile_path(char* result, size_t capacity, const char* directory, const char* name)
{
    const int size = snprintf(result, capacity, "%s/%s", directory, name);
    return size > 0 && (size_t)size < capacity;
}

static uint64_t profile_now(void)
{
    struct timespec value;
    clock_gettime(CLOCK_MONOTONIC, &value);
    return (uint64_t)value.tv_sec * UINT64_C(1000000000) + (uint64_t)value.tv_nsec;
}

static bool profile_json_string(FILE* output, const char* text)
{
    bool valid = fputc('"', output) != EOF;
    for (const unsigned char* at = (const unsigned char*)text; valid && *at != 0; at += 1)
    {
        if (*at == '"' || *at == '\\')
        {
            valid = fputc('\\', output) != EOF && fputc(*at, output) != EOF;
        }
        else if (*at < 32)
        {
            valid = fprintf(output, "\\u%04x", *at) > 0;
        }
        else if (*at >= 128)
        {
            const unsigned width = *at >= 0xc2 && *at <= 0xdf ? 2 : *at >= 0xe0 && *at <= 0xef ? 3 :
                                   *at >= 0xf0 && *at <= 0xf4 ? 4 : 0;
            uint32_t point = width != 0 ? *at & ((1u << (7 - width)) - 1) : 0;
            valid = width != 0;
            for (unsigned i = 1; valid && i < width; i += 1)
            {
                valid = at[i] >= 0x80 && at[i] <= 0xbf;
                point = (point << 6) | (at[i] & 0x3f);
            }
            valid = valid && point >= (width == 2 ? 0x80u : width == 3 ? 0x800u : 0x10000u) &&
                    point <= 0x10ffff && !(point >= 0xd800 && point <= 0xdfff);
            valid = valid && fwrite(at, 1, width, output) == width;
            at += valid ? width - 1 : 0;
        }
        else
        {
            valid = fputc(*at, output) != EOF;
        }
    }
    valid = fputc('"', output) != EOF && valid;
    return valid;
}

static bool profile_argv(const char* path, char* const* command)
{
    FILE* output = fopen(path, "wx");
    bool valid = output != NULL && fputc('[', output) != EOF;
    for (unsigned index = 0; valid && command[index] != NULL; index += 1)
    {
        valid = (index == 0 || fputc(',', output) != EOF) && profile_json_string(output, command[index]);
    }
    if (output != NULL)
    {
        valid = fputs("]\n", output) != EOF && valid;
        valid = fclose(output) == 0 && valid;
    }
    return valid;
}

static bool profile_snapshot(const char* input_path, const char* output_path, uint64_t* copied)
{
    *copied = 0;
    const int input = open(input_path, O_RDONLY | O_NONBLOCK | O_CLOEXEC);
    struct stat before;
    struct stat after;
    bool valid = input >= 0 && fstat(input, &before) == 0 && S_ISREG(before.st_mode) && before.st_size >= 0 &&
                 (uint64_t)before.st_size <= PROFILE_INPUT_LIMIT;
    const int output = valid ? open(output_path, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0400) : -1;
    valid = output >= 0 && valid;
    while (valid && *copied < (uint64_t)before.st_size)
    {
        unsigned char bytes[65536];
        const uint64_t left = (uint64_t)before.st_size - *copied;
        const size_t requested = left < sizeof(bytes) ? (size_t)left : sizeof(bytes);
        ssize_t got;
        do { got = read(input, bytes, requested); } while (got < 0 && errno == EINTR);
        valid = got > 0;
        size_t done = 0;
        while (valid && done < (size_t)got)
        {
            ssize_t wrote;
            do { wrote = write(output, bytes + done, (size_t)got - done); } while (wrote < 0 && errno == EINTR);
            valid = wrote > 0;
            done += wrote > 0 ? (size_t)wrote : 0;
        }
        *copied += valid ? (uint64_t)got : 0;
    }
    valid = valid && fstat(input, &after) == 0 && before.st_size == after.st_size &&
            before.st_mtim.tv_sec == after.st_mtim.tv_sec && before.st_mtim.tv_nsec == after.st_mtim.tv_nsec &&
            before.st_ctim.tv_sec == after.st_ctim.tv_sec && before.st_ctim.tv_nsec == after.st_ctim.tv_nsec;
    if (input >= 0) valid = close(input) == 0 && valid;
    if (output >= 0) valid = close(output) == 0 && valid;
    return valid;
}

static uint64_t profile_file_bytes(const char* path)
{
    struct stat value;
    const bool valid = stat(path, &value) == 0 && S_ISREG(value.st_mode) && value.st_size >= 0;
    return valid ? (uint64_t)value.st_size : UINT64_MAX;
}

static int profile_descriptor(int descriptor)
{
    int result = descriptor;
    if (descriptor >= 0 && descriptor <= STDERR_FILENO)
    {
        result = fcntl(descriptor, F_DUPFD_CLOEXEC, STDERR_FILENO + 1);
        close(descriptor);
    }
    return result;
}

static bool profile_pipe(int descriptors[2])
{
    bool valid = pipe2(descriptors, O_CLOEXEC) == 0;
    if (valid)
    {
        descriptors[0] = profile_descriptor(descriptors[0]);
        descriptors[1] = profile_descriptor(descriptors[1]);
        valid = descriptors[0] >= 0 && descriptors[1] >= 0 &&
                fcntl(descriptors[0], F_SETFL, O_NONBLOCK) == 0;
    }
    return valid;
}

/* Pipes make EOF, including inherited writers, part of reader completion.
 * Only the parent writes retained files; a successful direct-child exit does
 * not permit a descendant to append diagnostics after acceptance. */
static bool profile_drain(int descriptor, int output, bool* eof, uint64_t* total)
{
    bool valid = true;
    unsigned char bytes[65536];
    ssize_t got = 0;
    do
    {
        got = read(descriptor, bytes, sizeof(bytes));
        if (got > 0)
        {
            valid = (uint64_t)got <= PROFILE_OUTPUT_LIMIT - *total;
            size_t done = 0;
            while (valid && done < (size_t)got)
            {
                ssize_t wrote;
                do { wrote = write(output, bytes + done, (size_t)got - done); } while (wrote < 0 && errno == EINTR);
                valid = wrote > 0;
                done += wrote > 0 ? (size_t)wrote : 0;
            }
            *total += valid ? (uint64_t)got : 0;
        }
        else if (got == 0) *eof = true;
        else valid = errno == EINTR || errno == EAGAIN || errno == EWOULDBLOCK;
    } while (valid && got > 0);
    return valid;
}

static ReaderResult profile_reader(const char* directory, const char* label, char* const* command, unsigned timeout)
{
    ReaderResult result = { 0 };
    char name[64];
    char output_path[PATH_MAX];
    char error_path[PATH_MAX];
    char argv_path[PATH_MAX];
    snprintf(name, sizeof(name), "%s.stdout", label);
    bool valid = profile_path(output_path, sizeof(output_path), directory, name);
    snprintf(name, sizeof(name), "%s.stderr", label);
    valid = profile_path(error_path, sizeof(error_path), directory, name) && valid;
    snprintf(name, sizeof(name), "%s.argv.json", label);
    valid = profile_path(argv_path, sizeof(argv_path), directory, name) && valid;
    valid = valid && profile_argv(argv_path, command);
    const int output = valid ? profile_descriptor(open(output_path, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0600)) : -1;
    const int error = output >= 0 ? profile_descriptor(open(error_path, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0600)) : -1;
    int output_pipe[2] = { -1, -1 }, error_pipe[2] = { -1, -1 };
    valid = output >= 0 && error >= 0 && valid && profile_pipe(output_pipe) && profile_pipe(error_pipe);
    const pid_t child = valid ? fork() : -1;
    if (child == 0)
    {
        const int quiet = profile_descriptor(open("/dev/null", O_RDONLY | O_CLOEXEC));
        if (setpgid(0, 0) != 0 || quiet < 0 || dup2(quiet, STDIN_FILENO) < 0 ||
            dup2(output_pipe[1], STDOUT_FILENO) < 0 || dup2(error_pipe[1], STDERR_FILENO) < 0)
        {
            _exit(125);
        }
        close(quiet);
        close(output);
        close(error);
        setenv("DEBUGINFOD_URLS", "", 1);
        setenv("LC_ALL", "C", 1);
        alarm(timeout + 1);
        execvp(command[0], command);
        _exit(errno == ENOENT ? 127 : 126);
    }
    if (output_pipe[1] >= 0) close(output_pipe[1]);
    if (error_pipe[1] >= 0) close(error_pipe[1]);
    result.started = child > 0;
    if (child > 0)
    {
        (void)setpgid(child, child);
        int status = 0;
        pid_t waited = 0;
        bool output_eof = false, error_eof = false, streams_ok = true;
        const uint64_t deadline = profile_now() + (uint64_t)timeout * UINT64_C(1000000000);
        while (waited == 0 || !output_eof || !error_eof)
        {
            if (waited == 0) waited = waitpid(child, &status, WNOHANG);
            if (waited < 0 && errno == EINTR) waited = 0;
            streams_ok = profile_drain(output_pipe[0], output, &output_eof, &result.output_bytes) && streams_ok;
            streams_ok = profile_drain(error_pipe[0], error, &error_eof, &result.error_bytes) && streams_ok;
            if (!streams_ok || waited < 0 || profile_interrupted != 0 || profile_now() >= deadline)
            {
                result.timed_out = profile_interrupted == 0 && streams_ok && profile_now() >= deadline;
                (void)kill(-child, SIGKILL);
                if (waited == 0)
                {
                    (void)kill(child, SIGKILL);
                    do { waited = waitpid(child, &status, 0); } while (waited < 0 && errno == EINTR);
                }
                streams_ok = false;
                break;
            }
            else if (waited == 0 || !output_eof || !error_eof)
            {
                const struct timespec pause_time = {
                    .tv_nsec = 10000000,
                };
                nanosleep(&pause_time, NULL);
            }
        }
        result.exited = waited == child && WIFEXITED(status);
        result.completed = streams_ok && output_eof && error_eof;
        result.code = result.exited ? WEXITSTATUS(status) : -1;
        result.signal = waited == child && WIFSIGNALED(status) ? WTERMSIG(status) : 0;
        result.output_bytes = profile_file_bytes(output_path);
        result.error_bytes = profile_file_bytes(error_path);
    }
    if (output_pipe[0] >= 0) close(output_pipe[0]);
    if (error_pipe[0] >= 0) close(error_pipe[0]);
    if (output >= 0) result.completed = close(output) == 0 && result.completed;
    if (error >= 0) result.completed = close(error) == 0 && result.completed;
    return result;
}

static bool profile_reader_ok(const ReaderResult* result)
{
    return result->started && result->completed && result->exited && result->code == 0 && !result->timed_out &&
           result->output_bytes <= PROFILE_OUTPUT_LIMIT && result->error_bytes <= PROFILE_OUTPUT_LIMIT;
}

static bool profile_event_names(const char* path, char names[PERF_DATA_ATTR_LIMIT][1024], unsigned expected)
{
    FILE* input = fopen(path, "r");
    bool valid = input != NULL;
    unsigned count = 0;
    char line[1024];
    while (valid && fgets(line, sizeof(line), input) != NULL)
    {
        size_t bytes = strlen(line);
        if (strncmp(line, "# Tip: ", 7) == 0)
        {
            valid = bytes != 0 && line[bytes - 1] == '\n';
            continue;
        }
        valid = bytes > 1 && line[bytes - 1] == '\n' && count < expected;
        while (bytes > 0 && isspace((unsigned char)line[bytes - 1])) bytes -= 1;
        line[bytes] = 0;
        valid = bytes != 0 && !isspace((unsigned char)line[0]) && valid;
        for (unsigned i = 0; valid && i < count; i += 1) valid = strcmp(names[i], line) != 0;
        if (valid) memcpy(names[count++], line, bytes + 1);
    }
    if (input != NULL)
    {
        valid = !ferror(input) && valid;
        valid = fclose(input) == 0 && valid;
    }
    return valid && count == expected && expected != 0;
}

static bool profile_events(const char* path, char names[PERF_DATA_ATTR_LIMIT][1024], const PerfDataSummary* summary)
{
    FILE* input = fopen(path, "r");
    bool valid = input != NULL;
    uint64_t count = 0;
    uint64_t observed[PERF_DATA_ATTR_LIMIT] = { 0 };
    char line[4096];
    while (valid && fgets(line, sizeof(line), input) != NULL)
    {
        size_t bytes = strlen(line);
        valid = bytes != 0 && line[bytes - 1] == '\n';
        while (bytes > 0 && isspace((unsigned char)line[bytes - 1])) bytes -= 1;
        const char* start = line;
        while (isspace((unsigned char)*start)) start += 1;
        valid = bytes != 0 && start < line + bytes && line[bytes - 1] == ':' && valid;
        if (valid)
        {
            line[bytes - 1] = 0;
            unsigned attribute = summary->attribute_count;
            for (unsigned i = 0; i < summary->attribute_count; i += 1)
            {
                if (strcmp(start, names[i]) == 0) attribute = i;
            }
            valid = attribute < summary->attribute_count;
            if (valid) observed[attribute] += 1;
        }
        count += 1;
    }
    if (input != NULL)
    {
        valid = !ferror(input) && valid;
        valid = fclose(input) == 0 && valid;
    }
    for (unsigned i = 0; valid && i < summary->attribute_count; i += 1)
    {
        const PerfDataAttribute* attribute = summary->attributes + i;
        const uint64_t expected = attribute->group_values + ((attribute->sample_type & 16) == 0 ? attribute->direct_samples : 0);
        valid = observed[i] == expected && expected != 0;
    }
    return valid && count == summary->decoded_events && count != 0;
}

static bool profile_report(const char* path, char names[PERF_DATA_ATTR_LIMIT][1024], const PerfDataSummary* summary)
{
    FILE* input = fopen(path, "r");
    bool valid = input != NULL;
    bool lost_seen = false;
    uint64_t totals[PERF_DATA_ATTR_LIMIT] = { 0 };
    bool seen[PERF_DATA_ATTR_LIMIT] = { 0 };
    unsigned section = summary->attribute_count;
    unsigned rows = 0;
    char line[16384];
    while (valid && fgets(line, sizeof(line), input) != NULL)
    {
        const size_t length = strlen(line);
        valid = length != 0 && line[length - 1] == '\n';
        if (strncmp(line, "# Total Lost Samples:", 21) == 0)
        {
            const char* at = line + 21;
            while (isspace((unsigned char)*at)) at += 1;
            char* end = NULL;
            errno = 0;
            const uint64_t loss = strtoull(at, &end, 10);
            valid = !lost_seen && *at >= '0' && *at <= '9' && end != at && loss == 0 && errno == 0 && valid;
            while (end != NULL && isspace((unsigned char)*end)) end += 1;
            valid = end != NULL && *end == 0 && valid;
            lost_seen = true;
        }
        else if (strncmp(line, "# Samples:", 10) == 0)
        {
            const char* at = line + 10;
            while (isspace((unsigned char)*at)) at += 1;
            valid = *at >= '1' && *at <= '9' && valid;
            while (*at >= '0' && *at <= '9') at += 1;
            if (*at == '.')
            {
                at += 1;
                valid = *at >= '0' && *at <= '9' && valid;
                while (*at >= '0' && *at <= '9') at += 1;
            }
            if (*at != 0 && strchr("KMGTPE", *at) != NULL) at += 1;
            if (strncmp(at, " of events '", 12) == 0) at += 12;
            else if (strncmp(at, " of event '", 11) == 0) at += 11;
            else valid = false;
            const char* end = strrchr(at, '\'');
            valid = end != NULL && strcmp(end, "'\n") == 0 && valid;
            section = summary->attribute_count;
            for (unsigned i = 0; valid && i < summary->attribute_count; i += 1)
            {
                if ((size_t)(end - at) == strlen(names[i]) && memcmp(at, names[i], (size_t)(end - at)) == 0) section = i;
            }
            valid = section < summary->attribute_count && valid;
            if (valid)
            {
                valid = !seen[section];
                seen[section] = true;
            }
        }
        else if (line[0] != '#')
        {
            char* first = strchr(line, ';');
            if (first != NULL)
            {
                const char* at = line;
                while (isspace((unsigned char)*at)) at += 1;
                char* end = NULL;
                errno = 0;
                const uint64_t count = strtoull(at, &end, 10);
                valid = section < summary->attribute_count && *at >= '0' && *at <= '9' && end > at && errno == 0 && valid;
                while (end < first && isspace((unsigned char)*end)) end += 1;
                valid = end == first && valid;
                char* second = strchr(first + 1, ';');
                valid = second != NULL && strchr(second + 1, ';') == NULL && valid;
                if (valid)
                {
                    const char* symbol = first + 1;
                    while (symbol < second && isspace((unsigned char)*symbol)) symbol += 1;
                    const char* dso = second + 1;
                    while (isspace((unsigned char)*dso)) dso += 1;
                    valid = symbol < second && *dso != 0 && count <= UINT64_MAX - totals[section];
                    if (valid) totals[section] += count;
                }
                rows += 1;
            }
            else
            {
                for (const char* at = line; valid && *at != 0; at += 1) valid = isspace((unsigned char)*at) != 0;
            }
        }
    }
    if (input != NULL)
    {
        valid = !ferror(input) && valid;
        valid = fclose(input) == 0 && valid;
    }
    for (unsigned i = 0; valid && i < summary->attribute_count; i += 1)
    {
        const PerfDataAttribute* attribute = summary->attributes + i;
        const uint64_t expected = attribute->group_values + ((attribute->sample_type & 16) == 0 ? attribute->direct_samples : 0);
        valid = seen[i] && totals[i] == expected && expected != 0;
    }
    return valid && lost_seen && rows != 0;
}

static bool profile_order(const char* path)
{
    FILE* input = fopen(path, "r");
    bool valid = input != NULL;
    char line[256];
    unsigned rows = 0;
    while (valid && fgets(line, sizeof(line), input) != NULL)
    {
        valid = strcmp(line, "Misordered timestamps: 0\n") == 0;
        rows += 1;
    }
    if (input != NULL)
    {
        valid = !ferror(input) && valid;
        valid = fclose(input) == 0 && valid;
    }
    return valid && rows == 1;
}

static bool profile_result(FILE* output, const char* name, const ReaderResult* result)
{
    bool valid = profile_json_string(output, name);
    valid = fprintf(output, ":{\"started\":%s,\"exited\":%s,\"completed\":%s,\"timeout\":%s,\"exit_code\":",
                    result->started ? "true" : "false", result->exited ? "true" : "false", result->completed ? "true" : "false", result->timed_out ? "true" : "false") > 0 && valid;
    valid = (result->exited ? fprintf(output, "%d", result->code) > 0 : fputs("null", output) != EOF) && valid;
    valid = fprintf(output, ",\"signal\":%d,\"stdout_bytes\":%" PRIu64 ",\"stderr_bytes\":%" PRIu64 "}",
                    result->signal, result->output_bytes, result->error_bytes) > 0 && valid;
    return valid;
}

int main(int argc, char** argv)
{
    const char* data = NULL;
    const char* directory = NULL;
    const char* reader = "perf";
    const char* symfs = NULL;
    const char* kallsyms = NULL;
    unsigned timeout = 30;
    bool require_duty = false;
    bool help = argc == 2 && strcmp(argv[1], "--help") == 0;
    bool valid = true;
    for (int i = 1; valid && !help && i < argc; i += 1)
    {
        if (strcmp(argv[i], "--require-duty") == 0) require_duty = true;
        else if (i + 1 >= argc) valid = false;
        else if (strcmp(argv[i], "--data") == 0) data = argv[++i];
        else if (strcmp(argv[i], "--output-dir") == 0) directory = argv[++i];
        else if (strcmp(argv[i], "--perf") == 0) reader = argv[++i];
        else if (strcmp(argv[i], "--symfs") == 0) symfs = argv[++i];
        else if (strcmp(argv[i], "--kallsyms") == 0) kallsyms = argv[++i];
        else if (strcmp(argv[i], "--timeout") == 0)
        {
            char* end = NULL;
            const unsigned long value = strtoul(argv[++i], &end, 10);
            valid = end != argv[i] && *end == 0 && value >= 1 && value <= 600;
            timeout = valid ? (unsigned)value : timeout;
        }
        else valid = false;
    }
    int result = 2;
    if (help || !valid || data == NULL || directory == NULL)
    {
        fprintf(help ? stdout : stderr, "usage: profile_gate --data FILE --output-dir NEW_DIR [--perf PROGRAM] [--symfs DIR] [--kallsyms FILE] [--timeout SECONDS] [--require-duty]\n");
        result = help ? 0 : 2;
    }
    else if (mkdir(directory, 0700) != 0)
    {
        fprintf(stderr, "profile_gate: output directory must be new: %s\n", directory);
    }
    else
    {
        struct sigaction action = { 0 };
        action.sa_handler = profile_signal;
        sigemptyset(&action.sa_mask);
        sigaction(SIGINT, &action, NULL);
        sigaction(SIGTERM, &action, NULL);
        char snapshot[PATH_MAX], binary_path[PATH_MAX], report_path[PATH_MAX], events_path[PATH_MAX], order_path[PATH_MAX];
        bool paths = profile_path(snapshot, sizeof(snapshot), directory, "capture.data") &&
                     profile_path(binary_path, sizeof(binary_path), directory, "binary.tsv") &&
                     profile_path(report_path, sizeof(report_path), directory, "report.stdout") &&
                     profile_path(events_path, sizeof(events_path), directory, "events.stdout") &&
                     profile_path(order_path, sizeof(order_path), directory, "order.stderr");
        uint64_t copied = 0;
        const bool snapshot_ok = paths && profile_snapshot(data, snapshot, &copied);
        const char* reason = snapshot_ok ? "binary_rejected" : "input_snapshot_failed";
        FILE* binary = snapshot_ok ? fopen(binary_path, "wx") : NULL;
        PerfDataSummary summary = { 0 };
        bool accepted = binary != NULL && perf_data_scan(snapshot, binary, &summary) == 0;
        if (binary != NULL) accepted = fclose(binary) == 0 && accepted;
        bool duty_available = summary.complete && summary.attribute_count != 0;
        bool duty_partial = false;
        for (unsigned i = 0; i < summary.attribute_count; i += 1)
        {
            const PerfDataAttribute* attribute = summary.attributes + i;
            const bool known = attribute->duty_known_intervals != 0 && attribute->duty_zero_intervals == 0;
            duty_available = duty_available && known;
            duty_partial = duty_partial || attribute->duty_partial_intervals != 0;
        }
        if (accepted && duty_partial)
        {
            accepted = false;
            reason = "counter_duty_incomplete";
        }
        else if (accepted && require_duty && !duty_available)
        {
            accepted = false;
            reason = "counter_duty_unavailable";
        }
        ReaderResult version = { 0 };
        ReaderResult attributes = { 0 };
        ReaderResult report = { 0 };
        ReaderResult events = { 0 };
        ReaderResult order = { 0 };
        char names[PERF_DATA_ATTR_LIMIT][1024] = { 0 };
        if (accepted)
        {
            char* command[] = {
                (char*)reader,
                "evlist",
                "-i",
                snapshot,
                NULL,
            };
            char attributes_path[PATH_MAX];
            const bool path_ok = profile_path(attributes_path, sizeof(attributes_path), directory, "attributes.stdout");
            attributes = profile_reader(directory, "attributes", command, timeout);
            accepted = path_ok && profile_reader_ok(&attributes) && attributes.error_bytes == 0 &&
                       profile_event_names(attributes_path, names, summary.attribute_count);
            reason = "reader_attributes_incomplete";
        }
        if (accepted)
        {
            char* command[] = {
                (char*)reader,
                "--version",
                NULL,
            };
            version = profile_reader(directory, "version", command, timeout);
            accepted = profile_reader_ok(&version) && version.error_bytes == 0 && version.output_bytes != 0;
            reason = "reader_version_failed";
        }
        if (accepted)
        {
            char* command[32];
            unsigned n = 0;
            command[n++] = (char*)reader;
            command[n++] = "report";
            command[n++] = "--stdio";
            command[n++] = "--header";
            command[n++] = "--no-children";
            command[n++] = "--no-group";
            command[n++] = "--percent-limit";
            command[n++] = "0";
            command[n++] = "--fields";
            command[n++] = "sample,symbol,dso";
            command[n++] = "--field-separator";
            command[n++] = ";";
            if (symfs != NULL) { command[n++] = "--symfs"; command[n++] = (char*)symfs; }
            if (kallsyms != NULL) { command[n++] = "--kallsyms"; command[n++] = (char*)kallsyms; }
            command[n++] = "-i";
            command[n++] = snapshot;
            command[n] = NULL;
            report = profile_reader(directory, "report", command, timeout);
            accepted = profile_reader_ok(&report) && report.error_bytes == 0 &&
                       profile_report(report_path, names, &summary);
            reason = "reader_report_incomplete";
        }
        if (accepted)
        {
            char* command[] = {
                (char*)reader,
                "script",
                "-i",
                snapshot,
                "-F",
                "event",
                NULL,
            };
            events = profile_reader(directory, "events", command, timeout);
            accepted = profile_reader_ok(&events) && events.error_bytes == 0 &&
                       profile_events(events_path, names, &summary);
            reason = "reader_sample_population_incomplete";
        }
        if (accepted)
        {
            char* command[] = {
                (char*)reader,
                "script",
                "-d",
                "-i",
                snapshot,
                "-F",
                "event",
                NULL,
            };
            order = profile_reader(directory, "order", command, timeout);
            accepted = profile_reader_ok(&order) && order.output_bytes == 0 && profile_order(order_path);
            reason = "reader_ordering_unqualified";
        }
        accepted = accepted && profile_interrupted == 0;
        reason = accepted ? "complete_profile" : profile_interrupted != 0 ? "interrupted" : reason;
        char temporary[PATH_MAX], receipt[PATH_MAX];
        bool wrote = profile_path(temporary, sizeof(temporary), directory, "acceptance.tmp") &&
                     profile_path(receipt, sizeof(receipt), directory, "acceptance.json");
        FILE* output = wrote ? fopen(temporary, "wx") : NULL;
        wrote = output != NULL && wrote;
        if (output != NULL)
        {
            wrote = fprintf(output, "{\"accepted\":%s,\"reason\":", accepted ? "true" : "false") > 0 && wrote;
            wrote = profile_json_string(output, reason) && wrote;
            wrote = fputs(",\"input\":", output) != EOF && wrote;
            wrote = profile_json_string(output, data) && wrote;
            wrote = fprintf(output, ",\"snapshot_bytes\":%" PRIu64 ",\"binary_complete\":%s,\"physical_samples\":%" PRIu64 ",\"decoded_events\":%" PRIu64 ",\"scheduling_duty\":\"%s\",\"require_duty\":%s,\"readers\":{",
                            copied, summary.complete ? "true" : "false", summary.samples, summary.decoded_events,
                            duty_partial ? "partial_observed" : duty_available ? "full_observed" : "unavailable",
                            require_duty ? "true" : "false") > 0 && wrote;
            wrote = profile_result(output, "version", &version) && wrote;
            wrote = fputc(',', output) != EOF && wrote;
            wrote = profile_result(output, "attributes", &attributes) && wrote;
            wrote = fputc(',', output) != EOF && wrote;
            wrote = profile_result(output, "report", &report) && wrote;
            wrote = fputc(',', output) != EOF && wrote;
            wrote = profile_result(output, "events", &events) && wrote;
            wrote = fputc(',', output) != EOF && wrote;
            wrote = profile_result(output, "ordering", &order) && wrote;
            wrote = fputs("}}\n", output) != EOF && wrote;
            wrote = fclose(output) == 0 && wrote;
        }
        wrote = wrote && rename(temporary, receipt) == 0;
        result = accepted && wrote ? 0 : 1;
        fprintf(result == 0 ? stdout : stderr, "profile_gate: %s (%s), evidence %s\n", result == 0 ? "accepted" : "rejected", wrote ? reason : "receipt_write_failed", directory);
    }
    return result;
}
