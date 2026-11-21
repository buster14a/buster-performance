# Three ways to write native row values in the checker window

Item 3 in [Buster #3196](https://github.com/buster14a/buster/issues/3196) asks whether writing values during row emission can remove the cost of the later values pass. Three independent prototypes ran on locked 9700X CPU 2. Each used seven paired rounds of four executions per corpus. All 252 runs reproduced the ordinary row stream on the three inputs.

| Change | SQLite | Lua | musl |
| --- | ---: | ---: | ---: |
| [Write default values and carried first-slot payloads during emission](slot-values/) | +1.779 | +1.366 | +0.154 |
| [Use one list for three first-slot value sources](shared-list/) | +4.315 | +2.531 | +2.958 |
| [Write every value into its final slot](all-slots/) | +14.261 | +13.041 | +10.812 |

The numbers are the median change in the combined first-pass write and values intervals in TSC ticks per swept record. Positive means slower. The first prototype cost more in every SQLite and Lua pair. Its musl range crossed zero. The second prototype cost more in every pair on all three inputs. The complete slot writer increased time in every pair on every corpus, including the full X row pass. Repeated execution also cost more on each input for all three builds. Each build's directory contains source, raw measurements, paired ranges and replay scripts.

The first design still applies separate fixups for conversions, strides, control labels and updates. The second still runs the specialized loops for those cases. The complete writer handles those cases by preparing the rare numbering decisions before the final emission. The ordinary implementation remains faster across these comparisons.
