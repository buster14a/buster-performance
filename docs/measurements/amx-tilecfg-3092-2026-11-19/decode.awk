# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# LLVM's Intel-syntax disassembly with raw bytes. Only the verified straight-line
# prefix is extracted for execution. All instruction bytes in .text are counted.
function fail(msg) { print FILENAME ": " msg > "/dev/stderr"; failed=1; exit 1 }
/^[[:xdigit:]]+ <\.Lbuster_builtin_[^>]+>:$/ {
    if (helper++) fail("more than one helper")
    start = strtonum("0x" $1)
}
/^[[:space:]]*[[:xdigit:]]+:/ {
    pc = strtonum("0x" substr($1, 1, length($1)-1))
    if (pc != total) fail("gap in decoded .text")
    i=2; while (length($i)==2 && $i ~ /^[[:xdigit:]]+$/) ++i
    length_bytes=i-2
    if (!length_bytes || !$i || $i ~ /unknown|^\./) fail("undecoded instruction")
    total += length_bytes
    if (!helper) next
    mnemonic=$i; asmtext=$i; for (++i;i<=NF;++i) asmtext=asmtext " " $i
    if (mnemonic=="ldtilecfg") {
        if (ld++ || asmtext!="ldtilecfg [rsp]") fail("unexpected LDTILECFG")
        load=pc
    }
    if (ld) next
    if (mnemonic !~ /^(push|mov|sub|and|xor|xorps|vxorps|movups|vmovdqu64|shr)$/) fail("unapproved prefix instruction: " asmtext)
    if (!init && mnemonic ~ /^(xor|xorps|vxorps)$/) init=pc
    if (asmtext=="mov byte ptr [rsp], 0x1") { palette=pc; clearstores=stores; clear_ins=init_ins }
    if (init) ++init_ins
    if (asmtext ~ /^(mov|movups|vmovdqu64) (byte|word|qword|xmmword|zmmword) ptr \[rsp/) ++stores
}
END {
    if (failed) exit 1
    if (helper!=1 || ld!=1 || !(start<init && init<palette && palette<load && load<total) || total!=text_size) fail("incomplete .text, helper or initializer")
    print start, init, load, total-start, clearstores, palette-init, stores, load-init, clear_ins, init_ins
}
