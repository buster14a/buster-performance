#!/usr/bin/env bash
# Run from the workstation connected to Benchpress: bash benchpress-3596.sh
set -euo pipefail

if [[ $# == 0 ]]; then
    # Stage the script in a new directory. A disconnect leaves the remote job and its log intact.
    run_dir=$(tailscale ssh david@benchpress 'set -eu
        dir=$(mktemp -d "$HOME/buster-fast-bench/3596-codex.XXXXXXXX")
        cat > "$dir/run.sh"
        nohup setsid bash "$dir/run.sh" --remote "$dir" > "$dir/run.log" 2>&1 < /dev/null &
        echo $! > "$dir/pid"
        printf "%s\n" "$dir"' < "$0")
    [[ $run_dir =~ ^/[-a-zA-Z0-9_./]+/3596-codex\.[a-zA-Z0-9]+$ ]] || { echo "Unexpected remote directory: $run_dir" >&2; exit 1; }
    log_dir=$(dirname -- "$(realpath -- "$0")")
    log="$log_dir/benchpress-$(basename -- "$run_dir").log"
    printf 'Remote directory: %s\nLocal log: %s\n' "$run_dir" "$log"
    tailscale ssh david@benchpress "cd '$run_dir' && tail -n +1 --pid=\"\$(cat pid)\" -f run.log && test -f exit-status && exit \"\$(cat exit-status)\"" | tee "$log"
    exit
fi

[[ $# == 2 && $1 == --remote ]] || { echo "Usage: bash benchpress-3596.sh" >&2; exit 2; }
run=$2
trap 'status=$?; printf "%s\n" "$status" > "$run/exit-status.new"; mv "$run/exit-status.new" "$run/exit-status"' EXIT
model=$(awk -F': ' '/^model name/{ print $2; exit }' /proc/cpuinfo)
printf 'Host %s, CPU %s\n' "$(uname -n)" "$model"
[[ $model == *"Ryzen 7 9700X"* ]] || { echo "Expected Ryzen 7 9700X" >&2; exit 1; }
bench_home="$HOME/buster-fast-bench"
lock="$bench_home/exclusive.sh"
[[ -x $lock ]] || { echo "Missing shared lock: $lock" >&2; exit 1; }
if [[ -r $bench_home/README-9700x.md ]]; then cat "$bench_home/README-9700x.md" > "$run/host-instructions.md"; fi
export EXCLUSIVE_OWNER=codex-3596
export EXCLUSIVE_TITLE="PR 3596 direct compiler measurements"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3596
export CORES_TITLE="$EXCLUSIVE_TITLE" CORES_LINK="$EXCLUSIVE_LINK"
export BUSTER_CI_CACHE="${BUSTER_CI_CACHE:-${XDG_CACHE_HOME:-$HOME/.cache}/buster/ci}"
export BUSTER_HOST_ARCH=znver5 GIT_TERMINAL_PROMPT=0 LC_ALL=C
unset BUSTER_NO_DIRECT SOURCE_DATE_EPOCH BUSTER_TEST_NODE_BODIES BUSTER_TOOLCHAIN
base_sha=20f3573eebb641e30cfceed4089a4ac3430259f2
head_sha=cfc20db4503197e9a0bb1b6ed816462510cd907f
printf 'Base %s\nPR   %s\nRun  %s\n' "$base_sha" "$head_sha" "$run"

git init --quiet "$run/tree"
cd "$run/tree"
git fetch --quiet --no-tags --depth=2 https://github.com/buster14a/buster.git "$head_sha"
test "$(git rev-parse FETCH_HEAD)" = "$head_sha"
test "$(git rev-parse "$head_sha^2")" = "$base_sha"

build_cores=()
if command -v cores >/dev/null 2>&1; then build_cores=(cores -n 4 --); fi
for revision in base head; do
    if [[ $revision == base ]]; then sha=$base_sha; else sha=$head_sha; fi
    git -c advice.detachedHead=false checkout --quiet --detach "$sha"
    printf 'Building %s under the shared lock\n' "$revision"
    if ! "${build_cores[@]}" "$lock" timeout -k 10 600 ./build.sh --config Release --jobs 4 > "$run/$revision-build.log" 2>&1; then
        tail -n 50 "$run/$revision-build.log" >&2
        exit 1
    fi
    python3 - <<'COMPILER'
from pathlib import Path
import json, shlex, subprocess
rows = json.loads(Path("build/compile_commands.json").read_text())
row = next(r for r in rows if r["file"].endswith("/c_direct.c"))
argv = row.get("arguments") or shlex.split(row["command"])
assert "-O3" in argv and "-march=znver5" in argv, argv
version = subprocess.check_output([argv[0], "--version"], text=True).splitlines()[0]
assert "23.1.4" in version, version
print(version, "-O3 -march=znver5", flush=True)
COMPILER
    cp -L --reflink=auto build/compiler "$run/$revision"
    "$lock" timeout -k 5 60 taskset -c 2 "$run/$revision" test-direct
done

bash tools/ci/fetch-corpus.sh "$run/corpus"
bash tools/ci/hosted-offline.sh lua "$run/lua"
cat > "$run/measure.py" <<'MEASURE_PY'
from pathlib import Path
import csv
import hashlib
import os
import statistics
import subprocess
import sys
import time

run = Path(sys.argv[1])
workload = sys.argv[2]
verify_only = sys.argv[3:] == ["--verify-only"]
corpus = run / "corpus"
lua = run / "lua/src"
musl = corpus / "libc/musl"
output = run / (workload + ".o")
bins = [run / "base", run / ("base" if workload == "sqlite-aa" else "head")]
common = ["--lanes", "1", "--target=x86_64-linux-gnu", "-march=znver5", "-std=gnu17", "-c"]
frozen = ["--predefines", str(corpus / "provenance/gnu17-pinned-predefines.txt"), "-nostdinc"]
system = []
for inc in ("lib/clang/23/include", "local/include", "include"):
    system.extend(["-isystem", str(corpus / "headers/usr" / inc)])

if workload == "tiny":
    src = run / "tiny.c"
    src.write_text("int square(int x) { return x * x; }\n")
    sources, flags, pairs, repeats = [src], [], 48, 12
elif workload == "hex":
    src = run / "array-hex.c"
    values = [f"0x{(113 * i + 79 * (i // 8)) & 255:02x}" for i in range(131072)]
    rows = ["  " + ", ".join(values[i:i+12]) + ",\n" for i in range(0, len(values), 12)]
    src.write_text("const unsigned char pixels[] = {\n" + "".join(rows) + "};\n")
    assert hashlib.sha256(src.read_bytes()).hexdigest() == "10d34bb6fad8613f2ac57d449e3531b337a239f8576c220982da8fec096d863f"
    sources, flags, pairs, repeats = [src], [], 32, 4
elif workload in ("sqlite", "sqlite-aa"):
    sources = [corpus / "sqlite/sqlite3.c"]
    assert hashlib.sha256(sources[0].read_bytes()).hexdigest() == "0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d"
    flags = frozen + system + ["-DSQLITE_OMIT_LOAD_EXTENSION", "-DSQLITE_THREADSAFE=0", "-DSQLITE_ENABLE_MEMSYS5", "-DSQLITE_ENABLE_RTREE", "-I"+str(corpus/"sqlite")]
    pairs, repeats = 32, 1
elif workload == "lua":
    sources = sorted(lua.glob("*.c"))
    assert len(sources) == 34
    flags, pairs, repeats = frozen + system + ["-I"+str(lua)], 12, 1
elif workload == "musl-string":
    sources = sorted((musl / "src/string").glob("*.c"))
    assert len(sources) == 72
    includes = [musl/"arch/x86_64", musl/"arch/generic", corpus/"musl-generated/obj/include", musl/"src/include", musl/"src/internal", musl/"include", corpus/"headers/usr/lib/clang/23/include"]
    flags = frozen + ["-D_XOPEN_SOURCE=700"] + ["-I"+str(path) for path in includes]
    pairs, repeats = 12, 1
else:
    raise SystemExit("unknown workload: " + workload)

def compile_one(binary, source, extra=(), probe=False):
    cmd = [str(binary), *common, *extra, *flags, str(source), "-o", str(output)]
    result = subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE if probe else subprocess.DEVNULL)
    if result.returncode:
        if result.stderr:
            sys.stderr.buffer.write(result.stderr)
        result.check_returncode()
    return result.stderr

def route(report):
    lines = report.splitlines()
    if not any(line.startswith(b"time-process\ttokens\t") for line in lines):
        raise RuntimeError("Missing compiler stage report")
    # On these revisions the full driver requests a worker budget. The fused path goes straight to ELF.
    return "full" if any(line.startswith(b"worker-budget\t") for line in lines) else "direct"

if workload == "tiny":
    for binary in bins:
        assert route(compile_one(binary, sources[0], ["--time-stages", "--no-direct"], True)) == "full"

direct = 0
for source in sources:
    signatures = []
    for binary in bins:
        output.unlink(missing_ok=True)
        trace = compile_one(binary, source, ["--time-stages"], True)
        signatures.append((route(trace), hashlib.sha256(output.read_bytes()).digest()))
    if signatures[0] != signatures[1]:
        raise SystemExit("Object or compiler path changed for " + str(source))
    direct += signatures[0][0] == "direct"
if workload not in ("lua", "musl-string") and direct != 1:
    raise SystemExit("Expected direct compilation for " + workload)
print(f"Verified {workload}: {len(sources)} identical objects, {direct} direct, {len(sources)-direct} full driver", flush=True)
if verify_only:
    sys.exit(0)

if os.sched_getaffinity(0) != {2}:
    raise SystemExit("CPU affinity must be exactly CPU 2")
source_bytes = sum(p.stat().st_size for p in sources)
samples = []
with (run / (workload + ".tsv")).open("w") as raw:
    writer = csv.writer(raw, delimiter="\t")
    writer.writerow(["pair", "order", "base_ns", "comparison_ns", "sources_bytes", "processes_per_batch", "batches_per_sample"])
    for i in range(pairs + 2):
        order = (0, 1) if i % 2 == 0 else (1, 0)
        pair = [0.0, 0.0]
        for leg in order:
            start = time.perf_counter_ns()
            for _ in range(repeats):
                for source in sources:
                    compile_one(bins[leg], source)
            pair[leg] = (time.perf_counter_ns() - start) / repeats
        if i >= 2:
            samples.append(pair)
            writer.writerow([i - 1, "AB" if order[0] == 0 else "BA", *pair, source_bytes, len(sources), repeats])
a, b = (statistics.median(column) for column in zip(*samples))
ratios = [left/right for left, right in samples]
q1, _, q3 = statistics.quantiles(ratios, method="inclusive")
print(f"RESULT {workload:12s} base={a/1e6:.3f}ms comparison={b/1e6:.3f}ms paired={statistics.median(ratios):.3f}x IQR=[{q1:.3f},{q3:.3f}] pairs={len(samples)} source_GB/s={source_bytes/a:.3f},{source_bytes/b:.3f}", flush=True)
MEASURE_PY

for workload in tiny hex sqlite-aa sqlite lua musl-string; do
    printf 'Measuring %s\n' "$workload"
    "$lock" timeout -k 5 90 bash -c '
        snapshot() {
            cat /proc/loadavg
            ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8
        }
        snapshot
        taskset -c 2 python3 "$1/measure.py" "$1" "$2"
        status=$?
        snapshot
        exit "$status"
    ' _ "$run" "$workload"
done
printf 'Raw paired samples: %s/*.tsv\n' "$run"
