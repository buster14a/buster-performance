#!/bin/bash
# queue3.sh once queue2.sh (PID 2069696 on the host) is done.
while kill -0 2069696 2> /dev/null; do sleep 10; done
exec ./queue3.sh
