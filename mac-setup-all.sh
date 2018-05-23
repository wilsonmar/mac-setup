#!/usr/local/bin/bash

# mac-setup-all.sh in https://github.com/wilsonmar/mac-setup
# This downloads and installs all the utilities related to use of Git,
# customized based on specification in file secrets.sh within the same repo.
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/wilsonmar/mac-setup/master/mac-setup-all.sh)"

# See https://github.com/wilsonmar/git-utilities/blob/master/README.md
# Based on https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup
# and https://git-scm.com/docs/git-config
# and https://medium.com/my-name-is-midori/how-to-prepare-your-fresh-mac-for-software-development-b841c05db18
# https://www.bonusbits.com/wiki/Reference:Mac_OS_DevOps_Workstation_Setup_Check_List
# More at https://github.com/thoughtbot/laptop/blob/master/mac
# This is free software; see the source for copying conditions.  There is NO
# warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# TOC: Functions (GPG_MAP_MAIL2KEY, Python, Python3, Java, Node, Go, Docker) > 
# Starting: Secrets > XCode > XCode/Ruby > bash.profile > Brew > gitconfig > gitignore > Git web browsers > p4merge > linters > Git clients > git users > git tig > BFG > gitattributes > Text Editors > git [core] > git coloring > rerere > prompts > bash command completion > git command completion > Git alias keys > Git repos > git flow > git hooks > Large File Storage > gcviewer, jmeter, jprofiler > code review > git signing > Cloud CLI/SDK > Selenium > SSH KeyGen > SSH Config > Paste SSH Keys in GitHub > GitHub Hub > dump contents > disk space > show log

# set -o nounset -o pipefail -o errexit  # "strict mode"
# set -u  # -uninitialised variable exits script.
# set -e  # -exit the script if any statement returns a non-true return value.
# set -a  # Mark variables which are modified or created for export. Each variable or function that is created or modified is given the export attribute and marked for export to the environment of subsequent commands. 
# set -v  # -verbose Prints shell input lines as they are read.
IFS=$'\n\t'  # Internal Field Separator for word splitting is line or tab, not spaces.
# shellcheck disable=SC2059
trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT
trap cleanup EXIT
trap sig_cleanup INT QUIT TERM


function fancy_echo() {
   local fmt="$1"; shift
   # shellcheck disable=SC2059
   printf "\\n>>> $fmt\\n" "$@"
}
# From https://gist.github.com/somebox/6b00f47451956c1af6b4
function echo_ok { echo -e '\033[1;32m'"$1"'\033[0m'; }
function echo_warn { echo -e '\033[1;33m'"$1"'\033[0m'; }
function echo_error  { echo -e '\033[1;31mERROR: '"$1"'\033[0m'; }

command_exists() {
  command -v "$@" > /dev/null 2>&1
}


######### Starting time stamp, OS versions, command attributes:


# For Git on Windows, see http://www.rolandfg.net/2014/05/04/intellij-idea-and-git-on-windows/
TIME_START="$(date -u +%s)"
FREE_DISKBLOCKS_START="$(df | sed -n -e '2{p;q}' | cut -d' ' -f 6)"
THISPGM="mac-setup-all.sh"
# ISO-8601 plus RANDOM=$((1 + RANDOM % 1000))  # 3 digit random number.
LOG_DATETIME=$(date +%Y-%m-%dT%H:%M:%S%z)-$((1 + RANDOM % 1000))
LOGFILE="$HOME/$THISPGM.$LOG_DATETIME.log"
echo "$THISPGM starting with logging to file:" >$LOGFILE  # new file
echo $LOGFILE >>$LOGFILE
clear  # screen
echo $LOGFILE  # to screen

RUNTYPE=""  # value to be replaced with definition in secrets.sh.
#bar=${RUNTYPE:-none} # :- sets undefine value. See http://redsymbol.net/articles/unofficial-bash-strict-mode/

fancy_echo "sw_vers ::"     >>$LOGFILE
 echo "$(sw_vers)"       >>$LOGFILE
 echo "uname -a : $(uname -a)"      >>$LOGFILE

function cleanup() {
    err=$?
    echo "At cleanup() LOGFILE=$LOGFILE"
    #open -a "Atom" $LOGFILE
    open -e $LOGFILE  # open for edit using TextEdit
    #rm $LOGFILE
    trap '' EXIT INT TERM
    exit $err 
}
cleanup2() {
    err=$?
    echo "At cleanup2() LOGFILE=$LOGFILE"
    # pico $LOGFILE
    trap '' EXIT INT TERM
    exit $err 
}
sig_cleanup() {
    echo "Run interrupted."
    trap '' EXIT # some shells will call EXIT after the INT handler
    false # sets $?
    cleanup
}

# Disable inputting password:

MAC_USERID=$(id -un 2>/dev/null || true)  # example: wilsonmar
      fancy_echo "MAC_USERID=$MAC_USERID ..." >>$LOGFILE

if [[ "${MAC_TOOLS,,}" = *"nopassword"* ]]; then
   fancy_echo "MAC_TOOLS nopassword sudo visudo using MAC_USERID=$MAC_USERID ..."
   sudo visudo
   # TODO: $USERNAME ALL=(root) NOPASSWD: /usr/sbin/installer
fi

#Mandatory:
   # Ensure Apple's command line tools (such as cc) are installed by node:
   if ! command_exists cc ; then
      fancy_echo "Accept Apple's license ..."
      xcodebuild -license
      fancy_echo "Installing Apple's command line tools (this takes a while) ..."
      xcode-select --install  # /Library/Developer/CommandLineTools
      # Xcode installs its git to /usr/bin/git; recent versions of OS X (Yosemite and later) ship with stubs in /usr/bin, which take precedence over this git. 
   fi
   xcode-select --version  >>$LOGFILE  # xcode-select version 2349.
   # See https://wilsonmar.github.io/mac-utilities/#XCodeTools


######### bash.profile configuration:


BASHFILE="$HOME/.bash_profile"  # on Macs
# if ~/.bash_profile has not been defined, create it:
if [ ! -f "$BASHFILE" ]; then #  NOT found:
   fancy_echo "Creating blank \"${BASHFILE}\" ..." >>$LOGFILE
   touch "$BASHFILE"
   echo "PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin" >>"$BASHFILE"
   # El Capitan no longer allows modifications to /usr/bin, and /usr/local/bin is preferred over /usr/bin, by default.
else
   LINES=$(wc -l < "${BASHFILE}")
   fancy_echo "\"${BASHFILE}\" already created with $LINES lines." >>$LOGFILE
   echo "Backing up file $BASHFILE to $BASHFILE-$LOG_DATETIME.bak ..."  >>$LOGFILE
   cp "$BASHFILE" "$BASHFILE-$LOG_DATETIME.bak"
fi

function BASHFILE_EXPORT() {

   # example: BASHFILE_EXPORT "gitup" "open -a /Applications/GitUp.app"

   name=$1
   value=$2

   if grep -q "export $name=" "$BASHFILE" ; then    
      fancy_echo "$name alias already in $BASHFILE" >>$LOGFILE
   else
      fancy_echo "Adding $name in $BASHFILE..."
      # Do it now:
            export "$name=$value" 
      # For after a Terminal is started:
      echo "export $name='$value'" >>"$BASHFILE"
   fi
}


######### bash completion:


# Because of the shebang, bash v4 is expected.
fancy_echo "$(bash --version | grep 'bash')" >>$LOGFILE

# See https://kubernetes.io/docs/tasks/tools/install-kubectl/#on-macos-using-bash
# Also see https://github.com/barryclark/bashstrap

# TODO: Extract 4 from $BASH_VERSION
      # GNU bash, version 4.4.19(1)-release (x86_64-apple-darwin17.3.0)


###### Install homebrew using whatever Ruby is installed:


# Ruby comes with MacOS:
fancy_echo "Using Ruby that comes with MacOS:" >>$LOGFILE
ruby -v >>$LOGFILE  # ruby 2.5.0p0 (2017-12-25 revision 61468) [x86_64-darwin16]
if [[ "${RUNTYPE,,}" == *"upgrade"* ]]; then
   sudo gem update --system
   # https://asciidoctor.org/docs/install-asciidoctor-macos/
fi

# Set the permissions that Brew expects	
# sudo chflags norestricted /usr/local && sudo chown $(whoami):admin /usr/local && sudo chown -R $(whoami):admin /usr/local

#Mandatory:
   if ! command_exists brew ; then
       fancy_echo "Installing homebrew using Ruby..."   >>$LOGFILE
       ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
       brew tap caskroom/cask
   else
       # Upgrade if run-time attribute contains "upgrade":
       if [[ "${RUNTYPE,,}" == *"upgrade"* ]]; then
          fancy_echo "Brew upgrading ..." >>$LOGFILE
          brew --version
          # brew upgrade  # upgrades all modules.
       fi
   fi
   fancy_echo "$(brew --version)"  >>$LOGFILE
      # Homebrew 1.5.12
      # Homebrew/homebrew-core (git revision 9a81e; last commit 2018-03-22)

   brew analytics off  # see https://github.com/Homebrew/brew/blob/master/docs/Analytics.md

function BREW_INSTALL() {

  # Example call:    BREW_INSTALL "GIT_CLIENTS" "git --something" "--version"

   local category="$1"    # sample: "DATA_TOOLS"
   local package_in="$2"  # sample: "moreutils --without-parallel"
   local versions="$3"    # sample: "brew"

   prefix="$category BREW_INSTALL"
   package="$(echo $package_in | head -n1 | awk '{print $1;}')"
   RESPONSE=$(brew info $package)
   package_info="$(brew cask info $package | grep "$package:")"
   if [[ "${RUNTYPE,,}" == *"remove"* ]]; then
      if [[ "$RESPONSE" == *"No available formula"* ]] || [[ $RESPONSE == *"Not installed"* ]]; then
         fancy_echo "$category $package_info already removed ..."
      else
         fancy_echo "$category $package_info removing ..."
         brew uninstall --force $package
         rm -rf "/Applications/$appname.app"  #needed with uninstall
      fi
   else # other RUNTYPEs:
      fancy_echo "$prefix brew info $RESPONSE"
      if [[ $RESPONSE == *"No available formula"* ]] || [[ $RESPONSE == *"Not installed"* ]]; then
         fancy_echo "$category $package_info installing ..."
         brew install "$package_in"
      else
         if [[ "${RUNTYPE,,}" == *"upgrade"* ]]; then
            fancy_echo "$category $package_info upgrading ..."
            brew upgrade $package
         fi
      fi

      if [[ -z "${versions// }"  ]]; then  #it's blank
         echo "$prefix (no version)"
      else
         if [[ "$versions" == "brew" ]]; then
            VER="$(brew info $package | grep "$package:")"
            echo "$prefix $VER"
         elif command_exists $package ; then
            #echo "$category $package command available now."
            if [[ "$versions" == "version" ]]; then
               VER="$($package version | head -n 1)"
               echo "$prefix $VER" 
            elif [[ "$versions" == "--version" ]]; then
               VER="$($package --version | head -n 1)"
               echo "$prefix $VER"
            elif [[ "$versions" == "-v" ]]; then
               VER="$($package -v | head -n 1)"
               echo "$prefix $VER" 
            else
               VER="$($versions)"
               echo "$prefix $VER" 
#              find / -name $package 2>/dev/null
            fi
         fi

         if [[ "$category" == "LOCALHOSTS" ]] ||  [[ "$category" == "CLOUD_TOOLS" ]]; then
            echo "$prefix $package_info ..."
         elif [[ "${TRYOUT,,}" == *"$package"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
            echo "$prefix $package opening ..."
            "$package" &
         fi
      fi
   fi
}

## or, if running Bash 4.1+
#BREW_INSTALL bash-completion@2
## If running Bash 3.2 included with macOS
#BREW_INSTALL bash-completion


function BREW_CASK_INSTALL() {

   # Example: BREW_CASK_INSTALL "EDITORS" "webstorm" "Webstorm" "brew"
   local category="$1"
   local package_in="$2"
   local appname="$3"
   local versions="$4"    # sample: "brew"

   prefix="$category BREW_INSTALL $RUNTYPE"
   package=$(echo "$package_in" | head -n1 | awk '{print $1;}')
   RESPONSE=$(brew cask info $package)
   package_info="$(brew cask info $package | grep "$package:")"
   if [[ "${RUNTYPE,,}" == *"remove"* ]]; then
      # TODO: Confirm response_file contents if removed:
      if [[ "$RESPONSE" == *"Not installed"* ]] || [[ "$RESPONSE" == *"No available formula"* ]]; then
         fancy_echo "$prefix $package_info already removed ..."
      else
         fancy_echo "$category $package_info being removed ..."
         brew remove "$package"
            # Error: No such keg
      fi

      if [   -d "/usr/local/Caskroom/$appname" ]; then # found:
         rm -rf "/usr/local/Caskroom/$appname" 
      fi

      if [   -d "/Applications/$appname.app" ]; then # found:
         rm -rf "/Applications/$appname.app" 
      fi
   else # other RUNTYPEs:
      if [[ "$RESPONSE" == *"No available formula"* ]] || [[ "$RESPONSE" == *"Not installed"* ]]; then
      #if grep -q "Not installed" "response_file" ; then # for update too:
         fancy_echo "$category $package_info installing ..."
         brew cask install --appdir="/Applications" "$package_in"
      else # installed already:
         if [[ "${RUNTYPE,,}" == *"upgrade"* ]]; then
            # $package -v >>$LOGFILE
            fancy_echo "$category $package_info upgrading ..."
            brew cask upgrade $package
         fi
      fi

      if command_exists $package ; then
         echo "$category $package command available, so alias not needed."
      else
         echo "$prefix $(brew cask info $package)"
         if grep -q "alias $package=" "$BASHFILE" ; then
            echo "$category $package alias to $appname.app already in $BASHFILE"
         else
            echo "$category $package alias to $appname.app adding in $BASHFILE ..."
                 alias "$package='open -a \"/Applications/$appname.app\"'"
            echo "alias $package='open -a \"/Applications/$appname.app\"'" >>"$BASHFILE"
            source $BASHFILE  # Activate
         fi
      fi
   
      if [[ "${TRYOUT,,}" == *"$package"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         if command -v $prefix >/dev/null 2>/dev/null; then
            echo "$prefix $package opening ..."
            open -a "/Applications/$appname.app" &
         else
            echo "$prefix $package not available!"
         fi
      fi
   fi
}


######### Install git client to download the rest:


# TODO: Check for git command caz this is Mandatory:
if [[ "${GIT_CLIENTS,,}" == *"git"* ]]; then
   BREW_INSTALL "GIT_TOOLS" "git" "--version"
    # git version 2.14.3 (Apple Git-98)
fi

function GITHUB_UPDATE() {
      UPSTREAM="${1:-'@{u}'}"
      LOCAL="$(git rev-parse @)"
      REMOTE="$(git rev-parse "$UPSTREAM")"
      BASE="$(git merge-base @ "$UPSTREAM")"
      if [ $LOCAL == $REMOTE ]; then
         echo "Up-to-date"
      elif [ $LOCAL = $BASE ]; then
         git fetch  # instead of git pull
         git log ..@{u} --oneline
         #git reset --hard HEAD@{1} to go back and discard result of git pull if you don't like it.
         git merge  # Response: Already up to date.
      elif [ $REMOTE == $BASE ]; then
         git add . -A
         git commit -m"GITHUB_UPDATE in $THISPGM"
         git push
      else
         echo "Plese resolve diverged repo."
         gitk master..upstream/master
         #p4merge
      fi
}


######### Download/clone GITHUB_REPO_URL repo:


# In order to keep secrets.sh out of the repo where it can be sent up to public GitHub:
SECRETSFILE="$HOME/secrets.sh"
GITHUB_PATH="https://github.com/wilsonmar/mac-setup.git"
REPO_PATH="$HOME/mac-setup"
if [ ! -f "$SECRETSFILE" ]; then #  NOT found:
   fancy_echo "$SECRETSFILE not found." >>$LOGFILE

   if [ ! -d "$REPO_PATH" ]; then #  NOT found:
      fancy_echo "Cloning from $GITHUB_PATH ..." >>$LOGFILE
      echo "to $REPO_PATH ..." >>$LOGFILE
      git clone $GITHUB_PATH "$REPO_PATH"
      cd $REPO_PATH
      cp secrets.sh "$SECRETSFILE" # once only on init.
      rm secrets.sh  # so it's not edited by mistaks
   else
      cd $REPO_PATH
      GITHUB_UPDATE
   fi
fi
fancy_echo "At $(pwd)" >>$LOGFILE
pwd


######### Read and use secrets.sh file:


# If the file still contains defaults, it should not be used:
if grep -q "wilsonmar@gmail.com" "$SECRETSFILE" ; then  # file contents not customized:
   fancy_echo "Please edit file $SECRETSFILE with your own credentials. Aborting this run..."
   exit  # so script ends now
else
   fancy_echo "Reading from $SECRETSFILE ..." >>$LOGFILE
   # To preven fatal: '/Users/wilsonmar/secrets.sh' is outside repository
   #pushd $HOME  # not needed since SECRETSFILE var contains full path
   # secrets.unlock.sh  # prompt for password so can be read
   chmod +x $SECRETSFILE
   source "$SECRETSFILE"  # to load contents into memory.
   # TODO: run secrets.unlock.sh to lock it again
   #popd

   #git update-index --skip-worktree $SECRETSFILE
   #fancy_echo "git ls-files -v|grep '^h' ::" >>$LOGFILE
   #echo "$(git ls-files -v|grep '^S')" >>$LOGFILE

   echo "SECRETSFILE=$SECRETSFILE ::" >>$LOGFILE
   echo "RUNTYPE=$RUNTYPE ::" >>$LOGFILE
   echo "GIT_NAME=$GIT_NAME">>$LOGFILE
   echo "GIT_ID=$GIT_ID" >>$LOGFILE
   echo "GIT_EMAIL=$GIT_EMAIL" >>$LOGFILE
   echo "GIT_USERNAME=$GIT_USERNAME" >>$LOGFILE
   echo "GITS_PATH=$GITS_PATH" >>$LOGFILE
   echo "GITHUB_ACCOUNT=$GITHUB_ACCOUNT" >>$LOGFILE
   echo "GITHUB_REPO=$GITHUB_REPO" >>$LOGFILE
   # DO NOT echo $GITHUB_PASSWORD. Do not cat $SECRETFILE because it contains secrets.
   echo "GIT_CLIENTS=$GIT_CLIENTS" >>$LOGFILE
   echo "GIT_TOOLS=$GIT_TOOLS" >>$LOGFILE

   echo "EDITORS=$EDITORS" >>$LOGFILE
   echo "BROWSERS=$BROWSERS" >>$LOGFILE

   echo "LANG_TOOLS=$GUI_LANG" >>$LOGFILE
   echo "JAVA_TOOLS=$JAVA_TOOLS" >>$LOGFILE
   echo "PYTHON_TOOLS=$PYTHON_TOOLS" >>$LOGFILE
   echo "NODE_TOOLS=$NODE_TOOLS" >>$LOGFILE
   echo "RUBY_TOOLS=$RUBY_TOOLS" >>$LOGFILE

   echo "DATA_TOOLS=$DATA_TOOLS" >>$LOGFILE
   echo "MARIADB_PASSWORD=$MARIADB_PASSWORD" >>$LOGFILE
   echo "MONGODB_DATA_PATH=$MONGODB_DATA_PATH" >>$LOGFILE
   echo "TEST_TOOLS=$TEST_TOOLS" >>$LOGFILE

   echo "CLOUD_TOOLS=$CLOUD_TOOLS" >>$LOGFILE
   # echo "IRON_TOKEN=$IRON_TOKEN" >>$LOGFILE   # secret
   # echo "IRON_PROJECT_ID=$IRON_PROJECT_ID" >>$LOGFILE  # secret
   # AWS_ACCESS_KEY_ID=""
   # AWS_SECRET_ACCESS_KEY=""
   # AWS_REGION="us-west-1"
   # SAUCE_USERNAME=""
   # SAUCE_ACCESS_KEY=""

   echo "MON_TOOLS=$MON_TOOLS" >>$LOGFILE
   echo "DOCKERHOSTS=$DOCKERHOSTS" >>$LOGFILE

   echo "VIZ_TOOLS=$VIZ_TOOLS" >>$LOGFILE
   echo "LOCALHOSTS=$LOCALHOSTS" >>$LOGFILE

   echo "CUCUMBER_PORT=$CUCUMBER_PORT" >>$LOGFILE
   echo "ELASTIC_PORT=$ELASTIC_PORT" >>$LOGFILE
   echo "GRAFANA_PORT=$GRAFANA_PORT" >>$LOGFILE
   echo "HYGIEIA_PORT=$HYGIEIA_PORT" >>$LOGFILE
   echo "JEKYLL_PORT=$JEKYLL_PORT" >>$LOGFILE
   echo "JENKINS_PORT=$JENKINS_PORT" >>$LOGFILE
   echo "KIBANA_PORT=$KIBANA_PORT" >>$LOGFILE
   echo "MYSQL_PORT=$MYSQL_PORT" >>$LOGFILE
   echo "MEANJS_PORT=$MEANJS_PORT" >>$LOGFILE
   echo "MINIKUBE_PORT=$MINKUBE_PORT" >>$LOGFILE
   echo "MONGODB_PORT=$MONGODB_PORT" >>$LOGFILE
   echo "NEO4J_PORT=$NEO4J_PORT" >>$LOGFILE
   echo "NEXUS_PORT=$NEXUS_PORT" >>$LOGFILE
   echo "NGINX_PORT=$NGINX_PORT" >>$LOGFILE
   echo "PACT_PORT=$PACT_PORT"   >>$LOGFILE
   echo "POSTGRESQL_PORT=$POSTGRESQL_PORT" >>$LOGFILE
   echo "PROMETHEUS_PORT=$PROMETHEUS_PORT" >>$LOGFILE
   echo "REDIS_PORT=$REDIS_PORT" >>$LOGFILE
   echo "SONAR_PORT=$SONAR_PORT" >>$LOGFILE
   echo "TOMCAT_PORT=$TOMCAT_PORT" >>$LOGFILE

   echo "TRYOUT=$TRYOUT" >>$LOGFILE
   echo "TRYOUT_KEEP=$TRYOUT_KEEP" >>$LOGFILE

   echo "COLAB_TOOLS=$COLAB_TOOLS" >>$LOGFILE
        # TODO: Artifactory, Jira, 
   echo "MEDIA_TOOLS=$MEDIA_TOOLS" >>$LOGFILE

fi

GITS_PATH_INIT() {

   newdir=$1

   if [ ! -z "$GITS_PATH" ]; then # fall-back if not set in secrets.sh:
      GITS_PATH="$HOME/gits"  # the default
   fi

   if [ ! -d "$GITS_PATH" ]; then  # no path, so create:
      fancy_echo "GITS_PATH_INIT creating $GITS_PATH ..." 
      mkdir "$GITS_PATH"
   fi

   if [[ ! -z "${newdir// }" ]]; then  #it's not blank
      fancy_echo "GITS_PATH_INIT creating newdir=$newdir ..." 
      mkdir "$GITS_PATH/$newdir"
   fi
}


######### MacOS hidden files configuration:


if [[ "${MAC_TOOLS,,}" == *"unhide"* ]]; then
   fancy_echo "Configure OSX Finder to show hidden files too:" >>$LOGFILE
   defaults write com.apple.finder AppleShowAllFiles YES
   # also see dotfiles.
fi


######### MacOS maxfiles config:


echo "MAC_TOOLS=$MAC_TOOLS" >>$LOGFILE

if [[ "${MAC_TOOLS,,}" == *"maxfiles"* ]]; then
   # CAUTION: This is not working yet.

   FILE="/Library/LaunchDaemons/limit.maxfiles.plist"
   if [ ! -f "$FILE" ]; then #  NOT found, so add it
      fancy_echo "Copying configs/ to $FILE ..."
      sudo cp configs/limit.maxfiles.plist $FILE
      #see http://bencane.com/2013/09/16/understanding-a-little-more-about-etcprofile-and-etcbashrc/
      sudo chmod 644 $FILE
   fi

   FILE="/Library/LaunchDaemons/limit.maxproc.plist"
   if [ ! -f "$FILE" ]; then #  NOT found, so add it
      fancy_echo "Copying configs/ to $FILE ..."
      sudo cp configs/limit.maxproc.plist $FILE
      sudo chmod 644 $FILE
      # https://apple.stackexchange.com/questions/168495/why-wont-kern-maxfiles-setting-in-etc-sysctl-conf-stick
   fi

   if grep -q "ulimit -n " "/etc/profile" ; then    
      fancy_echo "ulimit -n already in /etc/profile" >>$LOGFILE
   else
      fancy_echo "Concatenating ulimit 2048 to /etc/profile ..."
      echo 'ulimit -n 2048' | sudo tee -a /etc/profile
      fancy_echo "Now please reboot so the settings take. Exiting ..."
      exit
   #see http://bencane.com/2013/09/16/understanding-a-little-more-about-etcprofile-and-etcbashrc/
   fi 

   # Based on https://docs.microsoft.com/en-us/dotnet/core/macos-prerequisites?tabs=netcore2x
   fancy_echo "launchctl limit ::" >>$LOGFILE
   launchctl limit >>$LOGFILE  # no sudo needed

   OPEN_FILES=$(ulimit -n)  # 256 default
   fancy_echo "ulimit -a = $OPEN_FILES" >>$LOGFILE

   # https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man3/sysctl.3.html
   /usr/sbin/sysctl -a | grep files >>$LOGFILE
      #kern.maxfiles: 49152
      #kern.maxfilesperproc: 24576
      #kern.num_files: 4692s

   FILE="/etc/sysctl.conf"
   if [ ! -f "$FILE" ]; then #  NOT found, so add it
      fancy_echo "Copying kern to $FILE ..."
      echo "kern.maxfiles=49152" | sudo tee -a $FILE
      echo "kern.maxfilesperproc=24576" | sudo tee -a $FILE
   fi
fi


###### bash.profile locale settings missing in OS X Lion+:


if [[ "${MAC_TOOLS,,}" == *"locale"* ]]; then
   # See https://stackoverflow.com/questions/7165108/in-os-x-lion-lang-is-not-set-to-utf-8-how-to-fix-it
   # https://unix.stackexchange.com/questions/87745/what-does-lc-all-c-do
   # LC_ALL forces applications to use the default language for output, and forces sorting to be bytewise.
   if grep -q "LC_ALL" "$BASHFILE" ; then    
      fancy_echo "LC_ALL Locale setting already in $BASHFILE" >>$LOGFILE
   else
      fancy_echo "Adding LC_ALL Locale in $BASHFILE..." >>$LOGFILE
      echo "# Added by $0 ::" >>"$BASHFILE"
      echo "export LC_ALL=en_US.utf-8" >>"$BASHFILE"
      #export LANG="en_US.UTF-8"
      #export LC_CTYPE="en_US.UTF-8"
   
      # Run .bash_profile to have changes take, run $FILEPATH:
      source "$BASHFILE"
   fi 
   #locale
      # LANG="en_US.UTF-8"
      # LC_COLLATE="en_US.UTF-8"
      # LC_CTYPE="en_US.utf-8"
      # LC_MESSAGES="en_US.UTF-8"
      # LC_MONETARY="en_US.UTF-8"
      # LC_NUMERIC="en_US.UTF-8"
      # LC_TIME="en_US.UTF-8"
      # LC_ALL=

   BASHFILE_EXPORT "ARCHFLAGS" "-arch x86_64"
fi


######### Mac tools:


# Replaced OS X commands with the GNU version:
if [[ "${MAC_TOOLS,,}" == *"coreutils"* ]]; then
   # See https://wilsonmar.github.io/mac-utilities

                 MANPATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnuman"
   echo "export MANPATH=\"$HOMEBREW_PREFIX/opt/coreutils/libexec/gnuman\"" >>$BASHFILE
   export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"
   echo "export PATH=\"$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH\"" >>$BASHFILE

   # add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH` of /usr/local/opt/coreutils/libexec/gnubin
   # BTW: brew --prefix coreutils yields /usr/local/bin/coreutils
   BREW_INSTALL "MAC_TOOLS" "coreutils" "brew"
         # Warning: coreutils 8.29 is already installed and up-to-date

   # Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.

   # more From https://gist.github.com/xuhdev/8b1b16fb802f6870729038ce3789568f
   # https://github.com/mathiasbynens/dotfiles/blob/master/brew.sh
   BREW_INSTALL "coreutils" "less" "--version"

   ### Utilities for Mac only
   BREW_INSTALL "coreutils" "htop" "--version" # like GNU top
   BREW_INSTALL "coreutils" "nmap" "--version"
   BREW_INSTALL "coreutils" "tmux" "--version"

   ### GNU utilities for Mac:
   BREW_INSTALL "coreutils" "watch" "--version"  # /usr/local/Cellar/watch/3.3.14: 9 files, 80KB
   BREW_INSTALL "coreutils" "tree" "--version"
   # BREW_INSTALL findutils
   # BREW_INSTALL screen # for Terminal multiplexer with VT100/ANSI terminal emulation

   BREW_INSTALL "coreutils" "moreutils" "--version"

else
   fancy_echo "MAC_TOOLS coreutils not specified." >>$LOGFILE
fi


if [[ "${MAC_TOOLS,,}" == *"iterm2"* ]]; then
   # https://www.iterm2.com/documentation.html
   BREW_CASK_INSTALL "MAC_TOOLS" "iterm2" "iTerm" ""
   BASHFILE_EXPORT "CLICOLOR" "1"
   # http://sourabhbajaj.com/mac-setup/iTerm/README.html
   # TODO: https://github.com/mbadolato/iTerm2-Color-Schemes/tree/master/schemes
else
   fancy_echo "MAC_TOOLS iterm2 not specified." >>$LOGFILE
fi


if [[ "${MAC_TOOLS,,}" == *"mas"* ]]; then
   # To manage apps purchased & installed using App Store on MacOS:
   BREW_INSTALL "MAC_TOOLS" "mas" "mas version"

   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      if [[ "${TRYOUT,,}" == *"mas"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         fancy_echo "TRYOUT: mas listing apps added via App Store ..." >>$LOGFILE
         mas list >>$LOGFILE
      fi
   fi
else
   fancy_echo "MAC_TOOLS mas not specified." >>$LOGFILE
fi


if [[ "${MAC_TOOLS,,}" == *"paragon-ntfs"* ]]; then
   # https://www.paragon-software.com/home/ntfs-mac/#
   # See http://wilsonmar.github.io/mac-diskspace/
   BREW_CASK_INSTALL "MAC_TOOLS" "paragon-ntfs" "Paragon" "-v"
   # Restart is necessary.
else
   fancy_echo "MAC_TOOLS paragon-ntfs not specified." >>$LOGFILE
fi

if [[ "${MAC_TOOLS,,}" == *"ansible"* ]]; then
   # To install programs. See http://wilsonmar.github.io/ansible/
   BREW_INSTALL "MAC_TOOLS" "ansible" "ansible -v"
else
   fancy_echo "MAC_TOOLS ansible not specified." >>$LOGFILE
fi

if [[ "${MAC_TOOLS,,}" == *"1Password"* ]]; then
   # See https://1password.com/ to store secrets on laptops securely.
   BREW_CASK_INSTALL "MAC_TOOLS" "1password" "1Password 6" "brew"
   #echo -e "$(1Password -v)" >>$LOGFILE  # 1Password v6.0.0-beta.7
else
   fancy_echo "MAC_TOOLS 1password not specified." >>$LOGFILE
fi


if [[ "${MAC_TOOLS,,}" == *"powershell"* ]]; then
   # See https://wilsonmar.github.io/powershell-on-mac/
   # https://docs.microsoft.com/en-us/powershell/scripting/powershell-scripting?view=powershell-6
   # https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-powershell-core-on-macos-and-linux?view=powershell-6#macos-1012
   BREW_CASK_INSTALL "MAC_TOOLS" "powershell" "PowerShell" "-v"
      # PowerShell v6.0.2
   # From https://github.com/PowerShell/PowerShell
   if [[ "${TRYOUT,,}" == *"powershell"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
      fancy_echo "MAC_TOOLS powershell verify ..." >>$LOGFILE
      { echo '$psversiontable';
        echo 'Get-ExecutionPolicy -List | Format-Table -AutoSize';
        echo 'exit';
      } | pwsh &
   fi
else
   fancy_echo "MAC_TOOLS powershell not specified." >>$LOGFILE
fi


if [[ "${MAC_TOOLS,,}" == *"alfred"* ]]; then
   # https://www.alfredapp.com/ multi-function utility
   # https://github.com/nikitavoloboev/my-mac-os for Alfred workflows
   # TODO: Get version 3  $(ls -dt /Applications/Alfred*|head -1)
   BREW_CASK_INSTALL "MAC_TOOLS" "alfred" "Alfred 3" "brew"
   # Buy the $19 https://www.alfredapp.com/powerpack/
else
   fancy_echo "MAC_TOOLS Alfred not specified." >>$LOGFILE
fi


if [[ "${MAC_TOOLS,,}" == *"vmware-fusion"* ]]; then
   BREW_CASK_INSTALL "MAC_TOOLS" "vmware-fusion" "VMware Fusion" "brew"
else
   fancy_echo "MAC_TOOLS vmware-fusion not specified." >>$LOGFILE
fi


if [[ "${MAC_TOOLS,,}" == *"bartender"* ]]; then
   # manage icons at top launch bar
   BREW_CASK_INSTALL "MAC_TOOLS" "bartender" "Bartender" "brew"
else
   fancy_echo "MAC_TOOLS bartender not specified." >>$LOGFILE
fi


if [[ "${MAC_TOOLS,,}" == *"charles"* ]]; then
   # https://stackoverflow.com/questions/33322334/charles-proxy-response-unreadable
   # https://www.bonusbits.com/wiki/HowTo:Setup_Charles_Proxy_on_Mac
   BREW_CASK_INSTALL "MAC_TOOLS" "charles" "Charles" "brew"
else
   fancy_echo "MAC_TOOLS charles not specified." >>$LOGFILE
fi


if [[ "${MAC_TOOLS,,}" == *"carthage"* ]]; then
   # Package manager for Apple Mac Coacoa
   BREW_INSTALL "MAC_TOOLS" "carthage" "brew"
else
   fancy_echo "MAC_TOOLS carthage not specified." >>$LOGFILE
fi


if [[ "${MAC_TOOLS,,}" == *"others"* ]]; then
      echo "Installing MAC_TOOLS=others ..."; 
#   BREW_CASK_INSTALL monolingual # remove unneeded osx lang files https://ingmarstein.github.io/Monolingual/
#   BREW_CASK_INSTALL vmware-fusion  # run Windows

#   BREW_CASK_INSTALL xtrafinder
#   BREW_CASK_INSTALL sizeup  # $12.99 resize windows http://www.irradiatedsoftware.com/sizeup/
#   BREW_CASK_INSTALL duet
#   BREW_CASK_INSTALL logitech-harmony  # multi-controller of TVs etc
#   BREW_CASK_INSTALL cheatsheet  # hold ⌘ gives you all the shortcuts you can use with the active app.
#   BREW_CASK_INSTALL steam
#   BREW_CASK_INSTALL fritzing
#   BREW_CASK_INSTALL nosleep
#   BREW_CASK_INSTALL balsamiq-mockups  # for designing website forms
#   BREW_CASK_INSTALL smartsynchronize
#   BREW_CASK_INSTALL toggldesktop
#   BREW_CASK_INSTALL xmind
#   BREW_INSTALL jsdoc3
#   BREW_CASK_INSTALL appcleaner
#   BREW_CASK_INSTALL qlcolorcode
#   BREW_CASK_INSTALL qlstephen
#   BREW_CASK_INSTALL qlmarkdown
#   BREW_CASK_INSTALL quicklook-json
#   BREW_CASK_INSTALL quicklook-csv
#   BREW_CASK_INSTALL betterzipql
#   BREW_CASK_INSTALL asepsis
#   BREW_CASK_INSTALL cheatsheet
# http://almworks.com/jiraclient/download.html
#   BREW_CASK_INSTALL bluestacks  # to emulate Android phone
fi


######### ~/.gitconfig initial settings:


GITCONFIG=$HOME/.gitconfig  # file

if [ ! -f "$GITCONFIG" ]; then 
   fancy_echo "$GITCONFIG! file not found."
else
   fancy_echo "Backing up $GITCONFIG-$LOG_DATETIME.bak ..." >>$LOGFILE
   cp "$GITCONFIG" "$GITCONFIG-$LOG_DATETIME.bak"
fi


######### Git functions:


# Based on https://gist.github.com/dciccale/5560837
# Usage: GIT_BRANCH=$(parse_git_branch)$(parse_git_hash) && echo ${GIT_BRANCH}
# Check if branch has something pending:
function git_parse_dirty() {
   git diff --quiet --ignore-submodules HEAD 2>/dev/null; [ $? -eq 1 ] && echo "*"
}
# Get the current git branch (using git_parse_dirty):
function git_parse_branch() {
   git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(git_parse_dirty)/"
}
# Get last commit hash prepended with @ (i.e. @8a323d0):
function git_parse_hash() {
   git rev-parse --short HEAD 2> /dev/null | sed "s/\(.*\)/@\1/"
}


######### Language function definitions:


# Add function to read in string and email, and return a KEY found for that email.
# GPG_MAP_MAIL2KEY associates the key and email in an array
function GPG_MAP_MAIL2KEY() {
KEY_ARRAY=($(echo "$str" | awk -F'sec   rsa2048/|2018* [SC]' '{print $2}' | awk '{print $1}'))
# Remove trailing blank: KEY="$(echo -e "${str}" | sed -e 's/[[:space:]]*$//')"
MAIL_ARRAY=($(echo "$str" | awk -F'<|>' '{print $2}'))
#Test if the array count of the emails and the keys are the same to avoid conflicts
if [ ${#KEY_ARRAY[@]} == ${#MAIL_ARRAY[@]} ]; then
   declare -A KEY_MAIL_ARRAY=()
   for i in "${!KEY_ARRAY[@]}"
   do
      KEY_MAIL_ARRAY[${MAIL_ARRAY[$i]}]=${KEY_ARRAY[$i]}
   done
   #Return key matching email passed into function
   echo "${KEY_MAIL_ARRAY[$1]}"
else
   #exit from script if array count of emails and keys are not the same
   exit 1 && fancy_echo "Email count and Key count do not match"
fi
}

function VIRTUALBOX_INSTALL() {
   BREW_CASK_INSTALL "VIRTUALBOX_INSTALL" "virtualbox" "VirtualBox" "brew"
   BREW_CASK_INSTALL "VIRTUALBOX_INSTALL" "vagrant-manager" "Vagrant Manager" "brew"
}

function PYTHON_INSTALL() {
   # Python2 is a pre-requisite for git-cola & GCP installed below.
   # Python3 is a pre-requisite for aws.
   # Because there are two active versions of Pythong (2.7.4 and 3.6 now)...
     # See https://docs.brew.sh/Homebrew-and-Python
   # See https://docs.python-guide.org/en/latest/starting/install3/osx/
   
   BREW_INSTALL "PYTHON_INSTALL" "python" "--version"
      # Python 2.7.14

   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then

      # Not BREW_INSTALL pyenv  # Python environment manager.
	    #brew linkapps python
      # pip comes with Python 2 >=2.7.9 or Python 3 >=3.4
      fancy_echo "$(pip --version)"            >>$LOGFILE
         # pip 9.0.3 from /usr/local/lib/python2.7/site-packages (python 2.7)

      # Define command python as going to version 2.7:
      BASHFILE_EXPORT "python" "/usr/local/bin/python2.7"
   
      # To prevent the older MacOS default python being seen first in PATH ...
      if grep -q "/usr/local/opt/python/libexec/bin" "$BASHFILE" ; then    
         fancy_echo "Python PATH already in $BASHFILE" >>$LOGFILE
      else
         fancy_echo "Adding Python PATH in $BASHFILE..."
         echo "export PATH=\"/usr/local/opt/python/libexec/bin:$PATH\"" >>"$BASHFILE"
      fi

         # Run .bash_profile to have changes take, run $FILEPATH:
         source "$BASHFILE"
         #echo "$PATH"

      # TODO: Python add-ons
      #BREW_INSTALL freetype  # http://www.freetype.org to render fonts
      #BREW_INSTALLopenexr
      #BREW_INSTALLfreeimage
      #BREW_INSTALLgmp
      #fancy_echo "Installing other popular Python helper modules ..."
      #pip install ipython[all]
      #pip install jupyter
      # https://zeppelin.apache.org/ notebooks
      #pip install numpy
      #pip install scipy
      #pip install matplotlib
  fi
   # There is also a Enthought Python Distribution -- www.enthought.com
}


function PYTHON3_INSTALL() {
   fancy_echo "Installing Python3 is a pre-requisite for AWS-CLI"
   # Because there are two active versions of Python (2.7.4 and 3.6 now)...
     # See https://docs.brew.sh/Homebrew-and-Python
   # See https://docs.python-guide.org/en/latest/starting/install3/osx/
   
   BREW_INSTALL "PYTHON3_INSTALL" "python3" "--version"
      # Python 3.6.4
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      echo "$(pip3 --version)"            >>$LOGFILE
      # pip 9.0.3 from /usr/local/lib/python3.6/site-packages (python 3.6)

      if ! python3 -c "import pytz">/dev/null 2>&1 ; then   
         fancy_echo "Installing utility import pytz ..."
         python3 -m pip install pytz  # in /usr/local/lib/python3.6/site-packages
      fi

      # To use anaconda, add the /usr/local/anaconda3/bin directory to your PATH environment 
      # variable, eg (for bash shell):
      # export PATH=/usr/local/anaconda3/bin:"$PATH"
      #brew doctor fails run here due to /usr/local/anaconda3/bin/curl-config, etc.
      #Cask anaconda installs files under "/usr/local". The presence of such
      #files can cause warnings when running "brew doctor", which is considered
      #to be a bug in Homebrew-Cask.

      # NOTE: To make "python" command reach Python3 instead of 2.7, per docs.python-guide.org/en/latest/starting/install3/osx/
      # Put in PATH Python 3.6 bits at /usr/local/bin/ before Python 2.7 bits at /usr/bin/

      # QUESTION: What is the MacOS equivalent to pipe every .py file to anaconda's python:
      # assoc .py=Python.File
      # ftype Python.File=C:\path\to\Anaconda\python.exe "%1" %*
   fi
}


function JAVA_INSTALL() {
   # See https://wilsonmar.github.io/java-on-apple-mac-osx/
   # and http://sourabhbajaj.com/mac-setup/Java/
   if ! command_exists java ; then
      # /usr/bin/java
      fancy_echo "Installing Java, a pre-requisite for Selenium, JMeter, etc. ..."
      # Don't rely on Oracle to install Java properly on your Mac.
      brew tap caskroom/versions
      brew cask install --appdir="/Applications" java8
      # CAUTION: A specific version of JVM needs to be specified because code that use it need to be upgraded.
   fi

   # TODO: Fix 
   TEMP=$(java -version | grep "java version") #| cut -d'=' -f 2 ) # | awk -F= '{ print $2 }'
   JAVA_VERSION=${TEMP#*=};
   echo "JAVA_VERSION=$JAVA_VERSION"
   export JAVA_VERSION=$(java -version)
   echo "JAVA_VERSION=$JAVA_VERSION" >>$LOGFILE
      # java version "1.8.0_144"
      # Java(TM) SE Runtime Environment (build 1.8.0_144-b01)
      # Java HotSpot(TM) 64-Bit Server VM (build 25.144-b01, mixed mode)
   if [ ! -z ${JAVA_HOME+x} ]; then  # variable has NOT been defined already.
      JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"
      #echo "export JAVA_HOME=$(/usr/libexec/java_home -v 9)" >>$BASHFILE
         # /Library/Java/JavaVirtualMachines/jdk1.8.0_162.jdk/Contents/Home is a directory
   fi
      echo "JAVA_INSTALL JAVA_HOME=$JAVA_HOME" >>$LOGFILE

   # https://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash
   if grep -q "JAVA_HOME=" "$BASHFILE" ; then    
      echo "JAVA_INSTALL JAVA_HOME=$JAVA_HOME" >>$LOGFILE
   else 
      echo "export JAVA_HOME=$JAVA_HOME" >>$BASHFILE
   # /Library/Java/JavaVirtualMachines/jdk1.8.0_121.jdk/Contents/Home
   #   echo "export IDEA_JDK=$(/usr/libexec/java_home -v $JAVA_VERSION)" >>$BASHFILE
   #   echo "export RUBYMINE_JDK=$(/usr/libexec/java_home -v $JAVA_VERSION)" >>$BASHFILE
      source $BASHFILE
   fi
   # TODO: https://github.com/alexkaratarakis/gitattributes/blob/master/Java.gitattributes
   # TODO: More plugins from https://jmeter-plugins.org/wiki/Start/
}


function SCALA_INSTALL() {
   # See http://scala-lang.org/install.html and http://sourabhbajaj.com/mac-setup/Scala/README.html
   # There's also brew scala@2.10      scala@2.11  
   BREW_INSTALL "SCALA_INSTALL" "scala" "-version"
       # Scala code runner version 2.12.5 -- Copyright 2002-2018, LAMP/EPFL and Lightbend, Inc.
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      BASHFILE_EXPORT "SCALA_HOME" "/usr/local/opt/scala/libexec"

      # echo '-J-XX:+CMSClassUnloadingEnabled' >> /usr/local/etc/sbtopts
      # echo '-J-Xmx2G' >> /usr/local/etc/sbtopts
      # within Eclipse > Help → Install New Software..., add the Add... button in the dialog.
      # To use with IntelliJ, set the Scala home to: /usr/local/opt/scala/idea

      BREW_INSTALL "SCALA_INSTALL" "sbt" "brew"
      #echo -e "sbt : $(sbt -version)" >>$LOGFILE
     # Getting org.scala-sbt sbt 1.1.4  (this may take some time)...

      if [[ "${TRYOUT,,}" == *"scala"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         fancy_echo "TRYOUT = run program HelloWorld.scala :"
         scala tests/HelloWorld.scala
      fi
   fi
   # https://stackoverflow.com/questions/41110256/how-do-i-tell-intellij-about-scala-installed-with-brew-on-osx
}

function NODE_INSTALL() {
   fancy_echo "In function NODE_INSTALL ..." >>$LOGFILE
   # See https://wilsonmar.github.io/node-starter/
   # http://treehouse.github.io/installation-guides/mac/node-mac.html

   # We begin with NVM to install Node versions: https://www.airpair.com/javascript/node-js-tutorial
   # in order to have several diffent versions of node installed simultaneously.
   # See https://github.com/creationix/nvm
   BASHFILE_EXPORT "NVM_DIR" "$HOME/.nvm"
   if [ ! -d "$HOME/.nvm" ]; then
      fancy_echo "Making $HOME/.nvm folder ..."
      mkdir "$HOME/.nvm"
   fi

   BREW_INSTALL "NODE_INSTALL" "nvm" ""  # node version manager
         # 0.33.8 
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      echo "npx -v : $(npx -v) "  # 9.7.1 https://medium.com/@maybekatz/introducing-npx-an-npm-package-runner-55f7d4bd282b

      if ! command_exists node ; then
         fancy_echo "Installing node using nvm"
         nvm install node  # use nvm to install the latest version of node.
         # v9.10.1...
         nvm install --lts # lastest Long Term Support version  # v8.11.1...
         # nvm install 8.9.4  # install a specific version
      else  
         if [[ "${RUNTYPE,,}" == *"upgrade"* ]]; then
            fancy_echo "node upgrading ..."
            # nvm i nvm  # instead of brew upgrade node
         fi
      fi
      node --version  >>$LOGFILE

      # Run with latest Long Term Stable version:
        # nvm is not compatible with the npm config "prefix" option: currently set to "/usr/local/Cellar/nvm/0.33.8/versions/node/v9.10.1"
      # a) Run with older Long Term Stable version:
#         nvm run 8.11.1 --version
      nvm use --lts >>$LOGFILE # (npm v5.6.0)  
      RESPONSE=$(nvm use --delete-prefix v8.11.1)
      # b) Run with current newest version:
      #RESPONSE=$(nvm use --delete-prefix v9.10.1)

      fancy_echo "RESPONSE=$RESPONSE"
 #     node --version   # v8.11.1 or v9.10.1 
      npm --version >>$LOzzGFILE

      #echo -e "\n  npm list -g --depth=1 --long" >>$LOGFILE
      #echo -e "$(npm list -g --depth=1)" >>$LOGFILE
      # v8.11.1
      # v9.10.1
      # node -> stable (-> v9.10.1) (default)
      # stable -> 9.10 (-> v9.10.1) (default)
      # iojs -> N/A (default)
      # lts/* -> lts/carbon (-> v8.11.1)
      # lts/argon -> v4.9.1 (-> N/A)
      # lts/boron -> v6.14.1 (-> N/A)
      # lts/carbon -> v8.11.1

   # npm start
   # See https://github.com/creationix/howtonode.org by Tim Caswell
   # Look in folder node-test1

   # $NVM_HOME
   # $NODE_ENV 
   fi
}


function GO_INSTALL() {
   BREW_INSTALL "GO_INSTALL" "go" "version"
      if grep -q "golang/bin" "$BASHFILE" ; then    
         fancy_echo "export PATH $GOROOT/bin already in $BASHFILE" >>$LOGFILE
      else
         fancy_echo "Adding PATH to $GOROOT/bin in $BASHFILE..." >>$LOGFILE
         printf "\nexport PATH=\"\$PATH:$GOROOT/bin\" # GOROOT" >>"$BASHFILE"  # from brew info go 
      fi 
      source "$BASHFILE"
   BASHFILE_EXPORT "GOPATH" "$HOME/golang"
   BASHFILE_EXPORT "GOROOT" "/usr/local/opt/go/libexec"
}
if [[ "${TEST_TOOLS,,}" == *"pact-go"* ]] || [[ "$TRYOUT_KEEP" == *"pact-go"* ]]; then
   GO_INSTALL

   # Pact contract testing https://docs.pact.io/ is available in several languages.
   # See https://github.com/pact-foundation/pact-go
   # https://dius.com.au/2016/02/03/microservices-pact/
   PACT_HOME="/usr/local/etc/pact-go" # as if brew'd.
   fancy_echo "TEST_TOOLS pact-go re-creating $PACT_HOME ..." >>$LOGFILE
   if [ ! -d "$PACT_HOME" ]; then
      mkdir "$PACT_HOME"
      echo "TEST_TOOLS pact-go $PACT_HOME created."
   else
#      rm -rf "$PACT_HOME"
#      mkdir "$PACT_HOME"
      echo "TEST_TOOLS pact-go $PACT_HOME re-created."
   fi
   
   PACT_VERSION="v0.0.12" # Extract from webpage:
   PACT_VERSION="pact-version.html"; \
   wget -q "https://github.com/pact-foundation/pact-go/releases" -O $outputFile; \
   cat "$outputFile" | sed -n -e '/<\/header>/,/<\/footer>/ p' | grep "Last stable release:" | sed 's/<\/\?[^>]\+>//g' | awk -F' ' '{ print $4 }'; rm -f $outputFile

   DOWNLOAD_URL="https://github.com/pact-foundation/pact-go/releases/download/$PACT_VERSION/pact-go_darwin_amd64.tar.gz"
   if [ ! -f "$PACT_HOME/pact-go_darwin_amd64.tar.gz" ]; then
      echo "TEST_TOOLS pact-go downloading $DOWNLOAD_URL ..." >>$LOGFILE
      curl -L "$DOWNLOAD_URL" -O "$PACT_HOME/pact-go_darwin_amd64.tar.gz" 2>/dev/null # 10.5MB received.
         # 2>/dev/null to  ignore curl: (3) <url> malformed
      ls "$PACT_HOME"
   fi

   if [ ! -f "$PACT_HOME/pact-go_darwin_amd64.tar.gz" ]; then #downloaded:
      echo "TEST_TOOLS pact-go tar.gz not found."
   else
      echo "TEST_TOOLS pact-go unpacking tar.gz to tar ..."
     #file "$PACT_HOME/pact-go_darwin_amd64.tar.gz" # to see what kind of file it is (redirected?)      
      tar xvf "$PACT_HOME/pact-go_darwin_amd64.tar.gz" -C "$PACT_HOME"
         # creates pact folder
   fi

   if [ ! -d "$PACT_HOME/pact" ]; then # unpacked:
      echo "TEST_TOOLS pact-go pact folder not found."
   else
      echo "TEST_TOOLS pact-go rm tar.gz ..."
      rm "$PACT_HOME/pact-go_darwin_amd64.tar.gz"
   fi

   if [[ "${TRYOUT,,}" == *"pact-go"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
      echo "TEST_TOOLS pact-go TRYOUT ..."

      pushd "$PACT_HOME"
      echo "TEST_TOOLS pact-go st $(pwd) for ./pact-go daemon ..." 
      ./pact-go daemon
      popd

      if [ ! -d "$PACT_HOME" ]; then
         mkdir "$PACT_HOME"
         echo "TEST_TOOLS pact-go $PACT_HOME created."
      else
         rm -rf "$PACT_HOME"
         mkdir "$PACT_HOME"
         echo "TEST_TOOLS pact-go $PACT_HOME re-created."
      fi

      if [ ! -d "$GOPATH/src" ]; then
         mkdir "$GOPATH/src"
         echo "TEST_TOOLS pact-go GOPATH/src created."
      else
         rm -rf "GOPATH/src"
         mkdir "GOPATH/src"
         echo "TEST_TOOLS pact-go GOPATH/src re-created."
      fi

      pushd "$GOPATH/src"
      if [ ! -d "pact-go" ]; then 
         go get github.com/pact-foundation/pact-go 
         #  https://github.com/pact-foundation/pact-go.gif --depth=1
      else
            git fetch  # instead of git pull
            git log ..@{u}
            #git reset --hard HEAD@{1} to go back and discard result of git pull if you don't like it.
           git merge  # Response: Already up to date.
      fi
      cd $GOPATH/src/github.com/pact-foundation/pact-go/examples/
      # go get -d github.com/pact-foundation/pact-go to install the source packages
      
      go test -v -run TestConsumer
      popd  # from GITS_PATH
      echo "TEST_TOOLS pact-go back at $(pwd)" >>$LOGFILE

      if [[ "${TRYOUT_KEEP,,}" == *"pact-go"* ]]; then
         echo "TEST_TOOLS pact-go TRYOUT_KEEP ..."
         pushd "$PACT_HOME"
         echo "At $(pwd) for ./pact-go info" 
         ./pact-go
         # PACT_PORT="6666"
         popd
      else
         fancy_echo "TRYOUT pact-go running $pact-go_HOME/bin/pact-go.sh ..."
      fi
   fi
else
   fancy_echo "TEST_TOOLS pact-go not specified." >>$LOGFILE
fi


if [[ "${TEST_TOOLS,,}" == *"gatling"* ]]; then
   SCALA_INSTALL  # prerequiste - see http://twitter.github.io/scala_school
   # TODO: JDK8_INSTALL Gatling requires JDK8
   BASHFILE_EXPORT "GATLING_HOME" "/usr/local/opt/gatling"
   if [ ! -d "$GATLING_HOME" ]; then
      mkdir "$GATLING_HOME"
   fi

   if [   -d "$GATLING_HOME" ]; then
      # Scrape for download version "2.3.1" from https://gatling.io/download/
      GATLING_VERSION="gatling-version.html"; wget -q "https://gatling.io/download/" -O $outputFile; cat "$outputFile" | sed -n -e '/<\/header>/,/<\/footer>/ p' | grep "Last stable release:" | sed 's/<\/\?[^>]\+>//g' | awk -F' ' '{ print $4 }'; rm -f $outputFile
      fancy_echo "TEST_TOOLS gatling download to $GATLING_VERSION $GATLING_HOME ..."
      DOWNLOAD_URL="gatling-version.html"; wget -q "https://gatling.io/download/" -O $outputFile; cat "$outputFile" | sed -n -e '/<\/header>/,/<\/footer>/ p' | grep "Format:" | sed -n 's/.*href="\([^"]*\).*/\1/p' ; rm -f $outputFile
          #"https://repo1.maven.org/maven2/io/gatling/highcharts/gatling-charts-highcharts-bundle/$GATLING_VERSION/gatling-charts-highcharts-bundle-$GATLING_VERSION-bundle.tar.gz"
      curl "$DOWNLOAD_URL" -o "$GATLING_HOME/gatling.tar.gz"  # 55.3M renamed
      unzip "$GATLING_HOME/gatling.tar.gz"  # to gatling-charts-highcharts-bundle-2.3.1
      rm    "$GATLING_HOME/gatling.tar.gz"
      cd "gatling-charts-highcharts-bundle-$GATLING_VERSION" 
      mv -v * "$GATLING_HOME"  # overwrite all files
      # rsync -u "gatling-charts-highcharts-bundle-$GATLING_VERSION" "$GATLING_HOME" # to skip files newer on the receiver.
         # LICENSE    bin        conf       lib        results    user-files
   else
      if [[ "${RUNTYPE,,}" == *"upgrade"* ]]; then
         fancy_echo "TEST_TOOLS gatling upgrade manually ..."
         #gatling version | grep gatling  # git version 2.16.3 # gatling version 2.2.9
         #brew upgrade gatling 
      fi
   fi

   fancy_echo "TEST_TOOLS gatling ::" >>$LOGFILE
   #echo "$(gatling version)" >>$LOGFILE

   if [[ "${TRYOUT,,}" == *"gatling"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
      fancy_echo "TRYOUT gatling running $GATLING_HOME/bin/gatling.sh ..."
      # TODO: Check for required java version "1.8.0_162"
      #echo "0,\n,\n" | $GATLING_HOME/bin/gatling.sh
         # Choose a simulation number: 0
         # Select simulation id: Enter for basicsimulation
         # \n for Enter to Select Run description

      # TODO: Figure out /usr/local/opt/gatling/results/0-1524357859146/index.html
      # GATLING_RUN="0-1524357859146"
      #open /usr/local/opt/gatling/results/$GATLING_RUN/index.html
   fi
else
   fancy_echo "TEST_TOOLS gatling not specified." >>$LOGFILE
fi


if [[ "${TEST_TOOLS,,}" == *"soapui"* ]]; then
   # https://www.soapui.org/ 
   # TODO: Get version from https://smartbear.com/product/ready-api/soapui/overview/
   VER="SoapUI-5.4.0"
   BREW_CASK_INSTALL "TEST_TOOLS" "soapui" "$VER" "brew"
      # https://s3.amazonaws.com/downloads.eviware/soapuios/5.4.0/SoapUI-5.4.0.dmg
else
   fancy_echo "TEST_TOOLS soapui not specified." >>$LOGFILE
fi


# https://www.protractortest.org/#/



######### Text editors:


# Specified in secrets.sh
          # nano, pico, vim, sublime, code, atom, macvim, textmate, emacs, intellij, sts, eclipse.
          # NOTE: nano and vim are built into MacOS, so no install.
fancy_echo "EDITORS=$EDITORS" >>$LOGFILE
      echo "The last one installed is the Git default." >>$LOGFILE

# INFO: https://danlimerick.wordpress.com/2011/06/12/git-for-windows-tip-setting-an-editor/
# https://insights.stackoverflow.com/survey/2018/#development-environments-and-tools
#    Says vim is the most popular among Sysadmins. 

# Update version that comes with MacOS, which is old, per https://gist.github.com/xuhdev/8b1b16fb802f6870729038ce3789568f
if [[ "${EDITORS,,}" == *"emacs"* ]]; then
   BREW_INSTALL "EDITORS" "emacs --with-cocoa" "--version"
   # See http://zmjones.com/mac-setup/#Emacs to install emacs packages in ~/.emacs.d/
   git config --global core.editor emacs
fi

if [[ "${EDITORS,,}" == *"nano"* ]]; then
   # comes with MacOS
   BREW_INSTALL "EDITORS" "nano" "--version"
   git config --global core.editor nano
fi

# Since TextEdit is the default for displaying logs:
if [[ "${EDITORS,,}" == *"textedit"* ]]; then 
   # No BASH_CASK_INSTALL TextEdit comes with MacOS:
      if grep -q "alias textedit=" "$BASHFILE" ; then    
         fancy_echo "PATH to TextEdit.app already in $BASHFILE" >>$LOGFILE
      else
         fancy_echo "Adding PATH to TextEdit.app in $BASHFILE..."
         echo "alias textedit='open -a \"/Applications/TextEdit.app\"'" >>"$BASHFILE"
      fi 
   git config --global core.editor textedit
else
   fancy_echo "EDITORS textedit not specified." >>$LOGFILE
fi


if [[ "${EDITORS,,}" == *"brackets"* ]]; then
   # Cross-platform code editor for the web, written in JavaScript, HTML and CSS 
   BREW_CASK_INSTALL "EDITORS" "brackets" "Brackets" "brew"
   # NO brackets -v  # version 1.12 on 2018-04-17
   # so cannot git config --global core.editor brackets
else
   fancy_echo "EDITORS brackets not specified." >>$LOGFILE
fi


if [[ "${EDITORS,,}" == *"vim"* ]]; then
   BREW_INSTALL "EDITORS" "vim" "brew"
   git config --global core.editor vim
fi

if [[ "${EDITORS,,}" == *"pico"* ]]; then
   BREW_INSTALL "EDITORS" "pico" "--version"
   git config --global core.editor pico
fi

if [[ "${EDITORS,,}" == *"sublime"* ]]; then
   # /usr/local/bin/subl
   BREW_CASK_INSTALL "EDITORS" "sublime-text" "Sublime Text" "brew"
      # Sublime Text Build 3143

   # one time:
   #sudo ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl

         fancy_echo "Adding PATH to SublimeText in $BASHFILE..."
         # Per https://www.sublimetext.com/docs/3/osx_command_line.html
         # ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ~/bin/subl
         echo "" >>"$BASHFILE"
         echo "export PATH=\"\$PATH:/usr/local/bin/subl\"" >>"$BASHFILE"

      if ! grep -q "export EDITOR=" "$BASHFILE" ; then    
         fancy_echo "Adding EDITOR to SublimeText in $BASHFILE..."
         echo "export EDITOR='subl -w'" >>"$BASHFILE"
      fi
         source "$BASHFILE"

      # Only install the following during initial install:
      # TODO: Configure Sublime for spell checker, etc. https://github.com/SublimeLinter/SublimeLinter-shellcheck
      # install Package Control see https://gist.github.com/patriciogonzalezvivo/77da993b14a48753efda

      # per https://www.sublimetext.com/docs/3/settings.html
      # sed "Packages/User/Preferences.sublime-settings"

      # TODO: Install https://github.com/jisaacks/GitGutter
      # to show 

   if [[ "${TRYOUT,,}" == *"sublime"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
      fancy_echo "EDITORS sublime-text starting ..."
      if ! command_exists subl ; then
         subl &
      else
         open -a "/Applications/Sublime Text.app" &
      fi
   fi
else
   fancy_echo "EDITORS sublime not specified." >>$LOGFILE
fi


if [[ "${EDITORS,,}" == *"code"* ]]; then
   BREW_CASK_INSTALL "EDITORS" "visual-studio-code" "Visual Studio Code" "brew"
    # code --version
      # 1.21.1
      # 79b44aa704ce542d8ca4a3cc44cfca566e7720f1
      # x64
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      git config --global core.editor code

      # https://github.com/timonwong/vscode-shellcheck
      fancy_echo "EDITORS Visual Studio Code Shellcheck extension"
      code --install-extension timonwong.shellcheck
      #fancy_echo "Opening Visual Studio Code ..."
      #open "/Applications/Visual Studio Code.app"
      #fancy_echo "Starting code in background ..."
      #code &

      echo "export EDITOR='code -w'" >>"$BASHFILE"

      # $HOME/Library/Application Support/Code
      if [[ "${TRYOUT,,}" == *"code"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         fancy_echo "EDITORS Visual Studio code starting ..."
         #open -a "/Applications/Code.app" &
         code &
      fi
   fi
else
   fancy_echo "EDITORS code not specified." >>$LOGFILE
fi


if [[ "${EDITORS,,}" == *"atom"* ]]; then
   BREW_CASK_INSTALL "EDITORS" "atom" "Atom" "--version"
   #atom --version
      # Atom    : 1.20.1
      # Electron: 1.6.9
      # Chrome  : 56.0.2924.87
      # Node    : 7.4.0
      # Wilsons-MacBook-Pro
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      git config --global core.editor atom

      # Add plug-in https://github.com/AtomLinter/linter-shellcheck
      # See https://www.youtube.com/watch?v=DjEuROpsvp4 for config packages.
      apm install linter-shellcheck
   fi
else
   fancy_echo "EDITORS atom not specified." >>$LOGFILE
fi


if [[ "${EDITORS,,}" == *"macvim"* ]]; then
   BREW_CASK_INSTALL "EDITORS" "macvim" "MacVim" "brew"
   # git config --global core.editor macvim
else
   fancy_echo "EDITORS macvim not specified." >>$LOGFILE
fi


if [[ "${EDITORS,,}" == *"textmate"* ]]; then
   BREW_CASK_INSTALL "EDITORS" "textmate" "TextMate" "-v"
   # mate -v
      #mate 2.12 (2018-03-08) 
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      # Per https://stackoverflow.com/questions/4011707/how-to-start-textmate-in-command-line
      # Create a symboling link to bin folder
      ln -s /Applications/TextMate.app/Contents/Resources/mate "$HOME/bin/mate"
      BASHFILE_EXPORT "EDITOR" "/usr/local/bin/mate -w"
      git config --global core.editor textmate
   fi
else
   fancy_echo "EDITORS textmate not specified." >>$LOGFILE
fi


if [[ "${EDITORS,,}" == *"textwrangler"* ]]; then
   fancy_echo "NOTE: textwrangler not found in brew search ..."
   echo "Install textwrangler text editor from MacOS App Store ..."
fi


if [[ "${EDITORS,,}" == *"emacs"* ]]; then
   BREW_CASK_INSTALL "EDITORS" "emacs" "Emacs" "--version"
   # /usr/local/bin/emacs:41: warning: Insecure world writable dir /Users/wilsonmar/gits/wilsonmar in PATH, mode 040777
   # GNU Emacs 25.3.1
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      git config --global core.editor emacs
      # Evaluate https://github.com/git/git/tree/master/contrib/emacs
   fi
else
   fancy_echo "EDITORS emacs not specified." >>$LOGFILE
fi


if [[ "${EDITORS,,}" == *"intellij"* ]]; then
    # See http://macappstore.org/intellij-idea-ce/
   BREW_CASK_INSTALL "EDITORS" "intellij-idea-ce" "IntelliJ IDEA CE" "--version"
       # alias idea='open -a "`ls -dt /Applications/IntelliJ\ IDEA*|head -1`"'
        # TODO: Configure intellij text editor using bash shell commands.
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      # See https://emmanuelbernard.com/blog/2017/02/27/start-intellij-idea-command-line/   
      git config --global core.editor idea
   fi
else
   fancy_echo "EDITORS intellij not specified." >>$LOGFILE
fi
# See https://www.jetbrains.com/help/idea/using-git-integration.html

# https://gerrit-review.googlesource.com/Documentation/dev-intellij.html


if [[ "${EDITORS,,}" == *"sts"* ]]; then
    # See http://macappstore.org/sts/
   BREW_CASK_INSTALL "EDITORS" "sts" "STS" "brew"
   # Based on https://emmanuelbernard.com/blog/2017/02/27/start-intellij-idea-command-line/   
   #git config --global core.editor sts
else
   fancy_echo "EDITORS sts not specified." >>$LOGFILE
fi


if [[ "${EDITORS,,}" == *"eclipse"* ]]; then
    # See http://macappstore.org/eclipse-ide/
   BREW_CASK_INSTALL "EDITORS" "eclipse-ide" "Eclipse" "brew" 
   #git config --global core.editor eclipse

   # See http://www.codeaffine.com/gonsole/ = Git Console for the Eclipse IDE (plug-in)
   # https://rherrmann.github.io/gonsole/repository/
   # The plug-in uses JGit, a pure Java implementation of Git, to interact with the repository.
   # TODO: git config --global core.editor eclipse

   #fancy_echo "Opening eclipse in background ..."
   #eclipse &
   # See https://www.cs.colostate.edu/helpdocs/eclipseCommLineArgs.html

   # TODO: http://www.baeldung.com/jacoco for code coverage calculations within Eclipse

   # Add the "clean-sheet" Ergonomic Eclipse Theme for Windows 10 and Mac OS X.
   # http://www.codeaffine.com/2015/11/04/clean-sheet-an-ergonomic-eclipse-theme-for-windows-10/
else
   fancy_echo "EDITORS STS not specified." >>$LOGFILE
fi


if [[ "${EDITORS,,}" == *"webstorm"* ]]; then
   # See http://www.jetbrains.com/webstorm/
   BREW_CASK_INSTALL "EDITORS" "webstorm" "Webstorm" "brew"
else
   fancy_echo "EDITORS webstorm not specified." >>$LOGFILE
fi

if [[ "${EDITORS,,}" == *"android-studio-preview"* ]]; then
   # See https://developer.android.com/studio/preview/index.html
   BREW_CASK_INSTALL "EDITORS" "android-studio-preview" "Android Studio Preview" "brew"
else
   fancy_echo "EDITORS android not specified." >>$LOGFILE
fi

# Other EDITORS: Unity for VR.



######### Git clients:


fancy_echo "GIT_CLIENTS=$GIT_CLIENTS" >>$LOGFILE
echo "The last one installed is set as the Git client." >>$LOGFILE
# See https://www.slant.co/topics/465/~best-git-clients-for-macos
          # git, cola, github, gitkraken, smartgit, sourcetree, tower, magit, gitup. 
          # See https://git-scm.com/download/gui/linux
          # https://www.slant.co/topics/465/~best-git-clients-for-macos

#[core]
#  editor = vim
#  whitespace = fix,-indent-with-non-tab,trailing-space,cr-at-eol
#  excludesfile = ~/.gitignore
#[push]
#  default = matching

#[diff]
#  tool = vimdiff
#[difftool]
#  prompt = false

if [[ "${GIT_CLIENTS,,}" == *"cola"* ]]; then
   # https://git-cola.github.io/  (written in Python)
   # https://medium.com/@hamen/installing-git-cola-on-osx-eaa9368b4ee
   BREW_INSTALL "GIT_CLIENTS" "git-cola" "--version"
      # cola version 3.0
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      if [[ "${TRYOUT,,}" == *"cola"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         fancy_echo "Starting git-cola in background ..."
         git-cola &
      fi
   fi
fi


# GitHub Desktop is written by GitHub, Inc.,
# open sourced at https://github.com/desktop/desktop
# so people can just click a button on GitHub to download a repo from an internet browser.
if [[ "${GIT_CLIENTS,,}" == *"github"* ]]; then
    # https://desktop.github.com/
   BREW_CASK_INSTALL "GIT_CLIENTS" "github" "GitHub Desktop" "brew"
else
   fancy_echo "GIT_CLIENTS github not specified." >>$LOGFILE
fi


if [[ "${GIT_CLIENTS,,}" == *"gitkraken"* ]]; then
   # GitKraken from https://www.gitkraken.com/ and https://blog.axosoft.com/gitflow/
   BREW_CASK_INSTALL "EDITORS" "gitkraken" "GitKraken" "brew"
else
   fancy_echo "GIT_CLIENTS gitkraken not specified." >>$LOGFILE
fi


if [[ "${GIT_CLIENTS,,}" == *"sourcetree"* ]]; then
    # See https://www.sourcetreeapp.com/
   BREW_CASK_INSTALL "EDITORS" "sourcetree" "Sourcetree" "brew"
else
   fancy_echo "GIT_CLIENTS sourcetree not specified." >>$LOGFILE
fi


if [[ "${GIT_CLIENTS,,}" == *"smartgit"* ]]; then
    # SmartGit from https://syntevo.com/smartgit
   BREW_CASK_INSTALL "EDITORS" "smartgit" "SmartGit" "brew"
else
   fancy_echo "GIT_CLIENTS smartgit not specified." >>$LOGFILE
fi


if [[ "${GIT_CLIENTS,,}" == *"tower"* ]]; then
    # Tower from https://www.git-tower.com/learn/git/ebook/en/desktop-gui/advanced-topics/git-flow
   BREW_CASK_INSTALL "EDITORS" "tower" "Tower" "brew"
else
   fancy_echo "GIT_CLIENTS tower not specified." >>$LOGFILE
fi


if [[ "${GIT_CLIENTS,,}" == *"magit"* ]]; then
    # See https://www.slant.co/topics/465/viewpoints/18/~best-git-clients-for-macos~macvim
    #     "Useful only for people who use Emacs text editor."

    # https://magit.vc/manual/magit/
   BREW_INSTALL "GIT_CLIENTS" "magit" "brew"
      # TODO: magit -v
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      if [[ "${TRYOUT,,}" == *"magit"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         fancy_echo "ERROR: Cannot Start magit in background ..." >>$LOGFILE
         #emacs magit & 
      fi
   fi
else
   fancy_echo "GIT_CLIENTS magit not specified." >>$LOGFILE
fi


if [[ "${GIT_CLIENTS,,}" == *"gitup"* ]]; then
   # http://gitup.co/
   # https://github.com/git-up/GitUp
   # https://gitup.vc/manual/gitup/
   BREW_CASK_INSTALL "GIT_CLIENTS" "gitup" "GitUp" "brew"
      # https://s3-us-west-2.amazonaws.com/gitup-builds/stable/GitUp.tar.gz
#   if [[ "${TRYOUT,,}" == *"gitup"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
#      fancy_echo "Starting GitUp in background ..." >>$LOGFILE
#      gitup &
#   fi
else
   fancy_echo "GIT_CLIENTS gitup not specified." >>$LOGFILE
fi


######### Git web browser setting:


# Install browser using Homebrew to display GitHub to paste SSH key at the end.
fancy_echo "BROWSERS=$BROWSERS" >>$LOGFILE
      echo "The last one installed is set as the Git browser." >>$LOGFILE

if [[ "${BROWSERS,,}" == *"safari"* ]]; then
   if ! command_exists safari ; then
      fancy_echo "No install needed on MacOS for BROWSERS=\"safari\"."
      # /usr/bin/safaridriver
   else
      fancy_echo "No upgrade on MacOS for BROWSERS=\"safari\"."
   fi
   git config --global web.browser safari

   #fancy_echo "Opening safari ..."
   #safari
fi


if [[ "${BROWSERS,,}" == *"brave"* ]]; then
   # brave is more respectful of user data.
   BREW_CASK_INSTALL "EDITORS" "brave" "Brave" "brew"
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      git config --global web.browser brave
   fi
else
   fancy_echo "BROWSERS brave not specified." >>$LOGFILE
fi


# See Complications at
# https://stackoverflow.com/questions/19907152/how-to-set-google-chrome-as-git-default-browser

# [web]
# browser = google-chrome
#[browser "chrome"]
#    cmd = C:/Program Files (x86)/Google/Chrome/Application/chrome.exe
#    path = C:/Program Files (x86)/Google/Chrome/Application/

if [[ "${BROWSERS,,}" == *"chrome"* ]]; then
   # google-chrome is the most tested and popular.
   BREW_CASK_INSTALL "BROWSERS" "chrome" "Google Chome" "brew"
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      git config --global web.browser google-chrome
   fi
else
   fancy_echo "BROWSERS chrome not specified." >>$LOGFILE
fi


if [[ "${BROWSERS,,}" == *"firefox"* ]]; then
   # firefox is more respectful of user data.
   BREW_CASK_INSTALL "BROWSERS" "firefox" "Firefox" "brew"
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      git config --global web.browser firefox
   fi
else
   fancy_echo "BROWSERS firefox not specified." >>$LOGFILE
fi

# Other alternatives listed at https://git-scm.com/docs/git-web--browse.html

   # BREW_INSTALL links

   #git config --global web.browser cygstart
   #git config --global browser.cygstart.cmd cygstart


######### Diff/merge tools:


# Based on https://gist.github.com/tony4d/3454372 
fancy_echo "Configuring to enable git mergetool..." >>$LOGFILE
if [[ "$GITCONFIG" = *"[difftool]"* ]]; then  # contains text.
   fancy_echo "[difftool] p4merge already in $GITCONFIG" >>$LOGFILE
else
   fancy_echo "Adding [difftool] p4merge in $GITCONFIG..." >>$LOGFILE
   git config --global merge.tool p4mergetool
   git config --global mergetool.p4mergetool.cmd "/Applications/p4merge.app/Contents/Resources/launchp4merge \$PWD/\$BASE \$PWD/\$REMOTE \$PWD/\$LOCAL \$PWD/\$MERGED"
   # false = prompting:
   git config --global mergetool.p4mergetool.trustExitCode false
   git config --global mergetool.keepBackup true

   git config --global diff.tool p4mergetool
   git config --global difftool.prompt false
   git config --global difftool.p4mergetool.cmd "/Applications/p4merge.app/Contents/Resources/launchp4merge \$LOCAL \$REMOTE"

   # Auto-type in "adduid":
   # gpg --edit-key "$KEY" answer adduid"
   # NOTE: By using git config command, repeated invocation would not duplicate lines.

   # git mergetool
   # You will be prompted to run "p4mergetool", hit enter and the visual merge editor will launch.

   # See https://danlimerick.wordpress.com/2011/06/19/git-for-window-tip-use-p4merge-as-mergetool/
   # git difftool
fi


######### Local Linter services:


# This Bash file was run through online at https://www.shellcheck.net/
# See https://github.com/koalaman/shellcheck#user-content-in-your-editor

# To ignore/override an error identified:
# shellcheck disable=SC1091
#BREW_INSTALL shellcheck

# This enables Git hooks to run on pre-commit to check Bash scripts being committed.


######### Git tig repo viewer:


if [[ "${GIT_TOOLS,,}" == *"git-gerrit"* ]]; then
   # https://gerrit-releases.storage.googleapis.com/index.html
   JAVA_INSTALL  # pre-requisite
   BREW_INSTALL "GIT_TOOLS" "git-gerrit" "brew"
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      if [[ "${TRYOUT,,}" == *"git-gerrit"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         fancy_echo "Cannot Start git-gerrit in background ..." >>$LOGFILE
         git-gerrit & 
      fi
   fi
else
   fancy_echo "GIT_TOOLS git-gerrit not specified." >>$LOGFILE
fi


######### Git tig repo viewer:


if [[ "${GIT_TOOLS,,}" == *"tig"* ]]; then
   BREW_INSTALL "GIT_TOOLS" "tig" ""
     # tig version 2.3.3

      # See https://jonas.github.io/tig/
      # A sample of the default configuration has been installed to:
      #   /usr/local/opt/tig/share/tig/examples/tigrc
      # to override the system-wide default configuration, copy the sample to:
      #   /usr/local/etc/tigrc
      # Bash completion has been installed to:
      #   /usr/local/etc/bash_completion.d
else
   fancy_echo "GIT_TOOLS tig not specified." >>$LOGFILE
fi


######### BFG to identify and remove passwords and large or troublesome blobs.


# See https://rtyley.github.io/bfg-repo-cleaner/ 

# Install sub-folder under git-utilities:
# git clone https://github.com/rtyley/bfg-repo-cleaner --depth=0

#git clone --mirror $WORK_REPO  # = git://example.com/some-big-repo.git

#JAVA_INSTALL

#java -jar bfg.jar --replace-text banned.txt \
#    --strip-blobs-bigger-than 100M \
#    $SECRETSFILE


######### Git Large File Storage:


# Git Large File Storage (LFS) replaces large files such as audio samples, videos, datasets, and graphics with text pointers inside Git, while storing the file contents on a remote server like GitHub.com or GitHub Enterprise. During install .gitattributes are defined.
# See https://git-lfs.github.com/
# See https://help.github.com/articles/collaboration-with-git-large-file-storage/
# https://www.atlassian.com/git/tutorials/git-lfs
# https://www.youtube.com/watch?v=p3Pse1UkEhI

if [[ "${GIT_TOOLS,,}" == *"lfs"* ]]; then
   BREW_INSTALL "GIT_TOOLS" "git" "brew"
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      echo "$(git-lfs version)" >>$LOGFILE
      # git-lfs/2.4.0 (GitHub; darwin amd64; go 1.10)

      # Update global git config (creates hooks pre-push, post-checkout, post-commit, post-merge)
      #  git lfs install

      # Update system git config:
      #  git lfs install --system

      # See https://help.github.com/articles/configuring-git-large-file-storage/
      # Set LFS to kick into action based on file name extensions such as *.psd by
      # running command:  (See https://git-scm.com/docs/gitattributes)
      # git lfs track "*.psd"
      #    The command appends to the repository's .gitattributes file:
      # *.psd filter=lfs diff=lfs merge=lfs -text

      #  git lfs track "*.mp4"
      #  git lfs track "*.mp3"
      #  git lfs track "*.jpeg"
      #  git lfs track "*.jpg"
      #  git lfs track "*.png"
      #  git lfs track "*.ogg"
      # CAUTION: Quotes are important in the entries above.
      # CAUTION: Git clients need to be LFS-aware.

      # Based on https://github.com/git-lfs/git-lfs/issues/1720
      git config lfs.transfer.maxretries 10

      # Define alias to stop lfs
      #git config --global alias.plfs "\!git -c filter.lfs.smudge= -c filter.lfs.required=false pull && git lfs pull"
      #$ git plfs
   fi
else
   fancy_echo "GIT_TOOLS lfs not specified." >>$LOGFILE
fi


######### TODO: .gitattributes


# See https://github.com/alexkaratarakis/gitattributes for templates
# Make sure .gitattributes is tracked
# git add .gitattributes
# TODO: https://github.com/alexkaratarakis/gitattributes/blob/master/Common.gitattributes



######### ~/.gitconfig [user] and [core] settings:


# ~/.gitconfig file contain this examples:
#[user]
#	name = Wilson Mar
#	id = WilsonMar+GitHub@gmail.com
#	email = wilsonmar+github@gmail.com

   fancy_echo "Adding [user] info in in $GITCONFIG ..." >>$LOGFILE
   git config --global user.name     "$GIT_NAME"
   git config --global user.email    "$GIT_EMAIL"
   git config --global user.id       "$GIT_ID"
   git config --global user.username "$GIT_USERNAME"



######### ~/.gitignore settings:


#[core]
#	# Use custom `.gitignore`
#	excludesfile = ~/.gitignore
#   hitespace = space-before-tab,indent-with-non-tab,trailing-space

GITIGNORE_PATH="$HOME/.gitignore_global"
if [ ! -f $GITIGNORE_PATH ]; then 
   fancy_echo "Copy to $GITIGNORE_PATH."
   cp ".gitignore_global" $GITIGNORE_PATH

   git config --global core.excludesfile "$GITIGNORE_PATH"
   # Treat spaces before tabs, lines that are indented with 8 or more spaces, and all kinds of trailing whitespace as an error
   git config --global core.hitespace "space-before-tab,indent-with-non-tab,trailing-space"
fi



######### Git coloring in .gitconfig:


# If git config color.ui returns true, skip:
git config color.ui | grep 'true' &> /dev/null
if [ $? == 0 ]; then
   fancy_echo "git config --global color.ui already true (on)." >>$LOGFILE
else # false or blank response:
   fancy_echo "Setting git config --global color.ui true (on)..."
   git config --global color.ui true
fi

#[color]
#	ui = true

if grep -q "color.status=auto" "$GITCONFIG" ; then    
   fancy_echo "color.status=auto already in $GITCONFIG" >>$LOGFILE
else
   fancy_echo "Adding color.status=auto in $GITCONFIG..." >>$LOGFILE
   git config --global color.status auto
   git config --global color.branch auto
   git config --global color.interactive auto
   git config --global color.diff auto
   git config --global color.pager true

   # normal, black, red, green, yellow, blue, magenta, cyan, white
   # Attributes: bold, dim, ul, blink, reverse, italic, strike
   git config --global color.status.added     "green   normal bold"
   git config --global color.status.changed   "blue    normal bold"
   git config --global color.status.header    "white   normal dim"
   git config --global color.status.untracked "cyan    normal bold"

   git config --global color.branch.current   "yellow  reverse"
   git config --global color.branch.local     "yellow  normal bold"
   git config --global color.branch.remote    "cyan    normal dim"

   git config --global color.diff.meta        "yellow  normal bold"
   git config --global color.diff.frag        "magenta normal bold"
   git config --global color.diff.old         "blue    normal strike"
   git config --global color.diff.new         "green   normal bold"
   git config --global color.diff.whitespace  "red     normal reverse"
fi


######### diff-so-fancy color:


if [[ "${GIT_TOOLS,,}" == *"diff-so-fancy"* ]]; then
   BREW_INSTALL "GIT_TOOLS" "diff-so-fancy" "brew"
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then

      # Configuring based on https://github.com/so-fancy/diff-so-fancy
      git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"

      # Default Git colors are not optimal. We suggest the following colors instead.
      git config --global color.diff-highlight.oldNormal    "red bold"
      git config --global color.diff-highlight.oldHighlight "red bold 52"
      git config --global color.diff-highlight.newNormal    "green bold"
      git config --global color.diff-highlight.newHighlight "green bold 22"

      git config --global color.diff.meta       "yellow"
      git config --global color.diff.frag       "magenta bold"
      git config --global color.diff.commit     "yellow bold"
      git config --global color.diff.old        "red bold"
      git config --global color.diff.new        "green bold"
      git config --global color.diff.whitespace "red reverse"

      # Should the first block of an empty line be colored. (Default: true)
      git config --bool --global diff-so-fancy.markEmptyLines false

      # Simplify git header chunks to a more human readable format. (Default: true)
      git config --bool --global diff-so-fancy.changeHunkIndicators false

      # stripLeadingSymbols - Should the pesky + or - at line-start be removed. (Default: true)
      git config --bool --global diff-so-fancy.stripLeadingSymbols false

      # useUnicodeRuler By default the separator for the file header uses Unicode line drawing characters. If this is causing output errors on your terminal set this to false to use ASCII characters instead. (Default: true)
      git config --bool --global diff-so-fancy.useUnicodeRuler false

      # To bypass diff-so-fancy. Use --no-pager for that:
      #git --no-pager diff
   fi
else
   fancy_echo "GIT_TOOLS diff-so-fancy not specified." >>$LOGFILE
fi



######### Reuse Recorded Resolution of conflicted merges


if [[ "${GIT_TOOLS,,}" == *"rerere"* ]]; then
   # See https://git-scm.com/docs/git-rerere
   # and https://git-scm.com/book/en/v2/Git-Tools-Rerere

   #[rerere]
   #  enabled = 1
   #  autoupdate = 1
   git config --global rerere.enabled  "1"
   git config --global rerere.autoupdate  "1"
fi


######### ~/.bash_profile prompt settings:


# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
# See http://maximomussini.com/posts/bash-git-prompt/

if [[ "${GIT_TOOLS,,}" == *"bash-git-prompt"* ]]; then
   # From https://github.com/magicmonty/bash-git-prompt
   BREW_INSTALL "GIT_TOOLS" "bash-git-prompt" "brew"
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      if grep -q "gitprompt.sh" "$BASHFILE" ; then    
         fancy_echo "gitprompt.sh already in $BASHFILE"
      else
         fancy_echo "Adding gitprompt.sh in $BASHFILE..."
         echo "if [ -f \"/usr/local/opt/bash-git-prompt/share/gitprompt.sh\" ]; then" >>"$BASHFILE"
         echo "   __GIT_PROMPT_DIR=\"/usr/local/opt/bash-git-prompt/share\" " >>"$BASHFILE"
         echo "   source \"/usr/local/opt/bash-git-prompt/share/gitprompt.sh\" " >>"$BASHFILE"
         echo "fi" >>"$BASHFILE"
      fi
   fi
else
   fancy_echo "GIT_TOOLS bash-git-prompt not specified." >>$LOGFILE
fi

######### bash colors:


BASHFILE_EXPORT "CLICOLOR" "1"


######### Git command completion in ~/.bash_profile:


# So you can type "git st" and press Tab to complete as "git status".
# See video on this: https://www.youtube.com/watch?v=VI07ouVS5FE
# If git-completion.bash file is already in home folder, download it:
FILE=.git-completion.bash
FILEPATH="$HOME/.git-completion.bash"
# If git-completion.bash file is mentioned in  ~/.bash_profile, add it:
if [ -f $FILEPATH ]; then 
   fancy_echo "List file to confirm size:" >>$LOGFILE
   ls -al $FILEPATH >>$LOGFILE
      # -rw-r--r--  1 wilsonmar  staff  68619 Mar 21 10:31 /Users/wilsonmar/.git-completion.bash
else
   fancy_echo "Download in home directory the file maintained by git people:"
   curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o $FILEPATH
   # alt # cp $FILE  ~/$FILEPATH
fi

# if internet download fails, use saved copy in GitHub repo:
if [ ! -f $FILEPATH ]; then 
   fancy_echo "Copy file saved in GitHub repo:"
   cp $FILE  $FILEPATH
fi

# show first line of file:
# line=$(read -r FIRSTLINE < ~/.git-completion.bash )


######### Git alias keys


# If git-completion.bash file is not already in  ~/.bash_profile, add it:
if grep -q "$FILEPATH" "$BASHFILE" ; then    
   fancy_echo "$FILEPATH already in $BASHFILE" >>$LOGFILE
else
   fancy_echo "Adding code for $FILEPATH in $BASHFILE..."
   echo "# Added by $0 ::" >>"$BASHFILE"
   echo "if [ -f $FILEPATH ]; then" >>"$BASHFILE"
   echo "   . $FILEPATH" >>"$BASHFILE"
   echo "fi" >>"$BASHFILE"
   cat $FILEPATH >>"$BASHFILE"
fi 

# Run .bash_profile to have changes above take:
   source "$BASHFILE"


######### Difference engine p4merge:


if [[ "${GIT_TOOLS,,}" == *"p4merge"* ]]; then
   # See https://www.perforce.com/products/helix-core-apps/merge-diff-tool-p4merge
   if grep -q "alias p4merge=" "$BASHFILE" ; then    
      fancy_echo "GIT_TOOLS p4merge alias already in $BASHFILE" >>$LOGFILE
   else
      fancy_echo "GIT_TOOLS p4merge alias in $BASHFILE..."
      echo "alias p4merge='/Applications/p4merge.app/Contents/MacOS/p4merge'" >>"$BASHFILE"
   fi 
   BREW_CASK_INSTALL "GIT_TOOLS" "p4merge" "p4merge" "brew"
else
   fancy_echo "GIT_TOOLS p4merge not specified." >>$LOGFILE
fi

# TODO: Different diff/merge engines


######### Git Repository:

  
   git config --global github.user   "$GITHUB_ACCOUNT"
   git config --global github.token  token

# https://github.com/
# https://gitlab.com/
# https://bitbucket.org/
# https://travis-ci.org/


######### TODO: Git Flow helper:


if [[ "${GIT_TOOLS,,}" == *"git-flow"* ]]; then
   # GitFlow is a branching model for scaling collaboration using Git, created by Vincent Driessen. 
   # See https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow
   # See https://datasift.github.io/gitflow/IntroducingGitFlow.html
   # https://danielkummer.github.io/git-flow-cheatsheet/
   # https://github.com/nvie/gitflow
   # https://vimeo.com/16018419
   # https://buildamodule.com/video/change-management-and-version-control-deploying-releases-features-and-fixes-with-git-how-to-use-a-scalable-git-branching-model-called-gitflow

   # Per https://github.com/nvie/gitflow/wiki/Mac-OS-X
   BREW_INSTALL "GIT_TOOLS" "git-flow" "brew"

   #[gitflow "prefix"]
   #  feature = feature-
   #  release = release-
   #  hotfix = hotfix-
   #  support = support-
   #  versiontag = v

   #git clone --recursive git@github.com:<username>/gitflow.git
   #cd gitflow
   #git branch master origin/master
   #git flow init -d
   #git flow feature start <your feature>
else
   fancy_echo "GIT_TOOLS git-flow not specified." >>$LOGFILE
fi


######### git local hooks 


if [[ "${GIT_TOOLS,,}" == *"hooks"* ]]; then
   # # TODO: Install link per https://wilsonmar.github.io/git-hooks/
   if [ ! -f ".git/hooks/git-commit" ]; then 
      fancy_echo "git-commit file not found in .git/hooks. Copying hooks folder ..."
      rm .git/hooks/*.sample  # samples are not run
      cp hooks/* .git/hooks   # copy
      chmod +x .git/hooks/*   # make executable
   else
      fancy_echo "git-commit file found in .git/hooks. Skipping ..."
   fi

   if [[ "${TRYOUT,,}" == *"hooks"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
      if [[ "${LANG_TOOLS,,}" == *"python"* ]]; then  # contains azure.
         PYTHON_PGM="hooks/basic-python2"
         if [[ "${TRYOUT,,}" == *"cleanup"* ]]; then
            fancy_echo "$PYTHON_PGM TRYOUT == cleanup ..."
            python "hooks/$PYTHON_PGM"  # run
            rm -rf $PYTHON_PGM
         fi
      fi

      if [[ "${LANG_TOOLS,,}" == *"python3"* ]]; then  # contains azure.
         PYTHON_PGM="hooks/basic-python3"
         if [[ "${TRYOUT,,}" == *"cleanup"* ]]; then
            fancy_echo "$PYTHON_PGM TRYOUT == cleanup ..."
            python3 "hooks/$PYTHON_PGM"  # run
            rm -rf $PYTHON_PGM
         fi
      fi
   fi
else
   fancy_echo "GIT_TOOLS hooks not specified." >>$LOGFILE
fi
# Thanks to ShingLyu.github.io for support on Python Selenium scripting.


######### DATA_TOOLS :: 


function REDIS_INSTALL() {
      # http://redis.io/
   BREW_INSTALL "GIT_TOOLS" "redis" "brew"
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      fancy_echo "$(redis-cli --version)" >>$LOGFILE  # redis-cli 4.0.9

      if [[ "${RUNTYPE,,}" == *"remove"* ]]; then
         rm ~/Library/LaunchAgents/homebrew.mxcl.redis.plist
      fi

      echo "DATA_TOOLS redis config ..."
      if [ ! -z "$REDIS_PORT" ]; then # fall-back if not set in secrets.sh:
         REDIS_PORT="6379"  # default
      fi
      if grep -q "port 6379" "/usr/local/etc/redis.conf" ; then    
         sed -i "s/port 6379/port $REDIS_PORT/g" /usr/local/etc/redis.conf
      fi
      #ULIMIT_SET
   fi
}
if [[ "${DATA_TOOLS,,}" == *"redis"* ]] || [[ "$TRYOUT_KEEP" == *"redis"* ]]; then
   REDIS_INSTALL
   if [[ "${TRYOUT,,}" == *"redis"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
      if grep -q "$(redis-cli ping)" "PONG" ; then    
         echo "DATA_TOOLS redis started ..."
         # but connection may be terminated.
      else
         echo "DATA_TOOLS redis starting in background ..."
         /usr/local/opt/redis/bin/redis-server /usr/local/etc/redis.conf &
         open "http://localhost:$REDIS_PORT/"
      fi
   else
      fancy_echo "DATA_TOOLS redis TRYOUT not specified." >>$LOGFILE
   fi

   if [[ "$TRYOUT_KEEP" != *"redis"* ]]; then # not specified, so it's gone:
      echo "DATA_TOOLS redis stopping ..." >>$LOGFILE
      redis-cli shutdown
   else
      PID="$(ps x | grep -m1 '/redis-server' | grep -v "grep" | awk '{print $1}')"
      echo "DATA_TOOLS redis still running on PID=$PID." >>$LOGFILE
      # redis-cli --help
         # Usage: redis { console | start | stop | restart | status | version }
   fi
else
   fancy_echo "DATA_TOOLS redis not specified." >>$LOGFILE
fi


function REDIS_INSTALL() {
      # http://redis.io/
   BREW_INSTALL "REDIS_INSTALL" "redis" "redis-cli --version"
   if [[ "${RUNTYPE,,}" == *"remove"* ]]; then
      rm ~/Library/LaunchAgents/homebrew.mxcl.redis.
   else
      echo "DATA_TOOLS redis config ..."

      if [ ! -z "$REDIS_PORT" ]; then # fall-back if not set in secrets.sh:
         REDIS_PORT="6379"  # default
      fi
      if grep -q "port 6379" "/usr/local/etc/redis.conf" ; then    
         sed -i "s/port 6379/port $REDIS_PORT/g" /usr/local/etc/redis.conf
      fi
      #ULIMIT_SET
   fi
}
if [[ "${DATA_TOOLS,,}" == *"redis"* ]]; then
   REDIS_INSTALL
   # TODO: If successful
   if [[ "${TRYOUT,,}" == *"redis"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
      if grep -q "$(redis-cli ping)" "PONG" ; then    
         echo "DATA_TOOLS redis started ..."
         # but connection may be terminated.
      else
         echo "DATA_TOOLS redis starting in background ..."
         /usr/local/opt/redis/bin/redis-server /usr/local/etc/redis.conf &
         open "http://localhost:$REDIS_PORT/"
      fi
   else
      fancy_echo "DATA_TOOLS redis TRYOUT not specified." >>$LOGFILE
   fi

   if [[ "$TRYOUT_KEEP" != *"redis"* ]]; then # not specified, so it's gone:
      echo "DATA_TOOLS redis stopping ..." >>$LOGFILE
      redis-cli shutdown
   else
      PID="$(ps x | grep -m1 '/redis-server' | grep -v "grep" | awk '{print $1}')"
      echo "DATA_TOOLS redis still running on PID=$PID." >>$LOGFILE
      # redis-cli --help
         # Usage: redis { console | start | stop | restart | status | version }
   fi
else
   fancy_echo "DATA_TOOLS redis not specified." >>$LOGFILE
fi


function POSTGRESQL_INSTALL() {

   # https://www.postgresql.org/download/macosx/  from EnterpriseDB
   # http://formulae.brew.sh/formula/postgresql
   BREW_INSTALL "POSTGRESQL_INSTALL" "postgresql" "pg-ctl --version"
   if [[ "${RUNTYPE,,}" == *"remove"* ]]; then
      rm -rf /usr/local/var/postgres
      rm -rf /usr/local/share/postgresql
   else
      # fancy_echo "$(brew info postgresql | grep "postgresql:")" >>$LOGFILE 
      # postgresql: stable 10.3 (bottled), HEAD
      fancy_echo "DATA_TOOLS postgresql $(pg_ctl --version)" >>$LOGFILE  # pg_ctl (PostgreSQL) 10.3
      # psql --version  # psql (PostgreSQL) 10.3

      # symlinked from /usr/local/Cellar/postgresql/10.3/share/postgresql/postgresql.conf.sample
      FOLDER="/usr/local/var/postgres/" # (/etc/postgresql/9.3/main on Linux)
         # /usr/local/share/postgresql/
         # /var/lib/postgresql/data/postgresql.conf within Docker

      if [ ! -d "$FOLDER" ]; then
         fancy_echo "POSTGRESQL_INSTALL: initdb (directory structure) ..."
         initdb $FOLDER
      fi

      # Do this to avoid server reboot:
      # See https://stackoverflow.com/questions/38466190/cant-connect-to-postgresql-on-port-5432
      if [ ! -z "$POSTGRESQL_PORT" ]; then # fall-back if not set in secrets.sh:
         POSTGRESQL_PORT="5432"  # default
      fi

      if [ ! -f "$FOLDER/postgresql.conf" ]; then
         fancy_echo "POSTGRESQL_INSTALL: postgresql.conf in $FOLDER ..."
         # cp "$FOLDER/postgresql.conf.sample"  "$FOLDER/postgresql.conf"
         sed -i "s/#listen_addresses = 'localhost'/listen_addresses = 'localhost'/" "$FOLDER/postgresql.conf"
         sed -i "s/#port = 5432/port = $POSTGRESQL_PORT/g" "$FOLDER/postgresql.conf"
      fi
   
      #   if [ ! -f "$FOLDER/pg_hba.conf" ]; then
      #      fancy_echo "POSTGRESQL_INSTALL: pg_hba.conf ..." # Client Authentication Configuration
            # cp "$FOLDER/pg_hba.conf.sample"  "$FOLDER/pg_hba.conf"
           # TODO: edit pg_hba.conf from port 32
      #   fi

      # createdb  # https://www.postgresql.org/docs/9.5/static/app-createdb.html
   fi
}
if [[ "${DATA_TOOLS,,}" == *"postgresql"* ]] || [[ "$TRYOUT_KEEP" == *"postgresql"* ]]; then
   POSTGRESQL_INSTALL  # using POSTGRESQL_PORT from secrets.sh
   # TODO: If successful
   if [[ "${TRYOUT,,}" == *"postgresql"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then

      if [ -f "$FOLDER/postmaster.pid" ]; then
         fancy_echo "DATA_TOOLS postgresql removing postmaster.pid leftover from previous run ..."
         rm "$FOLDER/postmaster.pid" 
         rm "$FOLDER/postmaster.opts" 
      fi

      PID="$(ps x | grep -m1 '/postgresql' | grep -v "grep" | awk '{print $1}')"
      if [ ! -z "$PID" ]; then  # a process is NOT found running
         fancy_echo "DATA_TOOLS postgresql already running PID=$PID ..."
      else
         fancy_echo "DATA_TOOLS postgresql starting ..."
         pg_ctl -D "$FOLDER" -l "$HOME/postgresql.$LOG_DATETIME.log" start
            # listening on IPv4 address "127.0.0.1", port 5432 default port $POSTGRESQL_PORT
            # listening on Unix socket "/tmp/.s.PGSQL.5432"
         PID="$(ps x | grep -m1 '$/postgresql' | grep -v "grep" | awk '{print $1}')"
         echo "DATA_TOOLS: postgresql running PID=$PID ..." 
      fi

      echo "DATA_TOOLS: postgresql started files in $FOLDER ..." >>$LOGFILE
      ls -al "$FOLDER" >>$LOGFILE

      # TODO: ssh "http://localhost:127.0.0.1:$POSTGRESQL_PORT"
      # superuser (usually postgres) 

      # Additionally, https://www.codementor.io/engineerapart/getting-started-with-postgresql-on-mac-osx-are8jcopb#iv-popular-guis-for-postgresql-on-macosx
      # install https://eggerapps.at/postico/ - modern
      # https://www.pgadmin.org/ - the oldest, since 1996
      # https://www.navicat.com/products/navicat-for-postgresql - enterprise $200
      # PSequel 

      # Enter psql command line to:
      # createuser
   else
      fancy_echo "DATA_TOOLS postgresql TRYOUT not specified." >>$LOGFILE
   fi

   if [[ "$TRYOUT_KEEP" != *"postgresql"* ]]; then # not specified, so it's gone:
      echo "DATA_TOOLS postgresql stopping ..." >>$LOGFILE
      pg_ctl -D "$FOLDER" stop -s -m fast
   else
      echo "DATA_TOOLS postgresql still running on PID=$PID." >>$LOGFILE
      pg_ctl --help
   fi
else
   fancy_echo "DATA_TOOLS postgresql not specified." >>$LOGFILE
fi


function MONGODB_INSTALL() {
   # https://docs.mongodb.com/manual/tutorial/install-mongodb-on-os-x/
   # https://resources.mongodb.com/getting-started-with-mongodb?jmp=nav&_ga=2.127956172.1397263068.1523600765-730663662.1523600765
   # Based on https://treehouse.github.io/installation-guides/mac/mongo-mac.html

   BREW_INSTALL "MONGODB_INSTALL" "mongodb" "--version"
      # mongodb@3.0, mongodb@3.2, mongodb@3.4, mongodb@10.0, mongodb@10.1, mongodb-connector-odbc 
      # linked: /usr/local/Cellar/mongodb/3.6.3
   #fancy_echo "MONGODB_INSTALL: $(mongo --version | grep "MongoDB shell")" >>$LOGFILE 
      # MongoDB shell version 3.6.3
      FILE="$HOME/Library/LaunchAgents/homebrew.mxcl.mongodb.plist"
      if [ ! -f "$FILE" ]; then #  NOT found, so add it
         fancy_echo "MONGODB_INSTALL: Post-install to $FILE ..."
         ln -sfv /usr/local/opt/mongodb/*.plist ~/Library/LaunchAgents
         # /Users/wilsonmar/Library/LaunchAgents/homebrew.mxcl.mongodb.plist -> /usr/local/opt/mongodb/homebrew.mxcl.mongodb.plist
      fi
         launchctl load "$FILE"

      if [ ! -z "$MONGODB_DATA_PATH" ]; then  # default to ...
         MONGODB_DATA_PATH="/usr/local/var/mongodb" # where mysql & postgres db's are too.
      fi   

      if [ ! -d "$MONGODB_DATA_PATH" ]; then 
         fancy_echo "Creating MONGODB_DATA_PATH $MONGODB_DATA_PATH ..."
         mkdir -p "$MONGODB_DATA_PATH"  # not default ="/data/db"
      fi

      if [ ! -d "$MONGODB_DATA_PATH" ]; then 
         fancy_echo "Defining MongoDB permissions [Enter password] ..."
         sudo chown -R $MAC_USERID $MONGODB_DATA_PATH  # ls -l -R /media/craig/  
      fi

   # http://groups.google.com/group/mongodb-user
   # http://docs.mongodb.org/
}
if [[ "${DATA_TOOLS,,}" == *"mongodb"* ]]; then
   MONGODB_INSTALL
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      if [[ "${TRYOUT,,}" == *"mongodb"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then

      # TODO: Config file --config /usr/local/etc/mongod.conf (/etc/mongodb.conf on Ubuntu)

      # Check if mongodb already up:
      PID="$(ps -A | grep -m1 'mongodb' | grep -v "grep" | awk '{print $1}')"
      if [ ! -z "$PID" ]; then 
         echo "DATA_TOOLS: mongodb running on PID=$PID." >>$LOGFILE
      else # not up:
         fancy_echo "DATA_TOOLS: mongodb starting in background ..."
         mongod --dbpath $MONGODB_DATA_PATH --config /usr/local/etc/mongod.conf & 
            # response: pid=6295 port=27017 dbpath=/data/db 
            # --dbpath NOT /usr/local/opt/mongodb/bin/mongod 
       fi
         echo "DATA_TOOLS: mongodb mongo interactive  ..." >>$LOGFILE
         mongo >>$LOGFILE <<ANSWERS
          show dbs
          quit()
ANSWERS
      fi

      if [[ "${TRYOUT_KEEP,,}" == *"mongodb"* ]]; then
         fancy_echo "DATA_TOOLS: mongodb in TRYOUT_KEEP  ..." >>$LOGFILE
         echo "Now you can enter mongo commands:" >>$LOGFILE
      else
         PID="$(ps -A | grep -m1 'mongodb' | grep -v "grep" | awk '{print $1}')"
         fancy_echo "DATA_TOOLS: mongodb stopping PID $PID [Enter password] ..." >>$LOGFILE
         kill $PID  # sudo service mongo stop  # does work in Mac.
         # kill see https://docs.mongodb.com/manual/tutorial/manage-mongodb-processes/#use-kill
      fi
   fi
fi



function NEXUS_INSTALL() {
   BREW_INSTALL "DATA_TOOLS" "nexus" "brew"
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
    # See https://help.sonatype.com/repomanager3/installation/configuring-the-runtime-environment#ConfiguringtheRuntimeEnvironment-ChangingtheHTTPPort
      if [ ! -z "$NEXUS_PORT" ]; then # fall-back if not set in secrets.sh:
         NEXUS_PORT="8081"  # default
      fi
      echo "NEXUS_INSTALL port $NEXUS_PORT ..."
      # /usr/local/var/nexus contains logs, db, 
      # /usr/local/bin/nexus not a directory
      # /usr/local/var/homebrew/linked/nexus linked to 
      # /usr/local/opt/nexus   
      NEXUS_CONF="/usr/local/opt/nexus/libexec/conf/nexus.properties"
      if grep -q "application-host=0.0.0.0" "$NEXUS_CONF" ; then
         sed -i "s/application-host=0.0.0.0/application-host=127.0.0.1/g" "$NEXUS_CONF"
      fi
      if grep -q "application-port=$NEXUS_PORT" "$NEXUS_CONF" ; then
         echo "NEXUS_INSTALL already" >>$LOGFILE
      else
         # TODO: Find port in conf.
         sed -i "s/application-port=8081/application-port=$NEXUS_PORT/g" "$NEXUS_CONF"
      fi
      # https://support.sonatype.com/hc/en-us/articles/213465508-How-can-I-reset-a-forgotten-admin-password-
      # nexus stop
      # Add user (nexus-basedir)/../sonatype-work/nexus/conf/security.xml
   fi
}
if [[ "${DATA_TOOLS,,}" == *"nexus"* ]]; then
   NEXUS_INSTALL
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      if [[ "${TRYOUT,,}" == *"nexus"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         RESPONSE="$(nexus status)" # example: Nexus OSS is running (13756).
         if [[ "$(nexus status)" == *"Nexus OSS is not running."* ]]; then 
            echo "DATA_TOOLS nexus starting on port $NEXUS_PORT in background ..."
            nexus start
            open "http://localhost:$NEXUS_PORT/nexus"
         else
            echo "DATA_TOOLS $RESPONSE ..."
         fi
      else
         fancy_echo "DATA_TOOLS nexus TRYOUT not specified." >>$LOGFILE
      fi

      if [[ "$TRYOUT_KEEP" != *"nexus"* ]]; then # not specified, so it's gone:
         echo "DATA_TOOLS nexus stopping ..." >>$LOGFILE
         nexus stop
      else
         PID="$(ps x | grep -m1 '/nexus' | grep -v "grep" | awk '{print $1}')"
         echo "DATA_TOOLS nexus still running on PID=$PID." >>$LOGFILE
         # nexus
         # Usage: nexus { console | start | stop | restart | status | version }
      fi
   fi  
else
   fancy_echo "DATA_TOOLS nexus not specified." >>$LOGFILE
fi


function SONAR_INSTALL(){
   # Required: java >= 1.8   
   fancy_echo "SONAR_INSTALL" >>$LOGFILE  # sonar 3.3.4

   BREW_INSTALL "DATA_TOOLS" "sonar" "brew" # /usr/local/bin/sonar
                          # linked from /usr/local/Cellar/sonarqube/7.1/bin/sonar
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      SONAR_CONF="/usr/local/opt/sonarqube/libexec/conf/nexus.properties"
            # "/usr/local/Cellar/sonarqube/7.1/libexec/conf/sonar.properties"
      if [ ! -z "$SONAR_PORT" ]; then # fall-back if not set in secrets.sh:
         SONAR_PORT="9000"  # default 9000
      fi

      sed -i "s/#sonar.web.port=9000/sonar.web.port=$SONAR_PORT/g" "$SONAR_CONF"
      # consider #sonar.web.javaOpts=-Xmx512m -Xms128m -XX:+HeapDumpOnOutOfMemoryError

      # https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner
      # https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner#AnalyzingwithSonarQubeScanner-Installation
      BREW_INSTALL "DATA_TOOLS" "sonar-scanner" "sonar-scanner -v" # previously sonar-runner 
   fi
}
if [[ "${TEST_TOOLS,,}" == *"sonar"* ]] || [[ "$TRYOUT_KEEP" == *"sonar"* ]]; then
   SONAR_INSTALL
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then

      # TODO: Create database in mysql per http://chapter31.com/2013/05/02/installing-sonar-source-on-mac-osx/
      # and https://neomatrix369.wordpress.com/2013/09/16/installing-sonarqube-formely-sonar-on-mac-os-x-mountain-lion-10-8-4/
      #MYSQL_INSTALL

      # Download from https://docs.sonarqube.org/display/PLUG/SonarSource+Plugins
      # into /usr/local/Cellar/sonar/5.1.2/libexec/extensions/plugins/
      # See https://www.sonarsource.com/products/codeanalyzers/sonarjs.html

      # NOTE: Hygieia and others pull from sonar.

      if [[ "${TRYOUT,,}" == *"sonar"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         fancy_echo "TEST_TOOLS sonar TRYOUT starting in background ..." >>$LOGFILE
         sonar console &  # response: "SonarQube is up"
         open "http://localhost:$SONAR_PORT/"

         # Run a scan now.
      else
         fancy_echo "TEST_TOOLS sonar TRYOUT not specified." >>$LOGFILE
      fi

      if [[ "$TRYOUT_KEEP" != *"sonar"* ]]; then # not specified, so it's gone:
         echo "TEST_TOOLS sonar stopping ..." >>$LOGFILE
         sonar stop
      else
         echo "TEST_TOOLS sonar still running on multiple PID." >>$LOGFILE
         sonar --help # Usage: sonar { console | start | stop | restart | status | version }
         sonar status
      fi
   fi
else
   fancy_echo "TEST_TOOLS sonar not specified." >>$LOGFILE
fi


function NEO4J_INSTALL() {
   # Required: java >= 1.8
   if ! command_exists neo4j ; then
  #if ! command -v neo4j >/dev/null 2>/dev/null; then  # 2>neo4jx: command not found is expected
      fancy_echo "DATA_TOOLS neo4j installing ..."
      # Not in https://neo4j.com/docs/operations-manual/current/installation/osx/
      brew install neo4j
         brew info neo4j >>$LOGFILE 
       # brew list neo4j >>$LOGFILE
   else
      if [[ "${RUNTYPE,,}" == *"upgrade"* ]]; then
         fancy_echo "DATA_TOOLS neo4j upgrading ..."
         neo4j --version
         brew upgrade neo4j
      elif [[ "${RUNTYPE,,}" == *"remove"* ]]; then
         neo4j stop
         brew remove neo4j
         exit
      fi
   fi
   fancy_echo "NEO4J_INSTALL $(neo4j --version)" >>$LOGFILE  # neo4j 3.3.4

      # https://neo4j.com/docs/operations-manual/current/configuration/file-locations/
        BASHFILE_EXPORT "NEO4J_HOME" "/usr/local/opt/neo4j"
        BASHFILE_EXPORT "NEO4J_CONF" "/usr/local/opt/neo4j/libexec/conf/"

         if [ ! -z "$NEO4J_PORT" ]; then # fall-back if not set in secrets.sh:
            NEO4J_PORT="7474"  # default 7474
         fi

   fancy_echo "NEO4J_INSTALL sed conf ..." >>$LOGFILE
   sed -i "s/#dbms.connector.http.listen_address=:7474/dbms.connector.http.listen_address=:$NEO4J_PORT/g" "$NEO4J_CONF/neo4j.conf"
   # textedit /usr/local/Cellar/neo4j/3.3.4/libexec/conf/neo4j.conf
}
if [[ "${DATA_TOOLS,,}" == *"neo4j"* ]] || [[ "$TRYOUT_KEEP" == *"neo4j"* ]]; then
   NEO4J_INSTALL
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      if [[ "${TRYOUT,,}" == *"neo4j"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         chmod +X "$NEO4J_HOME/bin/neo4j"
         "$NEO4J_HOME/bin/neo4j" console &
         # Remote interface available at http://localhost:7474/
         open "http://localhost:$NEO4J_PORT/"
      else
         fancy_echo "DATA_TOOLS neo4j TRYOUT not specified." >>$LOGFILE
      fi

      if [[ "$TRYOUT_KEEP" != *"neo4j"* ]]; then # not specified, so it's gone:
         echo "DATA_TOOLS neo4j stopping ..." >>$LOGFILE
         neo4j stop
      else
         echo "DATA_TOOLS neo4j still running on PID=$PID." >>$LOGFILE
         neo4j --help
         neo4j status
         # Usage: neo4j { console | start | stop | restart | status | version }
      fi
   fi
else
   fancy_echo "DATA_TOOLS neo4j not specified." >>$LOGFILE
fi


function RSTUDIO_INSTALL() { 
   # See https://wilsonmar.github.io/R 
      if grep -q "/usr/local/Cellar/r/3.4.4/lib/R" "$BASHFILE" ; then    
         fancy_echo "RSTUDIO_INSTALL r PATH already in $BASHFILE" >>$LOGFILE
      else
         fancy_echo "RSTUDIO_INSTALL r in $BASHFILE..."
         echo "" >>"$BASHFILE"
         # From bash info r showing /usr/local/Cellar/r/3.4.4/lib/R
         echo "export PATH=\"\$PATH:/usr/local/Cellar/r/3.4.4/lib/R/bin\"" >>"$BASHFILE"
         echo "alias rv34='/usr/local/Cellar/r/3.4.4/lib/R/bin/R'" >>"$BASHFILE"
         source "$BASHFILE"
      fi 
   BREW_CASK_INSTALL "RSTUDIO_INSTALL" "xquartz" "XQuartz" "brew"
      # 2.7.11

   BREW_CASK_INSTALL "RSTUDIO_INSTALL" "r --with-x11 --with-openblas" "R" "brew"
      # note: alternate name for r is r-app?

   BREW_CASK_INSTALL "RSTUDIO_INSTALL" "rstudio" "RStudio" 
}
if [[ "${DATA_TOOLS,,}" == *"rstudio"* ]]; then
   RSTUDIO_INSTALL

   if [[ "${TRYOUT,,}" == *"rstudio"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
      echo "DATA TOOLS: rstudio starting ..." >>$LOGFILE
      rstudio &

      #TODO: sudo rstudio-server start
   fi

   if [[ "${TRYOUT_KEEP,,}" == *"rstudio"* ]]; then
      echo "DATA_TOOLS rstudio stopping ..." >>$LOGFILE
      
      # sudo rstudio-server stop
   else
      PID="$(ps x | grep -m1 '/rstudio' | grep -v "grep" | awk '{print $1}')"
      echo "DATA_TOOLS rstudio still running on PID=$PID." >>$LOGFILE
      # rstudio --help
      # sudo rstudio-server active-sessions
   fi
else
   fancy_echo "DATA_TOOLS rstudio not specified." >>$LOGFILE
fi


function VAULT_INSTALL() {
   BREW_INSTALL "DATA_TOOLS" "vault" ""
   # TODO: Configure per https://www.vaultproject.io/docs/configuration/index.html
}
if [[ "${DATA_TOOLS,,}" == *"vault"* ]]; then
   VAULT_INSTALL
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      if [[ "${TRYOUT,,}" == *"vault"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         fancy_echo "DATA_TOOLS vault started ..."
      else
         fancy_echo "DATA_TOOLS vault TRYOUT not specified." >>$LOGFILE
      fi
   fi
else
   fancy_echo "DATA_TOOLS vault not specified." >>$LOGFILE
fi


if [[ "${DATA_TOOLS,,}" == *"others"* ]]; then
   fancy_echo "DATA_TOOLS=others ..."
#  dbunit? # http://www.javavillage.in/dbunit-sample-example.php
#  brew install mysql       #  mysql@5.5, mysql@5.6
#  BREW_INSTALL "DATA_TOOLS" "influxdb" "brew" # 1.5.1, influxd -config /usr/local/etc/influxdb.conf

#  BREW_CASK_INSTALL "DATA_TOOLS" "google-drive" "Google Drive" "brew"
          # https://drive.google.com/drive/u/0/folders/
#  BREW_CASK_INSTALL "DATA_TOOLS" "dropbox" "Dropbox" "brew"
#  BREW_CASK_INSTALL "DATA_TOOLS" "amazon-drive" "Amazon Drive" "brew"
          # https://www.amazon.com/clouddrive/all
#  BREW_CASK_INSTALL "DATA_TOOLS" "evernote" "Evernote" "brew"

#  BREW_CASK_INSTALL "DATA_TOOLS" "tableau" "Tableau" "brew"
#  BREW_CASK_INSTALL "DATA_TOOLS" "tableau-public" "Tableau Public" "brew"
#  BREW_CASK_INSTALL "DATA_TOOLS" "tableau-reader" "Tableau Reader" "brew"

# http://ess.r-project.org/  Emacs Speaks Statistics (ESS) 
# See http://zmjones.com/mac-setup/
fi
 
if [[ "${DATA_TOOLS,,}" == *"elastic"* ]] || [[ "$TRYOUT_KEEP" == *"elastic"* ]]; then
   # https://logz.io/blog/elk-mac/?aliId=12015968
   # http://www.elasticsearchtutorial.com/elasticsearch-in-5-minutes.html
   JAVA_INSTALL

   BREW_INSTALL "DATA_TOOLS" "elasticsearch" "brew"
   BREW_INSTALL "DATA_TOOLS" "logstash" "brew"
   BREW_INSTALL "DATA_TOOLS" "kibana" "brew"  # old?
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      echo "DATA_TOOLS elasticsearch ELASTIC_PORT config ..."
      if [ ! -z "$ELASTIC_PORT" ]; then # fall-back if not set in secrets.sh:
         ELASTIC_PORT="9200"  # default 9200
      fi
      if grep -q "http.port: 9200" "/usr/local/etc/elasticsearch/elasticsearch.yml" ; then    
         sed -i "s/#http.port: 9200/http.port: $ELASTIC_PORT/g" \
            /usr/local/etc/elasticsearch/elasticsearch.yml
      fi

      if [ ! -z "$KIBANA_PORT" ]; then # fall-back if not set in secrets.sh:
         KIBANA_PORT="5601"  # default 5601
      fi
      if grep -q "port 5601" "/usr/local/etc/kibana/kibana.yml" ; then    
         sed -i "s/#server.port: 5601/server.port: $KIBANA_PORT/g" \
            /usr/local/etc/kibana/kibana.yml
      fi
      if grep -q "port 5601" "/etc/logstash/conf.d/syslog.conf" ; then    
         sed -i "s/#server.port: 5601/server.port: $KIBANA_PORT/g" \
            /etc/logstash/conf.d/syslog.conf  # the server being monitored.
      fi
      # Add Elasticsearch indices in Kibana.
      # /usr/local/opt/kibana/plugins 

      # X-Packs for Kibana and Logstash are for subscribers.
      # https://www.elastic.co/guide/en/beats/libbeat/6.2/installing-beats.html
      # Packetbeat, Metricbeat, Filebeat, Winlogbeat, Heartbeat 

      # https://www.elastic.co/guide/en/kibana/6.x/tutorial-load-dataset.html
      # https://www.elastic.co/guide/en/elasticsearch/reference/6.x/mapping.html
      #curl -H 'Content-Type: application/x-ndjson' -XPOST 'localhost:9200/bank/account/_bulk?pretty' --data-binary @accounts.json
      #curl -H 'Content-Type: application/x-ndjson' -XPOST 'localhost:9200/shakespeare/doc/_bulk?pretty' --data-binary @shakespeare_6.0.json
      #curl -H 'Content-Type: application/x-ndjson' -XPOST 'localhost:9200/_bulk?pretty' --data-binary @logs.jsonl

      # GET /_cat/indices?v

      if [[ "${TRYOUT,,}" == *"elastic"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         fancy_echo "DATA_TOOLS elasticsearch starting ..." >>$LOGFILE
         brew services start elasticsearch
         curl "http://localhost:$ELASTIC_PORT" >>$LOGFILE

         brew services start logstash
         brew services start kibana      
         open "http://localhost:$KIBANA_PORT/status" # Kibana 
         brew services list

         #open "http://localhost:&ELASTIC_PORT/status#?_g=()"
         #open "http://localhost:&ELASTIC_PORT/_search?pretty"
         #open "http://localhost:&ELASTIC_PORT/_cat/indices?v"
         #open "http://localhost:&ELASTIC_PORT/app/kibana#/home?_g=()"
         #open "http://localhost:&ELASTIC_PORT/filebeat-*/_search?pretty'"

         # tail -f "/usr/local/var/log/elasticsearch/elasticsearch_$MAC_USERID.log"

         if [[ "${TRYOUT_KEEP,,}" == *"elastic"* ]]; then
            echo "TEST_TOOLS elastic TRYOUT_KEEP ..."
            brew services stop elasticsearch
            brew services stop logstash
            brew services stop kibana      
            brew services list
         else
            fancy_echo "TRYOUT_KEEP elastic running ..."
         fi
      else
         fancy_echo "TRYOUT elastic not specified ..."
      fi
   fi
else
   fancy_echo "DATA_TOOLS elasticsearch not specified." >>$LOGFILE
fi


######### Node language:

function NPM_MODULE_INSTALL() {
   module=$1   # "mongodo" or other Node module
   runtype=$2  # "upgrade" or blank

#   NPM_LIST=$(npm list -g "$module" | grep "$module")
   if grep -q "$(npm list -g "$module" | grep "$module")" "(empty)" ; then  # no reponse, so add:
      fancy_echo "NPM_MODULE_INSTALL installing $module $runtype ..."
      npm install -g $module
   else
      if [[ "${RUNTYPE,,}" == *"upgrade"* ]]; then
         fancy_echo "NPM_MODULE_INSTALL upgrade $module ..."
         npm update -g $module
      fi
   fi
   fancy_echo "NPM_MODULE_INSTALL $module version now ..." >>$LOGFILE
   npm list -g "$module" >>$LOGFILE
}
if [[ "${LANG_TOOLS,,}" == *"nodejs"* ]]; then
   NODE_INSTALL  # pre-requisite function.
fi

   # NOTE: NODE_TOOLS = npm (node package manager) installed within node.
   # https://colorlib.com/wp/npm-packages-node-js/

if [[ "${NODE_TOOLS,,}" == *"appium"* ]]; then
   NODE_INSTALL
   
   npm install -g appium

   # Initialize WebDriverAgent project:
   pushd /usr/local/lib/node_modules/appium/node_modules/appium-xcuitest-driver/WebDriverAgent
   mkdir -p Resources/WebDriverAgent.bundle
   sh ./Scripts/bootstrap.sh -d
   popd

   # TODO: Finish this per http://docs.katalon.com/display/KD/Mobile+on+macOS
else
   fancy_echo "NODE_TOOLS appium not specified." >>$LOGFILE
fi

if [[ "${NODE_TOOLS,,}" == *"sfdx"* ]]; then
   NODE_INSTALL
   # ref https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_install_cli.htm#sfdx_setup_install_cli
   # Instead of npm install --global sfdx-cli

   # This is cask but no GUI
   BREW_CASK_INSTALL "NODE_TOOLS" "sfdx" "" "--version"
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      sfdx plugins --core >>$LOGFILE
      # @salesforce/plugin-generator 0.0.5 (core)
      # builtins 1.0.0 (core)
      # salesforcedx 42.12.0 (core)
      sfdx plugins >>$LOGFILE

      # export SFDX_AUTOUPDATE_DISABLE=true

      if [[ "${TRYOUT,,}" == *"sfdx"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         fancy_echo "NODE_TOOLS sfdx starting ..." >>$LOGFILE
         fancy_echo "NODE_TOOLS sfdx menu of commands ..."
         # sfdx force --help

         pushd "$GITS_PATH"
         if [ ! -d "sfdx-simple" ]; then 
            git clone https://github.com/forcedotcom/sfdx-simple --depth=1
            cd sfdx-simple
         else # already there, so update:
            cd sfdx-simple
            GITHUB_UPDATE
         fi
         echo "RUBY_TOOLS sfdx-simple at $(pwd) after clone" >>$LOGFILE
      
         #If you already have an authorized Dev Hub, set it as the default:
         #sfdx force:config:set defaultdevhubusername=<username|alias>
         # else
         #sfdx force:auth:web:login -d -a "Hub Org"  # Authorize to your Developer Hub (Dev Hub) org.

         # If exist?
         # sfdx force:org:create -s -f config/project-scratch-def.json  # Create a scratch org.
         # else # use an existing scratch org, set it as the default:
         # sfdx force:config:set defaultusername=<username|alias>

         #sfdx force:source:push  # Push your source.

         #sfdx force:apex:test:run
         # sfdx force:apex:test:report -i <id>

         #Open the scratch org.
         #sfdx force:org:open --path one/one.app

         popd
         echo "RUBY_TOOLS sfdx-simple at $(pwd) after usage." >>$LOGFILE
      fi
   fi
else
   fancy_echo "NODE_TOOLS mavsfdxen not specified." >>$LOGFILE
fi

   # Task runners:
   if [[ "${NODE_TOOLS,,}" == *"bower"* ]]; then
      NPM_MODULE_INSTALL bower "$RUNTYPE"
   fi

   if [[ "${NODE_TOOLS,,}" == *"gulp-cli"* ]]; then
      npm install -g gulp-cli
   fi
   if [[ "${NODE_TOOLS,,}" == *"gulp"* ]]; then
      npm install -g gulp
   fi
   if [[ "${NODE_TOOLS,,}" == *"npm-check"* ]]; then
      npm install -g npm-check
   fi
   # Linters: less, UglifyJS2, eslint, jslint, cfn-lint
   if [[ "${NODE_TOOLS,,}" == *"less"* ]]; then
      npm install -g less
   fi
   if [[ "${NODE_TOOLS,,}" == *"jshint"* ]]; then
      npm install -g jshint  # linter
   fi
   if [[ "${NODE_TOOLS,,}" == *"eslint"* ]]; then
      npm install -g eslint  # linter for ES6 javascript, includes jscs
   fi

   if [[ "${NODE_TOOLS,,}" == *"webpack"* ]]; then
      npm install -g webpack  # consolidate several javascript files into one file.
   fi
   if [[ "${NODE_TOOLS,,}" == *"mocha"* ]]; then
      npm install -g mocha # testing framework
   fi
   if [[ "${NODE_TOOLS,,}" == *"chai"* ]]; then
      npm install -g chai # assertion library  "should", "expect", "assert" for BDD and TDD styles of programming 
   fi
   if [[ "${NODE_TOOLS,,}" == *"karma"* ]]; then
      npm install -g karma
   fi
   if [[ "${NODE_TOOLS,,}" == *"karma-cli"* ]]; then
      npm install -g karma-cli
   fi
   if [[ "${NODE_TOOLS,,}" == *"jest"* ]]; then
      npm install -g jest
   fi
   if [[ "${NODE_TOOLS,,}" == *"protractor"* ]]; then
      npm install -g protractor
   fi
   # testing: enzyme, jest, 
   # nodemon, # https://codeburst.io/dont-use-nodemon-there-are-better-ways-fc016b50b45e
   if [[ "${NODE_TOOLS,,}" == *"node-inspector"* ]]; then
      npm install -g node-inspector
   fi

   if [[ "${NODE_TOOLS,,}" == *"browserify"* ]]; then
      npm install -g browserify
   fi
   if [[ "${NODE_TOOLS,,}" == *"tsc"* ]]; then
      npm install -g tsc
   fi
   # web servers:
   if [[ "${NODE_TOOLS,,}" == *"express"* ]]; then
      npm install -g express
   fi
   if [[ "${NODE_TOOLS,,}" == *"hapi"* ]]; then
      npm install -g hapi
   fi
   
   if [[ "${NODE_TOOLS,,}" == *"angular"* ]]; then
      npm install -g angular
   fi
   if [[ "${NODE_TOOLS,,}" == *"react"* ]]; then
      npm install -g react  # Test using Jest https://medium.com/@mathieux51/jest-selenium-webdriver-e25604969c6
   fi
   if [[ "${NODE_TOOLS,,}" == *"redux"* ]]; then
      npm install -g redux
   fi
   
   # moment.js
   if [[ "${NODE_TOOLS,,}" == *"yeoman-generator"* ]]; then
      npm install -g yeoman-generator
   fi
   if [[ "${NODE_TOOLS,,}" == *"graphicmagick"* ]]; then
      npm install -g graphicmagick
   fi

   # cloud: aws-sdk
   if [[ "${NODE_TOOLS,,}" == *"aws-sdk"* ]]; then
      npm install -g aws-sdk
   fi
   if [[ "${NODE_TOOLS,,}" == *"cfn-lint"* ]]; then
      npm install -g cfn-lint  # CloudFormation JSON and YAML Validator
   fi

   # database:
   if [[ "${NODE_TOOLS,,}" == *"mongodb"* ]]; then
      npm install -g mongodb
   fi
   if [[ "${NODE_TOOLS,,}" == *"postgresql"* ]]; then
      npm install -g postgresql
   fi
   if [[ "${NODE_TOOLS,,}" == *"redis"* ]]; then
      npm install -g redis
   fi

   if [[ "$NODE_TOOLS" == *"others"* ]]; then
      echo "Installing NODE_TOOLS=others ..."; 
#   npm install -g growl
#   npm install -g kudoexec
#   npm install -g node-inspector
#   npm install -g phantomjs
#   npm install -g superstatic
#   npm install -g tsd
#   npm install -g typescript
#   npm install -g jira-client  # https://www.npmjs.com/package/jira-client
   # Also: Ember.js, Marionette.js
   fi

   #fancy_echo "npm list -g --depth=1 --long" >>$LOGFILE
   #echo -e "$(npm list -g --depth=1)" >>$LOGFILE



if [[ "${NODE_TOOLS,,}" == *"meanjs"* ]] || [[ "$TRYOUT_KEEP" == *"meanjs"* ]]; then
   # meanjs is a boilerplate app from https://github.com/meanjs/mean
   # MEAN is an acronmym for MongoDB, Express.js, Angular.js, and Node.js

   # Keep mongodb running:
   if echo "$TRYOUT_KEEP" | grep -q "mongodb"; then
      echo "mongodb already in string";
   else
      echo "$TRYOUT_KEEP,mongodb";  # add to string
   fi

   if echo "$TRYOUT" | grep -q "mongodb"; then
      echo "mongodb already in string";
   else
      echo "$TRYOUT,mongodb";  # add to string
   fi
   MONGODB_INSTALL

   fancy_echo "NODE_TOOLS meanjs installing ..."
   #NODE_INSTALL  # pre-requisite function.
      # TODO: npx instead to install within project folder.
      NPM_MODULE_INSTALL bower "$RUNTYPE"
      NPM_MODULE_INSTALL angular "$RUNTYPE"
      NPM_MODULE_INSTALL express "$RUNTYPE"
   echo "At $(pwd) before push" >>$LOGFILE

   pushd "$GITS_PATH"
   if [ ! -d "meanjs" ]; then 
      git clone https://github.com/meanjs/mean.git  meanjs --depth=1
      cd meanjs
   else
      cd meanjs
      GITHUB_UPDATE 
   fi

   echo "NODE_TOOLS meanjs at $(pwd) after clone" >>$LOGFILE
   fancy_echo "NODE_TOOLS meanjs npm install ..."
   npm install
   #npm run generate-ssl-certs
   fancy_echo "NODE_TOOLS meanjs npm start in background ..."
   npm start & # npm run start:prod
   popd  # from GIT_PATH

      if [ ! -z "$MEANJS_PORT" ]; then # fall-back if not set in secrets.sh:
         MEANJS_PORT="3000"  # default
      fi
   echo "NODE_TOOLS meanjs at $(pwd) to open port $MEANJS_PORT" >>$LOGFILE
   open "http://localhost:$MEANJS_PORT"
   # Read http://meanjs.org/docs.html

   if [[ "${TRYOUT_KEEP,,}" == *"meanjs"* ]]; then
      fancy_echo "NODE_TOOLS: meanjs in TRYOUT_KEEP  ..." >>$LOGFILE
      echo "NODE_TOOLS: meanjs running on localhost:$MEANJS_PORT ...." >>$LOGFILE
   else
      # npm stop command doesn't work, so ps - 86633 ttys000    0:03.10 node --inspect server.js
      PID="$(ps -A | grep -m1 'node --' | grep -v "grep" | awk '{print $1}')"
      fancy_echo "DATA_TOOLS: mongodb stopping PID $PID [Enter password] ..." >>$LOGFILE
      kill $PID  # Response: [09:27:40] [nodemon] app crashed - waiting for file changes before starting...
   fi
else
   fancy_echo "NODE_TOOLS meanjs not specified." >>$LOGFILE
fi


if [[ "${NODE_TOOLS,,}" == *"magicbook"* ]]; then
   NODE_INSTALL  # pre-requisite function.
   # See https://github.com/magicbookproject/magicbook
      NPM_LIST=$(npm list -g magicbook | grep magicbook) 
      if ! grep -q "magicbook" "$NPM_LIST" ; then # not installed, so:
         npm install magicbook -g
      fi
   if [[ "${TRYOUT,,}" == *"magicbook"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
      fancy_echo "TRYOUT = Run magicbook new project generator:"
      MAGICBOOK_PROJECT="myproject"  # TODO: Move to secrets.sh
      magicbook new "$MAGICBOOK_PROJECT" 
                 cd "$MAGICBOOK_PROJECT"
      magicbook build  # --config=myfolder/myconfig.json
   fi
else
   fancy_echo "NODE_TOOLS magicbook not specified." >>$LOGFILE
fi


######### JAVA_TOOLS:

function MAVEN_INSTALL() {
   BREW_INSTALL "JAVA_TOOLS" "maven" "brew"  
}
if [[ "$JAVA_TOOLS" == *"maven"* ]]; then
   MAVEN_INSTALL
    # Associated: Maven (mvn) in /usr/local/opt/maven/bin/mvn
   # yarn is installed by adding it within Maven or Gradle pom.xml
else
   fancy_echo "JAVA_TOOLS maven not specified." >>$LOGFILE
fi

function GRADLE_INSTALL() {
   BREW_INSTALL "JAVA_TOOLS" "gradle" "brew"
}
if [[ "$JAVA_TOOLS" == *"gradle"* ]]; then
   GRADLE_INSTALL
    # no xml angle brackets! Uses Groovy DSL
    # See http://www.gradle.org/docs/1.6/userguide/userguide.html
      # 4.7
   # http://www.gradle.org/docs/1.6/userguide/plugins.html
   # http://www.gradle.org/docs/1.6/userguide/gradle_command_line.html
   # gradle setupBuild  # reads build.gradle
   # gradle tasks
   # gradle test
else
   fancy_echo "JAVA_TOOLS gradle not specified." >>$LOGFILE
fi

function ANT_INSTALL() {
   BREW_INSTALL "JAVA_TOOLS" "ant" "brew"
}
if [[ "$JAVA_TOOLS" == *"ant"* ]]; then
   ANT_INSTALL
      # /usr/local/Cellar/ant/1.10.3/bin/ant
   ant --execdebug
   unset ANT_HOME  # https://github.com/Homebrew/legacy-homebrew/issues/32851

   if [[ "${TRYOUT,,}" == *"ant"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
      # To avoid Error: Could not find or load main class org.apache.tools.ant.launch.Launcher
      #      export ANT_HOME=/usr/local/var/homebrew/linked/ant
      #echo "export ANT_HOME=/usr/local/var/homebrew/linked/ant" >>$BASHFILE
      ant &  # GUI
         # Buildfile: build.xml does not exist!
         # Build failed
   fi
else
   fancy_echo "JAVA_TOOLS ant not specified." >>$LOGFILE
fi

if [[ "$JAVA_TOOLS" == *"junit4"* ]]; then
   # junit5 reached 2nd GA February 18, 2018 https://junit.org/junit5/docs/current/user-guide/
   # http://junit.org/junit4/
   # https://github.com/junit-team/junit4/wiki/Download-and-Install
   # https://www.tutorialspoint.com/junit/junit_environment_setup.htm
   fancy_echo "There is no brew install junit because it is installed by adding it within Maven or Gradle." 
   # TODO: Insert java-junit4-maven.xml as a dependency to maven pom.xml
   # 
fi

if [[ "$JAVA_TOOLS" == *"junit5"* ]]; then
   # junit5 reached 2nd GA February 18, 2018 https://junit.org/junit5/docs/current/user-guide/
   # http://junit.org/junit4/
   # https://github.com/junit-team/junit4/wiki/Download-and-Install
   # https://www.tutorialspoint.com/junit/junit_environment_setup.htm
   fancy_echo "There is no brew install junit because it is installed by adding it within Maven or Gradle." 
   # TODO: Insert java-junit5-maven.xml as a dependency to maven pom.xml

   if [[ "${TRYOUT,,}" == *"HelloJUnit5"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
      fancy_echo "TRYOUT = HelloJUnit5 explained by @jstevenperry at https://ibm.co/2uWIwcp"

      pushd "$GITS_PATH"
      if [ ! -d "HelloJUnit5" ]; then 
         git clone https://github.com/makotogo/HelloJUnit5.git --depth=1
         cd HelloJUnit5
      else # already there, so update:
         cd HelloJUnit5
         git fetch  # instead of git pull
         git log ..@{u}
         #git reset --hard HEAD@{1} to go back and discard result of git pull if you don't like it.
         git merge  # Response: Already up to date.
      fi
      echo "JAVA_TOOLS junit5 at $(pwd) after clone" >>$LOGFILE
      chmod +x run-console-launcher.sh
      # doesn't matter if [[ "${JAVA_TOOLS,,}" == *"maven"* ]]; then
      ./run-console-launcher.sh
      if [[ "${JAVA_TOOLS,,}" == *"gradle"* ]]; then
         gradle test
      fi
      popd

      # Add folder in .gitignore:
      if [ ! -f "../.gitignore" ]; then
         echo "Adding osx-init/HelloJUnit5/ in ../.gitignore"
         echo "osx-init/HelloJUnit5/" >../.gitignore
         echo "osx-init/.gradle/"    >>../.gitignore
      else 
      	 if ! grep -q "HelloJUnit5" "../.gitignore"; then    
            echo "Adding osx-init/HelloJUnit5/ in ../.gitignore"
            echo "osx-init/HelloJUnit5/" >>../.gitignore
            echo "osx-init/.gradle/"     >>../.gitignore
         fi
      fi
      # Also see http://www.baeldung.com/junit-5-test-order
   fi
fi # See https://howtoprogram.xyz/2016/09/09/junit-5-maven-example/


# Also: https://github.com/google/guava  # Google Core Libraries for Java in maven/gradle


if [[ "$JAVA_TOOLS" == *"jmeter"* ]]; then
   # from https://jmeter.apache.org/download_jmeter.cgi
   BREW_INSTALL "JAVA_TOOLS" "jmeter" "--version"
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      BASHFILE_EXPORT "JMETER_HOME" "/usr/local/opt/jmeter/libexec"
                   # symlink from /usr/local/Cellar/jmeter/4.0/
      # TODO: Paste the file to $JMETER_HOME/lib/ext = /usr/local/Cellar/jmeter/4.0/libexec

      FILE="jmeter-plugins-manager-0.5.jar"  # TODO: Check if version has changed since Jan 4, 2018.
      FILE_PATH="$JMETER_HOME/libexec/lib/ext/jmeter-plugins-manager.jar"
      if [ -f $FILE_PATH ]; then  # file exists within folder 
         fancy_echo "$FILE already installed. Skipping install." >>$LOGFILE
         ls -al             $FILE_PATH >>$LOGFILE
      else
         fancy_echo "Downloading $FILE to $FOLDER ..."
         # From https://jmeter-plugins.org/wiki/StandardSet/
         curl -O http://jmeter-plugins.org/downloads/file/$FILE 
         fancy_echo "Overwriting $FILE_PATH ..."
         yes | cp -rf $FILE  $FILE_PATH
         ls -al             $FILE_PATH
      fi

      FILE="jmeter-plugins-standard-1.4.0.jar"  # TODO: Check if version has changed since Jan 4, 2018.
      # From https://jmeter-plugins.org/downloads/old/
      # From https://jmeter-plugins.org/downloads/file/JMeterPlugins-Standard-1.4.0.tar.gz
      FILE_PATH="$JMETER_HOME/libexec/lib/ext/jmeter-plugins-standard.jar"
      if [ -f $FILE_PATH ]; then  # file exists within folder 
         fancy_echo "$FILE already installed. Skipping install." >>$LOGFILE
         ls -al             $FILE_PATH >>$LOGFILE
      else
         fancy_echo "Downloading $FILE_PATH ..."
         # See https://mvnrepository.com/artifact/kg.apc/jmeter-plugins-standard
         curl -O http://central.maven.org/maven2/kg/apc/jmeter-plugins-standard/1.4.0/jmeter-plugins-standard-1.4.0.jar
         # 400K received. 
         fancy_echo "Overwriting $FILE_PATH ..."
         yes | cp -rf $FILE $FILE_PATH
         ls -al             $FILE_PATH
      fi

      FILE="jmeter-plugins-extras-1.4.0.jar"  # TODO: Check if version has changed since Jan 4, 2018.
      # From https://jmeter-plugins.org/downloads/old/
      FILE_PATH="$JMETER_HOME/libexec/lib/ext/jmeter-plugins-extras.jar"
      if [ -f $FILE_PATH ]; then  # file exists within folder 
         fancy_echo "$FILE already installed. Skipping install." >>$LOGFILE
         ls -al             $FILE_PATH >>$LOGFILE
      else
         fancy_echo "Downloading $FILE_PATH ..."
         # See https://mvnrepository.com/artifact/kg.apc/jmeter-plugins-extras
         curl -O http://central.maven.org/maven2/kg/apc/jmeter-plugins-extras/1.4.0/jmeter-plugins-extras-1.4.0.jar
         # 400K received. 
         fancy_echo "Overwriting $FILE_PATH ..."
         yes | cp -rf $FILE $FILE_PATH
         ls -al             $FILE_PATH
      fi

      FILE="jmeter-plugins-extras-libs-1.4.0.jar"  # TODO: Check if version has changed since Jan 4, 2018.
         # From https://jmeter-plugins.org/downloads/old/
      FILE_PATH="$JMETER_HOME/libexec/lib/ext/jmeter-plugins-extras-libs.jar"
      if [ -f $FILE_PATH ]; then  # file exists within folder 
         fancy_echo "$FILE already installed. Skipping install."
         ls -al             $FILE_PATH
      else
         fancy_echo "Downloading $FILE_PATH ..."
         # See https://mvnrepository.com/artifact/kg.apc/jmeter-plugins-extras-libs
         curl -O http://central.maven.org/maven2/kg/apc/jmeter-plugins-extras-libs/1.4.0/jmeter-plugins-extras-libs-1.4.0.jar
         # 400K received. 
         fancy_echo "Overwriting $FILE_PATH ..."
         yes | cp -rf $FILE $FILE_PATH
         ls -al             $FILE_PATH
      fi

      mv jmeter*.jar $JMETER_HOME/lib/ext

      if [[ "${TRYOUT,,}" == *"HelloJUnit5"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         fancy_echo "TRYOUT = HelloJUnit5 explained by @jstevenperry at https://ibm.co/2uWIwcp"
         git clone https://github.com/makotogo/HelloJUnit5.git --depth=1
         pushd HelloJUnit5
         chmod +x run-console-launcher.sh
         echo "TRYOUT HelloJUnit5 run-console-launcher.sh"
         ./run-console-launcher.sh
         if [[ "${JAVA_TOOLS,,}" == *"gradle"* ]]; then
            gradle test
         fi
         popd

         # Add folder in .gitignore:
         if [ ! -f "../.gitignore" ]; then
            echo "Adding osx-init/HelloJUnit5/ in ../.gitignore"
            echo "osx-init/HelloJUnit5/" >../.gitignore
            echo "osx-init/.gradle/"    >>../.gitignore
         else 
         	 if ! grep -q "HelloJUnit5" "../.gitignore"; then    
              echo "Adding osx-init/HelloJUnit5/ in ../.gitignore"
               echo "osx-init/HelloJUnit5/" >>../.gitignore
               echo "osx-init/.gradle/"     >>../.gitignore
            fi
         fi
      fi

      if [[ "${TRYOUT,,}" == *"jmeter"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         jmeter &  # GUI
      fi

      if [[ "${RUNTYPE,,}" == *"cleanup"* ]]; then
         rm jmeter.log
      fi
   fi
else
   fancy_echo "JAVA_TOOLS jmeter not specified." >>$LOGFILE
fi


if [[ "$MON_TOOLS" == *"gcviewer"* ]]; then
   if ! command_exists gcviewer ; then
      fancy_echo "MON_TOOLS gcviewer installing ..."
      brew install gcviewer
         brew info gcviewer >>$LOGFILE
         brew list gcviewer >>$LOGFILE
      # creates gcviewer.properties in $HOME folder.
   else
      if [[ "${RUNTYPE,,}" == *"upgrade"* ]]; then
         fancy_echo "MON_TOOLS gcviewer upgrading ..."
         # gcviewer --version
         brew upgrade gcviewer 
            # gcviewer 1.35 already installed
      else
         fancy_echo "MON_TOOLS gcviewer already installed:" >>$LOGFILE
      fi
      fancy_echo "MON_TOOLS $(brew info gcviewer | grep "gcviewer:")" >>$LOGFILE
         # gcviewer: stable 1.35
   fi
   # .gcviewer.log
else
      fancy_echo "MON_TOOLS gcviewer not specified." >>$LOGFILE
fi


if [[ "$MON_TOOLS" == *"jprofiler"* ]]; then
   JAVA_INSTALL
   BREW_CASK_INSTALL "MON_TOOLS" "jprofiler" "JProfiler" "brew"

      # Creates $HOME/.jprofiler10/config.xml containing the license key.
      # https://www.ej-technologies.com/resources/jprofiler/help/doc/#jprofiler.offline
else
   fancy_echo "MON_TOOLS jprofiler not specified." >>$LOGFILE
fi

if [[ "$MON_TOOLS" == *"others"* ]]; then
   fancy_echo "MON_TOOLS others ..." >>$LOGFILE
  # Others: Jprobe, Jconsole, VisualVM,
# brew install nmap
fi



if [[ "${CLOUD_TOOLS,,}" == *"terraform"* ]]; then
   # See https://wilsonmar.github.io/terraform/
   PREFIX="CLOUD_TOOLS terraform"
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      if ! command_exists tfenv ; then
         # Instead of BREW_INSTALL "CLOUD_TOOLS" "terraform" "--version"
         BREW_INSTALL "CLOUD_TOOLS" "tfenv" "--version"  # https://github.com/kamatama41/tfenv
         brew unlink terraform
         tfenv install latest  # instead of pip3 upgrade terraform 
      fi

      if grep -q "=\"terraform" "$BASHFILE" ; then    
         fancy_echo "$PREFIX alias already in $BASHFILE" >>$LOGFILE
      else
         fancy_echo "$PREFIX adding aliases in $BASHFILE ..."
         echo "alias tf=\"terraform \$1\"" >>"$BASHFILE"
         echo "alias tfa=\"terraform apply\"" >>"$BASHFILE"
         echo "alias tfd=\"terraform destroy\"" >>"$BASHFILE"
         echo "alias tfs=\"terraform show\"" >>"$BASHFILE"
         source "$BASHFILE"
      fi

      if [[ "${RUNTYPE,,}" != *"fromscratch"* ]]; then
         if [ -d "$GITS_PATH/terraform/tf-sample" ]; then
            fancy_echo "CLOUD_TOOLS terraform $RUNTYPE removing..." >>$LOGFILE
            rm -rf "$GITS_PATH/terraform/tf-sample"
         fi
      fi
      GITS_PATH_INIT "terraform" 
      pushd "$GITS_PATH/terraform"
      if [ ! -d "$GITS_PATH/terraform/tf-sample" ]; then # https://www.terraform.io/intro/examples/
            # git clone https://github.com/gruntwork-io/intro-to-terraform.git \
            git clone https://github.com/terraform-providers/terraform-provider-aws.git \
               tf-sample --depth=1
            chmod +x scripts/*
            cd tf-sample
      else 
            cd tf-sample
#           TODO: GITHUB_UPDATE
      fi
      cd examples/two-tier
      terraform init
echo "terraform before at $(PWD) "
exit #debugging
      terraform plan
      terraform apply
      popd
      echo "back at $(PWD)"
      GO_INSTALL
   else # remove
      rm -rf "$GITS_PATH/terraform/tf-sample"
      terraform destroy
   fi
else
   fancy_echo "CLOUD_TOOLS terraform not specified." >>$LOGFILE
fi
echo "exiting on terraform "
exit #debugging


######### Python modules:


# These may be inside virtualenv:

if [[ -z "${PYTHON_TOOLS// }"  ]]; then  #it's blank

fancy_echo "PYTHON_TOOLS=$PYTHON_TOOLS" >>$LOGFILE

DOTNET_CASK_INSTALL() {
   # https://docs.microsoft.com/en-us/dotnet/core/macos-prerequisites?tabs=netcore2x
   BREW_CASK_INSTALL "LANG_TOOLS" "dotnet" "brew" # even tho --version is stated.
   # https://docs.microsoft.com/en-us/dotnet/core/tutorials/using-on-macos   
   # https://apple.stackexchange.com/questions/248997/how-do-i-install-net-core-on-osx
   BREW_INSTALL "DOTNET_CASK_INSTALL" "openssl" "brew"
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      # TODO: Verify these links exists before linking:
      if [ ! -f "/usr/local/lib/libcrypto.1.0.0.dylib" ]; then
         ln -s /usr/local/opt/openssl/lib/libcrypto.1.0.0.dylib /usr/local/lib/
      fi
      if [ ! -f "/usr/local/lib/libssl.1.0.0.dylib" ]; then
         ln -s /usr/local/opt/openssl/lib/libssl.1.0.0.dylib /usr/local/lib/
      fi

      # See https://wilsonmar.github.io/bash-coding/#ExtractWeb
      # Extract SDK URL from https://www.microsoft.com/net/learn/get-started/macos#install
      PKG_LINK=$(curl -s https://www.microsoft.com/net/learn/get-started/macos#macos | \
         grep -B1 "Download .NET SDK" | grep "href" | \
         grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*" | grep -E ".pkg"); 
      #PKG_LINK="https://download.microsoft.com/download/2/E/C/2EC018A0-A0FC-40A2-849D-AA692F68349E/dotnet-sdk-2.1.105-osx-gs-x64.pkg"
      fancy_echo "DOTNET_CASK_INSTALL $PKG_LINK ..."

      PKG_NAME=$(basename $PKG_LINK); #PKG_NAME="dotnet-sdk-2.1.105-osx-gs-x64.pkg"
      echo "PKG_NAME=$PKG_NAME"

         if [ ! -d "$GITS_PATH" ]; then 
            mkdir  "$GITS_PATH"
         fi
       DOTNET_PROJ="$GITS_PATH/dotnet_proj"
         if [ ! -d "$DOTNET_PROJ" ]; then 
            mkdir  "$DOTNET_PROJ"
         fi
         echo "$PREFIX at $DOTNET_PROJ/$PKG_NAME ..."
      pushd "$DOTNET_PROJ"
      curl -L -O "$PKG_LINK" # -o "$DOTNET_PROJ/$PKG_NAME"
      popd

      if [ ! -f "$DOTNET_PROJ/$PKG_NAME" ]; then
         echo "ERROR: File not in $DOTNET_PROJ/$PKG_NAME"
      else
         echo "$DOTNET_PROJ/$PKG_NAME installing ..."
         #echo "y" | 
         sudo installer -store -verbose -allowUntrusted \
            -pkg "$DOTNET_PROJ/$PKG_NAME" -target / # target is a device, not a path.
      fi
   fi
}

if [[ "${LANG_TOOLS,,}" == *"dotnet"* ]]; then
   DOTNET_CASK_INSTALL
 exit #debugging
fi


if [[ "${PYTHON_TOOLS,,}" == *"anaconda"* ]]; then
   PYTHON_INSTALL

   BREW_INSTALL "PYTHON_TOOLS" "anaconda" "brew"
      #echo -e "\n  anaconda" >>$LOGFILE
      # echo -e "$(anaconda --version)" >>$LOGFILE
      #echo -e "$(conda list)" >>$LOGFILE
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then

      if grep -q "/usr/local/anaconda3/bin" "$BASHFILE" ; then    
         fancy_echo "anaconda3 PATH already in $BASHFILE"
      else
         fancy_echo "Adding anaconda3 PATH in $BASHFILE..."
         echo "export PATH=\"/usr/local/anaconda3/bin:$PATH\"" >>"$BASHFILE"
      fi
   fi
else
   fancy_echo "PYTHON_TOOLS anaconda not specified." >>$LOGFILE
fi


if [[ "${PYTHON_TOOLS,,}" == *"opencv"* ]]; then
   PYTHON_INSTALL
   fancy_echo "At PYTHON_TOOLS opencv ..." 
   # See https://www.learnopencv.com/how-to-compile-opencv-sample-code/
   # https://www.learnopencv.com/install-opencv3-on-macos/
   BREW_INSTALL "PYTHON_TOOLS" "opencv" "brew"
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      VER=$(ls /usr/local/Cellar/opencv/)  # 3.4.1_2
      fancy_echo "PYTHON_TOOLS opencv $VER links ::" >>$LOGFILE
      # symlink to your Python 2.7 site-packages per https://alyssaq.github.io/2014/installing-opencv-on-mac-osx-with-homebrew/
      sudo ln -s "/usr/local/Cellar/opencv/$VER/lib/python2.7/site-packages/cv.py /Library/Python/2.7/site-packages/cv.py" >>$LOGFILE
      sudo ln -s "/usr/local/Cellar/opencv/$VER/lib/python2.7/site-packages/cv2.so /Library/Python/2.7/site-packages/cv2.so" >>$LOGFILE
      # Ignore "File exists" when run again.

      if [[ "${TRYOUT,,}" == *"opencv"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         fancy_echo "PYTHON_TOOLS opencv iPython TODO: Run opencv ..."
         # Compile & run the FaceTracker.cpp file in OpenCV /samples
         #ipython &
         # import site; site.getsitepackages()
         # exit
      fi
   fi
else
   fancy_echo "PYTHON_TOOLS opencv not specified." >>$LOGFILE
fi

if [[ "${PYTHON_TOOLS,,}" == *"robotframework"* ]]; then
   PYTHON_INSTALL 
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      if ! python -c "import robotframework">/dev/null 2>&1 ; then   
         echo "Installing PYTHON_TOOLS=robotframework ..."; 
         pip install robotframework
         pip install docutils # docutils in ~/Library/Python/2.7/lib/python/site-packages
      else
         if [[ "${RUNTYPE,,}" == *"upgrade"* ]]; then
            fancy_echo "Upgrading PYTHON_TOOLS=robotframework ..."
            echo "$(pip freeze | grep robotframework)"
            pip install robotframework --upgrade
            pip install docutils --upgrade
         fi
      fi
      fancy_echo "$(pip freeze | grep robotframework)"  >>$LOGFILE
         # robotframework==3.0.3

      if [[ "${TRYOUT,,}" == *"robotframework"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         fancy_echo "TODO: TRYOUT robotframework" 
      fi
   fi
else
   fancy_echo "PYTHON_TOOLS robotframework not specified." >>$LOGFILE
fi


if [[ "${PYTHON_TOOLS,,}" == *"others"* ]]; then
   PYTHON_INSTALL  # Exit if Python install not successful.

   echo "Installing PYTHON_TOOLS=others ..."; 
# TODO:
#      pip install git-review
#      pip install scikit-learn

   fancy_echo "pip freeze list of all Python modules installed ::"  >>$LOGFILE
   echo "$(pip freeze)"  >>$LOGFILE
else
   fancy_echo "PYTHON_TOOLS others not specified." >>$LOGFILE
fi

fi # PYTHON_TOOLS



######### TODO: Insert GPG in GitHub:


# TODO: https://help.github.com/articles/telling-git-about-your-gpg-key/
# From https://gist.github.com/danieleggert/b029d44d4a54b328c0bac65d46ba4c65
# Add public GPG key to GitHub
# open https://github.com/settings/keys
# keybase pgp export -q $KEY | pbcopy

# https://help.github.com/articles/adding-a-new-gpg-key-to-your-github-account/


######### TODO: FONTS="opensans, sourcecode" (for editors and web tools)


if [[ -z "${FONTS// }"  ]]; then  #it's blank

if [[ "${FONTS,,}" == *"ubuntu"* ]]; then
   # Download from https://design.ubuntu.com/font/
      # https://assets.ubuntu.com/v1/fad7939b-ubuntu-font-family-0.83.zip
   # In SublimeText user settings file, 
   # For Terminal use: "font face": "Ubunto mono",
   # For writing code, "Luxi mono"
fi

if [[ "${FONTS,,}" == *"sourcecode"* ]]; then
   # https://github.com/adobe-fonts/source-code-pro/releases
   # For text editors: sourcecode (Source Code Pro by Adobe) is clear and thin
   # SourceCodeVariable-Roman.ttf
   # SourceCodeVariable-Italic.ttf
   BREW_CASK_INSTALL "FONTS" "sourcecode" "brew"
fi

   # For web pages: opensans

fi #FONTS


######### LOCALHOSTS SERVERS ::


if [[ "${LOCALHOSTS,,}" == *"nginx"* ]] || [[ "$TRYOUT_KEEP" == *"nginx"* ]]; then
   # See https://wilsonmar.github.io/nginx
   JAVA_INSTALL  # pre-requisite
   BREW_INSTALL "LOCALHOSTS" "nginx" "-v"
   echo -e "openssl :: $(openssl version)" >>$LOGFILE

   # Docroot is:    /usr/local/var/www
   # Files load to: /usr/local/etc/nginx/servers/.
   # Default port   /usr/local/etc/nginx/nginx.conf to 8080 so nginx can run without sudo.
   if [[ "${TRYOUT,,}" == *"nginx"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
      PS_OUTPUT=$(ps -ef | grep nginx)
      if grep -q "nginx: master process" "$PS_OUTFILE" ; then 
         fancy_echo "LOCALHOSTS=nginx running on $PS_OUTPUT." >>$LOGFILE
      else
         if [ ! -z "$NGINX_PORT" ]; then # fall-back if not set in secrets.sh:
            NGINX_PORT="8087"  # default 8080
         fi
         fancy_echo "Configuring LOCALHOSTS /usr/local/etc/nginx/nginx.conf to port $NGINX_PORT ..."
         sed -i "s/8080/$NGINX_PORT/g" /usr/local/etc/nginx/nginx.conf

         fancy_echo "Starting LOCALHOSTS=nginx in background ..."
         nginx &
         
         fancy_echo "Opening localhost:$NGINX_PORT for LOCALHOSTS=nginx ..."
         open "http://localhost:$NGINX_PORT"  # to show default Welcome to Nginx
      fi 
   fi
else
   fancy_echo "LOCALHOSTS nginx not specified." >>$LOGFILE
fi


if [[ "${LOCALHOSTS,,}" == *"tomcat"* ]] || [[ "$TRYOUT_KEEP" == *"tomcat"* ]]; then
   # See https://tomcat.apache.org/
   JAVA_INSTALL  # pre-requisite
   BREW_INSTALL "LOCALHOSTS" "tomcat" "-v"
   if [[ "${TRYOUT,,}" == *"tomcat"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
      PS_OUTPUT=$(ps -ef | grep tomcat)
      if grep -q "/Library/java" "$PS_OUTFILE" ; then 
         fancy_echo "LOCALHOSTS=tomcat running on $PS_OUTPUT." >>$LOGFILE
      else
         if [ ! -z "$TOMCAT_PORT" ]; then # fall-back if not set in secrets.sh:
            TOMCAT_PORT="8089"  # default 8080
         fi
         # Using dynamic path /usr/local/opt/tomcat/
         fancy_echo "Configuring LOCALHOSTS /usr/local/opt/tomcat/libexec/conf/server.xml to port $TOMCAT_PORT ..."
         sed -i "s/8080/$TOMCAT_PORT/g" /usr/local/opt/tomcat/libexec/conf/server.xml
            #     <Connector port="8080" protocol="HTTP/1.1"
            #     <Connector executor="tomcatThreadPool"
            #               port="8089" protocol="HTTP/1.1"

         fancy_echo "Starting LOCALHOSTS=tomcat in background ..."
         catalina run &
         # brew services start tomcat  # To have launchd start tomcat now and restart at login

         fancy_echo "Opening localhost:$TOMCAT_PORT for LOCALHOSTS=tomcat ..."
         open "http://localhost:$TOMCAT_PORT"
         # See https://www.mkyong.com/tomcat/how-to-change-tomcat-default-port/

         catalina stop
      fi 
   fi
else
   fancy_echo "LOCALHOSTS tomcat not specified." >>$LOGFILE
fi


if [[ "${LOCALHOSTS,,}" == *"mountebank"* ]] || [[ "$TRYOUT_KEEP" == *"mountebank"* ]]; then
   # https://github.com/bbyars/mountebank/ for use with SonarQube and other security scanners.
   # http://travelsalmon.com/ is publicly accessible
                  PROJ_PATH="/usr/local/bin/mountebank"
   if [[ "${RUNTYPE,,}" == *"remove"* ]]; then
      if [ ! -d "$PROJ_PATH" ]; then
         echo "LOCALHOSTS $PROJ_PATH not there to remove ..."
      else
         echo "LOCALHOSTS removing $PROJ_PATH ..."
         rm -rf "$PROJ_PATH"
      fi
   else    
      if ! command_exists mb ; then # not downloaded:
         if [ ! -d "$PROJ_PATH" ]; then # not downloaded:
            echo "LOCALHOSTS mountebank PROJ_PATH=$PROJ_PATH ..."
            mkdir   $PROJ_PATH
         fi

         # TODO: Obtain pkg URL from http://www.mbtest.org/docs/install
         URL="https://s3.amazonaws.com/mountebank/v1.14/mountebank-v1.14.0.pkg"
         PKG="mountebank-v1.14.0.pkg"

         if [ ! -f"$PROJ_PATH/$PKG" ]; then # not downloaded:
            echo "LOCALHOSTS mountebank downloading $URL ..."
            # curl -L "$URL" -O "$PROJ_PATH/$PKG" 1>/dev/null 2>/dev/null
         fi

         fancy_echo "LOCALHOSTS mountebank installing/upgrading ..." >>$LOGFILE
         sudo installer -allowUntrusted -pkg "$PROJ_PATH/$PKG" -target /
            # -store # -verboseR # target is a device, not a path.
      fi
      if [[ "${TRYOUT,,}" == *"mountebank"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         echo "LOCALHOSTS mountebank mb starting on $MB_PORT in background ..."
         # http://www.mbtest.org/docs/commandLine
         mb --port "$MB_PORT" --nologfile &
         # RESPONSE: info: [mb:2525] mountebank v1.14.0 now taking orders - point your browser to http://localhost:2525 for help
         open "http://localhost:$MB_PORT"
         # https://github.com/bbyars/mountebank/issues/167#issuecomment-385420564

         if [[ "$TRYOUT_KEEP" != *"mountebank"* ]]; then
            echo "LOCALHOSTS mountebank stopping ..." >>$LOGFILE
            mb stop # --pidfile ~/test/mb.pid
               # RESPONSE: info: [mb:2525] Adios - see you soon?
         else
            # pause 2 minutes to view app on browser
            PID="$(ps x | grep -m1 '/mb' | grep -v "grep" | awk '{print $1}')"
            # 72655 ttys000    0:00.01 sh /usr/local/bin/mb --port 2525 --nologfile
            # 72659 ttys000    0:00.44 /usr/local/mountebank-v1.14.0-darwin-x64/node-v8.9.4-darwin-x64/bin/node /usr/local/mountebank-v1.14.0-darwin-x64/mountebank/bin/mb --port 2525 --nologfile
            echo "LOCALHOSTS mountebank running on PID=$PID." >>$LOGFILE
         fi
      fi
      if [[ "${RUNTYPE,,}" == *"cleanup"* ]]; then
         rm mb.log
      fi
   fi
else
   fancy_echo "LOCALHOSTS mountebank not specified." >>$LOGFILE
fi


if [[ "${LOCALHOSTS,,}" == *"hygieia"* ]] || [[ "$TRYOUT_KEEP" == *"hygieia"* ]]; then
   # https://wilsonmar.github.io/devops-dashboards/
   # https://capitalone.github.io/Hygieia/setup.html
   # NOTE: Hygieia was written in Java to store data in a MongoDB database.
   # The Hygieia API server exposes REST APIs written in Spring Boot and mysema.querydsl.
                  PROJ_PATH="$GITS_PATH/hygieia"
   if [[ "${RUNTYPE,,}" == *"remove"* ]]; then
      if [ ! -d "$PROJ_PATH" ]; then
         echo "LOCALHOSTS $PROJ_PATH not there to remove ..."
      else
         echo "LOCALHOSTS removing $PROJ_PATH ..."
         rm -rf "$PROJ_PATH"
      fi
   else
      PID="$(ps x | grep -m1 '/mongodb' | grep -v "grep" | awk '{print $1}')"
      if [ ! -z "$PID" ]; then
         echo "LOCALHOSTS mongodb starting ..." >>$LOGFILE
         TRYOUT_KEEP="mongodb"
         mongod --dbpath $MONGODB_DATA_PATH --config /usr/local/etc/mongod.conf & 
            # Start mongo shell on the same host machine as the mongod. 
            # --host specifies the localhost address and port that the mongod listens on:
         mongo --host 127.0.0.1:27017 &
            # RESPONSE: configuration is unrestricted.
      else
         echo "LOCALHOSTS mongodb running on PID=$PID." >>$LOGFILE
      fi

echo "here at end $(pwd)"
exit
      if ! command_exists hygieia ; then # not downloaded:
         pushd "$GITS_PATH"
         if [ ! -d "hygieia" ]; then 
            # Fork https://github.com/capitalone/Hygieia
            echo "LOCALHOSTS hygieia cloning to $(pwd) ..." >>$LOGFILE
            git clone https://github.com/capitalone/hygieia --depth=1
            cd hygieia
         else # already there, so update:
            cd hygieia
#            GITHUB_UPDATE
         fi
         echo "LOCALHOSTS mvn at $(pwd) ..." >>$LOGFILE
         mvn clean install package -X -e
            # RESPONSE: [INFO] Total time: 08:34 min
         popd

         echo "LOCALHOSTS config ..." >>$LOGFILE
         FILE_PATH="$GITS_PATH/hygieia/UI/gulfile.js"
         if grep -q "browserSync.init({\n          server: {" "$FILE_PATH" ; then
            fancy_echo "adding in file. " >>$LOGFILE
         else
            fancy_echo "Adding port: $HYGIEIA_PORT $FILE_PATH ..."
            # HYGIEIA_PORT="9100" defined earlier
            sed -i "1n; /^server: {/i \\\tport: $HYGIEIA_PORT\," "$FILE_PATH"
         fi
      fi

      if [[ "${TRYOUT,,}" == *"hygieia"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         echo "LOCALHOSTS hygieia mb starting on $MB_PORT in background ..."

         # gulpfile.js
         # pulling from SONAR_INSTALL ?

         open "http://localhost:$HYGIEIA_PORT"
            # https://capitalone.github.io/Hygieia/troubleshoot.html
            # https://github.com/bbyars/hygieia/issues/167#issuecomment-385420564

         if [[ "$TRYOUT_KEEP" != *"hygieia"* ]]; then
            echo "LOCALHOSTS hygieia stopping ..." >>$LOGFILE
            # ??? 
         else
            # pause 2 minutes to view app on browser
            PID="$(ps x | grep -m1 '/mb' | grep -v "grep" | awk '{print $1}')"
            echo "LOCALHOSTS hygieia running on PID=$PID." >>$LOGFILE
         fi
      fi
   fi
else
   fancy_echo "LOCALHOSTS hygieia not specified." >>$LOGFILE
fi



######### Use git-secret to manage secrets in a git repository:


if [[ "${GIT_TOOLS,,}" == *"git-secrets"* ]]; then
   # See https://github.com/sobolevn/git-secret
   BREW_INSTALL "GIT_TOOLS" "git-secret" "--version"
else
   fancy_echo "GIT_TOOLS git-secrets not specified." >>$LOGFILE
fi
   # QUESTION: Supply passphrase or create keys without passphrase



######### Cloud CLI/SDK:


fancy_echo "CLOUD_TOOLS=\"$CLOUD_TOOLS\"" >>$LOGFILE

function DOCKER_INSTALL() {  # https://docs.docker.com/install/
   # First remove boot2docker and Kitematic https://github.com/boot2docker/boot2docker/issues/437
   # https://store.docker.com/editions/community/docker-ce-desktop-mac
   if ! command_exists docker ; then
      fancy_echo "Installing docker ..."
      brew install docker  docker-compose  docker-machine  xhyve  docker-machine-driver-xhyve
      # This creates folder ~/.docker
      # Docker images are stored in $HOME/Library/Containers/com.docker.docker
      brew link --overwrite docker
      # /usr/local/bin/docker -> /Applications/Docker.app/Contents/Resources/bin/docker
      brew link --overwrite docker-machine
      brew link --overwrite docker-compose

      # docker-machine-driver-xhyve driver requires superuser privileges to access the hypervisor. To enable, execute:
      sudo chown root:wheel /usr/local/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
      sudo chmod u+s /usr/local/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
   else
      if [[ "${RUNTYPE,,}" == *"upgrade"* ]]; then
         fancy_echo "docker upgrading ..."
         docker version
         brew upgrade docker-machine-driver-xhyve
         brew upgrade xhyve
         brew upgrade docker-compose  
         brew upgrade docker-machine 
         brew upgrade docker 
      fi
   fi
   fancy_echo "DOCKER_INSTALL $(docker --version)" >>$LOGFILE
      # Docker version 18.03.0-ce, build 0520e24
      # Client:
       # Version: 18.03.0-ce
       # API version: 1.37
       # Go version:  go1.9.4
       # Git commit:  0520e24
       # Built: Wed Mar 21 23:06:22 2018
       # OS/Arch: darwin/amd64
       # Experimental:  false
       # Orchestrator:  swarm
}
if [[ "${CLOUD_TOOLS,,}" == *"docker"* ]]; then  # contains gcp.
   DOCKER_INSTALL

   if [[ "${TRYOUT,,}" == *"docker"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
      fancy_echo "TRYOUT run docker ..."
      docker-machine create default

      # See https://github.com/bonusbits/devops_bash_config_examples/blob/master/shared/.bash_docker
      # https://www.upcloud.com/support/how-to-configure-docker-swarm/
      # docker-machine --help
      # Create a machine:
      # docker-machine create default --driver xhyve --xhyve-experimental-nfs-share
      # docker-machine create -d virtualbox dev1
      # eval $(docker-machine env default)
      # docker-machine upgrade dev1
      # docker-machine rm dev2fi

      # docker run -d dockerswarm/swarm:master join --advertise=192.168.1.105:2375 consul://192.168.1.103:8500
      # sudo docker run -d dockerswarm/swarm:master join --advertise=192.168.1.105:2375 consul://192.168.1.103:8500
   fi
else
   fancy_echo "CLOUD_TOOLS docker not specified." >>$LOGFILE
fi


if [[ "${CLOUD_TOOLS,,}" == *"icloud"* ]]; then
   if [ ! -d "/Library/Mobile Documents/com~apple~CloudDocs/" ]; then # found dir:
      fancy_echo "CLOUD_TOOLS=icloud folder has $(find . -type f | wc -l) files ..."
   fi
fi

if [[ "${CLOUD_TOOLS,,}" == *"vagrant"* ]]; then
   VIRTUALBOX_INSTALL # pre-requisite
   BREW_INSTALL "CLOUD_TOOLS" "vagrant" "brew"

   if [[ "${TRYOUT,,}" == *"vagrant"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
      if [[ "${LANG_TOOLS,,}" == *"python"* ]]; then  # contains azure.
         PYTHON_PGM="hooks/basic-python2"

         if [[ "${TRYOUT,,}" == *"cleanup"* ]]; then
            fancy_echo "$PYTHON_PGM TRYOUT == cleanup ..."
            rm -rf $PYTHON_PGM
         fi
      fi
      if [[ "${LANG_TOOLS,,}" == *"python3"* ]]; then  # contains azure.
         PYTHON_PGM="hooks/basic-python3"
         if [[ "${TRYOUT,,}" == *"cleanup"* ]]; then
            fancy_echo "$PYTHON_PGM TRYOUT == cleanup ..."
            rm -rf $PYTHON_PGM
         fi
      fi

      # Create a test directory and cd into the test directory.
      #vagrant init precise64  # http://files.vagrantup.com/precise64.box
      #vagrant up
      #vagrant ssh  # into machine
      #vagrant suspend
      #vagrant halt
      #vagrant destroy 
   fi
else
   fancy_echo "CLOUD_TOOLS vagrant not specified." >>$LOGFILE
fi


if [[ "${CLOUD_TOOLS,,}" == *"ironworker"* ]]; then
   # See http://dev.iron.io/worker/cli/ and https://github.com/iron-io/ironcli
   # Dont brew install ironcli for IronMQ http://dev.iron.io/mq/3/on-premise/installation/single.html
   # BREW_INSTALL "CLOUD_TOOLS" "iron-functions" "brew"
      # /usr/local/Cellar/iron-functions/0.2.72: 4 files, 16.4MB from https://github.com/iron-io/functions
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      # Instead of BREW_INSTALL "CLOUD_TOOLS" "ironworker" "brew"
      curl -sSL https://cli.iron.io/install | sh

      if [[ "${TRYOUT,,}" == *"ironworker"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         echo "CLOUD_TOOLS ironworker $GITS_PATH/ironworker running ..." >>$LOGFILE
         # Per http://dev.iron.io/worker/getting_started/
         # $IRON_TOKEN
         # $IRON_PROJECT_ID
         # worker-us-east.iron.io
         DOCKER_INSTALL  # pre-requisite
         docker run --rm -it -v "$PWD":/worker -w /worker iron/ruby ruby tests/iron_hello.rb
         # docker run --rm -v "$(pwd)":/worker -w /worker IMAGE[:TAG] 'MY_COMMAND -payload MY_PAYLOAD.json'
      fi
   fi
else
   fancy_echo "CLOUD_TOOLS ironworker not specified." >>$LOGFILE
fi


function LIQUIBASE_INSTALL() {
   fancy_echo "LIQUIBASE_INSTALL starting ..." 
   # https://www.liquibase.org/
   BREW_INSTALL "LIQUIBASE_INSTALL" "liquibase" "--version"
      # /usr/local/Cellar/liquibase/3.6.1: 2,043 files, 38.9MB, built in 2 seconds
      # Starting Liquibase at Thu, 26 Apr 2018 13:12:01 MDT (version 3.6.1 built at 2018-04-11 08:41:04)
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
                   LIQUIBASE_HOME="/usr/local/opt/liquibase/libexec"
      echo "export LIQUIBASE_HOME='/usr/local/opt/liquibase/libexec'" >>$BASHFILE
      # Add changelog & changeset: https://www.liquibase.org/quickstart.html
      echo "LIQUIBASE_INSTALL LIQUIBASE_HOME=$LIQUIBASE_HOME ..." 
   fi
}
if [[ "${CLOUD_TOOLS,,}" == *"rancher"* ]]; then
   # See https://github.com/rancher/rancher/wiki/Cowpoke-1:-Getting-Started-with-Rancher
   # https://rancher.com
   LIQUIBASE_INSTALL
   BREW_INSTALL "CLOUD_TOOLS" "rancher-cli" "brew"
   BREW_INSTALL "CLOUD_TOOLS" "rancher-compose" "brew"
   PYTHON_INSTALL
   DOCKER_INSTALL

   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      GITS_PATH_INIT "rancher"
      pushd "$GITS_PATH/rancher"
         if [ ! -d "cattle" ]; then 
            git clone https://github.com/rancher/cattle.git --depth=1
            chmod +x scripts/*
         else # already there, so update:
            cd cattle
            GITHUB_UPDATE
         fi
      popd
      echo "back at $(PWD)"

      if [[ "${TRYOUT,,}" == *"rancher"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         echo "CLOUD_TOOLS rancher $GITS_PATH/rancher running ..." >>$LOGFILE
      fi
   fi
else
   fancy_echo "CLOUD_TOOLS rancher not specified." >>$LOGFILE
fi


# See https://wilsonmar.github.io/gcp
if [[ "${CLOUD_TOOLS,,}" == *"gcp"* ]]; then
   # See https://cloud.google.com/sdk/docs/
   PYTHON_INSTALL  # function defined at top of this file.

   # TODO: Override alias:
      if grep -q "alias gcs=" "$BASHFILE" ; then    
         fancy_echo "alias gcs= already in $BASHFILE" >>$LOGFILE
      else
         fancy_echo "Adding alias gcs in $BASHFILE ..."
         echo "alias gcs='cd ~/.google-cloud-sdk;ls'" >>"$BASHFILE"
      fi
   BREW_CASK_INSTALL "CLOUD_TOOLS" "google-cloud-sdk" "gcloud --version"
      #gcloud --version
         # Google Cloud SDK 194.0.0
         # bq 2.0.30
         # core 2018.03.16
         # gsutil 4.29
   # NOTE: gcloud command on its own results in an error.
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      fancy_echo "Run \"gcloud init\" "
      # See https://cloud.google.com/appengine/docs/standard/python/tools/using-local-server
      # about creating the app.yaml configuration file and running dev_appserver.py  --port=8085
      fancy_echo "Run \"gcloud auth login\" for web page to authenticate login."
      # successful auth leads to https://cloud.google.com/sdk/auth_success
      fancy_echo "Run \"gcloud config set account your-account\""
      # Response is "Updated property [core/account]."
   fi
else
   fancy_echo "CLOUD_TOOLS gcp not specified." >>$LOGFILE
fi


if [[ "${CLOUD_TOOLS,,}" == *"awscli"* ]]; then  # contains aws.
   fancy_echo "awscli requires Python3."
   # See https://docs.aws.amazon.com/cli/latest/userguide/cli-install-macos.html#awscli-install-osx-pip
   PYTHON3_INSTALL  # function defined at top of this file.
   # :  # break out immediately. Not execute the rest of the if strucutre.
   # https://www.youtube.com/watch?v=zEQUuo5nWbo

   if ! command_exists aws ; then
      fancy_echo "Installing awscli using PIP ..."
      pip3 install awscli --upgrade --user
   else
      if [[ "${RUNTYPE,,}" == *"upgrade"* ]]; then
         fancy_echo "awscli upgrading ..."
         aws --version  # aws-cli/1.11.160 Python/2.7.10 Darwin/17.4.0 botocore/1.7.18
         pip3 upgrade awscli --upgrade --user
      fi
   fi
   echo "$(aws --version)" >>$LOGFILE  # aws-cli/1.11.160 Python/2.7.10 Darwin/17.4.0 botocore/1.7.18

   # TODO: https://github.com/bonusbits/devops_bash_config_examples/blob/master/shared/.bash_aws
   # For aws-cli commands, see http://docs.aws.amazon.com/cli/latest/userguide/ 
else
   fancy_echo "CLOUD_TOOLS awscli not specified." >>$LOGFILE
fi




if [[ "${CLOUD_TOOLS,,}" == *"azure"* ]]; then  # contains azure.
   # See https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos?view=azure-cli-latest
   # Issues at https://github.com/Azure/azure-cli/issues

   # NOTE: The az CLI does not use a Python virtual environment. So ...
   PYTHON3_INSTALL  # function defined at top of this file.
   NODE_INSTALL
   # Python location '/usr/local/opt/python/bin/python3.6'

   BREW_INSTALL "CLOUD_TOOLS" "azure-cli" "az --version"
       # azure-cli (2.0.30)

   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then

      if [[ "${TRYOUT,,}" == *"az-func"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         AZ_TENANT="$(az account show --query 'tenantId' -o tsv)"
         # Add aliases func, azfun, azurefunctions :
         npm install -g azure-functions-core-tools@core # v2 to run functions locally
         # https://docs.microsoft.com/en-us/azure/azure-functions/functions-reference#folder-structure         
         # https://www.microsoft.com/net/learn/get-started/macos
         # Following https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local
         if [ ! -d "MyFunctionProj" ]; then  # /usr/local/bin/gcloud not installed
            func init MyFunctionProj  # create folder as Git repo
         fi
         cd MyFunctionProj
         # Scrape https://www.nuget.org/packages?q=Microsoft.Azure.WebJobs.Extensions.CosmosDB for Latest version: Latest version: 3.0.0-beta7
         # #skippedToContent > section > div.list-packages > article > div > div.col-sm-11 > ul > li:nth-child(3) > span > span
         LATEST_VERSION="3.0.0-beta7"
         func extensions install --package Microsoft.Azure.WebJobs.Extensions.CosmosDB --version "$LATEST_VERSION"
         # BLAH: No such file or directory
         # https://docs.microsoft.com/en-us/azure/azure-functions/functions-triggers-bindings#register-binding-extensions
      fi

      if [[ "${TRYOUT,,}" == *"az-vm"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         # Create a virtual memory instance and exit
         AZ_TENANT="$(az account show --query 'tenantId' -o tsv)"
      
         # NOTE: Logging in through command line is not supported. For cross-check, try 'az login' to authenticate through browser.
         # TODO: Create a service principal see https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest

         # TODO: Login using service principal from variables in secrets.sh:
         # See https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli?view=azure-cli-latest
         # az login --service-principal -u $AZ_USER -p $AZ_PASSWORD --tenant $AZ_TENANT
         # Get tenantID from: az account show --query 'tenantId' -o tsv

         # TODO(wisdom): Invoke a Python Selenium test script to do Device Login:
         # On az login - open a web browser to https://microsoft.com/devicelogin 
         # and enter the code BS3FNKPB3 to authenticate. Click Continue.
         # <input id="security-token" class="form-control" type="password" name="j_password">
         python tests/az_login_setup.py  "chrome"  $AZ_USER  $AZ_PASSWORD

         # Create resource group:
         az group create --name TutorialResources --location eastus

         # Create virtual machine: https://docs.microsoft.com/en-us/cli/azure/azure-cli-vm-tutorial?view=azure-cli-latest#step-3
         az vm create --resource-group TutorialResources \
        --name TutorialVM1 \
        --image UbuntuLTS \
        --generate-ssh-keys \
        --verbose

         # Get VM information with queries:
         az vm show --name TutorialVM1 --resource-group TutorialResources

         # Set environment variables from CLI output:
         az network nic show --ids $NIC_ID -g TutorialResources \
            --query '{IP:ipConfigurations[].publicIpAddress.id, Subnet:ipConfigurations[].subnet.id}'

         # Create the new VM on the subnet:
         VM2_IP_ADDR=$(az vm create -g TutorialResources \
           -n TutorialVM2 \
           --image UbuntuLTS \
           --generate-ssh-keys \
           --subnet $SUBNET_ID \
          --query publicIpAddress \
          -o tsv)

         # SSH into:
         ssh $VM2_IP_ADDR

         # Cleanup:
         az group delete --name TutorialResources --no-wait

         # See https://www.robinosborne.co.uk/2014/11/18/scripting-a-statsd-mongodb-elasticsearch-metrics-server-on-azure-with-powershell/
      fi
   fi
else
   fancy_echo "CLOUD_TOOLS azure not specified." >>$LOGFILE
fi

if [[ "${CLOUD_TOOLS,,}" == *"serverless"* ]]; then

      if ! command_exists serverless ; then
         NODE_INSTALL
         npm install serverless -g  # Install serverless globally
      fi
      echo "npm install serverless :: $(serverless --version)" >>$LOGFILE


   if [[ "${TRYOUT,,}" == *"serverless-aws"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
      # See https://serverless.com/getting-started/, docs.serverless.com, forum.serverless.com, gitter.im/serverless/serverless

      SERVERLESS_FOLDER="~/serverless"  # TODO: user define in secrets.sh
      if [ ! -d "$SERVERLESS_FOLDER" ]; then # found dir:
         fancy_echo "Making folder $SERVERLESS_FOLDER ..."
         mkdir $SERVERLESS_FOLDER
         cd $SERVERLESS_FOLDER
      fi

      if [ ! -z "$AWS_ACCESS_KEY_ID" ]; then
         fancy_echo "AWS_ACCESS_KEY_ID not defined. ..."
         # See https://www.youtube.com/watch?v=HSd9uYj2LJA
         exit
      fi
      if [ ! -z "$AWS_SECRET_ACCESS_KEY" ]; then
         fancy_echo "AWS_SECRET_ACCESS_KEY not defined. ..."
         exit
      fi
      if [ ! -z "$AWS_REGION" ]; then
         fancy_echo "AWS_REGION not defined. us-west-1 assumed ..."
         AWS_REGION="us-west-1"
      fi
      # TODO: Recognize Login on https://platform.serverless.com/login?cli=v1&login-id=...

      serverless login  # popup browser for Github login to authorize serverless. 
         # Serverless: Waiting for a successful authentication in the browser.
         # Serverless: You are now logged in (to GitHub)
      serverless create --template hello-world  # to  Generating boilerplate...
         # TODO: sed in serverless.yml "service: serverless-hello-world" to your own service name ???
         # NOTE in file runtime:nodejs6.10 for http://bit.ly/aws-creds-setup
      serverless deploy -r "$AWS_REGION" -s dev -v
         # RESPONSE: enpoints: GET - https://ojbr.execute-api.us-east-1...
      # TODO: replace xyz ???
      open "http://xyz.amazonaws.com/hello-world"
   fi

   if [[ "${TEST_TOOLS,,}" == *"serverless-aws"* ]]; then
      fancy_echo "\"serverless-aws\" remains running ..." >>$LOGFILE
   else
      fancy_echo "\"serverless-aws\" being removed ..."
      serverless remove
   fi
else
   fancy_echo "CLOUD_TOOLS serverless not specified." >>$LOGFILE
fi


if [[ "${CLOUD_TOOLS,,}" == *"heroku"* ]]; then  # contains heroku.
   # https://cli.heroku.com
      # https://devcenter.heroku.com/articles/heroku-cli
   BREW_INSTALL "CLOUD_TOOLS" "heroku" "-v"
      # Cloning into '/usr/local/Homebrew/Library/Taps/heroku/homebrew-brew'...
      # heroku-cli/6.16.8-ae149be (darwin-x64) node-v9.10.1
else
   fancy_echo "CLOUD_TOOLS heroku not specified." >>$LOGFILE
fi


if [[ "${CLOUD_TOOLS,,}" == *"openstack"* ]]; then  # contains openstack.
   # See https://iujetstream.atlassian.net/wiki/spaces/JWT/pages/40796180/Installing+the+Openstack+clients+on+OS+X
   PYTHON_INSTALL  # function defined at top of this file.
   BREW_INSTALL "CLOUD_TOOLS" "openstack" "--version"
   # openstack --version | grep openstack
      # openstack (2.0.30)
      # ... and many other lines.
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      if [[ "${TRYOUT,,}" == *"openstack"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         OPENSTACK_PROJECT="openstack1"
         # Start the VirtualEnvironment software:
         virtualenv "$OPENSTACK_PROJECT"

         # Activate the VirtualEnvironment for the project:
         source "$OPENSTACK_PROJECT/bin/activate"

         # Install OpenStack clients:
         pip install python-keystoneclient python-novaclient python-heatclient python-swiftclient python-neutronclient python-cinderclient python-glanceclient python-openstackclient

         # Set up your OpenStack credentials: See Setting up openrc.sh for details.
         source .openrc

         # Test a non-destructive Open Stack command:
         openstack image list
      fi
   fi
else
   if [[ "${TRYOUT,,}" == *"openstack"* ]]; then
      fancy_echo "ERROR: \"openstack\" needs to be in CLOUD_TOOLS for TRYOUT."
   fi
fi

if [[ "${CLOUD_TOOLS,,}" == *"minikube"* ]] || [[ "$TRYOUT_KEEP" == *"minikube"* ]]; then 
   # See https://kubernetes.io/docs/tasks/tools/install-minikube/
   PYTHON_INSTALL  # function defined at top of this file.
   VIRTUALBOX_INSTALL # pre-requisite

   BREW_INSTALL "CLOUD_TOOLS" "kubectl" "version"
      # minikube version: v0.25.2 
            # ... and many other lines.

   BREW_INSTALL "CLOUD_TOOLS" "minikube" "version"

   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then

      if [[ "${TRYOUT,,}" == *"minikube"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         fancy_echo "TRYOUT run minikube ..."
         kubectl cluster-info
         #kubectl cluster-info dump  # for diagnostis
         # based on https://kubernetes.io/docs/getting-started-guides/minikube/
         fancy_echo "TRYOUT CLOUD_TOOLS=\"minikube\" starting (Downloading Minikube ISO) ..."
         minikube start
         # Subsequent calls:
         # Starting local Kubernetes v1.9.4 cluster...
         # Starting VM...
         # Getting VM IP address...
         # Setting up certs...
         # Connecting to cluster...
         # Setting up kubeconfig...
         # Starting cluster components...
         # Kubectl is now configured to use the cluster.
         # Loading cached images from config file.
         minikube ip
         # 192.168.99.101

         if [ ! -z "$MINIKUBE_PORT" ]; then # fall-back if not set in secrets.sh:
            MINIKUBE_PORT="8083"  # default 8080
         fi
         kubectl run hello-minikube --image=k8s.gcr.io/echoserver:1.4 --port="$MINIKUBE_PORT"
          # deployment "hello-minikube" created
         export no_proxy=$no_proxy,$(minikube ip)
         kubectl expose deployment hello-minikube --type=NodePort
          # service "hello-minikube" exposed
         kubectl get svc
          # NAME             TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
          # hello-minikube   NodePort    10.103.43.52   <none>        8083:30407/TCP   11s
          # kubernetes       ClusterIP   10.96.0.1      <none>        443/TCP          28m
         kubectl get pod
          # NAME                              READY     STATUS    RESTARTS   AGE
          # hello-minikube-798bc4dc8f-8nx7h   1/1       Running   1          8m
         minikube service hello-minikube --url
          # http://192.168.99.101:30407
         curl $(minikube service hello-minikube --url)
          # curl: (7) Failed to connect to 192.168.99.101 port 30123: Connection refused
          # CLIENT VALUES:
          # client_address=192.168.99.1
          # command=GET
          # real path=/ ....
         minikube dashboard  # http://192.168.99.101:30000/#!/overview?namespace=default


         kubectl delete services hello-minikube
         # RESPONSE: service "hello-minikube" deleted
         kubectl delete deployment hello-minikube
         # deployment.extensions "hello-minikube" deleted
         minikube stop
         # Stopping local Kubernetes cluster...
         # Machine stopped.
      fi
   fi
else
   fancy_echo "CLOUD_TOOLS minikube not specified." >>$LOGFILE
fi


# https://docs.openstack.org/mitaka/user-guide/common/cli_install_openstack_command_line_clients.html

# TODO: IBM's Cloud CLI from brew? brew search did not find it.
# is installed on MacOS by package IBM_Cloud_CLI_0.6.6.pkg from
# page https://console.bluemix.net/docs/cli/reference/bluemix_cli/get_started.html#getting-started
# or curl -fsSL https://clis.ng.bluemix.net/install/osx | sh
# Once installed, the command is "bx login".
# IBM's BlueMix cloud for AI has a pre-prequisite in NodeJs.
# npm install watson-visual-recognition-utils -g
# npm install watson-speech-to-text-utils -g
# See https://www.ibm.com/blogs/bluemix/2017/02/command-line-tools-watson-services/


if [[ "${CLOUD_TOOLS,,}" == *"cf"* ]]; then  # contains aws.
   # See https://docs.cloudfoundry.org/cf-cli/install-go-cli.html
   # Tap so no BREW_INSTALL "CLOUD_TOOLS" "cf" "--version"
   if ! command_exists cf ; then
      fancy_echo "Installing cf (Cloud Foundry CLI) ..."
      brew install cloudfoundry/tap/cf-cli
      # see https://github.com/cloudfoundry/cli
      brew info cf-cli >>$LOGFILE
      brew list cf-cli >>$LOGFILE

      # To uninstall on Mac OS, delete the binary /usr/local/bin/cf, and the directory /usr/local/share/doc/cf-cli.
   else
      if [[ "${RUNTYPE,,}" == *"upgrade"* ]]; then
         fancy_echo "cf upgrading ..."
         cf --version
            # cf version 6.35.2+88a03e995.2018-03-15
         brew upgrade cloudfoundry/tap/cf-cli
      fi
   fi
   fancy_echo "$(cf --version)" >>$LOGFILE
      # cf version 6.35.2+88a03e995.2018-03-15

   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      if [[ "${TRYOUT,,}" == *"cf"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         fancy_echo "TRYOUT run cf ..."
      fi
   fi
else
   if [[ "${TRYOUT,,}" == *"cf"* ]]; then
      fancy_echo "ERROR: \"cf\" needs to be in CLOUD_TOOLS for TRYOUT."
   fi
fi


######### Virtualenv for Python 2 and Python3:


   # virtualenv supports both Python2 and Python3.
   # virtualenv -p "$(command -v python)" hooks/basic-python2
      #New python executable in /Users/wilsonmar/gits/wilsonmar/git-utilities/tests/basic-python2/bin/python2.7
      #Also creating executable in /Users/wilsonmar/gits/wilsonmar/git-utilities/tests/basic-python2/bin/python
      # Installing setuptools, pip, wheel...
   # virtualenv -p "$(command -v python3)" tests/basic-python3
   # virtualenv -p "c:\Python34\python.exe foo
if [[ "${PYTHON_TOOLS,,}" == *"virtualenv"* ]]; then
      if ! command_exists virtualenv ; then
         fancy_echo "Installing PYTHON_TOOLS=\"virtualenv\" to manage multiple Python versions ..."
         pip3 install virtualenv
         pip3 install virtualenvwrapper
         source /usr/local/bin/virtualenvwrapper.sh
      else
         fancy_echo "No upgrade on MacOS for PYTHON_TOOLS=\"virtualenv\"."
      fi
      #fancy_echo "Opening virtualenv ..."
      #virtualenv

      if [[ "${TRYOUT,,}" == *"virtualenv"* ]]; then
         fancy_echo "ERROR: \"virtualenv\" needs to be in PYTHON_TOOLS for TRYOUT."
      fi
else
      fancy_echo "PYTHON_TOOLS virtualenv not specified." >>$LOGFILE
fi



######### SSH-KeyGen:


if [[ "${GIT_TOOLS,,}" == *"keygen"* ]]; then  # contains aws.
   # PROTIP: Consider brew install shuttle for ssh management
   #FILE="$USER@$(uname -n)-$RANDOM"  # computer node name.
   SSH_USER="$USER@$(uname -n)"  # computer node name.
   fancy_echo "Diving into folder ~/.ssh ..." >>$LOGFILE

   if [ ! -d "$HOME/.ssh" ]; then # found dir:
      fancy_echo "Making ~/.ssh folder ..." >>$LOGFILE
      mkdir $HOME/.ssh
   fi

   pushd ~/.ssh  # specification of folder didn't work.

   FILEPATH="$HOME/.ssh/$SSH_USER"
   if [ -f "$SSH_USER" ]; then # found:
      fancy_echo "File \"${FILEPATH}\" already exists." >>$LOGFILE
   else
      fancy_echo "ssh-keygen creating \"${FILEPATH}\" instead of id_rsa ..."
      ssh-keygen -f "${SSH_USER}" -t rsa -N ''
         # -Comment, -No passphrase or -P
      ssh-keygen -f "$SSH_USER.pub" -m 'PEM' -e > "$SSH_USER.pem"  # for use by AZ
      chmod 600 $SSH_USER.pem
   fi

   ######### ~/.ssh/config file of users:

   SSHCONFIG=~/.ssh/config
   if [ ! -f "$SSHCONFIG" ]; then 
      fancy_echo "$SSHCONFIG file not found. Creating..."
      touch $SSHCONFIG
   else
      OCCURENCES=$(echo ${SSHCONFIG} | grep -o '\<HostName\>')
      fancy_echo "$SSHCONFIG file already created with $OCCURENCES entries." >>$LOGFILE
      # Do not delete $SSHCONFIG file!
   fi
   echo -e "\n   $SSHCONFIG ::" >>$LOGFILE
   echo -e "$(cat $SSHCONFIG)" >>$LOGFILE

   # See https://www.saltycrane.com/blog/2008/11/creating-remote-server-nicknames-sshconfig/
   if grep -q "$FILEPATH" "$SSHCONFIG" ; then    
      fancy_echo "SSH \"$FILEPATH\" to \"$GITHUB_ACCOUNT\" already in $SSHCONFIG" >>$LOGFILE
   else
      # Do not delete $SSHCONFIG

      # Check if GITHUB_ACCOUNT has content:
      if [ ! -f "$GITHUB_ACCOUNT" ]; then 
         fancy_echo "Adding SSH $FILEPATH to \"$GITHUB_ACCOUNT\" in $SSHCONFIG..."
         echo "# For: git clone git@github.com:${GITHUB_ACCOUNT}/some-repo.git from $GIT_ID" >>$SSHCONFIG
         echo "# $LOG_DATETIME" >>$SSHCONFIG
         echo "Host github.com" >>$SSHCONFIG
         echo "    Hostname github.com" >>$SSHCONFIG
         echo "    User git" >>$SSHCONFIG
         echo "    IdentityFile $FILEPATH" >>$SSHCONFIG
         echo "Host gist.github.com" >>$SSHCONFIG
         echo "    Hostname github.com" >>$SSHCONFIG
         echo "    User git" >>$SSHCONFIG
         echo "    IdentityFile $FILEPATH" >>$SSHCONFIG
      fi
   fi

   ######### Paste SSH Keys in GitHub:

   # NOTE: pbcopy is a Mac-only command:
   if [ "$(uname)" == "Darwin" ]; then
      pbcopy < "$SSH_USER.pub"  # in future pbcopy of password and file transfer of public key.
   #elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
   fi

   fancy_echo "Now you copy contents of \"${FILEPATH}.pub\", "
   echo "and paste into GitHub, Settings, New SSH Key ..."
   #   open https://github.com/settings/keys
   ## TODO: Add a token using GitHub API from credentials in secrets.sh 

   # see https://www.thegeekstuff.com/2008/11/3-steps-to-perform-ssh-login-without-password-using-ssh-keygen-ssh-copy-id/

   fancy_echo "Pop from folder $FILEPATH ..." >>$LOGFILE
   popd
   echo "At $(pwd)" >>$LOGFILE
else
   fancy_echo "GIT_TOOLS keygen not specified." >>$LOGFILE
fi # keygen


######### Selenium browser drivers:


fancy_echo "BROWSERS=$BROWSERS" >>$LOGFILE
# To click and type on browser as if a human would do.
# See http://seleniumhq.org/
# Not necessarily: if [[ "${TEST_TOOLS,,}" == *"selenium"* ]]; then  # contains .
   # https://www.utest.com/articles/selenium-setup-on-a-mac-and-configuring-selenium-webdriver-on-mac-os
   # per ttps://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Cross_browser_testing/Your_own_automation_environment

   # Download the latest webdrivers into folder /usr/bin: https://www.seleniumhq.org/about/platforms.jsp
   # Edge:     https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver/
   # Safari:   https://webkit.org/blog/6900/webdriver-support-in-safari-10/
      # See https://itisatechiesworld.wordpress.com/2015/04/15/steps-to-get-selenium-webdriver-running-on-safari-browser/
      # says it's unstable since Yosemite
   # Brave: https://github.com/brave/muon/blob/master/docs/tutorial/using-selenium-and-webdriver.md
      # Much more complicated!

   if [[ "${BROWSERS,,}" == *"chrome"* ]]; then  # contains azure.
      # Chrome:   https://sites.google.com/a/chromium.org/chromedriver/downloads
      if ! command_exists chromedriver ; then
         brew install chromedriver  # to /usr/local/bin/chromedriver
            brew info chromedriver >>$LOGFILE
            brew list chromedriver >>$LOGFILE
      fi

      PS_OUTPUT=$(ps -ef | grep chromedriver)
      if grep -q "chromedriver" "$PS_OUTFILE" ; then # chromedriver 2.36 is already installed
         fancy_echo "chromedriver already running." >>$LOGFILE
      else
         fancy_echo "Deleting chromedriver.log from previous session ..."
         rm chromedriver.log
      fi 

      if [[ "${TRYOUT,,}" == *"chrome"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         PS_OUTPUT=$(ps -ef | grep chromedriver)
         if grep -q "chromedriver --port" "$PS_OUTPUT" ; then    
            fancy_echo "chromedriver already running." >>$LOGFILE
         else
            fancy_echo "Starting chromedriver in background ..."
            chromedriver & # invoke:
            # Starting ChromeDriver 2.36.540469 (1881fd7f8641508feb5166b7cae561d87723cfa8) on port 9515
            # Only local connections are allowed.
            # [1522424121.500][SEVERE]: bind() returned an error, errno=48: Address already in use (48)
            ps | grep chromedriver
            # 1522423621378   chromedriver   INFO  chromedriver 0.20.0
            # 1522423621446   chromedriver   INFO  Listening on 127.0.0.1:4444
         fi
      fi
   else
      fancy_echo "BROWSERS chrome not specified." >>$LOGFILE
   fi


   if [[ "${BROWSERS,,}" == *"firefox"* ]]; then  # contains azure.
      # Firefox:  https://github.com/mozilla/geckodriver/releases
      if ! command_exists geckodriver ; then
             brew install geckodriver  # to /usr/local/bin/geckodriver
                brew info geckodriver >>$LOGFILE
                brew list geckodriver >>$LOGFILE
      fi

      if grep -q "/usr/local/bin/geckodriver" "$BASHFILE" ; then    
         fancy_echo "PATH to geckodriver already in $BASHFILE"
      else
         fancy_echo "Adding PATH to /usr/local/bin/geckodriver in $BASHFILE..."
         echo "" >>"$BASHFILE"
         echo "export PATH=\"\$PATH:/usr/local/bin/geckodriver\"" >>"$BASHFILE"
         source "$BASHFILE"
      fi 

      if [[ "${TRYOUT,,}" == *"firefox"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         PS_OUTPUT=$(ps -ef | grep geckodriver)
         if grep -q "geckodriver --port" "$PS_OUTPUT" ; then    
            fancy_echo "geckodriver already running." >>$LOGFILE
         else
            fancy_echo "Starting geckodriver in background ..."
            geckodriver & # invoke:
            # 1522423621378   geckodriver INFO  geckodriver 0.20.0
            # 1522423621446   geckodriver INFO  Listening on 127.0.0.1:4444
         fi
         ps | grep geckodriver
      fi 
   else
      fancy_echo "BROWSERS firefox not specified." >>$LOGFILE
   fi

   if [[ "${BROWSERS,,}" == *"phantomjs"* ]]; then  # contains azure.
      # NOTE: http://phantomjs.org/download.html is for direct download.
      if ! command_exists phantomjs ; then
         brew install phantomjs  # to /usr/local/bin/phantomjs  # for each MacOS release
            brew info phantomjs >>$LOGFILE
            brew list phantomjs >>$LOGFILE
      else
         if [[ "${RUNTYPE,,}" == *"upgrade"* ]]; then
            # No need to invoke driver.
            fancy_echo "phantomjs upgrading ..."
            phantomjs --version  # 2.1.1
            brew upgrade phantomjs
         fi
      fi
      PHANTOM_VERSION=$(phantomjs --version)  # 2.1.1
      fancy_echo "PHANTOM_VERSION=$PHANTOM_VERSION"
      # NOTE: "export phantomjs= not nessary with brew install.

      if [[ "${TRYOUT,,}" == *"phantomjs"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         phantomjs tests/phantomjs-smoke.js
         # More code at http://phantomjs.org/quick-start.html
      fi
   else
      fancy_echo "BROWSERS phantomjs not specified." >>$LOGFILE
   fi

   if [[ "${BROWSERS,,}" == *"others"* ]]; then  # contains azure.
      fancy_echo "Browser add-ons: "
      #BREW_CASK_INSTALL "BROWSERS" "flash-player" "" "brew"  # https://github.com/caskroom/homebrew-cask/blob/master/Casks/flash-player.rb
      #BREW_CASK_INSTALL "BROWSERS" "adobe-acrobat-reader" "" "brew"
      #BREW_CASK_INSTALL "BROWSERS" "adobe-air" "" "brew"
      #BREW_CASK_INSTALL "BROWSERS" "silverlight" "" "brew"

      # TODO: install tesseract for Selenium to recognize text within images
   else
      fancy_echo "BROWSERS others not specified." >>$LOGFILE
   fi


######### Cucumber with Gherkin RSpec ::


MODULE="cucumber" # https://docs.cucumber.io/
   # TODO: http://www.agiletrailblazers.com/blog/the-5-step-guide-for-selenium-cucumber-and-gherkin
CATEGORY="{$TEST_TOOLS,,}"
PREFIX="TEST_TOOLS $MODULE"
if [[ "$CATEGORY" == *"$MODULE"* ]] || [[ "$TRYOUT_KEEP" == *"$MODULE"* ]]; then
   
                  PROJ_PATH="$GITS_PATH/$MODULE"
   if [[ "${RUNTYPE,,}" == *"remove"* ]]; then
      if [ ! -d "$PROJ_PATH" ]; then
         echo "$PREFIX $PROJ_PATH not there to remove."
      else
         echo "$PREFIX removing $PROJ_PATH ..."
         rm -rf "$PROJ_PATH"
      fi
   else
      if ! command_exists "$MODULE" ; then # install:
         if [[ "${RUNTYPE,,}" == *"fromscratch"* ]]; then
            echo "$PREFIX cleanup $PROJ_PATH ..."
            rm -rf "$PROJ_PATH"
         fi

         pushd "$GITS_PATH"
         if [ ! -d "$MODULE" ]; then 
            # Fork https://github.com/ below to your own account.
            echo "$PREFIX cloning ..."
            git clone https://github.com/cucumber/cucumber-java-skeleton "$MODULE" --depth=1
            # git clone https://github.com/tourdedave/the-internet "$MODULE" --depth=1
#               # TODO: Add pom.xml
            # https://wiki.saucelabs.com/display/DOCS/Example+Selenium+Scripts+for+Automated+Website+Tests
            cd "$MODULE"
         else # already there, so update:
            cd "$MODULE"
            echo "$PREFIX TODO: updating $(pwd) ..."
#           GITHUB_UPDATE 
         fi
         echo "$PREFIX at $(pwd) ..." >>$LOGFILE
         # bundle install
#         RUBY_INSTALL #Ruby (2.3.3 or higher)
         MAVEN_INSTALL # pre-requsite
         mvn test # runs Cucumber features using Cucumber's JUnit runner. 
            # RESPONSE: [INFO] Total time: 08:34 min
        # mvn clean install package -X -e
         # or
         #GRADLE_INSTALL
         #gradlew test --info &
         # The @RunWith(Cucumber.class) annotation on the RunCukesTest class tells JUnit to kick off Cucumber.
exit #debugging

         #gem install bundler
         #sudo gem install selenium-webdriver -v 3.2.1 #Selenium Webdriver (3.2.1) 
         #gem install cucumber #Cucumber (2.4.0)
         #gem install rspec    #Gherkin (4.1.1)
         #gem install cucumber # (2.4.0) business language
         #gem install rspec    # Gherkin (4.1.1) BDD mocking and performance assertions
         #TODO: cucumber command
         popd
      fi # command_exists

      if [[ "${TRYOUT,,}" == *"$MODULE"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         echo "$PREFIX starting on $MODULE_PORT in background ..."
         # TODO: rackup
         # bundle install
         #rake db:migrate
         #rake db:test:prepare
         #rake cucumber "$@"

         #open "http://localhost:$MODULE_PORT"
 
         if [[ "$TRYOUT_KEEP" != *"$MODULE"* ]]; then
            echo "$PREFIX stopping ..." >>$LOGFILE
            ruby gherkin_basic_firefox.rb
         else
#            # pause 2 minutes? to view app on browser
            PID="$(ps x | grep -m1 '/$MODULE' | grep -v "grep" | awk '{print $1}')"
            echo "$PREFIX running on PID=$PID." >>$LOGFILE
         fi
      fi # TRYOUT
   fi # remove
else
   fancy_echo "$PREFIX not specified." >>$LOGFILE
fi
exit #debugging


######### TEST_TOOLS :: 


if [[ "${TEST_TOOLS,,}" == *"testng"* ]]; then
   fancy_echo "TEST_TOOLS testng specified." >>$LOGFILE
else
   fancy_echo "TEST_TOOLS testng not specified." >>$LOGFILE
fi


if [[ "${TEST_TOOLS,,}" == *"protractor"* ]]; then
   # protractor for testing AngularJS versions greater than 1.0.6/1.1.4, 
   # See http://www.protractortest.org/#/ and https://www.npmjs.com/package/protractor
   NODE_INSTALL  # pre-requsite nodejs v6 and newer.
   # https://github.com/mbcooper/ProtractorExample

   # TODO: Inside virtualenv ?
   # npm install -g protractor
   # protractor conf.js  # run test
else
   fancy_echo "TEST_TOOLS protractor not specified." >>$LOGFILE
fi


function SONAR_INSTALL(){
   # Required: java >= 1.8   
   fancy_echo "SONAR_INSTALL" >>$LOGFILE  # sonar 3.3.4

   BREW_INSTALL "DATA_TOOLS" "sonar" "brew" # /usr/local/bin/sonar
      # linked from /usr/local/Cellar/sonarqube/7.1/bin/sonar
   BREW_INSTALL "DATA_TOOLS" "sonar-scanner" "-v" # previously sonar-runner 
      # https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner
      # https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner#AnalyzingwithSonarQubeScanner-Installation
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      SONAR_CONF="/usr/local/opt/sonarqube/libexec/conf/nexus.properties"
            # "/usr/local/Cellar/sonarqube/7.1/libexec/conf/sonar.properties"
      if [ ! -z "$SONAR_PORT" ]; then # fall-back if not set in secrets.sh:
         SONAR_PORT="9000"  # default 9000
      fi

      sed -i "s/#sonar.web.port=9000/sonar.web.port=$SONAR_PORT/g" "$SONAR_CONF"
      # consider #sonar.web.javaOpts=-Xmx512m -Xms128m -XX:+HeapDumpOnOutOfMemoryError
   fi
}
if [[ "${TEST_TOOLS,,}" == *"sonar"* ]] || [[ "$TRYOUT_KEEP" == *"sonar"* ]]; then
   SONAR_INSTALL

   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then

      # TODO: Create database in mysql per http://chapter31.com/2013/05/02/installing-sonar-source-on-mac-osx/
      # and https://neomatrix369.wordpress.com/2013/09/16/installing-sonarqube-formely-sonar-on-mac-os-x-mountain-lion-10-8-4/
      #MYSQL_INSTALL

      # Download from https://docs.sonarqube.org/display/PLUG/SonarSource+Plugins
      # into /usr/local/Cellar/sonar/5.1.2/libexec/extensions/plugins/
      # See https://www.sonarsource.com/products/codeanalyzers/sonarjs.html

      # NOTE: Hygieia and others pull from sonar.

      if [[ "${TRYOUT,,}" == *"sonar"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         fancy_echo "TEST_TOOLS sonar TRYOUT starting in background ..." >>$LOGFILE
         sonar console &  # response: "SonarQube is up"
         open "http://localhost:$SONAR_PORT/"

         # Run a scan now.

      else
         fancy_echo "TEST_TOOLS sonar TRYOUT not specified." >>$LOGFILE
      fi

      if [[ "$TRYOUT_KEEP" != *"sonar"* ]]; then # not specified, so it's gone:
         echo "TEST_TOOLS sonar stopping ..." >>$LOGFILE
         sonar stop
      else
         echo "TEST_TOOLS sonar still running on multiple PID." >>$LOGFILE
         sonar --help # Usage: sonar { console | start | stop | restart | status | version }
         sonar status
      fi
   fi
else
   fancy_echo "TEST_TOOLS sonar not specified." >>$LOGFILE
fi

# TODO: GreenMail is a email server used for testing  # http://www.javavillage.in/greenmail.php


######### GitHub hub to manage GitHub functions:


if [[ "${GIT_TOOLS,,}" == *"hub"* ]]; then
   GO_INSTALL  # prerequiste
   # See https://hub.github.com/
   BREW_INSTALL "GIT_TOOLS" "hub" "version"
      # echo "alias git=hub" >>"$BASHFILE"
else
   fancy_echo "GIT_TOOLS hub not specified." >>$LOGFILE
fi


######### Python test coding languge:


   if [[ "${LANG_TOOLS,,}" == *"python"* ]]; then  # contains azure.
      # Python:
      # See https://saucelabs.com/resources/articles/getting-started-with-webdriver-in-python-on-osx
      # Get bindings: http://selenium-python.readthedocs.io/installation.html

      # TODO: Check aleady installed:
         pip install selenium   # password is requested. 
            # selenium in /usr/local/lib/python2.7/site-packages

      # TODO: If webdrive is installed:
         pip install webdriver

      if [[ "${BROWSERS,,}" == *"chrome"* ]]; then  # contains azure.
         python tests/chrome_pycon_search.py chrome
         # python tests/chrome-google-search-quit.py
      fi
      if [[ "${BROWSERS,,}" == *"firefox"* ]]; then  # contains azure.
         python tests/firefox_github_ssh_add.py
         # python tests/firefox_unittest.py  # not working due to indents
         # python tests/firefox-test-chromedriver.py
      fi
      if [[ "${BROWSERS,,}" == *"safari"* ]]; then  # contains azure.
         fancy_echo "Need python tests/safari_github_ssh_add.py"
      fi

      # TODO: https://github.com/alexkaratarakis/gitattributes/blob/master/Python.gitattributes
   else
      fancy_echo "LANG_TOOLS python not specified." >>$LOGFILE
   fi

# Now to add/commit - https://marklodato.github.io/visual-git-guide/index-en.html
# TODO: Protractor for AngularJS
# For coding See http://www.techbeamers.com/selenium-webdriver-python-tutorial/

# TODO: Java Selenium script


######### Sauce Labs with Node Selenium :


# https://github.com/saucelabs-sample-test-frameworks/JS-Protractor-Selenium
#   SAUCE_USERNAME=""
#   SAUCE_ACCESS_KEY=""
# ./node_modules/.bin/protractor conf.js


######### Golum Python Framework for Selenium :


if [[ "${TEST_TOOLS,,}" == *"golum"* ]]; then  # contains golum.
   PYTHON3_INSTALL  # pre-requisite
   # https://golem-framework.readthedocs.io/en/latest/installation.html
   # https://github.com/lucianopuccio/Golem.git 
   pip install golem-framework  # installs Flask, itsdangerous, Werkzeug, MarkupSafe, 

   # Sstart the Golem Web Module, run the following command:
   golem gui

   #The Web Module can be accessed at 
   # open "http://localhost:5000/"

else
   fancy_echo "TEST_TOOLS golum not specified." >>$LOGFILE
fi


######### MON_TOOLS ::


if [[ "${MON_TOOLS,,}" == *"wireshark"* ]]; then
   BREW_CASK_INSTALL "MON_TOOLS" "wireshark" "Wireshark" "brew"
   # BREW_CASK_INSTALL wireshark-chmodbpf
   # wireshark v6.0.0-beta.7
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      if [[ "${TRYOUT,,}" == *"wireshark"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         fancy_echo "Starting TShark to Wireshark.app ..." >>$LOGFILE
         #open -a "/Applications/Wireshark.app"
         tshark -O TCP -c 2  # caputure x TCP packets then stop.
      fi
      # See https://wiki.wireshark.org/Tools
   fi
else
   fancy_echo "MON_TOOLS wireshark not specified." >>$LOGFILE
fi


if [[ "${MON_TOOLS,,}" == *"prometheus"* ]] || [[ "$TRYOUT_KEEP" == *"prometheus"* ]]; then
   DOCKER_INSTALL
   # See https://github.com/prometheus/prometheus/  cmd
   GO_INSTALL # pre-requsite
   BREW_INSTALL "MON_TOOLS" "prometheus" "--version"

   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      if [[ "$TRYOUT" != *"prometheus"* ]]; then
       # https://prometheus.io/docs/introduction/first_steps/
       # https://gist.github.com/kitallis/2311aec01b005fecfa32

       # TODO: Edit prometheus.yml
       prometheus --config.file=prometheus.yml
         if [ ! -z "$PROMETHEUS_PORT" ]; then # fall-back if not set in secrets.sh:
            PROMETHEUS_PORT="9090"  # default 9090
         fi
       open "http://localhost:$PROMETHEUS_PORT"
       # Close browser session manually.
      fi

      if [ ! -z ${DOCKERHOSTS+x} ]; then  # variable has NOT been defined already.
         echo "DOCKERHOSTS=$DOCKERHOSTS" >>$LOGFILE
         docker run --name prometheus -d -p "127.0.0.1:9090:$PROMETHEUS_PORT" quay.io/prometheus/prometheus bash
         # prometheus -config.file=prometheus.yml

         if [[ "$TRYOUT" != *"prometheus"* ]]; then
            open "http://localhost:$PROMETHEUS_PORT"
         fi

         if [[ "$TRYOUT_KEEP" != *"prometheus"* ]]; then
               docker kill prometheus
               docker container stop prometheus
               docker rm "prometheus"
               docker rm $(docker ps -q -f status=exited) # remove all stopped docker containers.
         fi
      fi
   fi
else
   fancy_echo "MON_TOOLS prometheus not specified." >>$LOGFILE
fi


if [[ "${MON_TOOLS,,}" == *"others"* ]]; then
   fancy_echo "MON_TOOLS=$MON_TOOLS" >>$LOGFILE
# Dynatrace agent
# Open Tracing (Cloud Native)
# AppDynamics agent

# Graphite MacOS app
# BREW_CASK_INSTALL istat-menus  # iStat Menus.app - macos stats on Launch bar
   # com.bjango.istatmenus.agent.plist
   # com.bjango.istatmenus.status.plist
# fluentd has no brew only dmg for clouds https://docs.fluentd.org/v0.12/articles/install-by-dmg
# StatsD # Node-based. from 2016
# collectd  # portable C. needs plugins
# BREW_CASK_INSTALL "MON_TOOLS" "Datadog-agent" "Datadog" "brew" # commercial service

# See https://alternativeto.net/software/grafana/
# Comparison: https://blog.takipi.com/statsd-vs-collectd-vs-fluentd-and-other-daemons-you-should-know/
else
   fancy_echo "MON_TOOLS others not specified." >>$LOGFILE
fi



######### VIZ_TOOLS ::

fancy_echo "VIZ_TOOLS=$VIZ_TOOLS" >>$LOGFILE

if [[ "${VIZ_TOOLS,,}" == *"grafana"* ]] || [[ "$TRYOUT_KEEP" == *"grafana"* ]]; then
      # http://docs.grafana.org/installation/mac/
   BREW_INSTALL "VIZ_TOOLS" "grafana" "brew"
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      if [[ "${TRYOUT,,}" == *"grafana"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then

         if [ ! -z "$GRAFANA_PORT" ]; then # fall-back if not set in secrets.sh:
            GRAFANA_PORT="8089"  # default 8080
         fi

         PS_OUTPUT=$(ps -ef | grep grafana)
         if grep -q "grafana-server" "$PS_OUTFILE" ; then 
            fancy_echo "grafana already running." >>$LOGFILE
            # grafana stop or kill it
         fi 

         fancy_echo "Starting VIZ_TOOLS=grafana session in background ..." >>$LOGFILE
         grafana-server --config=/usr/local/etc/grafana/grafana.ini \
                     --homepath /usr/local/share/grafana \
                     cfg:default.paths.logs=/usr/local/var/log/grafana \
                     cfg:default.paths.data=/usr/local/var/lib/grafana \
                     cfg:default.paths.plugins=/usr/local/var/lib/grafana/plugins &

         fancy_echo "Opening grafana localhost:$GRAFANA_PORT ..."
         open "http://localhost:$GRAFANA_PORT"
          # Capture version: Grafana v5.0.4 (commit: unknown-dev)
          # default login is "admin" / "admin"
         # https://prometheus.io/docs/visualization/grafana/
         # https://grafana.com/dashboards
      fi
      # brew tap homebrew/services
      # brew services start grafana
      # default sqlite database is located at /usr/local/var/lib/grafana
      # see http://docs.grafana.org/administration/cli/
      PID="ps -A | grep -m1 'grafana' | grep -v "grep" | awk '{print $1}'"
      fancy_echo "grafana $PID ..."
      if [[ "$TRYOUT_KEEP" != *"grafana"* ]]; then
         kill $PID
      fi
   fi
else
   fancy_echo "VIZ_TOOLS grafana not specified." >>$LOGFILE
fi


if [[ "${VIZ_TOOLS,,}" == *"tableau"* ]]; then 
   BREW_CASK_INSTALL "VIZ_TOOLS" "tableau" "Tableau" "brew"
else
   fancy_echo "VIZ_TOOLS tableau not specified." >>$LOGFILE
fi

if [[ "${VIZ_TOOLS,,}" == *"tableau-public"* ]]; then 
   BREW_CASK_INSTALL "VIZ_TOOLS" "tableau-public" "Tableau-public" "brew"
else
   fancy_echo "VIZ_TOOLS tableau-public not specified." >>$LOGFILE
fi

if [[ "${VIZ_TOOLS,,}" == *"tableau-viewer"* ]]; then 
   BREW_CASK_INSTALL "VIZ_TOOLS" "tableau-viewer" "Tableau-viewer" "brew"
else
   fancy_echo "VIZ_TOOLS tableau-viewer not specified." >>$LOGFILE
fi


if [[ "${VIZ_TOOLS,,}" == *"others"* ]]; then
   fancy_echo "VIZ_TOOLS=$VIZ_TOOLS" >>$LOGFILE
fi


######### COLAB_TOOLS


#fancy_echo "At installing Collaboration / screen sharing:" >>$LOGFILE

   # https://www.biba.com/downloads.html
   # blue jeans? (used by ATT)
   # GONE? BREW_CASK_INSTALL "Colloquy" ## IRC http://colloquy.info/downloads.html
   # GONE: BREW_CASK_INSTALL "gotomeeting"   # 32-bit

if [[ "${COLAB_TOOLS,,}" == *"asciinema"* ]]; then
   # https://asciinema.org/
   BREW_INSTALL "COLAB_TOOLS" "asciinema" "brew"
else
   fancy_echo "COLAB_TOOLS asciinema not specified." >>$LOGFILE
fi

if [[ "${COLAB_TOOLS,,}" == *"discord"* ]]; then
   # https://discordapp.com/
   BREW_CASK_INSTALL "COLAB_TOOLS" "discord" "Discord" "brew"
else
   fancy_echo "COLAB_TOOLS discord not specified." >>$LOGFILE
fi

if [[ "${COLAB_TOOLS,,}" == *"google-hangouts"* ]]; then
   BREW_CASK_INSTALL "COLAB_TOOLS" "google-hangouts" "Google Hangouts" "brew"
else
   fancy_echo "COLAB_TOOLS google-hangouts not specified." >>$LOGFILE
fi

if [[ "${COLAB_TOOLS,,}" == *"hipchat"* ]]; then 
   BREW_CASK_INSTALL "COLAB_TOOLS" "hipchat" "Hipchat" "brew"
else
   fancy_echo "COLAB_TOOLS hipchat not specified." >>$LOGFILE
fi

if [[ "${COLAB_TOOLS,,}" == *"joinme"* ]]; then 
   BREW_CASK_INSTALL "COLAB_TOOLS" "joinme" "Join me" "brew"
else
   fancy_echo "COLAB_TOOLS joinme not specified." >>$LOGFILE
fi

if [[ "${COLAB_TOOLS,,}" == *"keybase"* ]]; then 
   BREW_CASK_INSTALL "COLAB_TOOLS" "keybase" "Keybase" "brew"
else
   fancy_echo "COLAB_TOOLS keybase not specified." >>$LOGFILE
fi

   # for encrypted non-SMS messaging:
   # See http://osxdaily.com/2018/05/12/how-setup-use-signal-mac/
if [[ "${COLAB_TOOLS,,}" == *"signal"* ]]; then 
   BREW_CASK_INSTALL "COLAB_TOOLS" "signal" "Signal" "brew"
   # Also link to the companion app on iPhones or Android
else
   fancy_echo "COLAB_TOOLS signal not specified." >>$LOGFILE
fi

if [[ "${COLAB_TOOLS,,}" == *"skype"* ]]; then 
   BREW_CASK_INSTALL "COLAB_TOOLS" "skype" "Skype" "brew"
else
   fancy_echo "COLAB_TOOLS skype not specified." >>$LOGFILE
fi
   # obsolete: BREW_CASK_INSTALL microsoft-lync

if [[ "${COLAB_TOOLS,,}" == *"skype-for-business"* ]]; then
   BREW_CASK_INSTALL "COLAB_TOOLS" "skype-for-business" "Skype for Business" "brew"
else
   fancy_echo "COLAB_TOOLS skype-for-business not specified." >>$LOGFILE
fi

if [[ "${COLAB_TOOLS,,}" == *"slack"* ]]; then
   BREW_CASK_INSTALL "COLAB_TOOLS" "slack" "Slack" "brew"
else
   fancy_echo "COLAB_TOOLS slack not specified." >>$LOGFILE
fi

if [[ "${COLAB_TOOLS,,}" == *"sococo"* ]]; then 
   BREW_CASK_INSTALL "COLAB_TOOLS" "sococo" "Sococo" "brew"
else
   fancy_echo "COLAB_TOOLS sococo not specified." >>$LOGFILE
fi

if [[ "${COLAB_TOOLS,,}" == *"teamviewer"* ]]; then 
   BREW_CASK_INSTALL "COLAB_TOOLS" "teamviewer" "Teamviewer" "brew"

      if [[ "${RUNTYPE,,}" == *"remove"* ]]; then
         rm ~/Library/LaunchAgents/com.teamviewer.teamviewer.plist
         rm ~/Library/LaunchAgents/com.teamviewer.teamviewer_desktop.plist
         break
      fi
else
   fancy_echo "COLAB_TOOLS teamviewer not specified." >>$LOGFILE
fi

if [[ "${COLAB_TOOLS,,}" == *"telegram"* ]]; then 
   BREW_CASK_INSTALL "COLAB_TOOLS" "telegram" "Telegram" "brew"
else
   fancy_echo "COLAB_TOOLS telegram not specified." >>$LOGFILE
fi

if [[ "${COLAB_TOOLS,,}" == *"whatsapp"* ]]; then 
   BREW_CASK_INSTALL "COLAB_TOOLS" "whatsapp" "Whatsapp" "brew"
else
   fancy_echo "COLAB_TOOLS whatsapp not specified." >>$LOGFILE
fi

if [[ "${COLAB_TOOLS,,}" == *"zoom"* ]]; then 
   # CAUTION: 32-bit
   BREW_CASK_INSTALL "COLAB_TOOLS" "zoom" "Zoom" "brew"
else
   fancy_echo "COLAB_TOOLS zoom not specified." >>$LOGFILE
fi

#TODO: https://zapier.com/blog/disable-mic-webcam-notifications/


######### MEDIA TOOLS:


if [[ "${MEDIA_TOOLS,,}" == *"camtasia"* ]]; then
   # https://www.amazon.com/kindle-dbs/fd/kcp
   BREW_CASK_INSTALL "MEDIA_TOOLS" "camtasia" "Camtasia" "brew"
   #echo -e "$(camtasia -v)" >>$LOGFILE  # Kindle v6.0.0-beta.7
else
   fancy_echo "MEDIA_TOOLS camtasia not specified." >>$LOGFILE
fi

if [[ "${MEDIA_TOOLS,,}" == *"kindle"* ]]; then
   # https://www.amazon.com/kindle-dbs/fd/kcp
   BREW_CASK_INSTALL "MEDIA_TOOLS" "kindle" "Kindle" "brew"
else
   fancy_echo "MEDIA_TOOLS kindle not specified." >>$LOGFILE
fi

if [[ "${MEDIA_TOOLS,,}" == *"tesseract"* ]]; then
   fancy_echo "MEDIA_TOOLS tesseract (with leptonica, ghost script, imagemagick)" >>$LOGFILE
   # MEDIA_TOOLS tesseract leptonica with support for TIFF (Tagged Image File Format), JPEG, and gif"
   # see http://tpgit.github.io/UnOfficialLeptDocs/leptonica/README.html#i-o-libraries-leptonica-is-dependent-on
   BREW_INSTALL "MEDIA_TOOLS" "leptonica --with-libtiff --with-openjpeg --with-giflib" "brew"
   # no leptonica --version at /usr/local/opt/leptonica

   echo "MEDIA_TOOLS tesseract ghostscript install ..."
   BREW_INSTALL "MEDIA_TOOLS" "gs" "-v"

   echo "MEDIA_TOOLS tesseract imagemagick with TIFF and Ghostscript support"
   BREW_INSTALL "MEDIA_TOOLS" "imagemagick --with-ghostscript" "brew"
      # no --version /usr/local/opt/imagemagick/magick
   
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then
      if ! command_exists cc ; then
         # at https://github.com/tesseract-ocr/
         fancy_echo "MEDIA_TOOLS tesseract installing ..."
         BREW_INSTALL "MEDIA_TOOLS" "tesseract --with-serial-num-pack --devel" "--version"
         # Default language is English. see http://blog.philippklaus.de/2011/01/chinese-ocr/
      fi
      # Install pdftk based on https://gist.github.com/rmehner/fed9d1ac70eaa296306a
      # More TIFF files from https://photojournal.jpl.nasa.gov/gallery/snt?subselect=mission:mars+sample+return:

      if [[ "${TRYOUT,,}" == *"tesseract"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         echo "MEDIA_TOOLS tesseract starting ..."
         tesseract -l eng tests/files/eurotext.png tesseract.png.output
         open tesseract.png.output.txt
         rm   tesseract.png.output.txt

         # https://ryanfb.github.io/etc/2014/11/13/command_line_ocr_on_mac_os_x.html
         # on-line TIFF converter at https://www.coolutils.com/online/Image-Converter/

         # Get input image grayscale .tif and ~2000*500 (~500x150 is too small)
         # convert input.png -resize 400% -type Grayscale input.tif

         # Convert pdf to text by first splitting it into little graphics files to perform OCR on:
      fi
   fi
else
   fancy_echo "MEDIA_TOOLS tesseract not specified." >>$LOGFILE
fi

if [[ "${MEDIA_TOOLS,,}" == *"real-vnc"* ]]; then 
   BREW_CASK_INSTALL "MEDIA_TOOLS" "real-vnc" "VNC Viewer" "brew"
   # and VNC Server 

   if [[ "${RUNTYPE,,}" == *"remove"* ]]; then
         rm ~/Library/LaunchAgents/com.realvnc.vncserver.peruser.plist
         rm ~/Library/LaunchAgents/com.realvnc.vncserver.prelogin.plist
         break
   else
      if [[ "${TRYOUT,,}" == *"real-vnc"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         fancy_echo "EDITORS real-vnc starting ..."
         open -a "/Applications/VNC Viewer.app" &
         # real-vnc &
      fi
   fi
fi

# BREW_CASK_INSTALL audacity   # audio recording and editing


if [[ "${MEDIA_TOOLS,,}" == *"others"* ]]; then
   fancy_echo "Installing MEDIA_TOOLS=others ..."  >>$LOGFILE
# BREW_CASK_INSTALL spotify    # listen to music (monthly fees)
# BREW_CASK_INSTALL vlc        # Video LAN Client to view mp4 video files

# BREW_CASK_INSTALL snagit     # capture screen images
# licecap # capture gif image of screen https://www.cockos.com/licecap/
# BREW_CASK_INSTALL cloud      # capture screen to cloud storage http://www.getcloudapp.com/

# BREW_CASK_INSTALL handbrake  # rip DVDs to (massive) mp4 files
# BREW_INSTALL youtube-dl      # youtube video download

# BREW_CASK_INSTALL adobe-creative-cloud  #
# BREW_INSTALL ffmpeg  # manipulate images from command line
   # See https://www.macupdate.com/app/mac/35968/remux for a GUI
# BREW_CASK_INSTALL gimp       # image file editing
# BREW_CASK_INSTALL sketchup   # image file editing

# https://www.reaper.fm/

# BREW_CASK_INSTALL camtasia   # screen recording and video editing
# BREW_CASK_INSTALL screenflow # screencast recording

# BREW_CASK_INSTALL qlimageize 
else
   fancy_echo "MEDIA_TOOLS others not specified." >>$LOGFILE
fi


######### LOCALHOSTS ::


if [[ "${LOCALHOSTS,,}" == *"jenkins"* ]] || [[ "$TRYOUT_KEEP" == *"jenkins"* ]]; then
   # https://wilsonmar.github.io/jenkins-setup
   JAVA_INSTALL  # pre-requisite
   BREW_INSTALL "LOCALHOSTS" "jenkins" "--jenkins"
   if [[ "${RUNTYPE,,}" != *"remove"* ]]; then   
      if [[ "${TRYOUT,,}" == *"jenkins"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
         JENKINS_VERSION=$(jenkins --version)  # 2.113
         PID="ps -A | grep -m1 'jenkins' | grep -v "grep" | awk '{print $1}'"
         if [ ! -z "$PID" ]; then 
            fancy_echo "LOCALHOSTS=jenkins running on PID=$PID." >>$LOGFILE
         else
            # Before Jenkinsfile config.
            # Custom JENKINS_PORT="8086" defined in secrets.sh within this script
            if [ ! -z "$JENKINS_PORT" ]; then # fall-back if not set in secrets.sh:
               JENKINS_PORT="8088"  # default 8080
            fi
            #JENKINS_CONF="/usr/local/Cellar/Jenkins/$JENKINS_VERSION/homebrew.mxcl.jenkins.plist"
            JENKINS_CONF="/usr/local/opt/jenkins/homebrew.mxcl.jenkins.plist"
            fancy_echo "Configuring LOCALHOSTS $JENKINS_CONF to port $JENKINS_PORT ..."
            sed -i "s/httpPort=8080/httpPort=$JENKINS_PORT/g" $JENKINS_CONF
               # --httpPort=8080 is default.

            fancy_echo "Starting LOCALHOSTS=jenkins on port $JENKINS_PORT in background ..."
            jenkins --httpPort=$JENKINS_PORT &
            #java -jar jenkins.war "--httpPort=$JENKINS_PORT" &  /usr/local/Cellar/jenkins/2.113/bin/jenkins
            #JAVA_HOME="$(/usr/libexec/java_home --version 1.8)" \
               # exec java  -jar /usr/local/Cellar/jenkins/2.113/libexec/jenkins.war "$@"
               # /Library/Java/JavaVirtualMachines/jdk1.8.0_162.jdk/Contents/Home
         
            # Instead of:
            #fancy_echo "Opening localhost:$JENKINS_PORT for LOCALHOSTS=jenkins ..."
            #open "http://localhost:$JENKINS_PORT"

            # pick up key such as 851ed535fd3249ab95a274d23242655c from:
            # /Users/wilsonmar/.jenkins/secrets/initialAdminPassword
            JENKINS_SECRET=$(<$HOME/.jenkins/secrets/initialAdminPassword)
            echo "$JENKINS_SECRET"

            # Call Python Selenium script to paste the number on screen's Administrator Password field:
            # <input id="security-token" class="form-control" type="password" name="j_password">
            python tests/jenkins_secret_setup.py  "chrome"  $JENKINS_PORT  $JENKINS_SECRET

            # test using https://github.com/ewelinawilkosz/hello-jenkins
            # https://www.youtube.com/watch?v=Dw0-GH0y0Hw&t=43s for HPE Perf Eng
            # https://github.com/jenkinsci/configuration-as-code-plugin
            # https://jmeter-plugins.org/wiki/PluginsManager/

            PID="ps -A | grep -m1 'jenkins' | grep -v "grep" | awk '{print $1}'"
            fancy_echo "jenkins $PID ..."
            if [[ "$TRYOUT_KEEP" != *"jenkins"* ]]; then
               kill $PID
            fi
         fi
      fi 
   fi
else
   fancy_echo "LOCALHOSTS jenkins not specified." >>$LOGFILE
fi


######### RUBY_TOOLS ::


function RUBY_INSTALL() {
   # Mac OSX prior to 10.9 ships with a very dated Ruby version. Use Homebrew to install a recent version:
   fancy_echo "RUBY_INSTALL from $(ruby -v) ..." 
      # ruby 2.0.0p648 (2015-12-16 revision 53162) [universal.x86_64-darwin15]. 
   # TODO: if ruby is not version 2:
      # Install Ruby version management tool such as rvm, rbenv or chruby to run multiple versions of Ruby.
      \curl -L https://get.rvm.io | bash -s stable
      rvm | head -n 1  # response "= rvm" verifies install.

      brew upgrade ruby 2>/dev/null
      gem update --system
      fancy_echo "RUBY_INSTALL now at $(ruby -v) ..." >>$LOGFILE
      # ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin17]

   # Pull the PGP key:
   #gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
   # install:
   #curl -sSL https://get.rvm.io | bash -s stable
   # install what you want to use:
   #rvm install 2.1.1
   # use that version of Ruby system wide:
   #rvm use 2.1.1
}

fancy_echo "RUBY_TOOLS=$RUBY_TOOLS" >>$LOGFILE

if [[ "${RUBY_TOOLS,,}" == *"rails"* ]]; then
   RUBY_INSTALL
   gem install rails --no-ri --no-doc
   rails --version  # Rails 4.2.6 

   # pushd to projects folder:
   # rails new test_app
   # cd test_app
   # bundle exec rails server
else
   fancy_echo "RUBY_TOOLS rails not specified." >>$LOGFILE
fi

if [[ "${RUBY_TOOLS,,}" == *"travis"* ]]; then
   RUBY_INSTALL 
   fancy_echo "RUBY_TOOLS travis install for CI/CO ..." >>$LOGFILE
   # See https://github.com/travis-ci/travis.rb#installation
   # NOTE: travis-cli is obsoleted.
   # gem query -i -n travis # resolves to true if installed.
   if grep -q "$(gem list travis -i)" "true" ; then # exists
      fancy_echo "RUBY_TOOLS travis already installed." >>$LOGFILE
   else
      fancy_echo "RUBY_TOOLS travis installing ..."
      # TODO: Shell completion not installed. Would you like to install it now? |y| 
      gem install travis -v 1.8.8 --no-rdoc --no-ri
      travis version  # 1.8.8
   fi
else
   fancy_echo "RUBY_TOOLS travis not specified." >>$LOGFILE
fi

function RUST_INSTALL() {
   # Brew is not used so rustup toolchain multiplexer managing different versions.
   # https://github.com/rust-lang-nursery/rustup.rs
    # https://rustup.rs/
   # https://www.rust-lang.org/en-US/install.html

   # TODO: if not already installed: ./rustc --version $ rustc 1.25.0 (84203cac6 2018-03-25)
      # Interactively, 1 for Proceed to install proxies in $HOME/.cargo/bin/rustc
   if ! command_exists rustup ; then
      echo "1" | curl https://sh.rustup.rs -sSf | sh
      fancy_echo "RUST_INSTALL PATH in $BASHFILE..." >>$LOGFILE
      printf "export PATH=\"\$PATH:$HOME/.cargo/bin\" # Rust" >>"$BASHFILE"
      source "$BASHFILE"
      rustup completions bash > /etc/bash_completion.d/rustup.bash-completion
   else
      if [[ "${RUNTYPE,,}" == *"upgrade"* ]]; then
         fancy_echo "RUST_INSTALL upgrading ..."
         rustup self update
         rustup update
      fi
   fi
}
if [[ "${RUBY_TOOLS,,}" == *"rust"* ]]; then
   RUST_INSTALL
fi

function GROOVY_INSTALL() {
    # See http://groovy-lang.org/install.html
   BREW_INSTALL "GROOVY_INSTALL" "groovy" "--version"
      # Groovy Version: 2.4.14 JVM: 1.8.0_162 Vendor: Oracle Corporation OS: Mac OS X

   BASHFILE_EXPORT "GROOVY_HOME" "/usr/local/opt/groovy/libexec"
   
   if [[ "${TRYOUT,,}" == *"groovy"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
      fancy_echo "TRYOUT = groovy = run a Groovy script :"
      groovy tests/groovy_smoketest
   fi

   # https://stackoverflow.com/questions/41110256/how-do-i-tell-intellij-about-groovy-installed-with-brew-on-osx
}


if [[ "${GIT_TOOLS,,}" == *"jekyll"* ]] || [[ "$TRYOUT_KEEP" == *"jekyll"* ]]; then

   if [[ "${TRYOUT,,}" == *"jekyll"* ]] || [[ "${TRYOUT,,}" == *"all"* ]]; then
   RUBY_INSTALL
   # See https://help.github.com/articles/setting-up-your-github-pages-site-locally-with-jekyll/

   # Be at a source repository:
      pushd "$GITS_PATH"
      if [ ! -d "$GITS_PATH/$GITHUB_ACCOUNT" ]; then 
         mkdir "$GITHUB_ACCOUNT"
      fi
      cd $GITHUB_ACCOUNT
      fancy_echo "GIT_TOOLS jekyll at $PWD." >>$LOGFILE
      
      GITHUB_REPO_URL="https://github.com/$GITHUB_ACCOUNT/$GITHUB_REPO"
      if [ ! -d "$GITHUB_REPO" ]; then # not
         echo "GIT_TOOLS jekyll cloning from $GITHUB_REPO_URL ..."
         git clone "$GITHUB_REPO_URL"
         if [ ! -d "$GITHUB_REPO" ]; then # clone not successful, so make it
            echo "GIT_TOOLS jekyll creating alternative repo contents ..."
            # git init $GITHUB_REPO
            git clone https://github.com/github/government.github.com.git --depth=1 "$GITHUB_REPO"
            cd "$GITHUB_REPO"
         else
            echo "GIT_TOOLS jekyll using $GITHUB_REPO ..."
            cd "$GITHUB_REPO"
         fi
      else # already there, so update: https://stackoverflow.com/questions/3258243/check-if-pull-needed-in-git
         cd "$GITHUB_REPO"
         fancy_echo "GIT_TOOLS jekyll at $PWD ..."
            git fetch origin # instead of git pull or git remote -v update
         UPSTREAM=${1:-'@{u}'}
         LOCAL=$(git rev-parse @)
         REMOTE=$(git rev-parse "$UPSTREAM")
         BASE=$(git merge-base @ "$UPSTREAM")
         if [ "$LOCAL" = "$REMOTE" ]; then
            echo "GIT_TOOLS jekyll Up-to-date with $GITHUB_REPO_URL ..."
         elif [ "$LOCAL" = "$BASE" ]; then
            echo "GIT_TOOLS jekyll updating from $GITHUB_REPO_URL ..."
            git log ..@{u} --oneline
            git log HEAD..origin/master --oneline
            #git reset --hard HEAD@{1} to go back and discard result of git pull if you don't like it.
            git merge  # Response: Already up to date.
         elif [ "$REMOTE" = "$BASE" ]; then
            echo "GIT_TOOLS jekyll pushing to $GITHUB_REPO_URL ..."
            git add . -A
            git commit -m"update from $THISPGM"
            git push
            echo "GIT_TOOLS jekyll pushed to $GITHUB_REPO_URL ..."
         else
            echo "GIT_TOOLS jekyll diverged with $GITHUB_REPO_URL ..."
         fi
      fi

      if [ ! -f "Gemfile" ]; then # file NOT found:
         echo "source \"https://rubygems.org\"" >Gemfile
         echo "\"github-pages\", group: :jekyll_plugins" >>Gemfile
         echo "group :jekyll_plugins do" >>Gemfile
         echo "  gem \"jekyll-paginate\"" >>Gemfile
         echo "  gem \"jekyll-sitemap\"" >>Gemfile
         echo "  gem \"jekyll-gist\"" >>Gemfile
         echo "  gem \"jekyll-feed\"" >>Gemfile
         echo "  gem \"jemoji\"" >>Gemfile
         echo "end" >>Gemfile
      fi
      
      echo "GIT_TOOLS jekyll bundler install ..." >>$LOGFILE
      if grep -q "$(gem list bundler -i)" "true" ; then # exists
         fancy_echo "GIT_TOOLS jekyll bundler update" >>$LOGFILE
         gem update jekyll bundler
      else
         fancy_echo "GIT_TOOLS jekyll bundler installing into $GITHUB_REPO ..."
         echo "N" | gem install jekyll bundler
            # To Overwrite the executable? [yN]  N
            # Fetching gem metadata from https://rubygems.org/
         bundler version >>$LOGFILE # Bundler version 1.16.1 (2018-04-21 commit )
            # QUESTION: fatal: not a git repository (or any of the parent directories): .git
      fi

      if [ ! -f "Gemfile.lock" ]; then #  -file NOT found:
         bundle install  # as published on GitHub.
            # https://github.com/jch/html-pipeline#dependencies
      else
         bundle update
      fi

         if [ ! -z "$JEKYLL_PORT" ]; then # fall-back if not set in secrets.sh:
            JEKYLL_PORT="4000"  # default 4000
         fi

      echo "GIT_TOOLS jekyll serve to $JEKYLL_PORT in background" >>$LOGFILE
      bundle exec jekyll serve --port "$JEKYLL_PORT" &
      echo "GIT_TOOLS jekyll sleep for server to come up" >>$LOGFILE
         sleep 8  # seconds 
      # See https://jekyllrb.com/docs/configuration/#serve-command-options

      echo "GIT_TOOLS jekyll open localhost:$JEKYLL_PORT" >>$LOGFILE
      open "http://127.0.0.1:$JEKYLL_PORT"

      read -n1 -r -p "Confirm web page appears, then press any key to continue ..." key
      if [ "$key" = '' ]; then
          echo "[$key] continuing..."
      else
          # Anything else pressed, do whatever else.
          echo "[$key] pressed. continuing..."
      fi

      popd
      echo "GIT_TOOLS jekyll back at $PWD after clone" >>$LOGFILE

   fi

   if [[ "${TRYOUT_KEEP,,}" == *"jekyll"* ]]; then
         fancy_echo "GIT_TOOLS: jekyll in TRYOUT_KEEP  ..." >>$LOGFILE
         echo "Now you can enter jekyll commands:" >>$LOGFILE
   else
         PID="$(ps -A | grep -m1 'jekyll serve' | grep -v "grep" | awk '{print $1}')"
            #  PID TTY           TIME CMD
            #36799 ttys000    0:13.11 /usr/local/bin/jekyll serve    
            #36812 ttys000    0:00.07 /usr/local/lib/ruby/gems/2.5.0/gems/rb-fsevent-0.10.3/
         echo "GIT_TOOLS: jekyll stopping PID $PID ..." >>$LOGFILE
         kill $PID  # kills both jekyll server and gem rb-fservent.
   fi
else
      fancy_echo "GIT_TOOLS jekyll not specified." >>$LOGFILE
fi


######### Dump contents:


# List variables
#fancy_echo "env varibles, alphabetically ::" >>$LOGFILE
#echo -e "$(export -p)" >>$LOGFILE

# List ~/.bash_profile:
#fancy_echo "$BASHFILE ::" >>$LOGFILE
#echo "$(cat $BASHFILE)" >>$LOGFILE


#########  brew cleanup


#Listing of all brew cask installed (including dependencies automatically added):"
#fancy_echo "brew info --all ::" >>$LOGFILE
#echo "$(brew info --all)" >>$LOGFILE
#Listing of all brews installed (including dependencies automatically added):""

if [[ "${RUNTYPE,,}" == *"cleanup"* ]]; then
   rm "$HOME/$THISPGM.*.log"
      rm geckodriver.log
      rm jmeter.log
      rm ghostdriver.log
 
   brew cleanup --force
   fancy_echo "ls ~/Library/Caches/Homebrew ::" >>$LOGFILE
   echo "$(ls ~/Library/Caches/Homebrew)" >>$LOGFILE
   rm -f -r /Library/Caches/Homebrew/*
   brew doctor
fi

# List contents of ~/.gitconfig
#echo -e "\n   $GITCONFIG ::" >>$LOGFILE
#echo -e "$(cat $GITCONFIG)" >>$LOGFILE

# List using git config --list:
#echo -e "\n   git config --list ::" >>$LOGFILE
#echo -e "$(git config --list)" >>$LOGFILE


######### Disk space consumed:


FREE_DISKBLOCKS_END=$(df | sed -n -e '2{p;q}' | cut -d' ' -f 6) 
DIFF=$(((FREE_DISKBLOCKS_START-FREE_DISKBLOCKS_END)/2048))
fancy_echo "$DIFF MB of disk space consumed during this script run." >>$LOGFILE
# 380691344 / 182G = 2091710.681318681318681 blocks per GB
# 182*1024=186368 MB
# 380691344 / 186368 G = 2042 blocks per MB

TIME_END=$(date -u +%s);
DIFF=$((TIME_END-TIME_START))
MSG="End of script $THISPGM after $((DIFF/60))m $((DIFF%60))s seconds elapsed."
fancy_echo "$MSG"
echo -e "\n$MSG" >>$LOGFILE

say "script ended."  # through speaker on Mac.
#END