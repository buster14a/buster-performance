# Extended frozen-corpus census for #2886

The final candidate produces byte-identical object files to the pinned base for
SQLite and three representative musl translation units in both the default and
`--no-direct` modes. All 48 controlled compilation/census runs succeed. Every
input/mode pair has three identical object hashes within each revision, and all
24 corresponding base/final hashes match.

The common BSS improvement across these workloads is **two fewer exclusive
pages**. Seven input/mode pairs have three fewer present BSS pages; SQLite with
`--no-direct` has two fewer. A present, nonexclusive anonymous page can be the
shared zero page, so present counts must not all be described as private
committed memory. These are end-of-compilation page-residency snapshots, not
counts of exact page faults, page reads, or elapsed-time improvements.

## Revisions and environment

- Base source: `8e4d32879e17b7d9548cad54257a2f8461328366`, hosted vector O3
  product from GitHub Actions run `45779319802`.
- Final source: `170b82def21a488f903a48ab6484a30b4030022e`, hosted vector O3
  product from run `45790224011`. The product records CI merge revision
  `484a2001d659a052797199180a363ed03172973c` and source tree
  `fbe10e9c09f76debe273782e000a3ac527ded466`, verified by the parent task against
  the candidate.
- The products record identical target flags and toolchain identity
  `eda0bc02300979a219273d969c9830eb0090c72d1fa357b24bc308ade5050259`.
- Measurement host: this task's Linux/x86-64 container, Intel Xeon Platinum
  8370C, kernel `6.18.57`. This is not a measurement on the project's 9700X.
- No elapsed timings were collected. The stored rusage counters are diagnostics
  for the instrumented process and can include compiler descendant work; they
  are not a throughput result.

Compiler SHA-256:

| Product | SHA-256 |
|---|---|
| Base | `c090b5d35a9d031afe6a37771445dff87b9541d3521175c45001352164a2b2ff` |
| Final | `8bf6f8a58afb73f4ad13e9829375a5baf8c596d65b3a01b9946498575f58fc92` |

## Protocol and records

`corpus_campaign.c` is a standalone C runner. It takes compiler, output
directory, workspace root, and corpus root paths. `census_reduce.c` reads every
`INPUT-MODE-ROUND.tsv.gz` and produces a per-run summary; it deduplicates page
addresses at the baked/relocated section boundary for the sealed union.

Each input/mode receives a fresh executable inode made by ordinary read/write,
not a reflink. The runner reads that copy completely once, runs three
compilations against the same inode, then removes it before the next case.
The compiler receives `--lanes 1`. `BUSTER_HUGE_PAGES=0` and
`BUSTER_EXECUTABLE_HUGE_PAGES=0` are set; `BUSTER_NO_DIRECT` and
`SOURCE_DATE_EPOCH` are unset. The census helper is invoked with
`--pause --base-pages`; it forces `PR_SET_THP_DISABLE=1` before exec and verifies
the inherited setting. It uses the compiler's existing exit-helper pause hook,
stops the parent during that pause, and reaps the forced helper descendant.

The first run in each triple also receives `--all-pages`, preserving absent
pages and zero-present symbols. All runs retain compressed raw TSVs, stderr,
exact argv arrays, executable copy inode/byte receipts, census/compressor
statuses, and object SHA-256/size records. Object bytes are removed after
hashing. The two final `object-hashes.tsv` files compare equal with `cmp`.

Every accepted raw TSV has `BASE_PAGES_CONTROL=1`,
`THP_DISABLE_BEFORE_EXEC=1`, `CENSUS_OK=1`, `EXIT_STATUS=0`, and
`REAPED_DESCENDANTS=1`. `DESCENDANT_STATUS=137` is expected: the no-collapse
helper is killed by the production parent-death signal. Census, compression,
and object-hash statuses are zero for every accepted run.

The commands used, from `/workspace/scratch/3be69f2da096`, are:

```sh
cc -std=c11 -O2 -Wall -Wextra -Werror evidence/corpus_campaign.c -o evidence/corpus_campaign
cc -std=c11 -O2 -Wall -Wextra -Werror evidence/census_reduce.c -o evidence/census_reduce
evidence/corpus_campaign /workspace/scratch/3be69f2da096/evidence/main-ci/product/bin/compiler /workspace/scratch/3be69f2da096/evidence/base-census-corpus /workspace/scratch/3be69f2da096 /tmp/buster-2886-corpus
evidence/corpus_campaign /tmp/buster-2886-final-ci/product/bin/compiler /workspace/scratch/3be69f2da096/evidence/final-census-corpus /workspace/scratch/3be69f2da096 /tmp/buster-2886-corpus
evidence/census_reduce evidence/base-census-corpus evidence/base-census-corpus/summary.tsv
evidence/census_reduce evidence/final-census-corpus evidence/final-census-corpus/summary.tsv
cmp evidence/base-census-corpus/object-hashes.tsv evidence/final-census-corpus/object-hashes.tsv
```

## Input selection, flags, and provenance

The verified corpus is the `preprocessor-391e729af658-ci.tar.zst` release from
`buster14a/buster-performance`, fetched through the compiler repository's
`tools/ci/fetch-corpus.sh`. Archive SHA-256:
`ceb39bf938cd7a7469bbb53646c3318d0cbfdac4d37b6d05b183c4fd0b9898c2`.
Its `MANIFESTS.sha256` hash is
`391e729af6587355050881752558e790299cfe638c7dc7803bd028a8535ebcbd`.
The parent task verified the archive and all retained per-directory file
manifests before these compilations. No corpus source bytes are included in
this measurement record.

SQLite uses the four definitions from
`buster/.github/workflows/hosted-correctness.yml`'s frozen object comparison:
`SQLITE_OMIT_LOAD_EXTENSION`, `SQLITE_THREADSAFE=0`, `SQLITE_ENABLE_MEMSYS5`,
and `SQLITE_ENABLE_RTREE`, plus its source directory's `-I`.
The literal CI recipe initially failed in this container because its default
Clang resource include directory did not contain `stdarg.h`. The accepted
campaign adds `-nostdinc` and the frozen snapshot's original system include
order using `-isystem`:

1. `headers/usr/lib/clang/23/include`
2. `headers/usr/local/include` (empty)
3. `headers/usr/include`

Both binaries receive identical paths and flags. The failed initial campaign
is retained separately under `base-census-corpus-initial`; its SQLite results
are excluded from the accepted comparison. Its other cases are also not used
in the final table, which uses the complete rerun.

The musl recipe copies the options in
`buster-performance/docs/measurements/executable-pages-2873-2026-11-16/scripts/musl-common.sh`
at `11a41d14c1a07231a196ed70cb578c05ef6d5d3d`: `-std=c99 -nostdinc
-ffreestanding -D_XOPEN_SOURCE=700`, followed by the seven include directories
in the original order with the local corpus root substituted. The selected
sources are `src/stdio/vfprintf.c`, `src/stdlib/strtol.c`, and
`src/malloc/lite_malloc.c`. The last source follows the historical script's
`src/*/*.c` selection; nested `mallocng/malloc.c` and `oldmalloc/malloc.c` are
outside that selection.

| Source relative to corpus | SHA-256 |
|---|---|
| `sqlite/sqlite3.c` | `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d` |
| `libc/musl/src/stdio/vfprintf.c` | `5ae7748a197b3c334f2b6791f8613940f27d3bac6f27bcfa73706222fff4ffa8` |
| `libc/musl/src/stdlib/strtol.c` | `2291cd02a25622bd31de831d7dfaff5c618ed7846b3123033a714188de78e61e` |
| `libc/musl/src/malloc/lite_malloc.c` | `7ee902268de1c1d3542d61ead38ca56c002630a2890f150f5959edee8f8506d9` |

The corpus `README.txt` records SQLite 3.53.2's official amalgamation URL and
public-domain dedication, and Zig 0.14.1-vendored musl 1.2.5 (including Zig's
patches), pinned to Zig commit
`d03a147ea0a590ca711b3db07106effc559b0fc6`. Musl's retained terms are in
`libc/musl/COPYRIGHT`; its hash is
`f9bc4423732350eb0b3f7ed7e91d530298476f8fec0c6c427a1c04ade22655af`.
Header/package attribution remains in `headers/package-owners.txt`,
`headers/provenance.tsv`, source notices, and the corpus `LICENSES/` texts.
The new runner and reducer contain original project code under
`Apache-2.0 WITH LLVM-exception`, not copied third-party implementation.

## Observed BSS results

Each table entry is stable across all three runs. Counts include ordinary
`.bss` and the new `.bss.buster_start` output section, deduplicated by address.

| Input | Mode | Base present / exclusive | Final present / exclusive |
|---|---|---:|---:|
| SQLite | default | 10 / 9 | 7 / 7 |
| SQLite | `--no-direct` | 17 / 17 | 15 / 15 |
| musl vfprintf | default | 17 / 16 | 14 / 14 |
| musl vfprintf | `--no-direct` | 17 / 16 | 14 / 14 |
| musl strtol | default | 10 / 9 | 7 / 7 |
| musl strtol | `--no-direct` | 17 / 16 | 14 / 14 |
| musl lite_malloc | default | 10 / 9 | 7 / 7 |
| musl lite_malloc | `--no-direct` | 17 / 16 | 14 / 14 |

SQLite's `--no-direct` exception is visible in raw page records: final ordinary
BSS page `0x73d5000` is present for SQLite and absent for strtol. It covers the
beginning of `check_driver_executable.named` and nearby checker globals; page
overlap alone does not identify which variable caused the access. Its
corresponding base page `0x73d4000` is exclusive for SQLite and nonexclusive
for smaller cases. `check_driver_lanes` itself has two present pages in both
final SQLite and final strtol, compared with three in the base. This does not
show an extra lanes-array residency cost for SQLite.

## Sealed data: locality and measurement limits

The sealed union is `buster_baked` plus `.data.rel.ro.buster`, with overlapping
boundary pages counted once. Ranges are aligned 2 MiB address ranges occupied
by at least one present page; they are not huge-page allocations.

| Input | Mode | Present pages base → final | Occupied 2 MiB ranges base → final |
|---|---|---:|---:|
| SQLite | default | 64 → 64 | 3 → 1 |
| SQLite | `--no-direct` | 560 → 560 | 6 → 5 |
| musl vfprintf | default | 560 → 560 | 7 → 5 |
| musl vfprintf | `--no-direct` | 1,632–2,064 → 544 | 6 → 5 |
| musl strtol | default | 64 → 64 | 3 → 1 |
| musl strtol | `--no-direct` | 432 → 432 | 5 → 5 |
| musl lite_malloc | default | 0–1,536 → 64 | 0–3 → 1 |
| musl lite_malloc | `--no-direct` | 2,064 → 560 | 6 → 5 |

The later baseline musl cases have substantial file-backed residency
variation despite the explicit before-exec THP control and fresh-copy
protocol. The third lite_malloc/default run even has zero present sealed
pages at the final snapshot and 149 recorded major faults. Page reclaim or
page-cache mapping behavior in the shared container is a possible explanation;
the measurements do not identify the cause. These rows cannot support a causal
claim of hundreds of saved reads, faults, or required pages. All raw values
remain in the record, including these outliers. The stable SQLite,
vfprintf/default, and strtol rows give more bounded evidence of address-range
locality. No timing or actual file-huge-page improvement is established by
this campaign.
