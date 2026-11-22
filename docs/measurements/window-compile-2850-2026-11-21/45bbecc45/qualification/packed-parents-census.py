from pathlib import Path
import array,collections,csv
s=Path(__file__).resolve().parent
with (s/'parent-index-census.tsv').open('w',buffering=1) as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['source','representation','source-tokens','roots','foreign-parents','foreign-blocks64','foreign-tiles4096','max-foreign-per-4096','payload-bytes','full32-bytes'])
 for src in ['sqlite','main','all-cut-lanes','paren-254','paren-2060']:
  parents=array.array('I',(s/'source-depths'/('candidate-'+src+'.bin.parents')).read_bytes());n=len(parents);roots=parents.count(2**32-1);nt=(n+4095)//4096;nb=(n+63)//64
  for name in ['signed8','signed16','local4096','local65536']:
   by=collections.Counter();small=set()
   for i,p in enumerate(parents):
    if p==2**32-1:continue
    if name=='signed8':inside=-127<=p-i<=126
    elif name=='signed16':inside=-32767<=p-i<=32766
    elif name=='local4096':inside=i//4096==p//4096
    else:inside=i//65536==p//65536 and p%65536<65534
    if not inside:by[i//4096]+=1;small.add(i//64)
   # Conservative indexed exception format: every 64-row block with a foreign edge
   # retains 64 full indices. Dense input column includes root and exception codes.
   pay=(n if name=='signed8' else 2*n)+4*nb+256*len(small)
   t.writerow([src,name,n,roots,sum(by.values()),len(small),len(by),max(by.values(),default=0),pay,4*n])
