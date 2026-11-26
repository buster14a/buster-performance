# Recovery and recapture of candidate 1024 for #2610

This packet recovers the previous session's last experimental compiler and
recreates its missing two-workload dynamic result. **Candidate 1024 remains
rejected as a solution to [buster#2610](https://github.com/buster14a/buster/issues/2610):
`yy_reduce` still executes 3,071,254 call-save/restore instructions, above the
660,000 target.** No production qualification or hardware timing is claimed.

The compiler is the frozen measurement draft
[#3639](https://github.com/buster14a/buster/pull/3639), head
`79510829fb67510fb1ac2dfe4a28a0a12a9f2912`, built as hosted test merge
`0bdefd975178987e4e697154785459bb995d38a4` on the pinned
`74eacd4744a8131ba4c1a5bd8ad87b89ec0f7dbe` base. It is not a compiler built
from current main. Work on later main and any subsequent candidates must keep
their source, controls and measurement pairs separate.

## Recreated result

All values are executed instructions in the generated executable's code ranges,
joined to its instruction-origin sidecar. Differences are candidate minus the
freshly recaptured control.

| Metric | Control 0 | Candidate 1024 | Difference |
| --- | ---: | ---: | ---: |
| SQLite size-5 mix1 instructions | 2,250,814,969 | 2,250,439,821 | -375,148 |
| SQLite transport union | 253,741,219 | 253,263,595 | -477,624 |
| SQLite call saves/restores | 92,517,948 | 88,535,573 | -3,982,375 |
| SQLite edge traffic | 120,810,256 | 124,315,007 | +3,504,751 |
| SQLite argument copies | 95,232,001 | 95,334,477 | +102,476 |
| SQLite ordinary/edge spills and reloads | 124,154,797 | 124,154,797 | 0 |
| `yy_reduce` instructions | 103,295,056 | 103,217,730 | -77,326 |
| `yy_reduce` call saves/restores | 3,923,938 | 3,071,254 | -852,684 |
| Lua arithmetic instructions | 865,590,587 | 865,590,110 | -477 |
| Lua arithmetic transport union | 17,785,128 | 17,784,622 | -506 |

[comparison.tsv](comparison.tsv) contains every origin and derived-count delta.
The transport union is the deduplicated set of ordinary spills/reloads, call
saves/restores and edge traffic. Spill and edge categories overlap and must not
be added to obtain that union. Argument copies are outside the transport union.
The standalone edge category rises even though the union falls.

The complete per-function comparisons have **no positive total-instruction
delta**: 32 SQLite functions and 11 Lua-arithmetic functions decrease, and every
other joined function is unchanged. Separate per-function comparisons of the
transport union and spills/reloads also have no positive delta.
[speedtest1.function-deltas.tsv](speedtest1.function-deltas.tsv) and
[arithmetic.function-deltas.tsv](arithmetic.function-deltas.tsv) list all changed
function totals; the archive includes the complete joined tables and the
separate traffic comparisons. These statements cover the two captured workloads,
not unmeasured dynamic behavior of the other four Lua scripts.

## Recovery controls and correctness

The control's complete SQLite and Lua executables match the original frozen
baseline SHA256 values. Both complete origin sidecars also match the archived
controls byte for byte. The receipt and original hashes are retained in the
archive, so the comparison is not based only on text-section similarity.

Both newly captured pairs pass exact origin accounting and tag-fit audits,
with zero unmatched executable instructions. The outside-object counts are 15
for SQLite and 25 for arithmetic in both variants. The two fresh baseline totals
match their previously published values exactly.

SQLite's native verification output in each measurement pair has the same
frozen hash:

```text
Verification Hash: 1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739
```

All five fixed-seed Lua scripts were executed natively for both recovered
variants; their stdout matches the archived Clang oracle outputs and stderr is
empty. Arithmetic's output comes from the recaptured pair; calls, closures,
strings and tables were additionally run for this correctness check. Their
dynamic instruction counts were not recaptured here.

Compilation retains the old coverage: SQLite 2,709 compiled functions and no
fallback; Lua 1,086 compiled functions with the existing unsupported
`luaD_rawrunprotected` fallback. The full per-function compilation reports are
preserved. The successful original hosted run is
[45844778824](https://github.com/buster14a/buster/actions/runs/45844778824).
This recovery packet does not present the earlier focused-test or full
emitted-code-certificate claims as newly rerun checks.

## Where candidate 1024 stops

The recovered target trace confirms the earlier search-coverage diagnosis:

- All RDI intervals are reached: 115 cumulative accepted intervals after 369
  eligible intervals, with 85,227,555 structural work units charged.
- The search stops while processing RSI: 183 cumulative accepted intervals
  after 636 eligible intervals, with 134,217,726 work units charged.
- R9 is not reached.
- The final accepted prefix is published. There are 3,809 considered targets,
  2,124 successful sparse trials, 1,685 proposal refusals, 1,348 weighted-cost
  refusals and 40 path refusals, all from the transport guard.
- Sparse epoch replay visits 5,917 blocks across the successful trials.

The work count is the implementation's structural allowance, not a measurement
of CPU instructions or compiler elapsed time. The trace supports continued
investigation of search coverage; it does not establish that a larger search
will meet the primary target or all corpus criteria.

## Packet and reproduction

`recovery-evidence.tar.gz` contains a `packet/` tree with:

- all four new compressed raw Callgrind captures and compressed native/counted
  stdout and stderr;
- complete compressed joined tables, tag sidecars and compilation reports;
- unchanged C measurement/join helpers, source-input and resource-header hashes,
  original native oracles and retained component notices;
- hosted source/product identities, external artifact/tool digests, exact
  compilation/measurement commands, control-parity and raw-integrity receipts;
- summaries, per-function traffic comparisons and the bounded-search trace.

Compiler executables, generated program executables, uncompressed raw captures
and large disassemblies are external. Their hashes and reconstruction commands
are retained. `packet/metadata/product/external-product-files.sha256` is the
original external compiler-product manifest; it is not a manifest of this
packet. The packet's own `SHA256SUMS` covers its included files.

Extract and verify:

```sh
sha256sum -c recovery-evidence.sha256
tar -xzf recovery-evidence.tar.gz
cd packet
sha256sum -c SHA256SUMS
```

See `packet/COMMANDS.md` and `packet/PROVENANCE.md` after extraction. The original
measurement driver preserves its stable executable/database paths and suite
lock. Its fixed historical input directory name does not select a remote host.

This recapture ran on the cloud AMD EPYC 9V74 environment with Debian glibc 2.41
and the original Valgrind 3.24.0 package. These are deterministic generated-code
instruction counts, not hardware timing results. Benchpress/9700X was not
accessed or queued by this recovery session.

The preceding immutable record is performance commit
`4b7481be76d5b93497a1530a3115c6ab51fae17f`; it ended at candidate 512.
This packet adds new captures for candidate 1024 and does not reconstruct,
replace or erase the previous session's explicitly lost raw files.

---

Agent session: 6b086a82-e9b8-83eb-aad4-587684d3a052 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6 Astra Pro

Recovered implementation and earlier evidence:
6b07eef1-3474-83ed-9c43-8fe10b12d07a (OpenAI session ID; no share URL is exposed),
OpenAI / GPT-6 Astra Pro.
