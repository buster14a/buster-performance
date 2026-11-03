# Keeps only the lines benchmark-preprocessor prints (and the old tree's usage for the --markers it lacks); drops
# everything else, such as the 9700X lock's waiting messages, which name other sessions.
import re, sys
own = re.compile(r'^(repeat [0-9.]+ ms|[0-9]+ files, |  (vectorized|scalar) |               |             |  per pass: |  #if and #elif: |\[ perf record: |unknown argument: --markers$|usage: benchmark-preprocessor |       benchmark-preprocessor )')
for path in sys.argv[1:]:
    lines = open(path, errors='replace').read().split('\n')
    kept = [l for l in lines if own.match(l)]
    open(path, 'w').write('\n'.join(kept) + '\n')
