| | `sqlite3.c` | Lua | musl | the compiler's own source |
| --- | ---: | ---: | ---: | ---: |
| calls the kernel in place is to make | 12,921 | 4,182 | 8,586 | 16,877 |
| made | 12,883 | 4,182 | 8,556 | 16,876 |
| **with every argument's conversion** | **12,865 (99.57%)** | **4,131 (98.78%)** | **8,415 (98.01%)** | **14,150 (83.84%)** |
| of them plain | 12,865 | 4,131 | 8,179 | 12,815 |
| left to T for an argument | 0 | 0 | 25 | 0 |
| records and conversions that differ from T's | 0 | 0 | 0 | 0 |
| **expressions decided on the window** | **43,876 (86.04%)** | **9,135 (84.28%)** | **37,304 (85.92%)** | **32,853 (63.16%)** |
| of them refused, as C refuses them | 147 | 165 | 1,899 | 1,213 |
| differ from C | 0 | 0 | 0 | 0 |
| listed for a call | 18 | 47 | 157 | 2,107 |
