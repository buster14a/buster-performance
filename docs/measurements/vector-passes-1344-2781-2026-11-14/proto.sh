set -u
cd /home/david/dev/ai/droid/buster
W=/home/david/.cache/droid-vector-census
D=$(ls -d $W/rows/measure-tier1-rows-*)
mkdir -p $W/proto
sha256sum $W/variants/lexer-default.o | cut -c1-16
compile() { # name passes env
  local n=$1 v=$2 e=$3
  local opt=""; [ "$v" != default ] && opt="--tier1-passes=$v"
  env $e ./build/compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing $opt -c -o $W/proto/lexer-$n.o src/buster/compiler/c_lexer_benchmark.c > $W/proto/lexer-$n.report 2>&1 || { echo "$n: compile failed"; tail -3 $W/proto/lexer-$n.report; return 1; }
  clang -o $W/proto/lexer-$n $D/lexer-main.o $W/proto/lexer-$n.o || { echo "$n: link failed"; return 1; }
}
compile default default "X=1"
sha256sum $W/proto/lexer-default.o | cut -c1-16
compile licm +licm "X=1"
compile gvn +gvn "X=1"
compile licm-gvn +licm,+gvn "X=1"
compile vlicm +licm "BUSTER_PROTO_VECTORS=1"
compile vgvn +gvn "BUSTER_PROTO_VECTORS=1"
compile vlicm-vgvn +licm,+gvn "BUSTER_PROTO_VECTORS=1"
for n in default licm gvn licm-gvn vlicm vgvn vlicm-vgvn; do
  out=""
  for r in 1 2 3 4 5; do
    l=$(taskset -c 5 $W/proto/lexer-$n $W/mid200.c 2>&1); s=$?
    c=$(echo "$l" | grep -E '^  c_tokenize ' | sed -E 's/ +/ /g' | cut -d' ' -f7)
    out="$out $c"
    [ $s -ne 0 ] && out="$out(status $s)"
  done
  i=$(taskset -c 5 $W/proto/lexer-$n $W/mid200.c 2>&1 | grep -E '^  c_tokenize ' | sed -E 's/ +/ /g' | cut -d' ' -f10)
  entry=$(nm $W/proto/lexer-$n | grep ' t c_tokenize$' | cut -d' ' -f1)
  taskset -c 5 $W/stephist --entry $entry --calls 1 --output $W/proto/mid200-$n.hist -- $W/proto/lexer-$n $W/mid200.c > $W/proto/steph-$n.log 2>&1
  echo "$n: cycles/B$out; instr/B $i; $(tail -1 $W/proto/steph-$n.log | cut -d' ' -f4) instructions"
  echo "   $(tr '\t' '\n' < $W/proto/lexer-$n.report | grep -E '^(records|spill_stores|spill_loads|rematerializations|edge_moves|licm_moved|gvn_removed)=' | tr '\n' ' ')"
done
for n in gcc32 gcc16 gcc15 gcc8; do
  out=""; for r in 1 2 3 4 5; do c=$(taskset -c 5 $W/gcc/lexer-$n $W/mid200.c 2>&1 | grep -E '^  c_tokenize ' | sed -E 's/ +/ /g' | cut -d' ' -f7); out="$out $c"; done
  echo "$n: cycles/B$out"
done
out=""; for r in 1 2 3 4 5; do c=$(taskset -c 5 $D/lexer-clang2 $W/mid200.c 2>&1 | grep -E '^  c_tokenize ' | sed -E 's/ +/ /g' | cut -d' ' -f7); out="$out $c"; done
echo "clang: cycles/B$out"
