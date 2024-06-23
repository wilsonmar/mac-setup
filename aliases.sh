#!/usr/bin/env bash
# This is ~/aliases.sh from template https://github.com/wilsonmar/mac-setup/blob/main/aliases.sh
# gas "v34 rand5 dice : aliases.sh"
# Called after mac-setup.sh from ~/.bash_profile for Bash or ~/.zshrc for zsh
# on both MacOS and git bash on Windows.

# One reason I can jump easily between Debian, Ubuntu, mac because I
# have customized keyboard aliases so I use the same command across machines.
export OS_TYPE="$( uname )"
echo "aliases.sh running on OS_TYPE=$OS_TYPE ..."

alias c="clear"  # screen
alias cd=' cd'
alias ..=' cd ..; ls'
alias ...=' cd ..; cd ..; ls'
alias ....=' cd ..; cd ..; cd ..; ls'
alias cd..='..'
alias cd...='...'
alias cd....='....'

alias now='date +"%A %Y-%m-%d %T %p %s"'
   # Wednesday 2024-06-05 08:39:37 AM 1717598377

# Recap: One-key keyboard shortcuts (used most often):
#alias d='docker'
alias h='history'
alias j='jobs -l'
alias l='ls -FalhGT | more'   # T for year
alias p="pwd"        # present working directory
alias x='exit'

# User name keys:
alias grep='grep --color=auto'
USERNAME_ID=$( id -un )  # whoami has been deprecated
export GITHUBDIR="github-$USERNAME_ID"
# for  cd $HOME/$GITHUBDIR

# See https://wilsonmar.github.io/mac-utilities/#top-processes
alias ht="htop -t"        # processes in an indented tree - control+C to stop.
alias k9='kill -9'
alias ka="killall"
alias kp="ps auxwww | more"  # "que pasa" processes running

alias rs='exec -l $SHELL'    # reset shell
alias sleepnow="pmset sleepnow"

# Listings:
alias lt="ls -1R | more"   # list tree
alias ltt="ls -ltaT | more"   # list by date
alias cf="find . -print | wc -l"  # count files in folder.
alias lsx="exa --group-directories-first --group --color=always --classify --binary"
alias tree="exa --tree --group-directories-first --ignore-glob 'node_modules|bower_components|.git'"
alias lf="ls -p | more"      # list folders only
alias dir='ls -alrT'         # for windows habits
alias l='ls -FalhGT | more'         # T for year
alias ll='ls -FalhGT | more'  # T for year

#### AUTOMATION:
if [ "${OS_TYPE}" = "Darwin" ]; then  # it's on a Mac:
   alias automator='open -a "/System/Applications/Automator.app"'   
      # https://support.apple.com/guide/automator/welcome/mac
      # https://macosxautomation.com/automator/
      # https://www.youtube.com/watch?v=BTmZOh1GI3U&list=RDCMUC5ZoLwtjX_7Zs8LoqpiLztQ&start_radio=1&rv=BTmZOh1GI3U&t=6
   #alias alfred='open -a "$HOME/Applications/Alfred 3.app"'
   #alias geekbench='open -a "$HOME/Applications/Geekbench 4.app"'   # performance benchmarking
   if [ -d "$HOME/Applications/VMware Fusion.app" ]; then
      alias vfusion='open -a "$HOME/Applications/VMware Fusion.app"'
   fi
fi

#### System utilities:
# Dump of system information:
# On Linux: 
# On macOS: system_profiler

#### SECRETS:  see https://wilsonmar.github.io/1password/
# alias 1pass='open -a "/Applications/1Password 7.app"'       # No longer used
alias keybase='open -a "$HOME/Applications/Keybase.app"'    # Secrets

# Secrets should not display, so pbcopy enables pasting command+V from Clipboard:
#if [ "${OS_TYPE}" = "Darwin" ]; then  # it's on a Mac:
   alias randpass="echo $(openssl rand -base64 25) | pbcopy"
   # alias randpw="echo $(pwgen pwgen -ns 25 1) | pbcopy"  # removed because it requires external package
   # From https://sunknudsen.com/stories/exploring-the-password-policy-rabbit-hole
   alias rand9="cat /dev/random | LC_ALL=C tr -cd 'a-zA-Z0-9_-;:!?.@\\*/#%$' | head -c 9 | pbcopy"
   # Generate AES fixed-length 256-bit hexidecimal key for wrapping:
   alias rand32="openssl rand -hex 32 | pbcopy"
   # Roll 5 dice: random 5-digit base-6 number: FIXME: only works first time.
   alias rand5=$( base-6_digit(){ echo $(( RANDOM % 6 )); }; random_number=""; for i in {1..5};do random_number+=$(base-6_digit); done; echo "$random_number" | pbcopy )
#fi

##### Terminal 
# terminal.app
# hyper is in /usr/local/bin 
# alias iterm='open -a "/Applications/iTerm.app"'
# alias iterm2='open -a "$HOME/Applications/iTerm2.app"'

#### MEMORY:
alias ramfree="top -l 1 -s 0 | grep PhysMem"  # PhysMem: 30G used (3693M wired), 1993M unused.
# /proc & /sys folders exist in RAM Used by the kernel to store information on running processes

#### DISKSPACE:
alias spacefree="du -h | awk 'END{print $1}'"
if [ "${OS_TYPE}" = "Linux" ]; then  # it's NOT on a Mac:
   alias lll="sudo du -aBM / 2>/dev/null | sort -nr | head -n 10"  # 10 largest files
elif [ "${OS_TYPE}" = "Darwin" ]; then  # it's on a Mac:
   # Last 50 files updated anywhere:
   alias f50='stat -f "%m%t%Sm %N" /tmp/* | sort -rn | head -50 | cut -f2- 2>/dev/null'
fi

#### NETWORKING:
#alias myip="ifconfig en0 | grep inet | grep -v inet6 | cut -d ' ' -f2" 
# ip route get 1 | awk '{print $NF;exit}'
if [ "${OS_TYPE}" = "Darwin" ]; then  # it's on a Mac:
   alias netq="networkquality"  # comes with MacOS
      # Downlink: 139.896 Mbps, 358 RPM - Uplink: 10.534 Mbps, 358 RPM^C
fi
# wireless en0, wired en1: PRIVATE_IP address: 172.20.1.91 or 192.168.1.253
alias privip="ipconfig getifaddr en0"

# Public ip like https://www.whatismyip.com/:
# alias mac="curl http://canhazip.com"  # public IP 
# alias pubip="curl https://checkip.amazonaws.com"  # public IP
alias pubip="curl -s ifconfig.me"  # public IP
# alias ipa="ip a"  # analyze networking
alias ipinfo="curl ipinfo.io"  # more verbose JSON containing country and zip of IP
alias ipcity="curl -s ipinfo.io | jq -r .city"
alias wanip4="dig @resolver1.opendns.com ANY myip.opendns.com +short"
# alias wanip6="dig @resolver1.opendns.com AAAA myip.opendns.com +short -6"
# https://blog.apnic.net/2021/06/17/how-a-small-free-ip-tool-survived/
# alias wanip6="curl -s https://ipv6.icanhazip.com"
# https://ipv4.icanhazip.com/
alias ports="lsof -i -n -P | grep TCP"
alias listening="lsof -nP +c 15 | grep LISTEN"
   # rapportd          596 johndoe    9u     IPv6  0x93d60554f660a3a        0t0                 TCP *:50866 (LISTEN)

# See https://www.perplexity.ai/search/how-to-assign-P8L9reHhTWWlLUZ9Cj1pHg
alias randmac="export RANDMAC=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//');echo ${RANDMAC}"
# sudo ifconfig en0 ether "{RANDMAC}"


#### GUI APPS: 
if [ "${OS_TYPE}" = "Darwin" ]; then
   alias calc='open -a "/System/Applications/Calculator.app"'

   #### built-in macOS system GUI apps invoke from command line:
   alias airport='open -a "/System/Applications/Utilities/Airport Utility.app"'
   alias amon='open -a "/System//Applications/Utilities/Activity Monitor.app"'  # See CPU usage by app
   alias sysinfo='open -a "/System/Applications/Utilities/System Information.app"'
   alias syspref='open -a "/System//Applications/System Preferences.app"'

   ### built-in Apple apps:
   alias appstore='open -a "/System/Applications/App Store.app"'
   # cal = calendar 
fi

##### TEXT EDITOR:  see https://wilsonmar.github.io/text-editor
if [ -d "/Applications/Visual Studio Code.app" ]; then
   alias code='open -a "/Applications/Visual Studio Code.app"'
   alias vscode='open -a "/Applications/Visual Studio Code.app"'
   export EDITOR="code"  # code = Visual Studio Code; subl = Sublime Text
fi
   # export EDITOR="/usr/local/bin/mate -w" 
alias edit="$EDITOR"   # make a habit of using this instead program name (such as code), so you can switch default editor easier 
alias ebp="$EDITOR ~/.bash_profile && source ~/.bash_profile"
alias sbp='source ~/.bash_profile'
alias ezs="$EDITOR ~/.zshrc"   # for Zsh
alias szs='source ~/.zshrc'
alias sshconf="$EDITOR ~/.ssh/config"
#alias ohmyzsh="$EDITOR ~/.oh-my-zsh"

# alias atom was removed from market by GitHub.
# alias brackets='open -a "/Applications/Brackets.app"'
# alias eclipse='open "/Applications/Eclipse.app"'
# alias electron='open -a "$HOME/Applications/Electron.app"'
# alias idea='open -a "/Applications/IntelliJ IDEA CE.app"'
# alias macvim='open -a "/Applications/MacVim.app"'
# alias nvim='open "$HOME/Applications/Neovim.app"'
#alias pycharm='open -a "$HOME/Applications/Pycharm.app"'
# alias sts='open -a "/Applications/STS.app"'
# See https://wilsonmar.github.io/dotfiles/#SublimeText.app
alias subl='open -a "/Applications/Sublime Text.app"'
# alias textedit='open -a "/Applications/TextEdit.app"'
# alias sourcetree='open -a "$HOME/Applications/Sourcetree.app"'
# alias vi="nvim"
# alias vim="nvim"
# alias vs='$HOME/Applications/Visual\ Studio.app/Contents/MacOS/VisualStudio &'   # from Microsoft
# https://www.jetbrains.com/webstorm/
# alias webstorm='open -a "/Applications/Webstorm.app"'
if [ -d "/Applications/Visual Studio Code.app" ]; then
   alias xcode='open -a /Applications/Visual Studio Code.app'
fi

##### CLOUD:
alias awscreds="$EDITOR ~/.aws/credentials"
# From https://stackoverflow.com/questions/31331788/using-aws-cli-what-is-best-way-to-determine-the-current-region
alias awsregion="aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].[RegionName]'"

# Enhanced diff: Not in brew
# alias p4merge='/Applications/p4merge.app/Contents/MacOS/p4merge'

#### MICROSOFT / AZURE CLOUD DATA:
alias teams='open -a "/Applications/Microsoft Teams.app"'
if [ -d "/Applications/OneDrive.app" ]; then
   alias 1drive='open -a "/Applications/OneDrive.app"'
fi
# box
# Google Drive
# Apple iCloud

#### Meetings (Communications):
#alias chime='open -a "/Applications/Amazon Chime.app"'
#alias collo='open -a "/Applications/Colloquy.app"'         # Installed from Apple store 
alias discord='open -a "/Applications/Discord.app"'       # Has security issue. Don't use.

alias facetime='open -a "/System/Applications/FaceTime.app"'       # built-in from Apple
#alias gotomeeting='open -a "/Applications/GoToMeeting.app"'
alias messages='open -a "/System/Applications/Messages.app"'       # built-in from Apple
# alias skype='open -a "/Applications/Skype.app"'
alias signal='open -a "/Applications/Signal.app"'
alias slack='open -a "/Applications/Slack.app"'
alias teams='open -a "$HOME/Applications/Microsoft Teams.app"'
#alias telegram='open -a "$HOME/Applications/Telegram.app"'
alias whatsapp='open -a "/Applications/Whatsapp.app"'
alias zoom='open -a "/Applications/zoom.us.app"'


##### Reading/Learning:
#alias anki='open -a "$HOME/Applications/Anki.app"'      # Flash cards https://apps.ankiweb.net/
alias kindle='open -a "/Applications/Kindle.app"'
alias reader='open -a "/Applications/Adobe Acrobat Reader DC.app"'
# https://wilsonmar.github.io/dotfiles/#Transmission.app  # Torrent

alias excel='open -a "/Applications/Microsoft Excel.app"'
alias ppt='open -a "/Applications/Microsoft PowerPoint.app"'
alias word='open -a "/Applications/Microsoft Word.app"'

##### Content creation (Audio/Video):
alias obs='open -a "/Applications/OBS.app"'
# alias sketch='open -a "/Applications/Sketch.app"'
# alias audacity='open -a "/Applications/Audacity.app"'      # Audio engineering
# alias unity='open -a "$HOME/Applications/Unity.app"'


##### Software development:
# https://expo.dev/tools
alias ghd='open -a "$HOME/Applications/GitHub Desktop.app"'
alias postman='open -a "/Applications/Postman.app"'

#alias postman='open -a "$HOME/Applications/Postman.app"'
#alias postman='open -a "$HOME/Applications/Chrome Apps/Postman.app"'
# alias insomnia='open -a "/Applications/Insomnia.app"'

# alias rstudio='open -a "/Applications/RStudio.app"'
# alias jprofiler='open -a "/Applications/JProfiler.app"'
# alias soapui='open -a "/Applications/SoapUI-5.4.0.app"'


#### GIT & GITHUB: see https://wilsonmar.github.io/git-shortcuts/
# https://coderwall.com/p/_-ypzq/git-bash-fixing-it-with-alias-and-functions
# Only on MacOS, not git bash on Windows MINGW64:
alias hb="hub browse"

if [[ "$(uname)" == *"Darwin"* ]]; then  # it's on a Mac:
   # echo "Adding functions for Mac ..."
   # TODO: https://www.phillip-kruger.com/post/some_bash_functions_for_git/
   alias vers="system_profiler SPHardwareDataType"
      # alias vers="sw_vers"
         # For just ProductName: macOS, ProductVersion: 14.5, BuildVersion: 23F79
   function gas() { git status ;  git add . -A ; git commit -m "$1" ; git push; }
   function gsa() { git stash save "$1" -a; git stash list; }  # -a = all (untracked, ignored)
   function gsp() { git stash pop; }
   function gd() { # get dirty
     [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]] && echo "*"
   }
fi
alias gc='git commit -S -m --quiet' # requires you to type a Signed commit message
alias ga='git add . -A'  # --patch
alias gb='git branch -avv'
# TODO: Add date/time to update text:
alias gbs='git status -s -b;git add . -A;git commit --quiet -m"Update";git push'
alias gdc="git diff --cached"
alias gds="git diff --staged"
alias get='git fetch;' # git pull + merge
alias gf='git fetch origin master;git diff master..origin/master'
alias gfu='git fetch upstream;git diff HEAD @{u} --name-only'
alias gcm='git checkout master'
alias githead="git rev-parse --short HEAD"  # current SHA commit ID
alias gl='git log --pretty=format:"%h %s %ad" --graph --since=1.days --date=relative;git log --show-signature -n 1'
alias gl1="git log --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gl2="git log --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
# List all files that ever existed, including deleted files: https://tech.serhatteker.com/post/2022-01/git-list-tracked-files/
alias gld="git log --pretty=format: --name-only --diff-filter=A | sort - | sed '/^$/d'"
alias gmo='git merge origin/master'
alias gmf='git merge --no-ff'
alias gpr='git pull --rebase'
alias gp='git push'
alias gpom='git push -u origin master'
alias grm='git rm $(git ls-files --deleted)'
alias gri='git rebase -i'
alias grl='git reflog -n 7'
alias grh='git reset --hard'
alias grl='git reflog -n 7'
alias grv='git remote -vv'
alias gsl='git config user.email;git status -s -b; git stash list'
alias gss='git stash show'
alias gtf='git ls-tree --full-tree --name-only -r HEAD'
alias grx="rm .git/merge"  # Remove merge
# https://www.youtube.com/watch?v=YwG8C0jPapE making your own custom git commands (intermediate) by @anthonywritescode (Anthony Sottile)


#### PRIVACY:  see https://wilsonmar.github.io/git-signing/
alias gsk="gpg --list-secret-keys --keyid-format LONG"
alias gst="gpg show-ref --tags"
alias sign='gpg --detach-sign --armor'


#### PYTHON:  see https://wilsonmar.github.io/python/
alias python="python3"
alias pip="pip3"
# https://virtualenvwrapper.readthedocs.io/en/latest/
alias cr="cargo run --verbose"  # Rust .rs program file in folder
# conda
alias envs="conda env list"
alias venl="conda env list -v -v -v | grep -v '^#' | perl -lane 'print $F[-1]' | xargs /bin/ls -lrtd"
alias ven="virtualenv venv"
alias vba="source venv/bin/activate"
alias vbd="source deactivate"


#### TERRAFORM:  see https://wilsonmar.github.io/terraform#KeyboardAliases
# Make using these tf aliases a habit for less typing and
# to enable switch to tofu (opentofu.org) with less mistakes.
#lias tf="tofu $1"  # provide any parameter
alias tf="terraform $1"  # provide any parameter
alias tffd="terraform fmt -diff"
alias tfv="terraform validate"
alias tfi="terraform init"
alias tfp="terraform plan"
alias tfsd="tfsec | sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g'"
alias tfa="time terraform apply -auto-approve"
alias tfs="terraform show"
alias tfr="terraform refresh"
alias tfsl="terraform state list"
alias tfsp="terraform state pull"
alias tfd="time terraform destroy -auto-approve"

#### CONSUL (HASHICORP): see https://wilsonmar.github.io/hashicorp-consul#Shortcuts
alias csl="curl http://127.0.0.1:8500/v1/status/leader"
alias cacc="consul agent -config-dir /etc/consul.d/config"
alias ccn="consul catalog nodes"
alias ccs="consul catalog services"
alias cml="consul members -wan"
alias cmld="consul members -detailed"
alias cnl="consul namespace list"
alias crl="consul operator raft list-peers"
alias crj="cat /var/consul/raft/peers.json"

# See https://wilsonmar.github.io/hashicorp-boundary#Shortcuts
alias bdy="boundary"
# sentinel   # from Hashicorp
# alias falcon='open -a "/Applications/Falcon.app"'  # controlled by HC Infosec

#### DOCKER:  see https://wilsonmar.github.io/docker
# Because docker is both a cask and CLI formula:
# Do not define  alias docker='open -a "$HOME/Applications/Docker.app"'
alias ddk="killall com.docker.osx.hyperkit.linux"   # docker restart
alias dps="docker ps"                               # docker processes list
# CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
alias dports='docker ps --format "table {{.Names}}\t{{.Ports}}"'
alias dcmds='docker ps --format "table {{.Names}}\t{{.Commands}}"'

alias dcl="docker container ls -aq"                 # docker list active container
alias dcp="docker container prune --force"          # Remove all stopped containers
# Total reclaimed space: 0B
# To avoid "Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
if [ -f "/var/run/docker.pid" ]; then  # NOT found:
   alias dsa="docker stop $(docker container ls -aq )" # docker stop active container
   alias dpx="docker rm -v $(docker ps -aq -f status=exited)"  # Remove stopped containers
fi
alias dcu="docker compose up"
alias dcp="docker compose ps"
alias dcd="docker compose down -v"
# docker inspect $CONTAINER_NAME

# TODO: If Linux for: cat myfile.txt | pbcopy
# First: sudo apt-get install xclip -y
# alias pbcopy=’xsel — clipboard — input’
# For pbpaste to invoke lines in Clipboard as CLI commands:
# For pbpaste to write into a file: pbpaste > pastetest.txt
# alias pbpaste=’xsel — clipboard — output’
# Also see pacman and dnf https://ostechnix.com/how-to-use-pbcopy-and-pbpaste-commands-on-linux/
# Alternately: https://superuser.com/questions/288320/whats-like-osxs-pbcopy-for-linux
# alias pbcopy='xclip -selection clipboard'
# alias pbpaste='xclip -selection clipboard -o'

#### See https://wilsonmar.github.io/kubernetes
alias kubec="$EDITOR ~/.kube/conf"
# FIXME: complete -F __start_kubectl k
alias mk8s="minikube delete;minikube start --driver=docker --memory=4096"
# See https://wilsonmar.github.io/kubernetes-operators/#KeyboardAlias
alias o="operator-sdk"
# From https://github.com/sidd-harth/kubernetes
alias k="kubectl"
# Show current context and namespace details:
alias kc='k config get-contexts'
# Change context to use namespace: kn default:
alias kn='k config set-context --current --namespace '
alias kd='k -o yaml --dry-run=client'
alias kall='k get all -o wide --show-labels'

#if command -v docker >/dev/null; then  # installed in /usr/local/bin/docker
#   echo "Docker installed, so ..."
#   alias dockx="docker stop $(docker ps -a -q);docker rm -f $(docker ps -a -q)"
#fi
# See https://github.com/ysmike/dotfiles/blob/master/bash/.aliases
# More: https://www.cyberciti.biz/tips/bash-aliases-mac-centos-linux-unix.html

#     catn filename to show text file without comment (#) lines:
alias catn="grep -Ev '''^(#|$)'''"
alias keys="catn $HOME/aliases.sh"

   if [ -d "$HOME/.google-cloud-sdk" ]; then   # directory found:
alias gcs='cd $HOME/.google-cloud-sdk;ls'
   fi

# Defined after creating a folder:
#export PROJECT_FOLDER_NAME="wiz"  # should be blank
#export PROJECT_FOLDER_PATH="$PROJECT_FOLDER_BASE/$PROJECT_FOLDER_NAME"
#export PROJECT_FOLDER_BASE_DEFAULT="$HOME/Projects"
#           export PROJECT_FOLDER_BASE="$HOME/Projects"  # -pcp
      if [ -d "${PROJECT_FOLDER_BASE}" ]; then   # directory found:
alias wmpfb="cd $PROJECT_FOLDER_BASE"
      fi

# echo "GITHUB_FOLDER_BASE=${GITHUB_FOLDER_BASE}"
   if [ ! -d "${GITHUB_FOLDER_BASE}" ]; then   # not specified in parms
      echo "-env $GITHUB_FOLDER_BASE directory NOT found ..."
   else
#### Jekyll build locally: See https://wilsonmar.github.io/jekyll-site-development/
alias bs="wm;bundle exec jekyll serve --config _config.yml,_config_dev.yml"
alias wmo="cd $GITHUB_FOLDER_BASE/wilsonmar.github.io/_posts"

# FIXME: 
# function wmio() { mdfind -onlyin "${GITHUB_FOLDER_BASE}/wilsonmar.github.io/_posts" "$1" }

alias wmf="cd $GITHUB_FOLDER_BASE/futures"

alias wms='cd $GITHUB_FOLDER_BASE/mac-setup'
alias wmdso='cd $GITHUB_FOLDER_BASE/DevSecOps'
alias wm1='cd $GITHUB_FOLDER_BASE/Akl-Demo'

alias wmb='cd $GITHUB_FOLDER_BASE/DevSecOps/bash'
alias wmz='cd $GITHUB_FOLDER_BASE/azure-quickly'
alias wmw='cd $GITHUB_FOLDER_BASE/aws-quickly'
alias wmp='cd $GITHUB_FOLDER_BASE/python-samples'
alias wmg='cd $GITHUB_FOLDER_BASE/gcp-samples'
alias wmr='cd $GITHUB_FOLDER_BASE/rustlang-samples'
alias wmgo='cd $GITHUB_FOLDER_BASE/golang-samples'

alias js="cd $GITHUB_FOLDER_BASE/wilsonmar.github.io;bundle exec jekyll serve --config _config.yml --incremental"
# git status -s -b

alias wmbn='cd $HOME/bomonike/bomonike.github.io'
alias wmh='cd $HOME/bomonike/hackproof'

   fi

# For more Mac aliases, see https://gist.github.com/natelandau/10654137
   # described at https://natelandau.com/my-mac-osx-bash_profile/
   # https://github.com/clvv/fasd
   # Not using alias -s  # suffix alias at https://github.com/seebi/zshrc/blob/master/aliases.sh

# END