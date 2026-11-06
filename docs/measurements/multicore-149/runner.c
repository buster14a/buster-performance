// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and THIRD_PARTY_NOTICES.md.
//
// #149: whole-process, compile-only 1..8-lane acceptance on Benchpress. The controller never holds the host lock:
// it invokes exclusive.sh once per sample, which invokes this executable's --sample helper. Only the compiler's
// fork-to-wait4 interval is timed. Inputs, binaries, source revision and host policy are checked outside that interval.
// Each sample has fresh outputs, full logs and an exact child status; complete objects are compared with one lane's.
// --self-test uses private in-process configuration and this executable's fake compiler. It cannot publish acceptance.
// Layout: read_case; run_process; identity/host_receipt; sample; campaign; runner_test.c's isolated failure controls.
#define _GNU_SOURCE
#include <ctype.h>
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <limits.h>
#include <math.h>
#include <sched.h>
#include <signal.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/file.h>
#include <sys/prctl.h>
#include <sys/resource.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#define BUSTER_LANES 8u
#define BUSTER_MAX_RUNS 101u
#define BUSTER_MAX_ARGUMENTS 8192u
#define BUSTER_MAX_OUTPUTS 4096u
#define BUSTER_MAX_SOURCES 65536u
#define BUSTER_TEXT_LIMIT (16u << 20)
#define BUSTER_SAMPLE_SECONDS 120u
#define BUSTER_LOCK_SECONDS 1200u
#define BUSTER_LOCK_PATH "/var/lib/buster-9700x/lock"

extern char** environ;

typedef struct Lines Lines;
struct Lines
{
    char* text;
    char** items;
    size_t count;
};

typedef struct Case Case;
struct Case
{
    Lines arguments;
    Lines outputs;
    Lines hashes;
    char** source_paths;
    bool deferred;
};

typedef struct Configuration Configuration;
struct Configuration
{
    char executable[PATH_MAX];
    char case_directory[PATH_MAX];
    char output[PATH_MAX];
    char compiler[PATH_MAX];
    char source[PATH_MAX];
    char lock[PATH_MAX];
    char reference[PATH_MAX];
    char expected_identity[PATH_MAX];
    unsigned runs;
    unsigned lanes;
    bool helper;
    bool instrumented;
    bool cpu2;
    // Only runner_self_test sets these; no production command-line or environment override exists.
    const char* fake_mode;
    unsigned timeout;
};

typedef struct Process Process;
struct Process
{
    uint64_t wall_ns;
    uint64_t user_us;
    uint64_t system_us;
    uint64_t peak_kb;
    uint64_t minor_faults;
    uint64_t major_faults;
    uint64_t voluntary_switches;
    uint64_t involuntary_switches;
    int status;
    bool interrupted;
};

static volatile sig_atomic_t process_group;
static volatile sig_atomic_t process_signal;
static volatile sig_atomic_t process_grace = 5;

static void stop_process(int number)
{
    const int signal_number = process_signal != 0 ? SIGKILL : SIGTERM;
    process_signal = number;
    if (process_group > 0)
    {
        kill(-(pid_t)process_group, signal_number);
        kill((pid_t)process_group, signal_number);
        alarm((unsigned)process_grace);
    }
}

static bool install_signals(void)
{
    const struct sigaction action = {
        .sa_handler = stop_process,
    };
    bool valid = sigaction(SIGALRM, &action, NULL) == 0;
    valid = sigaction(SIGINT, &action, NULL) == 0 && valid;
    valid = sigaction(SIGTERM, &action, NULL) == 0 && valid;
    valid = sigaction(SIGHUP, &action, NULL) == 0 && valid;
    return valid;
}

static bool path_join(char* result, size_t capacity, const char* directory, const char* name)
{
    const int length = snprintf(result, capacity, "%s/%s", directory, name);
    return length > 0 && (size_t)length < capacity;
}

static bool copy_string(char* result, size_t capacity, const char* text)
{
    const size_t length = strlen(text);
    const bool valid = length < capacity;
    if (valid)
    {
        memcpy(result, text, length + 1);
    }
    return valid;
}

static bool plain_text(const char* text)
{
    bool valid = text != NULL && *text != 0;
    for (const unsigned char* at = (const unsigned char*)text; valid && *at != 0; at += 1)
    {
        valid = *at >= 32 && *at != 127;
    }
    return valid;
}

static bool number(const char* text, unsigned maximum, unsigned* result)
{
    uint64_t value = 0;
    bool valid = text != NULL && *text != 0;
    for (const char* at = text; valid && *at != 0; at += 1)
    {
        valid = *at >= '0' && *at <= '9';
        if (valid)
        {
            value = value * 10 + (unsigned)(*at - '0');
            valid = value <= maximum;
        }
    }
    if (valid)
    {
        *result = (unsigned)value;
    }
    return valid;
}

static uint64_t now_ns(void)
{
    struct timespec value = { 0 };
    const bool read = clock_gettime(CLOCK_MONOTONIC, &value) == 0;
    return read ? (uint64_t)value.tv_sec * UINT64_C(1000000000) + (uint64_t)value.tv_nsec : 0;
}

static char* read_text(const char* path, size_t* length)
{
    FILE* file = fopen(path, "rb");
    char* result = NULL;
    size_t used = 0;
    size_t capacity = 4096;
    char* bytes = file != NULL ? malloc(capacity + 1) : NULL;
    bool valid = bytes != NULL;
    while (valid)
    {
        const size_t got = fread(bytes + used, 1, capacity - used, file);
        used += got;
        valid = !ferror(file);
        if (!valid || feof(file))
        {
            break;
        }
        if (used == capacity)
        {
            valid = capacity < BUSTER_TEXT_LIMIT;
            char* larger = valid ? realloc(bytes, capacity * 2 + 1) : NULL;
            valid = larger != NULL;
            if (valid)
            {
                bytes = larger;
                capacity *= 2;
            }
        }
    }
    if (file != NULL)
    {
        valid = fclose(file) == 0 && valid;
    }
    valid = valid && memchr(bytes, 0, used) == NULL;
    if (valid)
    {
        bytes[used] = 0;
        result = bytes;
        *length = used;
    }
    else
    {
        free(bytes);
    }
    return result;
}

static bool write_text(const char* path, const char* text)
{
    FILE* file = fopen(path, "wb");
    const size_t length = strlen(text);
    bool valid = file != NULL && fwrite(text, 1, length, file) == length;
    if (file != NULL)
    {
        valid = fclose(file) == 0 && valid;
    }
    return valid;
}

static bool copy_file(const char* source, const char* destination)
{
    FILE* input = fopen(source, "rb");
    FILE* output = input != NULL ? fopen(destination, "wb") : NULL;
    bool valid = input != NULL && output != NULL;
    size_t got = 1;
    while (valid && got != 0)
    {
        unsigned char bytes[65536];
        got = fread(bytes, 1, sizeof(bytes), input);
        valid = !ferror(input) && fwrite(bytes, 1, got, output) == got;
    }
    if (input != NULL)
    {
        valid = fclose(input) == 0 && valid;
    }
    if (output != NULL)
    {
        valid = fclose(output) == 0 && valid;
    }
    return valid;
}

static bool same_file(const char* left, const char* right)
{
    struct stat a_status;
    struct stat b_status;
    bool valid = lstat(left, &a_status) == 0 && lstat(right, &b_status) == 0 && S_ISREG(a_status.st_mode) && S_ISREG(b_status.st_mode) &&
                 a_status.st_size > 0 && a_status.st_size == b_status.st_size;
    FILE* a = valid ? fopen(left, "rb") : NULL;
    FILE* b = valid ? fopen(right, "rb") : NULL;
    valid = valid && a != NULL && b != NULL;
    size_t got = 1;
    while (valid && got != 0)
    {
        unsigned char first[65536];
        unsigned char second[65536];
        got = fread(first, 1, sizeof(first), a);
        const size_t other = fread(second, 1, sizeof(second), b);
        valid = got == other && memcmp(first, second, got) == 0 && !ferror(a) && !ferror(b);
    }
    if (a != NULL)
    {
        valid = fclose(a) == 0 && valid;
    }
    if (b != NULL)
    {
        valid = fclose(b) == 0 && valid;
    }
    return valid;
}

static void free_lines(Lines* lines)
{
    free(lines->items);
    free(lines->text);
    *lines = (Lines){ 0 };
}

static bool read_lines(const char* path, size_t maximum, Lines* lines)
{
    size_t length = 0;
    lines->text = read_text(path, &length);
    bool valid = lines->text != NULL && length != 0 && lines->text[length - 1] == '\n';
    size_t count = 0;
    for (size_t i = 0; valid && i < length; i += 1)
    {
        const unsigned char byte = (unsigned char)lines->text[i];
        valid = byte == '\n' || (byte >= 32 && byte != 127);
        count += byte == '\n';
    }
    valid = valid && count > 0 && count <= maximum;
    lines->items = valid ? calloc(count, sizeof(*lines->items)) : NULL;
    valid = valid && lines->items != NULL;
    size_t start = 0;
    for (size_t i = 0; valid && i < length; i += 1)
    {
        if (lines->text[i] == '\n')
        {
            valid = i > start;
            lines->text[i] = 0;
            lines->items[lines->count++] = lines->text + start;
            start = i + 1;
        }
    }
    return valid;
}

static int compare_names(const void* first, const void* second)
{
    const char* const* a = first;
    const char* const* b = second;
    return strcmp(*a, *b);
}

static bool output_name(const char* name)
{
    const size_t length = strlen(name);
    bool valid = length > 2 && length < NAME_MAX && strcmp(name + length - 2, ".o") == 0 && strstr(name, "..") == NULL;
    valid = valid && (isalnum((unsigned char)name[0]) || name[0] == '_');
    for (size_t i = 0; valid && i < length; i += 1)
    {
        const unsigned char byte = (unsigned char)name[i];
        valid = isalnum(byte) || byte == '_' || byte == '.' || byte == '-';
    }
    return valid;
}

static void free_case(Case* input)
{
    free_lines(&input->arguments);
    free_lines(&input->outputs);
    free_lines(&input->hashes);
    free(input->source_paths);
    *input = (Case){ 0 };
}

static bool controlled_argument(const char* argument)
{
    const char* prefixes[] = { "--lanes", "--time-stages", "--worker-budget", "--sample", "--fake-compiler", "--self-test", "--id-order", "--poison-arenas", "--units-memory", "--shared-parts", "--dump-", "-o", "-M" };
    bool controlled = argument[0] == '@' || strcmp(argument, "-E") == 0 || strcmp(argument, "-S") == 0 || strcmp(argument, "-fsyntax-only") == 0;
    for (size_t i = 0; !controlled && i < sizeof(prefixes) / sizeof(prefixes[0]); i += 1)
    {
        controlled = strncmp(argument, prefixes[i], strlen(prefixes[i])) == 0;
    }
    return controlled;
}

static bool read_case(const char* directory, Case* input)
{
    char path[PATH_MAX];
    bool valid = path_join(path, sizeof(path), directory, "args.txt") && read_lines(path, BUSTER_MAX_ARGUMENTS, &input->arguments);
    valid = valid && path_join(path, sizeof(path), directory, "outputs.txt") && read_lines(path, BUSTER_MAX_OUTPUTS, &input->outputs);
    valid = valid && path_join(path, sizeof(path), directory, "sources.sha256") && read_lines(path, BUSTER_MAX_SOURCES, &input->hashes);
    size_t provenance_length = 0;
    char* provenance = valid && path_join(path, sizeof(path), directory, "provenance.txt") ? read_text(path, &provenance_length) : NULL;
    valid = valid && provenance != NULL && provenance_length > 0;
    free(provenance);
    input->source_paths = valid ? calloc(input->hashes.count, sizeof(*input->source_paths)) : NULL;
    valid = valid && input->source_paths != NULL;
    for (size_t i = 0; valid && i < input->hashes.count; i += 1)
    {
        const char* line = input->hashes.items[i];
        valid = strlen(line) > 67 && line[64] == ' ' && (line[65] == ' ' || line[65] == '*') && line[66] == '/';
        for (size_t c = 0; valid && c < 64; c += 1)
        {
            valid = isxdigit((unsigned char)line[c]) != 0;
        }
        struct stat status;
        const char* source = line + (valid ? 66 : 0);
        valid = valid && strchr(source, '\\') == NULL && stat(source, &status) == 0 && S_ISREG(status.st_mode);
        input->source_paths[i] = (char*)source;
    }
    if (valid)
    {
        qsort(input->source_paths, input->hashes.count, sizeof(*input->source_paths), compare_names);
    }
    for (size_t i = 1; valid && i < input->hashes.count; i += 1)
    {
        valid = strcmp(input->source_paths[i - 1], input->source_paths[i]) != 0;
    }
    char** sorted_outputs = valid ? calloc(input->outputs.count, sizeof(*sorted_outputs)) : NULL;
    bool* observed = valid ? calloc(input->outputs.count, sizeof(*observed)) : NULL;
    valid = valid && sorted_outputs != NULL && observed != NULL;
    for (size_t i = 0; valid && i < input->outputs.count; i += 1)
    {
        valid = output_name(input->outputs.items[i]);
        sorted_outputs[i] = input->outputs.items[i];
    }
    if (valid)
    {
        qsort(sorted_outputs, input->outputs.count, sizeof(*sorted_outputs), compare_names);
    }
    for (size_t i = 1; valid && i < input->outputs.count; i += 1)
    {
        valid = strcmp(sorted_outputs[i - 1], sorted_outputs[i]) != 0;
    }
    unsigned compile_only = 0;
    size_t sources = 0;
    for (size_t i = 0; valid && i < input->arguments.count; i += 1)
    {
        const char* argument = input->arguments.items[i];
        const size_t length = strlen(argument);
        valid = !controlled_argument(argument);
        compile_only += strcmp(argument, "-c") == 0;
        input->deferred = input->deferred || strcmp(argument, "--deferred-bodies") == 0;
        const bool file_operand = strcmp(argument, "--predefines") == 0 || strcmp(argument, "-include") == 0 || strcmp(argument, "-imacros") == 0;
        const char* file_option = file_operand ? (i + 1 < input->arguments.count ? input->arguments.items[i + 1] : "") :
                                  strncmp(argument, "--predefines=", 13) == 0 ? argument + 13 :
                                  strncmp(argument, "-include", 8) == 0 ? argument + 8 : strncmp(argument, "-imacros", 8) == 0 ? argument + 8 : NULL;
        if (valid && file_option != NULL)
        {
            valid = file_option[0] == '/' && bsearch(&file_option, input->source_paths, input->hashes.count, sizeof(*input->source_paths), compare_names) != NULL;
            i += file_operand;
        }
        if (valid && argument[0] == '/' && length > 2 && strcmp(argument + length - 2, ".c") == 0)
        {
            const char* base = strrchr(argument, '/') + 1;
            char name[NAME_MAX + 1];
            valid = copy_string(name, sizeof(name), base) && bsearch(&argument, input->source_paths, input->hashes.count, sizeof(*input->source_paths), compare_names) != NULL;
            if (valid)
            {
                name[strlen(name) - 1] = 'o';
                const char* wanted = name;
                char** found = bsearch(&wanted, sorted_outputs, input->outputs.count, sizeof(*sorted_outputs), compare_names);
                valid = found != NULL && !observed[(size_t)(found - sorted_outputs)];
                if (valid)
                {
                    observed[(size_t)(found - sorted_outputs)] = true;
                    sources += 1;
                }
            }
        }
        else if (valid && argument[0] != '-' && length > 2 && strcmp(argument + length - 2, ".c") == 0)
        {
            valid = false;
        }
    }
    valid = valid && compile_only == 1 && sources == input->outputs.count;
    free(observed);
    free(sorted_outputs);
    if (!valid)
    {
        fprintf(stderr, "multicore-149: malformed or inconsistent case manifests in %s\n", directory);
    }
    return valid;
}

static bool compiler_environment(void)
{
    const char* removed[] = { "MAKEFLAGS", "MFLAGS", "CPATH", "C_INCLUDE_PATH", "CPLUS_INCLUDE_PATH", "OBJC_INCLUDE_PATH", "LIBRARY_PATH", "COMPILER_PATH", "GCC_EXEC_PREFIX", "BUSTER_CLANG_RESOURCE_DIR" };
    bool valid = true;
    for (size_t i = 0; i < sizeof(removed) / sizeof(removed[0]); i += 1)
    {
        valid = unsetenv(removed[i]) == 0 && valid;
    }
    for (size_t i = 0; valid && environ[i] != NULL;)
    {
        if (strncmp(environ[i], "BUSTER_TEST_", 12) == 0)
        {
            const char* end = strchr(environ[i], '=');
            const size_t length = end != NULL ? (size_t)(end - environ[i]) : 0;
            char name[256];
            valid = length > 0 && length < sizeof(name);
            if (valid)
            {
                memcpy(name, environ[i], length);
                name[length] = 0;
                valid = unsetenv(name) == 0;
            }
        }
        else
        {
            i += 1;
        }
    }
    valid = setenv("LC_ALL", "C", 1) == 0 && valid;
    valid = setenv("LANG", "C", 1) == 0 && valid;
    valid = setenv("TZ", "UTC", 1) == 0 && valid;
    valid = setenv("SOURCE_DATE_EPOCH", "0", 1) == 0 && valid;
    return valid;
}

// Blocking wait4 preserves the measurement boundary. An alarm first terminates the child's process group, then
// escalates after two seconds. A helper receiving TERM while its wrapper is stopped also terminates its compiler.
static Process run_process(char* const* arguments, const char* directory, int output, int errors, unsigned seconds, const cpu_set_t* affinity, bool compile)
{
    Process result = {
        .status = -1,
    };
    fflush(NULL);
    process_signal = 0;
    process_grace = compile ? 2 : 5;
    const pid_t parent = getpid();
    const uint64_t begin = now_ns();
    const pid_t child = fork();
    if (child == 0)
    {
        alarm(0);
        signal(SIGALRM, SIG_DFL);
        signal(SIGINT, SIG_DFL);
        signal(SIGTERM, SIG_DFL);
        signal(SIGHUP, SIG_DFL);
        const struct rlimit cores = { 0 };
        bool ready = setpgid(0, 0) == 0 && setrlimit(RLIMIT_CORE, &cores) == 0;
        ready = ready && (!compile || (prctl(PR_SET_PDEATHSIG, SIGKILL) == 0 && getppid() == parent));
        ready = ready && (directory == NULL || chdir(directory) == 0);
        ready = ready && (affinity == NULL || sched_setaffinity(0, sizeof(*affinity), affinity) == 0);
        ready = ready && (output < 0 || dup2(output, STDOUT_FILENO) >= 0) && (errors < 0 || dup2(errors, STDERR_FILENO) >= 0);
        ready = ready && (!compile || compiler_environment());
        if (ready && compile && affinity != NULL)
        {
            cpu_set_t observed;
            const int cpu = sched_getcpu();
            ready = sched_getaffinity(0, sizeof(observed), &observed) == 0 && CPU_EQUAL(affinity, &observed) && cpu >= 0 && CPU_ISSET(cpu, &observed);
            FILE* placement = ready ? fopen("placement.txt", "w") : NULL;
            ready = ready && placement != NULL;
            if (placement != NULL)
            {
                fprintf(placement, "scope=initial-thread-before-exec\nindividual-worker-pinning=no\ncurrent-cpu=%d\naffinity=", cpu);
                bool first = true;
                for (unsigned c = 0; c < CPU_SETSIZE; c += 1)
                {
                    if (CPU_ISSET(c, &observed))
                    {
                        fprintf(placement, "%s%u", first ? "" : ",", c);
                        first = false;
                    }
                }
                fputc('\n', placement);
                ready = !ferror(placement) && ready;
                ready = fclose(placement) == 0 && ready;
            }
        }
        if (ready)
        {
            execvp(arguments[0], arguments);
        }
        _exit(127);
    }
    process_group = child > 0 ? (sig_atomic_t)child : 0;
    if (child > 0)
    {
        // The child's setpgid is authoritative; EACCES/ESRCH here just mean it already execed/exited.
        (void)setpgid(child, child);
        alarm(seconds);
    }
    struct rusage usage = { 0 };
    int status = 0;
    pid_t waited = -1;
    do
    {
        waited = child > 0 ? wait4(child, &status, 0, &usage) : -1;
    } while (child > 0 && waited < 0 && errno == EINTR);
    const uint64_t end = now_ns();
    alarm(0);
    result.interrupted = process_signal != 0;
    if (child > 0)
    {
        // Reap only our child, but do not leave a timed-out command's descendants alive.
        kill(-child, SIGKILL);
    }
    process_group = 0;
    if (child > 0 && waited == child && begin != 0 && end >= begin)
    {
        result.wall_ns = end - begin;
        result.user_us = (uint64_t)usage.ru_utime.tv_sec * UINT64_C(1000000) + (uint64_t)usage.ru_utime.tv_usec;
        result.system_us = (uint64_t)usage.ru_stime.tv_sec * UINT64_C(1000000) + (uint64_t)usage.ru_stime.tv_usec;
        result.peak_kb = (uint64_t)usage.ru_maxrss;
        result.minor_faults = (uint64_t)usage.ru_minflt;
        result.major_faults = (uint64_t)usage.ru_majflt;
        result.voluntary_switches = (uint64_t)usage.ru_nvcsw;
        result.involuntary_switches = (uint64_t)usage.ru_nivcsw;
        result.status = status;
    }
    return result;
}

static bool successful(Process result)
{
    return result.status != -1 && WIFEXITED(result.status) && WEXITSTATUS(result.status) == 0 && !result.interrupted;
}

static bool capture(char* const* arguments, char* result, size_t capacity)
{
    FILE* file = tmpfile();
    Process ran = {
        .status = -1,
    };
    if (file != NULL)
    {
        ran = run_process(arguments, NULL, fileno(file), fileno(file), 30, NULL, false);
    }
    bool valid = successful(ran) && fseek(file, 0, SEEK_SET) == 0;
    const size_t got = valid ? fread(result, 1, capacity - 1, file) : 0;
    valid = valid && !ferror(file) && fgetc(file) == EOF;
    if (valid)
    {
        result[got] = 0;
    }
    else
    {
        fprintf(stderr, "multicore-149: metadata command failed: %s\n", arguments[0]);
    }
    if (file != NULL)
    {
        valid = fclose(file) == 0 && valid;
    }
    return valid;
}

static const char* const case_files[] = { "args.txt", "outputs.txt", "sources.sha256", "provenance.txt" };

static bool identity(const Configuration* configuration, const char* destination)
{
    char status[32768];
    char revision[128];
    char top[PATH_MAX + 1];
    char* clean[] = { "git", "-C", (char*)configuration->source, "status", "--porcelain=v1", "--untracked-files=normal", NULL };
    char* head[] = { "git", "-C", (char*)configuration->source, "rev-parse", "HEAD", NULL };
    char* root[] = { "git", "-C", (char*)configuration->source, "rev-parse", "--show-toplevel", NULL };
    bool valid = capture(clean, status, sizeof(status)) && status[0] == 0 && capture(head, revision, sizeof(revision)) &&
                 capture(root, top, sizeof(top));
    if (valid)
    {
        top[strcspn(top, "\r\n")] = 0;
        valid = strcmp(top, configuration->source) == 0 && strlen(revision) == 41 && revision[40] == '\n';
        for (unsigned i = 0; valid && i < 40; i += 1)
        {
            valid = isxdigit((unsigned char)revision[i]) != 0;
        }
    }
    char lane[PATH_MAX];
    char manifests[4][PATH_MAX];
    valid = valid && path_join(lane, sizeof(lane), configuration->source, "src/buster/compiler/lane.c");
    for (size_t i = 0; valid && i < 4; i += 1)
    {
        valid = path_join(manifests[i], sizeof(manifests[i]), configuration->case_directory, case_files[i]);
    }
    char* hashes[] = { "sha256sum", "--", (char*)configuration->compiler, lane, manifests[0], manifests[1], manifests[2], manifests[3],
                       (char*)configuration->executable, (char*)configuration->lock, NULL };
    char digest[65536];
    valid = valid && capture(hashes, digest, sizeof(digest));
    FILE* file = valid ? fopen(destination, "w") : NULL;
    valid = valid && file != NULL;
    if (file != NULL)
    {
        fprintf(file, "compiler-source=%s\ncompiler-revision=%scompiler-source-state=clean\nsha256sum:\n%s", configuration->source, revision, digest);
        valid = !ferror(file) && valid;
        valid = fclose(file) == 0 && valid;
    }
    if (!valid)
    {
        fprintf(stderr, "multicore-149: cannot establish clean, unchanged compiler/input identity\n");
    }
    return valid;
}

static bool check_source_hashes(const Configuration* configuration)
{
    char manifest[PATH_MAX];
    char output[8192];
    bool valid = path_join(manifest, sizeof(manifest), configuration->case_directory, "sources.sha256");
    char* arguments[] = { "sha256sum", "--check", "--strict", "--status", manifest, NULL };
    valid = valid && capture(arguments, output, sizeof(output));
    return valid;
}

static bool small_text(const char* path, char* destination, size_t capacity)
{
    size_t length = 0;
    char* text = read_text(path, &length);
    while (text != NULL && length > 0 && (text[length - 1] == '\n' || text[length - 1] == '\r'))
    {
        text[--length] = 0;
    }
    const bool valid = text != NULL && plain_text(text) && copy_string(destination, capacity, text);
    free(text);
    return valid;
}

static bool cpu_text(unsigned cpu, const char* leaf, char* destination, size_t capacity)
{
    char path[PATH_MAX];
    const int length = snprintf(path, sizeof(path), "/sys/devices/system/cpu/cpu%u/%s", cpu, leaf);
    return length > 0 && (size_t)length < sizeof(path) && small_text(path, destination, capacity);
}

static bool cpu_field(const char* contents, const char* field, char* destination, size_t capacity)
{
    const char* at = strstr(contents, field);
    const char* colon = at != NULL ? strchr(at, ':') : NULL;
    const char* value = colon != NULL ? colon + 1 : NULL;
    while (value != NULL && (*value == ' ' || *value == '\t'))
    {
        value += 1;
    }
    const size_t length = value != NULL ? strcspn(value, "\r\n") : 0;
    const bool valid = length > 0 && length < capacity;
    if (valid)
    {
        memcpy(destination, value, length);
        destination[length] = 0;
    }
    return valid;
}

static bool environment_receipt(const char* path)
{
    const char* preload = getenv("LD_PRELOAD");
    const char* libraries = getenv("LD_LIBRARY_PATH");
    const char* huge = getenv("BUSTER_HUGE_PAGES");
    bool valid = (preload == NULL || *preload == 0) && (libraries == NULL || *libraries == 0) &&
                 (huge == NULL || strcmp(huge, "0") == 0 || strcmp(huge, "1") == 0);
    FILE* file = valid ? fopen(path, "w") : NULL;
    valid = valid && file != NULL;
    if (file != NULL)
    {
        fprintf(file, "compiler-environment:\nLC_ALL=C\nLANG=C\nTZ=UTC\nSOURCE_DATE_EPOCH=0\n");
        fprintf(file, "cleared=MAKEFLAGS,MFLAGS,CPATH,C_INCLUDE_PATH,CPLUS_INCLUDE_PATH,OBJC_INCLUDE_PATH,LIBRARY_PATH,COMPILER_PATH,GCC_EXEC_PREFIX,BUSTER_CLANG_RESOURCE_DIR,BUSTER_TEST_*\n");
        fprintf(file, "LD_PRELOAD=absent\nLD_LIBRARY_PATH=absent\n");
        const char* names[] = { "BUSTER_HUGE_PAGES", "CORES", "PATH" };
        for (size_t i = 0; valid && i < sizeof(names) / sizeof(names[0]); i += 1)
        {
            const char* value = getenv(names[i]);
            valid = value == NULL || *value == 0 || plain_text(value);
            fprintf(file, "%s=%s\n", names[i], value != NULL && *value != 0 ? value : "unset");
        }
        valid = !ferror(file) && valid;
        valid = fclose(file) == 0 && valid;
    }
    if (!valid)
    {
        fprintf(stderr, "multicore-149: refuse loader overrides, invalid huge-page policy, or an unrecordable environment\n");
    }
    return valid;
}

// The receipt distinguishes initial process affinity from individual worker pinning. Frequencies and temperatures
// are observations, not claims of a constant frequency. The policy file excludes those deliberately varying values.
static bool host_receipt(const char* directory, const char* suffix)
{
    char report_name[64];
    char policy_name[64];
    snprintf(report_name, sizeof(report_name), "host.%s.txt", suffix);
    snprintf(policy_name, sizeof(policy_name), "host-policy.%s.txt", suffix);
    char report_path[PATH_MAX];
    char policy_path[PATH_MAX];
    bool valid = path_join(report_path, sizeof(report_path), directory, report_name) && path_join(policy_path, sizeof(policy_path), directory, policy_name);
    size_t length = 0;
    char* cpuinfo = valid ? read_text("/proc/cpuinfo", &length) : NULL;
    char model[256];
    char flags[4096];
    char hostname[256];
    valid = valid && cpuinfo != NULL && cpu_field(cpuinfo, "model name", model, sizeof(model)) &&
            cpu_field(cpuinfo, "flags", flags, sizeof(flags)) && small_text("/proc/sys/kernel/hostname", hostname, sizeof(hostname));
    valid = valid && strncmp(model, "AMD Ryzen 7 9700X ", 18) == 0;
    cpu_set_t affinity;
    valid = valid && sched_getaffinity(0, sizeof(affinity), &affinity) == 0;
    for (unsigned cpu = 0; valid && cpu < BUSTER_LANES; cpu += 1)
    {
        valid = CPU_ISSET(cpu, &affinity);
    }
    FILE* report = valid ? fopen(report_path, "w") : NULL;
    FILE* policy = valid ? fopen(policy_path, "w") : NULL;
    valid = valid && report != NULL && policy != NULL;
    unsigned packages[BUSTER_LANES] = { 0 };
    unsigned cores[BUSTER_LANES] = { 0 };
    if (valid)
    {
        fprintf(report, "hostname=%s\nmodel=%s\nflags=%s\nhelper-current-cpu=%d\n", hostname, model, flags, sched_getcpu());
        fprintf(policy, "hostname=%s\nmodel=%s\nflags=%s\n", hostname, model, flags);
        fprintf(report, "primary-compiler-affinity=0,1,2,3,4,5,6,7\nworker-affinity=inherited-mask; workers may migrate\n");
        fprintf(report, "wait-policy=source-pinned lane.c; gates/serial-stage parks/helper-board use immediate futex; barriers use 128 PAUSE, up to 1000000ns MWAITX (PAUSE without __MWAITX__), then futex\n");
        fprintf(report, "wait-duration-measurement=unavailable; source policy is not an observed waiting-time distribution\n");
    }
    for (unsigned cpu = 0; valid && cpu < BUSTER_LANES; cpu += 1)
    {
        char package[64];
        char core[64];
        char siblings[128];
        char governor[128];
        char frequency[128];
        valid = cpu_text(cpu, "topology/physical_package_id", package, sizeof(package)) && number(package, UINT_MAX, &packages[cpu]) &&
                cpu_text(cpu, "topology/core_id", core, sizeof(core)) && number(core, UINT_MAX, &cores[cpu]) &&
                cpu_text(cpu, "topology/thread_siblings_list", siblings, sizeof(siblings)) &&
                cpu_text(cpu, "cpufreq/scaling_governor", governor, sizeof(governor));
        for (unsigned prior = 0; valid && prior < cpu; prior += 1)
        {
            valid = packages[prior] != packages[cpu] || cores[prior] != cores[cpu];
        }
        if (valid)
        {
            fprintf(policy, "cpu=%u package=%u core=%u siblings=%s governor=%s\n", cpu, packages[cpu], cores[cpu], siblings, governor);
            const bool read = cpu_text(cpu, "cpufreq/scaling_cur_freq", frequency, sizeof(frequency));
            fprintf(report, "cpu=%u package=%u core=%u siblings=%s governor=%s frequency-khz=%s\n", cpu, packages[cpu], cores[cpu], siblings, governor, read ? frequency : "unavailable");
            const char* fields[] = { "cpufreq/energy_performance_preference", "cpufreq/scaling_min_freq", "cpufreq/scaling_max_freq", "cpufreq/scaling_driver" };
            for (size_t f = 0; f < sizeof(fields) / sizeof(fields[0]); f += 1)
            {
                const bool present = cpu_text(cpu, fields[f], frequency, sizeof(frequency));
                fprintf(policy, "cpu=%u %s=%s\n", cpu, fields[f], present ? frequency : "unavailable");
                fprintf(report, "cpu=%u %s=%s\n", cpu, fields[f], present ? frequency : "unavailable");
            }
        }
    }
    const char* optional[] = { "/sys/devices/system/cpu/cpufreq/boost", "/sys/devices/system/cpu/amd_pstate/status", "/sys/kernel/mm/transparent_hugepage/enabled" };
    for (size_t i = 0; valid && i < sizeof(optional) / sizeof(optional[0]); i += 1)
    {
        char value[512];
        const bool read = small_text(optional[i], value, sizeof(value));
        fprintf(policy, "%s=%s\n", optional[i], read ? value : "unavailable");
        fprintf(report, "%s=%s\n", optional[i], read ? value : "unavailable");
    }
    DIR* monitors = valid ? opendir("/sys/class/hwmon") : NULL;
    struct dirent* entry;
    unsigned temperatures = 0;
    while (monitors != NULL && (entry = readdir(monitors)) != NULL)
    {
        if (strncmp(entry->d_name, "hwmon", 5) == 0)
        {
            for (unsigned sensor = 1; sensor <= 4; sensor += 1)
            {
                char path[PATH_MAX];
                char value[128];
                snprintf(path, sizeof(path), "/sys/class/hwmon/%s/temp%u_input", entry->d_name, sensor);
                if (small_text(path, value, sizeof(value)))
                {
                    fprintf(report, "%s=%s millidegrees-C\n", path, value);
                    temperatures += 1;
                }
            }
        }
    }
    if (monitors != NULL)
    {
        valid = closedir(monitors) == 0 && valid;
    }
    if (report != NULL)
    {
        fprintf(report, "temperature-readings=%u\n", temperatures);
        valid = !ferror(report) && valid;
        valid = fclose(report) == 0 && valid;
    }
    if (policy != NULL)
    {
        valid = !ferror(policy) && valid;
        valid = fclose(policy) == 0 && valid;
    }
    free(cpuinfo);
    if (!valid)
    {
        fprintf(stderr, "multicore-149: require Ryzen 7 9700X, available CPUs 0..7 on eight distinct cores, and readable governors\n");
    }
    return valid;
}

static bool held_lock(void)
{
    const char* held = getenv("BUSTER_9700X_HELD");
    struct stat descriptor;
    struct stat named;
    const bool valid = held != NULL && strcmp(held, "1") == 0 && fstat(9, &descriptor) == 0 && stat(BUSTER_LOCK_PATH, &named) == 0 &&
                       S_ISREG(named.st_mode) && descriptor.st_dev == named.st_dev && descriptor.st_ino == named.st_ino && flock(9, LOCK_EX | LOCK_NB) == 0;
    if (!valid)
    {
        fprintf(stderr, "multicore-149: --sample requires exclusive.sh's BUSTER_9700X_HELD=1 and inherited locked fd 9 for %s\n", BUSTER_LOCK_PATH);
    }
    return valid;
}

static const char* const stage_names[] = {
    "setup", "lanes-start", "preprocess", "parse", "type-table", "check-input", "check-expressions", "check-declarations",
    "static-data", "check-program", "select", "backend-setup", "lower", "tier0", "emit-setup", "lanes", "branch-sizing",
    "encode", "unwind", "code-atoms", "debug", "publish-data", "object-build", "object-write", "runtime", "executable", "write", "release",
};

#define BUSTER_STAGES (sizeof(stage_names) / sizeof(stage_names[0]))

static bool stage_serial(size_t stage, bool multiple, bool deferred)
{
    const char* name = stage_names[stage];
    const char* const serial[] = { "setup", "preprocess", "parse", "type-table", "check-input", "check-expressions", "check-declarations", "static-data",
                                  "check-program", "select", "backend-setup", "emit-setup", "publish-data", "object-build", "object-write", "release" };
    bool selected = strcmp(name, "setup") == 0 || strcmp(name, "release") == 0;
    for (size_t i = 0; !multiple && i < sizeof(serial) / sizeof(serial[0]); i += 1)
    {
        selected = selected || strcmp(name, serial[i]) == 0;
    }
    selected = selected && !(deferred && strcmp(name, "check-input") == 0);
    return selected;
}

static const char stage_header[] = "lanes\tpaired_wall_ms\tstage_total_ms\tserial_lower_bound_ms\tserial_elapsed_share_lower_bound\tamdahl_8_upper_from_one_lane\tamdahl_infinite_upper_from_one_lane\tlanes_start_ms\n";

static bool read_stage_receipt(const Configuration* configuration, const Case* input, const char* path, Process process)
{
    FILE* file = fopen(path, "r");
    bool valid = file != NULL;
    unsigned asked_count = 0;
    unsigned actual_count = 0;
    unsigned asked = 0;
    unsigned actual = 0;
    unsigned seen[BUSTER_STAGES + 2] = { 0 };
    double values[BUSTER_STAGES + 2] = { 0 };
    char* line = NULL;
    size_t capacity = 0;
    ssize_t length;
    while (valid && (length = getline(&line, &capacity, file)) >= 0)
    {
        valid = length < (1 << 20) && memchr(line, 0, (size_t)length) == NULL;
        if (valid)
        {
            line[strcspn(line, "\r\n")] = 0;
            const char* asked_prefix = "time-process\tlanes-asked\t";
            const char* actual_prefix = "time-process\tlanes\t";
            if (strncmp(line, asked_prefix, strlen(asked_prefix)) == 0)
            {
                asked_count += 1;
                valid = number(line + strlen(asked_prefix), 4096, &asked);
            }
            else if (strncmp(line, actual_prefix, strlen(actual_prefix)) == 0)
            {
                actual_count += 1;
                valid = number(line + strlen(actual_prefix), 4096, &actual);
            }
            else if (strncmp(line, "time-stage\t", 11) == 0)
            {
                char* name = line + 11;
                char* value = strchr(name, '\t');
                valid = value != NULL;
                if (valid)
                {
                    *value++ = 0;
                    size_t slot = BUSTER_STAGES + 2;
                    for (size_t s = 0; s < BUSTER_STAGES; s += 1)
                    {
                        slot = strcmp(name, stage_names[s]) == 0 ? s : slot;
                    }
                    slot = strcmp(name, "total") == 0 ? BUSTER_STAGES : slot;
                    slot = strcmp(name, "lower.prepare") == 0 ? BUSTER_STAGES + 1 : slot;
                    if (slot < BUSTER_STAGES + 2)
                    {
                        char* end = NULL;
                        errno = 0;
                        const double elapsed = strtod(value, &end);
                        valid = errno == 0 && end != value && (*end == '\t' || *end == 0) && isfinite(elapsed) && elapsed >= 0;
                        seen[slot] += 1;
                        values[slot] = elapsed;
                    }
                }
            }
        }
    }
    free(line);
    if (file != NULL)
    {
        valid = !ferror(file) && valid;
        valid = fclose(file) == 0 && valid;
    }
    valid = valid && asked_count == 1 && actual_count == 1 && asked == configuration->lanes && actual == configuration->lanes;
    double sum = 0;
    double serial = input->outputs.count == 1 ? values[BUSTER_STAGES + 1] : 0;
    for (size_t s = 0; s < BUSTER_STAGES + 2; s += 1)
    {
        valid = valid && seen[s] == 1;
        if (s < BUSTER_STAGES)
        {
            sum += values[s];
            serial += stage_serial(s, input->outputs.count > 1, input->deferred) ? values[s] : 0;
        }
    }
    const double total = values[BUSTER_STAGES];
    const double difference = sum > total ? sum - total : total - sum;
    const double wall = (double)process.wall_ns / 1e6;
    valid = valid && total > 0 && difference <= 0.002 * BUSTER_STAGES && total <= wall + 0.1 && serial <= total + 0.002 * BUSTER_STAGES;
    char destination[PATH_MAX];
    valid = valid && path_join(destination, sizeof(destination), configuration->output, "stages.tsv");
    FILE* report = valid ? fopen(destination, "w") : NULL;
    valid = valid && report != NULL;
    if (report != NULL)
    {
        fputs(stage_header, report);
        const double share = wall > 0 ? serial / wall : 0;
        fprintf(report, "%u\t%.6f\t%.6f\t%.6f\t%.9f\t", configuration->lanes, wall, total, serial, share);
        if (configuration->lanes == 1 && !configuration->cpu2 && share > 0)
        {
            fprintf(report, "%.6f\t%.6f\t", 1.0 / (share + (1.0 - share) / BUSTER_LANES), 1.0 / share);
        }
        else
        {
            fputs("NA\tNA\t", report);
        }
        fprintf(report, "%.6f\n", values[1]);
        valid = !ferror(report) && valid;
        valid = fclose(report) == 0 && valid;
    }
    if (!valid)
    {
        fprintf(stderr, "multicore-149: missing, duplicate, invalid or wrong-team stage receipt for requested lanes=%u\n", configuration->lanes);
    }
    return valid;
}

static bool output_hashes(const Configuration* configuration, const Case* input)
{
    char path[PATH_MAX];
    char errors[PATH_MAX];
    bool valid = path_join(path, sizeof(path), configuration->output, "objects.sha256") && path_join(errors, sizeof(errors), configuration->output, "hash.stderr");
    char** arguments = valid ? calloc(input->outputs.count + 3, sizeof(*arguments)) : NULL;
    valid = valid && arguments != NULL;
    if (valid)
    {
        arguments[0] = "sha256sum";
        arguments[1] = "--";
        for (size_t i = 0; i < input->outputs.count; i += 1)
        {
            arguments[i + 2] = input->outputs.items[i];
        }
    }
    const int out = valid ? open(path, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0600) : -1;
    const int err = valid ? open(errors, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0600) : -1;
    valid = valid && out >= 0 && err >= 0;
    if (valid)
    {
        valid = successful(run_process(arguments, configuration->output, out, err, 30, NULL, false));
    }
    if (out >= 0)
    {
        valid = close(out) == 0 && valid;
    }
    if (err >= 0)
    {
        valid = close(err) == 0 && valid;
    }
    free(arguments);
    return valid;
}

static const char sample_header[] = "lanes\tinstrumented\tcpu_mask\twall_ns\tuser_us\tsystem_us\twait4_peak_kb\tminor_faults\tmajor_faults\tvoluntary_switches\tinvoluntary_switches\twait_status\tinterrupted\tobjects\tverified\n";

static bool sample_record(const Configuration* configuration, const Case* input, Process process, bool verified)
{
    char path[PATH_MAX];
    bool valid = path_join(path, sizeof(path), configuration->output, "sample.tsv");
    FILE* file = valid ? fopen(path, "w") : NULL;
    valid = valid && file != NULL;
    if (file != NULL)
    {
        fputs(sample_header, file);
        fprintf(file, "%u\t%u\t%u\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%d\t%u\t%zu\t%u\n",
                configuration->lanes, configuration->instrumented, configuration->cpu2 ? 4u : 255u, process.wall_ns, process.user_us, process.system_us, process.peak_kb,
                process.minor_faults, process.major_faults, process.voluntary_switches, process.involuntary_switches, process.status, process.interrupted, input->outputs.count, verified);
        valid = !ferror(file) && valid;
        valid = fclose(file) == 0 && valid;
    }
    return valid;
}

// The caller owns the new sample directory. Tests also call this with a deliberately stale object to prove that
// removal happens before execution. Only the production helper performs the real host/lock/identity checks.
static bool sample(const Configuration* configuration, const Case* input, Process* observed)
{
    const bool testing = configuration->fake_mode != NULL;
    char before[PATH_MAX];
    char after[PATH_MAX];
    char environment[PATH_MAX];
    bool valid = path_join(before, sizeof(before), configuration->output, "identity.before.txt") &&
                 path_join(after, sizeof(after), configuration->output, "identity.after.txt") &&
                 path_join(environment, sizeof(environment), configuration->output, "environment.txt");
    if (!testing)
    {
        valid = valid && identity(configuration, before) && same_file(before, configuration->expected_identity) && check_source_hashes(configuration) &&
                host_receipt(configuration->output, "before") && environment_receipt(environment);
        char policy_directory[PATH_MAX];
        char expected_policy[PATH_MAX];
        char actual_policy[PATH_MAX];
        char expected_environment[PATH_MAX];
        valid = valid && copy_string(policy_directory, sizeof(policy_directory), configuration->expected_identity);
        char* slash = valid ? strrchr(policy_directory, '/') : NULL;
        valid = valid && slash != NULL && slash != policy_directory;
        if (valid)
        {
            *slash = 0;
            valid = path_join(expected_policy, sizeof(expected_policy), policy_directory, "host-policy.before.txt") &&
                    path_join(actual_policy, sizeof(actual_policy), configuration->output, "host-policy.before.txt") && same_file(expected_policy, actual_policy) &&
                    path_join(expected_environment, sizeof(expected_environment), policy_directory, "environment.txt") && same_file(expected_environment, environment);
        }
    }
    char lane_text[16];
    snprintf(lane_text, sizeof(lane_text), "%u", configuration->lanes);
    char** arguments = valid ? calloc(input->arguments.count + 10, sizeof(*arguments)) : NULL;
    valid = valid && arguments != NULL;
    size_t used = 0;
    if (valid)
    {
        arguments[used++] = (char*)configuration->compiler;
        if (testing)
        {
            arguments[used++] = "--fake-compiler";
            arguments[used++] = (char*)configuration->fake_mode;
        }
        arguments[used++] = "--lanes";
        arguments[used++] = lane_text;
        arguments[used++] = "--worker-budget=8";
        if (configuration->instrumented)
        {
            arguments[used++] = "--time-stages";
        }
        for (size_t i = 0; i < input->arguments.count; i += 1)
        {
            arguments[used++] = input->arguments.items[i];
        }
    }
    char command[PATH_MAX];
    valid = valid && path_join(command, sizeof(command), configuration->output, "argv.txt");
    FILE* argv_file = valid ? fopen(command, "w") : NULL;
    valid = valid && argv_file != NULL;
    if (argv_file != NULL)
    {
        for (size_t i = 0; i < used; i += 1)
        {
            fprintf(argv_file, "%s\n", arguments[i]);
        }
        valid = !ferror(argv_file) && valid;
        valid = fclose(argv_file) == 0 && valid;
    }
    for (size_t i = 0; valid && i < input->outputs.count; i += 1)
    {
        char path[PATH_MAX];
        valid = path_join(path, sizeof(path), configuration->output, input->outputs.items[i]);
        if (valid)
        {
            valid = unlink(path) == 0 || errno == ENOENT;
        }
    }
    char output_path[PATH_MAX];
    char error_path[PATH_MAX];
    valid = valid && path_join(output_path, sizeof(output_path), configuration->output, "stdout.txt") && path_join(error_path, sizeof(error_path), configuration->output, "stderr.txt");
    const int output = valid ? open(output_path, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0600) : -1;
    const int errors = valid ? open(error_path, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0600) : -1;
    valid = valid && output >= 0 && errors >= 0;
    cpu_set_t mask;
    CPU_ZERO(&mask);
    if (testing)
    {
        valid = valid && sched_getaffinity(0, sizeof(mask), &mask) == 0;
    }
    else
    {
        for (unsigned cpu = 0; cpu < BUSTER_LANES; cpu += 1)
        {
            if (!configuration->cpu2 || cpu == 2)
            {
                CPU_SET(cpu, &mask);
            }
        }
    }
    Process process = {
        .status = -1,
    };
    if (valid)
    {
        process = run_process(arguments, configuration->output, output, errors, configuration->timeout, &mask, true);
        valid = successful(process);
        if (!valid)
        {
            fprintf(stderr, "multicore-149: compiler failed: raw wait status=%d interrupted=%u\n", process.status, process.interrupted);
        }
    }
    if (output >= 0)
    {
        valid = close(output) == 0 && valid;
    }
    if (errors >= 0)
    {
        valid = close(errors) == 0 && valid;
    }
    free(arguments);
    for (size_t i = 0; valid && i < input->outputs.count; i += 1)
    {
        char path[PATH_MAX];
        char reference[PATH_MAX];
        struct stat status;
        valid = path_join(path, sizeof(path), configuration->output, input->outputs.items[i]) && lstat(path, &status) == 0 && S_ISREG(status.st_mode) && status.st_size > 0;
        if (valid && configuration->reference[0] != 0)
        {
            valid = path_join(reference, sizeof(reference), configuration->reference, input->outputs.items[i]) && same_file(reference, path);
        }
        if (!valid)
        {
            fprintf(stderr, "multicore-149: missing, empty, nonregular or byte-different output: %s\n", input->outputs.items[i]);
        }
    }
    valid = valid && (!configuration->instrumented || read_stage_receipt(configuration, input, error_path, process));
    if (valid && !testing)
    {
        char first_policy[PATH_MAX];
        char last_policy[PATH_MAX];
        char last_environment[PATH_MAX];
        valid = identity(configuration, after) && same_file(before, after) && check_source_hashes(configuration) && host_receipt(configuration->output, "after") &&
                path_join(first_policy, sizeof(first_policy), configuration->output, "host-policy.before.txt") &&
                path_join(last_policy, sizeof(last_policy), configuration->output, "host-policy.after.txt") && same_file(first_policy, last_policy) &&
                path_join(last_environment, sizeof(last_environment), configuration->output, "environment.after.txt") &&
                environment_receipt(last_environment) && same_file(environment, last_environment);
        valid = valid && output_hashes(configuration, input);
    }
    *observed = process;
    valid = sample_record(configuration, input, process, valid) && valid;
    if (valid && !testing && configuration->reference[0] != 0)
    {
        // Keep the reference and every hash receipt; verified candidate objects need not multiply the artifact size.
        for (size_t i = 0; valid && i < input->outputs.count; i += 1)
        {
            char path[PATH_MAX];
            valid = path_join(path, sizeof(path), configuration->output, input->outputs.items[i]) && unlink(path) == 0;
        }
    }
    return valid;
}

static bool read_sample(const Configuration* configuration, size_t objects, Process* result)
{
    char path[PATH_MAX];
    bool valid = path_join(path, sizeof(path), configuration->output, "sample.tsv");
    FILE* file = valid ? fopen(path, "r") : NULL;
    char header[sizeof(sample_header) + 1];
    char row[2048];
    valid = file != NULL && fgets(header, sizeof(header), file) != NULL && strcmp(header, sample_header) == 0 && fgets(row, sizeof(row), file) != NULL;
    unsigned lanes = 0;
    unsigned instrumented = 0;
    unsigned mask = 0;
    unsigned interrupted = 0;
    unsigned verified = 0;
    size_t count = 0;
    int consumed = 0;
    const int fields = valid ? sscanf(row, "%u\t%u\t%u\t%" SCNu64 "\t%" SCNu64 "\t%" SCNu64 "\t%" SCNu64 "\t%" SCNu64 "\t%" SCNu64 "\t%" SCNu64 "\t%" SCNu64 "\t%d\t%u\t%zu\t%u%n",
                                     &lanes, &instrumented, &mask, &result->wall_ns, &result->user_us, &result->system_us, &result->peak_kb, &result->minor_faults,
                                     &result->major_faults, &result->voluntary_switches, &result->involuntary_switches, &result->status, &interrupted, &count, &verified, &consumed) : 0;
    result->interrupted = interrupted != 0;
    valid = valid && fields == 15 && row[consumed] == '\n' && row[consumed + 1] == 0 && fgetc(file) == EOF && !ferror(file);
    valid = valid && lanes == configuration->lanes && instrumented == (unsigned)configuration->instrumented && mask == (configuration->cpu2 ? 4u : 255u) &&
            count == objects && verified == 1 && result->wall_ns > 0 && successful(*result);
    if (file != NULL)
    {
        valid = fclose(file) == 0 && valid;
    }
    return valid;
}

static bool locked_sample(const Configuration* campaign, const Case* input, const char* name, unsigned lanes, bool instrumented, bool cpu2, Process* result)
{
    *result = (Process){ .status = -1 };
    Configuration one = *campaign;
    one.lanes = lanes;
    one.instrumented = instrumented;
    one.cpu2 = cpu2;
    char output_name[128];
    char error_name[128];
    snprintf(output_name, sizeof(output_name), "%s.lock.stdout", name);
    snprintf(error_name, sizeof(error_name), "%s.lock.stderr", name);
    char output_path[PATH_MAX] = { 0 };
    char error_path[PATH_MAX] = { 0 };
    bool valid = path_join(one.output, sizeof(one.output), campaign->output, name) && path_join(output_path, sizeof(output_path), campaign->output, output_name) &&
                 path_join(error_path, sizeof(error_path), campaign->output, error_name);
    char lane_text[16];
    snprintf(lane_text, sizeof(lane_text), "%u", lanes);
    char* arguments[32];
    size_t used = 0;
    arguments[used++] = one.lock;
    arguments[used++] = one.executable;
    arguments[used++] = "--sample";
    arguments[used++] = "--case";
    arguments[used++] = one.case_directory;
    arguments[used++] = "--output";
    arguments[used++] = one.output;
    arguments[used++] = "--compiler";
    arguments[used++] = one.compiler;
    arguments[used++] = "--compiler-source";
    arguments[used++] = one.source;
    arguments[used++] = "--lock";
    arguments[used++] = one.lock;
    arguments[used++] = "--lanes";
    arguments[used++] = lane_text;
    arguments[used++] = "--identity";
    arguments[used++] = one.expected_identity;
    if (one.reference[0] != 0)
    {
        arguments[used++] = "--reference";
        arguments[used++] = one.reference;
    }
    if (instrumented)
    {
        arguments[used++] = "--instrumented";
    }
    if (cpu2)
    {
        arguments[used++] = "--cpu2";
    }
    arguments[used] = NULL;
    const int output = valid ? open(output_path, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0600) : -1;
    const int errors = valid ? open(error_path, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0600) : -1;
    valid = valid && output >= 0 && errors >= 0;
    if (valid)
    {
        fprintf(stdout, "multicore-149: %s, lanes=%u, mask=%s, instrumented=%u\n", name, lanes, cpu2 ? "2" : "0..7", instrumented);
        valid = successful(run_process(arguments, NULL, output, errors, BUSTER_LOCK_SECONDS, NULL, false));
    }
    if (output >= 0)
    {
        valid = close(output) == 0 && valid;
    }
    if (errors >= 0)
    {
        valid = close(errors) == 0 && valid;
    }
    valid = valid && read_sample(&one, input->outputs.count, result);
    if (!valid)
    {
        fprintf(stderr, "multicore-149: sample failed; retained %s and %s\n", one.output, error_path);
    }
    return valid;
}

static int compare_times(const void* first, const void* second)
{
    const uint64_t a = *(const uint64_t*)first;
    const uint64_t b = *(const uint64_t*)second;
    return a < b ? -1 : a > b;
}

// Only the primary one-lane diagnostic supplies an Amdahl fraction for the 1-to-N curve. Diagnostics at larger
// lane counts already shorten the parallel interval, so their elapsed serial shares are not baseline fractions.
static bool one_lane_serial_share(const Configuration* configuration, double* result)
{
    char directory[PATH_MAX];
    char path[PATH_MAX];
    bool valid = path_join(directory, sizeof(directory), configuration->output, "diagnostic-0") && path_join(path, sizeof(path), directory, "stages.tsv");
    FILE* file = valid ? fopen(path, "r") : NULL;
    char header[sizeof(stage_header) + 1];
    char row[1024];
    valid = file != NULL && fgets(header, sizeof(header), file) != NULL && strcmp(header, stage_header) == 0 && fgets(row, sizeof(row), file) != NULL;
    unsigned lanes = 0;
    double wall = 0;
    double total = 0;
    double serial = 0;
    double share = 0;
    double startup = 0;
    char model[64];
    char infinite[64];
    int consumed = 0;
    const int fields = valid ? sscanf(row, "%u\t%lf\t%lf\t%lf\t%lf\t%63s\t%63s\t%lf%n", &lanes, &wall, &total, &serial, &share, model, infinite, &startup, &consumed) : 0;
    valid = valid && fields == 8 && row[consumed] == '\n' && row[consumed + 1] == 0 && fgetc(file) == EOF && !ferror(file) && lanes == 1 &&
            isfinite(wall) && wall > 0 && isfinite(total) && total > 0 && isfinite(serial) && serial >= 0 && serial <= wall &&
            isfinite(share) && share >= 0 && share <= 1 && isfinite(startup) && startup >= 0;
    if (valid)
    {
        *result = serial / wall;
    }
    if (file != NULL)
    {
        valid = fclose(file) == 0 && valid;
    }
    return valid;
}

static bool summary(const Configuration* configuration, const Process* samples)
{
    char path[PATH_MAX];
    double serial = 0;
    bool valid = one_lane_serial_share(configuration, &serial) && path_join(path, sizeof(path), configuration->output, "summary.tsv");
    FILE* file = valid ? fopen(path, "w") : NULL;
    valid = valid && file != NULL;
    uint64_t first = 0;
    if (file != NULL)
    {
        fputs("cohort\tlanes\tcpu_mask\truns\tmedian_ms\tmin_ms\tmax_ms\tspeedup_vs_one_lane_same_mask\teffective_serial_fraction\tserial_fraction_lower_bound_from_one_lane\tamdahl_upper_from_one_lane\tamdahl_infinite_upper_from_one_lane\n", file);
        for (unsigned slot = 0; slot <= BUSTER_LANES; slot += 1)
        {
            uint64_t values[BUSTER_MAX_RUNS];
            for (unsigned run = 0; run < configuration->runs; run += 1)
            {
                values[run] = samples[(size_t)slot * configuration->runs + run].wall_ns;
            }
            qsort(values, configuration->runs, sizeof(*values), compare_times);
            const uint64_t median = values[configuration->runs / 2];
            first = slot == 0 ? median : first;
            const unsigned lanes = slot < BUSTER_LANES ? slot + 1 : 1;
            const double speedup = median != 0 ? (double)first / (double)median : 0;
            fprintf(file, "%s\t%u\t%u\t%u\t%.6f\t%.6f\t%.6f\t", slot < BUSTER_LANES ? "primary" : "cpu2-control", lanes,
                    slot < BUSTER_LANES ? 255u : 4u, configuration->runs, (double)median / 1e6, (double)values[0] / 1e6, (double)values[configuration->runs - 1] / 1e6);
            if (slot < BUSTER_LANES)
            {
                fprintf(file, "%.9f\t", speedup);
                if (lanes > 1 && speedup > 0)
                {
                    fprintf(file, "%.9f\t", ((double)lanes / speedup - 1.0) / (lanes - 1));
                }
                else
                {
                    fputs("NA\t", file);
                }
                fprintf(file, "%.9f\t%.9f\t", serial, 1.0 / (serial + (1.0 - serial) / lanes));
                if (serial > 0)
                {
                    fprintf(file, "%.9f\n", 1.0 / serial);
                }
                else
                {
                    fputs("NA\n", file);
                }
            }
            else
            {
                fputs("NA\tNA\tNA\tNA\tNA\n", file);
            }
        }
        valid = !ferror(file) && valid;
        valid = fclose(file) == 0 && valid;
    }
    return valid;
}

static bool campaign(Configuration* configuration, const Case* input)
{
    char original[PATH_MAX];
    char frozen[PATH_MAX];
    bool valid = copy_string(original, sizeof(original), configuration->case_directory) && path_join(frozen, sizeof(frozen), configuration->output, "case") && mkdir(frozen, 0700) == 0;
    for (size_t i = 0; valid && i < 4; i += 1)
    {
        char from[PATH_MAX];
        char to[PATH_MAX];
        valid = path_join(from, sizeof(from), original, case_files[i]) && path_join(to, sizeof(to), frozen, case_files[i]) && copy_file(from, to);
    }
    valid = valid && copy_string(configuration->case_directory, sizeof(configuration->case_directory), frozen);
    char identity_after[PATH_MAX];
    char environment[PATH_MAX];
    valid = valid && path_join(configuration->expected_identity, sizeof(configuration->expected_identity), configuration->output, "identity.before.txt") &&
            path_join(identity_after, sizeof(identity_after), configuration->output, "identity.after.txt") &&
            path_join(environment, sizeof(environment), configuration->output, "environment.txt");
    valid = valid && identity(configuration, configuration->expected_identity) && check_source_hashes(configuration) &&
            host_receipt(configuration->output, "before") && environment_receipt(environment);
    valid = valid && setenv("EXCLUSIVE_OWNER", "multicore-149", 1) == 0 && setenv("EXCLUSIVE_TITLE", "Buster issue 149 multicore acceptance", 1) == 0 &&
            setenv("EXCLUSIVE_LINK", "https://github.com/buster14a/buster/issues/149", 1) == 0;
    Process ignored;
    valid = valid && locked_sample(configuration, input, "reference", 1, false, false, &ignored) &&
            path_join(configuration->reference, sizeof(configuration->reference), configuration->output, "reference");
    Process* samples = valid ? calloc((BUSTER_LANES + 1) * configuration->runs, sizeof(*samples)) : NULL;
    valid = valid && samples != NULL;
    for (unsigned slot = 0; valid && slot <= BUSTER_LANES; slot += 1)
    {
        char name[64];
        snprintf(name, sizeof(name), "warmup-%u", slot);
        valid = locked_sample(configuration, input, name, slot < BUSTER_LANES ? slot + 1 : 1, false, slot == BUSTER_LANES, &ignored);
    }
    for (unsigned run = 0; valid && run < configuration->runs; run += 1)
    {
        for (unsigned position = 0; valid && position <= BUSTER_LANES; position += 1)
        {
            const unsigned slot = (run + position) % (BUSTER_LANES + 1);
            char name[64];
            snprintf(name, sizeof(name), "run-%03u-%u", run + 1, slot);
            valid = locked_sample(configuration, input, name, slot < BUSTER_LANES ? slot + 1 : 1, false, slot == BUSTER_LANES,
                                  samples + (size_t)slot * configuration->runs + run);
        }
    }
    for (unsigned slot = 0; valid && slot <= BUSTER_LANES; slot += 1)
    {
        char name[64];
        snprintf(name, sizeof(name), "diagnostic-%u", slot);
        valid = locked_sample(configuration, input, name, slot < BUSTER_LANES ? slot + 1 : 1, true, slot == BUSTER_LANES, &ignored);
    }
    valid = valid && identity(configuration, identity_after) && same_file(configuration->expected_identity, identity_after) &&
            check_source_hashes(configuration) && host_receipt(configuration->output, "after");
    for (size_t i = 0; valid && i < 4; i += 1)
    {
        char from[PATH_MAX];
        char to[PATH_MAX];
        valid = path_join(from, sizeof(from), original, case_files[i]) && path_join(to, sizeof(to), frozen, case_files[i]) && same_file(from, to);
    }
    char first_policy[PATH_MAX];
    char last_policy[PATH_MAX];
    char last_environment[PATH_MAX];
    valid = valid && path_join(first_policy, sizeof(first_policy), configuration->output, "host-policy.before.txt") &&
            path_join(last_policy, sizeof(last_policy), configuration->output, "host-policy.after.txt") && same_file(first_policy, last_policy) &&
            path_join(last_environment, sizeof(last_environment), configuration->output, "environment.after.txt") &&
            environment_receipt(last_environment) && same_file(environment, last_environment);
    valid = valid && summary(configuration, samples);
    free(samples);
    char status[PATH_MAX];
    const bool named = path_join(status, sizeof(status), configuration->output, "case-status.txt");
    const char* state = valid ? "case-status=qualified\nparent-issue-status=not-established-by-one-case\n" : "case-status=failed\nparent-issue-status=not-established\n";
    valid = named && write_text(status, state) && valid;
    return valid;
}

static bool canonical(char* path)
{
    char resolved[PATH_MAX];
    const bool valid = path[0] == '/' && plain_text(path) && realpath(path, resolved) != NULL && copy_string(path, PATH_MAX, resolved);
    return valid;
}

static bool cpu_list(const char* text)
{
    unsigned seen = 0;
    bool valid = strlen(text) == 15;
    for (unsigned i = 0; valid && i < BUSTER_LANES; i += 1)
    {
        const char digit = text[2 * i];
        valid = digit >= '0' && digit <= '7' && (i == BUSTER_LANES - 1 || text[2 * i + 1] == ',');
        if (valid)
        {
            const unsigned bit = 1u << (unsigned)(digit - '0');
            valid = (seen & bit) == 0;
            seen |= bit;
        }
    }
    return valid && seen == 255u;
}

static bool options(int argc, char** argv, Configuration* configuration)
{
    *configuration = (Configuration){
        .runs = 7,
        .lanes = 1,
        .helper = argc > 1 && strcmp(argv[1], "--sample") == 0,
        .timeout = BUSTER_SAMPLE_SECONDS,
    };
    bool valid = realpath("/proc/self/exe", configuration->executable) != NULL;
    unsigned fields = 0;
    for (int i = configuration->helper ? 2 : 1; valid && i < argc; i += 1)
    {
        char* destination = NULL;
        unsigned bit = 0;
        if (strcmp(argv[i], "--case") == 0)
        {
            destination = configuration->case_directory;
            bit = 1u;
        }
        else if (strcmp(argv[i], "--output") == 0)
        {
            destination = configuration->output;
            bit = 2u;
        }
        else if (strcmp(argv[i], "--compiler") == 0)
        {
            destination = configuration->compiler;
            bit = 4u;
        }
        else if (strcmp(argv[i], "--compiler-source") == 0)
        {
            destination = configuration->source;
            bit = 8u;
        }
        else if (strcmp(argv[i], "--lock") == 0)
        {
            destination = configuration->lock;
            bit = 16u;
        }
        else if (configuration->helper && strcmp(argv[i], "--identity") == 0)
        {
            destination = configuration->expected_identity;
            bit = 32u;
        }
        else if (configuration->helper && strcmp(argv[i], "--reference") == 0)
        {
            destination = configuration->reference;
            bit = 64u;
        }
        else if (!configuration->helper && strcmp(argv[i], "--runs") == 0 && i + 1 < argc)
        {
            valid = (fields & 128u) == 0 && number(argv[++i], BUSTER_MAX_RUNS, &configuration->runs) && configuration->runs >= 3 && (configuration->runs & 1u) != 0;
            fields |= 128u;
        }
        else if (!configuration->helper && strcmp(argv[i], "--cpus") == 0 && i + 1 < argc)
        {
            valid = (fields & 256u) == 0 && cpu_list(argv[++i]);
            fields |= 256u;
        }
        else if (configuration->helper && strcmp(argv[i], "--lanes") == 0 && i + 1 < argc)
        {
            valid = (fields & 512u) == 0 && number(argv[++i], BUSTER_LANES, &configuration->lanes) && configuration->lanes > 0;
            fields |= 512u;
        }
        else if (configuration->helper && strcmp(argv[i], "--instrumented") == 0)
        {
            valid = !configuration->instrumented;
            configuration->instrumented = true;
        }
        else if (configuration->helper && strcmp(argv[i], "--cpu2") == 0)
        {
            valid = !configuration->cpu2;
            configuration->cpu2 = true;
        }
        else
        {
            valid = false;
        }
        if (destination != NULL)
        {
            valid = (fields & bit) == 0 && i + 1 < argc && copy_string(destination, PATH_MAX, argv[++i]);
            fields |= bit;
        }
    }
    valid = valid && (fields & 31u) == 31u && (!configuration->helper || ((fields & 32u) != 0 && (fields & 512u) != 0));
    valid = valid && canonical(configuration->case_directory) && canonical(configuration->compiler) && canonical(configuration->source) && canonical(configuration->lock);
    valid = valid && (!configuration->helper || canonical(configuration->expected_identity));
    valid = valid && (configuration->reference[0] == 0 || canonical(configuration->reference));
    valid = valid && configuration->output[0] == '/' && plain_text(configuration->output) && (!configuration->cpu2 || configuration->lanes == 1);
    char build[PATH_MAX];
    valid = valid && path_join(build, sizeof(build), configuration->source, "build/") && strncmp(configuration->compiler, build, strlen(build)) == 0 &&
            access(configuration->compiler, X_OK) == 0 && access(configuration->lock, X_OK) == 0;
    valid = valid && (!configuration->helper || configuration->reference[0] != 0 || (configuration->lanes == 1 && !configuration->instrumented && !configuration->cpu2));
    return valid;
}

static int runner_self_test(const char* executable);
static int fake_compiler(int argc, char** argv, const char* executable);

#include "runner_test.c"

int main(int argc, char** argv)
{
    int result = 1;
    char executable[PATH_MAX];
    bool valid = install_signals() && realpath("/proc/self/exe", executable) != NULL;
    if (valid && argc == 2 && strcmp(argv[1], "--self-test") == 0)
    {
        result = runner_self_test(executable);
    }
    else if (valid && argc > 2 && strcmp(argv[1], "--fake-compiler") == 0)
    {
        result = fake_compiler(argc - 2, argv + 2, executable);
    }
    else
    {
        Configuration configuration;
        valid = valid && options(argc, argv, &configuration);
        const char* inherited = getenv("BUSTER_9700X_HELD");
        if (valid && !configuration.helper && inherited != NULL && *inherited != 0)
        {
            fprintf(stderr, "multicore-149: controller must run outside the host lock, including CI job-hook locks; each sample acquires its own lock\n");
            valid = false;
        }
        valid = valid && (!configuration.helper || held_lock());
        Case input = { 0 };
        valid = valid && read_case(configuration.case_directory, &input);
        if (valid)
        {
            valid = mkdir(configuration.output, 0700) == 0 && canonical(configuration.output);
            if (!valid)
            {
                fprintf(stderr, "multicore-149: output must name a new directory with an existing parent\n");
            }
        }
        if (valid && configuration.helper)
        {
            // The helper alone retains the shared lock; execed metadata tools and the compiler do not inherit it.
            valid = fcntl(9, F_SETFD, FD_CLOEXEC) == 0;
            Process observed;
            result = valid && sample(&configuration, &input, &observed) ? 0 : 1;
        }
        else if (valid)
        {
            result = campaign(&configuration, &input) ? 0 : 1;
        }
        else
        {
            fprintf(stderr, "usage: runner --case ABS_DIR --output NEW_ABS_DIR --compiler ABS_PATH --compiler-source ABS_REPO --lock ABS_EXCLUSIVE_SH [--runs ODD_3_TO_101] [--cpus 0,1,2,3,4,5,6,7]\n");
        }
        free_case(&input);
    }
    return result;
}
