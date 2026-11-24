# Three behaviours of the direct path on main `1c5287c3`, found while profiling it

Each file is compiled with the driver's default `-c`, linked with `cc` and run.

| file | main `1c5287c3` | the branch | `--no-direct` |
| --- | --- | --- | --- |
| `exp.c` (`double floor_value = 1e-6; return floor_value < 0;`) | exits 1: the 64-byte loop lexes the exponent's sign as an operator, `1e - 6` | exits 0 | exits 0 |
| `at.c` (`int value = 1 @ ` + a backquote + ` ;`) | exit status 0, an object written: the loop passes a character with no token kind as whitespace | `error: expected ';' at end of declaration`, status 1 | the same error |
| `date.c` (`puts(__DATE__ " " __TIME__)`) | prints `Nov 24 2026 00:00:00` whenever it is compiled | the same (not changed) | the build's date and time |

`exp.c` is why `sqlite3.c` with `-DSQLITE_ENABLE_FTS5` is the one object of 6,201 that differs between main and the
branch.
