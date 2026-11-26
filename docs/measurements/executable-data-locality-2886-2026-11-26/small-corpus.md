# Issue 2886: controlled small-corpus page census

The controlled baseline and final head each completed all 24 snapshots: four inputs, default and
`--no-direct` modes, and three processes per combination. All eight final object files are
byte-identical to their baseline counterparts. This is page-layout evidence on the cloud Intel
Xeon Platinum 8370C environment, not timing acceptance on the designated performance host.

## Artifact identity

| Build | Source revision | Source tree | Hosted workflow | Compiler SHA256 |
| --- | --- | --- | --- | --- |
| Baseline | `8e4d32879e17b7d9548cad54257a2f8461328366` | `8bf0a22e6067a7698ca6257d3e6cbe40f49b108a` | `45779319802` | `c090b5d35a9d031afe6a37771445dff87b9541d3521175c45001352164a2b2ff` |
| Final | `170b82def21a488f903a48ab6484a30b4030022e` | `fbe10e9c09f76debe273782e000a3ac527ded466` | `45790224011` | `8bf6f8a58afb73f4ad13e9829375a5baf8c596d65b3a01b9946498575f58fc92` |

The final artifact records GitHub's PR merge revision
`484a2001d659a052797199180a363ed03172973c`; its source tree exactly matches the final source
revision above. Both builds use the same Release vector/O3 configuration and toolchain hash
`eda0bc02300979a219273d969c9830eb0090c72d1fa357b24bc308ade5050259`.

## Results

All page counts are in 4 KiB units. A 64 KiB window or 2 MiB range is counted if it contains at
least one present page in the named section. These are mapped pages, including file
fault-around, not a record of individual program reads or fault addresses.

| Input | Mode | BSS present, base → final | BSS exclusive, base → final | Baked pages / 64 KiB windows / 2 MiB ranges, both | Relro pages / windows, both | Relro 2 MiB ranges, base → final |
| --- | --- | --- | --- | --- | --- | --- |
| empty | default | 10 → 6–7 | 9 → 6–7 | 0 / 0 / 0 | 64 / 4 | 3 → 1 |
| empty | `--no-direct` | 17 → 13–14 | 16 → 13–14 | 48 / 3 / 1 | 64 / 4 | 2 → 2 |
| tiny | default | 10 → 7 | 9 → 7 | 0 / 0 / 0 | 64 / 4 | 3 → 1 |
| tiny | `--no-direct` | 17 → 14 | 16 → 14 | 176 / 11 / 2 | 128 / 8 | 2 → 2 |
| patterns | default | 17 → 14 | 16 → 14 | 304 / 19 / 3 | 208 / 13 | 4 → 2 |
| patterns | `--no-direct` | 17 → 14 | 16 → 14 | 304 / 19 / 3 | 192 / 12 | 3 → 2 |
| feedback | default | 10 → 7 | 9 → 7 | 0 / 0 / 0 | 64 / 4 | 3 → 1 |
| feedback | `--no-direct` | 17 → 14 | 16 → 14 | 288 / 18 / 3 | 160 / 10 | 2 → 2 |

The `default` label means no `--no-direct` argument. It does not imply that the direct path
handles the whole input; `patterns` falls back to the legacy path.

The conservative small-corpus BSS result is **three fewer present pages and two fewer exclusive
pages**. The final empty cases have one varying page, `0x6076000`, occupied by the forced exit
helper's stack tail. The helper shares the compiler address space and may first touch that page
after the parent snapshot. All other BSS pages are stable. Compare maxima for these two cases;
do not attribute that helper scheduling variation to an extra saved page. A present page with
the exclusive bit clear must not be described as private committed memory.

### Exact tiny/default read-only placement

The following addresses are identical in all three controlled repetitions. Each listed 64 KiB
window contains 16 mapped 4 KiB pages in `.data.rel.ro.buster`.

| Build | 64 KiB window starts | Pages grouped by 2 MiB range |
| --- | --- | --- |
| Baseline | `0x1790000`, `0x17b0000`, `0x1ac0000`, `0x20d0000` | `[0x1600000, 0x1800000)`: 32; `[0x1a00000, 0x1c00000)`: 16; `[0x2000000, 0x2200000)`: 16 |
| Final | `0x1670000`, `0x16d0000`, `0x16f0000`, `0x17c0000` | `[0x1600000, 0x1800000)`: 64 |

Thus the same four fault-around windows and 64 mapped pages occupy one aligned 2 MiB range,
instead of three ranges. `tiny-direct-layout.tsv` preserves the explicit half-open intervals
and per-range counts. This demonstrates denser placement; it does not demonstrate an actual
huge mapping or a hardware TLB improvement.

### Process fault counters

These are `wait4` child minor-fault ranges from the same instrumented runs, included as
observations rather than a timing or speedup claim. The helper descendant itself reports one
minor fault per run. Final runs have zero child major faults; baseline patterns/default has a
0–1 major-fault range, and all other baseline cases have zero.

| Input | Mode | Baseline child minor faults | Final child minor faults |
| --- | --- | --- | --- |
| empty | default | 234–236 | 230–231 |
| empty | `--no-direct` | 780–784 | 775–778 |
| tiny | default | 253–254 | 249–250 |
| tiny | `--no-direct` | 870–874 | 866–869 |
| patterns | default | 1445–1448 | 1443–1444 |
| patterns | `--no-direct` | 1355–1358 | 1350–1353 |
| feedback | default | 262–264 | 258–259 |
| feedback | `--no-direct` | 922–924 | 919–920 |

## Reproduction

Use a directory `ROOT` containing `evidence/datapages.c`, `evidence/census_campaign.c`, the two
original tiny fixtures in `evidence/corpus`, and a `buster-base` checkout pinned to the baseline
revision. The other inputs are that checkout's `tests/driver/tier1_patterns.c` and
`tests/ci/feedback/driver.c`, with its sibling `driver.h`. Their exact hashes are in each
campaign's `inputs.sha256`. The runner requires absolute paths and has no personal scratch path
default.

```sh
gcc -std=gnu17 -O2 -Wall -Wextra -Werror "$ROOT/evidence/datapages.c" -o "$ROOT/evidence/datapages"
gcc -std=gnu17 -O2 -Wall -Wextra -Werror "$ROOT/evidence/census_campaign.c" -o "$ROOT/evidence/census_campaign"
"$ROOT/evidence/census_campaign" "$BASE_COMPILER" "$ROOT/evidence/base-census-base-pages" "$ROOT" --fresh-per-mode --base-pages
"$ROOT/evidence/census_campaign" "$FINAL_COMPILER" "$ROOT/evidence/final-census-base-pages" "$ROOT" --fresh-per-mode --base-pages
```

The campaign records exact argv and environment adjustments in `commands.txt`. It creates an
ordinary read/write executable copy with a new inode for each input/mode, reads the full file,
uses the same copy for three fresh processes, then removes it. It uses no reflink. It sets
`BUSTER_HUGE_PAGES=0`, `BUSTER_EXECUTABLE_HUGE_PAGES=0`, unsets `BUSTER_NO_DIRECT` and
`SOURCE_DATE_EPOCH`, and passes `--lanes 1 -c` to the compiler. The first repetition includes
absent pages and zero-present symbols; all repetitions include the complete present-page census.

`datapages --base-pages` sets `PR_SET_THP_DISABLE(1)` before fork/exec and verifies the inherited
policy in the child. The default tool behavior leaves that policy unchanged. The local sandbox
denies ptrace, so these runs use the existing `BUSTER_TEST_EXIT_HELPER_PAUSE` compiler hook.
The tool forces `BUSTER_EXIT_HELPER=1` and a 2000 ms pause, confirms the compiler parent's final
sleep after compilation, stops that parent, reads its pagemap, and resumes it. It is a subreaper
and reaps every descendant. The main status is zero and exactly one helper is reaped in every
accepted run. The helper's expected SIGKILL status follows its production parent-death behavior
with executable collapse disabled.

The snapshot occurs before libc exit handlers, unlike the earlier issue's ptrace-at-exit_group
method. Symbols can share pages; adjacent sections can share a boundary page. The C reducer
`census_reduce.c` deduplicates baked/relro boundary pages for its combined sealed totals.
`per-run-summary.tsv` is its output; `summary.tsv` is the compact three-run min/max table.

Recorded helper source SHA256 values:

- `datapages.c`: `1a08ae1a2ed67768f10acd1b4be36d42fbfb72e14787575a140f551a8384d4ad`
- `census_campaign.c`: `62e5441d9937782c9b78ad129a39370513c8d966c38daebf867ab3f6aea5966b`

`objects.sha256` in each controlled directory contains the eight output hashes. A byte-for-byte
comparison, not just matching hash strings, confirmed every corresponding baseline/final object.
The files are the last outputs of their three-run combination; the small-corpus campaign does
not preserve three separate copies of each object.

## Raw groups to retain

| Directory or file | Role |
| --- | --- |
| `base-census-base-pages/`, `final-census-base-pages/` | Primary controlled 24 + 24 snapshots; retain raw gzip, stderr logs, command receipts, source/tool/input hashes, object hashes, both summaries. Do not package compiled tools or object files. |
| `base-pages-pilot-tiny/`, `base-pages-pilot-patterns/` | Three-run pilots validating the explicit preexec THP control. Valid but superseded by the full controlled runs. |
| `base-census-fresh/`, `bss-census-fresh/` | Complete preliminary fresh-inode campaigns. The BSS-only head isolates the BSS edit and has eight matching objects. Read-only residency was not fully controlled; do not use those read-only counts as the final comparison. |
| `base-census/` | Original exploratory artifact-inode campaign plus initial tiny snapshot; preserves earlier unstable read-only residency. The original runner source and hashes remain here. |
| `base-census-controlled/` | Incomplete fresh-copy attempt interrupted by workspace ENOSPC at tiny/legacy round 3. Retain only as an explicitly failed exploratory record; its final compressed output may be incomplete and is not an accepted sample. |
| `tools-v1/` | Exact pre-`--base-pages` helper and runner sources for the preliminary fresh-inode captures. |
| `tiny-direct-layout.tsv`, `census-platform.txt` | Address grouping and method/platform provenance for the final small-corpus comparison. |

The extended SQLite/musl corpus and file-collapse probes are separate experiments owned by the
other validation reports. No read-only residency expansion in exploratory records should be
described as a proved huge mapping. The separate collapse probe found file-backed
`MADV_COLLAPSE` unavailable in this environment; actual file collapse and target-hardware timing
remain outside this census's demonstrated results.
