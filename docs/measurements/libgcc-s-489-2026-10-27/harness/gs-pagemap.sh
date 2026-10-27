#!/bin/bash
# On the 9700X: the C driver's hello world under gdb, stopped at exit_group: which pages of its .bss are present
# (/proc/PID/pagemap), for each tree.
B=~/buster-fast-bench
cat > $B/libgcc-s-489-pagemap.py <<'PY'
import gdb, struct
pid = gdb.selected_inferior().pid
lo = hi = 0
for line in open("/proc/%d/maps" % pid):
    parts = line.split()
    if parts[1] == "rw-p" and len(parts) == 5:
        a, b = (int(x, 16) for x in parts[0].split("-"))
        if b - a > (100 << 20) and lo == 0:
            lo, hi = a, b
out = open(gdb.parameter("args").split()[-1] + ".pages", "w")
with open("/proc/%d/pagemap" % pid, "rb") as f:
    f.seek((lo >> 12) * 8)
    data = f.read(((hi - lo) >> 12) * 8)
for i in range(len(data) // 8):
    (v,) = struct.unpack_from("<Q", data, i * 8)
    if v >> 63:
        out.write("%x\n" % (lo + (i << 12)))
PY
for d in libgcc-s-489-main libgcc-s-489-claude; do
    cd $B/$d || exit 1
    XDG_CACHE_HOME=$B/$d/proc-cache gdb -q -batch -ex 'catch syscall exit_group' -ex 'run' -ex "source $B/libgcc-s-489-pagemap.py" --args ./build/compiler $B/libgcc-s-489-hello.c -o $B/$d/pagemap-hello > $B/$d/pagemap-gdb.log 2>&1
    echo "== $d $? $(wc -l < pagemap-hello.pages)"
done
