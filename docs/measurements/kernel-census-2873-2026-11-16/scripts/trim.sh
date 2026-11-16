#!/bin/bash
# trim.sh IN.gz OUT.gz: a CPU-wide recording's perf script text with only the harness's and the compile's processes
# (taskset, setarch, waitall, perf-exec, compiler, and the compiler's number once perf has seen it exit): the CPU-wide
# recording holds other tasks' samples and every process's mmap records, among them other sessions' paths. kcensus's
# tables in the record were made from the text before trimming; on the trimmed text the rows "other tasks" are empty.
zcat "$1" | awk '
/^\t/ { if (keep) print; next }
/^ (N\/A|[0-9]+[KMG])$/ { if (keep) print; next }
{
    comm = $1
    pid = $2
    sub(/\/.*/, "", pid)
    if (comm == "compiler") ours[pid] = 1
    keep = comm ~ /^(compiler|waitall|setarch|taskset|perf-exec)$/ || (comm ~ /^:/ && (substr(comm, 2) in ours))
    if (keep) print
}' | gzip -9 > "$2"
