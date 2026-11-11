# loop and jrcxz as asm bodies against the whole assembler's helpers — #1839 item 4, 2026-11-11

Source: buster's branch `claude/b5b-asm-loop-bodies` (#1839's item 4). A `loop` or `jrcxz` to a label of its template's
own, with no sized `jmp` or `jcc` between, was a template for the whole assembler, called as its helper; the assembler
now fixes its rel8 displacement, and the statement is an asm body in its caller.

## Run

On `benchpress` (Ryzen 7 9700X), under the shared host lock, pinned with `taskset -c 2`, wall time from `date +%s%N`
(`loop.sh`):
- base `4f07ef3ff6fc` (main, the branch's merge base) and head `b26cb69ed8b6` (`base4.rev`, `head4.rev`), both built
  on benchpress by `./build.sh` (Release, native; `build-base4.log`, `build-head4.log`);
- `loop.c` by each build at its default (Tier 0): 50 million iterations of a `1: addq %rcx, %0; loop 1b` template (one
  to four turns) and a `jrcxz` template;
- 5 rounds, base and head alternately (`loop-times.tsv`); both print 275000000 in every run.

## Result

| build | median | runs (ms) |
|---|---|---|
| base (helper) | 182.7 ms | 182.4, 182.9, 182.7, 182.9, 182.5 |
| head (body) | 117.1 ms | 117.0, 114.5, 117.1, 117.3, 117.4 |

Head is 35.9% faster. `sum-base4.s` calls the helper; `sum-head4.s` has the template's `loop` in its own code and no
call.
