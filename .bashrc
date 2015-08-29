# Bash specific 
if [ -n "$BASH" ] ; then
  shopt -s extglob

  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi
  source $(brew --prefix cdargs)/contrib/cdargs-bash.sh
fi

# Shell Settings
set -o vi
ulimit -n 65536 65536 

# Environment Variables
export CLICOLOR=1
export EDITOR="vim"
export GOPATH=$HOME/go
export NVM_DIR=~/.nvm
export PGHOST=localhost
export TERM="xterm-256color"

# Path Variables
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH="/Applications/Postgres.app/Contents/Versions/9.3/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="/usr/local/mysql/bin:$PATH"
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/texbin:$PATH"
export PATH="~/Library/Haskell/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# Sources
[ -f /Users/austinpray/.travis/travis.sh ] && source /Users/austinpray/.travis/travis.sh
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
source $(brew --prefix nvm)/nvm.sh

. `brew --prefix`/etc/profile.d/z.sh

# Aliases
alias be="bundle exec "
alias less=$PAGER
alias zless=$PAGER
alias pcr="rake assets:precompile RAILS_ENV=production"
alias sserver="python -m SimpleHTTPServer"
alias tmux="tmux -2"
alias chrome='open -a "Google Chrome"'
alias n='terminal_velocity ~/notes'


# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-*} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}
