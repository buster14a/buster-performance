"""Compile frozen source units in fresh ordinary and mixed-source processes and compare complete output."""
import argparse
import csv
import hashlib
import importlib.util
import os
from pathlib import Path
import subprocess
import sys


def digest(data):
    return hashlib.sha256(data).hexdigest()


def observe(executable, flags, env, obj):
    obj.unlink(missing_ok=True)
    run = subprocess.run([executable, "--lanes", "1", "-c", *flags, "-o", obj], env=env, capture_output=True, timeout=90)
    return run.returncode, digest(obj.read_bytes()) if obj.is_file() else "", run.stdout, run.stderr


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--compiler", type=Path, required=True)
    p.add_argument("--reference", type=Path, required=True)
    p.add_argument("--output", type=Path, required=True)
    for source in ("sqlite", "self-source", "lua-source", "musl-source", "musl-generated"):
        p.add_argument("--"+source, type=Path)
    args = p.parse_args()
    if bool(args.sqlite) != bool(args.self_source) or bool(args.musl_source) != bool(args.musl_generated):
        p.error("supply SQLite with self source and musl with generated headers")
    if not (args.sqlite or args.lua_source or args.musl_source):
        p.error("supply a source corpus")
    args.output.mkdir(parents=True, exist_ok=True)
    helper = Path(__file__).resolve().parents[1]/"4bd73ecaf"
    sys.path.insert(0, str(helper))
    spec = importlib.util.spec_from_file_location("corpus_sources", helper/"diagnostic-corpora.py")
    corpus = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(corpus)
    env = {k: v for k, v in os.environ.items() if not k.startswith(("BUSTER_CONTROL_", "BUSTER_BODY_", "BUSTER_CHECK_BODY_"))}
    total = exact = 0
    with (args.output/"comparison.tsv").open("w") as f:
        w = csv.writer(f, delimiter="\t")
        w.writerow(("source", "policy", "ordinary-status", "source-status", "ordinary-object-sha256", "source-object-sha256",
                    "same-stdout", "same-stderr", "ordinary-stderr-sha256", "source-stderr-sha256"))
        for name, flags in corpus.sources(args):
            for policy, switches in corpus.POLICIES.items():
                clean = observe(args.reference.resolve(), [*flags, *switches], env, args.output/"clean.o")
                live = observe(args.compiler.resolve(), [*flags, *switches], dict(env, BUSTER_CONTROL_SOURCE_NATIVE="1"), args.output/"source.o")
                w.writerow((name, policy, clean[0], live[0], clean[1], live[1], int(clean[2] == live[2]), int(clean[3] == live[3]),
                            digest(clean[3]), digest(live[3])))
                total += 1
                exact += clean == live
                if clean != live:
                    target = args.output/name/policy
                    target.mkdir(parents=True, exist_ok=True)
                    for arm, result in (("ordinary", clean), ("source", live)):
                        (target/(arm+".stderr")).write_bytes(result[3])
    print(f"{exact}/{total} complete source-object comparisons")
    return int(total != exact)


if __name__ == "__main__":
    raise SystemExit(main())
