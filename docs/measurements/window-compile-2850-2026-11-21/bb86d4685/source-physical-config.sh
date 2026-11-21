declare -a modes=(parent plain dry source) metrics=(pmu wall)
declare -A binary=([parent]=sourcepr7ef [plain]=sourcebb8 [dry]=sourcebb8 [source]=sourcebb8)
declare -A option=([parent]="" [plain]="" [dry]=--node-window-source [source]=--node-window-source)
round_count=3
