# Certified neutral subtrees in the program reference walker

The [private source](implementation.patch) applies to public main 325883abf. It computes a 16-lane mask of leaf and derived nodes that the ordinary reference walker can skip. Every timed process compiles the whole input with ordinary artifact output. On and off select the same candidate executable by setting NODE_REF_WINDOW=1 or leaving it unset. The baseline is an independent unmodified public compiler.

| Input | Comparison | Total cycles/token, median [range] | User instructions, median | True elapsed ms, median [range] |
| --- | --- | ---: | ---: | ---: |
| [SQLite](sqlite/README.md) | off minus baseline | −2.9396 [−3.6891, −1.4912] | +976,444.0 | −0.9725 [−1.4365, −0.6365] |
| [SQLite](sqlite/README.md) | on minus off | +0.2415 [−0.8838, +0.4476] | -7,305,282.5 | +0.4295 [+0.2160, +1.0725] |
| [SQLite](sqlite/README.md) | on minus baseline | −3.2415 [−3.8234, −1.2498] | -6,328,828.0 | −0.4205 [−0.5430, −0.3640] |
| [Buster compiler](main/README.md) | off minus baseline | −2.8656 [−6.3839, −0.9739] | +1,769,159.5 | −2.0965 [−3.4860, −0.5435] |
| [Buster compiler](main/README.md) | on minus off | +0.7399 [+0.5015, +0.7665] | -16,886.0 | +0.7885 [−1.5955, +4.5895] |
| [Buster compiler](main/README.md) | on minus baseline | −2.1257 [−5.6174, −0.4723] | +1,746,410.5 | +0.2450 [−5.0815, +2.4930] |

The additional untimed off/on compilations produced byte-identical program reference, region and object-retention witnesses on [SQLite](sqlite/checked-witness.sha256) and [Buster](main/checked-witness.sha256). The [SQLite](sqlite/reference-proof.txt) and [compiler](main/reference-proof.txt) counts were collected separately from every timed process.
