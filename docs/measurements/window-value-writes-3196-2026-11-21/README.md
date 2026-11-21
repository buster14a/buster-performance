# Two ways to write native row values in the checker window

Item 3 in [Buster #3196](https://github.com/buster14a/buster/issues/3196) asks whether writing values during row emission can remove the cost of the later values pass. Two independent prototypes ran on locked 9700X CPU 2. Each used seven paired rounds of four executions per corpus. All 168 runs reproduced the ordinary row stream on the three inputs.

| Change | SQLite | Lua | musl |
| --- | ---: | ---: | ---: |
| [Write default values and carried first-slot payloads during emission](slot-values/) | +1.779 | +1.366 | +0.154 |
| [Use one list for three first-slot value sources](shared-list/) | +4.315 | +2.531 | +2.958 |

The numbers are the median change in the combined first-pass write and values intervals in TSC ticks per swept record. Positive means slower. The first prototype cost more in every SQLite and Lua pair. Its musl range crossed zero. The second prototype cost more in every pair on all three inputs. Repeated execution also cost more on each input for both builds. Each build's directory contains source, raw measurements, paired ranges and replay scripts.

The first design still applies separate fixups for conversions, strides, control labels and updates. The second still runs the specialized loops for those cases. Neither build earned a change to the compiler. The remaining whole-slot experiment must account for cases in which a later operator determines an earlier row's argument, label or temporary.
