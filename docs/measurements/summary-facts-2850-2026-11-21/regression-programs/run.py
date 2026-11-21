import subprocess, sys, re, os, collections
compiler = sys.argv[1]
files = [l.strip() for l in sys.stdin if l.strip()]
key = re.compile(r'(\S*differ\S*|values wrong|failures|not-kept\S*|unkept|wrong|taken-there-and-refused-by-the-census|census-alone)=(\d+)')
counts = collections.Counter()
for f in files:
    try:
        r = subprocess.run([compiler, 'measure-node-machine', '--shadow', '--window-rows', '--passes', '0', '--list', '3'] + sys.argv[2:] + [f], capture_output=True, text=True, timeout=120)
    except subprocess.TimeoutExpired:
        counts['timeout'] += 1
        print('TIMEOUT', f)
        continue
    out = r.stdout + r.stderr
    if 'window rows expressions=' not in out:
        counts['rejected'] += 1
        continue
    if r.returncode == 0:
        counts['clean'] += 1
        continue
    sig = []
    for line in out.split('\n'):
        if line.startswith('node-shadow:'):
            head = ' '.join(line.split()[1:4])
            for k, n in key.findall(line):
                if int(n) != 0:
                    sig.append('%s/%s=%s' % (head, k, n))
    counts['found'] += 1
    print('FOUND %s status %d | %s' % (f, r.returncode, '; '.join(sig) or 'NO KEY'))
    sys.stdout.flush()
print(dict(counts))
