// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Synthetic controller controls; no Clang, assembler, Buster or timing images.
#define main hp_method_entry
#include "hp_method.c"
#undef main
#include <sys/wait.h>

static unsigned control_count;
static unsigned control_failures;

static void control_check(bool passed, const char* name)
{
    ++control_count;
    control_failures += !passed;
    printf("%s %u %s\n", passed ? "PASS" : "FAIL", control_count, name);
}

static void control_clear(char error[BUSTER_HP_ERROR_CAPACITY])
{
    memset(error, 0, BUSTER_HP_ERROR_CAPACITY);
}

static bool control_write(const char* path, const char* value, char error[BUSTER_HP_ERROR_CAPACITY])
{
    return hp_write_file(path, (HpBytes){(const unsigned char*)value, strlen(value)}, error);
}

static int control_child(int argc, char** argv)
{
    const char* mode = getenv("BUSTER_HP_SYNTHETIC_MODE");
    int result = mode != NULL && strcmp(mode, "nonzero") == 0 ? 7 : 0;
    if (argc > 1 && strcmp(argv[1], "-dumpmachine") == 0)
    {
        puts(mode != NULL && strcmp(mode, "bad-target") == 0 ? "wrong-target" : "x86_64-unknown-linux-gnu");
    }
    else if (argc > 1 && strcmp(argv[1], "-###") == 0)
    {
        const char* triple = mode != NULL && strcmp(mode, "bad-target") == 0 ? "wrong-target" : "x86_64-unknown-linux-gnu";
        const char* command = mode != NULL && strcmp(mode, "assembler") == 0 ? "-cc1as" : "-cc1";
        fprintf(stderr, "clang version 23.1.4\nTarget: x86_64-unknown-linux-gnu\nThread model: posix\n \"%s\" \"%s\" \"-triple\" \"%s\" \"-target-cpu\" \"znver5\" \"-target-feature\" \"+sse2\"\n", argv[0], command, triple);
    }
    else
    {
        puts("synthetic compile child only");
    }
    return result;
}

int main(int argc, char** argv)
{
    bool child = argc > 1 && (strcmp(argv[1], "-dumpmachine") == 0 || strcmp(argv[1], "-###") == 0 || strcmp(argv[1], "-c") == 0);
    int result = 0;
    if (child)
    {
        result = control_child(argc, argv);
    }
    else
    {
        char template[BUSTER_HP_PATH_CAPACITY] = {0};
        char fixture_parent[BUSTER_HP_PATH_CAPACITY] = {0};
        bool parent_ready = argc == 2 && realpath(argv[1], fixture_parent) != NULL;
        int template_length = snprintf(template, sizeof(template), "%s/controller-XXXXXX", fixture_parent);
        char* root = parent_ready && template_length > 0 && (size_t)template_length < sizeof(template) ? mkdtemp(template) : NULL;
        char error[BUSTER_HP_ERROR_CAPACITY] = {0};
        char path[BUSTER_HP_PATH_CAPACITY] = {0}, other[BUSTER_HP_PATH_CAPACITY] = {0}, self[BUSTER_HP_PATH_CAPACITY] = {0};
        HpMethod method = {0};
        bool ready = root != NULL && realpath(argv[0], self) != NULL;
        control_check(ready, "private synthetic fixture available");
        if (ready)
        {
            strcpy(method.root, root);
            strcpy(method.tree, root);
            strcpy(method.cc, self);
            control_check(method_digest("0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"), "lowercase digest accepted");
            control_check(!method_digest(NULL), "null digest rejected");
            control_check(!method_digest(""), "empty digest rejected");
            control_check(!method_digest("0123456789ABCDEF0123456789abcdef0123456789abcdef0123456789abcdef"), "uppercase digest rejected");
            control_check(!method_digest("g123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"), "nonhex digest rejected");
            const char manifest_row[] = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa  src/one.c\naaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa  build.sh";
            HpBytes manifest_bytes = {(const unsigned char*)manifest_row, sizeof(manifest_row) - 1};
            control_check(method_manifest_has(manifest_bytes, "src/one.c"), "exact full manifest member accepted");
            control_check(method_manifest_has(manifest_bytes, "build.sh"), "final manifest row without LF accepted");
            control_check(!method_manifest_has(manifest_bytes, "one.c"), "manifest suffix collision rejected");
            control_check(!method_manifest_has(manifest_bytes, "src/one.c/extra"), "manifest prefix collision rejected");
            control_check(!method_manifest_has((HpBytes){(const unsigned char*)"short", 5}, "x"), "short manifest row rejected without overread");
            control_check(method_canonical(root, path, error) && strcmp(path, root) == 0, "existing absolute canonical path");
            control_clear(error);
            control_check(!method_canonical("relative", path, error), "relative existing input rejected");
            control_clear(error);
            control_check(hp_join_path(other, root, "new-output", error) && method_new_path(other, path, error) && strcmp(path, other) == 0, "fresh child resolves existing parent");
            control_clear(error);
            control_check(!method_new_path("relative/new", path, error), "relative output rejected");
            control_clear(error);
            control_check(!method_new_path("/no-such-buster-parent/new", path, error), "missing output parent rejected");
            control_clear(error);
            control_check(!method_new_path("/tmp/..", path, error), "dotdot output leaf rejected");
            control_clear(error);
            control_check(!method_new_path("/tmp/", path, error), "empty output leaf rejected");
            control_clear(error);
            control_check(hp_join_path(path, root, "abc", error) && control_write(path, "abc", error) && method_hash(path, "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad", error), "real SHA command validates known synthetic bytes");
            control_clear(error);
            control_check(!method_hash(path, "0000000000000000000000000000000000000000000000000000000000000000", error), "changed identity rejected");
            control_clear(error);
            control_check(hp_join_path(other, root, "copy", error) && method_copy(path, other, error) && hp_files_equal(path, other, error), "exclusive byte copy exact");
            control_clear(error);
            control_check(!method_copy(path, other, error), "copy refuses overwrite");
            control_clear(error);
            char* source_values[] = {"src/other.c", "src/main_unit_checker.c", "src/last.c", NULL};
            method.sources = (HpArguments){NULL, source_values, 3};
            control_check(hp_plan_sources(&method.sources, &method.plan, error) && method_objects(&method, error) && method.objects.count == 3 && strstr(method.objects.values[1], "/objects/1.o") != NULL && method.objects.values[3] == NULL, "object paths preserve source index and terminator");
            strcpy(method.manifest, "/synthetic-source-manifest");
            memset(method.normal_sha, 'a', 64);
            memset(method.manifest_sha, 'b', 64);
            strcpy(method.tc, "/synthetic-toolchain");
            method.fragment = true;
            control_check(method_settings(&method, 2, error), "settings created exclusively");
            HpArguments settings = {0};
            control_check(method_path(path, &method, "settings.nul", error) && method_load_arguments(path, &settings, error) && settings.count == 9 && strcmp(settings.values[5], "1") == 0 && strcmp(settings.values[6], "3") == 0 && strcmp(settings.values[7], "1") == 0 && strcmp(settings.values[8], "2") == 0, "settings roundtrip contains index/count/fragment/core budget");
            hp_arguments_free(&settings);
            control_clear(error);
            control_check(!method_settings(&method, 2, error), "settings refuses overwrite");
            control_clear(error);
            control_check(method_path(path, &method, "objects", error) && hp_mkdir_new(path, error) && method_path(path, &method, "logs", error) && hp_mkdir_new(path, error), "synthetic child record directories");
            control_clear(error);
            control_check(method_compiles(&method, 2, error), "bounded fork/wait compiler wrappers accept zero synthetic children");
            HpBuffer status = {0};
            control_check(method_path(path, &method, "logs/compile-2.status", error) && hp_read_file(path, 100, &status, error) && status.size == 2 && memcmp(status.data, "0\n", 2) == 0, "last synthetic child actual status retained");
            hp_buffer_free(&status);
            control_clear(error);
            control_check(!method_compiles(&method, 2, error), "existing child receipts fail instead of overwrite");
            control_clear(error);
            control_check(!method_compiles(&method, 0, error), "zero compile budget rejected without child");
            control_clear(error);
            control_check(!method_compiles(&method, BUSTER_HP_SOURCE_LIMIT + 1, error), "oversized compile budget rejected without overread");
            HpMethod failing = {0};
            bool failing_ready = hp_join_path(failing.root, root, "nonzero-compiles", error) && hp_mkdir_new(failing.root, error) && hp_join_path(path, failing.root, "logs", error) && hp_mkdir_new(path, error);
            strcpy(failing.cc, self);
            strcpy(failing.tree, root);
            failing.sources = (HpArguments){NULL, source_values, 3};
            failing_ready = failing_ready && method_objects(&failing, error);
            setenv("BUSTER_HP_SYNTHETIC_MODE", "nonzero", 1);
            control_clear(error);
            control_check(failing_ready && !method_compiles(&failing, 2, error), "nonzero synthetic compile causes controller failure");
            control_clear(error);
            control_check(hp_join_path(path, failing.root, "logs/compile-0.status", error) && hp_read_file(path, 100, &status, error) && status.size == 2 && memcmp(status.data, "7\n", 2) == 0, "actual nonzero child code preserved");
            hp_buffer_free(&status);
            control_check(hp_join_path(path, failing.root, "logs/compile-2.argv.nul", error) && access(path, F_OK) != 0 && errno == ENOENT, "new compile not launched after observed failure");
            hp_arguments_free(&failing.objects);
            unsetenv("BUSTER_HP_SYNTHETIC_MODE");
            control_clear(error);
            control_check(method_path(path, &method, "default-good", error) && method_default(&method, path, error), "default target from successful synthetic child accepted");
            setenv("BUSTER_HP_SYNTHETIC_MODE", "bad-target", 1);
            control_clear(error);
            control_check(method_path(path, &method, "default-bad", error) && !method_default(&method, path, error), "wrong target bytes rejected");
            setenv("BUSTER_HP_SYNTHETIC_MODE", "nonzero", 1);
            control_clear(error);
            control_check(method_path(path, &method, "default-nonzero", error) && !method_default(&method, path, error), "nonzero default target child rejected");
            unsetenv("BUSTER_HP_SYNTHETIC_MODE");
            HpPlanArguments arguments = {0};
            arguments.values[0] = self;
            arguments.values[1] = "-c";
            arguments.values[2] = "synthetic.c";
            arguments.count = 3;
            HpDriverIsa isa = {0};
            control_clear(error);
            control_check(method_path(path, &method, "driver-good", error) && method_driver(&arguments, "-cc1", &method, path, &isa, error) && strcmp(isa.cpu, "znver5") == 0, "saved successful synthetic effective C driver parsed and canonical bound");
            hp_driver_free(&isa);
            setenv("BUSTER_HP_SYNTHETIC_MODE", "bad-target", 1);
            control_clear(error);
            control_check(method_path(path, &method, "driver-bad", error) && !method_driver(&arguments, "-cc1", &method, path, &isa, error), "effective target mismatch rejected");
            setenv("BUSTER_HP_SYNTHETIC_MODE", "nonzero", 1);
            control_clear(error);
            control_check(method_path(path, &method, "driver-nonzero", error) && !method_driver(&arguments, "-cc1", &method, path, &isa, error), "nonzero effective receipt process rejected");
            setenv("BUSTER_HP_SYNTHETIC_MODE", "assembler", 1);
            control_clear(error);
            control_check(method_path(path, &method, "driver-assembler", error) && method_driver(&arguments, "-cc1as", &method, path, &isa, error), "saved successful synthetic assembler receipt parsed");
            hp_driver_free(&isa);
            unsetenv("BUSTER_HP_SYNTHETIC_MODE");
            HpMethod different = method;
            strcpy(different.cc, "/bin/true");
            control_clear(error);
            control_check(method_path(path, &method, "driver-wrong-exe", error) && !method_driver(&arguments, "-cc1", &different, path, &isa, error), "different canonical executable rejected");
            hp_driver_free(&isa);
            control_clear(error);
            control_check(!method_resume(&method, 0, error), "zero cannot bypass objects-stage control");
            control_clear(error);
            control_check(!method_resume(&method, 17, error), "unsupported shift rejected before any probe");
            control_clear(error);
            control_check(!method_resume(&method, 16, error), "missing ready record rejected before any producer");
            control_clear(error);
            control_check(method_path(path, &method, "ready.nul", error) && control_write(path, "malformed", error) && !method_resume(&method, 16, error), "malformed ready record rejected before any producer");
            control_clear(error);
            control_check(method_snapshot(&method, error), "iterative snapshot covers synthetic object/log/settings artifacts");
            control_check(method_path(path, &method, "snapshot.sha256", error) && hp_verify_sources(method.root, path, error), "fresh snapshot independently validates all recorded hashes");
            control_clear(error);
            control_check(hp_join_path(other, root, "later-extra", error) && control_write(other, "outside original snapshot", error) && hp_verify_sources(method.root, path, error), "later distinct artifacts do not mutate original snapshot");
            control_clear(error);
            control_check(hp_join_path(other, root, "abc", error) && unlink(other) == 0 && control_write(other, "mutated", error) && !hp_verify_sources(method.root, path, error), "mutated retained artifact rejected");
            control_clear(error);
            control_check(!method_snapshot(&method, error), "snapshot refuses overwrite");
            char second_template[BUSTER_HP_PATH_CAPACITY] = {0};
            int second_length = snprintf(second_template, sizeof(second_template), "%s/symlink-XXXXXX", fixture_parent);
            char* second = second_length > 0 && (size_t)second_length < sizeof(second_template) ? mkdtemp(second_template) : NULL;
            HpMethod symlink_method = {0};
            bool second_ready = second != NULL;
            if (second_ready)
            {
                strcpy(symlink_method.root, second);
                second_ready = hp_join_path(path, second, "alias", error) && symlink("/dev/null", path) == 0;
            }
            control_clear(error);
            control_check(second_ready && !method_snapshot(&symlink_method, error), "snapshot rejects symlink artifacts");
            HpMethod bound = {0};
            bool bound_ready = hp_join_path(bound.root, root, "ready-binding", error) && hp_mkdir_new(bound.root, error) && hp_join_path(path, bound.root, "member", error) && control_write(path, "abc", error);
            const char* member_row = "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad  member\n";
            char snapshot_path[BUSTER_HP_PATH_CAPACITY] = {0};
            char ready_path[BUSTER_HP_PATH_CAPACITY] = {0};
            char snapshot_sha[65] = {0};
            bound_ready = bound_ready && hp_join_path(snapshot_path, bound.root, "snapshot.sha256", error) && control_write(snapshot_path, member_row, error) && hp_sha256_file(snapshot_path, snapshot_sha, error) && hp_join_path(ready_path, bound.root, "ready.nul", error);
            const char* bound_record[] = {"buster-hot-placement-c-v1", method.normal_sha, method.manifest_sha, "0000000000000000000000000000000000000000000000000000000000000000", NULL};
            bound_ready = bound_ready && hp_record_arguments(ready_path, bound_record, error);
            control_clear(error);
            control_check(bound_ready && !method_resume(&bound, 16, error) && strstr(error, "SHA256 mismatch") != NULL, "ready record rejects changed snapshot manifest before any probe");
            bound_record[3] = snapshot_sha;
            bound_ready = unlink(ready_path) == 0 && hp_record_arguments(ready_path, bound_record, error);
            control_clear(error);
            control_check(bound_ready && !method_resume(&bound, 16, error) && strstr(error, "settings.nul") != NULL, "exact ready snapshot reaches only next metadata gate");
            bound_ready = unlink(snapshot_path) == 0 && control_write(snapshot_path, "", error);
            control_clear(error);
            control_check(bound_ready && !method_resume(&bound, 16, error) && strstr(error, "SHA256 mismatch") != NULL, "snapshot row removal cannot weaken original object inventory");
            const char* inherited = getenv("BUSTER_9700X_HELD");
            char* saved = inherited != NULL ? strdup(inherited) : NULL;
            unsetenv("BUSTER_9700X_HELD");
            control_clear(error);
            control_check(!method_identity(&method, error) && strstr(error, "inherited") != NULL, "missing real lock rejected before identity or probe calls");
            if (saved != NULL)
            {
                setenv("BUSTER_9700X_HELD", saved, 1);
            }
            free(saved);
            // Borrowed test source names are not the owned HpArguments layout.
            method.sources = (HpArguments){0};
            method_free(&method);
        }
        printf("{\"controls\":%u,\"failures\":%u,\"scope\":\"synthetic controller only; no producers or target images\"}\n", control_count, control_failures);
        result = control_failures == 0 ? 0 : 1;
    }
    return result;
}
