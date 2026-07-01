# direnv

Stow package for `~/.config/direnv/direnvrc`. Per-user direnv setup —
`.envrc` files in your projects can call any of the helpers defined
here.

## Table of contents

- [Layout](#layout)
- [What direnv is](#what-direnv-is)
- [Helpers defined here](#helpers-defined-here)
- [Example .envrc files](#example-envrc-files)
- [nix-direnv integration](#nix-direnv-integration)
- [Fresh-machine setup](#fresh-machine-setup)

## Layout

| File                             | Stows to                    |
| -------------------------------- | --------------------------- |
| `direnv/.config/direnv/direnvrc` | `~/.config/direnv/direnvrc` |

## What direnv is

direnv hooks into your shell so that whenever you `cd` into a directory
containing `.envrc`, it loads that file as environment for the directory
(and unloads on leaving). Activated via the OMZ `direnv` plugin in
`zsh/.zshrc`. Trust new `.envrc` files explicitly with `direnv allow`.

## Helpers defined here

| Helper                        | Usage in `.envrc`                     | What                                                              |
| ----------------------------- | ------------------------------------- | ----------------------------------------------------------------- |
| `layout python_venv [python]` | `layout python_venv python3.12`       | create/activate `./.venv/`; pin python binary                     |
| `layout uv`                   | `layout uv`                           | activate `./.venv/` created by `uv venv` (faster pip-replacement) |
| `use go <version>`            | `use go 1.21`                         | use Homebrew's `go@1.21` (run `brew install go@1.21` first)       |
| `use node <version>`          | `use node 20`                         | use Homebrew's `node@20`                                          |
| `op_env <item>`               | `op_env "GitHub PAT"`                 | inject env vars from a 1Password item (needs `op` signed in)      |
| `use_flake` / `use_nix`       | (provided by nix-direnv when sourced) | activate a nix flake / shell                                      |

## Example .envrc files

**Python project with uv:**

```sh
layout uv
export PYTHONDONTWRITEBYTECODE=1
```

**Go service with a version pin:**

```sh
use go 1.22
export CGO_ENABLED=0
PATH_add bin
```

**Project that needs secrets from 1Password:**

```sh
op_env "production-postgres"   # injects DATABASE_URL, etc.
```

Then `direnv allow` once and the env loads automatically when you `cd`
in.

## nix-direnv integration

If `nix-direnv` is installed (Mac: `brew install nix-direnv`; Linux:
distro package or via nix itself), the `direnvrc` sources it
automatically — `use_flake` / `use_nix` become available to `.envrc`
files. Without nix-direnv installed, the source-attempt is silent.

## Fresh-machine setup

```sh
brew install direnv          # in the Brewfile
stow direnv
# OMZ's direnv plugin (in zsh/.zshrc) hooks into the shell on startup.
```
