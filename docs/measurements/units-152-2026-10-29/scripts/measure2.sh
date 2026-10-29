#!/bin/bash
# #152's scaling measurement on the 9700X: the driver's units by --lanes 1, 2, 4 and 8, against make -j8 with clang -O0
# and with tcc, on Lua 5.4.8's interpreter, synth's shape (512 units of 200 functions) and musl 1.2.5's units, every
# process on CPUs 0 to 7 (one per core). Each corpus is one hold of the lock: time-runs runs every command once to
# warm up, then RUNS times in an order that rotates by run, and reports each one's median.
# Usage: measure2.sh COMPILER OUTDIR [lua|synth|musl]...
# measure2.sh is measure.sh with synth's unit names on one line (measure.sh's first synth run compiled unit_0.c alone).
set -u
C=$1
OUT=$2
shift 2
W=$HOME/buster-fast-bench/units-152-claude
RUNS=${RUNS:-7}
export TMPDIR=$W/tmp
mkdir -p "$OUT"
lock() { EXCLUSIVE_OWNER=claude-152 EXCLUSIVE_TITLE="solve #152 multi-file driver (scaling)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/152" ~/buster-fast-bench/exclusive.sh "$@"; }
P="taskset -c 0-7"

lua() {
    local d=$OUT/lua src=$W/inputs/lua-5.4.8/src
    rm -rf $d && mkdir -p $d && cd $d
    local names=$(cd $src && ls *.c | grep -v '^luac.c$' | sed 's/\.c$//')
    local files=$(for n in $names; do echo -n "$src/$n.c "; done)
    {
        echo "OBJECTS = $(for n in $names; do echo -n "$n.o "; done)"
        echo 'lua: $(OBJECTS)'
        echo '	$(CC) -o $@ $(OBJECTS) -lm -ldl'
        echo "%.o: $src/%.c"
        echo '	$(CC) $(CFLAGS) -c $< -o $@'
    } > Makefile
    local defines="-DLUA_COMPAT_5_3 -DLUA_USE_LINUX"
    local lists=()
    for lanes in 1 2 4 8; do lists+=(--list -c "$P $C --lanes $lanes -std=gnu99 -U__ELF__ $defines -o lua_buster $files -lm -ldl"); done
    lists+=(--list -c "rm -f *.o lua; $P make -s -j8 CC=clang 'CFLAGS=-O0 -std=gnu99 $defines'")
    lists+=(--list -c "rm -f *.o lua; $P make -s -j8 CC=tcc 'CFLAGS=$defines'")
    lists+=(--list -c "rm -f *.o lua; $P make -s -j1 CC=clang 'CFLAGS=-O0 -std=gnu99 $defines'")
    lists+=(--list -c "rm -f *.o lua; $P make -s -j1 CC=tcc 'CFLAGS=$defines'")
    echo "== lua: $(echo $names | wc -w) units"
    lock $C time-runs --executable /bin/sh --runs $RUNS "${lists[@]}" | grep -v "^run "
    echo 'print(6 * 7)' | ./lua_buster - && echo 'print(6 * 7)' | ./lua -
}

synth() {
    local d=$OUT/synth src=$W/explore/synth
    rm -rf $d && mkdir -p $d && cd $d
    # The names on one line: a newline in an sh -c script would end the compiler's command at the first unit.
    local files=$(ls $src/unit_*.c | tr '\n' ' ')
    {
        echo "OBJECTS = $(for f in $files; do n=$(basename $f .c); echo -n "$n.o "; done)"
        echo 'synth: $(OBJECTS)'
        echo '	$(CC) -o $@ $(OBJECTS)'
        echo "%.o: $src/%.c"
        echo '	$(CC) $(CFLAGS) -c $< -o $@'
    } > Makefile
    local lists=()
    for lanes in 1 2 4 8; do lists+=(--list -c "$P $C --lanes $lanes -o synth_buster $files"); done
    lists+=(--list -c "rm -f *.o synth; $P make -s -j8 CC=clang CFLAGS=-O0")
    lists+=(--list -c "rm -f *.o synth; $P make -s -j8 CC=tcc CFLAGS=")
    lists+=(--list -c "rm -f *.o synth; $P make -s -j1 CC=tcc CFLAGS=")
    echo "== synth: $(echo $files | wc -w) units, $(cat $files | wc -l) lines"
    lock $C time-runs --executable /bin/sh --runs $RUNS "${lists[@]}" | grep -v "^run "
    ./synth_buster && ./synth
}

musl() {
    local d=$OUT/musl m=$HOME/buster-fast-bench/refine-claude/inputs/musl
    rm -rf $d && mkdir -p $d/probe && cd $d
    local flags="-std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -I$m/arch/x86_64 -I$m/arch/generic -I$m/obj/src/internal -I$m/src/include -I$m/src/internal -I$m/obj/include -I$m/include"
    # musl's Makefile's selection: src/*/*.c but those an arch file replaces, and the arch's own .c files.
    local base=$(cd $m && ls src/*/*.c | sort)
    local replaced=$(cd $m && for a in src/*/x86_64/*.[csS]; do d2=$(dirname $(dirname $a)); n=$(basename $a); echo "$d2/${n%.*}.c"; done | sort -u)
    local selected=$( (comm -23 <(echo "$base") <(echo "$replaced"); cd $m && ls src/*/x86_64/*.c) | sort)
    # The units the driver compiles (one probe, outside the timing), so that every compiler compiles the same ones.
    (cd probe && lock $P $C --lanes 8 -c $flags $(for s in $selected; do echo -n "$m/$s "; done) 2> ../probe_errors.txt)
    local units=$(for s in $selected; do n=$(basename $s .c); [ -f probe/$n.o ] && echo -n "$m/$s "; done)
    echo "== musl: $(echo $selected | wc -w) units selected, $(echo $units | wc -w) that the driver compiles"
    grep -o "error: [^(:]*" probe_errors.txt | sort | uniq -c | sort -rn | head -8
    {
        echo -n "all:"; for u in $units; do echo -n " $(basename $u .c).o"; done; echo
        for u in $units; do echo "$(basename $u .c).o: $u"; echo '	$(CC) $(CFLAGS) -c $< -o $@'; done
    } > Makefile
    local lists=()
    for lanes in 1 2 4 8; do lists+=(--list -c "rm -f *.o; $P $C --lanes $lanes -c $flags $units"); done
    lists+=(--list -c "rm -f *.o; $P make -s -j8 CC=clang 'CFLAGS=-O0 $flags'")
    lists+=(--list -c "rm -f *.o; $P make -s -k -j8 CC=tcc 'CFLAGS=$flags' 2> /dev/null; true")
    lists+=(--list -c "rm -f *.o; $P make -s -k -j1 CC=tcc 'CFLAGS=$flags' 2> /dev/null; true")
    lock $C time-runs --executable /bin/sh --runs $RUNS "${lists[@]}" | grep -v "^run "
}

for corpus in "$@"; do $corpus; done
