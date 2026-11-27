#include "buster/compiler/c_direct.c"
static uint32_t fq(void* c, uint32_t q, const uint8_t* n, uint32_t l) { (void)c; (void)q; (void)n; (void)l; return 0; }
int main(int argc, char** argv)
{
    const char* dirs[16]; uint8_t sys[16]; uint32_t nd = 0; const char* macros[16]; uint32_t nm = 0;
    for (int i = 4; i + 1 < argc; i += 2)
    {
        if (strcmp(argv[i], "-I") == 0) { sys[nd] = 0; dirs[nd++] = argv[i + 1]; }
        else if (strcmp(argv[i], "-S") == 0) { sys[nd] = 1; dirs[nd++] = argv[i + 1]; }
        else if (strcmp(argv[i], "-D") == 0) { macros[nm++] = argv[i + 1]; }
    }
    const char* reason = NULL;
    CDirectRequest r = { 0 };
    r.input_path = argv[1]; r.predefines_path = argv[2]; r.output_path = argv[3];
    r.directories = dirs; r.directory_system = sys; r.directory_count = nd; r.angled_first = 0;
    for (uint32_t i = 0; i < nd; i++) { if (sys[i]) { r.angled_first = i; break; } }
    r.macros = macros; r.macro_count = nm; r.unwind_tables = true; r.pic = true;
    r.out_bail_reason = &reason; r.feature_query = fq;
    int st = c_direct_try_compile(&r);
    printf("status %d reason %s\n", st, reason ? reason : "-");
    return 0;
}
