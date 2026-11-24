import re,sys
d='buster/compiler/'
lex=open(d+'c_direct_lex.c').read()
typ=open(d+'c_direct_types.c').read()
cc=open(d+'c_direct_cc.c').read()
x86=open(d+'c_direct_x86.c').read()
names=[]
def DS(n):
    if n not in names: names.append(n)
    return f' dstat.{n} += 1; '
def DSA(n,e):
    if n not in names: names.append(n)
    return f' dstat.{n} += (uint64_t)({e}); '
def once(s, anchor, ins, after=True, count=1):
    assert s.count(anchor)>=1, anchor
    if count==1: assert s.count(anchor)==1, (anchor, s.count(anchor))
    return s.replace(anchor, anchor+ins if after else ins+anchor, count if count else -1)
def entry(s, sig, n):
    i=s.index(sig); j=s.index('\n{\n', i)
    return s[:j+3]+DS(n)+'\n'+s[j+3:]
# --- lexer
lex=once(lex,'const __mmask64 non_ascii = _mm512_movepi8_mask(v);', DS('chunk_iters'))
lex=once(lex,'''                    p += limit;
                    if (limit == 64u)
                    {
                        continue;
                    }''', DS('chunk_ws_first')+DSA('chunk_ws_bytes','limit'), after=False)
lex=once(lex,'''                        if (ch1 == '*')
                        {
                            const uint8_t* after = fast_skip_block_comment(p + 2, end, &line);''', DS('sp_block_comment')+' if (after != NULL) {'+DSA('comment_bytes','after - p')+'}')
lex=once(lex,'''                        if (ch1 == '/')
                        {
                            p = fast_skip_line_comment(p + 2, end, &line);''', DS('sp_line_comment'))
lex=once(lex,"out_kind[out_count] = ch1 == '=' ? FTOK_DIV_ASSIGN : FTOK_SLASH;", DS('sp_slash_op'))
lex=once(lex,"                    if (ch == '#' && bol)\n                    {", DS('sp_directive'))
lex=once(lex,"                        FastTok stok = { 0 };", DS('sp_string_char'))
lex=once(lex,"                    // Fallback single token for '\\\\', mid-line '#', or non-ASCII", DS('sp_fallback'), after=False)
lex=once(lex,"const uint32_t m_count = (uint32_t)__builtin_popcountll(tok_starts);", DSA('chunk_tokens','m_count')+DSA('chunk_tok_bytes','limit')+' dstat.limit_hist[limit] += 1; dstat.mcount_hist[m_count] += 1; '+DS('chunk_commits'))
lex=once(lex,"                    const uint32_t b = pos_arr[k];\n                    const uint32_t len = (uint32_t)__builtin_ctzll(non_ident >> b);\n                    uint8_t kind = FTOK_IDENT;", DS('id_lanes')+' dstat.idlen_hist[len > 63 ? 63 : len] += 1; ')
lex=once(lex,"        id = slot->id;\n        *out_kind = slot->tok_kind;", DS('id16_hit'))
lex=once(lex,"        id = fast_ident_intern(t, p, len);\n        uint8_t kind = FTOK_IDENT;", DS('id16_miss'))
lex=entry(lex,'static BUSTER_DIRECT_HOT uint32_t fast_ident_intern(','intern_calls')
lex=once(lex,"                                out_kind[out_count + k] = fm->fast_kind;\n                                out_data[out_count + k] = fm->fast_data;", DS('macro_inplace'))
lex=once(lex,"                        if (k < first_macro_lane)\n                        {", DS('macro_break'))
lex=once(lex,"                        if (fmode == 4u)\n                        {", DS('macro_empty'))
lex=once(lex,"                            if (q < end && *q == '(')\n                            {\n                                p = q;\n                                bol = false;", DS('macro_identity'))
lex=once(lex,"                            const FastTok* const bt = pp->macro_toks + fm->body_start;", DS('macro_const'))
lex=once(lex,"                            if (after_args != NULL)\n                            {", DS('macro_skipargs'))
lex=once(lex,"                    const FastTok mtok = { .kind = first_macro_kind, .data = first_macro_id };", DS('macro_general'))
lex=once(lex,"                    num_lanes &= num_lanes - 1u;\n                    const uint32_t b = pos_arr[k];", DS('num_lanes'), after=False)
lex=once(lex,"                        out_data[out_count + k] = (uint32_t)(p[b] - '0');", DS('num_1digit'))
lex=once(lex,"                        if (all_dig)\n                        {", DS('num_2_4digit'))
lex=once(lex,"                if (pair_mask != 0)\n                {", DS('pair_loops'))
lex=once(lex,"                if (vec_folded != 0)\n                {", DS('vec_folded'))
lex=once(lex,"        FastTok tok = { 0 };\n        f->ptr = fast_lex_one(pp, f->ptr, f->end, &f->line, &f->at_bol, false, &tok);", DS('drain_lex_one'), after=False)
lex=once(lex,"            FastExprFrame* ef = pp->expand + (pp->expand_depth - 1u);\n            if (ef->pos >= ef->count)" if "FastExprFrame* ef" in lex else "            FastExpandFrame* ef = pp->expand + (pp->expand_depth - 1u);\n            if (ef->pos >= ef->count)", DS('expand_iters'), after=False)
lex=once(lex,"            const uint8_t kw = fast_pp_skip_inactive(pp, f);", ' const uint8_t* ds_p0 = f->ptr; ', after=False)
lex=once(lex,"            const uint8_t kw = fast_pp_skip_inactive(pp, f);", DS('inactive_calls')+DSA('inactive_bytes','f->ptr - ds_p0'))
lex=entry(lex,'static BUSTER_DIRECT_HOT const uint8_t* fast_lex_one(','lex_one_calls')
lex=entry(lex,'static BUSTER_DIRECT_HOT bool fast_pp_try_expand_ex(','try_expand_calls')
lex=entry(lex,'static __attribute__((noinline)) void fast_pp_handle_define(','define_calls')
lex=entry(lex,'static __attribute__((noinline)) void fast_pp_handle_directive(','directive_calls')
lex=entry(lex,'static const uint8_t* fast_lex_number(','lex_number_calls')
lex=entry(lex,'static const uint8_t* fast_skip_block_comment(','block_comment_calls')
lex=entry(lex,'static const uint8_t* fast_skip_line_comment(','line_comment_calls')
lex=entry(lex,'static const uint8_t* fast_lex_string(','lex_string_calls')
lex=entry(lex,'static const uint8_t* fast_lex_char(','lex_char_calls')
# inner-chunk limit pullbacks
lex=once(lex,"                        limit = 64u - (uint32_t)__builtin_clzll(cuts);\n                    }\n                }\n                else\n                {", DS('cut_at_63'), after=False)
# --- types
typ=entry(typ,'static const FastMemberInfo* fast_struct_find_member(','member_lookups')
typ=once(typ,"    const uint32_t count = st->count;\n    const FastMemberInfo* found = NULL;", DSA('member_count_sum','count')+' dstat.member_hist[count > 255 ? 255 : count] += 1; ')
typ=entry(typ,'static inline uint32_t fast_cc_scope_enter(','scope_enters')
typ=entry(typ,'static uint32_t fast_cc_sym_bind(','sym_binds')
typ=entry(typ,'static bool fast_cc_is_type_start(','is_type_start_calls')
typ=entry(typ,'static BUSTER_DIRECT_HOT bool fast_cc_parse_declarator(','declarator_calls')
typ=entry(typ,'static BUSTER_DIRECT_HOT FastType fast_cc_parse_decl_specs(','decl_specs_calls')
# --- cc
for sig,n in [('static void fval_spill_one(FastExprCtx* ex, FastVal* v)','spill_one_calls'),
              ('static BUSTER_DIRECT_HOT uint32_t fval_to_gp(','to_gp_calls'),
              ('static BUSTER_DIRECT_HOT void fval_convert(','convert_calls'),
              ('static BUSTER_DIRECT_HOT void fval_store(','store_calls'),
              ('static BUSTER_DIRECT_HOT void fval_emit_binary(','binary_calls'),
              ('static BUSTER_DIRECT_HOT void fval_emit_call(','call_calls'),
              ('static BUSTER_DIRECT_HOT void fast_expr_reduce_top(','reduce_calls'),
              ('static BUSTER_DIRECT_HOT void fast_cc_expr(','expr_calls'),
              ('static BUSTER_DIRECT_HOT void fast_cc_compile_func(','func_calls'),
              ('static uint32_t fval_alloc_gp_avoid(','alloc_gp_calls'),
              ('static void fval_flush_flags(','flush_flags_calls'),
              ('static void fval_branch(','branch_calls'),
              ('static FastBodyScan fast_cc_prescan_body(','prescan_calls')]:
    cc=entry(cc,sig,n)
cc=once(cc,"    while (cc->pos < cc->tcount && !cc->bailout)\n    {\n        const uint8_t k = fast_cc_peek(cc);\n        if (expect_val)", DS('expr_loop_iters'), after=False) if False else cc.replace("    while (cc->pos < cc->tcount && !cc->bailout)\n    {\n        const uint8_t k = fast_cc_peek(cc);\n        if (expect_val)", "    while (cc->pos < cc->tcount && !cc->bailout)\n    {\n"+DS('expr_loop_iters')+"\n        const uint8_t k = fast_cc_peek(cc);\n        if (expect_val)",1)
cc=once(cc,"    while (ssp > 0 && cc->pos < cc->tcount && !cc->bailout)\n    {\n        FastStmtFrame* top = sstack + (ssp - 1u);", DS('stmt_loop_iters'))
cc=once(cc,"        const uint32_t rem = n - i;\n        const uint32_t chunk = rem >= 64u ? 64u : rem;", DS('prescan_chunks'))
x86=once(x86,"    fast_obj_build_eh_frame(obj);\n    if (obj->overflow)", DSA('text_bytes','obj->text.len')+DSA('rela_text','obj->rela_text.count')+DSA('rodata_bytes','obj->rodata.len')+DSA('rodata_str_bytes','obj->rodata_str.len')+DSA('data_bytes','obj->data.len')+DSA('obj_syms','obj->sym_count')+DSA('fdes','obj->fde_count')+DSA('strtab_bytes','obj->strtab.len'), after=False)
# pp-level totals at the end of fast_pp_run_file
lex=once(lex,"        ok = fast_pp_drain(pp);\n        if (ok && pp->out_count < pp->out_cap)\n        {", DSA('out_tokens','pp->out_count')+DSA('idents','pp->idents.count')+DSA('ident_str_bytes','pp->idents.str_used')+DSA('macros','pp->macro_count')+DSA('macro_toks','pp->macro_tok_count')+DSA('nums','pp->num_count')+DSA('lits','pp->lit_count')+DSA('lit_bytes','pp->lit_bytes_used')+DSA('arena_used','pp->arena->used')+DSA('scratch_used','pp->scratch->used'))
hdr='typedef struct DStat DStat;\nstruct DStat\n{\n'+''.join(f'    uint64_t {n};\n' for n in names)+'    uint64_t limit_hist[65];\n    uint64_t mcount_hist[65];\n    uint64_t idlen_hist[64];\n    uint64_t member_hist[256];\n};\nDStat dstat;\nconst char* const dstat_names[] = {'+', '.join(f'"{n}"' for n in names)+'};\nconst unsigned dstat_count = '+str(len(names))+';\n'
lex=once(lex,'#include <immintrin.h>\n', hdr)
open(d+'c_direct_lex.c','w').write(lex); open(d+'c_direct_types.c','w').write(typ); open(d+'c_direct_cc.c','w').write(cc); open(d+'c_direct_x86.c','w').write(x86)
print(len(names),'counters')
