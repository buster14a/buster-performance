#!/usr/bin/env python3
# Replaces each kernel address in a gzipped `perf script -F pid,tid,ip,sym` text with ffffffff80000000, so that the
# published samples don't give the host's kernel layout; attrsum.py still counts them as the kernel's, by symbol.
#   mask_kernel.py IN.txt.gz OUT.txt.gz
import gzip, sys
with gzip.open(sys.argv[1], 'rt', errors='replace') as src, gzip.open(sys.argv[2], 'wt') as dst:
    for line in src:
        parts = line.split(None, 2)
        if len(parts) >= 2 and len(parts[1]) == 16:
            try:
                if int(parts[1], 16) >= 0xffff800000000000:
                    line = line.replace(parts[1], 'ffffffff80000000', 1)
            except ValueError:
                pass
        dst.write(line)
