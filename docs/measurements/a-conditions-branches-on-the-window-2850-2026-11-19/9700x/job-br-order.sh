#!/bin/bash
# job-br-order.sh: the switch's executable (br1x) on musl with the settings in the other order, off, on, on, off inside
# each reading (job-upd-knob.sh's is on, off, off, on): whether what the first place of a reading reads is the
# setting's or the place's. Seven readings, CPU 2, each run its own hold of the lock.
cd "$(dirname "$0")"
label=br1x
specs=("$label order-off1 1 --shadow --passes 0 --window-contexts" "$label order-on1 0 --shadow --passes 0 --window-contexts" "$label order-on2 0 --shadow --passes 0 --window-contexts" "$label order-off2 1 --shadow --passes 0 --window-contexts")
./turns-env.sh "" 7 "musl" "${specs[@]}" || exit 1
echo job finished
