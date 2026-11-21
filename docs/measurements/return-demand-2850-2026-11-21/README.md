# Demand-driven return facts in the ordinary SQLite compiler

On the Ryzen 7 9700X, demand-driven evaluation cut the paired median SQLite compile time by 1.971 ms and saved 12.71 total cycles per preprocessed token compared with the pristine compiler. All seven independent wall pairs and all seven cycle pairs favored demand evaluation. The same-executable comparison saved 2.085 ms and 15.84 cycles per token. Dense-oracle verification found that flow alone resolved all 1,708 eligible SQLite bodies, leaving zero requests to the expression facts table. The [full local checker run](correctness/checker-shards.txt) passed 845,265 checks in verification mode.

All three modes compiled the frozen SQLite amalgamation through the ordinary `-c` driver. The baseline was unmodified Buster `4dd0f0b163d258dd7778cbb14676a7ac4bf3510a` (Release SHA-256 `3403a79fd83868e792e53cc44832c411371cfc82f4e8bc1ddae5a49b6e3437a8`). The other two modes used one executable built from `a7c300f3ae627ffed2dee744835ce03886a72892`, which applies the [diagnostic patch](diagnostic.patch) with SHA-256 `68507b3e0d54c8f0c6d49dfeb5ffa3f2db74e58824b0506654082ba3582f8970` to that baseline. Its executable SHA-256 was `e4ff9d223f39f2e8415d848f72f03ee03e69137681b2839e7c9f34d9eeb58abe`. The parent and off modes left `BUSTER_RETURN_DEMAND` unset. The on mode set it to 1. All timed commands left `BUSTER_RETURN_REPORT` unset.

| Mode | Total cycles/token | User cycles/token | Kernel cycles/token | Total instructions | User instructions | Wall ms | Decimal MB/s |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| parent | 929.3597 | 820.0996 | 108.7799 | 1,378,631,776.5 | 1,345,421,656.5 | 120.9150 | 78.626 |
| off | 931.4361 | 822.5853 | 108.5370 | 1,379,890,255.0 | 1,346,678,452.5 | 120.8835 | 78.646 |
| on | 915.9610 | 807.1990 | 109.1706 | 1,357,720,240.5 | 1,324,558,435.0 | 118.8405 | 79.998 |

| Paired difference | Total cycles/token, median [min, max] | Total instructions, median | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: | ---: |
| off minus parent | +0.7173 [−1.3225, +6.9015] | +1,264,646.5 | +1,256,794.0 | −0.0295 [−0.4070, +0.7365] |
| on minus off | −15.8405 [−19.1510, −10.1665] | −22,128,587.5 | −22,120,032.5 | −2.0845 [−2.3920, −1.1580] |
| on minus parent | −12.7098 [−18.8655, −10.1059] | −20,936,706.0 | −20,863,235.0 | −1.9710 [−2.1930, −1.5650] |

Each round averaged the two symmetric slots for each mode before taking the paired difference. The PMU and elapsed-time series ran separately. Each wall observation followed one warm-up. The denominator was 716,136 preprocessed tokens and the input was 9,507,037 bytes. The actual CPU 2 and host lock protocol, source and compiler toolchain match the [paired driver method](../window-compile-2850-2026-11-21/paired-driver/README.md). The [order](order.tsv) records the three-mode rotation used here.

The 42 PMU observations ran all events for 100% of enabled time. The 42 timed wall observations had zero major faults. The seven separate qualification compiles comprised three stage controls, three `-Wall -Wextra` controls and one direct `verify` control. All 91 outputs were 2,061,192 bytes with the same SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. The default produced no diagnostics and all warning controls produced identical stdout/stderr (3,701 bytes on stderr).

| Mode | PMU page faults, min–max | Wall minor faults, min–max |
| --- | ---: | ---: |
| parent | 5,659–5,664 | 5,768–5,771 |
| off | 5,660–5,663 | 5,768–5,772 |
| on | 5,656–5,660 | 5,764–5,768 |

The separate [verification report](return-demand.txt) recorded 323,623 graph nodes and 2,674 bodies. Of the 1,708 eligible bodies, 1,631 were sealed and 77 were resolved through the coarse control check. The run requested zero exact facts. The verify mode independently computed the dense reference and compared each body’s return warning and flow information. The report counted 43,001 eligible control entries.

The [complete per-sample PMU and wall values](samples.tsv), [paired differences](paired.tsv), [raw reports](reports.tar.xz), [object receipts](objects.tsv), [warning receipts](diagnostics.tsv), [invocations](return-demand-one.sh) and [portable local correctness campaign](correctness/README.md) accompany this measurement.
