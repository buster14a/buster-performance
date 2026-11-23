# #3450: census of Tier 1 selection's per-lane and munch routes

#3450's Tier 1 item: "`tier1_burs_classify_node` per lane for `IR_STACK_ADDR`, addresses whose constant or offset
doesn't fit 32 bits, and `fcmp ==`/`!=` (`tier1_select_burs.c`); also `tier1_select_munch` for operators outside the
grammar". Session: `session_01EgbxndFreFrJqAywiEGoue`.

`census.diff` is experiment only, on main 4b0e65e7. It counts two things over `--tier1 -c --lanes 1` of sqlite3.c,
Lua 5.4.8 and musl (`objects.sh`, the command lines of the earlier records):
- each classify step's active nodes and its per-lane lanes, by reason;
- each picked pattern's munch flag, with its node's IR operation.

The counts were taken in a cloud container. The counts don't depend on the host.

## Per-lane classification (`tier1_burs_classify_node` inside the vector classifier)

| corpus | classified nodes | frame object address | wide displacement | floating == / != | share |
| --- | ---: | ---: | ---: | ---: | ---: |
| sqlite3.c | 739,565 | 1,490 | 0 | 21 | 0.20% |
| Lua | 132,345 | 458 | 0 | 51 | 0.38% |
| musl | 217,856 | 4,473 | 0 | 39 | 2.07% |

## Maximal munch (`tier1_burs_pick` falls back to `tier1_select_munch`)

| corpus | picked nodes | munched | share | top operations |
| --- | ---: | ---: | ---: | --- |
| sqlite3.c | 259,830 | 91,022 | 35.0% | br 29,516, phi 11,774, call 11,756, sext 10,141, symbol_addr 6,387, copy 4,098, trunc 3,801, param 3,664, ret 3,146, lifetime 2,457, call_indirect 1,853 |
| Lua | 55,765 | 21,745 | 39.0% | br 5,748, call 5,420, phi 2,094, symbol_addr 1,965, sext 1,639, param 1,364, ret 1,000, trunc 666, lifetime 589 |
| musl | 110,734 | 52,146 | 47.1% | br 7,340, call 6,646, param 5,249, ret 4,509, phi 4,496, sext 3,561, symbol_addr 3,374, load 2,788, fmul 2,096, lifetime 1,882, fadd 1,542 |

Munch is not a rare route. It is how Tier 1 selects every operator the BURS grammar doesn't cover: control flow,
calls, phis, parameters, extensions and symbol addresses, and floating arithmetic. It also selects the loads and
constants whose rule names a candidate the walks didn't make. Removing it means growing the grammar, and its baked
tables, to the whole IR the selector takes: a project of its own, not a fallback's vectorization.
