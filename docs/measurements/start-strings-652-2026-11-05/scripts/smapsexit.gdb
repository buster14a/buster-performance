set pagination off
catch syscall exit_group
run
python
import re
pid = gdb.selected_inferior().pid
cur = None
for line in open("/proc/%d/smaps" % pid):
    m = re.match(r'^([0-9a-f]+)-([0-9a-f]+) (\S+)', line)
    if m:
        cur = (m.group(1), int(m.group(2), 16) - int(m.group(1), 16), m.group(3))
        continue
    if line.startswith("AnonHugePages:"):
        kb = int(line.split()[1])
        if kb:
            print("huge %d KB in %s (%d MB, %s)" % (kb, cur[0], cur[1] >> 20, cur[2]))
end
kill
