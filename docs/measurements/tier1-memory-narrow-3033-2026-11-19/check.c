#include <stdio.h>
#include <stdint.h>
#include <string.h>

union cell { unsigned wide; unsigned short words[2]; unsigned char bytes[4]; };
extern unsigned put_byte(union cell *, unsigned char);
extern unsigned put_word(union cell *, unsigned short);
extern unsigned other_byte(union cell *, unsigned short);
extern unsigned may_alias(union cell *, unsigned char *, unsigned short);

int main(void)
{
    union cell cells[3] = { { .wide = 0x87654321 }, { .wide = 0 }, { .wide = 0x12345678 } };
    for (unsigned i = 0; i <= UINT16_MAX; ++i)
    {
        union cell *p = &cells[1];
        p->wide = ~0u;
        if (put_byte(p, (unsigned char)i) != (unsigned char)i || p->wide != (unsigned char)i)
            return 1;
        p->wide = ~0u;
        if (put_word(p, (unsigned short)i) != i || p->wide != i)
            return 2;
        if (other_byte(p, (unsigned short)i) != (i >> 8) || p->wide != i)
            return 3;
        for (unsigned j = 0; j < 3; ++j)
        {
            unsigned char separate = 0;
            unsigned char *q = j < 2 ? &p->bytes[j] : &separate;
            const unsigned expected = j == 0 ? (i & 0xff00u) | 0x5au : j == 1 ? (i & 0xffu) | 0x5a00u : i;
            if (may_alias(p, q, (unsigned short)i) != expected || p->wide != expected || (j == 2 && separate != 0x5a))
                return 4;
        }
        if (cells[0].wide != 0x87654321 || cells[2].wide != 0x12345678)
            return 5;
    }
    puts("65536 inputs: return values, full writes, guards and alias cases passed");
    return 0;
}
