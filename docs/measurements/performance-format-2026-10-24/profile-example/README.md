# Native Perfetto example

Every observation here is deliberately synthetic. This fixture demonstrates the
reused native format; it is not a performance result or a production importer.

`capture.pftrace` contains eight timestamped stack samples, two threads,
instrumentation, scheduling, a dispatch flow and memory/energy counters. A track
marks unknown sample coverage; it is an annotation, not a fabricated native
lost-record count. `arbitrary-custom.*` demonstrates an exact Arrow/JSONL table
linked to the same execution, including uint64 maximum, decimals and a null reason.

The manifest contains resource references and benchmark semantics. Stack/frame,
thread and clock representation remains native Perfetto. Arrow supplies table
types through its ordinary IPC schema. JSONL is an equivalent representation,
not additional rows.

Reproduce the trace with an ordinary C17 compiler, from this example directory:

```sh
cc -std=c17 -O2 -Wall -Wextra -Werror fixture.c -o fixture
./fixture regenerated.pftrace
cmp capture.pftrace regenerated.pftrace
```

Using the official **Perfetto v58.2** Trace Processor, reproduce the checks:

```sh
trace_processor_shell query -f verify.sql capture.pftrace
```

The expected output is `native-query-results.csv`; the package's native validation
report records eighteen checked results and the pinned tool identity/digest.
The selection `[2ms,7ms)` is relative to the 1,000,000,000 ns trace origin and
contains five samples. SQL uses the corresponding absolute timestamps.

This validates native parsing/query behavior. Real perf/Superluminal import
fidelity, source/assembly attribution, embedded viewer behavior, cross-view
synchronization and large-capture cost still need implementation acceptance.
