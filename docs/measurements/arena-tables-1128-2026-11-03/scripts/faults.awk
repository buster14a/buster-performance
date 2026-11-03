# faults.awk: perf script -F ip,sym,dso samples -> the first user frame of each sample whose kernel stack is a
# page fault (by fault kind), and the kernel frames of madvise samples.
/^\S/ { if (n) flush(); n = 1; nk = 0; user = ""; kstack = ""; next }
/^\s+[0-9a-f]+ / {
    dso = $NF; sym = $2
    if (dso ~ /kernel/) { kstack = kstack " " sym }
    else if (user == "" && sym !~ /^(__memset|__memmove|__memcpy)/) { user = sym }
    else if (user == "") { user = sym }
    next
}
/^$/ { if (n) flush(); n = 0; next }
function flush() {
    total += 1
    if (kstack ~ /exc_page_fault/) { k = (kstack ~ /do_huge_pmd/ ? "huge " : "base ") user; f[k] += 1; faults += 1 }
    else if (kstack ~ /__x64_sys_madvise/) { split(kstack, a, " "); k = ""; for (i = 1; i <= 6 && i in a; i++) k = k " " a[i]; m[k] += 1 }
}
END {
    printf "samples %d, faults %d\n", total, faults
    for (k in f) printf "%6.2f%%  fault %s\n", 100 * f[k] / total, k | "sort -rn | head -40"
    close("sort -rn | head -40")
    for (k in m) printf "%6.2f%%  madvise%s\n", 100 * m[k] / total, k | "sort -rn | head -15"
}
