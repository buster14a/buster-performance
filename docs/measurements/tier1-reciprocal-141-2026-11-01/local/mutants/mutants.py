#!/usr/bin/env python3
# The mutant harness behind buster#1001 (this record's, not part of buster): recompiles main_unit_backend.c of a mutated copy of src/ and relinks it with
# the head's other objects, then runs test-tier1-select and test-tier1-emit. Usage:
#   mutants.py objects REPO OBJDIR            compile every source of REPO's build/compile_commands.json into OBJDIR
#   mutants.py run REPO OBJDIR WORK [names]   build and test each mutant (all, or the named ones), 4 at a time
import json, os, shutil, subprocess, sys, concurrent.futures

MUTANTS = {
    "signed-sign-fixup": ("tier1_select.c",
        "        records[count++] = tier1_select_register_record(tier1_select_binary_form(X86_OPERATION_ADD, width), rdx, rax);\n", ""),
    "unsigned-add-halving": ("tier1_select.c",
        "        records[count++] = tier1_select_shift(X86_OPERATION_SHR, width, rax, 1);\n", ""),
    "dividend-not-kept-for-add": ("tier1_select.c",
        "    const bool kept = remainder || reciprocal.add;\n", "    const bool kept = remainder;\n"),
    "no-pre-shift": ("tier1_select.c",
        "        records[count++] = tier1_select_shift(X86_OPERATION_SHR, width, rax, reciprocal.pre_shift);\n", ""),
    "straight-line-no-saves": ("tier1_emit.c",
        "            const uint32_t saved = tier1_emit_call_saved(result, &transitions, node) & tier1_select_fixed_registers(plan->patterns[node].rule) & ~(1u << holes.destination);\n",
        "            const uint32_t saved = 0;\n"),
    "munch-divide-rank": ("tier1_select.c",
        "        case TIER1_RULE_DIVIDE:\n            rank = 0;\n            break;\n", ""),
    "remainder-imm32-truncates": ("tier1_select.c",
        "        if (tier1_select_immediate_fits(width, divisor))\n", "        if (true)\n"),
}

def compile_commands(repo):
    with open(os.path.join(repo, "build", "compile_commands.json")) as f:
        text = f.read().strip().rstrip(",")
    return json.loads("[" + text + "]")

def objects(repo, objdir):
    os.makedirs(objdir, exist_ok=True)
    jobs = []
    for i, entry in enumerate(compile_commands(repo)):
        args = list(entry["arguments"])
        args[args.index("-o") + 1] = os.path.join(objdir, "%d.o" % i)
        jobs.append(args)
    with concurrent.futures.ThreadPoolExecutor(4) as pool:
        results = list(pool.map(lambda a: subprocess.run(a, cwd=repo, capture_output=True, text=True), jobs))
    bad = [r for r in results if r.returncode != 0]
    for r in bad:
        print(r.stderr[:2000])
    print("objects:", len(results), "failed:", len(bad))

def run_one(repo, objdir, work, name):
    file, old, new = MUTANTS[name]
    tree = os.path.join(work, name)
    shutil.rmtree(tree, ignore_errors=True)
    os.makedirs(tree)
    shutil.copytree(os.path.join(repo, "src"), os.path.join(tree, "src"))
    shutil.copytree(os.path.join(repo, "tests"), os.path.join(tree, "tests"))
    path = os.path.join(tree, "src", "buster", "compiler", file)
    with open(path) as f:
        text = f.read()
    if text.count(old) != 1:
        return name, "mutation does not apply exactly once (%d)" % text.count(old)
    with open(path, "w") as f:
        f.write(text.replace(old, new))
    entries = compile_commands(repo)
    backend = next(i for i, e in enumerate(entries) if e["file"].endswith("main_unit_backend.c"))
    args = list(entries[backend]["arguments"])
    obj = os.path.join(tree, "backend.o")
    args[args.index("-o") + 1] = obj
    args = [a for a in args if a != "-Werror"]
    r = subprocess.run(args, cwd=tree, capture_output=True, text=True)
    if r.returncode != 0:
        return name, "compile failed: " + r.stderr[:500]
    linked = [obj if i == backend else os.path.join(objdir, "%d.o" % i) for i in range(len(entries))]
    exe = os.path.join(tree, "compiler")
    r = subprocess.run(["clang", "-no-pie"] + linked + ["-lm", "-ldl", "-o", exe], capture_output=True, text=True)
    if r.returncode != 0:
        return name, "link failed: " + r.stderr[:500]
    out = []
    for command in (["test-tier1-select"], ["test-tier1-emit"]):
        t = subprocess.run([exe] + command, cwd=tree, capture_output=True, text=True, timeout=120)
        summary = [l for l in (t.stdout + t.stderr).splitlines() if "checks," in l]
        out.append("%s exit %d: %s" % (command[0], t.returncode, summary[-1] if summary else (t.stdout + t.stderr)[-300:]))
    return name, " | ".join(out)

def run(repo, objdir, work, names):
    names = names or list(MUTANTS)
    with concurrent.futures.ThreadPoolExecutor(4) as pool:
        for name, result in pool.map(lambda n: run_one(repo, objdir, work, n), names):
            print("%-28s %s" % (name, result), flush=True)

if __name__ == "__main__":
    if sys.argv[1] == "objects":
        objects(sys.argv[2], sys.argv[3])
    else:
        run(sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5:])
