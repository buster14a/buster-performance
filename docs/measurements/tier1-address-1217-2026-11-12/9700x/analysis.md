Lua: 660 runs, 6 layouts, 11 rounds

### Lua's five scripts, time, ms

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 223.37 | 220.33 | 0.9864 |
| 1 | 221.40 | 219.20 | 0.9901 |
| 2 | 224.96 | 221.97 | 0.9867 |
| 3 | 223.39 | 221.88 | 0.9932 |
| 4 | 224.46 | 226.11 | 1.0074 |
| 5 | 222.32 | 220.65 | 0.9925 |

Mean ratio over the layouts 0.9927 (95% interval 0.9847 to 1.0008)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 24.48 | 24.05 | 0.9824 |
| tables | 44.27 | 44.85 | 1.0132 |
| strings | 51.54 | 50.83 | 0.9862 |
| arithmetic | 41.91 | 40.69 | 0.9710 |
| closures | 61.57 | 61.20 | 0.9939 |

### Lua's five scripts, user cycles, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 1224.44 | 1206.24 | 0.9851 |
| 1 | 1211.81 | 1199.49 | 0.9898 |
| 2 | 1231.29 | 1215.10 | 0.9869 |
| 3 | 1221.33 | 1212.99 | 0.9932 |
| 4 | 1227.40 | 1237.70 | 1.0084 |
| 5 | 1215.65 | 1206.36 | 0.9924 |

Mean ratio over the layouts 0.9926 (95% interval 0.9839 to 1.0013)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 134.99 | 132.50 | 0.9816 |
| tables | 238.79 | 242.12 | 1.0139 |
| strings | 279.62 | 276.04 | 0.9872 |
| arithmetic | 231.67 | 224.88 | 0.9707 |
| closures | 338.81 | 337.11 | 0.9950 |

### Lua's five scripts, user instructions, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 6116.04 | 6006.60 | 0.9821 |
| 1 | 6116.20 | 6006.52 | 0.9821 |
| 2 | 6115.67 | 6007.58 | 0.9823 |
| 3 | 6116.13 | 6006.77 | 0.9821 |
| 4 | 6114.80 | 6005.24 | 0.9821 |
| 5 | 6115.96 | 6003.85 | 0.9817 |

Mean ratio over the layouts 0.9821 (95% interval 0.9818 to 0.9823)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 706.19 | 675.68 | 0.9568 |
| tables | 1186.07 | 1172.05 | 0.9882 |
| strings | 1111.96 | 1110.18 | 0.9984 |
| arithmetic | 1509.98 | 1468.12 | 0.9723 |
| closures | 1601.85 | 1580.55 | 0.9867 |

speedtest1: 22 runs, one layout

| Metric | base | head | head / base | paired rounds' ratio, median (range) |
| --- | ---: | ---: | ---: | ---: |
| time, ms | 226.76 | 226.42 | 0.9985 | 0.9996 (0.9745 to 1.0176) |
| user cycles, M | 937.62 | 936.69 | 0.9990 | 0.9990 (0.9933 to 1.0201) |
| user instructions, M | 3208.32 | 3199.34 | 0.9972 | 0.9972 (0.9972 to 0.9972) |
