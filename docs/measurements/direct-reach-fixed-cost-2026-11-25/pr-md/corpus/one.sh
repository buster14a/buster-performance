#!/bin/bash
# one.sh COMPILER TAG FILE [FLAGS...]: one unit's dependency rule by the default driver (the direct path where it takes
# the unit) and by --no-direct, in five option sets; prints
# "TAG<TAB>MODE<TAB>FILE<TAB>taken<TAB>status-default/status-full<TAB>rule-default/rule-full<TAB>same|DIFF"
P=$1; tag=$2; f=$3; shift 3
t=$(mktemp -d /dev/shm/dep.XXXXXX)
keep=/tmp/claude-0/depdiff
for mode in md mmd mf mmdp rel; do
  case $mode in
    md) opts=(-MD); d=a.d;;
    mmd) opts=(-MMD); d=a.d;;
    mf) opts=(-MD -MP -MF "$t/x.d" -MT 'tgt $(V)' -MQ 'q $x' -MT last); d=x.d;;
    mmdp) opts=(-MMD -MP -MF "$t/x.d"); d=x.d;;
    rel) opts=(-MD -MP -MF "$t/x.d"); d=x.d;;
  esac
  for run in default full; do
    extra=(); [ $run = full ] && extra=(--no-direct)
    rm -f "$t/a.o" "$t/$d"
    if [ $mode = rel ]; then
      err=$(cd "$(dirname "$f")" && LLVM_PROFILE_FILE=/dev/null timeout 120 "$P" "${extra[@]}" "$@" "${opts[@]}" -c "$(basename "$f")" -o "$t/a.o" 2>&1 </dev/null; echo "status=$?")
    else
      err=$(cd "$t" && LLVM_PROFILE_FILE=/dev/null timeout 120 "$P" "${extra[@]}" "$@" "${opts[@]}" -c "$f" -o "$t/a.o" 2>&1 </dev/null; echo "status=$?")
    fi
    st=${err##*status=}
    if [ -f "$t/$d" ]; then ds=$(sha256sum < "$t/$d" | cut -c1-16); else ds=none; fi
    if [ $run = default ]; then
      taken=none
      if [ -f "$t/a.o" ]; then readelf -p .comment "$t/a.o" 2>/dev/null | grep -q 'buster direct' && taken=direct || taken=full; fi
      st_d=$st; ds_d=$ds; rm -f "$t/d.default"; [ -f "$t/$d" ] && cp "$t/$d" "$t/d.default"
    else
      st_f=$st; ds_f=$ds
    fi
  done
  verdict=same
  if [ "$st_d" != "$st_f" ] || [ "$ds_d" != "$ds_f" ]; then
    verdict=DIFF
    n=$(echo "$tag $mode $f" | sha256sum | cut -c1-12)
    mkdir -p "$keep/$n"; echo "$tag $mode $f $*" > "$keep/$n/what"
    [ -f "$t/d.default" ] && cp "$t/d.default" "$keep/$n/default.d"; [ -f "$t/$d" ] && cp "$t/$d" "$keep/$n/full.d"
  fi
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$tag" "$mode" "$f" "$taken" "$st_d/$st_f" "$ds_d/$ds_f" "$verdict"
done
rm -rf "$t"
