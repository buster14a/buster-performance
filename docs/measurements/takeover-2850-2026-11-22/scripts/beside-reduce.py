#!/usr/bin/env python3
# beside-reduce.py REPORT...: the bodies' comparisons summed over a report's units: after the pipeline and before the walk
# (attempted, differing), the controls' twin, the return flow's proof, the plain locals and their taken addresses, and
# the tapes' named objects against the program's references.
import sys, re
for path in sys.argv[1:]:
    k = {}
    def add(n, v): k[n] = k.get(n, 0) + int(v)
    for line in open(path):
        m = re.search(r"node-shadow: bodies lowered=\d+ .* attempted=(\d+) .* same=(\d+) different=(\d+)", line)
        if m: add('after', m.group(1)); add('after_differ', m.group(3))
        m = re.search(r"bodies before the walk lowered=\d+ .* attempted=(\d+) .* same=(\d+) different=(\d+)", line)
        if m: add('before', m.group(1)); add('before_differ', m.group(3))
        m = re.search(r"controls from the tokens: attempted=(\d+) .* same=(\d+) different=(\d+)", line)
        if m: add('twin', m.group(1)); add('twin_differ', m.group(3))
        m = re.search(r"silence proved for=(\d+) .*the program warns of=(\d+) proved-silent-and-warned-of=(\d+)", line)
        if m: add('flow', m.group(1)); add('flow_loud', m.group(2)); add('flow_unsound', m.group(3))
        m = re.search(r"node-shadow: bodies the attempted bodies' plain locals=(\d+) their address taken=(\d+)", line)
        if m: add('locals_after', m.group(1)); add('addressed_after', m.group(2))
        m = re.search(r"bodies before the walk the attempted bodies' plain locals=(\d+) their address taken=(\d+)", line)
        if m: add('locals_before', m.group(1)); add('addressed_before', m.group(2))
        m = re.search(r"references: the tapes' named objects the program's references of the body=(\d+) with-an-object-the-program-does-not-list=(\d+) \(objects (\d+)\) with-a-reference-no-tape-names=(\d+) \(references (\d+)\)", line)
        if m: add('refs_same', m.group(1)); add('refs_more', m.group(2)); add('refs_extra', m.group(3)); add('refs_fewer', m.group(4)); add('refs_missing', m.group(5))
        m = re.search(r"dropped a range of=(\d+) attempted-there=(\d+)", line)
        if m: add('dropped', m.group(1)); add('dropped_attempted', m.group(2))
        m = re.search(r"bodies before the walk lowered=(\d+) \(tokens (\d+)\) the-machine-takes-every-root-of=(\d+) \(tokens (\d+),.* attempted=\d+ \(tokens (\d+),", line)
        if m: add('lowered', m.group(1)); add('lowered_tokens', m.group(2)); add('whole', m.group(3)); add('whole_tokens', m.group(4)); add('before_tokens', m.group(5))
        m = re.search(r"the statement controls' path taken in units=(\d+) not-taken-in=(\d+)", line)
        if m: add('path_units', m.group(1)); add('path_without', m.group(2))
        m = re.search(r"a producer of these: .* sweeps=(\d+) \(tokens (\d+),.* takes=(\d+) \(tokens (\d+),", line)
        if m: add('swept', m.group(1)); add('swept_tokens', m.group(2)); add('taken', m.group(3)); add('taken_tokens', m.group(4))
    print(path)
    print("  " + " ".join(f"{n}={v}" for n, v in k.items()))
    if k.get('lowered_tokens'):
        t = k['lowered_tokens']
        print("  of the lowered bodies' tokens: whole %.2f%% attempted-before %.2f%% swept %.2f%% taken %.2f%%" % (
            100.0 * k.get('whole_tokens', 0) / t, 100.0 * k.get('before_tokens', 0) / t, 100.0 * k.get('swept_tokens', 0) / t, 100.0 * k.get('taken_tokens', 0) / t))
