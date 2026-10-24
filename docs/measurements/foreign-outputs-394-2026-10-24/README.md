# link-foreign's output kinds (#394), 2026-10-24

The 9700X's validation and measurements of
[buster14a/buster#405](https://github.com/buster14a/buster/pull/405), which
makes `link-foreign` write static executables with `libc.a`, static PIEs and
shared libraries beside its dynamic PIEs, and take a dynamic PIE's own IFUNCs
([#394](https://github.com/buster14a/buster/issues/394)). The linker design's
"Foreign executables, as built" and the driver's contract cite this record.

| Tree | Commit | What it is |
| --- | --- | --- |
| `tree394` | `bb2e0cb` | #405 as first pushed |
| `treemain394` | `505985b` | main that #405 was measured against (the writer's A/B) |
| `tree394r` | `a077498` | #405 after its review's fixes (`4ea67a9`), merged with main |

Each tree is its commit's `git archive`; `source-*.sha256` is the SHA-256 of
each of its files, which match the archives of those commits byte for byte.
The `build/compiler` SHA-256s are in `host.txt` (`tree394`, then
`treemain394`) and `review/compiler.sha256`.

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, GCC 16.2.1, GNU ld
2.47, lld 23.1.1, mold 3.0.0, wild 0.10.0, CPU 2 at the performance governor,
outputs on tmpfs (`/tmp`). Each step took the shared lock on its own, through
`~/buster-fast-bench/exclusive.sh` with `EXCLUSIVE_OWNER=claude-linker-80` and
`EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/405`. The lock's
waiting messages, which name other runs, are removed from the logs; nothing
else in them is changed. `phase394.sh` ran the first tree's steps and
`review/phase394r.sh` the review's.

## Validation

- `build-*.log`, `callgraph.log`: both trees built; `check-call-graph` found
  no cycle outside its three allowed ones.
- `tests.log`: the 9700X job's test list (`tests.txt`, through `parallel
  --timeout 180`): 69 of 70 passed. The one that failed is c-testsuite's: the
  script didn't fetch c-testsuite's tree into the fresh `build/` that the job
  fetches it into ("no tests in build/c-testsuite"), so it ran no program. CI's
  run of the same commit
  ([40108831992](https://github.com/buster14a/buster/actions/runs/40108831992))
  passed it.
- `corpus.log`: `test-foreign-corpus` with SQLite 3.53.4's shell, Lua 5.4.8 and
  this repository's compiler beside the original programs, every kind against
  lld and mold: 773 checks, 0 failures. This is the first tree's test, whose
  exception for mold's unnamed `IRELATIVE` rows the review found too broad (and
  whose reason, "a second slot", was wrong): `review/` has the corrected
  test's run.
- `review/`: the review's tree, see "The review's fixes" below.

## The whole link

`benchmark-link.log`: generated programs that call libc, linked by the direct
path and, from the object writer's objects, by GNU ld, lld, mold, wild and
`link-foreign` (`--lanes=8` for its threads), medians in milliseconds, each
linker on its own threads and on one (GNU ld on one only). Synth's shape,
102,400 workers in 512 units (44 to 57 MB of output):

| Kind | link-foreign | lld | mold | wild | GNU ld |
| --- | ---: | ---: | ---: | ---: | ---: |
| dynamic PIE | 30.8 / 54.6 | 56.1 / 97.6 | 36.7 / 99.3 | 25.2 / 99.9 | 351.9 |
| static executable | 32.0 / 58.3 | 53.8 / 98.3 | 42.7 / 100.1 | 26.2 / 103.3 | 307.9 |
| static PIE | 32.6 / 59.3 | 60.6 / 102.5 | 42.2 / 106.6 | 26.7 / 103.3 | 342.0 |
| shared library | 39.7 / 65.6 | 68.5 / 128.2 | 46.7 / 116.6 | 30.8 / 126.6 | 433.9 |

2,000 workers (about tcc's output), one thread each:

| Kind | link-foreign | lld | mold | wild | GNU ld |
| --- | ---: | ---: | ---: | ---: | ---: |
| dynamic PIE | 1.16 | 5.43 | 3.30 | 2.52 | 9.06 |
| static executable | 2.06 | 7.78 | 7.45 | 5.07 | 16.31 |
| static PIE | 2.07 | 8.05 | 7.62 | 5.05 | 16.94 |
| shared library | 1.29 | 5.85 | 3.73 | 2.90 | 9.96 |

One worker (about hello world's), one thread each; the benchmark doesn't run
wild's static kinds of this program, whose TLS segment wild 0.10 starts off
its alignment:

| Kind | link-foreign | lld | mold | wild | GNU ld |
| --- | ---: | ---: | ---: | ---: | ---: |
| dynamic PIE | 0.60 | 4.44 | 2.44 | 1.39 | 5.42 |
| static executable | 1.50 | 6.58 | 6.06 | | 12.82 |
| static PIE | 1.53 | 6.63 | 6.27 | | 13.28 |
| shared library | 0.61 | 4.44 | 2.42 | 1.34 | 5.35 |

`link-foreign`'s threads cost more than they give below a few megabytes of
output (its eight lanes' start), as before: on the small programs its own
threads' rows are slower than its one thread's.

`appendix-*.log`: the appendix's hello world and tcc compiled objects, linked
as static executables and static PIEs against `libc.a` with the GNU ld
command line GCC's driver makes, 41 runs after 20 ms pauses, medians in
milliseconds, every output run:

| Program | link-foreign, 1 lane | wild | mold | lld |
| --- | ---: | ---: | ---: | ---: |
| hello, static | 1.50 | 3.90 | 6.38 | 6.45 |
| hello, static PIE | 1.54 | 3.97 | 6.03 | 6.64 |
| tcc, static | 2.09 | 5.83 | 8.33 | 8.67 |
| tcc, static PIE | 2.06 | 5.99 | 8.46 | 8.82 |

## The writer's dynamic PIEs

#405 changes the writer's passes that every dynamic PIE runs (its IFUNCs'
count and numbering). `executable-*-r*.log`: `benchmark-executable --only
dynamic`, main's tree and #405's in turn, three rounds, pinned to CPU 2. The
medians of the three rounds' medians, #405 over main: 1.000 to 1.014 for the
small programs and 0.996 to 1.002 for 180,000 workers, in place and as a new
file; the count phase at 180,000 workers 1,523.2 µs against 1,511.0 (in
place). No change past the rounds' spread.

## The review's fixes

The review's two findings, fixed in `4ea67a9`:

1. A static link with no startup code to apply `IRELATIVE` relocations (no
   input refers to `__rela_iplt_start`, or in a static PIE to `_DYNAMIC`: a
   program without libc) refuses every IFUNC a fixup reaches, naming it and
   the missing name. lld links such a program, which faults at the call.
2. The corpus names each `IRELATIVE` row by its resolver and by whether it
   writes a GOT slot or a pointer in data, checks that no two write one place,
   and replaces the blanket exception for mold's unnamed rows: mold's row in
   the self corpus was its `IRELATIVE` relocation of a pointer to `memset` in a
   static PIE's `.data.rel.ro`, which `link-foreign` and lld relocate relative
   to the IFUNC's stub, and each such row of mold's must now be one of
   `link-foreign`'s stub pointers, one for one. The C fixture gained two
   IFUNCs, called, loaded from the GOT and pointed to from data.

`review/` has the review's tree, built and checked on the 9700X by
`review/phase394r.sh`:

- `review/test-foreign.log`: `test-foreign --cross-check`, every section
  passing. The driver's 9,725 checks are the first tree's 9,709 and the new
  no-libc IFUNC cases' 16: refused as a static executable and as a static PIE,
  the diagnostic naming the IFUNC and the missing name, and linked and run
  when the `_start` applies the relocations itself.
- `review/corpus.log`: `test-foreign-corpus` with SQLite, Lua and this
  repository's compiler, with the corrected test: 843 checks, 0 failures.
  mold's pointer rows paired one for one in five comparisons: two in each of
  the C fixture's PIEs and static PIEs (its two IFUNCs in a table in data), by
  gcc and by clang, and one in this compiler's static PIE (`memset`, the row
  the first tree's test excused as "a second slot").

The review's changes are in the conversion's refusal and the corpus test; the
benchmarks above measured the first tree, whose link paths are the same but
for the refusal's two name lookups.

## Limitations

The benchmark's programs are generated (`link_program.c`'s), not compiled C;
the appendix's and the corpus's are compiled. Medians from one machine and one
session; the linkers' runs time fresh processes, with `link-foreign`'s setup
among them.
