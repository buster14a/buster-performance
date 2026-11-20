import argparse
import csv
import hashlib
import os
from pathlib import Path
import struct
import subprocess
import sys
import tempfile

p=argparse.ArgumentParser()
p.add_argument('base',type=Path);p.add_argument('head',type=Path);p.add_argument('directory',type=Path)
p.add_argument('--debug',action='store_true');p.add_argument('--corpus',type=Path,default=Path('/home/david/dev/buster-corpus'))
a=p.parse_args()
a.base=a.base.resolve();a.head=a.head.resolve();a.directory=a.directory.resolve();a.directory.mkdir(parents=True,exist_ok=True)
musl=a.corpus/'libc/musl';gen=a.corpus/'musl-generated/obj'
dirs=[musl/'arch/x86_64',musl/'arch/generic',gen/'src/internal',musl/'src/include',musl/'src/internal',gen/'include',musl/'include']
flags=['--tier1','-O2','--lanes','1','-march=znver5','-w','-std=c99','-nostdinc','-ffreestanding','-D_XOPEN_SOURCE=700']
if a.debug: flags.append('-g')
for d in dirs:flags.extend(['-I',str(d)])
files={}
for f in sorted(musl.glob('src/*/*.c')):files.setdefault(f.name,f)
for f in sorted(musl.glob('src/*/x86_64/*.c')):files.setdefault(f.name,f)
env=dict(os.environ,SOURCE_DATE_EPOCH='1792454400')
def text_size(data):
    # ELF64 little-endian section-name index and section header entries from the object file.
    headers=struct.unpack_from('<Q',data,40)[0]
    stride,count,names=struct.unpack_from('<HHH',data,58)
    strings_offset=struct.unpack_from('<Q',data,headers+stride*names+24)[0]
    for i in range(count):
        sh=headers+i*stride; pos=strings_offset+struct.unpack_from('<I',data,sh)[0]
        if data[pos:pos+6]==b'.text\0':return struct.unpack_from('<Q',data,sh+32)[0]
    return 0
def digest(data):return hashlib.sha256(data).hexdigest()
with tempfile.TemporaryDirectory(dir=a.directory) as temp, open(a.directory/'objects.tsv','w',buffering=1) as output:
    writer=csv.writer(output,delimiter='\t',lineterminator='\n')
    writer.writerow(['source','base_status','head_status','base_digest','head_digest','base_text','head_text'])
    for file in files.values():
        outcomes=[]
        for label,exe in [('base',a.base),('head',a.head)]:
            object_path=Path(temp)/f'{label}.o'
            try:
                completed=subprocess.run([str(exe),*flags,'-c',str(file),'-o',str(object_path)],stdout=subprocess.PIPE,stderr=subprocess.STDOUT,env=env,timeout=40)
                code=completed.returncode
                data=object_path.read_bytes() if code==0 else completed.stdout
                text=text_size(data) if code==0 else 0
            except subprocess.TimeoutExpired:
                code=124;data=b'timeout';text=0
            outcomes.append((code,digest(data),text,data))
        (bc,bd,bt,ba),(hc,hd,ht,ha)=outcomes
        rel=str(file.relative_to(musl))
        writer.writerow([rel,bc,hc,bd,hd,bt,ht])
        if bc!=hc or ((bc!=0 or a.debug) and bd!=hd):
            sub=a.directory/'differences'/rel.replace('/','_');sub.mkdir(parents=True,exist_ok=True)
            for label,code,data in [('base',bc,ba),('head',hc,ha)]:
                (sub/(label+('.o' if code==0 else '.log'))).write_bytes(data)
