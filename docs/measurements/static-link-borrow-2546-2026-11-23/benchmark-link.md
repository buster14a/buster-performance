# benchmark-link, main against the branch

`benchmark-link --only direct --kinds dynamic,static --cpus 2`, each binary under its own lock hold, with its own
snapshots on tmpfs (`XDG_CACHE_HOME=/tmp/2546-claude/caches/lb-NAME`): [`raw/lb/lb-base-1.log`](raw/lb/lb-base-1.log)
and [`raw/lb/lb-fix2-1.log`](raw/lb/lb-fix2-1.log). The benchmark binds with `bind_begin`, which copies, and its
timings leave `link_check` out, so this branch should leave it as it was. The direct path's medians, µs:

| | main (`base`) | the branch (`fix2`) |
| --- | ---: | ---: |
| 1 worker, dynamic PIE | 19.7 | 19.7 |
| 1 worker, static executable | 299.1 | 297.5 |
| 2,000 workers, dynamic PIE | 100.0 | 100.1 |
| 2,000 workers, static executable | 381.2 | 381.8 |
| 102,400 workers, dynamic PIE | 7,549.9 | 7,555.7 |
| 102,400 workers, static executable | 8,430.3 | 8,523.1 |

A second round of each was queued after these, and its logs are added here if it completes.
