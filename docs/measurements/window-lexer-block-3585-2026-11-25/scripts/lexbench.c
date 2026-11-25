// lexbench.c FILE ROUNDS [STORE_SHIFT]: fast_pp_lex_window over FILE's text, window after window, ROUNDS times; the
// window's arrays placed STORE_SHIFT bytes past a 4 KB boundary (64 by default, as an arena would put them).
// FILE should have no byte the lexer stops at (sanitize.py), so that every block is a full one.
#include "buster/compiler/c_direct.c"
#include <sys/mman.h>

int main(int argc, char** argv)
{
    FILE* in = fopen(argv[1], "rb");
    fseek(in, 0, SEEK_END);
    const long size = ftell(in);
    fseek(in, 0, SEEK_SET);
    uint8_t* text = mmap(NULL, (size_t)size + 4096, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (fread(text, 1, (size_t)size, in) != (size_t)size) { return 2; }
    memset(text + size, '\n', 4096);
    const uint32_t rounds = (uint32_t)atoi(argv[2]);
    const uint32_t shift = argc > 3 ? (uint32_t)atoi(argv[3]) : 64u;
    FastPP* pp = calloc(1, sizeof(FastPP));
    uint8_t* arrays = mmap(NULL, 1u << 20, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    memset(arrays, 0, 1u << 20);
#ifdef BUSTER_FWIN_REGION_BYTES
    pp->win.kinds = arrays + 4096 * 1 + shift;
    pp->win.lens = pp->win.kinds + BUSTER_FWIN_LENS_OFFSET;
    pp->win.starts = (__typeof__(pp->win.starts))(void*)(pp->win.kinds + BUSTER_FWIN_STARTS_OFFSET);
#else
    pp->win.kinds = arrays + 4096 * 1 + shift;
    pp->win.lens = arrays + 4096 * 2 + shift;
    pp->win.starts = (uint32_t*)(arrays + 4096 * 4 + shift);
#endif
    FastIncludeFile f = { 0 };
    f.base = text;
    f.end = text + size;
    f.serial = 1;
    uint64_t windows = 0, tokens = 0, sum = 0;
    for (uint32_t r = 0; r < rounds; r += 1)
    {
        const uint8_t* p = text;
        bool bol = true;
        while (p + 80 <= f.end)
        {
            fast_pp_lex_window(pp, &f, p, bol, false);
            windows += 1;
            tokens += pp->win.count;
            sum += pp->win.kinds[pp->win.count / 2] + pp->win.starts[pp->win.count / 3] + pp->win.lens[pp->win.count / 4];
            if (pp->win.stop != BUSTER_FWIN_STOP_CAPACITY && pp->win.lex_ptr == p) { fprintf(stderr, "stuck at %ld: stop %u\n", (long)(p - text), pp->win.stop); return 3; }
            if (pp->win.stop != BUSTER_FWIN_STOP_CAPACITY && pp->win.stop != BUSTER_FWIN_STOP_TAIL) { fprintf(stderr, "stop %u at %ld\n", pp->win.stop, (long)(pp->win.lex_ptr - text)); }
            bol = pp->win.lex_bol;
            p = pp->win.lex_ptr;
            if (pp->win.stop == BUSTER_FWIN_STOP_TAIL) { break; }
        }
    }
    printf("windows %llu tokens %llu sum %llu bytes %ld\n", (unsigned long long)(windows / rounds), (unsigned long long)(tokens / rounds), (unsigned long long)sum, size);
    return 0;
}
