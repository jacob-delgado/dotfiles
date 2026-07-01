# fzf

Stow package for `~/.fzf.zsh`. Sourced automatically by the oh-my-zsh
`fzf` plugin on shell startup.

## Table of contents

- [Defaults](#defaults)
- [Colors (Dracula)](#colors-dracula)
- [fd integration](#fd-integration)
- [Keybinding-specific options](#keybinding-specific-options)
- [frg — live ripgrep + fzf](#frg--live-ripgrep--fzf)
- [Fresh-machine setup](#fresh-machine-setup)

## Defaults

```sh
FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
FZF_TMUX=1
```

`FZF_TMUX=1` makes fzf pop up in a tmux popup pane when invoked inside
tmux — much nicer than taking over the whole terminal.

## Colors (Dracula)

`FZF_DEFAULT_OPTS` also carries the official [Dracula](https://draculatheme.com/fzf)
`--color` palette so the picker matches kitty/tmux/vim:

```sh
--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
--color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
--color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
--color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4
```

Unlike `bat`/`tig` (which inherit the terminal's ANSI palette), fzf's
colors are pinned to Dracula hex here.

## fd integration

If `fd` is on PATH, replace fzf's built-in walker with it. `fd` is
faster than the default `find` invocation and respects `.gitignore`:

```sh
if command -v fd >/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi
```

Guarded so machines without `fd` still get a working fzf.

## Keybinding-specific options

OMZ's `fzf` plugin binds:

| Keys     | Action                                            | Options set here                                        |
| -------- | ------------------------------------------------- | ------------------------------------------------------- |
| `Ctrl+T` | insert a selected file path into the command line | `FZF_CTRL_T_OPTS` — bat preview, falling back to cat    |
| `Ctrl+R` | history search                                    | `FZF_CTRL_R_OPTS` — 3-line wrapped preview pane         |
| `Alt+C`  | cd to a selected directory                        | `FZF_ALT_C_COMMAND` — fd-based directory walker (above) |

```sh
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range :500 {} 2>/dev/null || cat {}'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:wrap"
```

## frg — live ripgrep + fzf

A function for project-wide content search. Type to refine; rg re-runs on
every keystroke. Enter opens the chosen line in `$EDITOR`.

```sh
frg            # start with an empty query, type to search
frg "TODO"     # seed the query
```

Implementation:

```sh
frg() {
  local rg_prefix='rg --column --line-number --no-heading --color=always --smart-case'
  fzf --ansi --disabled --query "${*:-}" \
      --bind "start:reload:$rg_prefix {q} || true" \
      --bind "change:reload:sleep 0.1; $rg_prefix {q} || true" \
      --delimiter : \
      --preview 'bat --color=always --style=numbers --highlight-line {2} -- {1}' \
      --preview-window 'right,60%,border-left,+{2}+3/3,~3' \
      --bind "enter:become(${EDITOR:-vim} +{2} {1})"
}
```

Also bound to `prefix + g` in tmux — see `tmux/README.md`.

## Fresh-machine setup

```sh
stow fzf       # symlinks ~/.fzf.zsh
```

The OMZ `fzf` plugin (in `zsh/.zshrc`'s plugins list) auto-sources the
symlink. No manual `source` line needed.
