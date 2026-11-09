import csv,glob,sys
def med(x):
    x=sorted(x); n=len(x); return x[(n-1)//2] if n%2 else (x[n//2-1]+x[n//2])/2
def stages(pattern):
    st={}
    for f in glob.glob(pattern):
        for l in open(f):
            p=l.rstrip('\n').split('\t')
            if p[0]=='time-stage' and len(p)>2 and p[1]!='stage':
                try: st.setdefault(p[1],[]).append(float(p[2]))
                except ValueError: pass
    return st
rows=list(csv.DictReader(open('microarch/ab1340/time.tsv'),delimiter='\t'))
for label in ['main-znver5:sq-c','znver5:sq-c','main-znver5:sq-syn','znver5:sq-syn']:
    r=[x for x in rows if x['label']==label and x['status']=='0']
    st=stages('microarch/ab1340/logs/%s.r*.log'%label)
    print(label,'n=%d'%len(r),'wall=%.2f'%med([float(x['wall_ms']) for x in r]),'user=%.2f'%med([float(x['user_ms']) for x in r]),'sys=%.2f'%med([float(x['system_ms']) for x in r]),'rss=%d'%med([int(x['maxrss_kb']) for x in r]),
      ' '.join('%s=%.2f'%(k,med(st[k])) for k in ['check-input','check-expressions','check-program','lower','total'] if k in st))
for v in ['main-znver5','znver5']:
    vals={}
    for f in sorted(glob.glob('microarch/ab1340/stat/%s.sq-c.basic.r*.csv'%v)):
        for l in open(f):
            p=l.split(',')
            if len(p)>2 and p[2] in ('instructions:u','cycles:u','instructions:k','cycles:k'):
                vals.setdefault(p[2],[]).append(int(p[0]))
    print(v,' '.join('%s=%.1fM(n=%d)'%(k,med(x)/1e6,len(x)) for k,x in vals.items()))
for v in ['main','head']:
    for w in ['on','off']:
        st=stages('warnings-off/logs/%s-%s.r*.log'%(v,w))
        print(v,'warnings',w,'n=%d'%len(st.get('total',[])),' '.join('%s=%.2f'%(k,med(st[k])) for k in ['check-program','total']))
rows=list(csv.DictReader(open('microarch/ab1340-self/time.tsv'),delimiter='\t'))
for label in ['main-znver5:self-syn','znver5:self-syn']:
    r=[x for x in rows if x['label']==label]
    st=stages('microarch/ab1340-self/logs/%s.r*.log'%label)
    print(label,'wall',[x['wall_ms'] for x in r],'check-program',sorted(st['check-program']),'rss',[x['maxrss_kb'] for x in r])
