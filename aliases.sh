# This is ~/aliases.sh from template https://github.com/wilsonmar/mac-setup/blob/main/aliases.sh
# NOTE: Functions are in functions.sh for Mac only.
# Both called from ~/.bash_profile for Bash or ~/.zshrc for zsh
# on both MacOS and git bash on Windows.

# Not using alias -s  # suffix alias at https://github.com/seebi/zshrc/blob/master/aliases.zsh

alias now='date +"%A %Y-%m-%d %T %p %s"'
alias c="clear"  # screen
alias cd=' cd'
alias ..=' cd ..; ls'
alias ...=' cd ..; cd ..; ls'
alias ....=' cd ..; cd ..; cd ..; ls'
alias cd..='..'
alias cd...='...'
alias cd....='....'

alias h='history'
alias x='exit'
alias p="pwd"   # present working directory

alias j='jobs -l'

alias k9='kill -9'
alias ka="killall"
alias kp="ps auxwww | more"  # "que pasa" processes running

#### See https://wilsonmar.github.io/text-editor
export EDITOR="code"  # code = Visual Studio Code; subl = Sublime Text
# export EDITOR="/usr/local/bin/mate -w" 
alias edit="$EDITOR"   # change this, not your habitual editor name
alias ebp="$EDITOR ~/.bash_profile && source ~/.bash_profile"
alias sbp='source ~/.bash_profile'
alias atom='open -a "/Applications/Atom.app"'
alias textedit='open -a "/Applications/TextEdit.app"'
alias p4merge='/Applications/p4merge.app/Contents/MacOS/p4merge'
# alias sourcetree='open -a SourceTree'
# alias sts='open -a "/Applications/STS.app"'
# alias eclipse='open "/Applications/Eclipse.app"'
alias vi="nvim"
alias vim="nvim"
# alias macvim='open -a "/Applications/MacVim.app"'
# alias vs='$HOME/Applications/Visual\ Studio.app/Contents/MacOS/VisualStudio &'
# alias idea='open -a "/Applications/IntelliJ IDEA CE.app"'
# alias brackets='open -a "/Applications/Brackets.app"'

# For Zsh only:
# alias szs="$EDITOR ~/.zshrc"

alias rs='exec -l $SHELL'

### To access MacOS system GUI apps from command line:
alias aam='open -a "/Applications/Utilities/Activity Monitor.app"'  # See CPU usage by app
alias prefs='open -a "/Applications/System\Preferences.app"'
alias sysinfo='open -a "/Applications/Utilities/System Information.app"'

### To access Apple apps:
alias appstore='open -a "/Applications/App Store.app"'
alias calc='open -a "/Applications/Calculator.app"'
alias facetime='open -a "/Applications/FaceTime.app"'
alias messages='open -a "/Applications/Messages.app"'
alias safari='open -a "$HOME/Applications/Safari.app"'
alias xcode='open -a /Applications/xcode.app'

### To access custom-installed GUI apps from command line:
alias 1pass='open -a "/Applications/1Password 7.app"'      # Secret
alias alfred='open -a "/Applications/Alfred 3.app"'
alias anki='open -a "$HOME/Applications/Anki.app"'         # Flash cards https://apps.ankiweb.net/
alias automator='open -a "/Applications/Automator.app"'    # https://automator.app/
alias audacity='open -a "/Applications/Audacity.app"'      # Audio engineering
# alias brave='open -a "/Applications/Brave.app"'
alias chime='open -a "/Applications/Amazon Chime.app"'
alias chrome='open -a "/Applications/Google Chrome.app"'
alias collo='open -a "/Applications/Colloquy.app"'         # 
# alias discord='open -a "/Applications/Discord.app"'
alias ppt='open -a "/Applications/Microsoft PowerPoint.app"'
alias excel='open -a "/Applications/Microsoft Excel.app"'
# https://expo.dev/tools
alias edge='open -a "/Applications/Microsoft Edge.app"'
alias geekbench='open -a "$HOME/Applications/Geekbench 4.app"'  #
alias ghd='open -a "/Applications/GitHub Desktop.app"'
alias iterm='open -a "$HOME/Applications/iTerm.app"'
# alias jprofiler='open -a "/Applications/JProfiler.app"'
alias keybase='open -a "$HOME/Applications/Keybase.app"'                  # Secrets
alias kindle='open -a "$HOME/Applications/Kindle.app"'
# obs
alias postman='open -a "/Applications/Postman.app"'
#alias pycharm='open -a "$HOME/Applications/Pycharm.app"'
alias reader='open -a "/Applications/Adobe Acrobat Reader DC.app"'
# alias rstudio='open -a "/Applications/RStudio.app"'
alias sentinel='open -a "/Applications/Sentinel.app"'  # Hashicorp
alias signal='open -a "/Applications/Signal.app"'
alias sketch='open -a "$HOME/Applications/Sketch.app"'
alias skype='open -a "$HOME/Applications/Skype.app"'
alias slack='open -a "$HOME/Applications/Slack.app"'
#alias soapui='open -a "/Applications/SoapUI-5.4.0.app"'
alias sourcetree='open -a "$HOME/Applications/Sourcetree.app"'
alias telegram='open -a "$HOME/Applications/Telegram.app"'
#alias unity='open -a "$HOME/Applications/Unity.app"'
alias teams='open -a "/Applications/Microsoft Teams.app"'
alias vfusion='open -a "/Applications/VMware Fusion.app"'
# alias webstorm='open -a "/Applications/Webstorm.app"'
alias whatsapp='open -a "/Applications/Telegram.app"'
alias word='open -a "/Applications/Microsoft Word.app"'
alias zoom='open -a "/Applications/Zoom.app"'

# Only on MacOS, not git bash on Windows MINGW64:
#if [ "$(uname)" == "Darwin" ]; then  # it's on a Mac:
#   alias vers="sw_vers"
#   function gd() { # get dirty
#	[[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]] && echo "*"
#   }
#  function gas() { git status ;  git add . -A ; git commit -m "$1" ; git push; }
#   function gsa() { git stash save "$1" -a; git stash list; }  # -a = all (untracked, ignored)
#fi

alias cf="find . -print | wc -l"  # count files in folder.
alias lf="ls -p | more"      # list folders only
alias dir='ls -alrT'         # for windows habits
alias l='ls -FalhGT | more'         # T for year
alias ll='ls -FalhGT | more'  # T for year
alias lt="ls -ltaT | more"   # list by date
# Last 30 files updated anywhere:
alias f50='stat -f "%m%t%Sm %N" /tmp/* | sort -rn | head -50 | cut -f2- 2>/dev/null'

# wireless en0, wired en1: PRIVATE_IP address:
alias en0="ipconfig getifaddr en0"  # like 172.20.1.91 or 192.168.1.253
   #alias myip="ifconfig en0 | grep inet | grep -v inet6 | cut -d ' ' -f2" 
   # ip route get 1 | awk '{print $NF;exit}'

# These all return the public ip like https://www.whatismyip.com/:
# alias mac="curl http://canhazip.com"  # public IP 
#alias pubip="curl https://checkip.amazonaws.com"  # public IP
alias pubip="curl -s ifconfig.me"  # public IP
alias ipinfo="curl ipinfo.io"  # more verbose JSON containing country and zip of IP
alias wanip4='dig @resolver1.opendns.com ANY myip.opendns.com +short'
alias wanip6='dig @resolver1.opendns.com AAAA myip.opendns.com +short -6'

alias ramfree="top -l 1 -s 0 | grep PhysMem"  # PhysMem: 30G used (3693M wired), 1993M unused.
alias spacefree="du -h | awk 'END{print $1}'"

alias gcs='cd ~/.google-cloud-sdk;ls'

alias ga='git add . -A'  # --patch
alias gb='git branch -avv'
alias gbs='git status -s -b;git add . -A;git commit --quiet -m"Update";git push'
alias get='git fetch;' # git pull + merge
alias gf='git fetch origin master;git diff master..origin/master'
alias gfu='git fetch upstream;git diff HEAD @{u} --name-only'
alias gc='git commit -m --quiet' # requires you to type a commit message
alias gcm='git checkout master'
alias gl='git log --pretty=format:"%h %s %ad" --graph --since=1.days --date=relative;git log --show-signature -n 1'
alias gl1="git log --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gl2="git log --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias gmo='git merge origin/master'
alias gmf='git merge --no-ff'
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
alias hb="hub browse"
alias githead="git rev-parse --short HEAD"  # current SHA commit ID
alias grx="rm .git/merge"  # Remove merge

alias sign='gpg --detach-sign --armor'
alias gsk="gpg --list-secret-keys --keyid-format LONG"
alias gst="gpg show-ref --tags"

alias grep='grep --color=auto'

alias cr="cargo run --verbose"  # Rust .rs program file in folder

alias ven="virtualenv venv"
alias vbc="source venv/bin/activate"
alias vde="source deactivate"

alias tf="terraform $1"  # provide a parameter
alias tfa="terraform apply"
alias tfd="terraform destroy"
alias tfs="terraform show"

alias ddk="killall com.docker.osx.hyperkit.linux"   # docker restart
alias dps="docker ps"                               # docker processes list
alias dcl="docker container ls -aq"                 # docker list active container

alias dpa="docker container prune --force"          # Remove all stopped containers

# To avoid "Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
if [ -f "/var/run/docker.pid" ]; then  # NOT found:
   alias dsa="docker stop $(docker container ls -aq )" # docker stop active container
   alias dpx="docker rm -v $(docker ps -aq -f status=exited)"  # Remove stopped containers
fi
# shorthand alias so you can type "k" instead of kubectl: https://wilsonmar.github.io/kubernetes
alias k="kubectl"
complete -F __start_kubectl k
alias mk8s="minikube delete;minikube start --driver=docker --memory=4096"

#if command -v docker >/dev/null; then  # installed in /usr/local/bin/docker
#   echo "Docker installed, so ..."
#   alias dockx="docker stop $(docker ps -a -q);docker rm -f $(docker ps -a -q)"
#fi
# See https://github.com/ysmike/dotfiles/blob/master/bash/.aliases
# More: https://www.cyberciti.biz/tips/bash-aliases-mac-centos-linux-unix.html

alias wmx='cd $HOME/gmail_acct/azure-quickly'
alias wmf='cd $HOME/gmail_acct/futures'
alias wmb='cd $HOME/gmail_acct/DevSecOps/bash'
alias wmp='cd $HOME/gmail_acct/python-samples'
alias wmgo='cd $HOME/gmail_acct/golang-samples'
#alias wmr='cd $HOME/gmail_acct/rustlang-samples'

#### Custom Jekyll build locally:
alias wmo='cd $HOME/gmail_acct/wilsonmar.github.io/_posts'
alias wm='cd $HOME/gmail_acct/wilsonmar.github.io/_posts;git status -s -b'
alias wf='cd $HOME/gmail_acct/futures;git status -s -b'
alias js='cd $HOME/gmail_acct/wilsonmar.github.io;bundle exec jekyll serve --config _config.yml --incremental'
#alias bs='wm;bundle exec jekyll serve --config _config.yml,_config_dev.yml'

alias keys="catn $HOME/aliases.sh"
