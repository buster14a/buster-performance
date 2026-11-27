from pathlib import Path
p=Path('src/buster/compiler/c_preprocessor_impl.c')
s=p.read_text()
anchor=s.index('static void pp_scan_body_vector(const uint8_t* kinds')
s=s[:anchor]+'''static unsigned pp_bench_body_mode;
__attribute__((constructor)) static void pp_bench_body_init(void)
{
    char path[4096];
    const ssize_t n = readlink("/proc/self/exe",path,sizeof(path)-1);
    if (n > 0)
    {
        path[n] = 0;
        const char* m = strstr(path,"-bodymode");
        pp_bench_body_mode = m != NULL ? (unsigned)strtoul(m+9,NULL,10) : 0;
    }
}
'''+s[anchor:]
s=s.replace('if (end - begin == 1)','if (pp_bench_body_mode == 2 && end - begin == 1)',1)
pos=s.index('bool pastes;',s.index('static void pp_define(Preprocessor*'))
s=s[:pos]+s[pos:].replace('if (BUSTER_VECTOR_PATH(pp->vectorized))','if (pp_bench_body_mode != 1 && BUSTER_VECTOR_PATH(pp->vectorized))',1)
p.write_text(s)
