#!/usr/bin/env python3
# perunit.py FILE...: least squares of each unit's reader ticks on its tokens by class (PROBEU lines: reader R
# definitions D others O skipped S): R = a*D + b*O + c*S + k, by numpy-free normal equations; c is what a skipped token
# still costs the reader, in TSC ticks.
import sys
def solve(rows):
    n = len(rows[0]) - 1
    A = [[0.0] * n for _ in range(n)]
    y = [0.0] * n
    for r in rows:
        x, t = r[:-1], r[-1]
        for i in range(n):
            y[i] += x[i] * t
            for j in range(n):
                A[i][j] += x[i] * x[j]
    for i in range(n):
        p = max(range(i, n), key=lambda k: abs(A[k][i]))
        A[i], A[p] = A[p], A[i]; y[i], y[p] = y[p], y[i]
        for k in range(i + 1, n):
            f = A[k][i] / A[i][i]
            for j in range(i, n):
                A[k][j] -= f * A[i][j]
            y[k] -= f * y[i]
    b = [0.0] * n
    for i in reversed(range(n)):
        b[i] = (y[i] - sum(A[i][j] * b[j] for j in range(i + 1, n))) / A[i][i]
    return b
for f in sys.argv[1:]:
    rows = []
    for line in open(f):
        p = line.split()
        if p and p[0] == 'PROBEU':
            v = dict(zip(p[1::2], map(float, p[2::2])))
            rows.append([v['definitions'], v['others'], v['skipped'], 1.0, v['reader']])
    a, b, c, k = solve(rows)
    tot = [sum(r[i] for r in rows) for i in range(5)]
    print(f"{f}: units={len(rows)} ticks a definition token {a:.1f}, another read token {b:.1f}, a skipped token {c:.1f}, a unit {k:.0f}; "
          f"tokens: definitions {tot[0]:.0f} others {tot[1]:.0f} skipped {tot[2]:.0f}; reader {tot[4]/1e6:.1f} M ticks")
