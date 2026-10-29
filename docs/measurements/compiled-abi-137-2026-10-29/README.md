# #137's compiled ABI worlds: what the lowering's changes cost, 2026-10-29

Three stacked branches of buster14a/buster#137 change the lowering (`c_check_program_lower.c`). This record measures
what they cost a unit that uses none of what they add, the frozen `sqlite3.c`:

- PR1, `claude/github-issue-137-946ff6`: #534's `_BitInt`s of up to 64 bits, which never reached main, `va_arg` of a
  vector, a record passed as its low eightbyte alone (`BUSTER_ABI_FLAG_LOW`), and the compiled ABI worlds. Measured at
  `9f0454a9`, whose last commit runs the lowering's tasks' loop without the tests for a `_BitInt` unless the unit has
  a `_BitInt` type;
- PR2, `claude/137-bit-int-wide`, on PR1: `_BitInt(65)` to `_BitInt(128)`. Measured at `f610356d`;
- PR3, `claude/137-complex-integers`, on PR2: GNU's complex integer types. Measured at `65be323c`.

PR4 (`claude/137-atomic-worlds`) changes only the calling convention's test, and isn't measured. Main is `513ed96a`,
the branches' merge base when they were measured. The pull requests' publication heads, with main `9bb5060e` merged,
aren't measured here.

| `sqlite3.c` | main `513ed96a` | PR1 `9f0454a9` | PR2 `f610356d` | PR3 `65be323c` |
| --- | ---: | ---: | ---: | ---: |
| `-c`, user instructions (`perf stat`) | 1,260,285,273 | +354,977 (+0.028%) | +367,348 (+0.029%) | +397,548 (+0.032%) |
| `-c`, wall (`time-runs`) | 124.605 ms | −0.09% | +0.30% | +0.27% |
| `-c`, user cycles (`time-runs`) | 585.63 M | −0.01% | +0.38% | +0.33% |
| `-fsyntax-only`, user instructions (`time-runs`) | 957,964,137 | −22,273 | −23,645 | +6,902 |
| `-fsyntax-only`, wall | 98.647 ms | −0.06% | +0.26% | +0.05% |
| `-fsyntax-only`, user cycles | 447.29 M | −0.15% | +0.15% | +0.12% |
| `benchmark-lowering-source`, referenced definitions | 23.451 ms | +0.76% | +1.26% | +1.17% |

Every executable writes main's `-c` object, byte for byte (`final/measure5.out`).

Where the rows come from (`scripts/measure5.sh`, on the 9700X's CPU 2):

- `ab --rounds 5 --cpu 2 --lock exclusive.sh` over the four trees, in an order that rotates by round, each round a
  `time-runs --runs 21` of `-c` and of `-fsyntax-only`, each process under the lock alone (`final/ab5-driver.log`).
  The wall and cycles rows are the medians of the five rounds' medians (`scripts/summarize-ab4.py`).
- Then five rounds of `benchmark-lowering-source` the same way (`final/ab5-lowering.log`): the median of the rounds'
  `referenced_ns`, the lowering of the definitions that `-c` lowers (`scripts/summarize-lowering.py`).
- Then three `perf stat -e instructions:u` runs of `-c` per tree, each under the lock (`final/stat5-*.csv`): the
  medians.

Round by round, against main's median in the same round:

| | PR1 | PR2 | PR3 |
| --- | --- | --- | --- |
| `-c`, wall | −0.18% to +0.03% (above main in 1 of 5) | +0.21% to +0.34% (5 of 5) | +0.07% to +0.34% (5 of 5) |
| `-fsyntax-only`, wall | −0.21% to +0.02% (1 of 5) | +0.10% to +0.38% (5 of 5) | −0.05% to +0.27% (4 of 5) |
| lowering benchmark | +0.58% to +0.88% (5 of 5) | +0.97% to +1.47% (5 of 5) | +0.93% to +1.38% (5 of 5) |

The instruction counts are the firmest numbers. PR1 adds 0.35 million of `-c`'s 1,260 million instructions, all of
them after checking: `-fsyntax-only` runs main's count to within 0.03 million. PR2 and PR3 add 0.01 and 0.03 million
more. The wall rows of one placement each can't be read at that resolution. PR2's `-fsyntax-only` is 0.10% to 0.38%
slower than main's in every round, at main's instruction count, in code that PR2 doesn't change: that is the
placement of the same code, and it is as large as PR2's and PR3's `-c` differences.

The lowering benchmark is slower for every head in every round: 0.76% for PR1, about 0.18 ms. The heads' added
instructions are too few for that (0.35 million instructions take about 0.03 ms at `-c`'s rate). This record doesn't
attribute it: PR1 adds a second copy of the tasks' loop (`check_lower_drain_bit_ints`) and changes the lowering's code
in the checker unit, which moves the code after it, and it wasn't measured over placements.

## Over placements

`scripts/shifts.sh` follows #509's method (`docs/profiling.md`, "Comparing two versions"). `build.sh shifts` linked
main, PR1 and PR3 each at four placements of the checker unit's code: 0, 1,024, 2,048 and 3,072 bytes of padding before
`main_unit_checker.c`'s `.text` (`placements/shifts.out`). `time-runs --copies 3` ran `-c` from three fresh copies of
each placement's executable, three runs each, with main's executables again as `main-again`, in three `ab` rounds
(`placements/shifts-ab.log`). Against main, over its placements and copies:

| Round | PR1 wall | PR1 cycles | PR3 wall | PR3 cycles | main-again wall | main-again cycles |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | +0.10% | +0.20% | +0.17% | +0.22% | +0.05% | +0.11% |
| 2 | +0.14% | +0.11% | +0.22% | +0.29% | +0.01% | +0.01% |
| 3 | +0.13% | +0.16% | +0.04% | +0.08% | −0.14% | −0.09% |

A build's medians over its four placements spread by 0.17% to 0.60% within a round. PR1's `-c` is 0.10% to 0.14%
slower than main's over placements, where main against itself shows −0.14% to +0.05%: a cost of about 0.1%, at the
edge of the floor. The one-placement A/B's −0.09% falls within the placements' spread. PR3 shows +0.04% to +0.22%.

## Before the specialization

`before-specialization/` is the same script (`scripts/measure4.sh`, with one `perf record` per tree in place of the
instruction counts) run earlier on PR1 `c8364624`, PR2 `558b7469` and PR3 `126b885a`. These were the heads before the
tasks' loop was specialized. PR2's and PR3's heads also lacked their commits that lower wide constants as the checker
folds them (`d83bf395`, `c62be7e3`). Against main `513ed96a` (`time-runs`):

| `sqlite3.c` | main | PR1 `c8364624` | PR2 `558b7469` | PR3 `126b885a` |
| --- | ---: | ---: | ---: | ---: |
| `-c`, user instructions | 1,260,285,674 | +4,133,442 (+0.328%) | +4,139,433 | +4,131,526 |
| `-c`, wall | 124.666 ms | −0.10% | +0.13% | +0.34% |
| `-c`, user cycles | 586.59 M | −0.12% | +0.12% | +0.43% |
| `-fsyntax-only`, wall | 98.646 ms | −0.09% | +0.13% | +0.39% |
| lowering benchmark | 23.453 ms | +0.78% | +1.33% | +1.06% |

The specialization removed 3.8 of the 4.1 million instructions. At this placement, neither count showed in `-c`'s
wall or cycles, and the lowering benchmark's +0.8% stayed. The single `perf record` profiles (`perf4-*.txt`, about
6,300 samples each) are kept, but they don't resolve differences of this size.

This run's trees weren't hashed before they were replaced. Its commits are the ones the session exported. Its PR1
count matches the 7940HS's count of `c8364624`'s build below (+4.13 million).

## Attribution on the 7940HS

Instructions of `-c sqlite3.c` on the 7940HS (Zen 4), `perf stat -e instructions:u`, three runs each (the medians).
Every executable wrote main's object (`attribution/`):

| Executable | Instructions | Against main |
| --- | ---: | ---: |
| main `513ed96a` | 1,259,688,933 (again: 1,259,688,267) | |
| `c8364624` | 1,263,819,998 | +4,131,731 |
| `c8364624` without the expansion's dispatch to `check_lower_bit_int_node` (`v1.patch`) | 1,261,606,439 | +1,917,506 |
| … nor the compares' test of narrow operands and the conversions' test of a `_BitInt` target (`v3.patch`) | 1,259,895,267 | +206,334 |
| … nor the loads' and assignments' tests: all five of the lowering's tests for a `_BitInt` (`v2.patch`) | 1,259,752,634 | +63,701 |
| `9f0454a9`, the specialization | 1,260,037,735 | +349,468 |

Each variant is `c8364624` with its patch, which makes those tests constant false: the expansion's dispatch, its
test of a compare's narrow operands and the conversions' test of a `_BitInt` target (v3) took 3.9 million
instructions. `9f0454a9` makes those three tests constant in a copy of the tasks' loop that a unit without a `_BitInt`
type runs.

`scripts/attribution.sh`, `attribution-v2.sh` and `attribution-v3.sh` built and counted main and the variants
(`attribution/attribution.out`). The first script's `head` rows counted a build of the session's working tree before it
was committed as `c8364624`, and the session's check of the specialization counted a build of its working tree
before it was committed as `9f0454a9`. Their sources weren't kept, so their counts aren't in the table. `scripts/attribution-commits.sh` built `c8364624` and `9f0454a9` from
`git archive` and counted them with main again (`attribution/attribution-commits.out`, the rows above). They match the
earlier counts to within 6,000 instructions.

## Trees and identities

| Name | Commit | What it is |
| --- | --- | --- |
| `main` | [`513ed96a`](https://github.com/buster14a/buster/tree/513ed96a463cf43190d40405a93bb8ab29c02cd4) | main when measured, the branches' merge base |
| `head` | [`9f0454a9`](https://github.com/buster14a/buster/tree/9f0454a9111707370c8719cf771f747f00b28581) | PR1's head when measured |
| `pr2` | [`f610356d`](https://github.com/buster14a/buster/tree/f610356d435cba8e2ab0ae85e3bfffcc21c0f10f) | PR2's head when measured, PR1's `9f0454a9` merged |
| `pr3` | [`65be323c`](https://github.com/buster14a/buster/tree/65be323cc51c24ae7343bbea2eea4a0c7a157d2d) | PR3's head when measured, PR2's `f610356d` merged |

Each tree on the 9700X was `git archive` of its commit. `identity/source-*.sha256` holds the SHA-256 of every file of
each tree but `build/` and the scripts' logs: 708 files each, all of which match `git archive` of the commits above.
Each tree was built with `BUSTER_DEBUG_INFO=0 ./build.sh` under the lock. `identity/inputs.sha256` holds the SHA-256 of
the four executables, of the twelve placements' executables, and of the input, with the host's kernel and clang. A
second build of `head` gave the same bytes (`identity/provenance.out`, `scripts/provenance.sh`), so the build is
reproducible: the hashed executables are the ones measured.

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1. The attribution's host: AMD Ryzen 9 7940HS, Linux
7.3.0-5-cachyos, clang 23.1.4.

The input is the preprocessor oracle's frozen `sqlite3.c`
(`/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c`, SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`), with `-DSQLITE_OMIT_LOAD_EXTENSION
-DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I` its directory. The 7940HS ran a copy with the
same SHA-256.

## Logs

While `exclusive.sh` waited for the lock, it wrote messages into the logs on the host that name other sessions' and
CI's runs. `scripts/keep_own_lines.py` kept only the lines this record's tools print in `final/ab5-driver.log`,
`before-specialization/ab4-driver.log` and both `measure*.out`, and a `grep` of the same lines did so for
`placements/shifts-ab.log` (613 of its 617 lines). Nothing else was changed.

## Limitations

- One input, which uses none of what the branches add: this measures what the additions cost the code that doesn't
  use them, not how fast they lower what they add.
- The five-round A/B has no A/A control. The placement comparison's `main-again` is its floor, for `-c` of PR1 and
  PR3 alone. PR2, between them in the stack, wasn't compared over placements, and neither was the lowering
  benchmark.
- The lowering benchmark's +0.76% for PR1 holds in every round and isn't attributed.
- The publication heads, with main `9bb5060e` merged, aren't measured.
