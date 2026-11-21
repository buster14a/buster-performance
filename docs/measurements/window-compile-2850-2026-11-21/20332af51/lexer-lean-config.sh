declare -a modes=(baseline aggregate lean) metrics=(pmu wall)
declare -A binary=([baseline]=constbaseb86 [aggregate]=lexera16 [lean]=lexer203)
round_count=3
