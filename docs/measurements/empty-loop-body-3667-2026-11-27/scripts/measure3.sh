#!/bin/bash
# #3667: variants of the change in one tree at main 6ac6c1d5 (vars/vN: c_direct*.c), each built and measured under the
# lock: v1 the preprocessor side alone, v2 with the statement compiler's call of an empty helper, v3 the whole.
cd ~/buster-fast-bench/3667-claude
export EXCLUSIVE_OWNER=3667-claude EXCLUSIVE_TITLE="Fail closed on empty for/while bodies in direct path" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3667
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
args=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sq" "$sq/sqlite3.c")
for v in ${VARIANTS:-v1 v2 v3}; do
  (cd var && git checkout -q -- src)
  cp vars/$v/*.c var/src/buster/compiler/
  (cd var && timeout 1200 ~/buster-fast-bench/exclusive.sh ./build.sh --config Release) > build3-$v.log 2>&1 || echo "build $v failed" >> status3.txt
  (cd var && timeout 600 ~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler measure-compile --runs 3 --instructions-baseline tools/ci/compile-instructions.txt -- "${args[@]}") > measure3-$v.log 2>&1
  nm -S --size-sort var/build/compiler | grep -E " (fast_cc_compile_func|fast_pp_drain|fast_pp_single_token)$" > sizes3-$v.txt
done
(cd var && git checkout -q -- src)
echo done >> status3.txt
