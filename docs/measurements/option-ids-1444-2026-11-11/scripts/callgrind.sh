#!/bin/sh
# #1444 item 5: Callgrind's instructions and string-function calls of the base, the option IDs alone and the head, on the
# cloud container. Valgrind runs no AVX-512 instruction, and the head's ID sets compile to AVX-512 compares on an
# AVX-512 host, so each tree is built for the baseline ISA (BUSTER_HOST_ARCH=x86-64), whose executables, unbaked, also
# build their tables at the start (about 7.4 M instructions more than the 9700X's).
#   BASE=... IDS=... HEAD=... callgrind.sh   (the three executables; run in a directory with empty.c, tiny.c and strcalls.py)
set -e
for case in empty tiny sqlite native; do
    case $case in
        empty) set -- -fsyntax-only empty.c ;;
        tiny) set -- -c tiny.c -o /dev/null ;;
        sqlite) set -- -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I/tmp tiny.c -o /dev/null ;;
        native) set -- -fsyntax-only -march=native -fwrapv -funsigned-char empty.c ;;
    esac
    for build in base:$BASE head:$IDS head2:$HEAD; do
        valgrind --tool=callgrind --callgrind-out-file=${build%%:*}-$case.out ${build#*:} "$@" > /dev/null 2> ${build%%:*}-$case.err
        # Each string function's calls by caller, through its IFUNC stub (strcalls.py).
        python3 strcalls.py ${build%%:*}-$case.out > ${build%%:*}-$case.calls
    done
done
