"""Compare two compilers on one group of ordinary frozen C files with common compile options."""
import argparse
import csv
import hashlib
import os
from pathlib import Path
import subprocess

POLICIES = {
    "default": (),
    "wall": ("-Wall", "-Wextra"),
    "strict": ("-Wall", "-Wextra", "-Werror"),
    "quiet": ("-w",),
    "everything": ("-Weverything",),
}


PACKED_OPTIONS = (
    "BUSTER_SOURCE_ROOT_CURSOR",
    "BUSTER_SOURCE_CONTROL_MASKS",
    "BUSTER_SOURCE_DIRTY_DIAGNOSTICS",
    "BUSTER_SOURCE_WARNING_INDEX",
    "BUSTER_SOURCE_CLOSE_CONTEXTS",
    "BUSTER_SOURCE_CLASS_CONSUMER",
    "BUSTER_SOURCE_BORROW_CHILDREN",
    "BUSTER_SOURCE_FIRST_NODE",
    "BUSTER_CONTROL_EARLY_RELEASE",
    "BUSTER_CONTROL_EARLY_NATIVE",
    "BUSTER_SOURCE_WRITE_COLUMNS",
    "BUSTER_SOURCE_FILE_DATA",
    "BUSTER_SOURCE_GROW_GRAPH",
    "BUSTER_SOURCE_RETIRE_LISTS",
    "BUSTER_CONTROL_SOURCE_NATIVE",
    "BUSTER_CONTROL_OBJECT_FIELDS",
    "BUSTER_OBJECT_TEXT_STREAM",
    "BUSTER_OBJECT_TEXT_RUNS",
    "BUSTER_OBJECT_DATA_SPANS",
    "BUSTER_OBJECT_EARLY_RELOCATIONS",
)


def digest(value):
    return hashlib.sha256(value).hexdigest()


def compile_one(compiler, flags, out, env):
    out.unlink(missing_ok=True)
    child = subprocess.run([compiler, "--lanes", "1", "-c", *flags, "-o", out],
                           env=env, stdin=subprocess.DEVNULL, capture_output=True, timeout=180)
    return child.returncode, digest(out.read_bytes()) if out.is_file() else "", child.stdout, child.stderr


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("compiler", type=Path)
    parser.add_argument("reference", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("group")
    parser.add_argument("options_and_sources", nargs=argparse.REMAINDER)
    args = parser.parse_args()
    sources = [arg for arg in args.options_and_sources if arg.endswith(".c")]
    if not sources:
        parser.error("supply the paths of the C translation units")
    options = [arg for arg in args.options_and_sources if not arg.endswith(".c") and arg != "--"]
    env = {k: v for k, v in os.environ.items() if not k.startswith(("BUSTER_CONTROL_", "BUSTER_BODY_", "BUSTER_CHECK_BODY_", "BUSTER_SOURCE_", "BUSTER_OBJECT_"))}
    args.output.mkdir(parents=True, exist_ok=True)
    total = exact = 0
    with (args.output / (args.group + ".tsv")).open("w", buffering=1) as result:
        table = csv.writer(result, delimiter="\t")
        table.writerow(("file", "policy", "ref-exit", "source-exit", "same-object", "same-stdout", "same-stderr",
                        "ref-stderr-size", "ref-stderr-sha", "source-stderr-sha", "ref-object-sha", "source-object-sha",
                        "ref-stdout-sha", "source-stdout-sha"))
        for i, path in enumerate(sources):
            for policy, switches in POLICIES.items():
                flags = [*options, *switches, path]
                a = compile_one(args.reference.resolve(), flags, args.output / (args.group + "-clean.o"), env)
                b = compile_one(args.compiler.resolve(), flags, args.output / (args.group + "-source.o"), env | dict.fromkeys(PACKED_OPTIONS, "1"))
                table.writerow((path, policy, a[0], b[0], *(int(x == y) for x,y in zip(a[1:],b[1:])), len(a[3]), digest(a[3]), digest(b[3]),
                                a[1], b[1], digest(a[2]), digest(b[2])))
                if a != b or args.group in ("main", "sqlite"):
                    for arm, outcome in (("clean", a), ("source", b)):
                        for channel, content in (("stdout", outcome[2]), ("stderr", outcome[3])):
                            (args.output / f"{args.group}-{i}-{policy}-{arm}.{channel}").write_bytes(content)
                exact += a == b
                total += 1
    print(f"{exact}/{total} complete source-object comparisons")
    return int(total != exact)


if __name__ == "__main__":
    raise SystemExit(main())
