#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Write argument and source lists from the frozen Buster corpus and Lua 5.4.8."""

import argparse
import hashlib
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("frozen", "lua", "out"):
        parser.add_argument("--" + name, type=Path, required=True)
    args = parser.parse_args()
    frozen, lua = (p.absolute() for p in (args.frozen, args.lua))
    musl = frozen / "libc/musl"
    gen = frozen / "musl-generated/obj"
    args.out.mkdir(parents=True, exist_ok=True)
    unique = {}
    for path in sorted([*musl.glob("src/*/*.c"), *musl.glob("src/*/x86_64/*.c")]):
        unique.setdefault(path.stem, path)
    dirs = [
        musl / "arch/x86_64",
        musl / "arch/generic",
        gen / "src/internal",
        musl / "src/include",
        musl / "src/internal",
        gen / "include",
        musl / "include",
    ]
    system = ["-nostdinc"]
    for suffix in ("usr/lib/clang/23/include", "usr/local/include", "usr/include"):
        path = frozen / "headers" / suffix
        if path.is_dir():
            system.extend(["-isystem", str(path)])
    cases = {
        "musl": (
            list(unique.values()),
            [
                "-std=c99",
                "-ffreestanding",
                "-nostdinc",
                "-D_XOPEN_SOURCE=700",
                *["-I" + str(p) for p in dirs],
            ],
        ),
        "lua": (
            sorted(lua.glob("*.c")),
            ["-std=gnu99", "-DLUA_COMPAT_5_3", "-DLUA_USE_LINUX", *system],
        ),
        "sqlite": ([frozen / "sqlite/sqlite3.c"], ["-std=gnu17", *system]),
    }
    for name, (files, flags) in cases.items():
        assert files and all(p.is_file() for p in files)
        (args.out / f"{name}.files").write_text("".join(f"{p}\n" for p in files))
        (args.out / f"{name}.flags").write_text("".join(f"{s}\n" for s in flags))
        with (args.out / f"{name}.inputs.tsv").open("w") as out:
            out.write("path\tbytes\tsha256\n")
            for p in files:
                content = p.read_bytes()
                base = (
                    lua
                    if name == "lua"
                    else (musl if name == "musl" else frozen / "sqlite")
                )
                out.write(
                    f"{p.relative_to(base)}\t{len(content)}\t{hashlib.sha256(content).hexdigest()}\n"
                )


if __name__ == "__main__":
    main()
