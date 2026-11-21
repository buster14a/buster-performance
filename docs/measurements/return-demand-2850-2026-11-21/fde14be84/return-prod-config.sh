declare -a modes=(baseline production) metrics=(pmu wall)
declare -A binary=([baseline]=returndense875 [production]=returnprodv1)
round_count=3
if [[ $experiment == returnprod-sqlite ]]; then round_count=7; fi
