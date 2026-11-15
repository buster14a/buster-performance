import subprocess, collections, re, sys
hist={}
for l in open(sys.argv[1]):
    if l.startswith('#'): continue
    a,c=l.split(); hist[int(a,16)+0x200000]=int(c)
rule=sys.argv[2]; least=int(sys.argv[3])
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
A=int(subprocess.run("nm build/compiler | grep ' node_facts_window' | awk '{print $1}'",shell=True,capture_output=True,text=True).stdout.strip(),16)
SZ=int(subprocess.run("nm -S build/compiler | grep ' node_facts_window' | awk '{print $2}'",shell=True,capture_output=True,text=True).stdout.strip(),16)
d=subprocess.run(['objdump','-d','--no-show-raw-insn','--start-address=%#x'%A,'--stop-address=%#x'%(A+SZ),'build/compiler'],capture_output=True,text=True).stdout.split('\n')
ins={}
for l in d:
    m=re.match(r'\s*([0-9a-f]+):\s+(.*)$',l)
    if m: ins[int(m.group(1),16)]=m.group(2)
tot=0
for a in sorted(ins):
    c=hist.get(a,0)
    chain=recs.get(a,[])
    names=[fn for fn,loc in chain]
    o = names[-2] if len(names)>=2 else (names[-1] if names else '?')
    if (o==rule or (rule=='window' and len(names)==1)) and c>=least:
        tot+=c
        print("%x %6d %-22s %-8s %s" % (a,c,names[0][:22],chain[0][1].split(':')[-1] if chain else '',ins[a][:70]))
print("total",tot)
