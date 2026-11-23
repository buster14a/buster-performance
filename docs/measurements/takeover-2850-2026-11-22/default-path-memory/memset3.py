# memset3.py: under gdb, each large memset's size, fill byte, caller and line, and how many of its range's base pages
# were NOT resident before it (read from /proc/PID/pagemap: bit 63 present, bit 62 swapped), which on anonymous memory
# means the kernel gives them zeroed at their first write.
import gdb, struct
rows = []
def absent_pages(pid, address, size):
    first = address >> 12; last = (address + size - 1) >> 12
    count = last - first + 1
    with open(f'/proc/{pid}/pagemap', 'rb') as f:
        f.seek(first * 8)
        data = f.read(count * 8)
    absent = 0
    for (entry,) in struct.iter_unpack('<Q', data):
        if not (entry >> 63) & 1 and not (entry >> 62) & 1: absent += 1
    return absent, count
class M(gdb.Breakpoint):
    def stop(self):
        size = int(gdb.parse_and_eval('$rdx'))
        if size < 16384: return False
        fill = int(gdb.parse_and_eval('$rsi')) & 255
        address = int(gdb.parse_and_eval('$rdi'))
        caller = gdb.newest_frame().older()
        name = caller.name() if caller is not None else '?'
        line = caller.find_sal().line if caller is not None else 0
        absent, count = absent_pages(gdb.selected_inferior().pid, address, size)
        print('MEMSET', size, fill, address, name, line, absent, count)
        return False
M('__memset_avx512_unaligned_erms')
gdb.execute('run')
