# K4 parent indices past the packed depth limit

For #3442, the reach probe ran the ordinary preprocessor and parser and recorded the token roles, node depths and final K4 parents. Lua, SQLite and musl stayed within the 2,047-depth packed range. The separate valid C fixture returns a parameter enclosed in 2,304 nested parentheses and reaches the production fallback.

| Input | Files | K4 calls | Parent indices | Deep calls | Deep indices | Maximum depth |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| lua | 34 | 34 | 571,903 | 0 | 0 | 22 |
| sqlite | 1 | 1 | 716,136 | 0 | 0 | 13 |
| musl | 1,336 | 1,336 | 5,039,561 | 0 | 0 | 12 |
| dense | 1 | 1 | 4,619 | 1 | 4,619 | 2,305 |

Seven candidate implementations were compared to the production scalar fallback on the locked Ryzen 7 9700X. Each reproduced every captured parent. A second oracle searches directly left and right for the nearest admissible key, applies the role's selection and resolves ties by operator level. It checks inputs through 129 tokens, including offsets near UINT32_MAX where a 32-bit depth-times-32 key wraps. All widths also run against the production fallback at its representable depths. Larger inputs include 16,384 tokens and use both rising and falling depths.

| Implementation | Shape and size cells at or below scalar | Median ratio | Maximum ratio |
| --- | ---: | ---: | ---: |
| Eight-lane full-width queries and block minima | 0/616 | 2.377 | 9.145 |
| Register stack tops, deferred scalar selection | 116/616 | 1.064 | 2.484 |
| Register stack tops, deferred vector selection | 25/616 | 1.275 | 11.326 |
| Gather role metadata, resolve on arrival | 53/616 | 1.123 | 3.189 |
| Gather role metadata, always store wide keys | 8/616 | 1.419 | 2.944 |
| Read packed role metadata, resolve on arrival | 194/616 | 1.040 | 2.095 |
| Read packed role metadata, always store wide keys | 4/616 | 1.343 | 1.805 |

Each cell is the median of three seeds, with seven alternating timing samples per seed. The seven shapes cover uniform depths 0, 2,047 and 2,048, monotone rises and falls, a rise followed by a fall, and mixed depths. Each seed verified 351,232 synthetic indices over 88 widths. The examined implementations still miss the per-size gate, so the scalar fallback remains on the production branch.

[Input generator, captured parent arrays, source, commands, independent oracle and all per-size samples](parent-depth-native.tar.xz)

## Searching each packet with minima for four, two and one neighbor

The vector query advances within each eight-lane packet past neighbors whose minimum is still above the requested threshold. A second version compares unanswered lanes to the minimum of the pending stack before searching it. The adjacent-lane versions use this check with a linear lane scan or first resolve an entire packet from adjacent neighbors. Each implementation preserves the full unsigned depth.

| Implementation | Cells at or below scalar | Median ratio | Slowest ratio |
| --- | ---: | ---: | ---: |
| Four-, two- and one-lane minima | 0/616 | 1.8763 | 5.6667 |
| Minima with a stack threshold check | 23/616 | 1.7179 | 5.6774 |
| Adjacent-lane scan with a stack threshold check | 0/616 | 2.2119 | 9.0484 |
| Try the immediate neighbor before the minima | 59/616 | 1.6679 | 3.4127 |

All four reproduced the recorded parent of every token across 1,372 real and generated parser calls, including the declaration at depth 2,305. Three seeds each checked 351,232 synthetic indices and the independent full-width oracle. All four still exceed the scalar time at some sizes.

[Implementations, independent oracle, replay checks and all three locked timing runs](packet-minima.tar.xz)
