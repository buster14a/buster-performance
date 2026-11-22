#!/usr/bin/env python3
# window-bodies.py REPORT: from the experiment's lines (experiment-body, experiment-pop, experiment-span), the lowered
# bodies by what takes every root the lowering popped of them: the reference machine at reader time; the window's forms
# with nothing listed and every wanted record the kernel's; the same with the listed expressions too; in bodies and in
# their tokens.
import sys, collections
bodies = {}
pops = collections.defaultdict(list)
spans = {}
for line in open(sys.argv[1]):
    f = line.split()
    if not f:
        continue
    if f[0] == 'experiment-body:':
        opening = int(f[1]); closing = int(f[9])
        bodies[opening] = closing - opening + 1
    elif f[0] == 'experiment-pop:':
        pops[int(f[1])].append((int(f[2]), int(f[3])))
    elif f[0] == 'experiment-span:':
        # low high class mask kind op token count root part differs
        spans[int(f[9])] = (int(f[3]), int(f[4]), int(f[10]), int(f[8]))
total = sum(bodies.values())
def count(name, test):
    n = 0; t = 0
    for opening, tokens in bodies.items():
        if test(pops[opening]):
            n += 1; t += tokens
    print(f"{name}: bodies {n} of {len(bodies)}, tokens {t} of {total} ({100.0 * t / total:.2f}%)")
reference = lambda ps: all(taken for node, taken in ps)
def window(classes, parts, masks=None):
    def test(ps):
        for node, taken in ps:
            s = spans.get(node)
            if s is None or s[0] not in classes or s[2] not in parts or (masks is not None and s[1] & ~masks):
                return False
        return True
    return test
count("every popped root taken by the reference at reader time", reference)
count("every popped root whole on the window (any class of the tests', a record left to T or not)", window((0, 1, 2), (0, 1)))
count("... and silent (nothing listed, or listed then silent on T's records)", window((0, 1), (0, 1)))
count("... nothing listed", window((0,), (0, 1)))
count("... nothing listed and every wanted record the kernel's", window((0,), (0,)))
count("... the same, and no call, label of its own or temporary in a tape", window((0,), (0,), 8))
# What stops the bodies the reference takes whole from being the window's alone.
why = collections.Counter(); why_tokens = collections.Counter()
for opening, tokens in bodies.items():
    ps = pops[opening]
    if reference(ps) and not window((0,), (0,))(ps):
        reasons = set()
        for node, taken in ps:
            s = spans.get(node)
            reasons.add('no tape on the window' if s is None else 'listed' if s[0] == 1 else 'refused by the tests' if s[0] == 2 else 'a record left to T' if s[2] else None)
        reasons.discard(None)
        key = ' + '.join(sorted(reasons))
        why[key] += 1; why_tokens[key] += tokens
for key, n in why.most_common():
    print(f"  reference-whole bodies not the window's alone, by their roots' reasons: {key}: bodies {n}, tokens {why_tokens[key]} ({100.0 * why_tokens[key] / total:.2f}%)")
roots = sum(len(v) for v in pops.values())
on = sum(1 for v in pops.values() for node, taken in v if node in spans)
print(f"popped roots {roots}; with a whole tape on the window {on}; taken by the reference {sum(1 for v in pops.values() for node, taken in v if taken)}")
