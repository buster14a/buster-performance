// Scratch compatibility probe: retain the default callback's checker pipeline,
// then require the private preprocessor and executable interfaces to be visible.
#define buster_fuzz_test_input review_default_fuzz_input
#include "buster/compiler/fuzz.c"
#undef buster_fuzz_test_input

int buster_fuzz_test_input(const uint8_t* data, size_t size)
{
    const int result = review_default_fuzz_input(data, size);
    if (result == 0)
    {
        PPTokens tokens = { 0 };
        if (pp_tokens_reserve(&tokens, 16))
        {
            pp_tokens_set(&tokens, 0, C_TOKEN_L_SQUARE, 0, 0, 0);
            if (tokens.kinds[0] != C_TOKEN_L_SQUARE)
            {
                abort();
            }
        }
        pp_tokens_release(&tokens);
        const uint64_t aligned = executable_align((uint64_t)size, 16);
        if (aligned < size || (aligned & 15) != 0)
        {
            abort();
        }
        (void)&pp_history_lookup;
        (void)&check_input;
        (void)&check_graph_run;
    }
    return result;
}
