# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

zstyle ':omz:update' mode reminder      # prompt when an update is available
zstyle ':omz:update' frequency 14       # check every 2 weeks

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Skip untracked-files check for VCS dirty status; much faster in big repos.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(aliases colored-man-pages command-not-found cp dirhistory direnv docker extract fzf gitfast golang helm kind kube-ps1 kubectl skaffold sudo taskwarrior tig tmux)
[[ -d "${ZSH_CUSTOM:-$ZSH/custom}/plugins/you-should-use" ]]      && plugins+=(you-should-use)
[[ -d "${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-autosuggestions" ]] && plugins+=(zsh-autosuggestions)
# fzf-tab must come after every plugin that registers completions.
[[ -d "${ZSH_CUSTOM:-$ZSH/custom}/plugins/fzf-tab" ]]             && plugins+=(fzf-tab)

# Pick up Homebrew-installed zsh completions before OMZ runs compinit.
# Homebrew's share/ is group-writable by 'admin' (the only group member is you),
# which OMZ's compaudit would otherwise reject — accept it via compfix opt-out.
if command -v brew >/dev/null; then
  FPATH="$(brew --prefix)/share/zsh-completions:$(brew --prefix)/share/zsh/site-functions:$FPATH"
  ZSH_DISABLE_COMPFIX=true
fi

source $ZSH/oh-my-zsh.sh

# User configuration

# path config
export PATH=$PATH:$HOME/bin
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
export PATH=$PATH:/usr/local/go/bin
command -v ruby >/dev/null && export GEM_HOME=$(ruby -e 'puts Gem.user_dir')

# Prefer GNU tools over the BSD versions on macOS (installed via Homebrew).
if [[ "$OSTYPE" == darwin* ]]; then
  for gnu_tool in binutils coreutils findutils gnu-sed gnu-tar gnu-which grep; do
    gnu_bin="/opt/homebrew/opt/$gnu_tool/libexec/gnubin"
    [[ "$gnu_tool" == "binutils" ]] && gnu_bin="/opt/homebrew/opt/$gnu_tool/bin"
    [[ -d "$gnu_bin" ]] && export PATH="$gnu_bin:$PATH"
  done
  unset gnu_tool gnu_bin
fi

# History
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=500000
export SAVEHIST=500000

setopt SHARE_HISTORY            # implies INC_APPEND_HISTORY, no need to set both
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FCNTL_LOCK
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_LEX_WORDS
setopt HIST_NO_FUNCTIONS        # don't store function definitions
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
HISTORY_IGNORE="(ls|cd|pwd|exit)"

# Shell behavior — globs, navigation, completion ergonomics, quiet terminal.
setopt EXTENDED_GLOB            # ^pat (negate), ~pat (exclude), **/* (recursive)
setopt NO_BEEP                  # silence the terminal bell everywhere
setopt INTERACTIVE_COMMENTS     # allow `# notes` in interactive lines
setopt AUTO_CD                  # `dirname` alone cd's there
setopt AUTO_PUSHD               # every cd pushes the old dir onto the stack
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT             # don't print the stack after each cd
setopt COMPLETE_IN_WORD         # complete from cursor position, not only end
setopt ALWAYS_TO_END            # move cursor to end of word after completion

# Completion menu polish (compinit is run by oh-my-zsh, above).
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true

export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi
export EDITOR=vim

# Pager + man-page rendering
export LESS='-RFX'                                  # raw colors, quit-if-one-screen, no alt-screen
export LESSHISTFILE=-                               # don't pollute ~/.lesshst
export MANPAGER="sh -c 'col -bx | bat -l man -p'"   # syntax-highlighted man pages
export BAT_THEME='ansi'                             # bat respects the terminal palette

# ripgrep config only takes effect when this env var points at it.
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# Modern CLI tools — initialize after oh-my-zsh so they can override keybindings.
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
command -v atuin  >/dev/null && eval "$(atuin init zsh)"

# eza (modern ls) aliases — only override if eza is installed.
if command -v eza >/dev/null; then
  alias ls='eza'
  alias ll='eza -l --git --group-directories-first'
  alias la='eza -la --git --group-directories-first'
  alias lt='eza --tree --level=2 --git-ignore'
fi

# kitty remote-control aliases (require allow_remote_control + KITTY_LISTEN_ON;
# both are set by kitty.conf + shell integration inside a kitty session).
if command -v kitty >/dev/null; then
  alias kt='kitty @ set-tab-title'
  alias kw='kitty @ set-window-title'
  kgo()   { kitty @ focus-tab --match "title:$1"; }
  ktabs() { kitty @ ls | jq -r '.[].tabs[] | "[\(.id)] \(.title)  (\(.windows | length) win)"'; }
fi

for zsh_syntax_highlighting in \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
  [[ -r "$zsh_syntax_highlighting" ]] && source "$zsh_syntax_highlighting" && break
done
unset zsh_syntax_highlighting

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
