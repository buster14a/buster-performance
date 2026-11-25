#!/usr/bin/env python3
# syms.py OBJECT: one line a symbol: name, binding, type, visibility and section name (UND for undefined), sorted;
# function-local statics (LOCAL OBJECT), .L names, FILE and SECTION symbols left out.
import struct, sys
data = open(sys.argv[1], 'rb').read()
shoff, = struct.unpack_from('<Q', data, 0x28)
shentsize, shnum, shstrndx = struct.unpack_from('<HHH', data, 0x3a)
secs = [struct.unpack_from('<IIQQQQIIQQ', data, shoff + i * shentsize) for i in range(shnum)]
def cstr(off):
    return data[off:data.index(b'\0', off)].decode('latin-1')
shstr = secs[shstrndx][4]
names = [cstr(shstr + s[0]) for s in secs]
out = []
for s in secs:
    if s[1] != 2:  # SHT_SYMTAB
        continue
    strtab = secs[s[6]][4]
    for k in range(1, s[5] // 24):
        st_name, st_info, st_other, st_shndx, st_value, st_size = struct.unpack_from('<IBBHQQ', data, s[4] + k * 24)
        name = cstr(strtab + st_name)
        bind = ['LOCAL', 'GLOBAL', 'WEAK'][st_info >> 4] if (st_info >> 4) < 3 else str(st_info >> 4)
        typ = ['NOTYPE', 'OBJECT', 'FUNC', 'SECTION', 'FILE'][st_info & 15] if (st_info & 15) < 5 else str(st_info & 15)
        vis = ['DEFAULT', 'INTERNAL', 'HIDDEN', 'PROTECTED'][st_other & 3]
        if typ in ('FILE', 'SECTION') or name.startswith('.L') or name == '' or (bind == 'LOCAL' and typ != 'FUNC'):
            continue
        sec = 'UND' if st_shndx == 0 else 'COM' if st_shndx == 0xfff2 else 'ABS' if st_shndx == 0xfff1 else names[st_shndx]
        typ = '-' if sec == 'UND' else typ
        out.append(f'{name} {bind} {typ} {vis} {sec}')
print('\n'.join(sorted(out)))
