# ripgrep

Stow package for `~/.config/ripgrep/config`. The config file is **only**
read if `RIPGREP_CONFIG_PATH` points at it — `rg` does not look for it
by default.

## Table of contents

- [Layout](#layout)
- [Required env var](#required-env-var)
- [Settings](#settings)
- [Colors (Dracula)](#colors-dracula)
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
--max-columns=200          # cap matched-line width
--max-columns-preview      # show a truncation message on long lines
```

Glob excludes (additional to whatever `.gitignore` says):

```
--glob=!.git/*
--glob=!node_modules/*
--glob=!.venv/*
--glob=!__pycache__/*
--glob=!dist/*
--glob=!build/*
--glob=!target/*           # Rust + JVM build dirs
--glob=!vendor/*           # Go vendored deps
--glob=!*.min.js
--glob=!*.min.css
--glob=!*.map              # source maps
```

Custom filetype aliases — `rg --type <alias> "pattern"`:

```
--type-add=tf:*.{tf,tfvars}
--type-add=k8s:*.{yaml,yml}
--type-add=helm:*.{yaml,yml,tpl}
--type-add=proto:*.proto
```

`--hidden` makes `rg` walk into `.config/`, `.local/`, etc. — the
`--glob` exclusions then prune the noisy ones.

Anything you override on the CLI wins over the config file.

## Colors (Dracula)

The official [Dracula](https://draculatheme.com/ripgrep) palette, so `rg`
output matches fzf/kitty/etc:

```
--colors=path:fg:0xbd,0x93,0xf9     # purple paths
--colors=line:fg:0x50,0xfa,0x7b     # green line numbers
--colors=column:fg:0x50,0xfa,0x7b   # green column numbers
--colors=match:fg:0xff,0x55,0x55    # red match highlights
```

## Verifying it's loaded

```sh
rg foo --debug 2>&1 | head -5
```

The first line of debug output names the config file path being read.

## Companion: ripgrep-all (rga)

`brew install ripgrep-all` provides `rga`, a wrapper that runs rg
across non-text files by extracting their content first: PDFs, ebooks
(EPUB, MOBI), Office docs, archives (zip, tar, 7z), and even SQLite
databases:

```sh
rga "encryption" ~/Documents/papers   # grep across PDFs
rga "TODO" project.zip                # grep inside an archive without extracting
```

`rga` reads its own config dir (`~/.config/ripgrep-all/`) — it does
**not** share this `ripgrep/config` file. Run `rga --help` to set up
adapter-specific options.

## Fresh-machine setup

```sh
brew install ripgrep ripgrep-all   # both in the Brewfile
stow ripgrep
# RIPGREP_CONFIG_PATH is exported by zsh/.zshrc already
```
