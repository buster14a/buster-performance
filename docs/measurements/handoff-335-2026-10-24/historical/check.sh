set -e
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
musl=$corpus/libc/musl
system=(-march=znver5 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
muslf=(-march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -pipe -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
c=./build/compiler
$c test-parser --clang "${system[@]}" "$corpus/sqlite/sqlite3.c" 2>&1 | tail -4
for input in small headers sqlite; do
  case $input in small) a=("${muslf[@]}" "$musl/src/stdio/vfprintf.c");; headers) a=("${system[@]}" ../inputs/headers.c);; sqlite) a=("${system[@]}" "$corpus/sqlite/sqlite3.c");; esac
  for d in "parse -fsyntax-only" "-fsyntax-only"; do
    s1=0; s2=0
    $c $d "${a[@]}" > /tmp/h335.off 2>&1 || s1=$?
    $c $d --parser-keywords "${a[@]}" > /tmp/h335.on 2>&1 || s2=$?
    echo "$input [$d]: status $s1/$s2, $(wc -c < /tmp/h335.off) bytes, $(cmp -s /tmp/h335.off /tmp/h335.on && echo identical || echo DIFFERENT)"
  done
done
