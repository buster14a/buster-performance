`faults-holes.py TREE [N]` is the list as the last round ran it: with no N it checks that every fault applies once,
with N it applies fault N in place and prints its name. A fault is one term changed alone. `local-round.sh` (the
cloud container's mutation tree) and `job-faults-holes.sh` (the 9700X, each build and each run its own hold of the
lock) apply each fault, build Develop and run `test-checker --seed 133 --part 5/8`; `tally.py ROUND.txt...` joins
the two machines' verdicts by fault.

| round | the code (`code.patch` on main `{{=v['before_revision']}}`) | faults | caught | survived | did not build |
| --- | --- | ---: | ---: | ---: | ---: |
| `round1/` | the two parts as first written | {{=n(v['faults']['round1']['total'])}} | {{=n(v['faults']['round1']['caught'])}} | {{=n(len(v['faults']['round1']['survived']))}} | {{=n(len(v['faults']['round1']['not_built']))}} |
| `round2/` | with the first round's lines and tests | {{=n(v['faults']['round2']['total'])}} | {{=n(v['faults']['round2']['caught'])}} | {{=n(len(v['faults']['round2']['survived']))}} | {{=n(len(v['faults']['round2']['not_built']))}} |
| `round3/` | **the code here** | {{=n(v['faults']['round3']['total'])}} | {{=n(v['faults']['round3']['caught'])}} | {{=n(len(v['faults']['round3']['survived']))}} | {{=n(len(v['faults']['round3']['not_built']))}} |

The first two rounds ran from the list's two ends at once (`cloud.txt`, `9700x.txt`), the third on the 9700X
alone. A mutant that did not build was a text the build refuses (a variable left unused, `x && !x`), written again
for the next round. Each round's list is its `faults.py`. The last round's survivors:
{{=join(['`%s`' % s for s in v['faults']['round3']['survived']])}}.
