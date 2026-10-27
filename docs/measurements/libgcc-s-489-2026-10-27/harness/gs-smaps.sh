#!/bin/bash
# On the 9700X: the C driver's hello world under gdb, stopped at exit_group, with its /proc/PID/smaps, for each tree.
B=~/buster-fast-bench
for d in libgcc-s-489-main libgcc-s-489-claude; do
    cd $B/$d || exit 1
    XDG_CACHE_HOME=$B/$d/proc-cache gdb -q -batch -ex 'catch syscall exit_group' -ex 'run' -ex 'python import gdb; pid=gdb.selected_inferior().pid; open("'$B/$d'/smaps-hello.txt","w").write(open("/proc/%d/smaps"%pid).read())' --args ./build/compiler $B/libgcc-s-489-hello.c -o $B/$d/smaps-hello > /dev/null 2>&1
    echo "== $d $?"; grep -c . smaps-hello.txt
done
