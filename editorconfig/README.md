# editorconfig

Stow package for `~/.editorconfig`. Vim picks it up via
`editorconfig/editorconfig-vim` (in `vim/.vimrc`); most editors / IDEs
support it natively.

## Table of contents

- [Layout](#layout)
- [Defaults](#defaults)
- [Per-project overrides](#per-project-overrides)
- [Fresh-machine setup](#fresh-machine-setup)

## Layout

| File | Stows to |
|---|---|
| `editorconfig/.editorconfig` | `~/.editorconfig` |

## Defaults

```
[*]
charset                  = utf-8
end_of_line              = lf
indent_style             = space
indent_size              = 2
insert_final_newline     = true
trim_trailing_whitespace = true
max_line_length          = 100
```

Per-language overrides:

| Pattern | Indent | Notes |
|---|---|---|
| `*.go` | tab | Go convention |
| `Makefile`, `*.mk` | tab | Make requires tabs |
| `*.py` | 4 spaces | PEP 8 |
| `*.{rs,c,cpp,h,hpp,java,kt,scala}` | 4 spaces | |
| `*.md` | — | `trim_trailing_whitespace = false`, no `max_line_length` |

## Per-project overrides

This file has `root = true` so editorconfig stops walking up the
filesystem when it finds it. **Any project's own `.editorconfig`
overrides this one** — drop a more specific file in your project root
when you need different rules.

## Fresh-machine setup

```sh
stow editorconfig
```

Vim's `editorconfig-vim` plugin (in `vim/`) reads this automatically.
For other editors: VS Code, JetBrains, Sublime, Neovim, and most modern
editors support `.editorconfig` natively or via a free plugin.
