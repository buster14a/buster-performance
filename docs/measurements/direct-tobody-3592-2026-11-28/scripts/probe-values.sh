#!/bin/bash
# probe-values.sh COMPILER DIR: the probes that take the direct path and compute a value, compiled by default and with
# --no-direct and linked by clang with a driver that calls f over a range of arguments: the two outputs compared.
set -uo pipefail
B=$1; dir=$2; t=$(mktemp -d)
printf '#include <stdio.h>\nint f();\nint main(void) { long s = 0; for (int c = -300; c < 400; c += 7) s = s * 31 + f(c); printf("%%ld\\n", s); return 0; }\n' > $t/int.c
printf '#include <stdio.h>\nint f(const char *);\nint main(void) { printf("%%d\\n", f("Hello, World! \\xc3\\xa9\\xff")); return 0; }\n' > $t/str.c
printf '#include <stdio.h>\n#include <locale.h>\nint f(locale_t, int);\nint main(void) { locale_t l = newlocale(LC_ALL_MASK, "C", (locale_t)0); long s = 0; for (int c = -128; c < 256; c += 3) s = s * 31 + f(l, c); printf("%%ld\\n", s); return 0; }\n' > $t/loc.c
echo 'int g(int c) { return c * 3 - 7; }' > $t/g.c
for p in p13 p17 p18 p19 p21 p22 p23 p25 p26 p27 p28 p31 p32 p14; do
    main=$t/int.c; extra=; [ $p = p26 ] && main=$t/str.c; [ $p = p14 ] && main=$t/loc.c; [ $p = p21 ] && extra=$t/g.c
    "$B" --lanes 1 -std=gnu99 -O2 -c "$dir/$p.c" -o $t/d.o 2>/dev/null; "$B" --no-direct --lanes 1 -std=gnu99 -O2 -c "$dir/$p.c" -o $t/n.o 2>/dev/null
    clang -w $main $extra $t/d.o -o $t/d && clang -w $main $extra $t/n.o -o $t/n
    d=$($t/d); n=$($t/n)
    echo "$p $(readelf -p .comment $t/d.o | grep -o 'buster direct') direct=$d full=$n $([ "$d" = "$n" ] && echo same || echo DIFFERENT)"
done
rm -rf "$t"
