# Pregraph constant operands on ordinary parent expressions

The [complete filtered source](implementation.patch) adds an explicit `--node-window-constants` mode. Three symmetric native Release rounds compare each mode against the same frozen [SQLite](sqlite/README.md) and [Buster compiler source](main/README.md). Every mode used `--lanes 1 -c` with actual artifact generation. The [historical source proof and correctness controls](../root-splice/pure-interior/README.md) describe the arithmetic cases selected for this production experiment.

This revision is an interim mechanism measurement. Its [full correctness campaign](correctness/) found 24 changes to secondary diagnostic notes in failed static assertions across tracked source and option combinations. The two timed translation units retained identical output. The failed assertion notes require a source change and renewed qualification before acceptance.

The selected mode improved paired wall and combined cycles on the same executable in all three rounds on each input. Against the independent pristine executable, only the compiler's own source had lower wall and cycles in every pair. The SQLite pristine comparison crossed zero in both metrics.
