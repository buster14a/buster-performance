// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Independent read-only audit of 24 retained 21df57f8 ordinary wait observations.
// Basic read/hash helpers are copied from the independently reviewed timing reader v4.
// No production launcher, validator, instrumentation, or runner code is included.
#define _GNU_SOURCE
#include <ctype.h>
#include <dirent.h>
#include <errno.h>
#include <inttypes.h>
#include <limits.h>
#include <math.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

typedef struct Text Text;
struct Text
{
    char* bytes;
    char** rows;
    size_t count;
};

static const char* subject;
static const char* root;
static Text arguments;
static Text outputs;
static uint64_t previous_guard_end;
static uint64_t maximum_guard;
static unsigned audited;
static unsigned metrics_audited;
static size_t object_digests;
static uint64_t totals[5][4][8];

static void require(bool valid, const char* format, ...)
{
    if (!valid)
    {
        fprintf(stderr, "INDEPENDENT-REVIEW-FAILED [%s]: ", subject != NULL ? subject : "case");
        va_list args;
        va_start(args, format);
        vfprintf(stderr, format, args);
        va_end(args);
        fputc('\n', stderr);
        exit(1);
    }
}

static char* path(const char* directory, const char* leaf)
{
    char* result = NULL;
    require(asprintf(&result, "%s/%s", directory, leaf) > 0, "path allocation");
    return result;
}

static char* bytes(const char* name, bool nonempty)
{
    struct stat info;
    require(lstat(name, &info) == 0 && S_ISREG(info.st_mode) && info.st_size >= (nonempty ? 1 : 0) && info.st_size <= (16 << 20), "not a bounded regular file: %s", name);
    FILE* file = fopen(name, "rb");
    require(file != NULL, "open %s", name);
    size_t size = (size_t)info.st_size;
    char* result = calloc(size + 1, 1);
    require(result != NULL && fread(result, 1, size, file) == size && fgetc(file) == EOF && !ferror(file), "read %s", name);
    require(fclose(file) == 0 && memchr(result, 0, size) == NULL, "close/NUL check %s", name);
    return result;
}

static Text lines(const char* name)
{
    Text text = { .bytes = bytes(name, true) };
    size_t size = strlen(text.bytes);
    require(size > 0 && text.bytes[size - 1] == '\n' && strchr(text.bytes, '\r') == NULL, "line termination: %s", name);
    for (size_t i = 0; i < size; i += 1) text.count += text.bytes[i] == '\n';
    text.rows = calloc(text.count, sizeof(*text.rows));
    require(text.rows != NULL, "line allocation");
    char* row = text.bytes;
    for (size_t i = 0; i < text.count; i += 1)
    {
        char* end = strchr(row, '\n');
        require(end != NULL, "missing newline");
        *end = 0;
        text.rows[i] = row;
        row = end + 1;
    }
    return text;
}

static size_t split(char* row, char** fields, size_t capacity)
{
    size_t count = 0;
    char* cursor = row;
    do
    {
        require(count < capacity, "too many fields");
        fields[count++] = cursor;
        char* next = strchr(cursor, '\t');
        if (next != NULL) *next++ = 0;
        cursor = next;
    } while (cursor != NULL);
    return count;
}

static uint64_t integer(const char* text)
{
    require(text[0] >= '0' && text[0] <= '9', "not an unsigned integer: %s", text);
    require(text[0] != '0' || text[1] == 0, "noncanonical integer: %s", text);
    errno = 0;
    char* end = NULL;
    uint64_t value = strtoull(text, &end, 10);
    require(errno == 0 && end != text && *end == 0, "invalid integer: %s", text);
    return value;
}

static uint64_t key_number(const char* row, const char* key)
{
    require(strncmp(row, key, strlen(key)) == 0, "expected key %s", key);
    return integer(row + strlen(key));
}

static double decimal(const char* text)
{
    errno = 0;
    char* end = NULL;
    double value = strtod(text, &end);
    require(errno == 0 && end != text && *end == 0 && isfinite(value), "invalid finite decimal: %s", text);
    return value;
}

static void close_value(const char* text, double expected, double tolerance)
{
    double value = decimal(text);
    require(fabs(value - expected) <= tolerance, "numeric mismatch: recorded=%s recomputed=%.12g tolerance=%.3g", text, expected, tolerance);
}

static void equals_file(const char* filename, const char* expected)
{
    char* actual = bytes(filename, true);
    require(strcmp(actual, expected) == 0, "changed receipt: %s", filename);
    free(actual);
}

static int command(char* const* argv, const char* directory)
{
    pid_t child = fork();
    require(child >= 0, "fork hash checker");
    if (child == 0)
    {
        if (directory != NULL && chdir(directory) != 0) _exit(126);
        execvp(argv[0], argv);
        _exit(127);
    }
    int status = -1;
    require(waitpid(child, &status, 0) == child, "wait hash checker");
    return WIFEXITED(status) ? WEXITSTATUS(status) : -1;
}

static void hashes(const char* manifest, const char* directory)
{
    char* argv[] = { "sha256sum", "--check", "--strict", "--status", (char*)manifest, NULL };
    require(command(argv, directory) == 0, "independent SHA-256 verification failed: %s", manifest);
}

static void hash_text(const char* text)
{
    int descriptors[2];
    require(pipe(descriptors) == 0, "hash receipt pipe");
    pid_t child = fork();
    require(child >= 0, "fork identity checker");
    if (child == 0)
    {
        close(descriptors[1]);
        if (dup2(descriptors[0], STDIN_FILENO) < 0) _exit(126);
        close(descriptors[0]);
        execlp("sha256sum", "sha256sum", "--check", "--strict", "--status", (char*)NULL);
        _exit(127);
    }
    require(close(descriptors[0]) == 0, "close identity pipe reader");
    size_t length = strlen(text), sent = 0;
    while (sent < length)
    {
        ssize_t count = write(descriptors[1], text + sent, length - sent);
        if (count < 0 && errno == EINTR) continue;
        require(count > 0, "write identity manifest");
        sent += (size_t)count;
    }
    require(close(descriptors[1]) == 0, "close identity manifest");
    int status = -1;
    require(waitpid(child, &status, 0) == child && WIFEXITED(status) && WEXITSTATUS(status) == 0, "independent identity digest verification");
}

static void parse_hash_row(const char* row, const char* expected_name)
{
    require(strlen(row) > 66 && row[64] == ' ' && row[65] == ' ', "malformed hash row");
    for (size_t i = 0; i < 64; i += 1) require(isxdigit((unsigned char)row[i]) != 0, "nonhex digest");
    if (expected_name != NULL) require(strcmp(row + 66, expected_name) == 0, "wrong hash path: %s", row + 66);
}

static void same(const char* a, const char* b)
{
    char* value = bytes(a, true);
    equals_file(b, value);
    free(value);
}

static void file_digest(const char* filename, char result[65])
{
    int p[2];
    require(pipe(p) == 0, "digest pipe");
    pid_t child = fork();
    require(child >= 0, "digest fork");
    if (child == 0)
    {
        close(p[0]);
        if (dup2(p[1], STDOUT_FILENO) < 0) _exit(126);
        close(p[1]);
        execlp("sha256sum", "sha256sum", "--", filename, (char*)NULL);
        _exit(127);
    }
    require(close(p[1]) == 0, "digest writer close");
    char buffer[PATH_MAX + 256];
    size_t used = 0;
    for (;;)
    {
        ssize_t n = read(p[0], buffer + used, sizeof(buffer) - 1 - used);
        if (n < 0 && errno == EINTR) continue;
        require(n >= 0, "digest read");
        if (n == 0) break;
        used += (size_t)n;
        require(used < sizeof(buffer) - 1, "digest output bound");
    }
    buffer[used] = 0;
    int status = -1;
    require(close(p[0]) == 0 && waitpid(child, &status, 0) == child && status == 0, "digest child");
    require(used > 66 && buffer[64] == ' ' && buffer[65] == ' ', "digest format");
    for (unsigned i = 0; i < 64; ++i) require((buffer[i] >= '0' && buffer[i] <= '9') || (buffer[i] >= 'a' && buffer[i] <= 'f'), "digest digits");
    memcpy(result, buffer, 64); result[64] = 0;
}

static const char* kinds[] = { "initial-spin", "mwaitx", "fallback-spin", "barrier-futex", "other-futex" };
static const char* outcomes[] = { "completed", "eagain", "eintr", "other" };
static const uint64_t boundaries[] = { 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000 };

static void trace(const char* filename, unsigned lanes, uint64_t pid, char tids[256])
{
    Text raw = lines(filename);
    unsigned pins[8] = {0}, owners[8] = {0}, calibrations[8] = {0}, seen[8][5][4] = {{{0}}};
    uint64_t thread[8] = {0};
    unsigned count = 0;
    for (size_t r = 0; r < raw.count; ++r)
    {
        char* row = raw.rows[r];
        char* trimmed = row;
        while (*trimmed == ' ' || *trimmed == '\t') ++trimmed;
        bool diagnostic = strncmp(trimmed, "lane-pin", 8) == 0 || strncmp(trimmed, "wait-diagnostic", 15) == 0;
        if (!diagnostic) continue;
        require(trimmed == row, "indented diagnostic record");
        char* f[12]; size_t n = split(row, f, 12);
        if (strcmp(f[0], "lane-pin") == 0)
        {
            require(n == 5, "pin field count");
            uint64_t lane = key_number(f[1], "index=");
            require(lane < lanes && key_number(f[2], "expected=") == lane && key_number(f[3], "observed=") == lane && strcmp(f[4], "status=0") == 0 && pins[lane]++ == 0, "pin CPU/status/uniqueness");
        }
        else if (strcmp(f[0], "wait-diagnostic") == 0)
        {
            require(n == 8, "lane field count");
            uint64_t lane = key_number(f[1], "lane=");
            uint64_t tid = key_number(f[2], "tid=");
            require(lane < lanes && tid > 0 && tid <= INT_MAX && key_number(f[3], "expected-cpu=") == lane && key_number(f[4], "observed-cpu=") == lane && strcmp(f[5], "cpu-status=0") == 0 && strcmp(f[6], "scope=start-through-flow") == 0 && strcmp(f[7], "end-policy=forced-join") == 0 && owners[lane]++ == 0, "lane identity/CPU/scope");
            thread[lane] = tid;
        }
        else if (strcmp(f[0], "wait-diagnostic-calibration") == 0)
        {
            require(n == 7, "calibration field count");
            uint64_t lane = key_number(f[1], "lane=");
            require(lane < lanes && strcmp(f[2], "pairs=1000") == 0 && strcmp(f[3], "failures=0") == 0 && calibrations[lane]++ == 0, "calibration identity/count");
            uint64_t low = key_number(f[4], "min-ns="), high = key_number(f[5], "max-ns="), total = key_number(f[6], "total-ns=");
            require(low <= high && (__uint128_t)low * 1000 <= total && total <= (__uint128_t)high * 1000, "calibration bounds");
        }
        else if (strcmp(f[0], "wait-diagnostic-metric") == 0)
        {
            require(n == 9, "metric field count");
            uint64_t lane = key_number(f[1], "lane=");
            unsigned k = 5, o = 4;
            require(strncmp(f[2], "kind=", 5) == 0 && strncmp(f[3], "outcome=", 8) == 0, "metric label keys");
            for (unsigned i = 0; i < 5; ++i) if (strcmp(f[2] + 5, kinds[i]) == 0) k = i;
            for (unsigned i = 0; i < 4; ++i) if (strcmp(f[3] + 8, outcomes[i]) == 0) o = i;
            require(lane < lanes && k < 5 && o < 4 && seen[lane][k][o]++ == 0, "metric identity/uniqueness");
            uint64_t calls = key_number(f[4], "calls="), errors = key_number(f[5], "clock-errors="), elapsed = key_number(f[6], "elapsed-ns="), maximum = key_number(f[7], "max-ns=");
            require(strncmp(f[8], "buckets=", 8) == 0, "bucket key");
            uint64_t bucket[8], sum = 0;
            char* cursor = f[8] + 8;
            unsigned highest = 0;
            for (unsigned i = 0; i < 8; ++i)
            {
                char* comma = strchr(cursor, ',');
                require((comma != NULL) == (i < 7), "bucket count");
                if (comma != NULL) *comma = 0;
                bucket[i] = integer(cursor);
                require(UINT64_MAX - sum >= bucket[i], "bucket sum overflow");
                sum += bucket[i];
                if (bucket[i]) highest = i;
                require(UINT64_MAX - totals[k][o][i] >= bucket[i], "aggregate bucket overflow");
                totals[k][o][i] += bucket[i];
                cursor = comma == NULL ? NULL : comma + 1;
            }
            require(errors == 0 && sum == calls && maximum <= elapsed && elapsed <= (__uint128_t)maximum * calls && (calls != 0 || (elapsed == 0 && maximum == 0)), "metric count/clock/elapsed bounds");
            require(k >= 3 || o == 0 || calls == 0, "impossible spin/MWAITX outcome");
            if (calls)
            {
                unsigned actual_bucket = 0;
                while (actual_bucket < 7 && maximum >= boundaries[actual_bucket]) ++actual_bucket;
                require(actual_bucket == highest, "maximum bucket");
                __uint128_t least = 0, most = 0;
                for (unsigned i = 0; i < 8; ++i)
                {
                    uint64_t lower = i ? boundaries[i - 1] : 0;
                    uint64_t upper = i < 7 && boundaries[i] - 1 < maximum ? boundaries[i] - 1 : maximum;
                    least += (__uint128_t)bucket[i] * lower;
                    most += (__uint128_t)bucket[i] * upper;
                }
                least += maximum - (highest ? boundaries[highest - 1] : 0);
                require(least <= elapsed && elapsed <= most, "elapsed histogram bounds");
            }
            ++count;
        }
        else require(false, "unknown diagnostic record");
    }
    require(count == lanes * 20 && thread[0] == pid, "metric total/owner PID");
    size_t used = 0;
    for (unsigned lane = 0; lane < lanes; ++lane)
    {
        require(pins[lane] == 1 && owners[lane] == 1 && calibrations[lane] == 1, "lane/pin/calibration multiplicity");
        for (unsigned j = 0; j < lane; ++j) require(thread[j] != thread[lane], "duplicate worker TID");
        for (unsigned k = 0; k < 5; ++k) for (unsigned o = 0; o < 4; ++o) require(seen[lane][k][o] == 1, "missing metric");
        int n = snprintf(tids + used, 256 - used, "%s%" PRIu64, lane ? "," : "", thread[lane]);
        require(n > 0 && (size_t)n < 256 - used, "TID formatting"); used += (size_t)n;
    }
    metrics_audited += count;
}

static const char* stage_names[] = {
    "setup", "lanes-start", "preprocess", "parse", "type-table", "check-input", "check-expressions", "check-declarations", "static-data", "check-program", "select", "backend-setup", "lower", "tier0", "emit-setup", "lanes", "branch-sizing", "encode", "unwind", "code-atoms", "debug", "publish-data", "object-build", "object-write", "runtime", "executable", "write", "release", "total", "lower.prepare"
};

static void stage_table(const char* observation, unsigned lanes, uint64_t wall)
{
    Text raw = lines(path(observation, "sample/stderr.txt"));
    unsigned seen[30] = {0}, asked = 0, actual = 0, header = 0;
    double value[30] = {0};
    for (size_t r = 0; r < raw.count; ++r)
    {
        char* row = raw.rows[r];
        if (strncmp(row, "time-process\tlanes-asked\t", 25) == 0) { require(integer(row + 25) == lanes, "asked lanes"); ++asked; }
        else if (strncmp(row, "time-process\tlanes\t", 19) == 0) { require(integer(row + 19) == lanes, "actual lanes"); ++actual; }
        else if (strncmp(row, "time-stage\t", 11) == 0)
        {
            char* f[16]; size_t n = split(row, f, 16);
            require(n >= 3, "stage field count");
            if (strcmp(f[1], "stage") == 0)
            {
                require(n == 7 && strcmp(f[2], "ms") == 0 && strcmp(f[3], "percent") == 0 && strcmp(f[4], "system-ms") == 0 && strcmp(f[5], "minor-faults") == 0 && strcmp(f[6], "peak-kb-added") == 0, "stage header format");
                ++header;
            }
            else
            {
                double v = decimal(f[2]); require(v >= 0, "negative stage");
                for (unsigned i = 0; i < 30; ++i) if (strcmp(f[1], stage_names[i]) == 0) { ++seen[i]; value[i] = v; }
            }
        }
    }
    require(asked == 1 && actual == 1 && header == 1, "stage team/header multiplicity");
    double sum = 0, serial = outputs.count == 1 ? value[29] : 0;
    for (unsigned i = 0; i < 30; ++i)
    {
        require(seen[i] == 1, "stage multiplicity %s", stage_names[i]);
        if (i < 28) sum += value[i];
        if (i == 0 || i == 27 || (outputs.count == 1 && ((i >= 2 && i <= 11) || i == 14 || (i >= 21 && i <= 23)))) serial += value[i];
    }
    double paired = (double)wall / 1e6;
    require(value[28] > 0 && fabs(sum - value[28]) <= 0.056 && value[28] <= paired + 0.1 && serial <= value[28] + 0.056, "stage total/wall bound");
    Text table = lines(path(observation, "stages.tsv"));
    require(table.count == 2 && strcmp(table.rows[0], "lanes\tpaired_wall_ms\tstage_total_ms\tserial_lower_bound_ms\tserial_elapsed_share_lower_bound\tamdahl_8_upper_from_one_lane\tamdahl_infinite_upper_from_one_lane\tlanes_start_ms") == 0, "stage table header");
    char* f[9]; require(split(table.rows[1], f, 9) == 8 && integer(f[0]) == lanes, "stage table fields");
    close_value(f[1], paired, 0.0000011); close_value(f[2], value[28], 0.0000011); close_value(f[3], serial, 0.0000011); close_value(f[4], serial / paired, 0.0000000011); close_value(f[7], value[1], 0.0000011);
    if (lanes == 1 && serial > 0) { close_value(f[5], 1 / (serial / paired + (1 - serial / paired) / 8), 0.0000011); close_value(f[6], paired / serial, 0.0000011); }
    else require(strcmp(f[5], "NA") == 0 && strcmp(f[6], "NA") == 0, "nonbaseline Amdahl fields");
}

static void observation(const char* label, unsigned lanes)
{
    char name[64]; snprintf(name, sizeof(name), "wait-%s-%u", label, lanes);
    subject = name;
    char* directory = path(root, name);
    char* timing_name = NULL; require(asprintf(&timing_name, "timing-%s", label) > 0, "timing name");
    char* timing = path(root, timing_name);
    char* status_name = NULL; require(asprintf(&status_name, "%s-controller.status", directory) > 0, "controller status path");
    equals_file(status_name, "0\n");
    char* log_name = NULL; require(asprintf(&log_name, "%s-controller.log", directory) > 0, "controller log path"); (void)bytes(log_name, false);
    const char* case_files[] = { "args.txt", "outputs.txt", "sources.sha256", "provenance.txt" };
    for (unsigned i = 0; i < 4; ++i) same(path(path(timing, "case"), case_files[i]), path(path(directory, "case"), case_files[i]));
    Text control = lines(path(directory, "before/control.identity"));
    Text qualified = lines(path(timing, "identity.before.txt"));
    require(control.count == 12 && qualified.count == 12, "control identity length");
    for (unsigned i = 0; i < 6; ++i) require(strcmp(control.rows[i], qualified.rows[i]) == 0, "control identity source/pins");
    for (unsigned i = 0; i < 4; ++i) { parse_hash_row(control.rows[6 + i], path(path(directory, "case"), case_files[i])); require(strncmp(control.rows[6 + i], qualified.rows[6 + i], 64) == 0, "case identity digest"); }
    const char* launch = path(root, "tools/wait-observe");
    const char* lock = "/home/david/buster-fast-bench/exclusive.sh";
    parse_hash_row(control.rows[10], launch); require(strncmp(control.rows[10], "c6389cb7c8529f0a09b573de59b328e7e19c48c1c664bce3dd364c45c3eb5a6f", 64) == 0, "launcher pin");
    parse_hash_row(control.rows[11], lock); require(strncmp(control.rows[11], "f3f4559861fa74e0790fde88fe68645b8ba8e170fb24313dc9f38b2f6feff083", 64) == 0, "lock pin");
    char* raw_control = bytes(path(directory, "before/control.identity"), true);
    const char* hash_start = strstr(raw_control, "sha256sum:\n"); require(hash_start != NULL, "control hash marker"); hash_text(hash_start + 11);
    equals_file(path(directory, "after/control.identity"), raw_control);
    Text diagnostic = lines(path(directory, "before/diagnostic.identity"));
    const char* diagnostic_binary = "/home/david/buster-fast-bench/149-merge-2dc-codex/diagnostic-2dc/build/compiler";
    const char* validator = path(root, "tools-source/docs/measurements/multicore-149/wait-diagnostic-merged-2026-11-06/validate-wait.py");
    const char* expected_paths[] = { diagnostic_binary, validator, launch, lock, path(timing, "case-status.txt"), path(timing, "reference/objects.sha256") };
    const char* pins[] = { "098eebdffc96491035b3508d56df6546aba5c97209b3f556088f9b1b73d049e3", "91168e21edbe8c68e56eb491ec41a2a98e241fe00b529ee641366c7ae99fce17", "c6389cb7c8529f0a09b573de59b328e7e19c48c1c664bce3dd364c45c3eb5a6f", "f3f4559861fa74e0790fde88fe68645b8ba8e170fb24313dc9f38b2f6feff083" };
    require(diagnostic.count == 6, "diagnostic identity length");
    for (unsigned i = 0; i < 6; ++i) { parse_hash_row(diagnostic.rows[i], expected_paths[i]); if (i < 4) require(strncmp(diagnostic.rows[i], pins[i], 64) == 0, "diagnostic binary/tool pin"); }
    hashes(path(directory, "before/diagnostic.identity"), NULL);
    same(path(directory, "before/diagnostic.identity"), path(directory, "after/diagnostic.identity"));
    same(path(directory, "before/applied.diff"), path(directory, "after/applied.diff"));
    char digest[65]; file_digest(path(directory, "before/applied.diff"), digest); require(strcmp(digest, "199e7888f51df9f46995ea751198a00f92ba306acd3272b016068ed66a245414") == 0, "applied diff pin");
    const char* stable[][2] = { {"sample/host-policy.before.txt", "host-policy.before.txt"}, {"sample/host-policy.after.txt", "host-policy.before.txt"}, {"sample/environment.txt", "environment.txt"}, {"sample/environment.after.txt", "environment.txt"} };
    for (unsigned i = 0; i < 4; ++i) same(path(directory, stable[i][0]), path(timing, stable[i][1]));
    equals_file(path(directory, "sample/trace-policy.txt"), "BUSTER_WAIT_TRACE=1\nscope=instrumented-session-lanes\nend-policy=forced-join\n");
    Text argv = lines(path(directory, "sample/argv.txt"));
    char lane_text[16], cpus[32] = {0}; snprintf(lane_text, sizeof(lane_text), "%u", lanes);
    for (unsigned i = 0; i < lanes; ++i) { size_t n = strlen(cpus); snprintf(cpus + n, sizeof(cpus) - n, "%s%u", i ? "," : "", i); }
    const char* first[] = { diagnostic_binary, "--lanes", lane_text, "--lane-cpus", cpus, "--worker-budget=8", "--time-stages" };
    require(argv.count == arguments.count + 7, "argv count");
    for (unsigned i = 0; i < 7; ++i) require(strcmp(argv.rows[i], first[i]) == 0, "diagnostic argv prefix");
    for (size_t i = 0; i < arguments.count; ++i) require(strcmp(argv.rows[i + 7], arguments.rows[i]) == 0, "diagnostic full input argv");
    Text placement = lines(path(directory, "sample/placement.txt"));
    require(placement.count == 4 && strcmp(placement.rows[0], "scope=initial-thread-before-exec") == 0 && strcmp(placement.rows[1], "worker-pinning-request=driver-lane-cpus") == 0 && key_number(placement.rows[2], "current-cpu=") < 8 && strcmp(placement.rows[3], "affinity=0,1,2,3,4,5,6,7") == 0, "process startup placement");
    Text process = lines(path(directory, "sample/process.txt"));
    require(process.count == 5 && strcmp(process.rows[0], "wait-status=0") == 0 && strcmp(process.rows[1], "interrupted=0") == 0, "child process status");
    uint64_t wall = key_number(process.rows[2], "wall-ns="); require(wall > 0, "positive child wall");
    (void)key_number(process.rows[3], "user-us="); (void)key_number(process.rows[4], "system-us=");
    equals_file(path(directory, "sample/compiler.status"), "0\n");
    Text pid_rows = lines(path(directory, "sample/compiler.pid")); require(pid_rows.count == 1, "PID receipt lines");
    uint64_t pid = integer(pid_rows.rows[0]); require(pid > 1 && pid <= INT_MAX, "compiler PID bound");
    char tids[256]; trace(path(directory, "sample/stderr.txt"), lanes, pid, tids);
    file_digest(path(directory, "sample/stderr.txt"), digest);
    char* validation = NULL; require(asprintf(&validation, "PASS lanes=%u metrics=%u sha256=%s tids=%s\n", lanes, lanes * 20, digest, tids) > 0, "validator expected receipt");
    equals_file(path(directory, "sample/validation.txt"), validation);
    stage_table(directory, lanes, wall);
    same(path(directory, "sample/objects.sha256"), path(timing, "reference/objects.sha256"));
    object_digests += outputs.count;
    for (size_t i = 0; i < outputs.count; ++i) { struct stat info; errno = 0; require(lstat(path(path(directory, "sample"), outputs.rows[i]), &info) != 0 && errno == ENOENT, "successful compared object was not removed"); }
    Text guard = lines(path(directory, "guard.stdout")); char* f[8];
    require(guard.count == 1 && split(guard.rows[0], f, 8) == 7 && strcmp(f[0], "lock-guard") == 0, "guard row format");
    uint64_t begin = key_number(f[1], "start-realtime-ns="), end = key_number(f[2], "end-realtime-ns="), duration = key_number(f[3], "monotonic-ns=");
    require(begin > 0 && end >= begin && begin >= previous_guard_end && duration > 0 && duration <= UINT64_C(255000000000) && wall <= duration && strcmp(f[4], "status=0") == 0 && strcmp(f[5], "interrupted=0") == 0 && strcmp(f[6], "descendants-clean=1") == 0, "guard status/cleanup/order/bounds");
    previous_guard_end = end; if (duration > maximum_guard) maximum_guard = duration;
    Text observation_status = lines(path(directory, "observation-status.txt"));
    require(observation_status.count == 5 && strcmp(observation_status.rows[0], "observation-status=validated") == 0 && strcmp(observation_status.rows[1], "observation-scope=campaign") == 0 && key_number(observation_status.rows[2], "guard-monotonic-ns=") == duration && key_number(observation_status.rows[3], "wrapper-wall-ns-including-wait=") >= duration && strcmp(observation_status.rows[4], "lock-hold-upper-bound-valid=1") == 0, "observation status/wrapper bound");
    (void)bytes(path(directory, "guard.stderr"), false); (void)bytes(path(directory, "sample/hash.stderr"), false); (void)bytes(path(directory, "sample/stdout.txt"), false);
    char* owner = bytes(path(directory, "lock-owner.txt"), true);
    char* owner_tail = NULL;
    require(asprintf(&owner_tail, " multicore-149-wait: %s --wait-guard --qualified %s --output %s --control-source /home/david/buster-fast-bench/149-merge-2dc-codex/compiler --diagnostic-source /home/david/buster-fast-bench/149-merge-2dc-codex/diagnostic-2dc --lock %s --validator %s --lanes %u\n  title: Buster issue 149 wait diagnostic\n  link: https://github.com/buster14a/buster/issues/149\n", launch, timing, directory, lock, validator, lanes) > 0, "owner command formatting");
    require(strlen(owner) > strlen(owner_tail) && strcmp(owner + strlen(owner) - strlen(owner_tail), owner_tail) == 0, "own-lock exact command receipt");
    ++audited;
    printf("observation=%s lanes=%u metrics=%u objects=%zu compiler-pid=%" PRIu64 " guard-ns=%" PRIu64 " status=PASS\n", name, lanes, lanes * 20, outputs.count, pid, duration);
}

int main(int argc, char** argv)
{
    if (argc == 5 && strcmp(argv[1], "--trace") == 0)
    {
        uint64_t requested = integer(argv[3]); require(requested >= 1 && requested <= 8, "trace fixture lane count");
        unsigned lanes = (unsigned)requested;
        uint64_t pid = integer(argv[4]); require(pid > 0 && pid <= INT_MAX, "trace fixture PID");
        char tids[256]; trace(argv[2], lanes, pid, tids);
        printf("independent-trace=PASS lanes=%u metrics=%u tids=%s\n", lanes, metrics_audited, tids);
    }
    else
    {
        require(argc == 2, "usage: wait-review CAMPAIGN or --trace TRACE LANES PID");
        root = realpath(argv[1], NULL); require(root != NULL, "campaign path");
        equals_file(path(root, "wait-controller.status"), "wait-status=completed\n");
        DIR* campaign = opendir(root); require(campaign != NULL, "campaign directory");
        unsigned found = 0;
        struct dirent* entry;
        while ((entry = readdir(campaign)) != NULL)
        {
            const char* label = strncmp(entry->d_name, "wait-sqlite-", 12) == 0 ? entry->d_name + 12 : strncmp(entry->d_name, "wait-synth-", 11) == 0 ? entry->d_name + 11 : strncmp(entry->d_name, "wait-musl-", 10) == 0 ? entry->d_name + 10 : NULL;
            if (label == NULL) continue;
            struct stat info;
            if (label[0] >= '1' && label[0] <= '8' && (strcmp(label + 1, "-controller.log") == 0 || strcmp(label + 1, "-controller.status") == 0))
            {
                require(lstat(path(root, entry->d_name), &info) == 0 && S_ISREG(info.st_mode), "controller receipt is not regular");
                continue;
            }
            require(strlen(label) == 1 && label[0] >= '1' && label[0] <= '8' && lstat(path(root, entry->d_name), &info) == 0 && S_ISDIR(info.st_mode), "unexpected ordinary wait entry");
            ++found;
        }
        require(closedir(campaign) == 0 && found == 24, "ordinary wait directory count");
        const char* labels[] = { "sqlite", "synth", "musl" };
        const unsigned expected[] = { 1, 512, 1309 };
        for (unsigned c = 0; c < 3; ++c)
        {
            char name[64]; snprintf(name, sizeof(name), "timing-%s", labels[c]); char* timing = path(root, name);
            arguments = lines(path(timing, "case/args.txt")); outputs = lines(path(timing, "case/outputs.txt"));
            require(outputs.count == expected[c], "case expected object count");
            Text objects = lines(path(timing, "reference/objects.sha256")); require(objects.count == outputs.count, "reference object digest count");
            for (size_t i = 0; i < outputs.count; ++i)
            {
                parse_hash_row(objects.rows[i], outputs.rows[i]);
                struct stat info;
                require(lstat(path(path(timing, "reference"), outputs.rows[i]), &info) == 0 && S_ISREG(info.st_mode) && info.st_size > 0, "reference object is not regular/nonempty");
            }
            hashes(path(timing, "reference/objects.sha256"), path(timing, "reference"));
            hashes(path(timing, "case/sources.sha256"), NULL);
            for (unsigned lanes = 1; lanes <= 8; ++lanes) observation(labels[c], lanes);
        }
        require(audited == 24 && metrics_audited == 2160 && object_digests == 14576, "full observation/metric/object-digest count");
        for (unsigned k = 0; k < 5; ++k) for (unsigned o = 0; o < 4; ++o)
        {
            printf("aggregate-buckets kind=%s outcome=%s intervals=[0,1000),[1000,10000),[10000,100000),[100000,1000000),[1000000,10000000),[10000000,100000000),[100000000,1000000000),[1000000000,infinity) counts=", kinds[k], outcomes[o]);
            for (unsigned b = 0; b < 8; ++b) printf("%s%" PRIu64, b ? "," : "", totals[k][o][b]);
            putchar('\n');
        }
        printf("ordinary-wait-record-integrity=PASS observations=24 lanes=108 metrics=2160 reference-objects=1822 diagnostic-object-digests=14576 maximum-guard-ns=%" PRIu64 "\n", maximum_guard);
        puts("scope=perturbed-session-lanes;forced-join;worker-TIDs-not-independently-corroborated;no-exact-above-1.5ms-count;no-residency-or-frequency-claim;no-parent-issue-acceptance");
    }
    require(fflush(stdout) == 0 && !ferror(stdout), "output write failure");
    return 0;
}

