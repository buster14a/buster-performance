declare -a modes=(off original control plain) metrics=(pmu)
declare -A binary flag expected
for m in "${modes[@]}"; do binary[$m]=cond543; done
expected=([off]=2977 [original]=4344 [control]=4344 [plain]=4329)
