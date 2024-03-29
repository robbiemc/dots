DOTS="${DOTS:-${HOME}/.dots}"

# Profile startup
zmodload zsh/zprof

# Autocomplete
# TODO: Add more stuff in here as needed, this is very basic.
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh/completion
autoload -Uz compinit && compinit

# Highlighting
source ${DOTS}/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Terminal title & prompt
source ${DOTS}/zsh/title.zsh
source ${DOTS}/zsh/prompt.zsh

# History
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
HISTFILE=~/.zsh_history
SAVEHIST=10000
HISTSIZE=10000

# Directory Stuff
setopt AUTO_PUSHD
setopt PUSHD_SILENT
setopt EXTENDED_GLOB

# Key Bindings
bindkey -e
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[3;5~' kill-word
bindkey '^H' backward-kill-word

# Aliases
if [[ "${OSTYPE}" == linux* ]]; then
  alias ls='ls --group-directories-first --color=auto'
fi
alias ll='ls -l'
alias la='ls -al'
alias br='git br'
alias st='git st'
alias dus='du -sk | sort -n'
alias gdb='gdb -silent'
alias vimf='vim $(fzf)'
#alias vimf='vim $(fzf --preview "bat --line-range :150 --color always {}")'
alias vimcommit='vim $(git files | xargs echo)'
alias tmuxa='tmux new-session -AD -s'
alias tmuxl='tmux list-sessions'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

# FZF
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse'
if [[ -e /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

# Random stuff
export BLOCK_SIZE="'1"
export BAT_THEME=Solarized-dark
if [[ "${OSTYPE}" == darwin* ]]; then
  export BROWSER='open'
fi
setopt NO_BG_NICE
autoload -U zargs
autoload -U zcalc
autoload -U zmv

# dircolors
if hash dircolors &>/dev/null; then
  if [[ -e "${HOME}/.dir_colors/dircolors" ]]; then
    eval `dircolors "${HOME}/.dir_colors/dircolors"`
  else
    eval `dircolors --sh`
  fi
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

# Less
export LESS='-g -i -M -R -S -w -z-4'
if hash lesspipe &>/dev/null; then
  export LESSOPEN="| lesspipe %s 2>&-"
fi

function mkcdir () {
  mkdir -p -- "$1" && cd -- "$1"
}
compdef mkcdir=mkdir

if [[ -e ${HOME}/.custom/zshrc ]]; then
  source ${HOME}/.custom/zshrc
fi
