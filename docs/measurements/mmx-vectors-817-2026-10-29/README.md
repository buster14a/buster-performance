# #817's vectors of 4 and 8 bytes: what code without them pays, 2026-10-29

Branch `claude/loving-carson-j9sz52-intrinsics7` (buster14a/buster#817) gives Tier 0's VECTOR class vectors of 4 and 8
bytes, for MMX's intrinsics, and lowers them: their operators, calls, casts, `__builtin_bit_cast` and builtins. A cast
of an integer to a GNU C vector of its bytes is its bits, where an operator's conversion of a scalar to a vector splats
it, and the branch's first heads told the two apart in the lowering's loop over its tasks: they asked every cast whether
it was such a one (`check_lower_vector_bit_cast`). This record measures what that cost `-c` of code without vectors,
where the cost came from, the fix, and the head that took it.

Every measurement ran on the 9700X, pinned to CPU 2, each run under the 9700X's lock on its own. The inputs:

- **`sqlite3.c`**: the frozen one of corpus `preprocessor-391e729af658`, which has no vectors, by `-fsyntax-only`
  (`drive`) and by `-c` (`lower`), whose objects every tree of a campaign made the same, byte for byte (each
  campaign's log and `inputs*.sha256`);
- **`main.c`**: the head's own, checked with `build.sh`'s flags (`print-compile-flags`) and one lane (`main`).

Each tree built with `BUSTER_DEBUG_INFO=0` under its own hold of the lock, and its sources hash to the commit's
`git archive`, or to it with the variant's patch, which this record holds. An A/A control (`aa`) is a copy of the
base's executable, the same bytes, run as a tree of its own. Instruction counts are deterministic here: the A/A copy
is within 60 instructions of its base in `-c` and within 16,000 in `main.c`'s. Cycles move more: the A/A copy differs
from its base by up to 0.9%.

## abG: the first head against main

Base: main `5655370ee77cb6f64c9c759d84748c744c4e6bd5`; head: the branch's `588fb14bde27b14b08fbaf6323d42e0c132337f9`.
Three rounds of `perf stat -r 11` (`-r 5` for `main.c`) of user instructions, cycles and task-clock; the medians of the
rounds (`abG/perf.log`):

| Measure | base | A/A copy | head | head against base |
| --- | ---: | ---: | ---: | ---: |
| `sqlite3.c -fsyntax-only`, instructions | 1,022,356,155 | 1,022,356,110 | 1,022,354,353 | -1,802 |
| `sqlite3.c -fsyntax-only`, cycles | 468.117 M | 467.611 M | 470.577 M | +0.53% |
| `sqlite3.c -c`, instructions | 1,295,990,310 | 1,295,990,250 | 1,299,164,042 | +3,173,732 (+0.245%) |
| `sqlite3.c -c`, cycles | 591.947 M | 591.216 M | 595.763 M | +0.64% |
| `main.c -fsyntax-only`, instructions | 17,629,334,586 | 17,629,343,695 | 17,629,333,052 | -1,534 |
| `main.c -fsyntax-only`, cycles | 6,802.702 M | 6,744.022 M | 6,790.212 M | -0.18% |

`-c` ran 3.17 M more instructions, a quarter of a percent, in code that has no vector. `-fsyntax-only`, which doesn't
lower, ran as many as base. Its cycles' +0.53% is inside no A/A spread of this campaign and has no instruction behind
it; this record doesn't attribute it.

## abH: where `-c`'s instructions went

abH.sh built the branch's next head, `ff2b8e0d0cbdd0881ea7926be7d8dfc2852731a1` (`head2`, its review's fix, which
changes only the vector operators' rows), and two variants of it, and abH2.sh measured `-c` alone, in three rounds
whose order rotates (`abH/perf2.log`):

- **v1** (`abH/v1.patch`): the bit-cast test behind an inline test of the cast's type's class, the out-of-line call
  only for a vector's type;
- **v2** (`abH/v2.patch`): the bit-cast test removed from both of its places, `check_lower_plain` and
  `check_lower_expand` (bit casts then splat: a reference, not a fix).

| `sqlite3.c -c` | base | A/A copy | head2 | v1 | v2 |
| --- | ---: | ---: | ---: | ---: | ---: |
| instructions | 1,295,990,765 | 1,295,990,752 | 1,299,165,193 | 1,297,961,034 | 1,295,983,313 |
| against base | | -13 | +3,174,428 | +1,970,269 | -7,452 |
| cycles | 589.995 M | 591.116 M | 591.410 M | 593.351 M | 591.480 M |

The whole cost was the test: without it, `-c` ran within 7,452 instructions of main. With the call behind an inline
test of the cast's class, which is false for every cast `sqlite3.c` has, it still ran 1.97 M more, though the test's
own instructions run once a cast. The test is in the tasks' loop, which `check_lower_plain` and `check_lower_expand`
are inlined into; v2's `check_lower_drain`, disassembled, is base's instruction for instruction (head2's and v1's
weren't compared with it). (abH.sh's own perf rounds, `abH/perf.log`, were stopped after their first runs, for the
lock's sake, and replaced by abH2.sh's.)

## abJ: the fix and its variants

The fix (`499c1ce1cab0cc50535518ba82b879efd044eed9`, on the branch's merge
`63e99bb39964acf83ad7db63c19878e75638c8c2` of main `74af99374e75a1325f5ffce7932fca372585a490`) takes the test out of
the loop: an integer's conversion
to a GNU C vector of its bytes is a cast's bits in `check_lower_vector_conversion`, out of line, and what splats a
scalar into a vector (a vector operator's operands, a compound assignment's right operand and a vector conditional's
arms) splats it at the operator itself, out of line too. The conditional is the logical operators' code, shared with
`check_lower_expand`'s copy (`check_lower_logical`), and the vector operators' route in `check_lower_expand` takes it.
Its variants place that route otherwise, each a patch against the fix:

- **r3** (`abJ/r3.patch`): `check_lower_logical` takes the program and the node's value, as `check_lower_expand` has
  them, and a vector's conditional goes out of line from the logical operators' branch, the vector operators' test
  being main's;
- **r4** (`abJ/r4.patch`): main's inline code of the logical operators, with a branch of its own for a vector's
  conditional before it;
- **b** (`abJ/b.patch`): main's inline code, with the vector operators' test extended to the conditional;
- **c** (`abJ/c.patch`, against `63e99bb`): the merge's three changed sources with the old test removed (bit casts
  then splat: a reference, not a fix), in the fix's tree, whose other difference from the merge is
  `docs/c-checker.md`.

abJ.sh built them and measured `-c` alone, in two rounds of `perf stat -r 11` whose order rotates (`abJ/perf.log`); the
medians of the rounds:

| `sqlite3.c -c` | base | A/A copy | head | r3 | r4 | b | c |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| instructions | 1,296,550,042 | 1,296,550,064 | 1,296,635,536 | 1,296,560,466 | 1,296,694,036 | 1,296,635,946 | 1,296,548,428 |
| against base | | +22 | +85,494 | +10,424 | +143,994 | +85,904 | -1,614 |
| cycles | 592.513 M | 593.021 M | 592.878 M | 596.573 M | 594.787 M | 593.839 M | 593.970 M |

The fix took the 3.17 M instructions to 85,494, and r3 to 10,424, the fewest of the variants that splat a vector
conditional's scalar arm. No tree's cycles differ from base's by more than the A/A copy's two rounds differ from each
other (595.290 M and 590.751 M, 0.77%). The branch's next head takes r3 (abK).

## abK: the head with r3, after its merge of main

Base: main `da8424103bf67b1fc608acfbd37b1b3523f9c650`; head: the branch's `94be962aa4388782b86b74cf4741ba20dc267bab`,
r3 on its merge `8812a8475f1bfbde8cdd65bd194418c4f1d497cb` of that main. abK.sh built both, ran each tree's `-c` of
`sqlite3.c` (the same object, by base, its A/A copy and head) and `main.c`, then three rounds of `perf stat -r 11`
(`-r 5` for `main.c`) whose order rotates; the medians of the rounds (`abK/perf.log`):

| Measure | base | A/A copy | head | head against base |
| --- | ---: | ---: | ---: | ---: |
| `sqlite3.c -fsyntax-only`, instructions | 1,023,511,202 | 1,023,511,177 | 1,023,512,143 | +941 |
| `sqlite3.c -fsyntax-only`, cycles | 469.255 M | 468.854 M | 465.426 M | -0.82% |
| `sqlite3.c -c`, instructions | 1,297,785,059 | 1,297,785,029 | 1,297,789,671 | +4,612 |
| `sqlite3.c -c`, cycles | 592.884 M | 592.924 M | 590.243 M | -0.45% |
| `main.c -fsyntax-only`, instructions | 19,057,928,278 | 19,057,923,476 | 19,057,919,438 | -8,840 |
| `main.c -fsyntax-only`, cycles | 7,210.424 M | 7,214.405 M | 7,224.154 M | +0.19% |

`-c` ran 4,612 more instructions than main (0.0004%), and `-fsyntax-only` 941: abG's 3.17 M are gone. `main.c`'s
-8,840 is inside the A/A copy's rounds' spread (19,057,922,777 to 19,057,934,640). Head's cycles are 0.82% and 0.45%
below base's in `sqlite3.c`, in every round, with no instructions behind them; this record doesn't attribute them.
`main.c`'s +0.19% is inside base's own rounds' spread (7,200.396 M to 7,236.572 M, 0.50%).

## Files

| File | What it is |
| --- | --- |
| `abG/abG.sh`, `abG/abG.log`, `abG/perf.log`, `abG/inputs.sha256` | abG's script and log, `perf stat`'s output, and the executables', objects' and inputs' hashes. |
| `abG/build_*.log`, `abG/lower_*.log`, `abG/main_*.log` | Its builds' reports, and each tree's `-c` and `main.c` runs' output. |
| `abH/abH.sh`, `abH/abH.log`, `abH/perf.log` | The variants' builds and their `-c` objects' check, and its stopped perf rounds. |
| `abH/abH2.sh`, `abH/abH2.log`, `abH/perf2.log`, `abH/inputs2.sha256` | The variants' `-c` measurement, its log, and the hashes. |
| `abH/v1.patch`, `abH/v2.patch` | The variants against `ff2b8e0`. |
| `abH/build_*.log`, `abH/lower_*.log` | Their builds' reports and `-c` runs' output. |
| `abJ/abJ.sh`, `abJ/abJ.log`, `abJ/perf.log`, `abJ/inputs.sha256` | abJ's script and log, `perf stat`'s output, and the executables', objects' and inputs' hashes. |
| `abJ/r3.patch`, `abJ/r4.patch`, `abJ/b.patch`, `abJ/c.patch` | The variants against `499c1ce`, and `c`'s against `63e99bb`. |
| `abJ/build_*.log`, `abJ/lower_*.log` | Their builds' reports and `-c` runs' output. |
| `abK/abK.sh`, `abK/abK.log`, `abK/perf.log`, `abK/inputs.sha256` | abK's script and log, `perf stat`'s output, and the executables', objects' and inputs' hashes. |
| `abK/build_*.log`, `abK/lower_*.log`, `abK/main_*.log` | Its builds' reports, and each tree's `-c` and `main.c` runs' output. |
| `sources.sha256` | Each tree's sources' list hashed, and the commit and patch they match. |
