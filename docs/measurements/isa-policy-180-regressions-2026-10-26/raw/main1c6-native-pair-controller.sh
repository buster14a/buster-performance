set -e
set -o pipefail
scp -q '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/prototype-base-main1c6-qualification.sh' benchpress:'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/'
bash '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/prototype-base-main1c6-qualification-command.sh'
scp -q '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/prototype-isa-policy-main1c6-qualification.sh' benchpress:'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/'
bash '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/prototype-isa-policy-main1c6-qualification-command.sh'
