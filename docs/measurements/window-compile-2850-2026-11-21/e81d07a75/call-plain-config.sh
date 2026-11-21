declare -a modes=(parent-default head-default parent-window head-window head-calls) metrics=(pmu wall)
declare -A binary=([parent-default]=chainprbase6e9 [parent-window]=chainprbase6e9 [head-default]=plaincalle81 [head-window]=plaincalle81 [head-calls]=plaincalle81)
declare -A option=([parent-default]="" [parent-window]=--node-window [head-default]="" [head-window]=--node-window [head-calls]=--node-window-calls)
round_count=3
