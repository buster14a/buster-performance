# Bit-field access units (#1372), 2026-11-13

This is the evidence for [buster#1372](https://github.com/buster14a/buster/issues/1372) and the pull request that
implements its access units. By Claude, in David's directed session
([the session](https://claude.ai/code/session_01EgbxndFPcjcMyz9oRmLbvR)).

The lowering read and wrote each bit-field through the bytes that hold that field's bits alone. In the issue's
`struct B { unsigned x : 3, y : 7, z : 13, w : 9; }`, these are 1- or 2-byte windows at 0, 1 and 2 that overlap without
matching, so a read after a store missed store-to-load forwarding. The pull request reads and writes every bit-field
through the access unit clang gives its run (`CGRecordLowering::accumulateBitFields`, which buster's
`abi_bit_field_unit` already computed for the calling convention). In `struct B` that is a 4-byte access at 0 for every
field, as in clang -O0's code, at both tiers. Buster's `docs/c-checker.md` ("Bit-fields") describes the rule.

## Revisions

| Role | Commit | What |
| --- | --- | --- |
| base | `b7a95eedbe16fbd8434654f192f8f7aab76c56e5` | buster's main when the work began |
| head | `b168949e` (tree `da465974f3af6e852a704265d2995db5bb5f7275`) | the PR's first commit: the units, chained again at each access |
| head2 | `b8d19f15` (tree `350e68718452956f663d5f6cae4514b26117c933`) | the PR's third commit: each member's unit made once, before the bodies |

The PR's second commit, `a2c05114`, adds two test fixtures alone. The 9700X's trees were made by applying the commits'
patches to `base` (`scripts/setup.sh`, `scripts/setup2.sh`); their tree hashes are the commits' above. Both builds
are `./build.sh --config Release` with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0`.

## The kernel

`scripts/k_bits.c` is the issue's kernel: two read-modify-writes of `struct B`'s fields, then four reads.
`scripts/driver.c`, compiled by clang -O2 alike for every variant, calls it 50,000,000 times, each after a store to
`b.x`. The six variants are the same driver linked with `k_bits` compiled by base's and head's Tier 0 (`-c`) and Tier 1
(`-c --tier1`) and by clang 23.1.1 -O0 and -O2. `9700x/k-*.s` are their disassemblies; head2's two objects are head's
byte for byte (`9700x/run3.log`).

**Method.** On the Ryzen 7 9700X (`9700x/host.txt`), CPU 2 (governor `performance`), each variant `perf stat -r 5`'d in
user mode: `cycles`, `instructions`, `ls_bad_status2.stli_other` (store-to-load conflicts) and `ls_stlf` (forwards).
Three rounds, each one hold of the shared lock with the variants in a rotated order (`scripts/round.sh`, run by
`scripts/run2.sh`). Every one of the 90 processes printed the same sum, 3799999488 (`9700x/result-*.txt`).

**Results**, the median of the three rounds' means (each round's spread is in its CSV; every round is within 0.15% of
the median):

| `k_bits` by | cycles | instructions | store-to-load conflicts | forwards |
| --- | ---: | ---: | ---: | ---: |
| base, Tier 0 | 2,570.16 M | 4,300.27 M | 372.15 M | 350.03 M |
| head, Tier 0 | **776.94 M** | 4,200.27 M | **978** | 600.02 M |
| base, Tier 1 | 2,464.19 M | 2,700.27 M | 300.01 M | 350.03 M |
| head, Tier 1 | **771.49 M** | 2,700.27 M | **1,037** | 600.02 M |
| clang -O0 | 720.79 M | 3,100.27 M | 1,534 | 1,050.02 M |
| clang -O2 | 354.90 M | 1,850.27 M | 725 | 150.02 M |

- Tier 0 takes 3.31 times fewer cycles (−69.8%), Tier 1 3.19 times fewer (−68.7%). Against clang -O0's cycles, Tier 1
  goes from 3.42 times to 1.07 times, and Tier 0 from 3.57 times to 1.08 times.
- The conflicts, 6 a call at Tier 1 and 7.4 at Tier 0, are gone; each of the 12 accesses a call now forwards or reads
  the cache.
- Tier 1 retires the same instructions: its 42 are the same but for the accesses' widths and offsets. Tier 0 retires 2
  fewer a call: its code is 72 instructions where it was 74, without an `inc` of an address.

## Compile time

**Method.** `time-runs` (buster's whole-process timer, in a Williams design's order), 21 runs of each build after 2
warm-ups, on CPU 2, each comparison one hold (`scripts/compile.sh`, `scripts/compile2.sh`). Medians:

| Compile | base | head2 | head2 / base |
| --- | ---: | ---: | ---: |
| `sqlite3.c -c`, instructions | 1,353.36 M | 1,353.20 M | −0.012% |
| `sqlite3.c -c`, user cycles | 602.48 M | 602.96 M | +0.08% |
| `sqlite3.c -c`, wall | 124.18 ms (123.32 to 125.76) | 124.22 ms (123.58 to 125.54) | +0.04% |
| `sqlite3.c --tier1 -c`, instructions | 4,739.10 M | 4,738.99 M | −0.002% |
| `sqlite3.c --tier1 -c`, user cycles | 2,131.15 M | 2,144.47 M | +0.62% |
| `sqlite3.c --tier1 -c`, wall | 402.61 ms (401.12 to 407.35) | 404.75 ms (403.86 to 405.49) | +0.53% |
| 256-field stress `-c`, instructions | 495.58 M | 492.28 M | −0.67% |
| 256-field stress `-c`, user cycles | 118.29 M | 116.38 M | −1.61% |
| 256-field stress `-c`, wall | 28.17 ms (27.96 to 29.22) | 27.68 ms (27.51 to 27.89) | −1.74% |

`sqlite3.c` is the frozen corpus's (`corpus-391e729af658`, its SHA-256 in `9700x/identities.sha256`), with
`-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE` and the host's
headers. The stress (`scripts/gen_fields.c`) is a struct of 256 one-bit fields, one run of 32 units of 8 bytes, and 64
functions that each read and update every field through a pointer: 32,768 bit-field accesses.

- **head**, which walked back over the field's run and chained its units again at every access, cost the stress
  266.09 M more instructions (761.67 M), 42.4% more cycles and 32.4% more time (`9700x/time-fields-c.txt`): about 8,100
  instructions an access. head2 chains each struct's units once, before the bodies, into a column of 2 bytes a member,
  and an access reads its member's; the stress then takes 3.31 M fewer instructions than base.
- `sqlite3.c`'s instructions fall slightly, by 0.17 M at `-c`. `-c`'s cycles and time are within the runs' spread.
- `--tier1 -c` takes 0.62% more cycles (13.3 M) for 0.11 M fewer instructions; the builds' ranges of cycles (2,122.90
  to 2,139.82 M and 2,138.27 to 2,147.64 M) overlap only at their ends. With no more work done, I read it as the two
  executables' code placement, which this record didn't vary: it is a single-layout result.
- Peak resident sets (wait4's) are within 0.1% for `sqlite3.c -c`; the stress's is 2.6 MB more with 29 fewer minor
  faults, and `--tier1`'s varies between 293 and 296 MB from run to run on head2.

## Limitations

- One kernel. Its gain is the forwarding failures' cost; code that reads a bit-field long after its store gains
  nothing, and code whose fields' windows matched their units already doesn't change.
- `scripts/run.sh` was the first plan: a hold per variant and per round. The lock was contended (a hold waited about 15
  minutes), so after the first variant's first round it was stopped while waiting (by SIGSTOP and SIGKILL of its
  waiter's `exclusive.sh` before its `flock`, so its command never ran) and `scripts/run2.sh` measured the rounds as
  above, from `run.sh`'s objects and executables. `run.sh`'s one finished run is not kept. `run.sh` compiled the six
  `k_bits` objects and linked their executables outside the lock (a few milliseconds of work), before its first hold.
- `scripts/compile.sh`'s `sqlite3.c` command passed test-command options (`--predefines`, `--no-default-config`,
  `--target`) that the driver refuses: both builds exited with status 1 in 0.15 ms. `9700x/time-sqlite-c.txt` is kept
  as that failed run; `scripts/compile2.sh` times the same file with the driver's options.
- `exclusive.sh`'s waiting lines, which name other sessions' runs, are stripped from the logs.

## Files

- `scripts/`: the harness, run from `~/buster-fast-bench/1372-claude/` on the 9700X.
- `9700x/perf-VARIANT-ROUND.csv`, `9700x/result-VARIANT-ROUND.txt`: each round's `perf stat` and the programs' output.
- `9700x/k-VARIANT.s`: the six `k_bits` objects' disassemblies.
- `9700x/time-*.txt`, `9700x/time2-*.txt`: `time-runs`' reports.
- `9700x/identities.sha256`: the objects', executables', compilers' and inputs' SHA-256s.
- `9700x/build.log`, `9700x/run2.log`, `9700x/run3.log`: the builds' and runs' logs.
