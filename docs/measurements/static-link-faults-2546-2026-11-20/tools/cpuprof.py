import sys, collections
# perf script -F comm,ip,sym with -g (fp): sample header line "comm" then chain lines "\t ip sym".
# Attribute each sample to its first user frame (the user ip); count kernel vs user.
user_fn = collections.Counter()
kern_by_user = collections.Counter()
kern_fn = collections.Counter()
cur = None
def flush(chain):
    if not chain: return
    kernel = [f for f in chain if f[0].startswith('ffffffff')]
    user = [f for f in chain if not f[0].startswith('ffffffff')]
    u = user[0][1] if user else '?'
    if kernel:
        kern_by_user[u] += 1
        kern_fn[(u, kernel[0][1])] += 1
    else:
        user_fn[u] += 1
chain = []
for line in open(sys.argv[1]):
    if not line.startswith('\t') and line.strip():
        flush(chain); chain = []
        continue
    p = line.strip().split(None, 1)
    if len(p) == 2: chain.append((p[0], p[1]))
flush(chain)
pat = sys.argv[2].split(',')
sel = lambda u: any(x in u for x in pat)
tu = sum(v for k, v in user_fn.items() if sel(k)); tk = sum(v for k, v in kern_by_user.items() if sel(k))
print('selected user samples', tu, 'kernel samples', tk)
for k, v in user_fn.most_common():
    if sel(k): print(' user %5d %s' % (v, k))
for k, v in kern_by_user.most_common():
    if sel(k): print(' kern %5d %s' % (v, k))
for k, v in kern_fn.most_common(200):
    if sel(k[0]) : print(' kfn %5d %s <- %s' % (v, k[1], k[0]))
