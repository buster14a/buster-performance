# Source-owned checked functions through native object emission

Revision `387855378dfdf01a5ec7552bb971544aefb94319` extends the mixed source publication in `4c775cc4b`. The producer retains the translation unit’s object handles and declaration-token inventory between function-local checks. It derives direct access to functions defined in the unit before local machine encoding. The statement-expression reader retains ownership of its regions, and the local program preserves C’s implicit zero return for main.

Both complete frozen ELF objects match ordinary compilation. A zero-persistent-node nine-function executable and a mixed eleven-function executable also match ordinary ELF, Clang execution, call side effects and unreachable-call counts. [Object and residency counts](units.tsv)

For every selected SQLite source body, the independent machine comparison includes all typed and call entries, machine records, branch counts, encoded bytes, and final fixups with original object handles. All 1,212 match, comprising 51,414 typed operations, 3,554 branches, 138,937 bytes and 2,101 fixups. [Each function](per-function-machine-comparison.tsv) [Raw output and commands](per-function-raw.tar.gz)

The checker translation unit in these diagnostic builds uses -O0 alongside the ordinary optimized driver. The focused 25-source, three-policy comparison found suppressed diagnostics for one unsequenced update under all three policies. The source publication is experimental. [Per-policy comparison](focused-language-policies.tsv) [Patch above the control producer](source.patch) [Current delta](preparation.patch)
