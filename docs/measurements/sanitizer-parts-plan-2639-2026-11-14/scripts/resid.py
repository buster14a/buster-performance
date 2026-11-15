import sys
exec(open(__import__('os').path.expanduser('~/.cache/claude-2639/fit2.py')).read().split("print('rate by size class")[0])
pred = np.where(on, (ins + 3) // 4, ins + ins * ins / 25000) + 30
scale = y.sum() / pred.sum()
pred = pred * scale
edges = [0, 221, 1168, 1703, 2266, 2352, 2608, 3048, len(y)]
print('region          y      pred   ratio  blk/i  calls/i phis/i loads/i stores/i vec/i cases/i  opt%   meanN')
for a, b in zip(edges, edges[1:]):
    sl = slice(a, b)
    n = ins[sl].sum()
    print(f'[{a:4d},{b:4d}) {y[sl].sum():6.1f} {pred[sl].sum():6.1f}  {y[sl].sum()/pred[sl].sum():5.2f}  {blk[sl].sum()/n:.3f}  {calls[sl].sum()/n:.3f}  {phis[sl].sum()/n:.3f}  {loads[sl].sum()/n:.3f}  {stores[sl].sum()/n:.3f}  {vec[sl].sum()/n:.3f}  {cases[sl].sum()/n:.4f}  {100*io[sl].sum()/n:4.1f}  {n/(b-a):7.0f}')
# top functions in region 1 by y/pred
r = slice(221, 1168)
idx = np.argsort(-(y[r] - pred[r]))[:15]
for i in idx:
    j = 221 + i
    print(f'  {names[j][:50]:50s} n={ins[j]:7.0f} blk={blk[j]:6.0f} y={y[j]:6.2f} pred={pred[j]:6.2f} vec={vec[j]:6.0f} calls={calls[j]:5.0f} phis={phis[j]:5.0f} cases={cases[j]:5.0f} sq/n={sq[j]/max(ins[j],1):7.1f} largest={lg[j]:6.0f}')
