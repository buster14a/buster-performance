# Compile-clock attribution control: Buster #870

This record measures the limitation that [buster #870](https://github.com/buster14a/buster/issues/870) reports:
`--time-stages`' `getrusage(RUSAGE_SELF).ru_stime` deltas are not a precise per-stage kernel cost. It is a
qualification campaign, not a compiler speedup, and no performance gate consumes the split.

The control alternates CPU-only work, page faults and syscalls at swept phase lengths and start offsets, and compares
the `getrusage` deltas with hardware `cycles:u`/`cycles:k` attribution from `perf_event_open`. It also tests
`task-clock:k`, which the earlier instrumentation treated as a candidate independent kernel timer. The repeated frozen
SQLite compile is the same input as `docs/compile-time.md`. The reporting change itself is in the companion Buster PR
that closes #870.

## Frozen inputs

| Input | Identity |
| --- | --- |
| Buster source revision | `9c17a6a2155776e5367177e1775faaa4df52b4da` |
| Compiler executable | SHA-256 `72f5bd41aca1544a7c697a109196b924a56cb6be0c0a56b1bcdd342fa4a43272` |
| Frozen SQLite input | SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d` |
| Corpus manifest | SHA-256 `391e729af6587355050881752558e790299cfe638c7dc7803bd028a8535ebcbd` |
| Reference compiler | tcc 0.9.28rc 2026-01-17, SHA-256 `49e2d1afd09cdab6593ca127b056ccc35fc5f3a2d0e08dae67f604db2751c082` |
| Host | Ryzen 7 9700X (`benchpress`), CPU 2 affinity, 15 CPUs online (`0-9,11-15`) |
| Kernel | `6.18.50-2-lts` |
| perf | `7.2.9-1`, `perf_event_paranoid=-1` |
| CPU 2 | governor `performance`, observed 4.89 to 5.52 GHz during the runs |

The kernel was built with `CONFIG_VIRT_CPU_ACCOUNTING_GEN=y`, `CONFIG_IRQ_TIME_ACCOUNTING=y`,
`CONFIG_PARAVIRT_TIME_ACCOUNTING=y`, `CONFIG_NO_HZ_FULL=y` and `CONFIG_HZ=300`; `/sys/devices/system/cpu/isolated`
had no entries, and `/sys/devices/system/cpu/nohz_full` reported the kernel's literal `(null)`. The raw environment is
in [logs/environment.txt](logs/environment.txt). Every measured command took the shared 9700X lock for its own run;
lock-wait lines in a log precede the command and do not overlap its timing.

## Method

`scripts/clock_control.c` is a bounded C control. For each block it spins to a requested offset in a 10 ms grid, then
runs five phases in rotated order: CPU-only (dependent xorshift), page faults on freshly
`madvise(MADV_DONTNEED)`-ed anonymous pages, CPU-only again, `getpid` syscalls, and an empty phase. Phase lengths are
250, 500, 1000, 2000, 5000, 10000, 20000 and 50000 µs; offsets are 0 to 8750 µs in 1250 µs steps. Three processes,
each with three rounds, give 2,880 samples.

Every phase boundary reads `getrusage` (system time, minor faults, voluntary and involuntary switches),
`CLOCK_PROCESS_CPUTIME_ID`, the TSC and four perf events: hardware user cycles (`exclude_kernel=1`), hardware kernel
cycles (`exclude_user=1`), software `task-clock:u` and software `task-clock:k`. The hardware user and kernel counts are
converted to milliseconds with the phase's own total cycle rate. The empty phase measures the marks' own overhead
(0.000 to 0.001 ms). `scripts/run.sh` also runs one syscall phase under `perf stat` as an external identity check.

The summary compares `getrusage`'s system share and absolute milliseconds with the hardware kernel share and
milliseconds at every length. `low-confidence` means they disagree beyond the campaign's tolerance (at most 10% of
the target or 0.5 ms, plus a 2 percentage-point share bound); `unavailable` means the hardware counters could not be
read. A consistent host would only be evidence that the split is usable there and at those lengths.

## Results

### CPU-only phases

| target µs | samples | elapsed ms | getrusage system ms | PMU kernel ms | abs error ms | getrusage system share | PMU kernel share |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 250 | 144 | 0.235 | 0.000 | 0.001 | 0.001 | 0.0000 | 0.0023 |
| 500 | 144 | 0.469 | 0.000 | 0.001 | 0.001 | 0.0000 | 0.0012 |
| 1000 | 144 | 0.938 | 0.000 | 0.001 | 0.002 | 0.0000 | 0.0006 |
| 2000 | 144 | 1.876 | 0.000 | 0.002 | 0.004 | 0.0000 | 0.0008 |
| 5000 | 144 | 4.689 | 0.005 | 0.003 | 0.014 | 0.0009 | 0.0006 |
| 10000 | 144 | 9.376 | 0.000 | 0.004 | 0.005 | 0.0000 | 0.0005 |
| 20000 | 144 | 18.752 | 0.000 | 0.008 | 0.012 | 0.0000 | 0.0004 |
| 50000 | 144 | 46.874 | 0.045 | 0.018 | 0.028 | 0.0010 | 0.0004 |

Pure user work is not the main problem: the `getrusage` system time is 0.000 to 0.045 ms, and the hardware kernel
share is under a quarter of a percent. The median involuntary-switch count is zero at every length, so preemption
does not explain the mixed phases. This is the control that keeps a host-wide "getrusage is always wrong" claim from
being made.

### Page faults and syscalls

| target µs | kind | samples | work units | elapsed ms | getrusage system ms | PMU kernel ms | abs error ms |
| ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 250 | fault | 72 | 1,463 | 0.183 | 0.000 | 0.130 | 0.119 |
| 500 | fault | 72 | 2,927 | 0.211 | 0.000 | 0.154 | 0.148 |
| 1000 | fault | 72 | 5,855 | 0.284 | 0.000 | 0.218 | 0.201 |
| 2000 | fault | 72 | 11,710 | 1.433 | 0.173 | 1.319 | 1.091 |
| 5000 | fault | 72 | 29,275 | 4.566 | 3.433 | 4.328 | 0.998 |
| 10000 | fault | 72 | 58,550 | 9.963 | 9.773 | 9.541 | 0.360 |
| 20000 | fault | 72 | 117,100 | 20.397 | 19.891 | 19.554 | 0.552 |
| 50000 | fault | 72 | 131,072 | 22.788 | 22.666 | 21.864 | 0.907 |
| 250 | syscall | 72 | 8,088 | 0.250 | 0.000 | 0.194 | 0.192 |
| 500 | syscall | 72 | 16,177 | 0.499 | 0.000 | 0.388 | 0.385 |
| 1000 | syscall | 72 | 32,354 | 0.995 | 0.000 | 0.772 | 0.771 |
| 2000 | syscall | 72 | 64,708 | 1.994 | 0.182 | 1.549 | 1.370 |
| 5000 | syscall | 72 | 161,770 | 4.980 | 3.095 | 3.865 | 1.038 |
| 10000 | syscall | 72 | 323,540 | 9.962 | 6.476 | 7.736 | 2.191 |
| 20000 | syscall | 72 | 647,080 | 19.929 | 9.996 | 15.477 | 5.361 |
| 50000 | syscall | 72 | 1,617,700 | 49.805 | 29.910 | 38.679 | 8.832 |

Short page-fault phases have **zero** attributed system time while the hardware counts 0.13 to 0.22 ms of kernel
cycles; the time appears later as the phase grows. Syscall phases undercount even at 50 ms (29.9 ms against 38.7 ms).
This is the delayed, lumpy behavior that makes a short stage's system-ms unstable. The 50 ms page-fault row is capped
by the 512 MiB control arena (131,072 pages), which its `work units` column shows.

### `task-clock:k` is not a kernel timer

| target µs | `task-clock:k` ms | PMU kernel ms | difference ms |
| ---: | ---: | ---: | ---: |
| 250 | 0.235 | 0.001 | 0.235 |
| 500 | 0.469 | 0.001 | 0.469 |
| 1000 | 0.938 | 0.001 | 0.937 |
| 2000 | 1.876 | 0.002 | 1.875 |
| 5000 | 4.689 | 0.003 | 4.686 |
| 10000 | 9.376 | 0.004 | 9.372 |
| 20000 | 18.752 | 0.008 | 18.744 |
| 50000 | 46.872 | 0.018 | 46.857 |

`task-clock:k` tracks the whole CPU-only phase, not its kernel cycles. The external `perf stat` receipt in
[logs/perf-stat.txt](logs/perf-stat.txt) shows the same for a syscall phase: `task-clock` and `task-clock:k` both read
**33.41 ms**, while `cycles:k` is 75,457,698 and `cycles:u` is 100,354,203. A software clock with a privilege suffix is
not an independent kernel timer, so the control uses hardware kernel cycles as its oracle and retains `task-clock:k`
only as a rejected comparison.

### Repeated frozen SQLite compile

| run | parse elapsed ms | parse system ms | parse minor faults | total span ms | system status | accuracy |
| ---: | ---: | ---: | ---: | ---: | --- | --- |
| 1 | 7.539 | 6.825 | 677 | 134.947 | `available` | `low-confidence` |
| 2 | 7.516 | 5.616 | 677 | 135.432 | `available` | `low-confidence` |
| 3 | 7.180 | 3.341 | 677 | 134.637 | `available` | `low-confidence` |
| 4 | 7.318 | 3.657 | 677 | 134.047 | `available` | `low-confidence` |
| 5 | 7.511 | 7.391 | 677 | 134.312 | `available` | `low-confidence` |
| 6 | 7.293 | 2.423 | 677 | 134.162 | `available` | `low-confidence` |
| 7 | 7.262 | 3.329 | 677 | 134.020 | `available` | `low-confidence` |

Parse elapsed has a 1.05x max/min range (7.180 to 7.539 ms) while parse system time has a 3.05x range (2.423 to
7.391 ms) and every run has the same 677 minor faults. That is the original finding: stable elapsed time, unstable
attributed system time. The report identifies the status and low confidence in `time-process` rows, so the numbers
are retained as raw values rather than promoted to stage kernel costs.

### `measure-compile`

The 11-run harness on the same input reports:

```text
stage system time: low-confidence getrusage(RUSAGE_SELF) deltas between resource marks, -1 when unavailable; do not subtract them from stage elapsed time or rank stages by them
--time-stages costs 0.747 ms (0.56%) of the default's median wall time
default against reference: 134.526 ms against 42.655 ms, 3.15 times, 91.871 ms apart
  parse                      7.301  (7.239 to 7.356)    5.5%     3.612      677     80436
  span                     133.854  (132.951 to 136.130)  the stages' medians add up to 133.659
```

This is a reporting qualification, not a claim about compiler speed. The elapsed stage ranking and the frozen
input are unchanged.

## What the report now says

`--time-stages` keeps the raw `getrusage` numbers but makes their limits machine-readable:

- `time-process stage-system-source getrusage-rusage-self-ru-stime` and
  `stage-system-boundary resource-marks` identify the source and the boundaries.
- `stage-system-status available|unavailable` says whether the read succeeded. A failed read latches unavailable and
  writes `-1` for every stage's system and fault columns, instead of substituting a zero that would distort a later
  delta.
- `stage-system-accuracy low-confidence|unavailable` and `stage-system-reason resource-mark-getrusage-deltas` state
  how the values may be used.
- `stage-system-use do-not-rank-or-subtract-from-elapsed` keeps the previous policy explicit.
- The report reader accepts legacy numeric reports and wholly unavailable ones, and refuses a mixed report or an
  `available` status carrying `-1`. `measure-compile` reports `-1` for an unavailable column rather than sorting
  sentinels into a plausible median.

Elapsed stage time remains a TSC measurement and is usable when the split is unavailable. Minor faults share the
split's availability because both come from the same read.

## Limits

This is one host, one kernel and one synthetic control, run under the shared lock. The hardware counters are core
cycles converted with each phase's own cycle rate; they are an independent accounting oracle, not a second
implementation of `getrusage`. The control shows that a mixed workload's short stages cannot be ranked by the split;
it does not claim that every host, every length or every pure user phase is equally distorted. It also does not
replace the separate RSS (#865) or working-set (#628) investigations.

The raw SQLite logs may contain an `exclusive.sh: waiting` line from before the timed command; the wrapper prints it
before acquiring the lock and the command's timing starts after acquisition. The control's source identity is in
`scripts/clock_control.c`; `logs/` retains the exact TSVs used by [analysis/summary.md](analysis/summary.md).

## Reproduce

From this directory, with a compiler built from the Buster revision above and the frozen corpus:

```sh
./scripts/run.sh /path/to/buster/build/compiler /tmp/compile-clock-870 /path/to/corpus-391e729af658 3
```

`run.sh` compiles the C control with `clang -std=c17 -O2 -Wall -Wextra -Werror`, takes the host lock for each measured
command, and writes `logs/` and `analysis/`. `scripts/analyze.py` can regenerate the summary from an existing output
directory. The control also runs without the PMU (`--no-pmu`) and on any Linux host; the report then says
`unavailable` rather than inventing a split.

## Provenance

The control, runner and analyzer are original project code under Apache-2.0 WITH LLVM-exception. Linux perf's
`perf_event_open` interface and the kernel's `/proc` and sysfs accounting files were consulted for semantics; no Linux
implementation code is incorporated. The frozen SQLite corpus and tcc identities are the compile-time guide's. This
agent session did not fabricate human DCO certification.
