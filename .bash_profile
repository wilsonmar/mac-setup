PATH=/usr/local/bin:/usr/bin:/bin:/sbin:/usr/local/share/dotnet
# Note colons separate items in $PATH.
# /usr/local/bin before usr/bin so Homebrew stuff is found first
# alias fix_brew='sudo chown -R $USER /usr/local/'export PATH="/usr/local/bin:$PATH"
# For homebrew:
# $(brew --prefix)/sbin

# For use in brew cask install xxx
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"
#export HOMEBREW_CASK_OPTS="--appdir=~/Applications --caskroom=~/Caskroom"

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
#export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
#PS1='\u \W$(__git_ps1)\$ '

alias wm='cd ~/gits/wilsonmar/wilsonmar.github.io/_posts;git status -s -b'
alias wf='cd ~/gits/wilsonmar/futures;git status -s -b'
alias aih='iothub-explorer'

alias bs='bundle exec jekyll serve --config _config.yml,_config_dev.yml'

alias myip="ifconfig en0 | grep inet | grep -v inet6 | cut -d ' ' -f2"
alias last20='stat -f "%m%t%Sm %N" /tmp/* | sort -rn | head -20 | cut -f2-'

export GPG_TTY=$(tty)

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Copied from https://github.com/wilsonmar/git-utilities:
export PATH="$HOME/gits:$PATH"
export PATH="$HOME/gits/wilsonmar/git-utilities/git-custom-commands:$PATH"
export WM="$HOME/gits/wilsonmar/wilsonmar.github.io"
# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;
# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	complete -o default -o nospace -F _git g;
fi;


# https://gist.github.com/sindresorhus/98add7be608fad6b5376a895e5a59972

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

# For Ruby:
#export PATH="$PATH:$HOME/.rvm/gems/ruby-2.3.1/bin"
export LC_ALL=en_US.utf-8
#export PATH="$HOME/.rbenv/bin:$PATH"
#eval "$(rbenv init -)"

# Go installs packages in the first in this path of go source, separated by colons. See https://wilsonmar.github.io/golang
export GOPATH="$HOME/gopkgs"
export GOHOME="$HOME/gits/wilsonmar/golang-samples"
#export GOROOT=/usr/local/Cellar/go/1.8.1  # Homebrew https://dave.cheney.net/2013/06/14/you-dont-need-to-set-goroot-really
#export PATH=$PATH:$GOROOT/bin

# Since which maven doesn't work:
export M2_HOME=/usr/local/Cellar/maven/3.5.0/libexec
export M2=$M2_HOME/bin
export PATH=$PATH:$M2_HOME/bin

complete -C aws_completer aws
export AWS_DEFAULT_REGION=us-west-2
export EC2_URL=https://us-west-2.console.aws.amazon.com/ec2/v2/home?region=us-west-2#Instances:sort=instanceId

export PATH="$PATH:$HOME/onpath/sonar-scanner/bin"
export PATH="$PATH:$HOME/.google-cloud-sdk/bin"
# source '/Users/mac/lib/azure-cli/az.completion'

# Following https://wilsonmar/github.io/jmeter-install ::
export PATH="/usr/local/Cellar/jmeter/3.3/libexec/bin:$PATH"
export JMETER_HOME=/usr/local/Cellar/jmeter/3.3/libexec  # if installed using Homebrew

export ANDROID_SDK_ROOT="/usr/local/share/android-sdk"      
export ANT_HOME=/usr/local/opt/ant
export PATH=$ANT_HOME/bin:$PATH

export MAVEN_HOME=/usr/local/opt/maven
export PATH=$MAVEN_HOME/bin:$PATH

export GRADLE_HOME=/usr/local/opt/gradle
export PATH=$GRADLE_HOME/bin:$PATH

export ANDROID_HOME=/usr/local/opt/android-sdk
export ANDROID_NDK_HOME=/usr/local/opt/android-ndk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/build-tools/19.1.0
if [ -f /Users/wilsonmar/.git-completion.bash ]; then
   . /Users/wilsonmar/.git-completion.bash
fi

# mac-bash-profile.txt in https://github.com/wilsonmar/git-utilities
# For paste into ~/.bash_profile 

alias c="clear"
alias p="pwd"
alias sbp='source ~/.bash_profile'
alias rs='exec -l $SHELL'

alias dir='ls -alr'
alias ll='ls -FalhG'

alias gs='git status -s -b'
alias grm='git rm $(git ls-files --deleted)'
alias gb='git branch -avv'
function gd() { # get dirty
	[[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]] && echo "*"
}
function parse_git_branch() {
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(gd)/"
}
alias get='git pull'
alias gf='git fetch;git diff master..origin/master'
alias gmo='git merge origin/master'
alias ga='git add .'
alias gc='git commit -m' # requires you to type a commit message
alias gl='clear;git status;git log --pretty=format:"%h %s %ad" --graph --since=1.days --date=relative;git log --show-signature -n 1'
alias gbs='git status;git add . -A;git commit -m"Update";git push'
function gas() { git status ;  git add . -A ; git commit -m "$1" ; git push; }
alias gp='git push'

# For more Mac aliases, see https://gist.github.com/natelandau/10654137
   # described at https://natelandau.com/my-mac-osx-bash_profile/
# https://github.com/clvv/fasd

alias p4merge='/Applications/p4merge.app/Contents/MacOS/p4merge'
export EDITOR="/usr/local/bin/mate -w" 
alias sts='open -a "/Applications/STS.app"'
alias eclipse='open "/Applications/Eclipse.app"'
alias subl='open -a "/Applications/Sublime Text.app"'
alias textedit='open -a "/Applications/TextEdit.app"'
export PATH="$PATH:/usr/local/bin/chromedriver"
alias macvim='open -a "/Applications/MacVim.app"'
alias tf="terraform $1"
alias tfa="terraform apply"
alias tfd="terraform destroy"
alias tfs="terraform show"
export CLICOLOR=1
export ARCHFLAGS="-arch x86_64"
alias idea='open -a "/Applications/IntelliJ IDEA CE.app"'
export alias python=/usr/local/bin/python2.7
export PATH="/usr/local/opt/python/libexec/bin:/usr/local/opt/gradle/bin:/usr/local/opt/maven/bin:/usr/local/opt/ant/bin:/usr/local/Cellar/jmeter/3.3/libexec/bin:/Users/wilsonmar/gits/wilsonmar/git-utilities/git-custom-commands:/Users/wilsonmar/gits:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/local/share/dotnet:/usr/local/Cellar/maven/3.5.0/libexec/bin:/Users/wilsonmar/onpath/sonar-scanner/bin:/Users/wilsonmar/.google-cloud-sdk/bin:/usr/local/opt/android-sdk/tools:/usr/local/opt/android-sdk/platform-tools:/usr/local/opt/android-sdk/build-tools/19.1.0:/usr/local/bin/chromedriver"
alias gcs='cd ~/.google-cloud-sdk;ls'
export NVM_DIR="/Users/wilsonmar/.nvm"
