Lua: 660 runs, 6 layouts, 11 rounds

### Lua's five scripts, time, ms

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 186.10 | 182.76 | 0.9821 |
| 1 | 185.58 | 183.38 | 0.9881 |
| 2 | 184.43 | 181.63 | 0.9848 |
| 3 | 184.16 | 183.97 | 0.9990 |
| 4 | 185.18 | 185.45 | 1.0015 |
| 5 | 184.39 | 183.89 | 0.9973 |

Mean ratio over the layouts 0.9921 (95% interval 0.9836 to 1.0007)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 20.83 | 20.35 | 0.9772 |
| tables | 36.89 | 36.94 | 1.0012 |
| strings | 44.62 | 44.38 | 0.9945 |
| arithmetic | 29.09 | 28.76 | 0.9883 |
| closures | 53.24 | 52.61 | 0.9881 |

### Lua's five scripts, user cycles, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 1013.61 | 994.72 | 0.9814 |
| 1 | 1011.42 | 998.74 | 0.9875 |
| 2 | 1004.63 | 988.78 | 0.9842 |
| 3 | 1002.98 | 1002.13 | 0.9992 |
| 4 | 1008.54 | 1010.45 | 1.0019 |
| 5 | 1003.75 | 1001.40 | 0.9977 |

Mean ratio over the layouts 0.9919 (95% interval 0.9829 to 1.0011)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 114.57 | 111.95 | 0.9771 |
| tables | 197.83 | 197.86 | 1.0001 |
| strings | 241.23 | 239.95 | 0.9947 |
| arithmetic | 160.45 | 158.51 | 0.9879 |
| closures | 291.73 | 288.09 | 0.9876 |

### Lua's five scripts, user instructions, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 4919.76 | 4834.36 | 0.9826 |
| 1 | 4920.54 | 4834.04 | 0.9824 |
| 2 | 4920.48 | 4836.55 | 0.9829 |
| 3 | 4919.91 | 4834.23 | 0.9826 |
| 4 | 4920.82 | 4836.14 | 0.9828 |
| 5 | 4918.63 | 4833.99 | 0.9828 |

Mean ratio over the layouts 0.9827 (95% interval 0.9825 to 0.9829)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 542.17 | 523.10 | 0.9648 |
| tables | 980.92 | 964.17 | 0.9829 |
| strings | 1001.00 | 991.90 | 0.9909 |
| arithmetic | 1005.92 | 977.74 | 0.9720 |
| closures | 1390.19 | 1377.24 | 0.9907 |

speedtest1: 22 runs, one layout

| Metric | base | head | head / base | paired rounds' ratio, median (range) |
| --- | ---: | ---: | ---: | ---: |
| time, ms | 181.55 | 181.34 | 0.9988 | 0.9979 (0.9760 to 1.0154) |
| user cycles, M | 752.36 | 752.00 | 0.9995 | 0.9994 (0.9951 to 1.0052) |
| user instructions, M | 2605.15 | 2588.72 | 0.9937 | 0.9937 (0.9937 to 0.9938) |
