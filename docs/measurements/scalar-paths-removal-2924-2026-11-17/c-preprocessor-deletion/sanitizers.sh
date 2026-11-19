#!/bin/bash
# MSan then ASan (vector host, Release) of C12a's head: test-preprocessor, test-files, -E of main.c, test-parser's
# handoff (the keyword pass).
cd /home/user/buster-c12a
L=~/.cache/claude-c7/c12a/san
mkdir -p $L/tmp
export TMPDIR=$L/tmp
: > $L/summary.txt
for san in memory address; do
    (BUSTER_SANITIZER=$san BUSTER_HOST_ARCH=vector nice -n 10 ./build.sh --config Release > $L/build-$san.log 2>&1); echo "build $san: $?" >> $L/summary.txt
    exe=$L/compiler-$san
    cp build/compiler $exe
    clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
    run() { local name=$1; shift; ( "$@" ) > $L/$san-$name.log 2>&1; echo "$san $name: $?" >> $L/summary.txt; }
    run pp $exe test-preprocessor --jobs 2
    run files $exe test-files
    run e-main $exe -E -march=native -Isrc -fwrapv -funsigned-char -o $L/main-$san.i src/buster/compiler/main.c
    run parser $exe test-parser
    run fuzz $exe test-preprocessor-fuzz --std c23 --fuzz 300
    rm -f $L/main-$san.i
done
echo done >> $L/summary.txt
