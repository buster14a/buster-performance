import sys
exec(open(__import__('os').path.expanduser('~/.cache/claude-2639/fit2.py')).read().split("print('rate by size class")[0])
def run(label, pred, rule):
    cost = [max(1, int(round(v * 1e7 / pred.sum()))) for v in pred]
    b = plan(cost, 8, rule)
    parts = [y[i:j].sum() for i, j in b]
    print(f'{label:40s} rule={int(rule)} max {max(parts):6.1f}  ' + ' '.join(f'{v:5.1f}' for v in parts))
cur = np.where(on, (ins + 3) // 4, ins) + 8
new = np.where(on, (ins + 3) // 4, ins + 2 * blk + ins * ins / 50000) + 30
for rule in (True, False):
    run('current', cur, rule)
    run('n+2b+n^2/50000+30', new, rule)
    run('oracle', y.copy(), rule)
