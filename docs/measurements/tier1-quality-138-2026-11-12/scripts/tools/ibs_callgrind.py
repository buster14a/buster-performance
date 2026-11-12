#!/usr/bin/env python3
# ibs_callgrind.py ADDRESSES OBJECT [BIAS [SCALE]] > FILE: ibs.sh's samples by address ("count hex-address" lines) as a file in
# callgrind's format, one cost line per address, so that tier1-gap-1189's gap.c joins them with a disassembly and the
# tags as it joins callgrind's counts (gap count DISASSEMBLY FILE OBJECT 0 [KINDS]). BIAS is what the run added to the
# executable's file addresses (0x555555554000 for a PIE run with randomization off; 0 for a -no-pie executable).
# SCALE multiplies every count (to compare two files of different numbers of runs: scale each by the other's runs).
# Addresses outside [BIAS, BIAS + 2^31) are other objects' (the C library, the loader) and go to object "other".
import sys
path, obj = sys.argv[1], sys.argv[2]
bias = int(sys.argv[3], 0) if len(sys.argv) > 3 else 0
scale = int(sys.argv[4]) if len(sys.argv) > 4 else 1
ours = []; other = 0
for line in open(path):
    count, address = line.split()
    a = int(address, 16)
    if bias <= a < bias + (1 << 31):
        ours.append((a - bias, int(count) * scale))
    else:
        other += int(count) * scale
print("# callgrind format\nevents: Ir\n")
print(f"ob=(1) {obj}\nfn=(1) samples")
for a, c in sorted(ours):
    print(f"{a:#x} {c}")
print(f"ob=(2) other\nfn=(2) other\n0x0 {other}")
