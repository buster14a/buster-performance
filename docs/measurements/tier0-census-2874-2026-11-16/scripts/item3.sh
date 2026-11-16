#!/bin/bash
# item3.sh LABEL: #2874's item 3, what no table removes (the encoder, branch sizing, the object), three ways for each
# corpus, in cycles a typed entry and a token. No lock: it reads results/LABEL. results/LABEL/tables/item3.txt.
#
# - In a compile: the parts' sampled user cycles (tables/CORPUS-compile-entry.txt, reduce.sh), with the two parts of the
#   row that write bytes too and that the issue's item doesn't name (the atoms and relocations, the unwind table).
# - In benchmark-backend-source: its own `sizing` and `encode` rows on the corpus's functions (the median of its runs).
# - At their own benchmarks' rates, on the corpus's counts: benchmark-x86-encoder --fixups' x86_encode_16 (cycles an
#   instruction) and benchmark-branch-sizing's size_branches on its tier0-mix corpus (cycles a record) times the corpus's
#   records (benchmark-backend-source's first line); benchmark-object-writer's build (cycles a byte written) times the
#   bytes of the corpus's objects (objects.sh), and its two writes (ns a byte written) on the same bytes, apart: a
#   file's write is the kernel's time, which the budget's row (sampled user cycles) doesn't hold.
set -u
cd "$(dirname "$0")"
# The record keeps scripts/ beside results/; on the 9700X the scripts are in the directory that holds results/.
[ -d results ] || cd ..
label=$1
out=results/$label
median()
{
    sort -g | awk '{ v[NR] = $1 } END { if (NR == 0) print "nan"; else if (NR % 2) print v[(NR + 1) / 2]; else print (v[NR / 2] + v[NR / 2 + 1]) / 2 }'
}
encoder=$(for f in "$out"/own-encoder-fixups-*.txt; do awk '$1 == "x86_encode_16" { for (i = 1; i <= NF; i++) if ($i == "cycles") print $(i - 1) }' "$f"; done | median)
sizing=$(for f in "$out"/own-branch-sizing-*.txt; do awk '/^tier0-mix:/ { mix = 1; next } /^[a-z0-9-]+:/ { mix = 0 } mix && $1 == "size_branches" { for (i = 1; i <= NF; i++) if ($i == "per" && $(i + 1) == "record") { print $(i - 1); exit } }' "$f"; done | median)
build_cycles=$(for f in "$out"/own-object-writer-*.txt; do awk '$1 == "build" && $2 == "(count," { for (i = 1; i <= NF; i++) if ($i == "cycles") print $(i - 1) }' "$f"; done | median)
build_us=$(for f in "$out"/own-object-writer-*.txt; do awk '$1 == "build" && $2 == "(count," { for (i = 1; i <= NF; i++) if ($i == "µs") { print $(i - 1); exit } }' "$f"; done | median)
in_place_us=$(for f in "$out"/own-object-writer-*.txt; do awk '$1 == "write" && $2 == "in" && $3 == "place" { print $4 }' "$f"; done | median)
new_file_us=$(for f in "$out"/own-object-writer-*.txt; do awk '$1 == "write" && $2 == "a" && $3 == "new" { print $5 }' "$f"; done | median)
written_kb=$(for f in "$out"/own-object-writer-*.txt; do awk '/objects in .*per object on average/ { for (i = 1; i <= NF; i++) if ($i == "KB" && $(i + 1) == "written;") print $(i - 1) }' "$f"; done | median)
{
    echo "own rates: x86_encode_16 $encoder cycles an instruction; size_branches (tier0-mix) $sizing cycles a record; object build $build_cycles cycles and $build_us µs an object of $written_kb KB written, written in place in $in_place_us µs, as a new file in $new_file_us µs"
    printf '%-8s %-58s %12s %12s\n' corpus "" "an entry" "a token"
    for name in sqlite3 lua musl; do
        entries=$(awk '$2 == "entries" { print $3 }' "$out/tables/$name-denominators.txt")
        tokens=$(awk '$2 == "entries" { print $5 }' "$out/tables/$name-denominators.txt")
        records=$(awk '/^benchmark-backend-source: [0-9]+ functions/ { print $7; exit }' "$out/backend-$name-1.txt")
        bytes=$(awk -v c="$name" '$1 == c { print $5 }' "$out/objects.txt")
        objects=$(awk -v c="$name" '$1 == c { print $3 }' "$out/objects.txt")
        bench_sizing=$(for f in "$out"/backend-$name-[0-9]*.txt; do awk '$1 == "sizing" { print $3 }' "$f"; done | median)
        bench_encode=$(for f in "$out"/backend-$name-[0-9]*.txt; do awk '$1 == "encode" { print $3 }' "$f"; done | median)
        part()
        {
            awk -v part="$1" 'BEGIN { n = length(part) } second && substr($0, 8, n) == part && substr($0, 8 + n, 1) == " " { print $(NF - 2); exit } /\(all its sub-parts\)/ { second = 1 }' "$out/tables/$name-compile-entry.txt"
        }
        awk -v name="$name" -v entries="$entries" -v tokens="$tokens" -v records="$records" -v bytes="$bytes" -v objects="$objects" \
            -v c_encoder="$(part 'the encoder')" -v c_sizing="$(part 'branch sizing')" -v c_object="$(part "the object's sections")" -v c_atoms="$(part 'the atoms and relocations')" \
            -v c_unwind="$(part 'the unwind table')" -v b_sizing="$bench_sizing" -v b_encode="$bench_encode" -v encoder="$encoder" -v sizing="$sizing" \
            -v build_cycles="$build_cycles" -v build_us="$build_us" -v in_place_us="$in_place_us" -v new_file_us="$new_file_us" -v written_kb="$written_kb" '
            function line(text, entry) { printf "%-8s %-58s %12.2f %12.2f\n", name, text, entry, entry * entries / tokens }
            BEGIN {
                printf "%-8s %d entries, %d tokens, %d records, %d objects of %d bytes\n", name, entries, tokens, records, objects, bytes
                line("in a compile: the encoder", c_encoder)
                line("in a compile: branch sizing", c_sizing)
                line("in a compile: the object", c_object)
                line("in a compile: the three", c_encoder + c_sizing + c_object)
                line("in a compile: the atoms and relocations", c_atoms)
                line("in a compile: the unwind table", c_unwind)
                line("in a compile: the five", c_encoder + c_sizing + c_object + c_atoms + c_unwind)
                line("benchmark-backend-source: encode", b_encode)
                line("benchmark-backend-source: sizing", b_sizing)
                line("benchmark-backend-source: the two", b_encode + b_sizing)
                per_byte = build_cycles / (written_kb * 1000)
                per_ns = build_cycles / (build_us * 1000)
                own_encoder = records * encoder / entries
                own_sizing = records * sizing / entries
                own_build = bytes * per_byte / entries
                line("own rate: the encoder", own_encoder)
                line("own rate: branch sizing", own_sizing)
                line("own rate: the object built", own_build)
                line("own rate: the three", own_encoder + own_sizing + own_build)
                line("own rate: the object written in place (the kernel)", bytes * in_place_us / written_kb * per_ns / entries)
                line("own rate: the object written as a new file (the kernel)", bytes * new_file_us / written_kb * per_ns / entries)
            }'
    done
} > "$out/tables/item3.txt"
cat "$out/tables/item3.txt"
