Lua: 660 runs, 6 layouts, 11 rounds

### Lua's five scripts, time, ms

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 203.75 | 205.81 | 1.0101 |
| 1 | 204.29 | 203.81 | 0.9977 |
| 2 | 203.59 | 201.87 | 0.9916 |
| 3 | 203.42 | 204.05 | 1.0031 |
| 4 | 204.80 | 204.84 | 1.0002 |
| 5 | 207.31 | 205.60 | 0.9918 |

Mean ratio over the layouts 0.9990 (95% interval 0.9916 to 1.0065)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 19.59 | 19.60 | 1.0005 |
| tables | 42.59 | 42.54 | 0.9988 |
| strings | 50.31 | 50.48 | 1.0032 |
| arithmetic | 32.16 | 32.55 | 1.0123 |
| closures | 59.25 | 59.04 | 0.9965 |

### Lua's five scripts, user cycles, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 1108.29 | 1117.84 | 1.0086 |
| 1 | 1112.10 | 1111.64 | 0.9996 |
| 2 | 1108.11 | 1099.58 | 0.9923 |
| 3 | 1108.32 | 1111.50 | 1.0029 |
| 4 | 1114.88 | 1117.28 | 1.0022 |
| 5 | 1131.35 | 1121.32 | 0.9911 |

Mean ratio over the layouts 0.9994 (95% interval 0.9924 to 1.0065)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 107.15 | 107.40 | 1.0024 |
| tables | 228.72 | 227.93 | 0.9966 |
| strings | 272.48 | 273.93 | 1.0053 |
| arithmetic | 176.80 | 179.01 | 1.0125 |
| closures | 325.24 | 323.55 | 0.9948 |

### Lua's five scripts, user instructions, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 5345.62 | 5345.63 | 1.0000 |
| 1 | 5345.38 | 5344.52 | 0.9998 |
| 2 | 5346.19 | 5344.43 | 0.9997 |
| 3 | 5343.72 | 5344.69 | 1.0002 |
| 4 | 5345.56 | 5345.54 | 1.0000 |
| 5 | 5345.33 | 5345.43 | 1.0000 |

Mean ratio over the layouts 1.0000 (95% interval 0.9998 to 1.0001)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 584.14 | 584.14 | 1.0000 |
| tables | 1087.62 | 1087.68 | 1.0001 |
| strings | 1068.13 | 1068.12 | 1.0000 |
| arithmetic | 1132.58 | 1132.58 | 1.0000 |
| closures | 1472.98 | 1472.53 | 0.9997 |

speedtest1: 22 runs, one layout

| Metric | base | head | head / base | paired rounds' ratio, median (range) |
| --- | ---: | ---: | ---: | ---: |
| time, ms | 205.03 | 206.64 | 1.0079 | 1.0089 (0.9628 to 1.0128) |
| user cycles, M | 883.28 | 887.12 | 1.0043 | 1.0030 (0.9956 to 1.0109) |
| user instructions, M | 2943.49 | 2940.98 | 0.9991 | 0.9991 (0.9991 to 0.9993) |
