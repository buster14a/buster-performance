Lua: 660 runs, 6 layouts, 11 rounds

### Lua's five scripts, time, ms

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 204.60 | 205.30 | 1.0034 |
| 1 | 204.88 | 204.67 | 0.9990 |
| 2 | 205.94 | 205.18 | 0.9963 |
| 3 | 206.51 | 207.07 | 1.0027 |
| 4 | 202.99 | 202.52 | 0.9977 |
| 5 | 205.86 | 205.50 | 0.9983 |

Mean ratio over the layouts 0.9996 (95% interval 0.9966 to 1.0026)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 19.87 | 19.84 | 0.9982 |
| tables | 42.89 | 42.59 | 0.9929 |
| strings | 50.01 | 50.11 | 1.0020 |
| arithmetic | 32.98 | 33.09 | 1.0035 |
| closures | 59.14 | 59.06 | 0.9988 |

### Lua's five scripts, user cycles, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 1118.86 | 1122.19 | 1.0030 |
| 1 | 1118.13 | 1117.51 | 0.9994 |
| 2 | 1123.31 | 1119.34 | 0.9965 |
| 3 | 1125.90 | 1129.59 | 1.0033 |
| 4 | 1106.29 | 1104.36 | 0.9983 |
| 5 | 1122.52 | 1120.72 | 0.9984 |

Mean ratio over the layouts 0.9998 (95% interval 0.9969 to 1.0027)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 109.16 | 108.93 | 0.9980 |
| tables | 230.75 | 229.36 | 0.9940 |
| strings | 270.77 | 271.58 | 1.0030 |
| arithmetic | 181.80 | 182.50 | 1.0039 |
| closures | 324.91 | 324.76 | 0.9995 |

### Lua's five scripts, user instructions, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 5400.83 | 5400.84 | 1.0000 |
| 1 | 5399.70 | 5399.79 | 1.0000 |
| 2 | 5400.45 | 5400.43 | 1.0000 |
| 3 | 5400.89 | 5400.83 | 1.0000 |
| 4 | 5402.67 | 5400.72 | 0.9996 |
| 5 | 5401.57 | 5401.40 | 1.0000 |

Mean ratio over the layouts 0.9999 (95% interval 0.9998 to 1.0001)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 607.97 | 607.97 | 1.0000 |
| tables | 1097.91 | 1097.89 | 1.0000 |
| strings | 1068.49 | 1068.46 | 1.0000 |
| arithmetic | 1145.58 | 1145.58 | 1.0000 |
| closures | 1480.80 | 1480.80 | 1.0000 |

speedtest1: 22 runs, one layout

| Metric | base | head | head / base | paired rounds' ratio, median (range) |
| --- | ---: | ---: | ---: | ---: |
| time, ms | 207.34 | 208.82 | 1.0071 | 1.0075 (0.9952 to 1.0217) |
| user cycles, M | 886.12 | 890.78 | 1.0053 | 1.0054 (0.9953 to 1.0121) |
| user instructions, M | 2960.20 | 2952.06 | 0.9973 | 0.9973 (0.9971 to 0.9973) |
