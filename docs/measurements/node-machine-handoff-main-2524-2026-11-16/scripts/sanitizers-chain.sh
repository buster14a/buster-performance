#!/bin/bash
until grep -q "all done" /tmp/claude-0/-home-user/743aa3e7-1556-5d1b-ba6c-46b8ead1bd58/scratchpad/san12/progress.txt 2>/dev/null; do sleep 20; done
sed -i 's/^all done$/first set done/' /tmp/claude-0/-home-user/743aa3e7-1556-5d1b-ba6c-46b8ead1bd58/scratchpad/san12/progress.txt
/tmp/claude-0/-home-user/743aa3e7-1556-5d1b-ba6c-46b8ead1bd58/scratchpad/san12/run2.sh > /tmp/claude-0/-home-user/743aa3e7-1556-5d1b-ba6c-46b8ead1bd58/scratchpad/san12/run2.log 2>&1
