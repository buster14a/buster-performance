#!/bin/bash
# rows.sh NAME COMPILER KIND: the kernel's cycles by system call, fault and exit, inclusive, on CPU 2 as a whole
# (perf record -g -C 2 -e cycles:k), for KIND's work by COMPILER: `musl` (ab.sh's: the 1,336 units, a process each),
# `sqlite` (20 compiles of sqlite3.c, one after the other) or `command` (musl as one command). COMPILER /usr/bin/true
# gives the harness's own. results/rows-NAME.tsv: the event count, then a line a symbol (inclusive cycles, symbol).
# One hold of the lock.
cd "$(dirname "$0")"
here=$PWD
name=$1
compiler=$2
kind=$3
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
work()
{
    if [ "$kind" = sqlite ]; then
        for ((i = 0; i < 20; i += 1)); do
            taskset -c 2 ../tools/waitall "$compiler" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o /dev/shm/2873-rows.o
        done
    else
        bash "$here/ab.sh" --work "$kind" "$compiler" rows
    fi
}
export -f work
export compiler kind sqlite here
work > /dev/null 2>&1
taskset -c 4 perf record -q -g -C 2 -e cycles:k -c 100003 -o "/dev/shm/2873-rows-$name.data" -- bash -c work > /dev/null 2>&1
perf report -i "/dev/shm/2873-rows-$name.data" --children --sort symbol --stdio -g none 2> /dev/null > "/dev/shm/2873-rows-$name.txt"
count=$(grep "Event count" "/dev/shm/2873-rows-$name.txt" | sed 's/.*: //')
{
    echo "$count events"
    awk -v total="$count" '$3 ~ /^\[.\]$/ && $4 ~ /^(__x64_sys_[a-z0-9_]+|asm_exc_page_fault|do_exit|exit_mmap|do_syscall_64|ret_from_fork_asm|asm_sysvec_[a-z_]+|asm_common_interrupt|entry_SYSCALL_64_after_hwframe|do_group_exit|__mmput|kernel_clone|bprm_execve|load_elf_binary|begin_new_exec|exec_mmap|ksys_mmap_pgoff|vm_mmap_pgoff|__vm_munmap|x64_sys_call|__mm_populate|do_madvise|do_mprotect_pkey)$/ { gsub("%", "", $1); printf "%.0f\t%s\n", $1 * total / 100, $4 }' "/dev/shm/2873-rows-$name.txt"
} > "results/rows-$name.tsv"
rm -f "/dev/shm/2873-rows-$name.data" "/dev/shm/2873-rows-$name.txt" /dev/shm/2873-rows.o
