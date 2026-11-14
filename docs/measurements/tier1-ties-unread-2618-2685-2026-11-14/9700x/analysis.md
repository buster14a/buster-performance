Lua: 660 runs, 6 layouts, 11 rounds

### Lua's five scripts, time, ms

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 200.92 | 207.45 | 1.0325 |
| 1 | 200.99 | 197.98 | 0.9850 |
| 2 | 201.60 | 197.00 | 0.9772 |
| 3 | 201.74 | 198.05 | 0.9817 |
| 4 | 199.35 | 199.20 | 0.9992 |
| 5 | 205.92 | 195.91 | 0.9514 |

Mean ratio over the layouts 0.9875 (95% interval 0.9599 to 1.0160)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 19.57 | 19.39 | 0.9911 |
| tables | 42.04 | 41.79 | 0.9941 |
| strings | 49.69 | 48.30 | 0.9720 |
| arithmetic | 31.66 | 30.55 | 0.9651 |
| closures | 58.42 | 57.84 | 0.9902 |

### Lua's five scripts, user cycles, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 1094.60 | 1132.84 | 1.0349 |
| 1 | 1094.87 | 1078.72 | 0.9853 |
| 2 | 1098.25 | 1073.25 | 0.9772 |
| 3 | 1100.18 | 1078.27 | 0.9801 |
| 4 | 1085.63 | 1084.86 | 0.9993 |
| 5 | 1122.84 | 1066.86 | 0.9501 |

Mean ratio over the layouts 0.9875 (95% interval 0.9586 to 1.0173)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 107.22 | 106.26 | 0.9910 |
| tables | 225.91 | 224.74 | 0.9948 |
| strings | 269.37 | 261.64 | 0.9713 |
| arithmetic | 174.16 | 167.72 | 0.9630 |
| closures | 320.65 | 317.32 | 0.9896 |

### Lua's five scripts, user instructions, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 5278.77 | 5135.21 | 0.9728 |
| 1 | 5279.54 | 5134.42 | 0.9725 |
| 2 | 5280.30 | 5136.62 | 0.9728 |
| 3 | 5282.51 | 5136.14 | 0.9723 |
| 4 | 5281.44 | 5136.05 | 0.9725 |
| 5 | 5281.29 | 5135.01 | 0.9723 |

Mean ratio over the layouts 0.9725 (95% interval 0.9723 to 0.9728)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 568.88 | 542.18 | 0.9531 |
| tables | 1063.88 | 1042.97 | 0.9803 |
| strings | 1058.88 | 1052.50 | 0.9940 |
| arithmetic | 1132.57 | 1058.08 | 0.9342 |
| closures | 1456.73 | 1439.90 | 0.9884 |

speedtest1: 22 runs, one layout

| Metric | base | head | head / base | paired rounds' ratio, median (range) |
| --- | ---: | ---: | ---: | ---: |
| time, ms | 196.77 | 194.49 | 0.9884 | 0.9874 (0.9665 to 1.0021) |
| user cycles, M | 829.20 | 820.39 | 0.9894 | 0.9884 (0.9855 to 0.9917) |
| user instructions, M | 2818.47 | 2798.79 | 0.9930 | 0.9930 (0.9930 to 0.9930) |
