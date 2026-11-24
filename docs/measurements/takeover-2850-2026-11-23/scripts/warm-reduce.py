import glob, statistics, re, os, sys
d=sys.argv[1]; title=sys.argv[2]
def read(f):
    r={}
    for l in open(f):
        if l.startswith('#') or not l.strip(): continue
        p=l.strip().split(',')
        r[p[2]]=float(p[0])
        if p[2]=='cycles:u': r['ns']=float(p[3])
    return r
R={}
for f in sorted(glob.glob(d+'/r*.perf')):
    m=re.match(r'r(\d+)\.p(\d)\.(\w)\.perf',os.path.basename(f))
    R.setdefault(int(m.group(1)),{}).setdefault(m.group(3),[]).append(read(f))
names={'a':'main 939732da','b':'the change, no pool','p':'the change, BUSTER_ARENA_POOL'}
print(title)
print('%-32s %12s %14s %14s %16s %8s' % ('setting (14 runs, medians)','elapsed ms','user cycles M','kernel cyc M','user instr M','faults'))
for s in 'abp':
    v=[x for r in R for x in R[r][s]]
    print('%-32s %12.3f %14.3f %14.3f %16.3f %8.0f' % (names[s], statistics.median(x['ns'] for x in v)/1e6, statistics.median(x['cycles:u'] for x in v)/1e6, statistics.median(x['cycles:k'] for x in v)/1e6, statistics.median(x['instructions:u'] for x in v)/1e6, statistics.median(x['page-faults'] for x in v)))
for k,label in [('ns','elapsed ms'),('cycles:u','user cycles M'),('cycles:k','kernel cycles M'),('instructions:u','user instructions M')]:
    for s in 'bp':
        dd=[statistics.mean(x[k] for x in R[r][s])-statistics.mean(x[k] for x in R[r]['a']) for r in sorted(R)]
        print('%-20s %s less main, by round: %s | median %+.3f, %d/7 lower' % (label, 'pool' if s=='p' else 'no pool', ' '.join('%+.2f'%(x/1e6) for x in dd), statistics.median(dd)/1e6, sum(1 for x in dd if x<0)))
shas=set(open(f).read().strip() for f in glob.glob(d+'/*.sha') if not os.path.basename(f).startswith('lua'))
print('distinct (status, object, diagnostics) over every sqlite3.c run, the filled one too:', len(shas))
for key in ('cold','second'):
    x=read(d+'/%s.p.perf'%key)
    print('%s compile into the file: elapsed %.3f ms, user cycles %.3f M, kernel cycles %.3f M' % ('first' if key=='cold' else 'second', x['ns']/1e6, x['cycles:u']/1e6, x['cycles:k']/1e6))
T={}; obj={}
for f in sorted(glob.glob(d+'/lua.r*.sha')):
    m=re.match(r'lua\.r(\d)\.p(\d)\.(\w)\.sha',os.path.basename(f))
    tot=[0,0,0,0]
    for l in open(f):
        p=l.split(); vals=[float(x) for x in p[4:8]]
        for i in range(4): tot[i]+=vals[i]
        obj.setdefault(p[0],set()).add((p[1],p[2],p[3]))
    T.setdefault(m.group(3),[]).append(tot)
print("Lua's %d files, each a process, on sqlite3.c's leftovers; 3 rounds of a p p a; a pass's sums, medians of 6:" % len(obj))
for s in 'ap':
    v=T[s]
    print('  %-30s user cycles %.2f M, kernel cycles %.2f M, user instructions %.2f M, faults %.0f' % ((names[s],)+tuple(statistics.median(x[i] for x in v)/(1e6 if i<3 else 1) for i in range(4))))
print('  files whose status, object or diagnostics differ between the settings:', sum(1 for k,v in obj.items() if len(v)!=1))
