// Census counters for #3581 (scratch; never committed).
#ifndef C_DIRECT_CENSUS_H
#define C_DIRECT_CENSUS_H
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
typedef struct DCShape { uint64_t hash; uint64_t count; uint64_t ticks; uint32_t len; uint8_t kinds[34]; } DCShape;
static struct
{
    uint64_t expr_calls[8];
    uint64_t expr_tokens[66];
    uint64_t expr_iters[66];
    uint64_t loop[2][256];
    uint64_t ident_symkind[8];
    uint64_t reduce_op[256];
    uint64_t to_gp[16][2];
    uint64_t to_xmm[16];
    uint64_t addr_to_gp[16];
    uint64_t convert_kind[16];
    uint64_t convert_same, convert_samescalar, convert_total;
    uint64_t convert_pair[32][32];
    uint64_t binary[64][16][16];
    uint64_t call_argc[18];
    uint64_t call_argkind[16];
    uint64_t call_direct, call_indirect, call_builtin, call_var;
    uint64_t spill_one[16];
    uint64_t spill_all_calls;
    uint64_t alloc_gp_calls, alloc_gp_spill;
    uint64_t store[16][16];
    uint64_t stmt[256];
    uint64_t stmt_iters;
    uint64_t flush_flags_calls;
    uint64_t check_conv_calls;
    uint64_t decl_specs, declarators, funcs, is_type_start;
    uint64_t decl_specs_scope[2];
    uint64_t declarator_scope[2];
    uint64_t emit_bytes_start;
    DCShape* shapes;
    uint32_t shape_cap;
    uint64_t shape_long; uint64_t expr_ticks;
    uint64_t conv_nopointer, flush_found, imm_fold, imm_conv_other, param_specs, param_one;
    uint64_t decl_simple[8]; uint64_t decl_next[256]; uint64_t specs_first[256]; uint64_t specs_simple; uint64_t specs_ntok[8];
} dcen;
static void dcen_shape(const uint8_t* kinds, uint32_t len, uint64_t ticks)
{
    if (len > 34u) { dcen.shape_long += 1; return; }
    if (dcen.shapes == NULL) { dcen.shape_cap = 1u << 17; dcen.shapes = calloc(dcen.shape_cap, sizeof(DCShape)); }
    uint64_t h = 1469598103934665603ull ^ len;
    for (uint32_t i = 0; i < len; i += 1) { h = (h ^ kinds[i]) * 1099511628211ull; }
    h |= 1u;
    uint32_t s = (uint32_t)(h >> 40) & (dcen.shape_cap - 1u);
    while (dcen.shapes[s].hash != 0 && dcen.shapes[s].hash != h) { s = (s + 1u) & (dcen.shape_cap - 1u); }
    if (dcen.shapes[s].hash == 0) { dcen.shapes[s].hash = h; dcen.shapes[s].len = len; memcpy(dcen.shapes[s].kinds, kinds, len); }
    dcen.shapes[s].count += 1; dcen.shapes[s].ticks += ticks;
}
#endif
