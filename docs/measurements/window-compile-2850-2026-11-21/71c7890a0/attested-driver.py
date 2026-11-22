import argparse
import csv
import hashlib
import itertools
import os
import subprocess
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("ordinary", type=Path)
parser.add_argument("source", type=Path)
parser.add_argument("output", type=Path)
args = parser.parse_args()
directory = args.output.resolve()
directory.mkdir(parents=True, exist_ok=True)
inputs = directory / "inputs"
inputs.mkdir(exist_ok=True)
(inputs / "shared.h").write_text("""typedef unsigned long size_t;
struct entry { int value; };
enum code { A = 1, B = A + 1 };
int external(struct entry *);
int labelled(int) __asm__("other_label");
inline int twice(int value) { return 2 * value; }
int twice(int);
""")
units = {
    "a": "int first(struct entry *e) { return external(e) + labelled(B); }",
    "b": "int second(int x) { return x > 2 ? twice(x) : labelled(A); }",
    "c": "int third(unsigned x) { static short table[] = { 1, 3, 5, 7 }; return table[x & 3]; }",
    "d": "int fourth(struct entry *p) { switch (p->value) { case 1: return 2; case 2: return 4; default: return 1; } }",
    "e": "int fifth(void) { int unused = 0; return 5; }"
}
for name, source in units.items():
    (inputs / (name + ".c")).write_text('#include "shared.h"\n' + source + '\n')
policy = {"default": [], "wall": ["-Wall", "-Wextra"], "strict": ["-Wall", "-Wextra", "-Werror"], "quiet": ["-w"], "everything": ["-Weverything"]}
clean_env = {k:v for k, v in os.environ.items() if not k.startswith(("BUSTER_CONTROL_", "BUSTER_CHECK_BODY_", "BUSTER_LOCAL_CONTROL_"))}
digest = lambda data: hashlib.sha256(data).hexdigest()
with (directory / "comparisons.tsv").open("w", buffering=1) as output:
    writer = csv.writer(output, delimiter="\t")
    writer.writerow(("lanes","attested","policy","ordinary-exit","source-exit","same-object-set-and-bytes","same-stdout","same-stderr","ordinary-objects","ordinary-stderr-sha","source-stderr-sha"))
    for lanes, mode, flags in itertools.product((1, 2, 4), ("off", "on", "verify"), policy):
        results = []
        for name, compiler in (("ordinary", args.ordinary.resolve()), ("source", args.source.resolve())):
            target = directory / name
            target.mkdir(exist_ok=True)
            for obj in target.glob("*.o"):
                obj.unlink()
            env = dict(clean_env)
            if name == "source":
                env["BUSTER_CONTROL_SOURCE_NATIVE"] = "1"
            command = [compiler, "--lanes", str(lanes), "--attested="+mode, "-nostdinc", "-std=gnu17", "-c", *policy[flags], *sorted(inputs.glob("*.c"))]
            run = subprocess.run(command, cwd=target, env=env, stdin=subprocess.DEVNULL, capture_output=True, timeout=30)
            objects = {p.name: digest(p.read_bytes()) for p in sorted(target.glob("*.o"))}
            results.append((run.returncode, objects, run.stdout, run.stderr))
        ordinary, source = results
        same = [a == b for a, b in zip(ordinary, source)]
        writer.writerow((lanes, mode, flags, ordinary[0], source[0], *(int(v) for v in same[1:]), ";".join(k+"="+v for k, v in ordinary[1].items()), digest(ordinary[3]), digest(source[3])))
        if not all(same):
            for arm, result in zip(("ordinary", "source"), results):
                (directory / f"{lanes}-{mode}-{flags}-{arm}.stderr").write_bytes(result[3])
