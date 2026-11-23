# Counts swaps through r11 (mov A,r11; mov B,A; mov r11,B) whose third move is followed by a call within six
# instructions with no jump between; also all moves through r11.
function reset() { n = 0 }
/^[0-9a-f]+ <.*>:$/ { fn = $2; reset(); next }
/^ *[0-9a-f]+:\t/ {
    split($0, parts, "\t"); ins = parts[2]; gsub(/ +/, " ", ins)
    if (ins == "") next
    if (ins ~ /%r11/) r11 += 1
    k = ++n; text[k] = ins
    if (pending > 0) {
        since += 1
        if (ins ~ /^call/) { sites += 1; per[pfn] += 1; pending = 0 }
        else if (ins ~ /^j/ || since > 6) pending = 0
    }
    if (k >= 3 && text[k-2] ~ /^mov %r[a-z0-9]+,%r11$/ && text[k] ~ /,%r[a-z0-9]+$/ && text[k] ~ /^mov %r11,/) {
        pending = 1; since = 0; pfn = fn
    }
    next
}
END { printf "swap-sites %d r11-instructions %d\n", sites, r11; for (f in per) printf "%6d %s\n", per[f], f | "sort -rn | head -12" }
