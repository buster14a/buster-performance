# pm.py PID EXE: per allocated section of EXE, pages present and pages written (anonymous: COW'd) at this moment.
import sys, struct, subprocess
pid, exe = int(sys.argv[1]), sys.argv[2]
secs = []
for line in subprocess.run(["readelf", "-SW", exe], capture_output=True, text=True).stdout.splitlines():
    p = line.replace("[ ", "[").split()
    if len(p) > 7 and p[0].startswith("[") and p[1] in (".tdata", ".data.rel.ro", ".data.rel.ro.buster", ".data.rel.ro.buster", ".got", ".data", "buster_baked", ".got.plt", ".bss", ".init_array", ".rodata", ".relro_padding"):
        secs.append((p[1], int(p[3], 16), int(p[5], 16)))
f = open(f"/proc/{pid}/pagemap", "rb")
for name, addr, size in secs:
    first, last = addr >> 12, (addr + size + 4095) >> 12
    f.seek(first * 8); data = f.read((last - first) * 8)
    present = written = 0; wpages = []
    for i in range(last - first):
        (e,) = struct.unpack_from("<Q", data, i * 8)
        if e >> 63 & 1:
            present += 1
            if not (e >> 61 & 1):
                written += 1; wpages.append(first + i)
    print(f"{name:22s} pages {last-first:6d} present {present:5d} written {written:4d}", " ".join(hex(p << 12) for p in wpages[:40]))
