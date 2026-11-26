#!/bin/bash
# bp-place.sh: the merge (m16, e53577ce1) and the squashed head (p8, c4085ccd2) at four placements of the checker's code
# (BUSTER_CHECKER_OFFSET 0, 1024, 2048, 3072 through BUSTER_BUILD_DEFINES, every build alike), each build under its own
# hold; then one hold: the eight in rotation, 3 rounds of 5, perf stat cycles and instructions.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
cd "$D/work" || exit 1
for off in 0 1024 2048 3072; do
  for arm in m16:e53577ce1 p8:c4085ccd2; do
    name=${arm%%:*}; sha=${arm##*:}
    git checkout -q -- . 2>/dev/null; git checkout -q --detach "$sha" || exit 1
    EXCLUSIVE_TITLE="#3577 direct path: build $name at offset $off" BUSTER_HOST_ARCH=znver5 BUSTER_BUILD_DEFINES=-DBUSTER_CHECKER_OFFSET=$off ~/buster-fast-bench/exclusive.sh timeout -k 5 590 ./build.sh --config Release > "$D/build-$name-o$off.log" 2>&1
    st=$?; echo "build $name o$off status $st $(date -u +%H:%M:%S)"; [ $st = 0 ] || exit 1
    cp build/compiler "$D/bins/compiler-$name-o$off"; chmod +x "$D/bins/compiler-$name-o$off"
  done
done
cd "$D" || exit 1
EXCLUSIVE_TITLE="#3577 direct path: measure placements" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1
  flags=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /tmp/3577-claude-c.o)
  for r in 1 2 3; do
    for off in 0 1024 2048 3072; do
      for t in m16 p8; do
        echo "== $r $t o$off $(taskset -c 2 perf stat -r 5 -e cycles:u,instructions:u ./bins/compiler-$t-o$off "${flags[@]}" 2>&1 | grep -E "cycles|instructions" | awk "{print \$1}" | tr "\n" " ")"
      done
    done
  done
' x "$sqlite" > place.txt
cat place.txt
awk '$1 == "==" && $2 > 1 { c[$3" "$4] += $5; n[$3" "$4]++ } END { for (k in c) printf "%s %.2f M\n", k, c[k] / n[k] / 1e6 }' place.txt | sort
awk '$1 == "==" && $2 > 1 { c[$3] += $5; n[$3]++ } END { for (k in c) printf "arm %s mean over placements (rounds 2-3): %.2f M cycles\n", k, c[k] / n[k] / 1e6 }' place.txt
rm -f bins/compiler-m16-o* bins/compiler-p8-o*
df -h ~ | tail -1
echo DONE
