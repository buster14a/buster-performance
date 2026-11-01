# Mask spills to memory against to a general register (buster #179), 2026-11-01

[buster #179](https://github.com/buster14a/buster/issues/179) leaves where a spilled AVX-512 mask goes, its stack slot
or a free general register, to a measurement on the 9700X. This is that measurement: `measure-mask-spills`, which
[buster PR #997](https://github.com/buster14a/buster/pull/997) adds, run by the PR's CI job on the shared Ryzen 7
9700X. The job holds the host's lock for its whole run (the runner's hooks), and the step pins the command to CPU 2.

## Sources and host

- **buster:** [`f96a98c85cfe8c60ba90f70dfad256581afae229`](https://github.com/buster14a/buster/tree/f96a98c85cfe8c60ba90f70dfad256581afae229),
  PR #997's head (branch `claude/cool-thompson-ojz9n5`). `src/buster/compiler/mask_spill_measure.c`, SHA-256
  `d77a31890393c59518f3b60c6c0fbde9683e10e149ba5b264e4fb3ff8d647c5c`, as the step printed it and as the commit has it.
- **Executable:** the job's build (`BUSTER_HOST_ARCH=znver5`), `build/compiler` SHA-256
  `ad49f5c4a65a9c860ec227d35c6ff57e7ab5a97a5ba9182fe00fd0d344e20057`, by clang 23.1.4
  (`7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`).
- **Run:** [run 41255263386](https://github.com/buster14a/buster/actions/runs/41255263386), job
  [124700707601](https://github.com/buster14a/buster/actions/runs/41255263386/job/124700707601) ("Native tests and
  benchmarks on Benchpress (Ryzen 7 9700X)"), the step "Measure mask spills to memory and to general registers",
  2026-11-01 00:26:03 to 00:26:05 UTC, after the job's native correctness step had passed.
- **Host:** AMD Ryzen 7 9700X, CPUID `00b40f40`. The command checks both and printed `approved=yes`.
- **Command:** `taskset -c 2 ./build/compiler measure-mask-spills --passes 21 --iterations 20000`.

`logs/9700x/measure-mask-spills.log` is the step's output as the job's log has it, from the step's start to the table's
last row, and the job hook's line that gave the machine back.

## What it measures

Each program is a loop of 84 steps, run for 20,000 iterations. A step is a `kadd` of the step's width that adds k0 (1)
to its chain's mask. Before the `kadd`, the strategy spills that mask and reloads it:

- `none`: no spill. This is the control.
- `memory`: `kmov` of the width to the chain's 8-byte stack slot, then back.
- `general`: `kmov` of the width to the chain's general register (rax, rcx, rdx, r8 to r11), then back.

The other parameters:

- **Chains:** one chain (k1) measures a round trip's latency. Seven independent ones (k1 to k7, the step's chain in
  turn) measure throughput.
- **Mix:** `vector` adds a `vpaddd` of a ZMM register to each step, four independent chains of them, as vector code has
  around its masks. `kmov k, r` takes a vector pipe.
- **Widths:** 1, 2, 4 and 8 bytes: `kmovb` with `kaddb` (AVX512DQ), `kmovw` (AVX512F) with `kaddw` (DQ), and `kmovd` and
  `kmovq` with `kaddd` and `kaddq` (AVX512BW).

`test-mask-spills` checks every program before any of this counts. Both encoders must give the same bytes and
`x86_validate` must accept them. The loop's instruction count must be the steps' recipe. Each mask's final value
after 1, 3 and 1,000 iterations must match the chains' arithmetic. The job's correctness step ran it, as does buster's
correctness list.

The command reads core cycles (perf, user mode). It reports per step:

- the median of the 21 passes, each pass running the three strategies in rotating order;
- the passes' minimum and maximum;
- `extra`: the median less the control's.

Every sample is also checked against its counters: the retired instructions must be the loop's, and the counters must
run the whole time.

## Results

Every width gives the same medians to within 0.007 cycles per step, so the table gives the 8-byte (`kmovq`, `kaddq`)
rows. The log has every width's rows.

| Chains | Mix | Strategy | Cycles per step | Extra |
| --- | --- | --- | ---: | ---: |
| 1 | none | none | 1.000 | 0 |
| 1 | none | memory | 13.001 | 12.001 |
| 1 | none | general | 11.001 | 10.001 |
| 1 | vector | none | 2.000 | 0 |
| 1 | vector | memory | 13.001 | 11.001 |
| 1 | vector | general | 11.001 | 9.001 |
| 7 | none | none | 0.500 | 0 |
| 7 | none | memory | 1.714 | 1.214 |
| 7 | none | general | 1.575 | 1.075 |
| 7 | vector | none | 0.500 | 0 |
| 7 | vector | memory | 1.714 | 1.214 |
| 7 | vector | general | 1.592 | 1.092 |

- **Latency:** a mask's round trip through memory adds 12 cycles to the `kadd`'s 1, and through a general register 10.
  Beside the vector chains, whose control step takes 2 cycles, the round trips' steps take the same 13 and 11 cycles.
- **Throughput:** seven masks' spill and reload pairs cost 1.21 cycles each beyond the `kadd`s through memory, and 1.08
  to 1.09 through general registers. The vector chains beside them change neither.
- **Spread:** the passes' range from fastest to slowest is at most 0.001 cycles per step in 39 of the 48 rows. The
  other nine are the eight rows of seven chains through general registers (0.017 to 0.037), and the byte width's seven
  chains through memory without the vector chains. That row's slowest pass took 1.857 cycles per step, against a
  median and fastest of 1.715 and 1.714.

## Limitations

- One process, in a CI job. These are synthetic loops: dependent round trips and independent pairs, not a compiler's
  mix of code.
- The `general` strategy is given a free general register for every mask. A compiler has to find one. Across a call,
  where every opmask register is caller-saved, only a callee-saved register would do, and the function's prologue and
  epilogue pay to save it. The loops pay neither cost.
- Cycles are core cycles at whatever clock the core ran, with no frequency or throttle reading.

The decision these numbers lead to is in buster's `docs/tier1-allocation.md`, "The opmask class (#179)".
