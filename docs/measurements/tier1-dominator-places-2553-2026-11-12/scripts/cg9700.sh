#!/bin/bash
# cg9700.sh OUT REV:COMPILER...: callgrind's exact counts of the 9700X's timed executables (Lua's link order 0 and
# speedtest1's shift 0, in /home/user/w2553/r9/exe) through the 9700X's own loader and C library (r9/glibc), each
# instruction tagged by the origin tags that COMPILER (the revision's tagged build, whose objects' .text equal the 9700X's)
# writes while compiling the same programs. Each run's output is checked: speedtest1's hash and Lua's scripts' outputs.
set -u
out=$(readlink -f "$1"); shift
R=/home/user/w2553/r9; I=/home/user/w2553/inputs; G=$R/glibc
opts="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
mkdir -p "$out"
src=(); for s in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do src+=("$I/lua-5.4.8/src/$s.c"); done
jobs=()
for pair in "$@"; do
    r=${pair%%:*}; c=${pair#*:}
    mkdir -p "$out/$r"
    rm -f "$out/$r/st.kinds" "$out/$r/lua.kinds"
    (cd $I && BUSTER_TIER1_KINDS=$out/$r/st.kinds "$c" --tier1 -fno-asynchronous-unwind-tables -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$I -c -o /dev/null $R/st-unity.c > "$out/$r/st-tags.txt" 2>&1)
    BUSTER_TIER1_KINDS=$out/$r/lua.kinds "$c" --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o /dev/null "${src[@]}" -lm -ldl > "$out/$r/lua-tags.txt" 2>&1
    objdump -d --no-show-raw-insn $R/exe/st-$r-s0 > "$out/$r/st.dis"; objdump -d --no-show-raw-insn $R/exe/lua-$r-o0 > "$out/$r/lua.dis"
    for p in st calls tables strings arithmetic closures; do jobs+=("$r $p"); done
done
one()
{
    local r=$1 p=$2 vg=(valgrind --tool=callgrind --dump-instr=yes "--callgrind-out-file=$out/$1/$2.cg" $G/ld-linux-x86-64.so.2 --library-path $G)
    if [ $p = st ]; then
        local d; d=$(mktemp -d /dev/shm/st.XXXXXX); mkdir -p $d/db $d/tmp
        (cd $d/db && SQLITE_TMPDIR=$d/tmp $G/ld-linux-x86-64.so.2 --library-path $G $R/exe/st-$r-s0 $opts --verify v.db 2>&1 | grep 'Verification Hash' > $out/$r/st.verify)
        rm -rf $d/db/* $d/tmp/*
        (cd $d/db && SQLITE_TMPDIR=$d/tmp "${vg[@]}" $R/exe/st-$r-s0 $opts s.db > $out/$r/st.out 2> $out/$r/st.err); rm -rf $d
        /home/user/w2553/bin/gap count $out/$r/st.dis $out/$r/st.cg $R/exe/st-$r-s0 0x0 $out/$r/st.kinds > $out/$r/st.tsv 2> $out/$r/st.gaperr
    else
        (cd $I/scripts && "${vg[@]}" $R/exe/lua-$r-o0 $p.lua > $out/$r/$p.out 2> $out/$r/$p.err)
        cmp -s $out/$r/$p.out /home/user/w2553/r9/ref/$p-clang0.out && echo same > $out/$r/$p.check || echo DIFFERS > $out/$r/$p.check
        /home/user/w2553/bin/gap count $out/$r/lua.dis $out/$r/$p.cg $R/exe/lua-$r-o0 0x0 $out/$r/lua.kinds > $out/$r/$p.tsv 2> $out/$r/$p.gaperr
    fi
}
export -f one; export out R I G opts
printf '%s\n' "${jobs[@]}" | xargs -P ${JOBS:-4} -L 1 bash -c 'one $0 $1'
for pair in "$@"; do
    r=${pair%%:*}
    {
        cat $out/$r/st.verify; cat $out/$r/*.check | sort | uniq -c
        for f in st calls tables strings arithmetic closures; do
            awk -F'\t' -v f=$f '$1 !~ /^#/ { k[$2]+=$4; if ($1=="luaV_execute"||$1=="sqlite3VdbeExec") h[$2]+=$4; t+=$4 } $1=="#check" {c=c" "$2"="$3} END { printf "%s total %d", f, t; n=split("e h x T t U u",L," "); for(i=1;i<=n;i++) printf " %s=%d", L[i], k[L[i]]; printf " | hot"; for(i=1;i<=n;i++) printf " %s=%d", L[i], h[L[i]]; printf "\n" }' $out/$r/$f.tsv
        done
    } > $out/$r/summary.txt
done
