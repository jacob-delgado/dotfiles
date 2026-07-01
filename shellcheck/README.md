# shellcheck

Stow package for `~/.shellcheckrc`. shellcheck is the de-facto shell
script linter. Used by `lefthook` on pre-commit, ALE in vim, and by
hand.

## Table of contents

- [Layout](#layout)
- [What's enabled / disabled](#whats-enabled--disabled)
- [Per-project overrides](#per-project-overrides)
- [Fresh-machine setup](#fresh-machine-setup)

## Layout

| File                       | Stows to          |
| -------------------------- | ----------------- |
| `shellcheck/.shellcheckrc` | `~/.shellcheckrc` |

## What's enabled / disabled

```ini
enable=all
shell=bash
external-sources=true

disable=SC2034   # variable appears unused (false positive in sourced libs)
disable=SC1090   # can't follow non-constant source
disable=SC1091   # can't find source file
```

The `enable=all` turns on shellcheck's optional checks (literal numeric
comparison, etc.) — more signal at the cost of slightly more verbose
output. The three disabled codes are the ones that fire most often on
legitimate code (utility scripts that source siblings, library files
that define helpers their callers use, etc.).

## Per-project overrides

Each rule can be re-enabled in a single file via a comment:

```bash
#!/usr/bin/env bash
# shellcheck enable=SC2034
```

Or per-line:

```bash
foo=bar  # shellcheck disable=SC2034
```

A repo can also drop its own `.shellcheckrc` at the root; it wins.

## Fresh-machine setup

```sh
brew install shellcheck    # in the Brewfile
stow shellcheck
```
