# Scratch-free tree construction for #2850

The ordinary C compile turns the parser's parent array into six traversal columns.
The redesign groups complete trees and uses the output buffers to hold the few
child edges that determine subtree boundaries. On frozen SQLite it removed three
temporary arrays, cut sized-traversal time by 8.2%, and retired 25.2 million
fewer user instructions in a fresh compile. Whole-compiler throughput was
0.083851 GB/s before and 0.083897 GB/s after. The nine paired rounds did
not resolve a wall-time improvement.

## Results

All times below are medians on CPU 2 of the Ryzen 7 9700X. Both executables
used the same Clang 23.1.4 Release build settings and baseline
`757df8ad0a2d49db9d8f3dbec720fd5c02076ab6`. Rebuilding the restored
candidate after the reader experiment reproduced the measured executable
byte for byte.

| Workload and measurement | Baseline | Redesign |
| --- | ---: | ---: |
| SQLite, fresh one-lane compile | 113.380 ms | 113.317 ms |
| SQLite, primary source bytes per second | 0.083851 GB/s | 0.083897 GB/s |
| SQLite, user instructions per compile | 1,274,019,844 | 1,248,825,547 |
| SQLite, instrumented `check-input` | 41.829 ms | 41.685 ms |
| SQLite, tree construction without sizes | 1.8355 ns/token | 1.6860 ns/token |
| SQLite, tree construction with sizes | 2.0675 ns/token | 1.8975 ns/token |
| SQLite, instructions per token with sizes | 48.328 | 12.497 |
| SQLite, temporary storage for the sized traversal | 8,593,644 B | 0 B |
| SQLite, fresh process peak RSS | 243,932 KiB | 244,054 KiB |
| Compiler translation unit, fresh one-lane compile | 587.948 ms | 588.693 ms |
| Compiler translation unit, tree construction without sizes | 2.1405 ns/token | 1.9740 ns/token |
| Compiler translation unit, tree construction with sizes | 2.4635 ns/token | 2.4620 ns/token |
| Compiler translation unit, temporary storage for the sized traversal | 29,202,804 B | 0 B |

SQLite's 716,136 tokens correspond to 9,507,037 primary source bytes.
The compiler input contains 2,433,566 preprocessed tokens. The storage rows
count `3 × (tokens + 1) × sizeof(uint32_t)` reserved by the old checker
for last children, end counts and subtree starts. The result columns still
occupy six words per token. Later passes reuse the scratch arena. SQLite's
process peak and fault counts were close in both arms.

The sized stage publishes 24 bytes per token. Its **logical output rate**
rose from 11.608 to 12.648 GB/s, a gain of 1.040 GB/s. Counting its four-byte
parent input gives 1.935 to 2.108 GB/s. Counting the original source against
the time spent in this stage gives 6.421 to 6.996 GB/s. These rates describe
a single traversal. The ordinary compile also preprocesses, checks, lowers
and emits the object. At SQLite's token count the measured stage saving is
0.122 ms per traversal. All rates use decimal GB.

At 1 GB/s the entire SQLite compile has 9.507 ms available. In the
instrumented candidate runs, preprocessing took 9.781 ms, `check-input`
took 41.685 ms, expression checking took 11.204 ms and `check-program`
took 22.949 ms.

SQLite finished sooner in five of nine paired rounds. Differences between
the two arm means within a round ranged from −1.080 to +0.273 ms. On the
larger compiler input, four of five rounds went to the baseline, and the
sized stage was flat. Median SQLite user cycles were 546.790 M and 545.734 M.
The staged counters and disassembly show what changed in the inner loop.
Sibling selection uses `vpconflictd`, the cross-block head uses
`vpgatherdd`, and `vpcompressd` packs the edges before propagation.

One additional experiment replaced sibling-list walks in the expression-value
reader with reverse walks over postorder subtree sizes. Against the selected
redesign it raised fresh SQLite wall time from 113.222 to 113.790 ms, with
all three paired rounds slower. Its patch and logs are under `walk/` in the
archive. The selected implementation ends at tree construction.

## Correctness

- SQLite, the compiler translation unit, and all 34 Lua 5.4.8 objects matched
  their baseline SHA-256 digests. The two SQLite objects each linked and ran
  an in-memory create, insert and sum query returning 26. Both versions also
  produced the same diagnostic and exit status for an invalid member access.
- The native parser suite passed with Clang, including 13,845 handoff streams,
  557 snippets, guarded vector tails, deep nesting and tiled parses. A separate
  Clang parser check passed on the frozen SQLite input. The four checker shards
  passed 835,260 checks, the attested checker passed its 31 checks, and the
  checker driver passed 55,533 checks with `--semantic-recovery-only`.
- A local ASan/UBSan run checked both traversal modes against the test suite's
  independent depth-first walk on 300 deterministic ordered forests. Accepting
  an unsafe cut made the new range regression report four failures. The local
  SQLite run with 16 text mutations and the Release call-graph check also
  passed. Compiling the same SQLite file with `--parse-tile` set to 0, 1, 16
  and 4096 produced identical objects across all four settings.

## Reproduction

The archive contains the candidate patch, both build logs, the native source
and executable hashes, disassembly, and per-invocation timing, counters,
stdout/stderr and lock records. Each timed invocation started a new pinned
process under its own shared lock and recorded load and the busiest processes
before and after the measurement. Warmups, stages and counters are separate
from plain wall time. Wall runs alternated ABBA and BAAB with two observations
per arm per round. Each tree sample is the parser benchmark's median of 21
passes with three traversals per pass. [Raw measurements](raw.tar.gz)

To inspect the recorded samples from this directory, run

```sh
mkdir -p replay
tar -xzf raw.tar.gz -C replay
python3 summarize.py replay/receipt
python3 summarize.py replay/self
```

With a patched checkout and an AVX-512 host, the separate memory-safety run
can be reproduced with `bash replay/local-checks/sanitize.sh /path/to/buster`.
Passing `mutate-cut` as its second argument exercises the failing boundary.

To rebuild on Benchpress, use a private directory and a Buster checkout at the
baseline above. From that checkout, with `evidence` pointing at this directory
and `run_dir` at the private run directory, run

```sh
export EXCLUSIVE_OWNER=tree-columns-replay EXCLUSIVE_TITLE='Tree column comparison'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
lock="$HOME/buster-fast-bench/exclusive.sh"
"$lock" timeout -k 5 540 ./build.sh --config Release --target compiler
cp build/compiler "$run_dir/compiler-base"
git apply "$evidence/replay/candidate.patch"
"$lock" timeout -k 5 540 ./build.sh --config Release --target compiler
cp build/compiler "$run_dir/compiler-edge"
```

The measurement driver acquires and releases the shared lock for each
invocation. For SQLite, run

```sh
cd "$run_dir"
python3 "$evidence/measure.py" compiler-base compiler-edge sqlite-results --mode wall --rounds 9
python3 "$evidence/measure.py" compiler-base compiler-edge sqlite-results --mode perf --rounds 3
for mode in stages tree tree-sizes
do
    python3 "$evidence/measure.py" compiler-base compiler-edge sqlite-results --mode "$mode" --rounds 2
done
```

The frozen compiler and Lua inputs are the ones used by the November 23
campaign. The compiler flags, official SQLite corpus path, and SQLite
feature definitions are recorded in the driver. [November 23 campaign](../takeover-2850-2026-11-23/README.md) · [Measurement driver](measure.py)

```sh
inputs="$HOME/buster-fast-bench/2850-claude-01Egbx/inputs"
python3 "$evidence/measure.py" compiler-base compiler-edge self-results --compiler-inputs "$inputs" --mode wall --rounds 5
for mode in tree tree-sizes
do
    python3 "$evidence/measure.py" compiler-base compiler-edge self-results --compiler-inputs "$inputs" --mode "$mode" --rounds 2
done
bash "$evidence/qualify.sh" compiler-base compiler-edge qualification "$inputs/lua-5.4.8/src"
```
