# Vector-only value numbering and LICM: the #1344 census and #2781's implementation

Raw evidence from Factory Droid session `b0df91f8-5327-4de1-a613-db1be1f3c3fb`
(2026-11-14, 22:21 to 23:22 Madrid) for
[buster#1344](https://github.com/buster14a/buster/issues/1344)'s census of Tier 1's
`c_tokenize` and [buster#2781](https://github.com/buster14a/buster/issues/2781)'s
design: #866's value numbering and LICM, restricted to vector and mask values,
on by default. The session stopped at its usage limit before recording this.

## Provenance

The files were copied byte for byte from a local recovery archive
(`droid-buster-recovery-2026-11-14.tar.zst`, sha256 `876f181e…7c78`) of the
session's scratch directory `~/.cache/droid-vector-census/`. The one addition is
`real/test-checker-driver.log`, the session's last background job's output
(`/tmp/droid-bg-1794694449335-….out`). ELF objects and executables are left out;
`omitted-binaries.sha256` lists each one's sha256, size and path. Nothing here
was rerun when it was recorded, and absolute paths in scripts and logs are the
original machine's.

Source revisions, on buster14a/buster:

| What | Commit |
| --- | --- |
| main the work starts from | `45cd9aec77c4885f55da8f2ee9cace69fa394a85` |
| prototype (`BUSTER_PROTO_VECTORS`) | `24c4f2abbc3d017c03c7ede8be8e4efd2d37963a` |
| implementation, committed unchanged from the session's working tree | `2011ce042e498f45d70bec7d3b7a69bcb14d173f` |

All three are on branch `droid/vector-passes-1344`.

## Layout

| Path | What |
| --- | --- |
| `findings-*.md`, `claim-*.md`, `pointer-*.md`, `issue-policy.md` | Drafts of the comments posted on #1344, #2781 and #2719 |
| `mid200.c`, `small.c`, `stephist.c`, `*.py`, `*.sh` | Inputs and harnesses: `stephist` single-steps one `c_tokenize` call and histograms its instructions |
| `mid200-*.{dump,hist,summary.txt}`, `steph-*.log`, `rows/`, `rows.log` | The census: every instruction of one call on `mid200.c` (9,076 bytes), clang -O2 against Tier 1 |
| `variants/`, `proto/`, `rounds-223648.tsv` | Desktop prototype runs of the pass variants |
| `neutral/` | Prototype scalar neutrality: SQLite and Lua objects with and without the restricted passes |
| `gcc/`, `other/` | gcc register-count builds of the lexer; the rows and scan programs |
| `bench/9700x/` | The prototype on the 9700X (benchpress, `exclusive.sh`, CPU 2, `-march=znver5`, 15 interleaved rounds): `rounds.tsv`, `host.txt`, `commit.txt` |
| `real/` | The implementation (`2011ce042`'s tree) on the owner's desktop |

The desktop is the owner's Ryzen 9 7940HS (Zen 4); its cycle counts are
directional, not 9700X timings.

## The implementation's results (`real/`, desktop)

- **Lexer**: with the default policy, `real/lexer-default.report` has
  `licm_moved=31`, `gvn_removed=565` and 68,328 records; with
  `--tier1-passes=-vectors`, 0, 0 and 76,955. `lexer-without.o` is
  byte-identical to the prototype run's old default (`variants/lexer-default.o`,
  `42781fdc…`). One `benchmark-lexer` run each (`lexer-*.out`): `c_tokenize`
  10.350 cycles/B without, 5.434 with; `c_tokenize_scalar` 14.464 without,
  15.307 with. The two outputs differ only in those timing rows.
- **SQLite**: `sqlite3-default.o` and `sqlite3-without.o` are identical
  (`2656bf0e…`), as are `sqlite3-baseline.o` and `sqlite3-baseline-without.o`;
  every report has `licm_moved=0` and `gvn_removed=0`.
  `sqlite3-archived-baseline.o` is the prototype's default object (`bd459107…`).
  The capture does not hold these builds' command lines.
- **Lua 5.4.8**: the 33 default objects in `lua-objects.sha256` match the
  prototype run's `neutral/lua-*-default.o` and `neutral/lua-*-vector.o` one
  for one.
- **Tests** that passed: `test-ir-optimize` (284,594 checks), the program-vector
  checker tests (27,571), the requests tests (213), `test-tier1-masks` (264,711),
  `test-tier1-pipeline` (9,504); `test-tier1-select`'s log is a count. The session
  also reported `test-ir-gvn` (2,195,108), `test-ir-licm` (3,424) and
  `test-check-lanes --tier1-outcomes` (3,592) with no failures; their logs were
  not kept.
- **`test-checker-driver` failed**: 192,003 checks, 14 failures
  (`real/test-checker-driver.log`), not yet diagnosed:
  - 2: the implementation's own driver fixture, "the default vector policy
    hoists and numbers vector values", on both host paths: its default build
    did not report both `licm_moved` and `gvn_removed` nonzero.
  - 4: #1373's inline `memcpy`/`abs`/`labs` fixtures print `12`
    (`1012` with `-fno-builtin-labs`) where clang prints `11` (`1011`), on both
    paths.
  - 8: symbol comparisons against clang: file-scope assembly's and a naked
    function's CFI, and target versions, on both paths. The host's clang was
    23.1.5 and 23.1.6 where 23.1.4 is the reference.
  Whether main fails the same on that host was not checked.

## Not done

The implementation has not been timed on the 9700X; `bench/9700x/` is the
prototype's. The remaining steps are on buster#2781.
