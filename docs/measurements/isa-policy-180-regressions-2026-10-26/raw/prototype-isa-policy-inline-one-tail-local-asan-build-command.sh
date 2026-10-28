#!/bin/bash
set -e
cd '/home/david/.cache/buster421-isa-policy-inline-one-tail'
CORES_TITLE='PR421 isa-policy-inline-one-tail sanitizer build' CORES_LINK=https://github.com/buster14a/buster/pull/421 ASAN_OPTIONS=detect_leaks=1:halt_on_error=1 UBSAN_OPTIONS=halt_on_error=1 cores -n 4 -- env PATH=/home/david/.cache/buster421-c051/sanitize-bin:/home/david/dev/scripts:/usr/local/bin:/usr/bin:/bin ./build.sh
