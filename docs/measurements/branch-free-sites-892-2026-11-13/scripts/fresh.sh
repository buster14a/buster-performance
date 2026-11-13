#!/bin/bash
# fresh.sh BUILD ARGUMENT...: runs bin/compiler-BUILD from a copy made now on tmpfs (a new file, so that no earlier
# run's page cache, file huge pages included, carries over), from the run root (#892's stage A/B under ab).
base=~/buster-fast-bench/892-claude
build=$1
shift
copy=/dev/shm/892-claude/fresh-$build
cp -f "$base/bin/compiler-$build" "$copy.new" && mv -f "$copy.new" "$copy" || exit 2
cd "$base/run" || exit 2
exec "$copy" "$@"
