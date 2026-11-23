# Tier 1's acceptance against clang -O2: run time, compile time and tests (buster#138, 2026-11-23)

[buster#138](https://github.com/buster14a/buster/issues/138) tracks Tier 1 against clang -O2, roadmap item 6. All of
its parts' issues were closed. This record measures its Done-when items at one revision:

- run time on speedtest1 and the Lua interpreter, against Tier 0, clang -O0, clang -O2 and tcc;
- the same builds' compile times;
- a fresh Csmith and YARPGen campaign at both tiers;
- the ABI cross-linking at Tier 1.

buster's `docs/tier1.md`, "#138's acceptance", has the summary.

- **Source:** buster `2e2d7674674653869203ef5dc5204a0e8574480e`, main `8d3002eb` with one commit: `measure-tier1-programs
  --compiles N`, which times the builds' compiles (buster's PR for #138). On the 9700X it was a clean clone of main's
  commit with that commit fetched from a bundle (`9700x/src.commit`). It was built there by `./build.sh --config
  Release`, with the 9700X job's toolchain, LLVM 23.1.4 (`9700x/build-src.log`, executable SHA-256 `70a1b35e…`).
- **Host:** the Ryzen 7 9700X (`benchpress`), Linux 6.18.50. Every build and run was one hold of the lock
  (`9700x/lock.sh`, owner `claude-138-acceptance`), and each log starts with the lock's own lines. `exclusive.sh`
  listed no other busy process at any hold. Timings are pinned to CPU 2.
- **Inputs, by their hashes** (`9700x/results/head-compiles5.env`): the frozen corpus's `sqlite3.c` (`0a409f16…`),
  SQLite 3.53.2's `test/speedtest1.c` (`b5eaf4bb…`), Lua 5.4.8's release (`4f18ddae…`) and the cc3387f record's five
  scripts. The scripts are the same bytes as the 9700X job's pin, buster-performance `818cfbbc`'s
  `tier1-reciprocal-141-2026-11-01/9700x/lua`. tcc 0.9.28rc is the job's pinned build (`49e2d1af…`), and clang is the
  job's 23.1.4.

## Run time and compile time

`9700x/programs.sh head-compiles5 --compiles 5` runs the 9700X job's own `measure-tier1-programs` step with `--compiles
5` added, in one hold of the lock: 11 rounds of the runs and 5 rounds of the compiles, each after one warm-up round, in
a Williams design's order. The run took 1 min 42 s. `9700x/results/head-compiles5.txt` has every run's and every
compile's line (`tier1-programs-run`, `tier1-programs-compile`), the medians and the tables.

Every build gave speedtest1's verification hash `1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739`, and each
Lua script's output was clang -O0's. Both code-size gates pass:

- `sqlite3.c`: 2,668 functions compiled by Tier 1, 872,558 bytes against clang -O0's 913,339;
- Lua's 34 units: 1,103 functions by Tier 1 and one fallback, 195,286 bytes against 248,990.

Run time, medians (Lua's are the sum of its five scripts' medians):

| Program | Tier 0 | `--tier1` | clang -O0 | clang -O2 | tcc | `--tier1` / -O2 | `--tier1` / -O0 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| speedtest1, ms | 218.9 | 146.2 | 269.5 | 129.4 | 269.6 | 1.13 | 0.54 |
| speedtest1, user cycles, M | 1,120.5 | 719.2 | 1,391.6 | 627.2 | 1,397.3 | 1.15 | 0.52 |
| speedtest1, instructions, M | 4,628.8 | 2,378.3 | 3,855.7 | 1,979.0 | 4,832.2 | 1.20 | 0.62 |
| Lua's five scripts, ms | 291.1 | 177.3 | 359.7 | 166.2 | 392.2 | 1.07 | 0.49 |
| Lua's five scripts, user cycles, M | 1,592.6 | 965.3 | 1,964.6 | 904.3 | 2,152.2 | 1.07 | 0.49 |
| Lua's five scripts, instructions, M | 9,335.6 | 4,524.8 | 8,290.5 | 4,250.0 | 9,393.0 | 1.06 | 0.55 |

By script, `--tier1` against clang -O2 by wall time:

| Script | `--tier1`, ms | clang -O2, ms | ratio |
| --- | ---: | ---: | ---: |
| calls | 20.2 | 18.0 | 1.12 |
| tables | 36.2 | 33.0 | 1.09 |
| strings | 42.4 | 37.1 | 1.14 |
| arithmetic | 27.8 | 32.9 | 0.85 |
| closures | 50.7 | 45.2 | 1.12 |

Compile time of the same builds, medians of 5 rounds. A build is speedtest1's two files or Lua's 33 sources, compiled
and linked. clang compiles speedtest1 as an object of each file and their link, and the others take it as one unit, as
the runs' builds are made:

| Build | Tier 0 | `--tier1` | clang -O0 | clang -O2 | tcc | `--tier1` / -O2 | `--tier1` / -O0 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| speedtest1, ms | 118.2 | 705.3 | 416.9 | 6,502.8 | 44.5 | 0.11 | 1.69 |
| speedtest1, user cycles, M | 573.2 | 3,803.3 | 2,188.5 | 35,851.6 | 232.0 | 0.11 | 1.74 |
| speedtest1, instructions, M | 1,334.6 | 9,303.1 | 4,990.3 | 51,813.7 | 573.1 | 0.18 | 1.86 |
| Lua, ms | 64.8 | 189.8 | 321.7 | 1,329.4 | 48.1 | 0.14 | 0.59 |
| Lua, user cycles, M | 298.1 | 965.8 | 1,460.9 | 6,938.4 | 236.3 | 0.14 | 0.66 |
| Lua, instructions, M | 735.1 | 2,206.2 | 3,016.1 | 10,890.2 | 599.4 | 0.20 | 0.73 |

### `-c sqlite3.c` alone

`9700x/compile.sh` runs `measure-compile --runs 7 --variant --tier1` on the frozen `sqlite3.c` with #136's flags, as
the evidence of 2026-11-12 on #138 measured it (`9700x/results/compile.txt`):

| Compile | wall ms (range) | user cycles, M | user instructions, M | wait4 peak, KiB |
| --- | ---: | ---: | ---: | ---: |
| default | 114.9 (114.5 to 115.3) | 558.5 | 1,298.5 | 245,496 |
| `--tier1` | 632.6 (632.2 to 633.6) | 3,406.6 | 8,400.5 | 339,492 |

The same tool with `--tier1` in the arguments and `--variant --tier1-no-inline` (5 runs,
`9700x/results/compile-inline.txt`; the command is in the file's first line) gives 632.8 ms against 397.4 ms, and
4,684.5 M user instructions without inlining. buster#2541's inlining is 235 ms of the compile, as its step 2 record
says ("the compile's growth is the code's"). On 2026-11-12, at main `d96b2e73`, `--tier1` took 424.7 ms for this
compile, and its code 1.42 and 1.39 times clang -O2's time.

## Coverage

`local/` has `--tier1-report` of the two programs' builds at the same commit (a Develop build in a cloud container,
one CPU; the counts don't depend on the host):

- speedtest1's unit: 1,420 of 1,420 emitted functions by Tier 1, after inlining expanded 7,299 calls;
- the Lua interpreter's 33 units: 1,087 of 1,088. The one left, `luaD_rawrunprotected`, calls `setjmp`
  (`tier1-refused ... cause=admission`, `fallback=tier0`).

## ABI cross-linking at Tier 1

`9700x/cross.sh` runs `test-calling-convention --cross-check` from the source tree in one hold, with clang 23.1.4 and
GCC 16.2.1 (`9700x/results/cross.txt`, `cross.env`; 6.9 s). Its compiled runs put this compiler on our side of random
signatures against clang and GCC at 16- and 64-byte vectors, and link our side by Tier 1 too, with and without frame
pointers:

| Run | Functions by Tier 1 | Checks | Failures |
| --- | ---: | ---: | ---: |
| clang, 16-byte vectors | 681 of 800 | 7,617 | 0 |
| clang, 16-byte vectors, frame pointers | 681 of 800 | 7,617 | 0 |
| GCC, 16-byte vectors | 737 of 800 | 7,618 | 0 |
| GCC, 16-byte vectors, frame pointers | 737 of 800 | 7,618 | 0 |
| clang, 64-byte vectors | 784 of 800 | 7,561 | 0 |
| clang, 64-byte vectors, frame pointers | 784 of 800 | 7,561 | 0 |
| GCC, 64-byte vectors | 793 of 800 | 7,035 | 0 |
| GCC, 64-byte vectors, frame pointers | 793 of 800 | 7,035 | 0 |

## Csmith and YARPGen

`differential/campaign.sh NAME SEED COUNT` runs buster#142's harness (`test-differential`) at the same commit:

- Csmith `0cdc7103` and YARPGen `1adb290f` (#142's pins), built from source;
- both of Buster's tiers (Tier 0 by default; `--tier1 -fno-asynchronous-unwind-tables --tier1-report`) against clang
  -O0 and -O2;
- a 30 s timeout a step;
- seeds 7000 to 7049, 7100 to 7149 and 7200 to 7249 of each generator, three campaigns of 100 programs.

It ran in a cloud container (4 CPUs, 15 GB, clang 23.1.6), the three campaigns at once. This is a correctness check
with no timing, as #139's record ran its campaigns. The 9700X has no YARPGen any more: `codex138-tools` is gone. The
compiler was a Develop build of the commit (`differential/compiler.sha256`); `differential/tools.txt` has the
generators' revisions and hashes. Each campaign directory keeps its summary, request, provenance, version probes, log
and a ledger of every case's steps (`ledger.tsv`, written by `differential/ledger.sh`). The generated programs aren't
kept.

| Generator | Programs | All four modes agree | Failed | Mismatches |
| --- | ---: | ---: | ---: | ---: |
| Csmith | 150 | 126 | 24 | 0 |
| YARPGen | 150 | 116 | 34 | 0 |
| Total | 300 | 242 | 58 | 0 |

Every failed case's first failure is a step of clang -O0's, the reference:

- **Csmith, 22 past the timeout:** 21 time out in every mode. In 7123, every mode times out but clang -O2's run, which
  exits with status 232.
- **Csmith, 2 at the output limit:** clang -O0's compile writes past the harness's output limit. In 7121 every compile
  does; in 7238 Buster's two tiers compile and run, and agree.
- **YARPGen, 23 past the small code model:** their arrays don't fit it. clang's link refuses them (`failed to convert
  GOTPCREL relocation`), and Buster's own link refuses them too, at both tiers ("the relocation's value does not fit
  its field").
- **YARPGen, 5 over the argument limit:** they call `test` with more than 239 arguments, past Tier 0's documented bound
  (buster's `docs/tier0.md`). Buster refuses them at both tiers ("unsupported: calls with more than 239 arguments"),
  and clang's link fails as above.
- **YARPGen, 5 linked by Buster alone:** Buster links them where clang's link fails, and its two tiers' outputs agree
  (7143, 7148, 7202, 7239, 7243).
- **YARPGen 7100:** Buster links it, but its `.bss` is 36.9 GB, and this host refuses to map that much (heuristic
  overcommit: a 36.9 GB anonymous `mmap` fails here too). Both tiers' executables die at exec with SIGSEGV before
  running any code.

Tier 1's coverage, from every program's `--tier1-report` (`differential/tier1-coverage.tsv`):

- Csmith: all 6,777 functions by Tier 1.
- YARPGen: 694 of 730. The 36 others were refused at selection (16 at a call, 20 at a parameter) and compiled by
  Tier 0. They are YARPGen's `test` functions with more than 64 parameters, past what Tier 1 passes; YARPGen 7014's has
  67 and is refused at a `param`.

There were no internal or resource failures.

## Left behind

`~/buster-fast-bench/138-claude-acceptance/` on the 9700X has the clone (`src`), its Release build, the scripts and the
results this record copies (about 1 GB with the build; safe to delete). The campaigns' generated programs stayed in the
cloud container and are gone with it; each ledger row and `failure.signature` here says what failed.
