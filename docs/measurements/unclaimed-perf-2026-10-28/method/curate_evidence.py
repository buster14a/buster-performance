# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Original archival adapter: copy bounded text evidence and record every source identity.
from pathlib import Path
import csv,hashlib,shutil
root=Path('/home/david/Documents/Codex/2026-10-28/solv')
dest=root/'work/buster-performance/docs/measurements/unclaimed-perf-2026-10-28'
extensions={'.md','.log','.txt','.tsv','.csv','.json','.sha256','.patch','.sh','.c','.h','.inc','.asm'}
for issue in ('590','636','641','649','652','657','658','664','674'):
    source=root/'work'/('evidence-'+issue)
    target=dest/('issue-'+issue)
    target.mkdir(parents=True,exist_ok=True)
    manifest=[]
    for file in sorted(source.rglob('*')):
        if not file.is_file() or file.is_symlink(): continue
        relative=file.relative_to(source)
        data=file.read_bytes()
        try:
            data.decode('utf-8')
            selected=b'\0' not in data and len(data)<=5*1024*1024
        except UnicodeDecodeError:
            selected=False
        if selected:
            output=target/relative
            output.parent.mkdir(parents=True,exist_ok=True)
            shutil.copy2(file,output)
        manifest.append((relative.as_posix(),len(data),hashlib.sha256(data).hexdigest(),'copied-text' if selected else 'retained-local-raw'))
    with (target/'COLLECTION.tsv').open('w',newline='') as stream:
        writer=csv.writer(stream,delimiter='\t',lineterminator='\n')
        writer.writerow(('source_path','bytes','sha256','disposition'))
        writer.writerows(manifest)
    print(issue,len(manifest),sum(x[1] for x in manifest if x[3]=='copied-text'))
shutil.copy2(root/'work/campaign/curate_evidence.py',dest/'method/curate_evidence.py')
