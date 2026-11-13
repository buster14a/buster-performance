Lua: 660 runs, 6 layouts, 11 rounds

### Lua's five scripts, time, ms

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 202.42 | 204.94 | 1.0124 |
| 1 | 204.97 | 202.81 | 0.9895 |
| 2 | 206.12 | 204.07 | 0.9901 |
| 3 | 205.32 | 202.91 | 0.9883 |
| 4 | 205.70 | 205.08 | 0.9970 |
| 5 | 208.08 | 205.55 | 0.9878 |

Mean ratio over the layouts 0.9941 (95% interval 0.9842 to 1.0042)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 19.86 | 19.76 | 0.9950 |
| tables | 42.44 | 42.88 | 1.0104 |
| strings | 50.62 | 50.11 | 0.9898 |
| arithmetic | 32.50 | 32.16 | 0.9892 |
| closures | 59.27 | 59.04 | 0.9960 |

### Lua's five scripts, user cycles, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 1107.23 | 1120.58 | 1.0121 |
| 1 | 1119.55 | 1107.64 | 0.9894 |
| 2 | 1125.42 | 1113.20 | 0.9891 |
| 3 | 1120.65 | 1107.31 | 0.9881 |
| 4 | 1122.69 | 1118.99 | 0.9967 |
| 5 | 1136.23 | 1121.91 | 0.9874 |

Mean ratio over the layouts 0.9938 (95% interval 0.9838 to 1.0038)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 109.16 | 108.75 | 0.9963 |
| tables | 228.02 | 230.86 | 1.0125 |
| strings | 274.63 | 271.34 | 0.9880 |
| arithmetic | 179.54 | 177.50 | 0.9887 |
| closures | 326.50 | 325.54 | 0.9971 |

### Lua's five scripts, user instructions, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 5611.86 | 5611.34 | 0.9999 |
| 1 | 5612.67 | 5613.80 | 1.0002 |
| 2 | 5611.63 | 5611.88 | 1.0000 |
| 3 | 5612.83 | 5612.27 | 0.9999 |
| 4 | 5614.70 | 5612.34 | 0.9996 |
| 5 | 5613.53 | 5612.94 | 0.9999 |

Mean ratio over the layouts 0.9999 (95% interval 0.9997 to 1.0001)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 640.39 | 640.39 | 1.0000 |
| tables | 1117.20 | 1117.18 | 1.0000 |
| strings | 1070.96 | 1071.24 | 1.0003 |
| arithmetic | 1279.81 | 1279.81 | 1.0000 |
| closures | 1504.40 | 1503.50 | 0.9994 |

speedtest1: 22 runs, one layout

| Metric | base | head | head / base | paired rounds' ratio, median (range) |
| --- | ---: | ---: | ---: | ---: |
| time, ms | 209.11 | 207.82 | 0.9938 | 0.9907 (0.9844 to 1.0207) |
| user cycles, M | 896.75 | 890.56 | 0.9931 | 0.9933 (0.9876 to 1.0023) |
| user instructions, M | 2989.79 | 2981.75 | 0.9973 | 0.9973 (0.9973 to 0.9974) |
