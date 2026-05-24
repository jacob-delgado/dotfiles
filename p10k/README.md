# p10k

Stow package for `~/.p10k.zsh` — the configured
[powerlevel10k](https://github.com/romkatv/powerlevel10k) prompt.

## Table of contents

- [Why this is in the repo](#why-this-is-in-the-repo)
- [How it's loaded](#how-its-loaded)
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

## Regenerating

If you change the prompt with `p10k configure`, the wizard writes the new
config to `~/.p10k.zsh` — which is symlinked here. Commit the resulting
diff:

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
