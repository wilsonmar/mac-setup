# This is ~/aliases.zsh from template https://github.com/wilsonmar/mac-setup/blob/main/aliases.zsh
# NOTE: Functions are in functions.zsh for Mac only.
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

# One-key keyboard shortcuts:
alias d='docker'
alias h='history'
alias j='jobs -l'
alias p="pwd"        # present working directory
alias x='exit'

alias grep='grep --color=auto'

# See https://wilsonmar.github.io/mac-utilities/#top-processes
alias ht="htop -t"        # processes in an indented tree - control+C to stop.
alias k9='kill -9'
alias ka="killall"
alias kp="ps auxwww | more"  # "que pasa" processes running

#### Define aliases to invoke GUI apps with several words:

#### built-in macOS system GUI apps invoke from command line:
alias aam='open -a "/Applications/Utilities/Activity Monitor.app"'  # See CPU usage by app
alias prefs='open -a "/Applications/System\Preferences.app"'
alias sysinfo='open -a "/Applications/Utilities/System Information.app"'

#### System utilities:
#alias alfred='open -a "/Applications/Alfred 3.app"'

# VIDEO: https://www.youtube.com/watch?v=BTmZOh1GI3U&list=RDCMUC5ZoLwtjX_7Zs8LoqpiLztQ&start_radio=1&rv=BTmZOh1GI3U&t=6
# https://macosxautomation.com/automator/
alias automator='open -a "/Applications/Automator.app"'    # https://support.apple.com/guide/automator/welcome/mac

#alias geekbench='open -a "$HOME/Applications/Geekbench 4.app"'   # performance benchmarking
#alias vfusion='open -a "/Applications/VMware Fusion.app"'      # VMware Fusion (licensed)


##### Terminal 
# terminal.app
#alias hyper='open -a "$HOME/Applications/Hyper.app"'
alias iterm='open -a "$HOME/Applications/iTerm.app"'
# alias iterm2='open -a "$HOME/Applications/iTerm2.app"'


##### See https://wilsonmar.github.io/text-editor
export EDITOR="code"  # code = Visual Studio Code; subl = Sublime Text
   # export EDITOR="/usr/local/bin/mate -w" 
alias edit="$EDITOR"   # make a habit of using this instead program name (such as code), so you can switch default editor easier 
alias ezs="$EDITOR ~/.zshrc"   # for Zsh
alias szs='source ~/.zshrc'
alias rs='exec -l $SHELL'    # reset shell
#alias ohmyzsh="$EDITOR ~/.oh-my-zsh"

#alias ebp="$EDITOR ~/.bash_profile && source ~/.bash_profile"
#alias sbp='source ~/.bash_profile'
# alias eclipse='open "/Applications/Eclipse.app"'

# alias atom='open -a "/Applications/Atom.app"'
# alias brackets='open -a "/Applications/Brackets.app"'
alias code='open -a "$HOME/Applications/Visual Studio Code.app"'
# alias vs='$HOME/Applications/Visual\ Studio.app/Contents/MacOS/VisualStudio &'

#alias pycharm='open -a "$HOME/Applications/Pycharm.app"'
# alias sts='open -a "/Applications/STS.app"'
alias sourcetree='open -a "$HOME/Applications/Sourcetree.app"'
# alias sourcetree='open -a SourceTree'

# See https://wilsonmar.github.io/dotfiles/#SublimeText.app
alias subl='open -a "/Applications/Sublime Text.app"'
alias textedit='open -a "/Applications/TextEdit.app"'
alias xcode='open -a /Applications/xcode.app'
alias vi="nvim"
alias vim="nvim"
# alias macvim='open -a "/Applications/MacVim.app"'
# alias idea='open -a "/Applications/IntelliJ IDEA CE.app"'

# https://www.jetbrains.com/webstorm/
# alias webstorm='open -a "/Applications/Webstorm.app"'

alias word='open -a "/Applications/Microsoft Word.app"'

# Diff:
alias p4merge='/Applications/p4merge.app/Contents/MacOS/p4merge'


##### Internet Browsers:
# alias brave='open -a "/Applications/Brave.app"'

# See https://wilsonmar.github.io/dotfiles/#GoogleChrome.app
alias chrome='open -a "/Applications/Google Chrome.app"'

alias edge='open -a "/Applications/Microsoft Edge.app"'
#alias firefox='open -a "/Applications/Firefox.app"'
# alias opera='open -a "/Applications/Opera.app"'
alias safari='open -a "/Applications/Safari.app"'
# alias tor='open -a "/Applications/Tor Browser.app"'


### built-in Apple apps:
alias appstore='open -a "/Applications/App Store.app"'
alias calc='open -a "/Applications/Calculator.app"'


#### See https://wilsonmar.github.io/1password/
alias 1pass='open -a "/Applications/1Password 7.app"'      # Secret
#alias keybase='open -a "$HOME/Applications/Keybase.app"'                  # Secrets
#alias sentinel='open -a "/Applications/Sentinel.app"'  # Hashicorp
# terraform
# terragoat


#### Meetings (Communications):
#alias facetime='open -a "/Applications/FaceTime.app"'       # built-in from Apple
#alias messages='open -a "/Applications/Messages.app"'       # built-in from Apple

alias chime='open -a "/Applications/Amazon Chime.app"'
#alias collo='open -a "/Applications/Colloquy.app"'         # Installed from Apple store 
#alias discord='open -a "/Applications/Discord.app"'       # Has security issue. Don't use.
#alias gotomeeting='open -a "/Applications/GoToMeeting.app"'
#alias skype='open -a "$HOME/Applications/Skype.app"'
#alias signal='open -a "/Applications/Signal.app"'
#alias slack='open -a "$HOME/Applications/Slack.app"'
alias teams='open -a "$HOME/Applications/Microsoft Teams.app"'
#alias telegram='open -a "$HOME/Applications/Telegram.app"'
alias teams='open -a "/Applications/Microsoft Teams.app"'
#alias whatsapp='open -a "/Applications/Whatsapp.app"'
alias zoom='open -a "/Applications/zoom.us.app"'


##### Reading/Learning:
#alias anki='open -a "$HOME/Applications/Anki.app"'         # Flash cards https://apps.ankiweb.net/
#alias kindle='open -a "$HOME/Applications/Kindle.app"'
alias reader='open -a "/Applications/Adobe Acrobat Reader DC.app"'
# https://wilsonmar.github.io/dotfiles/#Transmission.app  # Torrent


##### Media creation:
#alias audacity='open -a "/Applications/Audacity.app"'      # Audio engineering
alias excel='open -a "/Applications/Microsoft Excel.app"'
#alias obs='open -a "/Applications/OBS.app"'
alias ppt='open -a "/Applications/Microsoft PowerPoint.app"'
#alias sketch='open -a "$HOME/Applications/Sketch.app"'
#alias unity='open -a "$HOME/Applications/Unity.app"'


##### Software development:
# https://expo.dev/tools
alias ghd='open -a "/Applications/GitHub Desktop.app"'
# alias jprofiler='open -a "/Applications/JProfiler.app"'
#alias soapui='open -a "/Applications/SoapUI-5.4.0.app"'
#alias postman='open -a "$HOME/Applications/Postman.app"'
# alias insomnia='open -a "/Applications/Insomnia.app"'
# alias rstudio='open -a "/Applications/RStudio.app"'

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

#### See https://wilsonmar.github.io/git-shortcuts/
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
alias githead="git rev-parse --short HEAD"  # current SHA commit ID
alias grx="rm .git/merge"  # Remove merge

alias hb="hub browse"

#### See https://wilsonmar.github.io/git-signing/
alias sign='gpg --detach-sign --armor'
alias gsk="gpg --list-secret-keys --keyid-format LONG"
alias gst="gpg show-ref --tags"

alias cr="cargo run --verbose"  # Rust .rs program file in folder

alias ven="virtualenv venv"
alias vbc="source venv/bin/activate"
alias vde="source deactivate"

#### See https://wilsonmar.github.io/terraform
alias tf="terraform $1"  # provide a parameter
alias tfa="terraform apply"
alias tfd="terraform destroy"
alias tfs="terraform show"

#### See https://wilsonmar.github.io/docker
alias ddk="killall com.docker.osx.hyperkit.linux"   # docker restart
alias dps="docker ps"                               # docker processes list
alias dcl="docker container ls -aq"                 # docker list active container
alias dpa="docker container prune --force"          # Remove all stopped containers
# To avoid "Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
if [ -f "/var/run/docker.pid" ]; then  # NOT found:
   alias dsa="docker stop $(docker container ls -aq )" # docker stop active container
   alias dpx="docker rm -v $(docker ps -aq -f status=exited)"  # Remove stopped containers
fi
#### See https://wilsonmar.github.io/kubernetes
alias k="kubectl"
complete -F __start_kubectl k
alias mk8s="minikube delete;minikube start --driver=docker --memory=4096"

#if command -v docker >/dev/null; then  # installed in /usr/local/bin/docker
#   echo "Docker installed, so ..."
#   alias dockx="docker stop $(docker ps -a -q);docker rm -f $(docker ps -a -q)"
#fi
# See https://github.com/ysmike/dotfiles/blob/master/bash/.aliases
# More: https://www.cyberciti.biz/tips/bash-aliases-mac-centos-linux-unix.html

export GH_ACCT="github-wilsonmar"
alias wmx='cd $HOME/$GH_ACCT/azure-quickly'
alias wmf='cd $HOME/$GH_ACCT/futures'
alias wmb='cd $HOME/$GH_ACCT/DevSecOps/bash'
alias wmp='cd $HOME/$GH_ACCT/python-samples'
alias wmgo='cd $HOME/$GH_ACCT/golang-samples'
#alias wmr='cd $HOME/$GH_ACCT/rustlang-samples'

#### Jekyll build locally: See https://wilsonmar.github.io/jekyll-site-development/
alias wmo='cd $HOME/$GH_ACCT/wilsonmar.github.io/_posts'
alias wm='cd $HOME/$GH_ACCT/wilsonmar.github.io/_posts;git status -s -b'
alias wf='cd $HOME/$GH_ACCT/futures;git status -s -b'
alias js='cd $HOME/$GH_ACCT/wilsonmar.github.io;bundle exec jekyll serve --config _config.yml --incremental'
#alias bs='wm;bundle exec jekyll serve --config _config.yml,_config_dev.yml'

##### Leave this at bottom of file:
alias keys="catn $HOME/aliases.zsh"
