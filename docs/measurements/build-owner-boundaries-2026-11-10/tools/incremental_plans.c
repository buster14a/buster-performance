// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Actual Ninja edit plans for existing, fully built ordinary Release trees.
// This never builds, changes source bytes, or reports timing measurements.
#define _POSIX_C_SOURCE 200809L
#define _XOPEN_SOURCE 700
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <openssl/evp.h>
#include <signal.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/file.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

typedef struct Sample
{
    const char* name;
    const char* source;
    const char* baseline_container;
    bool candidate_only;
} Sample;

static const Sample samples[] = {
    { "pp_literal", "c_preprocessor_literal.c", "pp_literal", false },
    { "pp_interface", "c_preprocessor.c", "pp_interface", false },
    { "pp_history_interface", "c_preprocessor_history.c", "pp_history_interface", false },
    { "pp_impl", "c_preprocessor_impl.c", "pp_interface", true },
    { "pp_history_impl", "c_preprocessor_history_impl.c", "pp_history_interface", true },
    { "executable_interface", "executable.c", "executable_interface", false },
    { "executable_impl", "executable_impl.c", "executable_interface", true },
    { "check_input", "c_check_input.c", "check_input", false },
    { "check_actions", "c_check_actions.c", "check_actions", false },
    { "checker_test", "c_checker_test.c", "checker_test", false },
    { "ir_dataflow", "ir_dataflow.c", "ir_dataflow", false },
    { "ir_if_convert", "ir_if_convert.c", "ir_if_convert", false },
    { "tier0", "tier0.c", "tier0", false },
};

typedef struct Plan
{
    unsigned steps;
    unsigned compiles;
    unsigned unity;
    unsigned links;
    unsigned bakes;
    unsigned other;
    char sources[256][256];
} Plan;

static int active_descriptor = -1;
static struct timespec saved_times[2];
static volatile sig_atomic_t interrupted;

static void restore_active(void)
{
    if (active_descriptor >= 0)
    {
        if (futimens(active_descriptor, saved_times) != 0)
        {
            fputs("FATAL: source timestamp restoration failed; use the saved timestamp journal.\n", stderr);
        }
        close(active_descriptor);
        active_descriptor = -1;
    }
}

static void fail(const char* text)
{
    fprintf(stderr, "%s: %s\n", text, strerror(errno));
    exit(1);
}

static void receive_signal(int signal_number)
{
    interrupted = signal_number;
}

static void path_join(char* out, size_t size, const char* first, const char* second)
{
    const int count = snprintf(out, size, "%s/%s", first, second);
    if (count < 0 || (size_t)count >= size)
    {
        errno = ENAMETOOLONG;
        fail("path overflow");
    }
}

static bool same_time(struct timespec a, struct timespec b)
{
    return a.tv_sec == b.tv_sec && a.tv_nsec == b.tv_nsec;
}

static bool later(struct timespec a, struct timespec b)
{
    return a.tv_sec > b.tv_sec || (a.tv_sec == b.tv_sec && a.tv_nsec > b.tv_nsec);
}

static void digest_fd(int descriptor, char result[65])
{
    EVP_MD_CTX* context = EVP_MD_CTX_new();
    if (context == NULL || EVP_DigestInit_ex(context, EVP_sha256(), NULL) != 1)
    {
        fail("SHA-256 setup");
    }
    unsigned char buffer[65536];
    off_t offset = 0;
    ssize_t count;
    while ((count = pread(descriptor, buffer, sizeof(buffer), offset)) > 0)
    {
        if (EVP_DigestUpdate(context, buffer, (size_t)count) != 1)
        {
            fail("SHA-256 input");
        }
        offset += count;
    }
    if (count < 0)
    {
        fail("read for SHA-256");
    }
    unsigned char bytes[32];
    unsigned length = 0;
    if (EVP_DigestFinal_ex(context, bytes, &length) != 1 || length != sizeof(bytes))
    {
        fail("SHA-256 finalization");
    }
    EVP_MD_CTX_free(context);
    for (unsigned i = 0; i < length; i += 1)
    {
        snprintf(result + i * 2, 3, "%02x", bytes[i]);
    }
}

static void digest_path(const char* path, char result[65])
{
    const int descriptor = open(path, O_RDONLY | O_CLOEXEC | O_NOFOLLOW);
    if (descriptor < 0)
    {
        fail(path);
    }
    digest_fd(descriptor, result);
    close(descriptor);
}

static int capture(char* const* arguments, const char* path)
{
    const int descriptor = open(path, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0666);
    if (descriptor < 0)
    {
        fail(path);
    }
    fflush(NULL);
    const pid_t child = fork();
    if (child < 0)
    {
        fail("fork");
    }
    if (child == 0)
    {
        if (dup2(descriptor, STDOUT_FILENO) < 0 || dup2(descriptor, STDERR_FILENO) < 0)
        {
            _exit(126);
        }
        close(descriptor);
        execvp(arguments[0], arguments);
        _exit(127);
    }
    close(descriptor);
    int status = 0;
    pid_t waited;
    do
    {
        waited = waitpid(child, &status, 0);
    }
    while (waited < 0 && errno == EINTR);
    return waited == child && WIFEXITED(status) ? WEXITSTATUS(status) : 128 + (waited == child && WIFSIGNALED(status) ? WTERMSIG(status) : 0);
}

static int compare_sources(const void* a, const void* b)
{
    return strcmp(a, b);
}

static Plan plan_read(const char* tree, const char* path)
{
    char* const arguments[] = { "ninja", "-C", (char*)tree, "-f", "build-Release.ninja", "-n", "compiler", NULL };
    const int status = capture(arguments, path);
    if (status != 0)
    {
        errno = 0;
        fail("Ninja plan failed; raw log retained");
    }
    FILE* file = fopen(path, "rb");
    if (file == NULL)
    {
        fail(path);
    }
    Plan plan = { 0 };
    char* line = NULL;
    size_t capacity = 0;
    while (getline(&line, &capacity, file) >= 0)
    {
        unsigned finished = 0, total = 0;
        if (sscanf(line, "[%u/%u]", &finished, &total) != 2)
        {
            continue;
        }
        plan.steps += 1;
        const char* object = strstr(line, "Building C object ");
        if (object != NULL)
        {
            const char* source = strstr(object, "/src/buster/compiler/");
            const char* ending = source != NULL ? strstr(source, ".c.o") : NULL;
            if (source == NULL || ending == NULL || plan.compiles == 256 || (size_t)(ending + 2 - source - 1) >= sizeof(plan.sources[0]))
            {
                errno = 0;
                fail("unrecognized or excessive source compile in plan");
            }
            source += 1;
            const size_t length = (size_t)(ending + 2 - source);
            memcpy(plan.sources[plan.compiles], source, length);
            plan.sources[plan.compiles][length] = '\0';
            plan.unity += strstr(source, "/main.c.o") != NULL || strstr(source, "/main_unit_") != NULL;
            plan.compiles += 1;
        }
        else if (strstr(line, "Linking C executable Release/compiler.link") != NULL)
        {
            plan.links += 1;
        }
        else if (strstr(line, "Baking and checking compiler_link's executable") != NULL)
        {
            plan.bakes += 1;
        }
        else
        {
            plan.other += 1;
        }
    }
    if (ferror(file) || fclose(file) != 0)
    {
        fail("reading Ninja plan");
    }
    free(line);
    qsort(plan.sources, plan.compiles, sizeof(plan.sources[0]), compare_sources);
    for (unsigned i = 1; i < plan.compiles; i += 1)
    {
        if (strcmp(plan.sources[i - 1], plan.sources[i]) == 0)
        {
            errno = 0;
            fail("duplicate source compile in plan");
        }
    }
    return plan;
}

static void write_plan(FILE* summary, const char* sample, const char* source, const char* baseline, const char* phase, const Plan* plan)
{
    fprintf(summary, "%s\t%s\t%s\t%s\t%u\t%u\t%u\t%u\t%u\t%u\t%u\t", sample, source, baseline, phase,
            plan->steps, plan->compiles, plan->unity, plan->compiles - plan->unity, plan->links, plan->bakes, plan->other);
    for (unsigned i = 0; i < plan->compiles; i += 1)
    {
        fprintf(summary, "%s%s", i != 0 ? " " : "", plan->sources[i]);
    }
    fputc('\n', summary);
    fflush(summary);
}

int main(int argc, char** argv)
{
    int result = 0;
    if (argc == 2 && strcmp(argv[1], "--list") == 0)
    {
        puts("sample\tsource\tbaseline_container_sample\tcandidate_only");
        for (unsigned i = 0; i < sizeof(samples) / sizeof(samples[0]); i += 1)
        {
            printf("%s\tsrc/buster/compiler/%s\t%s\t%d\n", samples[i].name, samples[i].source, samples[i].baseline_container, samples[i].candidate_only);
        }
    }
    else if (argc != 6 || (strcmp(argv[4], "base") != 0 && strcmp(argv[4], "candidate") != 0))
    {
        fputs("usage: incremental-plans ROOT TREE_RELATIVE LABEL base|candidate OUTPUT_DIRECTORY\n       incremental-plans --list\n", stderr);
        result = 2;
    }
    else
    {
        char root[PATH_MAX], tree[PATH_MAX], output[PATH_MAX], path[PATH_MAX];
        if (realpath(argv[1], root) == NULL)
        {
            fail(argv[1]);
        }
        path_join(path, sizeof(path), root, argv[2]);
        if (realpath(path, tree) == NULL || strlen(tree) <= strlen(root) || strncmp(root, tree, strlen(root)) != 0 || tree[strlen(root)] != '/')
        {
            fail("tree must be inside the selected checkout");
        }
        if (strchr(argv[3], '/') != NULL || strstr(argv[3], "..") != NULL || argv[3][0] == '\0')
        {
            errno = EINVAL;
            fail("invalid result label");
        }
        if (mkdir(argv[5], 0777) != 0 && errno != EEXIST)
        {
            fail(argv[5]);
        }
        path_join(output, sizeof(output), argv[5], argv[3]);
        if (mkdir(output, 0777) != 0)
        {
            fail("result directory already exists or cannot be created; retain attempts separately");
        }
        path_join(path, sizeof(path), root, "build/.trees.lock");
        const int lock = open(path, O_RDWR | O_CLOEXEC);
        if (lock < 0 || flock(lock, LOCK_EX | LOCK_NB) != 0)
        {
            fail("build is active or tree lock is absent; no source timestamps were changed");
        }
        atexit(restore_active);
        struct sigaction action = { .sa_handler = receive_signal };
        sigemptyset(&action.sa_mask);
        sigaction(SIGINT, &action, NULL);
        sigaction(SIGTERM, &action, NULL);
        sigaction(SIGHUP, &action, NULL);
        setenv("LC_ALL", "C", 1);
        setenv("NINJA_STATUS", "[%f/%t] ", 1);
        path_join(path, sizeof(path), output, "summary.tsv");
        FILE* summary = fopen(path, "wx");
        if (summary == NULL)
        {
            fail(path);
        }
        fputs("sample\tsource\tbaseline_container_sample\tphase\tsteps\tcompiles\tunity\tstandalone\tlinks\tbakes\tother\tcompiled_sources\n", summary);
        path_join(path, sizeof(path), output, "timestamps-and-content.tsv");
        FILE* journal = fopen(path, "wx");
        if (journal == NULL)
        {
            fail(path);
        }
        fputs("sample\tphase\tsource\tdevice\tinode\tbytes\tatime_sec\tatime_nsec\tmtime_sec\tmtime_nsec\tsha256\n", journal);
        path_join(path, sizeof(path), output, "metadata.txt");
        FILE* metadata = fopen(path, "wx");
        if (metadata == NULL)
        {
            fail(path);
        }
        fprintf(metadata, "root=%s\ntree=%s\nrole=%s\nmethod=mtime-only edit; actual ninja -n compiler; no build commands executed\nrestoration=source content, inode, size, mode, atime and mtime checked; ctime changes as required by futimens\n", root, tree, argv[4]);
        char compiler[PATH_MAX], initial_digest[65], final_digest[65];
        path_join(compiler, sizeof(compiler), tree, "Release/compiler");
        struct stat compiler_before;
        if (stat(compiler, &compiler_before) != 0)
        {
            fail(compiler);
        }
        digest_path(compiler, initial_digest);
        fprintf(metadata, "compiler_sha256_before=%s\n", initial_digest);
        fflush(metadata);
        path_join(path, sizeof(path), output, "00-noop.log");
        const Plan initial = plan_read(tree, path);
        write_plan(summary, "control", "-", "-", "initial_noop", &initial);
        if (initial.steps != 0)
        {
            errno = 0;
            fail("tree is not up to date; no source timestamps were changed");
        }
        for (unsigned i = 0; i < sizeof(samples) / sizeof(samples[0]) && !interrupted; i += 1)
        {
            const Sample* sample = &samples[i];
            char relative[256], source[PATH_MAX], log_name[256];
            snprintf(relative, sizeof(relative), "src/buster/compiler/%s", sample->source);
            path_join(source, sizeof(source), root, relative);
            if (sample->candidate_only && strcmp(argv[4], "base") == 0)
            {
                if (access(source, F_OK) == 0)
                {
                    errno = 0;
                    fail("candidate-only implementation unexpectedly exists in baseline");
                }
                const Plan absent = { 0 };
                write_plan(summary, sample->name, relative, sample->baseline_container, "not_present_in_baseline", &absent);
                continue;
            }
            active_descriptor = open(source, O_RDONLY | O_CLOEXEC | O_NOFOLLOW);
            struct stat before;
            if (active_descriptor < 0 || fstat(active_descriptor, &before) != 0 || !S_ISREG(before.st_mode))
            {
                active_descriptor = -1;
                fail(source);
            }
            saved_times[0] = before.st_atim;
            saved_times[1] = before.st_mtim;
            char before_digest[65], after_digest[65];
            digest_fd(active_descriptor, before_digest);
            fprintf(journal, "%s\tbefore\t%s\t%llu\t%llu\t%lld\t%lld\t%ld\t%lld\t%ld\t%s\n", sample->name, relative,
                    (unsigned long long)before.st_dev, (unsigned long long)before.st_ino, (long long)before.st_size,
                    (long long)before.st_atim.tv_sec, before.st_atim.tv_nsec, (long long)before.st_mtim.tv_sec, before.st_mtim.tv_nsec, before_digest);
            fflush(journal);
            if (fsync(fileno(journal)) != 0)
            {
                fail("timestamp journal sync");
            }
            struct timespec touched[2] = { before.st_atim, { 0 } };
            if (clock_gettime(CLOCK_REALTIME, &touched[1]) != 0)
            {
                fail("clock_gettime");
            }
            if (!later(touched[1], compiler_before.st_mtim))
            {
                touched[1] = compiler_before.st_mtim;
                touched[1].tv_nsec += 1;
                if (touched[1].tv_nsec == 1000000000)
                {
                    touched[1].tv_sec += 1;
                    touched[1].tv_nsec = 0;
                }
            }
            if (futimens(active_descriptor, touched) != 0)
            {
                fail("touching one source timestamp");
            }
            snprintf(log_name, sizeof(log_name), "%02u-%s-edit.log", i + 1, sample->name);
            path_join(path, sizeof(path), output, log_name);
            const Plan edited = plan_read(tree, path);
            digest_fd(active_descriptor, after_digest);
            if (futimens(active_descriptor, saved_times) != 0)
            {
                fail("restoring source timestamps");
            }
            struct stat restored;
            if (fstat(active_descriptor, &restored) != 0 || before.st_dev != restored.st_dev || before.st_ino != restored.st_ino ||
                before.st_size != restored.st_size || before.st_mode != restored.st_mode || !same_time(before.st_atim, restored.st_atim) ||
                !same_time(before.st_mtim, restored.st_mtim) || strcmp(before_digest, after_digest) != 0)
            {
                errno = 0;
                fail("source content or timestamp restoration mismatch");
            }
            close(active_descriptor);
            active_descriptor = -1;
            fprintf(journal, "%s\trestored\t%s\t%llu\t%llu\t%lld\t%lld\t%ld\t%lld\t%ld\t%s\n", sample->name, relative,
                    (unsigned long long)restored.st_dev, (unsigned long long)restored.st_ino, (long long)restored.st_size,
                    (long long)restored.st_atim.tv_sec, restored.st_atim.tv_nsec, (long long)restored.st_mtim.tv_sec, restored.st_mtim.tv_nsec, after_digest);
            fflush(journal);
            write_plan(summary, sample->name, relative, sample->baseline_container, "edited", &edited);
            if (edited.compiles == 0 || edited.links != 1 || edited.bakes != 1 || edited.other != 0)
            {
                errno = 0;
                fail("edited source has an unexpected build plan; timestamp has been restored");
            }
            snprintf(log_name, sizeof(log_name), "%02u-%s-restored.log", i + 1, sample->name);
            path_join(path, sizeof(path), output, log_name);
            const Plan clean = plan_read(tree, path);
            write_plan(summary, sample->name, relative, sample->baseline_container, "restored_noop", &clean);
            if (clean.steps != 0)
            {
                errno = 0;
                fail("restoration left pending build work");
            }
        }
        digest_path(compiler, final_digest);
        struct stat compiler_after;
        if (stat(compiler, &compiler_after) != 0 || strcmp(initial_digest, final_digest) != 0 || compiler_before.st_ino != compiler_after.st_ino ||
            compiler_before.st_size != compiler_after.st_size || !same_time(compiler_before.st_mtim, compiler_after.st_mtim))
        {
            errno = 0;
            fail("compiler artifact changed during plans");
        }
        fprintf(metadata, "compiler_sha256_after=%s\nsource_restoration=passed\ncompiler_unchanged=passed\ninterrupted_signal=%d\n", final_digest, interrupted);
        if (fclose(metadata) != 0 || fclose(journal) != 0 || fclose(summary) != 0)
        {
            fail("closing evidence");
        }
        flock(lock, LOCK_UN);
        close(lock);
        result = interrupted ? 128 + interrupted : 0;
        printf("%s: %s; results=%s\n", argv[3], result == 0 ? "all edit and restoration plans captured" : "interrupted after restoration", output);
    }
    return result;
}
