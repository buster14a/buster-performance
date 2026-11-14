# Tier 1 CFG scaling acceptance for Buster #1356

**Status: run on 2026-11-13; both shapes scale linearly.** The results are in
[`results-2026-11-13-claude/`](results-2026-11-13-claude/README.md). The recipe
below is unchanged; that record lists its one deviation (how runs were grouped
into lock holds). This packet itself supplies original fixtures and a
reproduction recipe, not measurements or a speedup claim.

[Buster #1356](https://github.com/buster14a/buster/issues/1356) requires linear
growth of the `tier0` stage under `--tier1` for large switches and label tables.
[PR #1588](https://github.com/buster14a/buster/pull/1588) removed the three
reported quadratic edge scans and merged as
`17c554c053cac323f7bee458e5b3fb2a5ec87d61`. The acceptance snapshot selected on
13 November 2026 is main at **`b7a95eedbe16fbd8434654f192f8f7aab76c56e5`**. Measurements of
this later snapshot would establish its scaling, not isolate #1588's speedup
from the other changes between those revisions.

## Fixtures and oracle

`generate.c` accepts `switch` or `label-table`, a positive decimal case count
from 1 through 65,536, and optional `--driver`. Invalid arguments return 2
without writing a fixture; an output error returns 1. Its output is C source.

```sh
generate switch 16000 > switch-16000.c
generate switch 16000 --driver > switch-16000-driver.c
generate label-table 16000 > label-table-16000.c
generate label-table 16000 --driver > label-table-16000-driver.c
```

The timed source contains exactly one function, `int g(int a)`:

- `switch`: cases 0 through N-1 each return their index multiplied by 7;
  fallthrough returns 0, exactly the issue's independent-return shape.
- `label-table`: `static void* t[] = { &&L0, ... }`, followed by `goto *t[a]`;
  each `Li` independently returns i. There is no added bounds check or join.

The separate driver calls every valid index, compares the result with an
independent arithmetic expectation, reports mismatches, and returns failure
if any call disagrees. The switch driver also checks -1, N, N+1, `INT_MIN`
and `INT_MAX`. Out-of-range label-table calls are undefined and are not made.
Compile this driver separately with Clang and link it with Buster's object;
do not append it to the timed source or enable LTO. Keeping only `g` in the
timed translation unit makes a one-function strict Tier 1 report decisive.

The campaign sizes are **4,000, 8,000 and 16,000** for both shapes. The larger
generator limit is an input bound, not an additional required measurement.

## Prepare a fresh tree on Benchpress

Run the following Bash snippets in one shell on the approved Ryzen 7 9700X.
Use a private task directory and a clean checkout of the reviewed evidence
commit containing this packet. Record its exact commit; do not substitute a
moving compiler revision. Follow Buster's
[host guide](https://github.com/buster14a/buster/blob/b7a95eedbe16fbd8434654f192f8f7aab76c56e5/docs/commands/benchpress.md).

```bash
set -euo pipefail
export LC_ALL=C TZ=UTC
work="$HOME/buster-fast-bench/1356-codex"
evidence=/absolute/path/to/reviewed/buster-performance
packet="$evidence/docs/measurements/tier1-cfg-1356"
revision=b7a95eedbe16fbd8434654f192f8f7aab76c56e5
test ! -e "$work"
test -z "$(git -C "$evidence" status --porcelain)"
mkdir -p "$work"/{logs,inputs,drivers,objects,bin,raw}
git clone https://github.com/buster14a/buster.git "$work/compiler"
git -C "$work/compiler" checkout --detach "$revision"
test "$(git -C "$work/compiler" rev-parse HEAD)" = "$revision"
git -C "$evidence" rev-parse HEAD > "$work/evidence-revision.txt"
git -C "$work/compiler" rev-parse HEAD > "$work/compiler-revision.txt"
git -C "$work/compiler" status --porcelain > "$work/compiler-status.txt"
test ! -s "$work/compiler-status.txt"
export EXCLUSIVE_OWNER=codex-1356
export EXCLUSIVE_TITLE='Tier 1 switch and label-table scaling (#1356)'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1356
export CORES_TITLE="$EXCLUSIVE_TITLE" CORES_LINK="$EXCLUSIVE_LINK"

# One lock hold per command: the timeout limits execution after acquisition.
# Both busy snapshots are inside the hold; keep exclusive.sh's own stderr too.
locked()
{
    local log=$1 seconds=$2
    shift 2
    "$HOME/buster-fast-bench/exclusive.sh" bash -c '
        seconds=$1
        shift
        date -u +%FT%TZ
        printf "command:"
        printf " %q" "$@"
        printf "\n"
        cat /var/lib/buster-9700x/owner
        cat /proc/loadavg
        ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head
        run_status=0
        timeout -k 5 "$seconds" "$@" || run_status=$?
        cat /proc/loadavg
        ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head
        date -u +%FT%TZ
        printf "exit=%s\n" "$run_status"
        exit "$run_status"
    ' _ "$seconds" "$@" > "$log" 2>&1
}

cd "$work/compiler"
{
    uname -srvm
    LC_ALL=C lscpu
    clang --version
    cmake --version
    ninja --version
    cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
    cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference
    cat /sys/kernel/mm/transparent_hugepage/enabled
} > "$work/host.txt"
grep -Fq 'AMD Ryzen 7 9700X' "$work/host.txt"
build_command=(env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 BUSTER_SANITIZER=none BUSTER_FUZZ_AVAILABLE=0 BUSTER_PGO=0 ./build.sh --config Release --jobs 4)
if command -v cores > /dev/null; then
    build_command=(cores -n 4 -- "${build_command[@]}")
fi
locked "$work/logs/build.log" 480 "${build_command[@]}"
compiler="$work/compiler/build/compiler"
cp "$work/compiler/build/compile_commands.json" "$work/compile_commands.json"
cp "$work/compiler"/build/cmake/*/CMakeCache.txt "$work/CMakeCache.txt"
locked "$work/logs/build-generator.log" 60 clang -std=c17 -O2 -Wall -Wextra -Werror "$packet/generate.c" -o "$work/bin/generate"

for shape in switch label-table; do
    for n in 4000 8000 16000; do
        "$work/bin/generate" "$shape" "$n" > "$work/inputs/$shape-$n.c"
        "$work/bin/generate" "$shape" "$n" --driver > "$work/drivers/$shape-$n.c"
    done
done
sha256sum "$compiler" "$work/bin/generate" "$packet/generate.c" "$work"/inputs/*.c "$work"/drivers/*.c > "$work/identities.sha256"
```

Confirm the recorded CPU is the 9700X and that the build is Release/znver5.
Record any explicit environment overrides affecting compilation or huge-page
policy. If host power policy changes during the campaign, retain and label
that history before interpreting the combined samples.

## Qualify every generated function separately

These checks are outside the timed series. The report must contain exactly
one function and one successful Tier 1 compilation, with no fallback.
`--verify` belongs here only; it is absent from all timed invocations.

```bash
check_report()
{
    awk -F '\t' '
        $1 == "tier1" {
            reports++
            for (i = 2; i <= NF; i++) {
                split($i, field, "=")
                values[field[1]] = field[2]
            }
            good = values["functions"] == "1" && values["requested"] == "1" &&
                   values["admitted"] == "1" && values["compiled"] == "1" &&
                   values["unsupported"] == "0" && values["resource_failures"] == "0" &&
                   values["internal_failures"] == "0" && values["fallbacks"] == "0"
        }
        END { exit !(reports == 1 && good) }
    ' "$1"
}

for shape in switch label-table; do
    for n in 4000 8000 16000; do
        name="$shape-$n"
        locked "$work/logs/verify-$name.log" 120 taskset -c 2 "$compiler" -std=gnu17 --lanes 1 --tier1 --tier1-strict --tier1-report --verify -c "$work/inputs/$name.c" -o "$work/objects/$name.o"
        check_report "$work/logs/verify-$name.log"
        locked "$work/logs/link-$name.log" 60 clang -std=c17 -O2 -Wall -Wextra -Werror -no-pie "$work/drivers/$name.c" "$work/objects/$name.o" -o "$work/bin/$name"
        locked "$work/logs/run-$name.log" 60 taskset -c 2 "$work/bin/$name"
        sha256sum "$work/objects/$name.o" "$work/bin/$name" >> "$work/qualified.sha256"
    done
done
```

## Nine retained samples per point

This uses the existing
[`measure-compile`](https://github.com/buster14a/buster/blob/b7a95eedbe16fbd8434654f192f8f7aab76c56e5/src/buster/compiler/compile_measure.c)
clock and object-equality checks. One separately locked invocation contains
one bounded pair of compiler processes. There is one labeled warm-up pair per
point, followed by **nine measured pairs per point**. Point order rotates by
round; the entire sweep never holds the lock.

**Why `--runs 1 --warmups 0 --keep` is intentional:** `measure-compile`
overwrites its `errors.txt` for every child and retains only the final objects
and stderr, even with `--keep`. With zero references, one run and zero internal
warm-ups, its round-zero order is always default then time-stages. Each unique
directory therefore retains that pair's complete staged stderr, including
the Tier 1 report. A single `--runs 9 --keep` would not preserve all nine raw
stage reports. Changing the run count or adding references requires revisiting
this retention rule.

```bash
points=(switch:4000 switch:8000 switch:16000 label-table:4000 label-table:8000 label-table:16000)
printf 'sample\tshape\tn\treport\n' > "$work/samples.tsv"
shopt -s nullglob
for round in 0 1 2 3 4 5 6 7 8 9; do
    sample=$round
    if [ "$round" -eq 0 ]; then sample=warmup; fi
    for offset in 0 1 2 3 4 5; do
        point=${points[$(((round + offset) % 6))]}
        shape=${point%:*}
        n=${point#*:}
        pair="$work/raw/$sample/$shape-$n"
        mkdir -p "$pair"
        locked "$pair/run.log" 60 taskset -c 2 "$compiler" measure-compile --runs 1 --warmups 0 --directory "$pair" --keep -- -std=gnu17 --lanes 1 --tier1 --tier1-strict --tier1-report -c "$work/inputs/$shape-$n.c"
        reports=("$pair"/measure-compile-*/errors.txt)
        test "${#reports[@]}" -eq 1
        check_report "${reports[0]}"
        # Tie the measured code to the separately verified and executed object.
        cmp "$work/objects/$shape-$n.o" "${reports[0]%/errors.txt}/default.o"
        sha256sum "${reports[0]%/errors.txt}"/*.o >> "$work/measured-objects.sha256"
        printf '%s\t%s\t%s\t%s\n' "$sample" "$shape" "$n" "${reports[0]}" >> "$work/samples.tsv"
    done
done
sha256sum -c "$work/identities.sha256" > "$work/identities-after.log"
sha256sum -c "$work/qualified.sha256" > "$work/qualified-after.log"
```

Do not pass `--time-stages` after `--`: the command adds it to its staged
child itself, and passing it as a common argument would instrument both
members. Here `default` means the strict Tier 1 compile without stage clocks,
not Tier 0. Both members include the requested Tier 1 report.

Each `run.log` retains both process wall times, resource use and available
hardware counters, plus `measure-compile: 0 failures` and the wrapper's exit
status. Successful `measure-compile` requires both children to exit 0, a whole
stage report, and byte-identical default/staged objects. The recipe additionally
requires each measured object to match its separately verified and exhaustively
executed object, and records their hashes. Its successful raw
process rows do not print separate numeric child-status fields. The retained
`errors.txt` is the staged member's stderr; the default member's stderr was
overwritten. A failure stops the sweep and keeps its evidence. A timeout or
nonzero status is not a usable timing sample.

## Evaluate and publish

Keep all nine samples for each of the six points, their raw `errors.txt` and
`run.log`, the labeled warm-ups, object identities, source/build identities,
host record and busy-process snapshots. Archive the result under this
repository's `docs/measurements/`, preserving failed attempts and any explicitly
excluded contaminated runs. Do not overwrite this pending recipe with invented
results or silently replace the pinned compiler.

For each shape and N, report the median and minimum/maximum of the nine
`time-stage\ttier0` milliseconds and, separately, the default process wall
times. Report stage ns/case and the 4k-to-8k and 8k-to-16k growth ratios. The
issue asks for linear stage growth: approximately twice the work/time when N
doubles, rather than the old degree-squared growth. Assess the ratios with
the recorded spread; there is no automatic numeric pass threshold in this
packet. Leave #1356 open if either shape still shows superlinear growth or if
the evidence is incomplete. If the curves pass, link the immutable result
commit from #1356 and the compiler's CFG command guide.

Limitations: one compiler snapshot and one executable layout; fixed
default-then-stages order within each pair; report overhead present in both
members; no claim about the cause of small absolute-time differences, other
CFG shapes, or historical before/after speedup. The staged sample follows an
uninstrumented compile, so this is not a cold-start measurement. Whole-pipeline
costs can remain even though the three original edge scans are linear.

The generator and driver are original project material under
Apache-2.0 WITH LLVM-exception. Clang, libc and Buster are external build and
execution tools; no upstream implementation or fixture corpus is imported.
