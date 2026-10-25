# #335 temporary target-host campaign

This original command recipe and original C accounting probe qualify the opt-in
fused PP/parser candidate in Buster. They include compiler source from the
triggering checkout without modifications; `source.sha256` and `provenance.txt`
record its exact identity. The workflow must fetch this directory from an exact
reviewed buster-performance commit. The recipe is temporary qualification, not a
new production dependency or a default benchmark on every PR.

The approved Ryzen 7 9700X runner's job hook already owns the shared host lock.
This recipe is CI-only: interactive reproduction must take the shared lock
separately for each build, test, `time-runs` and accounting process, as the
original campaign recipe does. Never put a series of interactive runs under one
outer lock; do not nest `exclusive.sh` from CI. Its whole-driver workload is
bounded to about six minutes, plus build and correctness checks, within a
separate ten-minute job. CPU 2 is mandatory. All 12 whole-driver cells contain
five independent `time-runs` processes, each with one warm-up and 21 rotated
off/on fresh child processes. The 200 ms scalar preparation is outside timing.
Both statuses must match their first warm-ups; raw status lines remain visible.
The ordinary required compiler job is unaffected.

`qualify.c` adds accounting overhead. Its phase clocks are diagnostic and its
RSS includes the probe itself; use uninstrumented `time-runs` for retention.
Logical arena high-water is max(sum(Arena.length)), including alignment and
fully pushed column capacity, excluding unpushed reservations. It is neither
touched nor resident memory. Mapped high-water sums page-rounded compiler-source
mappings, excluding loader/libraries/stack. Traffic fields count selected
nominal payload bytes and legal conversion block occupancy; they omit scalar
exceptional rescans, lookup tables, cache transfers and DRAM traffic. Parser
payload is 10 bytes per logical token, plus explicit padding and pragma arrays.

The original `headers.c` body and harness are first-party material under
Apache-2.0 WITH LLVM-exception. SQLite 3.53.2 and Zig 0.14.1's patched musl 1.2.5
are external runtime inputs in the frozen corpus; no third-party source is
vendored here. Corpus provenance and manifest identities are copied to outputs.
The probe includes the pinned checkout's existing separately licensed source
and retains its original headers/notices in that checkout.
