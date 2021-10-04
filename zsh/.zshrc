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
HISTSIZE=10000
SAVEHIST=10000
HISTTIMEFORMAT=
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_fcntl_lock 2>/dev/null
setopt hist_reduce_blanks
setopt inc_append_history

# directory
export PS1="[%~]$ "

# load plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

# alias
alias vim=nvim
alias suod=sudo
alias sduo=sudo
alias farsee="curl -F \"c=@-\" \"https://fars.ee/\""
alias setgitproxy="git config --global http.proxy 'socks5://127.0.0.1:7891';git config --global https.proxy 'socks5://127.0.0.1:7891'"
alias unsetgitproxy="git config --global --unset http.proxy;git config --global --unset https.proxy"
alias setworkmail="git config user.name zhangjinqiang; git config user.email zhangjinqiang@uniontech.com"
alias grep='grep --color=auto'
alias ll='ls -lh'

# case insensitive on
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'

# select menu
zstyle ':completion:*' menu yes select

# up/down line search
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey -e
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# compinit
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# macos
if [ -f /opt/homebrew/bin/brew ]; then
  alias brew='arch -arm64 /opt/homebrew/bin/brew'
fi
if [ -d /opt/homebrew/opt/openjdk/bin ]; then
  export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
fi
