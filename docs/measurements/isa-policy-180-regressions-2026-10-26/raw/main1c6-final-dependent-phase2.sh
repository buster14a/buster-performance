set -e
set -o pipefail
while [ -r /proc/2345717/stat ]; do
    read -r -a phase1_stat_421 < /proc/2345717/stat || break
    if [ "${phase1_stat_421[21]}" != '9243125' ]; then break; fi
    if [ "${phase1_stat_421[2]}" = Z ]; then break; fi
    sleep 2
done
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-backend-r1-after-encode-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-backend-r1-after-encode-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-backend-r1-after-encode-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-backend-r1-after-encode-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-backend-r1-after-encode-b02/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-backend-r1-after-encode-b02/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-backend-r2-after-encode-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-backend-r2-after-encode-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-backend-r2-after-encode-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-backend-r2-after-encode-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-backend-r2-after-encode-b02/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-backend-r2-after-encode-b02/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-backend-r3-after-encode-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-backend-r3-after-encode-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-backend-r3-after-encode-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-backend-r3-after-encode-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-backend-r3-after-encode-b02/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-backend-r3-after-encode-b02/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r1-plain-f0-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r1-plain-f0-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r1-plain-f0-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r1-plain-f0-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r1-plain-f1-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r1-plain-f1-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r1-plain-f1-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r1-plain-f1-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r1-plain-f2-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r1-plain-f2-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r1-plain-f2-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r1-plain-f2-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r1-plain-f3-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r1-plain-f3-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r1-plain-f3-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r1-plain-f3-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r1-after30-f0-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r1-after30-f0-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r1-after30-f1-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r1-after30-f1-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r1-after30-f2-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r1-after30-f2-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r1-after30-f3-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r1-after30-f3-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r2-plain-f0-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r2-plain-f0-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r2-plain-f0-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r2-plain-f0-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r2-plain-f1-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r2-plain-f1-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r2-plain-f1-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r2-plain-f1-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r2-plain-f2-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r2-plain-f2-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r2-plain-f2-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r2-plain-f2-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r2-plain-f3-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r2-plain-f3-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r2-plain-f3-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r2-plain-f3-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r2-after30-f0-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r2-after30-f0-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r2-after30-f1-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r2-after30-f1-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r2-after30-f2-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r2-after30-f2-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r2-after30-f3-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r2-after30-f3-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r3-plain-f0-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r3-plain-f0-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r3-plain-f0-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r3-plain-f0-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r3-plain-f1-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r3-plain-f1-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r3-plain-f1-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r3-plain-f1-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r3-plain-f2-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r3-plain-f2-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r3-plain-f2-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r3-plain-f2-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r3-plain-f3-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r3-plain-f3-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r3-plain-f3-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r3-plain-f3-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r3-after30-f0-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r3-after30-f0-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r3-after30-f1-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r3-after30-f1-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r3-after30-f2-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r3-after30-f2-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r3-after30-f3-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-r3-after30-f3-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r1-plain-f0-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r1-plain-f0-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r1-plain-f0-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r1-plain-f0-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r1-plain-f1-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r1-plain-f1-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r1-plain-f1-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r1-plain-f1-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r1-plain-f2-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r1-plain-f2-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r1-plain-f2-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r1-plain-f2-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r1-plain-f3-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r1-plain-f3-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r1-plain-f3-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r1-plain-f3-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r1-after30-f0-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r1-after30-f0-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r1-after30-f1-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r1-after30-f1-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r1-after30-f2-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r1-after30-f2-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r1-after30-f3-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r1-after30-f3-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r2-plain-f0-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r2-plain-f0-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r2-plain-f0-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r2-plain-f0-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r2-plain-f1-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r2-plain-f1-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r2-plain-f1-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r2-plain-f1-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r2-plain-f2-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r2-plain-f2-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r2-plain-f2-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r2-plain-f2-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r2-plain-f3-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r2-plain-f3-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r2-plain-f3-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r2-plain-f3-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r2-after30-f0-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r2-after30-f0-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r2-after30-f1-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r2-after30-f1-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r2-after30-f2-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r2-after30-f2-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r2-after30-f3-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r2-after30-f3-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r3-plain-f0-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r3-plain-f0-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r3-plain-f0-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r3-plain-f0-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r3-plain-f1-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r3-plain-f1-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r3-plain-f1-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r3-plain-f1-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r3-plain-f2-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r3-plain-f2-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r3-plain-f2-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r3-plain-f2-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r3-plain-f3-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r3-plain-f3-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r3-plain-f3-b01/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r3-plain-f3-b01/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r3-after30-f0-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r3-after30-f0-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r3-after30-f1-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r3-after30-f1-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r3-after30-f2-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r3-after30-f2-b00/harness.err'
read -r phase1_exit_421 < '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r3-after30-f3-b00/exit.txt'
test "$phase1_exit_421" = 0
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-r3-after30-f3-b00/harness.err'
ASAN_OPTIONS=detect_leaks=1:halt_on_error=1 UBSAN_OPTIONS=halt_on_error=1 '/home/david/.cache/buster421-c051/read-modern-full' '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/' '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-manifest.tsv' > '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-summary.tsv' 2> '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-summary.err'
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-full-summary.err'
ASAN_OPTIONS=detect_leaks=1:halt_on_error=1 UBSAN_OPTIONS=halt_on_error=1 '/home/david/.cache/buster421-c051/read-modern-tail' '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/' '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-manifest.tsv' > '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-summary.tsv' 2> '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-summary.err'
test ! -s '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-tail-summary.err'
bash '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-phase2-controller.sh'
printf '0\n' > '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/main1c6-final-all-runs.exit'
