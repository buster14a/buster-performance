"""Paired fresh-process timing of the ordinary and local diagnostic drivers on a single core."""
import argparse
import csv
import hashlib
import os
from pathlib import Path
import statistics
import subprocess
import time

from reproduce import frozen_args


def measure(binary, args, env, dest):
    with (dest/"stdout").open("wb") as out, (dest/"stderr").open("wb") as err:
        start = time.monotonic_ns()
        proc = subprocess.Popen([binary, "--lanes","1","-fsyntax-only",*args], env=env, stdout=out, stderr=err)
        _, status, usage = os.wait4(proc.pid, 0)
        elapsed = (time.monotonic_ns()-start) / 1e6
        proc.returncode = os.waitstatus_to_exitcode(status)
    stdout = (dest/"stdout").read_bytes()
    stderr = (dest/"stderr").read_bytes()
    return (elapsed,usage.ru_utime*1000,usage.ru_stime*1000,usage.ru_maxrss,usage.ru_minflt,
            proc.returncode,hashlib.sha256(stdout).hexdigest(),hashlib.sha256(stderr).hexdigest())


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--compiler", type=Path, required=True)
    p.add_argument("--sqlite", type=Path, required=True)
    p.add_argument("--self-source", type=Path, required=True)
    p.add_argument("--output", type=Path, required=True)
    p.add_argument("--rounds", type=int, default=5)
    a = p.parse_args()
    a.output.mkdir(parents=True,exist_ok=True)
    base = {k:v for k,v in os.environ.items() if not k.startswith(("BUSTER_BODY_", "BUSTER_CHECK_BODY_", "BUSTER_CHECK_SOURCE_DECLARATIONS"))}
    local = {**base,"BUSTER_BODY_LIVE_DIAGNOSTICS":"1","BUSTER_CHECK_BODY_SOURCE_ONLY":"1",
             "BUSTER_CHECK_BODY_ADMIT_ALL":"1","BUSTER_CHECK_SOURCE_DECLARATIONS":"1"}
    fields = ("wall-ms","user-ms","system-ms","peak-KiB","minor-faults")
    with (a.output/"samples.tsv").open("w") as samples, (a.output/"paired.tsv").open("w") as paired:
        sw = csv.writer(samples, delimiter="\t")
        pw = csv.writer(paired, delimiter="\t")
        sw.writerow(("unit","policy","round","slot","driver",*fields,"status","stdout-sha256","stderr-sha256"))
        pw.writerow(("unit","policy","rounds","faster",*["delta-"+f for f in fields]))
        for name, flags in frozen_args(a.sqlite.resolve(),a.self_source.resolve()).items():
            for policy, opts in (("default",[]),("wall",["-Wall","-Wextra"])):
                diffs = []
                for r in range(a.rounds):
                    observations = {"whole":[],"local":[]}
                    for n, mode in enumerate((["whole","local","local","whole"] if r%2==0 else ["local","whole","whole","local"])):
                        val = measure(a.compiler.resolve(), [*opts,*flags], local if mode=="local" else base, a.output)
                        observations[mode].append(val)
                        sw.writerow((name,policy,r+1,n+1,mode,*val))
                        samples.flush()
                    outputs = {x[5:] for both in observations.values() for x in both}
                    if len(outputs)!=1 or next(iter(outputs))[0]!=0:
                        raise RuntimeError(f"observable process result differs for {name}/{policy} round {r+1}")
                    diffs.append([statistics.mean(v[i] for v in observations["local"])-
                                  statistics.mean(v[i] for v in observations["whole"]) for i in range(len(fields))])
                pw.writerow((name,policy,len(diffs),sum(d[0]<0 for d in diffs),
                             *[statistics.median(d[i] for d in diffs) for i in range(len(fields))]))
                paired.flush()
    (a.output/"stdout").unlink()
    (a.output/"stderr").unlink()


if __name__=="__main__":
    main()
