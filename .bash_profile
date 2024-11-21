#!/usr/bin/env bash
# git commit -m "v0.33 rm write to clipboard :.bash_profile"
# This is ~/.bash_profile from template https://github.com/wilsonmar/mac-setup/blob/main/.bash_profile
# This sets the environment for interactive shells.
# This file is opened automatically by macOS by default when Bash is used.

# This PATH should also be in ~/.zshenv
PATH=/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/sbin:/opt/local/bin:/opt/local/sbin:/usr/local/share/dotnet
   # Note colons separate items in $PATH.
   # /usr/bin/python:/usr/local/bin/python3:
   # /usr/local/bin before usr/bin so Homebrew stuff is found first
   # alias fix_brew='sudo chown -R $USER /usr/local/'export PATH="/usr/local/bin:$PATH"
   # For homebrew:
   # $(brew --prefix)/sbin

   # /opt/homebrew/ is added in front of /usr/local/bin by brew on Apple M1/2 machines.
   # /usr/local/bin contains pgms installed using brew, so should be first to override libraries
   # /usr/local/opt contains folders for brew-installed apps, such as /usr/local/opt/openssl@1.1
   # /usr/local/sbin contains java, javac, javadoc, javap, etc.
   # /bin contains macOS bash, zsh, chmod, cat, cp, date, echo, ls, rm, kill, link, mkdir, rmdir, conda, ...
   # /usr/bin contains macOS alias, awk, base64, nohup, make, man, perl, pbcopy, sudo, xattr, zip, etc.
   # /usr/sbin contains macOS chown, cron, disktutil, expect, fdisk, mkfile, softwareupdate, sysctl, etc.
   # /sbin contains macOS fsck, mount, etc.

# In .bashrc are parse_git_branch, PS1, git_completion, and extract for serverless, rvm, nvm
# source ~/.bashrc
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

echo "Apple macOS sw_vers = $(sw_vers -productVersion) / uname = $(uname -r)"
    # sw_vers: 10.15.1 / uname = 21.4.0
   # See https://eclecticlight.co/2020/08/13/macos-version-numbering-isnt-so-simple/
   # See https://scriptingosx.com/2020/09/macos-version-big-sur-update/

if [[ "$(uname -m)" = *"arm64"* ]]; then
   # used by .zshrc instead of .bash_profile
   # On Apple M1 Monterey: /opt/homebrew/bin is where Zsh looks (instead of /usr/local/bin):
   export BREW_PATH="/opt/homebrew"
   eval $( "${BREW_PATH}/bin/brew" shellenv)
   # Password will be requested here.
   export ARCHFLAGS="-arch arm64"
   export BREW_OPT="/opt/homebrew"

elif [[ "$(uname -m)" = *"x86_64"* ]]; then
   export BREW_PATH="/usr/local/bin"
   # used by .bashrc and .bash_profile
   export ARCHFLAGS="-arch x86_64"
   export BREW_OPT="/usr/local/opt"
   export PKG_CONFIG_PATH="$BREW_OPT/libffi/lib/pkgconfig"
fi

# For compilers to find sqlite and openssl per https://qiita.com/nahshi/items/fcf4898f7c45f11a5c63
#export CFLAGS="-I$(brew --prefix readline)/include -I$(brew --prefix openssl)/include -I$(xcrun --show-sdk-path)/usr/include"
export LDFLAGS="-L$(brew --prefix readline)/lib -L$(brew --prefix openssl)/lib"


### See https://wilsonmar.github.io/mac-setup/
# Customized from https://github.com/wilsonmar/mac-setup/blob/master/.zshrc
if [ -f "$HOME/mac-setup.env" ]; then
    source $HOME/mac-setup.env
fi


if ! command -v complete >/dev/null; then
   echo "brew complete NOT installed for BREW_PATH=$BREW_PATH to $HOMEBREW_CASK_OPTS"
else
   echo "brew complete for BREW_PATH=$BREW_PATH to $HOMEBREW_CASK_OPTS"
   complete "${BREW_PATH}/share/zsh/site-functions"  # auto-completions in .bashrc
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
echo "SHELL=$SHELL at $(which bash)..."  # $SHELL=/bin/zsh
      # or SHELL=/opt/homebrew/bin/bash at /opt/homebrew/bin//bash
      # Use /opt/homebrew/bin/zsh  (using homebrew or default one from Apple?)
      # Use /usr/local/bin/zsh if running Bash.
# Set Terminal prompt that shows the Zsh % prompt rather than $ bash prompt:
if [[ "/bin/zsh" = *"${SHELL}"* ]]; then
   echo "promptinit for zsh..."
   autoload -Uz promptinit && promptinit
   export PS1="${prompt_newline}${prompt_newline}  %11F%~${prompt_newline}%% "
      # %11F = yellow. %~ = full path, %% for the Zsh prompt (instead of $ prompt for bash)
      # %n = username
   # See https://apple.stackexchange.com/questions/296477/my-command-line-says-complete13-command-not-found-compdef
   # To avoid command line error (in .zshrc): command not found: complete
   autoload bashcompinit
   bashcompinit
   autoload -Uz compinit
   compinit
else # /opt/homebrew/bin/bash
   export PS1="\n  \w\[\033[33m\]\n$ "
fi

# Add `killall` tab completion for common apps:
#COMMON_APPS="Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter"
#complete -o "nospace" -W "$COMMON_APPS" killall;

sudo launchctl limit maxfiles 65536 200000
   # Password will be requested here due to sudo.

export GPG_TTY=$(tty)
export CLICOLOR=1
export LSCOLORS="GxFxCxDxBxegedabagaced" #

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
#export PATH="$BREW_OPT/postgresql@9.6/bin:$PATH"

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

# Added by ./mac-setup-all.sh for use on .zsh:
#if [ -f $HOME/.git-completion.bash ]; then
#      . $HOME/.git-completion.bash
#fi


### See https://gist.github.com/fraune/0831edc01fa89f46ce43b8bbc3761ac7
#if grep -q 'auth sufficient pam_tid.so' /etc/pam.d/sudo; then
#  echo "Touch ID is enabled for sudo."
#else
#  echo "Touch ID is not enabled for sudo. run-after-macos-update.sh"
#fi


# Per https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line
if [ -f "$HOME/Applications/Visual Studio Code.app" ]; then  # installed:
   export PATH="$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin:${PATH}"
      # contains folder code and code-tunnel
fi

# https://gist.github.com/sindresorhus/98add7be608fad6b5376a895e5a59972
# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

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

#export PATH="$PATH:$HOME/.rvm/gems/ruby-2.3.1/bin"
#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export LC_ALL=en_US.utf-8
#export PATH="$HOME/.rbenv/bin:$PATH"
#eval "$(rbenv init -)"   # at the end of the file


#### See https://wilsonmar.github.io/node-install after brew install nodejs
if [ -d "$HOME/.nvm" ]; then  # Ruby version manager
   export NVM_DIR="$HOME/.nvm"
   source "$HOME/.nvm/nvm.sh"  # instead of "$BREW_OPT/nvm/nvm.sh"
   #export PATH=$PATH:$HOME/.nvm/versions/node/v9.11.1/lib/node_modules
fi


# spoof MAC address and hostname at boot => https://www.youtube.com/watch?v=ASXANpr_zX8
# https://github.com/sunknudsen/privacy-guides/tree/master/how-to-spoof-mac-address-and-hostname-automatically-at-boot-on-macos
if [ ! -d "/usr/local/sbin/" ]; then
   sudo mkdir /usr/local/sbin/
fi
basedir="/usr/local/sbin"
if [ ! -f "$basedir/first-names.txt" ]; then
   sudo curl --fail --output "$basedir/first-names.txt" \
      https://raw.githubusercontent.com/sunknudsen/privacy-guides/master/how-to-spoof-mac-address-and-hostname-automatically-at-boot-on-macos/first-names.txt
fi
# Spoof computer name
#first_name=$(sed "$(jot -r 1 1 2048)q;d" "$basedir/first-names.txt" | sed -e 's/[^a-zA-Z]//g')
#model_name=$(system_profiler SPHardwareDataType | awk '/Model Name/ {$1=$2=""; print $0}' | sed -e 's/^[ ]*//')
#computer_name="$first_name’s $model_name"
#host_name=$(echo $computer_name | sed -e 's/’//g' | sed -e 's/ /-/g')
#sudo scutil --set ComputerName "$computer_name"
#sudo scutil --set LocalHostName "$host_name"
#sudo scutil --set HostName "$host_name"
#echo "Spoofed hostname = $host_name\n"
   # such as "Cristobals-MacBook-Pro"
# randmac="export RANDMAC=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//');echo ${RANDMAC}"
# Spoof MAC address of Wi-Fi interface - see https://www.youtube.com/watch?v=b-8hA5Qa_F8
mac_address_prefix=$(networksetup -listallhardwareports | awk -v RS= '/en0/{print $NF}' | head -c 8)
mac_address_suffix=$(openssl rand -hex 3 | sed 's/\(..\)/\1:/g; s/.$//')
mac_address=$(echo "$mac_address_prefix:$mac_address_suffix" | awk '{print tolower($0)}')
   # Such as 00:11:22:33:44:55

#networksetup -setairportpower en0 on
networksetup -setairportpower en0 off

#if command -v /usr/local/bin/airport >/dev/null; then  # command found, so:
#   sudo rm /usr/local/bin/airport
#fi
# Create symlink to airport command so it can still be used even though it is deprecated:
#sudo ln -s /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport /usr/local/bin/airport
   # WARNING: The airport command line tool is deprecated and will be removed in a future release.
   # For diagnosing Wi-Fi related issues, use the Wireless Diagnostics app or wdutil command line tool.
   # ifconfig: ioctl (SIOCAIFADDR): Can't assign requested address
   # WARNING of 3rd party: brew install macchanger  then macchanger -m xx:xx:xx:xx:xx:xx en0
   # Disconnect:
   # sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -z
#sudo /usr/local/bin/airport --disassociate

# Turn off the Wi-Fi device:
networksetup -setairportpower en0 off
# Change the MAC address: ifconfig deprecated
#sudo ifconfig en0 ether "$mac_address"
   # FIXME: ifconfig: ioctl (SIOCAIFADDR): Can't assign requested address
# Turn on the Wi-Fi device:
networksetup -setairportpower en0 on
echo "Spoofed MAC address of en0 interface = $mac_address\n"



#### See https://wilsonmar.github.io/maven  since which maven doesn't work:
#export M2_HOME=/usr/local/Cellar/maven/3.5.0/libexec
#export M2=$M2_HOME/bin
#export PATH=$PATH:$M2_HOME/bin
#export MAVEN_HOME=/usr/local/opt/maven
#export PATH=$MAVEN_HOME/bin:$PATH

### See https://wilsonmar.github.io/sonar
export PATH="$PATH:$HOME/onpath/sonar-scanner/bin"


#### See https://wilsonmar.github.io/azure after brew install dotnet
# source '/Users/mac/lib/azure-cli/az.completion'
if [ -d "$HOME/.dotnet/tools" ]; then # is installed:
   export PATH="$HOME/.dotnet/tools/:${PATH}"
   echo "dotnet --version = $(dotnet --version)"
      # SDK Version: 8.0.104  # in 3rd line
   # TODO: To trust the certificate, run 'dotnet dev-certs https --trust'
fi
# TODO: for zsh only:
  #if [ -d "$HOME/azure" ]; then  # folder was created for Microsoft Azure cloud, so:
  #   source "$HOME/lib/azure-cli/az.completion"
  #fi
  # https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/
  #if command -v kubectl >/dev/null; then  # found:
  #   source <(kubectl completion zsh)
  #fi


#### See https://wilsonmar.github.io/aws-onboarding/
complete -C aws_completer aws
export AWS_DEFAULT_REGION="us-west-2"
export EC2_URL="https://${AWS_DEFAULT_REGION}.console.aws.amazon.com/ec2/v2/home?region=${AWS_DEFAULT_REGION}#Instances:sort=instanceId"
alias ec2="open ${EC2_URL}"


#### See https://wilsonmar.github.io/gcp
# See https://cloud.google.com/sdk/docs/quickstarts
# After brew install -cask google-cloud-sdk
if command -v gcloud >/dev/null; then  # found:
   # gcloud version
   GOOGLE_BIN_PATH=".google-cloud-sdk/bin"
   if [ -d "$HOME/GOOGLE_BIN_PATH" ]; then  # folder was created:
      export PATH="$PATH:$HOME/$GOOGLE_BIN_PATH"
   fi
   # If zsh:
      # source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
      # source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
      # source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
fi


#### See https://wilsonmar.github.io/aws-onboarding/
if [ -d "$HOME/aws" ]; then  # folder was created for AWS cloud, so:
   complete -C aws_completer aws
   # export AWS_DEFAULT_REGION="us-west-2" is defined in mac-setup.env
   export EC2_URL="https://${AWS_DEFAULT_REGION}.console.aws.amazon.com/ec2/v2/home?region=${AWS_DEFAULT_REGION}#Instances:sort=instanceId"
   alias ec2="open ${EC2_URL}"
fi


### See https://wilsonmar.github.io/sonar
#export PATH="$PATH:$HOME/onpath/sonar-scanner/bin"


#### for Selenium
if [ -d "$BREW_PATH/chromedriver" ]; then
   export PATH="$PATH:/${BREW_PATH}/chromedriver"
fi


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
if [ -d "/usr/libexec/java_home" ]; then
   # TODO: Determine version of Java installed
      export CPPFLAGS="-I/usr/local/opt/openjdk@11/include"
      export JAVA_HOME=$(/usr/libexec/java_home -v 11)
         # /usr/local/Cellar/openjdk@11/11.0.20.1/libexec/openjdk.jdk/Contents/Home
   if [ -d "$HOME/jmeter" ]; then
      export PATH="$HOME/jmeter:$PATH"
   fi
fi


#### See https://wilsonmar.github.io/salesforce-npsp-performance/
# export GATLING_HOME=/usr/local/opt/gatling

#### See https://wilsonmar.github.io/neo4j
# export NEO4J_HOME=/usr/local/opt/neo4j
# export NEO4J_CONF=/usr/local/opt/neo4j/libexec/conf/

#export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"

#### See https://wilsonmar.github.io/airflow  # ETL
# PATH=$PATH:~/.local/bin
# export AIRFLOW_HOME="$HOME/airflow-tutorial"

#### See https://wilsonmar.github.io/scala
# export SCALA_HOME=/usr/local/opt/scala/libexec
# export JAVA_HOME generated by jenv, =/Library/Java/JavaVirtualMachines/jdk1.8.0_162.jdk/Contents/Home
#export JENV_ROOT="$(which jenv)" # /usr/local/var/jenv
#if command -v jyenv 1>/dev/null 2>&1; then
#  eval "$(jenv init -)"
#fi
#export PATH="$HOME/jmeter:$PATH"
#### See https://wilsonmar.github.io/task-runners
if ! command -v gradle >/dev/null; then
   echo "gradle not installed (for use with Java)..."
else
   # Since which gradle outputs "/opt/homebrew/bin//gradle" or
      # "/usr/local/opt/gradle" on Intel Mac:
   GRADLE_HOME=$( which gradle )
   if [ -d "${GRADLE_HOME}/bin" ]; then  # folder is there
      export PATH="$GRADLE_HOME/bin:${PATH}"  # contains gradle file.
   fi
fi

#### R language:
# export PATH="$PATH:/usr/local/Cellar/r/3.4.4/lib/R/bin"
# alias rv34='/usr/local/Cellar/r/3.4.4/lib/R/bin/R'

### See https://wilsonmar.github.io/ruby-on-apple-mac-osx/
if command -v rbenv 1>/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

#### See https://wilsonmar.github.io/rustlang
if [ -d "$HOME/.cargo/bin" ]; then
   export PATH="$HOME/.cargo/bin:$PATH"
fi

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

CONDA_FOLDER="/opt/homebrew/Caskroom/miniconda/base"
if [ -d "$CONDA_FOLDER/bin/pip3" ]; then  # folder was created:
   # >>> conda initialize >>>
   # !! Contents within this block are managed by 'conda init' !!
   __conda_setup="$('$CONDA_FOLDER/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
   if [ $? -eq 0 ]; then
      eval "$__conda_setup"
   else
      if [ -f "$CONDA_FOLDER/etc/profile.d/conda.sh" ]; then
         . "$CONDA_FOLDER/etc/profile.d/conda.sh"
      else
         export PATH="$CONDA_FOLDER/bin:$PATH"
      fi
   fi
   unset __conda_setup
   # <<< conda initialize <<<
   # conda activate py3k
fi

#### See https://wilsonmar.github.io/golang
# This is a custom path:
if command -v go >/dev/null; then
   export GOHOME='$HOME/golang1'
   export GOPATH='$HOME/go'
   export PATH="$PATH:/usr/local/opt/go/libexec/bin"
   #export GOROOT='/usr/local/opt/go/libexec/bin' ???
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


#### See https://wilsonmar.github.io/hashicorp-vault
# export VAULT_ADDR=https://vault.enbala-engine.com:8200
# TODO: Or vault-ent
if command -v vault >/dev/null; then  # found:
   export VAULT_VERSION="$( vault --version | awk '{print $2}' )"
      # v.13.2
   # For zsh:
   complete -C "$BREW_PATH/vault vault"
fi

#### See https://wilsonmar.github.io/hashicorp-consul
# export PATH="$HOME/.func-e/versions/1.20.1/bin/:${PATH}"  # contains envoy
# Inserted by: consul -autocomplete-install
# complete -o nospace -C "${BREW_PATH}/consul" consul


#export LIQUIBASE_HOME='/usr/local/opt/liquibase/libexec'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


# Position to most frequently used:
#cd ~/github-wilsonmar/wilsonmar.github.io/_posts
# gsl  # alias for "git status list"
#export PATH="$PATH:$HOME/github-wilsonmar/tf-samples"
#export PATH="$PATH:$HOME/github-wilsonmar/python-samples"


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
if [ -d "$HOME/.sdkman" ]; then
   export SDKMAN_DIR="$HOME/.sdkman"
   #[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

#### See https://wilsonmar.github.io/macos-install
# Show aliases keys as reminder:
source ~/aliases.sh
#     catn filename to show text file without comment (#) lines:
#alias catn="grep -Ev '''^(#|$)'''"
#catn ~/aliases.sh
# For more Mac aliases, see https://gist.github.com/natelandau/10654137
   # described at https://natelandau.com/my-mac-osx-bash_profile/
# https://github.com/clvv/fasd


# END