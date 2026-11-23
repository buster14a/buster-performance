# instr.py CALLGRIND_OUT EXECUTABLE FUNCTION: each instruction of FUNCTION with the times callgrind counted it (an
# instruction's Ir is its executions), from a --dump-instr=yes profile; addresses as linked.
import re, subprocess, sys
counts = {}
addr = 0
skip = False
for line in open(sys.argv[1]):
    if line.startswith("calls="):
        skip = True
        continue
    m = re.match(r"^(0x[0-9a-f]+|\+\d+|-\d+|\*)\s+(\S+)\s+(\d+)", line)
    if not m:
        continue
    p = m.group(1)
    addr = int(p, 16) if p.startswith("0x") else addr + int(p) if p[0] in "+-" else addr
    if skip:
        skip = False
        continue
    counts[addr] = counts.get(addr, 0) + int(m.group(3))
dis = subprocess.run(["objdump", "-d", "--no-show-raw-insn", f"--disassemble={sys.argv[3]}", sys.argv[2]], capture_output=True, text=True).stdout
for line in dis.splitlines():
    m = re.match(r"\s*([0-9a-f]+):\t(.*)", line)
    if m:
        a = int(m.group(1), 16)
        print(f"{counts.get(a, 0):>10} {m.group(1)}: {m.group(2)}")
