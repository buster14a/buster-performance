#!/bin/bash
set -euo pipefail
input=${1:?pass an input directory}
mkdir -p "$input"
cp "$(dirname -- "$0")/tables.c" "$input/"
awk 'BEGIN {
    print "static inline int f0(int x) { return x; }"
    for (i=1; i<4000; ++i) printf "static inline int f%d(int x) { return f%d(x)+1; }\n", i, i-1
    print "int result(int x) { return f3999(x); }"
}' > "$input/chain4000.c"
for n in 1000 2000; do
    awk -v n="$n" 'BEGIN {
        for (i=0; i<n; ++i) {
            printf "int f%d(void){", i
            for (j=0; j<25; ++j) printf "int v%d=%d;", j, j
            printf "return v0"
            for (j=1; j<25; ++j) printf "+v%d", j
            print ";}"
        }
    }' > "$input/locals$n.c"
done
awk 'BEGIN {
    for (i=0; i<2000; ++i) printf "int f%d(void);\n", i
    printf "int (*f[])(void)={f0"
    for (i=1; i<2000; ++i) printf ",f%d", i
    print "};"
    print "int main(void){for(int i=0;i<2000;i++)if(f[i]() != 300)return 1;return 0;}"
}' > "$input/check-locals.c"
