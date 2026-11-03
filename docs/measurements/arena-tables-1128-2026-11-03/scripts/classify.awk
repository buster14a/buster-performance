# Classifies perf script samples (with callchains) by the syscall or fault their kernel stack serves.
/^\S/ { if (n) flush(); n = 1; stack = ""; next }
/^\s+[0-9a-f]+ / { stack = stack " " $2; next }
/^$/ { if (n) flush(); n = 0; next }
function flush(   k) {
    total += 1
    k = "user/other"
    if (stack ~ /__x64_sys_madvise/) { k = stack ~ /down_write|rwsem_down_write/ ? "madvise: write lock wait" : (stack ~ /flush_tlb|smp_call_function/ ? "madvise: TLB flush" : (stack ~ /zap|unmap_page_range/ ? "madvise: zap" : "madvise: other")) }
    else if (stack ~ /__x64_sys_mprotect/) { k = stack ~ /rwsem_down_write|osq_lock/ ? "mprotect: write lock wait" : "mprotect: other" }
    else if (stack ~ /__x64_sys_munmap/) { k = stack ~ /rwsem_down_write|osq_lock/ ? "munmap: write lock wait" : (stack ~ /flush_tlb|smp_call_function/ ? "munmap: TLB flush" : "munmap: other") }
    else if (stack ~ /vm_mmap_pgoff|ksys_mmap/) { k = stack ~ /rwsem_down_write|osq_lock/ ? "mmap: write lock wait" : "mmap: other" }
    else if (stack ~ /exc_page_fault/) { k = stack ~ /do_huge_pmd/ ? "fault: huge page" : (stack ~ /rwsem_down_read|lock_mm_and_find_vma/ ? "fault: mmap_lock" : "fault: base page") }
    else if (stack ~ /sysvec_call_function/) { k = "IPI received (TLB flush)" }
    else if (stack ~ /entry_SYSCALL/) { k = "other syscall" }
    count[k] += 1
}
END { if (n) flush(); for (k in count) printf "%6.2f%%  %s\n", 100 * count[k] / total, k }
