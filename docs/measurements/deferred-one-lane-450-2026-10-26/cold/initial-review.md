# Exact 35f26f68 / 1d2b12c6 cold-call review

Review before the predeclared full-corpus repeat; no performance acceptance
or publication is claimed. Production source remains frozen at
`1d2b12c658807f466b989bcdfe2cdf548c1812d5`.

## Initial campaign

The coordinator validates 226 unchanged identity hashes, 568 independent
processes with exit zero and five actual lock holds of 37/24/1/2/3 seconds.
The full rows/summary are retained under cold/. Correctness and successful
process receipts are distinct from timing acceptance.

SQLite whole medians are 120.29 -> 119.66 ns/token (-0.5237%) for one lane,
all five paired changes negative (-0.8064%..-0.1917%); adaptive eight is
104.09 -> 103.84 (-0.2402%), with mixed paired signs (-0.7550%..+0.1442%).
One-lane dispatch falls 7204 -> 391 ns (about 94.6%); small cases are
30..40 ns. One-lane wake is zero and actual lane/copy counts are preserved.
Eight-lane SQLite dispatch is 14718 -> 14958 ns, with wake 19296 -> 19025 ns;
no multi-lane dispatch improvement is claimed. Source-order SQLite also
falls 102.30 -> 101.94 ns/token. No decomposition attributes the entire
whole-reader improvement solely to the removed affinity calls.

Of the 26 repeated requested-lane rows, six have positive build-median
whole changes: 00038/adaptive, 00062/one, 00066/one, 00075/adaptive and both
00213 readings. None has all five paired whole changes positive. Notably:

- 00066.c, 26 tokens: one lane rises 1764.08 -> 1803.77 ns/token (+2.2499%),
  about +1.032 us per reading from printed values. Its paired signs are
  negative in rounds1/4 and positive in2/3/5, range -1.5993%..+3.4584%,
  paired median +2.1168%. The adaptive reading's median falls 4.4759% but
  has a wide mixed range. This remains unresolved, not waived as tiny.
- 00056.c, 3035 tokens: repeated one/adaptive medians fall 1.4371%/1.1433%,
  and every paired whole change is lower; its single-sweep observations
  below have the opposite sign and are retained.
- Both readings of 00182, 00204, 00169 and 00200 are lower in all five
  pairs. One-lane 00075 and 00089 are also lower in every pair. The other
  repeated readings have mixed signs. Controls/normalized ratios do not
  override any whole-reading result.

## Complete single-sweep >2% inventory

Sorting all 438 requested-lane sweep rows finds exactly 36 above +2%,
spanning 26 source units. All actually use one lane/copy in both builds.
Thirty-four rows are small (9..184 tokens), and the only two larger rows
are both requests for the same 3035-token 00056.c. A dash means the other
request is not above +2% in this screen, not missing or excluded data.

| Unit | Tokens | One-lane change % | Adaptive-request change % |
| --- | ---: | ---: | ---: |
| 00014.c | 32 | — | +3.0877 |
| 00021.c | 32 | +3.8015 | +2.5302 |
| 00025.c | 29 | +2.4268 | — |
| 00029.c | 24 | +3.7474 | +4.7750 |
| 00033.c | 143 | +6.4733 | +7.5349 |
| 00034.c | 99 | — | +4.1091 |
| 00056.c | 3035 | +2.5833 | +2.4269 |
| 00058.c | 102 | +2.8924 | — |
| 00063.c | 14 | +6.9473 | +7.6268 |
| 00067.c | 14 | +6.7490 | +6.9796 |
| 00069.c | 14 | +2.3346 | — |
| 00075.c | 9 | — | +2.1082 |
| 00083.c | 141 | — | +3.0782 |
| 00087.c | 45 | +4.1378 | +2.0489 |
| 00099.c | 33 | +2.0204 | — |
| 00101.c | 23 | +4.7319 | — |
| 00105.c | 32 | +3.4891 | +5.2899 |
| 00110.c | 16 | +3.1969 | — |
| 00118.c | 23 | — | +2.1723 |
| 00119.c | 16 | +5.9348 | +4.1529 |
| 00121.c | 54 | — | +2.9301 |
| 00126.c | 45 | +2.5877 | — |
| 00133.c | 112 | — | +2.4146 |
| 00135.c | 95 | +2.2947 | — |
| 00139.c | 17 | +3.7011 | +3.8847 |
| 00210.c | 184 | +2.2710 | — |

The next sorted row is 00061 adaptive +1.9409%, confirming the threshold
boundary. Largest relative increase is 00063 adaptive, about +3.045 us
per reading. 00033 adaptive adds about +4.597 us. Larger 00056 adds about
6.798/6.374 us in the screen. Printed rounding is far too small to explain
those differences, and their size is not a reason to discard them.

## Independent native code-shape check

Read-only SHA-256/nm/objdump of the non-executable copied native images
matches the recorded baseline f6f6b58e... and candidate 9e5b3612... hashes.
Native common text is 0x12dde -> 0x12dfe (+32 bytes), with 0x808 stack
allocation in both; callback text is 0x65fb in both. The checker lane_run
changes 0x761 -> 0x387, with a separate existing cold function of 0x428:
combined native text grows 78 bytes (the local +97-byte observation was a
different target). Its stack allocation changes 0x2380 -> 0x138; the cold
utility owns the 0x2380 allocation. The other eight lane_run copies retain
their sizes.

Native check_input_run explicitly compares active count with one, loads
count1 and NULL CPUs, and calls the separate cold symbol at 0x1140260;
the other branch retains lane_run at0x1146c90 with the original CPU pointer.
No new annotation or context spills into the common frame were required.
This corroborates the mechanism; it does not independently accept timings.

## Supplemental experimental design assessment

Repeat all 219 eligible corpus units for five complete independent paired
rounds, with unchanged 24-pass commands and CPU/header/predefine options.
Alternate build order by unit and round, retain each unit in its own
process, include favorable and adverse original units alike, and omit a
duplicate SQLite campaign. This is a sound predeclared extension before
acceptance: it resolves the whole screen rather than selecting only cases
that happen to reverse sign. Retain every original observation.

Treat the new five-round corpus dataset separately from the original
13-unit campaign and one-pair screen. Compare all 438 requested-lane
results, reporting adverse medians/ranges and any consistently positive
paired changes. No source-order normalization waiver, selective removal,
threshold relaxation or post-hoc pooling is justified. Five repeats across
many endpoints are not a manufactured confidence interval; interpretation
must retain effect magnitudes and all pair values.

The design adds 2190 independent processes / 4380 raw reading rows. Raising
the existing reader's MAX_ROWS from4096 to8192 alone is sufficient;
MAX_ROUNDS16 and the fixed five-pair validation already fit. Use existing
paired-ROUND-UNIT names and a separate input directory, avoiding duplicate
keys with the original repeated cases. Keep all parsing/statistical logic
unchanged. Root alone schedules the actual bounded shared-lock hold, checks
its timeout/cleanup and validates post-campaign provenance.
