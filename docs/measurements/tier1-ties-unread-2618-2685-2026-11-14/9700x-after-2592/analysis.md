Lua: 660 runs, 6 layouts, 11 rounds

### Lua's five scripts, time, ms

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 200.15 | 197.92 | 0.9889 |
| 1 | 200.04 | 202.45 | 1.0120 |
| 2 | 199.44 | 200.56 | 1.0056 |
| 3 | 197.93 | 200.48 | 1.0129 |
| 4 | 200.36 | 201.18 | 1.0041 |
| 5 | 202.51 | 200.48 | 0.9900 |

Mean ratio over the layouts 1.0022 (95% interval 0.9912 to 1.0133)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 19.38 | 19.25 | 0.9935 |
| tables | 41.44 | 41.77 | 1.0078 |
| strings | 48.58 | 49.33 | 1.0154 |
| arithmetic | 31.04 | 32.61 | 1.0506 |
| closures | 58.69 | 58.08 | 0.9896 |

### Lua's five scripts, user cycles, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 1088.94 | 1077.03 | 0.9891 |
| 1 | 1090.86 | 1101.10 | 1.0094 |
| 2 | 1085.78 | 1092.18 | 1.0059 |
| 3 | 1077.61 | 1091.42 | 1.0128 |
| 4 | 1090.86 | 1095.61 | 1.0044 |
| 5 | 1103.38 | 1092.49 | 0.9901 |

Mean ratio over the layouts 1.0019 (95% interval 0.9914 to 1.0125)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 105.98 | 105.40 | 0.9945 |
| tables | 222.50 | 224.25 | 1.0079 |
| strings | 262.83 | 267.53 | 1.0179 |
| arithmetic | 170.80 | 179.38 | 1.0502 |
| closures | 321.98 | 318.35 | 0.9887 |

### Lua's five scripts, user instructions, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 5168.47 | 5145.68 | 0.9956 |
| 1 | 5167.45 | 5146.41 | 0.9959 |
| 2 | 5167.38 | 5143.60 | 0.9954 |
| 3 | 5168.56 | 5144.85 | 0.9954 |
| 4 | 5169.50 | 5145.74 | 0.9954 |
| 5 | 5166.45 | 5146.46 | 0.9961 |

Mean ratio over the layouts 0.9956 (95% interval 0.9953 to 0.9960)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 552.67 | 550.76 | 0.9965 |
| tables | 1049.20 | 1039.88 | 0.9911 |
| strings | 1057.36 | 1052.75 | 0.9956 |
| arithmetic | 1067.80 | 1066.35 | 0.9986 |
| closures | 1440.93 | 1435.86 | 0.9965 |

speedtest1: 22 runs, one layout

| Metric | base | head | head / base | paired rounds' ratio, median (range) |
| --- | ---: | ---: | ---: | ---: |
| time, ms | 196.65 | 195.27 | 0.9930 | 0.9942 (0.9710 to 1.0017) |
| user cycles, M | 829.53 | 825.17 | 0.9947 | 0.9949 (0.9901 to 1.0002) |
| user instructions, M | 2825.75 | 2812.99 | 0.9955 | 0.9955 (0.9954 to 0.9955) |
