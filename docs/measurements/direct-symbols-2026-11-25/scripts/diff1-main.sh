#!/bin/bash
# diff1.sh COMPILER TAG FILE [FLAGS...]: the whole symbol diff of a direct unit against --no-direct, into diffs/
P=$1; tag=$2; f=$3; shift 3
here=$(cd "$(dirname "$0")" && pwd)
t=$(mktemp -d /dev/shm/sd.XXXXXX)
(cd "$t" && LLVM_PROFILE_FILE=/dev/null timeout 120 "$P" "$@" -c "$f" -o "$t/d.o" > /dev/null 2>&1 < /dev/null)
(cd "$t" && LLVM_PROFILE_FILE=/dev/null timeout 120 "$P" "$@" --no-direct -c "$f" -o "$t/f.o" > /dev/null 2>&1 < /dev/null)
key=$(printf '%s %s' "$tag" "$f" | sha256sum | cut -c1-12)
{ echo "# $tag $f"; diff <(python3 "$here/syms.py" "$t/d.o") <(python3 "$here/syms.py" "$t/f.o") | grep '^[<>]'; } > "$here/diffs-main/$key.txt"
rm -rf "$t"
