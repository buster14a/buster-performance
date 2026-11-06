// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and THIRD_PARTY_NOTICES.md.
// One isolated, perturbed wait observation. Reuse the timing runner's guard and input/receipt checks.
#define main multicore_timing_runner_main
#include "runner.c"
#undef main

#define WAIT_REV "2dc50258e8b33393474b64032a5cbe9f17c63def"
#define WAIT_TREE "1829aa50f677d713bcb250966746575d526989ef"
#define WAIT_DIFF "199e7888f51df9f46995ea751198a00f92ba306acd3272b016068ed66a245414"
#define WAIT_DIAGNOSTIC "098eebdffc96491035b3508d56df6546aba5c97209b3f556088f9b1b73d049e3"
#define WAIT_CONTROL "51b54dd02986a28f294c0d5b2539e93739acb8962851127316da7953d4f8b09b"
#define WAIT_VALIDATOR "91168e21edbe8c68e56eb491ec41a2a98e241fe00b529ee641366c7ae99fce17"
#define WAIT_GUARD_LIMIT_NS ((uint64_t)(BUSTER_HOLD_SECONDS + BUSTER_HOLD_GRACE_SECONDS + BUSTER_REAP_SECONDS) * UINT64_C(1000000000))

typedef struct WaitOptions WaitOptions;
struct WaitOptions
{
    Configuration run;
    char qualified[PATH_MAX];
    char diagnostic_source[PATH_MAX];
    char diagnostic_binary[PATH_MAX];
    char validator[PATH_MAX];
    bool helper;
    bool smoke;
};

static const char* wait_result_state(bool passed, bool smoke)
{
    return !passed ? "failed" : smoke ? "smoke-passed" : "validated";
}

static bool wait_hash(const char* path, const char* expected)
{
    char digest[PATH_MAX + 128];
    char* args[] = { "sha256sum", "--", (char*)path, NULL };
    return capture(args, digest, sizeof(digest)) && strncmp(digest, expected, 64) == 0 && digest[64] == ' ' && digest[65] == ' ';
}

static bool wait_git(const char* directory, const char* revision, const char* tree, const char* expected_status)
{
    char head[128], tree_value[128], status[32768], top[PATH_MAX + 1];
    char* a[] = { "git", "-C", (char*)directory, "rev-parse", "HEAD", NULL };
    char* b[] = { "git", "-C", (char*)directory, "rev-parse", "HEAD^{tree}", NULL };
    char* c[] = { "git", "-C", (char*)directory, "status", "--porcelain=v1", "--untracked-files=all", NULL };
    char* d[] = { "git", "-C", (char*)directory, "rev-parse", "--show-toplevel", NULL };
    bool valid = capture(a, head, sizeof(head)) && capture(b, tree_value, sizeof(tree_value)) && capture(c, status, sizeof(status)) &&
                 capture(d, top, sizeof(top)) && strlen(head) == 41 && head[40] == '\n' && strlen(tree_value) == 41 && tree_value[40] == '\n';
    if (valid)
    {
        head[40] = tree_value[40] = 0;
        top[strcspn(top, "\r\n")] = 0;
        valid = strcmp(head, revision) == 0 && strcmp(tree_value, tree) == 0 && strcmp(status, expected_status) == 0 && strcmp(top, directory) == 0;
    }
    char* entries = valid ? malloc(BUSTER_TEXT_LIMIT) : NULL;
    char* list[] = { "git", "-C", (char*)directory, "ls-files", "-v", NULL };
    valid = valid && entries != NULL && capture(list, entries, BUSTER_TEXT_LIMIT);
    if (valid)
    {
        char* row = entries;
        while (*row != 0 && valid)
        {
            char* newline = strchr(row, '\n');
            valid = newline != NULL && row[0] == 'H' && row[1] == ' ';
            if (valid) row = newline + 1;
        }
    }
    free(entries);
    return valid;
}

static bool wait_identity(const WaitOptions* options, const char* out)
{
    const Configuration* c = &options->run;
    const char* changed = " M src/buster/compiler/lane.c\n M src/buster/compiler/lane_test.c\n";
    char diff[PATH_MAX], control_identity[PATH_MAX], patch_file[PATH_MAX];
    bool valid = path_join(diff, sizeof(diff), out, "applied.diff") && path_join(control_identity, sizeof(control_identity), out, "control.identity") &&
                 path_join(patch_file, sizeof(patch_file), out, "diagnostic.identity") &&
                 wait_git(c->source, WAIT_REV, WAIT_TREE, "") && wait_git(options->diagnostic_source, WAIT_REV, WAIT_TREE, changed) &&
                 wait_hash(c->compiler, WAIT_CONTROL) && wait_hash(options->diagnostic_binary, WAIT_DIAGNOSTIC) &&
                 wait_hash(options->validator, WAIT_VALIDATOR) && identity(c, control_identity);
    const int file = valid ? open(diff, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0600) : -1;
    char* changes[] = { "git", "-C", (char*)options->diagnostic_source, "diff", "--binary", NULL };
    valid = valid && file >= 0;
    if (valid) valid = successful(run_process(changes, NULL, file, STDERR_FILENO, 30, NULL, false));
    if (file >= 0) valid = close(file) == 0 && valid;
    valid = valid && wait_hash(diff, WAIT_DIFF);
    char status[PATH_MAX], objects[PATH_MAX];
    valid = valid && path_join(status, sizeof(status), options->qualified, "case-status.txt") && path_join(objects, sizeof(objects), c->reference, "objects.sha256");
    char* hashes[] = { "sha256sum", "--", (char*)options->diagnostic_binary, (char*)options->validator, (char*)c->executable,
                       (char*)c->lock, status, objects, NULL };
    char buffer[65536];
    valid = valid && capture(hashes, buffer, sizeof(buffer)) && write_text(patch_file, buffer);
    return valid;
}

static bool wait_timing_sample(const WaitOptions* options, const Case* input, const char* name, unsigned lanes, bool instrumented, bool cpu2)
{
    Configuration c = options->run;
    c.lanes = lanes;
    c.instrumented = instrumented;
    c.cpu2 = cpu2;
    char sample[PATH_MAX], guard[PATH_MAX], window[PATH_MAX], name_buffer[128], expected[PATH_MAX], actual[PATH_MAX];
    snprintf(name_buffer, sizeof(name_buffer), "%s.lock.stdout", name);
    bool valid = path_join(sample, sizeof(sample), options->qualified, name) && path_join(guard, sizeof(guard), options->qualified, name_buffer) &&
                 copy_string(c.output, sizeof(c.output), sample);
    snprintf(name_buffer, sizeof(name_buffer), "%s.lock-window.txt", name);
    valid = valid && path_join(window, sizeof(window), options->qualified, name_buffer);
    uint64_t guard_ns = 0, recorded_guard = 0, wrapper_ns = 0;
    int status = -1, consumed = 0;
    unsigned interrupted = 1, bound = 0;
    char row[512];
    FILE* file = valid ? fopen(window, "r") : NULL;
    valid = valid && file != NULL && fgets(row, sizeof(row), file) != NULL &&
            sscanf(row, "guard-monotonic-ns=%" SCNu64 "%n", &recorded_guard, &consumed) == 1 && row[consumed] == '\n' && row[consumed + 1] == 0 &&
            fgets(row, sizeof(row), file) != NULL && sscanf(row, "wrapper-wall-ns-including-wait=%" SCNu64 "%n", &wrapper_ns, &consumed) == 1 && row[consumed] == '\n' && row[consumed + 1] == 0 &&
            fgets(row, sizeof(row), file) != NULL && sscanf(row, "wrapper-status=%d%n", &status, &consumed) == 1 && row[consumed] == '\n' && row[consumed + 1] == 0 &&
            fgets(row, sizeof(row), file) != NULL && sscanf(row, "wrapper-interrupted=%u%n", &interrupted, &consumed) == 1 && row[consumed] == '\n' && row[consumed + 1] == 0 &&
            fgets(row, sizeof(row), file) != NULL && sscanf(row, "lock-hold-upper-bound-valid=%u%n", &bound, &consumed) == 1 && row[consumed] == '\n' && row[consumed + 1] == 0 &&
            fgetc(file) == EOF && !ferror(file);
    if (file != NULL) valid = fclose(file) == 0 && valid;
    Process observed;
    valid = valid && status == 0 && interrupted == 0 && bound == 1 && read_guard(guard, &guard_ns) && guard_ns == recorded_guard && guard_ns <= wrapper_ns &&
            guard_ns <= WAIT_GUARD_LIMIT_NS &&
            read_sample(&c, input->outputs.count, &observed);
    const char* root_names[] = { "identity.before.txt", "host-policy.before.txt", "environment.txt" };
    const char* sample_names[][2] = { { "identity.before.txt", "identity.after.txt" }, { "host-policy.before.txt", "host-policy.after.txt" }, { "environment.txt", "environment.after.txt" } };
    for (size_t i = 0; valid && i < 3; i += 1)
    {
        valid = path_join(expected, sizeof(expected), options->qualified, root_names[i]);
        for (size_t j = 0; valid && j < 2; j += 1)
            valid = path_join(actual, sizeof(actual), sample, sample_names[i][j]) && same_file(expected, actual);
    }
    valid = valid && path_join(expected, sizeof(expected), options->run.reference, "objects.sha256") &&
            path_join(actual, sizeof(actual), sample, "objects.sha256") && same_file(expected, actual);
    if (valid && instrumented)
    {
        struct stat information;
        valid = path_join(actual, sizeof(actual), sample, "stages.tsv") && lstat(actual, &information) == 0 && S_ISREG(information.st_mode) && information.st_size > 0;
    }
    return valid;
}

static bool wait_complete_case(const WaitOptions* options, const Case* input)
{
    const char* pairs[][2] = { { "identity.before.txt", "identity.after.txt" }, { "host-policy.before.txt", "host-policy.after.txt" },
                               { "environment.txt", "environment.after.txt" } };
    bool valid = true;
    for (size_t i = 0; valid && i < sizeof(pairs) / sizeof(pairs[0]); i += 1)
    {
        char a[PATH_MAX], b[PATH_MAX];
        valid = path_join(a, sizeof(a), options->qualified, pairs[i][0]) && path_join(b, sizeof(b), options->qualified, pairs[i][1]) && same_file(a, b);
    }
    char summary_path[PATH_MAX];
    struct stat info;
    valid = valid && path_join(summary_path, sizeof(summary_path), options->qualified, "summary.tsv") && lstat(summary_path, &info) == 0 && S_ISREG(info.st_mode) && info.st_size > 0;
    valid = valid && wait_timing_sample(options, input, "reference", 1, false, false);
    for (unsigned slot = 0; valid && slot <= BUSTER_LANES; slot += 1)
    {
        char name[64];
        snprintf(name, sizeof(name), "warmup-%u", slot);
        valid = wait_timing_sample(options, input, name, slot < BUSTER_LANES ? slot + 1 : 1, false, slot == BUSTER_LANES);
    }
    for (unsigned run = 1; valid && run <= 7; run += 1)
    {
        for (unsigned slot = 0; valid && slot <= BUSTER_LANES; slot += 1)
        {
            char name[64];
            snprintf(name, sizeof(name), "run-%03u-%u", run, slot);
            valid = wait_timing_sample(options, input, name, slot < BUSTER_LANES ? slot + 1 : 1, false, slot == BUSTER_LANES);
        }
    }
    for (unsigned slot = 0; valid && slot <= BUSTER_LANES; slot += 1)
    {
        char name[64];
        snprintf(name, sizeof(name), "diagnostic-%u", slot);
        valid = wait_timing_sample(options, input, name, slot < BUSTER_LANES ? slot + 1 : 1, true, slot == BUSTER_LANES);
    }
    return valid;
}

static bool wait_reference(const WaitOptions* options, const Case* input)
{
    char status[PATH_MAX], reference[PATH_MAX], original_case[PATH_MAX], before[PATH_MAX], after[PATH_MAX];
    size_t length = 0;
    bool valid = path_join(status, sizeof(status), options->qualified, "case-status.txt");
    char* text = valid ? read_text(status, &length) : NULL;
    const char* wanted_status = options->smoke ? "case-status=failed\nparent-issue-status=not-established\n" :
                                                  "case-status=qualified\nparent-issue-status=not-established-by-one-case\n";
    valid = valid && text != NULL && strlen(text) == length && strcmp(text, wanted_status) == 0 &&
                 path_join(reference, sizeof(reference), options->qualified, "reference") && path_join(original_case, sizeof(original_case), options->qualified, "case");
    free(text);
    for (size_t i = 0; valid && i < 4; i += 1)
    {
        char a[PATH_MAX], b[PATH_MAX];
        valid = path_join(a, sizeof(a), original_case, case_files[i]) && path_join(b, sizeof(b), options->run.case_directory, case_files[i]) && same_file(a, b);
    }
    valid = valid && path_join(before, sizeof(before), reference, "identity.before.txt") && path_join(after, sizeof(after), reference, "identity.after.txt") && same_file(before, after);
    text = valid ? read_text(before, &length) : NULL;
    char source_line[PATH_MAX + 32], compiler_line[PATH_MAX + 80];
    snprintf(source_line, sizeof(source_line), "compiler-source=%s\n", options->run.source);
    snprintf(compiler_line, sizeof(compiler_line), WAIT_CONTROL "  %s\n", options->run.compiler);
    valid = valid && text != NULL && strlen(text) == length && strstr(text, source_line) == text &&
            strstr(text, "compiler-revision=" WAIT_REV "\ncompiler-source-state=clean\n") != NULL && strstr(text, compiler_line) != NULL;
    free(text);
    Configuration control = options->run;
    Process observed;
    control.lanes = 1;
    control.instrumented = false;
    control.cpu2 = false;
    valid = valid && copy_string(control.output, sizeof(control.output), reference) && read_sample(&control, input->outputs.count, &observed);
    char objects[PATH_MAX];
    Lines hashes = { 0 };
    valid = valid && path_join(objects, sizeof(objects), reference, "objects.sha256") && read_lines(objects, BUSTER_MAX_OUTPUTS, &hashes) && hashes.count == input->outputs.count;
    for (size_t i = 0; valid && i < hashes.count; i += 1)
    {
        const char* row = hashes.items[i];
        valid = strlen(row) > 66 && row[64] == ' ' && row[65] == ' ' && strcmp(row + 66, input->outputs.items[i]) == 0;
        for (size_t j = 0; valid && j < 64; j += 1) valid = isxdigit((unsigned char)row[j]) != 0;
        char object[PATH_MAX];
        struct stat info;
        valid = valid && path_join(object, sizeof(object), reference, input->outputs.items[i]) && lstat(object, &info) == 0 && S_ISREG(info.st_mode) && info.st_size > 0;
    }
    const int null = valid ? open("/dev/null", O_WRONLY | O_CLOEXEC) : -1;
    char* check[] = { "sha256sum", "--check", "--strict", "--status", objects, NULL };
    valid = valid && null >= 0 && successful(run_process(check, reference, null, null, 30, NULL, false));
    if (null >= 0) valid = close(null) == 0 && valid;
    free_lines(&hashes);
    valid = valid && (options->smoke ? wait_timing_sample(options, input, "reference", 1, false, false) : wait_complete_case(options, input));
    return valid;
}

static bool wait_options(int argc, char** argv, WaitOptions* options)
{
    *options = (WaitOptions){ 0 };
    options->helper = argc > 1 && strcmp(argv[1], "--wait-sample") == 0;
    options->run.instrumented = true;
    options->run.timeout = BUSTER_SAMPLE_SECONDS;
    unsigned seen = 0;
    bool valid = realpath("/proc/self/exe", options->run.executable) != NULL;
    for (int i = options->helper ? 2 : 1; valid && i < argc; i += 1)
    {
        char* field = NULL;
        unsigned bit = 0;
        if (strcmp(argv[i], "--qualified") == 0) { field = options->qualified; bit = 1u; }
        else if (strcmp(argv[i], "--output") == 0) { field = options->run.output; bit = 2u; }
        else if (strcmp(argv[i], "--control-source") == 0) { field = options->run.source; bit = 4u; }
        else if (strcmp(argv[i], "--diagnostic-source") == 0) { field = options->diagnostic_source; bit = 8u; }
        else if (strcmp(argv[i], "--lock") == 0) { field = options->run.lock; bit = 16u; }
        else if (strcmp(argv[i], "--validator") == 0) { field = options->validator; bit = 32u; }
        else if (strcmp(argv[i], "--lanes") == 0 && i + 1 < argc)
        {
            valid = (seen & 64u) == 0 && number(argv[++i], BUSTER_LANES, &options->run.lanes) && options->run.lanes > 0;
            seen |= 64u;
        }
        else if (strcmp(argv[i], "--smoke") == 0)
        {
            valid = (seen & 128u) == 0;
            options->smoke = true;
            seen |= 128u;
        }
        else valid = false;
        if (field != NULL)
        {
            valid = (seen & bit) == 0 && i + 1 < argc && copy_string(field, PATH_MAX, argv[++i]);
            seen |= bit;
        }
    }
    valid = valid && (seen & 127u) == 127u && canonical(options->qualified) && canonical(options->run.source) && canonical(options->diagnostic_source) &&
            canonical(options->run.lock) && canonical(options->validator) && options->run.output[0] == '/' && plain_text(options->run.output) &&
            (!options->helper || canonical(options->run.output));
    valid = valid && path_join(options->run.case_directory, sizeof(options->run.case_directory), options->helper ? options->run.output : options->qualified, "case") &&
            path_join(options->run.reference, sizeof(options->run.reference), options->qualified, "reference") &&
            path_join(options->run.compiler, sizeof(options->run.compiler), options->run.source, "build/compiler") &&
            path_join(options->diagnostic_binary, sizeof(options->diagnostic_binary), options->diagnostic_source, "build/compiler") &&
            access(options->run.compiler, X_OK) == 0 && access(options->diagnostic_binary, X_OK) == 0 && access(options->run.lock, X_OK) == 0;
    return valid;
}

static bool wait_compare_outputs(const char* actual_dir, const char* reference_dir, const Case* input)
{
    bool valid = true;
    for (size_t i = 0; valid && i < input->outputs.count; i += 1)
    {
        char actual[PATH_MAX], reference[PATH_MAX];
        valid = path_join(actual, sizeof(actual), actual_dir, input->outputs.items[i]) &&
                path_join(reference, sizeof(reference), reference_dir, input->outputs.items[i]) && same_file(actual, reference);
    }
    return valid && input->outputs.count != 0;
}

static bool wait_observe(WaitOptions* options)
{
    Configuration* c = &options->run;
    char before[PATH_MAX] = { 0 }, after[PATH_MAX] = { 0 }, sample_dir[PATH_MAX] = { 0 }, before_policy[PATH_MAX] = { 0 }, after_policy[PATH_MAX] = { 0 };
    char environment[PATH_MAX] = { 0 }, environment_after[PATH_MAX] = { 0 }, stderr_path[PATH_MAX] = { 0 }, stdout_path[PATH_MAX] = { 0 }, pid_path[PATH_MAX] = { 0 }, status_path[PATH_MAX] = { 0 };
    bool valid = path_join(before, sizeof(before), c->output, "before") && path_join(after, sizeof(after), c->output, "after") &&
                 path_join(sample_dir, sizeof(sample_dir), c->output, "sample") && mkdir(before, 0700) == 0 && mkdir(sample_dir, 0700) == 0 &&
                 path_join(environment, sizeof(environment), sample_dir, "environment.txt") && path_join(environment_after, sizeof(environment_after), sample_dir, "environment.after.txt") &&
                 path_join(stderr_path, sizeof(stderr_path), sample_dir, "stderr.txt") && path_join(stdout_path, sizeof(stdout_path), sample_dir, "stdout.txt") &&
                 path_join(pid_path, sizeof(pid_path), sample_dir, "compiler.pid") && path_join(status_path, sizeof(status_path), sample_dir, "compiler.status");
    char owner_copy[PATH_MAX];
    size_t owner_length = 0;
    char* owner = valid ? read_text("/var/lib/buster-9700x/owner", &owner_length) : NULL;
    valid = valid && owner != NULL && strlen(owner) == owner_length && strstr(owner, " multicore-149-wait: ") != NULL &&
            path_join(owner_copy, sizeof(owner_copy), c->output, "lock-owner.txt") && write_text(owner_copy, owner);
    free(owner);
    Case input = { 0 };
    valid = valid && read_case(c->case_directory, &input) && wait_reference(options, &input) && wait_identity(options, before) &&
            check_source_hashes(c) && host_receipt(sample_dir, "before") && environment_receipt(environment);
    char timing_policy[PATH_MAX], timing_environment[PATH_MAX], sample_policy[PATH_MAX];
    valid = valid && path_join(timing_policy, sizeof(timing_policy), options->qualified, "host-policy.before.txt") &&
            path_join(timing_environment, sizeof(timing_environment), options->qualified, "environment.txt") &&
            path_join(sample_policy, sizeof(sample_policy), sample_dir, "host-policy.before.txt") &&
            same_file(timing_policy, sample_policy) && same_file(timing_environment, environment);
    char lanes[16], cpus[32];
    snprintf(lanes, sizeof(lanes), "%u", c->lanes);
    valid = valid && lane_cpu_argument(c->lanes, false, cpus, sizeof(cpus));
    char** arguments = valid ? calloc(input.arguments.count + 14, sizeof(*arguments)) : NULL;
    valid = valid && arguments != NULL;
    size_t n = 0;
    if (valid)
    {
        arguments[n++] = c->executable;
        arguments[n++] = "--wait-exec";
        arguments[n++] = pid_path;
        arguments[n++] = options->diagnostic_binary;
        arguments[n++] = "--lanes";
        arguments[n++] = lanes;
        arguments[n++] = "--lane-cpus";
        arguments[n++] = cpus;
        arguments[n++] = "--worker-budget=8";
        arguments[n++] = "--time-stages";
        for (size_t i = 0; i < input.arguments.count; i += 1) arguments[n++] = input.arguments.items[i];
    }
    char command[PATH_MAX], trace_policy[PATH_MAX];
    valid = valid && path_join(trace_policy, sizeof(trace_policy), sample_dir, "trace-policy.txt") &&
            write_text(trace_policy, "BUSTER_WAIT_TRACE=1\nscope=instrumented-session-lanes\nend-policy=forced-join\n") &&
            path_join(command, sizeof(command), sample_dir, "argv.txt");
    FILE* argv_file = valid ? fopen(command, "wx") : NULL;
    valid = valid && argv_file != NULL;
    if (argv_file != NULL)
    {
        for (size_t i = 3; i < n; i += 1) fprintf(argv_file, "%s\n", arguments[i]);
        const bool wrote = !ferror(argv_file);
        const bool closed = fclose(argv_file) == 0;
        valid = valid && wrote && closed;
    }
    const int out = valid ? open(stdout_path, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0600) : -1;
    const int err = valid ? open(stderr_path, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0600) : -1;
    valid = valid && out >= 0 && err >= 0 && setenv("BUSTER_WAIT_TRACE", "1", 1) == 0;
    cpu_set_t mask;
    CPU_ZERO(&mask);
    for (unsigned cpu = 0; cpu < BUSTER_LANES; cpu += 1) CPU_SET(cpu, &mask);
    Process process = { .status = -1 };
    if (valid) process = run_process(arguments, sample_dir, out, err, c->timeout, &mask, true);
    if (out >= 0) valid = close(out) == 0 && valid;
    if (err >= 0) valid = close(err) == 0 && valid;
    free(arguments);
    char process_path[PATH_MAX], process_text[512];
    snprintf(process_text, sizeof(process_text), "wait-status=%d\ninterrupted=%u\nwall-ns=%" PRIu64 "\nuser-us=%" PRIu64 "\nsystem-us=%" PRIu64 "\n",
             process.status, process.interrupted, process.wall_ns, process.user_us, process.system_us);
    const bool process_written = sample_dir[0] != 0 && path_join(process_path, sizeof(process_path), sample_dir, "process.txt") && write_text(process_path, process_text);
    char status[64];
    snprintf(status, sizeof(status), "%d\n", successful(process) ? 0 : 1);
    const bool status_written = status_path[0] != 0 && write_text(status_path, status);
    valid = process_written && status_written && valid && successful(process);
    char pid[64];
    unsigned parsed_pid = 0;
    valid = valid && small_text(pid_path, pid, sizeof(pid)) && number(pid, INT_MAX, &parsed_pid) && parsed_pid > 1;
    char validation[PATH_MAX];
    valid = valid && path_join(validation, sizeof(validation), sample_dir, "validation.txt");
    const int validation_fd = valid ? open(validation, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0600) : -1;
    char* validator[] = { "python3", options->validator, "--cpus", cpus, "--pid", pid, "--status-file", status_path, stderr_path, NULL };
    valid = valid && validation_fd >= 0;
    if (valid) valid = successful(run_process(validator, NULL, validation_fd, validation_fd, 30, NULL, false));
    if (validation_fd >= 0) valid = close(validation_fd) == 0 && valid;
    valid = valid && read_stage_receipt(c, &input, stderr_path, process);
    valid = valid && wait_compare_outputs(sample_dir, c->reference, &input);
    Configuration sample_configuration = *c;
    valid = valid && copy_string(sample_configuration.output, sizeof(sample_configuration.output), sample_dir) && output_hashes(&sample_configuration, &input);
    char observed_hashes[PATH_MAX], reference_hashes[PATH_MAX];
    valid = valid && path_join(observed_hashes, sizeof(observed_hashes), sample_dir, "objects.sha256") &&
            path_join(reference_hashes, sizeof(reference_hashes), c->reference, "objects.sha256") && same_file(observed_hashes, reference_hashes);
    valid = valid && mkdir(after, 0700) == 0 && wait_identity(options, after) && check_source_hashes(c) && wait_reference(options, &input) &&
            host_receipt(sample_dir, "after") && environment_receipt(environment_after) && same_file(environment, environment_after) &&
            path_join(before_policy, sizeof(before_policy), sample_dir, "host-policy.before.txt") &&
            path_join(after_policy, sizeof(after_policy), sample_dir, "host-policy.after.txt") && same_file(before_policy, after_policy);
    const char* identities[] = { "applied.diff", "control.identity", "diagnostic.identity" };
    for (size_t i = 0; valid && i < sizeof(identities) / sizeof(identities[0]); i += 1)
    {
        char a[PATH_MAX], b[PATH_MAX];
        valid = path_join(a, sizeof(a), before, identities[i]) && path_join(b, sizeof(b), after, identities[i]) && same_file(a, b);
    }
    for (size_t i = 0; valid && i < input.outputs.count; i += 1)
    {
        char actual[PATH_MAX];
        valid = path_join(actual, sizeof(actual), sample_dir, input.outputs.items[i]) && unlink(actual) == 0;
    }
    free_case(&input);
    return valid;
}

#ifndef WAIT_OBSERVE_NO_MAIN
int main(int argc, char** argv)
{
    if (!install_signals()) return 1;
    if (argc > 4 && strcmp(argv[1], "--wait-exec") == 0)
    {
        char pid[64];
        snprintf(pid, sizeof(pid), "%ld\n", (long)getpid());
        if (write_text(argv[2], pid)) execv(argv[3], argv + 3);
        return 127;
    }
    if (argc > 2 && strcmp(argv[1], "--wait-guard") == 0)
    {
        if (!held_lock() || setpgid(0, 0) != 0) return 1;
        argv[1] = "--wait-sample";
        return hold_guard(argv, BUSTER_HOLD_SECONDS, BUSTER_HOLD_GRACE_SECONDS, stdout) ? 0 : 1;
    }
    WaitOptions options;
    bool valid = wait_options(argc, argv, &options);
    if (valid && options.helper)
    {
        valid = held_lock() && fcntl(9, F_SETFD, FD_CLOEXEC) == 0 && wait_observe(&options);
        return valid ? 0 : 1;
    }
    const char* inherited = getenv("BUSTER_9700X_HELD");
    valid = valid && (inherited == NULL || *inherited == 0) && mkdir(options.run.output, 0700) == 0 && canonical(options.run.output);
    char frozen[PATH_MAX];
    valid = valid && path_join(frozen, sizeof(frozen), options.run.output, "case") && mkdir(frozen, 0700) == 0;
    for (size_t i = 0; valid && i < 4; i += 1)
    {
        char from[PATH_MAX], to[PATH_MAX];
        valid = path_join(from, sizeof(from), options.run.case_directory, case_files[i]) && path_join(to, sizeof(to), frozen, case_files[i]) && copy_file(from, to);
    }
    char out_path[PATH_MAX] = { 0 }, err_path[PATH_MAX] = { 0 }, result_path[PATH_MAX] = { 0 };
    valid = valid && path_join(out_path, sizeof(out_path), options.run.output, "guard.stdout") && path_join(err_path, sizeof(err_path), options.run.output, "guard.stderr") &&
            path_join(result_path, sizeof(result_path), options.run.output, "observation-status.txt");
    const int out = valid ? open(out_path, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0600) : -1;
    const int err = valid ? open(err_path, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0600) : -1;
    valid = valid && out >= 0 && err >= 0;
    char** args = valid ? calloc((size_t)argc + 3, sizeof(*args)) : NULL;
    valid = valid && args != NULL;
    if (valid)
    {
        args[0] = options.run.lock;
        args[1] = options.run.executable;
        args[2] = "--wait-guard";
        for (int i = 1; i < argc; i += 1) args[i + 2] = argv[i];
    }
    Process wrapper = { .status = -1 };
    valid = valid && setenv("EXCLUSIVE_OWNER", "multicore-149-wait", 1) == 0 && setenv("EXCLUSIVE_TITLE", "Buster issue 149 wait diagnostic", 1) == 0 &&
            setenv("EXCLUSIVE_LINK", "https://github.com/buster14a/buster/issues/149", 1) == 0;
    if (valid) wrapper = run_process(args, NULL, out, err, BUSTER_LOCK_SECONDS, NULL, false);
    if (out >= 0) valid = close(out) == 0 && valid;
    if (err >= 0) valid = close(err) == 0 && valid;
    free(args);
    uint64_t guard_ns = 0;
    valid = valid && successful(wrapper) && read_guard(out_path, &guard_ns) && guard_ns <= wrapper.wall_ns && guard_ns <= WAIT_GUARD_LIMIT_NS;
    char receipt[256];
    snprintf(receipt, sizeof(receipt), "observation-status=%s\nobservation-scope=%s\nguard-monotonic-ns=%" PRIu64 "\nwrapper-wall-ns-including-wait=%" PRIu64 "\nlock-hold-upper-bound-valid=%u\n",
             wait_result_state(valid, options.smoke), options.smoke ? "smoke" : "campaign", guard_ns, wrapper.wall_ns, valid);
    if (result_path[0] != 0) valid = write_text(result_path, receipt) && valid;
    return valid ? 0 : 1;
}
#endif
