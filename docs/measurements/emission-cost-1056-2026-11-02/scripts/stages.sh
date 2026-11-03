# Where the time goes (--time-stages, measure-compile): each build against the other as its reference, sqlite3.c and musl.
set -e
source ~/buster-fast-bench/1056-claude/common.sh
mkdir -p $root/run && cd $root/run
for pair in "head base" "base head"; do
    set -- $pair
    echo "== measure-compile sqlite3.c: $1, reference $2"
    $lock taskset -c 2 $root/$1/build/compiler measure-compile --runs 11 --reference $root/$2/build/compiler -- "${sqlite_options[@]}"
done
echo STAGES-DONE
