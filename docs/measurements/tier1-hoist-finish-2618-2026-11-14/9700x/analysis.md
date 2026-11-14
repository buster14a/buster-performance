Lua: 660 runs, 6 layouts, 11 rounds

### Lua's five scripts, time, ms

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 186.52 | 182.78 | 0.9799 |
| 1 | 184.96 | 182.89 | 0.9888 |
| 2 | 184.39 | 181.63 | 0.9850 |
| 3 | 185.88 | 183.71 | 0.9883 |
| 4 | 184.79 | 181.97 | 0.9847 |
| 5 | 184.60 | 183.50 | 0.9940 |

Mean ratio over the layouts 0.9868 (95% interval 0.9818 to 0.9918)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 20.79 | 20.32 | 0.9776 |
| tables | 36.83 | 36.89 | 1.0014 |
| strings | 44.59 | 44.10 | 0.9890 |
| arithmetic | 29.10 | 28.81 | 0.9900 |
| closures | 53.37 | 52.67 | 0.9868 |

### Lua's five scripts, user cycles, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 1015.89 | 995.38 | 0.9798 |
| 1 | 1008.29 | 997.15 | 0.9890 |
| 2 | 1004.97 | 989.50 | 0.9846 |
| 3 | 1013.91 | 1001.30 | 0.9876 |
| 4 | 1007.19 | 991.52 | 0.9844 |
| 5 | 1005.47 | 999.74 | 0.9943 |

Mean ratio over the layouts 0.9866 (95% interval 0.9815 to 0.9918)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 114.51 | 111.97 | 0.9778 |
| tables | 197.75 | 197.68 | 0.9996 |
| strings | 241.28 | 238.44 | 0.9883 |
| arithmetic | 160.38 | 158.89 | 0.9907 |
| closures | 292.89 | 288.98 | 0.9867 |

### Lua's five scripts, user instructions, M

| Layout | base | head | head / base |
| ---: | ---: | ---: | ---: |
| 0 | 4919.90 | 4833.42 | 0.9824 |
| 1 | 4919.74 | 4835.01 | 0.9828 |
| 2 | 4918.52 | 4834.81 | 0.9830 |
| 3 | 4919.84 | 4836.16 | 0.9830 |
| 4 | 4920.71 | 4835.17 | 0.9826 |
| 5 | 4919.59 | 4834.02 | 0.9826 |

Mean ratio over the layouts 0.9827 (95% interval 0.9825 to 0.9830)

| Script | base, median of layouts' medians | head | head / base |
| --- | ---: | ---: | ---: |
| calls | 542.17 | 523.10 | 0.9648 |
| tables | 980.87 | 964.19 | 0.9830 |
| strings | 1001.05 | 991.92 | 0.9909 |
| arithmetic | 1005.92 | 977.74 | 0.9720 |
| closures | 1389.74 | 1378.14 | 0.9917 |

speedtest1: 22 runs, one layout

| Metric | base | head | head / base | paired rounds' ratio, median (range) |
| --- | ---: | ---: | ---: | ---: |
| time, ms | 182.93 | 181.32 | 0.9912 | 0.9931 (0.9739 to 1.0036) |
| user cycles, M | 757.54 | 752.05 | 0.9928 | 0.9928 (0.9845 to 0.9997) |
| user instructions, M | 2605.15 | 2588.72 | 0.9937 | 0.9937 (0.9937 to 0.9937) |
