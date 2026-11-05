#!/bin/sh
# #652 part 3: main (483e5f70) against the branch's head (the parser's tables baked, RLIMIT_AS read once), both
# linked at four placements of main_unit_checker.c's code (./build.sh shifts), main's placements again as the
# floor; each build and run under the lock. Then a trivial program's start, dynamic against static, for the loader.
set -e
d=~/buster-fast-bench/652-claude-4
mkdir -p $d && cd $d
export EXCLUSIVE_OWNER=claude-652 EXCLUSIVE_TITLE="652 remaining work" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/652
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
head=${1:-0be486d6c4c02d64552ef0b021e76792ad13cfc8}
tag=${2:-v1}
shifts="0 1088 2112 3136"
repo=~/buster-fast-bench/652-claude-3/main
(cd $repo && git fetch -q origin main claude/fervent-meitner-mg6onh)
[ -d base ] || (cd $repo && git worktree add -q --detach $d/base 483e5f70d54ff8adccf011e773de4c04abd6489c)
[ -d head-$tag ] || (cd $repo && git worktree add -q --detach $d/head-$tag $head)
[ -x shifts-main/compiler-3136 ] || (cd base && ~/buster-fast-bench/exclusive.sh taskset -c 0-7 ./build.sh shifts --config Release $d/shifts-main main_unit_checker.c $shifts) > shifts-main.log 2>&1
(cd head-$tag && ~/buster-fast-bench/exclusive.sh taskset -c 0-7 ./build.sh shifts --config Release $d/shifts-$tag main_unit_checker.c $shifts) > shifts-$tag.log 2>&1
H=$d/shifts-$tag/compiler-0
$H test-baked-tables > baked-$tag.txt 2>&1 || true
builds=""
for build in main:main head:$tag main-again:main; do
    for shift in $shifts; do builds="$builds --build ${build%%:*} $d/shifts-${build#*:}/compiler-$shift"; done
done
: > empty.c
printf 'int main(void){return 0;}\n' > tiny.c
~/buster-fast-bench/exclusive.sh taskset -c 2 $H time-runs --runs 30 --warmups 3 --copies 2 $builds --list -fsyntax-only empty.c --list -E -P empty.c -o /dev/null --list -c tiny.c -o /dev/null > ab-$tag-small.txt 2>&1
q=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
~/buster-fast-bench/exclusive.sh taskset -c 2 $H time-runs --runs 4 --warmups 1 --copies 1 $builds --list -fsyntax-only -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$q $q/sqlite3.c > ab-$tag-sqlite.txt 2>&1
if [ ! -f loader.txt ]; then
  printf '#include <stdio.h>\nint main(void){puts("x");return 0;}\n' > hello.c
  clang -O2 -no-pie hello.c -o hello-dynamic && clang -O2 -static hello.c -o hello-static
  ~/buster-fast-bench/exclusive.sh sh -c "taskset -c 2 perf stat -r 1001 -e task-clock,page-faults,cycles:u,cycles:k ./hello-dynamic > /dev/null 2> loader-dynamic.txt; taskset -c 2 perf stat -r 1001 -e task-clock,page-faults,cycles:u,cycles:k ./hello-static > /dev/null 2> loader-static.txt; taskset -c 2 perf stat -r 501 -e task-clock,page-faults,cycles:u,cycles:k $H -fsyntax-only empty.c 2> loader-compiler.txt"
  cat loader-dynamic.txt loader-static.txt loader-compiler.txt > loader.txt
fi
echo done > run-$tag.done
