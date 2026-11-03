# Keeps only the lines benchmark-preprocessor, the repeat harness and perf record print; drops the 9700X lock's
# waiting messages (which name other sessions) and anything else.
import re, sys
own = re.compile(r'^(repeat [0-9.]+ ms|[0-9]+ files, |  (vectorized|scalar) |               |             |  per pass: |  #if and #elif: |\[ perf record: )')
for path in sys.argv[1:]:
    lines = open(path, errors='replace').read().split('\n')
    kept = [l for l in lines if own.match(l)]
    open(path, 'w').write('\n'.join(kept) + '\n')
