#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include "host_isa.h" /* from src/buster/compiler, with -I */
#include "extract.h"

static uint64_t rng = 88172645463325252ull;
static uint64_t next(void) { rng ^= rng << 13; rng ^= rng >> 7; rng ^= rng << 17; return rng; }

static const char* pieces[] = {
    "\\", "\\", "\\", "x", "x", "0", "1", "3", "4", "7", "8", "9", "a", "f", "F", "g", "e", "n", "t", "u", "U", "?", "'", "\"", "\n", "\r",
    "q", "Z", " ", "\t", "\x7f", "\xc2", "\xdf", "\xe0", "\xed", "\xef", "\xf0", "\xf4", "\xf5", "\x80", "\x9f", "\xa0", "\xbf", "\xc0", "\xc1", "\xff",
    "\xc3\xa9", "\xe2\x82\xac", "\xf0\x9f\x98\x80", "\\x41", "\\x4", "\\xff", "\\x100", "\\101", "\\777", "\\400", "\\377", "\\0", "\\\\", "\\n", "\\u00e9", "\\U0001f600", "\\u0041",
    "abcdefgh", "ABCDEFGHIJKLMNOP",
};

static uint64_t trials, valid_count, mismatches;

static void check(const uint8_t* body, uint32_t n, CheckStringEncoding encoding, uint8_t* page_end, bool c23)
{
    // Place the part "..." so that it ends at the guard page.
    uint32_t length = n + 2;
    uint8_t* bytes = page_end - length;
    bytes[0] = '"';
    memcpy(bytes + 1, body, n);
    bytes[length - 1] = '"';
    CheckStringPart part = { .bytes = bytes, .length = length };
    uint64_t ls = 0, lv = 0;
    bool vs = check_literal_string_part(&part, encoding, c23, true, NULL, &ls);
    bool vv = check_literal_string_part(&part, encoding, c23, false, NULL, &lv);
    trials += 1;
    if (vs != vv || (vs && ls != lv))
    {
        mismatches += 1;
        if (mismatches < 10)
        {
            printf("MEASURE MISMATCH enc %d scalar %d/%lu vector %d/%lu: ", encoding, vs, ls, vv, lv);
            for (uint32_t i = 0; i < length; i++) printf("%02x ", bytes[i]);
            printf("\n");
        }
        return;
    }
    if (vs)
    {
        valid_count += 1;
        static uint8_t outs[1 << 16], outv[1 << 16];
        memset(outs, 0xa5, ls + 64); memset(outv, 0xa5, ls + 64);
        uint64_t ws = 0, wv = 0;
        bool a = check_literal_string_part(&part, encoding, c23, true, outs, &ws);
        bool b = check_literal_string_part(&part, encoding, c23, false, outv, &wv);
        if (!a || !b || ws != ls || wv != lv || memcmp(outs, outv, ls + 64) != 0)
        {
            mismatches += 1;
            if (mismatches < 10)
            {
                printf("WRITE MISMATCH enc %d: ", encoding);
                for (uint32_t i = 0; i < length; i++) printf("%02x ", bytes[i]);
                printf("\n  scalar: "); for (uint64_t i = 0; i < ls; i++) printf("%02x ", outs[i]);
                printf("\n  vector: "); for (uint64_t i = 0; i < lv; i++) printf("%02x ", outv[i]);
                printf("\n");
            }
        }
    }
}

int main(int argc, char** argv)
{
    uint64_t rounds = argc > 1 ? strtoull(argv[1], 0, 10) : 1000000;
    const long page = sysconf(_SC_PAGESIZE);
    uint8_t* map = mmap(0, page * 4, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    mprotect(map + page * 3, page, PROT_NONE);
    uint8_t* page_end = map + page * 3;
    uint8_t body[4096];
    // Exhaustive: every 1-, 2- and 3-byte body over all bytes (3-byte over a subset)
    for (uint32_t a = 0; a < 256; a++) { body[0] = a; check(body, 1, CHECK_STRING_ORDINARY, page_end, false); }
    for (uint32_t a = 0; a < 256; a++) for (uint32_t b = 0; b < 256; b++) { body[0] = a; body[1] = b; check(body, 2, CHECK_STRING_UTF8, page_end, false); }
    static const uint8_t sub[] = { 0, '\\', 'x', '0', '3', '4', '7', '8', 'a', 'f', 'g', 'n', 'u', '"', '\'', '\n', 'A', 0x7f, 0x80, 0x8f, 0x90, 0x9f, 0xa0, 0xbf, 0xc0, 0xc1, 0xc2, 0xdf, 0xe0, 0xe1, 0xec, 0xed, 0xee, 0xef, 0xf0, 0xf1, 0xf3, 0xf4, 0xf5, 0xf8, 0xff };
    const uint32_t ns = sizeof(sub);
    for (uint32_t a = 0; a < ns; a++) for (uint32_t b = 0; b < ns; b++) for (uint32_t c = 0; c < ns; c++) for (uint32_t d = 0; d < ns; d++)
    { body[0] = sub[a]; body[1] = sub[b]; body[2] = sub[c]; body[3] = sub[d]; check(body, 4, CHECK_STRING_ORDINARY, page_end, false); }
    printf("exhaustive: %lu trials, %lu valid, %lu mismatches\n", trials, valid_count, mismatches);
    for (uint64_t r = 0; r < rounds; r++)
    {
        uint32_t target = (uint32_t)(next() % 300);
        if (next() % 8 == 0) target = 50 + (uint32_t)(next() % 30);   // around block edges
        uint32_t n = 0;
        // Bias: mostly one kind per string
        uint32_t style = next() % 4;
        while (n < target)
        {
            const char* p;
            if (style == 0) p = pieces[next() % (sizeof(pieces) / sizeof(pieces[0]))];
            else if (style == 1) { static char hx[8]; snprintf(hx, sizeof hx, "\\x%02x", (unsigned)(next() & 255)); p = (next() % 50 == 0) ? pieces[next() % (sizeof(pieces) / sizeof(pieces[0]))] : hx; }
            else if (style == 2) { static char oc[8]; snprintf(oc, sizeof oc, "\\%o", (unsigned)(next() % (next() % 2 ? 256 : 512))); p = (next() % 50 == 0) ? pieces[next() % (sizeof(pieces) / sizeof(pieces[0]))] : oc; }
            else p = (next() % 30 == 0) ? pieces[next() % (sizeof(pieces) / sizeof(pieces[0]))] : (const char*[]){ "a", "b", "Z", " ", "\xc3\xa9", "\xe2\x82\xac", "\xf0\x9f\x98\x80", "\\n", "\\\"", "\\\\", "1", "x" }[next() % 12];
            uint32_t k = (uint32_t)strlen(p);
            if (n + k > sizeof(body)) break;
            memcpy(body + n, p, k); n += k;
        }
        // occasionally single random byte flips
        if (n && next() % 4 == 0) body[next() % n] = (uint8_t)next();
        CheckStringEncoding enc = (next() & 1) ? CHECK_STRING_ORDINARY : CHECK_STRING_UTF8;
        check(body, n, enc, page_end, next() & 1);
    }
    printf("total: %lu trials, %lu valid, %lu mismatches\n", trials, valid_count, mismatches);
    return mismatches != 0;
}
