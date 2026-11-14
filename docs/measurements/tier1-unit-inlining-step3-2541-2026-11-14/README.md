# #2541 step 3: inlined subroutines under `-g`, the splice's rule, cyclic callees (2026-11-14)

The measurements of step 3 of
[#2541's design](https://github.com/buster14a/buster/blob/main/docs/tier1-unit-inlining.md): Tier 1's expanded callees as
`DW_TAG_inlined_subroutine` entries under `-g`; callees in cycles copied into callers outside them; the vector splice's
rule for a caller's own operands. Step 2's record is `tier1-unit-inlining-step2-2541-2026-11-14`, whose scripts these
runs used (`scripts` there).

- **Host:** AMD Ryzen 7 9700X, as step 2's record (`host.txt` there). Every run held the machine's lock, one hold per
  command (`9700x/q12.txt` and its log).
- **head4:** `583e24997b912988a24605be67fecf4849768337`, step 2's head merged with main (`9700x/head4.commit`); **s3:**
  the same with `9700x/cyclic-and-splice.diff` (cyclic callees and the splice rule; `9700x/s3.commit` is its base).

## Inlined subroutines under `-g`

The gate, gdb's backtrace showing an expanded callee, is checked by `test-check-debug`'s inline-instance fixture
(`check_debug_tier1_inline_test`): two static callees, one expanded into the other and both into `main`, by both paths
and one lane and eight; gdb stopped at the innermost callee's line in `main`'s code shows

```
#0  t1i_square (x=<optimized out>) at dbg_tier1_inline.c:6
#1  t1i_twice (x=<optimized out>) at dbg_tier1_inline.c:11
#2  main () at dbg_tier1_inline.c:18
```

(the shape of the fixture's checks; without the instances' DIEs the check fails on both paths). On the session's
container: sqlite3.c by `--tier1 -g -O2 -c` passes `llvm-dwarfdump --verify` with 16,708 instances; speedtest1's
executable by `--tier1 -O2` is the same `.text` bytes with `-g` and without; `--tier1 --tier1-no-inline -g` and without
`-g` write the same `.text` of sqlite3.c too. No timing: `-g` changes no code.

## Cyclic callees: measured, not adopted

q12, nine rounds (three holds of three), against step 2's head (`9700x/summary.txt`, `9700x/results`):

| | head4 | s3 | change |
| --- | ---: | ---: | ---: |
| speedtest1, M cycles | 753.8 | 754.9 | +0.14 (-0.27 to +0.54), faster at 2 of 8 |
| Lua, five scripts | 1,016.3 | 1,006.7 | -0.94 (-3.29 to +1.41), faster at 3 of 4 |
| closures.lua | 298.2 | 286.5 | -3.99 (-6.73 to -1.25), faster at 4 of 4 |
| speedtest1.o `.text` | 1,632,764 | 1,650,220 | +1.1% |
| Lua's units `.text` | 329,062 | 335,208 | +1.9% |
| `--tier1 -c sqlite3.c`, M cycles | 3,473.7 | 3,507.4 | +1.0% (`.text` +1.1%) |
| the self-built compiler's returns, M | 59.6 | 60.0 | |

Objects 72 of 72 the same bytes by lanes, holding and both twins (s3). No program of the gate gains for the code and the
compile it costs: not adopted. `cyclic-and-splice.diff` keeps it (the splice rule in it is the one adopted, which changes
no code).

## The splice's rule for a caller's own operands

`scripts/splice_rule_bench.c` (built on the host with `cc -O2 -march=native`, run under the lock on CPU 2): a caller of N nodes with K expanded sites, its operand columns rebased 16 nodes a
vector by four forms checked against the scalar loop first: gathers through the destination tables (step 1's), masked
adds over the sites before the vector, masked adds over every site (the splice's: an operand may name a value laid out
after its use), and a rank-and-permute form for up to 15 sites. On the 9700X, TSC cycles a node
(`9700x/step3/splice_rule_bench.txt`; the first run, without the every-site form, `splice_rule_bench-1.txt`):

| nodes | gather | every site, 1 | 4 | 8 | 12 | 16 | 32 |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 64 | 5.34 | 1.17 | 1.78 | 3.56 | 5.34 | 5.94 | 13.06 |
| 256 | 5.94 | 1.19 | 2.23 | 3.86 | 6.23 | 7.57 | 14.10 |
| 1,024 | 6.16 | 1.30 | 2.49 | 4.27 | 6.12 | 7.83 | 14.77 |
| 4,096 | 7.31 | 1.38 | 2.67 | 4.78 | 6.56 | 8.24 | 14.74 |

Every size measured up to 8 sites, the adds take fewer cycles; at 12 not at all of them. The rule: masked adds up to 8
sites, gathers past them. On sqlite3.c (`local/census-sqlite3.tsv`, a line per caller rewritten: its expanded sites and
its nodes, by a temporary print, `local/census-print.diff`), 1,478 of the 1,698 callers with expansions (87%) have at
most 8 sites, 47.5% of the nodes copied. The copy is under 0.1% of the compile either way; no end-to-end run can see it.
`local/splice_rule_bench-xeon.txt` is the same program on the session's container (an Intel Xeon), where the crossover
is lower (about 6 sites).
