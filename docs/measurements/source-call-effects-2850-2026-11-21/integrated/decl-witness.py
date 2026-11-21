import argparse
import csv
import hashlib
import os
from pathlib import Path
import subprocess
import tempfile

parser = argparse.ArgumentParser()
parser.add_argument("executable", type=Path)
parser.add_argument("fixture_dir", type=Path)
parser.add_argument("out", type=Path)
args = parser.parse_args()
args.out.mkdir(parents=True, exist_ok=True)
cc = args.executable.resolve()
names = ["bound.c", "focused.c", "generated.c", "diagnostics.c", "physical-runtime.c", "deferred.c"]
fields = "source lanes tier takes ordinary_status candidate_status same_stderr same_stdout same_object same_marks same_raw_type_ids mark_count ordinary_sha candidate_sha".split()

def observe(source, lanes, tier, compact, scratch):
    obj = scratch / "unit.o"
    marks = scratch / "decls.txt"
    obj.unlink(missing_ok=True)
    marks.unlink(missing_ok=True)
    env = dict(os.environ, BUSTER_CALL_MARKS=str(marks), BUSTER_WINDOW_CALL_LOG="1")
    flags = ["--node-window-calls"] if compact else []
    if compact:
        env["BUSTER_CALL_FORCE_DEBUG"] = "1"
    if tier:
        flags.append("--tier1")
    run = subprocess.run([cc, "-g", "--lanes", str(lanes), *flags, "-c", source, "-o", obj], env=env, capture_output=True)
    entries = marks.read_bytes().splitlines() if marks.exists() else []
    parts = [entry.rsplit(b' ', 1) for entry in entries]
    lines = run.stderr.splitlines(keepends=True)
    takes = sum(line.startswith(b'plain-call:') for line in lines)
    diagnostics = b"".join(line for line in lines if not line.startswith(b'plain-call:'))
    sha = hashlib.sha256(obj.read_bytes()).hexdigest() if obj.exists() else ""
    return (run.returncode, diagnostics, run.stdout, sha, [p[0] for p in parts], [p[1] for p in parts], takes)

with tempfile.TemporaryDirectory(dir=args.out) as tmp, (args.out / "matrix.tsv").open("w") as f:
    w = csv.writer(f, delimiter="\t", lineterminator="\n")
    w.writerow(fields)
    for name in names:
        source = (args.fixture_dir / name).resolve()
        for lanes in [1, 2]:
            for tier in [False, True]:
                a = observe(source, lanes, tier, False, Path(tmp))
                b = observe(source, lanes, tier, True, Path(tmp))
                w.writerow([name, lanes, int(tier), b[-1], a[0], b[0], *[int(x==y) for x,y in zip(a[1:6],b[1:6])], len(b[4]), a[3], b[3]])
