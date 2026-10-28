# Reject incomplete mixed perf profiles before analysis

This follow-up to [performance #50](https://github.com/buster14a/buster-performance/issues/50) reproduces the preserved mixed recording failure, identifies the bounded READ layout discrepancy, and adds an original C acceptance gate. A failing reader **exits 0** on both tested perf versions. Exit status alone therefore cannot qualify this recording.

No new profile was collected. No target host was accessed. The historical collector, recordings, evidence, and published results are unchanged. This is an analysis-tooling correction; it makes no compiler throughput claim and does not assign the recording defect to the kernel, recorder, or reader.

## Preserved inputs and reproduction

Both inputs are from the [frozen 92c025e7 release](https://github.com/buster14a/buster-performance/releases/tag/microarch-9700x-2026-10-27-92c025e7). The readable input is in `microarchitecture-9700x-2026-10-27-evidence.tar.zst` under `raw/9700x/combined-readable-9100.data`; the rejected input is in `microarchitecture-9700x-2026-10-27-exploratory.tar.zst` under `mixed/9700x/combined-lowrate-9000.data`. Resolve archive top-level prefixes using the retained manifests and [original restoration instructions](../microarchitecture-9700x-2026-10-27/README.md). Do not select a file by basename alone.

| Input | Bytes | SHA-256 |
|---|---:|---|
| Rejected `combined-lowrate-9000.data` | 37,835,916 | `ef599e214c7e2b828a9c183d2f9781696ea898c03232ed016997360123430fd5` |
| Readable `combined-readable-9100.data` | 43,010,748 | `b6569e0b9f2c8a287dc5863807f4cc3df217cc69a6a59b7234b2d70de6829096` |

Restore the compiler, target libc, and target kallsyms from that same evidence archive into a private symfs, following the [original method](../microarchitecture-9700x-2026-10-27/method/README.md#resolve-symbols-and-join-to-assembly). The compiler and libc hashes are retained in [raw/input-identities.txt](raw/input-identities.txt). Run the reader from the directory containing that symfs:

```sh
DEBUGINFOD_URLS= perf report --stdio --symfs symfs \
  --kallsyms /absolute/path/to/reproduction/9700x-kallsyms.txt \
  -i /absolute/path/to/combined-lowrate-9000.data --sort symbol,dso -n \
  > failing.stdout 2> failing.stderr
printf '%s\n' "$?" > failing.status
```

All local build, test, and perf invocations in this follow-up used the local allocator with `cores -n 2`, a task title, and the issue link. The reader host was `Linux minipc 7.3.0-5-cachyos`, x86-64; it is not the 9700X recording host. Exact retained commands and streams are under [raw/reader/](raw/reader/). The bad recording produces the same 85-byte stdout and 110-byte stderr on both readers:

```text
0x23f0238 [0x90]: processing failed for event of type: READ (8) [Bad address]
Error:
failed to process sample
```

Both direct child statuses are **0**. These statuses were captured inside the allocated shell, rather than inferred from the allocation wrapper. The readable control completes on both versions, with empty diagnostic streams and zero reported loss. Random perf closing tips can differ; uncompressed stream hashes preserve each observed output.

## Exact layout and version attribution

The file has little-endian `PERFILE2` layout, a 104-byte header, 160-byte attribute entries containing 144-byte attrs, and data starting at `0x6f8`. Its six attrs have `sample_id_all`. The core group has `sample_type=0x101849f`, `read_format=0x1f`; IBS has `sample_type=0x101848f`, `read_format=0x17`. Each attr has 15 IDs.

At offset `0x23f0238`, the header is READ type 8, misc 0, size `0x90`. The core grouped READ fields imply `0xa8` bytes including its sample-ID trailer:

| Relative offset | Bounded content |
|---|---|
| `+0x08` | PID/TID `3135975/3135975` |
| `+0x10` | Group count 4 |
| `+0x18`, `+0x20` | Enabled `416768179`, running `0` |
| `+0x28`, `+0x40`, `+0x58`, `+0x70` | Four `(value, ID, lost)` triples: value/lost 0; IDs `6124264`, `6124279`, `6124294`, `6124309` |
| `+0x88` | Final word `0x002fd9e8002fd9e8`, consistent with PID/TID `3135976/3135976` |
| `+0x90`, `+0x98`, `+0xa0` | Required TIME, CPU, IDENTIFIER slots lie beyond the declared record |

The next READ header starts at `0x23f02c8`, exactly the declared end. The record is 24 bytes shorter than this attr's layout. The final in-bounds word is not a registered event ID. The scanner rejects at this exact offset with `read_unknown_trailer_identifier`; it never reads into the following record to repair the trailer. [The bounded byte decode](raw/layout/failing-v2.txt) and [scanner rejection](raw/gate/failing/binary.tsv) retain the details. An exploratory full header walk counted 4,788 READ records and one such length mismatch; the accepting scanner stops at the first invalid record. Its preceding totals are partial evidence only.

| Reader | Executable SHA-256 | Build ID |
|---|---|---|
| Installed perf `7.2.11-1` | `99915acdaa90a558e27eb7d532d801f8eee2c91bb4fd2a39a17b8bef472d9387` | `0e06485ef378f136c768732d6b071e413deaa928` |
| Privately extracted cached Arch perf `7.2.9-1` | `a6da58ffc54b3c9bfe8d0d046ade1dbc70e8f5121932e35de916ad39162f7d4f` | `69f7a79dc2c6de1faad456ef2249f29f53c1fc19` |

The historical recorder log names perf `7.2.9-1`, but records no executable hash or Build ID. The cached package is a version-matched candidate, **not proof of the original recorder bytes**. Both tested readers reproduce the same failure, so it is not unique to 7.2.11.

Source inspection at upstream v7.2.9 commit `5fce161649b4d779d1b76d9fcd52dc77779774b8` and v7.2.11 commit `a2de78ee6ed8bf8cd99d177c74865a6e8c3cb6ea` is consistent with the observed behavior: non-sample IDENTIFIER selection uses the final word, missing event lookup returns `-EFAULT`, session processing prints the diagnostic, and the report command's outer return path resets the status to 0. See [evsel](https://github.com/gregkh/linux/blob/a2de78ee6ed8bf8cd99d177c74865a6e8c3cb6ea/tools/perf/util/evsel.c#L349), [evlist](https://github.com/gregkh/linux/blob/a2de78ee6ed8bf8cd99d177c74865a6e8c3cb6ea/tools/perf/util/evlist.c#L1640), [session](https://github.com/gregkh/linux/blob/a2de78ee6ed8bf8cd99d177c74865a6e8c3cb6ea/tools/perf/util/session.c#L2757), and [report](https://github.com/gregkh/linux/blob/a2de78ee6ed8bf8cd99d177c74865a6e8c3cb6ea/tools/perf/builtin-report.c#L1779). The four inspected files are byte-identical between these tags; [raw/reader/identities.json](raw/reader/identities.json) records their hashes and package identities. Exact Arch binary-to-source attestation is unavailable. `[Bad address]` is errno text, not proof of a kernel address fault. The malformed write's originating component remains unresolved.

## Acceptance contract

[method/profile_gate.c](method/profile_gate.c) uses [method/perf_data.c](method/perf_data.c) for independent binary validation before invoking perf. It snapshots at most 1 GiB of a stable regular input into a new mode-0700 output directory; it refuses existing evidence directories. It retains exact argv, stdout, stderr, binary receipts, child statuses, and an atomic `acceptance.json`. Original input bytes are never modified. Future analyses invoke this gate explicitly; archived collectors and analyses are not rewired.

Acceptance requires all of the following:

- Supported little-endian, uncompressed file header, bounded sections/records, attrs/IDs, exact supported SAMPLE/READ layouts, complete data section consumption, and nonempty coverage for every attr.
- No LOST/LOST_SAMPLES records, nonzero lost counter fields, or THROTTLE/UNTHROTTLE records.
- Successful completed readers, with both output pipes closed, bounded streams, and preserved child status. Late descendant diagnostics are included; inherited writers that stay open time out. Nonzero status, signals, timeout, stream/file errors, or unexpected diagnostics reject (the exact validated ordering summary is expected).
- An attr-name list of exactly the binary attr count; a full `report --no-group` with one unique named section per attr, nonempty symbol/DSO fields, and each section's exact integer histogram population equal to independent binary decoding.
- A second `script -F event` walk whose per-event populations match the same binary counts, plus `script -d` reporting exactly `Misordered timestamps: 0`. Header-only and partially decoded output reject even when the reader exits 0.

Default per-reader timeout is 30 seconds (configurable 1–600); each retained stream is capped at 64 MiB. Timeouts are checked between bounded drain operations, not a real-time scheduling guarantee. The parent is the sole writer of retained streams. The tool is a deliberately narrow Linux acceptance gate, not a general replacement for perf. Unsupported byte order, compression, sample layouts, optional identifier semantics, record types, metadata forms, oversized outputs, or changed reader text syntax reject. Perf 7.2.9-1 and 7.2.11-1 are verified; other versions must earn their own controls. The reader executable and private output tree are trusted local inputs, not a hostile-code security boundary.

Scheduling duty is separate from event coverage. Known running/enabled tuples with running below enabled reject. Missing timing fields or zero/zero tuples produce `scheduling_duty: unavailable`; they never become 100%. `--require-duty` rejects unavailable duty. `full_observed` means all observed usable tuples were equal, not proof of unsampled execution or complete hardware scheduling. The scanner's tuple counters describe cumulative snapshots that may overlap; they must not be summed as disjoint intervals. Hardware event alias/counter semantic validation is outside this gate and remains [performance #49](https://github.com/buster14a/buster-performance/issues/49).

## Verified format without `-s`

The readable control uses this historical command shape, retained here for future separately authorized collection:

```sh
perf record -q -o combined.data \
  -e '{cycles:u,instructions:u,branches:u,branch-misses:u}:S' -c 4000003 \
  -m 64M \
  -e 'ibs_op/cnt_ctl=1,period=400003/' \
  -e 'ibs_fetch/period=1000003/' \
  -d -W -R --sample-cpu \
  -- ./microarch bench compile 8 64 1 0 0 ./compiler-native
```

Omitting `-s` is a verified readable workaround for this frozen recording shape, not a general guarantee or an established causal fix. Its core `read_format=0x1c` (ID, GROUP, LOST) and IBS `read_format=0x14` (ID, LOST) omit enabled/running times. The gate therefore accepts its profile/event coverage with duty **unavailable**, and rejects it under `--require-duty`.

The final gate reaches data end `0x2900300`, decodes 299,303 physical records, 290,863 physical SAMPLE records and 368,365 expanded events. Counts are:

| Attr | Direct samples | Decoded/group values |
|---|---:|---:|
| cycles | 25,834 | 25,834 |
| instructions | 0 | 25,834 |
| branches | 0 | 25,834 |
| branch misses | 0 | 25,834 |
| IBS operations | 235,008 | 235,008 |
| IBS fetch | 30,021 | 30,021 |

Its binary storage has nine timestamp regressions; raw file order is not perf's ordered event stream. Both perf readers' ordered debug passes report zero misordered timestamps. Do not equate these two checks or reject a valid capture merely because buffers reached the file out of timestamp order.

## Build, test, and run

A GCC/Clang-compatible C11 compiler with 128-bit integer support, Linux libc interfaces, and perf are required; no implementation code or dependency was imported. From this folder, choose an external scratch build directory and compile:

```sh
cc -std=c11 -O2 -g -Wall -Wextra -Werror method/perf_data.c method/profile_gate.c -o /scratch/profile_gate
cc -std=c11 -O2 -g -Wall -Wextra -Werror method/perf_data.c method/perf_data_test.c -o /scratch/perf_data_test
cc -std=c11 -O2 -g -Wall -Wextra -Werror method/profile_gate_test.c -o /scratch/profile_gate_test
cd /scratch
./perf_data_test
./profile_gate_test /scratch/profile_gate /scratch/perf_data_test
./profile_gate --data /absolute/capture.data --output-dir new-evidence \
  --symfs /absolute/symfs --kallsyms /absolute/target-kallsyms.txt
```

Use the local allocator around each build/test/reader command on the shared workstation. `--perf /absolute/other/perf` selects another reader; `--require-duty` adds scheduling qualification. Exit 0 means accepted, 1 rejected, 2 invalid invocation or preexisting output directory. A missing/incomplete receipt never counts as acceptance.

Optimized scanner tests pass **58/58** and end-to-end gate checks pass **185/185**. The same 58 scanner tests and 185 gate checks pass with AddressSanitizer and UndefinedBehaviorSanitizer on the tools under test (`-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer`, leak/error abort enabled). Original C fixture emitters supply clean, partial-duty, zero-duty, and two-attr unequal-population cases. Tests include truncation, malformed attrs/IDs/layouts/records, missing event coverage, loss, duty, success-exit error/header-only/partial reports, swapped/duplicate sections, wrong populations/names, reader failure/signal/timeout/output limit, delayed descendant errors, held-open descendant pipes, ordering failures, exclusive output preservation, closed standard descriptors, UTF-8/quoted argv, and invalid/nonregular/oversized inputs.

Final real controls accept the readable recording on both perf versions, reject the bad recording at its exact binary offset before external readers, and reject the readable recording when duty is required. [raw/gate/](raw/gate/) retains the receipts and compressed exact reader streams; [raw/tests/](raw/tests/) retains validation logs. Independent static CLI review found and corrected the section-population and descendant-output gaps before this freeze. The review was bounded and adds no unsupported root-cause claim.

[RAW-SHA256SUMS](RAW-SHA256SUMS) identifies the committed evidence. [raw/source-and-tool-identities.txt](raw/source-and-tool-identities.txt) records source/tool hashes and local build identity. Historical paths are untouched; all additions belong to this issue-specific directory. The code and original reports use the repository's Apache-2.0 WITH LLVM-exception terms. Linux ABI documentation was consulted as a format specification, including [perf_event.h](https://github.com/torvalds/linux/blob/v7.2/include/uapi/linux/perf_event.h) and [the perf.data format](https://github.com/torvalds/linux/blob/v6.12/tools/perf/Documentation/perf.data-file-format.txt). External perf executables are GPL-2.0-only; no perf binary or implementation source is incorporated here.
