#!/usr/bin/env python3
# parts.py RESULTS LABEL NAME PASSES FACTS: the kernel's parts on sqlite3.c from profile.sh's three profiles of LABEL
# under NAME (cycles, instructions, mispredicted branches by function), PASSES passes a run: each part's cycles,
# instructions and mispredicted branches a pass and a record of the part, the records' counts from the run FACTS (a
# facts-sqlite3-*.txt of the same setting). A profile's run makes 3 * PASSES + 2 passes of the kernel (the counted
# passes, the split ones twice a window, the first pass and the checked one).
import re, sys, os
results, label, name, passes, facts = sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]), sys.argv[5]
runs = 3 * passes + 2
periods = {'cycles': 200003, 'instructions': 400009, 'branch-misses': 1009}
samples = {}
for event in periods:
    table = {}
    for line in open(os.path.join(results, label, 'profile-%s-%s.txt' % (event, name))):
        m = re.match(r'\s*[\d.]+%\s+(\d+)\s+\[\.\]\s+(\S+)', line)
        if m:
            table[m.group(2)] = int(m.group(1))
    samples[event] = table
text = open(os.path.join(results, label, facts)).read()
def number(pattern, default=0):
    m = re.search(pattern, text)
    return int(m.group(1)) if m else default
operators = {m.group(1): int(m.group(2)) for m in re.finditer(r'node-facts: operator op=(\S+) records=(\d+)', text)}
lookups = {m.group(1): int(m.group(2)) for m in re.finditer(r'node-facts: lookup=(\S+) records=(\d+)', text)}
records = number(r'node-facts: variant=\w+ records=(\d+)')
identifiers = number(r'identifiers=(\d+) \(enumerators')
lines = number(r"literals' lines=(\d+)")
rows = sum(v for k, v in operators.items() if k in ('-x', '~', '+', '-', '*', '/', '%', '<<', '>>', '<', '<=', '>', '>=', '==', '!=', '&', '|', '^'))
updates = sum(v for k, v in operators.items() if k in ('++x', '--x', 'x++', 'x--', '+=', '-=', '*=', '/=', '%=', '<<=', '>>=', '&=', '|=', '^='))
other = sum(v for k, v in operators.items() if k in (',', 'sizeof', 'alignof', '?:', '+x'))
def by_rule():
    return sum(int(m.group(1)) for m in re.finditer(r'node-facts: operator op=\S+ records=\d+ left=\d+ \([\d.]+%\) by-rule=(\d+)', text))
parts = [
    ('the lists, the classes and the dispatch, a record of the window', ['node_facts_window'], records),
    ('a leaf: its line\'s load and its record\'s store', ['node_facts_leaves', 'node_facts_leaves_lean'], identifiers + lines),
    ('`->`', ['node_facts_arrows', 'node_facts_arrows_lean'], lookups.get('->', 0)),
    ('`.`', ['node_facts_dots', 'node_facts_dots_lean'], lookups.get('.', 0)),
    ('`*`', ['node_facts_dereferences', 'node_facts_dereferences_lean'], lookups.get('*', 0)),
    ('a subscript', ['node_facts_subscripts', 'node_facts_subscripts_lean'], lookups.get('[]', 0)),
    ('a call', ['node_facts_calls', 'node_facts_calls_lean'], lookups.get('call', 0)),
    ('a discard', ['node_facts_discards'], lookups.get('discard', 0)),
    ('a row\'s operator, by the table', ['node_facts_rows_made'], rows),
    ('the rows\' operators the table doesn\'t type, each', ['node_facts_rows_rest'], 0),
    ('`=`', ['node_facts_stores'], operators.get('=', 0)),
    ('a conversion or an initialization', ['node_facts_converts'], operators.get('convert', 0) + operators.get('initialize', 0)),
    ('a condition or `!`', ['node_facts_truths'], operators.get('condition', 0) + operators.get('!', 0)),
    ('`&x`', ['node_facts_addresses_made'], operators.get('&x', 0)),
    ('a cast', ['node_facts_casts'], operators.get('cast', 0)),
    ('`&&` or `||`', ['node_facts_logics'], operators.get('&&', 0) + operators.get('||', 0)),
    ('an update', ['node_facts_updates'], updates),
    ('the rules, an operator at a time (a comma, sizeof, `?:`, a unary plus, and what a loop left)', ['node_facts_slow', 'node_facts_slow_each', 'node_facts_slow_list', 'node_facts_leave', 'node_facts_pair_fill', 'node_facts_member_fill'], 0),
]
print('runs of the kernel a profile: %d; records %d' % (runs, records))
total = {e: 0.0 for e in periods}
print('| part | of them | cycles a pass | cycles each | instructions each | mispredicted branches each |')
print('| --- | ---: | ---: | ---: | ---: | ---: |')
for title, functions, count in parts:
    per = {e: sum(samples[e].get(f, 0) for f in functions) * periods[e] / runs for e in periods}
    for e in periods:
        total[e] += per[e]
    if count:
        print('| %s | %s | %.2f M | %.1f | %.0f | %.2f |' % (title, format(count, ','), per['cycles'] / 1e6, per['cycles'] / count, per['instructions'] / count, per['branch-misses'] / count))
    else:
        print('| %s | | %.2f M | | | |' % (title, per['cycles'] / 1e6))
print('| all | | %.2f M | | %.2f M instructions | %.0f mispredicted |' % (total['cycles'] / 1e6, total['instructions'] / 1e6, total['branch-misses']))
