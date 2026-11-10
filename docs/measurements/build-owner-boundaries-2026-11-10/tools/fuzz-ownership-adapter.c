// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Evidence-only adapter: actual Clang .d graphs through the production ownership policies.
// This does not create Ninja records, assert Ninja freshness, or invoke the regression program's build workflow.
#define main buster_regression_program_main
#include "tools/ci/build_regression.c"
#undef main

static bool evidence_dep_token(const char** cursor, char token[PATH_MAX])
{
    const char* p = *cursor;
    size_t length = 0;
    for (;;)
    {
        if (p[0] == '\\' && p[1] == '\n') p += 2;
        else if (isspace((unsigned char)*p)) p += 1;
        else break;
    }
    while (*p != 0)
    {
        if (p[0] == '\\' && p[1] == '\n')
        {
            p += 2;
            continue;
        }
        if (isspace((unsigned char)*p)) break;
        if (*p == '\\')
        {
            p += 1;
            if (*p == 0) fail("trailing escape in captured Clang dependency path");
        }
        else if (p[0] == '$' && p[1] == '$') p += 1;
        if (length + 1 >= PATH_MAX) fail("captured Clang dependency path is too long");
        token[length++] = *p++;
    }
    token[length] = 0;
    *cursor = p;
    return length != 0;
}

static void evidence_dep_graph(const char* directory, const char* snapshot, const OwnershipUnits* units, OwnershipGraph* graph)
{
    memset(graph, 0, sizeof(*graph));
    const size_t snapshot_length = strlen(snapshot);
    uint32_t dependencies = 0;
    uint32_t external = 0;
    for (uint32_t unit = 0; unit < units->count; unit += 1)
    {
        char path[PATH_MAX];
        if (snprintf(path, sizeof(path), "%s/%s.d", directory, units->names[unit]) >= (int)sizeof(path)) fail("capture path is too long");
        Text text = read_file(path);
        const char* cursor = text.data;
        char token[PATH_MAX];
        char expected[PATH_MAX];
        snprintf(expected, sizeof(expected), "%s.o:", units->names[unit]);
        if (!evidence_dep_token(&cursor, token) || strcmp(token, expected) != 0) fail("unexpected target in %s", path);
        snprintf(expected, sizeof(expected), "src/buster/compiler/%s", units->names[unit]);
        const uint64_t owner = UINT64_C(1) << unit;
        bool self = false;
        while (evidence_dep_token(&cursor, token))
        {
            dependencies += 1;
            const char* relative = token;
            if (token[0] == '/')
            {
                if (strncmp(token, snapshot, snapshot_length) != 0 || token[snapshot_length] != '/')
                {
                    external += 1;
                    continue;
                }
                relative += snapshot_length + 1;
            }
            char normalized[PATH_MAX];
            if (!ownership_normalize(relative, normalized)) fail("invalid captured repository path %s", token);
            self = self || strcmp(normalized, expected) == 0;
            uint32_t file = 0;
            while (file < graph->count && strcmp(graph->files[file].path, normalized) != 0) file += 1;
            if (file == graph->count)
            {
                if (graph->count == BUSTER_REGRESSION_ENTRIES) fail("too many captured repository paths");
                const char* copied = strdup(normalized);
                if (copied == NULL) fail("can't retain captured repository path");
                graph->files[file] = (OwnershipFile){ .path = copied, .fixture = ownership_fixture_name(copied) };
                graph->count += 1;
            }
            graph->files[file].owners |= owner;
        }
        if (!self) fail("captured dependency record lacks its own source: %s", units->names[unit]);
        graph->seen |= owner;
        free(text.data);
    }
    if (graph->seen != ownership_all(units)) fail("missing captured unity dependency records");
    for (uint32_t file = 0; file < graph->count; file += 1)
    {
        char captured[PATH_MAX];
        if (snprintf(captured, sizeof(captured), "%s/%s", snapshot, graph->files[file].path) >= (int)sizeof(captured)) fail("snapshot path is too long");
        if (!same_bytes(graph->files[file].path, captured)) fail("root source differs from captured source snapshot: %s", graph->files[file].path);
    }
    printf("actual_clang_dependencies: units=%u repository_paths=%u dependency_tokens=%u external_tokens=%u source_snapshot_bytes=identical\n",
           units->count, graph->count, dependencies, external);
}

static void evidence_require_ordinary_rejection(const OwnershipUnits* units, const OwnershipGraph* graph)
{
    OwnershipException ordinary[sizeof(ownership_exceptions) / sizeof(ownership_exceptions[0]) +
                                sizeof(ownership_scalar_exceptions) / sizeof(ownership_scalar_exceptions[0])];
    const uint32_t count = ownership_active_exceptions(graph, false, ordinary);
    const OwnershipIssue issue = ownership_check(units, graph, ordinary, count);
    if (issue.reason == NULL) fail("ordinary shared-fixture policy unexpectedly accepted the captured fuzz graph");
    char actual[4096];
    char expected[4096];
    ownership_names(units, issue.actual, actual, sizeof(actual));
    ownership_names(units, issue.expected, expected, sizeof(expected));
    printf("ordinary_shared_policy: EXPECTED_REJECTION path=%s reason=%s actual=[%s] expected=[%s]\n",
           issue.path, issue.reason, actual, expected);
    puts("ordinary_named_boundaries: requiring rejection; the following child diagnostic is expected");
    fflush(NULL);
    const pid_t child = fork();
    if (child < 0) fail("can't fork negative named-boundary check");
    if (child == 0)
    {
        ownership_check_nonstandard(units, graph, false);
        _exit(0);
    }
    int status = 0;
    pid_t waited;
    do { waited = waitpid(child, &status, 0); } while (waited < 0 && errno == EINTR);
    if (waited != child || !WIFEXITED(status) || WEXITSTATUS(status) != 1) fail("ordinary named boundaries did not reject the captured fuzz graph normally");
    puts("ordinary_named_boundaries: EXPECTED_REJECTION exit=1");
}

int main(int argc, char** argv)
{
    if (argc != 3)
    {
        fprintf(stderr, "usage: %s CLANG_DEPFILE_DIRECTORY CAPTURE_SOURCE_SNAPSHOT\n", argv[0]);
        return 2;
    }
    puts("validation_scope: actual-Clang-dependency/configuration gate validation; no Ninja VALID or freshness claim");
    printf("capture_directory: %s\ncapture_source_snapshot: %s\n", argv[1], argv[2]);
    if (getcwd(root, sizeof(root)) == NULL) fail("can't read current repository root");
    const char* temporary = getenv("TMPDIR");
    if (snprintf(work, sizeof(work), "%s/fuzz-ownership-XXXXXX", temporary != NULL && temporary[0] != 0 ? temporary : "/tmp") >= (int)sizeof(work) ||
        mkdtemp(work) == NULL) fail("can't create isolated adapter scratch directory");
    printf("policy_and_source_root: %s\n", root);
    printf("adapter_scratch: %s\n", work);
    char* source_arguments[] = { "./build.sh", "print-sources", NULL };
    Text sources = capture(source_arguments);
    const OwnershipUnits units = ownership_units(sources);
    if (units.count != 11) fail("expected eleven configured unity sources, got %u", units.count);
    static OwnershipGraph graph;
    evidence_dep_graph(argv[1], argv[2], &units, &graph);
    ownership_classify(&graph);
    OwnershipException active[sizeof(ownership_exceptions) / sizeof(ownership_exceptions[0]) +
                              sizeof(ownership_scalar_exceptions) / sizeof(ownership_scalar_exceptions[0])];
    const uint32_t exceptions = ownership_active_exceptions(&graph, true, active);
    ownership_report(&units, ownership_check(&units, &graph, active, exceptions));
    puts("fuzz_shared_policy: PASS");
    ownership_check_structure(&units, &graph, active, exceptions);
    puts("fuzz_shared_structure: PASS");
    ownership_check_nonstandard(&units, &graph, true);
    puts("fuzz_named_boundaries: PASS");
    uint32_t fixtures = 0;
    for (uint32_t file = 0; file < graph.count; file += 1) fixtures += graph.files[file].fixture;
    printf("fuzz_ownership: fixture_support_paths=%u single_owner=%u shared_exceptions=%u units=%u\n",
           fixtures, fixtures - exceptions, exceptions, units.count);
    evidence_require_ordinary_rejection(&units, &graph);
    for (uint32_t file = 0; file < graph.count; file += 1) free((void*)graph.files[file].path);
    free(sources.data);
    puts("RESULT: PASS actual Clang fuzz dependency/configuration gates and ordinary-policy rejection");
    return 0;
}
