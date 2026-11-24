import struct, sys
for p in sys.argv[1:]:
    d = open(p, 'rb').read()
    w = struct.unpack('<19Q', d[:152])
    assert w[0] == 0xff6c70726f667281, hex(w[0])
    off = 152 + w[2] + w[3] * 72 + w[4]
    print(p, 'version', w[1], 'data', w[3], 'counters', w[5], 'sum', sum(struct.unpack('<%dQ' % w[5], d[off:off + 8 * w[5]])))
