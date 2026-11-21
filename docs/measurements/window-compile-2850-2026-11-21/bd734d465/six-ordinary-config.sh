declare -a modes=(baseline ordinary regular assignments) metrics=(pmu wall)
declare -A binary=([baseline]=sixbasef0a [ordinary]=sixbd7 [regular]=sixbd7 [assignments]=sixbd7)
declare -A option=([baseline]="" [ordinary]="" [regular]=--node-window [assignments]=--node-window-assignments)
declare -A audit_mode=([baseline]=0 [ordinary]=0 [regular]=1 [assignments]=4)
round_count=7
