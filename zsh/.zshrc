# default TERM
export TERM=xterm-256color

# # history
# export HISTFILESIZE=1000000000
# export HISTSIZE=1000000000
# setopt HIST_FIND_NO_DUPS
# setopt INC_APPEND_HISTORY
# export HISTTIMEFORMAT="[%F %T] "
# export HISTFILE=~/.zsh_history

stty sane

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=$HISTSIZE
HISTTIMEFORMAT=
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_fcntl_lock 2>/dev/null
setopt hist_reduce_blanks
setopt inc_append_history

# let wildcard working https://unix.stackexchange.com/questions/589508
setopt no_nomatch

# kitty tab
precmd () {print -Pn "\e]0;%~\a"}

# load plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
if [ -f /usr/share/autojump/autojump.zsh ]; then
  source /usr/share/autojump/autojump.zsh
fi

# enable-ssh-support
export GPG_TTY=$(tty)
if [[ $(gpgconf --list-options gpg-agent 2>/dev/null | awk -F: '$1=="enable-ssh-support" {print $10}') = 1 ]]; then
  unset SSH_AGENT_PID
  if [[ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
    gpgconf --launch gpg-agent
  fi
  gpg-connect-agent updatestartuptty /bye &>/dev/null
fi

# alias
alias vim=nvim
alias suod=sudo
alias sduo=sudo
alias farsee="curl -F \"c=@-\" \"https://fars.ee/\""
alias setgitproxy="git config --global http.proxy 'socks5://127.0.0.1:7891';git config --global https.proxy 'socks5://127.0.0.1:7891'"
alias unsetgitproxy="git config --global --unset http.proxy;git config --global --unset https.proxy"
alias grep='grep --color=auto'
alias ll='ls -lh'
alias gomodvendor="go mod verify && go mod tidy && go mod vendor"
alias history="history 1"
alias setsshagent="eval $(ssh-agent) ssh-add ~/.ssh/id_rsa"

# npm
NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="$PATH:$NPM_PACKAGES/bin"
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"

# case insensitive on
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'

# select menu
zstyle ':completion:*' menu yes select

# rehash
zstyle ':completion:*' rehash true

# cache for completion
zstyle ':completion::complete:*' use-cache 1

# up/down line search
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -e
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

# compinit
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# gentoo-zsh-completions
if [ -f /usr/share/zsh/site-functions/_portage ]; then
  autoload -U compinit promptinit
  compinit
  promptinit; prompt gentoo
fi

# directory
export PS1='%n@%m %~ %# '
if [ -d /var/db/repos ]; then
  export PS1='%B%F{green}%n@%m %B%F{blue}%~ %# %b%f%k'
fi

# macos
if [ -f /opt/homebrew/bin/brew ]; then
  alias brew='arch -arm64 /opt/homebrew/bin/brew'
fi
if [ -d /opt/homebrew/opt/openjdk/bin ]; then
  export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
fi

# github
if [ -f ~/.githubtoken ]; then
  source ~/.githubtoken
fi

# go bin
if [ -d ~/go/bin ]; then
  export PATH="/home/peeweep/go/bin:$PATH"
fi

# cargo bin
if [ -d ~/.cargo/bin ]; then
  export PATH="/home/peeweep/.cargo/bin:$PATH"
fi


# atuin
if [ -f /usr/bin/atuin ]; then
  eval "$(atuin init zsh)"
fi

# fzf
if [ -f /usr/bin/fzf ]; then
  eval "$(fzf --zsh)"
fi
