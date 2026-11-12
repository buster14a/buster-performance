#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# lists.sh: writes procbench's lists, lists/NAME.list, one per measurement (run.sh NAME ROUNDS runs one). No run: it
# only writes text, after prepare.sh has made the unit lists and the library's objects it names. A list is one
# placement of the work: CPU 2 alone (the one-core figures) or CPUs 0 to 7 (one per core), never both, since blocks of
# one-lane and eight-lane runs bias their neighbours.
set -u
cd "$(dirname "$0")"
. ./common.sh
mkdir -p lists
E="events=cycles-u+cycles-k+instructions-u+instructions-k"
one="cpus=2,$E"
all="cpus=0-7,$E"

# 1. -g on a compile: sqlite3.c with the compile_time step's options.
{
    echo "b-c|$one|$c -c $ct $sqlite/sqlite3.c -o $t/o/b-c.o"
    echo "b-cg|$one|$c -c -g $ct $sqlite/sqlite3.c -o $t/o/b-cg.o"
    echo "b-c-x|$one,var=BUSTER_EXIT_HELPER=0|$c -c $ct $sqlite/sqlite3.c -o $t/o/b-c-x.o"
    echo "b-cg-x|$one,var=BUSTER_EXIT_HELPER=0|$c -c -g $ct $sqlite/sqlite3.c -o $t/o/b-cg-x.o"
    echo "b-c-md|$one|$c -c -MD -MF $t/o/b-c-md.d $ct $sqlite/sqlite3.c -o $t/o/b-c-md.o"
    echo "b-syntax|$one|$c -fsyntax-only $ct $sqlite/sqlite3.c"
    echo "tcc-c|$one|/usr/bin/tcc -c $ct $sqlite/sqlite3.c -o $t/o/tcc-c.o"
    echo "tcc-cg|$one|/usr/bin/tcc -c -g $ct $sqlite/sqlite3.c -o $t/o/tcc-cg.o"
    echo "tcc-cgdwarf|$one|/usr/bin/tcc -c -gdwarf $ct $sqlite/sqlite3.c -o $t/o/tcc-cgdwarf.o"
} > lists/sqlite-g.list
{
    echo "b8-c|$all|$c -c $ct $sqlite/sqlite3.c -o $t/o/b8-c.o"
    echo "b8-cg|$all|$c -c -g $ct $sqlite/sqlite3.c -o $t/o/b8-cg.o"
} > lists/sqlite-g-8.list
{
    echo "clang-c|$one|/usr/bin/clang -O0 -c $ct $sqlite/sqlite3.c -o $t/o/clang-c.o"
    echo "clang-cg|$one|/usr/bin/clang -O0 -g -c $ct $sqlite/sqlite3.c -o $t/o/clang-cg.o"
    echo "gcc-c|$one|/usr/bin/gcc -O0 -c $ct $sqlite/sqlite3.c -o $t/o/gcc-c.o"
    echo "gcc-cg|$one|/usr/bin/gcc -O0 -g -c $ct $sqlite/sqlite3.c -o $t/o/gcc-cg.o"
} > lists/sqlite-g-refs.list

# 1. -g on a compile: musl's units as one command (the one-core record's 1,336), and the units tcc takes.
{
    echo "m-c|$one,dir=$t/m/c|$c $mo --lanes 1 -c @$t/lists/units1336.txt"
    echo "m-cg|$one,dir=$t/m/cg|$c $mo --lanes 1 -c -g @$t/lists/units1336.txt"
    echo "m-c-x|$one,dir=$t/m/cx,var=BUSTER_EXIT_HELPER=0|$c $mo --lanes 1 -c @$t/lists/units1336.txt"
    echo "mt-c|$one,dir=$t/m/tc|$c $mo --lanes 1 -c @$t/lists/units-tcc.txt"
    echo "mt-cg|$one,dir=$t/m/tcg|$c $mo --lanes 1 -c -g @$t/lists/units-tcc.txt"
    echo "tcc-c|$one,dir=$t/m/tcc|/usr/bin/tcc $mo -c @$t/lists/units-tcc.txt"
    echo "tcc-cg|$one,dir=$t/m/tccg|/usr/bin/tcc $mo -g -c @$t/lists/units-tcc.txt"
    echo "tcc-cgdwarf|$one,dir=$t/m/tccd|/usr/bin/tcc $mo -gdwarf -c @$t/lists/units-tcc.txt"
} > lists/musl-g.list
{
    echo "m8-c|$all,dir=$t/m/c8|$c $mo --lanes 8 -c @$t/lists/units1336.txt"
    echo "m8-cg|$all,dir=$t/m/cg8|$c $mo --lanes 8 -c -g @$t/lists/units1336.txt"
} > lists/musl-g-8.list
{
    echo "clang-c|$one,dir=$t/m/kc|/usr/bin/clang -O0 $mo -c @$t/lists/units1336.txt"
    echo "clang-cg|$one,dir=$t/m/kcg|/usr/bin/clang -O0 -g $mo -c @$t/lists/units1336.txt"
} > lists/musl-g-refs.list

# 2 and 3. SQLite's shell, as test-sqlite builds it: one command, and a build's steps (each source's -c, then the
# link of the objects), the steps alone and in turn.
shell()
{
    local options=$1 d=$2 p=$3
    for g in "" -g; do
        echo "${p}s-dyn$g|$options,dir=$d|$c $g $sh -o s-dyn$g $sqlite/shell.c $sqlite/sqlite3.c -lm"
        echo "${p}s-static$g|$options,dir=$d|$c -static $g $sh -o s-static$g $sqlite/shell.c $sqlite/sqlite3.c /usr/lib/libm.a"
        echo "${p}c-shell$g|$options,dir=$d|$c -c $g $sh $sqlite/shell.c -o shell$g.o"
        echo "${p}c-sq$g|$options,dir=$d|$c -c $g $sh $sqlite/sqlite3.c -o sq$g.o"
        echo "${p}l-dyn$g|$options,dir=$d|$c $g shell$g.o sq$g.o -lm -o l-dyn$g"
        echo "${p}l-static$g|$options,dir=$d|$c -static $g shell$g.o sq$g.o -lm -o l-static$g"
        echo "${p}q-dyn$g|$options,dir=$d|$c -c $g $sh $sqlite/shell.c -o shell$g.o ;; $c -c $g $sh $sqlite/sqlite3.c -o sq$g.o ;; $c $g shell$g.o sq$g.o -lm -o q-dyn$g"
        echo "${p}q-static$g|$options,dir=$d|$c -c $g $sh $sqlite/shell.c -o shell$g.o ;; $c -c $g $sh $sqlite/sqlite3.c -o sq$g.o ;; $c -static $g shell$g.o sq$g.o -lm -o q-static$g"
    done
    echo "${p}s-dyn-md|$options,dir=$d|$c $sh -MD -o s-dyn-md $sqlite/shell.c $sqlite/sqlite3.c -lm"
}
{
    shell "$one" $t/x ""
    # tcc's steps: its own link of the shell fails on this system (results/prepare/tcc-link.txt).
    for g in "" -g; do
        echo "tcc-c-shell$g|$one,dir=$t/x|/usr/bin/tcc -c $g $sh $sqlite/shell.c -o tcc-shell$g.o"
        echo "tcc-c-sq$g|$one,dir=$t/x|/usr/bin/tcc -c $g $sh $sqlite/sqlite3.c -o tcc-sq$g.o"
    done
} > lists/shell-1.list
{
    shell "$all" $t/x8 "8"
    # Both compiles at once, as make -j runs them, then the link.
    for g in "" -g; do
        echo "8p-dyn$g|$all,dir=$t/x8|/bin/bash $here/par.sh buster dyn $g"
        echo "8p-static$g|$all,dir=$t/x8|/bin/bash $here/par.sh buster static $g"
    done
} > lists/shell-8.list
{
    for g in "" -g; do
        echo "clang-dyn$g|$one,dir=$t/xk|/usr/bin/clang -O0 $g $sh -o clang-dyn$g $sqlite/shell.c $sqlite/sqlite3.c -lm"
        echo "clang-lld-dyn$g|$one,dir=$t/xk|/usr/bin/clang -O0 -fuse-ld=lld $g $sh -o clang-lld-dyn$g $sqlite/shell.c $sqlite/sqlite3.c -lm"
        echo "kc-shell$g|$one,dir=$t/xk|/usr/bin/clang -O0 -c $g $sh $sqlite/shell.c -o k-shell$g.o"
        echo "kc-sq$g|$one,dir=$t/xk|/usr/bin/clang -O0 -c $g $sh $sqlite/sqlite3.c -o k-sq$g.o"
    done
    echo "clang-mold-dyn-g|$one,dir=$t/xk|/usr/bin/clang -O0 -fuse-ld=mold -g $sh -o clang-mold-dyn-g $sqlite/shell.c $sqlite/sqlite3.c -lm"
} > lists/shell-refs.list
{
    for g in "" -g; do
        echo "8p-clang-lld-dyn$g|$all,dir=$t/xk|/bin/bash $here/par.sh clang dyn $g"
    done
} > lists/shell-refs-8.list

# 2. The links alone: the same objects (this compiler's and clang's, with and without -g) by link-foreign, by the
# driver and by the system's linkers, each on one thread on CPU 2, then with their threads on CPUs 0 to 7.
links()
{
    local options=$1 threads=$2 p=$3
    for set in b bg k kg; do
        case $set in
            b) objects="shell.o sq.o"; g="" ;;
            bg) objects="shell-g.o sq-g.o"; g=-g ;;
            k) objects="k-shell.o k-sq.o"; g="" ;;
            kg) objects="k-shell-g.o k-sq-g.o"; g=-g ;;
        esac
        for kind in dyn static; do
            if [[ $kind == dyn ]]; then before=$dyn; after=$dynend; flag=""; else before=$static; after=$staticend; flag=-static; fi
            if [[ $threads == 1 ]]; then lanes="--lanes 1"; lld="--threads=1"; mold="--thread-count=1"; else lanes=""; lld="--threads=8"; mold="--thread-count=8"; fi
            echo "${p}lf-$kind-$set|$options,dir=$t/x|$c link-foreign $lanes $before -o ${p}lf-$kind-$set $objects $after"
            echo "${p}drv-$kind-$set|$options,dir=$t/x|$c $flag $g $objects -lm -o ${p}drv-$kind-$set"
            echo "${p}lld-$kind-$set|$options,dir=$t/x|/usr/bin/ld.lld $lld $before -o ${p}lld-$kind-$set $objects $after"
            echo "${p}mold-$kind-$set|$options,dir=$t/x|/usr/bin/mold $mold $before -o ${p}mold-$kind-$set $objects $after"
            if [[ $threads == 1 ]]; then
                echo "${p}bfd-$kind-$set|$options,dir=$t/x|/usr/bin/ld.bfd $before -o ${p}bfd-$kind-$set $objects $after"
            fi
        done
    done
}
# A link is a few milliseconds, which the process before it moves (its code and data still in the caches, or not): each
# line runs twice in a row and its first run is left out (warmups=1), so that every kept run follows its own command.
links "$one,warmups=1" 1 "" > lists/link-shell-1.list
links "$all,warmups=1" 8 "8" > lists/link-shell-8.list

# 2 and 3. The clocks: the driver's --time-stages, link-foreign's --time and mold's --perf on the same commands, each
# run's report kept (capture).
clocks()
{
    local options=$1 d=$2 p=$3 lanes=$4 mold=$5
    for g in "" -g; do
        echo "${p}ts-c$g|$options|$c --time-stages -c $g $ct $sqlite/sqlite3.c -o $t/o/${p}ts-c$g.o"
        echo "${p}ts-shell-c$g|$options|$c --time-stages -c $g $sh $sqlite/shell.c -o $t/o/${p}ts-shell-c$g.o"
        echo "${p}ts-sq-c$g|$options|$c --time-stages -c $g $sh $sqlite/sqlite3.c -o $t/o/${p}ts-sq-c$g.o"
        echo "${p}ts-s-dyn$g|$options|$c --time-stages $g $sh -o $d/${p}ts-s-dyn$g $sqlite/shell.c $sqlite/sqlite3.c -lm"
        echo "${p}ts-s-static$g|$options|$c --time-stages -static $g $sh -o $d/${p}ts-s-static$g $sqlite/shell.c $sqlite/sqlite3.c /usr/lib/libm.a"
        echo "${p}ts-hello-dyn$g|$options|$c --time-stages $g $t/f/hello.c -o $t/f/${p}ts-hello-dyn$g"
    done
    for set in b bg k kg; do
        case $set in
            b) objects="shell.o sq.o" ;;
            bg) objects="shell-g.o sq-g.o" ;;
            k) objects="k-shell.o k-sq.o" ;;
            kg) objects="k-shell-g.o k-sq-g.o" ;;
        esac
        echo "${p}lft-dyn-$set|$options,dir=$t/x|$c link-foreign --time $lanes $dyn -o ${p}lft-dyn-$set $objects $dynend"
        echo "${p}lft-static-$set|$options,dir=$t/x|$c link-foreign --time $lanes $static -o ${p}lft-static-$set $objects $staticend"
        echo "${p}moldp-dyn-$set|$options,dir=$t/x|/usr/bin/mold --perf $mold $dyn -o ${p}moldp-dyn-$set $objects $dynend"
        echo "${p}moldp-static-$set|$options,dir=$t/x|/usr/bin/mold --perf $mold $static -o ${p}moldp-static-$set $objects $staticend"
    done
}
{
    clocks "$one,capture" $t/x "" "--lanes 1" "--thread-count=1"
    echo "ts-hello-static|$one,capture|$c --time-stages -static $t/f/hello.c -o $t/f/ts-hello-static"
} > lists/clocks-1.list
clocks "$all,capture" $t/x8 "8" "" "--thread-count=8" > lists/clocks-8.list

# 3. What every command pays: a process, the driver's start, a unit's and a link's fixed work. Each line's first run of
# two is left out, as the links' are.
one_kept=$one
one="$one,warmups=1"
{
    echo "f-true|$one|/usr/bin/true"
    echo "f-version|$one|$c -dumpversion"
    echo "f-empty-syntax|$one|$c -fsyntax-only $t/f/empty.c"
    echo "f-empty-c|$one|$c -c $t/f/empty.c -o $t/f/empty.o"
    echo "f-hello-c|$one|$c -c $t/f/hello.c -o $t/f/hello.o"
    echo "f-hello-cg|$one|$c -c -g $t/f/hello.c -o $t/f/hello-g.o"
    echo "f-hello-c-md|$one|$c -c -MD -MF $t/f/hello.d $t/f/hello.c -o $t/f/hello-md.o"
    echo "f-hello-dyn|$one|$c $t/f/hello.c -o $t/f/hello-dyn"
    echo "f-hello-dyn-g|$one|$c -g $t/f/hello.c -o $t/f/hello-dyn-g"
    echo "f-hello-static|$one|$c -static $t/f/hello.c -o $t/f/hello-static"
    echo "f-hello-static-g|$one|$c -static -g $t/f/hello.c -o $t/f/hello-static-g"
    echo "f-hello-link|$one,dir=$t/f|$c hello.o -o hello-link"
    echo "tcc-hello-c|$one|/usr/bin/tcc -c $t/f/hello.c -o $t/f/tcc-hello.o"
    echo "tcc-hello-dyn|$one|/usr/bin/tcc $t/f/hello.c -o $t/f/tcc-hello-dyn"
    echo "clang-hello-c|$one|/usr/bin/clang -O0 -c $t/f/hello.c -o $t/f/clang-hello.o"
    echo "clang-hello-dyn|$one|/usr/bin/clang -O0 -fuse-ld=lld $t/f/hello.c -o $t/f/clang-hello-dyn"
} > lists/fixed.list
one=$one_kept

# 2 and 3. musl's library (prepare.sh's lists a and b: 1,343 sources) and the program linked with every object of it.
library()
{
    local options=$1 lanes=$2 p=$3 lld=$4 mold=$5 linklanes=$6
    for g in "" g; do
        local flag=${g:+-g} d=$t/ml$g
        local line="-static crt1.o hello.o missing.o $(cat $d/objects.txt) $G/libgcc.a"
        echo "${p}ml-a$g|$options,dir=$d/a|$c $mo --lanes $lanes -c $flag @$t/lists/lib-a.txt"
        echo "${p}ml-b$g|$options,dir=$d/b|$c $mo --lanes $lanes -c $flag @$t/lists/lib-b.txt"
        echo "${p}ml-lf$g|$options,warmups=1,dir=$d|$c link-foreign $linklanes -o ${p}hello-lf $line"
        echo "${p}ml-lld$g|$options,warmups=1,dir=$d|/usr/bin/ld.lld $lld -o ${p}hello-lld $line"
        echo "${p}ml-mold$g|$options,warmups=1,dir=$d|/usr/bin/mold $mold -o ${p}hello-mold $line"
        if [[ $lanes == 1 ]]; then
            echo "${p}ml-bfd$g|$options,warmups=1,dir=$d|/usr/bin/ld.bfd -o ${p}hello-bfd $line"
            echo "${p}ml-ar$g|$options,dir=$d|/usr/bin/rm -f ${p}libc.a ;; /usr/bin/ar rcs ${p}libc.a $(cat $d/objects.txt)"
        fi
        echo "${p}ml-q$g|$options|/bin/bash $here/muslseq.sh $d $lanes $flag"
        echo "${p}ml-lft$g|$options,capture,dir=$d|$c link-foreign --time $linklanes -o ${p}hello-lft $line"
    done
}
library "$one" 1 "" "--threads=1" "--thread-count=1" "--lanes 1" > lists/musl-build-1.list
library "$all" 8 "8" "--threads=8" "--thread-count=8" "" > lists/musl-build-8.list

# 3. synth's shape (test-check-units --generate's 512 units of 200 functions): one command to an executable, and -c.
if [[ -f $t/lists/synth.txt ]]; then
    {
        echo "y-link|$one,dir=$t/y/o1|$c --lanes 1 -o program @$t/lists/synth.txt"
        echo "y-link-g|$one,dir=$t/y/o1g|$c --lanes 1 -g -o program @$t/lists/synth.txt"
        echo "y-c|$one,dir=$t/y/c1|$c --lanes 1 -c @$t/lists/synth.txt"
        echo "y-c-g|$one,dir=$t/y/c1g|$c --lanes 1 -c -g @$t/lists/synth.txt"
    } > lists/synth-1.list
    {
        echo "y8-link|$all,dir=$t/y/o8|$c --lanes 8 -o program @$t/lists/synth.txt"
        echo "y8-link-g|$all,dir=$t/y/o8g|$c --lanes 8 -g -o program @$t/lists/synth.txt"
    } > lists/synth-8.list
    {
        echo "ts-y-link|$one,capture,dir=$t/y/o1|$c --time-stages --lanes 1 -o program @$t/lists/synth.txt"
        echo "ts-y-link-g|$one,capture,dir=$t/y/o1g|$c --time-stages --lanes 1 -g -o program @$t/lists/synth.txt"
    } > lists/synth-clocks-1.list
    {
        echo "8ts-y-link|$all,capture,dir=$t/y/o8|$c --time-stages --lanes 8 -o program @$t/lists/synth.txt"
        echo "8ts-y-link-g|$all,capture,dir=$t/y/o8g|$c --time-stages --lanes 8 -g -o program @$t/lists/synth.txt"
    } > lists/synth-clocks-8.list
fi
# 3. The runtime's snapshot: the same commands with no snapshot to open (the cache directory removed before each), their
# reports kept; and the removal alone, which the first step of each line costs.
cold="$one,capture,var=XDG_CACHE_HOME=$t/cache-cold"
{
    echo "cold-hello|$cold|/usr/bin/rm -rf $t/cache-cold ;; $c --time-stages $t/f/hello.c -o $t/f/cold-hello"
    echo "cold-hello-static|$cold|/usr/bin/rm -rf $t/cache-cold ;; $c --time-stages -static $t/f/hello.c -o $t/f/cold-hello-static"
    echo "cold-s-dyn|$cold,dir=$t/x|/usr/bin/rm -rf $t/cache-cold ;; $c --time-stages $sh -o cold-s-dyn $sqlite/shell.c $sqlite/sqlite3.c -lm"
    echo "cold-l-dyn|$cold,dir=$t/x|/usr/bin/rm -rf $t/cache-cold ;; $c --time-stages shell.o sq.o -lm -o cold-l-dyn"
    echo "warm-hello|$one,capture|$c --time-stages $t/f/hello.c -o $t/f/warm-hello"
    echo "warm-hello-static|$one,capture|$c --time-stages -static $t/f/hello.c -o $t/f/warm-hello-static"
    echo "warm-s-dyn|$one,capture,dir=$t/x|$c --time-stages $sh -o warm-s-dyn $sqlite/shell.c $sqlite/sqlite3.c -lm"
    echo "warm-l-dyn|$one,capture,dir=$t/x|$c --time-stages shell.o sq.o -lm -o warm-l-dyn"
    echo "rm-cache|$one|/usr/bin/rm -rf $t/cache-none"
} > lists/cold.list

# 3. The exit helper (#1444): the same compiles with it and without, run by a harness that waits on another CPU (run.sh
# helper ROUNDS with HARNESS_CPU=5), where a parent's wait can return before the address space is torn down.
{
    echo "h-c|$one|$c -c $ct $sqlite/sqlite3.c -o $t/o/h-c.o"
    echo "h-c-x|$one,var=BUSTER_EXIT_HELPER=0|$c -c $ct $sqlite/sqlite3.c -o $t/o/h-c-x.o"
    echo "h-cg|$one|$c -c -g $ct $sqlite/sqlite3.c -o $t/o/h-cg.o"
    echo "h-cg-x|$one,var=BUSTER_EXIT_HELPER=0|$c -c -g $ct $sqlite/sqlite3.c -o $t/o/h-cg-x.o"
    echo "h-hello|$one|$c $t/f/hello.c -o $t/f/h-hello"
    echo "h-hello-x|$one,var=BUSTER_EXIT_HELPER=0|$c $t/f/hello.c -o $t/f/h-hello-x"
    echo "h-q-dyn|$one,dir=$t/x|$c -c $sh $sqlite/shell.c -o shell.o ;; $c -c $sh $sqlite/sqlite3.c -o sq.o ;; $c shell.o sq.o -lm -o h-q-dyn"
    echo "h-q-dyn-x|$one,dir=$t/x,var=BUSTER_EXIT_HELPER=0|$c -c $sh $sqlite/shell.c -o shell.o ;; $c -c $sh $sqlite/sqlite3.c -o sq.o ;; $c shell.o sq.o -lm -o h-q-dyn-x"
} > lists/helper.list

# 3. The outputs on the tree's file system (btrfs with zstd) rather than tmpfs: the commands that write the most.
b=$here/scratch/btrfs
{
    echo "bt-c|$one|$c -c $ct $sqlite/sqlite3.c -o $b/bt-c.o"
    echo "bt-cg|$one|$c -c -g $ct $sqlite/sqlite3.c -o $b/bt-cg.o"
    echo "bt-s-dyn|$one,dir=$b|$c $sh -o bt-s-dyn $sqlite/shell.c $sqlite/sqlite3.c -lm"
    echo "bt-s-dyn-g|$one,dir=$b|$c -g $sh -o bt-s-dyn-g $sqlite/shell.c $sqlite/sqlite3.c -lm"
    echo "tm-c|$one|$c -c $ct $sqlite/sqlite3.c -o $t/o/tm-c.o"
    echo "tm-cg|$one|$c -c -g $ct $sqlite/sqlite3.c -o $t/o/tm-cg.o"
    echo "tm-s-dyn|$one,dir=$t/x|$c $sh -o tm-s-dyn $sqlite/shell.c $sqlite/sqlite3.c -lm"
    echo "tm-s-dyn-g|$one,dir=$t/x|$c -g $sh -o tm-s-dyn-g $sqlite/shell.c $sqlite/sqlite3.c -lm"
    if [[ -f $t/lists/synth.txt ]]; then
        echo "bt-y-link|$one,dir=$b/y|$c --lanes 1 -o program @$t/lists/synth.txt"
        echo "tm-y-link|$one,dir=$t/y/o1|$c --lanes 1 -o program @$t/lists/synth.txt"
    fi
} > lists/btrfs.list
mkdir -p $b/y

# 2 and 3. Lanes without a CPU each: the shell's links and builds on CPUs 0 to 7 (busy.sh runs the list alone, and
# beside a process that computes on one of those CPUs): by the driver with its session's lanes, with one lane and with
# two, by link-foreign with the lanes its objects pay for and with eight, and the system's linkers with eight threads.
{
    for kind in dyn static; do
        if [[ $kind == dyn ]]; then before=$dyn; after=$dynend; flag=""; lib=-lm; else before=$static; after=$staticend; flag=-static; lib=/usr/lib/libm.a; fi
        echo "z-drv-$kind|$all,capture,warmups=1,dir=$t/x8|$c --time-stages $flag shell.o sq.o -lm -o z-drv-$kind"
        echo "z-drv1-$kind|$all,warmups=1,dir=$t/x8|$c --lanes 1 $flag shell.o sq.o -lm -o z-drv1-$kind"
        echo "z-drv2-$kind|$all,warmups=1,dir=$t/x8|$c --lanes 2 $flag shell.o sq.o -lm -o z-drv2-$kind"
        echo "z-lf-$kind|$all,capture,warmups=1,dir=$t/x8|$c link-foreign --time $before -o z-lf-$kind shell.o sq.o $after"
        echo "z-lf8-$kind|$all,capture,warmups=1,dir=$t/x8|$c link-foreign --time --lanes 8 $before -o z-lf8-$kind shell.o sq.o $after"
        echo "z-lld-$kind|$all,warmups=1,dir=$t/x8|/usr/bin/ld.lld --threads=8 $before -o z-lld-$kind shell.o sq.o $after"
        echo "z-mold-$kind|$all,warmups=1,dir=$t/x8|/usr/bin/mold --thread-count=8 $before -o z-mold-$kind shell.o sq.o $after"
        echo "z-s-$kind|$all,capture,dir=$t/x8|$c --time-stages $flag $sh -o z-s-$kind $sqlite/shell.c $sqlite/sqlite3.c $lib"
        echo "z-s1-$kind|$all,dir=$t/x8|$c --lanes 1 $flag $sh -o z-s1-$kind $sqlite/shell.c $sqlite/sqlite3.c $lib"
    done
    echo "z-c-sq|$all,dir=$t/x8|$c -c $sh $sqlite/sqlite3.c -o z-sq.o"
    echo "z-c1-sq|$all,dir=$t/x8|$c --lanes 1 -c $sh $sqlite/sqlite3.c -o z-sq1.o"
    echo "z-hello|$all,warmups=1|$c $t/f/hello.c -o $t/f/z-hello"
} > lists/busy.list
wc -l lists/*.list
