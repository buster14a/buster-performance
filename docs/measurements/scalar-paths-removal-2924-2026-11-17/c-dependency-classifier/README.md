# The Make-rule classifier's twin (#2924)

`c_dependency.c`'s `dependency_special` (which of up to 64 bytes of a path need escaping in a Make rule) had a scalar
twin, `dependency_special_scalar`, chosen by `DependencyRule.scalar` from `PPOptions.scalar`. It was in no group's list.
The coordinator assigned it on 2026-11-23 under the owner's rules (buster#2924 7112387760). Branch
`claude/2924-dependency`.

## Harness

[`dep-bench.c`](dep-bench.c) (EXPERIMENT ONLY) includes `c_dependency.c` (or a variant) and times `dependency_rule`
with `rule.scalar` off and on, alternately. Each sample is 200 rules of 200 prerequisites whose paths are LENGTH bytes,
for LENGTH 1 to 128, and of musl's 230 header paths (`paths.txt`). It reports the median of 41 samples, in rdtsc cycles
per rule. Built in the container (clang 23.1.4, `-O2 -march=znver5`). Run on the 9700X, CPU 2, under the lock, three
runs each ([`logs.tar.gz`](logs.tar.gz)).

[`check.c`](check.c) compares a variant with the scalar classifier for every byte value, at every length 0 to 64.
v1, v3 and v4 agree everywhere.

## Twin/vector cycles (above 1: the vector path is faster), three runs

| Length | original arm | v1 | v3 | v4 (kept) | control |
| --- | --- | --- | --- | --- | --- |
| 1 | 0.85, 0.84, 0.86 | 0.94, 0.96, 0.95 | 0.97, 0.94, 0.96 | 0.94, 0.95, 0.95 | 1.04, 1.06, 1.05 |
| 2 | 0.90, 0.89, 0.92 | 1.00, 1.03, 1.01 | 1.04, 0.99, 1.02 | 0.99, 1.00, 1.03 | 1.05, 1.06, 1.07 |
| 3 | 1.04, 1.00, 1.04 | 1.13, 1.14, 1.14 | 1.15, 1.10, 1.16 | 1.10, 1.13, 1.14 | 1.05, 1.00, 0.99 |
| 8 | 0.94, 0.95, 0.95 | 1.03, 1.04, 1.05 | 1.07, 1.04, 1.07 | 1.02, 1.03, 1.05 | 1.00, 0.99, 1.00 |
| 12 | 1.28, 1.25, 1.28 | 1.40, 1.41, 1.39 | 1.43, 1.38, 1.42 | 1.37, 1.39, 1.39 | 1.10, 1.10, 1.10 |
| 16 | 1.03, 1.01, 1.03 | 1.12, 1.11, 1.11 | 1.15, 1.10, 1.14 | 1.10, 1.12, 1.12 | 1.02, 1.01, 1.01 |
| 64 | 3.00, 2.88, 2.97 | 3.24, 3.25, 3.18 | | | 1.00, 1.00, 1.00 |
| musl's headers | 2.53, 2.58, 2.66 | 2.93 to 2.99 | 2.92 | 2.94 | 1.00 |

The full tables are in the logs: `run*.txt` and `r*.txt` hold the original arm, `r*-v1.txt` and `s*-v*.txt` the
variants, and `c*.txt` the control.

- **original arm:** eight compares ORed through mask registers, a mask from a branch on `count == 64`, and no call at
  `count == 0`.
- **v1:** a `bzhi` mask; the bytes below 64 are looked up in a table with `vpermb` (0x01 at NUL, tab, LF, CR, space,
  `#` and `$`), and `\` is a compare.
- **v3:** one `vpermi2b` over a 128-byte table, with bytes from 128 up excluded by their sign.
- **v4:** v1 without the `count != 0` branch, since a zero count gives an empty mask. **This one is kept.**
- **control:** both slots run the scalar classifier. Identical code in the two places reads 4% to 7% apart at 1 and
  2 bytes and 10% apart at 12. Placement alone gives this harness that spread at short lengths.

Mutants of v4 against `tests/driver/dependency_rule.c`: 7 of 8 are killed (a table entry dropped, the `\` compare
dropped, the low-byte mask, the live mask dropped or cut). `low-63` is equivalent: table entry 63 is zero.

## Reading

v4 is at least as fast as the twin at every length but one. One-byte paths read 0.94 to 0.95 of the twin's cycles,
about 1.5 cycles of ~37 per path. That sits inside the identical-code control's own spread at that length (1.04 to
1.06), but the control favoured the vector slot, so a small real loss is likely. Such a path has no directory and no
extension, so it essentially never occurs in `-M` output. The coordinator read it as parity under rule 3 (2026-11-24).
The deletion follows: `-M` of musl's units, `-MM` of Lua's and `-M` of sqlite3.c give byte-identical rules before and
after it (this container).
