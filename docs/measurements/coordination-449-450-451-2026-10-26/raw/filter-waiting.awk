# Remove only queued-wait owner metadata, which can contain another session's private chat link.
# Actual acquired-owner receipts, commands, observations, statuses and timestamps remain verbatim.
/^exclusive.sh: waiting for the 9700X, held by:/ { waiting = 1; next }
waiting && /^  (title|link|pull request):/ { next }
/^cores: #[0-9]+ waits for / { print "cores: waiting-owner metadata removed; grant and elapsed wait retained below"; next }
{ waiting = 0; print }
