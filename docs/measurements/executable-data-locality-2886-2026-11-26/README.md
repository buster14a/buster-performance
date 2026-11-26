# Compile startup data locality: writable pages and sealed table ranges

[buster#2886](https://github.com/buster14a/buster/issues/2886),
[PR #3632](https://github.com/buster14a/buster/pull/3632), following the sealing
work in [#3323](https://github.com/buster14a/buster/pull/3323).

The candidate packs small startup globals into one NOBITS page, moves the
driver's lane controls ahead of its large arena array, and places the direct
path's, frontend's and checker's relocated read-only tables first, in 64 KiB
aligned input groups. Baked table ordering, segment sealing and the existing
64-page collapse threshold are unchanged.

**Measured here:** two fewer exclusive BSS pages in every accepted workload;
two to three fewer present BSS pages; and the tiny/default compile's same four
read-only fault-around windows in one aligned 2 MiB range instead of three.
The read-only ordering adds no executable file size. All compared object
outputs are identical.

These are Linux cloud-container page-layout observations, not 9700X timing
acceptance. No 9700X/benchpress work was run or queued. This kernel rejects
read-only file `MADV_COLLAPSE`, so actual file-backed huge mappings and their
whole-process kernel-cycle benefit remain unmeasured here.

## Revisions and builds

| Build | Source revision | Source tree | Hosted workflow |
| --- | --- | --- | --- |
| Base | `8e4d32879e17b7d9548cad54257a2f8461328366` | `8bf0a22e6067a7698ca6257d3e6cbe40f49b108a` | [45779319802](https://github.com/buster14a/buster/actions/runs/45779319802) |
| Writable-state change alone | `a23b7c60035e579db2c581cc62cb4457544b9c52` | `250c611bfaa7bd4d7adfc0d0be892a27cff8d2da` | [45787875126](https://github.com/buster14a/buster/actions/runs/45787875126) |
| Final | `170b82def21a488f903a48ab6484a30b4030022e` | `fbe10e9c09f76debe273782e000a3ac527ded466` | [45790224011](https://github.com/buster14a/buster/actions/runs/45790224011) |

The PR artifacts record GitHub merge revisions `2cd097a96eca0e6ac85e05ddefbc74a0f7f867f3`
and `484a2001d659a052797199180a363ed03172973c`; their trees exactly match the
corresponding source revisions above. All three products use vector/O3 Release,
Clang 23.1.4, identical configuration, compile flags and library identities, and
toolchain hash `eda0bc02300979a219273d969c9830eb0090c72d1fa357b24bc308ade5050259`.
Artifact IDs are `15097652285`, `15102525784`, and `15102094080`, respectively.
The complete artifact identities and file hashes are preserved in the raw archive.

The final compiler SHA-256 is
`8bf6f8a58afb73f4ad13e9829375a5baf8c596d65b3a01b9946498575f58fc92`.
The measurement host reports Intel Xeon Platinum 8370C, Linux 6.18.57, and
4,096-byte base pages. Complete local compiler builds could not fit the shared
workspace's memory limit: serial Release and Release-in-parts exited 137 in
the checker. Their logs are retained; the measured products are the standard
hosted builds, with no locally modified executable bytes.

## Writable state

The final `.bss.buster_start` is **1,409 bytes**, NOBITS, aligned at
`0x1281c000`, and inside `__bss_start.._end`. Each marked object starts on a
cache line; the linker rejects a group exceeding 4 KiB. The driver's
`CheckProgramLanes` instance starts at `0x7485000`, with its controls before
the arena array. Existing base-page advice covers both BSS output sections.

The tables count the union of ordinary `.bss` and `.bss.buster_start`, without
double-counting pages. A present nonexclusive anonymous page may be the shared
zero page; present-page savings must not all be described as private committed
memory savings.

| Workload | Mode | Present pages, base → final | Exclusive pages, base → final |
| --- | --- | ---: | ---: |
| Tiny and feedback regression inputs | Default | 10 → 7 | 9 → 7 |
| Patterns regression input | Default / `--no-direct` | 17 → 14 | 16 → 14 |
| SQLite | Default | 10 → 7 | 9 → 7 |
| SQLite | `--no-direct` | 17 → 15 | 17 → 15 |
| musl `vfprintf` | Default / `--no-direct` | 17 → 14 | 16 → 14 |
| musl `strtol` and `lite_malloc` | Default | 10 → 7 | 9 → 7 |
| musl `strtol` and `lite_malloc` | `--no-direct` | 17 → 14 | 16 → 14 |

The other nonempty small-input legacy cases also change from 17/16 present/
exclusive pages to 14/14. Empty-input captures have a one-page variation from
the forced exit helper's stack tail, which shares the address space and can
first touch that page after the parent's snapshot. Compare conservative
maxima: 10/9 → 7/7 for default and 17/16 → 14/14 for legacy. Do not claim a
fourth page saved from that scheduling variation.

SQLite's legacy case retains a page containing `check_driver_executable.named`
and neighboring checker globals that smaller cases leave absent. Its lane
record still drops from three present pages to two; this is not an extra
lane-array page. The raw records identify page overlap, not which particular
variable caused an access.

## Sealed read-only data

For tiny/default, each listed 64 KiB window contains 16 present 4 KiB pages.
The exact sets are identical in all three repetitions:

| Build | 64 KiB window starts | Present pages by aligned 2 MiB range |
| --- | --- | --- |
| Base | `0x1790000`, `0x17b0000`, `0x1ac0000`, `0x20d0000` | `0x1600000`: 32; `0x1a00000`: 16; `0x2000000`: 16 |
| Final | `0x1670000`, `0x16d0000`, `0x16f0000`, `0x17c0000` | `0x1600000`: 64 |

The same four windows and 64 pages now meet the exit helper's existing
64-page threshold within one range. This is a placement result and a
threshold calculation, not an observation of a successfully collapsed mapping.
The controlled small corpus preserves every baked/relro page count and 64 KiB
window count; it improves relro range counts for patterns/default from 4 to 2
and patterns/legacy from 3 to 2. The other small legacy cases retain two ranges.

Stable extended cases show the same direction in the sealed union (baked and
relocated data, with a shared boundary page counted once):

| Workload | Present sealed pages, unchanged | Aligned 2 MiB ranges, base → final |
| --- | ---: | ---: |
| SQLite, default | 64 | 3 → 1 |
| SQLite, `--no-direct` | 560 | 6 → 5 |
| musl `vfprintf`, default | 560 | 7 → 5 |
| musl `strtol`, default | 64 | 3 → 1 |
| musl `strtol`, `--no-direct` | 432 | 5 → 5 |

Later baseline musl snapshots show substantial file-backed residency variation,
including a `lite_malloc` capture with no sealed pages resident and 149 major
faults. The cause is not established. Those rows are retained in the extended
report but cannot support a causal claim of hundreds of saved faults, reads,
or required pages. Counts of present pages alone never prove huge mappings.

The real final ELF's relocated-data section grows from `0xc539e8` to
`0xc75ee8` bytes: **140,544 bytes of alignment padding** fit inside the existing
gap before code. Both the writable-only and final executables are exactly
**78,318,104 bytes**; code still starts at address `0x2600000`, file offset
`0x2000000`. Baked data remains at `0x1000000`, size `0x664300`, with 2 MiB
alignment. The sealed program segment remains read-only; writable BSS remains
outside it.

## Correctness and kernel capability

The final hosted integration qualification passes. The writable-only and final
artifacts pass `test-baked-tables`; the writable-only artifact also passes
`test-lanes`, including all 187 arena checks and the new placement/advice checks.
The final hosted suite exercises the changed compiler. C linker fixtures verify
both ordinary and split-native input selection, alignment, payload preservation,
fallbacks, exclusion of external relocated data, and unchanged baked placement.

There are **96 accepted primary baseline/final compilation/census runs**:
48 small-corpus runs and 48 SQLite/musl runs. Eight small-input output pairs
were compared byte for byte. All 24 corresponding extended-corpus object hashes
match, and each of its eight input/mode hashes repeats across all three runs.

A separate C probe verifies that `PAGEMAP_SCAN` works. With process THP enabled,
an anonymous aligned mapping successfully collapses from 64 present 4 KiB pages
to one 2 MiB huge mapping covering 512 base-page positions. Fresh read-only
files, read/execute mappings, and an actually
executed ELF's aligned read-only data all reject `MADV_COLLAPSE` with `EINVAL`
and retain zero huge pages. Actual production file collapse, whole-process
CPU-2 kernel cycles, and the full musl campaign on the 9700X remain outside
this record's demonstrated results.

## Method, reproduction and files

The original issue's ptrace-at-`exit_group` capture is unavailable in this
sandbox. `datapages --pause` uses Buster's existing test hook after compilation
and before libc exit handlers. It verifies the parent's final sleep, stops it,
reads `/proc/PID/pagemap`, resumes it, and reaps all descendants. No executable
bytes change. This instrumentation forces the exit helper and a two-second
pause, so these runs are not timing measurements.

The controlled campaigns also use `--base-pages`, which sets and verifies
`PR_SET_THP_DISABLE=1` before exec, plus `BUSTER_HUGE_PAGES=0` and
`BUSTER_EXECUTABLE_HUGE_PAGES=0`. Each input/mode gets a new ordinary byte-copy
inode, read-warmed once and reused for its three processes. Both revisions
receive identical source paths, flags and headers. These controls clarify the
comparison but do not remove every source of file-residency variation in the
shared environment.

- [Small corpus report](small-corpus.md): complete tables, child-fault diagnostics,
  helper-stack caveat, reproduction commands and source hashes.
- [SQLite/musl report](corpus-census-report.md): complete data, excluded anomalies,
  input/flag/license provenance and reproduction commands.
- `scripts/`: the exact C capture tool, runners and reducer, plus original empty
  and tiny inputs. Arrange them under `ROOT/evidence` as the reports describe.
- `results/`: readable summaries, exact address groups and object hashes.
- `raw-2886.tar.xz`: raw captures, command receipts, artifact provenance, original
  C fixtures, build/test logs and exploratory writable-only evidence. Compiled
  executables and object payloads are excluded.

The archive is 305,960 bytes, SHA-256
`927307767949cc047dc5d1ca4ef6f91bb64080ab2319c260a7bd6ff51ffe0396`.
It contains 420 regular files from 417 original inputs, including 144 raw TSV
captures. The original `.tsv.gz` streams are stored losslessly expanded as
`.tsv`, allowing compression across the repeated records; all original source
hashes and every archived payload hash were independently checked. Extract and
verify from this record's directory:

```sh
sha256sum -c raw-2886.sha256
tar -xJf raw-2886.tar.xz
sha256sum -c raw-2886/MANIFEST.sha256
```

The archived format note maps source paths to members. To run the existing C
reducer on extracted captures, gzip their raw `INPUT-MODE-ROUND.tsv` files
again; new capture campaigns already produce the `.tsv.gz` names it expects.

The frozen corpus was fetched and fully hash-verified by the base checkout's
`tools/ci/fetch-corpus.sh`; no third-party source is republished here. SQLite uses
the CI definitions with the frozen snapshot's explicit header order because this
container lacks Clang's default `stdarg.h` resource path. Musl uses the historical
record's options. The detailed report records the source revisions, manifest
hashes and original licensing/provenance locations.

Agent session: `6b07ee25-da54-83ed-a205-eb9dad229051` (OpenAI session ID; no share URL is exposed).
Model: OpenAI / GPT-6 Astra Pro.
