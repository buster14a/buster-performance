# Tier 1 call arguments out of each other's registers (#2823)

The 9700X record for [PR #3330](https://github.com/buster14a/buster/pull/3330), which fixes [#2823](https://github.com/buster14a/buster/issues/2823).

- **Base:** main at `a891cc0588d75f1f3067bb641ff650afeb05bfa7`.
- **Head:** the same commit plus [head.patch](9700x/head.patch), the PR's source change at `2dfce0d9a5d80e43eda999edb2954fbe28a987b3` (`tier1_cfg.c` and its test; identical, apart from `index` lines, to `git diff a891cc05 2dfce0d9 -- src`).
- **Host:** benchpress, the Ryzen 7 9700X. Release compilers built with the 9700X job's Clang 23.1.4. Every program ran under `exclusive.sh`, one hold per program, pinned to CPU 2. [busy.txt](9700x/busy.txt) has the load and the busiest processes before and after each hold.
- **Scripts:** [measure.sh](9700x/measure.sh) built Lua 5.4.8 (in three link orders, [lua-orders.txt](9700x/lua-orders.txt)) and speedtest1 by each compiler's `--tier1 -fno-asynchronous-unwind-tables`, and by `clang -O0`, then checked outputs ([check.txt](9700x/check.txt)). [timing.sh](9700x/timing.sh) then timed them with `time-runs` over the same builds ([builds.sha256](9700x/builds.sha256), [identity.txt](9700x/identity.txt)).
- The runs were made by session `session_01Egbxnd67mUu2isTgj2N7JT` on 2026-11-23 between 00:41Z and 02:45Z, and archived here by session `session_01NNmNQuxtH8CVoBPk9j5b9y`.

## Checks

Every Lua script's output by base and head, in each link order, is the same as `clang -O0`'s; speedtest1's `--verify` hash is the same for all three builds.

## Results (median, head against base)

| Program | Wall | User cycles | Spread over link orders (wall) |
| --- | ---: | ---: | --- |
| Lua `arithmetic.lua` | +0.69% | +0.69% | −0.12% to +1.22% |
| Lua `calls.lua` | +0.19% | +0.21% | −1.36% to +1.78% |
| Lua `closures.lua` | −0.15% | −0.14% | −5.27% to +1.87% |
| Lua `strings.lua` | −0.79% | −0.86% | −1.75% to +3.74% |
| Lua `tables.lua` | −0.28% | −0.41% | −1.19% to +1.20% |
| speedtest1 (`--size 5 --testset mix1`) | +0.16% | +0.31% | one link |
| compile speedtest1's unity (`--tier1 -c`) | +0.19% | +0.26% | — |
| compile Lua's `lvm.c` (`--tier1 -c`) | −0.02% | +0.08% | — |

Every Lua difference lies inside the spread its link orders give, so wall time and cycles don't move measurably. speedtest1 retires 0.41% fewer instructions (2,418.9 M to 2,409.1 M), with +0.16% wall time inside its run-to-run range (148.4–149.9 ms base, 148.2–150.2 ms head). The compiler's own time doesn't change measurably.
