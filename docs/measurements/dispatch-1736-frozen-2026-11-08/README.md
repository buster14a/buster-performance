# PR 1736: frozen dispatch experiment, 2026-11-08

This is a historical comparison of [buster PR 1736](https://github.com/buster14a/buster/pull/1736), **not qualification against current main**. Base `0cf40fd3cbf1f56328eeb8a653fefe0f719ee24a` and candidate `fa44504e664ea85c170f9b6cc47f9ea8afef92a4` were built on the Ryzen 7 9700X using the same private, optional tag sidecar (`kinds.patch` SHA-256 `141776fef464c4555a5e04387681109bd85f766ec480f1c95a8d1edcb22e58e7`). Since this base, main has changed Tier 1 block layout, compare-load folding, and address folding. In particular, block layout affects the experiment's layout-adjacency condition.

## SQLite dynamic instruction counts

Both executables passed the existing speedtest1 verification hash `1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739`. The separate verified and Callgrind runs all produced the same logical database dump SHA-256 `3be217cd86db20ce5bd81e09c143e4b581061f1a3ac5bee7ee3e21a4ffd408d4`; outputs and exit statuses are in the archive. Each run used its own fresh tmpfs database and the pinned speedtest1 options in `sqlite-run.sh`. Callgrind 3.25.1 with instruction dumps counted the two byte-identified ordinary executables; the separately compiled tagged executables were byte-identical to those ordinary executables.

| Dynamic edge-tagged instructions | Base | Candidate | Change |
| --- | ---: | ---: | ---: |
| T: stores | 145,891,664 | 147,264,457 | +0.94% |
| U: reloads | 159,706,391 | 160,877,314 | +0.73% |
| e: register moves | 128,010,797 | 119,593,096 | -6.58% |
| Combined | 433,608,852 | 427,734,867 | -1.35% |
| Combined in `sqlite3VdbeExec` | 252,109,329 | 244,192,844 | -3.14% |

The observed tagged traffic falls far short of the issue's at-least-half edge-traffic target on this frozen SQLite comparison and does not establish acceptance. This is not a 9700X runtime result and says nothing about the five Lua scripts' dynamic traffic. The `--verify` run is separate from the count run; matching database dumps and successful exits support, but do not independently prove, identical every-step behavior.

An independent review matched `main`'s recorded address and instruction lengths against each disassembly, obtaining load bias `0x4000000` for each capture. No sampled instruction address inside either ELF executable region was unmatched. In each capture 1,986 instruction costs at 36 addresses associated with Callgrind's `???` object fell outside the executable interval and were excluded; their origin is unconfirmed. This is why `count.tsv` reports 1,986 unmatched, rather than zero. The `#total 0` in the earlier empty-input fit files is a parser-only check, not a dynamic count.

## Retention and controls

At each revision SQLite reported 2,709 and Lua 1,088 Tier 1 compiled functions, zero fallbacks, and explicit compiled/no-fallback outcomes for `sqlite3VdbeExec` and `luaV_execute`. Within each revision and workload, ordinary and tagged ELF files were byte-identical. All exported rows had unique names; independent row checks matched each outcome's record count and T/U/e counts. The static fitter reported no tag-to-disassembly fit diagnostics. `tag-class-audit.txt` and `audit-tag-classes.py` record an independent classification of all T/U/e tags: every one was a stack store, stack load, or register copy respectively. This supports instruction-shape mapping but does **not** independently prove all edge operations received a tag. Earlier fixture controls did not execute vector edge spills, KMOV edge copies or rematerialization-to-slot paths; do not infer complete instrumentation coverage from these measurements.

Eight additional compiles reproduced the four pairs byte-for-byte. The attached traces record observed reads and the preparation manifests bind the frozen corpus and binaries. The 219 observed external file and directory entries matched across a practical pre/post snapshot for the SQLite rechecks. The trace inventory does not prove exhaustive environmental closure: it does not fully bind failed path searches, all metadata/probes, `/proc` and `/sys` state, or every possible input opened in nonstandard ways. Original runs were inventoried after execution. The input archive, generated executables and database dumps are not included; the archive contains their hashes, tag streams, raw Callgrind data, compiler output, traces, checks, scripts, and receipts. The two compressed SQLite disassemblies and `gap.c` (SHA-256 `81856ce15d9eb8a0466a827e8dd80780170504e8e53e720b6ee3212af3c15e35`) permit offline reproduction of the joins. The corpus and original measurement recipes are identified in the [earlier #1189 record](../tier1-gap-1189-2026-11-03/README.md). Raw archive SHA-256: `8afd5e19b165fb14b18763dc308a34444125432183a18577fb42cc7d94f77043`.

The four `perf347-*.sha256` manifests are an independent **post-hoc** comparison of the retained compiler source trees with Git archives of the frozen commits plus the recorded sidecar patch. They match, but are not build-time provenance; the original compiler-build receipts are not included in this record.

Each hardware compile, verification, capture and count used the Benchpress shared lock. The evidence is a bounded experiment: it does not establish current-main behavior, complete semantic correctness, a general speedup, or issue acceptance.
