declare -a modes=(parent-default head-default parent-window head-window head-calls) metrics=(pmu wall)
declare -A binary=([parent-default]=chainprbase6e9 [parent-window]=chainprbase6e9 [head-default]=plaincallff2 [head-window]=plaincallff2 [head-calls]=plaincallff2)
declare -A option=([parent-default]="" [parent-window]=--node-window [head-default]="" [head-window]=--node-window [head-calls]=--node-window-calls)
round_count=3
