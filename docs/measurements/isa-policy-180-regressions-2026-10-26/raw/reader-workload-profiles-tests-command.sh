set -e
nice -n 19 /usr/bin/clang-23 -std=gnu17 -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer -fno-sanitize-recover=all -Wall -Wextra -Werror -DBUSTER_RECEIPT_FULL_GROUPS=0 '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/test-encoder-batch-counts.c' -o /home/david/.cache/buster421-c051/test-workload-tail
nice -n 19 /home/david/.cache/buster421-c051/test-workload-tail
nice -n 19 /usr/bin/clang-23 -std=gnu17 -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer -fno-sanitize-recover=all -Wall -Wextra -Werror -DBUSTER_RECEIPT_FULL_GROUPS=1 '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/test-encoder-batch-counts.c' -o /home/david/.cache/buster421-c051/test-workload-full
nice -n 19 /home/david/.cache/buster421-c051/test-workload-full
