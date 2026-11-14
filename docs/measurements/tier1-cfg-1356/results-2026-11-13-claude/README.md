# Tier 1 CFG scaling results for Buster #1356 (2026-11-13)

**Result: both shapes scale linearly.** On the Ryzen 7 9700X (benchpress), CPU 2
under the lock, the `tier0` stage of a strict Tier 1 compile (`--tier1
--tier1-strict`, which holds Tier 1's compile) costs about 1.2 to 1.3 µs per
case at every size, for both the switch and the label table. Doubling N
multiplies it by 1.85x to 1.99x. The issue's original figures on main
`02e0838d` were 10.9, 31.8 and 98.5 ms (2.9x and 3.1x per doubling).

This is the measurement that [the packet](../README.md) in this directory
specifies, run by a Claude Code session for
[buster14a/buster#1356](https://github.com/buster14a/buster/issues/1356).

| shape | N | `tier0` median ms (min to max, 9 samples) | ns/case | default process wall median ms (min to max) |
| --- | ---: | ---: | ---: | ---: |
| switch | 4,000 | 5.241 (5.157 to 5.348) | 1,310 | 10.124 (10.010 to 10.410) |
| switch | 8,000 | 10.400 (10.284 to 10.514) | 1,300 | 18.348 (18.097 to 18.683) |
| switch | 16,000 | 19.309 (19.151 to 19.633) | 1,207 | 33.101 (32.776 to 34.057) |
| label table | 4,000 | 5.223 (5.164 to 5.390) | 1,306 | 11.148 (10.972 to 11.221) |
| label table | 8,000 | 10.405 (10.220 to 10.601) | 1,301 | 20.171 (20.079 to 20.491) |
| label table | 16,000 | 19.239 (18.902 to 19.472) | 1,202 | 36.775 (36.433 to 37.029) |

Growth ratios of the medians (`ratios.txt`):

| shape | `tier0` 4k→8k | `tier0` 8k→16k | wall 4k→8k | wall 8k→16k |
| --- | ---: | ---: | ---: | ---: |
| switch | 1.98x | 1.86x | 1.81x | 1.80x |
| label table | 1.99x | 1.85x | 1.81x | 1.82x |

Every sample lies within 3.2% of its point's median (`tier0`) and 2.9% (wall), far smaller than
the gap between 2x (linear) and 4x (the old degree-squared growth). The
16,000-case points are slightly cheaper per case than the smaller ones;
this record does not explain that.

## Identities

- Compiler: buster `b7a95eedbe16fbd8434654f192f8f7aab76c56e5` (`compiler-revision.txt`,
  clean checkout: `compiler-status.txt` is empty), built Release with
  `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0` (`logs/build.log`, `CMakeCache.txt`,
  `compile_commands.json`).
- Packet: buster-performance `a35c9fd0cc7bfe9cbc1f4e48771782034421b562`
  (`evidence-revision.txt`): its `generate.c` and recipe, unchanged.
- Hashes of the compiler, generator, inputs and drivers: `identities.sha256`, checked
  again after the campaign (`identities-after.log`: all OK). Qualified objects and
  driver executables: `qualified.sha256` (`qualified-after.log`: all OK). Every
  measured object (`measured-objects.sha256`) matched its qualified object with `cmp`.
- Host: `host.txt` (kernel, `lscpu`, clang, CMake, Ninja, CPU 2's governor
  `performance` and EPP `performance`, THP `always`). CPU 10 was offline on the
  host during the run; the campaign ran only on CPU 2.

## What ran

1. `scripts/run.sh`: the packet's bash snippets verbatim, except for this run's directory
   (`~/buster-fast-bench/1356-claude`), the packet's location, the evidence revision
   written as a constant, and `EXCLUSIVE_OWNER`/`EXCLUSIVE_LINK`. It built the compiler
   and the generator, generated the inputs and drivers, and qualified the 4,000-case
   switch and the 8,000-case switch's compile and link.
2. **Deviation:** each locked command was waiting several minutes for the lock behind
   other sessions (6 holds in 30 minutes, about 78 to go), so `run.sh` was stopped while
   waiting to run `switch-8000`'s driver (`RESUMED.txt`; it was killed top-down, and
   no process of it remained). `scripts/resume.sh` then ran the same commands, with the
   same `locked()` and `check_report()`, grouped into one lock hold for the remaining
   qualification and one hold for each round of six `measure-compile` pairs. The inner
   `locked()` calls run under the outer hold (`BUSTER_9700X_HELD`) and still record their
   own load and process snapshots before and after each command. Each round's hold
   lasted a few seconds. Point order, rotation, the warm-up round and the nine
   measured rounds are the packet's.
3. `scripts/analyze.sh`: `summary-samples.tsv` (one line per measured pair: shape, N,
   round, `tier0` ms of the staged member, default member's wall ms), `summary.tsv`
   and `ratios.txt`. The warm-up round (`raw/warmup/`) is excluded.

All six points passed qualification: strict Tier 1 with `--verify`, one function
compiled, zero unsupported, failures and fallbacks (`logs/verify-*.log`), and each
exhaustive driver exited 0 (`logs/run-*.log`). Every timed pair reported
`measure-compile: 0 failures` and passed the same report check.

## Host load

`exclusive.sh` printed no `other processes busy as the lock is taken` lines for
any hold: no process that had used half a CPU or more over its life was running.
The per-command load average and top-process snapshots are in each log.

## Editing of the logs

`exclusive.sh`'s lock-wait messages name the session holding the lock and quote
its command and link. They were replaced by a one-line marker with
`scripts/strip_lock_waits.py` before publishing (18 files: some qualification
logs and the outer `logs/hold-*.log` files, which held only that message). No
other line was changed. Paths in `samples.tsv` and the logs are the host's:
`/home/david/buster-fast-bench/1356-claude/` is this directory. Object files,
executables, inputs and drivers are not stored; the generator reproduces the
inputs and drivers, and their hashes are recorded.

## Limitations

The packet's own limits apply: one compiler snapshot and one executable layout,
a fixed default-then-stages order within each pair, and report overhead in both
members. This is not a before/after measurement of #1588. The process wall time
includes stages other than `tier0`; it too grows by less than 2x per doubling here.
