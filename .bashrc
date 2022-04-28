#!/bin/bash

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.bash ] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.bash
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.bash ] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.bash
# added by travis gem
#if -f "~/.travis/travis.sh" then
   [ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh
#fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# Copied from alias-functions.sh at https://github.com/wilsonmar/git-utilities
#For use on Mac only (not Windows Git Bash):
function parse_git_branch() {  # to show "main" (formerly "master") or other current git branch:
# git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(gd)/"
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1/"
# git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# macOS is different from Linux in that a terminal emulator starts a login shell instead of an ordinary interactive shell.
# So a good practice is to put the definitions in .bashrc, then source .bashrc from .bash_profile.
# PS1="\u@\h \[\033[32m\]\w - \$(parse_git_branch)\[\033[00m\] $ "
# For Bash only from alias-functions.sh:
export PS1="\n\n  \w\[\033[33m\] \$(parse_git_branch)\[\033[00m\]\n$ "
   # instead of:
#export PS1="\n\n  \w\[\033[33m\] \n$ "

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM$
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[ -f /Users/wilsonmar/.nvm/versions/node/v9.11.1/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.bash ] && . /Users/wilsonmar/.nvm/versions/node/v9.11.1/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.bash
# tabtab source for electron-forge package
# uninstall by removing these lines or running `tabtab uninstall electron-forge`
# [ -f /Users/wilsonmar/gits/coffitivity-offline/node_modules/tabtab/.completions/electron-forge.bash ] && . /Users/wilsonmar/gits/coffitivity-offline/node_modules/tabtab/.completions/electron-forge.bash
complete -C aws_completer aws
