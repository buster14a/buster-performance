Lua: 660 runs, 6 layouts, 11 rounds

### Lua's five scripts, time, ms

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 222.86 | 223.34 | 1.0022 |
| 1 | 226.34 | 221.66 | 0.9793 |
| 2 | 222.89 | 222.35 | 0.9976 |
| 3 | 223.35 | 221.95 | 0.9937 |
| 4 | 222.94 | 225.38 | 1.0109 |
| 5 | 222.97 | 222.84 | 0.9994 |

Mean ratio over the layouts 0.9971 (95% interval 0.9862 to 1.0082)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 24.00 | 23.77 | 0.9904 |
| tables | 44.63 | 44.52 | 0.9974 |
| strings | 51.95 | 51.72 | 0.9956 |
| arithmetic | 40.70 | 40.32 | 0.9905 |
| closures | 62.55 | 62.30 | 0.9960 |

### Lua's five scripts, user cycles, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 1219.60 | 1222.13 | 1.0021 |
| 1 | 1237.34 | 1210.61 | 0.9784 |
| 2 | 1217.76 | 1215.36 | 0.9980 |
| 3 | 1220.12 | 1212.23 | 0.9935 |
| 4 | 1217.46 | 1231.68 | 1.0117 |
| 5 | 1218.36 | 1216.84 | 0.9988 |

Mean ratio over the layouts 0.9970 (95% interval 0.9855 to 1.0087)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 132.02 | 130.92 | 0.9917 |
| tables | 240.81 | 239.44 | 0.9943 |
| strings | 281.20 | 279.79 | 0.9950 |
| arithmetic | 224.91 | 222.71 | 0.9902 |
| closures | 343.91 | 342.97 | 0.9973 |

### Lua's five scripts, user instructions, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 5997.38 | 5998.96 | 1.0003 |
| 1 | 5995.77 | 5996.02 | 1.0000 |
| 2 | 5992.98 | 5997.23 | 1.0007 |
| 3 | 5997.41 | 5997.58 | 1.0000 |
| 4 | 5997.37 | 5995.08 | 0.9996 |
| 5 | 5999.79 | 5996.01 | 0.9994 |

Mean ratio over the layouts 1.0000 (95% interval 0.9995 to 1.0005)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 675.68 | 675.68 | 1.0000 |
| tables | 1172.11 | 1172.03 | 0.9999 |
| strings | 1100.83 | 1101.12 | 1.0003 |
| arithmetic | 1468.12 | 1468.11 | 1.0000 |
| closures | 1580.52 | 1579.87 | 0.9996 |

speedtest1: 22 runs, one layout

| Metric | base | head | head / base | paired rounds' ratio, median (range) |
| --- | ---: | ---: | ---: | ---: |
| time, ms | 215.63 | 213.84 | 0.9917 | 0.9930 (0.9762 to 1.0072) |
| user cycles, M | 933.17 | 922.76 | 0.9888 | 0.9903 (0.9761 to 0.9938) |
| user instructions, M | 3182.81 | 3172.46 | 0.9967 | 0.9967 (0.9967 to 0.9968) |
