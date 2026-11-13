#!/bin/sh
# #1399: exact instruction counts by callgrind, in a cloud container (valgrind can't run AVX-512, so both trees are
# built at BUSTER_HOST_ARCH=x86-64). base is a worktree at main b7a95eed, head1 the branch at beb5de5d, head2 at
# b27b69d8; each compiler was copied out after its build. S is the frozen corpus's sqlite3.c directory.
L=$1; S=$2
unset CPATH C_INCLUDE_PATH
ARGS="-c -w --tier1 --lanes=1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$S $S/sqlite3.c"
for r in base head1 head2; do
    (ulimit -v 67108864; valgrind --tool=callgrind --callgrind-out-file=$L/cg.$r $L/compiler-$r-x64 $ARGS -o $L/sq-$r.o > $L/cg-$r.log 2>&1; echo "$r exit $?") &
done
wait
for r in base head1 head2; do callgrind_annotate --threshold=100 --auto=no $L/cg.$r > $L/ann-$r.txt; done
cmp $L/sq-base.o $L/sq-head1.o && cmp $L/sq-base.o $L/sq-head2.o && echo objects identical
