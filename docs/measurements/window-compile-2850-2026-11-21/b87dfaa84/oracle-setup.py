from pathlib import Path
p=Path(__file__).resolve().parent.parent/'member-chain-lowering-proof/src/buster/compiler/c_check_program_emit.c';s=p.read_text();i=s.index('static bool check_program_emit_code_half(')
s=s[:i]+'''// Independent witness at Tier 0's input. No producer-side expected byte or per-chain counter participates.
static void check_chain_witness_typed(const Tier0Function* fn)
{
    const char* path = getenv("BUSTER_CHAIN_TYPED_FILE");
    if (path == NULL) return;
    FILE* out = fopen(path, "ab");
    if (out == NULL || fwrite(&fn->count, sizeof(fn->count), 1, out) != 1) abort();
    if (fwrite(fn->kinds,1,fn->count,out)!=fn->count || fwrite(fn->classes,1,fn->count,out)!=fn->count ||
        fwrite(fn->values,sizeof(*fn->values),fn->count,out)!=fn->count) abort();
    fclose(out);
}

'''+s[i:]
s=s.replace('                Tier0Code compiled = naked != 0 ?', '                if (naked == 0) check_chain_witness_typed(source);\n                Tier0Code compiled = naked != 0 ?')
s=s.replace('    const Tier0Code machine = tier0_compile(&function,scratch);','    check_chain_witness_typed(&function);\n    const Tier0Code machine = tier0_compile(&function,scratch);');p.write_text(s)
