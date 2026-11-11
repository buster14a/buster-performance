# asm goto as an asm body against its helper — #1839, 2026-11-11

Source: buster's branch `claude/b5b-asm-goto-body` (#1839's item 2): an asm goto,
which was a call of its helper `.Lbuster_asm_N` returning an exit number, is placed
in its caller as a Tier 0 asm body. The exits and stores run in the caller's code,
the exit number is the body's call row's result in eax, and the statement's
dispatch on it is unchanged.

## Run

On `benchpress` (Ryzen 7 9700X), under the shared host lock
(`~/buster-fast-bench/exclusive.sh`), each run pinned with `taskset -c 2`, wall
time from `date +%s%N` (`time.sh`):
- base `d86de4563c05` (main) and head `e656102e` (`base.rev`, `head.rev`), both
  built on benchpress by `./build.sh` (Release, native; `build-base.log`,
  `build-head.log`);
- the kernel `goto.c`, compiled by each build at its default (Tier 0): 200
  million iterations of a sign test branching to two labels and a compare with
  an output reaching a label;
- 5 rounds, base and head alternately (`times.tsv`). Both print 1699999997 in
  every run.

`run.sh` built the trees and its own timing loop (`results.tsv`, `run.log`)
recorded no times: benchpress has no `bc`. `time.sh` timed the same binaries.

## Result

| build | median | runs (ms) |
|---|---|---|
| base (helper) | 771.4 ms | 775.9, 771.4, 763.2, 762.2, 783.0 |
| head (body) | 526.6 ms | 523.7, 524.8, 533.7, 526.6, 541.6 |

Head is 31.7% faster (median against median).

`sign-base.s` and `sign-head.s` are `sign`'s code in each build. Base calls the
helper (`call`, its frame and the block's address); head runs the template's
`test`/`je`/`js`, the exits' moves and jumps and the move into eax in its
caller, and both then dispatch on the exit (`cmp`/`je`), as clang's `callbr`
doesn't: jumping straight to the labels is a follow-up.
