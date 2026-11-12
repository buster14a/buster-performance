#!/bin/bash
# ladder-build.sh [NAME...]: speedtest1 and Lua built by clang and LLVM's own tools in many configurations (the
# "ladder"), to rank what separates --tier1 from clang -O2 by run time: clang -O2 with one thing taken away (top-down),
# and a minimal pipeline, mem2reg with SCCP, dead code and CFG cleanup as --tier1's is, with one thing added
# (bottom-up), each over LLVM's -O2 backend or that backend with a piece disabled. Run inside one hold of the lock
# (lock.sh ./ladder-build.sh); the builds run at once on the machine's cores. scratch/ladder/NAME/{speedtest1,lua},
# results/ladder/builds.tsv (name, status, text bytes), results/ladder/NAME.log.
#
# Kinds of rows in the table below:
#   cc    COMPILER FLAGS...                the harness's own recipe with that compiler and flags
#   opt   FRONT-FLAGS | PIPELINE | LLC | OPT   clang FRONT-FLAGS -Xclang -disable-llvm-passes to bitcode, opt OPT
#                                          -passes=PIPELINE (O2 is default<O2>; "O2 sed SCRIPT" edits its printed text),
#                                          llc -O2 LLC
set -u
cd "$(dirname "$0")"
out=$PWD/results/ladder
work=$PWD/scratch/ladder
mkdir -p "$out" "$work"
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
head -1 /var/lib/buster-9700x/owner >> "$out/holders.txt"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
inputs=$PWD/inputs
lua=$inputs/lua-5.4.8/src
lua_sources="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
sqlite_flags="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite -I$inputs"
lua_flags="-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX"
m2r='function(mem2reg,sccp,adce,simplifycfg)'
clean='function(sccp,adce,simplifycfg)'

# name|kind|a|b|c|d (d: opt's extra flags)
table()
{
    cat <<TABLE
O2|cc|clang -O2
O1|cc|clang -O1
O0|cc|clang -O0
O3|cc|clang -O3
gcc-O2|cc|gcc -O2
O2-nossp|cc|clang -O2 -fno-stack-protector
O2-noinline|cc|clang -O2 -fno-inline
O2-nostrict|cc|clang -O2 -fno-strict-aliasing
O2-novec|cc|clang -O2 -fno-vectorize -fno-slp-vectorize
O2-nounroll|cc|clang -O2 -fno-unroll-loops
O2-basicra|cc|clang -O2 -mllvm -regalloc=basic
O2-nojoin|cc|clang -O2 -mllvm -join-liveintervals=false
O2-nomachine|cc|clang -O2 -mllvm -disable-machine-licm -mllvm -disable-machine-cse -mllvm -disable-machine-sink
O2-notaildup|cc|clang -O2 -mllvm -disable-tail-duplicate -mllvm -disable-early-taildup
O2-noplacement|cc|clang -O2 -mllvm -disable-block-placement
O2-nocgp|cc|clang -O2 -mllvm -disable-cgp
O2-nolsr|cc|clang -O2 -mllvm -disable-lsr
P-O2|opt|-O2|O2|
P-nogvn|opt|-O2|O2 sed s/,gvn<>//|
P-nolicm|opt|-O2|O2 sed s/,licm<[^>]*>//g;s/loop-mssa(licm<allowspeculation>),//g|
P-noinstcombine|opt|-O2|O2 sed s/,instcombine<[^>]*>//g;s/,aggressive-instcombine//|
P-nojt|opt|-O2|O2 sed s/,jump-threading//g;s/,dfa-jump-threading//;s/,correlated-propagation//g|
P-noearlycse|opt|-O2|O2 sed s/,early-cse<[^>]*>//g|
P-nodse|opt|-O2|O2 sed s/,dse//;s/,memcpyopt//|
P-nosroa|opt|-O2|O2 sed s/,sroa<[^>]*>//g;s/(sroa<[^>]*>,/(/g|
P-norotate|opt|-O2|O2 sed s/,loop-rotate<[^>]*>//g;s/loop(loop-rotate<[^>]*>,/loop(/|
P-noinline|opt|-O2|O2 sed s/(inline,/(/|
B|opt|-O2|$m2r|
B-nossp|opt|-O2 -fno-stack-protector|$m2r|
B+inline|opt|-O2|$m2r,cgscc(inline),$clean|
B+sroa|opt|-O2|function(sroa,sccp,adce,simplifycfg)|
B+instcombine|opt|-O2|function(mem2reg,instcombine<no-verify-fixpoint>,sccp,adce,simplifycfg)|
B+inline+sroa+cse|opt|-O2|function(sroa,early-cse<memssa>,sccp,adce,simplifycfg),cgscc(inline),function(sroa,early-cse<memssa>,sccp,adce,simplifycfg)|
B+sroa+cse|opt|-O2|function(sroa,early-cse<memssa>,sccp,adce,simplifycfg)|
B+earlycse|opt|-O2|function(mem2reg,early-cse<memssa>,sccp,adce,simplifycfg)|
B+gvn|opt|-O2|function(mem2reg,sccp,adce,simplifycfg,gvn,adce,simplifycfg)|
B+gvn-nostrict|opt|-O2 -fno-strict-aliasing|function(mem2reg,sccp,adce,simplifycfg,gvn,adce,simplifycfg)|
B+licm|opt|-O2|function(mem2reg,sccp,adce,simplifycfg,loop-mssa(licm),adce,simplifycfg)|
B+jt|opt|-O2|function(mem2reg,sccp,adce,simplifycfg,jump-threading,correlated-propagation,adce,simplifycfg)|
B+rotate|opt|-O2|function(mem2reg,sccp,adce,simplifycfg,loop(loop-rotate),simplifycfg)|
B-basicra|opt|-O2|$m2r|-regalloc=basic
B-fastra|opt|-O2|$m2r|-regalloc=fast
B-nojoin|opt|-O2|$m2r|-join-liveintervals=false
B-nomachine|opt|-O2|$m2r|-disable-machine-licm -disable-machine-cse -disable-machine-sink
B-notaildup|opt|-O2|$m2r|-disable-tail-duplicate -disable-early-taildup
B-noplacement|opt|-O2|$m2r|-disable-block-placement
B-nocgp|opt|-O2|$m2r|-disable-cgp
B-nolsr|opt|-O2|$m2r|-disable-lsr
B-nopeephole|opt|-O2|$m2r|-disable-peephole -disable-copyprop
B-llcO0|opt|-O2|$m2r|-O0
B-weak|opt|-O2|$m2r|-regalloc=basic -join-liveintervals=false -disable-machine-licm -disable-machine-cse -disable-machine-sink -disable-tail-duplicate -disable-early-taildup -disable-cgp -disable-lsr
Bw+inline|opt|-O2|$m2r,cgscc(inline),$clean|-regalloc=basic -join-liveintervals=false -disable-machine-licm -disable-machine-cse -disable-machine-sink -disable-tail-duplicate -disable-early-taildup -disable-cgp -disable-lsr
Bf+inline|opt|-O2|$m2r,cgscc(inline),$clean|-regalloc=fast
B+inline10|opt|-O2|$m2r,cgscc(inline),$clean||-inline-threshold=10
B+inline25|opt|-O2|$m2r,cgscc(inline),$clean||-inline-threshold=25
B+inline50|opt|-O2|$m2r,cgscc(inline),$clean||-inline-threshold=50
B+inline100|opt|-O2|$m2r,cgscc(inline),$clean||-inline-threshold=100
B+inline500|opt|-O2|$m2r,cgscc(inline),$clean||-inline-threshold=500
TABLE
}

pipeline()
{
    # $1: the table's pipeline field. Prints opt's -passes text.
    case $1 in
        O2) printf 'default<O2>' ;;
        "O2 sed "*) sed -e "${1#O2 sed }" "$work/o2.txt" | tr -d '\n' ;;
        *) printf '%s' "$1" ;;
    esac
}

one()
{
    local name=$1 kind=$2 a=$3 b=${4-} c=${5-} optflags=${6-}
    local d=$work/$name status=0
    rm -rf "$d"; mkdir -p "$d"
    {
        echo "## $name | $kind | $a | $b | $c | $optflags"
        if [ "$kind" = cc ]; then
            # The harness's recipe: an object of each of speedtest1's files and a link; Lua in one command.
            $a $sqlite_flags -c -o "$d/sqlite3.o" "$sqlite/sqlite3.c" || status=1
            $a $sqlite_flags -c -o "$d/speedtest1.o" "$inputs/speedtest1.c" || status=1
            $a -o "$d/speedtest1" "$d/speedtest1.o" "$d/sqlite3.o" -lm || status=1
            local sources=(); for s in $lua_sources; do sources+=("$lua/$s.c"); done
            $a $lua_flags -o "$d/lua" "${sources[@]}" -lm -ldl || status=1
        else
            local passes; passes=$(pipeline "$b")
            echo "passes: $passes"
            # llc's level is -O2 unless the row's flags give one.
            local level=-O2
            case $c in -O*) level= ;; esac
            compile()
            {
                # $1 object, $2 source, then the front end's flags
                local object=$1 source=$2; shift 2
                clang $a "$@" -Xclang -disable-llvm-passes -emit-llvm -c -o "$object.0.bc" "$source" &&
                    opt $optflags "-passes=$passes" -o "$object.bc" "$object.0.bc" &&
                    llc $level -filetype=obj -relocation-model=pic $c -o "$object" "$object.bc" && rm -f "$object.0.bc" "$object.bc"
            }
            compile "$d/sqlite3.o" "$sqlite/sqlite3.c" $sqlite_flags || status=1
            compile "$d/speedtest1.o" "$inputs/speedtest1.c" $sqlite_flags || status=1
            clang -O2 -o "$d/speedtest1" "$d/speedtest1.o" "$d/sqlite3.o" -lm || status=1
            local objects=()
            for s in $lua_sources; do
                compile "$d/$s.o" "$lua/$s.c" $lua_flags || status=1
                objects+=("$d/$s.o")
            done
            clang -O2 -o "$d/lua" "${objects[@]}" -lm -ldl || status=1
        fi
        echo "status $status"
    } > "$out/$name.log" 2>&1
    local text_st text_lua
    text_st=$(size -A "$d/speedtest1" 2>/dev/null | awk '$1 == ".text" { print $2 }')
    text_lua=$(size -A "$d/lua" 2>/dev/null | awk '$1 == ".text" { print $2 }')
    printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$name" "$status" "${text_st:-0}" "${text_lua:-0}" "$(sha256sum < "$d/speedtest1" | cut -c1-16)" "$(sha256sum < "$d/lua" | cut -c1-16)"
}

# The printed -O2 pipeline, which the sed rows edit (opt's own text for this LLVM).
printf 'int f(int x) { return x + 1; }\n' > "$work/pipe.c"
clang -O2 -Xclang -disable-llvm-passes -emit-llvm -c "$work/pipe.c" -o "$work/pipe.bc"
opt '-passes=default<O2>' -print-pipeline-passes -disable-output "$work/pipe.bc" > "$work/o2.txt"
cp "$work/o2.txt" "$out/o2-pipeline.txt"
{ clang --version | head -1; opt --version | sed -n 2p; llc --version | sed -n 2p; gcc --version | head -1; } > "$out/tools.txt"

export -f one pipeline; export out work sqlite inputs lua lua_sources sqlite_flags lua_flags m2r clean
if [ $# -eq 0 ]; then
    table
else
    for name in "$@"; do table | grep -F -- "$name|" | awk -F'|' -v n="$name" '$1 == n'; done
fi | tr '\n' '\0' | xargs -0 -P 7 -I{} bash -c 'IFS="|" read -r name kind a b c d <<< "$1"; one "$name" "$kind" "$a" "$b" "$c" "$d"' _ {} >> "$out/builds.tsv"
sort -o "$out/builds.tsv" "$out/builds.tsv"
date -u +%FT%TZ > "$out/build.done"
