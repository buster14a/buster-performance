declare -a modes=(baseline plain constants) metrics=(pmu wall)
declare -A binary=([baseline]=constbaseb86 [plain]=consta60 [constants]=consta60)
declare -A option=([baseline]="" [plain]="" [constants]=--node-window-constants)
round_count=7
