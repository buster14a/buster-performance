// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Standalone #3644 correctness driver. The included helpers are unmodified
// excerpts of their owning test modules at base 74eacd4744a8131ba4c1a5bd8ad87b89ec0f7dbe;
// all production logic and the new regression fixture come directly from the
// checkout. No timing or benchmark path runs here.
#include "selector-deps.inc"
#include "emitter-helpers.inc"
#include "selector-helpers.inc"
#include "dominance-helper.inc"
#include "buster/compiler/tier1_address_sink_test.c"

int main(void)
{
    Tier1EmitTest test = {
        .input = arena_reserve(32u << 20),
        .output = arena_reserve(64u << 20),
        .scratch = arena_reserve(32u << 20),
        .allowed = malloc(X86_FORM_COUNT),
    };
    const bool ready = test.input.base != 0 && test.output.base != 0 && test.scratch.base != 0 && test.allowed != 0 &&
                       x86_encoder_initialize() && x86_semantics_initialize() && x86_zen5_initialize();
    tier1_emit_test_expect(&test, ready, "standalone address fixture initialized");
    if (ready)
    {
        const X86Target target = { .architecture = X86_ARCH_BASELINE };
        x86_target_forms(&target, test.allowed);
        tier1_address_sink_tests(&test);
    }
    printf("standalone address-sink tests: %" PRIu64 " checks, %" PRIu64 " failures\n", test.checks, test.failures);
    free(test.allowed);
    arena_release(&test.scratch);
    arena_release(&test.output);
    arena_release(&test.input);
    return test.failures != 0;
}
