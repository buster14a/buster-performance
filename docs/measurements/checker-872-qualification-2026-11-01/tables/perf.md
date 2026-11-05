`perf stat -r 3 -e instructions:u,cycles:u`, pinned to CPU 2, over `benchmark-checker-deferred --lanes 1`:
`--passes 24` for `00204.c` and `--passes 6` for `sqlite3.c`. Each count is the median of three runs, whose
relative spread was at most 0.54% (the instructions' at most 0.00%).

| Tree | Unit | Instructions | Cycles | Instructions vs base | Cycles vs base |
| --- | --- | ---: | ---: | ---: | ---: |
| `base` | `00204.c` | 564,731,033 | 165,462,790 | +0.00% | +0.00% |
| `base` | `sqlite.c` | 10,141,280,543 | 5,386,555,040 | +0.00% | +0.00% |
| `m754` | `00204.c` | 586,322,197 | 183,979,410 | +3.82% | +11.19% |
| `m754` | `sqlite.c` | 10,553,039,220 | 5,588,069,177 | +4.06% | +3.74% |
| `end` | `00204.c` | 586,510,841 | 187,706,687 | +3.86% | +13.44% |
| `end` | `sqlite.c` | 10,569,149,015 | 5,607,872,903 | +4.22% | +4.11% |
| `p965` | `00204.c` | 588,056,552 | 186,376,710 | +4.13% | +12.64% |
| `p965` | `sqlite.c` | 10,756,709,969 | 5,649,688,576 | +6.07% | +4.89% |
| `p969` | `00204.c` | 586,255,603 | 184,557,534 | +3.81% | +11.54% |
| `p969` | `sqlite.c` | 10,737,863,536 | 5,655,993,368 | +5.88% | +5.00% |
| `p973` | `00204.c` | 586,257,538 | 184,475,389 | +3.81% | +11.49% |
| `p973` | `sqlite.c` | 10,737,879,533 | 5,642,400,342 | +5.88% | +4.75% |
| `p968` | `00204.c` | 590,265,421 | 187,958,541 | +4.52% | +13.60% |
| `p968` | `sqlite.c` | 10,826,447,115 | 5,703,274,946 | +6.76% | +5.88% |
| `pre980` | `00204.c` | 590,338,870 | 184,733,181 | +4.53% | +11.65% |
| `pre980` | `sqlite.c` | 10,826,558,208 | 5,685,506,869 | +6.76% | +5.55% |
| `fix980` | `00204.c` | 589,159,522 | 182,439,361 | +4.33% | +10.26% |
| `fix980` | `sqlite.c` | 10,820,537,743 | 5,637,599,823 | +6.70% | +4.66% |
| `p1002` | `00204.c` | 599,325,312 | 192,852,745 | +6.13% | +16.55% |
| `p1002` | `sqlite.c` | 10,984,909,464 | 5,686,133,205 | +8.32% | +5.56% |
| `main` | `00204.c` | 599,325,528 | 192,031,101 | +6.13% | +16.06% |
| `main` | `sqlite.c` | 10,984,777,220 | 5,736,645,395 | +8.32% | +6.50% |

The post-range checkpoints are cumulative from `d11a91d2`. `p965` (`693926a7`) is 114 first-parent merges
later (the interval ends with #965 and includes #927's implicit library declarations and #966's library
builtins); `p969` is 1 merge after it, `p973` 6, `p968` 6 and `pre980` 5 (the interval to `pre980` is 132
merges in all); `fix980` is #980, 1 merge after its parent; `p1002` is 13 merges after the fix; and `main`
is 2 after `p1002`.
