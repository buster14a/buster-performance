// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Read-only live cache audit. Compile against the Buster revision identified in the report.
#define main admission_cli_main
#include "tools/ci/admission.c"
#undef main

static void profile(CiState* state, const char* phase)
{
    ci_read_only = true;
    ci_current_state = state;
    ci_git_used_ms = 0;
    ci_git_computed = ci_git_cached = ci_git_deferred = 0;
    CiIdentity identities[BUSTER_CI_ITEMS] = {0};
    size_t count = ci_list_prs(identities);
    ci_prune(state, identities, count);
    for (size_t i = 0; i < count; ++i)
    {
        CiIdentity* current = &identities[i];
        CiPr* pr = ci_find_pr(state, current->number);
        if (pr == NULL)
        {
            if (state->pr_count == BUSTER_CI_ITEMS) ci_die("profile row limit");
            pr = &state->prs[state->pr_count++];
            *pr = (CiPr){.number = current->number, .manual = -1};
        }
        ci_observe(pr, current, ci_now());
        ci_resolve_merge(current, NULL);
        printf("phase=%s pr=%" PRIu64 " head=%s base=%s state=%u merge=%s code=%s\n", phase, pr->number, pr->head, pr->base, pr->frozen_state, pr->frozen_merge, pr->cached_code ? "true" : "false");
    }
    printf("phase=%s open=%zu computed=%u cached=%u deferred=%u git_work_ms=%" PRIu64 " engine=%s object_store=%s\n", phase, count, ci_git_computed, ci_git_cached, ci_git_deferred, ci_git_used_ms, ci_git_engine_name(), *ci_git.directory != 0 ? "created" : "absent");
    ci_current_state = NULL;
}

int main(int argc, char** argv)
{
    if (argc != 3) ci_die("usage: profile-preflight LOCAL_CACHE_FILE SOURCE_REVISION");
    ci_read_only = true;
    printf("source=%s mode=read-only no-GitHub-writes\n", argv[2]);
    CiState cold = ci_load_state();
    profile(&cold, "cold");
    Buffer cache = ci_state_json(&cold);
    FILE* file = fopen(argv[1], "wb");
    if (file == NULL || fwrite(cache.data, 1, cache.length, file) != cache.length || fclose(file) != 0) ci_die("cannot retain local profile cache");
    CiState warm = ci_state_parse(cache.data);
    free(cache.data); free(cold.saved_json);
    ci_git_dispose(&ci_git);
    ci_git_engine[0] = 0;
    profile(&warm, "restart-cache-only");
    free(warm.saved_json);
    return 0;
}
