# This file is opened automatically by macOS by default.
# This is ~/.bash_profile from template https://github.com/wilsonmar/mac-setup/blob/main/.bash_profile
PATH=/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/sbin:/opt/local/bin:/opt/local/sbin:/usr/local/share/dotnet
   # This PATH should also be in ~/.zshenv
   # Note colons separate items in $PATH.
   # /usr/bin/python:/usr/local/bin/python3:
   # /usr/local/bin before usr/bin so Homebrew stuff is found first
   # alias fix_brew='sudo chown -R $USER /usr/local/'export PATH="/usr/local/bin:$PATH"
   # For homebrew:
   # $(brew --prefix)/sbin

# In .bashrc are parse_git_branch, PS1, git_completion, and extract for serverless, rvm, nvm
source ~/.bashrc
   # NOTE: parse_git_branch is defined in .bash_profile, but not exported. 
   # When you run sudo bash, it starts an nonlogin shell that sources .bashrc instead of .bash_profile. 
   # PS1 was exported and so is defined in the new shell, but parse_git_branch is not.

# See https://eclecticlight.co/2020/08/13/macos-version-numbering-isnt-so-simple/
# https://scriptingosx.com/2020/09/macos-version-big-sur-update/
# For sw_vers -productVersion  => 10.16
# export SYSTEM_VERSION_COMPAT=1

#### See https://wilsonmar.github.io/homebrew
# For use in brew cask install 
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"
#export HOMEBREW_CASK_OPTS="--appdir=~/Applications --caskroom=~/Caskroom"
sudo launchctl limit maxfiles 65536 200000

export GPG_TTY=$(tty)
export CLICOLOR=1
export LSCOLORS="GxFxCxDxBxegedabagaced" # 
export ARCHFLAGS="-arch x86_64"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# shopt builtin command of the Bash shell that enables or disables options for the current shell session:
# See https://www.computerhope.com/unix/bash/shopt.htm
# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;
# Append to the Bash history file, rather than overwriting it:
shopt -s histappend;
# Autocorrect typos in path names when using `cd`:
shopt -s cdspell;

export GREP_OPTIONS='--color=auto'
#source ~/sf-secrets.shCreated by git-flow.sh
#export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"

# For compilers to find sqlite and openssl per https://qiita.com/nahshi/items/fcf4898f7c45f11a5c63 
#export CFLAGS="-I$(brew --prefix readline)/include -I$(brew --prefix openssl)/include -I$(xcrun --show-sdk-path)/usr/include"
export LDFLAGS="-L$(brew --prefix readline)/lib -L$(brew --prefix openssl)/lib"
export PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig"

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Copied from https://github.com/wilsonmar/git-utilities:
#export PATH="$HOME/gits:$PATH"
#export PATH="$HOME/gits/wilsonmar/git-utilities/git-custom-commands:$PATH"
#export WM="$HOME/gits/wilsonmar/wilsonmar.github.io"
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

# Added by ./mac-setup-all.sh ::
if [ -f $HOME/.git-completion.bash ]; then
      . $HOME/.git-completion.bash
fi

# https://gist.github.com/sindresorhus/98add7be608fad6b5376a895e5a59972
# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

#### For Ruby:
#export PATH="$PATH:$HOME/.rvm/gems/ruby-2.3.1/bin"
#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export LC_ALL=en_US.utf-8
#export PATH="$HOME/.rbenv/bin:$PATH"
#eval "$(rbenv init -)"   # at the end of the file

#### See https://wilsonmar.github.io/node-install
export NVM_DIR="$HOME/.nvm"
source "$HOME/.nvm/nvm.sh"  # instead of "/usr/local/opt/nvm/nvm.sh"
#export PATH=$PATH:$HOME/.nvm/versions/node/v9.11.1/lib/node_modules

#export GRADLE_HOME=/usr/local/opt/gradle
#export PATH=$GRADLE_HOME/bin:$PATH

#### See https://wilsonmar.github.io/maven  since which maven doesn't work:
#export M2_HOME=/usr/local/Cellar/maven/3.5.0/libexec
#export M2=$M2_HOME/bin
#export PATH=$PATH:$M2_HOME/bin
#export MAVEN_HOME=/usr/local/opt/maven
#export PATH=$MAVEN_HOME/bin:$PATH

#### See https://wilsonmar.github.io/aws-onboarding/
complete -C aws_completer aws
export AWS_DEFAULT_REGION="us-west-2"
export EC2_URL="https://${AWS_DEFAULT_REGION}.console.aws.amazon.com/ec2/v2/home?region=${AWS_DEFAULT_REGION}#Instances:sort=instanceId"
alias ec2="open ${EC2_URL}"

### See https://wilsonmar.github.io/sonar
export PATH="$PATH:$HOME/onpath/sonar-scanner/bin"

#### See https://wilsonmar.github.io/gcp
export PATH="$PATH:$HOME/.google-cloud-sdk/bin"

#### See https://wilsonmar.github.io/azure
# source '/Users/mac/lib/azure-cli/az.completion'

#### See https://wilsonmar.github.io/android-install/
#export ANDROID_SDK_ROOT="/usr/local/share/android-sdk"      
#export ANDROID_HOME=/usr/local/opt/android-sdk
#export ANDROID_NDK_HOME=/usr/local/opt/android-ndk
#export PATH=$PATH:$ANDROID_HOME/tools
#export PATH=$PATH:$ANDROID_HOME/platform-tools
#export PATH=$PATH:$ANDROID_HOME/build-tools/19.1.0

# export PATH="$PATH:/usr/local/bin/chromedriver"  # for Selenium

#### See https://wilsonmar/github.io/jmeter-install ::
#export PATH="/usr/local/Cellar/jmeter/3.3/libexec/bin:$PATH"
#export JMETER_HOME="/usr/local/Cellar/jmeter/5.4.1/libexec"
#export ANT_HOME=/usr/local/opt/ant
#export PATH=$ANT_HOME/bin:$PATH

#### See https://wilsonmar.github.io/salesforce-npsp-performance/
# export GATLING_HOME=/usr/local/opt/gatling

#### See https://wilsonmar.github.io/neo4j
# export NEO4J_HOME=/usr/local/opt/neo4j
# export NEO4J_CONF=/usr/local/opt/neo4j/libexec/conf/

#### See https://wilsonmar.github.io/scala
# export SCALA_HOME=/usr/local/opt/scala/libexec
# export JAVA_HOME generated by jenv, =/Library/Java/JavaVirtualMachines/jdk1.8.0_162.jdk/Contents/Home
#export JENV_ROOT="$(which jenv)" # /usr/local/var/jenv
#if command -v jyenv 1>/dev/null 2>&1; then
#  eval "$(jenv init -)"
#fi
#export PATH="$HOME/jmeter:$PATH" 

#### R language:
# export PATH="$PATH:/usr/local/Cellar/r/3.4.4/lib/R/bin"
# alias rv34='/usr/local/Cellar/r/3.4.4/lib/R/bin/R'

### See https://wilsonmar.github.io/ruby-on-apple-mac-osx/
if command -v rbenv 1>/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

#### See https://wilsonmar.github.io/rustlang
export PATH="$HOME/.cargo/bin:$PATH"

#### See https://wilsonmar.github.io/airflow
# PATH=$PATH:~/.local/bin
# export AIRFLOW_HOME="$HOME/airflow-tutorial"  

#### See https://wilsonmar.github.io/python-install
export PYTHON_CONFIGURE_OPTS=--enable-unicode=ucs2
# export PYTHONPATH="/usr/local/Cellar/python/3.6.5/bin/python3:$PYTHONPATH"
# python=/usr/local/bin/python3
#alias python=python3
# export PATH="$PATH:$HOME/Library/Caches/AmlWorkbench/Python/bin"
# export PATH="$PATH:/usr/local/anaconda3/bin"  # for conda
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$HOME/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize venv <<<
conda activate py3k

#### See https://wilsonmar.github.io/golang
export PATH="$PATH:/usr/local/opt/go/libexec/bin"
#export GOROOT='/usr/local/opt/go/libexec/bin'
export GOPATH='$HOME/go'
export GOHOME='$HOME/golang1'

#### See https://wilsonmar.github.io/elixir-lang
source $HOME/.asdf/asdf.sh

#### See https://wilsonmar.github.io/hashicorp-vault
# export VAULT_VERSION="1.9.2"  # TODO: extract this from --version
# complete -C /usr/local/bin/vault vault
# export VAULT_ADDR=https://vault.enbala-engine.com:8200

#export LIQUIBASE_HOME='/usr/local/opt/liquibase/libexec'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

#### See https://wilsonmar.github.io/macos-install
# Show aliases keys as reminder:
source ~/aliases.sh
#     catn filename to show text file without comment (#) lines:
alias catn="grep -Ev '''^(#|$)'''"
catn ~/aliases.sh
# For more Mac aliases, see https://gist.github.com/natelandau/10654137
   # described at https://natelandau.com/my-mac-osx-bash_profile/
# https://github.com/clvv/fasd

# Position to most frequently used:
cd ~/gmail_acct/wilsonmar.github.io/_posts
gsl  # alias for "git status list"

export PATH="$PATH:$HOME/gmail_acct/tf-samples"
export PATH="$PATH:$HOME/gmail_acct/python-samples"

complete -C /usr/local/bin/vault vault
