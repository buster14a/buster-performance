# #624's fragments forced on, on current main (#868), 2026-11-06

[#868](https://github.com/buster14a/buster/issues/868) asked to extend #624's
expression fragments past adjacent leaves. #883 tried that and measured it
slower ([pr883-fragment-placement-2026-10-31](../pr883-fragment-placement-2026-10-31/README.md)).
Later, #1235 (under #1048) made no compile take even #624's own fragments, as
they cost `sqlite3.c`'s lowering 0.27 ms. This record repeats that comparison on
current main, in an interleaved run on the locked Ryzen 7 9700X: the compile as it is, and the
same build with the fragments forced on, the path #868 would extend.

## What ran

- **Source:** buster14a/buster `ec5f0f6be04660d5b36ec688ba3d8ed3511ee85b`
  (main), plus `harness/toggle.patch`. That temporary, measurement-only line
  sets `CheckLowerWriter.fragments` when `BUSTER_868_FRAGMENTS` is in the
  environment. One executable runs both variants, so their code placement is
  the same.
- **Builds:** two full builds,
  `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 BUSTER_BUILD_DEFINES=-DBUSTER_CHECKER_OFFSET=N ./build.sh --config Release`,
  one with N = 0 and one with N = 2048. They place the checker's page-aligned
  code, where the lowering is, 2,048 bytes apart within the page
  (`check_lower_drain` at `0x19a1fe0` and `0x19a57e0`). Clang 23.1.1 and the
  executables' hashes are in `identity/`.
- **Inputs:**
  - the frozen corpus's `sqlite3.c` (sha256 `0a409f16…5e23d`), with the 9700X
    job's `measure-compile` options;
  - Lua 5.4.8's 34 units from the lua.org tarball (sha256 `4f18ddae…29ae`), with
    `-c -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX`.
- **Timing:**
  - 10 rounds, each under its own hold of the 9700X's lock (`exclusive.sh`),
    from 19:30 to 21:14 UTC. Other sessions' runs came between rounds.
  - In each round, both offsets, each with the fragments off and on. The
    variants' order alternated by round.
  - For each, `taskset -c 2 measure-compile --runs 11` on `sqlite3.c` and on
    each Lua unit: medians of 11 whole processes with `--time-stages` and 11
    without.
  - `raw/` has every output: 1,400 `measure-compile` runs, all with 0 failures.
    `rounds.tsv` (`harness/collect.sh`) takes each output's medians, Lua's
    summed over its units. `summary.txt` (`harness/summarize.sh`) pairs the
    variants by round and offset.
- **Objects and counters:** `objects/` has, for each build and variant, the
  objects' hashes and `--time-stages`' coverage. It also has perf's counters
  of 11 `sqlite3.c` compiles a variant, in the order off, on, on, off, at
  offset 0 (`harness/objects.sh`).

## Results

Every build and variant gave the same objects: `sqlite3.c`'s and all 34 of
Lua's, byte for byte.

| coverage (`lowering-nodes`) | off | on |
| --- | ---: | ---: |
| `sqlite3.c`: batched of 266,735 evaluated | 0 | 14,564 (5.46%), 14,666 classified |
| Lua's units: batched of 67,586 evaluated | 0 | 3,068 (4.54%) |

Medians over the 10 rounds, both offsets together (ms). Each paired
difference is "on" minus "off", from the same round and offset:

| input, row | off | on | on − off, median (range) | pairs above 0 |
| --- | ---: | ---: | ---: | ---: |
| `sqlite3.c` `lower` | 10.305 | 10.728 | +0.431 (+0.352 to +0.513) | 20 of 20 |
| `sqlite3.c` `lower.statements` | 6.700 | 7.119 | +0.429 (+0.302 to +0.529) | 20 of 20 |
| `sqlite3.c` stage span | 139.494 | 139.855 | +0.338 (−0.089 to +0.859) | 19 of 20 |
| `sqlite3.c` default wall | 140.548 | 140.758 | +0.390 (−0.228 to +1.113) | 19 of 20 |
| Lua's units' `lower`, summed | 5.959 | 6.060 | +0.111 (−0.039 to +0.185) | 18 of 20 |
| Lua's units' `lower.statements`, summed | 2.301 | 2.407 | +0.105 (+0.059 to +0.138) | 20 of 20 |
| Lua's units' default wall, summed | 154.561 | 154.512 | +0.158 (−2.468 to +2.394) | 11 of 20 |

Each offset alone shows the same thing (`summary.txt`): `sqlite3.c`'s `lower`
rose by +0.428 ms at offset 0 and by +0.432 ms at 2048, 10 of 10 pairs each.

perf's counters on `sqlite3.c`, 11 compiles a variant:

| | off | on | on | off |
| --- | ---: | ---: | ---: | ---: |
| user cycles | 683.27 M | 683.69 M | 688.19 M | 686.48 M |
| user instructions | 1,636.29 M | 1,640.33 M | 1,640.33 M | 1,636.29 M |
| user branch misses | 4.685 M | 4.687 M | 4.686 M | 4.687 M |

## Reading

- **The fragments cost more than they save.** Forced on, they take 5.46% of
  `sqlite3.c`'s evaluated nodes and 4.54% of Lua's, and make the lowering
  slower on both inputs:
  - `sqlite3.c`'s `lower` +0.43 ms (4.2%), every pair at both placements;
  - Lua's units' statements +0.105 ms, every pair.
- **The cost grew.** #1235's run measured 0.27 ms on an earlier base. Since
  then, the tasks' loop has become cheaper per node, and a fragment's proof
  hasn't.
- **No speedup is claimed.** A larger fragment would extend a path that
  doesn't pay at its present coverage, and #883 measured that extension
  slower again.

The toggle exists only in this harness; main's compiles keep the fragments off.

## Limits

- Two code placements of the checker's section, not #883's six.
- One machine and one toolchain (Clang 23.1.1 on benchpress).
- Lua's whole-process times are sums of 34 short processes, and their spread
  covers the lowering's difference.
- The images and objects themselves aren't kept; `identity/` and `objects/`
  pin their hashes.
- No lock logs or other sessions' commands are included.
