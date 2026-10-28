#!/bin/bash
set -e
cd '/home/david/.cache/buster421-isa-policy-constructor-home'
CORES_TITLE='PR421 constructor oracle owning home sanitizer matrix' CORES_LINK=https://github.com/buster14a/buster/pull/421 ASAN_OPTIONS=detect_leaks=1:halt_on_error=1 UBSAN_OPTIONS=halt_on_error=1 cores -n 4 -- ./build/compiler parallel --jobs 4 --timeout 120 '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/current-tests-split.list'
