# An update's rows on the window (buster#2850's step 2), 2026-11-20

The evidence for the piece that makes an update's two rows (the node machine's X sweep's
`node_machine_update_first` and `node_machine_update_last`) on the front's window. The piece before it is
[x-rows-on-the-window-2850-2026-11-19](../x-rows-on-the-window-2850-2026-11-19/), and the census its specification
reads again is [x-rows-census-2850-2026-11-19](../x-rows-census-2850-2026-11-19/).

## 1. Before the specification (`before/`)

One count, on the piece before's code (`before/count.patch` on main `903bf7ef4`: that piece's source and, in its
shadow's count of the listed expressions, a line of counts at exit): of the expressions the rows list first for an
update, which have another record that lists them, and what their updates are. A Develop build on the 9700X
(`before/dev-xr-develop.sh`), then `measure-node-machine --shadow --passes 0 --window-rows` on `sqlite3.c`, Lua and
musl, CPU 2, each run its own hold of the lock (`before/dev-xr-corpora.sh`); `before/9700x-count.txt` has the lines,
musl's first and then the three's in the corpora's order.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| listed for X, first for an update | 3,394 | 742 | 3,530 |
| of them with an operator evaluated as branches too | 13 | 4 | 15 |
| with a refused conversion or a constant to a floating class too | 0 | 0 | 0 |
| with updates alone | 3,381 | 738 | 3,515 |
| of those, with a postfix update through an address | 438 | 115 | 80 |
| of those, with a bool's update | 0 | 0 | 0 |
| their updates | 3,428 | 743 | 3,556 |
| by name; of them postfix | 2,134; 1,399 | 527; 389 | 3,174; 1,214 |
| through an address: prefix; postfix | 856; 438 | 101; 115 | 302; 80 |
| a pointer's | 445 | 322 | 618 |
| `++` and `--` | 2,025 | 524 | 1,383 |

An update is by name where its first operand's record is a name's value, a pointer's and a bool's by its own
record's type's facts, and postfix by its operator.
