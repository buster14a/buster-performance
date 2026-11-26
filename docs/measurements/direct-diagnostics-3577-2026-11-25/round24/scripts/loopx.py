import re, sys
# The skip function's loops: each backward conditional jump; for each, the instructions from its target to it, with
# the count of stack loads, stores and mask/vector ops.
lines = [l.rstrip("\n") for l in open(sys.argv[1])]
ins = []
for l in lines:
    m = re.match(r"\s*([0-9a-f]+):\s*(.*)", l)
    if m:
        ins.append((int(m.group(1), 16), m.group(2).strip()))
addr_index = {a: i for i, (a, _) in enumerate(ins)}
for i, (a, t) in enumerate(ins):
    m = re.match(r"(j\w+)\s+([0-9a-f]+)", t)
    if m and m.group(1) != "jmp":
        target = int(m.group(2), 16)
        if target < a and target in addr_index:
            j = addr_index[target]
            body = ins[j:i + 1]
            if len(body) < 40:
                continue
            stores = sum(1 for _, x in body if re.search(r",-?0x[0-9a-f]+\(%rsp\)$", x) or re.search(r",\(%rsp\)$", x))
            loads = sum(1 for _, x in body if re.search(r"\(%rsp\),", x))
            vec = sum(1 for _, x in body if x.startswith(("vp", "vmov", "k")))
            print(f"loop {target:x}..{a:x}: {len(body)} instructions, {loads} stack loads, {stores} stack stores, {vec} vector/mask")
