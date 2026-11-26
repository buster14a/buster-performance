# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# awk -v sets=2048 -f fixtures.awk > sets.c
BEGIN {
    for (i = 0; i < sets; i++) {
        printf "const int item%d __attribute__((used,section(\"set%05d\"))) = %d;\n", i, i, i
        printf "extern const int __start_set%05d[], __stop_set%05d[];\n", i, i
    }
    for (b = 0; b < 2; b++) {
        bound = b ? "stop" : "start"
        printf "const int *%ss[] = {\n", bound
        for (i = 0; i < sets; i++) printf "__%s_set%05d,\n", bound, i
        print "};"
    }
    printf "int main(void) { for(int i=0;i<%d;++i) if (*starts[i]!=i || stops[i]!=starts[i]+1) return 1; return 0; }\n", sets
}
