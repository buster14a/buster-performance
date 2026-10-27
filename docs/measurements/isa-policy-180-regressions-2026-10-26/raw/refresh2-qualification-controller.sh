#!/bin/bash
set -e
scp -q '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/refresh2-base-qualification.sh' benchpress:'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/'
bash '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/refresh2-base-qualification-command.sh'
mkdir '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/refresh2-base-qualification'
tar -xf '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/refresh2-base-qualification.tar' -C '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/refresh2-base-qualification'
printf '%s
' 'base complete-fixture qualification completed'
scp -q '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/refresh2-head-qualification.sh' benchpress:'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/'
bash '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/refresh2-head-qualification-command.sh'
mkdir '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/refresh2-head-qualification'
tar -xf '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/refresh2-head-qualification.tar' -C '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/refresh2-head-qualification'
printf '%s
' 'head complete-fixture qualification completed'
