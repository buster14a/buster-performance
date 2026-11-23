# benchmark-link, main against the branch

`benchmark-link --only direct --kinds dynamic,static --cpus 2`, each binary under its own lock hold, with its own
snapshots on tmpfs (`XDG_CACHE_HOME=/tmp/2546-claude/caches/lb-NAME`): [`raw/lb/lb-base-1.log`](raw/lb/lb-base-1.log)
and [`raw/lb/lb-fix2-1.log`](raw/lb/lb-fix2-1.log). The benchmark binds with `bind_begin`, which copies, and its
timings leave `link_check` out, so this branch should leave it as it was. The direct path's medians, µs:

| | main, round 1 | branch, round 1 | main, round 2 | branch, round 2 |
| --- | ---: | ---: | ---: | ---: |
| 1 worker, dynamic PIE | 19.7 | 19.7 | 19.4 | 19.5 |
| 1 worker, static executable | 299.1 | 297.5 | 296.8 | 298.1 |
| 2,000 workers, dynamic PIE | 100.0 | 100.1 | 100.1 | 99.5 |
| 2,000 workers, static executable | 381.2 | 381.8 | 379.8 | 382.9 |
| 102,400 workers, dynamic PIE | 7,549.9 | 7,555.7 | 7,535.4 | 7,602.6 |
| 102,400 workers, static executable | 8,430.3 | 8,523.1 | 8,464.1 | 8,526.2 |

Rounds ran in the order main, branch, main, branch ([`raw/lb/lb-base-2.log`](raw/lb/lb-base-2.log),
[`raw/lb/lb-fix2-2.log`](raw/lb/lb-fix2-2.log)). Every shape is within 1.1% between them, the large static executable's
0.7 to 1.1% in the branch's direction in both rounds; its link doesn't borrow or stage, so what the branch adds
there is the call to executable_chunk_borrows, which returns at once without a borrowed range.
