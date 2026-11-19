#!/bin/bash
# #2924 C10c's gate: APX's registers and 32-bit addresses, each entry point's vector loop against its scalar loop, with
# the encoder's last partial group by masked loads (C10b) and benchmark-x86-encoder's new --apx and --address32 streams
# (branch c10c from c10c.bundle), on the 9700X, Release, every run under the lock on CPU 2. At 1, 2, 4, 16 and 256
# instructions a call and whole: the scalar loop and the production loop (x86_encode_16_apx, x86_encode_16_address32)
# alone (--only), in turn, three rounds.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: APX's and 32-bit addresses' gate" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs
if [ ! -d src ]; then git clone -q --shared $D/../c7gate/src src || exit 1; fi
git -C src fetch -q https://github.com/buster14a/buster main claude/wonderful-wozniak-vbfba7 || { echo "fetch failed" >> logs/status.txt; exit 1; }
git -C src fetch -q "$D/c10c.bundle" "+refs/heads/c10c:refs/heads/c10c" || { echo "bundle failed" >> logs/status.txt; exit 1; }
git -C src checkout -q --detach refs/heads/c10c && git -C src reset -q --hard
git -C src rev-parse HEAD > logs/commit.txt
(cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build.log" 2>&1) || { echo "build failed" >> logs/status.txt; exit 1; }
cp src/build/compiler compiler
for mode in --apx --address32; do
    production=x86_encode_16_${mode#--}
    for section in 1 2 4 16 256 0; do
        args=("$mode")
        [ "$section" != 0 ] && args+=(--section "$section")
        for round in 1 2 3; do
            for only in scalar $production; do
                name="encoder-${mode#--}-section$section-$only-$round"
                $L timeout -k 5 900 taskset -c 2 ./compiler benchmark-x86-encoder "${args[@]}" --only $only > "logs/$name.log" 2>&1
                echo "$name: $?" >> logs/status.txt
            done
        done
    done
done
echo done >> logs/status.txt
