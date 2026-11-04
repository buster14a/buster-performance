# Rerunning the two-host micro-architecture campaign

This harness measured [the record one level up](../README.md). It runs the compiler
under perf on any Zen 4 or Zen 5 host and reduces the raw outputs to tables. It
changes no host setting and needs no root: `perf_event_paranoid` must allow
per-thread counting and sampling of the kernel (`-1` on both measured hosts), and
the IBS PMUs (`ibs_op`, `ibs_fetch`) and LBR (`-j any,u`) must be present.

## Files

- `uarch.c` — the runner and reducer (C17; `run.sh` builds it with clang on first
  use). `time`, `stat`, `sweep`, `metrics` and `fanout` run processes and write raw
  files; `summarize`, `stages`, `symbols`, `branches`, `memory` and `topdown` only
  read them. Every run command resumes: a run whose status file exists is skipped,
  so an interrupted step continues where it stopped.
- `run.sh` — the steps (listed in its header). Each step, or each chunk of a long
  one, takes the host's lock or core grant itself, for that chunk alone.
- `workloads.sh` — the workloads, as command lines relative to the run root.
- `hosts/zen4-7940hs.sh`, `hosts/zen5-9700x.sh` — each host's lock, CPUs, event
  names that differ between generations, dispatch width and chunk sizes. A new host
  needs a profile like these.
- `tables.sh` — the report's tables from one or more hosts' results.

## The run root

```text
ROOT/
  harness/                 this directory
  bin/compiler-znver4      ./build.sh with BUSTER_HOST_ARCH=znver4
  bin/compiler-znver5      ./build.sh with BUSTER_HOST_ARCH=znver5
  bin/compiler-x86-64      ./build.sh with BUSTER_HOST_ARCH=x86-64 (the scalar host)
  bin/compiler-pre1049-*   (ab1049, ab3) builds of other commits
  corpus -> .../preprocessor-391e729af658   the frozen corpus
  self-main.i              the compiler's main.c, preprocessed (below)
  predefines-znver5.h      clang -dM -E -march=znver5 -fwrapv -funsigned-char -x c /dev/null
```

The corpus is the project's frozen CI corpus: `bash tools/ci/fetch-corpus.sh DIR`
from a Buster checkout fetches and verifies it (on the 9700X it is
`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`). Link it as `corpus`, so
that every command names the same relative paths on every host; the objects are
then byte-identical across hosts. Make `self-main.i` once, with the measured
source's compiler, and copy the same file to every host:

```sh
bin/compiler-znver4 --predefines predefines-znver5.h -march=znver5 -I"$BUSTER/src" \
    -fwrapv -funsigned-char -fno-strict-aliasing -E -o self-main.i "$BUSTER/src/buster/compiler/main.c"
```

Build each variant from a `git archive` of the measured commit, through the
host's `cores` grant or lock (AGENTS.md), and copy `build/compiler` after each:

```sh
git archive COMMIT | tar -x -C tree && cd tree
BUSTER_HOST_ARCH=znver4 cores -n 6 -- ./build.sh && cp build/compiler ROOT/bin/compiler-znver4
```

The measured binaries were built once, on the Zen 4 host with clang 23.1.4, and the
same files were copied to the 9700X, so that each host runs identical executables.

## Running

From the run root:

```sh
ROOT=$PWD harness/run.sh harness/hosts/zen4-7940hs.sh env validate time groups profiles \
    energy scaling sweep metrics time-self groups-self summarize
```

On the 9700X, start it detached and stop it by its PID file, never by a pattern
(see the project memory's lock notes):

```sh
(setsid nohup env ROOT=$PWD harness/run.sh harness/hosts/zen5-9700x.sh env validate time groups \
    profiles energy scaling uncore sweep metrics time-self groups-self profiles-same summarize \
    > campaign.log 2>&1 < /dev/null & echo $! > campaign.pid)
```

The 9700X profile holds the lock about a minute per chunk and pauses 30 s between
holds (`PAUSE`). The whole list takes about 40 minutes of holds there, plus waits
for CI; locally about 25 minutes. Then:

```sh
harness/tables.sh results/zen4-7940hs:6 results/zen5-9700x:8 > tables.md
```

## What each step measures

| step | what | runs |
| --- | --- | --- |
| `validate` | each build's object, `-E` output and diagnostics, hashed | 1 |
| `time` | whole processes (wall, rusage), with `--time-stages` runs | 11 rotated rounds |
| `groups` | six perf stat groups of at most five counters, never multiplexed: user/kernel cycles and instructions; top-down level 1 (`de_src_op_disp.all`, `ex_ret_ops`, the two `de_no_dispatch_per_slot` stalls); level 2 (`ex_no_retire.*`, the frontend stall with `cmask` = width, microcoded ops); branches; frontend (IC, op cache, ITLB); memory (demand fills, DRAM fills, L2 misses, DTLB) | 5 per build and workload |
| `sweep` | every core event perf lists, user and kernel, each in one group with `cycles:u` and `instructions:u` | 2 |
| `metrics` | every perf metric, one `perf stat -M` each | 2 |
| `profiles` | leader-sampled groups (`{...}:S`, 50,021-cycle period) reduced per function; IBS ops with data source and latency, all and L3 misses only; LBR mispredicts by site; cycles with the kernel | 8 compiles each |
| `scaling` | one compile on 1..N lanes; musl's 1,355 sources on 1..N lanes; K independent compiles on K cores with package energy | 5 / 3 / 4 rounds |
| `energy` | package and per-core energy, APERF/MPERF of single-core compiles | 10 compiles per build |
| `uncore` | UMC CAS commands (DRAM traffic), where the host exposes `amd_umc` | 8 compiles; 2 batches of 8 |

## Limits

- Counts are user-mode unless named `:k`; the kernel's share comes from the
  `basic` group and the cycles profile.
- Leader-sampled groups attribute each sample's deltas to the leader's address:
  a function much shorter than the 50,021-cycle period inherits its neighbours'
  ratios. IBS samples are exact per op.
- The sweep gives each event its own run; events from different runs are not an
  exact partition of one execution. Perf's named events and metrics are as perf
  defines them for each generation; some aliases overlap.
- The desktop host runs other work; its single-core steps take one core of the
  `cores` pool (at normal priority) and the other cores may be busy.
