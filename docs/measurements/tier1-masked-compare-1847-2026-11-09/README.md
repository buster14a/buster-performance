# Tier 1 masked-compare fold (#1847, item 1): measure-tier1-rows on the 9700X

- Head: buster14a/buster `5358410f7` (tier1/1847-masked-compare's fold on main `cb608c1f6`; the PR's commit c23179c0 carries the same code onto a later main).
- Base: main `cb608c1f6`.
- Both compilers built with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh` in a cloud container and copied to benchpress.
- Command (one hold of the 9700X lock, CPU 2), run from a checkout of the base for `--src` and `--lexer`:

```
taskset -c 2 ../compiler-head measure-tier1-rows --runs 7 --clang clang --base ../compiler-base --march znver5 --src src --lexer src/buster/compiler/c_lexer.c --directory ../out
```

`rows.log` is the full output: every run's line, the medians, and the counts' and medians' tables. Clang 23.1.1.
