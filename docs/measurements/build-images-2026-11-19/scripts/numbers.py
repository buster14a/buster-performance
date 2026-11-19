# Prints the figures the README and the design quote, from the saved 9700X tables and the cloud census outputs.
# Usage: python3 -I scripts/numbers.py RECORD_DIR
import sys, os, re
d = sys.argv[1]
def table(path):
    rows = {}
    for line in open(path):
        f = line.split()
        if len(f) == 7 and f[1].isdigit():
            rows[f[0]] = dict(n=int(f[1]), ms=float(f[2]), user=float(f[3]), kern=float(f[4]), instr=float(f[5]), faults=float(f[6]))
    return rows
j1 = table(os.path.join(d, 'results/9700x/job1-20261119T203715/table.txt'))
j2 = {}
for line in open(os.path.join(d, 'results/9700x/job2-20261119T204248/table.txt')):
    f = line.split()
    if len(f) == 7 and f[1].isdigit():
        j2[f[0]] = dict(user=float(f[3]), kern=float(f[4]))
units = 1336; tokens = 5039561; source = 1464170
def tot(r): return r['user'] + r['kern']
print("musl on the 9700X, M cycles user+kernel; a unit; a token; GHz by task-clock")
for k in ('musl-process-orig', 'musl-orig-1', 'musl-red-1', 'musl-empty-1', 'musl-process-red', 'musl-orig-4', 'musl-red-4'):
    r = j1[k]; t = tot(r)
    print(f"  {k:18} {t:8.1f} M  {t*1e6/units/1e6:6.3f} M a unit  {t*1e6/tokens:7.1f} a token  {t/r['ms']:5.2f} GHz  {r['instr']:8.1f} M user instr")
for k in ('musl-orig-8', 'musl-red-8'):
    print(f"  {k:18} {j2[k]['user']+j2[k]['kern']:8.1f} M (job 2)")
po, o1, r1, e1, pr = (tot(j1[k]) for k in ('musl-process-orig', 'musl-orig-1', 'musl-red-1', 'musl-empty-1', 'musl-process-red'))
print(f"a process's cost a unit (process - command): {(po - o1)/units:.3f} M")
print(f"headers' work a unit (command - reduced): {(o1 - r1)/units:.3f} M; ratio command/reduced {o1/r1:.2f}; user instructions {j1['musl-orig-1']['instr']/j1['musl-red-1']['instr']:.2f}")
print(f"own + reached a unit (reduced - empty): {(r1 - e1)/units:.3f} M")
print(f"empty unit: {e1/units*1e3:.0f} K (user {j1['musl-empty-1']['user']/units*1e3:.0f} K, kernel {j1['musl-empty-1']['kern']/units*1e3:.0f} K), faults {j1['musl-empty-1']['faults']/units:.1f} a unit")
print(f"process a unit vs command: {po/o1:.2f}; vs reduced command: {po/r1:.2f}")
ghz = o1 / j1['musl-orig-1']['ms']  # M cycles per ms = GHz
for k, t in (('process a unit', po), ('one command', o1), ('reduced command', r1)):
    sec = t / (ghz * 1e3)
    print(f"  {k}: {sec*1e3:.0f} ms at {ghz:.2f} GHz, {source/sec/1e6:.2f} MB/s of source on one core")
# #2850's 73 cycles a token, with today's process and per-unit fixed costs
c2850 = 73 * tokens / 1e6
print(f"#2850's 73 a token on musl's tokens: {c2850:.0f} M; with today's process cost: {(po - o1) + c2850 + e1:.0f} M ({po/((po - o1) + c2850 + e1):.2f}x of today's process a unit); in one command with today's unit fixed cost: {c2850 + e1:.0f} M ({o1/(c2850 + e1):.2f}x of today's command)")
print("lanes (M cycles):", {k: round(tot(v), 1) for k, v in j1.items() if k.endswith('-4')}, "inflation orig 4/1", round(tot(j1['musl-orig-4'])/o1, 2), "red 4/1", round(tot(j1['musl-red-4'])/r1, 2),
      "orig 8/1", round((j2['musl-orig-8']['user']+j2['musl-orig-8']['kern'])/(j2['musl-orig-1']['user']+j2['musl-orig-1']['kern']), 2),
      "kernel 8/1 (job 2)", round(j2['musl-orig-8']['kern']/j2['musl-orig-1']['kern'], 2), j2['musl-orig-1']['kern'], j2['musl-orig-8']['kern'])
lo, lr = tot(j1['lua-orig-1']), tot(j1['lua-red-1'])
print(f"Lua: command {lo:.1f} M, reduced {lr:.1f} M, ratio {lo/lr:.2f}; 4 lanes {tot(j1['lua-orig-4']):.1f} / {tot(j1['lua-red-4']):.1f}")
for line in open(os.path.join(d, 'results/9700x/job1-20261119T203715/spawn.txt')):
    print("spawn:", line.strip().split('/')[-1])
for line in open(os.path.join(d, 'results/9700x/job2-20261119T204248/client.txt')):
    print("client:", line.strip().split('/')[-1])
