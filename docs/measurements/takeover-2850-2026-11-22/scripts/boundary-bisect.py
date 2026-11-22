import subprocess, sys, os, hashlib
# bisect.py COMPILER RECORDING COUNT -- ARGUMENTS...: the smallest range of supplied bodies' ordinals whose supply
# changes the object, by halving.
cc, rec, count = sys.argv[1], sys.argv[2], int(sys.argv[3])
args = sys.argv[sys.argv.index('--') + 1:]
def build(env, out):
    e = dict(os.environ); e.update(env)
    subprocess.run([cc, '--lanes', '1', '-c'] + args + ['-o', out], env=e, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return hashlib.sha256(open(out, 'rb').read()).hexdigest() if os.path.exists(out) else 'none'
plain = build({}, 'bisect-plain.o')
def fails(lo, hi):
    return build({'BUSTER_BOUNDARY_SUPPLY': rec, 'BUSTER_BOUNDARY_RANGE': f'{lo}:{hi}'}, 'bisect-try.o') != plain
lo, hi = 0, count
if not fails(lo, hi):
    print('no failure over the whole range'); sys.exit(0)
while hi - lo > 1:
    mid = (lo + hi) // 2
    if fails(lo, mid): hi = mid
    elif fails(mid, hi): lo = mid
    else:
        print(f'neither half of [{lo},{hi}) fails alone'); break
print(f'failing range: [{lo},{hi})')
