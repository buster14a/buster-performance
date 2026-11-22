// One preprocessing walk per unit. All units share the physical-file cache and identifier table.
#include "buster/compiler/c_lexer.c"
#include "buster/compiler/lane.c"
#include "buster/compiler/c_intern.c"
#include "buster/compiler/c_refine.c"
#include "buster/compiler/c_predefines.c"
#include "buster/compiler/c_preprocessor.c"

int main(int argc, char** argv)
{
    Arena arena = arena_reserve(1ull << 30);
    PPOptions options = { 0 };
    PPDriverInput* inputs = BUSTER_ARENA_PUSH_ARRAY(&arena, PPDriverInput, argc);
    const char* input = NULL;
    const char* output = NULL;
    bool markers = false;
    uint32_t count = 0;
    static InternTable names;
    static FileCache files;
    bool ok = inputs != NULL && pp_parse_options_inputs(argc - 1, argv + 1, &options, &arena, &input, &output, &markers, inputs, &count) &&
              count != 0 && output == NULL && intern_initialize(&names) && file_cache_initialize(&files, &names, pp_prepare_options(&options));
    options.files = &files;
    for (uint32_t i = 0; ok && i < count; i += 1)
    {
        static Preprocessor pp;
        ok = pp_initialize(&pp, &options, &names) && pp_run(&pp, inputs[i].path) && pp.errors == 0 && pp_print(&pp, stdout, false);
        pp_release(&pp);
    }
    ok = ok && fflush(stdout) == 0;
    file_cache_release(&files);
    intern_release(&names);
    arena_release(&arena);
    return ok ? 0 : 1;
}
