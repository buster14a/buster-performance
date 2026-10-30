// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Original, bounded controls for hp_common. Fixtures are private temporary
// files and C self-child modes; no compiler, assembler or target image is run.
#define _GNU_SOURCE
#include "hp_common.h"

#include <assert.h>
#include <errno.h>
#include <limits.h>
#include <signal.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

#define BUSTER_COMMON_CONTROL_LIMIT 160U
#define BUSTER_COMMON_ABC_SHA "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"
#define BUSTER_COMMON_EMPTY_SHA "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
#define BUSTER_COMMON_ARRAY_COUNT(values) (sizeof(values) / sizeof((values)[0]))

typedef struct CommonResult CommonResult;
struct CommonResult
{
    const char *name;
    bool expected;
    bool accepted;
    bool passed;
    char error[BUSTER_HP_ERROR_CAPACITY];
};

typedef struct CommonSuite CommonSuite;
struct CommonSuite
{
    CommonResult results[BUSTER_COMMON_CONTROL_LIMIT];
    size_t count;
    size_t failures;
    char root[BUSTER_HP_PATH_CAPACITY];
    char self[BUSTER_HP_PATH_CAPACITY];
};

static void common_record(CommonSuite *suite, const char *name, bool expected, bool accepted, const char *error)
{
    assert(suite->count < BUSTER_COMMON_ARRAY_COUNT(suite->results));
    CommonResult *result = &suite->results[suite->count++];
    result->name = name;
    result->expected = expected;
    result->accepted = accepted;
    result->passed = expected == accepted;
    snprintf(result->error, sizeof(result->error), "%s", error);
    suite->failures += !result->passed;
    printf("%s %s%s%s\n", result->passed ? "PASS" : "FAIL", name, !result->passed ? ": " : "", !result->passed ? error : "");
    return;
}

static void common_path(CommonSuite *suite, char output[BUSTER_HP_PATH_CAPACITY], const char *name)
{
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    bool ok = hp_join_path(output, suite->root, name, error);
    assert(ok);
    return;
}

static void common_create(const char *path, const void *bytes, size_t size)
{
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    HpBytes input =
    {
        bytes,
        size
    };
    bool ok = hp_write_file(path, input, error);
    assert(ok);
    return;
}

static bool common_read_is(const char *path, const void *bytes, size_t size)
{
    HpBuffer buffer = {0};
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    bool ok = hp_read_file(path, BUSTER_HP_FILE_LIMIT, &buffer, error);
    ok = ok && buffer.size == size && (size == 0 || memcmp(buffer.data, bytes, size) == 0);
    hp_buffer_free(&buffer);
    return ok;
}

static void common_files(CommonSuite *suite)
{
    char abc[BUSTER_HP_PATH_CAPACITY];
    char copy[BUSTER_HP_PATH_CAPACITY];
    char different[BUSTER_HP_PATH_CAPACITY];
    char short_file[BUSTER_HP_PATH_CAPACITY];
    char empty[BUSTER_HP_PATH_CAPACITY];
    char missing[BUSTER_HP_PATH_CAPACITY];
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    common_path(suite, abc, "input with spaces.bin");
    common_path(suite, copy, "equal copy.bin");
    common_path(suite, different, "different.bin");
    common_path(suite, short_file, "short.bin");
    common_path(suite, empty, "empty.bin");
    common_path(suite, missing, "missing-file");
    common_create(abc, "abc", 3);
    common_create(copy, "abc", 3);
    common_create(different, "abd", 3);
    common_create(short_file, "ab", 2);
    common_create(empty, NULL, 0);
    common_record(suite, "files-equal-paths-with-spaces", true, hp_files_equal(abc, copy, error), error);
    common_record(suite, "files-different-bytes", false, hp_files_equal(abc, different, error), error);
    common_record(suite, "files-different-lengths", false, hp_files_equal(abc, short_file, error), error);
    common_record(suite, "files-missing", false, hp_files_equal(abc, missing, error), error);
    common_record(suite, "files-empty", true, hp_files_equal(empty, empty, error), error);
    char digest[65] = {0};
    bool ok = hp_sha256_file(abc, digest, error);
    common_record(suite, "sha256-known-abc-path-spaces", true, ok && strcmp(digest, BUSTER_COMMON_ABC_SHA) == 0, error);
    ok = hp_sha256_file(empty, digest, error);
    common_record(suite, "sha256-known-empty", true, ok && strcmp(digest, BUSTER_COMMON_EMPTY_SHA) == 0, error);
    common_record(suite, "sha256-missing-file", false, hp_sha256_file(missing, digest, error), error);
    HpBuffer buffer = {0};
    ok = hp_read_file(abc, 3, &buffer, error);
    common_record(suite, "read-exact-limit-and-sentinel", true, ok && buffer.size == 3 && memcmp(buffer.data, "abc", 3) == 0 && buffer.data[3] == 0, error);
    hp_buffer_free(&buffer);
    ok = hp_read_file(abc, 2, &buffer, error);
    common_record(suite, "read-over-limit-empty-output", true, !ok && buffer.data == NULL && buffer.size == 0, error);
    ok = hp_read_file(empty, 1, &buffer, error);
    common_record(suite, "read-empty-with-sentinel", true, ok && buffer.size == 0 && buffer.data != NULL && buffer.data[0] == 0, error);
    hp_buffer_free(&buffer);
    common_record(suite, "read-zero-limit", false, hp_read_file(abc, 0, &buffer, error), error);
    common_record(suite, "read-size-max-limit", false, hp_read_file(abc, SIZE_MAX, &buffer, error), error);
    common_record(suite, "read-missing-file", false, hp_read_file(missing, 4, &buffer, error), error);
    common_record(suite, "buffer-free-resets-output", true, buffer.data == NULL && buffer.size == 0, "");
    unsigned char growing[9001];
    for (size_t i = 0; i < sizeof(growing); i += 1)
    {
        growing[i] = (unsigned char)(i * 17U);
    }
    char growth_file[BUSTER_HP_PATH_CAPACITY];
    common_path(suite, growth_file, "read growth.bin");
    common_create(growth_file, growing, sizeof(growing));
    ok = hp_read_file(growth_file, sizeof(growing), &buffer, error);
    common_record(suite, "read-growth-exact-limit-binary-content", true, ok && buffer.size == sizeof(growing) && memcmp(buffer.data, growing, sizeof(growing)) == 0 && buffer.data[sizeof(growing)] == 0, error);
    hp_buffer_free(&buffer);
    unsigned char *late = malloc(131073);
    assert(late != NULL);
    memset(late, 'a', 131073);
    char late_a[BUSTER_HP_PATH_CAPACITY];
    char late_b[BUSTER_HP_PATH_CAPACITY];
    common_path(suite, late_a, "identity late-a.bin");
    common_path(suite, late_b, "identity late-b.bin");
    common_create(late_a, late, 131073);
    late[131072] = 'b';
    common_create(late_b, late, 131073);
    free(late);
    common_record(suite, "identity-late-byte-after-two-full-chunks", false, hp_files_equal(late_a, late_b, error), error);
    HpBytes bytes =
    {
        (const unsigned char *)"changed",
        7
    };
    ok = hp_write_file(abc, bytes, error);
    common_record(suite, "write-refuses-existing-and-preserves-bytes", true, !ok && common_read_is(abc, "abc", 3), error);
    char new_empty[BUSTER_HP_PATH_CAPACITY];
    common_path(suite, new_empty, "new-empty.bin");
    bytes.data = NULL;
    bytes.size = 0;
    ok = hp_write_file(new_empty, bytes, error);
    common_record(suite, "write-empty-null-slice", true, ok && common_read_is(new_empty, NULL, 0), error);
    char bad_write[BUSTER_HP_PATH_CAPACITY];
    common_path(suite, bad_write, "refused-overflow-write.bin");
    bytes.data = (const unsigned char *)"x";
    bytes.size = SIZE_MAX;
    ok = hp_write_file(bad_write, bytes, error);
    struct stat state;
    common_record(suite, "write-overflow-rejected-before-create", true, !ok && lstat(bad_write, &state) != 0 && errno == ENOENT, error);
    common_path(suite, bad_write, "refused-null-write.bin");
    bytes.data = NULL;
    bytes.size = 1;
    ok = hp_write_file(bad_write, bytes, error);
    common_record(suite, "write-null-nonempty-rejected-before-create", true, !ok && lstat(bad_write, &state) != 0 && errno == ENOENT, error);
    char joined[BUSTER_HP_PATH_CAPACITY];
    ok = hp_join_path(joined, suite->root, "a name with spaces", error);
    common_record(suite, "join-path-spaces", true, ok && strstr(joined, "/a name with spaces") != NULL, error);
    char huge[BUSTER_HP_PATH_CAPACITY + 1];
    memset(huge, 'x', sizeof(huge) - 1);
    huge[sizeof(huge) - 1] = 0;
    common_record(suite, "join-path-overflow", false, hp_join_path(joined, suite->root, huge, error), error);
    char directory[BUSTER_HP_PATH_CAPACITY];
    common_path(suite, directory, "fresh directory");
    common_record(suite, "mkdir-new-path-spaces", true, hp_mkdir_new(directory, error), error);
    common_record(suite, "mkdir-refuses-existing", false, hp_mkdir_new(directory, error), error);
    return;
}

static void common_arguments_case(CommonSuite *suite, const char *name, const unsigned char *data, size_t size, bool expected)
{
    HpBytes input =
    {
        data,
        size
    };
    HpArguments arguments = {0};
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    bool accepted = hp_arguments_read(input, &arguments, error);
    common_record(suite, name, expected, accepted, error);
    hp_arguments_free(&arguments);
    return;
}

static void common_arguments(CommonSuite *suite)
{
    static const unsigned char valid[] = "-O3\0-Ipath with spaces\0";
    common_arguments_case(suite, "arguments-valid-nul-path-spaces", valid, sizeof(valid) - 1, true);
    common_arguments_case(suite, "arguments-empty-buffer", (const unsigned char *)"", 0, false);
    common_arguments_case(suite, "arguments-single-empty", (const unsigned char *)"\0", 1, false);
    common_arguments_case(suite, "arguments-no-final-nul", (const unsigned char *)"-O3", 3, false);
    common_arguments_case(suite, "arguments-trailing-empty", (const unsigned char *)"x\0\0", 3, false);
    common_arguments_case(suite, "arguments-interior-empty", (const unsigned char *)"x\0\0y\0", 5, false);
    common_arguments_case(suite, "arguments-trailing-partial", (const unsigned char *)"x\0y", 3, false);
    common_arguments_case(suite, "arguments-null-nonzero", NULL, 3, false);
    common_arguments_case(suite, "arguments-size-overflow", (const unsigned char *)"x", SIZE_MAX, false);
    unsigned char many[(BUSTER_HP_ARGUMENT_LIMIT + 1) * 2];
    for (size_t i = 0; i < sizeof(many); i += 2)
    {
        many[i] = 'x';
        many[i + 1] = 0;
    }
    common_arguments_case(suite, "arguments-exact-count-bound", many, BUSTER_HP_ARGUMENT_LIMIT * 2, true);
    common_arguments_case(suite, "arguments-over-count-bound", many, sizeof(many), false);
    HpArguments arguments = {0};
    HpBytes input =
    {
        valid,
        sizeof(valid) - 1
    };
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    bool ok = hp_arguments_read(input, &arguments, error);
    common_record(suite, "arguments-preserve-values-terminator", true, ok && arguments.count == 2 && strcmp(arguments.values[0], "-O3") == 0 && strcmp(arguments.values[1], "-Ipath with spaces") == 0 && arguments.values[2] == NULL, error);
    hp_arguments_free(&arguments);
    common_record(suite, "arguments-free-resets-output", true, arguments.storage == NULL && arguments.values == NULL && arguments.count == 0, "");
    char record[BUSTER_HP_PATH_CAPACITY];
    common_path(suite, record, "recorded arguments.nul");
    const char *values[] =
    {
        "program path with spaces",
        "literal ; $(not a shell) *",
        "--argument=two words",
        NULL
    };
    ok = hp_record_arguments(record, values, error);
    static const unsigned char expected[] = "program path with spaces\0literal ; $(not a shell) *\0--argument=two words\0";
    common_record(suite, "record-arguments-exact-nul-no-shell", true, ok && common_read_is(record, expected, sizeof(expected) - 1), error);
    common_record(suite, "record-arguments-refuses-overwrite", false, hp_record_arguments(record, values, error), error);
    return;
}

static void common_flag_case(CommonSuite *suite, const char *name, const char *const *values, size_t count, bool expected)
{
    HpArguments arguments = {0};
    arguments.values = (char **)values;
    arguments.count = count;
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    common_record(suite, name, expected, hp_validate_flags(&arguments, error), error);
    return;
}

static void common_flags(CommonSuite *suite)
{
    static const char *const original[] =
    {
        "-march=znver5",
        "-Isrc",
        "-fwrapv",
        "-funsigned-char",
        "-fno-strict-aliasing",
        "-Wall",
        "-Werror",
        "-DBUSTER_CLANG_DEFAULT_TARGET=\"x86_64-unknown-linux-gnu\"",
        "-O3"
    };
    common_flag_case(suite, "flags-reviewed-original-znver5-O3", original, BUSTER_COMMON_ARRAY_COUNT(original), true);
    static const struct
    {
        const char *name;
        const char *flag;
    } bad[] =
    {
        {
            "flags-additional-ISA",
            "-mavx512f"
        },
        {
            "flags-other-host",
            "-march=native"
        },
        {
            "flags-debug",
            "-g"
        },
        {
            "flags-debug0",
            "-g0"
        },
        {
            "flags-SAN",
            "-fsanitize=address"
        },
        {
            "flags-fragment-TRACE",
            "-DBUSTER_CHECK_LOWER_FRAGMENT_TRACE=1"
        },
        {
            "flags-FUZZ",
            "-DBUSTER_FUZZ_ENTRY=1"
        },
        {
            "flags-later-O0",
            "-O0"
        },
        {
            "flags-response-file",
            "@unreviewed.rsp"
        },
        {
            "flags-driver-config",
            "--config=unreviewed.cfg"
        },
        {
            "flags-target-override",
            "--target=aarch64-unknown-linux-gnu"
        }
    };
    for (size_t i = 0; i < BUSTER_COMMON_ARRAY_COUNT(bad); i += 1)
    {
        const char *values[] =
        {
            "-march=znver5",
            "-O3",
            bad[i].flag
        };
        common_flag_case(suite, bad[i].name, values, BUSTER_COMMON_ARRAY_COUNT(values), false);
    }
    const char *no_host[] =
    {
        "-O3"
    };
    common_flag_case(suite, "flags-missing-host", no_host, BUSTER_COMMON_ARRAY_COUNT(no_host), false);
    const char *no_opt[] =
    {
        "-march=znver5"
    };
    common_flag_case(suite, "flags-missing-O3", no_opt, BUSTER_COMMON_ARRAY_COUNT(no_opt), false);
    const char *duplicate_host[] =
    {
        "-march=znver5",
        "-march=znver5",
        "-O3"
    };
    common_flag_case(suite, "flags-duplicate-host", duplicate_host, BUSTER_COMMON_ARRAY_COUNT(duplicate_host), false);
    const char *passthrough[] =
    {
        "-march=znver5",
        "-O3",
        "-Xclang",
        "-target-feature",
        "-Xclang",
        "+avx2"
    };
    common_flag_case(suite, "flags-ISA-driver-passthrough", passthrough, BUSTER_COMMON_ARRAY_COUNT(passthrough), false);
    return;
}

static void common_manifest_case(CommonSuite *suite, const char *name, const char *tree, const void *text, size_t size, bool expected)
{
    char manifest[BUSTER_HP_PATH_CAPACITY];
    char leaf[80];
    int length = snprintf(leaf, sizeof(leaf), "source-manifest-%zu.sha256", suite->count);
    assert(length > 0 && (size_t)length < sizeof(leaf));
    common_path(suite, manifest, leaf);
    common_create(manifest, text, size);
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    common_record(suite, name, expected, hp_verify_sources(tree, manifest, error), error);
    return;
}

static void common_sources(CommonSuite *suite)
{
    char tree[BUSTER_HP_PATH_CAPACITY];
    char source[BUSTER_HP_PATH_CAPACITY];
    char outside[BUSTER_HP_PATH_CAPACITY];
    char link[BUSTER_HP_PATH_CAPACITY];
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    common_path(suite, tree, "source tree with spaces");
    assert(hp_mkdir_new(tree, error));
    assert(hp_join_path(source, tree, "input name.c", error));
    common_create(source, "abc", 3);
    static const char valid[] = BUSTER_COMMON_ABC_SHA "  input name.c\n";
    common_manifest_case(suite, "sources-valid-path-spaces", tree, valid, sizeof(valid) - 1, true);
    static const char no_newline[] = BUSTER_COMMON_ABC_SHA "  input name.c";
    common_manifest_case(suite, "sources-final-newline-optional", tree, no_newline, sizeof(no_newline) - 1, true);
    common_manifest_case(suite, "sources-empty-manifest", tree, "", 0, false);
    static const char duplicate[] = BUSTER_COMMON_ABC_SHA "  input name.c\n" BUSTER_COMMON_ABC_SHA "  input name.c\n";
    common_manifest_case(suite, "sources-duplicate-path", tree, duplicate, sizeof(duplicate) - 1, false);
    static const char changed[] = BUSTER_COMMON_EMPTY_SHA "  input name.c\n";
    common_manifest_case(suite, "sources-changed-content", tree, changed, sizeof(changed) - 1, false);
    static const char missing[] = BUSTER_COMMON_ABC_SHA "  missing.c\n";
    common_manifest_case(suite, "sources-missing-file", tree, missing, sizeof(missing) - 1, false);
    static const char traversal[] = BUSTER_COMMON_ABC_SHA "  ../input name.c\n";
    common_manifest_case(suite, "sources-traversal", tree, traversal, sizeof(traversal) - 1, false);
    static const char absolute[] = BUSTER_COMMON_ABC_SHA "  /etc/passwd\n";
    common_manifest_case(suite, "sources-absolute", tree, absolute, sizeof(absolute) - 1, false);
    static const char blank[] = BUSTER_COMMON_ABC_SHA "  input name.c\n\n";
    common_manifest_case(suite, "sources-blank-line", tree, blank, sizeof(blank) - 1, false);
    static const char nul[] = BUSTER_COMMON_ABC_SHA "  input\0name.c\n";
    common_manifest_case(suite, "sources-embedded-NUL", tree, nul, sizeof(nul) - 1, false);
    static const char bad_digest[] = "za7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad  input name.c\n";
    common_manifest_case(suite, "sources-malformed-digest", tree, bad_digest, sizeof(bad_digest) - 1, false);
    common_path(suite, outside, "outside sources");
    assert(hp_mkdir_new(outside, error));
    assert(hp_join_path(source, outside, "escaped.c", error));
    common_create(source, "abc", 3);
    assert(hp_join_path(link, tree, "parent-link", error));
    assert(symlink(outside, link) == 0);
    static const char parent_link[] = BUSTER_COMMON_ABC_SHA "  parent-link/escaped.c\n";
    common_manifest_case(suite, "sources-parent-symlink-escape", tree, parent_link, sizeof(parent_link) - 1, false);
    assert(hp_join_path(link, tree, "file-link.c", error));
    assert(symlink(source, link) == 0);
    static const char final_link[] = BUSTER_COMMON_ABC_SHA "  file-link.c\n";
    common_manifest_case(suite, "sources-final-symlink", tree, final_link, sizeof(final_link) - 1, false);
    char internal[BUSTER_HP_PATH_CAPACITY];
    assert(hp_join_path(internal, tree, "internal real", error));
    assert(hp_mkdir_new(internal, error));
    assert(hp_join_path(source, internal, "inside.c", error));
    common_create(source, "abc", 3);
    assert(hp_join_path(link, tree, "internal-link", error));
    assert(symlink(internal, link) == 0);
    static const char internal_link[] = BUSTER_COMMON_ABC_SHA "  internal-link/inside.c\n";
    common_manifest_case(suite, "sources-internal-parent-symlink-alias", tree, internal_link, sizeof(internal_link) - 1, false);
    return;
}

static int common_child_environment(bool empty_path)
{
    static const char *const cleared[] =
    {
        "CPATH",
        "C_INCLUDE_PATH",
        "CPLUS_INCLUDE_PATH",
        "LIBRARY_PATH",
        "CFLAGS",
        "CXXFLAGS",
        "CPPFLAGS",
        "LDFLAGS",
        "BUSTER_HOST_RUNTIME",
        "BUSTER_FUZZ_AVAILABLE",
        "BUSTER_FUZZ_ENTRY",
        "BUSTER_SANITIZER_OPTIMIZATION",
        "CCC_OVERRIDE_OPTIONS",
        "COMPILER_PATH",
        "GCC_EXEC_PREFIX",
        "LD_PRELOAD",
        "LD_AUDIT"
    };
    bool ok = true;
    for (size_t i = 0; i < BUSTER_COMMON_ARRAY_COUNT(cleared); i += 1)
    {
        ok = setenv(cleared[i], "must be cleared", 1) == 0 && ok;
    }
    ok = setenv("BUSTER_COMMON_KEEP", "unchanged", 1) == 0 && ok;
    ok = (empty_path ? unsetenv("PATH") : setenv("PATH", "/old/bin:/old path/bin", 1)) == 0 && ok;
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    const char *toolchain = "/private toolchain/clang23";
    ok = hp_prepare_environment(toolchain, error) && ok;
    for (size_t i = 0; ok && i < BUSTER_COMMON_ARRAY_COUNT(cleared); i += 1)
    {
        ok = getenv(cleared[i]) == NULL;
    }
    static const char *const names[] =
    {
        "BUSTER_HOST_ARCH",
        "BUSTER_DEBUG_INFO",
        "BUSTER_SANITIZER",
        "BUSTER_LINKER",
        "LC_ALL",
        "LC_NUMERIC",
        "SOURCE_DATE_EPOCH",
        "LD_LIBRARY_PATH",
        "BUSTER_CLANG_RESOURCE_DIR",
        "BUSTER_COMMON_KEEP"
    };
    static const char *const values[] =
    {
        "znver5",
        "0",
        "none",
        "/usr/bin/wild",
        "C",
        "C",
        "1792454400",
        "/private toolchain/clang23/lib",
        "/private toolchain/clang23/lib/clang/23",
        "unchanged"
    };
    for (size_t i = 0; ok && i < BUSTER_COMMON_ARRAY_COUNT(names); i += 1)
    {
        const char *actual = getenv(names[i]);
        ok = actual != NULL && strcmp(actual, values[i]) == 0;
    }
    const char *path = getenv("PATH");
    const char *expected = empty_path ? "/private toolchain/clang23/bin:/usr/bin:/bin" : "/private toolchain/clang23/bin:/old/bin:/old path/bin";
    ok = ok && path != NULL && strcmp(path, expected) == 0;
    printf("environment %s\n", ok ? "verified" : "failed");
    return ok ? 0 : 23;
}

static int common_child_closed_stdio(int argc, char **argv)
{
    bool ready = argc == 6;
    if (ready)
    {
        close(STDOUT_FILENO);
        close(STDERR_FILENO);
        if (strcmp(argv[5], "all") == 0)
        {
            close(STDIN_FILENO);
        }
        char digest[65] = {0};
        char error[BUSTER_HP_ERROR_CAPACITY] = {0};
        ready = hp_sha256_file(argv[4], digest, error) && strcmp(digest, BUSTER_COMMON_ABC_SHA) == 0;
        const char *arguments[] =
        {
            argv[0],
            "--child-mode",
            "zero",
            "closed captures",
            NULL
        };
        int code = -1;
        ready = hp_run(arguments, NULL, argv[3], true, &code, error) && code == 0 && ready;
        char out[BUSTER_HP_PATH_CAPACITY];
        char err[BUSTER_HP_PATH_CAPACITY];
        int out_size = snprintf(out, sizeof(out), "%s.stdout", argv[3]);
        int err_size = snprintf(err, sizeof(err), "%s.stderr", argv[3]);
        ready = ready && out_size > 0 && (size_t)out_size < sizeof(out) && err_size > 0 && (size_t)err_size < sizeof(err);
        const char *expected_out = "stdout:closed captures\n";
        const char *expected_err = "stderr:closed captures\n";
        ready = ready && common_read_is(out, expected_out, strlen(expected_out)) && common_read_is(err, expected_err, strlen(expected_err));
    }
    return ready ? 0 : 27;
}

static int common_child(int argc, char **argv)
{
    int result = 127;
    if (argc >= 3 && strcmp(argv[2], "environment") == 0)
    {
        result = common_child_environment(false);
    }
    else if (argc >= 3 && strcmp(argv[2], "environment-no-path") == 0)
    {
        result = common_child_environment(true);
    }
    else if (argc >= 3 && strcmp(argv[2], "signal") == 0)
    {
        signal(SIGTERM, SIG_DFL);
        raise(SIGTERM);
        result = 24;
    }
    else if (argc >= 3 && strcmp(argv[2], "wait-invalid-EINTR") == 0)
    {
        signal(SIGALRM, SIG_DFL);
        alarm(2);
        errno = EINTR;
        char error[BUSTER_HP_ERROR_CAPACITY] = {0};
        int code = -2;
        bool waited = hp_wait(-1, &code, error);
        alarm(0);
        result = !waited && code == -1 && error[0] != 0 ? 0 : 25;
    }
    else if (argc == 4 && strcmp(argv[2], "cwd") == 0)
    {
        char directory[BUSTER_HP_PATH_CAPACITY];
        bool ready = getcwd(directory, sizeof(directory)) != NULL && strcmp(directory, argv[3]) == 0;
        printf("cwd %s\n", ready ? "verified" : "failed");
        result = ready ? 0 : 26;
    }
    else if (argc >= 3 && strcmp(argv[2], "closed-stdio") == 0)
    {
        result = common_child_closed_stdio(argc, argv);
    }
    else if (argc >= 3 && (strcmp(argv[2], "zero") == 0 || strcmp(argv[2], "nonzero") == 0))
    {
        printf("stdout:%s\n", argc > 3 ? argv[3] : "missing");
        fprintf(stderr, "stderr:%s\n", argc > 3 ? argv[3] : "missing");
        result = strcmp(argv[2], "zero") == 0 ? 0 : 7;
    }
    return result;
}

static void common_processes(CommonSuite *suite)
{
    static const struct
    {
        const char *name;
        const char *mode;
        int code;
        bool expected;
    } cases[] =
    {
        {
            "process-zero-split-logs",
            "zero",
            0,
            true
        },
        {
            "process-nonzero-status",
            "nonzero",
            7,
            false
        },
        {
            "process-signal-status",
            "signal",
            128 + SIGTERM,
            false
        },
        {
            "environment-clear-and-selected-toolchain",
            "environment",
            0,
            true
        },
        {
            "environment-unset-PATH-fallback",
            "environment-no-path",
            0,
            true
        },
        {
            "process-invalid-wait-stale-EINTR-bounded",
            "wait-invalid-EINTR",
            0,
            true
        }
    };
    const char *before = getenv("PATH");
    char *saved_path = before != NULL ? strdup(before) : NULL;
    for (size_t i = 0; i < BUSTER_COMMON_ARRAY_COUNT(cases); i += 1)
    {
        char stem[BUSTER_HP_PATH_CAPACITY];
        common_path(suite, stem, cases[i].name);
        const char *arguments[] =
        {
            suite->self,
            "--child-mode",
            cases[i].mode,
            "argument with spaces ; literal",
            NULL
        };
        int code = -1;
        char error[BUSTER_HP_ERROR_CAPACITY] = {0};
        bool accepted = hp_run(arguments, NULL, stem, true, &code, error);
        common_record(suite, cases[i].name, true, accepted == cases[i].expected && code == cases[i].code, error);
        char status[BUSTER_HP_PATH_CAPACITY];
        int count = snprintf(status, sizeof(status), "%s.status", stem);
        assert(count > 0 && (size_t)count < sizeof(status));
        char expected[32];
        count = snprintf(expected, sizeof(expected), "%d\n", cases[i].code);
        assert(count > 0 && (size_t)count < sizeof(expected));
        common_record(suite, i == 0 ? "process-zero-status-receipt" : i == 1 ? "process-nonzero-status-receipt" : i == 2 ? "process-signal-status-receipt" : i == 3 ? "environment-status-receipt" : i == 4 ? "environment-no-path-status-receipt" : "process-invalid-wait-status-receipt", true, common_read_is(status, expected, (size_t)count), error);
        if (i == 0)
        {
            char output[BUSTER_HP_PATH_CAPACITY];
            count = snprintf(output, sizeof(output), "%s.stdout", stem);
            assert(count > 0 && (size_t)count < sizeof(output));
            const char *expected_out = "stdout:argument with spaces ; literal\n";
            common_record(suite, "process-stdout-exact", true, common_read_is(output, expected_out, strlen(expected_out)), error);
            count = snprintf(output, sizeof(output), "%s.stderr", stem);
            assert(count > 0 && (size_t)count < sizeof(output));
            const char *expected_err = "stderr:argument with spaces ; literal\n";
            common_record(suite, "process-stderr-exact", true, common_read_is(output, expected_err, strlen(expected_err)), error);
            count = snprintf(output, sizeof(output), "%s.argv.nul", stem);
            assert(count > 0 && (size_t)count < sizeof(output));
            HpBuffer record = {0};
            HpArguments parsed = {0};
            bool ok = hp_read_file(output, 16384, &record, error);
            HpBytes bytes =
            {
                record.data,
                record.size
            };
            ok = ok && hp_arguments_read(bytes, &parsed, error);
            ok = ok && parsed.count == 4 && strcmp(parsed.values[0], suite->self) == 0 && strcmp(parsed.values[3], arguments[3]) == 0;
            common_record(suite, "process-argv-nul-exact-spaces", true, ok, error);
            hp_arguments_free(&parsed);
            hp_buffer_free(&record);
        }
    }
    const char *after = getenv("PATH");
    bool unchanged = before == NULL ? after == NULL : saved_path != NULL && after != NULL && strcmp(saved_path, after) == 0;
    common_record(suite, "environment-parent-PATH-unchanged", true, unchanged, "");
    free(saved_path);
    char stem[BUSTER_HP_PATH_CAPACITY];
    common_path(suite, stem, "process-exec-failure");
    const char *missing[] =
    {
        "/nonexistent-buster-control-command",
        NULL
    };
    int code = -1;
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    bool accepted = hp_run(missing, NULL, stem, true, &code, error);
    common_record(suite, "process-exec-failure-status127", true, !accepted && code == 127, error);
    const char *zero[] =
    {
        suite->self,
        "--child-mode",
        "zero",
        "merged logs",
        NULL
    };
    common_path(suite, stem, "process-merged-logs");
    accepted = hp_run(zero, NULL, stem, false, &code, error);
    char output[BUSTER_HP_PATH_CAPACITY];
    int count = snprintf(output, sizeof(output), "%s.stdout", stem);
    assert(count > 0 && (size_t)count < sizeof(output));
    HpBuffer merged = {0};
    bool read = hp_read_file(output, 1024, &merged, error);
    common_record(suite, "process-merged-stdout-stderr", true, accepted && code == 0 && read && strstr((const char *)merged.data, "stdout:merged logs\n") != NULL && strstr((const char *)merged.data, "stderr:merged logs\n") != NULL, error);
    hp_buffer_free(&merged);
    char directory[BUSTER_HP_PATH_CAPACITY];
    common_path(suite, directory, "child working directory with spaces");
    assert(hp_mkdir_new(directory, error));
    common_path(suite, stem, "process-child-cwd");
    const char *cwd_arguments[] =
    {
        suite->self,
        "--child-mode",
        "cwd",
        directory,
        NULL
    };
    accepted = hp_run(cwd_arguments, directory, stem, true, &code, error);
    common_record(suite, "process-child-directory-path-spaces", true, accepted && code == 0, error);
    common_path(suite, stem, "process-child-bad-cwd");
    accepted = hp_run(zero, "/nonexistent-buster-common-directory", stem, true, &code, error);
    common_record(suite, "process-child-bad-directory-status127", true, !accepted && code == 127, error);
    common_path(suite, stem, "process-child-existing-output");
    count = snprintf(output, sizeof(output), "%s.stdout", stem);
    assert(count > 0 && (size_t)count < sizeof(output));
    common_create(output, "preserved", 9);
    accepted = hp_run(zero, NULL, stem, true, &code, error);
    common_record(suite, "process-refuses-output-overwrite", true, !accepted && code == 127 && common_read_is(output, "preserved", 9), error);
    for (size_t i = 0; i < 2; i += 1)
    {
        char inner[BUSTER_HP_PATH_CAPACITY];
        char hash_path[BUSTER_HP_PATH_CAPACITY];
        common_path(suite, inner, i == 0 ? "closed-stdio-inner-out-err" : "closed-stdio-inner-all");
        common_path(suite, hash_path, "input with spaces.bin");
        common_path(suite, stem, i == 0 ? "closed-stdio-out-err" : "closed-stdio-all");
        const char *arguments[] =
        {
            suite->self,
            "--child-mode",
            "closed-stdio",
            inner,
            hash_path,
            i == 0 ? "out-err" : "all",
            NULL
        };
        accepted = hp_run(arguments, NULL, stem, true, &code, error);
        common_record(suite, i == 0 ? "process-closed-stdout-stderr-hash-and-capture" : "process-closed-all-stdio-hash-and-capture", true, accepted && code == 0, error);
    }
    code = -2;
    errno = 0;
    accepted = hp_wait(-1, &code, error);
    common_record(suite, "wait-invalid-child", true, !accepted && code == -1, error);
    char huge[BUSTER_HP_PATH_CAPACITY + 1];
    memset(huge, 'x', sizeof(huge) - 1);
    huge[sizeof(huge) - 1] = 0;
    error[0] = 0;
    accepted = hp_run(zero, NULL, huge, true, &code, error);
    common_record(suite, "process-overlong-stem-bounded-error", true, !accepted && error[0] != 0, error);
    return;
}

static bool common_results(CommonSuite *suite)
{
    char output[BUSTER_HP_PATH_CAPACITY];
    common_path(suite, output, "results.json");
    FILE *file = fopen(output, "wx");
    bool ok = file != NULL;
    if (ok)
    {
        fprintf(file, "{\n  \"kind\": \"fresh C common-helper controls\",\n  \"cases\": %zu,\n  \"failures\": %zu,\n  \"results\": [\n", suite->count, suite->failures);
        for (size_t i = 0; i < suite->count; i += 1)
        {
            CommonResult *result = &suite->results[i];
            fputs("    {\"name\": ", file);
            HpString name =
            {
                result->name,
                strlen(result->name)
            };
            hp_json_string(file, name);
            fprintf(file, ", \"expected_accept\": %s, \"accepted\": %s, \"passed\": %s, \"error\": ", result->expected ? "true" : "false", result->accepted ? "true" : "false", result->passed ? "true" : "false");
            HpString error =
            {
                result->error,
                strlen(result->error)
            };
            hp_json_string(file, error);
            fprintf(file, "}%s\n", i + 1 < suite->count ? "," : "");
        }
        fputs("  ]\n}\n", file);
        ok = ferror(file) == 0;
        ok = fclose(file) == 0 && ok;
    }
    return ok;
}

int main(int argc, char **argv)
{
    int status = 2;
    if (argc >= 2 && strcmp(argv[1], "--child-mode") == 0)
    {
        status = common_child(argc, argv);
    }
    else if (argc == 3 && strcmp(argv[1], "--output") == 0)
    {
        CommonSuite suite = {0};
        bool ready = mkdir(argv[2], 0700) == 0 && realpath(argv[2], suite.root) != NULL;
        ssize_t count = ready ? readlink("/proc/self/exe", suite.self, sizeof(suite.self) - 1) : -1;
        ready = ready && count > 0 && (size_t)count < sizeof(suite.self);
        if (ready)
        {
            suite.self[count] = 0;
            common_files(&suite);
            common_arguments(&suite);
            common_flags(&suite);
            common_sources(&suite);
            common_processes(&suite);
            printf("Synthetic C common controls: %zu cases, %zu failures; only self-child modes and /usr/bin/sha256sum executed.\n", suite.count, suite.failures);
            bool wrote = common_results(&suite);
            status = suite.failures != 0 || !wrote ? 1 : 0;
        }
        else
        {
            perror("create fresh common-control output");
            status = 2;
        }
    }
    else
    {
        fprintf(stderr, "usage: common-controls --output NEW_DIRECTORY\n");
    }
    return status;
}
