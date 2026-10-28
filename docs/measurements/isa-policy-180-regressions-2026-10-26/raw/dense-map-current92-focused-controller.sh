set -e
scp -q '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/prototype-isa-policy-dense-map-placement-census.sh' benchpress:'/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/'
bash '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/prototype-isa-policy-dense-map-placement-census-command.sh'
bash '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/dense-map-current92-policy-controller.sh'
bash '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/dense-map-screen-current92-full-controller.sh'
