# ripgrep

Stow package for `~/.config/ripgrep/config`. The config file is **only**
read if `RIPGREP_CONFIG_PATH` points at it — `rg` does not look for it
by default.

## Table of contents

- [Layout](#layout)
- [Required env var](#required-env-var)
- [Settings](#settings)
- [Verifying it's loaded](#verifying-its-loaded)
- [Fresh-machine setup](#fresh-machine-setup)

## Layout

| File | Stows to |
|---|---|
| `ripgrep/.config/ripgrep/config` | `~/.config/ripgrep/config` |

## Required env var

`zsh/.zshrc` sets:

```sh
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"
```

Without that variable, `rg` ignores the config file completely.

## Settings

```
--smart-case               # case-insensitive unless the query has uppercase
--hidden                   # search dotfiles (still respects .gitignore)
--glob=!.git/*
--glob=!node_modules/*
--glob=!.venv/*
--glob=!__pycache__/*
```

`--hidden` makes `rg` walk into `.config/`, `.local/`, etc. — the
`--glob` exclusions then prune the noisy ones.

Anything you override on the CLI wins over the config file.

## Verifying it's loaded

```sh
rg foo --debug 2>&1 | head -5
```

The first line of debug output names the config file path being read.

## Fresh-machine setup

```sh
brew install ripgrep    # in the Brewfile
stow ripgrep
# RIPGREP_CONFIG_PATH is exported by zsh/.zshrc already
```
