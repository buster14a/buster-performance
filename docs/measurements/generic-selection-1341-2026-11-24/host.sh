# Keep the repository's 9700X profile and add load and memory snapshots inside each step's hold.
source "$REPOSITORY/tools/microarch/hosts/zen5-9700x.sh"
hold() {
    EXCLUSIVE_OWNER="$MICROARCH_OWNER" EXCLUSIVE_TITLE="$MICROARCH_TITLE" EXCLUSIVE_LINK="$MICROARCH_LINK" \
        "$HOME/buster-fast-bench/exclusive.sh" timeout -k 5 120 bash "$BENCH_ROOT/campaign.sh" observe "$@"
}
