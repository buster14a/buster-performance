#!/bin/sh
# hot.sh's samples by address: the executed code's distinct 4 KB pages and 64 KB windows, and the functions that
# hold the samples (by address, so a static function's copies count apart), with their sizes; the 30 largest of them.
cd ~/buster-fast-bench/652-claude-5
C=$PWD/shifts-s3/compiler-0
perf script -i hot.data --comm compiler-0 -F ip 2>/dev/null | sort -u > hot.ips
nm -S -n $C | awk '$3 ~ /^[tTwW]$/ && NF == 4 { print $1, $2, $4 }' > hot.symbols
python3 - <<'PY'
import bisect
ips = [int(l, 16) for l in open("hot.ips") if l.strip()]
syms = []
for l in open("hot.symbols"):
    a, s, n = l.split()
    syms.append((int(a, 16), int(s, 16), n))
starts = [s[0] for s in syms]
text = [ip for ip in ips if ip < 0x7f0000000000]
pages = {ip >> 12 for ip in text}
windows = {ip >> 16 for ip in text}
hit = {}
for ip in text:
    i = bisect.bisect_right(starts, ip) - 1
    if i >= 0 and syms[i][0] <= ip < syms[i][0] + syms[i][1]:
        hit[syms[i][0]] = syms[i]
total = sum(s[1] for s in hit.values())
print(f"{len(text)} distinct sampled addresses: {len(pages)} pages of 4 KB, {len(windows)} windows of 64 KB")
print(f"{len(hit)} functions hold them, {total // 1024} KB in all")
for a, s, n in sorted(hit.values(), key=lambda x: -x[1])[:30]:
    used = len({ip >> 12 for ip in text if a <= ip < a + s})
    print(f"  {s // 1024:6d} KB {used:4d} pages sampled  {n}")
PY
