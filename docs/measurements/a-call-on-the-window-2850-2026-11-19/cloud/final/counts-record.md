| | `sqlite3.c` | Lua | musl | the compiler's own source |
| --- | ---: | ---: | ---: | ---: |
| calls the kernel in place is to make | 12,921 | 4,182 | 8,586 | 16,877 |
| made | 12,883 | 4,182 | 8,556 | 16,876 |
| **with every argument's conversion** | **12,865 (99.57%)** | **4,131 (98.78%)** | **8,415 (98.01%)** | **14,150 (83.84%)** |
| of them plain | 12,865 | 4,131 | 8,179 | 12,815 |
| left to T for an argument | 0 | 0 | 25 | 0 |
| records and conversions that differ from T's | 0 | 0 | 0 | 0 |
| records the kernel in place is to make, and made | 250,825, 247,906 | 64,965, 62,855 | 198,338, 191,502 | 319,834, 310,953 |
| expressions the kernel placed and C ran on | 50,996 | 10,839 | 43,415 | 52,015 |
| **expressions decided on the window** | **43,876 (86.04%)** | **9,135 (84.28%)** | **37,304 (85.92%)** | **32,853 (63.16%)** |
| their records | 227,936 | 55,780 | 172,677 | 159,397 |
| of them refused, as C refuses them | 147 | 165 | 1,899 | 1,213 |
| expressions that differ from C's, and records | 0, 0 | 0, 0 | 0, 0 | 0, 0 |
| listed: a call | 18 | 47 | 157 | 2,107 |
| `&&`, `\|\|` or `?:` | 2,721 | 446 | 1,689 | 11,242 |
| an update | 3,535 | 795 | 3,902 | 5,325 |
| a comma or a selection | 150 | 370 | 42 | 0 |
| a division by a constant | 167 | 40 | 244 | 423 |
| a value the columns don't hold whole | 529 | 6 | 77 | 65 |
| another operator | 0 | 0 | 0 | 0 |
| strides read (asked of the type table) | 6,965 (0) | 1,074 (0) | 3,850 (5) | 12,897 (0) |
| rules that read T's two conversions | 0 | 0 | 128 | 140 |
| consumers and first operands read by loads | 1,356 | 192 | 351 | 2,481 |
| records swept | 321,488 | 91,270 | 377,187 | 557,944 |
