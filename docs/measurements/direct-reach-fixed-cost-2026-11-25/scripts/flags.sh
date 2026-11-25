#!/bin/bash
# flags.sh COMPILER: which everyday options keep a one-function unit off the direct path. The path is the driver's
# decision (direct_eligible in c_checker_driver.c), the same on any host; the object's .comment says which path wrote it.
bin=$1
tmp=$(mktemp -d)
printf 'int add(int a, int b) { return a + b; }\n' > "$tmp/add.c"
for fl in "" "-O2" "-O0" "-Os" "-O3" "-g" "-Wall" "-Wextra" "-w" "-Wno-unused" "-Werror=implicit-function-declaration" "-MD -MF $tmp/add.d" "-fPIC" "-pipe" \
    "-fno-strict-aliasing" "-std=c89" "-ansi" "-std=gnu89" "-std=c99" "-std=gnu99" "-std=c11" "-std=gnu11" "-std=c17" "-std=gnu17" "-std=c23" "-pedantic" \
    "-fomit-frame-pointer" "-fno-omit-frame-pointer" "-fwrapv" "-funsigned-char" "-fno-common" "-fvisibility=hidden" "-DNDEBUG" \
    "-fno-asynchronous-unwind-tables" "-fstack-protector-strong" "-D_FORTIFY_SOURCE=2 -O2" "-fno-builtin" "-pthread" \
    "-ffunction-sections" "-fexcess-precision=standard" "-frounding-math" "-fno-plt" "-flto"; do
    rm -f "$tmp/add.o"
    "$bin" -c $fl "$tmp/add.c" -o "$tmp/add.o" 2> "$tmp/err"; s=$?
    if [ $s -ne 0 ]; then path="refused: $(head -1 "$tmp/err")"; elif grep -qa 'buster direct' "$tmp/add.o"; then path=direct; else path=full; fi
    printf '%-42s %s\n' "[$fl]" "$path"
done
rm -rf "$tmp"
