#!/usr/bin/env python3
# genlink.py SEED OUTDIR: writes adversarial assembly objects for link-foreign --merge-strings, plus expect.txt listing
# every referenced label with its required alignment and unit, and pairs.txt listing (label, owner-label, delta) facts
# that hold under the block-head rule at alignment 1.
import os
import random
import sys

seed = int(sys.argv[1])
out = sys.argv[2]
rng = random.Random(seed)
os.makedirs(out, exist_ok=True)

alphabet = [b"a", b"b", b"c", b"\x80", b"\xff"]


def rand_str(n, alpha):
    return b"".join(rng.choice(alphabet[:alpha]) for _ in range(n))


def make_family(count, alpha):
    pool = []
    tail = rand_str(rng.randint(8, 40), alpha)
    for _ in range(count):
        k = rng.random()
        if pool and k < 0.25:
            s = rng.choice(pool)
            s = s[len(s) - rng.randint(0, len(s)):] if s else s
        elif pool and k < 0.5:
            s = rand_str(rng.randint(1, 12), alpha) + rng.choice(pool)
        elif pool and k < 0.6:
            s = rng.choice(pool)
        elif k < 0.75:
            s = rand_str(rng.randint(0, 30), alpha) + tail[len(tail) - rng.randint(1, len(tail)):]
        else:
            n = rng.choice([rng.randint(0, 9), rng.randint(5, 20), rng.randint(20, 90)])
            s = rand_str(n, alpha)
        pool.append(s[:300])
    return pool


def asm_bytes(b):
    return ", ".join(str(x) for x in b) if b else ""


objects = rng.randint(2, 5)
section_kinds = [
    (".rodata.str1.1", 1, 0),
    (".rodata.str1.8", 1, 3),
    (".rodata.str1.16", 1, 4),
    (".rodata.custom.str1.1", 1, 0),
    (".rodata.str2.2", 2, 1),
    (".rodata.str4.4", 4, 2),
]
family = make_family(rng.randint(20, 160), rng.randint(1, 3))
refs = []  # (label expression, alignment, unit, expected bytes)
label_counter = 0
for o in range(objects):
    lines = []
    nsec = rng.randint(1, 5)
    for si in range(nsec):
        name, unit, default_align = rng.choice(section_kinds)
        align_log2 = default_align if rng.random() < 0.7 else rng.randint(0, 5)
        if unit > 1 and align_log2 < unit.bit_length() - 1:
            align_log2 = unit.bit_length() - 1
        lines.append(f'.section {name},"aMS",@progbits,{unit}')
        lines.append(f".p2align {align_log2}")
        offset = 0
        pad = rng.random() < 0.4
        for i in range(rng.randint(1, 40)):
            s = rng.choice(family)
            if unit == 1:
                data = s + b"\0"
            else:
                data = b"".join((bytes([c]) + b"\0" * (unit - 1)) if rng.random() < 0.5 else (b"\0" * (unit - 1) + bytes([c])) for c in s) + b"\0" * unit
            label_counter += 1
            glob = rng.random() < 0.5
            label = f"s_{o}_{label_counter}" if glob else f".Ls_{o}_{label_counter}"
            if glob:
                lines.append(f".globl {label}")
                lines.append(f".type {label},@object")
                lines.append(f".size {label},{len(data)}")
            lines.append(f"{label}:")
            lines.append(f".byte {asm_bytes(data)}")
            eff = 1 << align_log2
            while offset % eff:
                eff //= 2
            if rng.random() < 0.8:
                # a referenced position: the start, or an interior unit
                interior = 0
                if len(s) > 0 and rng.random() < 0.2:
                    interior = rng.randint(0, len(s)) * unit
                ia = eff
                while interior % ia:
                    ia //= 2
                refs.append((f"{label}+{interior}" if interior else label, ia if interior else eff, unit, data[interior:]))
            offset += len(data)
            if pad:
                a = 1 << align_log2
                while offset % a:
                    lines.append(".byte " + ", ".join(["0"] * unit))
                    offset += unit
        # table for this object's local labels: emitted below in .data of this object
    # every object holds its own table part (local labels cannot be referenced from other objects)
    lines.append(".data")
    lines.append(".p2align 3")
    lines.append(f".globl table_{o}")
    lines.append(f"table_{o}:")
    mine = [r for r in refs if f"_{o}_" in r[0].split("+")[0]]
    for r in mine:
        lines.append(f".quad {r[0]}, {r[1] - 1}, {r[2]}")
    lines.append(f".globl table_{o}_end")
    lines.append(f"table_{o}_end:")
    with open(os.path.join(out, f"obj{o}.s"), "w") as f:
        f.write("\n".join(lines) + "\n")

main = [
    ".text",
    ".globl _start",
    "_start:",
]
for o in range(objects):
    main += [
        f"    lea table_{o}(%rip), %r12",
        f"    lea table_{o}_end(%rip), %r13",
        "    call walk",
    ]
main += [
    "    mov $60, %eax",
    "    xor %edi, %edi",
    "    syscall",
    "walk:",
    "1:  cmp %r13, %r12",
    "    jae 9f",
    "    mov (%r12), %rsi",
    "    mov 16(%r12), %r8",
    "    xor %edx, %edx",
    "2:  cmp $1, %r8",
    "    jne 21f",
    "    cmpb $0, (%rsi,%rdx)",
    "    je 3f",
    "    add $1, %rdx",
    "    jmp 2b",
    "21: cmp $2, %r8",
    "    jne 22f",
    "    cmpw $0, (%rsi,%rdx)",
    "    je 3f",
    "    add $2, %rdx",
    "    jmp 2b",
    "22: cmpl $0, (%rsi,%rdx)",
    "    je 3f",
    "    add $4, %rdx",
    "    jmp 2b",
    "3:  mov $1, %eax",
    "    mov $1, %edi",
    "    syscall",
    "    mov (%r12), %rax",
    "    and 8(%r12), %rax",
    "    setz %al",
    "    add $48, %al",
    "    mov %al, buf(%rip)",
    "    movb $10, buf+1(%rip)",
    "    mov $1, %eax",
    "    mov $1, %edi",
    "    lea buf(%rip), %rsi",
    "    mov $2, %edx",
    "    syscall",
    "    add $24, %r12",
    "    jmp 1b",
    "9:  ret",
    ".bss",
    "buf: .zero 16",
]
with open(os.path.join(out, "main.s"), "w") as f:
    f.write("\n".join(main) + "\n")

# Expected output: each reference's bytes up to its terminator unit, then '1' (aligned) and a newline.
expected = bytearray()
for o in range(objects):
    for r in [r for r in refs if f"_{o}_" in r[0].split("+")[0]]:
        unit = r[2]
        data = r[3]
        end = 0
        while data[end:end + unit] != b"\0" * unit:
            end += unit
        expected += data[:end] + b"1\n"
with open(os.path.join(out, "expected.bin"), "wb") as f:
    f.write(expected)
with open(os.path.join(out, "objects.txt"), "w") as f:
    f.write(" ".join(f"obj{o}.o" for o in range(objects)) + "\n")
