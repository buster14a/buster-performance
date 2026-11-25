// lexdump.c FILE STRIDE [DETAIL]: fast_pp_lex_window's windows over FILE: the chain of windows from its start, a line
// window from every line's start, and windows of both modes from every STRIDE-th byte. One line a window: its start,
// mode, count, stop, end, line state and a hash of its tokens (kind, first byte, and the length where a reader uses
// it). With DETAIL, the tokens of the windows that start at byte DETAIL.
#include "buster/compiler/c_direct.c"
#include <sys/mman.h>

static FastPP* g_pp;
static FastIncludeFile g_f;
static long g_detail = -1;

static uint32_t dump_start(uint32_t i)
{
#ifdef BUSTER_FWIN_SPAN
    return g_pp->win.origin + g_pp->win.starts[i];
#else
    return g_pp->win.starts[i];
#endif
}

static void dump_window(const uint8_t* p, bool bol, bool line_mode)
{
    g_pp->bailout = false;
    fast_pp_lex_window(g_pp, &g_f, p, bol, line_mode);
    const FastWindow* w = &g_pp->win;
    uint64_t h = 1469598103934665603ull;
    for (uint32_t i = 0; i < w->count; i += 1)
    {
        const uint32_t kind = w->kinds[i];
        const bool sized = kind == FTOK_IDENT || kind == FTOK_INT_LIT || kind == FTOK_CHAR_LIT || kind == BUSTER_FWIN_SCALAR;
        const uint64_t x = (uint64_t)kind | ((uint64_t)dump_start(i) << 8) | ((uint64_t)(sized ? w->lens[i] : 0u) << 40);
        h = (h ^ x) * 1099511628211ull;
        h ^= h >> 29;
    }
    const long start = (long)(p - g_f.base);
    printf("%ld %d %d | %u %u %ld %d %016llx\n", start, line_mode, bol, w->count, w->stop, (long)(w->lex_ptr - g_f.base), w->lex_bol, (unsigned long long)h);
    if (start == g_detail)
    {
        for (uint32_t i = 0; i < w->count; i += 1)
        {
            printf("  %u: kind %u start %u len %u\n", i, w->kinds[i], dump_start(i), w->lens[i]);
        }
    }
}

int main(int argc, char** argv)
{
    FILE* in = fopen(argv[1], "rb");
    fseek(in, 0, SEEK_END);
    const long size = ftell(in);
    fseek(in, 0, SEEK_SET);
    uint8_t* text = mmap(NULL, (size_t)size + 8192, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (fread(text, 1, (size_t)size, in) != (size_t)size) { return 2; }
    const long stride = atol(argv[2]);
    g_detail = argc > 3 ? atol(argv[3]) : -1;
    FastArena arena = { 0 };
    FastArena scratch = { 0 };
    if (!fast_arena_init(&arena, UINT64_C(64) * 1024u * 1024u, true) || !fast_arena_init(&scratch, UINT64_C(16) * 1024u * 1024u, true)) { return 3; }
    g_pp = (FastPP*)fast_arena_alloc(&scratch, sizeof(FastPP), 64);
    if (!fast_pp_init(g_pp, &arena, &scratch, false)) { return 4; }
    g_f.base = text;
    g_f.end = text + size;
    g_f.serial = 1;
    // The chain.
    const uint8_t* p = text;
    bool bol = true;
    while (p + 80 <= g_f.end)
    {
        dump_window(p, bol, false);
        const FastWindow* w = &g_pp->win;
        if (w->stop == BUSTER_FWIN_STOP_TAIL || w->stop == BUSTER_FWIN_STOP_BAIL) { break; }
        const bool again = w->stop == BUSTER_FWIN_STOP_CAPACITY;
        bol = again ? w->lex_bol : false;
        p = w->lex_ptr + (again ? 0 : 1);
    }
    // Every line's window.
    for (long i = 0; i + 80 <= size; i += 1)
    {
        if (i == 0 || text[i - 1] == '\n') { dump_window(text + i, true, true); }
    }
    // Both modes from every stride-th byte.
    for (long i = 0; i + 80 <= size; i += stride)
    {
        dump_window(text + i, (i / stride) & 1, false);
        dump_window(text + i, ((i / stride) >> 1) & 1, true);
    }
    return 0;
}
