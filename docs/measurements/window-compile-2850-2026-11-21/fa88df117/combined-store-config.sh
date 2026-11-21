declare -a modes=(parent for-init combined) metrics=(pmu)
declare -A binary=([parent]=gated0d8 [for-init]=for627 [combined]=combinedfa8)
declare -A flag expected=([parent]=2977 [for-init]=3587 [combined]=4468) stage
for opt_mode in "${modes[@]}"; do flag[$opt_mode]=--node-window-assignments; done
