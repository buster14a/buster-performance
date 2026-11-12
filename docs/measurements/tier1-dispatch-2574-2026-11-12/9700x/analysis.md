Lua: 660 runs, 6 layouts, 11 rounds

### Lua's five scripts, time, ms

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 221.35 | 221.46 | 1.0005 |
| 1 | 219.86 | 220.04 | 1.0008 |
| 2 | 222.94 | 223.67 | 1.0033 |
| 3 | 222.21 | 223.28 | 1.0048 |
| 4 | 227.05 | 221.93 | 0.9774 |
| 5 | 221.89 | 223.81 | 1.0087 |

Mean ratio over the layouts 0.9992 (95% interval 0.9875 to 1.0110)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 24.11 | 23.80 | 0.9869 |
| tables | 45.00 | 44.64 | 0.9920 |
| strings | 51.41 | 51.29 | 0.9977 |
| arithmetic | 40.69 | 40.28 | 0.9899 |
| closures | 61.31 | 62.22 | 1.0148 |

### Lua's five scripts, user cycles, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 1209.61 | 1211.12 | 1.0012 |
| 1 | 1198.98 | 1200.41 | 1.0012 |
| 2 | 1217.34 | 1221.18 | 1.0032 |
| 3 | 1213.19 | 1217.30 | 1.0034 |
| 4 | 1239.89 | 1212.73 | 0.9781 |
| 5 | 1210.52 | 1221.42 | 1.0090 |

Mean ratio over the layouts 0.9993 (95% interval 0.9879 to 1.0108)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 132.54 | 130.67 | 0.9858 |
| tables | 242.48 | 240.42 | 0.9915 |
| strings | 278.06 | 277.42 | 0.9977 |
| arithmetic | 224.72 | 222.42 | 0.9898 |
| closures | 337.08 | 342.16 | 1.0151 |

### Lua's five scripts, user instructions, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 6007.84 | 5970.22 | 0.9937 |
| 1 | 6006.54 | 5970.18 | 0.9939 |
| 2 | 6005.13 | 5968.64 | 0.9939 |
| 3 | 6004.10 | 5966.42 | 0.9937 |
| 4 | 6005.42 | 5969.08 | 0.9939 |
| 5 | 6003.74 | 5966.25 | 0.9938 |

Mean ratio over the layouts 0.9938 (95% interval 0.9937 to 0.9940)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 675.68 | 667.10 | 0.9873 |
| tables | 1172.04 | 1165.84 | 0.9947 |
| strings | 1110.18 | 1109.89 | 0.9997 |
| arithmetic | 1468.11 | 1449.20 | 0.9871 |
| closures | 1579.25 | 1576.85 | 0.9985 |

speedtest1: 22 runs, one layout

| Metric | base | head | head / base | paired rounds' ratio, median (range) |
| --- | ---: | ---: | ---: | ---: |
| time, ms | 215.71 | 216.49 | 1.0036 | 1.0036 (0.9823 to 1.0099) |
| user cycles, M | 932.02 | 936.30 | 1.0046 | 1.0046 (0.9973 to 1.0075) |
| user instructions, M | 3199.35 | 3195.50 | 0.9988 | 0.9988 (0.9988 to 0.9988) |
