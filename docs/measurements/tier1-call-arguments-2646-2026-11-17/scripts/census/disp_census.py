#!/usr/bin/env python3
# rsp-based accesses: how many need disp32, and how many would with hot-first slot order (each function's distinct
# 8-byte-aligned displacement buckets sorted by access count, packed from 0).
import sys, os, collections
sys.path.insert(0, os.path.dirname(__file__))
from frame_bias import funcs
n = 0; d32 = 0; d8 = 0; d0 = 0; reorder32 = 0
for p in sys.argv[1:]:
    res, pushes, sz = funcs(p)
    for f, ds in res.items():
        for d in ds:
            n += 1
            if d == 0: d0 += 1
            elif -128 <= d <= 127: d8 += 1
            else: d32 += 1
        buckets = collections.Counter(d // 8 for d in ds if d >= 0)
        order = [b for b, _ in buckets.most_common()]
        for i, b in enumerate(order):
            if 8 * i + 7 > 127: reorder32 += buckets[b]
print("accesses", n, "disp0", d0, "disp8", d8, "disp32", d32, "disp32 after hot-first order", reorder32)
