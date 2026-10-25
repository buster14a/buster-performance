#!/bin/bash
# #395's foreign DWARF on the 9700X: SQLite's shell compiled with -g (zlib-compressed debug sections, GNU as's default)
# and with -g -gz=none, linked as a PIE by link-foreign of two trees (vector path, exact path, and -S), 21 interleaved
# runs each, pinned to CPU 2: the link's, the conversion's and its debug phase's medians from --time; then lld and mold
# on one thread and on all of them (11 runs, wall time from spawn to exit).
old=$1
new=$2
work=$3
mkdir -p $work && cd $work || exit 1
f() { gcc -print-file-name=$1; }
gccdir=$(dirname $(f crtbeginS.o))
libdir=$(dirname $(f libc.so))
line() { echo "$(f Scrt1.o) $(f crti.o) $(f crtbeginS.o) shell$1.o sqlite3$1.o -L$gccdir -L$libdir -lm -lgcc --as-needed -lgcc_s --no-as-needed -lc -lgcc --as-needed -lgcc_s --no-as-needed $(f crtendS.o) $(f crtn.o)"; }
median() { sort -g | awk '{a[NR] = $1} END {printf "%.3f", a[int((NR + 1) / 2)]}'; }
for input in "" _u; do
    args=($(line $input))
    for tree in old new; do for way in vector scalar strip; do rm -f t_${tree}_${way}${input}_*; done; done
    for ((i = 0; i < 21; i++)); do
        for tree in old new; do
            compiler=$old; [ $tree = new ] && compiler=$new
            for way in vector scalar strip; do
                extra=(); [ $way = scalar ] && extra=(--scalar); [ $way = strip ] && extra=(-S)
                taskset -c 2 $compiler link-foreign -pie --time "${extra[@]}" -o out "${args[@]}" 2> time.txt || { cat time.txt; exit 1; }
                awk '$1 == "link-foreign:" {print $2}' time.txt >> t_${tree}_${way}${input}_link
                awk '$1 == "convert" {print $2}' time.txt >> t_${tree}_${way}${input}_convert
                awk '$1 == "convert" {for (i = 1; i < NF; i++) if ($i == "debug") print $(i + 1)}' time.txt >> t_${tree}_${way}${input}_debug
            done
        done
    done
    ./out :memory: "select 1;" > /dev/null || exit 1
    for tree in old new; do for way in vector scalar strip; do
        echo "inputs${input:-_compressed} $tree $way: link $(median < t_${tree}_${way}${input}_link) ms, convert $(median < t_${tree}_${way}${input}_convert) ms, debug $(median < t_${tree}_${way}${input}_debug) ms"
    done; done
    ldopts=(-pie -dynamic-linker /lib64/ld-linux-x86-64.so.2 --hash-style=gnu --build-id --eh-frame-hdr -z now -z relro)
    for linker in lld1 lld8 mold1 mold8; do
        rm -f w_$linker
        for ((i = 0; i < 11; i++)); do
            s=$(date +%s%N)
            case $linker in
                lld1) taskset -c 2 ld.lld --threads=1 "${ldopts[@]}" -o out_l "${args[@]}" ;;
                lld8) ld.lld --threads=8 "${ldopts[@]}" -o out_l "${args[@]}" ;;
                mold1) taskset -c 2 mold --thread-count=1 "${ldopts[@]}" -o out_l "${args[@]}" ;;
                mold8) mold --thread-count=8 "${ldopts[@]}" -o out_l "${args[@]}" ;;
            esac
            e=$(date +%s%N)
            echo "scale=3; ($e - $s) / 1000000" | bc >> w_$linker 2> /dev/null || awk -v a=$s -v b=$e 'BEGIN {printf "%.3f\n", (b - a) / 1000000}' >> w_$linker
        done
        echo "inputs${input:-_compressed} $linker: $(median < w_$linker) ms"
    done
done
