# unseal.py IN OUT: OUT is IN with the write flag put back on the PT_LOAD that holds buster_baked (the head's sealed
# segment), the control that differs from IN by that flag alone.
import struct, sys
data = bytearray(open(sys.argv[1], "rb").read())
phoff, = struct.unpack_from("<Q", data, 0x20)
phentsize, phnum = struct.unpack_from("<HH", data, 0x36)
shoff, = struct.unpack_from("<Q", data, 0x28)
shentsize, shnum, shstrndx = struct.unpack_from("<HHH", data, 0x3a)
stroff = struct.unpack_from("<Q", data, shoff + shstrndx * shentsize + 0x18)[0]
baked = None
for i in range(shnum):
    o = shoff + i * shentsize
    name = struct.unpack_from("<I", data, o)[0]
    n = data[stroff + name:data.index(0, stroff + name)].decode()
    if n == "buster_baked":
        baked = struct.unpack_from("<Q", data, o + 0x10)[0]
done = 0
for i in range(phnum):
    o = phoff + i * phentsize
    ptype, flags = struct.unpack_from("<II", data, o)
    vaddr, = struct.unpack_from("<Q", data, o + 0x10)
    memsz, = struct.unpack_from("<Q", data, o + 0x28)
    if ptype == 1 and vaddr <= baked < vaddr + memsz:
        struct.pack_into("<I", data, o + 4, flags | 2)
        done += 1
open(sys.argv[2], "wb").write(data)
print("unsealed", done, "segment(s), flags were", flags)
