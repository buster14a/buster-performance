import sys
d = sys.argv[1] + '/src/buster/compiler/'
def rd(n): return open(d + n).read()
def wr(n, s): open(d + n, 'w').write(s)
def once(s, anchor, ins, after=True):
    c = s.count(anchor)
    assert c == 1, (anchor[:80], c)
    return s.replace(anchor, anchor + ins if after else ins + anchor)
def entry(s, sig, ins):
    assert s.count(sig) == 1, sig
    i = s.index(sig); j = s.index('\n{\n', i)
    return s[:j + 3] + '    ' + ins + '\n' + s[j + 3:]
lex = rd('c_direct_lex.c')
lex = once(lex, '#define BUSTER_DIRECT_HOT __attribute__((section(".text.buster_checker")))', '\n#include "buster/compiler/c_direct_census.h"')
wr('c_direct_lex.c', lex)
typ = rd('c_direct_types.c')
typ = entry(typ, 'static BUSTER_DIRECT_HOT bool fast_cc_parse_declarator(', 'dcen.declarators += 1; dcen.declarator_scope[cc->scope_depth != 0] += 1;')
typ = entry(typ, 'static BUSTER_DIRECT_HOT FastType fast_cc_parse_decl_specs(', 'dcen.decl_specs += 1; dcen.decl_specs_scope[cc->scope_depth != 0] += 1;')
typ = entry(typ, 'static bool fast_cc_is_type_start(', 'dcen.is_type_start += 1;')
wr('c_direct_types.c', typ)
cc = rd('c_direct_cc.c')
cc = once(cc, '''    FastExprOp ops[128];
    uint32_t osp = 0;
    bool expect_val = true;
''', '    const uint32_t dc_start = cc->pos; uint32_t dc_iters = 0; dcen.expr_calls[(is_branch ? 2 : 0) | (discard_result ? 1 : 0) | (out_val != NULL ? 4 : 0)] += 1;\n')
cc = once(cc, '''    while (cc->pos < cc->tcount && !cc->bailout)
    {
        const uint8_t k = fast_cc_peek(cc);
        if (expect_val)
        {''', '\n            dcen.loop[1][k] += 1; dc_iters += 1;')
cc = once(cc, '''        // HOT PATH: `;` ends almost every expression statement immediately!''', '        dcen.loop[0][k] += 1; dc_iters += 1;\n', after=False)
cc = once(cc, '                    const uint32_t symbol_kind = sym->kind & 7u;\n', '                    dcen.ident_symkind[symbol_kind] += 1;\n')
cc = once(cc, '''    if (cc->bailout) { return; }
    if (ex.vsp != 1u)
    {
        fast_cc_bail(cc, "expression did not produce single value");''', '''    {
        const uint32_t dc_n = cc->pos - dc_start;
        dcen.expr_tokens[dc_n > 64 ? 65 : dc_n] += 1; dcen.expr_iters[dc_iters > 64 ? 65 : dc_iters] += 1;
        uint8_t dk[40]; uint32_t dl = dc_n > 33 ? 33 : dc_n;
        for (uint32_t i = 0; i < dl; i += 1)
        {
            uint8_t kk = cc->tk[dc_start + i];
            if (kk == FTOK_IDENT)
            {
                const uint8_t pk = i > 0 ? cc->tk[dc_start + i - 1] : 0;
                if (pk == FTOK_DOT || pk == FTOK_ARROW) { kk = 206; }
                else
                {
                    const uint32_t id = cc->td[dc_start + i];
                    const uint32_t si = id < cc->env_cap ? cc->sym_cur[id] : 0u;
                    kk = si == 0 ? 205 : (uint8_t)(200 + ((cc->syms[si].kind & 7u) == FSYM_LOCAL ? 0 : (cc->syms[si].kind & 7u) == FSYM_GLOBAL ? 1 : (cc->syms[si].kind & 7u) == FSYM_FUNC ? 2 : (cc->syms[si].kind & 7u) == FSYM_ENUM_CONST ? 3 : 4));
                }
            }
            dk[i] = kk;
        }
        dk[dl < 33 ? dl : 32] = (uint8_t)(is_branch ? 250 : discard_result ? 251 : 252);
        dcen_shape(dk, dl + 1 > 33 ? 34 : dl + 1);
    }
''', after=False)
cc = once(cc, '''    const FastExprOp cur = ops[--(*osp_ptr)];
    const uint16_t op = cur.op;
''', '    dcen.reduce_op[op & 255u] += 1;\n')
cc = entry(cc, 'static BUSTER_DIRECT_HOT uint32_t fval_to_gp(', 'dcen.to_gp[v->kind & 15u][consume] += 1;')
cc = entry(cc, 'static uint32_t fval_to_xmm(', 'dcen.to_xmm[v->kind & 15u] += 1;')
cc = entry(cc, 'static uint32_t fval_addr_to_gp(', 'dcen.addr_to_gp[v->kind & 15u] += 1;')
cc = entry(cc, 'static BUSTER_DIRECT_HOT void fval_convert(', '''dcen.convert_total += 1; dcen.convert_kind[v->kind & 15u] += 1; dcen.convert_same += v->type == dst_type; dcen.convert_samescalar += ftype_unqual(v->type) == ftype_unqual(dst_type);
    { const FastType a = v->type, b = dst_type; const uint32_t ca = (a & BUSTER_FTYPE_COMPLEX_BIT) ? 16u + ((a >> BUSTER_FTYPE_KIND_SH) & 7u) : (a & BUSTER_FTYPE_PTR_MASK) ? 30u : (a & 15u); const uint32_t cb = (b & BUSTER_FTYPE_COMPLEX_BIT) ? 16u + ((b >> BUSTER_FTYPE_KIND_SH) & 7u) : (b & BUSTER_FTYPE_PTR_MASK) ? 30u : (b & 15u); dcen.convert_pair[ca][cb] += 1; }''')
cc = entry(cc, 'static BUSTER_DIRECT_HOT void fval_emit_binary(', 'dcen.binary[op & 63u][lhs->kind & 15u][rhs->kind & 15u] += 1;')
cc = entry(cc, 'static BUSTER_DIRECT_HOT void fval_emit_call(', '''dcen.call_argc[argc > 16 ? 17 : argc] += 1; for (uint32_t i = 0; i < argc; i += 1) { dcen.call_argkind[args[i].kind & 15u] += 1; }
    if (callee->kind == FVAL_BUILTIN) { dcen.call_builtin += 1; } else if (callee->kind == FVAL_GLOBAL && callee->is_func_sym) { dcen.call_direct += 1; } else { dcen.call_indirect += 1; }''')
cc = entry(cc, 'static void fval_spill_one(FastExprCtx* ex, FastVal* v)', 'dcen.spill_one[v->kind & 15u] += 1;')
cc = entry(cc, 'static void fval_spill_all(', 'dcen.spill_all_calls += 1;')
cc = entry(cc, 'static uint32_t fval_alloc_gp_avoid(', 'dcen.alloc_gp_calls += 1;')
cc = once(cc, '    // Spill oldest GP holder not in avoid_mask from call_args or vstack\n', '    dcen.alloc_gp_spill += 1;\n')
cc = entry(cc, 'static BUSTER_DIRECT_HOT void fval_store(', 'dcen.store[lhs->kind & 15u][rhs->kind & 15u] += 1;')
cc = entry(cc, 'static void fval_flush_flags(', 'dcen.flush_flags_calls += 1;')
cc = entry(cc, 'static __attribute__((noinline)) void fast_cc_check_implicit_conv(', 'dcen.check_conv_calls += 1;')
cc = entry(cc, 'static BUSTER_DIRECT_HOT void fast_cc_compile_func(', 'dcen.funcs += 1;')
cc = once(cc, '''        const uint8_t k = fast_cc_peek(cc);

        // 1. Nested compound block `{ ... }`''', '\n        dcen.stmt[k] += 1;', after=False) if False else cc
cc = once(cc, '''        // 1. Nested compound block `{ ... }`''', '        dcen.stmt[k] += 1;\n', after=False)
cc = once(cc, '''        FastStmtFrame* top = sstack + (ssp - 1u);
''', '        dcen.stmt_iters += 1;\n')
cc += open('/home/user/dp/census/dump.c').read()
wr('c_direct_cc.c', cc)
print('patched')
