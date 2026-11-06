# Zero-initialized locals by memset, Buster #1376

**Historical, nonqualifying archive.** The measurements below used grouped lock holds that violated the
9700X per-run lock policy. They must not qualify the compiler change or be interpreted as current-head
performance acceptance. Preserve these data as observations; run a separately coordinated, individually
locked repeat on the selected current compiler and base before using them for qualification.

Compiler issue: [#1376](https://github.com/buster14a/buster/issues/1376). Compiler PR: [#1548](https://github.com/buster14a/buster/pull/1548).
At this review the PR head was `a4d0289f1b3b640da2412c92f79394a95ebc7687` and main had advanced beyond
the base below. The measured head differs from that PR head in documentation and tests; this historical
record does not establish qualification of the newer head or base.

Frozen sources:

- Base: main `2dc50258e8b33393474b64032a5cbe9f17c63def`.
- Head: `ba2e80abf95ed0edcf01cb0191e5ded8d93a7135` (the branch's `bda58d19` and its memset-result fix).
- `fill8`: the head with `BUSTER_CHECK_LOWER_FILL_UNROLLED` set to 8 (`setup.sh`, `update.sh` and `host.txt`'s diff),
  the threshold's control: every clear past 8 bytes calls memset, as clang `-O0`'s code does.

The head clears a local object's zeros past 128 bytes with one call of `memset` instead of a counted loop of 8-byte
stores. It takes no clear before a first part that copies an aggregate of the object's size (`T x = *p;`,
`T x = f();`), and initializes `T x = (T){ ... };` in place instead of clearing, filling and copying the literal's own
object.

## Host and method

The Ryzen 7 9700X (`benchpress`), CPU 2 (governor and EPP `performance`), THP `always`, clang 23.1.1, CMake 4.4.4,
Ninja 1.13.2 (`host.txt`), recorded as a host snapshot rather than a per-sample receipt. Each tree was built with
`BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh`, with one lock invocation per build (`build.sh`,
`builds.sh`, `update.sh`; `builds.log` retains build lines and executable SHA-256 values). Positive build-lock
receipts and a build-time source/input manifest were not retained.

`run-all.sh` held the shared lock once around the entire `measure.sh` series, including compiler invocations,
links and 65 measured executables, and once around the entire `compile.sh` series, including all `time-runs`
processes and two follow-up compiles. **Neither hold was acquired separately per measured run, as host policy
requires.** The self-source script's lock invocation and positive per-run lock receipts were not retained in this
archive. Waiting messages identifying other sessions were omitted from the retained logs; the scripts and measured
rows remain historical evidence of what was run. The resulting timings are not qualification evidence.

**Kernels** (`k/kernel.c`, the issue's four and two more): each is compiled by each compiler (`-c`, and `-c --tier1`
for Tier 1), clang `-O0` and clang `-O2 -fno-vectorize`, and linked with one driver compiled by clang `-O2`
(`k/driver.c`). The driver calls each kernel 2,000,000 times, three passes, and prints the best pass in ns per call.
`measure.sh` runs every executable once per round, five rounds, in an order that rotates by round, pinned to CPU 2.
The tables are each executable's median over the five rounds (`summarize.sh`); `results/run-1793987627/kernels.txt`
and `sizes.txt` have every round, `sha256.txt` the objects and executables.

**Threshold** (`k/sz.c`, `k/szdrv.c`): `long a[N/8] = { 0 }` for N from 16 to 256 bytes, then a store and a load,
4,000,000 calls a size, the best of five passes, by the same rounds.

**Compile time**: `time-runs --runs 21 --warmups 2` of the head's executable compares base and head as whole
processes on `-c --lanes 1` of the frozen `sqlite3.c` (the CI's defines), in rotated order, at one executable
placement each (`compile.sh`, `results/compile-1793987650/time-runs.txt`).

## Results

ns per call, medians of five rounds:

| kernel | base Tier 0 | head Tier 0 | base Tier 1 | head Tier 1 | clang `-O0` | clang `-O2` |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `int a[256] = { 0 };` (array) | 26.290 | **4.290** (6.1×) | 26.792 | **3.426** (7.8×) | 4.330 | 4.430 |
| `long a[64] = { 1, 2, 3 };` (partial) | 12.443 | **2.600** (4.8×) | 12.644 | **2.164** (5.8×) | 2.347 | 2.683 |
| `struct Big b = { 0 };`, 328 bytes (struct) | 9.455 | **4.689** (2.0×) | 8.115 | **4.733** (1.7×) | 4.929 | 3.225 |
| `struct Big b = (struct Big){ .flags = i };` (literal) | 19.025 | **2.568** (7.4×) | 17.518 | **2.227** (7.9×) | 2.441 | 3.246 |
| `struct Big b = *p;` (copy) | 10.458 | **4.375** (2.4×) | 9.568 | **4.371** (2.2×) | 4.719 | 4.479 |
| `struct Big b = k_make(i);` (return) | 14.876 | 9.945 (1.5×) | 14.100 | 10.169 (1.4×) | 3.064 | 3.549 |

In these historical medians every kernel but `return` took at most 11% more than clang `-O0` in Tier 0 (`partial`,
2.600 against 2.347 ns) and no more than it in Tier 1. `return` keeps a temporary and a `memmove` into the object, where clang passes the object itself as the
hidden result pointer; the head only drops the clear before the copy.

The threshold, ns per call:

| bytes | base T0 | head T0 | fill8 T0 | base T1 | head T1 | fill8 T1 | clang `-O0` |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 16 | 1.082 | 1.085 | 3.248 | 1.082 | 1.082 | 4.872 | 1.085 |
| 32 | 1.301 | 1.301 | 3.253 | 1.082 | 1.082 | 4.871 | 1.090 |
| 64 | 1.737 | 1.737 | 2.164 | 1.082 | 1.082 | 1.984 | 1.093 |
| 96 | 2.209 | 2.210 | 1.984 | 1.352 | 1.352 | 1.984 | 1.105 |
| 128 | 2.676 | 2.676 | 2.165 | 1.713 | 1.713 | 1.984 | 1.367 |
| 136 | 4.147 | 2.525 | 2.164 | 4.147 | 2.525 | 2.164 | 1.454 |
| 192 | 5.409 | 2.525 | 2.166 | 5.409 | 2.524 | 2.164 | 1.722 |
| 256 | 7.577 | 2.524 | 2.169 | 6.852 | 2.166 | 2.168 | 2.082 |

Up to 128 bytes the reported head and base timings are close. The generated objects are not archived, so these
measurements alone do not prove machine-code equality. Past 128 bytes the reported loop cost grows with size while
the call cost is comparatively flat. Calling memset below 64 bytes (`fill8`) would cost 2 to 4.5 times the stores in both tiers. At 96 and
128 bytes, Tier 0's stores take 0.2 and 0.5 ns more than the call, and Tier 1's 0.6 and 0.3 ns less, so 128 stays the
threshold. Head and `fill8` call the same memset past 128 bytes and differ there by about 0.36 ns: their kernels' code
sits at different places, which this record doesn't separate.

Compile time of `sqlite3.c` (`-c --lanes 1`, one placement): base 139.411 ms median wall, head 139.719 ms (+0.22%);
user cycles 675.127 M against 676.760 M (+0.24%); instructions 1,636,696,182 against 1,636,707,749 (+11,567, +0.0007%).
Within a single placement's layout effect; no compile-time change is claimed.

Code shape (`objdump -dr` and `size -A` of the objects; `results/compile-1793987650/shape.txt`,
`results/self-1793988037/shape-and-sha256.txt`):

| unit | base `.text` | head `.text` | base memset calls | head memset calls |
| --- | ---: | ---: | ---: | ---: |
| frozen `sqlite3.c` | 1,279,192 | 1,278,280 | 268 | 269 |
| the compiler's own `main.c` at base, `-march=znver5` | 1,314,830 | 1,290,158 (−1.9%) | 107 | 278 |

These object summaries count memset relocation entries, not source locals. The extra 171 entries do not establish
that 171 source locals changed; the underlying objects are not included for independent inspection.

## Historical correctness context

The PR runs `test-checker --program-initializers` (1,414 checks: each path's shapes and native runs against clang
`-O0` on a dirtied stack) and the whole correctness inventory (`tools/ci/correctness.tests`, 126 commands) on a
Ryzen 9 7940HS native build; those are the PR's receipts, not this record's.

## Limitations

- Kernel timings are microbenchmarks of one call shape each; the `return` gap is left to a follow-up.
- Each compiler is one build at one code placement; the threshold's 96- and 128-byte differences are within the
  placement effect the head/`fill8` comparison past 128 bytes shows.
- The `sqlite3.c` and `main.c` shapes are counts from object files, not timings.


The committed [archive verifier](verify-archive.py) recomputes retained medians and checks fixture hashes, row
counts, per-round check totals and reported `time-runs` statuses. It does not recover omitted binaries, prove the
build-time source/input state or establish per-run locking. The original scripts are preserved as historical
records and must not be used to repeat a grouped-lock campaign.
