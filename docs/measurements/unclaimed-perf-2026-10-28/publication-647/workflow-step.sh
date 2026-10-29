allowed="$(awk '/^Cpus_allowed_list:/ { print $2 }' /proc/self/status)"
mapfile -t core_cpus < <(lscpu -p=CPU,CORE,SOCKET,ONLINE | awk -F, -v allowed="$allowed" '
    BEGIN {
        n = split(allowed, ranges, ",")
        for (r = 1; r <= n; r++) {
            m = split(ranges[r], ends, "-")
            last = m == 2 ? ends[2] : ends[1]
            for (c = ends[1]; c <= last; c++) permitted[c] = 1
        }
    }
    $0 !~ /^#/ && $4 == "Y" && permitted[$1] && !seen[$3 ":" $2]++ && count++ < 8 { print $1 }
')
test "${#core_cpus[@]}" -gt 0
printf -v placement '%s,' "${core_cpus[@]}"
placement="${placement%,}"
writer=()
if [ "${#core_cpus[@]}" -ge 2 ]; then
  writer=(--cpus "${core_cpus[0]},${core_cpus[1]}")
fi
printf 'Streaming: allowed CPUs=%s; distinct-core CPUs=%s; lanes=%s\n' "$allowed" "$placement" "${#core_cpus[@]}"
taskset -c "$placement" ./build/compiler benchmark-streaming --units 100 --runs 5 --lanes "${#core_cpus[@]}" "${writer[@]}"
