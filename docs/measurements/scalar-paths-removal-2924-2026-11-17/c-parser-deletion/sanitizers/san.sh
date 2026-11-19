#!/bin/bash
# MSan, ASan then TSan (vector host, Release) of C12b's head: test-parser, test-gnu, test-files, the parse of main.c;
# TSan: test-files and test-files --flat src, whose lanes parse.
cd /home/user/buster-c12b
L=~/.cache/claude-c7/c12b/san
mkdir -p $L/tmp
export TMPDIR=$L/tmp
: > $L/summary.txt
for san in memory address thread; do
    (BUSTER_SANITIZER=$san BUSTER_HOST_ARCH=vector nice -n 10 ./build.sh --config Release > $L/build-$san.log 2>&1); echo "build $san: $?" >> $L/summary.txt
    exe=$L/compiler-$san
    cp build/compiler $exe
    clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
    run() { local name=$1; shift; ( "$@" ) > $L/$san-$name.log 2>&1; echo "$san $name: $?" >> $L/summary.txt; }
    if [ $san != thread ]; then
        run parser $exe test-parser
        run gnu $exe test-gnu
        run parse-main $exe parse -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char --predefines build/predefines.h -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c
    fi
    run files $exe test-files
    run files-flat $exe test-files --flat src
    rm -f $exe
done
echo done >> $L/summary.txt
