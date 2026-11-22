"""Reproduce fresh-process comparisons with the patched compiler and the two frozen C inputs."""
import argparse
import csv
import hashlib
import json
import lzma
import os
from pathlib import Path
import subprocess
import tempfile

HERE = Path(__file__).resolve().parent
SELF_REV = "84a7d3d76891d6c393497e62e6aff38f2b162fc2"
SQLITE_SHA = "0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d"

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def run(binary, args, obj, env):
    clean = {k: v for k, v in os.environ.items() if not k.startswith(("BUSTER_BODY_", "BUSTER_CHECK_BODY_", "BUSTER_CHECK_SOURCE_DECLARATIONS"))}
    obj.unlink(missing_ok=True)
    res = subprocess.run([binary, "--lanes", "1", "-c", *args, "-o", obj], env={**clean, **env}, capture_output=True)
    if res.returncode:
        raise RuntimeError(f"status {res.returncode} for {binary}\n" + res.stderr[-4000:].decode(errors="replace"))
    return res, sha(obj) if obj.exists() else ""

def rows(data, mode):
    result = {}
    for line in data.decode().splitlines():
        if line.startswith("body-" + mode + "-row\t"):
            _, close, count, fingerprint = line.split("\t")
            key = int(close)
            if key in result:
                raise ValueError(f"duplicate declaration ending at {key}")
            result[key] = (int(count), fingerprint)
    return result

def compressed(path, data):
    path.write_bytes(lzma.compress(data, preset=6))

def frozen_args(sqlite, src):
    return {"sqlite": ["-DSQLITE_OMIT_LOAD_EXTENSION", "-DSQLITE_THREADSAFE=0", "-DSQLITE_ENABLE_MEMSYS5",
                        "-DSQLITE_ENABLE_RTREE", "-I" + str(sqlite.parent), sqlite],
             "buster": ["-march=native","-I" + str(src/"src"),"-fwrapv","-funsigned-char","--predefines",HERE/"predefines.h",src/"src/buster/compiler/main.c"]}

def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--compiler", type=Path, required=True)
    p.add_argument("--base-compiler", type=Path)
    p.add_argument("--sqlite", type=Path, required=True, help="SQLite 3.53.2 sqlite3.c")
    p.add_argument("--self-source", type=Path, required=True, help="clean Buster worktree at " + SELF_REV)
    p.add_argument("--output", type=Path, required=True)
    args = p.parse_args()
    binary, sqlite, src, dest = [p.resolve() for p in (args.compiler, args.sqlite, args.self_source, args.output)]
    if sha(sqlite) != SQLITE_SHA or sha(HERE / "predefines.h") != "40159bd8f0802b54dfc139a19f55df8d7b6adc1dec44d493ea9809ba5549bb00":
        raise ValueError("frozen source or predefined macros differ")
    if subprocess.check_output(["git", "-C", src, "rev-parse", "HEAD"], text=True).strip() != SELF_REV:
        raise ValueError("frozen Buster source revision differs")
    base = args.base_compiler.resolve() if args.base_compiler else None
    dest.mkdir(parents=True, exist_ok=True)
    names = frozen_args(sqlite,src)
    totals = []
    for name, flags in names.items():
        sub = dest/name
        sub.mkdir(exist_ok=True)
        with tempfile.TemporaryDirectory() as tmp:
            obj = Path(tmp)/"unit.o"
            normal, ref_hash = run(base or binary, flags, obj, {})
            compressed(sub/"ordinary.stderr.xz", normal.stderr)
            for scope in ("functions", "declarations"):
                markers = {"BUSTER_CHECK_SOURCE_DECLARATIONS": "1"} if scope == "declarations" else {}
                local, local_obj = run(binary, flags, obj, {**markers,"BUSTER_CHECK_BODY_SOURCE_ONLY":"1","BUSTER_CHECK_BODY_ADMIT_ALL":"1"})
                whole, whole_obj = run(binary, flags, obj, {**markers,"BUSTER_CHECK_BODY_WHOLE_FINGERPRINT":"1"})
                assert not local_obj and whole_obj == ref_hash and normal.stdout == whole.stdout
                assert normal.stderr == b''.join(l for l in whole.stderr.splitlines(keepends=True) if not l.startswith(b'body-whole-row\t'))
                compressed(sub/(scope+".source.stderr.xz"), local.stderr)
                compressed(sub/(scope+".whole.stderr.xz"), whole.stderr)
                a, b = rows(local.stderr,"source"), rows(whole.stderr,"whole")
                if a != b or not a:
                    raise ValueError(f"{name} {scope} mismatches in {len(set(a)^set(b))} keys and {sum(a[k]!=b[k] for k in a.keys()&b.keys())} rows")
                data = ["closing-token\tnodes\tsource-fingerprint\twhole-fingerprint"]
                data.extend(f"{key}\t{a[key][0]}\t{a[key][1]}\t{b[key][1]}" for key in sorted(a))
                compressed(sub/(scope+".tsv.xz"), ("\n".join(data)+"\n").encode())
                totals.append([name,scope,len(a),sum(n for n,h in a.values()),max(n for n,h in a.values()),ref_hash])
                print(*totals[-1],flush=True)
    with (dest/"totals.tsv").open("w") as f:
        w = csv.writer(f, delimiter="\t",lineterminator="\n")
        w.writerow(["input","scope","matched-roots","matched-nodes","largest-root-nodes","ordinary-object-sha256"])
        w.writerows(totals)
    (dest/"binaries.json").write_text(json.dumps({"compiler_sha256":sha(binary),"baseline_sha256":sha(base) if base else sha(binary)},indent=2)+"\n")

if __name__ == "__main__":
    main()
