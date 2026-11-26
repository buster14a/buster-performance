# Whole-process kernel cycles for PR 3632

A separate Benchpress replay used `perf stat` to collect cycles in userspace and kernel mode across 41 alternating compilations per input and mode. It used the same source revisions, compiler configuration, inputs and CPU as the [wall-time comparison](../README.md), in separate host holds. Every pair emitted byte-identical objects.

| Workload | Median kernel cycles, base → head | Median minor faults, base → head |
| --- | ---: | ---: |
| Tiny C input, default | 702,366 → 709,229 | 158 → 154 |
| Tiny C input, `--no-direct` | 1,502,040 → 1,652,034 | 235 → 254 |
| SQLite, default | 8,699,699 → 8,676,420 | 91 → 87 |
| SQLite, `--no-direct` | 75,871,519 → 75,782,210 | 4,717 → 4,715 |

Kernel cycles improved by less than 0.3% in both SQLite cases. They rose 1.0% for tiny default input and 10.0% for tiny `--no-direct`. These counters use the direct perf invocation, which counts a different process interval from the compile harness. File-backed page collapse requires separate mapping evidence.

Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
