#!/usr/bin/env python3
# Replaces each kernel address in a gzipped `perf script -F pid,tid[,time],ip,sym,addr` text of page faults with
# ffffffff80000000, so that the published faults don't give the host's kernel layout; e1sum.py and e2sum.py still count
# them by symbol and thread, and the faulting addresses (the process's own, user space) are kept.
#   mask_kernel_faults.py IN.txt.gz OUT.txt.gz
import gzip, re, sys
hexword = re.compile(r'\b[0-9a-f]{16}\b')
def mask(match):
    return 'ffffffff80000000' if int(match.group(0), 16) >= 0xffff800000000000 else match.group(0)
with gzip.open(sys.argv[1], 'rt', errors='replace') as src, gzip.open(sys.argv[2], 'wt') as dst:
    for line in src:
        dst.write(hexword.sub(mask, line))
