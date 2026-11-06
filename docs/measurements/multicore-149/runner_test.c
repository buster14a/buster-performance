// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and THIRD_PARTY_NOTICES.md.
// Included by runner.c. These private configurations bypass the hardware boundary only for this executable's
// synthetic children; no test path invokes campaign or writes case-status=qualified.
#include <ftw.h>

static int fake_compiler(int argc, char** argv, const char* executable)
{
    const char* mode = argc > 0 ? argv[0] : "invalid";
    unsigned lanes = 1;
    const char* cpus = NULL;
    bool instrumented = false;
    bool valid = argc > 0;
    for (int i = 1; valid && i < argc; i += 1)
    {
        if (strcmp(argv[i], "--lanes") == 0)
        {
            valid = i + 1 < argc && number(argv[++i], BUSTER_LANES, &lanes) && lanes > 0;
        }
        else if (strcmp(argv[i], "--lane-cpus") == 0)
        {
            valid = cpus == NULL && i + 1 < argc;
            cpus = valid ? argv[++i] : NULL;
        }
        instrumented = instrumented || strcmp(argv[i], "--time-stages") == 0;
    }
    int result = 1;
    if (valid && strcmp(mode, "exit") == 0)
    {
        result = 7;
    }
    else if (valid && strcmp(mode, "signal") == 0)
    {
        raise(SIGUSR1);
    }
    else if (valid && strcmp(mode, "timeout") == 0)
    {
        char pid[64];
        snprintf(pid, sizeof(pid), "%ld\n", (long)getpid());
        valid = write_text("pid.txt", pid);
        signal(SIGTERM, SIG_IGN);
        while (valid)
        {
            pause();
        }
    }
    else if (valid && strcmp(mode, "nested") == 0)
    {
        char* child[] = { (char*)executable, "--fake-compiler", "timeout", NULL };
        const Process process = run_process(child, NULL, STDOUT_FILENO, STDERR_FILENO, 30, NULL, true);
        result = successful(process) ? 0 : 17;
    }
    else if (valid && strcmp(mode, "orphan-worker") == 0)
    {
        const pid_t descendant = fork();
        if (descendant == 0)
        {
            (void)setsid();
            signal(SIGTERM, SIG_IGN);
            char pid[64];
            snprintf(pid, sizeof(pid), "%ld\n", (long)getpid());
            if (!write_text("descendant-pid.txt", pid)) _exit(1);
            for (;;) pause();
        }
        signal(SIGTERM, SIG_IGN);
        for (;;) pause();
    }
    else if (valid && strcmp(mode, "orphan-helper") == 0)
    {
        // Simulate an unresponsive sample helper killed before it can clean its own worker group.
        signal(SIGTERM, SIG_IGN);
        const pid_t worker = fork();
        if (worker == 0)
        {
            (void)setpgid(0, 0);
            execl(executable, executable, "--fake-compiler", "orphan-worker", (char*)NULL);
            _exit(127);
        }
        for (;;) pause();
    }
    else if (valid && strcmp(mode, "outer-guard") == 0)
    {
        if (setpgid(0, 0) != 0) return 1;
        if (!write_text("guard-ready.txt", "separate-group\n")) return 1;
        char* helper[] = { (char*)executable, "--fake-compiler", "orphan-helper", NULL };
        FILE* receipt = fopen("outer-receipt.txt", "w");
        const bool accepted = receipt != NULL && hold_guard(helper, 3, 1, receipt);
        const bool closed = receipt != NULL && fclose(receipt) == 0;
        return !accepted && closed && write_text("outer-complete.txt", "incomplete\n") ? 0 : 1;
    }
    else if (valid && strcmp(mode, "outer-race-guard") == 0)
    {
        // A timeout before setpgid/child creation kills this process with the wrapper group.
        signal(SIGTERM, SIG_IGN);
        sleep(3);
        return write_text("unexpected-child.txt", "started\n") ? 0 : 1;
    }
    else if (valid && (strcmp(mode, "outer-wrapper") == 0 || strcmp(mode, "outer-race-wrapper") == 0))
    {
        const int lock = open("outer-lock", O_RDWR | O_CREAT, 0600);
        if (lock < 0 || dup2(lock, 9) < 0 || flock(9, LOCK_EX) != 0) return 1;
        if (lock != 9) close(lock);
        const pid_t guard = fork();
        if (guard == 0)
        {
            const char* guard_mode = strcmp(mode, "outer-wrapper") == 0 ? "outer-guard" : "outer-race-guard";
            execl(executable, executable, "--fake-compiler", guard_mode, (char*)NULL);
            _exit(127);
        }
        if (guard < 0) return 1;
        signal(SIGTERM, SIG_DFL); // Model exclusive.sh exiting immediately on the outer watchdog's TERM.
        for (;;) pause();
    }
    else if (valid)
    {
        char primary[32];
        char control[32];
        valid = lane_cpu_argument(lanes, false, primary, sizeof(primary)) && lane_cpu_argument(1, true, control, sizeof(control)) &&
                cpus != NULL && (strcmp(cpus, primary) == 0 || (lanes == 1 && strcmp(cpus, control) == 0));
        // Make the positive path depend on sanitization, rather than just checking a printed policy string.
        const char* epoch = getenv("SOURCE_DATE_EPOCH");
        valid = valid && getenv("MAKEFLAGS") == NULL && getenv("MFLAGS") == NULL && getenv("CPATH") == NULL && getenv("BUSTER_TEST_149") == NULL &&
                epoch != NULL && strcmp(epoch, "0") == 0;
        if (valid && strcmp(mode, "missing") != 0)
        {
            valid = strcmp(mode, "symlink") == 0 ? symlink("/dev/null", "unit.o") == 0 :
                    write_text("unit.o", strcmp(mode, "changed") == 0 ? "changed fixture\n" : strcmp(mode, "empty") == 0 ? "" : "original object fixture\n");
        }
        if (valid && instrumented && strcmp(mode, "no-report") != 0)
        {
            fprintf(stderr, "time-process\tlanes-asked\t%u\n", lanes);
            fprintf(stderr, "time-process\tlanes\t%u\n", strcmp(mode, "bad-lanes") == 0 ? lanes + 1 : lanes);
            if (strcmp(mode, "duplicate-lanes") == 0)
            {
                fprintf(stderr, "time-process\tlanes\t%u\n", lanes);
            }
            for (unsigned lane = lanes; lane > 0; lane -= 1)
            {
                const unsigned index = lane - 1;
                const unsigned cpu = lanes == 1 && strcmp(cpus, control) == 0 ? 2u : index;
                if (strcmp(mode, "missing-pin") == 0 && index == 0)
                {
                    continue;
                }
                if (index == 0 && (strcmp(mode, "missing-tabs") == 0 || strcmp(mode, "signed-field") == 0 || strcmp(mode, "spaced-field") == 0 || strcmp(mode, "carriage-suffix") == 0))
                {
                    if (strcmp(mode, "missing-tabs") == 0)
                    {
                        fprintf(stderr, "lane-pinindex=%uexpected=%uobserved=%ustatus=0\n", index, cpu, cpu);
                    }
                    else if (strcmp(mode, "signed-field") == 0)
                    {
                        fprintf(stderr, "lane-pin\tindex=+%u\texpected=%u\tobserved=%u\tstatus=0\n", index, cpu, cpu);
                    }
                    else if (strcmp(mode, "carriage-suffix") == 0)
                    {
                        fprintf(stderr, "lane-pin\tindex=%u\texpected=%u\tobserved=%u\tstatus=0\rignored\n", index, cpu, cpu);
                    }
                    else
                    {
                        fprintf(stderr, "lane-pin\tindex=%u\texpected= %u\tobserved=%u\tstatus=0\n", index, cpu, cpu);
                    }
                    continue;
                }
                fprintf(stderr, "lane-pin\tindex=%u\texpected=%u\tobserved=%u\tstatus=%d%s\n",
                        strcmp(mode, "extra-index") == 0 && index == 0 ? lanes : index, cpu,
                        strcmp(mode, "wrong-cpu") == 0 && index == 0 ? cpu + 1 : cpu,
                        strcmp(mode, "pin-error") == 0 && index == 0 ? -1 : 0,
                        strcmp(mode, "malformed-pin") == 0 && index == 0 ? " extra" : "");
                if (strcmp(mode, "duplicate-pin") == 0 && index == 0)
                {
                    fprintf(stderr, "lane-pin\tindex=%u\texpected=%u\tobserved=%u\tstatus=0\n", index, cpu, cpu);
                }
            }
            for (size_t s = 0; s < BUSTER_STAGES; s += 1)
            {
                fprintf(stderr, "time-stage\t%s\t%.3f\t0.0\t0.0\t0\t0\n", stage_names[s], s == 0 || strcmp(stage_names[s], "lanes") == 0 ? 0.001 : 0.0);
            }
            fprintf(stderr, "time-stage\tlower.prepare\t0.000\t0.0\n");
            fprintf(stderr, "time-stage\ttotal\t0.002\t100.0\n");
        }
        result = valid ? 0 : 1;
    }
    return result;
}

static int remove_test_path(const char* path, const struct stat* status, int kind, struct FTW* walk)
{
    (void)status;
    (void)kind;
    (void)walk;
    return remove(path);
}

static void test_expect(unsigned* checks, unsigned* failures, bool passed, const char* name)
{
    *checks += 1;
    *failures += !passed;
    fprintf(stdout, "%s %s\n", passed ? "PASS" : "FAIL", name);
}

static bool test_read_case(const char* directory)
{
    Case input = { 0 };
    const bool valid = read_case(directory, &input);
    free_case(&input);
    return valid;
}

static int runner_self_test(const char* executable)
{
    const char* temporary = getenv("TMPDIR");
    temporary = temporary != NULL && *temporary != 0 ? temporary : "/tmp";
    char directory[PATH_MAX];
    const int length = snprintf(directory, sizeof(directory), "%s/multicore-149-self-test-XXXXXX", temporary);
    bool ready = length > 0 && (size_t)length < sizeof(directory) && mkdtemp(directory) != NULL;
    char source[PATH_MAX];
    char arguments_path[PATH_MAX];
    char outputs_path[PATH_MAX];
    char hashes_path[PATH_MAX];
    char provenance[PATH_MAX];
    ready = ready && path_join(source, sizeof(source), directory, "unit.c") && path_join(arguments_path, sizeof(arguments_path), directory, "args.txt") &&
            path_join(outputs_path, sizeof(outputs_path), directory, "outputs.txt") && path_join(hashes_path, sizeof(hashes_path), directory, "sources.sha256") &&
            path_join(provenance, sizeof(provenance), directory, "provenance.txt");
    char arguments[PATH_MAX + 32];
    snprintf(arguments, sizeof(arguments), "-c\n%s\n", ready ? source : "missing");
    ready = ready && write_text(source, "int unit;\n") && write_text(arguments_path, arguments) && write_text(outputs_path, "unit.o\n") && write_text(provenance, "self-test fixture; no performance acceptance\n");
    char hashes[PATH_MAX + 128];
    char* hash_command[] = { "sha256sum", "--", source, NULL };
    ready = ready && capture(hash_command, hashes, sizeof(hashes)) && write_text(hashes_path, hashes);
    unsigned checks = 0;
    unsigned failures = 0;
    test_expect(&checks, &failures, ready, "create bounded test fixture");
    Case input = { 0 };
    ready = ready && read_case(directory, &input);
    test_expect(&checks, &failures, ready, "valid manifest and source/output mapping");
    Configuration configuration = {
        .runs = 3,
        .lanes = 1,
        .fake_mode = "ok",
        .timeout = 4,
    };
    ready = ready && copy_string(configuration.compiler, sizeof(configuration.compiler), executable) &&
            copy_string(configuration.case_directory, sizeof(configuration.case_directory), directory);
    if (ready)
    {
        test_expect(&checks, &failures, check_source_hashes(&configuration), "source hash verification accepts exact input");
        const bool changed = write_text(source, "int changed;\n");
        test_expect(&checks, &failures, changed && !check_source_hashes(&configuration), "changed input is rejected");
        ready = write_text(source, "int unit;\n") && ready;
        ready = setenv("MAKEFLAGS", "--jobserver-auth=998,999 -j8", 1) == 0 && setenv("MFLAGS", "-j8", 1) == 0 &&
                setenv("CPATH", "/not-a-frozen-header-root", 1) == 0 && setenv("BUSTER_TEST_149", "1", 1) == 0 && ready;
        ready = path_join(configuration.output, sizeof(configuration.output), directory, "reference") && mkdir(configuration.output, 0700) == 0 && ready;
        Process process;
        ready = ready && sample(&configuration, &input, &process);
        test_expect(&checks, &failures, ready && successful(process), "fresh one-lane reference and sanitized compiler environment");
        ready = ready && copy_string(configuration.reference, sizeof(configuration.reference), configuration.output);
    }
    if (ready)
    {
        configuration.lanes = 8;
        configuration.instrumented = true;
        ready = path_join(configuration.output, sizeof(configuration.output), directory, "positive") && mkdir(configuration.output, 0700) == 0;
        Process process;
        const bool passed = ready && sample(&configuration, &input, &process);
        test_expect(&checks, &failures, passed, "eight-lane bytes and unordered complete unique stage/team/pin receipts");
        Process reloaded = { 0 };
        test_expect(&checks, &failures, passed && read_sample(&configuration, 1, &reloaded) && reloaded.wall_ns == process.wall_ns, "raw sample receipt reads back exact wall time and status");
    }
    if (ready)
    {
        configuration.lanes = 1;
        ready = path_join(configuration.output, sizeof(configuration.output), directory, "diagnostic-0") && mkdir(configuration.output, 0700) == 0;
        Process process = { .status = -1 };
        const bool passed = ready && sample(&configuration, &input, &process);
        Configuration controller = configuration;
        const bool named = copy_string(controller.output, sizeof(controller.output), directory);
        double share = 0;
        const bool model = passed && named && one_lane_serial_share(&controller, &share);
        const double serial_ns = share * (double)process.wall_ns;
        test_expect(&checks, &failures, model && serial_ns > 999 && serial_ns < 1001, "summary serial fraction uses the primary one-lane paired wall");
        Process samples[(BUSTER_LANES + 1) * 3];
        for (size_t i = 0; i < sizeof(samples) / sizeof(*samples); i += 1)
        {
            samples[i] = process;
        }
        test_expect(&checks, &failures, model && summary(&controller, samples), "timing summary includes one-lane model bounds");
        configuration.lanes = 8;
    }
    if (ready)
    {
        configuration.lanes = 1;
        configuration.cpu2 = true;
        ready = path_join(configuration.output, sizeof(configuration.output), directory, "cpu2") && mkdir(configuration.output, 0700) == 0;
        Process process;
        const bool passed = ready && sample(&configuration, &input, &process);
        test_expect(&checks, &failures, passed, "CPU-2 control requests and verifies the CPU-2 lane receipt");
        configuration.lanes = 8;
        configuration.cpu2 = false;
    }
    const char* modes[] = { "exit", "signal", "timeout", "missing", "changed", "empty", "symlink", "bad-lanes", "duplicate-lanes", "no-report",
                            "missing-pin", "duplicate-pin", "wrong-cpu", "pin-error", "extra-index", "malformed-pin", "missing-tabs", "signed-field", "spaced-field", "carriage-suffix" };
    for (size_t i = 0; ready && i < sizeof(modes) / sizeof(modes[0]); i += 1)
    {
        configuration.fake_mode = modes[i];
        configuration.timeout = strcmp(modes[i], "timeout") == 0 ? 1 : 4;
        ready = path_join(configuration.output, sizeof(configuration.output), directory, modes[i]) && mkdir(configuration.output, 0700) == 0;
        char stale[PATH_MAX];
        bool stale_written = true;
        if (ready && strcmp(modes[i], "missing") == 0)
        {
            stale_written = path_join(stale, sizeof(stale), configuration.output, "unit.o") && write_text(stale, "original object fixture\n");
        }
        Process process;
        const bool passed = ready && sample(&configuration, &input, &process);
        test_expect(&checks, &failures, ready && stale_written && !passed, modes[i]);
        if (ready && strcmp(modes[i], "missing") == 0)
        {
            test_expect(&checks, &failures, access(stale, F_OK) != 0 && errno == ENOENT, "stale output was removed and cannot prove success");
        }
    }
    if (ready)
    {
        char nested[PATH_MAX];
        char pid_path[PATH_MAX];
        ready = path_join(nested, sizeof(nested), directory, "nested") && mkdir(nested, 0700) == 0 && path_join(pid_path, sizeof(pid_path), nested, "pid.txt");
        char* child[] = { (char*)executable, "--fake-compiler", "nested", NULL };
        const int null = open("/dev/null", O_RDWR | O_CLOEXEC);
        const Process process = ready && null >= 0 ? run_process(child, nested, null, null, 1, NULL, false) : (Process){ .status = -1 };
        if (null >= 0)
        {
            close(null);
        }
        char pid_text[64];
        unsigned pid = 0;
        const bool recorded = ready && small_text(pid_path, pid_text, sizeof(pid_text)) && number(pid_text, INT_MAX, &pid) && pid > 1;
        const bool gone = recorded && kill((pid_t)pid, 0) < 0 && errno == ESRCH;
        test_expect(&checks, &failures, process.interrupted && !successful(process) && gone, "outer timeout lets inner helper kill and reap a TERM-ignoring compiler");
    }
    if (ready)
    {
        char guard_path[PATH_MAX];
        ready = path_join(guard_path, sizeof(guard_path), directory, "guard.receipt");
        FILE* receipt = ready ? fopen(guard_path, "w") : NULL;
        char* good[] = { "/bin/true", NULL };
        const bool good_result = receipt != NULL && hold_guard(good, 5, 2, receipt);
        const bool good_closed = receipt != NULL && fclose(receipt) == 0;
        uint64_t elapsed = 0;
        test_expect(&checks, &failures, good_result && good_closed && read_guard(guard_path, &elapsed) && elapsed > 0, "successful guard emits a valid duration receipt");
        ready = ready && write_text(guard_path, "lock-guard\tstart-realtime-ns=1\tend-realtime-ns=2\tmonotonic-ns=3\tstatus=0\tinterrupted=0\tdescendants-clean=1\nextra\n");
        test_expect(&checks, &failures, ready && !read_guard(guard_path, &elapsed), "guard rejects extra or duplicate receipt data");
        ready = ready && write_text(guard_path, "lock-guard\tstart-realtime-ns=1\tend-realtime-ns=2\tmonotonic-ns=3\tstatus=0\tinterrupted=1\tdescendants-clean=1\n");
        test_expect(&checks, &failures, ready && !read_guard(guard_path, &elapsed), "interrupted guard receipt is incomplete");
        char nested[PATH_MAX], pid_path[PATH_MAX];
        ready = ready && path_join(nested, sizeof(nested), directory, "guard-nested") && mkdir(nested, 0700) == 0 &&
                path_join(pid_path, sizeof(pid_path), nested, "pid.txt");
        const int original = open(".", O_RDONLY | O_DIRECTORY | O_CLOEXEC);
        receipt = ready ? fopen(guard_path, "w") : NULL;
        char* child[] = { (char*)executable, "--fake-compiler", "nested", NULL };
        const bool entered = original >= 0 && receipt != NULL && chdir(nested) == 0;
        const bool guard_result = entered && hold_guard(child, 1, 6, receipt);
        const bool restored = original >= 0 && fchdir(original) == 0;
        if (original >= 0) close(original);
        const bool closed = receipt != NULL && fclose(receipt) == 0;
        char pid_text[64];
        unsigned pid = 0;
        const bool recorded = ready && small_text(pid_path, pid_text, sizeof(pid_text)) && number(pid_text, INT_MAX, &pid) && pid > 1;
        const bool gone = recorded && kill((pid_t)pid, 0) < 0 && errno == ESRCH;
        test_expect(&checks, &failures, entered && restored && closed && !guard_result && !read_guard(guard_path, &elapsed) && gone,
                    "guard timeout fails and reaps a TERM-ignoring nested compiler");
        char descendant_path[PATH_MAX];
        ready = ready && path_join(descendant_path, sizeof(descendant_path), nested, "descendant-pid.txt");
        const int saved = open(".", O_RDONLY | O_DIRECTORY | O_CLOEXEC);
        receipt = ready ? fopen(guard_path, "w") : NULL;
        char* orphan[] = { (char*)executable, "--fake-compiler", "orphan-helper", NULL };
        const bool orphan_entered = saved >= 0 && receipt != NULL && chdir(nested) == 0;
        const bool orphan_result = orphan_entered && hold_guard(orphan, 1, 1, receipt);
        const bool orphan_restored = saved >= 0 && fchdir(saved) == 0;
        if (saved >= 0) close(saved);
        const bool orphan_closed = receipt != NULL && fclose(receipt) == 0;
        pid = 0;
        const bool descendant_recorded = ready && small_text(descendant_path, pid_text, sizeof(pid_text)) && number(pid_text, INT_MAX, &pid) && pid > 1;
        const bool descendant_gone = descendant_recorded && kill((pid_t)pid, 0) < 0 && errno == ESRCH;
        test_expect(&checks, &failures, orphan_entered && orphan_restored && orphan_closed && !orphan_result && descendant_gone,
                    "subreaper cleans an escaped descendant after killing an unresponsive helper");
        char outer[PATH_MAX], outer_done[PATH_MAX], outer_pid[PATH_MAX], outer_lock[PATH_MAX], outer_ready[PATH_MAX];
        ready = ready && path_join(outer, sizeof(outer), directory, "outer") && mkdir(outer, 0700) == 0 &&
                path_join(outer_done, sizeof(outer_done), outer, "outer-complete.txt") &&
                path_join(outer_pid, sizeof(outer_pid), outer, "descendant-pid.txt") &&
                path_join(outer_lock, sizeof(outer_lock), outer, "outer-lock") && path_join(outer_ready, sizeof(outer_ready), outer, "guard-ready.txt");
        char* outer_child[] = { (char*)executable, "--fake-compiler", "outer-wrapper", NULL };
        const int outer_null = open("/dev/null", O_RDWR | O_CLOEXEC);
        const Process outer_process = ready && outer_null >= 0 ? run_process(outer_child, outer, outer_null, outer_null, 1, NULL, false) : (Process){ .status = -1 };
        if (outer_null >= 0) close(outer_null);
        const int contender = open(outer_lock, O_RDWR | O_CLOEXEC);
        const bool held = contender >= 0 && flock(contender, LOCK_EX | LOCK_NB) < 0 && (errno == EWOULDBLOCK || errno == EAGAIN);
        const uint64_t outer_start = now_ns();
        while (access(outer_done, F_OK) != 0 && now_ns() - outer_start < UINT64_C(8000000000))
        {
            const struct timespec pause = { .tv_nsec = 10000000 };
            (void)nanosleep(&pause, NULL);
        }
        pid = 0;
        const bool outer_recorded = small_text(outer_pid, pid_text, sizeof(pid_text)) && number(pid_text, INT_MAX, &pid) && pid > 1;
        const bool outer_gone = outer_recorded && kill((pid_t)pid, 0) < 0 && errno == ESRCH;
        bool released = false;
        const uint64_t release_start = now_ns();
        do
        {
            released = contender >= 0 && flock(contender, LOCK_EX | LOCK_NB) == 0;
            if (!released)
            {
                const struct timespec pause = { .tv_nsec = 10000000 };
                (void)nanosleep(&pause, NULL);
            }
        } while (!released && now_ns() - release_start < UINT64_C(2000000000));
        if (contender >= 0) close(contender);
        test_expect(&checks, &failures, outer_process.interrupted && access(outer_ready, F_OK) == 0, "outer wrapper timed out after guard entered its own group");
        test_expect(&checks, &failures, held, "guard retains fd 9 lock after the outer wrapper dies");
        test_expect(&checks, &failures, access(outer_done, F_OK) == 0 && outer_gone, "separate guard cleans active descendants after wrapper timeout");
        test_expect(&checks, &failures, released, "fd 9 lock is released when separate guard exits");
        while (waitpid(-1, NULL, WNOHANG) > 0) { }
        char race[PATH_MAX], race_lock[PATH_MAX], unexpected[PATH_MAX];
        ready = ready && path_join(race, sizeof(race), directory, "outer-race") && mkdir(race, 0700) == 0 &&
                path_join(race_lock, sizeof(race_lock), race, "outer-lock") && path_join(unexpected, sizeof(unexpected), race, "unexpected-child.txt");
        char* race_child[] = { (char*)executable, "--fake-compiler", "outer-race-wrapper", NULL };
        const int race_null = open("/dev/null", O_RDWR | O_CLOEXEC);
        const Process race_process = ready && race_null >= 0 ? run_process(race_child, race, race_null, race_null, 1, NULL, false) : (Process){ .status = -1 };
        if (race_null >= 0) close(race_null);
        const int race_contender = open(race_lock, O_RDWR | O_CLOEXEC);
        bool race_released = false;
        const uint64_t race_start = now_ns();
        do
        {
            race_released = race_contender >= 0 && flock(race_contender, LOCK_EX | LOCK_NB) == 0;
            if (!race_released)
            {
                const struct timespec pause = { .tv_nsec = 10000000 };
                (void)nanosleep(&pause, NULL);
            }
        } while (!race_released && now_ns() - race_start < UINT64_C(2000000000));
        if (race_contender >= 0) close(race_contender);
        test_expect(&checks, &failures, race_process.interrupted && race_released && access(unexpected, F_OK) != 0,
                    "outer timeout before guard process-group setup starts no descendants and releases fd 9");
        char* forbidden[] = { (char*)executable, "--hold-guard", "--case", NULL };
        const int null = open("/dev/null", O_RDWR | O_CLOEXEC);
        const Process refused = null >= 0 ? run_process(forbidden, directory, null, null, 5, NULL, false) : (Process){ .status = -1 };
        if (null >= 0) close(null);
        test_expect(&checks, &failures, refused.status != -1 && !successful(refused), "guard rejects an invocation outside the host lock");
    }
    if (ready)
    {
        ready = write_text(outputs_path, "unit.o\nunit.o\n");
        test_expect(&checks, &failures, ready && !test_read_case(directory), "duplicate output manifest is rejected");
        ready = write_text(outputs_path, "../unit.o\n") && ready;
        test_expect(&checks, &failures, ready && !test_read_case(directory), "unsafe output path is rejected");
        ready = write_text(outputs_path, "unit.o\n") && write_text(arguments_path, "-c\n--lanes=8\n") && ready;
        test_expect(&checks, &failures, ready && !test_read_case(directory), "case cannot override lane ownership");
        ready = write_text(arguments_path, "-c\n--lane-cpus=2\n") && ready;
        test_expect(&checks, &failures, ready && !test_read_case(directory), "case cannot override lane CPU assignment");
        char file_arguments[2 * PATH_MAX + 128];
        snprintf(file_arguments, sizeof(file_arguments), "-c\n--predefines\n%s\n%s\n", source, source);
        ready = write_text(arguments_path, file_arguments) && ready;
        test_expect(&checks, &failures, ready && test_read_case(directory), "hashed file operand is required but not counted as a translation unit");
        const char* file_options[] = { "--predefines=", "-include", "-imacros" };
        for (size_t i = 0; ready && i < sizeof(file_options) / sizeof(*file_options); i += 1)
        {
            snprintf(file_arguments, sizeof(file_arguments), "-c\n%s/not-in-the-source-manifest.h\n%s\n", file_options[i], source);
            ready = write_text(arguments_path, file_arguments);
            test_expect(&checks, &failures, ready && !test_read_case(directory), "unhashed predefines/include/imacros input is rejected");
        }
        ready = write_text(arguments_path, arguments) && write_text(hashes_path, "not-a-sha256\n") && ready;
        test_expect(&checks, &failures, ready && !test_read_case(directory), "malformed input digest is rejected");
        ready = write_text(hashes_path, hashes) && write_text(outputs_path, "unit.o") && ready;
        test_expect(&checks, &failures, ready && !test_read_case(directory), "unterminated manifest is rejected");
        test_expect(&checks, &failures, cpu_list("0,1,2,3,4,5,6,7") && !cpu_list("0,1,2,3,4,5,6,6") && !cpu_list("0,1,2,3"), "exact eight-core affinity control is required");
        char* forbidden[] = { (char*)executable, "--self-test", "--sample", NULL };
        const int null = open("/dev/null", O_RDWR | O_CLOEXEC);
        const Process refused = null >= 0 ? run_process(forbidden, directory, null, null, 5, NULL, false) : (Process){ .status = -1 };
        if (null >= 0)
        {
            close(null);
        }
        test_expect(&checks, &failures, refused.status != -1 && !successful(refused), "self-test flag cannot become a production sample bypass");
    }
    free_case(&input);
    const bool passed = ready && failures == 0;
    printf("runner self-test: %u checks, %u failures; acceptance=no\n", checks, failures);
    if (passed)
    {
        ready = nftw(directory, remove_test_path, 16, FTW_DEPTH | FTW_PHYS) == 0;
    }
    else
    {
        fprintf(stderr, "multicore-149: retained self-test failure files at %s\n", directory);
    }
    return passed && ready ? 0 : 1;
}
