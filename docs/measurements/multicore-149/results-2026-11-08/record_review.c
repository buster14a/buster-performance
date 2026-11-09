// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Independent read-only audit of retained 21df57f8 timing records; no runner code is included.
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
static char* compiler;
static uint64_t times[9][7];
static uint64_t previous_guard_end;
static uint64_t maximum_guard;
static unsigned audited;
static unsigned diagnostic_count;
static double one_lane_serial;

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

static const char* stage_names[] = {
    "setup", "lanes-start", "preprocess", "parse", "type-table", "check-input", "check-expressions", "check-declarations",
    "static-data", "check-program", "select", "backend-setup", "lower", "tier0", "emit-setup", "lanes", "branch-sizing",
    "encode", "unwind", "code-atoms", "debug", "publish-data", "object-build", "object-write", "runtime", "executable", "write", "release", "total", "lower.prepare"
};

static bool serial_stage(size_t i, bool multiple)
{
    bool selected = i == 0 || i == 27;
    if (!multiple) selected = selected || (i >= 2 && i <= 11) || i == 14 || (i >= 21 && i <= 23);
    return selected;
}

static void stages(const char* directory, unsigned lanes, bool cpu2, uint64_t wall)
{
    Text stderr_rows = lines(path(directory, "stderr.txt"));
    unsigned seen[30] = { 0 }, pin[8] = { 0 }, asked = 0, actual = 0, stage_headers = 0;
    double values[30] = { 0 };
    for (size_t r = 0; r < stderr_rows.count; r += 1)
    {
        char* row = stderr_rows.rows[r];
        if (strncmp(row, "lane-pin", 8) == 0)
        {
            char* f[8];
            require(split(row, f, 8) == 5 && strcmp(f[0], "lane-pin") == 0, "pin format");
            uint64_t index = key_number(f[1], "index=");
            require(index < lanes && key_number(f[2], "expected=") == (cpu2 ? 2 : index) && key_number(f[3], "observed=") == (cpu2 ? 2 : index) && strcmp(f[4], "status=0") == 0, "pin CPU/status");
            pin[index] += 1;
        }
        else if (strncmp(row, "time-process\tlanes-asked\t", 25) == 0)
        {
            require(integer(row + 25) == lanes, "asked lanes");
            asked += 1;
        }
        else if (strncmp(row, "time-process\tlanes\t", 19) == 0)
        {
            require(integer(row + 19) == lanes, "actual lanes");
            actual += 1;
        }
        else if (strncmp(row, "time-stage\t", 11) == 0)
        {
            char* f[16];
            size_t fields = split(row, f, 16);
            require(fields >= 3, "stage format");
            if (strcmp(f[1], "stage") == 0)
            {
                require(fields == 7 && strcmp(f[2], "ms") == 0 && strcmp(f[3], "percent") == 0 &&
                        strcmp(f[4], "system-ms") == 0 && strcmp(f[5], "minor-faults") == 0 &&
                        strcmp(f[6], "peak-kb-added") == 0, "stage header format");
                stage_headers += 1;
                continue;
            }
            double value = decimal(f[2]);
            require(value >= 0, "negative stage time");
            for (size_t s = 0; s < 30; s += 1)
            {
                if (strcmp(f[1], stage_names[s]) == 0)
                {
                    seen[s] += 1;
                    values[s] = value;
                }
            }
        }
        else require(strncmp(row, "wait-diagnostic", 15) != 0, "perturbed wait trace in normal timing compiler");
    }
    require(asked == 1 && actual == 1, "team receipt count");
    require(stage_headers == 1, "stage header multiplicity");
    for (unsigned i = 0; i < lanes; i += 1) require(pin[i] == 1, "pin receipt multiplicity");
    double sum = 0, serial = outputs.count == 1 ? values[29] : 0;
    for (size_t i = 0; i < 30; i += 1)
    {
        require(seen[i] == 1, "stage receipt multiplicity for %s", stage_names[i]);
        if (i < 28)
        {
            sum += values[i];
            if (serial_stage(i, outputs.count > 1)) serial += values[i];
        }
    }
    double paired = (double)wall / 1e6;
    require(values[28] > 0 && fabs(sum - values[28]) <= 0.056 && values[28] <= paired + 0.1 && serial <= values[28] + 0.056, "raw stage totals/wall bound");
    Text tsv = lines(path(directory, "stages.tsv"));
    require(tsv.count == 2 && strcmp(tsv.rows[0], "lanes\tpaired_wall_ms\tstage_total_ms\tserial_lower_bound_ms\tserial_elapsed_share_lower_bound\tamdahl_8_upper_from_one_lane\tamdahl_infinite_upper_from_one_lane\tlanes_start_ms") == 0, "stage table format");
    char* f[12];
    require(split(tsv.rows[1], f, 12) == 8 && integer(f[0]) == lanes, "stage table lane count");
    close_value(f[1], paired, 0.0000011);
    close_value(f[2], values[28], 0.0000011);
    close_value(f[3], serial, 0.0000011);
    close_value(f[4], serial / paired, 0.0000000011);
    close_value(f[7], values[1], 0.0000011);
    if (lanes == 1 && !cpu2 && serial > 0)
    {
        close_value(f[5], 1 / (serial / paired + (1 - serial / paired) / 8), 0.0000011);
        close_value(f[6], paired / serial, 0.0000011);
        one_lane_serial = decimal(f[3]) / decimal(f[1]);
    }
    else require(strcmp(f[5], "NA") == 0 && strcmp(f[6], "NA") == 0, "nonbaseline Amdahl fields");
    diagnostic_count += 1;
}

static void guard(const char* name, uint64_t wall)
{
    char* stdout_name = NULL;
    char* window_name = NULL;
    require(asprintf(&stdout_name, "%s.lock.stdout", name) > 0 && asprintf(&window_name, "%s.lock-window.txt", name) > 0, "guard path");
    Text raw = lines(path(root, stdout_name));
    require(raw.count == 1, "guard row count");
    char* f[8];
    require(split(raw.rows[0], f, 8) == 7 && strcmp(f[0], "lock-guard") == 0, "guard structure");
    uint64_t begin = key_number(f[1], "start-realtime-ns=");
    uint64_t end = key_number(f[2], "end-realtime-ns=");
    uint64_t elapsed = key_number(f[3], "monotonic-ns=");
    require(begin > 0 && end >= begin && elapsed > 0 && elapsed <= UINT64_C(255000000000) && wall <= elapsed && begin >= previous_guard_end, "guard clock/duration/order bound");
    require(strcmp(f[4], "status=0") == 0 && strcmp(f[5], "interrupted=0") == 0 && strcmp(f[6], "descendants-clean=1") == 0, "guard status/cleanup");
    previous_guard_end = end;
    if (elapsed > maximum_guard) maximum_guard = elapsed;
    Text window = lines(path(root, window_name));
    require(window.count == 5 && key_number(window.rows[0], "guard-monotonic-ns=") == elapsed && key_number(window.rows[1], "wrapper-wall-ns-including-wait=") >= elapsed && strcmp(window.rows[2], "wrapper-status=0") == 0 && strcmp(window.rows[3], "wrapper-interrupted=0") == 0 && strcmp(window.rows[4], "lock-hold-upper-bound-valid=1") == 0, "wrapper receipt/bounds");
    char* stderr_name = NULL;
    require(asprintf(&stderr_name, "%s.lock.stderr", name) > 0, "wrapper stderr path");
    (void)bytes(path(root, stderr_name), false);
}

static void sample(const char* name, unsigned slot, bool instrumented, int round, const char* identity, const char* policy, const char* environment, const char* object_hashes)
{
    subject = name;
    unsigned lanes = slot < 8 ? slot + 1 : 1;
    bool cpu2 = slot == 8;
    char* directory = path(root, name);
    Text table = lines(path(directory, "sample.tsv"));
    require(table.count == 2 && strcmp(table.rows[0], "lanes\tinstrumented\tcpu_mask\twall_ns\tuser_us\tsystem_us\twait4_peak_kb\tminor_faults\tmajor_faults\tvoluntary_switches\tinvoluntary_switches\twait_status\tinterrupted\tobjects\tverified") == 0, "sample table format");
    char* f[16];
    require(split(table.rows[1], f, 16) == 15, "sample field count");
    uint64_t v[15];
    for (size_t i = 0; i < 15; i += 1) v[i] = integer(f[i]);
    require(v[0] == lanes && v[1] == instrumented && v[2] == (cpu2 ? 4 : 255) && v[3] > 0 && v[11] == 0 && v[12] == 0 && v[13] == outputs.count && v[14] == 1, "sample lanes/status/count/verified");
    guard(name, v[3]);
    const char* paired[] = { "identity.before.txt", "identity.after.txt", "host-policy.before.txt", "host-policy.after.txt", "environment.txt", "environment.after.txt", "objects.sha256" };
    const char* expected[] = { identity, identity, policy, policy, environment, environment, object_hashes };
    for (size_t i = 0; i < 7; i += 1) equals_file(path(directory, paired[i]), expected[i]);
    const char* host_files[] = { "host.before.txt", "host.after.txt" };
    for (size_t i = 0; i < 2; i += 1)
    {
        char* host = bytes(path(directory, host_files[i]), true);
        const char* prefix_end = policy;
        for (unsigned line = 0; line < 3; line += 1)
        {
            prefix_end = strchr(prefix_end, '\n');
            require(prefix_end != NULL, "host policy header");
            prefix_end += 1;
        }
        require(strncmp(host, policy, (size_t)(prefix_end - policy)) == 0 && strstr(host, "primary-compiler-affinity=0,1,2,3,4,5,6,7\nworker-affinity=driver-pinned-to-requested-cpus; diagnostic-receipts-verify-placement\n") != NULL && strstr(host, "temperature-readings=") != NULL, "host observation header/completeness");
    }
    Text argv = lines(path(directory, "argv.txt"));
    require(argv.count == arguments.count + 6 + instrumented && strcmp(argv.rows[0], compiler) == 0 && strcmp(argv.rows[1], "--lanes") == 0 && integer(argv.rows[2]) == lanes && strcmp(argv.rows[3], "--lane-cpus") == 0 && strcmp(argv.rows[5], "--worker-budget=8") == 0, "compiler argv prefix");
    char cpus[32] = { 0 };
    for (unsigned i = 0; i < lanes; i += 1)
    {
        char piece[8];
        snprintf(piece, sizeof(piece), "%s%u", i == 0 ? "" : ",", cpu2 ? 2 : i);
        strcat(cpus, piece);
    }
    require(strcmp(argv.rows[4], cpus) == 0, "ordered lane CPU argument");
    if (instrumented) require(strcmp(argv.rows[6], "--time-stages") == 0, "diagnostic option");
    for (size_t i = 0; i < arguments.count; i += 1) require(strcmp(argv.rows[6 + instrumented + i], arguments.rows[i]) == 0, "case argument mutation");
    Text placement = lines(path(directory, "placement.txt"));
    require(placement.count == 4 && strcmp(placement.rows[0], "scope=initial-thread-before-exec") == 0 && strcmp(placement.rows[1], "worker-pinning-request=driver-lane-cpus") == 0 && strcmp(placement.rows[3], cpu2 ? "affinity=2" : "affinity=0,1,2,3,4,5,6,7") == 0, "initial placement receipt");
    uint64_t cpu = key_number(placement.rows[2], "current-cpu=");
    require(cpu2 ? cpu == 2 : cpu < 8, "initial observed CPU outside mask");
    char* stderr_text = bytes(path(directory, "stderr.txt"), instrumented);
    (void)bytes(path(directory, "stdout.txt"), false);
    (void)bytes(path(directory, "hash.stderr"), false);
    if (instrumented) stages(directory, lanes, cpu2, v[3]);
    else require(strstr(stderr_text, "time-stage\t") == NULL && strstr(stderr_text, "wait-diagnostic") == NULL, "instrumentation in normal sample");
    if (round >= 0) times[slot][round] = v[3];
    audited += 1;
}

static void summary(void)
{
    subject = "summary";
    require(one_lane_serial >= 0 && one_lane_serial <= 1, "one-lane serial share");
    Text table = lines(path(root, "summary.tsv"));
    require(table.count == 10 && strcmp(table.rows[0], "cohort\tlanes\tcpu_mask\truns\tmedian_ms\tmin_ms\tmax_ms\tspeedup_vs_one_lane_same_mask\teffective_serial_fraction\tserial_fraction_lower_bound_from_one_lane\tamdahl_upper_from_one_lane\tamdahl_infinite_upper_from_one_lane") == 0, "summary table format");
    uint64_t baseline = 0;
    for (unsigned slot = 0; slot < 9; slot += 1)
    {
        uint64_t sorted[7];
        memcpy(sorted, times[slot], sizeof(sorted));
        for (size_t i = 0; i < 7; i += 1)
        {
            require(sorted[i] > 0, "missing normal timing value");
            for (size_t j = i + 1; j < 7; j += 1)
            {
                if (sorted[j] < sorted[i])
                {
                    uint64_t swap = sorted[i]; sorted[i] = sorted[j]; sorted[j] = swap;
                }
            }
        }
        if (slot == 0) baseline = sorted[3];
        unsigned lanes = slot < 8 ? slot + 1 : 1;
        char* f[16];
        require(split(table.rows[slot + 1], f, 16) == 12 && strcmp(f[0], slot < 8 ? "primary" : "cpu2-control") == 0 && integer(f[1]) == lanes && integer(f[2]) == (slot < 8 ? 255 : 4) && integer(f[3]) == 7, "summary cohort");
        close_value(f[4], (double)sorted[3] / 1e6, 0.0000011);
        close_value(f[5], (double)sorted[0] / 1e6, 0.0000011);
        close_value(f[6], (double)sorted[6] / 1e6, 0.0000011);
        if (slot < 8)
        {
            double speedup = (double)baseline / (double)sorted[3];
            close_value(f[7], speedup, 0.0000000011);
            if (lanes > 1) close_value(f[8], ((double)lanes / speedup - 1) / (lanes - 1), 0.0000000011);
            else require(strcmp(f[8], "NA") == 0, "one-lane effective serial field");
            close_value(f[9], one_lane_serial, 0.0000000011);
            close_value(f[10], 1 / (one_lane_serial + (1 - one_lane_serial) / lanes), 0.0000000011);
            if (one_lane_serial > 0) close_value(f[11], 1 / one_lane_serial, 0.0000000011);
            else require(strcmp(f[11], "NA") == 0, "zero-share asymptote");
        }
        else for (unsigned fno = 7; fno < 12; fno += 1) require(strcmp(f[fno], "NA") == 0, "control labeled as a primary curve point");
        printf("recomputed-cohort slot=%u lanes=%u mask=%u median-ns=%" PRIu64 " min-ns=%" PRIu64 " max-ns=%" PRIu64 "\n", slot, lanes, slot < 8 ? 255 : 4, sorted[3], sorted[0], sorted[6]);
    }
}

static void topology(const char* policy)
{
    require(strstr(policy, "model=AMD Ryzen 7 9700X ") != NULL, "wrong host model");
    unsigned package[8] = { 0 }, core[8] = { 0 }, seen[8] = { 0 };
    char* copy = strdup(policy);
    char* cursor = copy;
    char* line = NULL;
    while ((line = strsep(&cursor, "\n")) != NULL)
    {
        if (strstr(line, " package=") != NULL)
        {
            unsigned cpu, p, c;
            char siblings[128], governor[128];
            int used = 0;
            require(sscanf(line, "cpu=%u package=%u core=%u siblings=%127s governor=%127s%n", &cpu, &p, &c, siblings, governor, &used) == 5 && line[used] == 0 && cpu < 8 && governor[0] != 0, "topology row");
            seen[cpu] += 1; package[cpu] = p; core[cpu] = c;
        }
    }
    for (unsigned i = 0; i < 8; i += 1)
    {
        require(seen[i] == 1, "physical core row multiplicity");
        for (unsigned j = 0; j < i; j += 1) require(package[i] != package[j] || core[i] != core[j], "logical siblings used as separate physical cores");
    }
    free(copy);
}

int main(int argc, char** argv)
{
    require(argc == 4, "usage: audit CASE-DIRECTORY EXPECTED-OBJECTS EXPECTED-INPUT-HASHES");
    root = realpath(argv[1], NULL);
    require(root != NULL, "case directory");
    size_t expected_objects = (size_t)integer(argv[2]);
    size_t expected_hashes = (size_t)integer(argv[3]);
    arguments = lines(path(root, "case/args.txt"));
    outputs = lines(path(root, "case/outputs.txt"));
    require(outputs.count == expected_objects && expected_objects > 0, "manifest object count");
    for (size_t i = 0; i < outputs.count; i += 1)
    {
        require(outputs.rows[i][0] != 0 && strchr(outputs.rows[i], '/') == NULL, "output filename");
        for (size_t j = 0; j < i; j += 1) require(strcmp(outputs.rows[i], outputs.rows[j]) != 0, "duplicate output name");
    }
    Text source_hashes = lines(path(root, "case/sources.sha256"));
    require(source_hashes.count == expected_hashes, "input digest cohort count");
    for (size_t i = 0; i < source_hashes.count; i += 1)
    {
        parse_hash_row(source_hashes.rows[i], NULL);
        require(source_hashes.rows[i][66] == '/', "nonabsolute input identity");
        for (size_t j = 0; j < i; j += 1) require(strcmp(source_hashes.rows[i] + 66, source_hashes.rows[j] + 66) != 0, "duplicate input digest path");
    }
    unsigned compile_only = 0;
    size_t direct_sources = 0;
    bool* observed_outputs = calloc(outputs.count, sizeof(*observed_outputs));
    require(observed_outputs != NULL, "source cohort accounting allocation");
    for (size_t i = 0; i < arguments.count; i += 1)
    {
        const char* argument = arguments.rows[i];
        require(strcmp(argument, "--deferred-bodies") != 0, "deferred campaign outside admitted default scope");
        compile_only += strcmp(argument, "-c") == 0;
        size_t length = strlen(argument);
        if (argument[0] == '/' && length > 2 && strcmp(argument + length - 2, ".c") == 0)
        {
            unsigned matched = 0;
            for (size_t j = 0; j < source_hashes.count; j += 1) matched += strcmp(argument, source_hashes.rows[j] + 66) == 0;
            require(matched == 1, "direct input absent from digest manifest");
            char* object = strdup(strrchr(argument, '/') + 1);
            object[strlen(object) - 1] = 'o';
            matched = 0;
            for (size_t j = 0; j < outputs.count; j += 1)
            {
                if (strcmp(object, outputs.rows[j]) == 0)
                {
                    require(!observed_outputs[j], "duplicate direct source/object binding");
                    observed_outputs[j] = true;
                    matched += 1;
                }
            }
            require(matched == 1, "direct input has no unique required object");
            free(object);
            direct_sources += 1;
        }
    }
    require(compile_only == 1 && direct_sources == outputs.count, "compile-only complete input cohort");
    for (size_t i = 0; i < outputs.count; i += 1) require(observed_outputs[i], "required object has no direct source argument");
    char* identity = bytes(path(root, "identity.before.txt"), true);
    char* policy = bytes(path(root, "host-policy.before.txt"), true);
    char* environment = bytes(path(root, "environment.txt"), true);
    equals_file(path(root, "identity.after.txt"), identity);
    equals_file(path(root, "host-policy.after.txt"), policy);
    equals_file(path(root, "environment.after.txt"), environment);
    const char* normalized = "compiler-environment:\nLC_ALL=C\nLANG=C\nTZ=UTC\nSOURCE_DATE_EPOCH=0\n";
    require(strncmp(environment, normalized, strlen(normalized)) == 0 && strstr(environment, "\nLD_PRELOAD=absent\nLD_LIBRARY_PATH=absent\n") != NULL && strstr(environment, "\nBUSTER_HUGE_PAGES=unset\nCORES=unset\nPATH=/usr/local/bin:/usr/bin:/bin\n") != NULL, "admitted normalized environment");
    topology(policy);
    require(strstr(identity, "compiler-revision=2dc50258e8b33393474b64032a5cbe9f17c63def\ncompiler-source-state=clean\nsha256sum:\n51b54dd02986a28f294c0d5b2539e93739acb8962851127316da7953d4f8b09b  ") != NULL && strstr(identity, "1e6ec3d9fe780c096323c945ee311d54af975104d9d1713809392fa30ac20c72  ") != NULL && strstr(identity, "e354444a18ae4a079014d3d0bef0b5107d8294ca633cbc2655f70ed04d416ca1  ") != NULL, "pinned source/compiler/lane/runner identities");
    Text identity_rows = lines(path(root, "identity.before.txt"));
    require(identity_rows.count == 12 && strncmp(identity_rows.rows[0], "compiler-source=/", 17) == 0 && strcmp(identity_rows.rows[1], "compiler-revision=2dc50258e8b33393474b64032a5cbe9f17c63def") == 0 && strcmp(identity_rows.rows[2], "compiler-source-state=clean") == 0 && strcmp(identity_rows.rows[3], "sha256sum:") == 0, "root identity format");
    for (size_t i = 4; i < 12; i += 1) parse_hash_row(identity_rows.rows[i], NULL);
    require(strncmp(identity_rows.rows[5], "1e6ec3d9fe780c096323c945ee311d54af975104d9d1713809392fa30ac20c72", 64) == 0 && strncmp(identity_rows.rows[10], "e354444a18ae4a079014d3d0bef0b5107d8294ca633cbc2655f70ed04d416ca1", 64) == 0 && strncmp(identity_rows.rows[11], "f3f4559861fa74e0790fde88fe68645b8ba8e170fb24313dc9f38b2f6feff083", 64) == 0, "lane/runner/shared-lock pins");
    char* source = identity_rows.rows[0] + 16;
    parse_hash_row(identity_rows.rows[4], path(source, "build/compiler"));
    parse_hash_row(identity_rows.rows[5], path(source, "src/buster/compiler/lane.c"));
    const char* case_files[] = { "args.txt", "outputs.txt", "sources.sha256", "provenance.txt" };
    for (size_t i = 0; i < 4; i += 1) parse_hash_row(identity_rows.rows[6 + i], path(path(root, "case"), case_files[i]));
    const char* pinned_manifests[][4] =
    {
        { "52e2e0472a6448b8575af022fea561331d1fc328927e02fa61503c61c539167e", "93454bb1577feba3efe85f06f945d872f9f150674eba928d5b0c439fe39429da", "0faa78042ad6714eb85090878dfc0e51157be5ec15084771cd5143674c4b6dee", "df3423fe3f9aca3fe3463184ddb841d6448a1985fdc41d697197271e0d878ab8" },
        { "3611ab46867f87a47b84b525df60ad5fdb1dc798bb972ba0cbc294af85f905ac", "748729aa947d7d30fe09c51e42c163f8da64276998ae0b959f8fc4973a88c76f", "66f0a01542e15c75ab2cb899ee21e964d1ad2d6fb40feb1c2f0a799fea8af250", "bb30117bc519f616dc0226a9a740efab187eecfdabafe5f75b033188fcb1cd7b" },
        { "1e2fc6431d30d296be66ecd51bea69bb0d4a0ba9b936e7270c2d5fa802c6d115", "b364af8078d851ba2ea04df95fff08c3f5997d788a453ce1ec1f173eb739cae3", "8908a037437babb99da35300f6d804e44a1a260dd03442c64dfe9aba5bf8fe40", "1183b6025aab3e34160dd3844a8d401f417b33ced05da0c8ca65de0f70fff560" },
    };
    unsigned cohort = outputs.count == 1 ? 0 : outputs.count == 512 ? 1 : 2;
    require(outputs.count == 1 || outputs.count == 512 || outputs.count == 1309, "unexpected admitted case");
    for (size_t i = 0; i < 4; i += 1) require(strncmp(identity_rows.rows[6 + i], pinned_manifests[cohort][i], 64) == 0, "prepared manifest pin changed for %s", case_files[i]);
    const char* first_hash = strstr(identity, "sha256sum:\n") + strlen("sha256sum:\n");
    hash_text(first_hash);
    const char* first_name = first_hash + 66;
    const char* first_end = strchr(first_name, '\n');
    require(first_end != NULL, "compiler identity row");
    compiler = strndup(first_name, (size_t)(first_end - first_name));
    Text reference_hashes = lines(path(root, "reference/objects.sha256"));
    require(reference_hashes.count == outputs.count, "reference digest count");
    for (size_t i = 0; i < outputs.count; i += 1)
    {
        parse_hash_row(reference_hashes.rows[i], outputs.rows[i]);
        struct stat info;
        require(lstat(path(path(root, "reference"), outputs.rows[i]), &info) == 0 && S_ISREG(info.st_mode) && info.st_size > 0, "reference object regular/nonempty");
    }
    hashes(path(root, "reference/objects.sha256"), path(root, "reference"));
    hashes(path(root, "case/sources.sha256"), NULL);
    char* object_hashes = bytes(path(root, "reference/objects.sha256"), true);
    sample("reference", 0, false, -1, identity, policy, environment, object_hashes);
    for (unsigned slot = 0; slot < 9; slot += 1)
    {
        char name[64]; snprintf(name, sizeof(name), "warmup-%u", slot);
        sample(name, slot, false, -1, identity, policy, environment, object_hashes);
    }
    for (unsigned round = 0; round < 7; round += 1)
    {
        for (unsigned position = 0; position < 9; position += 1)
        {
            unsigned slot = (round + position) % 9;
            char name[64]; snprintf(name, sizeof(name), "run-%03u-%u", round + 1, slot);
            sample(name, slot, false, (int)round, identity, policy, environment, object_hashes);
        }
    }
    for (unsigned slot = 0; slot < 9; slot += 1)
    {
        char name[64]; snprintf(name, sizeof(name), "diagnostic-%u", slot);
        sample(name, slot, true, -1, identity, policy, environment, object_hashes);
    }
    subject = "case final";
    require(audited == 82 && diagnostic_count == 9, "case count");
    DIR* entries = opendir(root);
    require(entries != NULL, "enumerate case");
    struct dirent* item;
    unsigned directories = 0;
    unsigned guards = 0, windows = 0, wrapper_errors = 0;
    while ((item = readdir(entries)) != NULL)
    {
        if (strcmp(item->d_name, ".") == 0 || strcmp(item->d_name, "..") == 0) continue;
        struct stat info;
        require(lstat(path(root, item->d_name), &info) == 0, "case entry stat");
        if (S_ISDIR(info.st_mode)) directories += 1;
        else
        {
            require(S_ISREG(info.st_mode), "nonregular root record");
            size_t length = strlen(item->d_name);
            guards += length >= 12 && strcmp(item->d_name + length - 12, ".lock.stdout") == 0;
            wrapper_errors += length >= 12 && strcmp(item->d_name + length - 12, ".lock.stderr") == 0;
            windows += length >= 16 && strcmp(item->d_name + length - 16, ".lock-window.txt") == 0;
        }
    }
    require(closedir(entries) == 0 && directories == 83 && guards == 82 && windows == 82 && wrapper_errors == 82, "extra/missing sample directories or per-grant receipts");
    equals_file(path(root, "case-status.txt"), "case-status=qualified\nparent-issue-status=not-established-by-one-case\n");
    summary();
    printf("independent-review=PASS samples=%u normal=63 warmup=9 diagnostic=%u reference=1 objects-per-sample=%zu object-hash-records=%zu guard-max-ns=%" PRIu64 "\n", audited, diagnostic_count, outputs.count, outputs.count * audited, maximum_guard);
    printf("review-boundary=timing-case-only;normal-placement-relies-on-pinned-driver;candidate-objects-were-compared-then-deleted-by-reviewed-runner;reference-objects-independently-rehashed;not-parent-issue-acceptance\n");
    return 0;
}
