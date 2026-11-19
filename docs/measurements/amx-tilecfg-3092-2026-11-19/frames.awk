# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
/ FDE / {
    split($NF,range,/\.\./)
    first=strtonum("0x" substr(range[1],4)); last=strtonum("0x" range[2])
    helper=(first==start)
    if (helper && (last != start+size || ++helpers!=1)) exit 1
    next
}
$1 ~ /^[[:xdigit:]]{16}$/ && $2 ~ /^(r|exp)/ {
    pc=strtonum("0x" $1)
    if (helper) {
        ++rows
        if ((rows==1 && pc!=first) || (rows==2 && pc!=first+1) || (rows==3 && pc!=first+4) || (rows==4 && pc!=last-1)) exit 1
        $1=(rows==4 ? "ret" : "helper+" (pc-first))
    }
    print
}
END { if (helpers!=1 || rows!=4) exit 1 }
