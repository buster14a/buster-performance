
static int dcen_cmp(const void* a, const void* b) { const DCShape* x = a; const DCShape* y = b; return x->count < y->count ? 1 : x->count > y->count ? -1 : 0; }
static const char* dcen_tok(uint8_t k)
{
    static const char* p[] = { "EOF","id","int","flt","chr","str","(",")","{","}","[","]",";",",",".","->","...","?",":","~","!","++","--","+","-","*","/","%","&","|","^","<<",">>","<","<=",">",">=","==","!=","&&","||","=","+=","-=","*=","/=","%=","&=","|=","^=","<<=",">>=","#","##" };
    static char buf[16];
    if (k < 54) { return p[k]; }
    switch (k)
    {
        case 200: return "L"; case 201: return "G"; case 202: return "F"; case 203: return "E"; case 204: return "T"; case 205: return "?id"; case 206: return "m";
        case 250: return "[br]"; case 251: return "[disc]"; case 252: return "[val]";
        case FTOK_KW_SIZEOF: return "sizeof"; case FTOK_INT_U32: return "u32"; case FTOK_INT_I64: return "i64"; case FTOK_INT_U64: return "u64";
        case FTOK_KW_INT: return "int"; case FTOK_KW_CHAR: return "char"; case FTOK_KW_VOID: return "void"; case FTOK_KW_UNSIGNED: return "unsigned"; case FTOK_KW_CONST: return "const";
        default: snprintf(buf, sizeof buf, "k%u", k); return buf;
    }
}
__attribute__((destructor)) static void dcen_dump(void)
{
    const char* path = getenv("DCEN_OUT");
    if (path == NULL) { return; }
    FILE* f = fopen(path, "w");
    if (f == NULL) { return; }
    uint64_t tot = 0;
    for (int i = 0; i < 8; i += 1) { tot += dcen.expr_calls[i]; }
    fprintf(f, "expr calls %llu: plain %llu discard %llu branch %llu val %llu\n", (unsigned long long)tot, (unsigned long long)dcen.expr_calls[0], (unsigned long long)dcen.expr_calls[1], (unsigned long long)dcen.expr_calls[2], (unsigned long long)dcen.expr_calls[4]);
    uint64_t ti = 0, tt = 0;
    for (int i = 0; i < 66; i += 1) { ti += dcen.expr_iters[i] * (uint64_t)i; tt += dcen.expr_tokens[i] * (uint64_t)i; }
    fprintf(f, "expr loop iterations ~%llu tokens ~%llu\n", (unsigned long long)ti, (unsigned long long)tt);
    fprintf(f, "tokens per expression:");
    for (int i = 0; i < 66; i += 1) { if (dcen.expr_tokens[i]) fprintf(f, " %d:%llu", i, (unsigned long long)dcen.expr_tokens[i]); }
    fprintf(f, "\nloop by (expect_val, kind):\n");
    for (int e = 1; e >= 0; e -= 1) for (int k = 0; k < 256; k += 1) if (dcen.loop[e][k]) fprintf(f, "  %s %-8s %llu\n", e ? "val" : "op ", dcen_tok((uint8_t)k), (unsigned long long)dcen.loop[e][k]);
    fprintf(f, "ident symbol kinds:"); for (int i = 0; i < 8; i += 1) fprintf(f, " %d:%llu", i, (unsigned long long)dcen.ident_symkind[i]);
    fprintf(f, "\nreduce ops:\n"); for (int i = 0; i < 256; i += 1) if (dcen.reduce_op[i]) fprintf(f, "  %3d %-6s %llu\n", i, i >= 64 ? dcen_tok((uint8_t)(i - 64)) : "", (unsigned long long)dcen.reduce_op[i]);
    fprintf(f, "to_gp by kind (consume0, consume1):\n"); for (int i = 0; i < 16; i += 1) if (dcen.to_gp[i][0] | dcen.to_gp[i][1]) fprintf(f, "  %2d %llu %llu\n", i, (unsigned long long)dcen.to_gp[i][0], (unsigned long long)dcen.to_gp[i][1]);
    fprintf(f, "to_xmm by kind:"); for (int i = 0; i < 16; i += 1) if (dcen.to_xmm[i]) fprintf(f, " %d:%llu", i, (unsigned long long)dcen.to_xmm[i]);
    fprintf(f, "\naddr_to_gp by kind:"); for (int i = 0; i < 16; i += 1) if (dcen.addr_to_gp[i]) fprintf(f, " %d:%llu", i, (unsigned long long)dcen.addr_to_gp[i]);
    fprintf(f, "\nconvert total %llu same-type %llu same-unqual %llu; by kind:", (unsigned long long)dcen.convert_total, (unsigned long long)dcen.convert_same, (unsigned long long)dcen.convert_samescalar);
    for (int i = 0; i < 16; i += 1) if (dcen.convert_kind[i]) fprintf(f, " %d:%llu", i, (unsigned long long)dcen.convert_kind[i]);
    fprintf(f, "\nconvert pairs (class src->dst, 30=ptr, 16+=complex):\n"); for (int a = 0; a < 32; a += 1) for (int b = 0; b < 32; b += 1) if (dcen.convert_pair[a][b] > 200) fprintf(f, "  %2d->%2d %llu\n", a, b, (unsigned long long)dcen.convert_pair[a][b]);
    fprintf(f, "binary (op lhs rhs) > 300:\n"); for (int o = 0; o < 64; o += 1) for (int a = 0; a < 16; a += 1) for (int b = 0; b < 16; b += 1) if (dcen.binary[o][a][b] > 300) fprintf(f, "  %-4s %2d %2d %llu\n", dcen_tok((uint8_t)o), a, b, (unsigned long long)dcen.binary[o][a][b]);
    fprintf(f, "calls direct %llu indirect %llu builtin %llu; argc:", (unsigned long long)dcen.call_direct, (unsigned long long)dcen.call_indirect, (unsigned long long)dcen.call_builtin);
    for (int i = 0; i < 18; i += 1) if (dcen.call_argc[i]) fprintf(f, " %d:%llu", i, (unsigned long long)dcen.call_argc[i]);
    fprintf(f, "\ncall arg kinds:"); for (int i = 0; i < 16; i += 1) if (dcen.call_argkind[i]) fprintf(f, " %d:%llu", i, (unsigned long long)dcen.call_argkind[i]);
    fprintf(f, "\nspill_one calls by kind:"); for (int i = 0; i < 16; i += 1) if (dcen.spill_one[i]) fprintf(f, " %d:%llu", i, (unsigned long long)dcen.spill_one[i]);
    fprintf(f, "\nspill_all %llu alloc_gp %llu (spilling %llu) flush_flags %llu check_conv %llu\n", (unsigned long long)dcen.spill_all_calls, (unsigned long long)dcen.alloc_gp_calls, (unsigned long long)dcen.alloc_gp_spill, (unsigned long long)dcen.flush_flags_calls, (unsigned long long)dcen.check_conv_calls);
    fprintf(f, "store (lhs rhs) > 200:\n"); for (int a = 0; a < 16; a += 1) for (int b = 0; b < 16; b += 1) if (dcen.store[a][b] > 200) fprintf(f, "  %2d %2d %llu\n", a, b, (unsigned long long)dcen.store[a][b]);
    fprintf(f, "statement loop iterations %llu; statements by first token:\n", (unsigned long long)dcen.stmt_iters); for (int k = 0; k < 256; k += 1) if (dcen.stmt[k]) fprintf(f, "  %-8s %llu\n", dcen_tok((uint8_t)k), (unsigned long long)dcen.stmt[k]);
    fprintf(f, "functions %llu decl_specs %llu (file %llu, block %llu) declarators %llu (file %llu, block %llu) is_type_start %llu\n", (unsigned long long)dcen.funcs, (unsigned long long)dcen.decl_specs, (unsigned long long)dcen.decl_specs_scope[0], (unsigned long long)dcen.decl_specs_scope[1], (unsigned long long)dcen.declarators, (unsigned long long)dcen.declarator_scope[0], (unsigned long long)dcen.declarator_scope[1], (unsigned long long)dcen.is_type_start);
    if (dcen.shapes != NULL)
    {
        uint32_t n = 0;
        for (uint32_t i = 0; i < dcen.shape_cap; i += 1) if (dcen.shapes[i].hash) dcen.shapes[n++] = dcen.shapes[i];
        qsort(dcen.shapes, n, sizeof(DCShape), dcen_cmp);
        fprintf(f, "shapes %u distinct, %llu longer than 32; top 120 (count cum%%):\n", n, (unsigned long long)dcen.shape_long);
        uint64_t cum = 0;
        for (uint32_t i = 0; i < n; i += 1)
        {
            cum += dcen.shapes[i].count;
            if (i < 120 || (i % 500) == 0)
            {
                fprintf(f, "  %6llu %5.1f%% ", (unsigned long long)dcen.shapes[i].count, 100.0 * (double)cum / (double)tot);
                for (uint32_t j = 0; j < dcen.shapes[i].len; j += 1) fprintf(f, " %s", dcen_tok(dcen.shapes[i].kinds[j]));
                fprintf(f, "\n");
            }
        }
    }
    fclose(f);
}
