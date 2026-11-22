#!/usr/bin/env python3
# pairs-reduce.py REPORT...: the machine's roots before the walk against the program's controls, summed over a report's
# units: by the control's kind, the controls with an expression, those with one root, none or several at their
# expression's root's token, and those whose root's control's token is the control's; then the roots it ran on in the
# lowered bodies and those some control has.
import sys, re, collections
for path in sys.argv[1:]:
    tot = collections.OrderedDict(); roots = claimed = 0
    for line in open(path):
        if 'alone roots against' not in line:
            continue
        for name, c, one, none, several, tok in re.findall(r"(evaluate|branch|return|initialize|another)=(\d+) \(one root (\d+), none (\d+), several (\d+); its control.s token the control.s (\d+)\)", line):
            e = tot.setdefault(name, [0, 0, 0, 0, 0])
            for i, x in enumerate((c, one, none, several, tok)):
                e[i] += int(x)
        m = re.search(r"roots-it-ran-on-there=(\d+) of-them-some-control.s=(\d+)", line)
        roots += int(m.group(1)); claimed += int(m.group(2))
    print(path)
    for name, e in tot.items():
        print(f"  {name}: controls {e[0]}, one root {e[1]}, none {e[2]}, several {e[3]}, the control's token {e[4]}")
    print(f"  roots it ran on there {roots}, some control's {claimed}")
