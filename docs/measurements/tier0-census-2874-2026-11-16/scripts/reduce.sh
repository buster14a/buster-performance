#!/bin/bash
# reduce.sh LABEL: the profiles of results/LABEL by part (build/parts with parts.rules over results/LABEL/chains.txt),
# into results/LABEL/tables. For each corpus: a compile's counts an entry and a token (the four events, a column each),
# and benchmark-backend-source's 21 timed passes of the vector path, and of branch sizing and encoding, an entry: each
# profile less the control's (the same runs with the validation's passes in their place). No lock: it reads files.
# The entries are benchmark-backend-source's corpus's, the tokens tokens.sh's, the runs each profile's log's.
set -u
cd "$(dirname "$0")"
label=$1
out=results/$label
tables=$out/tables
mkdir -p "$tables"
events="instructions cycles mispredicts fills"
runs_of()
{
    awk '$1 == "runs" { runs = $2; passes = ($3 == "passes" ? $4 : 1) } END { print runs * passes }' "$1"
}
for name in sqlite3 lua musl; do
    entries=$(awk '/^benchmark-backend-source: [0-9]+ functions/ { print $4; exit }' "$out/backend-$name-1.txt")
    tokens=$(awk '$1 == "tokens" { print $2 }' "$out/tokens-$name.txt")
    echo "$name entries $entries tokens $tokens" | tee "$tables/$name-denominators.txt"
    compile_entry=(); compile_token=(); compile_whole=(); vector=(); encode=()
    for event in $events; do
        runs=$(runs_of "$out/compile-$name-$event.log")
        compile_entry+=("$event=$out/compile-$name-$event.ips:$((runs * entries))")
        compile_token+=("$event=$out/compile-$name-$event.ips:$((runs * tokens))")
        compile_whole+=("$event=$out/compile-$name-$event.ips:$runs")
        runs=$(runs_of "$out/backend-$name-vector-$event.log")
        vector+=("$event=$out/backend-$name-vector-$event.ips-$out/backend-$name-validate-$event.ips:$((runs * 21 * entries))")
        encode+=("$event=$out/backend-$name-encode-$event.ips-$out/backend-$name-validate-$event.ips:$((runs * 21 * entries))")
        echo "$name $event compile-runs $(runs_of "$out/compile-$name-$event.log") backend-runs $runs" >> "$tables/$name-denominators.txt"
    done
    build/parts parts.rules "$out/chains.txt" "${compile_entry[@]}" --top 40 > "$tables/$name-compile-entry.txt"
    build/parts parts.rules "$out/chains.txt" "${compile_entry[@]}" --markdown > "$tables/$name-compile-entry.md"
    build/parts parts.rules "$out/chains.txt" "${compile_token[@]}" --markdown > "$tables/$name-compile-token.md"
    build/parts parts.rules "$out/chains.txt" "${vector[@]}" --markdown > "$tables/$name-backend-vector-entry.md"
    build/parts parts.rules "$out/chains.txt" "${encode[@]}" --markdown > "$tables/$name-backend-encode-entry.md"
    build/parts parts.rules "$out/chains.txt" "${compile_token[@]}" --top 40 > "$tables/$name-compile-token.txt"
    build/parts parts.rules "$out/chains.txt" "${compile_whole[@]}" --top 40 > "$tables/$name-compile-pass.txt"
    build/parts parts.rules "$out/chains.txt" "${compile_entry[@]}" --functions --top 400 > "$tables/$name-compile-entry-functions.txt"
    build/parts parts.rules "$out/chains.txt" "${vector[@]}" --top 40 > "$tables/$name-backend-vector-entry.txt"
    build/parts parts.rules "$out/chains.txt" "${vector[@]}" --functions --top 200 > "$tables/$name-backend-vector-entry-functions.txt"
    build/parts parts.rules "$out/chains.txt" "${encode[@]}" --top 40 > "$tables/$name-backend-encode-entry.txt"
done
echo done
