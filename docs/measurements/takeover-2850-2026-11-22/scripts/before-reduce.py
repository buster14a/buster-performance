#!/usr/bin/env python3
# before-reduce.py DIR: the same comparison made before the walk, summed over each report's units in DIR/{default,g,wall}/
# {sqlite,lua,main,musl}.txt: the bodies' entries from the tapes kept before the walk (whole there, attempted, the lowered
# function's, differing, left out by reason, and those the program dropped a range of) and the controls' twin from the
# tokens (attempted, its controls, the program's, differing, left out by reason).
import sys, re, collections, os
d = sys.argv[1]
for flags in ('default', 'g', 'wall'):
    for corpus in ('sqlite', 'lua', 'main', 'musl'):
        path = os.path.join(d, flags, corpus + '.txt')
        k = collections.Counter(); kl = collections.Counter(); t = collections.Counter(); tl = collections.Counter()
        for line in open(path):
            m = re.search(r"bodies before the walk lowered=(\d+) \(tokens (\d+)\) the-machine-takes-every-root-of=(\d+) \(tokens (\d+), [\d.]+%\) attempted=(\d+) \(tokens (\d+), [\d.]+%; entries (\d+)\) same=(\d+) different=(\d+)", line)
            if m:
                for name, v in zip(('lowered', 'tokens', 'whole', 'whole_tokens', 'attempted', 'attempted_tokens', 'entries', 'same', 'different'), m.groups()):
                    k[name] += int(v)
            m = re.search(r"bodies before the walk left out, by the first reason:(.*)", line)
            if m:
                for name, n in re.findall(r" (\S+)=(\d+) \(tokens", m.group(1)):
                    kl[name] += int(n)
            m = re.search(r"dropped a range of=(\d+) attempted-there=(\d+)", line)
            if m:
                k['dropped'] += int(m.group(1)); k['dropped_attempted'] += int(m.group(2))
            m = re.search(r"controls from the tokens: attempted=(\d+) \(tokens (\d+), [\d.]+%; controls (\d+)\) same=(\d+) different=(\d+) left out:(.*)", line)
            if m:
                for name, v in zip(('attempted', 'attempted_tokens', 'controls', 'same', 'different'), m.groups()[:5]):
                    t[name] += int(v)
                for name, n in re.findall(r" (\S+)=(\d+) \(tokens", m.group(6)):
                    tl[name] += int(n)
        share = lambda a: 100.0 * a / k['tokens'] if k['tokens'] else 0.0
        print(f"{flags} {corpus}: kept tapes: whole before the walk {k['whole']} ({share(k['whole_tokens']):.2f}% of the body tokens), attempted {k['attempted']} ({share(k['attempted_tokens']):.2f}%), "
              f"entries {k['entries']}, the lowered function's {k['same']}, differ {k['different']}, the program dropped a range of {k['dropped']} (attempted there {k['dropped_attempted']}); left out {dict(kl)}")
        print(f"{flags} {corpus}: the controls' twin: attempted {t['attempted']} ({share(t['attempted_tokens']):.2f}%), controls {t['controls']}, the program's {t['same']}, differ {t['different']}; left out {dict(tl)}")
