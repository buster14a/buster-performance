set -u
head -1 /var/lib/buster-9700x/owner >> /home/david/buster-fast-bench/2618d-claude/holds.txt
unset CPATH C_INCLUDE_PATH
for t in base head; do
    C=/home/david/buster-fast-bench/2618d-claude/$t/build/compiler
    mkdir -p /home/david/buster-fast-bench/2618d-claude/obj-$t
    (cd /home/david/buster-fast-bench/2618d-claude/obj-$t && for f in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do $C --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o $f.o /home/david/buster-fast-bench/2618d-claude/inputs/lua-5.4.8/src/$f.c || exit 1; done) || exit 1
    $C --tier1 -fno-asynchronous-unwind-tables -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite -I/home/david/buster-fast-bench/2618d-claude/inputs -o /home/david/buster-fast-bench/2618d-claude/st-$t /home/david/buster-fast-bench/2618d-claude/inputs/speedtest1-unity.c -lm || exit 1
done
while read o perm; do
    for t in base head; do
        objs=""; for f in $perm; do objs="$objs /home/david/buster-fast-bench/2618d-claude/obj-$t/$f.o"; done
        (cd /home/david/buster-fast-bench/2618d-claude && cc -o lua-$t-o$o $objs -lm -ldl) || exit 1
    done
done < /home/david/buster-fast-bench/2618d-claude/orders.txt
