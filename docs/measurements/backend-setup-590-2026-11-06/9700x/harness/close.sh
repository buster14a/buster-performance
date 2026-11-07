#!/bin/bash
# #590's closing qualification on benchpress (Ryzen 7 9700X): main's baked executable against the same link with
# BUSTER_BAKE=0 (the tables built when it runs), objects compared, small files against tcc, THP as the host has it
# (always) and disabled for the process and its children (PR_SET_THP_DISABLE, harness/nothp). Every build, compile and
# measurement takes the shared lock per run (exclusive.sh) and is pinned to CPU 2; rounds alternate the builds' order.
set -u
revision=$1
cd ~/buster-fast-bench/590-claude
export EXCLUSIVE_OWNER=claude-590 EXCLUSIVE_TITLE="#590 closing qualification: baked tables at main" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/590
ex=~/buster-fast-bench/exclusive.sh
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
work=close
log=$work/logs
obj=$work/objects
mkdir -p $log $obj $work/inputs
if [ ! -d $work/main ]; then
    git clone -q https://github.com/buster14a/buster $work/main && git -C $work/main checkout -q "$revision"
fi
git -C $work/main log -1 --format='%H %s' > $log/revision.txt
# The unbaked executable is the same link with BUSTER_BAKE=0 (build.sh reruns the post-link step alone), then the baked
# one is rebuilt; both by build.sh, as CI and the earlier records build them.
(cd $work/main && $ex env BUSTER_DEBUG_INFO=0 ./build.sh) > $log/build-baked-1.log 2>&1
(cd $work/main && $ex env BUSTER_DEBUG_INFO=0 BUSTER_BAKE=0 ./build.sh) > $log/build-unbaked.log 2>&1
cp $work/main/build/compiler $work/unbaked
(cd $work/main && $ex env BUSTER_DEBUG_INFO=0 ./build.sh) > $log/build-baked-2.log 2>&1
cp $work/main/build/compiler $work/baked
$ex $work/baked test-baked-tables > $log/test-baked-tables-baked.txt 2>&1
$ex $work/unbaked test-baked-tables > $log/test-baked-tables-unbaked.txt 2>&1
printf '' > $work/inputs/empty.c
printf 'int main(void) { return 0; }\n' > $work/inputs/tiny.c
cp harness/hello.c $work/inputs/hello.c
{
    date -u
    uname -a
    echo "THP enabled: $(cat /sys/kernel/mm/transparent_hugepage/enabled), defrag: $(cat /sys/kernel/mm/transparent_hugepage/defrag)"
    grep -m1 "model name" /proc/cpuinfo
    sha256sum /usr/bin/tcc "$sqlite/sqlite3.c" $work/baked $work/unbaked $work/inputs/*.c
    tcc -v
    clang --version | head -1
    size $work/baked $work/unbaked
} > $log/host.txt 2>&1
sed -n 's|^\([0-9][0-9]*\)$|c-testsuite/tests/single-exec/\1.c|p' $work/main/tests/c-testsuite/subset.txt > $log/subset.list
# Objects: both executables must write the same bytes.
$ex bash -c "d=0; n=0; while read f; do id=\$(basename \$f .c); $work/unbaked -c -o $obj/\$id.unbaked.o \$f 2>/dev/null; a=\$?; $work/baked -c -o $obj/\$id.baked.o \$f 2>/dev/null; b=\$?; n=\$((n+1)); { [ \$a = 0 ] && [ \$b = 0 ] && cmp -s $obj/\$id.unbaked.o $obj/\$id.baked.o; } || { d=\$((d+1)); echo \"differs: \$f (\$a/\$b)\"; }; done < <(cat $log/subset.list; ls $work/inputs/*.c); echo \"objects: \$n files (c-testsuite's subset, empty.c, tiny.c, hello.c), \$d differ\"" > $log/objects.txt 2>&1
for round in 1 2; do
    if [ $round = 1 ]; then order="unbaked baked"; else order="baked unbaked"; fi
    for input in empty tiny hello; do
        for cond in always disabled; do
            wrap=""
            [ $cond = disabled ] && wrap=harness/nothp
            for t in $order; do
                $ex taskset -c 2 $wrap $(pwd)/$work/$t measure-compile --runs 41 --reference /usr/bin/tcc -- -c $work/inputs/$input.c > $log/$input-$cond-$t-$round.txt 2>&1
            done
        done
    done
done
for cond in always disabled; do
    wrap=""
    [ $cond = disabled ] && wrap=harness/nothp
    $ex taskset -c 2 $wrap harness/best_of $obj/best_of.o 3 $(pwd)/$work/unbaked $(pwd)/$work/baked /usr/bin/tcc < $log/subset.list > $log/c-testsuite-$cond.txt 2>&1
done
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
for t in unbaked baked; do
    $ex taskset -c 2 $work/$t measure-compile --runs 11 --reference /usr/bin/tcc -- "${options[@]}" > $log/sqlite-$t.txt 2>&1
    $ex taskset -c 2 $work/$t "${options[@]}" -o $obj/sqlite3.$t.o >> $log/sqlite-$t.txt 2>&1
done
cmp $obj/sqlite3.unbaked.o $obj/sqlite3.baked.o > $log/sqlite-objects.txt 2>&1 && echo "sqlite3.o identical" >> $log/sqlite-objects.txt
echo done > $log/DONE
