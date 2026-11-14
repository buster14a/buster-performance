#!/usr/bin/env python3
# Aggregates clang -ftime-trace files of a build tree: per compile, per phase, per pass, per function and per header.
# usage: traces.py TREE [TOP]
import collections
import json
import os
import sys

tree = sys.argv[1]
top = int(sys.argv[2]) if len(sys.argv) > 2 else 25
WRAPPERS = {
    'Total ExecuteCompiler', 'Total Frontend', 'Total Backend', 'Total Optimizer', 'Total OptModule', 'Total CodeGenPasses',
    'Total Source', 'Total RunPass', 'Total OptFunction', 'Total CodeGen Function',
}


def wrapper(name):
    return (name in WRAPPERS or 'PassManager' in name or 'Adaptor' in name or 'RepeatedPass' in name
            or name.startswith('Total Parse') or name.startswith('Total Perform') or name.startswith('Total Instantiate'))


files = []
for directory, _, names in os.walk(tree):
    for name in names:
        if not name.endswith('.json') or name == 'compile_commands.json':
            continue
        path = os.path.join(directory, name)
        try:
            with open(path) as handle:
                data = json.load(handle)
        except (ValueError, OSError):
            continue
        if not isinstance(data, dict) or 'traceEvents' not in data:
            continue
        files.append((path, data['traceEvents']))

per_file = []
totals = collections.defaultdict(float)
functions_opt = []
functions_codegen = []
sources = collections.defaultdict(float)
passes_by_function = collections.defaultdict(float)
for path, events in files:
    total = {e['name']: e['dur'] / 1e6 for e in events if e.get('name', '').startswith('Total ')}
    for name, seconds in total.items():
        totals[name] += seconds
    short = os.path.relpath(path, tree)
    per_file.append((total.get('Total ExecuteCompiler', 0.0), total.get('Total Frontend', 0.0),
                     total.get('Total Optimizer', total.get('Total OptModule', 0.0)),
                     total.get('Total CodeGenPasses', 0.0), total.get('Total Backend', 0.0), short,
                     sorted(((s, n) for n, s in total.items() if not wrapper(n)), reverse=True)[:4]))
    # Begin/end pairs (Source) and complete events (X).
    stack = {}
    for e in events:
        name = e.get('name', '')
        if e.get('ph') == 'X' and 'dur' in e and not name.startswith('Total '):
            detail = e.get('args', {}).get('detail', '')
            if name == 'OptFunction':
                functions_opt.append((e['dur'] / 1e6, detail, short))
            elif name == 'CodeGen Function':
                functions_codegen.append((e['dur'] / 1e6, detail, short))
            elif name == 'Source':
                sources[detail] += e['dur'] / 1e6
            elif name not in ('RunPass',) and detail and not wrapper('Total ' + name):
                passes_by_function[(name, detail)] += e['dur'] / 1e6
            elif name == 'RunPass' and detail:
                passes_by_function[('RunPass', detail)] += e['dur'] / 1e6
        elif e.get('ph') == 'b' and name == 'Source':
            stack.setdefault((e.get('tid'), e.get('id')), []).append((e['ts'], e.get('args', {}).get('detail', '')))
        elif e.get('ph') == 'e' and name == 'Source':
            opened = stack.get((e.get('tid'), e.get('id')))
            if opened:
                start, detail = opened.pop()
                sources[detail] += (e['ts'] - start) / 1e6

print('%d traced compiles under %s' % (len(files), tree))
whole = sum(f[0] for f in per_file)
print('compile time, all traced compiles: %.1f s (front end %.1f, optimizer %.1f, code generation %.1f)' % (
    whole, sum(f[1] for f in per_file), sum(f[2] for f in per_file), sum(f[3] for f in per_file)))
print('\n-- the %d longest compiles: total, front end, optimizer, codegen passes, backend; its 4 costliest passes' % top)
for row in sorted(per_file, reverse=True)[:top]:
    passes = ', '.join('%s %.1f' % (n[len('Total '):], s) for s, n in row[6])
    print('%7.1f %6.1f %6.1f %6.1f %6.1f  %s\n        %s' % (row[0], row[1], row[2], row[3], row[4], row[5], passes))
print('\n-- passes summed over every compile (wrappers left out)')
for name, seconds in sorted(((n, s) for n, s in totals.items() if not wrapper(n)), key=lambda x: -x[1])[:top]:
    print('%8.1f s  %s' % (seconds, name[len('Total '):]))
print('\n-- the %d longest functions in the optimizer (OptFunction)' % top)
for seconds, name, short in sorted(functions_opt, reverse=True)[:top]:
    print('%7.2f s  %-60s %s' % (seconds, name[:60], short))
print('\n-- the %d longest functions in code generation (CodeGen Function)' % top)
for seconds, name, short in sorted(functions_codegen, reverse=True)[:top]:
    print('%7.2f s  %-60s %s' % (seconds, name[:60], short))
print('\n-- the %d costliest (pass, function or detail) pairs' % top)
for (name, detail), seconds in sorted(passes_by_function.items(), key=lambda x: -x[1])[:top]:
    print('%7.2f s  %-28s %s' % (seconds, name[:28], detail[:90]))
print('\n-- headers by inclusive parse time summed over compiles (top %d)' % top)
for detail, seconds in sorted(sources.items(), key=lambda x: -x[1])[:top]:
    print('%7.2f s  %s' % (seconds, detail[-100:]))
