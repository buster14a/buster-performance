# Peak of mapped bytes from `strace -f -e trace=mmap,munmap,mremap,brk` output: mmap adds its length, munmap subtracts.
/mmap\(/ && !/= -1/ { split($0, a, ", "); len = a[2] + 0; total += len; count[len] += 1; if (total > peak) peak = total; next }
/munmap\(/ && !/= -1/ { split($0, a, ", "); len = a[2]; sub(/\).*/, "", len); total -= len + 0; next }
/= -1 ENOMEM/ { failed = failed $0 "\n" }
END { printf "peak %.1f MiB, end %.1f MiB\n", peak / 1048576, total / 1048576; printf "%s", failed }
