#!/usr/bin/env zsh
# gas "v0.29 Add MAC spoofing :.zshrc"
# Using .bash_profile because shellshock scanner doesn't recognize Zsh.
# This is file ~/.zshrc from template at https://github.com/wilsonmar/mac-setup/blob/main/.zshrc
# This is explained in https://wilsonmar.github.io/zsh
# This file is not provided by macOS by default.
# This gets loaded after .zprofile is loaded when a new terminal window is opened.
# This sets the environment for interactive shells.
# It's typically a place where you "set it and forget it" type of parameters like
# $PATH, $PROMPT, aliases, and functions you would like to have in both login and interactive shells.
# This was migrated from ~/.bash_profile
echo "At ~/.zshrc to set environment variables for interactive shells."

#### Configurations for macOS Operating System :
# sudo launchctl limit maxfiles 65536 200000
   # Password will be requested here due to sudo.

# Colons separate items in $PATH (semicolons as in Windows will cause error):
   # /usr/local/bin contains user-installed pgms (using brew) so should be first to override libraries
   # but only on Intel Macs.
export PATH="/opt/homebrew/bin;/usr/local/bin:/usr/local/opt:/usr/local/sbin:/bin:/usr/bin:/usr/sbin:/sbin:${PATH}"
   # /opt/homebrew/ is added in front of /usr/local/bin by brew on Apple M1/2 machines.
   # /usr/local/bin contains pgms installed using brew, so should be first to override libraries
   # /usr/local/opt contains folders for brew-installed apps, such as /usr/local/opt/openssl@1.1
   # /usr/local/sbin contains java, javac, javadoc, javap, etc.
   # /bin contains macOS bash, zsh, chmod, cat, cp, date, echo, ls, rm, kill, link, mkdir, rmdir, conda, ...
   # /usr/bin contains macOS alias, awk, base64, nohup, make, man, perl, pbcopy, sudo, xattr, zip, etc.
   # /usr/sbin contains macOS chown, cron, disktutil, expect, fdisk, mkfile, softwareupdate, sysctl, etc.
   # /sbin contains macOS fsck, mount, etc.

export PATH="$HOME/.ssh:${PATH}"  # for SSH keys & certs.

# Where Apple puts *.app program folders that come with macOS (usually invoked manually by user):
export PATH="/Applications:$HOME/Applications:$HOME/Applications/Utilities:${PATH}"  # for apps

# Per https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line
if [ -f "$HOME/Applications/Visual Studio Code.app" ]; then  # installed:
   export PATH="$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin:${PATH}"
      # contains folder code and code-tunnel
fi


#### See https://wilsonmar.github.io/homebrew

echo "Apple macOS sw_vers = $(sw_vers -productVersion) / uname = $(uname -r)"  # sw_vers: 10.15.1 / uname = 21.4.0
   # See https://eclecticlight.co/2020/08/13/macos-version-numbering-isnt-so-simple/
   # See https://scriptingosx.com/2020/09/macos-version-big-sur-update/
# This in .zshrc fixes the "brew not found" error on a machine with Apple M1 CPU under Monterey:
# See https://apple.stackexchange.com/questions/148901/why-does-my-brew-installation-not-work
if [[ "$(uname -m)" = *"arm64"* ]]; then
   # used by .zshrc instead of .bash_profile
   # On Apple M1 Monterey: /opt/homebrew/bin is where Zsh looks (instead of /usr/local/bin):
   export BREW_PATH="/opt/homebrew"
   eval $( "${BREW_PATH}/bin/brew" shellenv)
   # Password will be requested here.

elif [[ "$(uname -m)" = *"x86_64"* ]]; then
   export BREW_PATH="/usr/local/bin"
   # used by .bashrc and .bash_profile
fi

# Provide a separate folder to install additional apps:
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"
#export HOMEBREW_CASK_OPTS="--appdir=~/Applications --caskroom=~/Caskroom"

if ! command -v complete >/dev/null; then
   echo "brew complete NOT installed for BREW_PATH=$BREW_PATH to $HOMEBREW_CASK_OPTS"
else
   echo "brew complete for BREW_PATH=$BREW_PATH to $HOMEBREW_CASK_OPTS"
   complete "${BREW_PATH}/share/zsh/site-functions"  # auto-completions in .bashrc
fi

# Add to beginning of $PATH:
export PATH="$BREW_PATH/bin/:$BREW_PATH/bin/share/:${PATH}"
   # /opt/homebrew/ contains folders bin, Cellar, Caskroom, completions, lib, opt, sbin, var, etc.
   # /opt/homebrew/bin/ contains brew, atom, git, go, htop, jq, tree, vault, wget, xz, zsh, etc. installed
   # /opt/homebrew/share/ contains emacs, fish, man, perl5, vim, zsh, zsh-completions, etc.
export FPATH=":$BREW_PATH/share/zsh-completions:$FPATH"
   #export PATH="${PATH}:/usr/local/opt/grep/libexec/gnubin"   # after brew install grep ?

# For azure.ai.cli
if [ -d "$HOME/.dotnet/tools" ]; then # is installed:
   export PATH="$HOME/.dotnet/tools/:${PATH}"
   echo "dotnet --version = $(dotnet --version)"
      # 8.0.100
fi

# Upgrade by setting Apple Directory Services database Command Line utility:
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
echo "SHELL=$SHELL at $(which zsh)"  # $SHELL=/bin/zsh
      # Use /opt/homebrew/bin/zsh  (using homebrew or default one from Apple?)
      # Use /usr/local/bin/zsh if running Bash.
# Set Terminal prompt that shows the Zsh % prompt rather than $ bash prompt:
if [[ "/bin/zsh" = *"${SHELL}"* ]]; then
   autoload -Uz promptinit && promptinit
   export PS1="${prompt_newline}${prompt_newline}  %11F%~${prompt_newline}%% "
      # %11F = yellow. %~ = full path, %% for the Zsh prompt (instead of $ prompt for bash)
      # %n = username
else
   export PS1="\n  \w\[\033[33m\]\n$ "
   # See https://apple.stackexchange.com/questions/296477/my-command-line-says-complete13-command-not-found-compdef
   # To avoid command line error (in .zshrc): command not found: complete
   autoload bashcompinit
   bashcompinit
   autoload -Uz compinit
   compinit
fi


export GREP_OPTIONS="--color=auto"

# Add `killall` tab completion for common apps:
#COMMON_APPS="Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter"
#complete -o "nospace" -W "$COMMON_APPS" killall;


#### See https://wilsonmar.github.io/mac-setup/#zsh-aliases
if [ -d "$HOME/.oh-my-zsh" ]; then # is installed:
   export ZSH="$HOME/.oh-my-zsh"
   # See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
   # Set list of themes to pick from when loading at random
   # Setting this variable when ZSH_THEME=random will cause zsh to load
   # a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
   #   If set to an empty array, this variable will have no effect.
   ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

   # Set name of the theme to load --- if set to "random", it will
   # load a random theme each time oh-my-zsh is loaded, in which case,
   # to know which specific one was loaded, run: echo $RANDOM_THEME
   ZSH_THEME="robbyrussell"
   source $ZSH/oh-my-zsh.sh
fi


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
#[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
#complete -W "NSGlobalDomain" defaults;


#### See https://wilsonmar.github.io/ruby-on-apple-mac-osx/
# No command checking since Ruby was installed by default on Apple macOS:
if ! command -v rbenv >/dev/null; then
   if [ -d "$HOME/.rbenv" ]; then  # Ruby environment manager (shims    version  versions)
      export PATH="$HOME/.rbenv/bin:${PATH}"
      eval "$(rbenv init -)"   # at the end of the file
      echo "$( ruby --version) with .rbenv"
         # Default is ruby 2.6.1p33 (2019-01-30 revision 66950) [x86_64-darwin18]"
   fi

   if [ -d "$HOME/.rvm" ]; then  # Ruby version manager
      #export PATH="$PATH:$HOME/.rvm/gems/ruby-2.3.1/bin:${PATH}"
      #[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
      echo "$( ruby --version) with .rvm"  # example: ruby 2.6.1p33 (2019-01-30 revision 66950) [x86_64-darwin18]"
   fi
fi


# https://github.com/asdf-vm/asdf


#### See https://wilsonmar.github.io/task-runners
# On Intel Mac:
   export GRADLE_HOME="/usr/local/opt/gradle"
if [ -d "${GRADLE_HOME}/bin" ]; then  # folder is there
   export PATH="$GRADLE_HOME/bin:${PATH}"  # contains gradle file.
fi


#### See https://wilsonmar.github.io/hashicorp-vault
# Or vault-ent
if command -v vault >/dev/null; then  # found:
   export VAULT_VERSION="$( vault --version | awk '{print $2}' )"
      # v.13.2
fi

#### See https://wilsonmar.github.io/hashicorp-consul
# export PATH="$HOME/.func-e/versions/1.20.1/bin/:${PATH}"  # contains envoy
# Inserted by: consul -autocomplete-install
# complete -o nospace -C "${BREW_PATH}/consul" consul


#### See https://wilsonmar.github.io/maven  since which maven doesn't work:
if ! command -v maven >/dev/null; then
   if [ -d "$HOME/.m2" ]; then  # folder was created
      #/usr/local/opt/maven
      #/usr/local/Cellar/maven
      export M2_HOME=/usr/local/Cellar/maven/3.5.0/libexec
      export M2=$M2_HOME/bin
      export PATH=$PATH:$M2_HOME/bin
      export MAVEN_HOME=/usr/local/opt/maven
      export PATH=$MAVEN_HOME/bin:$PATH
   fi
fi

### See https://wilsonmar.github.io/jmeter-install/
if [ -d "/usr/libexec/java_home" ]; then
   # TODO: Determine version of Java installed
      export CPPFLAGS="-I/usr/local/opt/openjdk@11/include"
      export JAVA_HOME=$(/usr/libexec/java_home -v 11)
         # /usr/local/Cellar/openjdk@11/11.0.20.1/libexec/openjdk.jdk/Contents/Home
fi

if [ -d "$HOME/jmeter" ]; then
   export PATH="$HOME/jmeter:$PATH"
fi

#### See https://wilsonmar.github.io/scala
# export SCALA_HOME=/usr/local/opt/scala/libexec
# export JAVA_HOME generated by jenv, =/Library/Java/JavaVirtualMachines/jdk1.8.0_162.jdk/Contents/Home
#export JENV_ROOT="$(which jenv)" # /usr/local/var/jenv
#if command -v jyenv 1>/dev/null 2>&1; then
#  eval "$(jenv init -)"
#fi


#### See https://wilsonmar.github.io/aws-onboarding/
if [ -d "$HOME/aws" ]; then  # folder was created for AWS cloud, so:
   complete -C aws_completer aws
   # export AWS_DEFAULT_REGION="us-west-2" is defined in mac-setup.env
   export EC2_URL="https://${AWS_DEFAULT_REGION}.console.aws.amazon.com/ec2/v2/home?region=${AWS_DEFAULT_REGION}#Instances:sort=instanceId"
   alias ec2="open ${EC2_URL}"
fi


#### See https://wilsonmar.github.io/gcp
if command -v gcloud >/dev/null; then  # found:
   # gcloud version
   source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
   source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
fi
# After brew install -cask google-cloud-sdk
# See  https://cloud.google.com/sdk/docs/quickstarts
if [ -d "$HOME/.google-cloud-sdk" ]; then  # folder created:
   source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
   GOOGLE_BIN_PATH="$HOME/.google-cloud-sdk/bin"
   if [ -d "$GOOGLE_BIN_PATH" ]; then  # folder was created for GCP cloud, so:
      export PATH="$PATH:$GOOGLE_BIN_PATH"
   fi
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
   # If working with Android Studio on Intel Mac:
   export ANDROID_HOME=/usr/local/opt/android-sdk
if [ -d "$PYENV_ROOT" ]; then  # folder was created for Python3, so:
   export PATH=$PATH:$ANDROID_HOME/tools
   export PATH=$PATH:$ANDROID_HOME/platform-tools
   export PATH=$PATH:$ANDROID_HOME/build-tools/19.1.0
   export ANDROID_SDK_ROOT="/usr/local/share/android-sdk"
   export ANDROID_NDK_HOME=/usr/local/opt/android-ndk
fi


#### for Selenium
if [ -d "$BREW_PATH/chromedriver" ]; then
   export PATH="$PATH:/${BREW_PATH}/chromedriver"
fi

#### See https://wilsonmar/github.io/jmeter-install ::
#export PATH="/usr/local/Cellar/jmeter/3.3/libexec/bin:$PATH"
#export JMETER_HOME="/usr/local/Cellar/jmeter/5.4.1/libexec"
#export ANT_HOME=/usr/local/opt/ant
#export PATH=$ANT_HOME/bin:$PATH


#### See https://wilsonmar.github.io/salesforce-npsp-performance/
# export GATLING_HOME=/usr/local/opt/gatling


#### See https://wilsonmar.github.io/rustlang
if [ -d "$HOME/.cargo/bin" ]; then
   export PATH="$HOME/.cargo/bin:$PATH"
fi

### See https://gist.github.com/fraune/0831edc01fa89f46ce43b8bbc3761ac7
if grep -q 'auth sufficient pam_tid.so' /etc/pam.d/sudo; then
  echo "Touch ID is enabled for sudo."
else
  echo "Touch ID is not enabled for sudo. run-after-macos-update.sh"
fi


#### See https://wilsonmar.github.io/python-install/#pyenv-install
if [ -d "$HOME/.pyenv" ]; then  # folder was created for Python3, so:
   export PYENV_ROOT="$HOME/.pyenv"
   export PATH="$PYENV_ROOT/bin:$PATH"
   export PYTHON_CONFIGURE_OPTS="--enable-unicode=ucs2"
   # export PYTHONPATH="/usr/local/Cellar/python/3.6.5/bin/python3:$PYTHONPATH"
   # python="${BREW_PATH}/python3"
   # NO LONGER NEEDED: alias python=python3
   # export PATH="$PATH:$HOME/Library/Caches/AmlWorkbench/Python/bin"
   # export PATH="$PATH:/usr/local/anaconda3/bin"  # for conda
   if command -v pyenv 1>/dev/null 2>&1; then
     eval "$(pyenv init -)"
   fi
fi


# >>> Python conda initialize >>>
# See https://wilsonmar.github.io/python-install/#miniconda-install
# Per https://github.com/conda/conda/issues/7126 and in brew caveat:
# eval "$(conda "shell.$(basename "${SHELL}")" hook)"

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
   # List conda environments created:
   conda info --envs
   # conda activate py310
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


#### See https://wilsonmar.github.io/elixir-lang
if [ -d "$HOME/.asdf" ]; then
    source $HOME/.asdf/asdf.sh
fi


#### See https://wilsonmar.github.io/neo4j  # Graph DB
# export NEO4J_HOME=/usr/local/opt/neo4j
# export NEO4J_CONF=/usr/local/opt/neo4j/libexec/conf/

#export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"

# Liquibase is a SQL database testing utility:
#export LIQUIBASE_HOME='/usr/local/opt/liquibase/libexec'

#### See https://wilsonmar.github.io/airflow  # ETL
# PATH=$PATH:~/.local/bin
# export AIRFLOW_HOME="$HOME/airflow-tutorial"

# How to spoof MAC address and hostname at boot => https://www.youtube.com/watch?v=ASXANpr_zX8
# https://github.com/sunknudsen/privacy-guides/tree/master/how-to-spoof-mac-address-and-hostname-automatically-at-boot-on-macos
if [ -d "/usr/local/sbin/" ]; then
   sudo mkdir /usr/local/sbin/
fi
basedir="/usr/local/sbin"
if [ ! -f "/usr/local/sbin/first-names.txt" ]; then
   sudo curl --fail --output /usr/local/sbin/first-names.txt https://raw.githubusercontent.com/sunknudsen/privacy-guides/master/how-to-spoof-mac-address-and-hostname-automatically-at-boot-on-macos/first-names.txt
fi
# Spoof computer name
first_name=$(sed "$(jot -r 1 1 2048)q;d" $basedir/first-names.txt | sed -e 's/[^a-zA-Z]//g')
model_name=$(system_profiler SPHardwareDataType | awk '/Model Name/ {$1=$2=""; print $0}' | sed -e 's/^[ ]*//')
computer_name="$first_name’s $model_name"
host_name=$(echo $computer_name | sed -e 's/’//g' | sed -e 's/ /-/g')
sudo scutil --set ComputerName "$computer_name"
sudo scutil --set LocalHostName "$host_name"
sudo scutil --set HostName "$host_name"
print "Spoofed hostname = $host_name\n"
   # such as "Cristobals-MacBook-Pro"
# randmac="export RANDMAC=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//');echo ${RANDMAC}"
# Spoof MAC address of Wi-Fi interface - see https://www.youtube.com/watch?v=b-8hA5Qa_F8
mac_address_prefix=$(networksetup -listallhardwareports | awk -v RS= '/en0/{print $NF}' | head -c 8)
mac_address_suffix=$(openssl rand -hex 3 | sed 's/\(..\)/\1:/g; s/.$//')
mac_address=$(echo "$mac_address_prefix:$mac_address_suffix" | awk '{print tolower($0)}')
   # Such as 00:11:22:33:44:55

#networksetup -setairportpower en0 on
networksetup -setairportpower en0 off

if command -v /usr/local/bin/airport >/dev/null; then  # command found, so:
   sudo rm /usr/local/bin/airport
fi
# Create symlink to airport command so it can still be used even though it is deprecated:
sudo ln -s /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport /usr/local/bin/airport
   # WARNING: The airport command line tool is deprecated and will be removed in a future release.
   # For diagnosing Wi-Fi related issues, use the Wireless Diagnostics app or wdutil command line tool.
   # ifconfig: ioctl (SIOCAIFADDR): Can't assign requested address
   # WARNING of 3rd party: brew install macchanger  then macchanger -m xx:xx:xx:xx:xx:xx en0
   # Disconnect:
   # sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -z
sudo /usr/local/bin/airport --disassociate

# Turn off the Wi-Fi device:
networksetup -setairportpower en0 off
# Change the MAC address: ifconfig deprecated
sudo ifconfig en0 ether "$mac_address"
# Turn on the Wi-Fi device:
networksetup -setairportpower en0 on
print "Spoofed MAC address of en0 interface = $mac_address\n"



### See https://wilsonmar.github.io/mac-setup/#zsh-aliases
source ~/aliases.zsh   # export alias variables into memory
#catn ~/aliases.zsh    # Show aliases keys as reminder


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
if [ -d "$HOME/.sdkman" ]; then
   export SDKMAN_DIR="$HOME/.sdkman"
   #[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
fi


### See https://wilsonmar.github.io/mac-setup/
# Customized from https://github.com/wilsonmar/mac-setup/blob/master/.zshrc
if [ -f "$HOME/mac-setup.env" ]; then
    source $HOME/mac-setup.env
fi

# END