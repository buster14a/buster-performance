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
| `tree394rr` | `4113e38` | #405 after its re-reviews' fixes (merged as `1d0f5e3`, which only rewraps comments) |

Each tree is its commit's `git archive`; `source-*.sha256` is the SHA-256 of
each of its files, which match the archives of those commits byte for byte.
The `build/compiler` SHA-256s are in `host.txt` (`tree394`, then
`treemain394`), `review/compiler.sha256` and `rereview/compiler.sha256`.

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

## The re-reviews' fixes

Two re-reviews found that the startup the conversion trusted to apply a static
link's `IRELATIVE` relocations was recognized by names that any input can
mention. The first found that a name's presence counted. `5c61f88` replaced
it with a chain of references from the entry's object, which the second
broke: a `_start` of its own with an inert `.quad __libc_start_main` makes
`libc.a`'s `libc-start.o` join, which refers on to `__rela_iplt_start`.
`4113e38` recognizes glibc's startup by the files its code comes from:

- the entry must be defined by the system's `crt1.o` (`rcrt1.o` for a static
  PIE), the first library directory's;
- `__libc_start_main` must be defined by a member of the system's `libc.a`;
- each is compared by device and inode with the file the resolution opened,
  from the `fstat` that maps each input;
- in a static PIE, `_dl_relocate_static_pie` must come from `libc.a`, and so
  must glibc 2.44's `_dl_relocate_static_pie_ifunc`;
- the names whose places the startup reads must be left to the linker.

Any other startup needs `--startup-applies-irelative`.

`rereview/` has that tree (`source-tree394rr.sha256`, its 560 files byte for
byte `git archive 4113e38`), built and checked on the 9700X by
`rereview/phase394rr.sh`, each step its own lock acquisition:

- `rereview/test-foreign.log`: `test-foreign --cross-check`, every section
  passing. The driver's 9,810 checks add the new cases in both static modes.
  - Refused: an inert `_start` in the start file's place with the real
    `libc.a`, on 1 and 3 lanes; the re-review's two-object chain without libc;
    the real start file with a `__libc_start_main` of the test's own; and a
    byte-identical copy of the start file.
  - Linked and run: `main` calling an IFUNC after the real start file, and
    through a symbolic link to it on 3 lanes.

  A mutant that compares no identities (built locally at `-O1`) fails the
  eight refusals' 32 checks.
- `rereview/corpus.log`: `test-foreign-corpus` with SQLite, Lua and this
  repository's compiler: 843 checks, 0 failures.
- `rereview/startup-cost.log` (`rereview/measure9700x.sh`, pinned to CPU 2):
  what the check costs. A static hello world compiled by GCC was linked by
  `link-foreign --time` against the system's `libc.a`, 41 interleaved runs
  with and without `--startup-applies-irelative`, which skips the system
  files' lookups. Medians, in milliseconds:

  | Kind | link | convert | `copies` phase |
  | --- | ---: | ---: | ---: |
  | static, checked | 1.147 | 0.399 | 0.006 |
  | static, with the option | 1.140 | 0.394 | 0.001 |
  | static PIE, checked | 1.166 | 0.403 | 0.007 |
  | static PIE, with the option | 1.161 | 0.397 | 0.001 |

  The `copies` phase (the conversion's last steps, the IFUNC refusal among
  them) holds the check: 5 to 6 µs, two `stat` searches of the library
  directories (six calls on this host's layout). It runs only for a static
  link with an IFUNC that a fixup reaches. A first version reused the runtime
  search, with its 1 GB arena and every crt object's and archive's probes; on
  a 7940HS it cost 0.11 ms of this link, against 0.02 ms for the `stat`s.

## Limitations

The benchmark's programs are generated (`link_program.c`'s), not compiled C;
the appendix's and the corpus's are compiled. Medians from one machine and one
session; the linkers' runs time fresh processes, with `link-foreign`'s setup
among them.
