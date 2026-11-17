#!/usr/bin/env python3
# Each mutant: one exact, unique replacement in the copy, an incremental Debug build, the suite, and the failure line
# it must print; reverted with git checkout after.
import subprocess, sys, os
tree = os.path.expanduser("~/.cache/claude-2646/mut/tree")
mutants = [
    ("ignored", "src/buster/compiler/tier1_allocate.c",
     "    return valued != UINT8_MAX ? valued : named_register;",
     "    return valued != UINT8_MAX ? valued : (named_register != UINT8_MAX ? UINT8_MAX : UINT8_MAX);",
     ["test-tier1-cfg"], "a call's argument takes the register the call reads it in"),
    ("evicts", "src/buster/compiler/tier1_allocate.c",
     "&& !tier1_allocation_register_hinted(&columns, last, interval, follow);",
     "&& (true || !tier1_allocation_register_hinted(&columns, last, interval, follow));",
     ["test-tier1-cfg"], "a register hint evicts nothing"),
    ("outranks", "src/buster/compiler/tier1_allocate.c",
     "    return valued != UINT8_MAX ? valued : named_register;",
     "    return named_register != UINT8_MAX ? named_register : valued;",
     ["test-tier1-cfg"], "a value hint outranks a register hint"),
    ("past-call", "src/buster/compiler/tier1_cfg.c",
     "const bool used = end > use_offsets[i] && input->use_positions[end - 1] + 1 == pieces.ends[i];",
     "const bool used = end > use_offsets[i] && (true || input->use_positions[end - 1] + 1 == pieces.ends[i]);",
     ["test-tier1-cfg"], "a value that lives past the call takes no hint from it"),
    ("emitter", "src/buster/compiler/tier1_emit_cfg.c",
     "                    use_registers[use_cursors[v]] = reg;",
     "                    use_registers[use_cursors[v]] = reg != UINT8_MAX ? UINT8_MAX : UINT8_MAX;",
     ["test-tier1-emit"], "a call's register arguments' uses name the registers it reads them in"),
    ("inline-sizes", "src/buster/compiler/c_testsuite.c",
     '''"--tier1-function-sizes", "--tier1-no-inline" };''',
     '''"--tier1-function-sizes", "--tier1-function-sizes" };''',
     ["test-c-testsuite --self-test"], "missing size report (report-only): failed"),
]
def run(cmd, **k): return subprocess.run(cmd, shell=True, cwd=tree, capture_output=True, text=True, **k)
results = []
for name, path, old, new, tests, expect in mutants:
    full = os.path.join(tree, path); text = open(full).read()
    if text.count(old) != 1 or text.count(new) != 0:
        results.append((name, "BAD MUTANT (count %d/%d)" % (text.count(old), text.count(new)))); continue
    open(full, "w").write(text.replace(old, new))
    b = run("./build.sh --config Debug 2>&1 | tail -3")
    if "published" not in b.stdout:
        results.append((name, "BUILD FAILED: " + b.stdout[-300:])); run("git checkout -q -- " + path); continue
    killed = False; out = ""
    for t in tests:
        r = run("timeout 900 ./build/compiler " + t + " 2>&1")
        out += r.stdout
        killed |= r.returncode != 0 and expect in r.stdout
    results.append((name, "KILLED" if killed else "SURVIVED: " + out[-400:]))
    run("git checkout -q -- " + path)
    print(name, results[-1][1][:200], flush=True)
d = run("git status --short")
print("tree clean after:", d.stdout.strip() == "")
