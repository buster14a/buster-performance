set pagination off
set breakpoint pending on
set print thread-events off
break check_lower_prepare
run
python
import gdb
pid = gdb.selected_inferior().pid
keys = ("Rss", "AnonHugePages", "FilePmdMapped", "Anonymous", "Shared_Clean", "Private_Clean", "Private_Dirty")
for line in open("/proc/%d/smaps_rollup" % pid):
    if line.split(":")[0] in keys:
        print("ROLLUP", line.strip())
region = None
for line in open("/proc/%d/smaps" % pid):
    parts = line.split()
    if "-" in parts[0] and len(parts) >= 5:
        region = parts[0] + " " + parts[1] + " " + (parts[5] if len(parts) > 5 else "[anon]")
    elif parts[0] in ("AnonHugePages:", "FilePmdMapped:") and parts[1] != "0":
        print("HUGE", region, parts[0], parts[1], "kB")
end
kill
quit
