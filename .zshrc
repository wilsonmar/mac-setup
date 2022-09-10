#!/usr/bin/env zsh
# This is file ~/.zshrc from template at https://github.com/wilsonmar/mac-setup/blob/main/.zshrc
# This is not provided by macOS by default.
# This is explained in https://wilsonmar.github.io/zsh
# This was migrated from ~/.bash_profile

# In .zshenv
# Colons separate items in $PATH (semicolons as in Windows will cause error):
export PATH="/usr/local/bin:/bin:/usr/bin:/usr/sbin:/sbin:${PATH}"
   # /usr/local/bin contains user-installed (using brew) so should be first to override libraries
   # /bin contains macOS bash, zsh, chmod, cat, cp, date, echo, ls, rm, kill, link, mkdir, rmdir, conda, ...
   # /usr/bin contains macOS alias, awk, base64, nohup, make, man, perl, pbcopy, sudo, xattr, zip, etc.
   # /usr/sbin contains macOS chown, cron, disktutil, expect, fdisk, mkfile, softwareupdate, sysctl, etc.
   # /sbin contains macOS fsck, mount, etc.

export PATH="/Applications:$HOME/Applications:$HOME/Applications/Utilities:${PATH}"  # for apps

#### See https://wilsonmar.github.io/homebrew
# Provide a separate folder to install additional apps:
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"
#export HOMEBREW_CASK_OPTS="--appdir=~/Applications --caskroom=~/Caskroom"

# Apple Directory Services database Command Line utility:
USER_SHELL_INFO="$( dscl . -read /Users/$USER UserShell )"   # UserShell: /bin/zsh
# Shell scripting NOTE: Double brackets and double dashes to compare strings, with space between symbols:
if [[ "UserShell: /bin/bash" = *"${USER_SHELL_INFO}"* ]]; then
   echo "chsh -s /bin/zsh to switch to zsh from ${USER_SHELL_INFO}"
  #chsh -s /opt/homebrew/bin/zsh  # not allow because it is a non-standard shell.
   # chsh -s /bin/zsh
   # Password will be requested here.
   exit 9  # to restart
fi
# if Zsh:
   echo "SHELL=$SHELL at $(which zsh)"  # /bin/zsh
      # Answer: /opt/homebrew/bin/zsh  (using homebrew or default one from Apple?)
      # Answer: "/usr/local/bin/zsh" if still running Bash.

echo "Apple macOS sw_vers = $(sw_vers -productVersion) / uname = $(uname -r)"  # sw_vers: 10.15.1 / uname = 21.4.0
   # See https://eclecticlight.co/2020/08/13/macos-version-numbering-isnt-so-simple/
   # See https://scriptingosx.com/2020/09/macos-version-big-sur-update/
# This in .zshrc fixes the "brew not found" error on a machine with Apple M1 CPU under Monterey:
# See https://apple.stackexchange.com/questions/148901/why-does-my-brew-installation-not-work
if [[ "$(uname -m)" = *"arm64"* ]]; then
   # On Apple M1 Monterey: /opt/homebrew/bin is where Zsh looks (instead of /usr/local/bin):
   export BREW_PATH="/opt/homebrew"
   complete "${BREW_PATH}/share/zsh/site-functions"  # auto-completions in .bashrc
   eval $( "${BREW_PATH}/bin/brew" shellenv)
   # Password will be requested here.
elif [[ "$(uname -m)" = *"x86_64"* ]]; then
   export BREW_PATH="/usr/local/bin"
fi
echo "BREW_PATH=$BREW_PATH"
export PATH="$BREW_PATH/bin/:$BREW_PATH/bin/share/:${PATH}"
   # /opt/homebrew/ contains folders bin, Cellar, Caskroom, completions, lib, opt, sbin, var, etc.
   # /opt/homebrew/bin/ contains brew, atom, git, go, htop, jq, tree, vault, wget, xz, zsh, etc. installed
   # /opt/homebrew/share/ contains emacs, fish, man, perl5, vim, zsh, zsh-completions, etc.
export FPATH=":$BREW_PATH/share/zsh-completions:$FPATH"
   #export PATH="${PATH}:/usr/local/opt/grep/libexec/gnubin"   # after brew install grep ?

#### Configurations for macOS Operating System :
# sudo launchctl limit maxfiles 65536 200000
   # Password will be requested here due to sudo.

export GREP_OPTIONS="--color=auto"
#export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"


#### Retrieve environment variables
if [ ! -f "$HOME/mac-setup.env" ]; then  # folder was created for Microsoft Azure cloud, so:
   echo "Loading mac-setup.env configuration variables..."
   source "$HOME/mac-setup.env"
fi

# See https://apple.stackexchange.com/questions/296477/my-command-line-says-complete13-command-not-found-compdef
# To avoid command line error (in .zshrc): command not found: complete
autoload bashcompinit
bashcompinit
autoload -Uz compinit
compinit

# Add `killall` tab completion for common apps:
COMMON_APPS="Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter"
complete -o "nospace" -W "$COMMON_APPS" killall;

#[[ -r ~/Projects/autopkg_complete/autopkg ]] && source ~/Projects/autopkg_complete/autopkg

#export ZSH="$HOME/.oh-my-zsh"
#if [ -d "$ZSH" ]; then  # is installed:
    # Set list of themes to pick from when loading at random
    # Setting this variable when ZSH_THEME=random will cause zsh to load
    # a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
    # If set to an empty array, this variable will have no effect.
    # ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

    # Set name of the theme to load --- if set to "random", it will
    # load a random theme each time oh-my-zsh is loaded, in which case,
    # to know which specific one was loaded, run: echo $RANDOM_THEME
    # See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#    ZSH_THEME="robbyrussell"
#    source $ZSH/oh-my-zsh.sh
#fi

# Set Terminal prompt that shows the Zsh % prompt rather than $ bash prompt:
# bash:
   #export PS1="\n  \w\[\033[33m\]\n$ "
# zsh:
autoload -Uz promptinit && promptinit
export PS1="${prompt_newline}${prompt_newline}  %11F%~${prompt_newline}%% "
   # %11F = yellow. %~ = full path, %% for the Zsh prompt (instead of $ prompt for bash)
   # %n = username

#### For compilers to find sqlite and openssl per https://qiita.com/nahshi/items/fcf4898f7c45f11a5c63
export CFLAGS="-I$(brew --prefix readline)/include -I$(brew --prefix openssl)/include -I$(xcrun --show-sdk-path)/usr/include"
export LDFLAGS="-L$(brew --prefix readline)/lib -L$(brew --prefix openssl)/lib"
export PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig"

export GPG_TTY="$(tty)"
export CLICOLOR=1
export LSCOLORS="GxFxCxDxBxegedabagaced"
# Language environment:
export LANG="en_US.UTF-8"
export LC_ALL="en_US.utf-8"
# Compilation flags: "x86_64" or "arm64" on Apple M1: https://gitlab.kitware.com/cmake/cmake/-/issues/20989
export ARCHFLAGS="-arch $(uname -m)"
   # echo "ARCHFLAGS=$ARCHFLAGS"


# https://gist.github.com/sindresorhus/98add7be608fad6b5376a895e5a59972
# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;


#### See https://wilsonmar.github.io/ruby-on-apple-mac-osx/
# No command checking since Ruby was installed by default on Apple macOS:
if [ -d "$HOME/.rbenv" ]; then  # Ruby environment manager
   export PATH="$HOME/.rbenv/bin:${PATH}"
   eval "$(rbenv init -)"   # at the end of the file
   echo "$( ruby --version) with .rbenv"  # example: ruby 2.6.1p33 (2019-01-30 revision 66950) [x86_64-darwin18]"
fi
if [ -d "$HOME/.rvm" ]; then  # Ruby version manager
   #export PATH="$PATH:$HOME/.rvm/gems/ruby-2.3.1/bin:${PATH}"
   #[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
   echo "$( ruby --version) with .rvm"  # example: ruby 2.6.1p33 (2019-01-30 revision 66950) [x86_64-darwin18]"
fi

# https://github.com/asdf-vm/asdf


#### See https://wilsonmar.github.io/task-runners
export GRADLE_HOME="/usr/local/opt/gradle"
if [ -d "${GRADLE_HOME}/bin" ]; then  # folder is there
   export PATH="$GRADLE_HOME/bin:${PATH}"  # contains gradle file.
fi

#### See https://wilsonmar.github.io/hashicorp-consul
# export PATH="$HOME/.func-e/versions/1.20.1/bin/:${PATH}"  # contains envoy

#### See https://wilsonmar.github.io/maven  since which maven doesn't work:
#if [ -d "$HOME/.m2" ]; then  # folder was created
#   if ! command -v maven >/dev/null; then
      #/usr/local/opt/maven
      #/usr/local/Cellar/maven
      #export M2_HOME=/usr/local/Cellar/maven/3.5.0/libexec
      #export M2=$M2_HOME/bin
      #export PATH=$PATH:$M2_HOME/bin
      #export MAVEN_HOME=/usr/local/opt/maven
      #export PATH=$MAVEN_HOME/bin:$PATH
#   fi
#fi


#### See https://wilsonmar.github.io/aws-onboarding/
if [ -d "$HOME/aws" ]; then  # folder was created for AWS cloud, so:
   complete -C aws_completer aws
   export AWS_DEFAULT_REGION="us-west-2"
   export EC2_URL="https://${AWS_DEFAULT_REGION}.console.aws.amazon.com/ec2/v2/home?region=${AWS_DEFAULT_REGION}#Instances:sort=instanceId"
   alias ec2="open ${EC2_URL}"
fi

#### See https://wilsonmar.github.io/gcp
GOOGLE_BIN_PATH="$HOME/.google-cloud-sdk/bin"
if [ -d "$GOOGLE_BIN_PATH" ]; then  # folder was created for GCP cloud, so:
   export PATH="$PATH:$GOOGLE_BIN_PATH"
fi

#### See https://wilsonmar.github.io/azure
# TODO:
if [ -d "$HOME/azure" ]; then  # folder was created for Microsoft Azure cloud, so:
   source "$HOME/lib/azure-cli/az.completion"
fi

# https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/
if command -v kubectl >/dev/null; then  # found:
   source <(kubectl completion zsh)
fi

### See https://wilsonmar.github.io/sonar
#export PATH="$PATH:$HOME/onpath/sonar-scanner/bin"


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



#### See https://wilsonmar.github.io/rustlang
export PATH="$HOME/.cargo/bin:$PATH"


#### See https://wilsonmar.github.io/python-install
export PYENV_ROOT="$HOME/.pyenv"
if [ -d "$PYENV_ROOT" ]; then  # folder was created for Python3, so:
   export PATH="$PYENV_ROOT/bin:$PATH"
   export PYTHON_CONFIGURE_OPTS="--enable-unicode=ucs2"
   # export PYTHONPATH="/usr/local/Cellar/python/3.6.5/bin/python3:$PYTHONPATH"
   # python=/usr/local/bin/python3
   #alias python=python3
   # export PATH="$PATH:$HOME/Library/Caches/AmlWorkbench/Python/bin"
   # export PATH="$PATH:/usr/local/anaconda3/bin"  # for conda
   if command -v pyenv 1>/dev/null 2>&1; then
     eval "$(pyenv init -)"
   fi
fi

# >>> Python conda initialize >>>
if [ -d "$HOME/miniconda3" ]; then  # folder was created for Python3, so:
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
fi


#### See https://wilsonmar.github.io/golang
if command -v go >/dev/null; then
    export GOROOT="$(brew --prefix golang)/libexec"  # /usr/local/opt/go/libexec/bin"
    if [ -d "$GOROOT" ]; then
      export PATH="${PATH}:${GOROOT}"
    fi

    export GOPATH="$HOME/go"   #### Folders created in mac-setup.zsh
    if [ -d "${GOPATH}" ]; then  # folder was created for Golang, so:
      export PATH="${PATH}:${GOPATH}/bin"
    fi

   if [ ! -d "${GOPATH}/src" ]; then
      mkdir -p "${GOPATH}/src"
   fi
   # echo "Start Golang projects by making a new folder within GOPATH ~/go/src"
   # ls "${GOPATH}/src"
   # export GOHOME="$HOME/golang1"   # defined in mac-setup.env
fi

#### See https://wilsonmar.github.io/scala
# export SCALA_HOME=/usr/local/opt/scala/libexec
# export JAVA_HOME generated by jenv, =/Library/Java/JavaVirtualMachines/jdk1.8.0_162.jdk/Contents/Home
#export JENV_ROOT="$(which jenv)" # /usr/local/var/jenv
#if command -v jyenv 1>/dev/null 2>&1; then
#  eval "$(jenv init -)"
#fi


#### See https://wilsonmar.github.io/elixir-lang
if [ -d "$HOME/.asdf" ]; then
    source $HOME/.asdf/asdf.sh
fi


#### See https://wilsonmar.github.io/airflow  # ETL
# PATH=$PATH:~/.local/bin
# export AIRFLOW_HOME="$HOME/airflow-tutorial"


#### See https://wilsonmar.github.io/neo4j  # Graph DB
# export NEO4J_HOME=/usr/local/opt/neo4j
# export NEO4J_CONF=/usr/local/opt/neo4j/libexec/conf/

# Liquibase is a SQL database testing utility:
#export LIQUIBASE_HOME='/usr/local/opt/liquibase/libexec'


#### See https://wilsonmar.github.io/jmeter-install/
#export PATH="$HOME/jmeter:$PATH"

# Inserted by: consul -autocomplete-install
complete -o nospace -C /usr/local/bin/consul consul

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
#export SDKMAN_DIR="$HOME/.sdkman"
#[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

source ~/aliases.zsh   # export alias variables into memory
#catn ~/aliases.zsh    # Show aliases keys as reminder

# echo "*** For working on the latest:"
cd ~/github-wilsonmar/wilsonmar.github.io/_posts
# cd "$HOME/github-wilsonmar/mac-setup"
# cd "$HOME/bomonike/fullest-stack"
# END

