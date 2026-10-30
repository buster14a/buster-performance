set -euo pipefail
umask 077
root=/home/david/buster-fast-bench/codex-pr914-input-binding-20261030-1856-5ea2ab42
test ! -e "$root"
test ! -L "$root"
/usr/bin/mkdir --mode=0700 -- "$root"
/usr/bin/dd iflag=fullblock,count_bytes bs=65536 count=12494 status=none conv=excl of="$root/stage-code.py"
printf '%s  %s\n' fff5bb7e02add872a01196c8f71b5f7365a1d53e6c56933ee7026d2cdf5176ae "$root/stage-code.py" | /usr/bin/sha256sum --check --strict
exec /usr/bin/python3 -I -B "$root/stage-code.py" "$root" 120730a87f18feba183edb8138a8604645305510fab1246801b9121dc43e1c5b
