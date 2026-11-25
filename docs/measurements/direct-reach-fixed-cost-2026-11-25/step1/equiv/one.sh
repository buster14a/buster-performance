#!/bin/bash
# one.sh COMPILER TAG FILE [FLAGS...]: one unit through the driver's default -c; prints
# "TAG<TAB>FILE<TAB>status<TAB>stderr-sha<TAB>object-sha|none<TAB>direct|full"
P=$1; tag=$2; f=$3; shift 3
t=$(mktemp -d /dev/shm/eq.XXXXXX)
err=$(cd "$t" && LLVM_PROFILE_FILE=/dev/null timeout 120 "$P" "$@" -c "$f" -o "$t/a.o" 2>&1 < /dev/null; echo "status=$?")
st=${err##*status=}
es=$(printf '%s' "${err%status=*}" | sha256sum | cut -c1-16)
if [ -f "$t/a.o" ]; then os=$(sha256sum < "$t/a.o" | cut -c1-16); grep -q 'buster direct' "$t/a.o" && path=direct || path=full; else os=none; path=none; fi
printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$tag" "$f" "$st" "$es" "$os" "$path"
rm -rf "$t"
