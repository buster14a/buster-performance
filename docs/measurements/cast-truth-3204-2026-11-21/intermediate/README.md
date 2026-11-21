# Superseded PR #3214 revisions

These paired readings apply to two intermediate revisions. Both were subsequently revised for diagnostic correctness. Each run compares its candidate to the frozen #3213 checker. The source change to the window's C loop is identical in both candidates. Each candidate's disassembled function contains 1,314 instructions with the same opcode sequence. The baseline function contains 1,349.

| Candidate and C-loop pass | SQLite | Lua | musl |
| --- | ---: | ---: | ---: |
| fcaca00fc, first | +0.00337 | −0.09432 | +0.58847 |
| fcaca00fc, repeat | −0.05816 | −0.05705 | +0.04551 |
| f9fd5d75e, first | −0.03706 | −0.16824 | +0.28768 |
| f9fd5d75e, repeat | −0.04014 | −0.04352 | −0.01214 |

Each value is the median of seven paired A–B–B–A differences, in TSC ticks per swept record, with a fresh copy of each executable for every round. The numerator is C's `the loop` field inside `window contexts ticks` or the same-chunk repeat. The denominator is C's `records-swept`. All runs held the shared lock on CPU 2 on the Ryzen 7 9700X. Both musl first-pass medians exceed the issue's +0.20 refutation threshold. For f9fd5d75e the musl range is −1.17 to +3.04 and the two baseline samples differ by a median −1.89. Each case's full range and the two baseline samples' spread can be regenerated from the archived reports.

The first candidate is fcaca00fc11d4d7e37a5908a57de39456fac027e, the second is f9fd5d75e5c9142e1f48111b204f8699f08d1292. Their respective combined source patches on 0647d69ba8af4e466c89df2519dea0b382524d37 have SHA-256 3c8bc4733823d393ed78df58eebfcabd045b21ff2831336439765eb36f420cdc and f3f18b48d29796d1477366734dccde14dae2162186762f0c22196f852d936d88. The earlier round shared the machine with our mutation campaign between sampling commands; the later round was batched separately. For the second candidate the syntax diagnostics, statuses and every window-shadow comparison agreed on all four frozen sources under both warning settings, as recorded in `f9-corpora.tsv`. A separate query oracle caught the regression that led to that candidate's replacement.

To repeat the timing analysis, extract both archives and run the following commands.

```sh
tar -xJf fcaca00fc.tar.xz
tar -xJf f9fd5d75e.tar.xz
python3 c-loop.py ref3213 final3204 -final
python3 c-loop.py refstrictf9 strictf9 -strictf9
```
