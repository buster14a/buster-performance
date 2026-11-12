Lua: 660 runs, 6 layouts, 11 rounds

### Lua's five scripts, time, ms

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 222.41 | 220.36 | 0.9908 |
| 1 | 223.34 | 227.75 | 1.0197 |
| 2 | 223.12 | 224.24 | 1.0050 |
| 3 | 224.47 | 224.25 | 0.9990 |
| 4 | 223.43 | 228.76 | 1.0239 |
| 5 | 222.89 | 222.59 | 0.9987 |

Mean ratio over the layouts 1.0061 (95% interval 0.9926 to 1.0198)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 23.89 | 23.58 | 0.9868 |
| tables | 44.84 | 44.48 | 0.9922 |
| strings | 51.84 | 51.47 | 0.9930 |
| arithmetic | 40.50 | 40.13 | 0.9910 |
| closures | 62.14 | 64.02 | 1.0302 |

### Lua's five scripts, user cycles, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 1219.34 | 1207.04 | 0.9899 |
| 1 | 1222.91 | 1248.04 | 1.0206 |
| 2 | 1220.92 | 1227.32 | 1.0052 |
| 3 | 1228.23 | 1227.18 | 0.9991 |
| 4 | 1222.30 | 1252.89 | 1.0250 |
| 5 | 1218.89 | 1217.78 | 0.9991 |

Mean ratio over the layouts 1.0064 (95% interval 0.9923 to 1.0208)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 131.81 | 130.10 | 0.9871 |
| tables | 241.69 | 239.97 | 0.9929 |
| strings | 281.48 | 279.22 | 0.9920 |
| arithmetic | 223.86 | 221.88 | 0.9911 |
| closures | 342.55 | 353.26 | 1.0312 |

### Lua's five scripts, user instructions, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 5993.34 | 5960.80 | 0.9946 |
| 1 | 5995.87 | 5959.29 | 0.9939 |
| 2 | 5994.22 | 5959.33 | 0.9942 |
| 3 | 5994.71 | 5962.26 | 0.9946 |
| 4 | 5994.66 | 5960.83 | 0.9944 |
| 5 | 5995.72 | 5959.43 | 0.9939 |

Mean ratio over the layouts 0.9943 (95% interval 0.9939 to 0.9946)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 675.68 | 667.10 | 0.9873 |
| tables | 1172.02 | 1165.82 | 0.9947 |
| strings | 1100.86 | 1100.51 | 0.9997 |
| arithmetic | 1468.12 | 1449.20 | 0.9871 |
| closures | 1577.92 | 1577.47 | 0.9997 |

speedtest1: 22 runs, one layout

| Metric | base | head | head / base | paired rounds' ratio, median (range) |
| --- | ---: | ---: | ---: | ---: |
| time, ms | 215.72 | 219.50 | 1.0175 | 1.0165 (0.9992 to 1.0282) |
| user cycles, M | 935.67 | 952.18 | 1.0177 | 1.0172 (1.0007 to 1.0257) |
| user instructions, M | 3182.81 | 3185.26 | 1.0008 | 1.0008 (1.0008 to 1.0008) |
