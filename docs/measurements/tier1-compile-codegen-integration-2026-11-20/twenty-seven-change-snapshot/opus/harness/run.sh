#!/usr/bin/env bash
set -euo pipefail
w=$(pwd);p="$w/tip-evidence/opus";export CORES_LINK=https://github.com/buster14a/buster/pull/3146
for v in control candidate;do
 if [[ $v == candidate ]];then while [[ ! -f tip-evidence/built ]];do sleep 5;done;fi
 CORES_TITLE="Build four complete Opus libraries with the 27-PR $v compiler" cores -n1 -- bash -ec 'for a in x86-64-v3 znver5;do for cfg in portable-nosp dispatch-nosp;do python "$1/build.py" "$cfg" "$2" "$a";done;done' _ "$p" "$v" > "$p/build-$v.log" 2>&1
done
for arch in x86-64-v3 znver5;do
 export OPUS_TEST_ARCH="$arch"
 CORES_TITLE="Cross-check all Opus encoders and decoders across seven audio profiles ($arch)" cores -n1 -- bash -ec 'python "$1/audio.py" build;python "$1/audio.py" check' _ "$p" > "$p/audio-$arch.log" 2>&1
done
touch "$p/audio-complete"
CORES_TITLE="Run upstream Opus API, extensions, padding, encoding and decoding on the complete stack" cores -n1 -- python "$p/official.py" > "$p/official.log" 2>&1
touch "$p/official-complete"
