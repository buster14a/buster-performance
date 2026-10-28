set +e
nice -n 19 /home/david/.cache/buster421-c051/test-workload-tail > /dev/full 2> raw/reader-workload-profiles-tail-full.err
profile_tail_status421=$?
nice -n 19 /home/david/.cache/buster421-c051/test-workload-full > /dev/full 2> raw/reader-workload-profiles-full-full.err
profile_full_status421=$?
nice -n 19 /home/david/.cache/buster421-c051/read-profile-legacy36 raw raw/final-encoder-manifest.tsv > /dev/full 2> raw/reader-workload-profiles-reader-full.err
profile_reader_status421=$?
printf 'tail_fixture_stdout_failure=%s\nfull_fixture_stdout_failure=%s\nlegacy_reader_stdout_failure=%s\n' "$profile_tail_status421" "$profile_full_status421" "$profile_reader_status421" > raw/reader-workload-profiles-output-failure.log
test "$profile_tail_status421" -eq 1 && test "$profile_full_status421" -eq 1 && test "$profile_reader_status421" -eq 1
