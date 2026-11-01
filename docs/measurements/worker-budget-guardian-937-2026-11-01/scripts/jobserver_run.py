#!/usr/bin/env python3
"""Run a command under a synthetic GNU make jobserver with spare tokens.

Creates one pipe of N token bytes, passes it as MAKEFLAGS' --jobserver-auth,
then runs the command and reports its wall time, exit status, stderr, and how
many tokens the command returned.
"""
import argparse
import os
import subprocess
import sys
import time


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--tokens", type=int, default=7)
    parser.add_argument("--jobs", type=int, default=8)
    parser.add_argument("--stdout", default=os.devnull)
    parser.add_argument("command", nargs=argparse.REMAINDER)
    args = parser.parse_args()
    command = args.command
    if command and command[0] == "--":
        command = command[1:]
    if not command:
        parser.error("no command")
    read_fd, write_fd = os.pipe()
    os.set_blocking(read_fd, False)
    os.set_blocking(write_fd, False)
    os.write(write_fd, b"+" * args.tokens)
    os.set_inheritable(read_fd, True)
    os.set_inheritable(write_fd, True)
    env = dict(os.environ)
    env["MAKEFLAGS"] = f" -j{args.jobs} --jobserver-auth={read_fd},{write_fd}"
    with open(args.stdout, "wb") as out:
        start = time.perf_counter_ns()
        proc = subprocess.run(
            command,
            stdout=out,
            stderr=subprocess.PIPE,
            env=env,
            pass_fds=(read_fd, write_fd),
        )
        end = time.perf_counter_ns()
    returned = 0
    try:
        while True:
            chunk = os.read(read_fd, 4096)
            if not chunk:
                break
            returned += len(chunk)
    except BlockingIOError:
        pass
    os.close(read_fd)
    os.close(write_fd)
    sys.stderr.buffer.write(proc.stderr)
    print(
        f"RESULT status={proc.returncode} wall_ns={end - start} "
        f"tokens_in={args.tokens} tokens_returned={returned}",
        file=sys.stderr,
    )
    return proc.returncode


if __name__ == "__main__":
    raise SystemExit(main())
