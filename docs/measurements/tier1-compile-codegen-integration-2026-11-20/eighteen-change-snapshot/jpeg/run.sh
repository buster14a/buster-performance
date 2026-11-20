#!/usr/bin/env bash
set -euo pipefail
w=$(pwd);p="$w/eighteen-evidence/jpeg";up="$w/independent-corpus/libjpeg-turbo-3.1.3"
cc=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
export SOURCE_DATE_EPOCH=1792454400 LC_ALL=C
while [[ ! -f "$w/eighteen-evidence/compilers-ready" ]];do sleep 5;done
for v in clang control candidate;do
 out="$p/$v"
 cmake -S "$up" -B "$out" -G Ninja -DCMAKE_BUILD_TYPE=Release "-DCMAKE_C_COMPILER=$cc" "-DCMAKE_C_COMPILER_LAUNCHER=python;$p/launch-compile.py;$v" -DCMAKE_C_FLAGS=-march=x86-64-v3 -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DWITH_SIMD=OFF -DWITH_TURBOJPEG=OFF -DENABLE_SHARED=OFF -DENABLE_STATIC=ON >"$p/$v-configure.log" 2>&1
 set +e
 CORES_TITLE="Compile the official libjpeg-turbo applications and static library ($v)" CORES_LINK=https://github.com/buster14a/buster/pull/3136 cores -n 1 -- ninja -C "$out" -j1 -k 0 >"$p/$v-build.log" 2>&1
 rc=$?;echo "$rc" >"$p/$v-build.status"
 if [[ -x $out/cjpeg-static && -x $out/djpeg-static ]];then
  CORES_TITLE="Run the upstream libjpeg-turbo test images and checksums ($v)" CORES_LINK=https://github.com/buster14a/buster/pull/3136 cores -n 1 -- ctest --test-dir "$out" -j1 --output-on-failure --output-junit "$p/$v-ctest.xml" >"$p/$v-tests.log" 2>&1
  echo "$?" >"$p/$v-tests.status"
 fi
 set -e
done
touch "$p/official-done"
