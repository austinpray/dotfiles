##pretty colors
export CLICOLOR=1
shopt -s extglob
set -o vi

# ryan
export TERM="xterm-256color"
# ryan
alias tmux="tmux -2"

export PATH="/usr/local/mysql/bin:$PATH"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# 2013-08-14 Austin Pray adds z.sh line:
. `brew --prefix`/etc/profile.d/z.sh

# 2013-08-15 Austin Pray adds virtualhosts.sh
export PATH="/usr/local/Cellar/virtualhost.sh/1.30/bin/virtualhost.sh:$PATH"

export PATH="~/bin:$PATH"

###added by austin 2013-09-20
export PATH="/Applications/Postgres.app/Contents/Versions/9.3/bin:$PATH"
export PGHOST=localhost

###added by austin 2013-10-27
source ~/.profile

export PATH=/usr/local/bin:$PATH

#homebrew
export PATH="/usr/local/sbin:$PATH"

#added bash-complete
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

alias pcr="rake assets:precompile RAILS_ENV=production"
alias hsdeploy='bundle exec rake assets:precompile RAILS_ENV=production && git add -A && git commit -a -m "compiled assets for production, updates manifest file" && git push'

alias sserver="python -m SimpleHTTPServer"

export PATH="~/Library/Haskell/bin:$PATH"

export PATH=/usr/texbin:"$PATH"

export EDITOR='vim'

# Pager
export PAGER=/usr/local/bin/vimpager
alias less=$PAGER
alias zless=$PAGER

source ~/bin/tmuxinator.bash

alias be="bundle exec "
PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
alias chrome="open /Applications/Google\ Chrome.app "

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

source /usr/local/Cellar/cdargs/1.35/contrib/cdargs-bash.sh

export ITWORKS="cool"

PATH="/Applications/Postgres.app/Contents/Versions/9.3/bin:$PATH"

# added by travis gem
[ -f /Users/austinpray/.travis/travis.sh ] && source /Users/austinpray/.travis/travis.sh


export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
