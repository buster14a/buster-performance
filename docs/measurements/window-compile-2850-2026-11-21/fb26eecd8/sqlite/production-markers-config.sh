declare -a modes=(baseline production) metrics=(pmu wall)
declare -A binary=([baseline]=main32588 [production]=markfb2)
round_count=3
[[ $experiment != markfb2-sqlite ]] || round_count=7
