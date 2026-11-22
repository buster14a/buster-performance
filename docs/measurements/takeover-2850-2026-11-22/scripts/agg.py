import sys, re, collections, glob
tot = collections.Counter()
files = sorted(glob.glob(sys.argv[1] + '/report-*.txt'))
for f in files:
    for line in open(f):
        m = re.match(r'\s*([\d.]+)%\s+(\d+)\s+\[(.)\]\s+(\S+)', line)
        if m:
            name = m.group(4).replace('.buster_split', '')
            tot[(m.group(3), name)] += int(m.group(2))
n = len(files)
total = sum(tot.values())
print(f'total periods {total/n/1e6:.1f} M cycles a run over {n} runs')
kern = sum(v for (k, _), v in tot.items() if k == 'k')
print(f'kernel {kern/total*100:.1f}%')
top = int(sys.argv[2]) if len(sys.argv) > 2 else 60
acc = 0
for (k, name), v in tot.most_common(top):
    acc += v
    print(f'{v/total*100:6.2f}% {acc/total*100:6.1f}%  {v/n/716136:7.2f} c/tok  [{k}] {name}')
# families
fam = collections.Counter()
rules = [('kernel', lambda k, s: k == 'k'), ('libc mem*', lambda k, s: s.startswith('__mem') or s.startswith('__str')),
         ('check_input_expression*', lambda k, s: s.startswith('check_input_expression') or s.startswith('check_literal')),
         ('check_input_* (reader)', lambda k, s: s.startswith('check_input')),
         ('check_program*/control', lambda k, s: s.startswith('check_program') or s.startswith('check_control')),
         ('warnings', lambda k, s: s.startswith('check_common') or s.startswith('check_unseq') or s.startswith('check_driver') or 'warning' in s),
         ('check_lower*', lambda k, s: s.startswith('check_lower') or s.startswith('c_lowering')),
         ('check_graph*', lambda k, s: s.startswith('check_graph')),
         ('check_action*', lambda k, s: s.startswith('check_action')),
         ('node machine/window', lambda k, s: s.startswith('node_') or 'window' in s),
         ('other check_*', lambda k, s: s.startswith('check_')),
         ('tier0/x86/emission', lambda k, s: s.startswith('tier0') or s.startswith('x86') or s.startswith('branch_sizing') or s.startswith('unwind') or s.startswith('emission') or s.startswith('object') or s.startswith('abi_')),
         ('parser', lambda k, s: s.startswith('parse')),
         ('preprocessor/lexer', lambda k, s: s.startswith('pp_') or s.startswith('c_tokenize') or s.startswith('c_lex') or s.startswith('c_intern') or s.startswith('c_refine') or s.startswith('preprocess')),
         ('bindings', lambda k, s: s.startswith('c_bindings')),
         ('types', lambda k, s: s.startswith('type_')),
         ]
for (k, name), v in tot.items():
    for label, rule in rules:
        if rule(k, name):
            fam[label] += v
            break
    else:
        fam['rest'] += v
print()
for label, v in fam.most_common():
    print(f'{v/total*100:6.2f}%  {v/n/716136:7.1f} c/tok  {v/n/5.49e6:6.2f} ms  {label}')
