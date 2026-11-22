"""Compare complete diagnostics, process status and output files for source-owned native bodies."""
import argparse
import csv
import hashlib
import json
import os
from pathlib import Path
import subprocess

POLICIES = {"default": [], "wall": ["-Wall", "-Wextra"], "everything": ["-Weverything", "-Wno-c++-compat"],
            "strict": ["-Wall", "-Wextra", "-Werror"], "quiet": ["-w"]}


def run(compiler, source, policy, environment, output):
    output.unlink(missing_ok=True)
    observed = subprocess.run([compiler, "--lanes", "1", "-c", "-nostdinc", *policy, source, "-o", output],
                              env=environment, capture_output=True)
    return observed.returncode, output.read_bytes() if output.exists() else None, observed.stdout, observed.stderr


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compiler", type=Path, required=True)
    parser.add_argument("--reference", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    cases = json.loads(Path(__file__).with_name("directed-sources.json").read_text())
    env = {k: v for k, v in os.environ.items() if not k.startswith(("BUSTER_CONTROL_", "BUSTER_CHECK_BODY_", "BUSTER_BODY_"))}
    total = exact = 0
    with (args.output/"comparison.tsv").open("w") as f:
        table = csv.writer(f, delimiter="\t")
        table.writerow(("group", "name", "policy", "clean-status", "source-status", "same-object", "same-stdout", "same-stderr",
                        "object-bytes", "stderr-bytes", "object-sha256", "stderr-sha256"))
        for group, fixtures in cases.items():
            for name, contents in fixtures.items():
                source = args.output/(group+"-"+name+".c")
                source.write_text(contents+"\n")
                for policy, switches in POLICIES.items():
                    if group == "edge-qa" and policy in ("quiet", "strict"):
                        continue
                    ordinary = run(args.reference, source, switches, env, args.output/"clean.o")
                    local = run(args.compiler, source, switches, dict(env, BUSTER_CONTROL_SOURCE_NATIVE="1"), args.output/"source.o")
                    table.writerow((group, name, policy, ordinary[0], local[0], *(int(a == b) for a, b in zip(ordinary[1:], local[1:])),
                                    len(local[1]) if local[1] is not None else "", len(local[3]),
                                    hashlib.sha256(local[1]).hexdigest() if local[1] is not None else "", hashlib.sha256(local[3]).hexdigest()))
                    total += 1
                    exact += ordinary == local
                    if ordinary != local:
                        for arm, result in (("clean", ordinary), ("source", local)):
                            (args.output/(group+"-"+name+"-"+policy+"-"+arm+".stderr")).write_bytes(result[3])
    print(f"{exact}/{total} complete object and diagnostic comparisons")
    return int(exact != total)


if __name__ == "__main__":
    raise SystemExit(main())
