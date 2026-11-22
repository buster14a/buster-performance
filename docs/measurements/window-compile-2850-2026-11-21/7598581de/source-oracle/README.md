# Rejected precedence-interval compiler

The fresh SQLite parser returned identical roles and different parents for 20,016 of its 716,136 grammar tokens. At token 4,382 the expected parent was 4,389. The interval compiler left the local index 85. The same three-token mismatch recurred 256 tokens later because the x86 BZHI mask count uses its low eight bits. The compiler rejected SQLite at line 509, which the reference compiled to ELF. Its fourth checker shard also found a difference in x86 builtin diagnostic coverage. [Every differing parent](parent-differences.tsv.gz) · [Baseline debugger output](baseline-sqlite.log) · [Candidate debugger output](candidate-sqlite.log) · [Checker output](checker-shard-4.log)

The source under test was 7598581de49a3a61bb73ee06a7e6c75f73969a3e against 0e1d5b825801135bf50e79da9d546bc95209ab30. The controlled performance screen was withheld after the source failure. [Implementation](implementation.patch)
