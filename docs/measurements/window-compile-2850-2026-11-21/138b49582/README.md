# Declaration identity and type identity at function close

The archive includes the source changes, reproduction commands and measurement records. Its SHA-256 is `059089c92cb5c03b354086718fdb7404e66585d3bb8c4e6a2e0706fc65e7a92d`. [Download the research packet](function-close-binding-proof.tar.xz).

Start with `function-close/README.md` inside the archive.

The [post-restore row lifetime and complete event reconstruction](post-restore-binding-lifetimes.tar.xz) joins the observer’s exact function-close offsets with all canonical upstream event rows. SQLite produced 138,671 body rows and Buster produced 259,471. Later source events referenced zero declaration handles created inside those windows. At the callback 11,749 SQLite and 33,997 Buster declarations still occupied the undo stack. Every one was popped in the immediately following restore. The archive also reconstructs both whole-unit logical event streams from representations of 38.22% and 39.12% of the original serialized size. Source, raw inputs and exact comparison outputs have SHA-256 `0da72b306623c84049458fd5ce70e997132f18940c046380fdcea3354da3fce4`.
