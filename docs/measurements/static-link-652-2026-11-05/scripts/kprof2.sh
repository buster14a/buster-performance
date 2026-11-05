#!/bin/sh
# The static head's empty -fsyntax-only, 300 processes, cycles with kernel call chains: each sample by what entered the
# kernel (a page fault, on a file's page or an anonymous one; a system call, by name) or user code.
cd ~/buster-fast-bench/652-claude-5
export EXCLUSIVE_OWNER=claude-652 EXCLUSIVE_TITLE="652 remaining work" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/652
C=$PWD/shifts-s3/compiler-0
~/buster-fast-bench/exclusive.sh sh -c "taskset -c 2 perf record -q -e cycles -c 20000 --call-graph fp -o kprof2.data -- sh -c 'for i in \$(seq 300); do $C -fsyntax-only empty.c; done' > /dev/null 2>&1"
perf script -i kprof2.data --comm compiler-0 -F ip,sym 2>/dev/null | awk '
  function flush() { if (n == 0) return; k = "user"; if (kernel) { k = "kernel: other"; if (fault) k = file ? "fault: file-backed" : anon ? "fault: anonymous" : "fault: other"; else if (sys != "") k = "syscall: " sys; else if (execve) k = "exec"; } count[k]++; total++ }
  /^$/ { flush(); n = 0; kernel = 0; fault = 0; file = 0; anon = 0; sys = ""; execve = 0; next }
  { n++; addr = $1; name = $2; if (n == 1 && addr ~ /^ffffffff/) kernel = 1
    if (name ~ /exc_page_fault/) fault = 1
    if (name ~ /filemap_map_pages|filemap_fault|do_read_fault|do_fault_around|next_uptodate_folio/) file = 1
    if (name ~ /do_anonymous_page|do_wp_page|wp_page_copy|clear_page/) anon = 1
    if (name ~ /^__x64_sys_/) { s = name; sub(/^__x64_sys_/, "", s); sys = s }
    if (name ~ /bprm_execve|load_elf_binary|begin_new_exec/) execve = 1 }
  END { flush(); for (k in count) printf "%5.1f%% %s\n", 100 * count[k] / total, k }' | sort -rn
echo done
