# p10k

Stow package for `~/.p10k.zsh` — the configured
[powerlevel10k](https://github.com/romkatv/powerlevel10k) prompt.

## Table of contents

- [Why this is in the repo](#why-this-is-in-the-repo)
- [How it's loaded](#how-its-loaded)
- [Colors (Dracula)](#colors-dracula)
- [Regenerating](#regenerating)
- [Fresh-machine setup](#fresh-machine-setup)

## Why this is in the repo

The theme itself ships with sensible defaults, but the prompt I actually
use is a customized version produced by running `p10k configure`. Without
this file, a fresh machine gets the wizard the first time zsh starts —
which is fine, but I prefer the deployed prompt to match what I'm used
to.

The file is ~1700 lines and mostly auto-generated; treat it as a
snapshot, not as hand-tuned config. Edits are fine, but re-running
`p10k configure` overwrites them.

## How it's loaded

`zsh/.zshrc` ends with:

```sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
```

Plus the instant-prompt preamble at the top of `.zshrc` (must stay close
to the top to be effective):

```sh
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
```

The instant-prompt cache file is regenerated automatically as you use the
shell; it isn't in this repo.

### Instant-prompt mode

`POWERLEVEL9K_INSTANT_PROMPT` is set to `quiet` rather than the stock
`verbose`. In a real terminal, init is silent and instant prompt works
perfectly. But a non-tty shell — like the one Claude Code uses to snapshot
the environment — can't give p10k's gitstatus job control or let
`atuin`/`zoxide` bind zle widgets, so those steps print errors. With
`verbose`, p10k then emits a console-output warning on every such launch.
`quiet` suppresses that spurious warning and has **no effect on real
interactive sessions** (which produce no output, so the prompt never
"jumps"). ⚠️ Like the Dracula colors below, re-running `p10k configure`
resets this to `verbose` — re-apply it.

## Colors (Dracula)

This is a `rainbow`-style config with the official
[Dracula](https://draculatheme.com/powerlevel10k) color values merged in
(colors only — segments, layout, and options are mine). The Dracula
theme is itself rainbow-based and mostly uses ANSI slots 0–7, so it
relies on the **terminal palette** being Dracula (kitty's `dracula.conf`)
rather than hardcoding hex; only ~11 segment colors are overridden
(os_icon, dir text, time, status, prompt char, multiline gap).

⚠️ **Re-running `p10k configure` overwrites these.** After regenerating,
re-merge the Dracula values — pull `files/.p10k.zsh` from
[`dracula/powerlevel10k`](https://github.com/dracula/powerlevel10k) and
copy across only the `*_FOREGROUND`/`*_BACKGROUND`/`*_COLOR` values, or
re-run the merge script used originally.

## Regenerating

If you change the prompt with `p10k configure`, the wizard writes the new
config to `~/.p10k.zsh` — which is symlinked here. Commit the resulting
diff (then re-apply the Dracula colors per the section above):

```sh
p10k configure          # interactive wizard
git -C ~/dotfiles diff p10k/.p10k.zsh
git -C ~/dotfiles commit -am "Regenerate p10k prompt"
```

## Fresh-machine setup

```sh
stow p10k       # symlinks ~/.p10k.zsh
```

Theme itself (cloned as an OMZ custom theme) is installed by
`bootstrap-debian.sh`:

```sh
git clone --depth=1 https://github.com/romkatv/powerlevel10k \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
```

You'll want a Nerd Font installed in your terminal for the prompt's
glyphs to render. The Brewfile pulls in `font-hack-nerd-font`.
