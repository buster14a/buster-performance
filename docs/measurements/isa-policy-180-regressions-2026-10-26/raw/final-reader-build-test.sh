set -e
clang --version
cd '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/'
clang -std=c17 -O1 -g -Wall -Wextra -Werror -fsanitize=address,undefined -fno-sanitize-recover=all -fno-omit-frame-pointer test-current-encoder-reader.c -o /home/david/.cache/buster421-c051/test-reader-final-default
/home/david/.cache/buster421-c051/test-reader-final-default '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/'
clang -std=c17 -O1 -g -Wall -Wextra -Werror -fsanitize=address,undefined -fno-sanitize-recover=all -fno-omit-frame-pointer -DBUSTER_RECEIPT_BATCH_SIZE=36 -DBUSTER_RECEIPT_AFTER_MS=30 test-current-encoder-reader.c -o /home/david/.cache/buster421-c051/test-reader-final-36
/home/david/.cache/buster421-c051/test-reader-final-36 '/home/david/Documents/Codex/2026-10-25/work-on-https-github-com-buster14a/work/buster-performance/docs/measurements/isa-policy-180-regressions-2026-10-26/raw/' final-encoder-r1-plain-f0-b00
clang -std=c17 -O1 -g -Wall -Wextra -Werror -fsanitize=address,undefined -fno-sanitize-recover=all -fno-omit-frame-pointer -DBUSTER_RECEIPT_BATCH_SIZE=36 -DBUSTER_RECEIPT_AFTER_MS=30 read-current-encoder.c -o /home/david/.cache/buster421-c051/read-refresh-encoder
