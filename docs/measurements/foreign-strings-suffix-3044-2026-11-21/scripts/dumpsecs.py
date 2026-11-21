# dumpsecs.py OUT OBJECTS...: the SHF_MERGE|SHF_STRINGS sections of ELF objects, in link order, as
# u32 count, then per section u32 group, u8 unit_log2, u8 alignment_log2, u32 size, bytes.
import struct, sys
out = sys.argv[1]
groups = {}
secs = []
for path in sys.argv[2:]:
    data = open(path, 'rb').read()
    if data[:4] != b'\x7fELF' or data[4] != 2:
        continue
    shoff = struct.unpack_from('<Q', data, 0x28)[0]
    shentsize, shnum, shstrndx = struct.unpack_from('<HHH', data, 0x3a)
    hdrs = [struct.unpack_from('<IIQQQQIIQQ', data, shoff + i * shentsize) for i in range(shnum)]
    strtab = hdrs[shstrndx]
    for h in hdrs:
        name_off, typ, flags, addr, off, size, link, info, align, entsize = h
        if typ != 1 or (flags & 0x30) != 0x30 or not (flags & 2) or entsize not in (1, 2, 4) or size == 0:
            continue
        nm = data[strtab[4] + name_off:data.index(b'\0', strtab[4] + name_off)]
        g = groups.setdefault((nm, flags, entsize), len(groups))
        a = max(align, 1)
        secs.append((g, {1: 0, 2: 1, 4: 2}[entsize], a.bit_length() - 1, data[off:off + size]))
with open(out, 'wb') as f:
    f.write(struct.pack('<I', len(secs)))
    for g, u, a, b in secs:
        f.write(struct.pack('<IBBI', g, u, a, len(b)))
        f.write(b)
print(len(secs), 'sections', len(groups), 'groups', sum(len(s[3]) for s in secs), 'bytes')
