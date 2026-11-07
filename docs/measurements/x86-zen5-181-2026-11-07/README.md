# The Zen 5 model's rows on the 9700X, Buster #181

Compiler branch: `claude/magical-albattani-dhulqc` of buster14a/buster
([PR #1681](https://github.com/buster14a/buster/pull/1681)), for
[#181](https://github.com/buster14a/buster/issues/181)
([the claim](https://github.com/buster14a/buster/issues/181#issuecomment-6708136023)).

The model (`x86_zen5.c`) has a row of the 9700X's own measurements for every case (a form and an operand kind) Tier 0
and Tier 1 emit, in `x86_zen5_rows.c`; `measure-x86-zen5` (`x86_zen5_measure.c`) builds every case's fixtures from the
form table and the effects tables, measures them and prints the rows (`--table`), or measures them again and compares
(`--check`). Buster's `docs/x86-zen5.md` has the columns, the method, its assumptions and the summary; this directory
has the record.

## Sources and host

Each tree is a `git archive` of its commit (`scripts/trees.sh`), extracted into a fresh directory on the 9700X and
built there by `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh` (`logs/build-*.log`, each executable's SHA-256
in `logs/receipt.txt`):

- **main:** `872cb8fe34b5b009698ccd1a81688f4a94f1e3ee`, the branch's base;
- **head:** `30de081ff0587323131f278ea74330aabedca44f`, the model, the harness and the rows.

The receipt (`logs/receipt.txt`): the AMD Ryzen 7 9700X, its kernel, clang 23.1.1, perf, CPU 2's governor and energy
preference, both executables' SHA-256 and the head's `x86_zen5.c`, `x86_zen5_rows.c` and `x86_zen5_measure.c`'s. The
input of `-c`, the 9700X job's frozen `sqlite3.c`
(`/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c`), has SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.

## Method

`scripts/all.sh` (with `scripts/env.sh`) ran everything, each build and run in a hold of the host's lock
(`~/buster-fast-bench/exclusive.sh`) of its own, pinned to CPU 2 where it measures:

- both trees' builds;
- the head's `test-x86-zen5` (`logs/test-x86-zen5.log`): the lookups, the operand kinds, the table's completeness, and
  every case's fixture programs built, validated, encoded alike by both encoders and run;
- three processes of the head's `measure-x86-zen5` (7 passes of 10,000 iterations a program, every experiment of a
  case in a rotating order each pass, the empty loop's counts subtracted), each in two holds of half the rows
  (`--sample 2`, `--offset 0` and `1`), so that no hold keeps CI waiting past its 10 minutes: `--table`
  (`logs/measure-1-*.log`), which measures every row again, and `--check` twice (`logs/measure-2-*.log`,
  `measure-3-*.log`), which compares every row with the committed one;
- the sweep, three processes (`logs/sweep-1.log` to `sweep-3.log`): `--immediate` and `--decorations` in place of the
  fixtures' own on `shl`, `imul`, `add` with an imm8 and an imm32, and `vpaddd` and `vaddps` of ZMM registers; and the
  masked rows beside their unmasked ones, a merging `vpaddd` and a zeroing `vmovdqu8` load;
- `-c` of `sqlite3.c` by both trees at Tier 0 and `--tier1 -fno-asynchronous-unwind-tables`, whose objects must be the
  same bytes (`logs/compile.log`).

The committed rows come from four earlier processes of the same harness (`table/README.txt` has each one's tree and
SHA-256): the first 849 rows' `--table`, the masked rows', the families' and the masked load's `--missing --table`.
The 1,349 committed rows are exactly those processes' rows. `scripts/build.sh`, `measure.sh` and
`campaign-masked.sh` ran them, each build and process in a hold of its own, on a working tree of the branch.

## Results

All of `scripts/all.sh`'s steps exited 0 (`logs/all.out`).

- **Tests:** the head's `test-x86-zen5` passed on the 9700X: 1,349 cases, none incomplete, and every case's fixture
  programs built, validated, encoded alike and run (`logs/test-x86-zen5.log`).
- **Reproduction:** both `--check` processes reproduced every committed row, 1,349 of 1,349 (675 and 674 a half);
  49 and 58 rows differ in a pipe bit, which `--check` reports and doesn't require (`logs/measure-2-*.log`,
  `measure-3-*.log`).
- **A fresh table:** the head's `--table` process (`logs/measure-1-*.log`) printed 1,270 of the 1,349 rows exactly
  as committed. The other 79 differ only in throughput (41 rows) or pipe bits (60): every latency, macro-op count,
  flags latency, load increment, FP-op count and measured/derived/absent mask is the same. Each throughput
  difference is one step of the column's 1/64 cycle (0.250 to 0.266, say) except `ktestw`, `ktestd`, `ktestq` and
  `kortestq`/`kortestd`, whose passes are 0.5 or 1 cycle, either in one process (`docs/x86-zen5.md`).
- **The sweep** (`logs/sweep-*.log`), the same in all three processes but for the masked `vpaddd`'s throughput
  (0.250 or 0.266):

  | Case | In place of the fixture's | Row |
  | --- | --- | --- |
  | `shl r64, imm8` | immediates 0, 1, 3, 63, 127 | latency 1, throughput 0.328, 1 op |
  | `imul r64, r/m64, imm8` | immediates 1, 3, 127, −128 | latency 3, throughput 0.328, 1 op |
  | `add r/m64, imm8` | immediates 1, 3, 127, −128 | latency 1, throughput 0.188, 1 op |
  | `add r/m32, imm32` | immediates 0, 4660, 2147483647 | latency 1, throughput 0.188, 1 op |
  | `vpaddd zmm` | no decorations; zeroing under k4 | latency 2, throughput 0.25 |
  | `vaddps zmm` | no decorations; zeroing under k4 | latency 2, throughput 0.5 |
  | `vpaddd zmm` merging under k7 (`MASKED`) | — | latency 3, throughput 0.25 to 0.27 |
  | `vmovdqu8 zmm, m512` | — | latency 4.5 (derived), throughput 0.5 |
  | `vmovdqu8 zmm {k7}{z}, m512` (`MASKED_MEMORY`) | — | latency 6.5 (derived), throughput 0.5 |

- **Generated code:** `sqlite3.c`'s objects from main and the head are the same bytes at Tier 0
  (`bdda6e11656452c083e8d4682c51275167fa28dc028b2f676d5d31d2a34d7be9`) and at `--tier1`
  (`3c72942aaac184e03e5efd04c8235bcbe13e6a205f991b469d498fea276cd50c`) (`logs/compile.log`, the hashes in
  `logs/all.out`).

## Earlier campaigns

- `logs-e9c2e280/`: the first commit's (849 rows): its `--table`, two `--check` processes, the sweep and `-c`. The
  checks reproduced 843 and 844 of 849 rows; the misses were all `kortest` and `ktest` throughputs, whose passes are
  0.5 or 1 cycle, which made `--check` accept a throughput within the run's own range (`docs/x86-zen5.md`).
- `logs-4a2039b1/`: the masked rows' commit (893 rows): every row reproduced by both `--check` processes; its sweep
  found that a zeroing opmask on a `vmovdqu8` load changes its row (`--decorations 131`: 6.5 cycles from the address
  where the unmasked load takes 4.5), which made any opmask on memory the `MASKED_MEMORY` kind in the head.

## Inventory

`inventory/` has how the cases were found: the temporary instrumentation (`inventory/dump.h`, never committed, which
appended every record Tier 0 and Tier 1 emitted to `BUSTER_FORM_INVENTORY`; `names.c` prints the form names), the
runs (`inventory/run.sh` over SQLite, speedtest1 and Lua 5.4.8 at both tiers and two targets; `run2.sh`, the records
without a row, over every Tier 0 and Tier 1 test suite and the corpora), and the aggregation (`inventory/*.py`), whose
output (`inventory/cases.tsv`, `rows.txt`) the rows came from; `*-without-rows.tsv` are the later sweeps' records
without a row (the merging opmasks', and the tests' remaining ones). The families' rows (every width and operand kind
of an operation the inventory found) were added beside them.

## Limits

- Every value is the 9700X's on these fixtures: independent instances, chains, and one-to-one mixes, in loops of 240
  units. Whole-program performance is not measured here; the model's consumers are measured by their own records.
- Latencies across register files and a memory kind's vector or opmask latency rest on the even split of a bridge's
  round trip (`docs/x86-zen5.md`); they are marked derived.
- A pipe bit says a case contends with a blocker at one to one, not which physical pipe it runs on; bits near the
  threshold change between processes, which `--check` reports and doesn't require.
