#!/bin/bash
# #3667: instruction samples of 400 compiles of variant v9, the cold path's share by symbol. Each run under the lock.
cd ~/buster-fast-bench/3667-claude
export EXCLUSIVE_OWNER=3667-claude EXCLUSIVE_TITLE="Fail closed on empty for/while bodies in direct path" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3667
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
(cd var && git checkout -q -- src)
cp vars/${VARIANT:-v9}/*.c var/src/buster/compiler/
(cd var && timeout 1200 ~/buster-fast-bench/exclusive.sh ./build.sh --config Release) > build4.log 2>&1
cat > var/loop4.sh <<EOS
#!/bin/bash
for i in \$(seq 400); do ./build/compiler -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sq $sq/sqlite3.c -o /tmp/3667-claude-p.o; done
EOS
chmod +x var/loop4.sh
(cd var && timeout 600 ~/buster-fast-bench/exclusive.sh perf record -q -e instructions:u -c 4001 -o ../perf4.data -- taskset -c 2 ./loop4.sh) > perf4.log 2>&1
perf report -i perf4.data --stdio --sort symbol 2>/dev/null | grep -E "^# (Samples|Event)|fast_cc_raw|fast_cc_empty|fast_cc_placed|fast_scan_ident|fast_skip_hspace|fast_ident_lookup|fast_ident_intern|fast_cc_list|memcmp|fast_load64" > report4.txt
(cd var && git checkout -q -- src)
echo done >> status4.txt
