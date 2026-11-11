// Experiment only (#2089), not for the branch: paints the stack below the caller with a pattern and finds how deep a
// run went. Inserted before parse_test_probe.
#define PARSE_TEST_DEPTH_SPAN (1u << 20)
#define PARSE_TEST_DEPTH_PATTERN 0x5a5a5a5a5a5a5a5aull
static uintptr_t parse_test_depth_reference;

static __attribute__((noinline)) uintptr_t parse_test_stack_pointer(void)
{
    uintptr_t sp;
    __asm__ volatile("mov %%rsp, %0" : "=r"(sp));
    return sp;
}

// Paints [reference - SPAN, sp - 4096) with the pattern.
static __attribute__((noinline)) void parse_test_paint(void)
{
    const uintptr_t sp = parse_test_stack_pointer();
    volatile uint64_t* low = (volatile uint64_t*)(parse_test_depth_reference - PARSE_TEST_DEPTH_SPAN);
    volatile uint64_t* high = (volatile uint64_t*)((sp - 4096) & ~(uintptr_t)7);
    for (volatile uint64_t* at = high - 1; at >= low; at -= 1)
    {
        *at = PARSE_TEST_DEPTH_PATTERN;
    }
}

// How far below the reference the lowest word that isn't the pattern is.
static __attribute__((noinline)) uint64_t parse_test_depth(void)
{
    volatile uint64_t* at = (volatile uint64_t*)(parse_test_depth_reference - PARSE_TEST_DEPTH_SPAN);
    while (*at == PARSE_TEST_DEPTH_PATTERN)
    {
        at += 1;
    }
    return parse_test_depth_reference - (uintptr_t)at;
}
