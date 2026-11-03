# stacks.awk: strace -f -k output -> counts of each memory call by kind and by the first frame outside lane.c's arenas.
function flush() {
    if (kind != "") { key = kind " <- " caller; count[key] += 1; total[kind] += 1; caller = ""; kind = ""; depth = 0 }
}
/^[0-9]+ / {
    flush()
    line = $0
    if (line ~ /MADV_DONTNEED/) kind = "madvise DONTNEED"
    else if (line ~ /MADV_NOHUGEPAGE/) kind = "madvise NOHUGE"
    else if (line ~ /MADV_HUGEPAGE/) kind = "madvise HUGE"
    else if (line ~ / madvise\(/) kind = "madvise other"
    else if (line ~ / mmap\(NULL, [0-9]+, PROT_NONE, MAP_PRIVATE\|MAP_ANONYMOUS/) kind = "mmap arena"
    else if (line ~ / mmap\(/) kind = "mmap other"
    else if (line ~ / munmap\(/) kind = "munmap"
    else if (line ~ /PROT_NONE\) = /) kind = "mprotect none"
    else if (line ~ / mprotect\(/) kind = "mprotect rw"
    next
}
/^ > / {
    if (kind == "" || caller != "") next
    f = $0; sub(/^ > [^(]*\(/, "", f); sub(/\).*/, "", f); fn = f; sub(/\+0x[0-9a-f]+$/, "", fn)
    if (fn ~ /^(__madvise|__mmap|mmap64|__munmap|munmap|mprotect|__mprotect|arena_|scratch_|$)/) next
    caller = f
    next
}
END {
    flush()
    for (k in total) printf "%7d  %s\n", total[k], k | "sort -rn"
    close("sort -rn")
    print "-----"
    for (k in count) printf "%7d  %s\n", count[k], k | "sort -rn | head -60"
}
