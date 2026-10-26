# The measurement's paths, flags and steps, sourced by the st-*.sh scripts (#136's speedtest1 measurement).
export LC_ALL=C
B=$HOME/buster-fast-bench/speedtest1-136-claude
Q=$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite
SRC=$B/src
C=$B/tree/build/compiler
M=$B/m
# The database and SQLite's temporary files go to tmpfs (/tmp on the 9700X).
RUNDIR=/tmp/speedtest1-136-claude
# SQLite's own performance procedure (test/speedtest.tcl at 3.53.2): its compile options, but for -Os and -g, and its
# speedtest1 options, but the database on tmpfs, timed by the wall clock rather than counted by cachegrind.
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
BUILDS=(ours direct clang tcc)
# How tcc's objects are linked: by tcc itself, unless the build step says otherwise in tcc-link.txt.
TCC_LINK=tcc
[ -e $M/tcc-link.txt ] && TCC_LINK=$(cat $M/tcc-link.txt)
compile() { # compiler source object
    case $1 in
        ours) taskset -c 2 $C -c $FLAGS -I$Q -o $3 $2 ;;
        clang) taskset -c 2 clang -O0 -c $FLAGS -I$Q -o $3 $2 ;;
        tcc) taskset -c 2 tcc -c $FLAGS -I$Q -o $3 $2 ;;
    esac
}
link() { # compiler executable objects...
    local c=$1 out=$2
    shift 2
    case $c:$TCC_LINK in
        ours:*|clang:*) taskset -c 2 cc -o $out "$@" -lm ;;
        tcc:tcc) taskset -c 2 tcc -o $out "$@" -lm ;;
        tcc:mold) taskset -c 2 cc -fuse-ld=mold -o $out "$@" /usr/lib/tcc/libtcc1.a -lm ;;
    esac
}
# The C driver's direct path takes one file: speedtest1-unity.c includes sqlite3.c, then speedtest1.c.
direct() { taskset -c 2 $C $FLAGS -I$Q -o $1 $SRC/speedtest1-unity.c -lm; }
# One run of a build from a fresh database: "wall_us user_s system_s" (bash's time), its output in $2.
run() { # build output
    rm -rf $RUNDIR
    mkdir -p $RUNDIR/db $RUNDIR/tmp
    local s e times
    TIMEFORMAT='%3U %3S'
    s=$EPOCHREALTIME
    { time (cd $RUNDIR/db && SQLITE_TMPDIR=$RUNDIR/tmp taskset -c 2 $M/st-$1 $OPTS "${@:3}" speedtest1.db > $2 2>&1) ; } 2> $2.time
    e=$EPOCHREALTIME
    echo "$(( ${e/./} - ${s/./} )) $(cat $2.time)"
}
