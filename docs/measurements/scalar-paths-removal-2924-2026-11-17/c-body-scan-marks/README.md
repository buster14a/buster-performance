# C12a's rest: `pp_define`'s body scan by a per-file bitset of marks (#2924)

The owner's rule 2 (2026-11-23, buster#2924 7112387760): the body scan's vector arm loses on musl (7006161887), so
make a vector form at least as fast as the scalar twin everywhere, then delete both arms. The proposal was a per-file
bitset of `#`, `##` and `__VA_OPT__` tokens made by preparation, so that each definition tests a few bits. Two forms
were built and gated. **Neither beats the scalar arm on musl.** This record holds the evidence for the owner.

## The forms

Both are in [`marks-v2-production.patch`](marks-v2-production.patch)'s shape (main `968a085f`): `PPFileData.marks`, a bit
per token, made with the directive table in both preparations (`pp_mark_tokens`, whole and windowed), and
`pp_scan_body`, which reads a definition's bits.

- **v1** ([`body-knob.patch`](body-knob.patch)): marks for every token; the check walks the list's words with a mask
  at each end.
- **v2** ([`body-knob-v2.patch`](body-knob-v2.patch)): the ids (`__VA_OPT__`) read only in 64-token blocks that hold a
  directive's line (a `#` at a line's start, or a block that starts inside one); the check reads 64 bits from the
  list's first token out of two words (`shrd`), tests them against zero and classifies the marked tokens only.

Each knob patch (EXPERIMENT ONLY) puts the old vector arm, the scalar arm and the marks in one executable, chosen by its
file's name: `compiler-areas0` vector, `1` scalar, `2` marks (preparation makes them only here), `4` a control no site
reads; `3` (split patches) makes the marks and checks by the scalar arm. Every timed build is a hard link to one copy.

**Correctness of the marks:** `-E` of musl's 1,336 units, Lua's units and sqlite3.c is byte-identical, output and
diagnostics, for every arm, in both gates. `test-preprocessor --clang` passes (a new lane-position fixture,
`pp_directive_test_marks`, 192 shifts of a block of definitions across the marks' words), and 9 of 11 mutants of the marks
were killed; the 2 that survive only over-report marks, which changes no output.

## The workload

A census of musl's `-E` (all units in one process): **1,454,605 definitions with a body, 1,295,868 of them (89%) one
token long**, 2,572,956 body tokens in all; 16.5 M tokens prepared (and marked). Lua: 50,009 definitions, 64% one token.
sqlite3.c: 4,850 definitions, 1.23 M tokens.

## Results (9700X, Release, CPU 2, under the lock)

**Exact user instructions** (gate2, mean of 9 runs; musl's split runs are one build each):

| Input | scalar arm | marks v2 | vector arm |
| --- | ---: | ---: | ---: |
| musl's units | 4,031.0 M | 4,076.5 M | 4,087.7 M |
| Lua's units | 410.12 M | 411.64 M | 411.28 M |
| sqlite3.c | 190.36 M | 191.19 M | 190.51 M |

v1 on musl: 4,078.2 M (vector 4,089.7 M, scalar 4,036.0 M).

**Where the marks' cost goes, musl** ([`split2`](split2.sh), v2): scalar 4,035.5 M; marks made but checked by the scalar
arm 4,049.4 M (**the pass: +14.0 M**; v1's pass +10.4 M: the directive-line test costs more than the ids it saves on musl,
whose headers are mostly directives); marks 4,073.6 M (**the check: +24.2 M over the scalar loop**, about 17 instructions
a definition). `perf` by symbol (`prof/arm1.txt`, `arm2.txt`): `pp_prepared_directive`, where `pp_define` is inlined, 15.47%
against 16.18% of instructions.

**User cycles against the vector arm,** `ab`, three rounds of `time-runs --runs 3`:

| Input | Gate | scalar arm | marks | control |
| --- | --- | --- | --- | --- |
| musl | v1 | −0.83%, −0.54%, −0.86% | +0.02%, −0.09%, −0.28% | +0.10%, +0.37%, +0.21% |
| musl | v2 | −1.05%, −0.41%, −0.47% | −0.46%, +0.58%, −0.39% | −0.35%, −0.19%, −0.24% |
| Lua | v1 | +0.08%, +0.47%, +0.48% | +0.12%, −0.04%, +0.10% | −0.14%, −0.07%, −0.21% |
| Lua | v2 | +0.32%, +0.29%, +0.15% | −0.02%, −0.19%, +0.08% | +0.16%, −0.42%, −0.09% |
| sqlite3.c | v1 | −0.31%, +2.18%, −0.27% | +0.86%, +0.72%, +0.55% | +0.52%, +0.01%, +0.33% |
| sqlite3.c | v2 | +1.09%, +2.40%, +2.25% | +1.12%, +0.94%, +1.06% | −0.12%, +1.23%, −0.37% |

## Reading

- On musl the scalar arm does the least work per definition: one token is one compare of its kind. Anything per
  file is extra there, and a bit test with its classification costs more than that compare. The marks land between the
  two arms on musl, at parity with the vector arm on Lua, and behind it on sqlite3.c.
- The scalar arm retires the fewest instructions on every input; its cycles lose on Lua (about +0.3%) and, noisily, on
  sqlite3.c.

So no form tried is at least as fast as the scalar arm on musl and as the vector arm on Lua. The choice goes back to the
owner (buster#2924).
