// ppdump.c FILE...: the direct path's preprocessor over each FILE as a buffer (no includes): a line a file with its
// output tokens' count and a hash of their kinds and data, or the bailout's reason.
#include "buster/compiler/c_direct.c"

int main(int argc, char** argv)
{
    for (int a = 1; a < argc; a += 1)
    {
        FILE* in = fopen(argv[a], "rb");
        fseek(in, 0, SEEK_END);
        const long size = ftell(in);
        fseek(in, 0, SEEK_SET);
        char* text = malloc((size_t)size + 1);
        if (fread(text, 1, (size_t)size, in) != (size_t)size) { return 2; }
        fclose(in);
        FastArena arena = { 0 };
        FastArena scratch = { 0 };
        if (!fast_arena_init(&arena, UINT64_C(256) * 1024u * 1024u, true) || !fast_arena_init(&scratch, UINT64_C(64) * 1024u * 1024u, true)) { return 3; }
        FastPP* pp = (FastPP*)fast_arena_alloc(&scratch, sizeof(FastPP), 64);
        bool ok = pp != NULL && fast_pp_init(pp, &arena, &scratch, false);
        ok = ok && fast_pp_run_buffer(pp, argv[a], text, (uint64_t)size);
        uint64_t h = 1469598103934665603ull;
        for (uint32_t i = 0; ok && i < pp->out_count; i += 1)
        {
            h = (h ^ (pp->out_kind[i] | ((uint64_t)pp->out_data[i] << 8))) * 1099511628211ull;
            h ^= h >> 29;
        }
        printf("%s %d %u %016llx %s\n", argv[a], ok, pp->out_count, (unsigned long long)h, pp->bailout ? pp->bailout_reason : "");
        fast_arena_destroy(&scratch);
        fast_arena_destroy(&arena);
        free(text);
    }
    return 0;
}
