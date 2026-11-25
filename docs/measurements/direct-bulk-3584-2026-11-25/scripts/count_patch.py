import sys,re
p='src/buster/compiler/c_direct_lex.c'
s=open(p).read()
names=[]
def C(n, e='1'):
    if n not in names: names.append(n)
    return f' dpstat.{n} += (uint64_t)({e}); '
def once(s, anchor, ins, after=True):
    assert s.count(anchor)==1, (anchor, s.count(anchor))
    return s.replace(anchor, anchor+ins if after else ins+anchor)
# reader entry, by caller context
s=once(s,'static BUSTER_DIRECT_HOT void fast_pp_read_tok(FastPP* pp, FastIncludeFile* f, bool stop_at_eol, FastTok* out_tok)\n{', C('read_calls')+C('read_eol','stop_at_eol')+' dpstat.read_ctx[dpstat_ctx] += 1; ')
s=once(s,'                    *out_tok = fast_pp_window_tok(pp, f, t, flags, &text_end);', C('read_from_window')+C('read_kind_ident','w->kinds[t]==FTOK_IDENT')+C('read_kind_num','w->kinds[t]==FTOK_INT_LIT')+C('read_kind_str','w->kinds[t]==FTOK_STR_LIT'), after=False)
s=once(s,'                fast_pp_lex_window(pp, f, w->lex_ptr, w->lex_bol, w->line_mode);\n                lexed_here = true;', C('read_relex_cap'))
s=once(s,'            fast_pp_lex_window(pp, f, f->ptr, f->at_bol, stop_at_eol);\n            lexed_here = true;', C('read_new_window')+C('read_new_line_window','stop_at_eol'))
s=once(s,'    f->ptr = fast_lex_one(pp, f->ptr, f->end, &f->line, &f->at_bol, stop_at_eol, out_tok);\n}', C('read_lex_one'), after=False)
# directive kinds
s=once(s,'    const uint8_t pkw = pp->idents.entries[kw_tok.data].pp_kw;\n', ' dpstat.dir_kw[pkw] += 1; '+C('directives'))
# contexts
s=once(s,'static __attribute__((noinline)) void fast_pp_handle_directive(FastPP* pp, FastIncludeFile* f)\n{', ' dpstat_ctx = 1; ')
s=once(s,'static __attribute__((noinline)) void fast_pp_handle_define(FastPP* pp, FastIncludeFile* f)\n{', ' dpstat_ctx = 2; '+C('defines'))
s=once(s,'    const uint32_t body_start = pp->macro_tok_count;\n    bool has_ops = false;', ' dpstat_ctx = 3; '+C('define_func','is_func')+C('define_params','param_count'))
s=once(s,'    fast_pp_skip_to_eol(f);\n\n    const uint32_t midx = ++pp->macro_count;', C('define_body_toks','pp->macro_tok_count - body_start')+' dpstat_ctx = 1; ')
s=once(s,'    if (!fast_pp_consume_lparen(pp, stop_at_eol, min_expand_depth, allow_file))\n    {', C('func_attempts')+C('func_attempts_file','allow_file && pp->expand_depth == min_expand_depth')+' uint32_t fs_save = dpstat_ctx; dpstat_ctx = 4; ', after=False)
s=once(s,'    uint32_t cdepth = 1u;\n    FastMacroCall* root = pp->call_stack;', ' dpstat_ctx = 5; '+C('func_calls')+C('func_calls_file','allow_file && pp->expand_depth == min_expand_depth'))
s=once(s,'    if (pp->bailout)\n    {\n        pp->arg_used = root->saved_arg_used;\n        return false;\n    }\n    out_replacement->kind = FTOK_EOF;\n    return true;\n}', ' dpstat_ctx = fs_save; ', after=False)
s=once(s,'                if (!fast_pp_next_raw_for_args(pp, &at, false, cf->min_expand_depth, cf->allow_file))', C('arg_toks'), after=False)
s=once(s,'                const uint32_t i = cf->scan_body_idx++;', C('scan_body_iters'))
s=once(s,'                        cf->active_pidx = pidx;', C('prescans'))
s=once(s,'            const uint32_t subst_start = pp->exp_used;', C('substitutions')+C('subst_body_toks','bcount'))
s=once(s,'            pp->arg_used = cf->saved_arg_used;', C('subst_out_toks','pp->exp_used - subst_start'), after=False)
s=once(s,'    // Any other macro: the expansion engine\'s, which reads its arguments through the window.', C('wm_general'))
s=once(s,'static __attribute__((noinline)) bool fast_pp_window_macro(FastPP* pp, FastIncludeFile* f, uint32_t id, uint8_t kind)\n{', C('wm_calls')+' dpstat_ctx = 6; ')
s=once(s,'    const FastTok mtok = fast_tok_make(kind, 0, 0, id);', '''
    {
        const uint32_t fmidx2 = pp->idents.entries[id].macro_idx;
        if (fmidx2 != 0 && pp->macros[fmidx2].is_func) {
            dpstat.wm_func += 1;
            const uint32_t n = w->count; uint32_t i = t + 1u;
            if (i < n && w->kinds[i] == FTOK_LPAREN) {
                dpstat.wm_func_lparen += 1; uint32_t depth = 1; i += 1; bool ok = true; uint32_t toks = 0; uint32_t idents = 0;
                while (i < n && depth > 0) { uint8_t k = w->kinds[i]; if (k == FTOK_LPAREN) depth++; else if (k == FTOK_RPAREN) depth--; else if (k == 0) { ok = false; break; } if (k==FTOK_IDENT) idents++; if (k==FTOK_STR_LIT) dpstat.wm_str += 1; if (k==FTOK_INT_LIT) {dpstat.wm_num += 1; if (fast_number_goes_on(f->base + w->starts[i], w->lens[i])) dpstat.wm_num_goes_on += 1;} i++; toks++; }
                if (ok && depth == 0) { dpstat.wm_func_inwin += 1; dpstat.wm_func_inwin_toks += toks; dpstat.wm_func_inwin_idents += idents; if (toks > 64) dpstat.wm_func_long += 1; }
                else if (!ok) dpstat.wm_func_scalar += 1; else dpstat.wm_func_winend += 1;
            }
        }
    }
''', after=False)
names += ['wm_func','wm_func_lparen','wm_str','wm_num','wm_num_goes_on','wm_func_inwin','wm_func_inwin_toks','wm_func_inwin_idents','wm_func_long','wm_func_scalar','wm_func_winend']
hdr='''
static inline bool fast_number_goes_on(const uint8_t* s, uint32_t len);
#include <stdio.h>
static uint32_t dpstat_ctx;
static struct { %s uint64_t read_ctx[8]; uint64_t dir_kw[256]; } dpstat;
static void __attribute__((destructor)) dpstat_print(void)
{
%s
    for (int i = 0; i < 8; i++) fprintf(stderr, "read_ctx[%%d] %%llu\\n", i, (unsigned long long)dpstat.read_ctx[i]);
    for (int i = 0; i < 256; i++) if (dpstat.dir_kw[i]) fprintf(stderr, "dir_kw[%%d] %%llu\\n", i, (unsigned long long)dpstat.dir_kw[i]);
}
'''
fields=''.join(f'uint64_t {n}; ' for n in names)
prints=''.join(f'    fprintf(stderr, "{n} %llu\\n", (unsigned long long)dpstat.{n});\n' for n in names)
s=once(s,'static void fast_pp_read_tok(FastPP* pp, FastIncludeFile* f, bool stop_at_eol, FastTok* out_tok);', hdr%(fields,prints), after=False)
open(p,'w').write(s)
