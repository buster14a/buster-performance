"""Compare the same 43 object inputs and stage-2 ELF for each source pair."""
import csv
import hashlib
from pathlib import Path
import struct

root = Path(__file__).resolve().parent
sources = (root.parent / 'integration-evidence/sources.argv').read_bytes().decode().split('\0')[:-1]
assert len(sources) == 43
pairs = [('eighteen','eighteen-control-own-stage2','eighteen-candidate-common')]
def inspect_elf(path):
    data = path.read_bytes()
    assert data[:6] == b'\x7fELF\x02\x01'
    start, = struct.unpack_from('<Q', data, 40)
    stride, count, names = struct.unpack_from('<HHH', data, 58)
    sections = [struct.unpack_from('<IIQQQQIIQQ', data, start+i*stride) for i in range(count)]
    def name(base, idx):
        return data[base+idx:data.index(0,base+idx)].decode()
    by_name = {name(sections[names][4], row[0]):row for row in sections}
    code = by_name['.text']
    text_bytes = data[code[4]:code[4]+code[5]]
    table = by_name['.symtab']
    strings = sections[table[6]][4]
    functions = {}
    for offset in range(table[4], table[4]+table[5], table[9]):
        symbol, info, _, section, address, size = struct.unpack_from('<IBBHQQ',data,offset)
        if info & 15 == 2 and section == sections.index(code):
            key = name(strings,symbol)
            # Keep identically named local functions distinguishable by ordinal when linked.
            index = 0
            while (key,index) in functions:
                index += 1
            functions[key,index] = size
    return len(data),hashlib.sha256(data).hexdigest(),len(text_bytes),hashlib.sha256(text_bytes).hexdigest(),functions
def writer(file,keys):
    file_out = (root/file).open('w')
    stream = csv.writer(file_out,delimiter='\t',lineterminator='\n')
    stream.writerow(keys.split())
    return file_out,stream
f1,objects=writer('selfhost-objects.tsv','pair source base_bytes head_bytes base_sha256 head_sha256 base_text head_text base_text_sha256 head_text_sha256 matched_functions base_function_bytes head_function_bytes smaller larger')
f2,changes=writer('selfhost-function-changes.tsv','pair source function ordinal base_bytes head_bytes delta_bytes')
f3,totals=writer('selfhost-totals.tsv','pair objects equal_objects equal_texts base_text head_text matched_functions base_function_bytes head_function_bytes smaller larger stage2_base_text stage2_head_text stage2_base_bytes stage2_head_bytes')
cache = {}
for label,base,head in pairs:
    summary = [0]*10
    for i,source in enumerate(sources+['stage2']):
        path = 'compiler' if source=='stage2' else f'unit-{i:04d}.o'
        value = []
        for d in (base,head):
            if (d,path) not in cache:
                cache[d,path] = inspect_elf(root/d/path)
            value.append(cache[d,path])
        a,b = value
        old,new = a[-1],b[-1]
        assert old.keys() == new.keys(), (label, source, len(old), len(new))
        differences = [(n,k,s,new[n,k]) for (n,k),s in old.items() if s!=new[n,k]]
        smaller = sum(y<x for _,_,x,y in differences)
        larger = len(differences)-smaller
        objects.writerow([label,source,a[0],b[0],a[1],b[1],a[2],b[2],a[3],b[3],len(old),sum(old.values()),sum(new.values()),smaller,larger])
        if source=='stage2':
            totals.writerow([label,*summary,a[2],b[2],a[0],b[0]])
        else:
            for n,k,x,y in sorted(differences):
                changes.writerow([label,source,n,k,x,y,y-x])
            summary = [x+y for x,y in zip(summary,[1,a[1]==b[1],a[3]==b[3],a[2],b[2],len(old),sum(old.values()),sum(new.values()),smaller,larger])]
for f in (f1,f2,f3):
    f.close()
