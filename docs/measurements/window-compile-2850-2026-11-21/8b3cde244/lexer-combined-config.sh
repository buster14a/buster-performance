declare -a modes=(baseline lookahead combined) metrics=(pmu wall)
declare -A binary=([baseline]=prepbase232 [lookahead]=lexer220 [combined]=lexer8b3)
round_count=3
