#!/usr/bin/env python3
# census-f-table.py CENSUS.txt: the side facts' census's table for the write-ups, from census-f.py's output.
import re, sys
files, cur = [], None
for line in open(sys.argv[1]):
    m = re.match(r'== (\S+)', line)
    if m:
        cur = {'name': m.group(1)}; files.append(cur); continue
    m = re.match(r'(.*?)\s{2,}(\d+)$', line.rstrip('\n'))
    if m and cur is not None:
        cur[m.group(1).strip()] = int(m.group(2)); continue
    m = re.match(r'(by control|return facts.*?|references an expression.*?): (\{.*\})', line)
    if m and cur is not None:
        cur[m.group(1).split(' (')[0]] = eval(m.group(2))
def n(x): return format(x, ',')
names = {'sqlite': '`sqlite3.c`', 'lua': 'Lua', 'musl': 'musl', 'main': "the compiler's own source"}
print('| | ' + ' | '.join(names[f['name'].split('/')[-1].split('.')[0]] for f in files) + ' |')
print('| --- | ' + ' | '.join('---:' for f in files) + ' |')
def row(label, cell): print('| %s | %s |' % (label, ' | '.join(cell(f) for f in files)))
row('expressions the window takes whole; their records', lambda f: '%s; %s' % (n(f['taken']), n(f['records'])))
row('by their control: a statement\'s; a condition\'s; a return\'s; an initialization\'s; a switch\'s; none',
    lambda f: '; '.join(n(x) for x in (f['by control'].get('EVALUATE', 0), f['by control'].get('BRANCH_FALSE', 0) + f['by control'].get('BRANCH_TRUE', 0), f['by control'].get('RETURN', 0),
                                       f['by control'].get('INITIALIZE', 0), f['by control'].get('SWITCH', 0), f['by control'].get('none', 0))))
row('**the references the program\'s walk makes of them**', lambda f: '**%s**' % n(f['references']))
row('expressions with none; one; two; three or more', lambda f: '; '.join(n(x) for x in (f['references an expression'].get(0, 0), f['references an expression'].get(1, 0), f['references an expression'].get(2, 0),
                                                                                         sum(v for k, v in f['references an expression'].items() if k >= 3))))
row('leaves with an object; of them with a static object or a name\'s symbol; of those not evaluated',
    lambda f: '%s; %s; %s' % (n(f['leaves with an object']), n(f['leaves with a static object or a symbol']), n(f['of them not evaluated'])))
row('**expressions whose references are those leaves\' objects; references missing; extra**',
    lambda f: '**%s**; %s; %s' % (n(f['refs exact: static-flag or symbol leaves']), n(f['refs missing: static-flag or symbol leaves']), n(f['refs extra: static-flag or symbol leaves'])))
row('the same by a name\'s symbol alone: missing (a string literal\'s object)', lambda f: n(f['refs missing: symbol leaves']))
row('the same by the static flag alone: missing', lambda f: n(f['refs missing: static-flag leaves']))
row('calls; through a value (no declared function\'s name)', lambda f: '%s; %s' % (n(f['calls']), n(f['indirect calls'])))
row('expressions with a call of a function declared noreturn', lambda f: n(f['expressions with a call of a noreturn function']))
row('the root\'s return fact: none; a stop; an unknown; both', lambda f: '; '.join(n(f['return facts'].get(k, 0)) for k in (0, 1, 2, 3)))
row('**expressions whose fact the flow\'s rule gives on the window\'s records**', lambda f: '**%s**' % n(f['fact exact: the reduction on the records']))
row('the same by "an unknown where a call is through a value" alone', lambda f: n(f['fact exact: unknown iff an indirect call']))
row('conditions; with a known truth; of them by a constant value; by one operand of an `&&` or an `\\|\\|` alone',
    lambda f: '%s; %s; %s; %s' % (n(f['conditions']), n(f['conditions with a branch truth']), n(f['conditions with a known value']), n(f['conditions decided by an operand alone'])))
row('roots with a constant integer value and no effect; of them with a comma', lambda f: '%s; %s' % (n(f['roots with a constant integer value and no effect']), n(f['of them with a comma'])))
row('switch selectors; of them of an enumeration\'s type', lambda f: '%s; %s' % (n(f['switch selectors']), n(f.get('switch selectors of an enumeration (the kind 17)', 0))))
