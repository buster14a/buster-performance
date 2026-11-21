# Source qualification

All 4,116 direct parent and candidate translation-unit comparisons agreed on status, stdout, diagnostics and complete object bytes under default, `-Wall -Wextra`, and `-Weverything -Wno-c++-compat`. The frozen inputs were SQLite, Buster, 34 Lua units and 1,336 musl units. The eight registered checker shards passed 848,392 checks.

The generated warning differential also compared 9,240 functions, with 580 native policy pairs and 145 Clang reference comparisons. The registered driver fixtures matched pinned Clang in 144 policy cases.

[Per-unit digests, checker reports and comparison driver](checks.tar.gz)
