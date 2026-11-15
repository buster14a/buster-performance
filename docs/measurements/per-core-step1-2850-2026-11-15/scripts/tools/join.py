import subprocess, collections, re, sys
hist={}
for l in open(sys.argv[1]):
    if l.startswith('#'): continue
    a,c=l.split(); hist[int(a,16)+0x200000]=int(c)
addrs=sorted(hist)
out=subprocess.run(['llvm-addr2line','-i','-f','-a','-e','build/compiler']+[hex(a) for a in addrs],capture_output=True,text=True).stdout.split('\n')
recs={}; cur=None; i=0
while i < len(out):
    l=out[i]
    if l.startswith('0x'):
        cur=int(l,16); recs[cur]=[]; i+=1; continue
    if cur is not None and l.strip():
        recs[cur].append((l.strip(), out[i+1].strip() if i+1<len(out) else '')); i+=2; continue
    i+=1
outer=collections.Counter(); total=0; entry={}
for a in addrs:
    names=[fn for fn,loc in recs.get(a,[])]
    c=hist[a]; total+=c
    # the frame under the window (or the top-level function for out-of-line callees)
    top=names[-1] if names else '?'
    if top.startswith("node_facts_window") or True:
        o = names[-2] if len(names)>=2 else 'window itself'
    else:
        o = top + ' (out of line)'
    outer[o]+=c
print("total",total)
for k,v in outer.most_common(30): print("%9d %5.1f%%  %s" % (v,100*v/total,k))
# entry counts of out-of-line functions
syms=subprocess.run("nm build/compiler | grep -E ' node_facts_(slow|leave|member_fill|window)'",shell=True,capture_output=True,text=True).stdout.split('\n')
for l in syms:
    if l.strip():
        a=int(l.split()[0],16); print(l.split()[2], "calls", hist.get(a,0))
