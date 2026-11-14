Lua: 660 runs, 6 layouts, 11 rounds

### Lua's five scripts, time, ms

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 182.66 | 181.96 | 0.9962 |
| 1 | 182.27 | 183.88 | 1.0088 |
| 2 | 183.22 | 182.02 | 0.9935 |
| 3 | 182.60 | 181.12 | 0.9919 |
| 4 | 182.24 | 183.43 | 1.0065 |
| 5 | 182.35 | 183.18 | 1.0046 |

Mean ratio over the layouts 1.0002 (95% interval 0.9926 to 1.0079)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 20.34 | 20.32 | 0.9993 |
| tables | 36.83 | 36.50 | 0.9912 |
| strings | 44.06 | 43.77 | 0.9934 |
| arithmetic | 28.75 | 28.91 | 1.0056 |
| closures | 52.56 | 53.33 | 1.0146 |

### Lua's five scripts, user cycles, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 994.87 | 990.83 | 0.9959 |
| 1 | 992.36 | 1002.08 | 1.0098 |
| 2 | 998.45 | 991.35 | 0.9929 |
| 3 | 994.12 | 985.96 | 0.9918 |
| 4 | 992.31 | 998.83 | 1.0066 |
| 5 | 992.74 | 997.53 | 1.0048 |

Mean ratio over the layouts 1.0003 (95% interval 0.9922 to 1.0084)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 111.91 | 111.82 | 0.9992 |
| tables | 197.12 | 195.49 | 0.9917 |
| strings | 238.00 | 236.71 | 0.9946 |
| arithmetic | 158.55 | 159.30 | 1.0047 |
| closures | 288.18 | 292.47 | 1.0149 |

### Lua's five scripts, user instructions, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 4819.56 | 4812.77 | 0.9986 |
| 1 | 4817.65 | 4812.61 | 0.9990 |
| 2 | 4818.41 | 4814.39 | 0.9992 |
| 3 | 4819.58 | 4814.69 | 0.9990 |
| 4 | 4819.73 | 4813.78 | 0.9988 |
| 5 | 4819.43 | 4816.26 | 0.9993 |

Mean ratio over the layouts 0.9990 (95% interval 0.9987 to 0.9993)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 521.19 | 521.19 | 1.0000 |
| tables | 961.76 | 961.72 | 1.0000 |
| strings | 994.16 | 989.27 | 0.9951 |
| arithmetic | 974.27 | 974.22 | 0.9999 |
| closures | 1368.13 | 1367.68 | 0.9997 |

speedtest1: 22 runs, one layout

| Metric | base | head | head / base | paired rounds' ratio, median (range) |
| --- | ---: | ---: | ---: | ---: |
| time, ms | 181.07 | 180.56 | 0.9972 | 0.9952 (0.9818 to 1.0071) |
| user cycles, M | 751.68 | 748.63 | 0.9959 | 0.9964 (0.9916 to 1.0015) |
| user instructions, M | 2574.07 | 2573.04 | 0.9996 | 0.9996 (0.9996 to 0.9996) |
