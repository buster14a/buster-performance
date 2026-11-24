#!/usr/bin/env python3
"""Compare two release compilers on the issue 2850 corpus, one lock per invocation."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import resource
import subprocess
import sys
import time

SQLITE = Path("/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite")
FLAGS = ["-DSQLITE_OMIT_LOAD_EXTENSION", "-DSQLITE_THREADSAFE=0", "-DSQLITE_ENABLE_MEMSYS5",
         "-DSQLITE_ENABLE_RTREE", f"-I{SQLITE}", str(SQLITE / "sqlite3.c")]


def digest(data):
    return hashlib.sha256(data).hexdigest()


def host():
    busy = subprocess.check_output(["ps", "-eo", "psr,pcpu,pid,etimes,user,comm", "--sort=-pcpu"], text=True)
    return {"load": Path("/proc/loadavg").read_text().strip(), "busy": busy.splitlines()[:11]}


def one(exe, mode, name, directory, compiler_inputs):
    flags = FLAGS
    if compiler_inputs:
        source = compiler_inputs / "pooled-main-source" / "src"
        flags = ["-march=native", f"-I{source}", "-fwrapv", "-funsigned-char", "--predefines",
                 str(compiler_inputs / "proof-predefines.h"), str(source / "buster/compiler/main.c")]
    prefix = directory / name
    obj = directory / "unit.o"
    log = {"name": name, "mode": mode, "host_before": host()}
    if mode in ("tree", "tree-sizes"):
        cmd = [exe, "benchmark-parser", "--only", mode, "--passes", "21", "--repeat", "3", *flags]
    else:
        obj.unlink(missing_ok=True)
        cmd = [exe, "--lanes", "1", "-c", *flags, "-o", str(obj)]
        if mode == "perf":
            cmd = ["perf", "stat", "-x,", "-o", f"{prefix}.perf", "-e",
                   "cycles:u,cycles:k,instructions:u,minor-faults,major-faults", "--", *cmd]
        if mode == "stages":
            cmd.insert(1, "--time-stages")
    before = resource.getrusage(resource.RUSAGE_CHILDREN)
    start = time.perf_counter_ns()
    ran = subprocess.run(cmd, capture_output=True)
    log["wall_ns"] = time.perf_counter_ns() - start
    usage = resource.getrusage(resource.RUSAGE_CHILDREN)
    log.update(exit=ran.returncode, minor_faults=usage.ru_minflt-before.ru_minflt, major_faults=usage.ru_majflt-before.ru_majflt,
               maxrss_kib=usage.ru_maxrss, stdout_sha256=digest(ran.stdout), stderr_sha256=digest(ran.stderr))
    log["host_after"] = host()
    if ran.stdout:
        Path(f"{prefix}.stdout").write_bytes(ran.stdout)
    if ran.stderr:
        Path(f"{prefix}.stderr").write_bytes(ran.stderr)
    if mode in ("wall", "perf", "stages") and obj.exists():
        log["object_sha256"] = digest(obj.read_bytes())
    print(json.dumps(log), flush=True)
    return ran.returncode


def main():
    cli = argparse.ArgumentParser(description=__doc__)
    cli.add_argument("parent", type=Path)
    cli.add_argument("candidate", type=Path)
    cli.add_argument("directory", type=Path)
    cli.add_argument("--mode", choices=("wall", "perf", "stages", "tree", "tree-sizes"), required=True)
    cli.add_argument("--compiler-inputs", type=Path, help="frozen self-host workload directory in the November 23 measurement")
    cli.add_argument("--rounds", type=int, default=7)
    cli.add_argument("--one", nargs=2, metavar=("ARM", "NAME"))
    args = cli.parse_args()
    exe = {"base": args.parent.resolve(), "candidate": args.candidate.resolve()}
    directory = args.directory.resolve()
    if args.one:
        arm, name = args.one
        return one(exe[arm], args.mode, name, directory, args.compiler_inputs)
    directory.mkdir(parents=True, exist_ok=True)
    workload = ["--compiler-inputs", args.compiler_inputs.resolve()] if args.compiler_inputs else []
    lock = Path.home() / "buster-fast-bench" / "exclusive.sh"
    env = dict(os.environ, LC_ALL="C")
    env.setdefault("EXCLUSIVE_OWNER", "tree-columns-replay")
    env.setdefault("EXCLUSIVE_TITLE", "Tree traversal throughput")
    env.setdefault("EXCLUSIVE_LINK", "https://github.com/buster14a/buster/issues/2850")
    with (directory / f"{args.mode}.jsonl").open("w") as rows, (directory / f"{args.mode}.lock").open("w") as locks:
        if args.mode == "wall":
            with (directory / "warmup.jsonl").open("w") as warmup:
                for arm in exe:
                    cmd = [lock, "timeout", "-k", "5", "180", "taskset", "-c", "2", sys.executable,
                           Path(__file__).resolve(), *exe.values(), directory, *workload, "--mode", "wall", "--one", arm, "warmup-" + arm]
                    subprocess.run(cmd, env=env, stdout=warmup, stderr=locks, check=True)
        for r in range(args.rounds):
            arms = ("base", "candidate", "candidate", "base")
            if r % 2:
                arms = tuple("base" if arm == "candidate" else "candidate" for arm in arms)
            for i, arm in enumerate(arms):
                name = f"{args.mode}-{r+1:02d}-{i+1}-{arm}"
                cmd = [lock, "timeout", "-k", "5", "180", "taskset", "-c", "2", sys.executable,
                       Path(__file__).resolve(), *exe.values(), directory, *workload, "--mode", args.mode, "--one", arm, name]
                subprocess.run(cmd, env=env, stdout=rows, stderr=locks, check=True)
                rows.flush()
    return 0


if __name__ == "__main__":
    sys.exit(main())
