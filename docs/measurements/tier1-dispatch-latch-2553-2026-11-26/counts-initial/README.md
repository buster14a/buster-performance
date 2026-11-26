# Initial candidate: tagged instruction counts and exact CFG replay

The narrow majority-predecessor candidate at compiler `d3d8ad3bc7373a58e62b3eb3ecb32a0001c61167` is **not an accepted solution to #2553**. It passes its focused correctness tests but leaves both hot dispatchers unchanged. This record preserves that negative result before testing the structural corridor experiment.

## Pinned compilers and executable parity

The baseline is `8e4d32879e17b7d9548cad54257a2f8461328366`. [Hosted run 45791795852](https://github.com/buster14a/buster/actions/runs/45791795852) built both revisions with the same measurement-only origin tags and snapshot writer. Artifact `15103689365` has ZIP SHA-256 `25c4b357ae48df2df512e84b77552b897b88d186deb0545cfe9c080a1801dbd2`.

| Product | SHA-256 |
| --- | --- |
| Tagged baseline compiler | `4c281f7892e112744b7a4f433db63b8cbba2ca379e5511025087684701f0fefa` |
| Tagged initial compiler | `c484d40acc69aa2b2c2a3bbc2b7ec18b34042f7b1e27ff1105179e288bae9d60` |
| Baseline SQLite | `e435f9cc873fde87815ca632e42d8440816a657818d02ce5b50e75363011fcc3` |
| Initial SQLite | `09abf13415a1b7a9a46ecd229fe3f7399e95ffa439d0ed60877e8c19c4662c18` |
| Lua, both revisions | `2cbe020165695789c6e3f6e02b355f23443b3c24024dac101b3e186f55415a76` |

Each tagged executable is byte-identical to its corresponding uninstrumented executable. Therefore the already captured same-path Callgrind trace can be joined to its exact tag map without rerunning a different program. Lua is also byte-identical across revisions. The archives retain the compiler identities, flags, logs, input pins, executable hashes, native outputs and reuse hashes.

SQLite's verification output matches the Clang oracle: `1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739`. All five seeded Lua outputs match the oracle. No native performance claim is made: these are exact executed instruction counts on the cloud host, not 9700X timings.

## Tagged counts

These totals sum mapped executable functions. They do not use the anonymous object's larger `#total`: unmatched external stubs are outside the executable's ELF LOAD segments. There are zero unmatched addresses inside either executable (15 external unmatched instructions for SQLite, 25 for each Lua workload). Origin attribution is from the pinned `gap.c`, with `GAP_INSTRUCTIONS=1`.

| SQLite, whole executable | Baseline | Initial | Initial minus baseline |
| --- | ---: | ---: | ---: |
| Instructions | 2,250,813,933 | 2,250,785,212 | -28,721 |
| Edge register moves, e+h+x | 37,068,474 | 37,046,555 | -21,919 |
| Edge stores, T+t | 30,206,285 | 30,206,577 | +292 |
| Edge reloads, U+u | 53,535,497 | 53,535,627 | +130 |
| Spill stores, S | 21,270,991 | 21,270,227 | -764 |
| Spill reloads, L | 19,142,024 | 19,141,406 | -618 |
| Call saves, C | 44,920,453 | 44,920,453 | 0 |
| Call restores, R | 47,597,495 | 47,597,495 | 0 |

`sqlite3VdbeExec` remains exactly **457,760,300** instructions, with 10,277,237 edge moves, 17,176,137 edge stores and 33,635,628 edge reloads. Its spill stores/reloads remain 8,946,932 / 7,911,535. The small changes are elsewhere; the full per-function comparison is retained in the provenance archive. In particular, `constructAutomaticIndex` gains 17 executed spill stores despite a small net instruction reduction. The candidate does not meet the issue's no-extra-spills condition.

The five Lua workloads remain byte-identical and total **3,994,120,551** instructions: 82,467,918 edge moves, 5,541,088 edge stores, 21,581,947 edge reloads, 29,251,355 spill stores and 12,898,903 spill reloads. `luaV_execute` contributes 2,035,500,325 instructions. Per-workload totals are arithmetic 865,590,329; calls 494,172,554; tables 856,913,522; strings 719,694,347; closures 1,057,749,799.

## Why the synthetic case did not match SQLite

The actual `sqlite3VdbeExec` input contains 3,591 blocks, 8,108 values and 667 phis. The unchanged baseline and initial allocations have 69,922 intervals, 70,774 fragments, 214 spill values and 2,385 resolved edge moves. Exact baseline replay produces fingerprint `03c4f1e1d5fec534` and a passing CFG certificate. The first function's captured allocation text is byte-identical across baseline and initial.

The late latch B3543 reaches header B3544, which reaches dispatcher B3545 or a shared default block B3542 that returns to the latch. The first real handler is B27. Both important carried phis have 154 of 156 incoming edges carrying the header value unchanged, **including the nearest cold predecessor**. Consequently the first candidate's different-operand guard rejects them; removing just that guard would still select the cold predecessor's changed register.

A latch-only convention is also insufficient. The header's existing joined hint names the shared default block, preserving the old cold convention. The corridor experiment therefore recognizes the bounded forward path and default bridge, and propagates the first handler's entry convention through it. Its actual replay passes the certificate but yields 216 spill values and 2,451 moves; removing repairs on the dispatch edge alone does not prove an overall improvement. Dynamic measurement is the next gate.

## Raw evidence and reproduction

The archives contain `ARCHIVE-SHA256SUMS` for their contents. Sources and traces are retained; large per-instruction joined TSVs and text dumps are regenerated from the retained inputs.

- [Baseline tags, disassembly, raw Callgrind and per-function counts](tagged-base-raw.tar.xz).
- [Initial candidate tags, disassembly, raw Callgrind and per-function counts](tagged-initial-raw.tar.xz).
- [Compiler/input provenance, tools, output verification and comparison tables](provenance-initial-raw.tar.xz).
- [Actual SQLite CFG input snapshots, exact replay logs, reader and corridor source](cfg-captures-initial-raw.tar.xz).

The provenance archive contains the exact compile commands and the counting script. For SQLite use a fresh directory from `mktemp -d /dev/shm/sqlite-2553.XXXXXX`, a fresh `count.db`, and the same `SQLITE_TMPDIR` path shape. An earlier different-length working directory changed SQLite's path-helper counts; that run was rejected. Arguments are `--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1`.

Regenerate each joined table with:

```sh
GAP_INSTRUCTIONS=1 gap count speedtest1.dis speedtest1.cg '???' 0x108000 speedtest1.kinds > speedtest1.tsv
```

Use the same command with `lua.dis`, the individual script's raw trace, and `lua.kinds`. Consult the retained ELF program headers and unmatched-address table before interpreting totals. The snapshot support README gives the exact reader build; `--require-match` checks captured fingerprint equality for the baseline, while changed allocator experiments omit that flag and must still pass the certificate.

No benchpress or 9700X access was used. The issue's required native placement sweep remains unmeasured.
