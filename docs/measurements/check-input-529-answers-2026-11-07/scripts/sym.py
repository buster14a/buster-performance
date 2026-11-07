import sys, subprocess, collections
# usage: sym.py FUNCTION [N], in a directory with `compiler`, `samples.txt` (perf script -F ip,sym,symoff,dso) and
# `user.txt` (its compiler samples: ip and sym+offset): FUNCTION's samples by their inlined frames and lines
# (llvm-symbolizer --inlining), as shares of all of samples.txt's samples.
func = sys.argv[1]; top = int(sys.argv[2]) if len(sys.argv) > 2 else 40
addrs = []
for line in open('user.txt'):
    ip, sym = line.split()
    if sym.split('+')[0] == func:
        addrs.append(ip)
total = sum(1 for _ in open('samples.txt'))
inp = '\n'.join('0x' + a for a in addrs) + '\n'
out = subprocess.run(['llvm-symbolizer', '--obj=compiler', '--inlining', '--relative-address', '--functions=linkage', '-C', '--no-demangle'], input=inp, capture_output=True, text=True).stdout
blocks = out.strip('\n').split('\n\n')
leaf = collections.Counter(); inl = collections.Counter(); outer = collections.Counter()
for b in blocks:
    lines = b.strip().split('\n')
    frames = [(lines[i], lines[i+1].rsplit('/',1)[-1]) for i in range(0, len(lines)-1, 2)]
    if not frames: continue
    leaf[frames[0][0] + ' ' + frames[0][1].rsplit(':',1)[0]] += 1
    # the outermost call site inside func: frame just below func
    names = [f[0] for f in frames]
    inl[frames[0][0]] += 1
    # outermost frame whose caller is func
    if len(frames) >= 2:
        outer[frames[-2][0] + ' @' + frames[-1][1].rsplit(':',1)[0]] += 1
    else:
        outer['(own) ' + frames[0][1].rsplit(':',1)[0]] += 1
n = len(addrs)
print(f'{func}: {n} samples ({100*n/total:.2f}% of all samples)')
print('-- by first-level inlined callee / own line')
for k, v in outer.most_common(top): print(f'{v:6d} {100*v/total:5.2f}%  {k}')
print('-- by leaf function')
for k, v in inl.most_common(15): print(f'{v:6d} {100*v/total:5.2f}%  {k}')
print('-- by leaf line')
for k, v in leaf.most_common(top): print(f'{v:6d} {100*v/total:5.2f}%  {k}')
