# Calling convention: 24–63-byte SSE, SSEUP records (#2113), 2026-11-15

Evidence for [buster#2113](https://github.com/buster14a/buster/issues/2113) and its pull request
[buster#2802](https://github.com/buster14a/buster/pull/2802). By Claude in David's directed session
([the session](https://claude.ai/code/session_01NNmNQuzEQ7mTxBKK79sG6o)).

The pull request passes and returns the unions of a 16-byte vector and a longer array, of 24 to 63 bytes, as clang 23's
`<size / 8 x double>` (the calling-convention module and Tier 0). It also gives a `VECTOR` value that LLVM puts on the
stack a slot of its register's width, aligned to it. The measurements check that this doesn't cost a compile's default
path anything (the module classifies every type, and Tier 0 places every aggregate argument), and that GCC 16's
cross-check passes.

## Revisions

| Role | What |
| --- | --- |
| base | buster's main at `2ebfe68a856613e300231520af5e7ec5627708b6`, the pull request's merge-base |
| head | the pull request's commit `283fc2f1553f8b6dd3a696e77dd344ffe4d4b018`; its next commit, `965b8828`, changes only `docs/tier0.md` |

## Host and builds

The 9700X (`9700x/identities.txt`: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, GCC 16.2.1). Each tree was built by
`env BUSTER_DEBUG_INFO=0 ./build.sh --config Release` with the 9700X job's clang 23.1.4 (`9700x/build-*.log`). The
compilers' SHA-256s are in `9700x/identities.txt`, with the frozen `sqlite3.c`'s (`0a409f16…`, the compile-time step's
corpus at `/var/lib/buster-9700x/corpora/preprocessor-391e729af658`).

`scripts/run.sh HEAD` ran everything, each build, check and run holding `exclusive.sh`'s lock for itself alone (`ab`
takes it per run). The 9700X was busy: its runs waited behind other sessions' holds between 23:32 and 02:26 UTC.

## Results

**Correctness.** `9700x/drive.txt`: both compilers compile `sqlite3.c` (`-c` with the options below) to the same object
bytes. `9700x/cross-check.txt`: the head's `test-calling-convention --cross-check` with GCC 16.2.1 and clang 23.1.4
passes: both SSE fixtures (37 checks each), clang's and GCC's runs at 16, 32 and 64 bytes, the compiled runs against
both on Tier 0 and Tier 1, and the extension runs, 0 failures.

**The whole compile** (`9700x/sqlite-ab.txt`): `ab --rounds 3 --cpu 2` over `time-runs --runs 3 --copies 3` with base,
head and base again, of `-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5
-DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c`. One placement per build. Against base:

| Round | head wall | head user cycles | base-again wall | base-again user cycles |
| ---: | ---: | ---: | ---: | ---: |
| 1 | −0.05% | +0.30% | +0.30% | +0.56% |
| 2 | −0.20% | −0.01% | +0.23% | +0.21% |
| 3 | −0.12% | −0.11% | +0.25% | +0.26% |

Base's median is 123.2 to 123.6 ms wall and 597.7 to 598.8 M user cycles. Its instructions are 1,362.798 M, and the
head's 1,362.805 M (+7.3 k, +0.0005%), every process. The difference is within the floor that base-again sets.

**The module's benchmark** (`9700x/module-ab.txt`): `ab --rounds 6 --cpu 2` of `benchmark-calling-convention`, base
and head in a Williams order; the medians over the six rounds, cycles and instructions per type (per argument for
`assign`):

| Benchmark | base cycles | head cycles | Δ | base instructions | head instructions | Δ |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| classify-all 16-byte vector | 224.49 | 223.57 | −0.41% | 624.25 | 615.76 | −1.36% |
| classify-all 16-byte scalar | 380.89 | 378.77 | −0.56% | 1391.73 | 1383.24 | −0.61% |
| classify-all 32-byte vector | 247.53 | 246.39 | −0.46% | 664.56 | 656.05 | −1.28% |
| classify-all 32-byte scalar | 384.94 | 383.16 | −0.46% | 1397.19 | 1388.68 | −0.61% |
| classify-all 64-byte vector | 265.37 | 263.80 | −0.59% | 727.48 | 718.97 | −1.17% |
| classify-all 64-byte scalar | 386.33 | 385.31 | −0.27% | 1400.49 | 1391.97 | −0.61% |
| batches-1 vector | 197.12 | 196.31 | −0.41% | 869.16 | 860.67 | −0.98% |
| batches-1 scalar | 300.12 | 298.13 | −0.66% | 1306.53 | 1298.04 | −0.65% |
| batches-4 vector | 181.27 | 181.83 | +0.31% | 670.07 | 661.58 | −1.27% |
| batches-4 scalar | 309.77 | 308.21 | −0.51% | 1284.21 | 1275.72 | −0.66% |
| batches-16 vector | 165.18 | 168.20 | +1.83% | 569.58 | 561.09 | −1.49% |
| batches-16 scalar | 302.61 | 300.25 | −0.78% | 1275.81 | 1267.32 | −0.67% |
| assign vector | 19.15 | 19.19 | +0.18% | 47.25 | 47.13 | −0.25% |
| assign scalar | 52.44 | 52.56 | +0.24% | 164.28 | 162.90 | −0.84% |
| assign-simple vector | 16.05 | 16.12 | +0.40% | 39.23 | 39.23 | 0.00% |
| assign-simple scalar | 48.61 | 48.94 | +0.68% | 167.95 | 166.65 | −0.77% |

Classification runs 8.5 fewer instructions per type: the finishing step's short-record and refusal branches are gone.
Its cycles fall by 0.3% to 0.8% but for two batch lines. `batches-16` on the vector path was slower in every round
(base 164.9 to 166.4 cycles per type, head 166.1 to 172.6). Its median throttle (the dispatch slots Zen 5's power cap
takes) was 1.1 per type for base and 3.8 for head, and its mispredicts 2.20 and 2.26. `assign-simple`'s vector path,
whose code the pull request doesn't change, ran the same instructions 0.40% slower, which sets the placement and noise
floor of these single-placement builds near half a percent.

## Limitations

- One placement per build; no `build.sh shifts` series.
- The logs keep the lines the tools themselves print. `exclusive.sh`'s waiting messages, which name other sessions'
  holds, are left out. So are the builds' compile lines (only `build.sh:`'s own lines are kept).
