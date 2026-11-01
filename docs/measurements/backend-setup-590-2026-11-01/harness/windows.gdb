set pagination off
set breakpoint pending on
set print thread-events off
break check_lower_prepare
run
python
import gdb, struct
pid = gdb.selected_inferior().pid
huge = 2 << 20
# The anonymous mappings of .bss: from the executable's last mapping up to the heap.
ranges = []
for line in open("/proc/%d/maps" % pid):
    parts = line.split()
    lo, hi = (int(x, 16) for x in parts[0].split("-"))
    if hi < 0x100000000 and len(parts) < 6 and "rw" in parts[1]:
        ranges.append((lo, hi))
with open("/proc/%d/pagemap" % pid, "rb") as pagemap:
    for lo, hi in ranges:
        window = lo & ~(huge - 1)
        while window < hi:
            first = max(window, lo)
            last = min(window + huge, hi)
            pagemap.seek((first // 4096) * 8)
            entries = pagemap.read(((last - first) // 4096) * 8)
            present = sum(1 for i in range(0, len(entries), 8) if struct.unpack("<Q", entries[i:i + 8])[0] >> 63)
            if present:
                print("WINDOW %#x present %d of %d" % (window, present, (last - first) // 4096))
            window += huge
end
kill
quit
