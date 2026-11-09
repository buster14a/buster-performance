# PR #1719: retained lexer regression and rejected immediate-encoding hypothesis

The historical `d7ccc6a3` → `5f995cd7` comparison reproduces a slower generated
lexer benchmark despite fewer instructions. A local shortest-immediate candidate
passes focused native checks but is slower in its own direct comparison. It was
rejected as a runtime fix and remains uncommitted. These results leave
[#1218](https://github.com/buster14a/buster/issues/1218)'s performance acceptance open.

## Exact scope and results

These are whole processes of the generated `c_lexer_benchmark.c` program on the
215,692-byte `c_lexer.c` input. Each process checks the corpus, then runs both
vector and scalar tokenizers: one warm-up and 21 timed passes per tokenizer.
The comparison command makes one whole-process warm-up and 11 rotating measured
rounds per build. It also measures independent machine-row and scan fixtures;
their complete results remain in the raw logs.

| Comparison | Base/head wall medians, ms | Base/head user cycles | Base/head instructions |
| --- | ---: | ---: | ---: |
| Original [CI run 42423116653](https://github.com/buster14a/buster/actions/runs/42423116653), `d7ccc6a3` → `5f995cd7` | 46.173 / 46.856 | 254,653,680 / 258,497,789 | 664,584,794 / 647,312,169 |
| Retained replay, same revisions | 46.182 / 46.736 (**+1.20%**) | 254,639,830 / 257,600,166 (**+1.16%**) | 664,564,780 / 647,292,744 (**−2.60%**) |
| Direct `5f995cd7` → local imm8 candidate | 46.693 / 47.104 (**+0.88%**) | 257,556,256 / 259,857,147 (**+0.89%**) | 647,293,534 / 647,293,398 |

All 11 paired whole-process wall comparisons regress in each campaign. Retained
replay paired wall ratios range from 1.00677 to 1.01633; the rejected candidate's
range is 1.00310 to 1.01316. The before object in the candidate comparison is
byte-identical to the replay's `5f995cd7` object (SHA256
`ba5e35501546faa0dadf3d8029dfd08dd3ac060378a275104d57286320d69476`).

The retained replay's initial internal medians localize the larger difference to
the scalar path: vector cycles/byte 25.739 → 25.754, scalar 23.726 → 24.353
(+2.64%); scalar instructions/byte decrease 94.052 → 90.625. In the separate
candidate comparison, vector cycles/byte are 25.740 → 25.769 and scalar
24.493 → 24.738 (+1.00%). These internal summaries are from the initial
validation processes, not an aggregation of all whole-process rounds.

## Encoding hypothesis and bounded inspection

The original head forces full immediates for 14 memory CMP instructions against
zero: six dword and eight qword operands. Each could use a sign-extended byte,
saving 42 immediate bytes before padding. The sole such CMP in
`c_tokenize_scalar_range` is on the UCN code-point path, rather than the ordinary
ASCII identifier loop. The candidate reuses the existing width-aware immediate
proof and field encoder, including normalized narrow negative values. Native
selection checks pass **780,063/0 failures**, and emission checks **280,436/0**.
The candidate's records/rows/moves remain 29,819/254/333; its `.text` shrinks
54 bytes including padding, but its measured runtime is adverse.

Two short cycle-sampling profiles contain 2,601/2,624 samples with zero reported
loss. Some sample increases occur in `peek_char` and `skip_line_comment`, whose
local instruction sequences are unchanged except for call displacements. Other
hot helpers do change instruction selection. The profiles are too small to
attribute a roughly 1% effect precisely; changed callees, branch/call edges,
relative layout and sampling variation remain possible explanations. No causal
load-latency or layout conclusion is established.

## Limits and later integration

Each comparison has one generated layout per revision. There is no repeated-base
floor, independent relative-layout sweep, or general speedup acceptance. Do not
multiply the separate campaigns into a supposedly measured candidate/main ratio.
Counter-bearing profiling runs are inspection evidence, not timing acceptance.
No further campaign was run after the adverse candidate pair.

The maintainer subsequently merged [PR #1719](https://github.com/buster14a/buster/pull/1719)
at **2026-11-08 00:32:58 UTC**, merge
`6361398abace4bc0a234d7496b9f03951a760687`, parents `0cf40fd3` and `5f995cd7`.
Its tree `ee1b697f46e6afd16572e3a76ad189462d4a4744` equals the independently
reviewed, uncommitted refresh checkpoint. That current-parent tree was **not
measured by this record**. The old regression and rejected candidate remain
historical evidence, not qualification or disqualification of later main.

See [commands.txt](commands.txt), [provenance](PROVENANCE.md), raw logs, scoped
assembly and SHA256 inventory. Binaries, objects, raw perf data and complete
disassemblies remain retained with hashes; none is included here.

---
Agent session: 01a1b81e-6ae2-7022-84e9-95739850f990, task /root/review_diagnostics;
independent source review /root/review_codegen and /root/review_diagnostics/refresh_delta_review,
decision /root (OpenAI Codex session ID; no private share URL is exposed)
Model: OpenAI / GPT-6 (exact runtime variant not exposed)
