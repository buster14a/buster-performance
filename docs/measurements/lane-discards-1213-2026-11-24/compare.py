"""Compare Linux VM calls, child rusage and compiler products. See README.md."""

import argparse
import csv
import gzip
import hashlib
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile


def build_inputs(base, root, lua):
    for shape, units, functions in (("empty", 256, 0), ("small", 256, 3), ("synth", 64, 200)):
        directory = root / shape
        directory.mkdir()
        if functions:
            subprocess.run([base, "test-check-units", "--generate", directory, "--units", str(units),
                            "--functions", str(functions)], check=True)
        else:
            for i in range(units):
                (directory / f"unit{i + 1}.c").touch()
    sources = {shape: sorted((root / shape).glob("*.c")) for shape in ("empty", "small", "synth")}
    sources["lua"] = sorted(p for p in lua.glob("*.c") if p.name not in ("ltests.c", "onelua.c"))
    if len(sources["lua"]) != 33:
        raise ValueError("expected the 33 translation units of the Lua 5.4.8 Git tree")
    sources["lua-link"] = sources["lua"]
    return sources


def compile_once(compiler, shape, inputs, lanes, parent, reference, prefix=()):
    with tempfile.TemporaryDirectory(dir=parent) as cwd:
        options = ["-o", "lua-bin"] if shape == "lua-link" else ["-c"]
        args = [*prefix, compiler, "--lanes", str(lanes), *options, *inputs]
        if shape == "lua-link":
            args += ["-lm", "-ldl"]
        with tempfile.TemporaryFile() as diagnostics:
            process = subprocess.Popen(args, cwd=cwd, stdout=diagnostics, stderr=diagnostics)
            _, status, usage = os.wait4(process.pid, 0)
            process.returncode = os.waitstatus_to_exitcode(status)
            diagnostics.seek(0)
            messages = diagnostics.read()
        if process.returncode:
            raise RuntimeError(f"{compiler} {shape} exited {process.returncode}: {messages!r}")
        products = sorted(Path(cwd).iterdir())
        if len(products) != (1 if shape == "lua-link" else len(inputs)):
            raise RuntimeError(f"missing {shape} products")
        manifest = "".join(f"{hashlib.sha256(p.read_bytes()).hexdigest()}  {p.name}\n" for p in products)
        signature = manifest, messages
        if reference.setdefault(shape, signature) != signature:
            raise RuntimeError(f"{compiler} {shape} differs in products or diagnostics")
        return usage


CALLS = ("mmap", "mprotect", "munmap", "ioctl", "madvise", "process_madvise", "pidfd_open")
FIELDS = (*CALLS, "madvise_DONTNEED", "process_madvise_DONTNEED", "positive_vector_returns",
          "vector_errors", "six_MiB_scalar_discards")


def count_calls(trace):
    counts = dict.fromkeys(FIELDS, 0)
    for line in trace.read_text().splitlines():
        start = re.match(r"\d+\s+(\w+)\(", line)
        resumed = re.match(r"\d+\s+<\.\.\. (\w+) resumed>", line)
        if start and start[1] in CALLS:
            name = start[1]
            counts[name] += 1
            if name in ("madvise", "process_madvise") and "MADV_DONTNEED" in line:
                counts[name + "_DONTNEED"] += 1
            if name == "madvise" and ", 6291456, MADV_DONTNEED" in line:
                counts["six_MiB_scalar_discards"] += 1
        elif resumed:
            name = resumed[1]
        else:
            continue
        if name == "process_madvise":
            if re.search(r"= [1-9][0-9]*$", line):
                counts["positive_vector_returns"] += 1
            if re.search(r"= -1 [A-Z]+", line):
                counts["vector_errors"] += 1
    return counts


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("base", "candidate", "lua", "output"):
        parser.add_argument(name, type=lambda path: Path(path).resolve())
    args = parser.parse_args()
    args.output.mkdir()
    raw = args.output / "raw"
    raw.mkdir()
    cpus = sorted(os.sched_getaffinity(0))
    if len(cpus) < 4:
        raise ValueError("four permitted CPUs required")
    os.sched_setaffinity(0, cpus[:4])
    os.environ.update({"LC_ALL": "C", "SOURCE_DATE_EPOCH": "1700000000"})
    builds = (("base", args.base), ("candidate", args.candidate))
    reference = {}
    with tempfile.TemporaryDirectory() as temp, (args.output / "traces.tsv").open("w") as traces, \
            (args.output / "rusage.tsv").open("w") as rusage:
        root = Path(temp)
        sources = build_inputs(args.base, root, args.lua)
        trace_table = csv.writer(traces, delimiter="\t", lineterminator="\n")
        usage_table = csv.writer(rusage, delimiter="\t", lineterminator="\n")
        trace_table.writerow(["shape", "units", "lanes", "build", *FIELDS])
        usage_table.writerow(["shape", "units", "lanes", "pair", "build", "minflt", "majflt", "peak_KiB"])
        trace = root / "calls"
        for shape, inputs in sources.items():
            for lanes in (1, 4):
                for name, compiler in builds:
                    prefix = ["strace", "-f", "-qq", "-e", "trace=" + ",".join(CALLS), "-o", trace]
                    compile_once(compiler, shape, inputs, lanes, root, reference, prefix)
                    counts = count_calls(trace)
                    if name == "candidate" and (counts["positive_vector_returns"] == 0 or
                                                counts["positive_vector_returns"] != counts["process_madvise"]):
                        raise RuntimeError(f"{shape} needs a successful vector advice trace on an unfiltered kernel")
                    trace_table.writerow([shape, len(inputs), lanes, name, *[counts[k] for k in FIELDS]])
                    with trace.open("rb") as src, gzip.open(raw / f"{shape}-{lanes}-{name}.txt.gz", "wb") as dst:
                        shutil.copyfileobj(src, dst)
                for pair in range(1, 6):
                    for name, compiler in (builds if pair % 2 else reversed(builds)):
                        u = compile_once(compiler, shape, inputs, lanes, root, reference)
                        usage_table.writerow([shape, len(inputs), lanes, pair, name, u.ru_minflt, u.ru_majflt, u.ru_maxrss])
            print(f"{shape} products and diagnostics matched", flush=True)
        for call in ("pidfd_open", "process_madvise"):
            prefix = ["strace", "-f", "-qq", "-e", "trace=" + call, "-e", "inject=" + call + ":error=EPERM", "-o", trace]
            compile_once(args.candidate, "lua-link", sources["lua-link"], 4, root, reference, prefix)
            if "(INJECTED)" not in trace.read_text():
                raise RuntimeError(f"{call} injection was not exercised; use an unfiltered kernel with vector advice")
            shutil.copyfile(trace, raw / f"denied-{call}.txt")
            print(f"{call} denied, Lua link matched", flush=True)
        with (args.output / "products.tsv").open("w") as products:
            print("shape\toutputs\tmanifest_SHA256\tdiagnostic_bytes", file=products)
            for shape, (manifest, messages) in reference.items():
                digest = hashlib.sha256(manifest.encode()).hexdigest()
                print(shape, manifest.count("\n"), digest, len(messages), sep="\t", file=products)


if __name__ == "__main__":
    main()
