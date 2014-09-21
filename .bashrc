# Shell Settings
set -o vi
shopt -s extglob

# Environment Variables
export CLICOLOR=1
export EDITOR="vim"
export GOPATH=$HOME/go
export NVM_DIR=~/.nvm
export PAGER=/usr/local/bin/vimpager
export PGHOST=localhost
export TERM="xterm-256color"

# Path Variables
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="/Applications/Postgres.app/Contents/Versions/9.3/bin:$PATH"
export PATH="/Applications/Postgres.app/Contents/Versions/9.3/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="/usr/local/mysql/bin:$PATH"
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/texbin:$PATH"
export PATH="~/Library/Haskell/bin:$PATH"
export PATH="~/bin:$PATH"

# Sources
source $(brew --prefix cdargs)/contrib/cdargs-bash.sh
source ~/bin/tmuxinator.bash
[ -f /Users/austinpray/.travis/travis.sh ] && source /Users/austinpray/.travis/travis.sh
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
source $(brew --prefix nvm)/nvm.sh

. `brew --prefix`/etc/profile.d/z.sh

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# Aliases
alias be="bundle exec "
alias chrome="open /Applications/Google\ Chrome.app "
alias hsdeploy="bundle exec rake assets:precompile RAILS_ENV=production && git add -A && git commit -a -m "compiled assets for production, updates manifest file" && git push"
alias less=$PAGER
alias zless=$PAGER
alias pcr="rake assets:precompile RAILS_ENV=production"
alias sserver="python -m SimpleHTTPServer"
alias tmux="tmux -2"
