# Pregraph constant operands on ordinary parent expressions

The [complete filtered source](implementation.patch) adds an explicit `--node-window-constants` mode. Seven symmetric native Release rounds compare each mode against the same frozen [SQLite](sqlite/README.md) and [Buster compiler source](main/README.md). Every mode used `--lanes 1 -c` with actual artifact generation. The [historical source proof and correctness controls](../root-splice/pure-interior/README.md) describe the arithmetic cases selected for this production experiment.

[PR #3247](https://github.com/buster14a/buster/pull/3247) retains the written operand needed for static assertion diagnostics. On Buster itself, all seven pairs confirmed a lower wall time and total cycles with constants enabled, against both independent parent and same-image controls. SQLite produced fewer retired instructions in each pair, with wall and total-cycle ranges crossing zero on both controls. The median SQLite effects were increases.
