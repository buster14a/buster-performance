#!/bin/bash
# one.sh COMPILER TAG FILE [FLAGS...]: for a unit the direct path takes, its symbols against --no-direct's:
# "TAG<TAB>FILE<TAB>direct|full|none<TAB>same|differ|full-failed<TAB>first difference"
P=$1; tag=$2; f=$3; shift 3
here=$(cd "$(dirname "$0")" && pwd)
t=$(mktemp -d /dev/shm/se.XXXXXX)
(cd "$t" && LLVM_PROFILE_FILE=/dev/null timeout 120 "$P" "$@" -c "$f" -o "$t/d.o" > /dev/null 2>&1 < /dev/null)
path=none; verdict=-; first=-
if [ -f "$t/d.o" ]; then grep -q 'buster direct' "$t/d.o" && path=direct || path=full; fi
if [ "$path" = direct ]; then
  (cd "$t" && LLVM_PROFILE_FILE=/dev/null timeout 120 "$P" "$@" --no-direct -c "$f" -o "$t/f.o" > /dev/null 2>&1 < /dev/null)
  if [ -f "$t/f.o" ]; then
    python3 "$here/syms.py" "$t/d.o" > "$t/d.s"; python3 "$here/syms.py" "$t/f.o" > "$t/f.s"
    if cmp -s "$t/d.s" "$t/f.s"; then verdict=same; else verdict=differ; first=$(diff "$t/d.s" "$t/f.s" | grep '^[<>]' | head -4 | tr '\n' ';'); fi
  else verdict=full-failed; fi
fi
printf '%s\t%s\t%s\t%s\t%s\n' "$tag" "$f" "$path" "$verdict" "$first"
rm -rf "$t"
