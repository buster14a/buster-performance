Lua: 660 runs, 6 layouts, 11 rounds

### Lua's five scripts, time, ms

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 224.78 | 222.53 | 0.9900 |
| 1 | 219.57 | 223.15 | 1.0163 |
| 2 | 223.45 | 223.03 | 0.9981 |
| 3 | 229.10 | 223.64 | 0.9762 |
| 4 | 225.84 | 223.13 | 0.9880 |
| 5 | 221.70 | 222.99 | 1.0058 |

Mean ratio over the layouts 0.9956 (95% interval 0.9809 to 1.0106)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 24.05 | 23.92 | 0.9948 |
| tables | 45.09 | 44.66 | 0.9904 |
| strings | 51.44 | 52.08 | 1.0123 |
| arithmetic | 40.73 | 40.60 | 0.9968 |
| closures | 63.05 | 61.61 | 0.9772 |

### Lua's five scripts, user cycles, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 1231.56 | 1219.00 | 0.9898 |
| 1 | 1199.87 | 1221.41 | 1.0180 |
| 2 | 1222.11 | 1220.09 | 0.9983 |
| 3 | 1253.58 | 1223.24 | 0.9758 |
| 4 | 1235.96 | 1220.00 | 0.9871 |
| 5 | 1211.48 | 1218.63 | 1.0059 |

Mean ratio over the layouts 0.9957 (95% interval 0.9802 to 1.0115)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 132.63 | 131.89 | 0.9944 |
| tables | 242.98 | 240.56 | 0.9901 |
| strings | 278.81 | 282.51 | 1.0133 |
| arithmetic | 225.05 | 224.41 | 0.9971 |
| closures | 347.84 | 339.38 | 0.9757 |

### Lua's five scripts, user instructions, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 6006.69 | 5994.76 | 0.9980 |
| 1 | 6005.14 | 5994.59 | 0.9982 |
| 2 | 6006.39 | 5995.64 | 0.9982 |
| 3 | 6006.54 | 5994.73 | 0.9980 |
| 4 | 6005.24 | 5993.36 | 0.9980 |
| 5 | 6006.34 | 5995.71 | 0.9982 |

Mean ratio over the layouts 0.9981 (95% interval 0.9980 to 0.9982)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 675.68 | 675.68 | 1.0000 |
| tables | 1172.02 | 1172.05 | 1.0000 |
| strings | 1110.10 | 1100.82 | 0.9916 |
| arithmetic | 1468.12 | 1468.11 | 1.0000 |
| closures | 1580.55 | 1577.93 | 0.9983 |

speedtest1: 22 runs, one layout

| Metric | base | head | head / base | paired rounds' ratio, median (range) |
| --- | ---: | ---: | ---: | ---: |
| time, ms | 216.85 | 216.05 | 0.9963 | 0.9969 (0.9833 to 1.0094) |
| user cycles, M | 935.13 | 934.45 | 0.9993 | 0.9994 (0.9876 to 1.0046) |
| user instructions, M | 3199.35 | 3182.81 | 0.9948 | 0.9948 (0.9948 to 0.9948) |
