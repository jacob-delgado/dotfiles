# yamllint

Stow package for `~/.config/yamllint/config`. `yamllint` is a YAML
linter — invoked by `lefthook` on pre-commit, by ALE in vim, and by
hand.

## Table of contents

- [Layout](#layout)
- [Rule tweaks](#rule-tweaks)
- [Per-project overrides](#per-project-overrides)
- [Fresh-machine setup](#fresh-machine-setup)

## Layout

| File | Stows to |
|---|---|
| `yamllint/.config/yamllint/config` | `~/.config/yamllint/config` |

`yamllint` only reads this file when run without `-c <path>` and when
the project has no `.yamllint`/`.yamllint.yml`/`.yamllint.yaml` of its
own.

## Rule tweaks

Starting from `extends: default`:

| Rule | Change | Why |
|---|---|---|
| `line-length: 120 (warning)` | bump from 80, demote to warning | nobody wraps YAML at 80 |
| `document-start` | disable | `---` is rarely useful in single-doc files |
| `truthy.check-keys: false` | don't flag `on:` keys | GitHub Actions uses `on:` as a top-level key |
| `comments.min-spaces-from-content: 1` | down from 2 | the default is overly strict |
| `comments-indentation` | disable | mis-indented comments are common in real YAML and rarely matter |
| `indentation.indent-sequences: consistent` | don't require nested under key | matches both common styles |
| `braces` / `brackets` `max-spaces-inside: 1` | allow `{ k: v }` | flow style is fine |

## Per-project overrides

Drop a `.yamllint` in your repo root — it wins. Lefthook's pre-commit
hook (template at `lefthook/lefthook.yml`) will use whichever yamllint
finds first.

## Fresh-machine setup

```sh
brew install yamllint    # in the Brewfile
stow yamllint
```
