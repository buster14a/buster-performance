"""Compare an ordinary C object with source-local compilation of the same input.

Run: python3 replay.py --compiler /path/to/compiler --output receipts -- [normal compiler arguments]
Omit -o and -c. The input list must describe one translation unit.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess

ap = argparse.ArgumentParser(description=__doc__)
ap.add_argument("--compiler", type=Path, required=True)
ap.add_argument("--output", type=Path, required=True)
ap.add_argument("--early-native", action="store_true")
ap.add_argument("--first-node", action="store_true")
ap.add_argument("--poison", action="store_true")
ap.add_argument("args", nargs=argparse.REMAINDER)
opts = ap.parse_args()
flags = opts.args[1:] if opts.args[:1] == ["--"] else opts.args
if not flags:
    ap.error("supply the C file and normal flags after --")
opts.output.mkdir(parents=True, exist_ok=True)
compiler = str(opts.compiler.resolve(strict=True))
source = dict(BUSTER_CONTROL_SOURCE_NATIVE="1", BUSTER_SOURCE_FILE_DATA="1",
              BUSTER_SOURCE_WRITE_COLUMNS="1", BUSTER_SOURCE_GROW_GRAPH="1",
              BUSTER_SOURCE_RETIRE_LISTS="1")
if opts.first_node:
    source["BUSTER_SOURCE_FIRST_NODE"] = "1"
if opts.early_native:
    source.update(BUSTER_CONTROL_EARLY_RELEASE="1", BUSTER_CONTROL_EARLY_NATIVE="1")
if opts.poison:
    source["BUSTER_SOURCE_POISON_COLUMNS"] = "1"
    if opts.early_native:
        source["BUSTER_CONTROL_EARLY_POISON"] = "1"
audit = dict(BUSTER_CONTROL_SOURCE_AUDIT="1", BUSTER_SOURCE_RESIDENCY_AUDIT="1",
             BUSTER_SOURCE_FILE_AUDIT="1", BUSTER_CONTROL_EARLY_AUDIT="1")
base_environment = {k: v for k, v in os.environ.items() if not k.startswith(
    ("BUSTER_SOURCE_", "BUSTER_CONTROL_", "BUSTER_CHECK_BODY_"))}
observations = {}
for mode, environment in [("ordinary", {}), ("source", source), ("audited", source | audit)]:
    obj = opts.output / (mode + ".o")
    obj.unlink(missing_ok=True)
    cmd = [compiler, "--lanes", "1", "-c", *flags, "-o", str(obj)]
    r = subprocess.run(cmd, env=base_environment | environment, capture_output=True, check=False)
    (opts.output / (mode + ".stdout")).write_bytes(r.stdout)
    (opts.output / (mode + ".stderr")).write_bytes(r.stderr)
    observations[mode] = {
        "status": r.returncode,
        "object": hashlib.sha256(obj.read_bytes()).hexdigest() if obj.exists() else None,
        "stdout": hashlib.sha256(r.stdout).hexdigest(),
        "stderr": hashlib.sha256(r.stderr).hexdigest(),
    }
passed = observations["source"] == observations["ordinary"] and all(
    observations["audited"][k] == observations["ordinary"][k] for k in ("status", "object", "stdout"))
report = {"compiler": compiler, "arguments": flags, "source_environment": source,
          "matched": passed, "observations": observations}
(opts.output / "report.json").write_text(json.dumps(report, indent=2) + "\n")
print(json.dumps(report, indent=2))
raise SystemExit(0 if passed else 1)
