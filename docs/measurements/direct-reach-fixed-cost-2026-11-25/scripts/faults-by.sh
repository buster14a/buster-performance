#!/bin/bash
# faults-by.sh NAME [UNIT]: one compile's page faults by the function that took them, and the process's floor (--version).
set -uo pipefail
here=$HOME/buster-fast-bench/direct-designs-np4nn5
n=$1; unit=${2:-add}
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
base=(--lanes 1 --predefines "$C/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc)
sys=(-isystem "$C/headers/usr/lib/clang/23/include" -isystem "$C/headers/usr/local/include" -isystem "$C/headers/usr/include")
tmp=$(mktemp -d /dev/shm/fb-np4nn5.XXXXXX)
printf 'int add(int a, int b) { return a + b; }\n' > "$tmp/add.c"
printf '#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n#include <stdint.h>\n#include <errno.h>\n#include <unistd.h>\nint main(int argc, char** argv) { char* p = malloc(16); strcpy(p, "x"); printf("%%s %%d\\n", p, argc); free(p); return errno; }\n' > "$tmp/six.c"
bin=$here/bin/compiler-$n
echo "=== --version floor"
for i in 1 2 3; do taskset -c 2 perf stat -x ';' --no-big-num -e cycles:u,cycles:k,page-faults,task-clock -- "$bin" --version 2>&1 >/dev/null | awk -F';' '{printf "%s=%s ", $3, $1}'; echo; done
echo "=== page faults by function ($unit)"
taskset -c 2 perf record -q -e page-faults -c 1 -o "$tmp/pf.data" -- "$bin" "${base[@]}" "${sys[@]}" -c "$tmp/$unit.c" -o "$tmp/out.o" > /dev/null 2>&1
perf report -i "$tmp/pf.data" --sort dso,sym --stdio 2>/dev/null | grep -v "^#" | grep -v "^$" | head -60
echo "=== kernel cycles by symbol ($unit, 300 compiles)"
cat > "$tmp/loop.sh" <<EOL
#!/bin/bash
for i in \$(seq 300); do "$bin" ${base[*]} ${sys[*]} -c "$tmp/$unit.c" -o "$tmp/out.o"; done
EOL
chmod +x "$tmp/loop.sh"
taskset -c 2 perf record -q -e cycles -c 20011 -o "$tmp/cy.data" -- "$tmp/loop.sh" > /dev/null 2>&1
perf report -i "$tmp/cy.data" --comm "compiler-$n" --sort sym --stdio 2>/dev/null | grep -v "^#" | grep -v "^$" | head -45
echo "=== strace -T"
strace -T -o "$tmp/st.txt" "$bin" "${base[@]}" "${sys[@]}" -c "$tmp/$unit.c" -o "$tmp/out.o"; awk '{print $NF, $1}' "$tmp/st.txt" | sed 's/(.*//' | tr -d '<>' | sort -rn | head -14; wc -l < "$tmp/st.txt"
rm -rf "$tmp"
