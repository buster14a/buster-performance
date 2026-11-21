#!/usr/bin/env python3
# classify.py COMPILER SWEEP.tsv... [-- OPTION...]: the sweep's found programs, each run again with --list 50 and
# named by the kinds of difference its report has; a line a program (kinds, file), then the kinds' counts.
import collections, re, subprocess, sys
compiler = sys.argv[1]
rest = sys.argv[2:]
options = rest[rest.index('--') + 1:] if '--' in rest else []
sweeps = rest[:rest.index('--')] if '--' in rest else rest
KINDS = [
    ('interrupt-call', lambda t: 'UNSOUND' in t and re.search(r'event id=89 ', t)),
    ('noderef', lambda t: 'UNSOUND' in t and re.search(r'event id=88 ', t)),
    ('ordered-comparison', lambda t: 'UNSOUND' in t and re.search(r'event id=27 ', t)),
    ('diagnose-if', lambda t: 'UNSOUND' in t and re.search(r'event id=98 ', t)),
    ('declarator-event', lambda t: re.search(r'kind=initializer \(reader initializer\) reader-takes=yes UNSOUND', t)),
    ('pointer-cast', lambda t: 'UNSOUND' in t and re.search(r'event id=12[5678] ', t)),
    ('cleanup-return', lambda t: re.search(r'kind=other-control \(reader return\)', t)),
    ('brace-kind', lambda t: re.search(r'kind=initializer \(reader brace-initializer\)', t)),
    ('object-declaration', lambda t: re.search(r'object difference .* declaration=4294967295 \(program \d+\)', t)),
    ('label-kept', lambda t: re.search(r'object difference .* labelled=1 \(0\)', t)),
    ('label-missed', lambda t: re.search(r'object difference .* labelled=0 \(1\)', t)),
    ('callee-taken', lambda t: re.search(r'reader-time T difference .* refusal=callee \(reader taken\)', t)),
    ('fact-words', lambda t: re.search(r'reader-time fact words difference', t)),
    ('tape-entries', lambda t: re.search(r'node-shadow: difference .* entries=DIFFERENT', t)),
    ('tape-values', lambda t: re.search(r'node-shadow: difference .* values=DIFFERENT', t)),
    ('window-tests', lambda t: re.search(r'node-tests: window difference', t)),
    ('window-rows', lambda t: re.search(r'window rows expressions=.* differences=[1-9]', t)),
    ('summaries', lambda t: re.search(r'window summaries difference', t)),
]
counts = collections.Counter()
rows = []
for sweep in sweeps:
    for line in open(sweep):
        f = line.rstrip('\n').split('\t')
        if f[1] != 'found':
            continue
        r = subprocess.run([compiler, 'measure-node-machine', '--shadow', '--window-rows', '--passes', '0', '--list', '50'] + options + [f[0]], capture_output=True)
        text = (r.stdout + r.stderr).decode('utf-8', 'replace')
        kinds = [name for name, test in KINDS if test(text)]
        if 'UNSOUND' in text and not any(k in kinds for k in ('interrupt-call', 'noderef', 'ordered-comparison', 'diagnose-if', 'declarator-event', 'pointer-cast', 'cleanup-return')):
            kinds.append('unsound-other')
        kinds = kinds or ['unnamed']
        for k in kinds:
            counts[k] += 1
        rows.append((','.join(kinds), f[0]))
for kinds, name in sorted(rows):
    print('%s\t%s' % (kinds, name))
print('programs', len(rows))
for k, n in counts.most_common():
    print('%4d %s' % (n, k))
