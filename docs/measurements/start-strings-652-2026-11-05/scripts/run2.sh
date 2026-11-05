#!/bin/sh
# #652: BASE against HEAD, both linked at four placements of main_unit_checker.c's code (./build.sh shifts), BASE's
# placements again as the floor; each build and run under the lock. run2.sh BASE HEAD TAG.
set -e
d=~/buster-fast-bench/652-claude-5
mkdir -p $d && cd $d
export EXCLUSIVE_OWNER=claude-652 EXCLUSIVE_TITLE="652 remaining work" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/652
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
base=$1
head=$2
tag=$3
shifts="0 1088 2112 3136"
repo=~/buster-fast-bench/652-claude-3/main
[ -d base-$tag ] || (cd $repo && git worktree add -q --detach $d/base-$tag $base)
[ -d head-$tag ] || (cd $repo && git worktree add -q --detach $d/head-$tag $head)
(cd base-$tag && ~/buster-fast-bench/exclusive.sh taskset -c 0-7 ./build.sh shifts --config Release $d/shifts-base-$tag main_unit_checker.c $shifts) > shifts-base-$tag.log 2>&1
(cd head-$tag && ~/buster-fast-bench/exclusive.sh taskset -c 0-7 ./build.sh shifts --config Release $d/shifts-$tag main_unit_checker.c $shifts) > shifts-$tag.log 2>&1
H=$d/shifts-$tag/compiler-0
$H test-baked-tables > baked-$tag.txt 2>&1 || true
builds=""
for build in base:base-$tag head:$tag base-again:base-$tag; do
    for shift in $shifts; do builds="$builds --build ${build%%:*} $d/shifts-${build#*:}/compiler-$shift"; done
done
: > empty.c
printf 'int main(void){return 0;}\n' > tiny.c
printf '#include <stdio.h>\nint main(void){printf("%%d\\n", 1);return 0;}\n' > hello.c
~/buster-fast-bench/exclusive.sh taskset -c 2 $H time-runs --runs 30 --warmups 3 --copies 2 $builds --list -fsyntax-only empty.c --list -E -P empty.c -o /dev/null --list -c tiny.c -o /dev/null --list -c hello.c -o /dev/null > ab-$tag-small.txt 2>&1
q=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
~/buster-fast-bench/exclusive.sh taskset -c 2 $H time-runs --runs 4 --warmups 1 --copies 1 $builds --list -fsyntax-only -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$q $q/sqlite3.c > ab-$tag-sqlite.txt 2>&1
grep "stage 1 linker" shifts-base-$tag.log shifts-$tag.log > linkers-$tag.txt || true
sha256sum shifts-base-$tag/compiler-0 shifts-$tag/compiler-0 >> linkers-$tag.txt
echo done > run-$tag.done
