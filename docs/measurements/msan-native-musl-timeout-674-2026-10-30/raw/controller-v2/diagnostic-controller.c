// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Private diagnostic controller, not a compiler source change. The containment
// protocol is adapted from the separately reviewed diagnostic-supervisor.c:
// WNOWAIT preserves the command identity until process-group killing, and a
// subreaper repeatedly kills/reaps its own direct children until ECHILD.
#define _GNU_SOURCE
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <poll.h>
#include <signal.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/prctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#define TASK "/home/david/Documents/Codex/2026-10-30/tak/work/msan-native-corpus-timeout-20261030"
#define SRC TASK "/source-674"
#define TC TASK "/official-23.1.4"
#define OLD TASK "/diagnostic"
#define REV TASK "/controller-v2"
#define OUT REV "/run"
#define CORPUS TASK "/corpus-391e729af658"
#define MUSL CORPUS "/libc/musl"
#define COMPILER SRC "/build/compiler"
#define SOURCE_MANIFEST OLD "/source-before.sha256"
#define BINARY_MANIFEST OLD "/binary.sha256"
#define TOOL_MANIFEST TASK "/setup-downloads/attempt.G8jRkCTc/receipts/toolchain-files.sha256"
#define BINARY_SHA "d8ae1c8b5eddab82dacc2e2a04279240e7d7151a9e0744ae44769af7b39b3a98"
#define MAX_PATHS 16384

static volatile sig_atomic_t stop_signal;
static FILE* events;
static bool io_failed;
static pid_t debugger_receipt_pid;
static int exit_result(int status);

typedef struct Run
{
    int result;
    int observed;
    int command_code;
    int command_status;
    int interrupted;
    bool timed_out;
    bool clock_failed;
    bool clean;
    bool observation_failed;
} Run;

static void note_signal(int number) { stop_signal = number; }

static uint64_t milliseconds(void)
{
    struct timespec now = {0};
    return clock_gettime(CLOCK_MONOTONIC, &now) == 0 ?
        (uint64_t)now.tv_sec * 1000 + (uint64_t)now.tv_nsec / 1000000 : 0;
}

static void stamp(FILE* file, const char* key)
{
    struct timespec now = {0};
    if (clock_gettime(CLOCK_REALTIME, &now) != 0 ||
        fprintf(file, "%s=%lld.%09ld\n", key, (long long)now.tv_sec, now.tv_nsec) < 0)
        io_failed = true;
}

static bool path_join(char* out, size_t capacity, const char* base, const char* suffix)
{
    const int length = snprintf(out, capacity, "%s/%s", base, suffix);
    return length > 0 && (size_t)length < capacity;
}

static FILE* fresh_file(const char* path)
{
    const int fd = open(path, O_WRONLY | O_CREAT | O_EXCL | O_NOFOLLOW | O_CLOEXEC, 0600);
    FILE* file = fd >= 0 ? fdopen(fd, "w") : NULL;
    if (fd >= 0 && !file) close(fd);
    if (file) setvbuf(file, NULL, _IONBF, 0);
    return file;
}

static bool close_file(FILE* file)
{
    if (!file) return false;
    const bool valid = !ferror(file);
    return fclose(file) == 0 && valid;
}

static bool setup_containment(void)
{
    const pid_t parent = getppid();
    struct sigaction action = {0}, defaults = {0};
    action.sa_handler = note_signal;
    defaults.sa_handler = SIG_DFL;
    sigemptyset(&action.sa_mask);
    sigemptyset(&defaults.sa_mask);
    sigset_t empty;
    sigemptyset(&empty);
    const bool valid = prctl(PR_SET_CHILD_SUBREAPER, 1) == 0 &&
        sigaction(SIGTERM, &action, NULL) == 0 && sigaction(SIGINT, &action, NULL) == 0 &&
        sigaction(SIGHUP, &action, NULL) == 0 && sigaction(SIGCHLD, &defaults, NULL) == 0 &&
        sigprocmask(SIG_SETMASK, &empty, NULL) == 0 && prctl(PR_SET_PDEATHSIG, SIGTERM) == 0;
    if (getppid() != parent || parent == 1) stop_signal = SIGTERM;
    return valid;
}

static void reset_child(pid_t parent)
{
    struct sigaction action = {0};
    action.sa_handler = SIG_DFL;
    sigemptyset(&action.sa_mask);
    if (sigaction(SIGTERM, &action, NULL) != 0 || sigaction(SIGINT, &action, NULL) != 0 ||
        sigaction(SIGHUP, &action, NULL) != 0 || setpgid(0, 0) != 0 ||
        prctl(PR_SET_PDEATHSIG, SIGKILL) != 0 || getppid() != parent) _exit(126);
}

// Only /proc/self/.../children is used for cleanup. Dead direct children are
// zombies until this controller reaps them, so their PIDs cannot be reused
// between enumeration and kill. Descendants that changed sessions are adopted
// after their parent is killed and are handled by a subsequent pass.
static bool reap_tree(pid_t command)
{
    if (command > 0) { kill(-command, SIGKILL); kill(command, SIGKILL); }
    const uint64_t start = milliseconds();
    if (!start) return false;
    bool proc_ok = true;
    while (milliseconds() != 0 && milliseconds() < start + 10000)
    {
        int status = 0;
        pid_t child = waitpid(-1, &status, WNOHANG);
        while (child > 0)
        {
            if (events) fprintf(events, "reaped=%ld raw_status=%d\n", (long)child, status);
            if (child == debugger_receipt_pid)
            {
                if (events) fprintf(events, "stack_sample_exit=%d raw_status=%d reaped_during_cleanup=1\n", exit_result(status), status);
                debugger_receipt_pid = 0;
            }
            child = waitpid(-1, &status, WNOHANG);
        }
        if (child < 0 && errno == ECHILD) return proc_ok;
        if (child < 0 && errno != EINTR) return false;
        char path[128];
        snprintf(path, sizeof(path), "/proc/self/task/%ld/children", (long)getpid());
        FILE* file = fopen(path, "r");
        if (!file) proc_ok = false;
        else
        {
            long adopted = 0;
            while (fscanf(file, "%ld", &adopted) == 1)
                if (adopted > 0 && adopted <= INT_MAX)
                {
                    if (events) fprintf(events, "kill_owned_child=%ld\n", adopted);
                    if (kill((pid_t)adopted, SIGKILL) != 0 && errno != ESRCH) proc_ok = false;
                }
            if (ferror(file)) proc_ok = false;
            fclose(file);
        }
        poll(NULL, 0, 2);
    }
    return false;
}

static int exit_result(int status)
{
    return WIFEXITED(status) ? WEXITSTATUS(status) : WIFSIGNALED(status) ? 128 + WTERMSIG(status) : 125;
}

// Read an already-open /proc/PID directory: an exiting/reused numeric PID cannot
// redirect these openat reads to a different process. Each read is size-bounded.
static bool copy_proc_file(int directory, const char* name, FILE* output, size_t maximum)
{
    const int fd = openat(directory, name, O_RDONLY | O_CLOEXEC | O_NOFOLLOW);
    if (fd < 0) { fprintf(output, "%s unavailable errno=%d\n", name, errno); return errno == ENOENT || errno == ESRCH; }
    fprintf(output, "file=%s\n", name);
    char buffer[1024];
    size_t total = 0;
    bool ok = true;
    while (total < maximum)
    {
        const size_t want = maximum - total < sizeof(buffer) ? maximum - total : sizeof(buffer);
        const ssize_t got = read(fd, buffer, want);
        if (got == 0) break;
        if (got < 0) { if (errno == EINTR) continue; ok = errno == ESRCH; break; }
        if (fwrite(buffer, 1, (size_t)got, output) != (size_t)got) ok = false;
        total += (size_t)got;
    }
    if (total == maximum) fprintf(output, "\nread_limit=%zu\n", maximum);
    fputc('\n', output);
    close(fd);
    return ok && !ferror(output);
}

static int open_process(pid_t pid, pid_t expected_parent)
{
    char path[80];
    snprintf(path, sizeof(path), "/proc/%ld", (long)pid);
    const int directory = open(path, O_RDONLY | O_DIRECTORY | O_CLOEXEC | O_NOFOLLOW);
    if (directory < 0) return -1;
    if (expected_parent > 0)
    {
        const int status = openat(directory, "status", O_RDONLY | O_CLOEXEC | O_NOFOLLOW);
        char bytes[8192] = {0};
        const ssize_t length = status >= 0 ? read(status, bytes, sizeof(bytes) - 1) : -1;
        if (status >= 0) close(status);
        char* field = length > 0 ? strstr(bytes, "\nPPid:\t") : NULL;
        if (!field || strtol(field + 7, NULL, 10) != expected_parent) { close(directory); return -1; }
    }
    return directory;
}

static bool is_compiler(pid_t pid)
{
    const int directory = open_process(pid, getpid());
    if (directory < 0) return false;
    char target[PATH_MAX];
    const ssize_t length = readlinkat(directory, "exe", target, sizeof(target) - 1);
    close(directory);
    if (length < 0) return false;
    target[length] = 0;
    return strcmp(target, COMPILER) == 0;
}

static bool observe_one(pid_t pid, pid_t parent, FILE* output)
{
    const int directory = open_process(pid, parent);
    if (directory < 0) { fprintf(output, "process=%ld unavailable_or_not_owned errno=%d\n", (long)pid, errno); return true; }
    fprintf(output, "process=%ld owned_parent=%ld\n", (long)pid, (long)parent);
    bool ok = copy_proc_file(directory, "stat", output, 8192);
    ok = copy_proc_file(directory, "status", output, 8192) && ok;
    ok = copy_proc_file(directory, "io", output, 4096) && ok;
    ok = copy_proc_file(directory, "wchan", output, 1024) && ok;
    ok = copy_proc_file(directory, "cmdline", output, 8192) && ok;
    const int fd_dir = openat(directory, "fd", O_RDONLY | O_DIRECTORY | O_CLOEXEC | O_NOFOLLOW);
    DIR* descriptors = fd_dir >= 0 ? fdopendir(fd_dir) : NULL;
    if (descriptors)
    {
        struct dirent* item;
        unsigned count = 0;
        while ((item = readdir(descriptors)) != NULL && count < 64)
        {
            if (item->d_name[0] == '.') continue;
            char target[1024];
            const ssize_t n = readlinkat(fd_dir, item->d_name, target, sizeof(target) - 1);
            if (n >= 0) { target[n] = 0; fprintf(output, "fd=%s target=%s\n", item->d_name, target); }
            ++count;
        }
        if (count == 64) fprintf(output, "fd_listing_limit=64\n");
        closedir(descriptors);
    }
    else if (fd_dir >= 0) close(fd_dir);
    close(directory);
    return ok && !ferror(output);
}

static bool observation(pid_t command, FILE* output, uint64_t elapsed)
{
    fprintf(output, "elapsed_ms=%llu\n", (unsigned long long)elapsed);
    bool ok = observe_one(command, getpid(), output);
    const int directory = open_process(command, getpid());
    if (directory >= 0)
    {
        char name[80];
        snprintf(name, sizeof(name), "task/%ld/children", (long)command);
        const int fd = openat(directory, name, O_RDONLY | O_CLOEXEC | O_NOFOLLOW);
        FILE* children = fd >= 0 ? fdopen(fd, "r") : NULL;
        if (children)
        {
            long pid = 0;
            unsigned count = 0;
            while (count < 64 && fscanf(children, "%ld", &pid) == 1)
            {
                if (pid > 0 && pid <= INT_MAX) ok = observe_one((pid_t)pid, command, output) && ok;
                ++count;
            }
            if (count == 64) fprintf(output, "direct_child_listing_limit=64\n");
            if (ferror(children)) ok = false;
            fclose(children);
        }
        else if (fd >= 0) close(fd);
        close(directory);
    }
    fflush(output);
    return ok && !ferror(output);
}

static pid_t spawn(char* const* argv, const char* cwd, const char* log, bool runtime_epoch)
{
    const int output = open(log, O_WRONLY | O_CREAT | O_EXCL | O_NOFOLLOW | O_CLOEXEC, 0600);
    if (output < 0) return -1;
    const pid_t parent = getpid();
    const pid_t child = fork();
    if (child == 0)
    {
        reset_child(parent);
        if (dup2(output, STDOUT_FILENO) < 0 || dup2(output, STDERR_FILENO) < 0 || chdir(cwd) != 0) _exit(126);
        close(output);
        if (runtime_epoch && setenv("SOURCE_DATE_EPOCH", "1792454400", 1) != 0) _exit(126);
        execv(argv[0], argv);
        const int failure = errno;
        dprintf(STDERR_FILENO, "launch_failure stage=execv errno=%d executable=%s\n", failure, argv[0]);
        _exit(127);
    }
    close(output);
    return child;
}

static Run run_command(char* const* argv, const char* cwd, const char* log,
    unsigned seconds, FILE* progress, const char* stack_log, bool runtime_epoch)
{
    Run result = {.result = 125};
    const uint64_t start = milliseconds();
    if (!start) { result.clock_failed = true; result.clean = reap_tree(0); return result; }
    if (events)
    {
        fprintf(events, "command_argv_begin\n");
        for (size_t i = 0; argv[i]; ++i) fprintf(events, "argv[%zu]=%s\n", i, argv[i]);
        fprintf(events, "command_cwd=%s deadline_seconds=%u runtime_source_date_epoch=%s\n",
            cwd, seconds, runtime_epoch ? "1792454400" : "unset");
    }
    const pid_t command = spawn(argv, cwd, log, runtime_epoch);
    if (command < 0) { result.clean = reap_tree(0); return result; }
    fprintf(events, "command=%ld\n", (long)command);
    const uint64_t deadline = start + (uint64_t)seconds * 1000;
    uint64_t next_observation = start;
    pid_t debugger = 0;
    uint64_t debugger_start = 0;
    bool stack_attempted = false;
    bool debugger_timeout = false;
    const int inherited_signal = stop_signal;
    siginfo_t information = {0};
    while (!result.observed && !result.timed_out && !result.clock_failed && !result.interrupted)
    {
        information = (siginfo_t){0};
        const int inspected = waitid(P_PID, (id_t)command, &information, WEXITED | WNOHANG | WNOWAIT);
        if (inspected == 0 && information.si_pid == command) result.observed = 1;
        else if (inspected != 0 && errno != EINTR) result.observed = -1;
        const uint64_t now = milliseconds();
        result.clock_failed = now == 0;
        // An already observed command exit retains its actual exit, even at the
        // deadline. The raw waitid result is recorded separately in all cases.
        result.timed_out = !result.observed && !result.clock_failed && now >= deadline;
        result.interrupted = stop_signal != inherited_signal || (runtime_epoch && stop_signal) ? stop_signal : 0;
        if (progress && !result.observed && !result.timed_out && !result.interrupted && !result.clock_failed && now >= next_observation)
        {
            if (!observation(command, progress, now - start)) result.observation_failed = true;
            next_observation = now + 5000;
        }
        if (progress && !stack_attempted && !result.observed && !result.timed_out && !result.interrupted && !result.clock_failed && now - start >= 180000)
        {
            stack_attempted = true;
            if (!is_compiler(command)) fprintf(events, "stack_sample=not_compiler_identity\n");
            else if (access("/usr/bin/gdb", X_OK) != 0) fprintf(events, "stack_sample=unavailable_gdb errno=%d\n", errno);
            else
            {
                char attach[80];
                snprintf(attach, sizeof(attach), "attach %ld", (long)command);
                char* args[] = {"/usr/bin/gdb", "-nx", "-nh", "-q", "-batch", "-iex", "set auto-load off",
                    "-ex", "set follow-fork-mode parent", "-ex", "set detach-on-fork on", "-ex", attach,
                    "-ex", "thread apply all bt 16", "-ex", "detach", "-ex", "quit", NULL};
                debugger = spawn(args, cwd, stack_log, false);
                debugger_receipt_pid = debugger > 0 ? debugger : 0;
                debugger_start = now;
                fprintf(events, "stack_sample=attempted debugger=%ld parent_only=%ld launch_errno=%d\n",
                    (long)debugger, (long)command, debugger < 0 ? errno : 0);
                if (debugger < 0) debugger = 0;
            }
        }
        if (debugger > 0)
        {
            int status = 0;
            const pid_t inspected_debugger = waitpid(debugger, &status, WNOHANG);
            if (inspected_debugger == debugger)
            {
                fprintf(events, "stack_sample_exit=%d raw_status=%d timed_out=%d denied_reason_in_log=%s\n",
                    exit_result(status), status, debugger_timeout, stack_log);
                debugger = 0;
                debugger_receipt_pid = 0;
            }
            else if (inspected_debugger < 0 && errno != EINTR)
            { fprintf(events, "stack_sample_wait_error=%d\n", errno); result.observation_failed = true; debugger = 0; debugger_receipt_pid = 0; }
            else if (now != 0 && now - debugger_start >= 8000 && !debugger_timeout)
            { kill(-debugger, SIGKILL); kill(debugger, SIGKILL); debugger_timeout = true; }
        }
        if (!result.observed && !result.timed_out && !result.clock_failed && !result.interrupted) poll(NULL, 0, 20);
    }
    result.command_code = information.si_code;
    result.command_status = information.si_status;
    if (!stack_attempted && progress) fprintf(events, "stack_sample=skipped_not_reached\n");
    if (debugger > 0)
    {
        kill(-debugger, SIGKILL); kill(debugger, SIGKILL);
        fprintf(events, "stack_sample=interrupted_by_command_completion debugger=%ld\n", (long)debugger);
        // The common cleanup records the actual raw wait status and proves
        // this debugger and all command descendants are gone before any audit.
    }
    result.clean = reap_tree(command);
    if (result.timed_out) result.result = 124;
    else if (result.interrupted) result.result = 128 + result.interrupted;
    else if (result.observed == 1)
        result.result = information.si_code == CLD_EXITED ? information.si_status :
            information.si_code == CLD_KILLED || information.si_code == CLD_DUMPED ? 128 + information.si_status : 125;
    fprintf(events, "original_result=%d observed=%d command_code=%d command_status=%d timed_out=%d signal=%d clock_failed=%d cleanup=%s observer=%d\n",
        result.result, result.observed, result.command_code, result.command_status, result.timed_out,
        result.interrupted, result.clock_failed, result.clean ? "ECHILD" : "INCOMPLETE", result.observation_failed);
    return result;
}

static int helper(char* const* argv, const char* cwd, const char* directory, const char* name, unsigned seconds)
{
    char log[PATH_MAX];
    if (!path_join(log, sizeof(log), directory, name)) return 125;
    const Run result = run_command(argv, cwd, log, seconds, NULL, NULL, false);
    return result.clean && !result.clock_failed ? result.result : 125;
}

static int check_manifest(const char* manifest, const char* cwd, const char* directory, const char* name)
{
    char* args[] = {"/usr/bin/sha256sum", "--check", (char*)manifest, NULL};
    return helper(args, cwd, directory, name, 60);
}

static bool content_equals(const char* path, const char* expected)
{
    char bytes[4096];
    const int fd = open(path, O_RDONLY | O_CLOEXEC | O_NOFOLLOW);
    if (fd < 0) return false;
    const ssize_t n = read(fd, bytes, sizeof(bytes));
    close(fd);
    return n >= 0 && (size_t)n == strlen(expected) && memcmp(bytes, expected, (size_t)n) == 0;
}

static bool files_equal(const char* left, const char* right)
{
    const int a = open(left, O_RDONLY | O_CLOEXEC | O_NOFOLLOW);
    const int b = open(right, O_RDONLY | O_CLOEXEC | O_NOFOLLOW);
    bool equal = a >= 0 && b >= 0;
    while (equal)
    {
        char x[4096], y[4096];
        const ssize_t nx = read(a, x, sizeof(x));
        const ssize_t ny = read(b, y, sizeof(y));
        if (nx < 0 || ny < 0 || nx != ny) equal = false;
        else if (nx == 0) break;
        else if (memcmp(x, y, (size_t)nx) != 0) equal = false;
    }
    if (a >= 0) close(a);
    if (b >= 0) close(b);
    return equal;
}

static bool trusted_manifest(void)
{
    FILE* file = fresh_file(OUT "/trusted-inputs.sha256");
    if (!file) return false;
    // Pins were independently read from the immutable source/build/staging
    // receipts while preparing this revision, before any corpus invocation.
    fprintf(file,
        "fcff029b3684862be05a49cd6f1b92a8aa20dd0987a8931d8f53b1511130a297  " SOURCE_MANIFEST "\n"
        "c1b9325f18b674f889a1060836cf853a3087be031783eefc3a0f02984d6954dc  " TOOL_MANIFEST "\n"
        "5c5edd3a4c412a437d3969c210c9d03cbc66d99c4911751afb25c34bd997d59d  " TASK "/corpus-manifests.sha256\n"
        "0b4fd107a443c858b67ac9c53436e403c69da3b980df4e929c6f3cf1bc7f3d19  " SRC "/tools/ci/sanitizers.sh\n"
        "c671086b641d573139b4b44cceee1e1ac54ee54018e5f5bc3314f2a9de8dff71  " TASK "/source-674.tar\n"
        "c336d48383874cffaab0dc4c5c359456d871f21380b746520dde5c7f4c125a67  " TC "/bin/clang\n"
        "98aa98682cbd6d8ef9804f9339d44af0307410cef610da2cc3b5ecf6888a3713  " TC "/bin/llvm-symbolizer\n"
        "8d85c1057d742e597985c7d4e6320b015a9139385cff4cbae06ffc0ebe89afee  " TC "/LICENSE.TXT\n"
        "b80f7d5be7005a27aa73634ffeeb1e77f135966938c4afb76b316d1d7994df5f  " TC "/lib/clang/23/lib/x86_64-unknown-linux-gnu/libclang_rt.msan.a\n"
        "c7f649fac9453fd763277dc5022a7ceafdc41ddbd5b0fe3fd9fd04e387cded38  " TC "/lib/clang/23/lib/x86_64-unknown-linux-gnu/libclang_rt.msan_cxx.a\n");
    return close_file(file);
}

static bool configure_environment(void)
{
    const char* clear[] = {"CPATH", "C_INCLUDE_PATH", "CPLUS_INCLUDE_PATH", "LIBRARY_PATH", "LD_PRELOAD",
        "CCC_OVERRIDE_OPTIONS", "COMPILER_PATH", "GCC_EXEC_PREFIX", "CFLAGS", "CXXFLAGS", "CPPFLAGS", "LDFLAGS",
        "BUSTER_HOST_RUNTIME", "BUSTER_FUZZ_AVAILABLE", "BUSTER_FUZZ_ENTRY", "SOURCE_DATE_EPOCH", "BASH_ENV", "ENV",
        "ASAN_OPTIONS", "LSAN_OPTIONS", "UBSAN_OPTIONS", "TSAN_OPTIONS", "MSAN_OPTIONS", NULL};
    for (size_t i = 0; clear[i]; ++i) if (unsetenv(clear[i]) != 0) return false;
    const char* values[][2] = {{"PATH", TC "/bin:/usr/bin:/bin"}, {"LD_LIBRARY_PATH", TC "/lib"},
        {"BUSTER_HOST_ARCH", "znver3"}, {"BUSTER_SANITIZER", "memory"}, {"BUSTER_SANITIZER_OPTIMIZATION", "3"},
        {"BUSTER_LINKER", "lld"}, {"BUSTER_CLANG_RESOURCE_DIR", TC "/lib/clang/23"}, {"BUSTER_ORACLE_CACHE", "check"},
        {"XDG_CACHE_HOME", OUT "/cache"}, {"TMPDIR", OUT "/tmp"}, {"LC_ALL", "C"}};
    for (size_t i = 0; i < sizeof(values) / sizeof(values[0]); ++i)
        if (setenv(values[i][0], values[i][1], 1) != 0) return false;
    return true;
}

static size_t selected_count(const char* path, bool* ok)
{
    DIR* directory = opendir(path);
    if (!directory) { *ok = false; return 0; }
    size_t count = 0;
    struct dirent* item;
    while ((item = readdir(directory)) != NULL)
    {
        if (strcmp(item->d_name, ".") == 0 || strcmp(item->d_name, "..") == 0) continue;
        char child[PATH_MAX];
        struct stat st;
        if (!path_join(child, sizeof(child), path, item->d_name) || lstat(child, &st) != 0) { *ok = false; break; }
        if (S_ISDIR(st.st_mode)) count += selected_count(child, ok);
        else if (S_ISREG(st.st_mode))
        {
            const size_t length = strlen(item->d_name);
            if (length > 2 && strcmp(item->d_name + length - 2, ".c") == 0) ++count;
        }
        else *ok = false;
        if (count > 613) *ok = false;
    }
    if (closedir(directory) != 0) *ok = false;
    return count;
}

typedef struct Paths { char* names[MAX_PATHS]; size_t count; size_t bytes; bool valid; } Paths;

static void collect_cache(const char* path, Paths* paths, unsigned depth)
{
    if (depth > 16) { paths->valid = false; return; }
    DIR* directory = opendir(path);
    if (!directory) { paths->valid = false; return; }
    struct dirent* item;
    while (paths->valid && (item = readdir(directory)) != NULL)
    {
        if (strcmp(item->d_name, ".") == 0 || strcmp(item->d_name, "..") == 0) continue;
        char child[PATH_MAX];
        struct stat st;
        if (!path_join(child, sizeof(child), path, item->d_name) || lstat(child, &st) != 0) { paths->valid = false; break; }
        if (S_ISDIR(st.st_mode)) collect_cache(child, paths, depth + 1);
        else if (S_ISREG(st.st_mode) && paths->count < MAX_PATHS && paths->bytes + strlen(child) + 1 < 1024 * 1024)
        {
            paths->names[paths->count] = strdup(child);
            if (!paths->names[paths->count]) paths->valid = false;
            else { ++paths->count; paths->bytes += strlen(child) + 1; }
        }
        else paths->valid = false;
    }
    if (closedir(directory) != 0) paths->valid = false;
}

static int compare_paths(const void* a, const void* b) { return strcmp(*(char* const*)a, *(char* const*)b); }

static int cache_receipt(void)
{
    Paths paths = {.valid = true};
    collect_cache(OUT "/cache", &paths, 0);
    qsort(paths.names, paths.count, sizeof(paths.names[0]), compare_paths);
    FILE* list = fresh_file(OUT "/cache-paths.txt");
    bool ok = list != NULL;
    for (size_t i = 0; i < paths.count; ++i) if (list && fprintf(list, "%s\n", paths.names[i]) < 0) ok = false;
    if (list && !close_file(list)) ok = false;
    int result = 125;
    if (paths.valid && ok)
    {
        if (paths.count)
        {
            char** args = calloc(paths.count + 3, sizeof(*args));
            if (args)
            {
                args[0] = "/usr/bin/sha256sum"; args[1] = "--";
                for (size_t i = 0; i < paths.count; ++i) args[i + 2] = paths.names[i];
                result = helper(args, SRC, OUT, "cache-after.sha256", 60);
                free(args);
            }
        }
        else { FILE* file = fresh_file(OUT "/cache-after.sha256"); result = file && close_file(file) ? 0 : 125; }
    }
    fprintf(events, "cache_files=%zu bounded_manifest_status=%d\n", paths.count, result);
    for (size_t i = 0; i < paths.count; ++i) free(paths.names[i]);
    return result;
}

static int capture_identities(const char* name)
{
    char self[PATH_MAX];
    const ssize_t n = readlink("/proc/self/exe", self, sizeof(self) - 1);
    if (n < 0) return 125;
    self[n] = 0;
    char* args[48] = {"/usr/bin/sha256sum", "--", self, REV "/diagnostic-controller.c", REV "/ci-configure-exec.sh",
        REV "/containment-fixture.c", TASK "/diagnostic-supervisor.c", TASK "/diagnostic-controller.sh",
        SOURCE_MANIFEST, BINARY_MANIFEST, OLD "/build.status", OLD "/build-driver.status", OLD "/compile_commands.json",
        OLD "/compile-flags.nul", OLD "/sources.nul", OLD "/target-macros.txt", OLD "/effective-driver.txt",
        OLD "/independent-staged-input-verification.txt", TASK "/source-674.tar", SRC "/tools/ci/sanitizers.sh",
        SRC "/tools/ci/correctness.tests", TC "/bin/clang", TC "/bin/llvm-symbolizer", TC "/LICENSE.TXT",
        TC "/lib/clang/23/lib/x86_64-unknown-linux-gnu/libclang_rt.msan.a",
        TC "/lib/clang/23/lib/x86_64-unknown-linux-gnu/libclang_rt.msan_cxx.a",
        TASK "/corpus-manifests.sha256", CORPUS "/MANIFESTS.sha256", OLD "/host-cpuinfo.txt", OLD "/host-lscpu.json",
        OLD "/local-kernel.txt", OLD "/local-libc.txt", "/usr/bin/sha256sum", "/bin/bash", NULL};
    if (access("/usr/bin/gdb", R_OK | X_OK) == 0)
    {
        size_t i = 0;
        while (args[i]) ++i;
        args[i] = "/usr/bin/gdb";
    }
    return helper(args, SRC, OUT, name, 60);
}

static int run_diagnostic(void)
{
    // This shared guard is the same pathname used by the retired controller.
    // It is consumed before prechecks: an aborted attempt cannot silently retry.
    FILE* guard = fresh_file(OLD "/run.started");
    if (!guard) { perror("shared one-run O_EXCL guard"); return 125; }
    stamp(guard, "run_started");
    fprintf(guard, "controller=C-v2 pid=%ld source=674ae159503b4b51f2c54865d9cfdd225e9d27a0\n", (long)getpid());
    const bool guard_ok = close_file(guard);
    if (mkdir(OUT, 0700) != 0) { perror("fresh C-controller output directory"); return 125; }
    FILE* status = fresh_file(OUT "/status.txt");
    events = fresh_file(OUT "/events.txt");
    if (!status || !events)
    {
        if (status) { fprintf(status, "final_status=125 setup=receipt_open_failed\n"); close_file(status); }
        if (events) close_file(events);
        perror("C-controller receipts"); return 125;
    }
    fprintf(status, "controller=C-v2\nsource_commit=674ae159503b4b51f2c54865d9cfdd225e9d27a0\nsource_binary_sha256=" BINARY_SHA "\n");
    stamp(status, "started");
    fprintf(status, "CORES=%s CORES_HELD=%s\n", getenv("CORES") ? getenv("CORES") : "unset",
        getenv("CORES_HELD") ? getenv("CORES_HELD") : "unset");
    Run command = {.result = 125, .clean = true};
    int pre = 0, source_post = 125, binary_post = 125, tool_post = 125, identity_post = 125, audit = 125, cache = 125;
    FILE* progress = NULL;
    bool clean_before_audit = true;
    // Do not short-circuit these operations: the unconditional audit still
    // needs its fixed environment and fresh report directory if another
    // preparation operation fails.
    const bool environment_ok = configure_environment();
    const bool cache_directory_ok = mkdir(OUT "/cache", 0700) == 0;
    const bool temporary_directory_ok = mkdir(OUT "/tmp", 0700) == 0;
    const bool report_directory_ok = mkdir(OUT "/reports", 0700) == 0;
    if (!guard_ok || io_failed || !environment_ok || !cache_directory_ok ||
        !temporary_directory_ok || !report_directory_ok) pre = 125;
    if (!getenv("CORES") || strcmp(getenv("CORES"), "1") != 0 || !getenv("CORES_HELD") || !*getenv("CORES_HELD")) pre = 125;
    fprintf(status, "host_arch=znver3 sanitizer=memory sanitizer_optimization=3 oracle_cache=check\n"
        "PATH=" TC "/bin:/usr/bin:/bin\nLD_LIBRARY_PATH=" TC "/lib\n"
        "resource=" TC "/lib/clang/23\nXDG_CACHE_HOME=" OUT "/cache\nTMPDIR=" OUT "/tmp\n"
        "SOURCE_DATE_EPOCH=unset_in_controller_set_only_in_runtime_child\n");
    if (!content_equals(OLD "/build.status", "build=0\nproof=0\n") ||
        !content_equals(OLD "/build-driver.status", "build_driver=0\n") ||
        !content_equals(BINARY_MANIFEST, BINARY_SHA "  build/compiler\n")) pre = 125;
    if (!pre && !trusted_manifest()) pre = 125;
    if (!pre)
    {
        const int trusted = check_manifest(OUT "/trusted-inputs.sha256", SRC, OUT, "trusted-inputs-before.log");
        const int source = check_manifest(SOURCE_MANIFEST, SRC, OUT, "source-before.log");
        const int binary = check_manifest(BINARY_MANIFEST, SRC, OUT, "binary-before.log");
        const int tool = check_manifest(TOOL_MANIFEST, SRC, OUT, "toolchain-before.log");
        const int identities = capture_identities("identities-before.sha256");
        const int corpus = check_manifest(TASK "/corpus-manifests.sha256", SRC, OUT, "corpus-metadata-before.log");
        const int libc = check_manifest(CORPUS "/manifests/libc.sha256", CORPUS "/libc", OUT, "corpus-libc-before.log");
        const int generated = check_manifest(CORPUS "/manifests/musl-generated.sha256", CORPUS "/musl-generated", OUT, "corpus-generated-before.log");
        pre = trusted || source || binary || tool || identities || corpus || libc || generated ? 125 : 0;
        fprintf(status, "pre_trusted=%d pre_source=%d pre_binary=%d pre_tools=%d pre_identities=%d pre_corpus_metadata=%d pre_libc=%d pre_generated=%d\n",
            trusted, source, binary, tool, identities, corpus, libc, generated);
        bool inventory_ok = true;
        const char* subdirs[] = {"math", "string", "stdlib", "fenv", "legacy", "process", "signal", "multibyte"};
        size_t count = 0;
        for (size_t i = 0; i < sizeof(subdirs) / sizeof(subdirs[0]); ++i)
        {
            char path[PATH_MAX];
            if (!path_join(path, sizeof(path), MUSL "/src", subdirs[i])) inventory_ok = false;
            else count += selected_count(path, &inventory_ok);
        }
        fprintf(status, "selected_inventory=%zu inventory_valid=%d\n", count, inventory_ok);
        if (!inventory_ok || count != 613) pre = 125;
        if (stop_signal) pre = 125;
    }
    if (!pre)
    {
        progress = fresh_file(OUT "/progress.log");
        if (!progress) pre = 125;
    }
    if (!pre)
    {
        char* argv[] = {"/bin/bash", "--noprofile", "--norc", REV "/ci-configure-exec.sh", "./build/compiler",
            "test-checker-corpus", "--clang", "clang", "--symbols-minimum", "354", "--no-default-config",
            "--target=x86_64-linux-gnu", "-march=znver5", "-std=c99", "-ffreestanding", "-nostdinc", "-D_XOPEN_SOURCE=700", "-Os", "-pipe",
            "-I", MUSL "/arch/x86_64", "-I", MUSL "/arch/generic", "-I", CORPUS "/musl-generated/obj/src/internal",
            "-I", MUSL "/src/include", "-I", MUSL "/src/internal", "-I", CORPUS "/musl-generated/obj/include", "-I", MUSL "/include",
            MUSL "/src/math", MUSL "/src/string", MUSL "/src/stdlib", MUSL "/src/fenv", MUSL "/src/legacy",
            MUSL "/src/process", MUSL "/src/signal", MUSL "/src/multibyte", NULL};
        command = run_command(argv, SRC, OUT "/command.log", 240, progress, OUT "/parent-stack-sample.log", true);
    }
    if (progress && !close_file(progress)) command.observation_failed = true;
    // This is unconditional, including setup/precheck/observer failures. Failed
    // containment is fatal and any subsequent report audit is only provisional.
    clean_before_audit = reap_tree(0) && command.clean;
    fprintf(status, "preflight=%d command=%d observed=%d command_code=%d command_status=%d timed_out=%d signal=%d clock_failed=%d cleanup_before_audit=%s observer=%d\n",
        pre, command.result, command.observed, command.command_code, command.command_status, command.timed_out,
        command.interrupted, command.clock_failed, clean_before_audit ? "ECHILD" : "INCOMPLETE", command.observation_failed);
    char* audit_argv[] = {"/bin/bash", "--noprofile", "--norc", SRC "/tools/ci/sanitizers.sh", "audit", OUT "/reports", NULL};
    audit = helper(audit_argv, SRC, OUT, "audit.log", 30);
    source_post = check_manifest(SOURCE_MANIFEST, SRC, OUT, "source-after.log");
    binary_post = check_manifest(BINARY_MANIFEST, SRC, OUT, "binary-after.log");
    tool_post = check_manifest(TOOL_MANIFEST, SRC, OUT, "toolchain-after.log");
    identity_post = capture_identities("identities-after.sha256");
    const int trusted_post = check_manifest(OUT "/trusted-inputs.sha256", SRC, OUT, "trusted-inputs-after.log");
    const bool identity_match = files_equal(OUT "/identities-before.sha256", OUT "/identities-after.sha256");
    cache = cache_receipt();
    const bool final_clean = reap_tree(0);
    stamp(status, "finished");
    const bool events_ok = close_file(events);
    events = NULL;
    if (!events_ok) io_failed = true;
    int final = command.result;
    if (pre || !clean_before_audit || !final_clean || command.clock_failed || !events_ok) final = 125;
    else if (command.result == 0 && (audit || source_post || binary_post || tool_post || identity_post || trusted_post ||
        !identity_match || cache || command.observation_failed || io_failed)) final = 1;
    fprintf(status, "audit=%d source_after=%d binary_after=%d tools_after=%d identities_after=%d identity_match=%d trusted_after=%d cache_receipt=%d final_cleanup=%s io_failure=%d event_delivery=%d\n",
        audit, source_post, binary_post, tool_post, identity_post, identity_match, trusted_post, cache, final_clean ? "ECHILD" : "INCOMPLETE", io_failed, events_ok ? 0 : 125);
    fprintf(status, "audit_scope=%s\n", clean_before_audit && final_clean ? "all_command_descendants_reaped" : "PROVISIONAL_incomplete_cleanup");
    fprintf(status, "qualification=bounded_diagnostic_only_no_hosted_reproduction_or_acceptance_claim\nfinal_status=%d\n", final);
    if (!close_file(status)) final = 125;
    return final;
}

static int control(int argc, char** argv)
{
    if (argc < 5) return 2;
    char* end = NULL;
    errno = 0;
    const unsigned long seconds = strtoul(argv[2], &end, 10);
    if (errno || !end || *end || seconds == 0 || seconds > 240 || argv[3][0] != '/') return 2;
    if (mkdir(argv[3], 0700) != 0) return 125;
    char status_path[PATH_MAX], events_path[PATH_MAX], command_log[PATH_MAX];
    if (!path_join(status_path, sizeof(status_path), argv[3], "status.txt") ||
        !path_join(events_path, sizeof(events_path), argv[3], "events.txt") ||
        !path_join(command_log, sizeof(command_log), argv[3], "command.log")) return 125;
    FILE* status = fresh_file(status_path);
    events = fresh_file(events_path);
    if (!status || !events) { if (status) fclose(status); if (events) fclose(events); return 125; }
    const Run result = run_command(argv + 4, "/", command_log, (unsigned)seconds, NULL, NULL, false);
    int postcheck = 0;
    if (strcmp(argv[1], "control-postfail") == 0)
    {
        char missing[PATH_MAX];
        if (!path_join(missing, sizeof(missing), argv[3], "never-created.manifest")) postcheck = 125;
        else postcheck = check_manifest(missing, "/", argv[3], "postcheck-failure.log");
    }
    const bool clean = reap_tree(0) && result.clean;
    const bool event_ok = close_file(events);
    events = NULL;
    const int final = !clean || result.clock_failed || !event_ok ? 125 : postcheck && result.result == 0 ? 1 : result.result;
    fprintf(status, "command=%d observed=%d command_code=%d command_status=%d timed_out=%d signal=%d cleanup=%s postcheck=%d event_delivery=%d final_status=%d\n",
        result.result, result.observed, result.command_code, result.command_status, result.timed_out,
        result.interrupted, clean ? "ECHILD" : "INCOMPLETE", postcheck, event_ok ? 0 : 125, final);
    return close_file(status) && event_ok ? final : 125;
}

int main(int argc, char** argv)
{
    if (!setup_containment()) { perror("controller containment setup"); return 125; }
    if (argc == 2 && strcmp(argv[1], "run") == 0) return run_diagnostic();
    if (argc >= 2 && (strcmp(argv[1], "control") == 0 || strcmp(argv[1], "control-postfail") == 0)) return control(argc, argv);
    fprintf(stderr, "usage: controller run | controller control|control-postfail SECONDS FRESH_ABSOLUTE_RECEIPT_DIR COMMAND [ARGS...]\n");
    return 2;
}
