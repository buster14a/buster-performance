#!/usr/bin/env bash
# #426 at 06e6538b (main merged) on the 9700X against main at 4f4a0bfa, after rows4's queue: the build's wall time, CPU
# time, largest process's peak RSS and the executable's sizes, with debug info (build.sh's default) and without it (the
# 9700X job's); then the default compile's instructions, cycles and wall time, and -g's overhead. Each step under the
# shared lock on its own; ab takes the lock for each of its runs itself.
cd "$(dirname "$0")" || exit 1
root="$(pwd)"
while ! grep -q "== done" ../rows4/queue.log 2> /dev/null; do sleep 30; done
export EXCLUSIVE_OWNER=claude-linker-80 EXCLUSIVE_TITLE="#395 DWARF from compiled code (part 1), head 06e6538b" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/426
export TMPDIR="$root/tmp"
step()
{
    local name="$1"
    shift
    echo "== $name $(date +%T)"
    ~/buster-fast-bench/exclusive.sh "$@" > "$root/$name.log" 2>&1
    echo "== $name status $? $(date +%T)"
}
# One build of a tree: build.sh under a parent that reports its wall time and its children's CPU time and largest
# resident set (getrusage(RUSAGE_CHILDREN)), then the executable's sizes.
cat > "$root/timed-build.py" <<'PY'
import os, resource, subprocess, sys, time
start = time.monotonic()
status = subprocess.run(["./build.sh"], env=dict(os.environ, LC_NUMERIC="C")).returncode
wall = time.monotonic() - start
usage = resource.getrusage(resource.RUSAGE_CHILDREN)
print("timed-build: status %d, wall %.2f s, user %.2f s, system %.2f s, cpu %.2f s, largest process %d KB" %
      (status, wall, usage.ru_utime, usage.ru_stime, usage.ru_utime + usage.ru_stime, usage.ru_maxrss))
sys.exit(status)
PY
build()
{
    local name="$1" tree="$2" debug="$3"
    (cd "$root/$tree" && step "$name" env BUSTER_DEBUG_INFO="$debug" python3 "$root/timed-build.py")
    (cd "$root/$tree" && size build/compiler && stat -c "%s bytes %n" build/compiler) >> "$root/$name.log" 2>&1
}
build build-debug-main main 1
build build-debug-part1 part1 1
for i in 1 2 3; do
    build build-$i-main main 0
    build build-$i-part1 part1 0
done
part1/build/compiler benchmark-check-debug --print "$TMPDIR/program.c"
cmp "$TMPDIR/program.c" "$root/../rows3/tmp/program.c" && echo "== program: the same as rows3's"
step perfstat bash -c 'for i in 1 2 3; do for t in main part1; do echo "== $t round $i"; perf stat -x, -e instructions:u,cycles:u,instructions:k,cycles:k -r 21 taskset -c 2 $t/build/compiler -o tmp/program-$t tmp/program.c 2>&1 >/dev/null | cut -d, -f1,3; done; done; cmp tmp/program-main tmp/program-part1 && echo "the same executable"'
echo "== ab-default $(date +%T)"
part1/build/compiler ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$root/main" "$root/part1" -- time-runs --runs 21 --list -o "$TMPDIR/program" "$TMPDIR/program.c" > "$root/ab-default.log" 2>&1
echo "== ab-default status $? $(date +%T)"
echo "== ab-debug $(date +%T)"
part1/build/compiler ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$root/part1" -- time-runs --runs 21 --list -o "$TMPDIR/program" "$TMPDIR/program.c" --list -g -o "$TMPDIR/program-g" "$TMPDIR/program.c" > "$root/ab-debug.log" 2>&1
echo "== ab-debug status $? $(date +%T)"
echo "== done $(date +%T)"
