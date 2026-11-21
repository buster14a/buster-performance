#!/usr/bin/env python3
# genc.py SEED OUTDIR: freestanding C units whose string literals end one another, printed through a write syscall,
# for gcc/clang -fno-pic -O2 (absolute 32-bit references, which the merge consumer supports).
import os
import random
import sys

seed = int(sys.argv[1])
out = sys.argv[2]
rng = random.Random(seed)
os.makedirs(out, exist_ok=True)
alpha = "abc"[: rng.randint(1, 3)]


def rs(n):
    return "".join(rng.choice(alpha) for _ in range(n))


pool = []
tail = rs(rng.randint(8, 40))
for _ in range(rng.randint(10, 120)):
    k = rng.random()
    if pool and k < 0.3:
        s = rng.choice(pool)
        s = s[len(s) - rng.randint(0, len(s)):]
    elif pool and k < 0.55:
        s = rs(rng.randint(1, 10)) + rng.choice(pool)
    elif pool and k < 0.65:
        s = rng.choice(pool)
    elif k < 0.8:
        s = rs(rng.randint(0, 20)) + tail[len(tail) - rng.randint(1, len(tail)):]
    else:
        s = rs(rng.choice([rng.randint(0, 9), rng.randint(9, 40), rng.randint(40, 120)]))
    pool.append(s[:200])

units = rng.randint(2, 4)
expected = []
for u in range(units):
    lines = [
        "static long sys_write(long fd, const void* p, long n) { long r; __asm__ volatile(\"syscall\" : \"=a\"(r) : \"a\"(1L), \"D\"(fd), \"S\"(p), \"d\"(n) : \"rcx\", \"r11\", \"memory\"); return r; }",
        "static void put(const char* s) { long n = 0; while (s[n]) n++; sys_write(1, s, n); sys_write(1, \"\\n\", 1); }",
    ]
    if rng.random() < 0.5:
        lines.append("static void putw(const unsigned short* s) { long n = 0; while (s[n]) n++; sys_write(1, s, 2 * n); sys_write(1, \"\\n\", 1); }")
        wide = True
    else:
        wide = False
    lines.append(f"void unit_{u}(void) {{")
    for i in range(rng.randint(5, 60)):
        s = rng.choice(pool)
        if wide and rng.random() < 0.2:
            lines.append(f'    putw(u"{s}");')
            expected.append(b"".join(bytes([ord(c), 0]) for c in s) + b"\n")
        else:
            lines.append(f'    put("{s}");')
            expected.append(s.encode() + b"\n")
    lines.append("}")
    with open(os.path.join(out, f"u{u}.c"), "w") as f:
        f.write("\n".join(lines) + "\n")
main = [f"void unit_{u}(void);" for u in range(units)]
main.append("void _start(void) {")
main += [f"    unit_{u}();" for u in range(units)]
main.append("    __asm__ volatile(\"syscall\" :: \"a\"(60L), \"D\"(0L));")
main.append("    __builtin_unreachable();")
main.append("}")
with open(os.path.join(out, "main.c"), "w") as f:
    f.write("\n".join(main) + "\n")
with open(os.path.join(out, "expected.bin"), "wb") as f:
    f.write(b"".join(expected))
with open(os.path.join(out, "units.txt"), "w") as f:
    f.write(" ".join(f"u{u}" for u in range(units)) + "\n")
