import struct, sys
def sections(path):
    data = open(path, 'rb').read()
    shoff, = struct.unpack_from('<Q', data, 0x28)
    shentsize, shnum, shstrndx = struct.unpack_from('<HHH', data, 0x3a)
    heads = [struct.unpack_from('<IIQQQQIIQQ', data, shoff + i * shentsize) for i in range(shnum)]
    strtab = heads[shstrndx]
    names = data[strtab[4]:strtab[4] + strtab[5]]
    out = {}
    for h in heads:
        name = names[h[0]:names.index(b'\0', h[0])].decode()
        body = b'' if h[1] == 8 else data[h[4]:h[4] + h[5]]
        out[name] = (h[2], h[3], h[5], body)
    return out
a = sections(sys.argv[1]); b = sections(sys.argv[2])
same = differ = 0
for name in sorted(set(a) | set(b)):
    if name not in a or name not in b:
        print('only in one:', name); differ += 1; continue
    if a[name] != b[name]:
        print('differs: %-24s flags %x addr %x size %d/%d' % (name, a[name][0], a[name][1], a[name][2], b[name][2])); differ += 1
    else:
        same += 1
print('same', same, 'different', differ)
