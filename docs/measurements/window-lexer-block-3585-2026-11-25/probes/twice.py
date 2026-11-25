import sys
p = sys.argv[1] + '/src/buster/compiler/c_direct_lex.c'
s = open(p).read()
old = 'static BUSTER_DIRECT_HOT void fast_pp_lex_window(FastPP* pp, const FastIncludeFile* f, const uint8_t* p, bool bol, bool line_mode)\n{'
assert s.count(old) == 1
s = s.replace(old, '''static BUSTER_DIRECT_HOT void fast_pp_lex_window_once(FastPP* pp, const FastIncludeFile* f, const uint8_t* p, bool bol, bool line_mode);
static BUSTER_DIRECT_HOT void fast_pp_lex_window(FastPP* pp, const FastIncludeFile* f, const uint8_t* p, bool bol, bool line_mode)
{
    const uint32_t generation = pp->win.generation;
    fast_pp_lex_window_once(pp, f, p, bol, line_mode);
    pp->win.generation = generation;
    fast_pp_lex_window_once(pp, f, p, bol, line_mode);
}
static BUSTER_DIRECT_HOT __attribute__((noinline)) void fast_pp_lex_window_once(FastPP* pp, const FastIncludeFile* f, const uint8_t* p, bool bol, bool line_mode)
{''')
open(p, 'w').write(s)
