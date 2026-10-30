// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Focused new Bash startup controls. All scripts/commands are C-written private
// fixtures. No repository build script, compiler, assembler or image is run.
#define _GNU_SOURCE
#include "hp_common.h"
#include <assert.h>
#include <errno.h>
#include <signal.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

#define BUSTER_BASH_ARRAY_COUNT(x) (sizeof(x) / sizeof((x)[0]))
extern char **environ;

static const char *const stripped[] =
{
    "BASH_ENV",
    "ENV",
    "BASHOPTS",
    "SHELLOPTS",
    "BASH_COMPAT",
    "POSIXLY_CORRECT",
    "BASH_ARGV0",
    "BASH_XTRACEFD",
    "CDPATH",
    "GLOBIGNORE",
    "IFS",
    "PS4",
    "EXECIGNORE",
    "FUNCNEST",
    "GLOBSORT"
};

typedef struct BashFixture BashFixture;
struct BashFixture
{
    char root[BUSTER_HP_PATH_CAPACITY];
    char script[BUSTER_HP_PATH_CAPACITY];
    char startup[BUSTER_HP_PATH_CAPACITY];
    char bin[BUSTER_HP_PATH_CAPACITY];
    char glob[BUSTER_HP_PATH_CAPACITY];
    char work[BUSTER_HP_PATH_CAPACITY];
    char alternate[BUSTER_HP_PATH_CAPACITY];
};

typedef struct BashResult BashResult;
struct BashResult
{
    const char *name;
    bool clean;
    int code;
};

static void path_join(char out[BUSTER_HP_PATH_CAPACITY], const char *root, const char *name)
{
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    bool valid = hp_join_path(out, root, name, error);
    assert(valid);
    return;
}

static void create_file(const char *path, const char *text)
{
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    HpBytes bytes =
    {
        (const unsigned char *)text,
        strlen(text)
    };
    bool valid = hp_write_file(path, bytes, error);
    assert(valid);
    return;
}

static bool file_is(const char *path, const void *expected, size_t size)
{
    HpBuffer bytes = {0};
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    bool valid = hp_read_file(path, 1024 * 1024, &bytes, error);
    valid = valid && bytes.size == size && (size == 0 || memcmp(bytes.data, expected, size) == 0);
    hp_buffer_free(&bytes);
    return valid;
}

static bool marker(const char *directory, const char *name)
{
    char path[BUSTER_HP_PATH_CAPACITY];
    path_join(path, directory, name);
    struct stat state;
    return lstat(path, &state) == 0;
}

static void fixture_create(BashFixture *f)
{
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    path_join(f->script, f->root, "synthetic API.sh");
    path_join(f->startup, f->root, "startup payload.sh");
    path_join(f->bin, f->root, "private bin");
    path_join(f->glob, f->root, "glob inputs");
    path_join(f->work, f->root, "working directory");
    path_join(f->alternate, f->root, "CDPATH directory");
    assert(hp_mkdir_new(f->bin, error));
    assert(hp_mkdir_new(f->glob, error));
    assert(hp_mkdir_new(f->work, error));
    assert(hp_mkdir_new(f->alternate, error));
    char path[BUSTER_HP_PATH_CAPACITY];
    path_join(path, f->work, "target");
    assert(hp_mkdir_new(path, error));
    path_join(path, f->alternate, "target");
    assert(hp_mkdir_new(path, error));
    static const char *const names[] =
    {
        "a1",
        "a10",
        "a2"
    };
    for (size_t i = 0; i < BUSTER_BASH_ARRAY_COUNT(names); i += 1)
    {
        path_join(path, f->glob, names[i]);
        create_file(path, "");
    }
    path_join(path, f->bin, "private-probe");
    create_file(path, "#!/bin/bash\nbuiltin printf probe > \"$TEST_DIR/exec\"\n");
    assert(chmod(path, 0700) == 0);
    create_file(f->startup, "builtin printf startup > \"$TEST_DIR/startup\"\nbuiltin printf '%s\\0' STARTUP-POLLUTION\n");
    create_file(f->script,
        "set -e\n"
        "if [[ -o posix ]] && shopt -q extglob && [[ ${BASH_COMPAT-} == 42 ]]; then builtin printf options > \"$TEST_DIR/options\"; fi\n"
        "if [[ $TEST_CASE == cdpath ]]; then (cd target; builtin pwd > \"$TEST_DIR/cd\"); fi\n"
        "if [[ $TEST_CASE == glob ]]; then (cd \"$TEST_GLOB\"; builtin printf '%s\\0' * > \"$TEST_DIR/glob\"); fi\n"
        "if [[ $TEST_CASE == lookup ]]; then private-probe; fi\n"
        "inner_fixture() { builtin printf nested > \"$TEST_DIR/nested\"; }\n"
        "outer_fixture() { inner_fixture; }\n"
        "if [[ $TEST_CASE == nesting ]]; then outer_fixture; fi\n"
        "printf '%s\\0' \"$@\"\n"
        "command printf '%s\\0' command-sentinel\n");
    return;
}

static bool environment_clean(void)
{
    bool valid = true;
    for (size_t i = 0; valid && i < BUSTER_BASH_ARRAY_COUNT(stripped); i += 1)
    {
        valid = getenv(stripped[i]) == NULL;
    }
    for (size_t i = 0; valid && environ != NULL && environ[i] != NULL; i += 1)
    {
        valid = strncmp(environ[i], "BASH_FUNC_", 10) != 0;
    }
    const char *similar = getenv("BASH_FUNCT_unrelated");
    const char *other = getenv("BASH_FUNCX_unrelated");
    valid = valid && similar != NULL && other != NULL && strcmp(similar, "keep first") == 0 && strcmp(other, "keep second") == 0;
    return valid;
}

static bool inject(const BashFixture *f, const char *name)
{
    bool valid = true;
    if (strcmp(name, "startup") == 0)
    {
        valid = setenv("BASH_ENV", "$(builtin printf expansion > \"$TEST_DIR/expansion\"; builtin printf '%s' \"$TEST_STARTUP\")", 1) == 0;
    }
    else if (strcmp(name, "ENV") == 0)
    {
        valid = setenv("ENV", f->startup, 1) == 0;
    }
    else if (strcmp(name, "functions") == 0)
    {
        valid = setenv("BASH_FUNC_printf%%", "() { builtin printf printf > \"$TEST_DIR/printf\"; builtin printf '%s\\0' PRINTF-POLLUTION; }", 1) == 0;
        valid = setenv("BASH_FUNC_command%%", "() { builtin printf command > \"$TEST_DIR/command\"; builtin printf '%s\\0' COMMAND-POLLUTION; }", 1) == 0 && valid;
        valid = setenv("BASH_FUNC_malformed", "ordinary prefix entry", 1) == 0 && setenv("BASH_FUNC_", "empty-name prefix", 1) == 0 && valid;
    }
    else if (strcmp(name, "options") == 0)
    {
        valid = setenv("SHELLOPTS", "xtrace:verbose", 1) == 0 && setenv("BASHOPTS", "extglob", 1) == 0 && setenv("BASH_COMPAT", "42", 1) == 0 && setenv("POSIXLY_CORRECT", "1", 1) == 0;
        valid = setenv("BASH_XTRACEFD", "1", 1) == 0 && setenv("PS4", "$(builtin printf trace > \"$TEST_DIR/trace\")TRACE> ", 1) == 0 && valid;
    }
    else if (strcmp(name, "extdebug") == 0)
    {
        valid = setenv("BASHOPTS", "extdebug", 1) == 0;
    }
    else if (strcmp(name, "cdpath") == 0)
    {
        valid = setenv("CDPATH", f->alternate, 1) == 0;
    }
    else if (strcmp(name, "glob") == 0)
    {
        valid = setenv("GLOBIGNORE", "a10", 1) == 0 && setenv("GLOBSORT", "-name", 1) == 0;
    }
    else if (strcmp(name, "lookup") == 0)
    {
        char path[BUSTER_HP_PATH_CAPACITY];
        path_join(path, f->bin, "private-probe");
        valid = setenv("EXECIGNORE", path, 1) == 0;
    }
    else if (strcmp(name, "nesting") == 0)
    {
        valid = setenv("FUNCNEST", "1", 1) == 0;
    }
    return valid;
}

static bool argv_equal(const char *stem, const char *const *values, size_t count)
{
    char path[BUSTER_HP_PATH_CAPACITY];
    int size = snprintf(path, sizeof(path), "%s.argv.nul", stem);
    assert(size > 0 && (size_t)size < sizeof(path));
    HpBuffer bytes = {0};
    HpArguments actual = {0};
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    bool valid = hp_read_file(path, 16384, &bytes, error);
    HpBytes input =
    {
        bytes.data,
        bytes.size
    };
    valid = valid && hp_arguments_read(input, &actual, error) && actual.count == count;
    for (size_t i = 0; valid && i < count; i += 1)
    {
        valid = strcmp(actual.values[i], values[i]) == 0;
    }
    hp_arguments_free(&actual);
    hp_buffer_free(&bytes);
    return valid;
}

static int worker(const BashFixture *f, const char *name, bool clean, const char *directory)
{
    bool valid = clearenv() == 0;
    char path[BUSTER_HP_PATH_CAPACITY];
    int size = snprintf(path, sizeof(path), "%s:/usr/bin:/bin", f->bin);
    assert(size > 0 && (size_t)size < sizeof(path));
    valid = setenv("PATH", path, 1) == 0 && setenv("HOME", f->root, 1) == 0 && setenv("LC_ALL", "C", 1) == 0 && valid;
    valid = setenv("TEST_DIR", directory, 1) == 0 && setenv("TEST_CASE", name, 1) == 0 && setenv("TEST_STARTUP", f->startup, 1) == 0 && setenv("TEST_GLOB", f->glob, 1) == 0 && valid;
    valid = setenv("BASH_FUNCT_unrelated", "keep first", 1) == 0 && setenv("BASH_FUNCX_unrelated", "keep second", 1) == 0 && valid;
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    bool edge = strcmp(name, "strip-all") == 0 || strcmp(name, "key4095") == 0 || strcmp(name, "key4096") == 0 || strcmp(name, "no-equals") == 0;
    int result = 31;
    if (edge)
    {
        if (strcmp(name, "strip-all") == 0)
        {
            for (size_t i = 0; valid && i < BUSTER_BASH_ARRAY_COUNT(stripped); i += 1)
            {
                valid = setenv(stripped[i], "inherited input", 1) == 0;
            }
            valid = inject(f, "functions") && valid;
        }
        else if (strcmp(name, "no-equals") != 0)
        {
            char key[BUSTER_HP_PATH_CAPACITY + 1];
            memset(key, 'a', sizeof(key));
            memcpy(key, "BASH_FUNC_", 10);
            key[strcmp(name, "key4095") == 0 ? 4095 : 4096] = 0;
            valid = setenv(key, "ordinary prefix", 1) == 0 && valid;
        }
        char *raw[] =
        {
            "BASH_FUNC_malformed_without_equals",
            NULL
        };
        if (strcmp(name, "no-equals") == 0)
        {
            environ = raw;
        }
        bool prepared = valid && hp_prepare_environment("/private synthetic toolchain", error);
        bool refusal = strcmp(name, "key4096") == 0 || strcmp(name, "no-equals") == 0;
        bool passed = valid && (refusal ? !prepared && error[0] != 0 : prepared && environment_clean());
        result = passed ? 0 : 32;
    }
    else
    {
        valid = inject(f, name) && valid;
        bool prepared = !clean || (valid && hp_prepare_environment("/private synthetic toolchain", error));
        bool cleared = !clean || (prepared && environment_clean());
        const char *normal[] =
        {
            "/bin/bash",
            f->script,
            "argument with spaces",
            "literal;$(not executed)",
            NULL
        };
        const char *interactive[] =
        {
            "/bin/bash",
            "--noprofile",
            "--norc",
            "--posix",
            "-i",
            f->script,
            "argument with spaces",
            "literal;$(not executed)",
            NULL
        };
        bool env_case = strcmp(name, "ENV") == 0;
        const char *const *arguments = env_case ? interactive : normal;
        size_t count = env_case ? 8 : 4;
        char stem[BUSTER_HP_PATH_CAPACITY];
        path_join(stem, directory, "bash");
        int code = -1;
        bool ran = valid && prepared && hp_run(arguments, f->work, stem, true, &code, error);
        char out[BUSTER_HP_PATH_CAPACITY];
        char err[BUSTER_HP_PATH_CAPACITY];
        size = snprintf(out, sizeof(out), "%s.stdout", stem);
        assert(size > 0 && (size_t)size < sizeof(out));
        size = snprintf(err, sizeof(err), "%s.stderr", stem);
        assert(size > 0 && (size_t)size < sizeof(err));
        static const unsigned char expected[] = "argument with spaces\0literal;$(not executed)\0command-sentinel\0";
        bool exact = file_is(out, expected, sizeof(expected) - 1);
        bool quiet = file_is(err, NULL, 0);
        bool effect = clean ? cleared && ran && code == 0 && exact && (quiet || env_case) : false;
        if (!clean && strcmp(name, "startup") == 0)
        {
            effect = ran && code == 0 && !exact && marker(directory, "startup") && marker(directory, "expansion");
        }
        else if (!clean && env_case)
        {
            effect = ran && code == 0 && !exact && marker(directory, "startup");
        }
        else if (!clean && strcmp(name, "functions") == 0)
        {
            effect = ran && code == 0 && !exact && marker(directory, "printf") && marker(directory, "command");
        }
        else if (!clean && strcmp(name, "options") == 0)
        {
            effect = ran && code == 0 && !exact && !quiet && marker(directory, "trace") && marker(directory, "options");
        }
        else if (!clean && strcmp(name, "extdebug") == 0)
        {
            effect = ran && code == 0 && exact && !quiet;
        }
        else if (!clean && strcmp(name, "lookup") == 0)
        {
            effect = !ran && code == 127 && !exact && !marker(directory, "exec");
        }
        else if (!clean && strcmp(name, "nesting") == 0)
        {
            effect = !ran && code != 0 && !exact && !marker(directory, "nested");
        }
        else if (!clean && (strcmp(name, "cdpath") == 0 || strcmp(name, "glob") == 0))
        {
            effect = ran && code == 0 && (strcmp(name, "glob") == 0 ? exact : !exact);
        }
        if (clean)
        {
            static const char *const forbidden[] =
            {
                "startup",
                "expansion",
                "printf",
                "command",
                "trace",
                "options"
            };
            for (size_t i = 0; effect && i < BUSTER_BASH_ARRAY_COUNT(forbidden); i += 1)
            {
                effect = !marker(directory, forbidden[i]);
            }
        }
        if (strcmp(name, "cdpath") == 0)
        {
            path_join(path, clean ? f->work : f->alternate, "target");
            size_t length = strlen(path);
            path[length++] = '\n';
            char cd_marker[BUSTER_HP_PATH_CAPACITY];
            path_join(cd_marker, directory, "cd");
            effect = effect && file_is(cd_marker, path, length);
        }
        if (strcmp(name, "glob") == 0)
        {
            static const unsigned char ascending[] = "a1\0a10\0a2\0";
            static const unsigned char filtered_reverse[] = "a2\0a1\0";
            char glob_marker[BUSTER_HP_PATH_CAPACITY];
            path_join(glob_marker, directory, "glob");
            effect = effect && file_is(glob_marker, clean ? ascending : filtered_reverse, clean ? sizeof(ascending) - 1 : sizeof(filtered_reverse) - 1);
        }
        if (clean && strcmp(name, "lookup") == 0)
        {
            effect = effect && marker(directory, "exec");
        }
        if (clean && strcmp(name, "nesting") == 0)
        {
            effect = effect && marker(directory, "nested");
        }
        char status_path[BUSTER_HP_PATH_CAPACITY];
        size = snprintf(status_path, sizeof(status_path), "%s.status", stem);
        assert(size > 0 && (size_t)size < sizeof(status_path));
        char status[32];
        size = snprintf(status, sizeof(status), "%d\n", code);
        assert(size > 0 && (size_t)size < sizeof(status));
        bool passed = valid && prepared && effect && argv_equal(stem, arguments, count) && file_is(status_path, status, (size_t)size);
        path_join(path, directory, "worker-report.txt");
        FILE *report = fopen(path, "wx");
        if (report != NULL)
        {
            fprintf(report, "setup=%d prepare=%d cleared=%d ran=%d code=%d stdout_exact=%d stderr_empty=%d effect=%d passed=%d\nerror=%s\n", valid, prepared, cleared, ran, code, exact, quiet, effect, passed, error);
            passed = fclose(report) == 0 && passed;
        }
        else
        {
            passed = false;
        }
        result = passed ? 0 : 33;
    }
    return result;
}

int main(int argc, char **argv)
{
    int result = 2;
    if (argc == 3 && strcmp(argv[1], "--output") == 0)
    {
        BashFixture f = {0};
        struct stat debugger;
        bool ready = mkdir(argv[2], 0700) == 0 && realpath(argv[2], f.root) != NULL && lstat("/usr/share/bashdb/bashdb-main.inc", &debugger) != 0 && errno == ENOENT;
        if (ready)
        {
            fixture_create(&f);
            static const char *const cases[] =
            {
                "startup",
                "ENV",
                "functions",
                "options",
                "extdebug",
                "cdpath",
                "glob",
                "lookup",
                "nesting",
                "strip-all",
                "key4095",
                "key4096",
                "no-equals"
            };
            BashResult records[32] = {0};
            size_t used = 0;
            size_t failures = 0;
            const char *before = getenv("PATH");
            char *saved = before != NULL ? strdup(before) : NULL;
            for (size_t i = 0; i < BUSTER_BASH_ARRAY_COUNT(cases); i += 1)
            {
                size_t phases = i < 9 ? 2 : 1;
                for (size_t phase = 0; phase < phases; phase += 1)
                {
                    bool clean = phases == 1 || phase != 0;
                    char leaf[80];
                    int size = snprintf(leaf, sizeof(leaf), "%s-%s", cases[i], clean ? "clean" : "dirty");
                    assert(size > 0 && (size_t)size < sizeof(leaf));
                    char directory[BUSTER_HP_PATH_CAPACITY];
                    path_join(directory, f.root, leaf);
                    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
                    assert(hp_mkdir_new(directory, error));
                    pid_t child = fork();
                    assert(child >= 0);
                    if (child == 0)
                    {
                        signal(SIGALRM, SIG_DFL);
                        alarm(5);
                        int code = worker(&f, cases[i], clean, directory);
                        _exit(code);
                    }
                    int code = -1;
                    bool waited = hp_wait(child, &code, error);
                    records[used].name = cases[i];
                    records[used].clean = clean;
                    records[used++].code = waited ? code : -1;
                    failures += !waited || code != 0;
                    printf("%s %s %s (worker=%d)\n", waited && code == 0 ? "PASS" : "FAIL", cases[i], clean ? "clean" : "dirty-positive", code);
                }
            }
            const char *after = getenv("PATH");
            bool unchanged = before == NULL ? after == NULL : saved != NULL && after != NULL && strcmp(saved, after) == 0;
            free(saved);
            failures += !unchanged;
            char path[BUSTER_HP_PATH_CAPACITY];
            path_join(path, f.root, "results.json");
            FILE *json = fopen(path, "wx");
            bool written = json != NULL;
            if (written)
            {
                fprintf(json, "{\n  \"cases\": %zu,\n  \"failures\": %zu,\n  \"parent_PATH_unchanged\": %s,\n  \"results\": [\n", used + 1, failures, unchanged ? "true" : "false");
                for (size_t i = 0; i < used; i += 1)
                {
                    fprintf(json, "    {\"name\": \"%s\", \"clean\": %s, \"worker_code\": %d, \"passed\": %s}%s\n", records[i].name, records[i].clean ? "true" : "false", records[i].code, records[i].code == 0 ? "true" : "false", i + 1 < used ? "," : "");
                }
                fputs("  ]\n}\n", json);
                written = ferror(json) == 0;
                written = fclose(json) == 0 && written;
            }
            printf("Private Bash controls: %zu cases, %zu failures; only private scripts and /bin/bash, no producer.\n", used + 1, failures);
            result = failures != 0 || !written ? 1 : 0;
        }
        else
        {
            fprintf(stderr, "fresh directory and absent system Bash debugger profile required\n");
        }
    }
    else
    {
        fprintf(stderr, "usage: bash-environment-controls --output NEW_DIRECTORY\n");
    }
    return result;
}
