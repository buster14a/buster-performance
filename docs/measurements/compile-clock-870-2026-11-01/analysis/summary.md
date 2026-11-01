# Compile-clock control (#870)

## Host and accounting configuration

| key | value |
| --- | --- |
| `cmdline` | `initrd=\initramfs-linux-lts.img rd.luks.name=ace4fbb3-2e2b-4a2b-81e8-2d4375f44b9d=cryptroot rd.luks.options=ace4fbb3-2e2b-4a2b-81e8-2d4375f44b9d=timeout=0 root=/dev/mapper/cryptroot rootflags=subvol=@,x-systemd.device-timeout=0 rw console=tty0 console=ttyS0,115200n8` |
| `config-gz` | `present` |
| `cpu-affinity` | `2` |
| `cpu-isolated` | `empty` |
| `cpu-nohz-full` | `(null)` |
| `cpu-online` | `0-9,11-15` |
| `cpufreq-cur-khz` | `5542623` |
| `cpufreq-governor` | `performance` |
| `cpus-online-sysconf` | `15` |
| `fault-arena` | `available:131072-pages` |
| `hostname` | `benchpress` |
| `kernel` | `Linux 6.18.50-2-lts #1 SMP PREEMPT_DYNAMIC Tue, 08 Sep 2026 10:48:06 +0000 x86_64` |
| `perf-event-paranoid` | `-1` |
| `pmu-kernel-cycles` | `available` |
| `pmu-request` | `enabled` |
| `pmu-user-cycles` | `available` |
| `task-clock-kernel` | `available` |
| `task-clock-user` | `available` |

Control processes: 3; samples: 2880.

## CPU-only attribution versus hardware kernel cycles

| target µs | samples | elapsed ms | getrusage system ms | PMU kernel ms | abs error ms | getrusage system share | PMU kernel share | involuntary switches |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 250 | 144 | 0.235 | 0.000 | 0.001 | 0.001 | 0.0000 | 0.0023 | 0.0 |
| 500 | 144 | 0.469 | 0.000 | 0.001 | 0.001 | 0.0000 | 0.0012 | 0.0 |
| 1000 | 144 | 0.938 | 0.000 | 0.001 | 0.002 | 0.0000 | 0.0006 | 0.0 |
| 2000 | 144 | 1.876 | 0.000 | 0.002 | 0.004 | 0.0000 | 0.0008 | 0.0 |
| 5000 | 144 | 4.689 | 0.005 | 0.003 | 0.014 | 0.0009 | 0.0006 | 0.0 |
| 10000 | 144 | 9.376 | 0.000 | 0.004 | 0.005 | 0.0000 | 0.0005 | 0.0 |
| 20000 | 144 | 18.752 | 0.000 | 0.008 | 0.012 | 0.0000 | 0.0004 | 0.0 |
| 50000 | 144 | 46.874 | 0.045 | 0.018 | 0.028 | 0.0010 | 0.0004 | 0.0 |

The CPU-only phase has no intentional kernel work. Any attributed system time, and any gap between the
getrusage share and the hardware kernel-cycle share, is accounting leakage or quantization.

## Page-fault and syscall phases

| target µs | kind | samples | work units | elapsed ms | getrusage system ms | PMU kernel ms | abs error ms |
| ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 250 | fault | 72 | 1463 | 0.183 | 0.000 | 0.130 | 0.119 |
| 500 | fault | 72 | 2927 | 0.211 | 0.000 | 0.154 | 0.148 |
| 1000 | fault | 72 | 5855 | 0.284 | 0.000 | 0.218 | 0.201 |
| 2000 | fault | 72 | 11710 | 1.433 | 0.173 | 1.319 | 1.091 |
| 5000 | fault | 72 | 29275 | 4.566 | 3.433 | 4.328 | 0.998 |
| 10000 | fault | 72 | 58550 | 9.963 | 9.773 | 9.541 | 0.360 |
| 20000 | fault | 72 | 117100 | 20.397 | 19.891 | 19.554 | 0.552 |
| 50000 | fault | 72 | 131072 | 22.788 | 22.666 | 21.864 | 0.907 |
| 250 | syscall | 72 | 8088 | 0.250 | 0.000 | 0.194 | 0.192 |
| 500 | syscall | 72 | 16177 | 0.499 | 0.000 | 0.388 | 0.385 |
| 1000 | syscall | 72 | 32354 | 0.995 | 0.000 | 0.772 | 0.771 |
| 2000 | syscall | 72 | 64708 | 1.994 | 0.182 | 1.549 | 1.370 |
| 5000 | syscall | 72 | 161770 | 4.980 | 3.095 | 3.865 | 1.038 |
| 10000 | syscall | 72 | 323540 | 9.962 | 6.476 | 7.736 | 2.191 |
| 20000 | syscall | 72 | 647080 | 19.929 | 9.996 | 15.477 | 5.361 |
| 50000 | syscall | 72 | 1617700 | 49.805 | 29.910 | 38.679 | 8.832 |

These phases do have kernel work. Their error is the same comparison, not evidence that a phase is cheap.

## task-clock:k is not an independent kernel timer

| target µs | task-clock:k ms | PMU kernel ms | difference ms |
| ---: | ---: | ---: | ---: |
| 250 | 0.235 | 0.001 | 0.235 |
| 500 | 0.469 | 0.001 | 0.469 |
| 1000 | 0.938 | 0.001 | 0.937 |
| 2000 | 1.876 | 0.002 | 1.875 |
| 5000 | 4.689 | 0.003 | 4.686 |
| 10000 | 9.376 | 0.004 | 9.372 |
| 20000 | 18.752 | 0.008 | 18.744 |
| 50000 | 46.872 | 0.018 | 46.857 |

On the control's CPU-only phases, `task-clock:k` tracks the whole phase rather than its kernel cycles.
It is retained as a comparison and not used as the attribution oracle.

## Verdict

Per-process verdicts: low-confidence, low-confidence, low-confidence.

A `low-confidence` verdict means the getrusage deltas disagree with hardware user/kernel cycles beyond the
campaign's tolerance, not that no kernel work happened. `--time-stages` therefore reports the split as raw,
low-confidence values and reports it unavailable when getrusage itself fails.

## Repeated frozen SQLite compile

| run | parse elapsed ms | parse system ms | parse minor faults | total span ms | system status | accuracy |
| ---: | ---: | ---: | ---: | ---: | --- | --- |
| 1 | 7.539 | 6.825 | 677 | 134.947 | `available` | `low-confidence` |
| 2 | 7.516 | 5.616 | 677 | 135.432 | `available` | `low-confidence` |
| 3 | 7.180 | 3.341 | 677 | 134.637 | `available` | `low-confidence` |
| 4 | 7.318 | 3.657 | 677 | 134.047 | `available` | `low-confidence` |
| 5 | 7.511 | 7.391 | 677 | 134.312 | `available` | `low-confidence` |
| 6 | 7.293 | 2.423 | 677 | 134.162 | `available` | `low-confidence` |
| 7 | 7.262 | 3.329 | 677 | 134.020 | `available` | `low-confidence` |

Parse elapsed median 7.318 ms (range 7.180 to 7.539), parse system median 3.657 ms (range 2.423 to 7.391).

The elapsed range is the stable timing; the system range is the qualification the report labels low confidence.
## measure-compile

```text
stage system time: low-confidence getrusage(RUSAGE_SELF) deltas between resource marks, -1 when unavailable; do not subtract them from stage elapsed time or rank stages by them
--time-stages costs 0.747 ms (0.56%) of the default's median wall time
default against reference: 134.526 ms against 42.655 ms, 3.15 times, 91.871 ms apart
--time-stages' stages, medians of 11 runs: ms (range), share of the median span; low-confidence system ms, minor faults, approximate post-exec peak KiB added (-1 unavailable)
  parse                      7.301  (7.239 to 7.356)    5.5%     3.612      677     80436
  span                     133.854  (132.951 to 136.130)  the stages' medians add up to 133.659
  outside                    1.427  (1.382 to 1.570)  the process's wall time outside the span
ranked: check-input 44.0% lower 10.7% check-program 10.4% check-expressions 10.3% preprocess 7.3% parse 5.5% tier0 3.6% check-declarations 2.9% emit-setup 0.9% select 0.6% code-atoms 0.6% backend-setup 0.6% setup 0.4% branch-sizing 0.4% static-data 0.3% object-build 0.3% publish-data 0.3% encode 0.3% object-write 0.1% unwind 0.1% release 0.1% type-table 0.0% debug 0.0% lanes-start 0.0%
measure-compile: 0 failures
```

