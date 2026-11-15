## speedtest1

| pad, bytes | rounds | default cycles, M | +unroll cycles, M | +unroll / default | default instructions, M | +unroll instructions, M | +unroll / default |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 0 | 7 | 736.99 | 744.08 | 1.0096 | 2558.30 | 2553.85 | 0.9983 |
| 528 | 7 | 734.67 | 743.91 | 1.0126 | 2558.30 | 2553.85 | 0.9983 |
| 1568 | 7 | 740.67 | 739.80 | 0.9988 | 2558.30 | 2553.85 | 0.9983 |
| 2608 | 7 | 741.57 | 741.17 | 0.9995 | 2558.30 | 2553.85 | 0.9983 |

Cycles, +unroll / default: mean over the placements 1.0051 (from 0.9988 to 1.0126)

## lua-arithmetic

| link order | rounds | default cycles, M | +unroll cycles, M | +unroll / default | default instructions, M | +unroll instructions, M | +unroll / default |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 0 | 7 | 157.96 | 157.64 | 0.9979 | 963.75 | 963.75 | 1.0000 |
| 1 | 7 | 157.73 | 155.61 | 0.9866 | 963.75 | 963.75 | 1.0000 |
| 2 | 7 | 153.41 | 154.24 | 1.0054 | 963.75 | 963.75 | 1.0000 |
| 3 | 7 | 156.64 | 159.84 | 1.0204 | 963.75 | 963.75 | 1.0000 |
| 4 | 7 | 155.66 | 156.65 | 1.0063 | 963.75 | 963.75 | 1.0000 |
| 5 | 7 | 156.80 | 157.16 | 1.0023 | 963.75 | 963.75 | 1.0000 |

Cycles, +unroll / default: mean over the placements 1.0032 (from 0.9866 to 1.0204)

## lua-calls

| link order | rounds | default cycles, M | +unroll cycles, M | +unroll / default | default instructions, M | +unroll instructions, M | +unroll / default |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 0 | 7 | 113.44 | 113.66 | 1.0019 | 521.19 | 525.00 | 1.0073 |
| 1 | 7 | 113.18 | 113.09 | 0.9992 | 521.19 | 525.00 | 1.0073 |
| 2 | 7 | 113.36 | 116.05 | 1.0237 | 521.19 | 525.00 | 1.0073 |
| 3 | 7 | 114.42 | 114.94 | 1.0045 | 521.19 | 525.00 | 1.0073 |
| 4 | 7 | 112.56 | 113.16 | 1.0053 | 521.19 | 525.00 | 1.0073 |
| 5 | 7 | 113.85 | 113.53 | 0.9971 | 521.19 | 525.00 | 1.0073 |

Cycles, +unroll / default: mean over the placements 1.0053 (from 0.9971 to 1.0237)

## lua-closures

| link order | rounds | default cycles, M | +unroll cycles, M | +unroll / default | default instructions, M | +unroll instructions, M | +unroll / default |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 0 | 7 | 297.14 | 287.19 | 0.9665 | 1355.42 | 1363.22 | 1.0058 |
| 1 | 7 | 291.06 | 288.42 | 0.9909 | 1356.33 | 1366.82 | 1.0077 |
| 2 | 7 | 288.10 | 289.93 | 1.0063 | 1359.92 | 1365.02 | 1.0037 |
| 3 | 7 | 285.82 | 292.99 | 1.0251 | 1355.42 | 1365.92 | 1.0077 |
| 4 | 7 | 292.85 | 285.50 | 0.9749 | 1357.22 | 1365.02 | 1.0057 |
| 5 | 7 | 308.22 | 287.23 | 0.9319 | 1357.22 | 1366.82 | 1.0071 |

Cycles, +unroll / default: mean over the placements 0.9826 (from 0.9319 to 1.0251)

## lua-strings

| link order | rounds | default cycles, M | +unroll cycles, M | +unroll / default | default instructions, M | +unroll instructions, M | +unroll / default |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 0 | 7 | 237.54 | 237.80 | 1.0011 | 989.75 | 989.02 | 0.9993 |
| 1 | 7 | 240.40 | 237.13 | 0.9864 | 989.54 | 988.85 | 0.9993 |
| 2 | 7 | 236.39 | 234.77 | 0.9931 | 989.37 | 988.77 | 0.9994 |
| 3 | 7 | 237.70 | 236.83 | 0.9963 | 989.74 | 989.09 | 0.9993 |
| 4 | 7 | 236.45 | 240.52 | 1.0172 | 989.70 | 989.10 | 0.9994 |
| 5 | 7 | 238.66 | 236.15 | 0.9895 | 989.50 | 988.78 | 0.9993 |

Cycles, +unroll / default: mean over the placements 0.9973 (from 0.9864 to 1.0172)

## lua-tables

| link order | rounds | default cycles, M | +unroll cycles, M | +unroll / default | default instructions, M | +unroll instructions, M | +unroll / default |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 0 | 7 | 198.47 | 197.41 | 0.9947 | 961.44 | 961.96 | 1.0005 |
| 1 | 7 | 200.52 | 198.40 | 0.9894 | 961.33 | 961.86 | 1.0006 |
| 2 | 7 | 196.25 | 197.05 | 1.0041 | 961.53 | 961.90 | 1.0004 |
| 3 | 7 | 195.32 | 194.76 | 0.9971 | 961.39 | 961.91 | 1.0005 |
| 4 | 7 | 196.09 | 199.55 | 1.0176 | 961.43 | 961.87 | 1.0005 |
| 5 | 7 | 197.28 | 196.95 | 0.9984 | 961.46 | 961.93 | 1.0005 |

Cycles, +unroll / default: mean over the placements 1.0002 (from 0.9894 to 1.0176)

