# fzf config
# Symlink this to ~/.fzf.zsh; the oh-my-zsh fzf plugin auto-sources it.
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_TMUX=1

# Prefer fd for file/dir listings: faster than find and respects .gitignore.
if command -v fd >/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

# CTRL+T: file preview via bat, falling back to cat.
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {} 2>/dev/null || cat {}'"

# CTRL+R: wrap long commands in a wider preview pane.
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:wrap"
