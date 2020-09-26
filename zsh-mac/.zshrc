export TERM=xterm-256color

# alias
alias vim=nvim
alias farsee="curl -F \"c=@-\" \"https://fars.ee/\""
alias setgitproxy="git config --global http.proxy 'socks5://127.0.0.1:7891';git config --global https.proxy 'socks5://127.0.0.1:7891'"
alias unsetgitproxy="git config --global --unset http.proxy;git config --global --unset https.proxy"
alias setworkmail="git config user.name zhangjinqiang; git config user.email zhangjinqiang@uniontech.com"

# load plugins
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# case insensitive on
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'

# select menu
zstyle ':completion:*' menu yes select

# up/down line search
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# compinit
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

