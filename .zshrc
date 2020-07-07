export EDITOR=vim
export PATH=$HOME/bin:/usr/local/bin:$PATH
unsetopt BEEP

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

export KEYTIMEOUT=1
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/austin/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

eval "$(starship init zsh)"

kitty + complete setup zsh | source /dev/stdin
function pbcopy() {
  kitty +kitten clipboard $@
}
function pbpaste() {
  kitty +kitten clipboard --get-clipboard
}

#bindkey -M vicmd '/' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-pattern-search-backward
bindkey '^R' history-incremental-search-backward

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

source "$HOME/.zsh_plugins.sh"
source "/usr/share/autojump/autojump.zsh"

# Path to your oh-my-zsh installation.
#export ZSH="$(antibody home)/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME=

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

#source $HOME/.zsh_plugins.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

## Personal Aliases

alias pipi='pip install --user'
alias ll='exa --long --git --header -a'

alias dc="docker-compose"
alias dcr="docker-compose run --rm"
alias dcrn="docker-compose run --no-deps --rm"

alias reboot="sudo systemctl reboot"
alias poweroff="sudo systemctl poweroff"
alias susp="sudo systemctl suspend"

alias icat="kitty +kitten icat"
#alias sc="sc-im"
#alias ld='lazydocker'

alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"'
alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'

alias today='vim ~/today.txt'

alias ding="echo -en '\a'"

alias k=kubectl
alias kx=kubectx
alias kn=kubens

alias open=xdg-open

#alias j=autojump


# Functions

webmTOmp4 () {
      ffmpeg -i "$1".webm -qscale 0 "$1".mp4
}
mp4TOmp3 () {
      ffmpeg -i "$1".mp4 "$1".mp3
}

makegif () {
    BN=$(basename $1)
    GIF="${BN%.*}.gif"
    GIF_O="${BN%.*}-opt.gif"
    ffmpeg -i "$1" "$GIF"
    shift
    gifsicle -O3 $@ "$GIF" -o "$GIF_O"
}

function git-branch-current() {
    printf "%s\n" $(git branch 2> /dev/null | grep -e ^* | tr -d "\* ")
}

function git-log-last-pushed-hash() {
    local currentBranch=$(git-branch-current);
    git log --format="%h" -n 1 origin/${currentBranch}
}

function git-rebase-unpushed() {
    git rebase --interactive $(git-log-last-pushed-hash)
}

function dphp() {
  NAME=dphp-`date '+%Y-%m-%d-%H-%M'`-`uuidgen -t`
  docker run -it --rm --name $NAME -v "$PWD":/usr/src/myapp -w /usr/src/myapp php:${1}-cli ${@:2}
}

function dpython() {
  NAME=python-`date '+%Y-%m-%d-%H-%M'`-`uuidgen -t`
  docker run -it --rm --name $NAME -v "$PWD":/app -w /app python $@
}

function dnode() {
  NAME=node-`date '+%Y-%m-%d-%H-%M'`-`uuidgen -t`
  docker run -it --rm --name $NAME -v "$PWD":/usr/src/myapp -w /usr/src/myapp node:${1} ${@:2}
}

function psysh() {
  NAME=psysh-`date '+%Y-%m-%d-%H-%M'`-`uuidgen -t`
  docker run -it --rm --name $NAME -v "$PWD":/app ricc/psysh $@
}

function composer() {
  NAME=composer-`date '+%Y-%m-%d-%H-%M'`-`uuidgen -t`
  docker run -it --rm --name $NAME -v "$PWD":/app composer $@
}

yq() {
  docker run --rm -i -v ${PWD}:/workdir mikefarah/yq yq $@
}

function docker-rmgrep() {
  docker ps -a | grep $1 | awk '{print $1}'  | xargs docker rm -f
}

export COMPOSE_HTTP_TIMEOUT=600

# npm
NPM_PACKAGES="${HOME}/.npm-packages"
PATH="$NPM_PACKAGES/bin:$PATH"
unset MANPATH
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

# pip
PATH="${HOME}/.local/bin:$PATH"

function kubeon() {
  kubectx prod1.k8s.carrot.com
}

function kubeoff() {
  kubectl config unset current-context
}

autoload -U +X bashcompinit && bashcompinit

#if [ -f /usr/bin/terraform ]; then
#complete -o nospace -C /usr/bin/terraform terraform
#fi


#export PATH="$HOME/.rbenv/bin:$PATH"
#eval "$(rbenv init -)"


#PATH="/usr/local/heroku/bin:$PATH"

# added by travis gem
#[ -f "$HOME/.travis/travis.sh" ] && source "$HOME/.travis/travis.sh"

# The next line updates PATH for the Google Cloud SDK.
#if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then source "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
#if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then source "$HOME/google-cloud-sdk/completion.zsh.inc"; fi
if [ -e /home/austin/.nix-profile/etc/profile.d/nix.sh ]; then . /home/austin/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

eval $(systemctl --user show-environment | grep SSH_AUTH_SOCK)
export SSH_AUTH_SOCK
