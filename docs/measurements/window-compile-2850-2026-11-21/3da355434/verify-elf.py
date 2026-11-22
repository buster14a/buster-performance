"""Compare each window's source bytes and unresolved addresses with an independently compiled x86-64 ELF."""
import argparse
import collections
import csv
from pathlib import Path
import struct

class Object:
    def __init__(self, path):
        self.raw = path.read_bytes()
        assert self.raw.startswith(b'\x7fELF\x02\x01') and struct.unpack_from('<HH', self.raw, 16) == (1, 62)
        headers = struct.unpack_from('<Q', self.raw, 40)[0]
        stride, count = struct.unpack_from('<HH', self.raw, 58)
        self.sections = [struct.unpack_from('<IIQQQQIIQQ', self.raw, headers + stride*i) for i in range(count)]
        self.symbols = []
        self.names = collections.defaultdict(list)
        self.relocations = collections.defaultdict(dict)
        symsec, = [section for section in self.sections if section[1] == 2]
        names = self.contents(symsec[6])
        for i in range(symsec[4], symsec[4]+symsec[5], symsec[9]):
            start, info, _, section, value, size = struct.unpack_from('<IBBHQQ', self.raw, i)
            name = names[start:names.index(0, start)].decode()
            record = (name, section, value, size, info & 15)
            self.symbols.append(record)
            if name:
                self.names[name].append(record)
        for sec in self.sections:
            if sec[1] == 4:
                rels = self.relocations[sec[7]]
                for i in range(sec[4], sec[4]+sec[5], sec[9]):
                    offset, info, addend = struct.unpack_from('<QQq', self.raw, i)
                    assert offset not in rels
                    rels[offset] = (info & 0xffffffff, self.symbols[info >> 32], addend)

    def contents(self, index):
        section = self.sections[index]
        if section[1] == 8:
            return bytes(section[5])
        return self.raw[section[4]:section[4]+section[5]]

def compare(log, elf, receipt):
    obj = Object(elf)
    data = collections.defaultdict(bytearray)
    refs = collections.defaultdict(dict)
    row_counts = collections.Counter()
    previous = None
    with log.open() as source:
        for line in source:
            if line.startswith('static-data-row\t'):
                _, name, row, content = line.rstrip('\n').split('\t')
                assert name
                begin = len(data[name])
                data[name].extend(bytes.fromhex(content))
                previous = row, name, begin
                row_counts[name] += 1
            elif line.startswith('static-data-fixup\t'):
                _, row, offset, addend, kind, target = line.rstrip('\n').split('\t')
                assert previous and row == previous[0] and target
                _, name, begin = previous
                offset = begin + int(offset)
                assert offset not in refs[name]
                refs[name][offset] = int(addend), kind, target
    assert data
    checked = []
    for name, payload in data.items():
        named = [s for s in obj.names[name] if s[4] == 1]
        if len(named) != 1:
            checked.append((name, row_counts[name], len(payload), len(refs[name]), 'absent' if not named else 'ambiguous'))
            continue
        _, section, value, size, _ = named[0]
        image = obj.contents(section)[value:value + size]
        assert size >= len(payload), (name,size,len(payload))
        assert image == payload + bytes(size - len(payload)), (name, 'payload', next((i for i,(a,b) in enumerate(zip(image,payload)) if a!=b), len(payload)))
        rels = {o-value:r for o,r in obj.relocations[section].items() if value <= o < value + size}
        assert refs[name].keys() == rels.keys(), (name, set(refs[name]) ^ set(rels))
        for offset, (addend, kind, target) in refs[name].items():
            typ, (symbol, shndx, at, _, _), rela_add = rels[offset]
            assert typ == 1, (name, offset, typ)
            if kind == 'string':
                content = bytes.fromhex(target)
                start = at + rela_add - addend
                section_data = obj.contents(shndx)
                assert start >= 0 and section_data[start:start + len(content)] == content, (name, offset, target, symbol, shndx, start)
            else:
                assert kind == 'symbol'
                if shndx == 0:
                    assert target == symbol and rela_add == addend, (name, offset, target, symbol, rela_add)
                else:
                    assert any(s[1] == shndx and s[2] + addend == at + rela_add for s in obj.names[target]), (name, offset, target, symbol, rela_add)
        checked.append((name, row_counts[name], len(payload), len(rels), 'exact'))
    with receipt.open('w') as out:
        writer = csv.writer(out, delimiter='\t', lineterminator='\n')
        writer.writerow(('symbol','rows','bytes','relocations','result'))
        writer.writerows(checked)
    counts = collections.Counter(r[-1] for r in checked)
    totals = tuple(sum(r[i] for r in checked if r[-1] == 'exact') for i in (1,2,3))
    print('symbols', dict(counts), 'matched rows / bytes / relocations', *totals)
    assert totals[0]

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    for field in ('log','elf','receipt'):
        parser.add_argument(field,type=Path)
    args = parser.parse_args()
    compare(args.log,args.elf,args.receipt)
