# Reproducing the #1384 source checks

`validate1384.c` is the original C generator, reference-source generator, runtime
driver generator and child-RSS supervisor for this record. The commands below
run on a Linux cloud host with Buster's required AVX-512 extensions. They use no
remote host, hardware queue, workflow dispatch, or 9700X access. These are
correctness and memory observations; the supervisor reports no timings.

## Recorded compiler identity

The archived hosted product's `identity/summary` identifies:

| Field | Value |
|---|---|
| Repository ID | `1421805693` (`buster14a/buster`) |
| Hosted run | [45779319802](https://github.com/buster14a/buster/actions/runs/45779319802) |
| Revision | `8e4d32879e17b7d9548cad54257a2f8461328366` |
| Source tree | `8bf0a22e6067a7698ca6257d3e6cbe40f49b108a` |
| Product row | `vector none O3` |
| Toolchain identity | `eda0bc02300979a219273d969c9830eb0090c72d1fa357b24bc308ade5050259` |
| Build image | `ubuntu26 20261116.202.1` |
| Build libc | `glibc 2.43` |
| Compiler SHA-256 | `c090b5d35a9d031afe6a37771445dff87b9541d3521175c45001352164a2b2ff` |

Its host flags are `-march=x86-64-v4 -maes -mgfni -mvaes -mavx512vbmi
-mavx512vbmi2 -mavx512vpopcntdq -mavx512bitalg -mavx512vnni`. The local check
host reports an Intel Xeon Platinum 8370C. Build-image information above describes
the product's build environment, not the machine executing these checks.

The external oracle used here is Clang 23.1.4, LLVM revision
`7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`. The final eight-shape harness source
has SHA-256 `c9cba71c389d795e3d4d8052e5d51be0fa3c155ce54db71154621ca882f0089a`.
When checking another compiler, record its revision, configuration and executable
digest separately; do not reuse the hosted product's identity for it.

## Eight source families

| Shape | Generated subject | Compact reference |
|---|---|---|
| `or` | `return a == 0 || ... || a == N-1;` | `(unsigned)a < N` |
| `and` | `return a != 0 && ... && a != N-1;` | `(unsigned)a >= N` |
| `statements` | `r = r || g(a + i);` repeated for each constant `i` | A loop that stops calling `g` after its first true result |
| `nonlocal` | `{ int t = g(a + i); if (a > i) h(t); }` | A compact loop preserving every call and its order |
| `frame_local` | `{ char buf[32]; if (a == i) take(buf); }` | The same scope in a compact loop |
| `frame` | A zero-initialized 32-byte scoped array, two stores, unconditional `h_bytes`, and a conditional early return reading the array | A compact loop preserving those observations and the early return |
| `loops` | Distinct scoped `for (int i...)` loops feeding an unsigned sum | A closed-form unsigned sum |
| `returns` | `if (a == i) return i * 7;` repeated | A range-guarded multiplication |

`frame_local` reproduces the per-scope expression reported in
[#3521](https://github.com/buster14a/buster/pull/3521). The surrounding function,
declarations and `return a` are reconstructed here; the PR did not link a full
source generator. `frame` is a broader stress case and must retain its separate
name and results. A refusal in it must not be hidden by substituting
`frame_local` or counting a Tier 0 fallback as a Tier 1 success.

The accepted count is 1 through 1,000,000. Use the same count for subject,
reference and driver. The count cap and driver's bounded inputs keep generated
signed additions in range; sum/hash arithmetic uses unsigned wraparound.

## Replay one case

These Bash commands invoke the C harness. Set `BUSTER_EXE` to an independently
identified compiler executable and `ORACLE_CC` to the oracle Clang executable.
Run from the evidence directory containing `validate1384.c`.

```bash
set -e
ORACLE_CC=clang
BUSTER_EXE=/absolute/path/to/compiler
HARNESS=./validate1384
CASE_DIR=./replay
SHAPE=or
COUNT=64

"$ORACLE_CC" -std=c11 -O2 -Wall -Wextra -Werror validate1384.c -o "$HARNESS"
mkdir -p "$CASE_DIR"
case_path="$CASE_DIR/$SHAPE-$COUNT"
"$HARNESS" generate "$SHAPE" "$COUNT" "$case_path.c"
"$HARNESS" reference "$SHAPE" "$COUNT" "$case_path-reference.c"
"$HARNESS" driver "$COUNT" "$CASE_DIR/driver-$COUNT.c"
"$ORACLE_CC" -std=c17 -O2 -c "$CASE_DIR/driver-$COUNT.c" -o "$CASE_DIR/driver-$COUNT.o"
"$ORACLE_CC" -std=c17 -O2 -c "$case_path-reference.c" -o "$case_path-reference.o"

extra_objects=()
if [ "$SHAPE" = frame_local ]; then
    "$HARNESS" frame-stub "$CASE_DIR/frame-stub.c"
    "$ORACLE_CC" -std=c17 -O2 -c "$CASE_DIR/frame-stub.c" -o "$CASE_DIR/frame-stub.o"
    extra_objects=("$CASE_DIR/frame-stub.o")
fi
verification=()
if [ "$COUNT" -eq 64 ]; then
    verification=(--verify)
fi

"$HARNESS" run "$case_path-tier0.json" "$BUSTER_EXE" --lanes 1 -std=c17 \
    -c "$case_path.c" -o "$case_path-tier0.o" > "$case_path-tier0.compile.log" 2>&1
"$HARNESS" run "$case_path-tier1.json" "$BUSTER_EXE" --lanes 1 -std=c17 \
    --tier1 --tier1-strict --tier1-report "${verification[@]}" \
    -c "$case_path.c" -o "$case_path-tier1.o" > "$case_path-tier1.compile.log" 2>&1

for implementation in reference tier0 tier1; do
    "$ORACLE_CC" -no-pie "$CASE_DIR/driver-$COUNT.o" "${extra_objects[@]}" \
        "$case_path-$implementation.o" -o "$case_path-$implementation"
    "$case_path-$implementation" > "$case_path-$implementation.out"
done
cmp "$case_path-reference.out" "$case_path-tier0.out"
cmp "$case_path-reference.out" "$case_path-tier1.out"
```

`frame-stub` generates `void take(char *p) { (void)p; h(1384); }` with a
declaration of `h`. It neither reads indeterminate array bytes nor hashes
addresses. The same original driver object and, where applicable, stub object
must be linked against all three implementations. Do not use LTO to combine
the driver's stubs with the subject at compile time.

The reference's syntax stays small at every count. It lets Clang serve as an
independent native oracle without parsing the giant flat binary-expression
chains on which its parser can exhaust the stack. The reference is not a
Buster allocation or liveness implementation. All eight references were checked
against Clang-compiled unrolled subjects at `N=4` under UBSan, comparing 15
output rows each. Adding `frame_local` preserved all previous generated subject,
reference and driver bytes.

## Expected observations and sizes

Each run prints exactly 15 rows, in this input order:

```text
-2, -1, 0, 1, 2, 15, 16, 127, 511, 4092, 4093, N/2, N-1, N, N+1
```

Each row contains `a`, `result`, `g`, `h`, `bytes`, and `hash`. Compare the entire
output byte for byte with the compact reference, including the return value and
every counter; the retained `*-reference.out` files are the expected outputs.
Duplicates at small counts are intentional.

The driver resets its 64-bit hash to `cbf29ce484222325` for every input. Each
record applies this unsigned C expression:

```c
trace_hash = (trace_hash ^ ((uint64_t)tag << 32) ^ value) * UINT64_C(1099511628211);
```

Tag 1 records each `g` argument; tag 2 records each `h` argument; tag 3 records
the byte-buffer length; tag 4 records each observed byte in order. `g` returns
zero unless the low 12 bits of its argument equal 4093, in which case it returns
a bounded positive value. This exercises both continuing and terminating
short-circuit cases.

| Family | Additional exact expectations |
|---|---|
| `or`, `and`, `loops`, `returns` | All call counters are zero; the hash stays `cbf29ce484222325`. |
| `statements` | `g` counts calls up to the first true result or `N`; `h` and `bytes` are zero. |
| `nonlocal` | `g = N`; `h = min(max(a, 0), N)`; `bytes = 0`. |
| `frame` | `bytes = a + 1` for `0 <= a < N`, otherwise `N`; `g = h = 0`. |
| `frame_local` | `h = 1` and hash `af66e8b2860714d7` for `0 <= a < N`; otherwise `h = 0` and the initial hash. `g = bytes = 0` throughout. |

Run every family at `N=64` with `--verify`, as in the command above. Use
`N=8000`, `16000`, and `32000` for the scaling series, omitting `--verify`
while retaining `--tier1-strict --tier1-report`. This separates the small-case
certification checks from the large production compilation's storage. Keep
the broader `frame` series separate from the reported `frame_local` case,
including every refusal and its diagnostic.

The supervisor uses `fork`/`execvp`/`wait4`, preserves the child's exit status,
and writes `argv`, `exit_status`, `signal`, and Linux `max_rss_kib` to JSON.
Require successful exits, the Tier 1 report's successful compilation with zero
fallbacks/resource failures, and identical observable output. A smaller RSS
number from a failed or fallback compile is not an improvement. RSS is a
whole-process cloud observation, not an allocator-only byte count, a timing
result, or a Zen 5 performance qualification.

## Provenance

The harness, compact references, driver, stub and runtime fixtures are original
code written for this validation. The inputs are the documented shape, explicit
count, fixed sample values, and original arithmetic/control-flow definitions.
The shape descriptions come from issue #1384 and its follow-up PRs; no external
implementation or fixture file was imported. Clang is an external behavioral
oracle. Buster's hosted product retains the source and toolchain provenance
recorded by its own identity files. No Python or other supporting-code generator
is required to replay the record.
