#include <stdbool.h>
#include <stdint.h>
void rare(uint32_t);
void other(uint32_t);
static bool tests(uint8_t mark, bool scalar, uint8_t reason) { return scalar || (mark & reason) != 0; }
#define TESTS(mark, scalar, reason) ((scalar) | (((mark) & (reason)) != 0))
// A: expect around an && chain
void a(const uint8_t* marks, const uint32_t* column, bool scalar, uint32_t n)
{
    for (uint32_t i = 0; i < n; i += 1)
    {
        uint8_t mark = marks[i];
        if (__builtin_expect(tests(mark, scalar, 0x20) && column[i] != 0, 0)) rare(i);
        other(i);
    }
}
// B: nested, expect on the helper's result alone
void b(const uint8_t* marks, const uint32_t* column, bool scalar, uint32_t n)
{
    for (uint32_t i = 0; i < n; i += 1)
    {
        uint8_t mark = marks[i];
        if (__builtin_expect(tests(mark, scalar, 0x20), 0) && column[i] != 0) rare(i);
        other(i);
    }
}
// C: macro with bitwise or
void c(const uint8_t* marks, const uint32_t* column, bool scalar, uint32_t n)
{
    for (uint32_t i = 0; i < n; i += 1)
    {
        uint8_t mark = marks[i];
        if (__builtin_expect(TESTS(mark, scalar, 0x20), 0) && column[i] != 0) rare(i);
        other(i);
    }
}
