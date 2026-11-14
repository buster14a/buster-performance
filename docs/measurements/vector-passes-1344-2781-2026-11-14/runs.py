import sys, re, collections
rows = []
for line in open(sys.argv[1]):
    c = int(line[:10]); a = int(line[11:19], 16); rest = line[20:]
    f = rest[:28].strip(); k = rest[29:57].strip(); t = rest[58:].strip()
    rows.append((c, a, f, k, t))
shapes = collections.Counter(); stores_by_shape = collections.Counter(); loads = 0; store_total = 0
i = 0
while i < len(rows):
    if rows[i][3] == "imm->stack store":
        j = i; vals = []; widths = []
        while j < len(rows) and rows[j][3] == "imm->stack store":
            m = re.match(r"mov\s+(\w+) PTR \[[^\]]+\],(\S+)", rows[j][4]); widths.append(m.group(1)); vals.append(m.group(2)); j += 1
        cnt = rows[i][0]
        n = j - i
        # second half after zero fill
        zero_fill = 8 if n >= 8 and all(v == "0x0" for v in vals[:8]) and all(w == "QWORD" for w in widths[:8]) else 0
        tail = vals[zero_fill:]; tw = widths[zero_fill:]
        if not tail: desc = "zero fill only"
        elif all(v == "0x0" for v in tail): desc = "zero fill + zero elements"
        elif len(set(tail)) == 1: desc = f"splat {tw[0]}"
        else: desc = f"general {tw[0]}x{len(tail)}"
        nxt = rows[j][3] if j < len(rows) else ""
        desc += " -> " + ("vector load" if nxt == "vector<-stack load" else nxt)
        shapes[(desc, n)] += cnt; stores_by_shape[(desc, n)] += cnt * n; store_total += cnt * n
        i = j
    else:
        i += 1
print("store total", store_total)
for (d, n), c in sorted(stores_by_shape.items(), key=lambda x: -x[1])[:25]:
    print(f"{c:9d} stores  {shapes[(d,n)]:7d} runs  run length {n:3d}  {d}")
