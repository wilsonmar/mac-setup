# This is file ~/.zshrc from template at https://github.com/wilsonmar/mac-setup/blob/main/.zshrc
# This is not provided by macOS by default.
# This is explained in https://wilsonmar.github.io/zsh
# This was migrated from ~/.bash_profile

# Colons separate items in $PATH:
export PATH=/usr/local/bin:$HOME/bin:/opt/homebrew/bin:/bin/zsh:/Applications:$HOME/Applications:$PATH
   # On Apple M1 Monterey: /opt/homebrew/bin is where Zsh looks for brew (instead of /usr/local/bin):
   # By default, macOs ships with zsh located in/bin/zsh.
   # For homebrew: # $(brew --prefix)/sbin

# This in .zshrc fixes the "brew not found" error on a machine with Apple M1 CPU under Monterey:
# See https://apple.stackexchange.com/questions/148901/why-does-my-brew-installation-not-work
eval $(/opt/homebrew/bin/brew shellenv)
   
# To activate zsh-completions:
  if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    autoload -Uz compinit
    compinit
  fi

# Path to your oh-my-zsh installation:
export ZSH="$HOME/.oh-my-zsh"
if [ ! -f "$ZSH" ]; then # install:
  echo "Please install based on https://ohmyz.sh/ (NO brew install)"
fi

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"
source $ZSH/oh-my-zsh.sh

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

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
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# export MANPATH="/usr/local/man:$MANPATH"

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

#### See https://wilsonmar.github.io/homebrew
# For use in brew cask install 
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"
#export HOMEBREW_CASK_OPTS="--appdir=~/Applications --caskroom=~/Caskroom"
sudo launchctl limit maxfiles 65536 200000

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
#source ~/sf-secrets.sh  # Created by git-flow.sh
#export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"

# For compilers to find sqlite and openssl per https://qiita.com/nahshi/items/fcf4898f7c45f11a5c63 
#export CFLAGS="-I$(brew --prefix readline)/include -I$(brew --prefix openssl)/include -I$(xcrun --show-sdk-path)/usr/include"
export LDFLAGS="-L$(brew --prefix readline)/lib -L$(brew --prefix openssl)/lib"
export PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig"
# See https://eclecticlight.co/2020/08/13/macos-version-numbering-isnt-so-simple/
# https://scriptingosx.com/2020/09/macos-version-big-sur-update/
# For sw_vers -productVersion  => 10.16
# export SYSTEM_VERSION_COMPAT=1

export GPG_TTY=$(tty)
export CLICOLOR=1
export LSCOLORS="GxFxCxDxBxegedabagaced" # 
# Language environment:
export LANG=en_US.UTF-8
# Compilation flags: "x86_64" or "arm64" on Apple M1: https://gitlab.kitware.com/cmake/cmake/-/issues/20989
export ARCHFLAGS="-arch $(uname -m)"
note "ARCHFLAGS=$ARCHFLAGS"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/vault vault

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

# Add `killall` tab completion for common apps:
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

# >>> Python conda initialize >>>
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
# source $HOME/.asdf/asdf.sh

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


   # NOTE: parse_git_branch is defined in .bash_profile, but not exported. 
   # When you run sudo bash, it starts an nonlogin shell that sources .bashrc instead of .bash_profile. 
   # PS1 was exported and so is defined in the new shell, but parse_git_branch is not.


#THIS MUST BE AT THE END OF THE FILE FOR Java SDKMAN TO WORK!!!
#export SDKMAN_DIR="/Users/wilsonmar/.sdkman"
#[[ -s "/Users/wilsonmar/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/wilsonmar/.sdkman/bin/sdkman-init.sh"

