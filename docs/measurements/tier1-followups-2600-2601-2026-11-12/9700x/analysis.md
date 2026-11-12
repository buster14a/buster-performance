Lua: 660 runs, 6 layouts, 11 rounds

### Lua's five scripts, time, ms

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 222.17 | 222.16 | 1.0000 |
| 1 | 223.75 | 224.58 | 1.0037 |
| 2 | 222.95 | 221.69 | 0.9943 |
| 3 | 225.21 | 220.29 | 0.9782 |
| 4 | 223.55 | 225.54 | 1.0089 |
| 5 | 222.69 | 223.12 | 1.0019 |

Mean ratio over the layouts 0.9978 (95% interval 0.9865 to 1.0092)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 24.01 | 23.73 | 0.9883 |
| tables | 44.84 | 44.45 | 0.9915 |
| strings | 51.88 | 51.51 | 0.9929 |
| arithmetic | 40.71 | 40.23 | 0.9882 |
| closures | 61.62 | 62.27 | 1.0105 |

### Lua's five scripts, user cycles, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 1217.75 | 1217.62 | 0.9999 |
| 1 | 1225.24 | 1230.19 | 1.0040 |
| 2 | 1220.26 | 1213.55 | 0.9945 |
| 3 | 1232.46 | 1204.15 | 0.9770 |
| 4 | 1223.36 | 1234.80 | 1.0094 |
| 5 | 1217.99 | 1220.47 | 1.0020 |

Mean ratio over the layouts 0.9978 (95% interval 0.9859 to 1.0097)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 132.56 | 130.89 | 0.9874 |
| tables | 241.84 | 239.96 | 0.9922 |
| strings | 281.64 | 279.44 | 0.9922 |
| arithmetic | 225.05 | 222.34 | 0.9880 |
| closures | 339.90 | 343.30 | 1.0100 |

### Lua's five scripts, user instructions, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 5998.48 | 5996.41 | 0.9997 |
| 1 | 5995.69 | 5994.89 | 0.9999 |
| 2 | 5996.88 | 5998.70 | 1.0003 |
| 3 | 5996.16 | 5995.08 | 0.9998 |
| 4 | 5998.72 | 5997.60 | 0.9998 |
| 5 | 5993.31 | 5996.09 | 1.0005 |

Mean ratio over the layouts 1.0000 (95% interval 0.9997 to 1.0003)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 675.68 | 675.68 | 1.0000 |
| tables | 1172.07 | 1172.11 | 1.0000 |
| strings | 1100.80 | 1101.13 | 1.0003 |
| arithmetic | 1468.11 | 1468.11 | 1.0000 |
| closures | 1579.87 | 1579.22 | 0.9996 |

speedtest1: 22 runs, one layout

| Metric | base | head | head / base | paired rounds' ratio, median (range) |
| --- | ---: | ---: | ---: | ---: |
| time, ms | 216.51 | 214.41 | 0.9903 | 0.9869 (0.9741 to 1.0149) |
| user cycles, M | 936.33 | 924.80 | 0.9877 | 0.9890 (0.9817 to 0.9940) |
| user instructions, M | 3182.81 | 3173.76 | 0.9972 | 0.9972 (0.9972 to 0.9972) |
