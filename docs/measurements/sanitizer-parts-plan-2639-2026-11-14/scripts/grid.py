import sys
exec(open(__import__('os').path.expanduser('~/.cache/claude-2639/fit2.py')).read().split("print('rate by size class")[0])

RULE = __import__("os").environ.get("RULE", "1") == "1"
res = []
for K in (25000, 50000, 100000, 10**12):
    for B in (0, 2, 4, 6, 8, 12):
        for P in (0, 2, 4):
            pred = np.where(on, (ins + 3) // 4, ins + B * blk + P * phis + ins * ins / K) + 30
            scale = y.sum() / pred.sum()
            err = np.abs(pred * scale - y).sum() / y.sum()
            cost = [max(1, int(round(v * 1e7 / pred.sum()))) for v in pred]
            b = plan(cost, 8, RULE)
            m = max(y[i:j].sum() for i, j in b)
            res.append((m, err, K, B, P))
for r in sorted(res)[:15]:
    print(f'max {r[0]:6.1f} err {r[1]:.3f} K={r[2]} B={r[3]} P={r[4]}')
