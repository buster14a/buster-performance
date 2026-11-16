#!/bin/bash
# ksys.sh NAME COMPILER KIND: the kernel's cycles by system call and exception, inclusive, for one count's work of KIND
# (ab.sh --work) by COMPILER on CPU 2 (perf record -g -C 2 -e cycles:k), into results/ksys-NAME.txt. One hold of the lock.
cd "$(dirname "$0")"
name=$1
compiler=$2
kind=$3
bash ab.sh --work "$kind" "$compiler" warm > /dev/null 2>&1
taskset -c 4 perf record -q -g -C 2 -e cycles:k -c 200003 -o "/dev/shm/2873-ksys-$name.data" -- bash ab.sh --work "$kind" "$compiler" "$name" > /dev/null 2>&1
perf report -i "/dev/shm/2873-ksys-$name.data" --children --sort symbol --stdio -g none 2> /dev/null | grep -E "__x64_sys_|asm_exc_page_fault|do_exit|exit_mmap|do_syscall_64|x64_sys_call|ret_from_fork|asm_sysvec|Event count|__mmput|free_pgtables|unmap_vmas|zap_|mprotect_fixup|mmap_region|do_vmi_|__split_vma|vma_merge|vma_modify|vms_" | head -70 > "results/ksys-$name.txt"
rm -f "/dev/shm/2873-ksys-$name.data"
