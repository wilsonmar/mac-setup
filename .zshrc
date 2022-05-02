#!/usr/bin/env zsh
# This is file ~/.zshrc from template at https://github.com/wilsonmar/mac-setup/blob/main/.zshrc
# This is not provided by macOS by default.
# This is explained in https://wilsonmar.github.io/zsh
# This was migrated from ~/.bash_profile

# Apple Directory Services database Command Line utility:
echo "$( dscl . -read /Users/$USER UserShell )"
    # UserShell: /bin/zsh
#which zsh
   # /opt/homebrew/bin/zsh
# echo "sw_vers = $( sw_vers -productVersion )"  # example: 10.15.1

# Colons separate items in $PATH:
export PATH="/bin:/usr/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:${PATH}"
   # /bin contains bash, chmod, cat, cp, date, echo, ls, rm, kill, link, mkdir, rmdir, zsh, ...
   # /usr/bin contains alias, awk, base64, nohup, make, man, perl, pbcopy, sudo, zip, etc.
   # /usr/sbin contains chown, cron, disktutil, fdisk, mkfile, sysctl, etc.
   # /sbin contains fsck, mount, etc.

# On Apple M1 Monterey: /opt/homebrew/bin is where Zsh looks (instead of /usr/local/bin):
BREW_PATH="$(brew --prefix)"   # /opt/homebrew or /usr/local/bin
   # On M1 chips (uname -u = "arm_64"), brew modules are installed in "/opt/homebrew/bin/""
   # On x86_64, brew modules are install in "/usr/local/bin" 
export PATH="$BREW_PATH/:$BREW_PATH/bin/:${PATH}"
   # /opt/homebrew/ contains bin, Cellar, Caskroom, completions, lib, opt, sbin, var, etc.
   # /opt/homebrew/bin/ contains brew, atom, git, go, htop, jq, tree, vault, wget, xz, zsh, etc. installed
   # /opt/homebrew/share/ contains emacs, fish, man, perl5, vim, zsh, zsh-completions, etc.
# Turn off group-writable permissions: see https://thevaluable.dev/zsh-install-configure-mouseless/
   chmod 755 "$BREW_PATH/share/zsh"
   #chmod g-w "$BREW_PATH/share/zsh"
   #chmod g-w "$BREW_PATH/share/zsh/site-functions"

#  chmod g-w "/usr/share/zsh/5.8/functions"
#export PATH="/usr/share/zsh/5.8/functions:${PATH}"  # contains autoload, compinit,

export PATH="/Applications:$HOME/Applications:$HOME/Applications/Utilities:${PATH}"  # for apps
export PATH="${PATH}:/usr/local/opt/grep/libexec/gnubin"   # after brew install grep

# This in .zshrc fixes the "brew not found" error on a machine with Apple M1 CPU under Monterey:
# See https://apple.stackexchange.com/questions/148901/why-does-my-brew-installation-not-work
eval $( "${BREW_PATH}/bin/brew" shellenv)
export FPATH="$BREW_PATH/share/zsh-completions:$FPATH"

#### Configurations for macOS Operating System :
sudo launchctl limit maxfiles 65536 200000
export GREP_OPTIONS='--color=auto'
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
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

#[[ -r ~/Projects/autopkg_complete/autopkg ]] && source ~/Projects/autopkg_complete/autopkg


#### See https://wilsonmar.github.io/zsh
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"
#export HOMEBREW_CASK_OPTS="--appdir=~/Applications --caskroom=~/Caskroom"


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
export PS1="%10F%m%f:%11F%1~%f % "


#### For compilers to find sqlite and openssl per https://qiita.com/nahshi/items/fcf4898f7c45f11a5c63 
export CFLAGS="-I$(brew --prefix readline)/include -I$(brew --prefix openssl)/include -I$(xcrun --show-sdk-path)/usr/include"
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
   # echo "ARCHFLAGS=$ARCHFLAGS"


# https://gist.github.com/sindresorhus/98add7be608fad6b5376a895e5a59972
# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;


#### See https://wilsonmar.github.io/hashicorp-vault
if command -v vault >/dev/null; then
   export VAULT_ADDR=https://vault.???.com:8200
   complete -C /usr/local/bin/vault vault
   complete -o nospace -C /usr/local/bin/vault vault
   VAULT_VERSION="$(ls $BREW_PATH/Cellar/vault/)"
   echo "VAULT_VERSION=$VAULT_VERSION at $VAULT_ADDR"  # Example: "1.10.1"
fi


#### For Ruby:
#export PATH="$PATH:$HOME/.rvm/gems/ruby-2.3.1/bin"
#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export LC_ALL=en_US.utf-8
#export PATH="$HOME/.rbenv/bin:$PATH"
#eval "$(rbenv init -)"   # at the end of the file


#### See https://wilsonmar.github.io/node-install
export NVM_DIR="$HOME/.nvm"
if [ -d "$NVM_DIR" ]; then  # folder was created for NodeJs, so:
   source "$HOME/.nvm/nvm.sh"  # instead of "/usr/local/opt/nvm/nvm.sh"
   #export PATH=$PATH:$HOME/.nvm/versions/node/v9.11.1/lib/node_modules
fi

#### Task Runners:
#export GRADLE_HOME=/usr/local/opt/gradle
#export PATH=$GRADLE_HOME/bin:$PATH

#### See https://wilsonmar.github.io/maven  since which maven doesn't work:
#export M2_HOME=/usr/local/Cellar/maven/3.5.0/libexec
#export M2=$M2_HOME/bin
#export PATH=$PATH:$M2_HOME/bin
#export MAVEN_HOME=/usr/local/opt/maven
#export PATH=$MAVEN_HOME/bin:$PATH


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
   source '$HOME/lib/azure-cli/az.completion'
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

#### See https://wilsonmar.github.io/neo4j
# export NEO4J_HOME=/usr/local/opt/neo4j
# export NEO4J_CONF=/usr/local/opt/neo4j/libexec/conf/


### See https://wilsonmar.github.io/ruby-on-apple-mac-osx/
if command -v rbenv 1>/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

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
      export PATH="$PATH:${GOROOT}"
    fi

    export GOPATH='$HOME/go'   #### Folders created in mac-setup.zsh
    if [ -d "$GOPATH" ]; then  # folder was created for Golang, so:
      export PATH="$PATH:${GOPATH}/bin"
    fi

   if [ ! -d "$GOPATH/src" ]; then
      mkdir -p "$GOPATH/src"
   fi
      # echo "Start Golang projects by making a new folder within GOPATH ~/go/src"
      # ls "${GOPATH}/src"

   # export GOHOME='$HOME/golang1'   # defined in mac-setup.env
fi


#### See https://wilsonmar.github.io/elixir-lang
if [ -d "$HOME/.asdf" ]; then
    source $HOME/.asdf/asdf.sh
fi


#### See https://wilsonmar.github.io/airflow  # ETL
# PATH=$PATH:~/.local/bin
# export AIRFLOW_HOME="$HOME/airflow-tutorial"  

# Liquibase is a SQL database testing utility:
#export LIQUIBASE_HOME='/usr/local/opt/liquibase/libexec'


#### See https://wilsonmar.github.io/scala
# export SCALA_HOME=/usr/local/opt/scala/libexec
# export JAVA_HOME generated by jenv, =/Library/Java/JavaVirtualMachines/jdk1.8.0_162.jdk/Contents/Home
#export JENV_ROOT="$(which jenv)" # /usr/local/var/jenv
#if command -v jyenv 1>/dev/null 2>&1; then
#  eval "$(jenv init -)"
#fi
#export PATH="$HOME/jmeter:$PATH" 

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
#export SDKMAN_DIR="$HOME/.sdkman"
#[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


#### See https://wilsonmar.github.io/mac-setup
# Show aliases keys as reminder:
source ~/aliases.zsh
#     catn filename to show text file without comment (#) lines:
alias catn="grep -Ev '''^(#|$)'''"
#catn ~/aliases.zsh
# For more Mac aliases, see https://gist.github.com/natelandau/10654137
   # described at https://natelandau.com/my-mac-osx-bash_profile/
# https://github.com/clvv/fasd


   # NOTE: parse_git_branch is defined in .bash_profile, but not exported. 
   # When you run sudo bash, it starts an nonlogin shell that sources .bashrc instead of .bash_profile. 
   # PS1 was exported and so is defined in the new shell, but parse_git_branch is not.


#THIS MUST BE AT THE END OF THE FILE FOR Java SDKMAN TO WORK!!!
#export SDKMAN_DIR="/Users/wilsonmar/.sdkman"
#[[ -s "/Users/wilsonmar/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/wilsonmar/.sdkman/bin/sdkman-init.sh"

