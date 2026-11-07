// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and THIRD_PARTY_NOTICES.md.
// Synthetic tests do not enter the production host lock or publish observations.
#define WAIT_OBSERVE_NO_MAIN
#include "wait-observe.c"

static bool fixture_path(char* path, size_t capacity, const char* root, const char* leaf)
{
    return path_join(path, capacity, root, leaf);
}

static bool fixture_sample(const char* root, const char* reference, const char* name, unsigned lanes, bool instrumented, bool cpu2)
{
    char sample[PATH_MAX], path[PATH_MAX], ref[PATH_MAX], row[2048], name_buffer[128];
    bool valid = fixture_path(sample, sizeof(sample), root, name);
    if (strcmp(name, "reference") != 0) valid = valid && mkdir(sample, 0700) == 0;
    snprintf(row, sizeof(row), "%s%u\t%u\t%u\t1\t1\t1\t1\t1\t0\t0\t0\t0\t0\t2\t1\n", sample_header, lanes, instrumented, cpu2 ? 4u : 255u);
    valid = valid && fixture_path(path, sizeof(path), sample, "sample.tsv") && write_text(path, row);
    if (strcmp(name, "reference") != 0)
        valid = valid && fixture_path(path, sizeof(path), sample, "objects.sha256") && fixture_path(ref, sizeof(ref), reference, "objects.sha256") && copy_file(ref, path);
    const char* root_names[] = { "identity.before.txt", "host-policy.before.txt", "environment.txt" };
    const char* sample_names[][2] = { { "identity.before.txt", "identity.after.txt" }, { "host-policy.before.txt", "host-policy.after.txt" }, { "environment.txt", "environment.after.txt" } };
    for (size_t i = 0; valid && i < 3; i += 1)
    {
        valid = fixture_path(ref, sizeof(ref), root, root_names[i]);
        for (size_t j = 0; valid && j < 2; j += 1)
            valid = fixture_path(path, sizeof(path), sample, sample_names[i][j]) && copy_file(ref, path);
    }
    if (valid && instrumented) valid = fixture_path(path, sizeof(path), sample, "stages.tsv") && write_text(path, "stage evidence\n");
    snprintf(name_buffer, sizeof(name_buffer), "%s.lock.stdout", name);
    valid = valid && fixture_path(path, sizeof(path), root, name_buffer) && write_text(path, "lock-guard\tstart-realtime-ns=1\tend-realtime-ns=2\tmonotonic-ns=100\tstatus=0\tinterrupted=0\tdescendants-clean=1\n");
    snprintf(name_buffer, sizeof(name_buffer), "%s.lock-window.txt", name);
    valid = valid && fixture_path(path, sizeof(path), root, name_buffer) && write_text(path, "guard-monotonic-ns=100\nwrapper-wall-ns-including-wait=200\nwrapper-status=0\nwrapper-interrupted=0\nlock-hold-upper-bound-valid=1\n");
    return valid;
}

int main(void)
{
    unsigned checks = 0, failures = 0;
    bool ready = install_signals();
    char directory[] = "/tmp/wait-observe-test-XXXXXX";
    ready = ready && mkdtemp(directory) != NULL;
    WaitOptions options = { 0 };
    ready = ready && copy_string(options.qualified, sizeof(options.qualified), directory);
    char original[PATH_MAX], frozen[PATH_MAX], reference[PATH_MAX], path[PATH_MAX], status[PATH_MAX];
    ready = ready && fixture_path(original, sizeof(original), directory, "case") && mkdir(original, 0700) == 0 &&
            fixture_path(frozen, sizeof(frozen), directory, "frozen") && mkdir(frozen, 0700) == 0 &&
            fixture_path(reference, sizeof(reference), directory, "reference") && mkdir(reference, 0700) == 0 &&
            copy_string(options.run.case_directory, sizeof(options.run.case_directory), frozen) &&
            copy_string(options.run.reference, sizeof(options.run.reference), reference) &&
            copy_string(options.run.source, sizeof(options.run.source), "/control") && copy_string(options.run.compiler, sizeof(options.run.compiler), "/control/build/compiler");
    for (size_t i = 0; ready && i < 4; i += 1)
    {
        char a[PATH_MAX], b[PATH_MAX];
        ready = fixture_path(a, sizeof(a), original, case_files[i]) && fixture_path(b, sizeof(b), frozen, case_files[i]) && write_text(a, "fixture\n") && write_text(b, "fixture\n");
    }
    char* outputs[] = { "one.o", "two.o" };
    Case input = { .outputs = { .items = outputs, .count = 2 } };
    for (size_t i = 0; ready && i < 2; i += 1)
    {
        ready = fixture_path(path, sizeof(path), reference, outputs[i]) && write_text(path, i == 0 ? "first object\n" : "second object\n");
    }
    Configuration reference_config = options.run;
    ready = ready && copy_string(reference_config.output, sizeof(reference_config.output), reference) && output_hashes(&reference_config, &input);
    char sample[2048];
    snprintf(sample, sizeof(sample), "%s1\t0\t255\t1\t1\t1\t1\t1\t0\t0\t0\t0\t0\t2\t1\n", sample_header);
    ready = ready && fixture_path(path, sizeof(path), reference, "sample.tsv") && write_text(path, sample) &&
            fixture_path(status, sizeof(status), directory, "case-status.txt") && write_text(status, "case-status=qualified\nparent-issue-status=not-established-by-one-case\n");
    char identity[1024];
    snprintf(identity, sizeof(identity), "compiler-source=/control\ncompiler-revision=" WAIT_REV "\ncompiler-source-state=clean\nsha256sum:\n" WAIT_CONTROL "  /control/build/compiler\n");
    char before[PATH_MAX], after[PATH_MAX];
    ready = ready && fixture_path(before, sizeof(before), reference, "identity.before.txt") && fixture_path(after, sizeof(after), reference, "identity.after.txt") &&
            write_text(before, identity) && write_text(after, identity);
    const char* root_names[][2] = { { "identity.before.txt", identity }, { "identity.after.txt", identity },
                                    { "host-policy.before.txt", "policy\n" }, { "host-policy.after.txt", "policy\n" },
                                    { "environment.txt", "environment\n" }, { "environment.after.txt", "environment\n" }, { "summary.tsv", "summary\n" } };
    for (size_t i = 0; ready && i < sizeof(root_names) / sizeof(root_names[0]); i += 1)
        ready = fixture_path(path, sizeof(path), directory, root_names[i][0]) && write_text(path, root_names[i][1]);
    ready = ready && fixture_sample(directory, reference, "reference", 1, false, false);
    for (unsigned slot = 0; ready && slot <= BUSTER_LANES; slot += 1)
    {
        char name[64];
        snprintf(name, sizeof(name), "warmup-%u", slot);
        ready = fixture_sample(directory, reference, name, slot < BUSTER_LANES ? slot + 1 : 1, false, slot == BUSTER_LANES);
    }
    for (unsigned run = 1; ready && run <= 7; run += 1)
    {
        for (unsigned slot = 0; ready && slot <= BUSTER_LANES; slot += 1)
        {
            char name[64];
            snprintf(name, sizeof(name), "run-%03u-%u", run, slot);
            ready = fixture_sample(directory, reference, name, slot < BUSTER_LANES ? slot + 1 : 1, false, slot == BUSTER_LANES);
        }
    }
    for (unsigned slot = 0; ready && slot <= BUSTER_LANES; slot += 1)
    {
        char name[64];
        snprintf(name, sizeof(name), "diagnostic-%u", slot);
        ready = fixture_sample(directory, reference, name, slot < BUSTER_LANES ? slot + 1 : 1, true, slot == BUSTER_LANES);
    }
    test_expect(&checks, &failures, ready && wait_reference(&options, &input), "two-object qualified reference is accepted");
    ready = ready && fixture_path(path, sizeof(path), reference, "two.o") && write_text(path, "changed object\n");
    test_expect(&checks, &failures, ready && !wait_reference(&options, &input), "changed reference object is rejected against its recorded hash");
    ready = ready && write_text(path, "second object\n") && write_text(status, "case-status=failed\nparent-issue-status=not-established\n");
    test_expect(&checks, &failures, ready && !wait_reference(&options, &input), "incomplete timing case cannot provide a qualified reference");
    options.smoke = true;
    test_expect(&checks, &failures, ready && wait_reference(&options, &input), "smoke mode checks the successful reference of an incomplete case");
    ready = ready && fixture_path(path, sizeof(path), directory, "reference.lock.stdout") && unlink(path) == 0;
    test_expect(&checks, &failures, ready && !wait_reference(&options, &input), "smoke rejects a missing reference guard receipt");
    ready = ready && write_text(path, "lock-guard\tstart-realtime-ns=1\tend-realtime-ns=2\tmonotonic-ns=100\tstatus=1\tinterrupted=1\tdescendants-clean=1\n");
    test_expect(&checks, &failures, ready && !wait_reference(&options, &input), "smoke rejects a failed reference guard receipt");
    char window[PATH_MAX];
    ready = ready && write_text(path, "lock-guard\tstart-realtime-ns=1\tend-realtime-ns=2\tmonotonic-ns=256000000000\tstatus=0\tinterrupted=0\tdescendants-clean=1\n") &&
            fixture_path(window, sizeof(window), directory, "reference.lock-window.txt") &&
            write_text(window, "guard-monotonic-ns=256000000000\nwrapper-wall-ns-including-wait=256000000001\nwrapper-status=0\nwrapper-interrupted=0\nlock-hold-upper-bound-valid=1\n");
    test_expect(&checks, &failures, ready && !wait_reference(&options, &input), "smoke rejects a successful guard beyond the hold limit");
    ready = ready && write_text(path, "lock-guard\tstart-realtime-ns=1\tend-realtime-ns=2\tmonotonic-ns=100\tstatus=0\tinterrupted=0\tdescendants-clean=1\n");
    ready = ready && write_text(window, "guard-monotonic-ns=100\nwrapper-wall-ns-including-wait=200\nwrapper-status=0\nwrapper-interrupted=0\nlock-hold-upper-bound-valid=1\n");
    test_expect(&checks, &failures, strcmp(wait_result_state(true, true), "smoke-passed") == 0 && strcmp(wait_result_state(false, true), "failed") == 0 &&
                strcmp(wait_result_state(true, false), "validated") == 0, "smoke success cannot become a validated campaign observation");
    options.smoke = false;
    ready = ready && fixture_path(path, sizeof(path), reference, "two.o") && write_text(status, "case-status=qualified\nparent-issue-status=not-established-by-one-case\n") && unlink(path) == 0 && symlink("/dev/null", path) == 0;
    test_expect(&checks, &failures, ready && !wait_reference(&options, &input), "symlink reference object is rejected");
    ready = ready && unlink(path) == 0 && write_text(path, "second object\n") && write_text(after, "wrong compiler identity\n");
    test_expect(&checks, &failures, ready && !wait_reference(&options, &input), "changed reference compiler identity is rejected");
    ready = ready && write_text(after, identity) && fixture_path(path, sizeof(path), frozen, "args.txt") && write_text(path, "changed input\n");
    test_expect(&checks, &failures, ready && !wait_reference(&options, &input), "changed frozen input manifest is rejected");
    char candidate[PATH_MAX], first[PATH_MAX], second[PATH_MAX], original_first[PATH_MAX];
    ready = ready && fixture_path(candidate, sizeof(candidate), directory, "candidate") && mkdir(candidate, 0700) == 0 &&
            fixture_path(first, sizeof(first), candidate, "one.o") && fixture_path(second, sizeof(second), candidate, "two.o") &&
            fixture_path(original_first, sizeof(original_first), reference, "one.o") && write_text(first, "first object\n") && write_text(second, "second object\n");
    test_expect(&checks, &failures, ready && wait_compare_outputs(candidate, reference, &input), "both candidate objects match the reference");
    ready = ready && write_text(second, "changed object\n");
    test_expect(&checks, &failures, ready && !wait_compare_outputs(candidate, reference, &input), "changed candidate object is rejected");
    ready = ready && unlink(second) == 0;
    test_expect(&checks, &failures, ready && !wait_compare_outputs(candidate, reference, &input), "missing candidate object is rejected");
    ready = ready && write_text(second, "second object\n") && unlink(first) == 0 && symlink(original_first, first) == 0;
    test_expect(&checks, &failures, ready && !wait_compare_outputs(candidate, reference, &input), "candidate symlink is rejected even when target bytes match");
    ready = ready && unlink(first) == 0 && write_text(first, "");
    test_expect(&checks, &failures, ready && !wait_compare_outputs(candidate, reference, &input), "empty candidate object is rejected");
    ready = ready && fixture_path(path, sizeof(path), frozen, "args.txt") && write_text(path, "fixture\n") &&
            fixture_path(path, sizeof(path), directory, "run-007-8/sample.tsv") && unlink(path) == 0;
    test_expect(&checks, &failures, ready && !wait_reference(&options, &input), "a missing non-reference timing sample invalidates the qualified case");
    char* invalid[] = { (char*)"wait-observe", NULL };
    WaitOptions refused;
    test_expect(&checks, &failures, !wait_options(1, invalid, &refused), "missing production options are rejected");
    (void)&wait_observe;
    printf("wait-observe synthetic tests: %u checks, %u failures; acceptance=no\n", checks, failures);
    if (ready && failures == 0) ready = nftw(directory, remove_test_path, 16, FTW_DEPTH | FTW_PHYS) == 0;
    else fprintf(stderr, "wait-observe: retained failed fixture at %s\n", directory);
    return ready && failures == 0 ? 0 : 1;
}
