// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Exercise the production dependency probes against tiny, disposable Ninja graphs. See DEPENDENCIES.md.
#ifndef BUILD_REGRESSION_SOURCE
#define BUILD_REGRESSION_SOURCE "/tmp/buster-3629/tools/ci/build_regression.c"
#endif
#define main build_regression_main
#include BUILD_REGRESSION_SOURCE
#undef main

static void control_mkdir(const char* path)
{
    char buffer[PATH_MAX];
    snprintf(buffer, sizeof(buffer), "%s", path);
    for (char* slash = buffer + 1; *slash != 0; slash += 1)
    {
        if (*slash == '/')
        {
            *slash = 0;
            if (mkdir(buffer, 0755) != 0 && errno != EEXIST)
            {
                fail("control mkdir %s: %s", buffer, strerror(errno));
            }
            *slash = '/';
        }
    }
    if (mkdir(buffer, 0755) != 0 && errno != EEXIST)
    {
        fail("control mkdir %s: %s", buffer, strerror(errno));
    }
}

static void control_write(const char* directory, const char* name, const char* contents)
{
    char path[PATH_MAX];
    snprintf(path, sizeof(path), "%s/%s", directory, name);
    write_file(path, contents, 0644);
}

static void control_setup(const char* directory, uint32_t variant)
{
    static const char* const directories[] = {
        "tests/preprocessor/named-ucns", "src/buster/compiler", "build/Release/parts/main_unit_backend", "capture",
    };
    for (uint32_t i = 0; i < sizeof(directories) / sizeof(directories[0]); i += 1)
    {
        char path[PATH_MAX];
        snprintf(path, sizeof(path), "%s/%s", directory, directories[i]);
        control_mkdir(path);
    }
    control_write(directory, "tests/preprocessor/named-ucns/0001.c", "const char* example = \"runtime data\";\n");
    control_write(directory, "tests/preprocessor/named-ucns/0001.expected", "diagnostic bytes\n");
    control_write(directory, "tests/preprocessor/named-ucns/catalog.tsv",
                  "buster-fixtures v1 preprocessor-named-ucns\n0001\tgnu17\t-\t-\ta runtime example\n");
    control_write(directory, "src/buster/compiler/ir_parse_test.c", "static int fixture_answer(void) { return 0; }\n");
    control_write(directory, "src/buster/compiler/main_unit_backend.c",
                  "#include \"ir_parse_test.c\"\nint main(void) { return fixture_answer(); }\n");
    control_write(directory, "src/buster/compiler/main_unit_checker.c",
                  "#include \"ir_parse_test.c\"\nint checker(void) { return fixture_answer(); }\n");
    control_write(directory, "build/Release/parts/main_unit_backend/extra.c", "int fixture_helper(void) { return 0; }\n");
    control_write(directory, "build/BusterPostLink.cmake", "file(COPY_FILE \"${INPUT}\" \"${OUTPUT}\")\n");
    if (variant == 9)
    {
        control_write(directory, "build/Release/compiler.link", "an existing link result\n");
    }
    char path[PATH_MAX];
    snprintf(path, sizeof(path), "%s/build/build-Release.ninja", directory);
    FILE* file = fopen(path, "w");
    if (file == NULL)
    {
        fail("can't write disposable graph");
    }
    fputs("rule cc\n  command = clang -MMD -MF $out.d -c $in -o $out\n", file);
    if (variant != 6)
    {
        fputs("  depfile = $out.d\n  deps = gcc\n", file);
    }
    fputs("rule bitcode\n  command = clang -emit-llvm -MMD -MF $out.d -c $in -o $out\n"
          "  depfile = $out.d\n  deps = gcc\n"
          "rule split\n  command = cp $in Release/parts/main_unit_backend/part0.bc && "
          "clang -emit-llvm -c Release/parts/main_unit_backend/extra.c -o Release/parts/main_unit_backend/part1.bc\n"
          "rule native\n  command = clang -x ir -c $in -o $out\n"
          "rule merge\n  command = ld -r $in -o $out\n"
          "rule link\n  command = clang $in -o $out\n"
          "rule bake\n  command = cmake -DINPUT=$in -DOUTPUT=$out -P BusterPostLink.cmake\n"
          "rule copy\n  command = cp $in $out\n", file);
    const char* implicit = variant == 2 ? " | ../tests/preprocessor/named-ucns/0001.c" :
                           variant == 3 ? " | ../tests/preprocessor/named-ucns/0001.expected" :
                           variant == 4 ? " | ../tests/preprocessor/named-ucns/catalog.tsv" :
                           variant == 5 ? " | ../tests/preprocessor/named-ucns" : "";
    fprintf(file, "build Release/main_unit_backend.c.o: %s ../src/buster/compiler/main_unit_backend.c%s\n",
            variant == 1 ? "bitcode" : "cc", implicit);
    const char* object = "Release/main_unit_backend.c.o";
    if (variant == 1)
    {
        fputs("build Release/parts/main_unit_backend/part0.bc Release/parts/main_unit_backend/part1.bc: split Release/main_unit_backend.c.o\n"
              "build Release/parts/main_unit_backend/part0.o: native Release/parts/main_unit_backend/part0.bc\n"
              "build Release/parts/main_unit_backend/part1.o: native Release/parts/main_unit_backend/part1.bc\n"
              "build Release/parts/main_unit_backend/native.o: merge Release/parts/main_unit_backend/part0.o Release/parts/main_unit_backend/part1.o\n", file);
        object = "Release/parts/main_unit_backend/native.o";
    }
    if (variant == 7)
    {
        fputs("build Release/main_unit_checker.c.o: cc ../src/buster/compiler/main_unit_checker.c\n", file);
    }
    if (variant != 9)
    {
        fprintf(file, "build Release/compiler.link: link %s%s\n", object, variant == 7 ? " Release/main_unit_checker.c.o" : "");
    }
    fprintf(file, "build Release/compiler: %s Release/compiler.link%s\nbuild compiler: phony Release/compiler\n",
            variant == 8 ? "copy" : "bake", variant == 9 ? " | Release/main_unit_backend.c.o" : "");
    if (fclose(file) != 0)
    {
        fail("can't finish disposable graph");
    }
    char build[PATH_MAX];
    snprintf(build, sizeof(build), "%s/build", directory);
    char* arguments[] = { "ninja", "-C", build, "-f", "build-Release.ninja", "compiler", NULL };
    snprintf(path, sizeof(path), "%s/build.log", directory);
    if (run(path, NULL, arguments) != 0)
    {
        fail("can't build disposable graph %u; read %s", variant, path);
    }
}

int main(int argc, char** argv)
{
    if (argc != 2 || argv[1][0] != '/')
    {
        fail("usage: dependency-controls ABSOLUTE-NEW-WORK-DIRECTORY");
    }
    if (getcwd(root, sizeof(root)) == NULL)
    {
        fail("can't read working directory");
    }
    check_ownership_fixtures();
    static const char* const labels[] = {
        "ordinary-release", "parts-release", "input-dependency", "expected-dependency", "catalog-dependency",
        "added-case-dependency", "missing-runner-owner", "extra-runner-owner", "missing-bake", "missing-link",
    };
    static const char* const files[] = {
        "tests/preprocessor/named-ucns/0001.c", "tests/preprocessor/named-ucns/0001.expected",
        "tests/preprocessor/named-ucns/catalog.tsv", "src/buster/compiler/ir_parse_test.c",
    };
    for (uint32_t variant = 0; variant < sizeof(labels) / sizeof(labels[0]); variant += 1)
    {
        char directory[BUSTER_REGRESSION_PATH / 2];
        snprintf(directory, sizeof(directory), "%s/%s", argv[1], labels[variant]);
        control_setup(directory, variant);
        Text originals[4];
        struct stat statuses[5];
        for (uint32_t i = 0; i < 4; i += 1)
        {
            char path[PATH_MAX];
            snprintf(path, sizeof(path), "%s/%s", directory, files[i]);
            originals[i] = read_file(path);
            statuses[i] = status_of(path);
            struct timespec times[2] = { statuses[i].st_atim, statuses[i].st_mtim };
            times[0].tv_sec -= 172800;
            if (utimensat(AT_FDCWD, path, times, 0) != 0)
            {
                fail("can't prepare old atime for %s", path);
            }
            statuses[i] = status_of(path);
        }
        char fixture_directory[PATH_MAX];
        snprintf(fixture_directory, sizeof(fixture_directory), "%s/tests/preprocessor/named-ucns", directory);
        statuses[4] = status_of(fixture_directory);
        char log[PATH_MAX];
        snprintf(log, sizeof(log), "%s/probe.log", directory);
        fflush(NULL);
        const pid_t child = fork();
        if (child < 0)
        {
            fail("control fork failed");
        }
        if (child == 0)
        {
            const int output = open(log, O_CREAT | O_TRUNC | O_WRONLY, 0644);
            if (output < 0 || dup2(output, STDOUT_FILENO) < 0 || dup2(output, STDERR_FILENO) < 0 || chdir(directory) != 0)
            {
                _exit(2);
            }
            close(output);
            snprintf(root, sizeof(root), "%s", directory);
            snprintf(work, sizeof(work), "%s/capture", directory);
            signal(SIGINT, on_signal);
            signal(SIGTERM, on_signal);
            char build[PATH_MAX];
            snprintf(build, sizeof(build), "%s/build", directory);
            check_runtime_fixture_dependencies(build, "Release");
            fflush(NULL);
            _exit(0);
        }
        int status = 0;
        if (waitpid(child, &status, 0) != child || !WIFEXITED(status) || WEXITSTATUS(status) != (variant < 2 ? 0 : 1))
        {
            fail("%s gave unexpected status %d; read %s", labels[variant], status, log);
        }
        for (uint32_t i = 0; i < 4; i += 1)
        {
            char path[PATH_MAX];
            snprintf(path, sizeof(path), "%s/%s", directory, files[i]);
            const struct stat after = status_of(path);
            const Text contents = read_file(path);
            if (contents.length != originals[i].length || memcmp(contents.data, originals[i].data, contents.length) != 0 ||
                !same_time(after, statuses[i]) || after.st_atim.tv_sec != statuses[i].st_atim.tv_sec ||
                after.st_atim.tv_nsec != statuses[i].st_atim.tv_nsec || after.st_ino != statuses[i].st_ino)
            {
                fail("%s did not restore %s", labels[variant], files[i]);
            }
            free(contents.data);
            free(originals[i].data);
        }
        const struct stat directory_after = status_of(fixture_directory);
        if (!same_time(directory_after, statuses[4]) || directory_after.st_atim.tv_sec != statuses[4].st_atim.tv_sec ||
            directory_after.st_atim.tv_nsec != statuses[4].st_atim.tv_nsec)
        {
            fail("%s did not restore the fixture directory times", labels[variant]);
        }
        char added[PATH_MAX];
        snprintf(added, sizeof(added), "%s/tests/preprocessor/named-ucns/build-dependency-added.c", directory);
        if (access(added, F_OK) == 0)
        {
            fail("%s left its added source", labels[variant]);
        }
        snprintf(added, sizeof(added), "%s/tests/preprocessor/named-ucns/build-dependency-added.expected", directory);
        if (access(added, F_OK) == 0)
        {
            fail("%s left its added expectation", labels[variant]);
        }
        pass("dependency control %s: %s, exact bytes/inodes/timestamps restored, added files absent", labels[variant],
             variant < 2 ? "accepted" : "rejected");
    }
    return 0;
}
