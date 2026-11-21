# Source from native-matrix.sh and native-matrix-one.sh after setting experiment.
declare -a modes metrics
declare -A binary flag stage expected
case "$experiment" in
 store-screen)
   modes=(parent arrow for-init)
   metrics=(pmu)
   binary=([parent]=gated0d8 [arrow]=arrow0a0 [for-init]=for627)
   for opt_mode in "${modes[@]}"; do flag[$opt_mode]=--node-window-assignments; done
   expected=([parent]=2977 [arrow]=3858 [for-init]=3587)
   ;;
 disc34d)
   modes=(reads parent-regular parent-stores ordinary regular stores)
   metrics=(pmu wall)
   binary=([reads]=read227 [parent-regular]=gated0d8 [parent-stores]=gated0d8 [ordinary]=disc34d [regular]=disc34d [stores]=disc34d)
   flag=([reads]=--node-window [parent-regular]=--node-window [parent-stores]=--node-window-assignments [ordinary]='' [regular]=--node-window [stores]=--node-window-assignments)
   expected=([reads]=2214 [parent-regular]=2214 [parent-stores]=2977 [ordinary]=0 [regular]=7617 [stores]=8380)
   ;;
 condccf)
   modes=(off alloc controls discover front type rows full)
   metrics=(pmu)
   for mode in "${modes[@]}"; do binary[$mode]=condccf; flag[$mode]=--node-window-conditions; stage[$mode]=$mode; expected[$mode]=2977; done
   expected[full]=4344
   ;;
 *) exit 2 ;;
esac
