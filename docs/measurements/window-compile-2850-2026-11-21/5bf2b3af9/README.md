# Direct ordinary compilation on consecutive public mains

The parent faff3cc89 merged #3252. Its immediate public successor 5bf2b3af9 merged #3251. Each independently built native Release compiler runs the normal artifact driver on frozen SQLite and the compiler source. A third compiler from public main f0a204a9c provides a directly measured early baseline in the same three rounds. The adjacent mainline comparison isolates #3251; changes relative to f0a204a9c include all intervening commits.

| Input | Comparison | Cycles/token, median [min, max] | User instructions, median | True wall ms, median [min, max] |
| --- | --- | ---: | ---: | ---: |
| [SQLite](sqlite/README.md) | faff3cc89 minus f0a204a9c | −40.1420 [−41.0601, −38.8463] | -46,330,711.0 | −5.4910 [−5.5770, −5.3220] |
| [SQLite](sqlite/README.md) | 5bf2b3af9 minus faff3cc89 | −0.7482 [−0.9095, +4.0117] | +26.5 | +0.3985 [+0.2545, +0.7465] |
| [SQLite](sqlite/README.md) | 5bf2b3af9 minus f0a204a9c | −39.7558 [−40.8902, −37.0483] | -46,330,663.0 | −5.1785 [−5.2365, −4.5755] |
| [Buster compiler](main/README.md) | faff3cc89 minus f0a204a9c | −32.5887 [−36.0708, −32.2225] | -122,027,004.5 | −13.4380 [−17.0675, −12.0895] |
| [Buster compiler](main/README.md) | 5bf2b3af9 minus faff3cc89 | −131.3035 [−132.4777, −121.3447] | -1,033,544,334.5 | −55.8265 [−58.4730, −54.7855] |
| [Buster compiler](main/README.md) | 5bf2b3af9 minus f0a204a9c | −163.8922 [−164.7002, −157.4155] | -1,155,571,339.0 | −71.8530 [−71.9110, −67.9160] |

The [first public-main four-mode comparison](../faff3cc89/README.md) contains the independent regular and assignment option controls.
