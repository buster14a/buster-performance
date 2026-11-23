#include "buster/compiler/x86_64_encoder.c"
#include UPPER
#include <stdio.h>
#include <sys/mman.h>
#include <string.h>
// test-tier0's VEX window check, standalone (buster#2874): 0 when it passes.
static int check(void)
{
    static const uint16_t* const tables[2] = { x86_vex_forms_tier0, x86_vex_forms };
    X86Instruction records[32];
    int failures = 0;
    for (uint32_t t = 0; t < 2; t += 1)
    {
        const X86VexWindow window = x86_vex_window(tables[t]);
        uint32_t wrong = UINT32_MAX;
        for (uint32_t first = 0; first < 0x10000; first += 32)
        {
            uint32_t expected = 0;
            for (uint32_t r = 0; r < 32; r += 1)
            {
                const uint32_t form = first + r;
                const uint32_t number = form & BUSTER_X86_FORM_NUMBER;
                const uint64_t noise = (uint64_t)form * 0x9e3779b97f4a7c15ull;
                records[r] = (X86Instruction){ .immediate = (int32_t)noise, .displacement = (int32_t)(noise >> 32), .reg = (uint8_t)(noise >> 8), .rm = (uint8_t)(noise >> 16),
                                               .index = (uint8_t)(noise >> 24), .mode = (uint8_t)(noise >> 40), .form = (uint16_t)form, .vvvv = (uint8_t)(noise >> 48),
                                               .decorations = (uint8_t)(noise >> 56) };
                expected |= number < BUSTER_X86_FORM_SS && tables[t][number % X86_FORM_COUNT] != 0 ? 1u << r : 0;
            }
            const uint32_t found = x86_vex_find(records, 32, &window);
            wrong = wrong == UINT32_MAX && found != expected ? first + (uint32_t)__builtin_ctz(found ^ expected) : wrong;
        }
        failures += wrong != UINT32_MAX;
    }
    for (uint32_t r = 0; r < 32; r += 1)
    {
        records[r] = (X86Instruction){ .form = (uint16_t)(r % 2 == 0 ? X86_FORM_ADDSD_X_XM64 : X86_FORM_MOVQ_XM64_X + BUSTER_X86_FORM_GS) };
    }
    const X86VexWindow window = x86_vex_window(x86_vex_forms_tier0);
    uint32_t short_count = UINT32_MAX;
    for (uint32_t count = 0; count <= 32; count += 1)
    {
        const uint32_t expected = count == 32 ? UINT32_MAX : (1u << count) - 1;
        short_count = short_count == UINT32_MAX && x86_vex_find(records, count, &window) != expected ? count : short_count;
    }
    failures += short_count != UINT32_MAX;
    // guard page
    const uint64_t page = 4096;
    uint8_t* pages = mmap(0, 2 * page, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    int guarded = pages != MAP_FAILED && mprotect(pages + page, page, PROT_NONE) == 0;
    uint32_t edge_count = UINT32_MAX;
    for (uint32_t count = 0; guarded && count <= 32; count += 1)
    {
        X86Instruction* edge = (X86Instruction*)(pages + page) - count;
        memcpy(edge, records, count * sizeof(X86Instruction));
        const uint32_t expected = count == 32 ? UINT32_MAX : (1u << count) - 1;
        edge_count = edge_count == UINT32_MAX && x86_vex_find(edge, count, &window) != expected ? count : edge_count;
    }
    failures += !(guarded && edge_count == UINT32_MAX);
    return failures;
}
int main(void)
{
    const int failures = check();
    printf("%d\n", failures);
    return 0;
}
