# Dataflow's sweep search against both solvers (#2924, phase C3)

`dataflow_sweeps_test.c`'s search gives, without a fixpoint, the sweep in which the solver first sets each live bit,
and from it the solver's exact iteration count. Before the scalar twin goes, the search was checked against both
solvers on main `8bd7f27ec`, with [`c3-oracle.patch`](c3-oracle.patch) applied:
- the search's `in`-row check and count, beside the twin comparison, in `test-dataflow`;
- the search in IR dataflow's per-function test, which `test-ir-source` runs on every form.

Every check passed. The formula's count equalled both solvers' on every graph and form:

| Where | What | Failures |
| --- | --- | --- |
| 9700X ([`oracle.sh`](oracle.sh), Develop, under the lock) | `test-ir-source` on sqlite3.c: 7,806 forms, 62,448 dataflow checks | 0 (`oracle/ir-sqlite.log.xz`) |
| 9700X | `test-dataflow --seed 11..18 --count 64` | 0 (`oracle/test-dataflow.log`) |
| Cloud container, same patch | `test-dataflow --seed` 1, 2, 3, 7, 133, 999, 123456789, and `--seed 5 --count 200` | 0 |
| Cloud container | `test-ir-source` on c-testsuite's subset (1,290 forms) and `tests/dataflow/edges.c` (12 forms) | 0 |
| Cloud container | `test-ir-source --dataflow-self-test` | 0 |

On the container, the later layout check also passed on the c-testsuite forms, `edges.c` and the self-test. That
check reads IR dataflow's successor columns, postorder and phi records from the IR.

`test-dataflow` took 0.7 to 1.0 s on the container with the search, against main's 0.2 s warm.
