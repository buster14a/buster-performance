"""Compare the source-ownership path and an independent ordinary compiler on the retained C inputs."""
import argparse
import csv
import hashlib
import json
import os
from pathlib import Path
import subprocess

POLICIES = {
    "default": (),
    "warnings": ("-Wall", "-Wextra"),
    "everything": ("-Weverything", "-Wno-c++-compat"),
    "strict": ("-Wall", "-Wextra", "-Werror"),
    "quiet": ("-w",),
}


def observe(compiler, flags, source, output, environment):
    output.unlink(missing_ok=True)
    run = subprocess.run(
        [compiler, "--lanes", "1", "-c", "-nostdinc", *flags, source, "-o", output],
        env=environment, stdin=subprocess.DEVNULL, capture_output=True, timeout=180,
    )
    digest = hashlib.sha256(output.read_bytes()).hexdigest() if output.is_file() else ""
    return run.returncode, digest, run.stdout, run.stderr


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compiler", type=Path, required=True)
    parser.add_argument("--reference", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--group", action="append")
    args = parser.parse_args()
    args.output.mkdir(exist_ok=True, parents=True)
    env = {k: v for k, v in os.environ.items() if not k.startswith(("BUSTER_CONTROL_", "BUSTER_CHECK_BODY_", "BUSTER_BODY_"))}
    corpus = json.loads(Path(__file__).with_name("exceptional-sources.json").read_text())
    tried = exact = 0
    with (args.output / "results.tsv").open("w") as results:
        table = csv.writer(results, delimiter="\t")
        table.writerow(("group", "fixture", "policy", "clean-status", "source-status", "same-object", "same-stdout", "same-stderr",
                        "clean-object-sha256", "source-object-sha256", "clean-stderr-sha256", "source-stderr-sha256"))
        for group in args.group or corpus:
            for name, contents in corpus[group].items():
                source = args.output / (group + "-" + name + ".c")
                source.write_text(contents + "\n")
                for policy, options in POLICIES.items():
                    flags = ("-march=znver5", *options) if group == "x86-immediates" else options
                    a = observe(args.reference.resolve(), flags, source, args.output / "ordinary.o", env)
                    b = observe(args.compiler.resolve(), flags, source, args.output / "source.o", dict(env, BUSTER_CONTROL_SOURCE_NATIVE="1"))
                    table.writerow((group, name, policy, a[0], b[0], *(int(x == y) for x,y in zip(a[1:], b[1:])), a[1], b[1],
                                    hashlib.sha256(a[3]).hexdigest(), hashlib.sha256(b[3]).hexdigest()))
                    if a != b:
                        (args.output / (source.stem + "-" + policy + "-ordinary.stderr")).write_bytes(a[3])
                        (args.output / (source.stem + "-" + policy + "-source.stderr")).write_bytes(b[3])
                    tried += 1
                    exact += a == b
    print(f"{exact}/{tried} pairs matched")
    return int(tried != exact)


if __name__ == "__main__":
    raise SystemExit(main())
