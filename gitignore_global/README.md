# gitignore_global

Stow package for `~/.gitignore_global`. Wired into git via
`[core] excludesfile = ~/.gitignore_global` in `git/.gitconfig`.

## Table of contents

- [Layout](#layout)
- [What's in it](#whats-in-it)
- [What's not in it](#whats-not-in-it)
- [Fresh-machine setup](#fresh-machine-setup)

## Layout

| File | Stows to |
|---|---|
| `gitignore_global/.gitignore_global` | `~/.gitignore_global` |

## What's in it

OS, editor, and tool noise that shouldn't appear in any project:

- macOS: `.DS_Store`, `._*`, `.Spotlight-V100`, `.fseventsd`, …
- Linux: `.directory`, `.Trash-*`, `.nfs*`
- Windows: `Thumbs.db`, `Desktop.ini`
- Vim: `*.swp`, `*~`, `.netrwhist`
- IDEs: `.idea/`, `.vscode/`, `*.sublime-workspace`, `.history/`
- ctags / LSP caches: `tags`, `.ccls-cache/`
- direnv: `.direnv/`
- pre-commit / lefthook caches
- Generic: `*.bak`, `*.orig`, `*.rej`

## What's not in it

Per-project artifacts (`node_modules/`, `__pycache__/`, `dist/`,
`target/`, `*.pyc`, build dirs, etc.) **stay in each project's own
`.gitignore`**. A global ignore for those would mask bugs in repos that
should be excluding them deliberately.

## Fresh-machine setup

```sh
stow gitignore_global
git config --global core.excludesfile ~/.gitignore_global   # already in git/.gitconfig
```
