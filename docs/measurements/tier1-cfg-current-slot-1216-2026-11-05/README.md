# Tier 1 CFG current-slot: bounded allocator comparison, 2026-11-05

This records a narrow diagnostic for [buster#1310](https://github.com/buster14a/buster/pull/1310) and [buster#1216](https://github.com/buster14a/buster/issues/1216). It is **not** the issue's speedtest1/Lua dynamic spill-traffic or end-to-end runtime acceptance.

## Inputs and method

- Host: AMD Ryzen 7 9700X, Linux x86-64, kernel `6.18.50-2-lts`; CPU 2. Clang reported `23.1.1`. The performance governor was observed after these runs; it was not independently logged under every run's lock.
- Reference source: `441db2428d2bd8d28503037b28c1b3740fe4b25a`. Compiler SHA-256: `265f2c48fa5923413eb206d87adff2d7c208a05c076d79f90fede01fa293c0dc`.
- Earlier PR head: `2140f341e2e364427a87286be80332ef8c258610`. Compiler SHA-256: `cb555c2001587194deddded95250b9604bd88557248c46a227512948e391c561`.
- Reviewed PR head: `30f5c5b03a52014cce8fada4bfa7fecd59eae300`. Compiler SHA-256: `8d59ec0daa227bad5033914352a97eb7f065c3c8baf28841d9823bdfc0b9b159`.
- The builds used `BUSTER_HOST_ARCH=znver5` and `BUSTER_DEBUG_INFO=0`. The new head build used `./build.sh --jobs 8`. Every build, count and timing used the shared `exclusive.sh` lock **separately**; they were not run under a single long lock.
- Workload: frozen `sqlite3.c`, SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, `/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c`. It is an external runtime input and is not included here.

The count command for each tree was:

```sh
EXCLUSIVE_OWNER=codex-1310 EXCLUSIVE_TITLE='PR 1310 sparse-prefix CFG count' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1310 \
  timeout 240s ~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler test-tier1-cfg-source "$SQLITE"
```

The allocator timing command for each tree was:

```sh
EXCLUSIVE_OWNER=codex-1310 EXCLUSIVE_TITLE="$TITLE" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1310 \
  timeout 240s ~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler benchmark-tier1-cfg-source --only cfg "$SQLITE"
```

For the fresh timing, `TITLE` was `PR 1310 baseline CFG timing` and then `PR 1310 sparse-prefix CFG timing`. The prior count used the same executable command and shared lock with the prior session's own owner/title labels. `--only cfg` reports a **21-pass median within one process**, not 21 independently randomized A/B pairs. The base and new head were timed in separate lock grants, base first; the head followed about three and a half minutes later after other host work. There was one process per revision, no randomized A/B order or uncertainty interval. Earlier baseline and earlier head timing logs are retained as additional context, also one process each; do not combine their medians as an independently paired result.

## Results and limits

Both reference and current head certified 2,600 functions on each allocator path; two functions were unsupported. The vector path's static CFG store count fell from 24,055 to 23,996 (59, or 0.25%); reloads remained 28,203. This is a static corpus count, not dynamic spill traffic or a generated-program runtime result. Raw counts and certificate totals are in `logs/`.

| Revision | CFG allocator ns / IR instruction | cycles / IR instruction | measured machine instructions / IR instruction |
| --- | ---: | ---: | ---: |
| reference `441db242` | 147.10 | 815.32 | 2,208.90 |
| current head `30f5c5b0` | 152.99 | 848.10 | 2,334.65 |

The single-process medians are respectively about 4.0%, 4.0%, and 5.7% higher at the current head. These observations are directional, not a statistically qualified regression estimate. The earlier PR head's separate median was 153.70 ns and 2,348.73 instructions per IR instruction, against its earlier baseline's 147.61 ns and 2,208.90 instructions. The prefix-only follow-up has not established that it removes the observed allocator cost. No generated-program speedup, issue acceptance, or full PR hardware qualification is claimed.

Hosted allocator correctness is separate from these timings: [hosted run 42077617422](https://github.com/buster14a/buster/actions/runs/42077617422) passed all eight correctness shards, including the new CFG fixtures on both hosted architectures; its required aggregate failed because draft status withheld hardware. The compiler PR remained draft at this stage pending performance assessment and normal qualification. The later edge-inlining follow-up is recorded below.

Timing and count logs are command output as collected and contain no other session's lock-holder details. `SHA256SUMS` records these files. No external source or binary is distributed in this evidence.

## Edge inlining follow-up

A separate one-process `perf record -e cycles:u -c 500000` of the `30f5c5b0` allocator benchmark gave 24K samples across the **whole command**, including preparation and verification; its text summary (trailing whitespace removed) is `logs/head-profile-summary.txt`. The raw capture remains on the private host because its header carries host metadata. This profile is a lead, not a before/after attribution. `nm -S` (`logs/symbol-sizes.txt`) shows that the baseline has no separately emitted `tier1_cfg_edge_value` symbol, whereas `30f5c5b0` emits three 708-byte copies. The baseline's inline decision changed when the new proof enlarged the edge helper.

Two minimal prototypes were built from `30f5c5b0` with the same Clang and build flags. Their exact patches, binary hashes, CFG-count outputs and allocator timings are in `logs/`:

- **Proof outlined only:** compiler SHA-256 `9d7fa1e7569f5229fa3e68129daafc54f3613bce83002974848eec2cbe11baf9`. The edge helper remained out of line. One 21-pass median was 153.03 ns and 2,336.27 machine instructions per IR instruction.
- **Edge forced inline and proof outlined:** the exact patch was later committed to buster as `b52cc4e5caced76edc36018b70e4d75aaf01a437`; compiler SHA-256 `2182087c2a09531c4551cb7125b216f3ee1e1d5057aa4b24af2f388e7b3117f1`. No separate edge helper appears in `nm`. Its two 21-pass medians were 149.79 and 149.87 ns, each with 2,229.49 machine instructions per IR instruction. The subsequent baseline median was 147.28 ns and 2,208.90 instructions. Both variants retained 23,996 static stores and certified 2,600 functions per allocator path.

Each prototype build, count and timing used its own shared lock; timings used the same command as above, with session-specific titles. The first baseline in the earlier table preceded the prototype by roughly 35 minutes; the second baseline followed the two prototype runs. These are a handful of separate processes without randomized order, placement variation or confidence intervals. They support the code-generation hypothesis but do not establish a general speedup or a statistically reliable size for the remaining cost. #1310 remains draft pending current-head hosted CI and a decision on the residual allocator cost against the small static-store reduction.
