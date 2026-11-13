Lua: 660 runs, 6 layouts, 11 rounds

### Lua's five scripts, time, ms

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 212.34 | 206.40 | 0.9720 |
| 1 | 205.69 | 202.58 | 0.9849 |
| 2 | 205.08 | 204.83 | 0.9988 |
| 3 | 206.69 | 204.56 | 0.9897 |
| 4 | 203.11 | 203.35 | 1.0012 |
| 5 | 205.93 | 206.09 | 1.0008 |

Mean ratio over the layouts 0.9912 (95% interval 0.9791 to 1.0033)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 19.93 | 19.67 | 0.9867 |
| tables | 42.82 | 42.74 | 0.9981 |
| strings | 50.12 | 50.68 | 1.0113 |
| arithmetic | 32.99 | 31.09 | 0.9424 |
| closures | 59.21 | 59.94 | 1.0123 |

### Lua's five scripts, user cycles, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 1154.96 | 1118.76 | 0.9687 |
| 1 | 1117.84 | 1103.09 | 0.9868 |
| 2 | 1116.59 | 1114.50 | 0.9981 |
| 3 | 1125.32 | 1114.06 | 0.9900 |
| 4 | 1105.33 | 1105.85 | 1.0005 |
| 5 | 1122.28 | 1123.60 | 1.0012 |

Mean ratio over the layouts 0.9908 (95% interval 0.9779 to 1.0039)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 109.31 | 107.54 | 0.9839 |
| tables | 230.24 | 229.83 | 0.9982 |
| strings | 271.24 | 273.91 | 1.0099 |
| arithmetic | 181.56 | 170.71 | 0.9402 |
| closures | 324.09 | 328.89 | 1.0148 |

### Lua's five scripts, user instructions, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 5400.87 | 5396.69 | 0.9992 |
| 1 | 5399.69 | 5395.66 | 0.9993 |
| 2 | 5401.34 | 5396.37 | 0.9991 |
| 3 | 5401.82 | 5394.92 | 0.9987 |
| 4 | 5399.82 | 5394.02 | 0.9989 |
| 5 | 5403.25 | 5394.70 | 0.9984 |

Mean ratio over the layouts 0.9989 (95% interval 0.9986 to 0.9993)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 607.97 | 607.02 | 0.9984 |
| tables | 1097.87 | 1097.82 | 1.0000 |
| strings | 1068.46 | 1068.31 | 0.9999 |
| arithmetic | 1145.58 | 1142.09 | 0.9970 |
| closures | 1481.25 | 1480.03 | 0.9992 |

speedtest1: 22 runs, one layout

| Metric | base | head | head / base | paired rounds' ratio, median (range) |
| --- | ---: | ---: | ---: | ---: |
| time, ms | 206.75 | 207.20 | 1.0022 | 1.0064 (0.9895 to 1.0194) |
| user cycles, M | 881.89 | 886.41 | 1.0051 | 1.0050 (0.9957 to 1.0105) |
| user instructions, M | 2960.20 | 2956.73 | 0.9988 | 0.9988 (0.9988 to 0.9988) |
