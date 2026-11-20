from pathlib import Path
from collections import Counter
import re
import struct
root=Path(__file__).resolve().parent
names=[]
for f in re.findall(r'\{"([a-z0-9]+)",', (root/'check.c').read_text()):
    names.extend([(f,64),(f+'f',32)])
names.extend([('pow',64),('powf',32),('catan.re',64),('catan.im',64),('catanf.re',32),('catanf.im',32)])
base=(root/'parent.bin').read_bytes()
head=(root/'candidate.bin').read_bytes()
oracle=(root/'clang.bin').read_bytes()
assert len(base)==len(oracle)==len(head)==len(names)*4*4096*12
def is_nan(raw,bits):
    frac=52 if bits==64 else 23
    exp=(1<<(bits-frac-1))-1
    return ((raw >> frac)&exp)==exp and raw&((1<<frac)-1)!=0
def ordered(raw,bits):
    sign=1<<(bits-1)
    return ((1<<bits)-1)-raw if raw&sign else sign+raw
with (root/'comparison.tsv').open('w') as out:
    out.write('function\tprecision\tobservations\tparent_candidate_differences\tparent_clang_result_differences\tboth_nan_different_payload\tfinite_or_infinite_differences\tmax_distance_in_representable_values_for_finite_pairs\tparent_clang_flag_differences\n')
    for number,(name,bits) in enumerate(names):
        counts=Counter()
        max_ulp=0
        for index in range(number,len(base)//12,len(names)):
            offset=index*12
            a,af=struct.unpack_from('<QI',base,offset)
            b,bf=struct.unpack_from('<QI',oracle,offset)
            counts['head']+=base[offset:offset+12]!=head[offset:offset+12]
            counts['flags']+=af!=bf
            if a!=b:
                counts['result']+=1
                if is_nan(a,bits) and is_nan(b,bits):
                    counts['nan']+=1
                else:
                    counts['other']+=1
                    frac=52 if bits==64 else 23
                    exp=(1<<(bits-frac-1))-1
                    if ((a>>frac)&exp)!=exp and ((b>>frac)&exp)!=exp:
                        max_ulp=max(max_ulp,abs(ordered(a,bits)-ordered(b,bits)))
        print(name,bits,4*4096,counts['head'],counts['result'],counts['nan'],counts['other'],max_ulp,counts['flags'],sep='\t',file=out)
