#!/usr/bin/env python3
# #872: the campaign's tables: medians per unit and tree, each merge against its parent, the token-weighted totals,
# and the perf counts of the endpoint and post-range checkpoints.
import collections, re, statistics, sys

runs_path, perf_path, perf_post_path, outdir = sys.argv[1:5]
commits = {l.split()[0]: l.split()[1][:10] for l in open('/tmp/opencode/872/trees.txt')}
runs = collections.defaultdict(list)
tokens = {}
cur = None
for line in open(runs_path, errors='replace'):
    if line.startswith('== round '):
        p = line.split()
        cur = dict(name=p[3], unit=p[4], round=int(p[2]))
        runs[(p[3], p[4])].append(cur)
    elif cur is not None and line.startswith('checker-deferred: file='):
        tokens[cur['unit']] = int(re.search(r'tokens=(\d+)', line).group(1))
        cur['source'] = float(re.search(r'source_order=([\d.]+)', line).group(1))
    elif cur is not None and line.startswith('checker-deferred:   lanes='):
        m = re.match(r'checker-deferred:   lanes=(\d+) active=(\d+) .*whole=([\d.]+) top=([\d.]+) environment=([\d.]+) walks=([\d.]+) positions=([\d.]+) lanes_span=([\d.]+) merge=([\d.]+) rest=([\d.]+)', line)
        if m:
            cur[int(m.group(1))] = dict(active=int(m.group(2)), whole=float(m.group(3)), top=float(m.group(4)),
                                        environment=float(m.group(5)), walks=float(m.group(6)),
                                        positions=float(m.group(7)), lanes_span=float(m.group(8)),
                                        merge=float(m.group(9)), rest=float(m.group(10)))
    elif cur is not None and line.startswith('exit='):
        cur['exit'] = line.split()[0]

def med(tree, unit, key, field=None):
    vals = []
    for r in runs.get((tree, unit), []):
        if key not in r or r.get('exit') != 'exit=0':
            continue
        v = r[key]
        vals.append(v[field] if field else v)
    return statistics.median(vals) if vals else float('nan')

units = sorted(tokens, key=lambda u: tokens[u])
trees = sorted({t for (t, _) in runs})
order = ['base', 'm754', 'm729', 'm747', 'm759', 'm800', 'm790', 'm826', 'm735', 'm752', 'm756', 'end', 'pre980', 'fix980', 'main']
trees = [t for t in order if t in trees]
pairs = ['base:m754', 'm754:m729', 'm729:m747', 'm747:m759', 'm759:m800', 'm800:m790',
         'm790:m826', 'm826:m735', 'm735:m752', 'm752:m756', 'm756:end',
         'end:pre980', 'pre980:fix980', 'fix980:main', 'base:end', 'base:fix980', 'base:main']

def w(name, key=None, field=None):
    return open(f'{outdir}/{name}', 'w')

# medians
for metric, key, field in [('source order', 'source', None), ('deferred, one lane', 1, 'whole'),
                           ('deferred, by the rule', 8, 'whole')]:
    f = w(('medians-source.md' if key == 'source' else 'medians-one-lane.md' if key == 1 else 'medians-rule.md'), None)
    f.write(f'| Unit | Tokens | ' + ' | '.join(trees) + ' |\n')
    f.write('| --- | ---: | ' + ' | '.join('---:' for _ in trees) + ' |\n')
    for unit in units:
        f.write(f'| `{unit}.c` | {tokens[unit]} | ' + ' | '.join(f'{med(t, unit, key, field):.2f}' for t in trees) + ' |\n')
    f.write('\nEach value is the median over the campaign\'s five rounds of the benchmark\'s median over its passes, in\n')
    f.write('nanoseconds per input token. `--passes 24` (`12` for `sqlite.c`).\n')
    f.close()

# merges
f = w('merges.md', None)
f.write('Each merge in `bc11fddb..d11a91d2` against its first parent, then the fix and current main. The columns are the\n')
f.write('median of the ten units\' percentage changes, and the changes of the four units the regression was reported on.\n\n')
f.write('| Parent | Child | Source order (median) | One lane (median) | By the rule (median) | `00213.c` one lane | `00204.c` one lane | `00200.c` one lane | `sqlite.c` one lane | `sqlite.c` source |\n')
f.write('| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |\n')
for pair in pairs:
    parent, child = pair.split(':')
    def pct(key, field, unit):
        return 100 * (med(child, unit, key, field) / med(parent, unit, key, field) - 1)
    smo = statistics.median(pct('source', None, u) for u in units)
    omo = statistics.median(pct(1, 'whole', u) for u in units)
    rmo = statistics.median(pct(8, 'whole', u) for u in units)
    f.write(f'| `{parent}` | `{child}` | {smo:+.1f}% | {omo:+.1f}% | {rmo:+.1f}% | ' +
            ' | '.join(f'{pct(1, "whole", u):+.1f}%' for u in ['00213', '00204', '00200', 'sqlite']) +
            f' | {pct("source", None, "sqlite"):+.1f}% |\n')
f.write('\nThe per-unit changes of every pair are in the tables below.\n\n')
for pair in pairs:
    parent, child = pair.split(':')
    f.write(f'### `{parent}` -> `{child}`\n\n')
    f.write('| Unit | Tokens | Source order | One lane | By the rule | One-lane top | One-lane walks | One-lane merge | One-lane rest |\n')
    f.write('| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |\n')
    for unit in units:
        def pct(key, field):
            return 100 * (med(child, unit, key, field) / med(parent, unit, key, field) - 1)
        f.write(f'| `{unit}.c` | {tokens[unit]} | {pct("source", None):+.1f}% | {pct(1, "whole"):+.1f}% | {pct(8, "whole"):+.1f}% | ' +
                f'{pct(1, "top"):+.1f}% | {pct(1, "walks"):+.1f}% | {pct(1, "merge"):+.1f}% | {pct(1, "rest"):+.1f}% |\n')
    f.write('\n')
f.close()

# totals
f = w('totals.md', None)
f.write('The sum over the ten units of tokens times the median ns/token: one compile of all ten, not a mean of ratios.\n\n')
f.write('| Tree | Commit | Source order | One lane | By the rule |\n')
f.write('| --- | --- | ---: | ---: | ---: |\n')
tot = {}
for t in trees:
    def total(key, field):
        return sum(tokens[u] * med(t, u, key, field) for u in units) / 1e6
    tot[t] = (total('source', None), total(1, 'whole'), total(8, 'whole'))
    commit = commits[t]
    f.write(f'| `{t}` | {commit} | {tot[t][0]:.2f} ms | {tot[t][1]:.2f} ms | {tot[t][2]:.2f} ms |\n')
f.write('\n| Change | Source order | One lane | By the rule |\n| --- | ---: | ---: | ---: |\n')
for pair in pairs:
    parent, child = pair.split(':')
    f.write(f'| `{parent}` -> `{child}` | ' + ' | '.join(f'{100 * (tot[child][i] / tot[parent][i] - 1):+.1f}%' for i in range(3)) + ' |\n')
f.close()

# perf
def parse_perf(path):
    out = {}
    cur = None
    for line in open(path, errors='replace'):
        if line.startswith('== perf '):
            p = line.split()
            cur = (p[2], p[3])
            out[cur] = {}
        elif cur and re.match(r'\s+[0-9,]+\s+instructions:u', line):
            out[cur]['instructions'] = int(line.split()[0].replace(',', ''))
        elif cur and re.match(r'\s+[0-9,]+\s+cycles:u', line):
            out[cur]['cycles'] = int(line.split()[0].replace(',', ''))
    return out
perf = parse_perf(perf_path)
perf.update(parse_perf(perf_post_path))
f = w('perf.md', None)
f.write('`perf stat -r 3 -e instructions:u,cycles:u`, pinned to CPU 2, over `benchmark-checker-deferred --lanes 1`:\n')
f.write('`--passes 24` for `00204.c` and `--passes 6` for `sqlite3.c`. Each count is the median of three runs, whose\n')
f.write('relative spread was at most 0.54% (the instructions\' at most 0.00%).\n\n')
f.write('| Tree | Unit | Instructions | Cycles | Instructions vs base | Cycles vs base |\n')
f.write('| --- | --- | ---: | ---: | ---: | ---: |\n')
for t in ['base', 'm754', 'end', 'p965', 'p969', 'p973', 'p968', 'pre980', 'fix980', 'p1002', 'main']:
    for u in ['00204', 'sqlite']:
        if (t, u) not in perf:
            continue
        p = perf[(t, u)]
        b = perf[('base', u)]
        f.write(f'| `{t}` | `{u}.c` | {p["instructions"]:,} | {p["cycles"]:,} | {100 * (p["instructions"] / b["instructions"] - 1):+.2f}% | {100 * (p["cycles"] / b["cycles"] - 1):+.2f}% |\n')
f.write('\nThe post-range checkpoints are cumulative from `d11a91d2`: `p965` is the merge of #965 (whose first-parent\n')
f.write('range includes #966\'s library builtins), `p969` #969, `p973` #973, `p968` #968, `p1002` #1002 and the\n')
f.write('merges between them, and `pre980`/`fix980` #980\'s parent and head.\n')
f.close()
