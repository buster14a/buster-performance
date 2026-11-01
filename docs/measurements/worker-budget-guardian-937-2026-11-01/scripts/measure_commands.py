#!/usr/bin/env python3
"""#937: time the compiler's commands with and without a GNU make jobserver guardian.

The jobserver cohorts create a pipe holding TOKENS token bytes and pass it in
MAKEFLAGS as --jobserver-auth, exactly as GNU make does for a recipe with spare
tokens. The matching no-jobserver cohorts run the same command with MAKEFLAGS
removed, so both take the same lane rule (one lane per core) and differ only in
the guardian: the wall difference is what the per-lease guardians cost. The
--lanes 1 cohorts are the serial controls.

The instrumented compiler prints each lease's acquire and release cost on
standard error; the harness parses them and checks that every token returned.
"""
import argparse
import os
import statistics
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


def run_once(args, cohort, command, mode, quiet=False):
    env = dict(os.environ)
    env.pop("MAKEFLAGS", None)
    env.pop("MFLAGS", None)
    read_fd = write_fd = -1
    if mode == "jobserver":
        read_fd, write_fd = os.pipe()
        os.set_blocking(read_fd, False)
        os.set_blocking(write_fd, False)
        os.write(write_fd, b"+" * args.tokens)
        os.set_inheritable(read_fd, True)
        os.set_inheritable(write_fd, True)
        env["MAKEFLAGS"] = f" -j{args.jobs} --jobserver-auth={read_fd},{write_fd}"
    start = time.perf_counter_ns()
    proc = subprocess.run(
        command,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.PIPE,
        env=env,
        pass_fds=(read_fd, write_fd) if mode == "jobserver" else (),
    )
    end = time.perf_counter_ns()
    returned = 0
    if read_fd >= 0:
        try:
            while True:
                chunk = os.read(read_fd, 4096)
                if not chunk:
                    break
                returned += len(chunk)
        except BlockingIOError:
            pass
        os.close(read_fd)
        os.close(write_fd)
    acquire, release = parse_leases(proc.stderr)
    row = {
        "cohort": cohort,
        "mode": mode,
        "wall_ns": end - start,
        "leases": len(acquire),
        "acquire_ns": sum(acquire),
        "release_ns": sum(release),
        "lease_ns": sum(acquire) + sum(release),
        "tokens_in": args.tokens if mode == "jobserver" else 0,
        "tokens_returned": returned,
    }
    if not quiet:
        print(
            "run\t{cohort}\t{mode}\twall_ns={wall_ns}\tleases={leases}\tacquire_ns={acquire_ns}"
            "\trelease_ns={release_ns}\tlease_ns={lease_ns}\ttokens_in={tokens_in}"
            "\ttokens_returned={tokens_returned}".format(**row),
            flush=True,
        )
    if proc.returncode != 0:
        sys.stderr.write(proc.stderr.decode("utf-8", "replace"))
        raise SystemExit(f"command failed: {command!r}")
    if mode == "jobserver" and returned != args.tokens:
        raise SystemExit(f"tokens not returned: {returned} of {args.tokens}")
    return row


def median(values):
    return int(statistics.median(values)) if values else 0


def percentile(values, fraction):
    ordered = sorted(values)
    if not ordered:
        return 0
    index = min(len(ordered) - 1, max(0, int(round(fraction * (len(ordered) - 1)))))
    return int(ordered[index])


def summarize(rows):
    cohorts = {}
    for row in rows:
        cohorts.setdefault(row["cohort"], []).append(row)
    for cohort in sorted(cohorts):
        group = cohorts[cohort]
        walls = [r["wall_ns"] for r in group]
        leases = [r["lease_ns"] for r in group]
        wall = median(walls)
        lease = median(leases)
        print(
            "median\t{cohort}\truns={runs}\tleases_each={lease_counts}\twall_ns={wall}\t"
            "wall_p10={p10}\twall_p90={p90}\tacquire_ns={acquire}\trelease_ns={release}\t"
            "lease_ns={lease}\tshare_pct={share:.4f}".format(
                cohort=cohort,
                runs=len(group),
                lease_counts=sorted({r["leases"] for r in group}),
                wall=wall,
                p10=percentile(walls, 0.10),
                p90=percentile(walls, 0.90),
                acquire=median([r["acquire_ns"] for r in group]),
                release=median([r["release_ns"] for r in group]),
                lease=lease,
                share=100.0 * lease / wall if wall else 0.0,
            )
        )
    # Paired differences of the jobserver and no-jobserver runs of the same index.
    for workload in ("sqlite", "link"):
        job = [r for r in rows if r["cohort"] == f"{workload}-jobserver"]
        plain = [r for r in rows if r["cohort"] == f"{workload}-no-jobserver"]
        paired = [j["wall_ns"] - p["wall_ns"] for j, p in zip(job, plain)]
        if paired:
            print(
                "pair\t{workload}\tguardian_wall_ns_median={median}\tmin={low}\tmax={high}".format(
                    workload=workload,
                    median=median(paired),
                    low=min(paired),
                    high=max(paired),
                )
            )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--binary", required=True)
    parser.add_argument("--directory", required=True)
    parser.add_argument("--sqlite", required=True)
    parser.add_argument("--main", required=True)
    parser.add_argument("--helper", required=True)
    parser.add_argument("--runs", type=int, default=21)
    parser.add_argument("--warmups", type=int, default=2)
    parser.add_argument("--tokens", type=int, default=7)
    parser.add_argument("--jobs", type=int, default=8)
    parser.add_argument("--only", choices=["all", "commands", "serials"], default="all")
    args = parser.parse_args()
    os.makedirs(args.directory, exist_ok=True)
    object_path = os.path.join(args.directory, "sqlite3.o")
    program_path = os.path.join(args.directory, "program")
    compile_command = [args.binary, "-c", args.sqlite, "-o", object_path]
    link_command = [args.binary, args.sqlite, args.main, args.helper, "-lm", "-o", program_path]
    cohorts = []
    if args.only in ("all", "commands"):
        cohorts.extend(
            [
                ("sqlite-jobserver", compile_command, "jobserver"),
                ("sqlite-no-jobserver", compile_command, "none"),
                ("link-jobserver", link_command, "jobserver"),
                ("link-no-jobserver", link_command, "none"),
            ]
        )
    if args.only in ("all", "serials"):
        cohorts.extend(
            [
                ("sqlite-lanes1", [args.binary, "--lanes", "1"] + compile_command[1:], "none"),
                ("link-lanes1", [args.binary, "--lanes", "1"] + link_command[1:], "none"),
            ]
        )
    rows = []
    for warmup in range(args.warmups):
        rotation = warmup % len(cohorts)
        for cohort, command, mode in cohorts[rotation:] + cohorts[:rotation]:
            run_once(args, cohort, command, mode, quiet=True)
    for index in range(args.runs):
        rotation = index % len(cohorts)
        order = cohorts[rotation:] + cohorts[:rotation]
        for cohort, command, mode in order:
            rows.append(run_once(args, cohort, command, mode))
    summarize(rows)
    if os.path.exists(program_path) and args.only in ("all", "commands"):
        check = subprocess.run([program_path, "--version"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        print(f"program\t--version\tstatus={check.returncode}\t{check.stdout.decode('utf-8', 'replace').strip()}")
        if check.returncode != 0:
            return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
