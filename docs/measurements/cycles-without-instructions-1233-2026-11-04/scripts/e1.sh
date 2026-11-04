#!/bin/bash
# #1233 E1: counters of main (754475d4, "M"), #1141's merge (4670b2eb, "H") and main again ("A", a byte-identical copy
# of M at another path of the same length), whole processes on CPU 2, the builds' order rotated by run, so that each
# build follows each other one as often. Two regimes for the tiny file: copies on the home file system (btrfs), as a
# build directory runs, and copies on /tmp (tmpfs), as the record's placements ran. Lua's 33 units from the home file
# system. Each process counts one group of at most five core events (the NMI watchdog holds the sixth counter), so no
# event multiplexes; one discarded warm-up per build before each group. Every process's line: regime, command, group,
# run, position, build, the build before it, its exit status, then perf stat's CSV.
# Usage: e1.sh tiny|lua   (each its own hold of the lock)
set -u
export LC_ALL=C
R=$HOME/buster-fast-bench/1233-claude; L=$R/logs; E=$R/e1; mkdir -p $E/out
what=$1
WORK=$E/out
: > $E/$what.csv
head -1 /var/lib/buster-9700x/owner >> $L/holds.txt
groups=(
    "cycles:u,instructions:u,de_no_dispatch_per_slot.no_ops_from_frontend:u,de_no_dispatch_per_slot.backend_stalls:u,ex_ret_brn_misp:u,page-faults:u,task-clock"
    "cycles:u,ic_tag_hit_miss.instruction_cache_miss:u,op_cache_hit_miss.op_cache_miss:u,bp_l1_tlb_miss_l2_tlb_hit:u,bp_l1_tlb_miss_l2_tlb_miss.all:u"
    "cycles:u,ex_ret_brn_tkn:u,bp_de_redirect:u,bp_l1_tlb_miss_l2_tlb_miss.coalesced_4k:u,ls_l1_d_tlb_miss.all:u"
)
builds=(M H A)
lua=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -w)
luafiles=$(ls $R/inputs/lua/*.c)
one() { # regime command group run position build previous executable args...
    local tag="$1,$2,$3,$4,$5,$6,$7"; local exe=$8 group=$3 build=$6; shift 8
    (cd "${WORK//@B@/$build}" && taskset -c 2 perf stat -x, -o $E/one.csv -e "${groups[$group]}" -- "$exe" "$@" > /dev/null 2> $E/err.txt)
    local status=$?
    grep -E '^[0-9<]' $E/one.csv | sed "s|^|$tag,$status,|" >> $E/$what.csv
}
series() { # regime command runs bindir args... (args may hold @B@, the build's name)
    local regime=$1 command=$2 runs=$3 bindir=$4; shift 4
    for g in 0 1 2; do
        for b in M H A; do one "$regime" "$command" $g 0 0 $b warmup $bindir/$b/compiler "${@//@B@/$b}"; done
        local prev=warmup
        for ((r = 1; r <= runs; r++)); do
            for k in 0 1 2; do
                b=${builds[$(((r + k) % 3))]}
                one "$regime" "$command" $g $r $k $b $prev $bindir/$b/compiler "${@//@B@/$b}"
                prev=$b
            done
        done
    done
}
if [ $what = tiny ]; then
    # tmpfs copies, made fresh in this hold, the same path length.
    T=/tmp/claude-1233; rm -rf $T; for b in M H A; do mkdir -p $T/$b; cp $R/bin/$b/compiler $T/$b/compiler; done
    sha256sum $T/*/compiler >> $L/receipts.txt
    series home tiny 100 $R/bin -c -o $E/out/tiny-@B@.o $R/inputs/tiny.c
    series tmpfs tiny 100 $T -c -o $E/out/tiny-tmpfs-@B@.o $R/inputs/tiny.c
    rm -rf $T
    # Primed: each measured process (M or H) right after an unmeasured primer of the same command: the same file
    # (self), a byte-identical copy of it at another path (copy: B is H's), or the other tree (other). Code at the
    # same virtual addresses keeps the branch predictors' state; the same file also keeps its physical pages warm.
    combos=("M M self" "A M copy" "H M other" "H H self" "B H copy" "M H other")
    for g in 0 1; do
        for c in "${combos[@]}"; do set -- $c; one primed tiny $g 0 0 $2 $1 $R/bin/$2/compiler -c -o $E/out/tiny-primed.o $R/inputs/tiny.c; done
        for ((r = 1; r <= 60; r++)); do
            for ((k = 0; k < 6; k++)); do
                set -- ${combos[$(((r + k) % 6))]}
                taskset -c 2 $R/bin/$1/compiler -c -o $E/out/tiny-primer.o $R/inputs/tiny.c > /dev/null 2>&1
                one primed tiny $g $r $k "$2-$3" $1 $R/bin/$2/compiler -c -o $E/out/tiny-primed.o $R/inputs/tiny.c
            done
        done
    done
    for b in M H A; do sha256sum $E/out/tiny-$b.o $E/out/tiny-tmpfs-$b.o; done >> $L/receipts.txt
else
    for b in M H A; do mkdir -p $E/out/lua-$b; done
    # -c of several files writes each object in the working directory: one per build.
    WORK=$E/out/lua-@B@
    series home lua 21 $R/bin --lanes 1 -c "${lua[@]}" $luafiles
    for f in $E/out/lua-M/*.o; do n=$(basename $f); cmp -s $f $E/out/lua-H/$n && cmp -s $f $E/out/lua-A/$n || echo "lua $n OBJECTS DIFFER"; done >> $L/receipts.txt
    echo "lua objects compared: $(ls $E/out/lua-M/*.o | wc -l)" >> $L/receipts.txt
fi
echo "e1 $what done" >> $L/receipts.txt
