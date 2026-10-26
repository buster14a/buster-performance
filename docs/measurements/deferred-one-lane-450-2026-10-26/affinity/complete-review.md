# Exact 31c4ced2 / 63844208 result: not accepted

All correctness gates passed. The coordinator verified 226 unchanged
identity hashes, 548 deferred and six supplemental generic processes with
zero exit failures. The eight actual measurement-lock holds lasted
37/25/2/2/4/5/5/4 seconds. Those process/identity results do not establish
timing acceptance.

SQLite whole-reader medians rose 121.20 -> 121.49 ns/token (+0.2393%) on one
lane and 105.94 -> 106.06 (+0.1133%) on eight; paired changes have mixed signs
(-1.3384%..+0.6601% and -0.7591%..+0.4059%). Dispatch fell 7013 -> 4439 ns
on one lane, about 36.7%, with zero wake time; the two-read approach leaves
roughly 4.4 us of dispatch. No whole-reader improvement is claimed.

`00182.c` (7,497 tokens) one-lane whole rises 85.94 -> 86.87 ns/token
(+1.0822%), with all five paired changes positive (+0.7738%..+2.4448%).
`00204.c` requested eight lanes, actually one, rises 91.84 -> 92.36
(+0.5662%), also all five paired changes positive (+0.0868%..+0.7513%).
Both source-order controls rise too, but normalization is not a waiver.
Other representative whole medians are mixed; full rows and the 219-program
sweep remain in affinity/summary.tsv. The sweep includes 00056.c (3,035
tokens, +2.005% one lane) and 00089.c (78 tokens, +7.229% adaptive), which
must be repeated rather than discarded as noise.

## Complete six-table generic review

All tables have matching CPU order, eight lane counts, 20,000 sync/broadcast
rounds, 1,250 pthread rounds, 21 measured passes after the existing warmup,
all four expected sections and exit zero. Main-table sleep counts are
identical (0 through 7 per pass). The unchanged benchmark uses cold startup
and collectives/arenas, not persistent-team hot dispatch.

The following latency rows increase in all three process pairs. Absolute
medians are medians of three printed process medians. Paired ranges use the
three within-round relative changes; printed rounding still applies.

| Metric | Baseline -> candidate | Median paired change | Paired range |
| --- | ---: | ---: | ---: |
| Four-lane sync | 109.9 -> 112.4 ns | +4.05% | +2.27%..+4.39% |
| Six-lane sync | 166.6 -> 174.4 ns | +1.55% | +1.35%..+4.68% |
| Eight-lane sync | 217.1 -> 222.2 ns | +3.04% | +0.55%..+7.03% |
| Eight-lane pthread barrier | 1848.6 -> 1866.0 ns | +0.94% | +0.70%..+1.46% |
| Eight-lane cold startup | 40.4 -> 42.7 us | +5.69% | +0.99%..+9.93% |

Other main-table latency rows have mixed signs or equal rounded values;
notable large swings include two-lane broadcast (23.5 -> 45.8 ns in round2),
three-lane pthread (913.4 -> 1629.5 ns in round1, then lower in rounds2/3),
and futex wake latencies varying between roughly 3 and 15 us. Four- and
eight-lane broadcast improve in all three pairs; one-lane broadcast changes
by just 0.1 ns on already tiny values. Zero one-lane sync/cold-start entries
do not support useful percentage ratios.

After-wait tables show unchanged/equal or mixed results for 200/1000 us,
with +0.06/+0.07 us wake increases in rounds1/3 and equal round2 values.
The 2000 us slowest-after penalty improves in every pair, but its median-after
changes -3.8/+4.0/+33.6 percentage points; 5000 us post-wait penalties change
from -26.2 points in round1 to small increases in rounds2/3. Wake at5000 us
falls in all three pairs. Calibration percentages are not absolute latency
ratios and cannot erase the consistently positive main-table observations.

All three balance workloads and all four rule/parts/full/half-speed columns
were reviewed: none has a strictly positive time change in all three pairs.
Many round1 times rise by about 0.2%..2%, while later pairs are mostly equal
or mixed. Efficiency changes are mostly 0..2 percentage points. All four
arena timings are mixed or equal across pairs; reserve/release is
1.92/1.48/1.85 -> 1.85/2.04/1.91 us. No stable arena improvement or RSS claim
follows.

The full six raw tables are retained. These observations are not attributed
causally to the affinity change without further evidence, and they do not
qualify the candidate. Exact source pair, generic scope and all repeated
regressions must remain explicit in the record.
