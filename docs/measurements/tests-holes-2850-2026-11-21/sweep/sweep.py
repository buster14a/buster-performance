#!/usr/bin/env python3
# sweep.py COMPILER OUT.tsv JOBS [OPTION...] < FILES: each file through the shadow with the options
# (measure-node-machine --shadow --window-rows --passes 0 --list 3), a line of OUT.tsv a file:
#   file, verdict (rejected | clean | found | timeout | crash), status, unsound takes, the events' IDs in expressions
#   (id:option:expressions, comma-separated), and where found the lines' keys that are not zero.
import subprocess, sys, re, os, collections
from concurrent.futures import ThreadPoolExecutor
compiler, out_path, jobs = sys.argv[1], sys.argv[2], int(sys.argv[3])
options = sys.argv[4:]
files = [l.strip() for l in sys.stdin if l.strip()]
key = re.compile(r'(\S*differ\S*|values wrong|failures|not-kept\S*|unkept|wrong|taken-there-and-refused-by-the-census|census-alone)=(\d+)')
event = re.compile(r'^node-census: event id=(\d+) option=(\S+) expressions=(\d+)', re.M)
unsound = re.compile(r'taken-there-and-refused-by-the-census=(\d+)')
def one(f):
    try:
        r = subprocess.run([compiler, 'measure-node-machine', '--shadow', '--window-rows', '--passes', '0', '--list', '3'] + options + [f], capture_output=True, timeout=120)
    except subprocess.TimeoutExpired:
        return (f, 'timeout', -1, 0, '', '')
    text = (r.stdout + r.stderr).decode('utf-8', 'replace')
    events = ','.join('%s:%s:%s' % m for m in event.findall(text))
    if r.returncode < 0 or r.returncode > 1 and 'window rows expressions=' not in text and 'node-census:' not in text and r.returncode >= 128:
        return (f, 'crash', r.returncode, 0, events, text[-300:].replace('\n', ' | ').replace('\t', ' '))
    if 'window rows expressions=' not in text:
        return (f, 'rejected', r.returncode, 0, events, '')
    m = unsound.search(text)
    takes = int(m.group(1)) if m else 0
    if r.returncode == 0:
        return (f, 'clean', 0, takes, events, '')
    sig = []
    for line in text.split('\n'):
        if line.startswith('node-shadow:'):
            head = ' '.join(line.split()[1:4])
            for k, n in key.findall(line):
                if int(n) != 0:
                    sig.append('%s/%s=%s' % (head, k, n))
    return (f, 'found', r.returncode, takes, events, '; '.join(sig) or 'NO KEY')
counts = collections.Counter()
with ThreadPoolExecutor(jobs) as pool, open(out_path, 'w') as out:
    for row in pool.map(one, files):
        counts[row[1]] += 1
        out.write('\t'.join(str(x) for x in row) + '\n')
print(dict(counts))
