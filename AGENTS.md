# buster-performance

Measurement records for [buster14a/buster](https://github.com/buster14a/buster);
its `AGENTS.md` has the rules for what goes here.

Push straight to `main`; do not open pull requests here. The owner wants records
on `main` without merging anything by hand:

```sh
git fetch origin main
git rebase origin/main
git push origin HEAD:main
```

If the push loses a race with another session, fetch, rebase and push again.
Never force-push `main`. The qualification workflows run on pushes to `main`;
check them after pushing and fix a failure with a new commit.
