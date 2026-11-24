# Header images in the preprocessor: a segment's work kept by what it read (2026-11-24)

Evidence for [buster#3070](https://github.com/buster14a/buster/issues/3070)'s step 2, its first piece as the issue's
[design note](https://github.com/buster14a/buster/issues/3070#issuecomment-7116864609) has it (2a): a header segment's
tokens and macro effects kept on a units lane under the macros it looked up, and taken by the lane's later units in
place of the segment's run. **It is exact and it does not pay enough: 4.1% of musl's command on one lane, nothing on
four. It is not merged; the patch is here.**

- **Source:** buster main `3723f1f6` with the root image's pull request
  ([buster#3475](https://github.com/buster14a/buster/pull/3475), `0b008cf1`), which is `base`; the patch
  (`scripts/patch/header-images.patch`, against that commit) is `on` with `--header-images=on` and `off` with
  `--header-images=off`. Built `./build.sh --config Release` on the 9700X under the lock (`scripts/images-run.sh`). The
  9700X's runs are of the patch before its last changes (the fixtures, a test's section and its fault, verify's wider
  comparison, the repair's copy of the preprocessor kept out of the images), none of them in the path of a command
  that takes images or has them off.
- **Hosts:** the 9700X for every timing (each round of `scripts/measure2.sh` one hold of the lock, the configurations in
  an order that rotates by round; CPU 2 for one lane, CPUs 2 to 5 for four); a cloud container for the counts and the
  exactness checks.
- **Workloads:** the root image's record's: 1,336 empty units, musl's 1,336 units on one lane and on four, Lua 5.4.8's
  34 units.

## In short

- **musl's command on one lane: 3,178.3 to 3,041.7 M cycles, −4.1% (−130 M), lower in 5 rounds of 5.** Lua's: −3.8%
  (−13.7 M), 5 of 5. Its user instructions fall 12.3% (6,433 to 5,645 M): the work taken away was cheaper by the
  instruction than the work added.
- **On four lanes it is 1.1% slower** (0 of 5 lower): each lane makes its own images, so each records every key again
  and holds its own copy.
- **Switched off, the patch costs musl's command 0.85%** (+27 M cycles, +55 M instructions, 0 of 5 lower): its hooks in
  the preprocessor's lookups and steps.
- **The gate was 300 M cycles off musl's command, refuted under 150 M.** It is refuted.
- **Why:** the preprocessor's own work falls by 235 M cycles (18.3% of the command to 10.7%), and the images' own work
  is 110 M of that back (`pp_image_begin` 2.25% of the command, `pp_image_end` 1.02%, the logs and the places 0.4%). What
  the images can't reach is the rest of the preprocessor's 431 M: the units' own files, each inclusion's lookup, the
  first sight of each key (13% of header tokens, on the slower path that records them), and the 250 units that
  preprocess again with their history for a warning, without images.
- **Exact:** musl (one lane and four), Lua under `-Wall -Wextra`, `sqlite3.c` with `shell.c`, c-testsuite's 220
  programs and the fixtures: every object and diagnostic with the images taken is the one without, and no segment
  differs from the image its key has (`--header-images=verify`).

## 1. What was built

`--header-images=on|off|verify` (off by default), for the units of a command of several source files on a lane that has
a root image (`PPImages`, the root's; the patch's comment at `PPImages` in `c_preprocessor.c` has the whole of it):

- **A segment** is a file's processing from its entry, or its return from a nested inclusion, to its next inclusion's
  directive or its end, in a file that isn't the unit's own.
- **Its start:** the file's cache record, its token and next directive, the inclusion's system level, whether its
  guard's group was taken, and the conditions open above the file's base.
- **Its keys:** each macro name it looked up before setting it, in order, with the identity of what the name had:
  nothing, the root image's macro id, or the defining file's cache record and the name's place there. An image's keys
  are two flat arrays, compared with the unit's answers eight at a time (the names' macros gathered, then the macros'
  identities from a table by macro id); where two images of one start part, a table of branches has the image for the
  unit's answer there.
- **What an image holds:** the tokens (kinds, flags, values and places, each on a base its reference names: none, the
  inclusion's own range, a key macro's defining range, a spelling the segment generated), the spellings, the macro
  records made and each name's last write, the conditions left open, the uses of `__FLT_EVAL_METHOD__`, and where it
  stopped. A hit appends the tokens 16 at a time with their bases gathered, makes the spellings again, appends the
  records and makes the writes.
- **The recorder:** while a segment is recorded every lookup, write and spelling is logged, and every fast path of the
  expansion stands back, so that the lookups are the general path's in one order whatever the unit compiled before
  (without that, glibc's `bits/mathcalls.h` gave keys that parted on different names). A segment is refused where it
  reported or weighed a diagnostic, read a directive or builtin that depends on the unit, began or ended with anything
  open, or changed a byte of the `Preprocessor` outside the fields an image holds or that only cache (a mask of the
  struct, compared before and after). A refused segment leaves its keys with its reason, so that later units run it
  unrecorded.
- **verify** takes no image, records every segment and compares one whose keys an image has with that image; a
  difference fails the unit. It found two faults of the build on the way: a spelling a unit makes in the root's last
  scratch chunk was taken for the root's own (glibc's `signal.h`; the unit's history replay caught the same), and its
  own comparison read half of the base references (a test's fault in an image, `BUSTER_TEST_IMAGE_DIRT`, caught that).

## 2. The lanes' workloads (9700X, `results/images2`, 5 rounds)

Medians, M cycles, and each configuration against `base` paired by round:

| workload | base | on | off |
| --- | ---: | --- | --- |
| 1,336 empty units | 164.4 | 168.3, +3.0% (lower in 2 of 5) | 163.5, −0.5% (3 of 5) |
| musl, one lane | 3,178.3 | 3,041.7, −4.1% (5 of 5) | 3,198.7, +0.85% (0 of 5) |
| musl, four lanes | 3,928.3 | 3,963.2, +1.1% (0 of 5) | 3,968.5, +1.0% (1 of 5) |
| Lua, one lane | 363.8 | 350.4, −3.8% (5 of 5) | 364.5, +0.2% (0 of 5) |

| musl, one lane | user | kernel | user instructions |
| --- | ---: | ---: | ---: |
| base | 2,592.2 | 580.6 | 6,432.8 |
| on | 2,455.5 | 586.5 | 5,644.6 |
| off | 2,622.8 | 581.3 | 6,488.2 |

The empty units' +3% with the images on is a lane's setup of them (its tables cleared, 1.5 MB of them the branches').

## 3. Where the cycles are with the images taken (9700X, `results/profile-musl-images2`)

`perf record` of musl's command with `--header-images=on` (2,449.3 M user and 547.7 M kernel cycles in that hold),
by stage as [header-work-3070-2026-11-23](../header-work-3070-2026-11-23)'s section 1 has the command without them:

| stage | without | with the images |
| --- | ---: | ---: |
| the preprocessor | 18.3% | 14.4% |
| of it, the images' own (`pp_image_*`) | | 3.7% |
| the reader | 18.1% | 18.4% |
| the kernel | 16.5% | 18.2% |
| the checker's other passes | 14.8% | 14.3% |
| the parser | 6.0% | 6.8% |
| the attested passes | 4.8% | 4.9% |

- `pp_image_begin` (the keys' walk and the hit) is 2.25% of the command, about 1,500 cycles a hit: an image's keys,
  tokens and records are read from memory that is cold between two units' hits, the names' macros are gathered from
  all over their table, and the names' writes are scattered stores.
- `pp_image_end` is 1.02%: 3,359 recordings.
- What is left of the preprocessor's own: `pp_prepared_directive` 1.44% (3.40% without), `pp_run_contexts` 1.22%
  (1.99%), `pp_evaluate_value` 0.65% (1.63%), `pp_start_condition` 0.41% (1.44%), and each inclusion's lookup as it was
  (`pp_lookup_path` 0.59%, `pp_find_include` 0.30%, `pp_scan_header_bytes` 0.26%).

## 4. The counts (container, `--time-stages`)

| one lane | segments | taken | tokens taken | recorded | tokens recorded | refused or run unrecorded | not started |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| musl's 1,336 units | 47,621 | 44,262 | 4,083,133 | 3,359 | 613,913 | 0 | 4,538 |
| Lua's 34 units | 9,727 | 7,804 | 292,744 | 443 | 24,220 | 1,480 | 798 |
| `sqlite3.c` and `shell.c` | 999 | 316 | 2,489 | 521 | 55,918 | 162 | 188 |

- musl's header tokens are 4,697,046: 86.9% are taken from an image. The census of the keys
  ([build-images-2026-11-19](../build-images-2026-11-19), section 2) had 93.96% in repeated keys; it named a
  definition by its text, and a macro that each unit's own file defines (`_GNU_SOURCE`) is another definition in each
  here, by its place.
- musl's keys are 2,064,916 names walked for 47,621 starts, 43 a start.
- Lua's refusals are small segments: a builtin whose answer isn't the keys' (1,240 segments of 510 tokens), a
  diagnostic weighed (34), something open (206).

## 5. Exactness (container)

- musl's 1,336 units, one lane and four: objects (`sha256sum` of every `.o`) and diagnostics with `on` the ones
  without; with `verify`, 44,262 segments compared with their images, none differing.
- Lua's 34 units under `-Wall -Wextra`, and `sqlite3.c` with `shell.c`: the same.
- `test-check-units --corpus build/c-testsuite/tests/single-exec` with `--option --header-images=on` and `=verify`: 220
  objects as alone, plainly and with the lanes' arenas poisoned.
- `tests/units/header-images` (the patch's: 22 units over 11 headers, among them
  [buster#3212](https://github.com/buster14a/buster/issues/3212)'s two cases, one file under two names with `__FILE__`
  and a macro popped after its undefinition) and `tests/units/root-image`: every object as alone with `on` and `verify`.
- `test-check-units` (the patch adds a section): 2,093 checks, 0 failures; in it, 13 kinds of fault in a new image
  each fail verify's command.

## 6. What it says for the design

- **The preprocessor is the small part of the headers' work**, and half of what it does there can't be taken by a
  lane's own images: taking every header segment's run away for nothing would be worth about 235 M cycles of musl's
  3,178 M.
- **Images a lane makes for itself lose to their own making on four lanes.** They have to be the build's (the issue's
  step 3) before they are worth their keys there.
- **The hooks have to cost nothing when no segment is recorded.** These cost 0.85%.
- **A unit that warns preprocesses twice**, the second time with its history and without images: 250 of musl's units
  (the driver's census in [build-images-2026-11-19](../build-images-2026-11-19), section 2), most of them for one
  warning in one header's function.

## Reproducing

```sh
# On the 9700X, in ~/buster-fast-bench/3070-claude-euler (the root image's record's setup): pr/ is buster#3475's head.
./images-run.sh images2 $PWD/images2.patch 5        # scripts/patch/header-images.patch, built and measured
./profile-musl.sh $PWD/bin/images2-on $PWD/results/profile-musl-images2   # bin/images2-on: images2 --header-images=on "$@"
python3 scripts/stage-table.py results/profile-musl-images2/musl-flat.txt
# In a checkout of 0b008cf1 with the patch applied and built:
build/compiler -c --lanes 1 --header-images=verify --time-stages OPTIONS UNITS
build/compiler test-check-units --corpus tests/units/header-images --option --lanes --option 1 --option --header-images=on
```
