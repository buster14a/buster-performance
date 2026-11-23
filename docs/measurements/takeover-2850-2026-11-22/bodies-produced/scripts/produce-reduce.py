#!/usr/bin/env python3
# produce-reduce.py REPORT...: the producer's verdicts summed over a report's units: the lowered bodies it has a verdict
# of, those it takes and their tokens, those in the set the bodies' comparisons give and those outside it, its kept
# controls against the program's, what it leaves by its first reason, what it leaves of that set by its reason, its
# ticks, and the bodies it left unread.
import sys, re
for path in sys.argv[1:]:
    k = {}
    leaves = {}
    missed = {}
    def add(d, n, v): d[n] = d.get(n, 0) + int(v)
    for line in open(path):
        m = re.search(r"the producer, before the walk: lowered-bodies=(\d+) it-takes=(\d+) \(tokens (\d+), [\d.]+%\) of-them-in-the-set-above=(\d+) outside-it=(\d+) its-kept-controls-the-program's=(\d+) different=(\d+)", line)
        if m:
            for n, v in zip(('bodies', 'taken', 'taken_tokens', 'in_the_set', 'outside', 'controls_same', 'controls_different'), m.groups()): add(k, n, v)
        m = re.search(r"a producer of these: .* sweeps=(\d+) \(tokens (\d+),.* takes=(\d+) \(tokens (\d+),", line)
        if m: add(k, 'set_swept', m.group(1)); add(k, 'set_swept_tokens', m.group(2)); add(k, 'set', m.group(3)); add(k, 'set_tokens', m.group(4))
        m = re.search(r"bodies before the walk lowered=(\d+) \(tokens (\d+)\)", line)
        if m: add(k, 'lowered', m.group(1)); add(k, 'lowered_tokens', m.group(2))
        m = re.search(r"bodies before the walk lowered=.* attempted=\d+ .* same=(\d+) different=(\d+)", line)
        if m: add(k, 'kept_same', m.group(1)); add(k, 'kept_different', m.group(2))
        m = re.search(r"controls from the tokens: attempted=\d+ .* same=(\d+) different=(\d+)", line)
        if m: add(k, 'twin_same', m.group(1)); add(k, 'twin_different', m.group(2))
        m = re.search(r"dropped a range of=(\d+) attempted-there=(\d+)", line)
        if m: add(k, 'dropped', m.group(1)); add(k, 'dropped_attempted', m.group(2))
        m = re.search(r"the producer's ticks: before-any-reading=(\d+) after-the-reading=(\d+) bodies-left-unread=(\d+) \(tokens (\d+)\)", line)
        if m:
            for n, v in zip(('before_ticks', 'after_ticks', 'unread', 'unread_tokens'), m.groups()): add(k, n, v)
        for tag, d in (("the producer leaves, by its first reason:", leaves), ("the producer leaves of the set above, by its reason:", missed)):
            if tag in line:
                for name, bodies, tokens in re.findall(r" ([a-z'-]+)=(\d+) \(tokens (\d+)\)", line.split(tag)[1]):
                    add(d, name, bodies); add(d, name + ' tokens', tokens)
    print(path)
    print("  " + " ".join(f"{n}={v}" for n, v in k.items()))
    if k.get('lowered_tokens'):
        print("  it takes %.2f%% of the lowered bodies' tokens; the set %.2f%%" % (100.0 * k.get('taken_tokens', 0) / k['lowered_tokens'], 100.0 * k.get('set_tokens', 0) / k['lowered_tokens']))
    print("  leaves: " + "; ".join(f"{n} {leaves[n]} ({leaves[n + ' tokens']} tokens)" for n in leaves if not n.endswith(' tokens')))
    print("  leaves of the set: " + ("; ".join(f"{n} {missed[n]} ({missed[n + ' tokens']} tokens)" for n in missed if not n.endswith(' tokens')) or "none"))
