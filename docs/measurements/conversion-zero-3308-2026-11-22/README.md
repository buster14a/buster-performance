# #3308: zeroing legacy conversions' destinations, on the 9700X

buster14a/buster#3308, branch `claude/tier0-convert-zero-3308`. Base: main `1f7ce98f`; fix: base plus the
branch's compiler commit (`builds.log`). Both trees built `--config Release` under `exclusive.sh` (`build.sh`).

Timings: `time.sh` / `time2.sh` compile the kernel with each tree's Tier 0, the fix's `--tier1` and clang -O0, then
run all four interleaved, 15 rounds, `taskset -c 2`, inside one hold of the lock (loadavg and busiest processes
before and after in the logs). Wall time per process, from `date +%s%N`.

| kernel | base Tier 0 | fix Tier 0 | fix `--tier1` | clang -O0 |
| --- | ---: | ---: | ---: | ---: |
| `sn.c` (the issue's spectral-norm, n = 700, 6 rounds), best / mean ms | 22.9 / 23.8 | 23.1 / 23.4 | 5.5 / 5.8 | 13.9 / 14.0 |
| `sn2.c` (A() times v[j] stored, no accumulator), best / mean ms | 7.4 / 7.7 | 7.4 / 7.7 | 5.6 / 5.8 | 8.4 / 8.7 |

All outputs agree (`times*.log`'s first lines). `A-base.s` / `A-fix.s`: the only change in `A` is the `xorps
%xmm1,%xmm1` before `cvtsi2sd %eax,%xmm1`.

`merge.c` / `merge.log`: A()'s tail and the caller's product as a loop in inline asm, xmm1 carrying the previous
iteration's divsd and mulsd into cvtsi2sd, with and without the xorps: 0.728 vs 0.722 ns per iteration (about 3.9
cycles, below divsd's latency), so on Zen 5 the register form of cvtsi2sd shows no dependence on its destination's old
value. That is why spectral-norm doesn't move here; the issue's 1.55x (93 -> 60 ms) is on an Intel Xeon, where the
merge dependency is real. Tier 0's spectral-norm loop on Zen 5 is bound instead by the accumulator's two stack
round trips around the call (`0x18(%rsp)` -> `(%rsp)` -> addsd -> `0x18(%rsp)`), about 20 cycles per iteration.
