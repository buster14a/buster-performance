Lua: 660 runs, 6 layouts, 11 rounds

### Lua's five scripts, time, ms

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 204.37 | 203.74 | 0.9969 |
| 1 | 207.39 | 205.21 | 0.9895 |
| 2 | 204.14 | 204.21 | 1.0003 |
| 3 | 204.44 | 204.29 | 0.9993 |
| 4 | 203.03 | 205.11 | 1.0102 |
| 5 | 208.07 | 206.30 | 0.9915 |

Mean ratio over the layouts 0.9979 (95% interval 0.9902 to 1.0057)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 19.58 | 19.58 | 1.0000 |
| tables | 42.76 | 42.38 | 0.9913 |
| strings | 50.61 | 50.64 | 1.0006 |
| arithmetic | 31.06 | 32.25 | 1.0385 |
| closures | 60.02 | 59.54 | 0.9920 |

### Lua's five scripts, user cycles, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 1111.63 | 1109.46 | 0.9980 |
| 1 | 1131.75 | 1117.35 | 0.9873 |
| 2 | 1111.89 | 1111.97 | 1.0001 |
| 3 | 1114.10 | 1112.92 | 0.9989 |
| 4 | 1106.41 | 1117.48 | 1.0100 |
| 5 | 1135.11 | 1124.74 | 0.9909 |

Mean ratio over the layouts 0.9975 (95% interval 0.9892 to 1.0058)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 107.24 | 107.08 | 0.9985 |
| tables | 230.20 | 227.83 | 0.9897 |
| strings | 274.40 | 274.23 | 0.9994 |
| arithmetic | 170.70 | 177.11 | 1.0376 |
| closures | 329.87 | 326.73 | 0.9905 |

### Lua's five scripts, user instructions, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 5394.05 | 5346.54 | 0.9912 |
| 1 | 5394.83 | 5346.31 | 0.9910 |
| 2 | 5394.50 | 5346.09 | 0.9910 |
| 3 | 5396.71 | 5346.53 | 0.9907 |
| 4 | 5395.85 | 5343.84 | 0.9904 |
| 5 | 5392.96 | 5344.44 | 0.9910 |

Mean ratio over the layouts 0.9909 (95% interval 0.9906 to 0.9912)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 607.02 | 584.14 | 0.9623 |
| tables | 1097.83 | 1087.65 | 0.9907 |
| strings | 1068.31 | 1068.18 | 0.9999 |
| arithmetic | 1142.09 | 1132.58 | 0.9917 |
| closures | 1479.58 | 1473.87 | 0.9961 |

speedtest1: 22 runs, one layout

| Metric | base | head | head / base | paired rounds' ratio, median (range) |
| --- | ---: | ---: | ---: | ---: |
| time, ms | 206.48 | 206.62 | 1.0007 | 1.0009 (0.9840 to 1.0129) |
| user cycles, M | 884.14 | 886.27 | 1.0024 | 1.0020 (0.9964 to 1.0097) |
| user instructions, M | 2947.21 | 2943.49 | 0.9987 | 0.9987 (0.9987 to 0.9987) |
