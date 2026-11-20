import csv
import subprocess
from pathlib import Path

root = Path(__file__).resolve().parent
target = 'znver5'
kernels = ['saxpy_f32', 'dot_f32', 'matmul_f32']
with (root / 'cases.tsv').open('w') as out:
    rows = csv.writer(out,delimiter='\t',lineterminator='\n')
    rows.writerow(['kernel','mode','pad','variant','program','address','reps'])
    for mode in ['default','unroll']:
        entries = {}
        for variant in ['base','head']:
            for pad in [0,16,32,48]:
                name = f'{variant}-{target}-{mode}-p{pad}'
                table = subprocess.check_output(['nm', '--defined-only', root/'programs'/name], text=True)
                for k in kernels:
                    address = int(next(r.split()[0] for r in table.splitlines() if r.endswith(' k_'+k)),16)
                    entries[variant,pad,k] = (name, address)
        for kernel in kernels:
            for pad in [0,16,32,48]:
                modulo = entries['base',pad,kernel][1] % 64
                for variant in ['base','head']:
                    name, address = next(info for (v,p,k),info in entries.items() if v==variant and k==kernel and info[1]%64==modulo)
                    rows.writerow([kernel,mode,pad,variant,name,hex(address),4096 if kernel=='matmul_f32' else 65536])
