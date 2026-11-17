# Tier 1: the SSE, SSEUP records whose payload no register is as wide as (#2798), 2026-11-17

Evidence for [buster#2798](https://github.com/buster14a/buster/issues/2798) and its pull request
[buster#2905](https://github.com/buster14a/buster/pull/2905). By Claude in David's directed session
([the session](https://claude.ai/code/session_01NNmNQt2NpXzuczEKuiAcWF)).

The pull request makes Tier 1 pass and return #2113's 24–63-byte records (clang's `<size / 8 x double>` in a ymm or
zmm register wider than the record, or alone in a stack slot of that register's width), which it left to Tier 0. The
measurements check that this costs a `--tier1` compile nothing, that the objects of a program without such records
don't change, and that GCC 16's cross-check passes with the strict fixture.

## Revisions

| Role | What |
| --- | --- |
| base | buster's main at `d876a5e0f0252407e467e95dc602b3ad26895f9d`, the pull request's merge-base |
| head | the pull request's commit `43d37cd296d8964d6809a8afaf908758ff2864eb`; its next commit, `298f6153`, adds a check to the code certificate, which runs under `--verify` alone, so these timings stand for it |

## Host and builds

The 9700X (`9700x/identities.txt`: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, GCC 16.2.1). Each tree was built by
`env BUSTER_DEBUG_INFO=0 ./build.sh --config Release` with the 9700X job's clang 23.1.4 (`9700x/build-*.log`). The
compilers' SHA-256s are in `9700x/identities.txt`, with the frozen `sqlite3.c`'s (`0a409f16…`, the compile-time step's
corpus at `/var/lib/buster-9700x/corpora/preprocessor-391e729af658`).

`scripts/run.sh BASE HEAD` ran everything, each build, check and run holding `exclusive.sh`'s lock for itself alone (`ab`
takes it per run). Other sessions' holds came between them (the waits are in `9700x/drive.txt` and
`9700x/sqlite-ab.txt`).

## Results

**Correctness.** `9700x/drive.txt`: base and head compile `sqlite3.c` (the options below) to the same object bytes, by
`--tier1` and by Tier 0. `9700x/cross-check.txt`: the head's `test-calling-convention --cross-check` with GCC 16.2.1 and
clang 23.1.4 passes: both SSE fixtures with strict Tier 1 (37 checks each), clang's and GCC's runs at 16, 32 and 64
bytes, the compiled runs against both on Tier 0 and Tier 1 (with and without frame pointers), and the extension runs, 0
failures.

**The whole `--tier1` compile** (`9700x/sqlite-ab.txt`): `ab --rounds 3 --cpu 2` over `time-runs --runs 3 --copies 3`
with base, head and base again, of `--tier1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0
-DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c`, the object in `/dev/shm`. One placement per
build. Against base:

| Round | head wall | head user cycles | base-again wall | base-again user cycles |
| ---: | ---: | ---: | ---: | ---: |
| 1 | +0.09% | +0.12% | −0.12% | −0.05% |
| 2 | +0.09% | +0.11% | +0.05% | +0.08% |
| 3 | +0.03% | +0.12% | −0.06% | −0.01% |

Base's medians are 627.3 ms wall and 3,369 M user cycles. Instructions are 8,339.764 M for base and 8,339.736 M for the
head (−28 k, −0.0003%), every process within 60 of its build's median. The head retires fewer instructions but reads
0.11% to 0.12% more user cycles in every round, past base-again's floor of ±0.08%; with less work retired, the likely
cause is the head's code placement, which this single-placement run doesn't separate (not investigated further). The
wall time difference, +0.03% to +0.09%, is within base-again's.

## Limitations

- One placement per build; no perf profile of the cycle difference.
- The compile measured has no record of #2113's shapes: it checks the cost of the selection's changed paths, which
  every by-value aggregate argument and parameter goes through, not the code Tier 1 now writes for those records,
  which no program in the corpora uses.
