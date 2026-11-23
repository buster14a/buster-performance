# #2841: Tier 0's register homes weighted by loop depth, on the 9700X

[buster#2841](https://github.com/buster14a/buster/issues/2841), PR
[buster#3322](https://github.com/buster14a/buster/pull/3322): `tier0_assign_homes` counts each reference
`8^min(depth, 4)` times, its loop depth, so that a loop's locals win registers over straight-line code's. Base is main
`a891cc05` (before the change); head is the PR's first commit `7e33a31d`. The PR's later commits (`2c2f047b`, a direct
asm goto dispatch's references at each entry's weight; a merge of main) change no function of the programs measured
here. Both were built with `./build.sh --config Release` at `BUSTER_HOST_ARCH=znver5`, `BUSTER_DEBUG_INFO=0`, on the
Ryzen 7 9700X (`raw/environment.txt`); every timed run had its own `exclusive.sh` hold on CPU 2. Lock-wait notices,
which quoted other sessions' commands, are stripped from the logs.

**Outcome:** no gain anywhere, and a 2 to 3% loss on Lua's call-heavy scripts at Tier 0. The weights don't close
#1398 step 5's lexer gap, so `--tier0-inline-shapes` stays opt-in.

## Scripts

- `run-2841.sh BASE HEAD [PHASES]` (the previous owner session's; its header lists the phases): the #1398 kernels
  (`kernels.c`, `driver.c`), `main.c`'s `-c` object with and without `--tier0-inline-shapes`, `-c` compile time of
  `sqlite3.c` and `main.c` by `time-runs` under 3 rounds, the head's sources self-built at Tier 0 by each compiler with
  and without the shapes and their `benchmark-lexer`, `benchmark-refinement` and `benchmark-files` twice each, then
  speedtest1 and Lua 5.4.8 (`measure-tier1-programs`' five scripts) by each compiler's Tier 0, by `time-runs`, twice.
- `lua-frames.sh`: static comparison of the two Lua binaries' hot call-path functions (`raw/lua-frames.txt`).

## Results

Self-built compiler, `benchmark-lexer src`'s `c_tokenize` (`raw/selfhost`), cycles/B (instructions/B), two runs:

| build | without shapes | with `--tier0-inline-shapes` |
| --- | ---: | ---: |
| base | 48.668, 48.666 (63.576) | 49.924 (64.836); the other run 97.3, an outlier |
| head | 48.694, 48.925 (63.579) | 49.917, 49.874 (64.842) |

The shapes still cost 2.5%, and their instructions per byte are unchanged by the weights. `refine_tokens_fused` is
within 0.3% across all four builds; `benchmark-files` (1 lane) takes 1118.5/1118.7 ms by base, 1115.0/1117.2 by head,
and about 1.3% more with the shapes by either (1132.7/1134.1, 1129.3/1131.0).

Tier 0 programs (`raw/programs`), head against base, wall time median of 5, two rounds; every output matches:

| program | round 1 | round 2 |
| --- | ---: | ---: |
| speedtest1 `--size 5` mix1 | +0.10% | +0.45% |
| Lua calls | +1.62% | +3.06% |
| Lua closures | +2.05% | +2.13% |
| Lua strings | −1.46% | −1.10% |
| Lua tables | −0.44% | −0.57% |
| Lua arithmetic | +0.50% | −0.15% |

#1398's kernels (`raw/kernels`): the code differs, but each kernel's time by head lies within base's run-to-run
spread (for example `k_sum` 324.3 and 314.9 ms by head, 324.2, 324.3 and 315.0 by base).

Compile time (`raw/compile`): `main.c` head +0.01% instructions and wall within noise; with the shapes +3.0%
instructions and +2.3% wall. `sqlite3.c` head +0.1% instructions; shapes +0.3 to +0.8% cycles.

`main.c`'s object (`raw/objects/sizes.txt`): `.text` +0.35% by head; 9.13 MB against 3.33 MB with the shapes.

## Why Lua's calls lose

`raw/lua-frames.txt`: with the weights, a hot function's rarely-run loop wins homes from the straight-line code that
runs on every call. `luaD_precall`'s loop that fills missing fixed parameters with nil takes registers from its
`func`/`ci`/`L` path (frame-slot accesses 21 → 26), and `luaD_pretailcall`'s likewise (25 → 30). `luaF_close` and
`luaF_closeupval` keep their loop's locals in registers now (frame accesses 4 → 0, 3 → 1) but push two and one more
callee-saved registers on every call (4 → 6, 5 → 6), as the callee-saved threshold admits a local referenced once in a
loop. Loop depth alone doesn't tell a hot loop from a cold one in a function whose straight-line path is what runs.

## Variants (2026-11-23)

Two bounded rounds to find a rule without the loss (`variants/`). `x2841.patch` is an experiment on the PR's merged
head `c9d66c22`, never part of a PR: `X2841_SHIFT` picks the loop factor (0 gives main's unweighted homes exactly, 3
the PR's 8x, 1 a factor of 2) and `X2841_CALLEE=1` makes a local referenced once count 1 wherever it is (so a loop
alone doesn't admit it to a callee-saved register). One compiler built every variant's programs.

- Static first (`variants/static.txt`, `lua-static.sh`): at a factor of 2 `luaD_precall` and `luaD_pretailcall` are
  back within one frame access of base; the once-counts-1 rule undoes `luaF_close`'s extra pushes. No variant changes
  the spliced lexer's `tokenize_c` (22,098 accesses by s1 and once1 against base's 22,093).
- Round 1 (`run-variants.sh`, `variants/round1`), against base, 5 runs, two rounds:

  | program | head (8x) | s1 (2x) | once1 (2x, once counts 1) |
  | --- | ---: | ---: | ---: |
  | speedtest1 | −1.49, −1.68 | −2.09, −2.20 | −2.61, −2.72 |
  | Lua calls | +2.40, +2.92 | +0.30, +0.87 | +0.30, +1.50 |
  | closures | −0.28, +0.87 | −0.34, −1.06 | −0.35, −1.77 |
  | strings | −0.36, −0.90 | +1.09, +0.46 | +2.85, +2.49 |
  | tables | −0.58, +0.31 | −0.12, +0.66 | −1.46, −1.13 |
  | arithmetic | +0.25, −1.59 | −0.11, −1.74 | −0.02, −1.64 |

- Round 2 (`run-variants2.sh`, `variants/round2`), s1 only, Lua at 9 runs: the self-built lexer's `c_tokenize`
  48.59/48.59 cycles/B by s1 against 48.73/48.69 by base (−0.25%), `refine_tokens_fused` and `benchmark-files` within
  noise; speedtest1 −1.11/−0.89%; Lua calls +1.24/+1.15%, strings +1.16/+1.45%, tables +0.96/+1.42%, closures
  −0.75/−0.71%, arithmetic −0.22/−0.30%; head again calls +3.18/+3.18%.

**Outcome:** no variant gains without a loss. s1 wins speedtest1 by 1 to 2% and the lexer by 0.25%, but runs Lua's
calls (+0.3 to +1.2% in four measurements) and strings (+0.5 to +1.5%) slower; once1 loses strings by 2.5 to 2.9%.
