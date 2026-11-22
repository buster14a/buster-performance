"""Compare ordinary and declaration-local diagnostics on frozen SQLite and Buster source files."""
import argparse
import csv
import hashlib
import lzma
import os
from pathlib import Path
import subprocess

from reproduce import frozen_args

POLICIES = {"default": [], "wall": ["-Wall", "-Wextra"], "strict": ["-Wall", "-Wextra", "-Werror"],
            "quiet": ["-w"], "everything": ["-Weverything"]}


def observe(binary, flags, environment):
    try:
        process = subprocess.run([binary, *flags], env=environment, capture_output=True, timeout=90)
        return process.returncode, process.stdout, process.stderr
    except subprocess.TimeoutExpired as error:
        return 124, error.stdout or b"", error.stderr or b""


def sources(args):
    if args.sqlite:
        yield from frozen_args(args.sqlite.resolve(),args.self_source.resolve()).items()
    if args.lua_source:
        for path in sorted(args.lua_source.resolve().glob("*.c")):
            yield "lua/"+path.name, [path]
    if args.musl_source:
        root=args.musl_source.resolve()
        gen=args.musl_generated.resolve()
        flags=["-std=c99","-nostdinc","-ffreestanding","-D_XOPEN_SOURCE=700"]
        for include in (root/"arch/x86_64",root/"arch/generic",gen/"src/internal",root/"src/include",root/"src/internal",gen/"include",root/"include"):
            flags.extend(("-I",include))
        seen=set()
        for path in sorted(root.glob("src/*/*.c"))+sorted(root.glob("src/*/x86_64/*.c")):
            if path.name not in seen:
                seen.add(path.name)
                yield "musl/"+str(path.relative_to(root)), [*flags,path]


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--compiler", type=Path, required=True)
    p.add_argument("--sqlite", type=Path)
    p.add_argument("--self-source", type=Path)
    p.add_argument("--lua-source", type=Path)
    p.add_argument("--musl-source", type=Path)
    p.add_argument("--musl-generated", type=Path)
    p.add_argument("--output", type=Path, required=True)
    p.add_argument("--policy", choices=POLICIES, action="append")
    args = p.parse_args()
    if bool(args.sqlite)!=bool(args.self_source) or bool(args.musl_source)!=bool(args.musl_generated):
        p.error("provide SQLite and frozen compiler source together, or both musl source and generated headers")
    if not (args.sqlite or args.lua_source or args.musl_source):
        p.error("supply at least one corpus")
    args.output.mkdir(parents=True, exist_ok=True)
    env = {k:v for k,v in os.environ.items() if not k.startswith(("BUSTER_BODY_", "BUSTER_CHECK_BODY_", "BUSTER_CHECK_SOURCE_DECLARATIONS"))}
    local = {"BUSTER_BODY_LIVE_DIAGNOSTICS":"1", "BUSTER_CHECK_BODY_SOURCE_ONLY":"1",
             "BUSTER_CHECK_BODY_ADMIT_ALL":"1", "BUSTER_CHECK_SOURCE_DECLARATIONS":"1"}
    matched = total = 0
    with (args.output/"comparison.tsv").open("w") as output:
        summary = csv.writer(output, delimiter="\t")
        summary.writerow(("corpus","policy","source-status","ordinary-status","equal","source-bytes","ordinary-bytes",
                          "source-stderr-sha256","ordinary-stderr-sha256","receipt"))
        for corpus, flags in sources(args):
            for policy in args.policy or ["default","wall"]:
                directory = args.output/corpus/policy
                directory.mkdir(parents=True, exist_ok=True)
                receipt = directory/"source.receipt"
                receipt.unlink(missing_ok=True)
                command = ["--lanes","1","-c",*flags,*POLICIES[policy],"-o",directory/"unit.o"]
                ordinary = observe(args.compiler.resolve(), command, env)
                source = observe(args.compiler.resolve(), command, {**env,**local,"BUSTER_BODY_DIAGNOSTIC_RECEIPT":str(receipt.resolve())})
                for label, result in (("ordinary",ordinary),("source",source)):
                    (directory/(label+".stderr.xz")).write_bytes(lzma.compress(result[2]))
                (directory/"unit.o").unlink(missing_ok=True)
                equal = source == ordinary and receipt.is_file()
                summary.writerow((corpus,policy,source[0],ordinary[0],int(equal),len(source[2]),len(ordinary[2]),
                                  hashlib.sha256(source[2]).hexdigest(),hashlib.sha256(ordinary[2]).hexdigest(),
                                  receipt.read_text().strip() if receipt.exists() else ""))
                matched += equal
                total += 1
    print(f"{matched}/{total} exact comparisons with local publication")
    if total != matched:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
