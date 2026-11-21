declare -a modes=(baseline lookahead carried writer) metrics=(pmu wall)
declare -A binary=([baseline]=prepbase232 [lookahead]=lexer220 [carried]=lexer8b3 [writer]=lexeradf)
round_count=3
