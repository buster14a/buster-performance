import sys,re
src=open(sys.argv[1],'rb').read()
n=len(src)
# crude classification: comments, strings, whitespace, identifiers, numbers, punct
i=0
comment=ws=ident=num=punct=string=0
nident=nnum=npunct=nstr=ncomment=0
idlens={}
import collections
while i<n:
    c=src[i]
    if c==0x2f and i+1<n and src[i+1]==0x2a:
        j=src.find(b'*/',i+2); j=n if j<0 else j+2
        comment+=j-i; ncomment+=1; i=j
    elif c==0x2f and i+1<n and src[i+1]==0x2f:
        j=src.find(b'\n',i); j=n if j<0 else j
        comment+=j-i; ncomment+=1; i=j
    elif c in b' \t\r\n\f\v':
        ws+=1; i+=1
    elif c==0x22 or c==0x27:
        j=i+1
        while j<n and src[j]!=c:
            if src[j]==0x5c: j+=1
            j+=1
        j+=1
        string+=j-i; nstr+=1; i=j
    elif (c|0x20)>=0x61 and (c|0x20)<=0x7a or c==0x5f:
        j=i+1
        while j<n and (chr(src[j]).isalnum() or src[j]==0x5f): j+=1
        ident+=j-i; nident+=1; idlens[j-i]=idlens.get(j-i,0)+1; i=j
    elif 0x30<=c<=0x39:
        j=i+1
        while j<n and (chr(src[j]).isalnum() or src[j] in b'._'): j+=1
        num+=j-i; nnum+=1; i=j
    else:
        punct+=1; npunct+=1; i+=1
print("bytes",n)
for k,v in [("comment",comment),("ws",ws),("ident",ident),("num",num),("punct",punct),("string",string)]:
    print(f"{k:8} {v:9} {100*v/n:5.1f}%")
print("counts: comments",ncomment,"idents",nident,"nums",nnum,"punct chars",npunct,"strings",nstr)
tot=sum(idlens.values()); acc=0
for L in sorted(idlens):
    acc+=idlens[L]
    if L in (1,2,4,8,12,16,20,24,32): print("ident len<=",L,f"{100*acc/tot:.1f}%")
print("lines",src.count(b'\n'))
