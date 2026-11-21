"""Run the pregraph admission probe on each file and preserve every oracle counter."""

import argparse
from concurrent.futures import ThreadPoolExecutor
import json
import os
from pathlib import Path
import subprocess


def measure(job):
    policy, source = job
    opts = POLICIES[policy]
    command = [str(args.compiler), "measure-node-machine", "--shadow", "--window-rows",
               "--front-first", "--passes", "0", *opts, str(source)]
    proc = subprocess.run(command, env=environment, capture_output=True, cwd=args.tree)
    counts = {}
    evidence = []
    for line in proc.stderr.decode(errors="replace").splitlines():
        if line.startswith("probe-select kind="):
            fields = dict(item.split("=", 1) for item in line.split()[1:])
            kind = fields.pop("kind")
            counts[kind] = {key: int(value) for key, value in fields.items()}
        elif line.startswith(("probe-select-unsafe", "probe-select-source")):
            evidence.append(line)
    return {"source": str(source), "policy": policy, "returncode": proc.returncode,
            "counts": counts, "evidence": evidence}


POLICIES = {
    "default": [],
    "wall": ["-Wall", "-Wextra"],
    "everything": ["-Weverything", "-Wno-c++-compat"],
}
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("compiler", type=Path)
parser.add_argument("tree", type=Path, help="Working directory for relative sources")
parser.add_argument("list", type=Path, help="One C source path per line")
parser.add_argument("output", type=Path)
parser.add_argument("--jobs", type=int, default=1)
args = parser.parse_args()
args.compiler = args.compiler.resolve()
sources = args.list.read_text().splitlines()
environment = dict(os.environ, NODE_PROOF_NO_FP="1", NODE_PROOF_POINTERS="1", NODE_PROOF_CALLS="1")
with ThreadPoolExecutor(max_workers=args.jobs) as pool, args.output.open("w") as output:
    jobs = ((policy, source) for source in sources for policy in POLICIES)
    for result in pool.map(measure, jobs):
        output.write(json.dumps(result) + "\n")
