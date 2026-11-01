#!/usr/bin/env python3
"""#937: confirm the lease count and wall time under a real GNU make jobserver."""
import argparse
import os
import subprocess
import sys
import time


def parse_leases(stderr: bytes):
    acquire = []
    release = []
    for line in stderr.decode("utf-8", "replace").splitlines():
        fields = line.split("\t")
        if len(fields) >= 3 and fields[0] == "worker-budget-timing":
            try:
                value = int(fields[2])
            except ValueError:
                continue
            if fields[1] == "acquire":
                acquire.append(value)
            elif fields[1] == "release":
                release.append(value)
    return acquire, release


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--makefile", required=True)
    parser.add_argument("--directory", required=True)
    parser.add_argument("--runs", type=int, default=5)
    parser.add_argument("--jobs", type=int, default=8)
    args = parser.parse_args()
    os.makedirs(args.directory, exist_ok=True)
    env = dict(os.environ)
    env["BUSTER_WORKER_BUDGET_TIMING"] = "1"
    for index in range(args.runs):
        for target in ("compile", "link") if index % 2 == 0 else ("link", "compile"):
            command = ["make", "-s", f"-j{args.jobs}", "-f", args.makefile, target]
            start = time.perf_counter_ns()
            proc = subprocess.run(command, cwd=args.directory, env=env, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)
            end = time.perf_counter_ns()
            acquire, release = parse_leases(proc.stderr)
            print(
                f"make\t{target}\t{index}\tstatus={proc.returncode}\twall_ns={end - start}"
                f"\tleases={len(acquire)}\tacquire_ns={sum(acquire)}\trelease_ns={sum(release)}"
                f"\tlease_ns={sum(acquire) + sum(release)}",
                flush=True,
            )
            if proc.returncode != 0:
                sys.stderr.write(proc.stderr.decode("utf-8", "replace"))
                return 1
    program = os.path.join(args.directory, "out", "program")
    if os.path.exists(program):
        check = subprocess.run([program, "--version"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        print(f"program\t--version\tstatus={check.returncode}\t{check.stdout.decode('utf-8', 'replace').strip()}")
        if check.returncode != 0:
            return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
