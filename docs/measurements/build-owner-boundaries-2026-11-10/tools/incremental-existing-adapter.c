// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Evidence-only entry point for the existing check_incremental() workflow on an already-built configuration.
// It does not replace dependency parsing, owner expectations, counts, or any production checks.
#define main buster_regression_program_main
#include "tools/ci/build_regression.c"
#undef main

static char evidence_model_path[PATH_MAX];
static struct timespec evidence_model_times[2];
static bool evidence_model_saved;

static void evidence_restore_model_times(void)
{
    if (evidence_model_saved)
    {
        if (utimensat(AT_FDCWD, evidence_model_path, evidence_model_times, 0) != 0)
        {
            fprintf(stderr, "incremental-evidence: can't restore model-unit timestamps: %s\n", strerror(errno));
            _Exit(1);
        }
        evidence_model_saved = false;
    }
}

static void evidence_incremental_signal(int number)
{
    evidence_restore_model_times();
    signal(number, SIG_DFL);
    raise(number);
}

static void evidence_configuration_records(const char* configuration)
{
    char manifest[64];
    snprintf(manifest, sizeof(manifest), "build-%s.ninja", configuration);
    char* arguments[] = { "ninja", "-C", tree, "-f", manifest, "-t", "deps", NULL };
    Text text = capture(arguments);
    uint32_t release_records = 0;
    uint32_t debug_records = 0;
    char* saved = NULL;
    for (char* line = strtok_r(text.data, "\n", &saved); line != NULL; line = strtok_r(NULL, "\n", &saved))
    {
        if (strstr(line, ": #deps ") != NULL)
        {
            release_records += strstr(line, ".dir/Release/") != NULL;
            debug_records += strstr(line, ".dir/Debug/") != NULL;
        }
    }
    printf("real_ninja_dependencies: manifest=%s Release_records=%u Debug_records=%u\n", manifest, release_records, debug_records);
    if ((strcmp(configuration, "Release") == 0 && release_records == 0) ||
        (strcmp(configuration, "Debug") == 0 && debug_records == 0)) fail("selected configuration has no actual dependency records");
    free(text.data);
}

int main(int argc, char** argv)
{
    if (argc != 2)
    {
        fprintf(stderr, "usage: %s EVIDENCE_DIRECTORY\n", argv[0]);
        return 2;
    }
    const char* architecture = getenv("BUSTER_HOST_ARCH");
    const char* debug_information = getenv("BUSTER_DEBUG_INFO");
    if (architecture == NULL || architecture[0] == 0 || debug_information == NULL || strcmp(debug_information, "0") != 0)
        fail("set BUSTER_HOST_ARCH explicitly and BUSTER_DEBUG_INFO=0");
    if (getcwd(root, sizeof(root)) == NULL || access("build.sh", X_OK) != 0) fail("run from the repository root");
    if (snprintf(work, sizeof(work), "%s/incremental-existing-XXXXXX", argv[1]) >= (int)sizeof(work) || mkdtemp(work) == NULL)
        fail("can't create isolated incremental evidence directory");
    if (snprintf(evidence_model_path, sizeof(evidence_model_path), "%s/%s", root, edited_unit) >= (int)sizeof(evidence_model_path))
        fail("model-unit path is too long");
    const struct stat model = status_of(evidence_model_path);
    evidence_model_times[0] = model.st_atim;
    evidence_model_times[1] = model.st_mtim;
    evidence_model_saved = true;
    if (atexit(evidence_restore_model_times) != 0) fail("can't register model-unit timestamp restoration");
    signal(SIGINT, evidence_incremental_signal);
    signal(SIGTERM, evidence_incremental_signal);

    char* output[] = { "./build.sh", "print-output", NULL };
    char* output_debug[] = { "./build.sh", "print-output", "--config", "Debug", NULL };
    capture_line(output, release, sizeof(release));
    capture_line(output_debug, debug, sizeof(debug));
    snprintf(tree, sizeof(tree), "%s", release);
    char* slash = strrchr(tree, '/');
    if (slash == NULL) fail("Release output has no configuration directory");
    *slash = 0;
    slash = strrchr(tree, '/');
    if (slash == NULL) fail("Release output has no build tree");
    *slash = 0;
    snprintf(ninja_log, sizeof(ninja_log), "%s/.ninja_log", tree);
    if (access(release, X_OK) != 0 || access(ninja_log, R_OK) != 0) fail("selected Release configuration must already be built");
    const bool debug_built = access(debug, X_OK) == 0;
    printf("validation_scope: existing check_incremental() only; no clean/configuration/failure suites\n");
    printf("architecture=%s debug_information=%s\nroot=%s\ntree=%s\nrelease=%s\ndebug=%s\nwork=%s\n",
           architecture, debug_information, root, tree, release, debug, work);
    printf("configuration_coexistence: Release_built=1 Debug_built=%u\n", debug_built);
    evidence_configuration_records("Release");
    if (debug_built) evidence_configuration_records("Debug");
    puts("record_selection: production dependents() is unchanged; no legacy helper failure is claimed");
    fflush(stdout);

    check_incremental();

    evidence_restore_model_times();
    const struct stat restored = status_of(evidence_model_path);
    if (restored.st_atim.tv_sec != model.st_atim.tv_sec || restored.st_atim.tv_nsec != model.st_atim.tv_nsec ||
        restored.st_mtim.tv_sec != model.st_mtim.tv_sec || restored.st_mtim.tv_nsec != model.st_mtim.tv_nsec)
        fail("model-unit timestamps differ after restoration");
    puts("model_unit_timestamps: RESTORED exactly");
    char names[8192];
    if (planned(names, sizeof(names))) fail("restored Release configuration has remaining work: %s", names);
    puts("final_Release_noop: PASS");
    if (debug_built)
    {
        char* plan_arguments[] = { "ninja", "-C", tree, "-f", "build-Debug.ninja", "-n", "compiler", NULL };
        Text plan = capture(plan_arguments);
        if (strstr(plan.data, "ninja: no work to do.") == NULL)
        {
            fputs(plan.data, stderr);
            fail("restored Debug configuration has remaining work");
        }
        free(plan.data);
        puts("final_Debug_noop: PASS");
    }
    puts("RESULT: PASS existing full incremental workflow, exact owners, publication/JSON checks, one-unit rebuild and restored no-op state");
    return 0;
}
