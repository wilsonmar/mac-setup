#!/usr/bin/env zsh
# This is mac-setup.zsh from template https://github.com/wilsonmar/mac-setup/blob/main/mac-setup.zsh
# shellcheck disable=SC2001 # See if you can use ${variable//search/replace} instead.
# shellcheck disable=SC1090 # Can't follow non-constant source. Use a directive to specify location.
# shellcheck disable=SC2129  # Consider using { cmd1; cmd2; } >> file instead of individual redirects.

# Coding of this shell script is explained in https://wilsonmar.github.io/shell-scripts

# After you obtain a Terminal (console) in your environment,
# cd to folder, copy this line (without the # comment character) and paste in the terminal so
# it installs utilities:
# zsh -c "$(curl -fsSL https://raw.githubusercontent.com/wilsonmar/mac-setup/main/mac-setup.zsh)" -v

# This downloads and installs all the utilities, then invokes programs to prove they work
# This was run on macOS Mojave and Ubuntu 16.04.

### 01. Capture a time stamp to later calculate how long the script runs, no matter how it ends:
THIS_PROGRAM="$0"
SCRIPT_VERSION="v0.82"  # Renumber steps
EPOCH_START="$( date -u +%s )"  # such as 1572634619
LOG_DATETIME=$( date +%Y-%m-%dT%H:%M:%S%z)-$((1 + RANDOM % 1000))
# clear  # screen (but not history)
echo "=========================== $LOG_DATETIME $THIS_PROGRAM $SCRIPT_VERSION"


### 02. Display a menu if no parameter is specified in the command line
args_prompt() {
   echo "OPTIONS:"
   echo "   -cont         continue (NOT stop) on error"
   echo "   -v            run -verbose (list space use and each image to console)"
   echo "   -vv           run -very verbose diagnostics"
   echo "   -x            set -x to trace command lines"
#  echo "   -x            set sudoers -e to stop on error"
   echo "   -q           -quiet headings for each step"
   echo " "
   echo "   -I           -Install brew utilities, apps"
   echo "   -U           -Upgrade installed packages if already installed"
   echo "   -sd          -sd card initialize"
   echo " "
   echo "   -N           -Name of Project folder"
   echo "   -fn \"John Doe\"            user full name"
   echo "   -n  \"john-doe\"            GitHub account -name"
   echo "   -e  \"john_doe@gmail.com\"  GitHub user -email"
   echo " "
   echo "   -nenv        Do not retrieve mac-setup.env file"
   echo "   -env \"~/.alt.secrets.zsh\"   (alternate env file)"
   echo "   -H           install/use -Hashicorp Vault secret manager"
   echo "   -m           Setup Vault SSH CA cert"
   echo " "
   echo "   -L           use CircleCI"
   echo "   -aws         -AWS cloud"
   echo "   -eks         -eks (Elastic Kubernetes Service) in AWS cloud"
   echo "   -g \"abcdef...89\" -gcloud API credentials for calls"
   echo "   -p \"cp100\"   -project in cloud"
   echo " "
   echo "   -d           -delete GitHub and pyenv from previous run"
   echo "   -c           -clone from GitHub"
   echo "   -G           -GitHub is the basis for program to run"
   echo "   -F \"abc\"     -Folder inside repo"
   echo "   -f \"a9y.py\"  -file (program) to run"
   echo "   -P \"-v -x\"   -Parameters controlling program called"
   echo "   -u           -update GitHub (scan for secrets)"
   echo " "
   echo "   -k           -k install and use Docker"
   echo "   -k8s         -k8s (Kubernetes) minikube"
   echo "   -b           -build Docker image"
   echo "   -dc           use docker-compose.yml file"
   echo "   -w           -write image to DockerHub"
   echo "   -r           -restart (Docker) before run"
   echo " "
   echo "   -py          run with Pyenv"
   echo "   -V           to run within VirtualEnv (pipenv is default)"
   echo "   -tsf         -tensorflow"
   echo "   -tf          -terraform"
   echo "   -A           run with Python -Anaconda "
   echo "   -y            install Python Flask"
   echo " "
   echo "   -go          -install Go language"
   echo "   -i           -install Ruby and Refinery"
   echo "   -j            install -JavaScript (NodeJs) app with MongoDB"
   echo " "
   echo "   -a           -actually run server (not dry run)"
   echo "   -t           setup -test server to run tests"
   echo "   -o           -open/view app or web page in default browser"
   echo " "
   echo "   -C           remove -Cloned files after run (to save disk space)"
   echo "   -K           -Keep OS processes running at end of run (instead of killing them)"
   echo "   -D           -Delete containers and other files after run (to save disk space)"
   echo "   -M           remove Docker iMages pulled from DockerHub (to save disk space)"
   echo "# USAGE EXAMPLES:"
   echo "chmod +x mac-setup.zsh   # change permissions"
   echo "# Using default configuration settings downloaed to \$HOME/mac-setup.env "
   echo "./mac-setup.zsh -v -I -U -go         # Install brew, golang"
   echo "./mac-setup.zsh -v -s -eggplant -k -a -console -dc -K -D  # eggplant use docker-compose of selenium-hub images"
   echo "./mac-setup.zsh -v -g \"abcdef...89\" -p \"cp100-1094\"  # Google API call"
   echo "./mac-setup.zsh -v -n -a  # NodeJs app with MongoDB"
   echo "./mac-setup.zsh -v -i -o  # Ruby app"   
   echo "./mac-setup.zsh -v -I -U -c -s -y -r -a -aws   # Python Flask web app in Docker"
   echo "./mac-setup.zsh -v -I -U    -s -H    -t        # Initiate Vault test server"
   echo "./mac-setup.zsh -v          -s -H              #      Run Vault test program"
   echo "./mac-setup.zsh -q          -s -H    -a        # Initiate Vault prod server"
   echo "./mac-setup.zsh -v -I -U -c    -H -G -N \"python-samples\" -f \"a9y-sample.py\" -P \"-v\" -t -AWS -C  # Python sample app using Vault"
   echo "./mac-setup.zsh -v -V -c -T -F \"section_2\" -f \"2-1.ipynb\" -K  # Jupyter anaconda Tensorflow in Venv"
   echo "./mac-setup.zsh -v -V -c -L -s    # Use CircLeci based on secrets"
   echo "./mac-setup.zsh -v -D -M -C"
   echo "./mac-setup.zsh -G -v -f \"challenge.py\" -P \"-v\"  # to run a program in my python-samples repo"
   echo "# Using alternative ~/.alt-mac-setup.env  configuration settings file :"
   echo "./mac-setup.zsh -v -env \"~/.alt-mck-setup.env\" -H -m -o  # -t for local vault for Vault SSH keygen"
   echo "./mac-setup.zsh -v -env \"~/.alt-mck-setup.env\" -aws  # for Terraform"
   echo "./mac-setup.zsh -v -env \"~/.alt-mck-setup.env\" -eks -D "
   echo "./mac-setup.zsh -v -env \"~/.alt-mck-setup.env\" -H -m -t    # Use SSH-CA certs with -H Hashicorp Vault -test actual server"
}
if [ $# -eq 0 ]; then  # display if no parameters are provided:
   args_prompt
   exit 1
fi
exit_abnormal() {            # Function: Exit with error.
  echo "exiting abnormally"
  #args_prompt
  exit 1
}

### 03. Custom functions to echo text to screen
# \e ANSI color variables are defined in https://wilsonmar.github.io/bash-scripts#TextColors
h2() { if [ "${RUN_QUIET}" = false ]; then    # heading
   printf "\n\e[1m\e[33m\u2665 %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
   fi
}
info() {   # output on every run
   printf "\e[2m\n➜ %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
}
note() { if [ "${RUN_VERBOSE}" = true ]; then
   printf "\n\e[1m\e[36m \e[0m \e[36m%s\e[0m" "$(echo "$@" | sed '/./,$!d')"
   printf "\n"
   fi
}
success() {
   printf "\n\e[32m\e[1m✔ %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
}
error() {    # &#9747;
   printf "\n\e[31m\e[1m✖ %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
}
warning() {  # &#9758; or &#9755;
   printf "\n\e[5m\e[36m\e[1m☞ %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
}
fatal() {   # Skull: &#9760;  # Star: &starf; &#9733; U+02606  # Toxic: &#9762;
   printf "\n\e[31m\e[1m☢  %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
}

if [ "${RUN_DEBUG}" = true ]; then  # -vv
   h2 "Header here"
   info "info"
   note "note"
   success "success!"
   error "error"
   warning "warning (warnNotice)"
   fatal "fatal (warnError)"
fi


### 04. Define variables for use as "feature flags"
   RUN_ACTUAL=false             # -a  (dry run is default)
   CONTINUE_ON_ERR=false        # -cont
   SET_TRACE=false              # -x
   RUN_VERBOSE=false            # -v
   OPEN_CONSOLE=false           # -console
   RUN_DEBUG=false              # -vv
   USE_TEST_ENV=false              # -t
   RUN_VIRTUALENV=false         # -V
   RUN_ANACONDA=false           # -A
   RUN_PYTHON=false             # -G
   RUN_GOLANG=false             # -go
   RUN_PARMS=""                 # -P
   USE_CIRCLECI=false           # -L
   USE_DOCKER=false             # -k
   SET_MACOS_SYSPREFS=false     # -macos

   USE_AWS_CLOUD=false          # -aws
   RUN_EKS=false                # -eks
   # From AWS Management Console https://console.aws.amazon.com/iam/
   #   AWS_OUTPUT_FORMAT="json"  # asked by aws configure CLI.
   # From secrets file:
   #   AWS_ACCESS_KEY_ID=""
   #   AWS_SECRET_ACCESS_KEY=""
   #   AWS_USER_ARN=""
   #   AWS_MFA_ARN=""
      AWS_DEFAULT_REGION="us-east-2"
      EKS_CLUSTER_NAME="sample-k8s"
      EKS_KEY_FILE_PREFIX="eksctl-1"
      EKS_NODES="2"
      EKS_NODE_TYPE="m5.large"
   # EKS_CLUSTER_FILE=""   # cluster.yaml instead
   EKS_CRED_IS_LOCAL=true
   USE_K8S=false                # -k8s
   USE_AZURE_CLOUD=false        # -z
   USE_GOOGLE_CLOUD=false       # -g
       GOOGLE_API_KEY=""  # manually copied from APIs & services > Credentials
   PROJECT_NAME=""              # -p                 

   USE_YUBIKEY=false            # -Y
   MOVE_SECURELY=false          # -m
      LOCAL_SSH_KEYFILE=""
      GITHUB_ORG=""
   USE_VAULT=false              # -H
       VAULT_ADDR=""
      #VAULT_RSA_FILENAME=""
       VAULT_USER_TOKEN=""
       VAULT_CA_KEY_FULLPATH="$HOME/.ssh/ca_key"
   VAULT_PUT=false

   RUBY_INSTALL=false           # -i
   NODE_INSTALL=false           # -n
   MONGO_DB_NAME=""

   MY_FOLDER=""                 # -F folder
   MY_FILE=""
     #MY_FILE="2-3.ipynb"
   RUN_EGGPLANT=false           # -eggplant

   RUN_WEBGOAT=false            # -W
   RUN_QUIET=false              # -q
   UPDATE_GITHUB=false   # -u
   UPDATE_PKGS=false            # -U

   RESTART_DOCKER=false         # -r
   BUILD_DOCKER_IMAGE=false     # -b
   WRITE_TO_DOCKERHUB=false     # -w
   USE_PYENV=false              # -py
   USE_DOCKER_COMPOSE=false     # -dc
   DOWNLOAD_INSTALL=false       # -I
   DELETE_CONTAINER_AFTER=false # -D
   RUN_TENSORFLOW=false         # -tsf
   RUN_TERRAFORM=false          # -tf
   OPEN_APP=false               # -o
   APP1_PORT="8000"

   IMAGE_SD_CARD=false          # -sd
   CLONE_GITHUB=false           # -c

   REMOVE_DOCKER_IMAGES=false   # -M
   REMOVE_GITHUB_AFTER=false    # -R
   KEEP_PROCESSES=false         # -K

USE_CONFIG_FILE=true            # -nenv
CONFIG_FILEPATH="$HOME/mac-setup.env"  # -env ".mac-setup.en"
   # Contents of ~/mac-setup.env overrides these defaults:
   PROJECT_FOLDER_PATH="$HOME/Projects"  # -P
   PROJECT_FOLDER_NAME=""

   GITHUB_PATH="$HOME/github-wilsonmar"
   GITHUB_REPO="wilsonmar.github.io"
   GITHUB_ACCOUNT="wilsonmar"
   GitHub_USER_NAME="Wilson Mar"             # -n
   GitHub_USER_EMAIL="wilson_mar@gmail.com"  # -e

   GIT_ID="WilsonMar@gmail.com"
   GIT_EMAIL="WilsonMar+GitHub@gmail.com"
   GIT_NAME="Wilson Mar"
   GIT_USERNAME="wilsonmar"

   GITHUB_FOLDER=""
   GitHub_BRANCH=""

SECRETS_FILE=".secrets.env.sample"


### 05. Set variables associated with each parameter flag
while test $# -gt 0; do
  case "$1" in
    -a)
      export RUN_ACTUAL=true
      shift
      ;;
    -A)
      export RUN_ANACONDA=true
      shift
      ;;
    -aws)
      export USE_AWS_CLOUD=true
      shift
      ;;
    -b)
      export BUILD_DOCKER_IMAGE=true
      shift
      ;;
    -console)
      export OPEN_CONSOLE=true
      shift
      ;;
    -cont)
      export CONTINUE_ON_ERR=true
      shift
      ;;
    -c)
      export CLONE_GITHUB=true
      shift
      ;;
    -C)
      export REMOVE_GITHUB_AFTER=true
      shift
      ;;
    -dc)
      export USE_DOCKER_COMPOSE=true
      shift
      ;;
    -d)
      export DELETE_BEFORE=true
      shift
      ;;
    -D)
      export DELETE_CONTAINER_AFTER=true
      shift
      ;;
    -eks)
      export USE_AWS_CLOUD=true
      export RUN_EKS=true
      shift
      ;;
    -eggplant)
      RUN_EGGPLANT=true
      GitHub_REPO_URL="https://github.com/wilsonmar/Eggplant.git"
      PROJECT_FOLDER_NAME="eggplant-demo"
      EGGPLANT_HOST="10.190.70.30"
      MY_FOLDER="docker-test.suite/Scripts"
      MY_FILE="openurl.script"
      APP1_PORT="80"
      shift
      ;;
    -env*)
      export USE_CONFIG_FILE=true
      shift
             CONFIG_FILEPATH=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      export CONFIG_FILEPATH
      shift
      ;;
    -e*)
      shift
      GitHub_USER_EMAIL=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      shift
      ;;
    -E)
      export CONTINUE_ON_ERR=true
      shift
      ;;
    -f*)
      shift
      MY_FILE=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      shift
      ;;
    -F*)
      shift
      MY_FOLDER=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      shift
      ;;
    -ga*)
      shift
      GITHUB_USER_ACCOUNT=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      shift
      ;;
    -go)
      export RUN_GOLANG=true
      shift
      ;;
    -g*)
      shift
      export USE_GOOGLE_CLOUD=true
             GOOGLE_API_KEY=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      export GOOGLE_API_KEY
      shift
      ;;
    -G)
      export RUN_PYTHON=true
      GitHub_REPO_URL="https://github.com/wilsonmar/python-samples.git"
      PROJECT_FOLDER_NAME="python-samples"
      shift
      ;;
    -H)
      USE_VAULT=true
      #VAULT_HOST=" "
      export VAULT_ADDR="https://${VAULT_HOST}" 
      # VAULT_USERNAME=""
      #VAULT_RSA_FILENAME="mck2"
      shift
      ;;
    -i)
      export RUBY_INSTALL=true
      GitHub_REPO_URL="https://github.com/nickjj/build-a-saas-app-with-flask.git"
      PROJECT_FOLDER_NAME="bsawf"
      #DOCKER_DB_NANE="snakeeyes-postgres"
      #DOCKER_WEB_SVC_NAME="snakeeyes_worker_1"  # from docker-compose ps  
      APPNAME="snakeeyes"
      shift
      ;;
    -I)
      export DOWNLOAD_INSTALL=true
      shift
      ;;
    -j)
      export NODE_INSTALL=true
      GitHub_REPO_URL="https://github.com/wesbos/Learn-Node.git"
      PROJECT_FOLDER_NAME="delicious"
      APPNAME="delicious"
      MONGO_DB_NAME="delicious"
      shift
      ;;
    -k)
      export USE_DOCKER=true
      shift
      ;;
    -k8s)
      export USE_K8S=true
      shift
      ;;
    -K)
      export KEEP_PROCESSES=true
      shift
      ;;
    -L)
      export USE_CIRCLECI=true
      #GitHub_REPO_URL="https://github.com/wilsonmar/circleci_demo.git"
      GitHub_REPO_URL="https://github.com/fedekau/terraform-with-circleci-example"
      PROJECT_FOLDER_NAME="circleci_demo"
      shift
      ;;
    -macos)
      export SET_MACOS_SYSPREFS=true
      shift
      ;;
    -m)
      export MOVE_SECURELY=true
      export LOCAL_SSH_KEYFILE="id_rsa"
      export GITHUB_ORG="organizations/Mck-Internal-Test"
      shift
      ;;
    -M)
      export REMOVE_DOCKER_IMAGES=true
      shift
      ;;
    -nenv)
      export USE_CONFIG_FILE=false
      shift
      ;;
    -n*)
      shift
      # shellcheck disable=SC2034 # ... appears unused. Verify use (or export if used externally).
             GitHub_USER_NAME=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      export GitHub_USER_NAME
      shift
      ;;
    -N*)
      shift
             PROJECT_FOLDER_NAME=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      export PROJECT_FOLDER_NAME
      shift
      ;;
    -o)
      export OPEN_APP=true
      shift
      ;;
    -py)
      export USE_PYENV=true
      shift
      ;;
    -p*)
      shift
             PROJECT_NAME=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      export PROJECT_NAME
      shift
      ;;
    -P*)
      shift
             RUN_PARMS=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      export RUN_PARMS
      shift
      ;;
    -q)
      export RUN_QUIET=true
      shift
      ;;
    -r)
      export RESTART_DOCKER=true
      shift
      ;;
    -sd)
      export IMAGE_SD_CARD=true
      shift
      ;;
    -tf)
      export RUN_TERRAFORM=true
      PROJECT_FOLDER_PATH="$HOME/mck_acct"  # -P
      PROJECT_FOLDER_NAME="onefirmgithub-vault"
      GitHub_REPO_URL="https://github.com/Mck-Enterprise-Automation/onefirmgithub-vault"
      export APPNAME="onefirmgithub-vault"
      GitHub_BRANCH="GC-348-provision-vault-infra"
      shift
      ;;
    -tsf)
      export RUN_TENSORFLOW=true
      export RUN_ANACONDA=true
      shift
      ;;
    -t)
      export USE_TEST_ENV=true
      shift
      ;;
    -T)
      export RUN_TENSORFLOW=true
      export RUN_ANACONDA=true
      shift
      ;;
    -u)
      export UPDATE_GITHUB=true
      shift
      ;;
    -U)
      export UPDATE_PKGS=true
      shift
      ;;
    -vv)
      export RUN_DEBUG=true
      shift
      ;;
    -v)
      export RUN_VERBOSE=true
      shift
      ;;
    -V)
      export RUN_VIRTUALENV=true
      GitHub_REPO_URL="https://github.com/PacktPublishing/Hands-On-Machine-Learning-with-Scikit-Learn-and-TensorFlow-2.0.git"
      export PROJECT_FOLDER_NAME="scikit"
      export APPNAME="scikit"
      #MY_FOLDER="section_2" # or ="section_3"
      shift
      ;;
    -x)
      export SET_TRACE=true
      shift
      ;;
    -w)
      export WRITE_TO_DOCKERHUB=true
      shift
      ;;
    -W)
      export RUN_WEBGOAT=true
      export GitHub_REPO_URL="https://github.com/wilsonmar/WebGoat.git"
      export PROJECT_FOLDER_NAME="webgoat"
      export APPNAME="webgoat"
      export MY_FOLDER="Contrast"  # "ShiftLeft"
      export MY_FILE="docker-compose.yml"
      export APP1_PORT="8080"
      shift
      ;;
    -y)
      export GitHub_REPO_URL="https://github.com/nickjj/build-a-saas-app-with-flask.git"
      export PROJECT_FOLDER_NAME="rockstar"
      export APPNAME="rockstar"
      shift
      ;;
    -Y)
      export USE_YUBIKEY=true
      shift
      ;;
    -z)
      export USE_AZURE_CLOUD=true
      shift
      ;;
    *)
      error "Parameter \"$1\" not recognized. Aborting."
      exit 0
      break
      ;;
  esac
done


### 06. Save config settings file to \$HOME/mac-setup.env (away from GitHub)

if command -v curl ; then
   if [ ! -f "$HOME/mac-setup.env" ]; then
      curl -LO "https://raw.githubusercontent.com/wilsonmar/mac-setup/main/mac-setup.env)"
   fi
fi


### 07. Obtain information about the operating system in use to define which package manager to use
   export OS_TYPE="$( uname )"
   export OS_DETAILS=""  # default blank.
   export PACKAGE_MANAGER=""
if [ "${OS_TYPE}" = "Darwin" ]; then  # it's on a Mac:
      OS_TYPE="macOS"
      PACKAGE_MANAGER="brew"
elif [ "${OS_TYPE}" = "Windows" ]; then
      OS_TYPE="Windows"   # replace value!
      PACKAGE_MANAGER="choco"  # TODO: Chocolatey or https://github.com/lukesampson/scoop
elif [ "${OS_TYPE}" = "Linux" ]; then  # it's NOT on a Mac:
   if command -v lsb_release ; then
      lsb_release -a
      OS_TYPE="Ubuntu"
      # TODO: OS_TYPE="WSL" ???
      PACKAGE_MANAGER="apt-get"  # or sudo snap install hub --classic

      silent-apt-get-install(){  # see https://wilsonmar.github.io/bash-scripts/#silent-apt-get-install
         if [ "${RUN_E}" = true ]; then
            info "apt-get install $1 ... "
            sudo apt-get install "$1"
         else
            sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq "$1" < /dev/null > /dev/null
         fi
      }
   elif [ -f "/etc/os-release" ]; then
      OS_DETAILS=$( cat "/etc/os-release" )  # ID_LIKE="rhel fedora"
      OS_TYPE="Fedora"
      # TODO: sudo dnf install pipenv  # for Fedora 28
      PACKAGE_MANAGER="yum"
   elif [ -f "/etc/redhat-release" ]; then
      OS_DETAILS=$( cat "/etc/redhat-release" )
      OS_TYPE="RedHat"
      PACKAGE_MANAGER="yum"
   elif [ -f "/etc/centos-release" ]; then
      OS_TYPE="CentOS"
      PACKAGE_MANAGER="yum"
   else
      # FreeBSD - pkg install hub
      # OpenSUSE - sudo zypper install hub
      # Arch Linux - sudo pacman -S hub
      error "Linux distribution not anticipated. Please update script. Aborting."
      exit 0
   fi
else 
   error "Operating system not anticipated. Please update script. Aborting."
   exit 0
fi
# note "OS_DETAILS=$OS_DETAILS"


### 08. Upgrade to the latest version of bash 
BASH_VERSION=$( bash --version | grep bash | cut -d' ' -f4 | head -c 1 )
   if [ "${BASH_VERSION}" -ge "4" ]; then  # use array feature in BASH v4+ :
      DISK_PCT_FREE=$(read -d '' -ra df_arr < <(LC_ALL=C df -P /); echo "${df_arr[11]}" )
      FREE_DISKBLOCKS_START=$(read -d '' -ra df_arr < <(LC_ALL=C df -P /); echo "${df_arr[10]}" )
   else
      if [ "${UPDATE_PKGS}" = true ]; then
         h2 "Bash version ${BASH_VERSION} too old. Upgrading to latest ..."
         if [ "${PACKAGE_MANAGER}" = "brew" ]; then
            brew install bash
         elif [ "${PACKAGE_MANAGER}" = "apt-get" ]; then
            silent-apt-get-install "bash"
         elif [ "${PACKAGE_MANAGER}" = "yum" ]; then    # For Redhat distro:
            sudo yum install bash      # please test
         elif [ "${PACKAGE_MANAGER}" = "zypper" ]; then   # for [open]SuSE:
            sudo zypper install bash   # please test
         fi
         info "Now at $( bash --version  | grep 'bash' )"
         fatal "Now please run this script again now that Bash is up to date. Exiting ..."
         exit 0
      else   # carry on with old bash:
         DISK_PCT_FREE="0"
         FREE_DISKBLOCKS_START="0"
      fi
   fi


### 09. Set traps to display information if script is interrupted.
# See https://github.com/MikeMcQuaid/strap/blob/master/bin/strap.zsh
trap this_ending EXIT
trap this_ending INT QUIT TERM
this_ending() {
   EPOCH_END=$(date -u +%s);
   EPOCH_DIFF=$((EPOCH_END-EPOCH_START))
   sudo --reset-timestamp  # prompt for password for sudo session
   # Using BASH_VERSION identified above:
   if [ "${BASH_VERSION}" -lt "4" ]; then
      FREE_DISKBLOCKS_END="0"
   else
      FREE_DISKBLOCKS_END=$(read -d '' -ra df_arr < <(LC_ALL=C df -P /); echo "${df_arr[10]}" )
   fi
   FREE_DIFF=$(((FREE_DISKBLOCKS_END-FREE_DISKBLOCKS_START)))
   MSG="End of script $SCRIPT_VERSION after $((EPOCH_DIFF/360)) seconds. and $((FREE_DIFF*512)) bytes on disk"
   # echo 'Elapsed HH:MM:SS: ' $( awk -v t=$beg-seconds 'BEGIN{t=int(t*1000); printf "%d:%02d:%02d\n", t/3600000, t/60000%60, t/1000%60}' )
   success "$MSG"
   # note "Disk $FREE_DISKBLOCKS_START to $FREE_DISKBLOCKS_END"
}
sig_cleanup() {
    trap '' EXIT  # some shells call EXIT after the INT handler.
    false # sets $?
    this_ending
}

### 10. Set Continue on Error and Trace

if [ "${CONTINUE_ON_ERR}" = true ]; then  # -cont
   warning "Set to continue despite error ..."
else
   note "Set -e (error stops execution) ..."
   set -e  # exits script when a command fails
   # ALTERNATE: set -eu pipefail  # pipefail counts as a parameter
fi
if [ "${SET_TRACE}" = true ]; then
   h2 "Set -x ..."
   set -x  # (-o xtrace) to show commands for specific issues.
fi
# set -o nounset


### 11. Print run Operating environment information
HOSTNAME=$( hostname )
PUBLIC_IP=$( curl -s ifconfig.me )
INTERNAL_IP=$( ipconfig getifaddr en0 )

if [ "$OS_TYPE" = "macOS" ]; then  # it's on a Mac:
   note "OS_TYPE = $OS_TYPE"
   # BASHFILE=~/.bash_profile ..."
   # BASHFILE="$HOME/.bash_profile"  # on Macs
else  # Linux:
   note "BASHFILE=~/.bashrc ..."
   BASHFILE="$HOME/.bashrc"  # on Linux
fi
   note "Running $0 in $PWD"  # $0 = script being run in Present Wording Directory.
   note "Start time $LOG_DATETIME"
   note "Bash $BASH_VERSION from $BASHFILE"
   note "OS_TYPE=$OS_TYPE using $PACKAGE_MANAGER from $DISK_PCT_FREE disk free"
   note "on hostname=$HOSTNAME "
   note "at PUBLIC_IP=$PUBLIC_IP, intern $INTERNAL_IP"

# TODO: print all command arguments submitted:
#while (( "$#" )); do 
#  echo $1 
#  shift 
#done 


### 12. Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


### 13. Install installers (brew, apt-get), depending on operating system

# Bashism Internal Field Separator used by echo, read for word splitting to lines newline or tab (not spaces).
IFS=$'\n\t'  

BASHFILE="$HOME/.bash_profile"  # on Macs
# if ~/.bash_profile has not been defined, create it:
if [ ! -f "$BASHFILE" ]; then #  NOT found:
   note "Creating blank \"${BASHFILE}\" ..."
   touch "$BASHFILE"
   echo "PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin" >>"$BASHFILE"
   # El Capitan no longer allows modifications to /usr/bin, and /usr/local/bin is preferred over /usr/bin, by default.
else
   LINES=$(wc -l < "${BASHFILE}")
   note "\"${BASHFILE}\" already created with $LINES lines."
#   echo "Backing up file $BASHFILE to $BASHFILE-$LOG_DATETIME.bak ..."
#   cp "$BASHFILE" "$BASHFILE-$LOG_DATETIME.bak"
fi

function BASHFILE_EXPORT() {
   # example: BASHFILE_EXPORT "gitup" "open -a /Applications/GitUp.app"
   name=$1
   value=$2

   if grep -q "export $name=" "$BASHFILE" ; then    
      note "$name alias already in $BASHFILE"
   else
      note "Adding $name in $BASHFILE..."
      # Do it now:
            export "$name=$value" 
      # For after a Terminal is started:
      echo "export $name='$value'" >>"$BASHFILE"
   fi
}

if [ "${DOWNLOAD_INSTALL}" = true ]; then  # -I

   h2 "-Install package managers ..."
   if [ "${PACKAGE_MANAGER}" = "brew" ]; then # -U

      # See https://stackoverflow.com/questions/20559255/error-while-installing-json-gem-mkmf-rb-cant-find-header-files-for-ruby/20561594
      # Ensure Apple's command line tools (such as cc) are installed by node:
      if ! command -v gcc >/dev/null; then  # not installed, so:
         note "Apple gcc compiler utility not available ..."
         if ! command -v xcode-select >/dev/null; then  # not installed, so:
            note "ERROR: xcode-select command not available ..."
         else
            if [ -f "/Applications/Xcode.app" ]; then  # Xcode IDE already installed:
               note "Xcode.app IDE already installed ..."
            fi
            # TODO: Specify install of CommandLineTools or Xcode.app:
            h2 "Installing Apple's xcode CommandLineTools (this takes a while) ..."
            xcode-select --install 
            # NOTE: Install to /usr/bin/gcc; 
            # macOS Yosemite and later ship with stubs in /usr/bin, which take precedence over this git. 
         fi
      fi
      # Verify:
      # Ensure cc, gcc, make, and Ruby Development Headers are available:
      h2 "Confirming xcrun utility is installed ..."
      if ! command -v xcrun >/dev/null; then  # installed:
         error "xcrun command not available!"
      else
         GCC_PATH=$( xcrun --find gcc )
         echo "GCC_PATH=$GCC_PATH"
         # Either in "/Library/Developer/CommandLineTools/usr/bin/gcc"
         # or     in "/Applications/Xcode.app/Contents/Developer/usr/bin/gcc"
      fi

      note "$( gcc --version )"  #  note "$(  cc --version )"
      note "$( xcode-select --version )"  # Example output: xcode-select version 2395 (as of 23APR2022).
         # XCode version: https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/pkgutil.1.html
         # pkgutil --pkg-info=com.apple.pkg.CLTools_Executables | grep version
         # Tools_Executables | grep version
         # version: 9.2.0.0.1.1510905681
      # TODO: https://gist.github.com/tylergets/90f7e61314821864951e58d57dfc9acd

      if ! command -v brew ; then   # brew not recognized:
         if [ "$OS_TYPE" = "macOS" ]; then  # it's on a Mac:
            h2 "Installing brew package manager on macOS using Ruby ..."
            mkdir homebrew && curl -L https://GitHub.com/Homebrew/brew/tarball/master \
               | tar xz --strip 1 -C homebrew
            # if PATH for brew available:

         elif [ "$OS_TYPE" = "WSL" ]; then
            h2 "Installing brew package manager on WSL ..." # A fork of Homebrew known as Linuxbrew.
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.zsh)"
            # https://medium.com/@edwardbaeg9/using-homebrew-on-windows-10-with-windows-subsystem-for-linux-wsl-c7f1792f88b3
            # Linuxbrew installs to /home/linuxbrew/.linuxbrew/bin, so add that directory to your PATH.
            test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
            test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

            if grep -q ".rbenv/bin:" "${BASHFILE}" ; then
               note ".rbenv/bin: already in ${BASHFILE}"
            else
               info "Adding .rbenv/bin: in ${BASHFILE} "
               echo "# .rbenv/bin are shims for Ruby commands so must be in front:" >>"${BASHFILE}"
               # shellcheck disable=SC2016 # Expressions don't expand in single quotes, use double quotes for that.
               echo "export PATH=\"$HOME/.rbenv/bin:$PATH\" " >>"${BASHFILE}"
               source "${BASHFILE}"
            fi

            if grep -q "brew shellenv" "${BASHFILE}" ; then
               note "brew shellenv: already in ${BASHFILE}"
            else
               info "Adding brew shellenv: in ${BASHFILE} "
               echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>"${BASHFILE}"
               source "${BASHFILE}"
            fi
         fi  # "$OS_TYPE" = "WSL"
      else  # brew found:
         if [ "${UPDATE_PKGS}" = true ]; then
            h2 "Updating brew itself ..."
            # per https://discourse.brew.zsh/t/how-to-upgrade-brew-stuck-on-0-9-9/33 from 2016:
            # cd "$(brew --repo)" && git fetch && git reset --hard origin/master && brew update
            brew update
         fi
      fi
      note "$( brew --version )"
         # Homebrew 2.2.2
         # Homebrew/homebrew-core (git revision e103; last commit 2020-01-07)
         # Homebrew/homebrew-cask (git revision bbf0e; last commit 2020-01-07)

   elif [ "${PACKAGE_MANAGER}" = "apt-get" ]; then  # (Advanced Packaging Tool) for Debian/Ubuntu

      if ! command -v apt-get ; then
         h2 "Installing apt-get package manager ..."
         wget http://security.ubuntu.com/ubuntu/pool/main/a/apt/apt_1.0.1ubuntu2.17_amd64.deb -O apt.deb
         sudo dpkg -i apt.deb
         # Alternative:
         # pkexec dpkg -i apt.deb
      else
         if [ "${UPDATE_PKGS}" = true ]; then
            h2 "Upgrading apt-get ..."
            # https://askubuntu.com/questions/194651/why-use-apt-get-upgrade-instead-of-apt-get-dist-upgrade
            sudo apt-get update
            sudo apt-get dist-upgrade
         fi
      fi
      note "$( apt-get --version )"

   elif [ "${PACKAGE_MANAGER}" = "yum" ]; then  #  (Yellow dog Updater Modified) for Red Hat, CentOS
      if ! command -v yum ; then
         h2 "Installing yum rpm package manager ..."
         # https://www.unix.com/man-page/linux/8/rpm/
         wget https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm
         rpm -ivh yum-3.4.3-154.el7.centos.noarch.rpm
      else
         if [ "${UPDATE_PKGS}" = true ]; then
            #rpm -ivh telnet-0.17-60.el7.x86_64.rpm
            # https://unix.stackexchange.com/questions/109424/how-to-reinstall-yum
            rpm -V yum
            # https://www.cyberciti.biz/faq/rhel-centos-fedora-linux-yum-command-howto/
         fi
      fi
      note "$( yum --version )"

   #  TODO: elif for Suse Linux "${PACKAGE_MANAGER}" = "zypper" ?

   fi # PACKAGE_MANAGER

fi # if [ "${DOWNLOAD_INSTALL}"


### 14. Define utility functions: ShellCheck & kill process by name, etc.
ps_kill(){  # $1=process name
      PSID=$( pgrap -l "$1" )
      if [ -z "$PSID" ]; then
         h2 "Kill $1 PSID=$PSID ..."
         kill 2 "$PSID"
         sleep 2
      fi
}

if [ "${DOWNLOAD_INSTALL}" = true ]; then  # -I
   if [ "${PACKAGE_MANAGER}" = "brew" ]; then
         if ! command -v shellcheck >/dev/null; then  # command not found, so:
            h2 "Brew installing shellcheck ..."
            brew install shellcheck
         else  # installed already:
            if [ "${UPDATE_PKGS}" = true ]; then
               h2 "Brew upgrading shellcheck ..."
               brew upgrade shellcheck
               # pip install --user --upgrade shellcheck
            fi
         fi
         note "$( shellcheck --version )"
            # version: 0.7.0
            # license: GNU General Public License, version 3
            # website: https://www.zshellcheck.net
   fi  # PACKAGE_MANAGER
fi  # DOWNLOAD_INSTALL

# TODO: (Removed because it executes even if shellcheck is not installed:
#if [ "${CONTINUE_ON_ERR}" = false ]; then  # -cont
#   shellcheck "$0"
#fi


### 15. Install basic utilities (git, jq, tree, etc.) used by many:
if [ "${DOWNLOAD_INSTALL}" = true ]; then  # -I
   # CAUTION: Install only packages that you actually use and trust!

      h2 "Removing apps pre-installed by Apple, taking up space if they are not used:"

      if [ -d "/Applications/iMovie.app" ]; then   # file NOT found:
         rm -rf "/Applications/iMovie.app"
      fi

      if [ -d "/Applications/Keynote.app" ]; then   # file NOT found:
         rm -rf "/Applications/Keynote.app"
      fi

      if [ -d "/Applications/Numbers.app" ]; then   # file NOT found:
         rm -rf "/Applications/Numbers.app"
      fi

      if [ -d "/Applications/Pages.app" ]; then   # file NOT found:
         rm -rf "/Applications/Pages.app"
      fi

      if [ -d "/Applications/GarageBand.app" ]; then   # file NOT found:
         rm -rf "/Applications/Garage Band.app"
      fi

      # If you have Microsoft O365, download from https://www.office.com/?auth=2&home=1

      h2 "Remaining apps installed by Apple App Store:"
      find /Applications -path '*Contents/_MASReceipt/receipt' -maxdepth 4 -print |\sed 's#.app/Contents/_MASReceipt/receipt#.app#g; s#/Applications/##'

      # Response: The Unarchiver.app, Pixelmator.app, 
      # TextWrangler.app, WriteRoom.app,
      # Texual.app, Twitter.app, Tweetdeck.app, Pocket.app, 

   if [ "${PACKAGE_MANAGER}" = "brew" ]; then
 
      h2 "brew install CLI utilities:"

      brew install curl
      brew install wget

     ### Unzip:
     #brew install --cask keka
      brew install xz
     #brew install --cask the-unarchiver

      brew install git
      note "$( git --version )"
         # git, version 2018.11.26
      #brew install hub   # github
      #note "$( hub --version )"
         # git version 2.27.0
         # hub version 2.14.2

     #Crypto for Security:
      brew install --cask 1password
      if [ ! -d "/Applications/Keybase.app" ]; then   # file NOT found:
         brew install --cask keybase
      else
         if [ "${UPDATE_PKGS}" = true ]; then
            rm -rf "/Applications/Keybase.app"
            brew upgrade --cask keybase
         fi
      fi
     #https://www.hashicorp.com/blog/announcing-hashicorp-homebrew-tap referencing https://github.com/hashicorp/homebrew-tap
      brew install hashicorp/tap/vault
      brew install hashicorp/tap/consul
      brew install hashicorp/tap/nomad
     #brew install hashicorp/tap/packer
      brew install hashicorp/tap/terraform
      brew install hashicorp/tap/sentinel
     #brew install hashicorp/tap/hcloud

     # Terminal enhancements:
      brew install --cask hyper
      brew install --cask iterm2   # for use by .oh-my-zsh
      # Path to your oh-my-zsh installation:
      export ZSH="$HOME/.oh-my-zsh"
      if [ ! -d "$ZSH" ]; then # install:
         note "Creating ~/.oh-my-zsh and installing based on https://ohmyz.sh/ (NO brew install)"
         mkdir -p "${ZSH}"
         sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
      else
         if [ "${UPDATE_PKGS}" = true ]; then
            upgrade_oh_my_zsh   # function.
         fi
      fi
      zsh --version  # Check the installed version
      # Custom theme from : git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
      # ZSH_THEME="powerlevel9k/powerlevel9k"
      # source ~/.zhrc  # source $ZSH/oh-my-zsh.sh

      # For htop -t  (tree of processes):
      brew install htop

      brew install jq
      note "$( jq --version )"  # jq-1.6

      brew install tree

     ### Browsers: see https://wilsonmar.github.io/browser-extensions
      if [ ! -d "/Applications/Google Chrome.app" ]; then   # file NOT found:
         brew install --cask google-chrome
      else
         if [ "${UPDATE_PKGS}" = true ]; then
            rm -rf "/Applications/Google Chrome.app"
            brew upgrade --cask google-chrome
         else
            note "Google Chrome.app already installed."
         fi
      fi
     #brew install --cask brave
      brew install --cask firefox
      brew install --cask microsoft-edge
      brew install --cask tor-browser
     #brew install --cask opera

     #See https://wilsonmar.github.io/text-editors
      brew install --cask atom
      brew install --cask visual-studio-code
     #brew install --cask sublime-text
     # Licensed Python IDE from ___:
     #brew install --cask pycharm
     #brew install --cask macvim
     #brew install --cask neovim    # https://github.com/neovim/neovim

     #brew install --cask anki
      brew install --cask diffmerge  # https://sourcegear.com/diffmerge/
      brew install --cask docker
     #brew install --cask geekbench

     #Media editing:
      brew install --cask sketch
     #Open Broadcaster Software (for recording sound & video)
      brew install --cask obs
     #brew install --cask micro-video-converter
     #brew install --cask vlc
     #brew install --cash imageoptim

     #Installs as zoom.us.app
      brew install --cask zoom
     #Can't if [ ! -d "/Applications/Slack.app" ]; then   # file NOT found:
      brew install --cask skype

      brew install --cask kindle

     #Software development tools:
     # REST API editor (like Postman):
     #brew install --cask postman
     #brew install --cask insomnia
     #brew install --cask sdkman

     # GUI Unicode .keylayout file editor for macOS at https://software.sil.org/ukelele/
     # Precursor to https://keyman.com/
     #brew install --cask ukelele     

   fi  # PACKAGE_MANAGER

   if [ "${RUN_DEBUG}" = true ]; then  # -vv

      h2 "Brew list ..."
      brew list 
      
      h2 "brew list --cask"
      brew list --cask

      h2 "List /Applications"
      ls /Applications
   fi

fi  # DOWNLOAD_INSTALL


####
if [ "${SET_MACOS_SYSPREFS}" = true ]; then  # -macos
   h2 "16. Override defaults in Apple macOS System Preferences:"
   # https://www.youtube.com/watch?v=r_MpUP6aKiQ = "~/.dotfiles in 100 seconds"
   # Patrick McDonald's $12,99 Udemy course "Dotfiles from Start to Finish" at https://bit.ly/3anaaFh

   if [ "${RUN_DEBUG}" = true ]; then  # -vv
      note "NSGlobalDomain NSGlobalDomain before update ..."
      defaults read NSGlobalDomain # > DefaultsGlobal.txt
   fi

   # Explained in https://wilsonmar.github.io/dotfiles/#general-uiux
         # General Appearance: Dark
         defaults write AppleInterfaceStyle –string "Dark";

         # ========== Sidebar icon size ==========
         # - Small
         defaults write .GlobalPreferences NSTableViewDefaultSizeMode -int 1
         # - Medium (the default)
         # defaults write .GlobalPreferences NSTableViewDefaultSizeMode -int 2
         # - Large
         # defaults write .GlobalPreferences NSTableViewDefaultSizeMode -int 3

         # ========== Allow Handoff between this Mac and your iCloud devices ==========
         # - Checked
         defaults -currentHost write com.apple.coreservices.useractivityd.plist ActivityReceivingAllowed -bool true
         defaults -currentHost write com.apple.coreservices.useractivityd.plist ActivityAdvertisingAllowed -bool true
         # - Unchecked (default)
         #defaults -currentHost write com.apple.coreservices.useractivityd.plist ActivityReceivingAllowed -bool false
         #defaults -currentHost write com.apple.coreservices.useractivityd.plist ActivityAdvertisingAllowed -bool false

         # ========== Default web browser ==========
         # - Safari (default)
         # - Google Chrome
         # https://github.com/ulwlu/dotfiles/blob/master/system/macos.zsh has grep error.
      
      # Explained in https://wilsonmar.github.io/dotfiles/#Dock
         # Dock (icon) Size: "smallish"
         defaults write com.apple.dock tilesize -int 36;

         # Position (Dock) on screen: Right
         defaults write com.apple.dock orientation right; 

         # Automatically hide and show the Dock:
         defaults write com.apple.dock autohide-delay -float 0; 

         # remove Dock show delay:
         defaults write com.apple.dock autohide -bool true; 
         defaults write com.apple.dock autohide-time-modifier -float 0;

         # remove icons in Dock
         defaults write com.apple.dock persistent-apps -array; 

      # Explained in https://wilsonmar.github.io/dotfiles/#Battery
      # Show remaining battery time; hide percentage
      defaults write com.apple.menuextra.battery ShowPercent -string "NO"
      defaults write com.apple.menuextra.battery ShowTime -string "YES"

   # Explained in https://wilsonmar.github.io/dotfiles/#Extensions
      # Show all filename extensions:
      defaults write NSGlobalDomain AppleShowAllExtensions -bool true; 
      defaults write -g AppleShowAllExtensions -bool true
      # Show hidden files:
      defaults write com.apple.finder AppleShowAllFiles YES;
      # Show ~/Library hidden by default:
      chflags hidden ~/Library

   # Explained in https://wilsonmar.github.io/dotfiles/#Trackpad
      # Tracking speed: (default is 1.5 in GUI)
      defaults read -g com.apple.trackpad.scaling
      # Tracking speed: maximum 5.0
      defaults write -g com.apple.trackpad.scaling 5.0
      # FIX: Output: 5.0\013

   # Explained in https://wilsonmar.github.io/dotfiles/#Mouse
      # Tracking speed: (default is 3 in GUI)
      defaults read -g com.apple.mouse.scaling
      # Tracking speed: maximum 5.0
      defaults write -g com.apple.mouse.scaling 5.0

   # https://www.youtube.com/watch?v=8fFNVlpM-Tw
   # Changing the login screen image on Monterey.

fi  # SET_MACOS_SYSPREFS


### 17. Image SD card 
# See https://wilsonmar.github.io/iot-raspberry-install/
# To avoid selecting a hard drive and wiping it out,
# it's best to manually use https://www.sdcard.org/downloads/formatter/
# But this automation is meant for use in a production line creating many copies.
# Download image, format new SD chip, and flash the image, all in a single command.
if [ "${IMAGE_SD_CARD}" = true ]; then  # -sd
   # Figure out device for 128GB sd card:
   diskutil list
   # TODO: Use a utility to sepect the disk
   IMAGE_DISK="/dev/disk4"  # or "/dev/disk4"
   # TODO: Pause to confirm.

   # TODO: Get the latest?
   IMAGE_XZ_FILENAME="metal-rpi_4-arm64.img.xz"
   IMAGE_FILENAME="metal-rpi_4-arm64.img"

   h2 "Image $IMAGE_XZ_FILENAME to $IMAGE_FILENAME on ${IMAGE_DISK} ,,,"

   # Prepare Pi - Download the proper Pi image ("1.0.1 released 2022-04-04.img")
   if [ ! -f "$IMAGE_XZ_FILENAME" ]; then   # file NOT found, so download from github:
      curl -LO "https://github.com/siderolabs/talos/releases/download/v1.0.0/${IMAGE_XZ_FILENAME}"
   fi

   if [ ! -f "$IMAGE_XZ_FILENAME" ]; then   # file NOT found, so download from github:
      error "Download of $IMAGE_XZ_FILENAME failed!"
   else
      ls -al "${IMAGE_XZ_FILENAME}"
      if [ ! -f "$IMAGE_FILENAME" ]; then   # file NOT found, so download from github:
         note "Decompressing ${IMAGE_XZ_FILENAME} using xz ..."
         xz "${IMAGE_XZ_FILENAME}"  # to "$IMAGE_FILENAME"
      fi
   fi

   if [ ! -f "$IMAGE_FILENAME" ]; then   # file NOT found, so download from github:
      error "xz de-compress of $IMAGE_XZ_FILENAME to $IMAGE_FILENAME failed!"
   else
      note "Verify ${IMAGE_FILENAME} ..."
      ls -al "${IMAGE_FILENAME}"
      # TODO: Verify MD5?
   fi 

   sudo -v   # get password

   h2 "Instead of using SD Association's SD Formatter or macOS Disk Utility "
   # TODO: See if on SD already:"
   # TODO: fdisk: /dev/disk2: Operation not permitted
   # Initialize sd card: "OK" to "Terminal" would like to access files on a removeable volume.
   # Response: fdisk: could not open MBR file /usr/standalone/i386/boot0: No such file or directory
   # Automatically answer yes to "Do you wish to write new MBR and partition table? [n] "
   yes | sudo fdisk -i "${IMAGE_DISK}"

   # Write image to card:
   sudo dd if=metal-rpi_4-arm64.img of="${IMAGE_DISK}"

   # TODO: Confirm on mac
   # Next, Put sd in Pi and reboot it (Talos needs to be on ethernet network, not wi-fi):

fi  # IMAGE_SD_CARD


### 18. Get secrets from a clear-text file in $HOME folder
Input_GitHub_User_Info(){
      # https://www.zshellcheck.net/wiki/SC2162: read without -r will mangle backslashes.
      read -r -p "Enter your GitHub user name [John Doe]: " GitHub_USER_NAME
      GitHub_USER_NAME=${GitHub_USER_NAME:-"John Doe"}
      GitHub_ACCOUNT=${GitHub_ACCOUNT:-"john-doe"}

      read -r -p "Enter your GitHub user email [john_doe@gmail.com]: " GitHub_USER_EMAIL
      GitHub_USER_EMAIL=${GitHub_USER_EMAIL:-"johb_doe@gmail.com"}
}
if [ "${USE_CONFIG_FILE}" = false ]; then  # -nenv
   warning "Using default values hard-coded in this bash script ..."
   # PIPENV_DOTENV_LOCATION=/path/to/.env or =1 to not load.
else  # use .mck-setup.env file:
   # See https://pipenv-fork.readthedocs.io/en/latest/advanced.html#automatic-loading-of-env
   if [ ! -f "$CONFIG_FILEPATH" ]; then   # file NOT found, then copy from github:
      curl -s -O https://raw.GitHubusercontent.com/wilsonmar/mac-setup/master/mac-setup.env
      warning "Downloading default config file mac-setup.env file to $HOME ... "
      if [ ! -f "$CONFIG_FILEPATH" ]; then   # file still NOT found
         fatal "File not found after download ..."
         exit 9
      fi
      note "Please edit values in file $HOME/mac-setup.env and run this again ..."
      exit 9
   else  # Read from default file name mac-setup.env :
      h2 "Reading default config file $HOME/mac-setup.env ..."
      note "$(ls -al "${CONFIG_FILEPATH}" )"
      chmod +x "${CONFIG_FILEPATH}"
      source   "${CONFIG_FILEPATH}"  # run file containing variable definitions.
      if [ -n "$GITHUB_ACCOUNT" ]; then
         fatal "GITHUB_ACCOUNT variable not defined ..."
         exit 9
      fi
      #if [ "${CIRCLECI_API_TOKEN}" = "xxx" ]; then 
      #   fatal "Please edit CIRCLECI_API_TOKEN in file \$HOME/.secrets.zsh and run again ..."
      #   exit 9
      #fi
      # VPN_GATEWAY_IP & user cert
   fi

   # TODO: Capture password manual input once for multiple shares 
   # (without saving password like expect command) https://www.linuxcloudvps.com/blog/how-to-automate-shell-scripts-with-expect-command/
      # From https://askubuntu.com/a/711591
   #   read -p "Password: " -s szPassword
   #   printf "%s\n" "$szPassword" | sudo --stdin mount \
   #      -t cifs //192.168.1.1/home /media/$USER/home \
   #      -o username=$USER,password="$szPassword"

fi  # if [ "${USE_CONFIG_FILE}" = false ]; then  # -s


### Display run variables 
#      note "AWS_DEFAULT_REGION= " "${AWS_DEFAULT_REGION}"
#      note "GitHub_USER_NAME=" "${GitHub_USER_NAME}"
#      note "GitHub_USER_ACCOUNT=" "${GitHub_USER_ACCOUNT}"
#      note "GitHub_USER_EMAIL=" "${GitHub_USER_EMAIL}"

### 19. Configure project folder location where files are created by the run
   if [ -z "${PROJECT_FOLDER_PATH}" ]; then  # -p ""  override blank (the default)
      h2 "Using current folder \"${PROJECT_FOLDER_PATH}\" as project folder path ..."
      pwd
   else
      if [ ! -d "$PROJECT_FOLDER_PATH" ]; then  # path not available.
         note "Creating folder ${PROJECT_FOLDER_PATH} as -project folder path ..."
         mkdir -p "$PROJECT_FOLDER_PATH"
      fi
      cd "${PROJECT_FOLDER_PATH}" || return # as suggested by SC2164
      note "cd into path $PWD ..."
   fi

   if [ "${RUN_DEBUG}" = true ]; then  # -vv
      note "$( ls "${PROJECT_FOLDER_PATH}" )"
   fi


### 20. Obtain repository from GitHub

echo "*** GitHub_REPO_URL=${GitHub_REPO_URL}"
if [ -n "${GitHub_REPO_URL}" ]; then   # variable is NOT blank

   Delete_GitHub_clone(){
   # https://www.zshellcheck.net/wiki/SC2115 Use "${var:?}" to ensure this never expands to / .
   PROJECT_FOLDER_FULL_PATH="${PROJECT_FOLDER_PATH}/${PROJECT_FOLDER_NAME}"
   if [ -d "${PROJECT_FOLDER_FULL_PATH:?}" ]; then  # path available.
      h2 "Removing project folder $PROJECT_FOLDER_FULL_PATH ..."
      ls -al "${PROJECT_FOLDER_FULL_PATH}"
      rm -rf "${PROJECT_FOLDER_FULL_PATH}"
   fi
   }
   Clone_GitHub_repo(){
      git clone "${GitHub_REPO_URL}" "${PROJECT_FOLDER_NAME}"
      cd "${PROJECT_FOLDER_NAME}"
      note "At $PWD"
   }
# To ensure that we have a project folder (from GitHub clone or not):
if [ "${CLONE_GITHUB}" = true ]; then   # -clone specified:

      if [ -z "${PROJECT_FOLDER_NAME}" ]; then   # name not specified:
         fatal "PROJECT_FOLDER_NAME not specified for git cloning ..."
         exit
      fi 

      PROJECT_FOLDER_FULL_PATH="${PROJECT_FOLDER_PATH}/${PROJECT_FOLDER_NAME}"
      h2 "-clone requested for $GitHub_REPO_URL in $PROJECT_FOLDER_NAME ..."
      if [ -d "${PROJECT_FOLDER_FULL_PATH:?}" ]; then  # path available.
         rm -rf "$PROJECT_FOLDER_NAME" 
         Delete_GitHub_clone    # defined above in this file.
      fi

      Clone_GitHub_repo      # defined above in this file.
      # curl -s -O https://raw.GitHubusercontent.com/wilsonmar/build-a-saas-app-with-flask/master/mac-setup.zsh
      # git remote add upstream https://github.com/nickjj/build-a-saas-app-with-flask
      # git pull upstream master

else   # -clone not specified:

   if [ -z "${PROJECT_FOLDER_NAME}" ]; then   # value not defined
      PROJECT_FOLDER_NAME="work"
      note "\"work\" folder is the default name."
   fi

   if [ -z "${PROJECT_FOLDER_NAME}" ]; then   # variable found:
      fatal "PROJECT_FOLDER_NAME not specified in script ..."
      exit
   else  # no project folder specified:
      if [ ! -d "${PROJECT_FOLDER_NAME}" ]; then   # directory not found
         note "Create blank project folder \"${PROJECT_FOLDER_NAME}\" since no GitHub is specified..."
         mkdir "${PROJECT_FOLDER_NAME}"
            cd "${PROJECT_FOLDER_NAME}"
      else  # folder exists:
         if [ "${DELETE_BEFORE}" = true ]; then  # -d 
            note "Removing project folder \"${PROJECT_FOLDER_NAME}\" ..."
            rm -rf "${PROJECT_FOLDER_NAME}"
            note "Making project folder \"${PROJECT_FOLDER_NAME}\" ..."
            mkdir "${PROJECT_FOLDER_NAME}"
         else
            #note "cd into $PWD since -delete GitHub not specified..."
            cd "${PROJECT_FOLDER_NAME}"
            note "At $( pwd )"
         fi         
      fi
   fi

fi  # CLONE_GITHUB


   if [ -z "${GitHub_USER_EMAIL}" ]; then   # variable is blank
      Input_GitHub_User_Info  # function defined above.
   else
      note "Using -u \"${GitHub_USER_NAME}\" -e \"${GitHub_USER_EMAIL}\" ..."
      # since this is hard coded as "John Doe" above
   fi

   if [ -z "${GitHub_BRANCH}" ]; then   # variable is blank
      git checkout "${GitHub_BRANCH}"
      note "Using branch \"$GitHub_BRANCH\" ..."
   else
      note "Using master branch ..."
   fi
fi   # GitHub_REPO_URL


### 21. Reveal secrets stored within <tt>.gitsecret</tt> folder within repo from GitHub 
# (after installing gnupg and git-secret)

   # This script detects whether secrets are stored various ways:
   # This is https://github.com/AGWA/git-crypt      has 4,500 stars.
   # Whereas https://github.com/sobolevn/git-secret has 1,700 stars.

if [ -d ".gitsecret" ]; then   # found
   # This script detects whether https://github.com/sobolevn/git-secret was used to store secrets inside a local git repo.
   # This looks in the repo .gitsecret folder created by the "git secret init" command on this repo (under DevSecOps).
   # "git secret tell" stores the public key of the current git user email.
   # "git secret add my-file.txt" then "git secret hide" and "rm my-file.txt"
   # This approach is not real secure because it's a matter of time before any static secret can be decrypted by brute force.
   # When someone is out - delete their public key, re-encrypt the files, and they won’t be able to decrypt secrets anymore.
        h2 ".gitsecret folder found ..."
      # Files in there were encrypted using "git-secret" commands referencing gpg gen'd key pairs based on an email address.
      if [ "${PACKAGE_MANAGER}" = "brew" ]; then
         if ! command -v gpg >/dev/null; then  # command not found, so:
            h2 "Brew installing gnupg ..."
            brew install gnupg  
         else  # installed already:
            if [ "${UPDATE_PKGS}" = true ]; then
               h2 "Brew upgrading gnupg ..."
               brew upgrade gnupg
            fi
         fi
         note "$( gpg --version )"  # 2.2.19
         # See https://github.com/sethvargo/secrets-in-serverless using kv or aws (iam) secrets engine.

         if ! command -v git-secret >/dev/null; then  # command not found, so:
            h2 "Brew installing git-secret ..."
            brew install git-secret  
         else  # installed already:
            if [ "${UPDATE_PKGS}" = true ]; then
               h2 "Brew upgrading git-secret ..."
               brew upgrade git-secret
            fi
         fi
         note "$( git-secret --version )"  # 0.3.2

      elif [ "${PACKAGE_MANAGER}" = "apt-get" ]; then
         silent-apt-get-install "gnupg"
      elif [ "${PACKAGE_MANAGER}" = "yum" ]; then    # For Redhat distro:
         sudo yum install gnupg      # please test
      elif [ "${PACKAGE_MANAGER}" = "zypper" ]; then   # for [open]SuSE:
         sudo zypper install gnupg   # please test
      else
         git clone https://github.com/sobolevn/git-secret.git
         cd git-secret && make build
         PREFIX="/usr/local" make install      
      fi  # PACKAGE_MANAGER

      if [ -f "${SECRETS_FILE}.secret" ]; then   # found
         h2 "${SECRETS_FILE}.secret being decrypted using the private key in the bash user's local $HOME folder"
         git secret reveal
            # gpg ...
         if [ -f "${SECRETS_FILE}" ]; then   # found
            h2 "File ${SECRETS_FILE} decrypted ..."
         else
            fatal "File ${SECRETS_FILE} not decrypted ..."
            exit 9
         fi
      fi 
   fi  # .gitsecret


### 22. Pipenv and Pyenv to install Python and its modules
pipenv_install() {
   # Pipenv is a dependency manager for Python projects like Node.js’ npm or Ruby’s bundler.
   # See https://realpython.com/pipenv-guide/
   # Pipenv combines pip & virtualenv in a single interface.

   if [ "${PACKAGE_MANAGER}" = "brew" ]; then
         # https://pipenv.readthedocs.io/en/latest/
         if ! command -v pipenv >/dev/null; then  # command not found, so:
            h2 "Brew installing pipenv ..."
            brew install pipenv
         else  # installed already:
            if [ "${UPDATE_PKGS}" = true ]; then
               h2 "Brew upgrading pipenv ..."
               brew upgrade pipenv
               # pip install --user --upgrade pipenv
            fi
         fi
         note "$( pipenv --version )"
            # pipenv, version 2018.11.26

      #elif for Alpine? 
      elif [ "${PACKAGE_MANAGER}" = "apt-get" ]; then
         silent-apt-get-install "pipenv"  # please test
      elif [ "${PACKAGE_MANAGER}" = "yum" ]; then    # For Redhat distro:
         sudo yum install pipenv      # please test
      elif [ "${PACKAGE_MANAGER}" = "zypper" ]; then   # for [open]SuSE:
         sudo zypper install pipenv   # please test
      else
         fatal "Package Manager not recognized installing pipenv."
         exit
   fi  # PACKAGE_MANAGER

   # See https://pipenv-fork.readthedocs.io/en/latest/advanced.html#automatic-loading-of-env
   # PIPENV_DOTENV_LOCATION=/path/to/.env

     # TODO: if [ "${RUN_ACTUAL}" = true ]; then  # -a for production usage
         #   pipenv install some-pkg     # production
         # else
         #   pipenv install pytest -dev   # include Pipfile [dev-packages] components such as pytest

      if [ -f "Pipfile.lock" ]; then  
         # See https://github.com/pypa/pipenv/blob/master/docs/advanced.rst on deployments
         # Install based on what's in Pipfile.lock:
         h2 "Install based on Pipfile.lock ..."
         pipenv install --ignore-pipfile
      elif [ -f "Pipfile" ]; then  # found:
         h2 "Install based on Pipfile ..."
         pipenv install
      elif [ -f "setup.py" ]; then  
         h2 "Install a local setup.py into your virtual environment/Pipfile ..."
         pipenv install "-e ."
            # ✔ Successfully created virtual environment!
         # Virtualenv location: /Users/wilson_mar/.local/share/virtualenvs/python-samples-gTkdon9O
         # where "-gTkdon9O" adds the leading part of a hash of the full path to the project’s root.
      fi
}  # pipenv_install()


### 23. Connect to GitHub Cloud, if requested:
if [ "${USE_GOOGLE_CLOUD}" = true ]; then   # -g
   # Perhaps in https://console.cloud.google.com/cloudshell  (use on Chromebooks with no Terminal)
   # Comes with gcloud, node, docker, kubectl, go, python, git, vim, cloudshell dl file, etc.

      # See https://cloud.google.com/sdk/gcloud
      if ! command -v gcloud >/dev/null; then  # command not found, so:
         h2 "Installing gcloud CLI in google-cloud-sdk ..."
         brew install --cask google-cloud-sdk
         # google-cloud-sdk is installed at /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk.
         # anthoscligcl
      else  # installed already:
         if [ "${UPDATE_PKGS}" = true ]; then
            h2 "Re-installing gcloud CLI in google-cloud-sdk ..."
            brew cask upgrade google-cloud-sdk
         fi
      fi
      note "$( gcloud --version | grep 'Google Cloud SDK' )"
         # Google Cloud SDK 280.0.0
         # bq 2.0.53
         # core 2020.02.07
         # gsutil 4.47

   # Set cursor to be consistently on left side after a blank line:
   export PS1="\n  \w\[\033[33m\]\n$ "
   note "$( ls )"

      h2 "gcloud info & auth list ..."
      GCP_AUTH=$( gcloud auth list )
      if [[ $GCP_AUTH == *"No credentialed accounts"* ]]; then
         gcloud auth login  # for pop-up browser auth.
      else
         echo "GCP_AUTH=$GCP_AUTH"
            #           Credentialed Accounts
            # ACTIVE  ACCOUNT
            # *       google462324_student@qwiklabs.net
      fi
      # To set the active account, run:
      # gcloud config set account `ACCOUNT`

   if [ -n "$PROJECT_NAME" ]; then   # variable is NOT empty
      h2 "Using -project $PROJECT_NAME ..."
      gcloud config set project "${PROJECT_NAME}"
   fi
   GCP_PROJECT=$( gcloud config list project | grep project | awk -F= '{print $2}' )
      # awk -F= '{print $2}'  extracts 2nd word in response:
      # project = qwiklabs-gcp-9cf8961c6b431994
      # Your active configuration is: [cloudshell-19147]
      if [[ $GCP_PROJECT == *"[default]"* ]]; then
         gcloud projects list
         exit 9
      fi

   PROJECT_ID=$( gcloud config list project --format "value(core.project)" )
      # Your active configuration is: [cloudshell-29462]
      #  qwiklabs-gcp-252d53a19c85b354
   info "GCP_PROJECT=$GCP_PROJECT, PROJECT_ID=$PROJECT_ID"
       # GCP_PROJECT= qwiklabs-gcp-00-3d1faad4cd8f, PROJECT_ID=qwiklabs-gcp-00-3d1faad4cd8f
   info "DEVSHELL_PROJECT_ID=$DEVSHELL_PROJECT_ID"

   RESPONSE=$( gcloud compute project-info describe --project "${GCP_PROJECT}" )
      # Extract from:
      #items:
      #- key: google-compute-default-zone
      # value: us-central1-a
      #- key: google-compute-default-region
      # value: us-central1
      #- key: ssh-keys
   #note "RESPONSE=$RESPONSE"

   if [ "${RUN_VERBOSE}" = true ]; then
      h2 "gcloud info and versions ..."
      gcloud info
      gcloud version
         # git: [git version 2.11.0]
         docker --version  # Docker version 19.03.5, build 633a0ea838
         kubectl version
         node --version
         go version        # go version go1.13 linux/amd64
         python --version  # Python 2.7.13
         unzip -v | grep Debian   # UnZip 6.00 of 20 April 2009, by Debian. Original by Info-ZIP.

      gcloud config list
         # [component_manager]
         # disable_update_check = True
         # [compute]
         # gce_metadata_read_timeout_sec = 5
         # [core]
         # account = wilsonmar@gmail.com
         # disable_usage_reporting = False
         # project = qwiklabs-gcp-00-3d1faad4cd8f
         # [metrics]
         # environment = devshell
         # Your active configuration is: [cloudshell-17739]

      # TODO: Set region?
      # gcloud functions regions list
         # projects/.../locations/us-central1, us-east1, europe-west1, asia-northeast1
   fi

   # See https://cloud.google.com/blog/products/management-tools/scripting-with-gcloud-a-beginners-guide-to-automating-gcp-tasks
      # docker run --name web-test -p 8000:8000 crccheck/hello-world

   # To manage secrets stored in the Google cloud per https://wilsonmar.github.io/vault
   # enable APIs for your account: https://console.developers.google.com/project/123456789012/settings%22?pli=1
   gcloud services enable \
      cloudfunctions.googleapis.com \
      storage-component.googleapis.com
   # See https://cloud.google.com/functions/docs/securing/managing-access-iam


   # Setup Google's Local Functions Emulator to test functions locally without deploying the live environment every time:
   # npm install -g @google-cloud/functions-emulator
      # See https://rominirani.com/google-cloud-functions-tutorial-using-gcloud-tool-ccf3127fdf1a


      # assume setup done by https://wilsonmar.github.io/gcp
      # See https://cloud.google.com/solutions/secrets-management
      # https://github.com/GoogleCloudPlatform/berglas is being migrated to Google Secrets Manager.
      # See https://github.com/sethvargo/secrets-in-serverless/tree/master/gcs to encrypt secrets on Google Cloud Storage accessed inside a serverless Cloud Function.
      # using gcloud beta secrets create "my-secret" --replication-policy "automatic" --data-file "/tmp/my-secret.txt"
   h2 "Retrieve secret version from GCP Cloud Secret Manager ..."
   gcloud beta secrets versions access "latest" --secret "my-secret"
         # A secret version contains the actual contents of a secret. "latest" is the VERSION_ID      

   h2 "In GCP create new repository using gcloud & git commands:"
   # gcloud source repos create REPO_DEMO

   # Clone the contents of your new Cloud Source Repository to a local repo:
   # gcloud source repos clone REPO_DEMO

   # Navigate into the local repository you created:
   # cd REPO_DEMO

   # Create a file myfile.txt in your local repository:
   # echo "Hello World!" > myfile.txt

   # Commit the file using the following Git commands:
   # git config --global user.email "you@example.com"
   # git config --global user.name "Your Name"
   # git add myfile.txt
   # git commit -m "First file using Cloud Source Repositories" myfile.txt

   # git push origin master


   # https://google.qwiklabs.com/games/759/labs/2373
   h2 "Using GCP for Speech-to-Text API"  # https://cloud.google.com/speech/reference/rest/v1/RecognitionConfig
   # usage limits: https://cloud.google.com/speech-to-text/quotas
   curl -O -s "https://raw.githubusercontent.com/wilsonmar/DevSecOps/master/gcp/gcp-speech-to-text/request.json"
   cat request.json
   # Listen to it at: https://storage.cloud.google.com/speech-demo/brooklyn.wav
   
   curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json \
      "https://speech.googleapis.com/v1/speech:recognize?key=${GOOGLE_API_KEY}" > result.json
   cat result.json

exit  # in dev

   # https://google.qwiklabs.com/games/759/labs/2374
   h2 "GCP AutoML Vision API"
   # From the Navigation menu and select APIs & Services > Library https://cloud.google.com/automl/ui/vision
   # In the search bar type in "Cloud AutoML". Click on the Cloud AutoML API result and then click Enable.

   QWIKLABS_USERNAME="???"

   # Give AutoML permissions:
   gcloud projects add-iam-policy-binding "${DEVSHELL_PROJECT_ID}" \
    --member="user:$QWIKLABS_USERNAME" \
    --role="roles/automl.admin"

   gcloud projects add-iam-policy-binding "${DEVSHELL_PROJECT_ID}" \
    --member="serviceAccount:custom-vision@appspot.gserviceaccount.com" \
    --role="roles/ml.admin"

   gcloud projects add-iam-policy-binding "$DEVSHELL_PROJECT_ID}" \
    --member="serviceAccount:custom-vision@appspot.gserviceaccount.com" \
    --role="roles/storage.admin"

   # TODO: more steps needed from lab

fi  # USE_GOOGLE_CLOUD


### 24. Connect to AWS
if [ "${USE_AWS_CLOUD}" = true ]; then   # -aws

   if [ "${PACKAGE_MANAGER}" = "brew" ]; then
      #fancy_echo "awscli requires Python3."
      # See https://docs.aws.amazon.com/cli/latest/userguide/cli-install-macos.html#awscli-install-osx-pip
      # PYTHON3_INSTALL  # function defined at top of this file.
      # :  # break out immediately. Not execute the rest of the if strucutre.
      # TODO: https://github.com/bonusbits/devops_bash_config_examples/blob/master/shared/.bash_aws
      # For aws-cli commands, see http://docs.aws.amazon.com/cli/latest/userguide/ 
      if ! command -v aws >/dev/null; then
         h2 "pipenv install awscli ..."
         if ! command -v pipenv >/dev/null; then
            brew install pipenv 
         fi
         pipenv install awscli --user  # no --upgrade 
      else
         if [ "${UPDATE_PKGS}" = true ]; then
            h2 "pipenv upgrade awscli ..."
            note "Before upgrade: $(aws --version)"  # aws-cli/2.0.9 Python/3.8.2 Darwin/19.4.0 botocore/2.0.0dev13
               # sudo rm -rf /usr/local/aws
               # sudo rm /usr/local/bin/aws
               # curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
               # unzip awscli-bundle.zip
               # sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
            if ! command -v pipenv >/dev/null; then
               brew install pipenv 
            fi
            pipenv install awscli --upgrade --user
         fi
      fi
      note "$( aws --version )"  # aws-cli/2.0.9 Python/3.8.2 Darwin/19.5.0 botocore/2.0.0dev13

   fi  # "${PACKAGE_MANAGER}" = "brew" ]; then


   #if [ -d "$HOME/.bash-my-aws" ]; then   # folder is there
   #   h2 "Installing ~/.bash-my-aws ..."
   #   git clone https://github.com/bash-my-aws/bash-my-aws.git ~/.bash-my-aws
   #else
   #   if [ "${UPDATE_PKGS}" = true ]; then
   #      h2 "ReInstalling ~/.bash-my-aws ..."
   #      git clone https://github.com/bash-my-aws/bash-my-aws.git ~/.bash-my-aws
   #   fi
   #fi

   #export PATH="$PATH:$HOME/.bash-my-aws/bin"
   # source ~/.bash-my-aws/aliases

   # For ZSH users, uncomment the following two lines:
   # autoload -U +X compinit && compinit
   # autoload -U +X bashcompinit && bashcompinit
   # source ~/.bash-my-aws/bash_completion.zsh


   if [ "${USE_VAULT}" = true ]; then   # -w
      # Alternative: https://hub.docker.com/_/vault

      if [ "${PACKAGE_MANAGER}" = "brew" ]; then
         # See https://www.davehall.com.au/tags/bash
         if ! command -v aws-vault >/dev/null; then  # command not found, so:
            h2 "Brew installing --cask aws-vault ..."
            brew install --cask aws-vault  
         else  # installed already:
            if [ "${UPDATE_PKGS}" = true ]; then
               h2 "Brew cask upgrade aws-vault ..."
               note "aws-vault version $( aws-vault --version )"  # v5.3.2
               brew upgrade aws-vault
            fi
         fi
         note "aws-vault version $( aws-vault --version )"  # v5.3.2

      fi  # "${PACKAGE_MANAGER}" = "brew" ]; then

   fi  # if [ "${USE_VAULT}" = true 


   # https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html
      # See https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
         if ! command -v aws-iam-authenticator >/dev/null; then  # not found:
            h2 "aws-iam-authenticator install ..."
            brew install aws-iam-authenticator
            chmod +x ./aws-iam-authenticator
         else  # installed already:
            if [ "${UPDATE_PKGS}" = true ]; then
               h2 "Brew upgrading aws-iam-authenticator ..."
               note "aws-iam-authenticator version $( aws-iam-authenticator version )"  # {"Version":"v0.5.0","Commit":"1cfe2a90f68381eacd7b6dcfa2bf689e76eb8b4b"}
               brew upgrade aws-iam-authenticator
            fi
         fi
         note "aws-iam-authenticator version $( aws-iam-authenticator version )"  # {"Version":"v0.5.0","Commit":"1cfe2a90f68381eacd7b6dcfa2bf689e76eb8b4b"}  


   h2 "Connect to AWS ..."
   aws version

exit

fi  # USE_AWS_CLOUD


### 25. Install Azure
if [ "${USE_AZURE_CLOUD}" = true ]; then   # -z
    # See https://docs.microsoft.com/en-us/cli/azure/keyvault/secret?view=azure-cli-latest
    note "TODO: Add Azure cloud coding ..."
    brew install --cask azure-vault
    # https://docs.microsoft.com/en-us/azure/key-vault/about-keys-secrets-and-certificates
fi


### 26. Install K8S minikube
if [ "${USE_K8S}" = true ]; then  # -k8s

   h2 "-k8s"

   # See https://kubernetes.io/docs/tasks/tools/install-minikube/
   RESPONSE="$( sysctl -a | grep -E --color 'machdep.cpu.features|VMX' )"
   if [[ "${RESPONSE}" == *"VMX"* ]]; then  # contains it:
      note "VT-x feature needed to run Kubernetes is available!"
   else
      fatal "VT-x feature needed to run Kubernetes is NOT available!"
      exit 9
   fi

      if [ "${PACKAGE_MANAGER}" = "brew" ]; then

         if ! command -v minikube >/dev/null; then  # command not found, so:
            h2 "brew install --casking minikube ..."
            brew install minikube  
         else  # installed already:
            if [ "${UPDATE_PKGS}" = true ]; then
               h2 "Brew cask upgrade minikube ..."
               note "minikube version $( minikube version )"  # minikube version: v1.11.0
               brew upgrade minikube
            fi
         fi
         note "minikube version $( minikube version )"  # minikube version: v1.11.0
             # commit: 57e2f55f47effe9ce396cea42a1e0eb4f611ebbd

      fi  # "${PACKAGE_MANAGER}" = "brew" 

exit

fi  # if [ "${USE_K8S}" = true ]; then  # -k8s


### 27. Install EKS using eksctl
if [ "${RUN_EKS}" = true ]; then  # -EKS

   # h2 "kubectl client install for -EKS ..."
   if [ "${PACKAGE_MANAGER}" = "brew" ]; then
      # Use Homebrew instead of https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html
      # See https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
      # to communicate with the k8s cluster API server. 
         if ! command -v kubectl >/dev/null; then  # not found:
         h2 "kubectl install ..."
            brew install kubectl
         else  # installed already:
            if [ "${UPDATE_PKGS}" = true ]; then
               h2 "Brew upgrading kubectl ..."
               note "kubectl $( kubectl version --short --client )"  # Client Version: v1.16.6-beta.0
               brew upgrade kubectl
            fi
         fi
         note "kubectl $( kubectl version --short --client )"  # Client Version: v1.16.6-beta.0

         # iam-authenticator

   ### h2 "eksctl install ..."
      # See https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html
         if ! command -v eksctl >/dev/null; then  # not found:
            h2 "eksctl install ..."
            brew tap weaveworks/tap
            brew install weaveworks/tap/eksctl
         else  # installed already:
            if [ "${UPDATE_PKGS}" = true ]; then
               h2 "Brew upgrading eksctl ..."
               note "eksctl version $( eksctl version )"  # 0.21.0
               brew tap weaveworks/tap
               brew upgrade eksctl && brew link --overwrite eksctl
            fi
         fi
         note "eksctl version $( eksctl version )"  # 0.21.0

   fi  # "${PACKAGE_MANAGER}" = "brew" ]; then


   h2 "aws iam get-user to check AWS credentials ... "
   # see https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html
   # Secrets from AWS Management Console https://console.aws.amazon.com/iam/
   # More variables at https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
   
   # For AWS authentication, I prefer to individual variables rather than use static data in a 
   # named profile file referenced in the AWS_PROFILE environment variable 
   # per https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html

   # h2 "Working with AWS MFA ..."
   # See https://blog.gruntwork.io/authenticating-to-aws-with-environment-variables-e793d6f6d02e
   # Give it the ARN of your MFA device (123456789012) and 
   # MFA token (123456) from the Google Authenticator App or key fob:
   #RESPONSE_JSON="$( aws sts get-session-token \
   #   --serial-number "${AWS_MFA_ARN}" \
   #   --token-code 123456 \
   #   --duration-seconds 43200 )"

   #RESPONSE_JSON="$( aws sts assume-role \
   #   --role-arn arn:aws:iam::123456789012:role/dev-full-access \
   #   --role-session-name username@company.com \
   #   --serial-number "${AWS_SERIAL_ARN}" \
   #   --token-code 123456 \
   #   --duration-seconds 43200  # 12 hours max.
   #)"

   # See https://aws.amazon.com/blogs/aws/aws-identity-and-access-management-policy-simulator/
   # See http://awsdocs.s3.amazonaws.com/EC2/ec2-clt.pdf = AWS EC2 CLI Reference

   RESPONSE="$( aws iam get-user )"
      # ERROR: Unable to locate credentials. You can configure credentials by running "aws configure".
      # This script stops if there is a problem here.
   note "$( echo "${RESPONSE}" | jq )"

   h2 "Create cluster $EKS_CLUSTER_NAME using eksctl ... "
   # See https://eksctl.io/usage/creating-and-managing-clusters/
   # NOT USED: eksctl create cluster -f "${EKS_CLUSTER_FILE}"  # cluster.yaml

exit
   eksctl create cluster -v \
        --name="${EKS_CLUSTER_NAME}" \
        --region="${AWS_DEFAULT_REGION}" \
        --ssh-public-key="${EKS_KEY_FILE_PREFIX}" \
        --nodes="${EKS_NODES}" \
        --node_type="${EKS_NODE_TYPE}" \
        --fargate \
        --write-kubeconfig="${EKS_CRED_IS_LOCAL}" \
        --set-kubeconfig-context=false
      # --version 1.16 \  # of kubernetes (1.16)
      # --nodes-min=, --nodes-max=  # to config K8s Cluster autoscaler to automatically adjust the number of nodes in your node groups.
     # RESPONSE: setting availability zones to go with region specified.
   # using official AWS EKS EC2 AMI, static AMI resolver, dedicated VPC
      # creating cluster stack "eksctl-v-cluster" to ${EKS_CLUSTER_NAME}
      # launching CloudFormation stacks "eksctl-v-nodegroup-0" to ${EKS_NODEGROUP_ID}
      # [ℹ]  nodegroup "ng-eb501ec0" will use "ami-073f227b0cd9507f9" [AmazonLinux2/1.16]
      # [ℹ]  using Kubernetes version 1.16
      # [ℹ]  creating EKS cluster "ridiculous-creature-1591935726" in "us-east-2" region with un-managed nodes
      # [ℹ]  will create 2 separate CloudFormation stacks for cluster itself and the initial nodegroup
      # [ℹ]  if you encounter any issues, check CloudFormation console or try 'eksctl utils describe-stacks --region=us-east-2 --cluster=ridiculous-creature-1591935726'
      # [ℹ]  CloudWatch logging will not be enabled for cluster "ridiculous-creature-1591935726" in "us-east-2"
      # [ℹ]  you can enable it with 'eksctl utils update-cluster-logging --region=us-east-2 --cluster=ridiculous-creature-1591935726'
      # [ℹ]  Kubernetes API endpoint access will use default of {publicAccess=true, privateAccess=false} for cluster "ridiculous-creature-1591935726" in "us-east-2"
      # [ℹ]  2 sequential tasks: { create cluster control plane "ridiculous-creature-1591935726", 2 sequential sub-tasks: { no tasks, create nodegroup "ng-eb501ec0" } }
      # [ℹ]  building cluster stack "eksctl-ridiculous-creature-1591935726-cluster"

   # After about 10-15 minutes:

   if [ "${EKS_CRED_IS_LOCAL}" = true ]; then
      if [ -f "$HOME/.kube/config" ]; then  # file exists:
         # If file exists in "$HOME/.kube/config" for cluster credentials
         h2 "kubectl get nodes ..."
         kubectl --kubeconfig .kube/config  get nodes
      else
         note "No $HOME/.kube/config, so create folder ..."
         sudo mkdir ~/.kube
         #sudo cp /etc/kubernetes/admin.conf ~/.kube/
         # cd ~/.kube
         #sudo mv admin.conf config
         #sudo service kubelet restart
      fi
   fi

   # https://github.com/cloudacademy/Store2018
   # git clone https://github.com/cloudacademy/Store2018/tree/master/K8s
   # from https://hub.docker.com/u/jeremycookdev/ 
       # deployment/
       #   store2018.service.yaml 
       #   store2018.inventoryservice.yaml
       #   store2018.accountservice.yaml
       #   store2018.yaml  # specifies host names
       # service/  # loadbalancers
       #   store2018.accountservice.service.yaml   = docker pull jeremycookdev/accountservice
       #   store2018.inventoryservice.service.yaml = docker pull jeremycookdev/inventoryservice
       #   store2018.service.yaml                  = docker pull jeremycookdev/store2018
       #   store2018.zshoppingservice.service.yaml  = docker pull jeremycookdev/shoppingservice
   # kubectl apply -f store2018.yml

   # kubectl get services --all-namespaces -o wide

      # NAMESPACE       NAME             TYPE          CLUSTER-IP     EXTERNAL-IP     PORT(S)        AGE
      # default         svc/kubernetes   ClusterIP     10.100.0.1     <none>          443/TCP        10m
      # kube-system     kube-dns         ClusterIP     10.100.0.10    <none>          53/UDP.53/TCP  10m
      # store2018                        LoadBalancer  10.100.77.214  281...amazon..  80:31318/TCP   26s

   # kubectl get deployments
      # NAME           DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
      # store-service  3         3         3            3           31s

   # kubectl get pods   # to deployment 
      # NAME  READY   STATUS   RESTARTS   AGE
      # ....  1/1     Running  0          31s

   # If using Linux accelerated AMI instance type and the Amazon EKS-optimized accelerated AMI
   #  apply the NVIDIA device plugin for Kubernetes as a DaemonSet on the cluster:
   # kubectl apply -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/1.0.0-beta/nvidia-device-plugin.yml

   # h2 "Opening EKS Clusters web page ..."
   # open https://${AWS_DEFAULT_REGION}.console.aws.amazon.com/eks/home?region=${AWS_DEFAULT_REGION}#/clusters

   # h2 "Opening EKS Worker Nodes in EC2 ..."
   # open https://${AWS_DEFAULT_REGION}.console.aws.amazon.com/ec2/v2/home?region=${AWS_DEFAULT_REGION}#instances;sort=tag:Name

   # h2 "Listing resources ..."  # cluster, security groups, IAM policy, route, subnet, vpc, etc.
   # note $( aws cloudformation describe-stack-resources --region="${AWS_DEFAULT_REGION}" \
   #      --stack-name="${EKS_CLUSTER_NAME}" )

   # h2 "Listing node group info ..."  # Egress, InstanceProfile, LaunchConfiguration, IAM:Policy, SecurityGroup
   # note $( aws cloudformation describe-stack-resources --region="${AWS_DEFAULT_REGION}" \
   #      --stack-name="${EKS_NODEGROUP_ID}" )

   # Install Splunk Forwarding from https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html

   # Install CloudWatch monitoring

   # Performance testing using ab (apache bench)

   if [ "$DELETE_CONTAINER_AFTER" = true ]; then  # -D
 
      kubectl delete deployments --all
      kubectl get pods

      kubectl delete services --all   # load balancers
      kubectl get services
   
      eksctl get cluster 
      eksctl delete cluster "${EKS_CLUSTER_NAME}"

      if [ -f "$HOME/.kube/config" ]; then  # file exists:
           rm "$HOME/.kube/config"
      fi

   fi   # if [ "$DELETE_CONTAINER_AFTER" = true ]; then  # -D

exit  # DEBUGGING

fi  # EKS


### 28. Open

   #if [ ! -f "docker-compose.override.yml" ]; then
   #   cp docker-compose.override.example.yml  docker-compose.override.yml
   #else
   #   warning "no .yml file"
   #fi


### 29. Use CircleCI SaaS
if [ "${USE_CIRCLECI}" = true ]; then   # -L
   # https://circleci.com/docs/2.0/getting-started/#setting-up-circleci
   # h2 "circleci setup ..."

   # Using variables from env file:
   h2 "circleci setup ..."
   if [ -n "${CIRCLECI_API_TOKEN}" ]; then  
      if ! command -v circleci ; then
         h2 "Installing circleci ..."
   # No brew: brew install circleci
         curl -fLSs https://circle.ci/cli | bash
      else
         if [ "${UPDATE_PKGS}" = true ]; then
            h2 "Removing and installing circleci ..."
            rm -rf "/usr/local/bin/circleci"
            curl -fLSs https://circle.ci/cli | bash
         fi
      fi
      note "circleci version = $( circleci version)"   # 0.1.7179+e661c13
      # https://github.com/CircleCI-Public/circleci-cli

      if [ -f "$HOME/.circleci/cli.yml" ]; then
         note "Using existing $HOME/.circleci/cli.yml ..."
      else
         circleci setup --token "${CIRCLECI_API_TOKEN}" --host "https://circleci.com"
      fi
   else
      error "CIRCLECI_API_TOKEN missing. Aborting ..."
      exit 9
   fi

   h2 "Loading Circle CI config.yml ..."
   mkdir -p "$HOME/.circleci"

   echo "-f MY_FILE=$MY_FILE"
   if [ -z "${MY_FILE}" ]; then   # -f not specified:
      note "-file not specified. Using config.yml from repo ... "
      # copy with -force to update:
      cp -f ".circleci/config.yml" "$HOME/.circleci/config.yml"
   elif [ -f "${MY_FILE}" ]; then 
      fatal "${MY_FILE} not found ..."
      exit 9
   else
      mv "${MY_FILE}" "$HOME/.circleci/config.yml"
   fi

   if [ ! -f "$HOME/.circleci/config.yml" ]; then 
      ls -al "$HOME/.circleci/config.yml"
      fatal "$HOME/.circleci/config.yml not found. Aborting ..."
      exit 9
   fi
   h2 "circleci config validate in $HOME/.circleci ..."
   circleci config validate
      # You are running 0.1.7179
      # A new release is available (0.1.8599)
      # You can update with `circleci update install`
      # Error: Could not load config file at .circleci/config.yml: open .circleci/config.yml: no such file or directory

   h2 "??? Run Circle CI ..."  # https://circleci.com/docs/2.0/local-cli/
   # circleci run ???

   h2 "Done with Circle CI ..."
   exit
fi  # USE_CIRCLECI


### 30. Use Yubikey
if [ "${USE_YUBIKEY}" = true ]; then   # -Y
      if [ "${PACKAGE_MANAGER}" = "brew" ]; then
         if ! command -v ykman >/dev/null; then  # command not found, so:
            note "Brew installing ykman ..."
            brew install ykman
         else  # installed already:
            if [ "${UPDATE_PKGS}" = true ]; then
               note "Brew upgrading ykman ..."
               brew upgrade ykman
            fi
         fi
      elif [ "${PACKAGE_MANAGER}" = "apt-get" ]; then
         silent-apt-get-install "ykman"
      elif [ "${PACKAGE_MANAGER}" = "yum" ]; then    # For Redhat distro:
         sudo yum install ykman      ; echo "TODO: please test"
         exit 9                      
      elif [ "${PACKAGE_MANAGER}" = "zypper" ]; then   # for [open]SuSE:
         sudo zypper install ykman   ; echo "TODO: please test"
         exit 9
      fi
      note "$( ykman --version )"
         # RESPONSE: YubiKey Manager (ykman) version: 3.1.1


      if [ "${PACKAGE_MANAGER}" = "brew" ]; then
         if ! command -v yubico-piv-tool >/dev/null; then  # command not found, so:
            note "Brew installing yubico-piv-tool ..."
            brew install yubico-piv-tool
         else  # installed already:
            if [ "${UPDATE_PKGS}" = true ]; then
               note "Brew upgrading yubico-piv-tool ..."
               brew upgrade yubico-piv-tool
            fi
         fi
         #  /usr/local/Cellar/yubico-piv-tool/2.0.0: 18 files, 626.7KB

      elif [ "${PACKAGE_MANAGER}" = "apt-get" ]; then
         silent-apt-get-install "yubico-piv-tool"
      elif [ "${PACKAGE_MANAGER}" = "yum" ]; then    # For Redhat distro:
         sudo yum install yubico-piv-tool      ; echo "TODO: please test"
         exit 9                      
      elif [ "${PACKAGE_MANAGER}" = "zypper" ]; then   # for [open]SuSE:
         sudo zypper install yubico-piv-tool   ; echo "TODO: please test"
         exit 9
      fi
      note "$( yubico-piv-tool --version )"   # RESPONSE: yubico-piv-tool 2.0.0


   # TODO: Verify code below
   h2 "PIV application reset to remove all existing keys ..."
   ykman piv reset
      # RESPONSE: Resetting PIV data...

   h2 "Generating new certificate ..."
   yubico-piv-tool -a generate -s 9c -A RSA2048 --pin-policy=once --touch-policy=never -o public.pem
   yubico-piv-tool -a verify  -S "/CN=SSH key/" -a selfsign -s 9c -i public.pem -o cert.pem
   yubico-piv-tool -a import-certificate -s 9c -i cert.pem

   h2 "Export SSH public key ..."
   ssh-keygen -f public.pem -i -mPKCS8 | tee ./yubi.pub

   h2 "Sign key on CA using vault ..."
   vault write -field=signed_key  "${SSH_CLIENT_SIGNER_PATH}/sign/oleksii_samorukov public_key=@./yubi.pub" \
      | tee ./yubi-cert.pub

   h2 "Test whethef connection is working ..."
   ssh  git@github.com -I /usr/local/lib/libykcs11.dylib -o "CertificateFile ./yubi-cert.pub"

fi  # USE_YUBIKEY


#### 31. Use GitHub

if [ "${MOVE_SECURELY}" = true ]; then   # -m
   # See https://github.com/settings/keys 
   # See https://github.blog/2019-08-14-ssh-certificate-authentication-for-github-enterprise-cloud/

   pushd  "$HOME/.ssh"
   h2 "At temporary $PWD ..."

   ## STEP: Generate local SSH key pair:
   if [ -n "${LOCAL_SSH_KEYFILE}" ]; then  # is not empty
      rm -f "${LOCAL_SSH_KEYFILE}"
      rm -f "${LOCAL_SSH_KEYFILE}.pub"
#      if [ ! -f "${LOCAL_SSH_KEYFILE}" ]; then  # not exists
         h2 "ssh-keygen -t rsa -f \"${LOCAL_SSH_KEYFILE}\" -C \"${VAULT_USERNAME}\" ..."
         ssh-keygen -t rsa -f "${LOCAL_SSH_KEYFILE}" -N ""
             #  -C "${VAULT_USERNAME}" 
#      else 
#         h2 "Using existing SSH key pair \"${LOCAL_SSH_KEYFILE}\" "
#      fi
      note "$( ls -al "${LOCAL_SSH_KEYFILE}" )"
   fi  # LOCAL_SSH_KEYFILE

fi  # MOVE_SECURELY


#### 32. Use Hashicorp Vault

USE_ALWAYS=true
if [ "${USE_ALWAYS}" = false ]; then   # -H

   if [ "${USE_VAULT}" = false ]; then   # -H

      ### STEP: Paste locally generated public key in GitHub UI:
      if [ ! -f "${VAULT_CA_KEY_FULLPATH}" ]; then  # not exists
         h2 "CA key file ${VAULT_CA_KEY_FULLPATH} not found, so generating for ADMIN ..."
         ssh-keygen -t rsa -f "${VAULT_CA_KEY_FULLPATH}" -N ""
            # -N bypasses the passphrase
            # see https://unix.stackexchange.com/questions/69314/automated-ssh-keygen-without-passphrase-how

         h2 "ADMIN: In GitHub.com GUI SSH Certificate Authorities, manually click New CA and paste CA cert. ..."
         # On macOS
            pbcopy <"${VAULT_CA_KEY_FULLPATH}.pub"
            open "https://github.com/${GITHUB_ORG}/settings/security"
         # TODO: On Windows after cinst pasteboard
            ## clip < ~/.ssh/id_rsa.pub
         # TODO: On Debian sudo apt-get install xclip
            ## xclip -sel clip < ~/.ssh/id_rsa.pub
         # Linux: See https://www.ostechnix.com/how-to-use-pbcopy-and-pbpaste-commands-on-linux/
         read -r -t 30 -p "Pausing -t 30 seconds to import ${LOCAL_SSH_KEYFILE} in GitHub.com GUI ..."
         # TODO: Replace with Selenium automation?
      else
         info "Using existing CA key file $VAULT_CA_KEY_FULLPATH ..."
      fi  # VAULT_CA_KEY_FULLPATH
      note "$( ls -al "${VAULT_CA_KEY_FULLPATH}" )"

  else  # USE_VAULT = true

      # Instead of pbcopy and paste in GitHub.com GUI, obtain and use SSH certificate from a SSH CA:
      if [ -z "${VAULT_CA_KEY_FULLPATH}" ]; then  # is not empty
         VAULT_CA_KEY_FULLPATH="./ca_key"  # "~/.ssh/ca_key"  # "./ca_key" for current (project) folder  
      fi
      
      ### STEP: Call Vault to sign public key and return it as a cert:
      h2 "Signing user ${GitHub_ACCOUNT} public key file ${LOCAL_SSH_KEYFILE} ..."
      ssh-keygen -s "${VAULT_CA_KEY_FULLPATH}" -I "${GitHub_ACCOUNT}" \
         -O "extension:login@github.com=${GitHub_ACCOUNT}" "${LOCAL_SSH_KEYFILE}.pub"
         # RESPONSE: Signed user key test-ssh-cert.pub: id "wilson-mar" serial 0 valid forever

      SSH_CERT_PUB_KEYFILE="${LOCAL_SSH_KEYFILE}-cert.pub"
      if [ ! -f "${SSH_CERT_PUB_KEYFILE}" ]; then  # not exists
         error "File ${SSH_CERT_PUB_KEYFILE} not found ..."
      else
         note "File ${SSH_CERT_PUB_KEYFILE} found ..."
         note "$( ls -al ${SSH_CERT_PUB_KEYFILE} )"
      fi
      # According to https://help.github.com/en/github/setting-up-and-managing-organizations-and-teams/about-ssh-certificate-authorities
      # To issue a certificate for someone who has different usernames for GitHub Enterprise Server and GitHub Enterprise Cloud, 
      # you can include two login extensions:
      # ssh-keygen -s ./ca-key -I KEY-IDENTITY \
      #    -O extension:login@github.com=CLOUD-USERNAME extension:login@
   fi  # USE_VAULT

   if [ "${USE_VAULT}" = false ]; then   # -H
      h2 "Use GitHub extension to sign user public key with 1d Validity for ${GitHub_ACCOUNT} ..."
      ssh-keygen -s "${VAULT_CA_KEY_FULLPATH}" -I "${GitHub_ACCOUNT}" \
         -O "extension:login@github.com=${GitHub_ACCOUNT}" -V '+1d' "${LOCAL_SSH_KEYFILE}.pub"
         # 1m = 1minute, 1d = 1day
         # -n user1 user1.pub
         # RESPONSE: Signed user key test-ssh-cert.pub: id "wilsonmar" serial 0 valid from 2020-05-23T12:59:00 to 2020-05-24T13:00:46
   fi

   popd  # from "$HOME/.ssh"
   h2 "Back into $( $PWD ) ..."

   if [ "${OPEN_APP}" = true ]; then   # -o
      h2 "Verify access to GitHub.com using SSH ..."
      # To avoid RESPONSE: PTY allocation request failed on channel 0
      # Ensure that "PermitTTY no" is in ~/.ssh/authorized_keys (on servers to contain id_rsa.pub)
      # See https://bobcares.com/blog/pty-allocation-request-failed-on-channel-0/

      h2 "Verify use of Vault SSH cert ..."
      ssh git@github.com  # -vvv  (ssh automatically uses `test-ssh-cert.pub` file)
      # RESPONSE: Hi wilsonmar! You've successfully authenticated, but GitHub does not provide shell access.
             # Connection to github.com closed.
   fi

fi  # MOVE_SECURELY


### 33. Use Hashicorp Vault
if [ "${USE_VAULT}" = true ]; then   # -H
      h2 "-HashicorpVault being used ..."

      # See https://learn.hashicorp.com/vault/getting-started/install for install video
          # https://learn.hashicorp.com/vault/secrets-management/sm-versioned-kv
          # https://www.vaultproject.io/api/secret/kv/kv-v2.html
      # NOTE: vault-cli is a Subversion-like utility to work with Jackrabbit FileVault (not Hashicorp Vault)
   if [ "${PACKAGE_MANAGER}" = "brew" ]; then
         if ! command -v vault >/dev/null; then  # command not found, so:
            note "Brew installing vault ..."
            brew install vault
            # vault -autocomplete-install
            # exec $SHELL
         else  # installed already:
            if [ "${UPDATE_PKGS}" = true ]; then
               note "Brew upgrading vault ..."
               brew upgrade vault
               # vault -autocomplete-install
               # exec $SHELL
            fi
         fi
      elif [ "${PACKAGE_MANAGER}" = "apt-get" ]; then
         silent-apt-get-install "vault"
      elif [ "${PACKAGE_MANAGER}" = "yum" ]; then    # For Redhat distro:
         sudo yum install vault      # please test
         exit 9
      elif [ "${PACKAGE_MANAGER}" = "zypper" ]; then   # for [open]SuSE:
         sudo zypper install vault   # please test
         exit 9
   fi
      RESPONSE="$( vault --version | cut -d' ' -f2 )"  # 2nd column of "Vault v1.3.4"
      export VAULT_VERSION="${RESPONSE:1}"   # remove first character.
      note "VAULT_VERSION=$VAULT_VERSION"   # 1.4.2_1
      
      # Instead of vault -autocomplete-install   # for interactive manual use.
      # The complete command inserts in $HOME/.bashrc and .zsh
      complete -C /usr/local/bin/vault vault
         # No response is expected. Requires running exec $SHELL to work.


      #### "Installing govaultenv ..."
   if [ "${PACKAGE_MANAGER}" = "brew" ]; then
         # https://github.com/jamhed/govaultenv
         if ! command -v govaultenv >/dev/null; then  # command not found, so:
            h2 "Brew installing govaultenv ..."
            brew tap jamhed/govaultenv https://github.com/jamhed/govaultenv
            brew install govaultenv
         else  # installed already:
            if [ "${UPDATE_PKGS}" = true ]; then
               h2 "Brew upgrading govaultenv ..."
               brew tap jamhed/govaultenv https://github.com/jamhed/govaultenv
               brew upgrade jamhed/govaultenv/govaultenv
            fi
         fi
         note "govaultenv $( govaultenv | grep version | cut -d' ' -f1 )"
            # version:0.1.2 commit:d7754e38bb855f6a0c0c259ee2cced29c86a4da5 build by:goreleaser date:2019-11-13T19:47:16Z
      #elif for Alpine? 
      elif [ "${PACKAGE_MANAGER}" = "apt-get" ]; then
         silent-apt-get-install "govaultenv"  # please test
      elif [ "${PACKAGE_MANAGER}" = "yum" ]; then    # For Redhat distro:
         sudo yum install govaultenv      # please test
      elif [ "${PACKAGE_MANAGER}" = "zypper" ]; then   # for [open]SuSE:
         sudo zypper install govaultenv   # please test
      else
         fatal "Package code not recognized."
         exit
   fi



   if [ -n "${VAULT_HOST}" ]; then  # filled
         # use production ADDR from secrets
         # note "VAULT_USERNAME=${VAULT_USERNAME}"
         if [ -z "${VAULT_HOST}" ]; then  # it's blank:
            error "VAULT_HOST is not defined (within secrets file) ..."
         else
            if ping -c 1 "${VAULT_HOST}" &> /dev/null ; then 
               note "ping of ${VAULT_HOST} went fine."
            else
               error "${VAULT_HOST} ICMP ping failed. Aborting ..."
               info  "Is VPN (GlobalProtect) enabled for your account?"
               exit
            fi
         fi
   fi  # VAULT_HOST


   if [ "${USE_TEST_ENV}" = true ]; then   # -t

      # If vault process is already running, use it:
      PS_NAME="vault"
      PSID=$( pgrep -l vault )
      note "Test PSID=$PSID"

      if [ -n "${PSID}" ]; then  # does not exist:
         h2 "Start up local Vault ..."
         # CAUTION: Vault dev server is insecure and stores all data in memory only!
         export VAULT_HOST="127.0.0.1"
         export VAULT_ADDR="http://127.0.0.1:8200"
         export VAULT_USERNAME="devservermode"

         if [ "${DELETE_BEFORE}" = true ]; then  # -d 
            note "Stopping existing vault local process ..."  # https://learn.hashicorp.com/vault/getting-started/dev-server
            ps_kill "${PS_NAME}"  # bash function defined in this file.
         fi

         note "Starting vault local dev server at $VAULT_ADDR ..."  # https://learn.hashicorp.com/vault/getting-started/dev-server
         note "THIS SCRIPT PAUSES HERE. OPEN ANOTHER TERMINAL SESSION. Press control+C to stop service."
         # TODO: tee 
         vault server -dev  -dev-root-token-id=\"root\"

         # Manually copy Root Token: Root Token: s.ibP35DXQmHwDHc1NweL8dbrA 
         # and create a 

         #UNSEAL_KEY="$( echo "${RESPONSE}" | grep -o 'Unseal Key: [^, }]*' | sed 's/^.*: //' )"
         #VAULT_DEV_ROOT_TOKEN_ID="$( echo "${RESPONSE}" | grep -o 'Root Token: [^, }]*' | sed 's/^.*: //' )"
         #note -e "UNSEAL_KEY=$UNSEAL_KEY"
         #note -e "VAULT_DEV_ROOT_TOKEN_ID=$VAULT_DEV_ROOT_TOKEN_ID"
          #sample VAULT_DEV_ROOT_TOKEN_ID="s.Lgsh7FXX9cUKQttfFo1mdHjE"
         # Error checking seal status: Get "http://127.0.0.1:8200/v1/sys/seal-status": dial tcp 127.0.0.1:8200: connect: connection refuse

         exit  # because

      else  # USE_TEST_ENV}" = true
         h2 "Making use of \"${PS_NAME}\" as PSID=${PSID} ..."
         # See https://www.vaultproject.io/docs/secrets/ssh/signed-ssh-certificates.html
         # And https://grantorchard.com/securing-github-access-with-hashicorp-vault/
         # From -secrets opening ~/.secrets.zsh :
         note "$( VAULT_HOST=$VAULT_HOST )"
         note "$( VAULT_TLS_SERVER=$VAULT_TLS_SERVER )"
         note "$( VAULT_SERVERS=$VAULT_SERVERS )"
         note "$( CONSUL_HTTP_ADDR=$CONSUL_HTTP_ADDR )"

         ## With Admin access:

         export SSH_CLIENT_SIGNER_PATH="ssh-client-signer"
         # Assuming Vault was enabled earlier in this script.
         h2 "Create SSH CA ..."
         vault secrets enable -path="${SSH_CLIENT_SIGNER_PATH}"  ssh
         vault write "${SSH_CLIENT_SIGNER_PATH}/config/ca"  generate_signing_key=true


         export SSH_USER_ROLE="${GitHub_USER_EMAIL}"
         SSH_ROLE_FILENAME="myrole.json"  # reuse for every user
         echo -e "{" >"${SSH_ROLE_FILENAME}"
         echo -e "  \"allow_user_certificates\": true," >>"${SSH_ROLE_FILENAME}"
         echo -e "  \"allow_users\": \"*\"," >>"${SSH_ROLE_FILENAME}"
         echo -e "  \"default_extensions\": [" >>"${SSH_ROLE_FILENAME}"
         echo -e "    {" >>"${SSH_ROLE_FILENAME}"
         echo -e "      \"login@github.com\": \"$SSH_USER_ROLE\" " >>"${SSH_ROLE_FILENAME}"
         echo -e "    }" >>"${SSH_ROLE_FILENAME}"
         echo -e "  ]," >>"${SSH_ROLE_FILENAME}"
         echo -e "  \"key_type\": \"ca\"," >>"${SSH_ROLE_FILENAME}"
         echo -e "  \"default_user\": \"ubuntu\"," >>"${SSH_ROLE_FILENAME}"
         echo -e "  \"ttl\": \"30m0s\"" >>"${SSH_ROLE_FILENAME}"
         echo -e "}" >>"${SSH_ROLE_FILENAME}"
         if [ "${RUN_DEBUG}" = true ]; then  # -vv
            code "${SSH_ROLE_FILENAME}"
         fi

         h2 "Create user role ${SSH_USER_ROLE} with GH mapping ..."
         vault write "${SSH_CLIENT_SIGNER_PATH}/roles/${SSH_USER_ROLE}" "@${SSH_ROLE_FILENAME}"

      fi  # PSID for vault exists

   fi  # USE_TEST_ENV


   if [ -n "${VAULT_ADDR}" ]; then  # filled
            # Output to JSON instead & use jq to parse?
            # See https://stackoverflow.com/questions/2990414/echo-that-outputs-to-stderr
         note "vault status ${VAULT_ADDR} ..."
         RESPONSE="$( vault status 2>&2)"  # capture STDERR output to &1 (STDOUT)
            # Key                    Value
            # ---                    -----
            # Seal Type              shamir
            # Initialized            true
            # Sealed                 false
            # Total Shares           5
            # Threshold              3
            # Version                1.2.3
            # Cluster Name           vault-cluster-441d9c8b
            # Cluster ID             bc3501e7-857d-c77b-6807-8156f464f7ec
            # HA Enabled             true
            # HA Cluster             https://10.42.4.34:8201
            # HA Mode                standby
            # Active Node Address    http://10.42.4.34:8200
         ERR_RESPONSE="$( echo "${RESPONSE}" | awk '{print $1;}' )"
            # TODO: Check error code.
         if [ "Error" = "${ERR_RESPONSE}" ]; then
            fatal "${ERR_RESPONSE}"
            exit
         else
            note -e "${RESPONSE}"
         fi

   fi  # VAULT_ADDR


   # on either test or prod Vault instance:
   if [ -n "${VAULT_USERNAME}" ]; then  # is not empty
      if [ -n "${VAULT_USER_TOKEN}" ]; then
          h2 "Vault login using VAULT_USER_TOKEN ..."
          vault login -format json -method=okta \
             username="${VAULT_USERNAME}" passcode="${VAULT_USER_TOKEN}" | \
             jq -r '"\tUsername: " + .auth.metadata.username + "\n\tPolicies: " + .auth.metadata.policies + "\n\tLease time: " + (.auth.lease_duration|tostring)'
      else
         h2 "Vault okta login as \"${VAULT_USERNAME}\" (manually confirm on Duo) ..."
         /usr/bin/expect -f - <<EOD
spawn vault login -method=okta username="${VAULT_USERNAME}" 
expect "Password (will be hidden):"
send "${VAULT_PASSWORD}\n"
EOD
   echo -e "\n"  # force line break exiting program.

      # Get token: https://www.idkrtm.com/hashicorp-vault-managing-tokens/
      #h2 "Create token and set current session to use that token ..."
      #VAULT_USER_TOKEN=$(vault token-create -ttl="1h" -format=json | jq -r '.auth' | jq -r '.client_token')

      fi   # VAULT_USER_TOKEN
   fi  # VAULT_USERNAME

         # Success! You are now authenticated. The token information displayed below
         # is already stored in the token helper. You do NOT need to run "vault login"
         # again. Future Vault requests will automatically use this token.
         # Key                    Value
         # ---                    -----
         # token                  xxxxxeKRBJaWjui3cKCc5Y8Rj6
         # token_accessor         xxxxfN3Iu9o6JBvNYX4huZPqv
         # token_duration         768h / 24 = 32 days
         # token_renewable        true
         # token_policies         ["default" "team/githu" "vault/pki"]
         # identity_policies      []
         # policies               ["default" "team/gihubne" "vault/pki"]
         # token_meta_policies    
         # token_meta_username    xxx.com
         # https://help.github.com/en/github/setting-up-and-managing-organizations-and-teams/managing-your-organizations-ssh-certificate-authorities
         # https://help.github.com/en/github/setting-up-and-managing-organizations-and-teams/about-ssh-certificate-authorities

   # See https://vaultproject.io/docs/secrets/ssh/signed-ssh-certificates

   pushd  "$HOME/.ssh"
   h2 "At temporary $PWD ..."

   if [ "${RUN_DEBUG}" = true ]; then  # -vv
      note "$( ls -al )"
   fi

   # TODO: [10:47] by Roman
#      VAULT_ENGINE="github/ssh"
#      VAULT_POLICY="$VAULT_ENGINE/${GITHUB_USERNAME}"
#      h2 "Vault write policy for \"$VAULT_ENGINE/${GITHUB_USERNAME}\" ..."
#      cat <<EOT | vault policy write "${VAULT_POLICY}" - 
#path "${VAULT_ENGINE}/sign/* {
#   capabilities - ["create", "read', "update", "delete", "list"]
#}
#EOT 
      if [ ! -f "${LOCAL_SSH_KEYFILE}.pub" ]; then
         fatal "${LOCAL_SSH_KEYFILE}.pub not found!"
         exit 9
      else
         note "Using ${LOCAL_SSH_KEYFILE}.pub in $HOME/.ssh ..."
      fi


      rm -f "$HOME/.ssh/${LOCAL_SSH_KEYFILE}-cert.pub"

      h2 "Sign user public certificate ..."
      export SSH_CLIENT_SIGNER_PATH="github/ssh"
      #echo "SSH_CLIENT_SIGNER_PATH=${SSH_CLIENT_SIGNER_PATH}"
      #echo "VAULT_USERNAME=${VAULT_USERNAME}"

      echo "LOCAL_SSH_KEYFILE=${LOCAL_SSH_KEYFILE}"
      vault write -field=signed_key "${SSH_CLIENT_SIGNER_PATH}/sign/${VAULT_USERNAME}" \
         public_key="@$HOME/.ssh/${LOCAL_SSH_KEYFILE}.pub" > "$HOME/.ssh/${LOCAL_SSH_KEYFILE}-cert.pub"
exit
#      vault write -field=signed_key $ENGINE/sign/$GITHUB_NAME public_key=@$HOME/.ssh/id_rsa.pub > ~/.ssh/id_rsa-cert.pub

      vault write -field=signed_key "${SSH_CLIENT_SIGNER_PATH}/roles/${SSH_USER_ROLE}" \
         "public_key=@./${LOCAL_SSH_KEYFILE}.pub" \
         | tee "${SSH_CERT_PUB_KEYFILE}.pub"

      h2 "Inspect ${SSH_CERT_PUB_KEYFILE} ..."
      if [ ! -f "${SSH_CERT_PUB_KEYFILE}.pub" ]; then
         fatal "${SSH_CERT_PUB_KEYFILE}.pub not found!"
         exit 9
      else
         ssh-keygen -L -f "${SSH_CERT_PUB_KEYFILE}.pub"
      fi

   popd  # from "$HOME/.ssh"
   h2 "Back into $( $PWD ) ..."

fi  # USE_VAULT


#### TODO: 34. Put secret in Hashicorp Vault

if [ "${VAULT_PUT}" = true ]; then  # -n

   note -e "\n Put secret/hello ..."
   note -e "\n"
   # Make CLI calls to the kv secrets engine for key/value pair:
   vault kv put secret/hello vault="${VAULT_USERNAME}"
      
   note -e "\n Get secret/hello text ..."
   note -e "\n"
   vault kv get secret/hello  # to system variable for .py program.
         # See https://www.vaultproject.io/docs/commands/index.html

   #note -e "\n Get secret/hello as json ..."
   #note -e "\n"
   #vault kv get -format=json secret/hello | jq -r .data.data.excited
   #note -e "\n Cat secret/hello from json ..."
   #cat .data.data.excited

   note -e "\n Enable userpass method ..."
   note -e "\n"
   vault auth enable userpass  # is only done once.
      # Success! Enabled userpass auth method at: userpass/

fi  # USE_VAULT


### 35. Install NodeJs
if [ "${NODE_INSTALL}" = true ]; then  # -n

# If VAULT is used:

   # h2 "Install -node"
   if [ "${PACKAGE_MANAGER}" = "brew" ]; then # -U
      if ! command -v node ; then
         h2 "Installing node ..."
         brew install node
      else
         if [ "${UPDATE_PKGS}" = true ]; then
            h2 "Upgrading node ..."
            brew upgrade node
         fi
      fi
   fi
   note "Node version: $( node --version )"   # v13.8.0
   note "npm version:  $( npm --version )"    # 6.13.7

   h2 "After git clone https://github.com/wesbos/Learn-Node.git ..."
   pwd
   if [ ! -d "starter-files" ]; then   # not found
      fatal  "starter-files folder not found. Aborting..."
      exit 9
   else
      # within repo:
      # cd starter-files 
      cd "stepped-solutions/45 - Finished App"
      h2 "Now at folder path $PWD ..."
      ls -1

      if [ "${CLONE_GITHUB}" = true ]; then   # -clone specified:
   
         h2 "npm install ..."
             npm install   # based on properties.json

         h2 "npm audit fix ..."
             npm audit fix
      fi
   fi

   if [ ! -f "package.json" ]; then   # not found
      fatal  "package.json not found. Aborting..."
      exit 9
   fi


   if [ ! -f "variables.env" ]; then   # not created
      h2 "Downloading variables.env ..."
      # Alternative: Copy from your $HOME/.secrets.env file
      curl -s -O https://raw.githubusercontent.com/wesbos/Learn-Node/master/starter-files/variables.env.sample \
         variables.env
   else
      warning "Reusing variables.env from previous run."
   fi


   # See https://docs.mongodb.com/manual/tutorial/install-mongodb-on-os-x/
   # Instead of https://www.mongodb.com/cloud/atlas/mongodb-google-cloud
   if [ "${PACKAGE_MANAGER}" = "brew" ]; then # -U
      if ! command -v mongo ; then  # command not found, so:
         h2 "Installing mmongodb-compass@4.2 ..."
         brew tap mongodb/brew
         brew install mongodb-compass@4.2
      else  # installed already:
         if [ "${UPDATE_PKGS}" = true ]; then
            h2 "Re-installing mongodb-compass@4.2 ..."
            brew untap mongodb/brew && brew tap mongodb/brew
            brew install mongodb-compass@4.2
         fi
      fi
   # elif other operating systems:
   fi
   # Verify whether MongoDB is running, search for mongod in your running processes:
   note "$( mongo --version | grep MongoDB )"    # 3.4.0 in video. MongoDB shell version v4.2.3 

      if [ ! -d "/Applications/mongodb Compass.app" ]; then  # directory not found:
         h2 "Installing cask mongodb-compass ..."
         brew install --cask mongodb-compass
            # Downloading https://downloads.mongodb.com/compass/mongodb-compass-1.20.5-darwin-x64.dmg
      else  # installed already:
         if [ "${UPDATE_PKGS}" = true ]; then
            h2 "Re-installing cask mongodb-compass ..."
            brew cask uninstall mongodb-compass
         fi
      fi

   h2 "TODO: Configuring MongoDB $MONGO_DB_NAME [4:27] ..."
   replace_1config () {
      file=$1
      var=$2
      new_value=$3
      awk -v var="$var" -v new_val="$new_value" 'BEGIN{FS=OFS="="}match($1, "^\\s*" var "\\s*") {$2=" " new_val}1' "$file"
   }
   # Use the function defined above: https://stackoverflow.com/questions/5955548/how-do-i-use-sed-to-change-my-configuration-files-with-flexible-keys-and-values/5955591#5955591
   # replace_1config "conf" "MAIL_USER" "${GitHub_USER_EMAIL}"  # from 123
   # replace_1config "conf" "MAIL_HOST" "${GitHub_USER_EMAIL}"  # from smpt.mailtrap.io
   # NODE_ENV=development
   # DATABASE=mongodb://user:pass@host.com:port/database
   # MAIL_USER=123
   # MAIL_PASS=123
   # MAIL_HOST=smtp.mailtrap.io
   # MAIL_PORT=2525
   # PORT=7777
   # MAP_KEY=AIzaSyD9ycobB5RiavbXpJBo0Muz2komaqqvGv0
   # SECRET=snickers
   # KEY=sweetsesh


   # shellcheck disable=SC2009  # Consider using pgrep instead of grepping ps output.
   #RESPONSE="$( ps aux | grep -v grep | grep mongod )"
   RESPONSE="$( pgrep -l mongod )"
                            note "${RESPONSE}"
         # root 10318   0.0  0.0  4763196   7700 s002  T     4:02PM   0:00.03 sudo mongod
              MONGO_PSID=$( echo "${RESPONSE}" | awk '{print $2}' )

   Kill_process(){
      info "Killing process $1 ..."
      sudo kill -2 "$1"
      sleep 2
   }
   if [ -z "${MONGO_PSID}" ]; then  # found
      h2 "Shutting down mongoDB ..."
      # See https://docs.mongodb.com/manual/tutorial/manage-mongodb-processes/
      # DOESN'T WORK: mongod --shutdown
      sudo kill -2 "${MONGO_PSID}"
      #Kill_process "${MONGO_PSID}"  # invoking function above.
         # No response expected.
      sleep 2
   fi
      h2 "Start MongoDB as a background process ..."
      mongod --config /usr/local/etc/mongod.conf --fork
         # ADDITIONAL: --port 27017 --replSet replset --logpath ~/log/mongo.log
         # about to fork child process, waiting until server is ready for connections.
         # forked process: 16698
      # if successful:
         # child process started successfully, parent exiting
      # if not succesful:
         # ERROR: child process failed, exited with error number 48
         # To see additional information in this output, start without the "--fork" option.

      # sudo mongod &
         # RESPONSE EXAMPLE: [1] 10318

   h2 "List last lines for status of mongod process ..." 
   tail -5 /usr/local/var/log/mongodb/mongo.log

fi # if [ "${NODE_INSTALL}


### 36. Install Virtualenv
if [ "${RUN_VIRTUALENV}" = true ]; then  # -V  (not the default pipenv)

   h2 "Install -python"
   if [ "${PACKAGE_MANAGER}" = "brew" ]; then # -U
      if ! command -v python3 ; then
         h2 "Installing python3 ..."
         brew install python3
      else
         if [ "${UPDATE_PKGS}" = true ]; then
            h2 "Upgrading python3 ..."
            brew upgrade python3
         fi
      fi
   elif [ "${PACKAGE_MANAGER}" = "apt-get" ]; then
      silent-apt-get-install "python3"
   fi
   note "$( python3 --version )"  # Python 3.7.6
   note "$( pip3 --version )"      # pip 19.3.1 from /Library/Python/2.7/site-packages/pip (python 2.7)


      # h2 "Install virtualenv"  # https://levipy.com/virtualenv-and-virtualenvwrapper-tutorial
      # to create isolated Python environments.
      #pipenv install virtualenvwrapper

      if [ -d "venv" ]; then   # venv folder already there:
         note "venv folder being re-used ..."
      else
         h2 "virtualenv venv ..."
         virtualenv venv
      fi

      h2 "source venv/bin/activate"
      # shellcheck disable=SC1091 # Not following: venv/bin/activate was not specified as input (see shellcheck -x).
      source venv/bin/activate

      # RESPONSE=$( python3 -c "import sys; print(sys.version)" )
      RESPONSE=$( python3 -c "import sys, os; is_conda = os.path.exists(os.path.join(sys.prefix, 'conda-meta'))" )
      h2 "Within (venv) Python3: "
      # echo "${RESPONSE}"
     
   if [ -f "requirements.txt" ]; then
      # Created by command pip freeze > requirements.txt previously.
      # see https://medium.com/@boscacci/why-and-how-to-make-a-requirements-txt-f329c685181e
      # Install the latest versions, which may not be backward-compatible:
      pip3 install -r requirements.txt
   fi

fi   # RUN_VIRTUALENV means Pipenv default



### 37. Configure Pyenv with virtualenv
if [ "${USE_PYENV}" = true ]; then  # -py

   h2 "Use Pipenv by default (not overrided by -Virtulenv)"
   # https://www.activestate.com/blog/how-to-build-a-ci-cd-pipeline-for-python/

   # pipenv commands: https://pipenv.kennethreitz.org/en/latest/cli/#cmdoption-pipenv-rm
   note "pipenv in $( pipenv --where )"
      # pipenv in /Users/wilson_mar/projects/python-samples
   # pipenv --venv  # no such option¶
   
   note "$( pipenv --venv || true )"

   #h2 "pipenv lock --clear to flush the pipenv cache"
   #pipenv lock --clear

   # If virtualenvs exists for repo, remove it:
   if [ -n "${WORKON_HOME}" ]; then  # found somethiNg:
      # Unless export PIPENV_VENV_IN_PROJECT=1 is defined in your .bashrc/.zshrc,
      # and export WORKON_HOME=~/.venvs overrides location,
      # pipenv stores virtualenvs globally with the name of the project’s root directory plus the hash of the full path to the project’s root,
      # so several can be generated.
      PIPENV_PATH="${WORKON_HOME}"
   else
      PIPENV_PATH="$HOME/.local/share/virtualenvs/"
   fi
   # shellcheck disable=SC2061  # Quote the parameter to -name so the shell won't interpret it.
   # shellcheck disable=SC2035  # Use ./*glob* or -- *glob* so names with dashes won't become options.
   RESPONSE="$( find "${PIPENV_PATH}" -type d -name *"${PROJECT_FOLDER_NAME}"* )"
   if [ -n "${RESPONSE}" ]; then  # found somethiNg:
      note "${RESPONSE}"
      if [ "${DELETE_BEFORE}" = true ]; then  # -d 
         pipenv --rm
            # Removing virtualenv (/Users/wilson_mar/.local/share/virtualenvs/bash-8hDxYnPf)…
            # or "No virtualenv has been created for this project yet!  Aborted!

         # pipenv clean  # creates a virtualenv
            # uninistall all dev dependencies and their dependencies:

         pipenv_install   # 
      else
         h2 "TODO: pipenv using current virtualenv ..."
      fi
   else  # no env found, so ...
      h2 "Creating pipenv - no previous virtualenv ..."
      PYTHONPATH='.' pipenv run python main.py    
   fi 

fi    # USE_PYENV


### 38. Install Anaconda
if [ "${RUN_ANACONDA}" = true ]; then  # -A

         if [ "${PACKAGE_MANAGER}" = "brew" ]; then # -U
            if ! command -v anaconda ; then
               h2 "brew install --cask anaconda ..."  # miniconda
               brew install --cask anaconda
            else
               if [ "${UPDATE_PKGS}" = true ]; then
                  h2 "Upgrading anaconda ..."
                  brew cask upgrade anaconda
               fi
            fi
         elif [ "${PACKAGE_MANAGER}" = "apt-get" ]; then
            silent-apt-get-install "anaconda"
         fi
         note "$( anaconda version )"  # anaconda Command line client (version 1.7.2)
         #note "$( conda info )"  # VERBOSE
         #note "$( conda list anaconda$ )"
                        
         export PREFIX="/usr/local/anaconda3"
         export   PATH="/usr/local/anaconda3/bin:$PATH"
         note "PATH=$( $PATH )"

         # conda create -n PDSH python=3.7 --file requirements.txt
         # conda create -n tf tensorflow

fi  # RUN_ANACONDA


### 39. RUN_GOLANG  ### See https://wilsonmar.github.io/golang
if [ "${RUN_GOLANG}" = true ]; then  # -go
   h2 "Installing Golang using brew ..."
   brew install golang

   # It’s considered best practice to use $HOME/go folder for your workspace!
   mkdir -p $HOME/go/{bin,src,pkg}
   # NOTE: GOPATH, GOROOT in PATH are defined in ~/.zshrc during each login.

   # Extra: Go Version Manager (GVM)
   # # If you wish To run multiple version of go, you might want to install this (ref here)
   # bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
   # # List All Go Version
   # gvm listall
   # # Use GVM to install GO (pick a version from above list)
   # gvm install go1.16.2
   # gvm use go1.16.2 [--default]

   # See https://www.golangprograms.com/advance-programs/code-formatting-and-naming-conventions-in-golang.html
   # go get -u github.com/golang/gofmt/gofmt
      # FIXME:
      # remote: Repository not found.
      # fatal: repository 'https://github.com/golang/gofmt/' not found
      # package github.com/golang/gofmt/gofmt: exit status 128
   # gofmt -w test1.go
   
   # go get -u github.com/golang/lint/golint
      # ERROR: package github.com/golang/lint/golint: code in directory /Users/wilson_mar/gopkgs/src/github.com/golang/lint/golint expects import "golang.org/x/lint/golint"
   # golint

   # https://github.com/securego/gosec
   # binary will be $GOPATH/bin/gosec
   #curl -sfL https://raw.githubusercontent.com/securego/gosec/master/install.zsh \
#   | sh -s -- -b "${GOPATH}/bin" vX.Y.Z
   # securego/gosec info checking GitHub for tag 'vX.Y.Z'
   # securego/gosec crit unable to find 'vX.Y.Z' - use 'latest' or see https://github.com/securego/gosec/releases for details

   # ALTERNATELY: install it into ./bin/
   # curl -sfL https://raw.githubusercontent.com/securego/gosec/master/install.zsh | sh -s vX.Y.Z

   # In alpine linux (as it does not come with curl by default)
   # wget -O - -q https://raw.githubusercontent.com/securego/gosec/master/install.zsh | sh -s vX.Y.Z

   # If you want to use the checksums provided on the "Releases" page
   # then you will have to download a tar.gz file for your operating system instead of a binary file
#   wget https://github.com/securego/gosec/releases/download/vX.Y.Z/gosec_vX.Y.Z_OS.tar.gz
      # --2020-06-24 07:28:19--  https://github.com/securego/gosec/releases/download/vX.Y.Z/gosec_vX.Y.Z_OS.tar.gz
      # Resolving github.com (github.com)... 140.82.114.3
      # Connecting to github.com (github.com)|140.82.114.3|:443... connected.
      # HTTP request sent, awaiting response... 404 Not Found
      # 2020-06-24 07:28:20 ERROR 404: Not Found.

   # The file will be in the current folder where you run the command 
   # and you can check the checksum like this
   #echo "check sum from the check sum file>  gosec_vX.Y.Z_OS.tar.gz" | sha256sum -c -
   #gosec --help

#   conda create -n godev go -c conda-forge
#   conda activate godev
#   echo $GOROOT
#   which go

fi   # RUN_GOLANG


### 40. Install Python
if [ "${RUN_PYTHON}" = true ]; then  # -s

   # https://docs.python-guide.org/dev/virtualenvs/

   PYTHON_VERSION="$( python3 -V )"   # "Python 3.7.6"
   # TRICK: Remove leading white space after removing first word
   PYTHON_SEMVER=$(sed -e 's/^[[:space:]]*//' <<<"${PYTHON_VERSION//Python/}")

   if [ -z "${MY_FILE}" ]; then  # is empty
      fatal "No program -file specified ..."
      exit 9
   fi

     if [ -z "${MY_FOLDER}" ]; then  # is empty
         note "-Folder not specified for within $PWD ..."
      else
         cd  "${MY_FOLDER}"
      fi

      if [ ! -f "${MY_FILE}" ]; then  # file not found:
         fatal "-file \"${MY_FILE}\" not found ..."
         exit 9
      fi

      h2 "-Good Python ${PYTHON_SEMVER} running ${MY_FILE} ${RUN_PARMS} ..."

# while debugging:
#         if [ ! -f "Pipfile" ]; then  # file not found:
#            note "Pipfile found, run Pipenv ${MY_FILE} ${RUN_PARMS} ..."
#            PYTHONPATH='.' pipenv run python "${MY_FILE}" "${RUN_PARMS}"
#         else

            # TRICK: Determine if a Python module was installed:
            RESPONSE="$( python -c 'import pkgutil; print(1 if pkgutil.find_loader("pylint") else 0)' )"
            if [ "${RESPONSE}" = 0 ]; then
               h2 "Installing pylint code scanner ..." 
               # See https://pylint.pycqa.org/en/latest/ and https://www.python.org/dev/peps/pep-0008/
               python3 -m pip install pylint
               command -v pylint   # https://stackoverflow.com/questions/43272664/linter-pylint-is-not-installed
            else  # RESPONSE=1
               if [ "${UPDATE_PKGS}" = true ]; then
                  h2 "Upgrading pylint ..."
                  python3 -m pip install pylint --upgrade
               fi
            fi
               h2 "Running pylint scanner on -file ${MY_FILE} ..."
               # TRICK: Route console output to a temp folder for display only on error:
               pylint "${MY_FILE}" 1>pylint.console.log  2>pylint.err.log
               STATUS=$?
               if ! [ "${STATUS}" = "0" ]; then  # NOT good
                  if [ "${CONTINUE_ON_ERR}" = true ]; then  # -cont
                     warning "Pylint found ${STATUS} blocking issues, being ignored."
                  else
                     fatal "pylint found issues : ${STATUS} "
                     cat pylint.err.log
                     cat pylint.console.log
                     # The above files are removed depending on $REMOVE_GITHUB_AFTER
                     exit 9
                  fi
               else
                  warning "Pylint found no issues. Congratulations."
               fi

            RESPONSE="$( python -c 'import pkgutil; print(1 if pkgutil.find_loader("flake8") else 0)' )"
            if [ "${RESPONSE}" = 0 ]; then
               h2 "Installing flake8 PEP8 code formatting scanner ..." 
               # See https://flake8.pycqa.org/en/latest/ and https://www.python.org/dev/peps/pep-0008/
               python3 -m pip install flake8
            else
               if [ "${UPDATE_PKGS}" = true ]; then
                  h2 "Upgrading flake8 ..."
                  python3 -m pip install flake8 --upgrade
               fi
            fi
               h2 "Running flake8 Pip8 code formatting scanner on ${MY_FILE} ..."
               flake8 "${MY_FILE}"
               flake8 "${MY_FILE}" 1>flake8.console.log  2>flake8.err.log
               STATUS=$?
               if ! [ "${STATUS}" = "0" ]; then  # NOT good
                  if [ "${CONTINUE_ON_ERR}" = true ]; then  # -cont
                     warning "Pylint found ${STATUS} blocking issues, being ignored."
                  else
                     fatal "pylint found issues : ${STATUS} "
                     cat flake8.err.log
                     cat flake8.console.log
                     # The above files are removed depending on $REMOVE_GITHUB_AFTER
                     exit 9
                  fi
               else
                  warning "Pylint found no issues. Congratulations."
               fi

            RESPONSE="$( python -c 'import pkgutil; print(1 if pkgutil.find_loader("bandit") else 0)' )"
            if [ "${RESPONSE}" = 0 ]; then
               h2 "Installing Bandit secure Python coding scanner ..."
               # See https://pypi.org/project/bandit/
               python3 -m pip install bandit
            else
               if [ "${UPDATE_PKGS}" = true ]; then
                  h2 "Upgrading flake8 ..."
                  python3 -m pip install bandit --upgrade
               fi
            fi
               h2 "Running Bandit secure Python coding scanner ..."  
               # See https://developer.rackspace.com/blog/getting-started-with-bandit/
               # TRICK: Route console output to a temp folder for display only on error:
               bandit -r "${MY_FILE}" 1>bandit.console.log  2>bandit.err.log
               STATUS=$?
               if ! [ "${STATUS}" = "0" ]; then  # NOT good
                  fatal "Bandit found issues : ${STATUS} "
                  cat bandit.err.log
                  cat bandit.console.log
                  # The above files are removed depending on $REMOVE_GITHUB_AFTER
                  exit 9
               else
                  note "Bandit found ${STATUS} blocking issues."
               fi


            # Run a different way than with Pipfile:
            h2 "Running Python file ${MY_FILE} ${RUN_PARMS} ..."
            python3 "${MY_FILE}" "${RUN_PARMS}"
         
#      fi   # Pipfile

      # Instead of https://www.jetbrains.com/pycharm/download/other.html
      if [ ! -d "/Applications/mongodb Compass.app" ]; then  # directory not found:
         h2 "brew install --cask PyCharm.app ..."
         brew install --cask pycharm
      else  # installed already:
         if [ "${UPDATE_PKGS}" = true ]; then
            h2 "brew cask upgrade PyCharm.app ..."
            brew cask upgrade pycharm
         fi
      fi
      if [ "${OPEN_APP}" = true ]; then  # -o
         if [ "${OS_TYPE}" = "macOS" ]; then
            sleep 3
            open "/Applications/PyCharm.app"
         fi
      fi

fi  # RUN_PYTHON


### 41. RUN_TERRAFORM
if [ "${RUN_TERRAFORM}" = true ]; then  # -tf
   h2 "Running Terraform"
   # echo "$PWD/${MY_FOLDER}/${MY_FILE}"

fi    # RUN_TERRAFORM


### 42. RUN_TENSORFLOW
if [ "${RUN_TENSORFLOW}" = true ]; then  # -tsf

      if [ -f "$PWD/${MY_FOLDER}/${MY_FILE}" ]; then
         echo "$PWD/${MY_FOLDER}/${MY_FILE}"
         # See https://jupyter-notebook.readthedocs.io/en/latest/notebook.html?highlight=trust#signing-notebooks
         jupyter trust "${MY_FOLDER}/${MY_FILE}"
         # RESPONSE: Signing notebook: section_2/2-3.ipynb
      else
         echo "$PWD/${MY_FOLDER}/${MY_FILE} not found among ..."
         ls   "$PWD/${MY_FOLDER}"
         exit 9
      fi

      # Included in conda/anaconda: jupyterlab & matplotlib

      h2 "installing tensorflow, tensorboard ..."
      # TODO: convert to use pipenv instead?
      pip3 install --upgrade tensorflow   # includes https://pypi.org/project/tensorboard/
      h2 "pip3 show tensorflow"
      pip3 show tensorflow

      # h2 "Install cloudinary Within requirements.txt : "
      # pip install cloudinary
      #if ! command -v jq ; then
      #   h2 "Installing jq ..."
      #   brew install jq
      #else
      #   if [ "${UPDATE_PKGS}" = true ]; then
      #      h2 "Upgrading jq ..."
      #      brew --upgrade --force-reinstall jq 
      #   fi
      #fi
      # /usr/local/bin/jq

   h2 "ipython kernel install --user --name=.venv"
   ipython kernel install --user --name=venv

   h2 "Starting Jupyter with Notebook $MY_FOLDER/$MY_FILE ..."
   jupyter notebook --port 8888 "${MY_FOLDER}/${MY_FILE}" 
      # & for background run
         # jupyter: open http://localhost:8888/tree
      # The Jupyter Notebook is running at:
      # http://localhost:8888/?token=7df8adf321965117234f22973419bb92ecab4e788537b90f

   if [ "$KEEP_PROCESSES" = false ]; then  # -K
      ps_kill 'tensorboard'   # bash function defined in this file.
   fi

fi  # if [ "${RUN_TENSORFLOW}"


#### 43. Finish RUN_VIRTUALENV
if [ "${RUN_VIRTUALENV}" = true ]; then  # -V
      h2 "Execute deactivate if the function exists (i.e. has been created by sourcing activate):"
      # per https://stackoverflow.com/a/57342256
      declare -Ff deactivate && deactivate
         #[I 16:03:18.236 NotebookApp] Starting buffering for db5328e3-...
         #[I 16:03:19.266 NotebookApp] Restoring connection for db5328e3-aa66-4bc9-94a1-3cf27e330912:84adb360adce4699bccffc00c7671793
fi

#### 44. USE_TEST_ENV

if [ "${USE_TEST_ENV}" = true ]; then  # -t

   if [ "${PACKAGE_MANAGER}" = "brew" ]; then
      if ! command -v selenium ; then
         h2 "Pip installing selenium ..."
         pip install selenium
      else
         if [ "${UPDATE_PKGS}" = true ]; then
            # selenium in /usr/local/lib/python3.7/site-packages (3.141.0)
            # urllib3 in /usr/local/lib/python3.7/site-packages (from selenium) (1.24.3)
            h2 "Pip upgrading selenium ..."
            pip install -U selenium
         fi
      fi
      # note "$( selenium --version | grep GnuPG )"  # gpg (GnuPG) 2.2.19
   fi

   # https://www.guru99.com/selenium-python.html shows use of Eclipse IDE
   # https://realpython.com/modern-web-automation-with-python-and-selenium/ headless
   # https://www.seleniumeasy.com/python/example-code-using-selenium-webdriver-python Windows chrome

   h2 "Install drivers of Selenium on browsers"
   # First find out what version of Chrome at chrome://settings/help
   # Based on: https://sites.google.com/a/chromium.org/chromedriver/downloads
   # For 80: https://chromedriver.storage.googleapis.com/80.0.3987.106/chromedriver_mac64.zip
   # Unzip creates chromedriver (executable with no extension)
   # Move it to /usr/bin or /usr/local/bin
   # ls: 14713200 Feb 12 16:47 /Users/wilson_mar/Downloads/chromedriver

   # https://developer.apple.com/documentation/webkit/testing_with_webdriver_in_safari
   # Safari:	https://webkit.org/blog/6900/webdriver-support-in-safari-10/
      # /usr/bin/safaridriver is built into macOS.
      # Run: safaridriver --enable  (needs password)

   # Firefox:	https://github.com/mozilla/geckodriver/releases
      # geckodriver-v0.26.0-macos.tar expands to geckodriver
   
   # reports are produced by TestNG, a plug-in to Selenium.

fi # if [ "${USE_TEST_ENV}"


### 45. RUBY_INSTALL
if [ "${RUBY_INSTALL}" = true ]; then  # -i

   # https://websiteforstudents.com/install-refinery-cms-ruby-on-rails-on-ubuntu-16-04-18-04-18-10/

   if [ "${PACKAGE_MANAGER}" = "brew" ]; then

      if ! command -v gnupg2 ; then
         h2 "Installing gnupg2 ..."
         brew install gnupg2
      else
         if [ "${UPDATE_PKGS}" = true ]; then
            h2 "Upgrading gnupg2 ..."
            brew upgrade gnupg2
         fi
      fi
      note "$( gpg --version | grep GnuPG )"  # gpg (GnuPG) 2.2.19

      # download and install the mpapis public key with GPG:
      #curl -sSL https://rvm.io/mpapis.asc | gpg --import -
         # (Michael Papis (mpapis) is the creator of RVM, and his public key is used to validate RVM downloads:
         # gpg-connect-agent --dirmngr 'keyserver --hosttable'
      #gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
         # FIX: gpg: keyserver receive failed: No route to host

      if ! command -v imagemagick ; then
         h2 "Installing imagemagick ..."
         brew install imagemagick
      else
         if [ "${UPDATE_PKGS}" = true ]; then
            h2 "Upgrading imagemagick ..."
            brew upgrade imagemagick
         fi
      fi

   elif [ "${PACKAGE_MANAGER}" = "apt-get" ]; then

      sudo apt-get update

      h2 "Use apt instead of apt-get since Ubuntu 16.04 (from Linux Mint)"
      sudo apt install curl git
      note "$( git --version --build-options )"
         # git version 2.20.1 (Apple Git-117), cpu: x86_64, no commit associated with this build
         # sizeof-long: 8, sizeof-size_t: 8

      h2 "apt install imagemagick"
      sudo apt install imagemagick

      h2 "sudo apt autoremove"
      sudo apt autoremove

      h2 "Install NodeJs to run Ruby"
      curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
      silent-apt-get-install "nodejs"

      h2 "Add Yarn repositories and keys (8.x deprecated) for apt-get:"
      curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
         # response: OK
      echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
      silent-apt-get-install "yarn" 

      h2 "Install Ruby dependencies "
      silent-apt-get-install "rbenv"   # instead of git clone https://github.com/rbenv/rbenv.git ~/.rbenv
         # Extracting templates from packages: 100%
      silent-apt-get-install "autoconf"
      silent-apt-get-install "bison"
      silent-apt-get-install "build-essential"
      silent-apt-get-install "libssl-dev"
      silent-apt-get-install "libyaml-dev"
      silent-apt-get-install "zlib1g-dev"
      silent-apt-get-install "libncurses5-dev"
      silent-apt-get-install "libffi-dev"
         # E: Unable to locate package autoconf bison
      silent-apt-get-install "libreadline-dev"    # instead of libreadline6-dev 
      silent-apt-get-install "libgdbm-dev"    # libgdbm3  # (not found)

      silent-apt-get-install "libpq-dev"
      silent-apt-get-install "libxml2-dev"
      silent-apt-get-install "libxslt1-dev"
      silent-apt-get-install "libcurl4-openssl-dev"
      
      h2 "Install SQLite3 ..."
      silent-apt-get-install "libsqlite3-dev"
      silent-apt-get-install "sqlite3"

      h2 "Install MySQL Server"
      silent-apt-get-install "mysql-client"
      silent-apt-get-install "mysql-server"
      silent-apt-get-install "libmysqlclient-dev"  # unable to locate

      #h2 "Install PostgreSQL ..."
      #silent-apt-get-install "postgres"

   elif [ "${PACKAGE_MANAGER}" = "yum" ]; then
      # TODO: More For Redhat distro:
      sudo yum install ruby-devel
   elif [ "${PACKAGE_MANAGER}" = "zypper" ]; then
      # TODO: More for [open]SuSE:
      sudo zypper install ruby-devel
   fi

      note "$( nodejs --version )"
      note "$( yarn --version )"
      note "$( sqlite3 --version )"


   cd ~/
   h2 "Now at path $PWD ..."

   h2 "git clone ruby-build.git to use the rbenv install command"
   FOLDER_PATH="$HOME/.rbenv/plugins/ruby-build"
   if [   -d "${FOLDER_PATH}" ]; then  # directory found, so remove it first.
      note "Deleting ${FOLDER_PATH} ..."
      rm -rf "${FOLDER_PATH}"
   fi
      git clone https://github.com/rbenv/ruby-build.git  "${FOLDER_PATH}"
         if grep -q ".rbenv/plugins/ruby-build/bin" "${BASHFILE}" ; then
            note "rbenv/plugins/ already in ${BASHFILE}"
         else
            info "Appending rbenv/plugins in ${BASHFILE}"
            echo "export PATH=\"$HOME/.rbenv/plugins/ruby-build/bin:$PATH\" " >>"${BASHFILE}"
            source "${BASHFILE}"
         fi
   
   if ! command -v rbenv ; then
      fatal "rbenv not found. Aborting for script fix ..."
      exit 1
   fi

   h2 "rbenv init"
            if grep -q "rbenv init " "${BASHFILE}" ; then
               note "rbenv init  already in ${BASHFILE}"
            else
               info "Appending rbenv init - in ${BASHFILE} "
               # shellcheck disable=SC2016 # Expressions don't expand in single quotes, use double quotes for that.
               echo "eval \"$( rbenv init - )\" " >>"${BASHFILE}"
               source "${BASHFILE}"
            fi
            # This results in display of rbenv().

   # Manually lookup latest stable release in https://www.ruby-lang.org/en/downloads/
   RUBY_RELEASE="2.6.5"  # 2.7.0"
   RUBY_VERSION="2.6"
      # To avoid rbenv: version `2.7.0' not installed

   h2 "Install Ruby $RUBY_RELEASE using rbenv ..."
   # Check if the particular Ruby version is already installed by rbenv
   RUBY_RELEASE_RESPONSE="$( rbenv install -l | grep $RUBY_RELEASE )"
   if [ -z "$RUBY_RELEASE_RESPONSE" ]; then  # not found:
      rbenv install "${RUBY_RELEASE}"
      # Downloading ...
   fi

   h2 "rbenv global"
   rbenv global "${RUBY_RELEASE}"   # insted of -l (latest)

   h2 "Verify ruby version"
   ruby -v

   h2 "To avoid Gem:ConfigMap deprecated in gem 1.8.x"
   # From https://github.com/rapid7/metasploit-framework/issues/12763
   gem uninstall #etc
   # This didn't fix: https://ryenus.tumblr.com/post/5450167670/eliminate-rubygems-deprecation-warnings
   # ruby -e "`gem -v 2>&1 | grep called | sed -r -e 's#^.*specifications/##' -e 's/-[0-9].*$//'`.split.each {|x| `gem pristine #{x} -- --build-arg`}"
   
   h2 "gem update --system"
   # Based on https://github.com/rubygems/rubygems/issues/3068
   # to get rid of the warnings by downgrading to the latest RubyGems that doesn't have the deprecation warning:
   sudo gem update --system   # 3.0.6
   
   gem --version
   
   h2 "create .gemrc"  # https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-16-04
   if [ ! -f "$HOME/.gemrc" ]; then   # file NOT found, so create it:
      echo "gem: --no-document" > ~/.gemrc
   else
      if grep -q "gem: --no-document" "$HOME/.gemrc" ; then   # found in file:
         note "gem: --no-document already in $HOME/.gemrc "
      else
         info "Adding gem --no-document in $HOME/.gemrc "
         echo "gem: --no-document" >> "$HOME/.gemrc"
      fi
   fi

   h2 "gem install bundler"  # https://bundler.io/v1.12/rationale.html
   sudo gem install bundler   # 1.17.3 to 2.14?
   note "$( bundler --version )"  # Current Bundler version: bundler (2.1.4)

   # To avoid Ubuntu rails install ERROR: Failed to build gem native extension.
   # h2 "gem install ruby-dev"  # https://stackoverflow.com/questions/22544754/failed-to-build-gem-native-extension-installing-compass
   h2 "Install ruby${RUBY_VERSION}-dev for Ruby Development Headers native extensions ..."
   silent-apt-get-install ruby-dev   # "ruby${RUBY_VERSION}-dev"
        # apt-get install ruby-dev

   h2 "gem install rails"  # https://gorails.com/setup/ubuntu/16.04
   sudo gem install rails    # latest at https://rubygems.org/gems/rails/versions
   if ! command -v rails ; then
      fatal "rails not found. Aborting for script fix ..."
      exit 1
   fi
   note "$( rails --version | grep "Rails" )"  # Rails 3.2.22.5
      # See https://rubyonrails.org/
      # 6.0.2.1 - December 18, 2019 (6.5 KB)

   h2 "rbenv rehash to make the rails executable available:"  # https://github.com/rbenv/rbenv
   sudo rbenv rehash

   h2 "gem install rdoc (Ruby doc)"
   sudo gem install rdoc

   h2 "gem install execjs"
   sudo gem install execjs

   h2 "gem install refinerycms"
   sudo gem install refinerycms
       # /usr/lib/ruby/include

   h2 "Build refinery app"
   refinerycms "${APPNAME}"
   # TODO: pushd here instead of cd?
      cd "${APPNAME}"   

   # TODO: Add RoR app resources from GitHub  (gem file)
   # TODO: Internationalize Refinery https://www.refinerycms.com/guides/translate-refinery
   # create branch for a language (nl=dutch):
          # git checkout -b i18n_nl
   # Issue rake task to get a list of missing translations for a given locale:
   # Add the keys
   # Run the Refinery tests to be sure you didn't break something, and that your YAML is valid.
      # bin/rake spec


   h2 "bundle install based on gem file ..."
   bundle install

   h2 "Starting rails server at ${APPNAME} ..."
   cd "${APPNAME}"
   note "Now at $PWD ..."
   rails server

   h2 "Opening website ..."
      curl -s -I -X POST http://localhost:3000/refinery
      curl -s       POST http://localhost:3000/ | head -n 10  # first 10 lines

   # TODO: Use Selenium to manually logon to the backend using the admin address and password…

   exit

fi # if [ "${RUBY_INSTALL}" = true ]; then  # -i


### 46. RUN_EGGPLANT
if [ "${RUN_EGGPLANT}" = true ]; then  # -eggplant

   # As seen at https://www.youtube.com/watch?v=B64_4r0vGkA May 28, 2020
   # See http://docs.eggplantsoftware.com/ePF/gettingstarted/epf-getting-started-eggplant-functional.htm
   if [ "${PACKAGE_MANAGER}" = "brew" ]; then # -U
      if [ ! -d "/Applications/Eggplant.app" ]; then  # directory not found:
         h2 "brew install --cask eggplant ..."
         brew install --cask eggplant
      else  # installed already:
         if [ "${UPDATE_PKGS}" = true ]; then
            h2 "Re-installing cask eggplant ..."
            brew cask uninstall eggplant
         fi
      fi
   fi  #  PACKAGE_MANAGER}" = "brew" 

   if [ "${OPEN_APP}" = true ]; then  # -o
      if [ "${OS_TYPE}" = "macOS" ]; then  # it's on a Mac:
         sleep 3
         open "/Applications/Eggplant.app"
         # TODO: Configure floating license server 10.190.70.30
      fi
   fi
   # Configure floating license on local & SUT on same network 10.190.70.30
   # Thank you to Ritdhwaj Singh Chandel

   if [ "${PACKAGE_MANAGER}" = "brew" ]; then # -U
      # Alternately, https://www.realvnc.com/en/connect/download/vnc/macos/
      if [ ! -d "/Applications/RealVNC/VNC Server.app" ]; then  # directory not found:
         h2 "brew install --cask vnc-server ..."
             brew install --cask vnc-server
             # Requires password
             # pop-up "vncagent" and "vncviwer" would like to control this computer using accessibility features
      else
         if [ "${UPDATE_PKGS}" = true ]; then
            h2 "brew cask upgrade vnc-server ..."
                brew cask upgrade vnc-server
         fi
      fi
   fi   # PACKAGE_MANAGER


   if [ "$OPEN_APP" = true ]; then  # -o
      if [ "$OS_TYPE" = "macOS" ]; then  # it's on a Mac:
         open "/Applications/RealVNC/VNC Server.app"
         # TODO: Automate configure app to input email, home subscription type, etc.
            # In Mac: ~/.vnc/config.d/vncserver
            # See https://help.realvnc.com/hc/en-us/articles/360002253878-Configuring-VNC-Connect-Using-Parameters
         # Uncheck System Preferences > Energy Saver, Prevent computer from sleeping automatically when the display is off
            # See https://help.realvnc.com/hc/en-us/articles/360003474692
         # Understanding VNC Server Modes: https://help.realvnc.com/hc/en-us/articles/360002253238
      fi
   fi

   # Reference: http://docs.eggplantsoftware.com/eggplant-documentation-home.htm
          # See http://docs.eggplantsoftware.com/ePF/using/epf-running-from-command-line.htm     

fi    # RUN_EGGPLANT


### 47. USE_DOCKER
if [ "${USE_DOCKER}" = true ]; then   # -k

   if [ "${DOWNLOAD_INSTALL}" = true ]; then  # -I & -U

      h2 "Install Docker and docker-compose:"

      if [ "${PACKAGE_MANAGER}" = "brew" ]; then

         if ! command -v docker ; then
            h2 "Installing docker ..."
            brew install docker
         else
            if [ "${UPDATE_PKGS}" = true ]; then
               h2 "Upgrading docker ..."
               brew upgrade docker
            fi
          fi

          if ! command -v docker-compose ; then
             h2 "Installing docker-compose ..."
             brew install docker-compose
          else
             if [ "${UPDATE_PKGS}" = true ]; then
                h2 "Upgrading docker-compose ..."
                brew upgrade docker-compose
             fi
          fi

          if ! command -v git ; then
             h2 "Installing Git ..."
             brew install git
          else
             if [ "${UPDATE_PKGS}" = true ]; then
                h2 "Upgrading Git ..."
                brew upgrade git
             fi
          fi

          if ! command -v curl ; then
             h2 "Installing Curl ..."
             brew install curl wget tree
          else
             if [ "${UPDATE_PKGS}" = true ]; then
                h2 "Upgrading Curl ..."
                brew upgrade curl wget tree
             fi
          fi

       elif [ "${PACKAGE_MANAGER}" = "apt-get" ]; then

         if ! command -v docker ; then
            h2 "Installing docker using apt-get ..."
            silent-apt-get-install "docker"
         else
            if [ "${UPDATE_PKGS}" = true ]; then
               h2 "Upgrading docker ..."
               silent-apt-get-install "docker"
            fi
         fi

         if ! command -v docker-compose ; then
            h2 "Installing docker-compose using apt-get ..."
            silent-apt-get-install "docker-compose"
         else
            if [ "${UPDATE_PKGS}" = true ]; then
               h2 "Upgrading docker-compose ..."
               silent-apt-get-install "docker-compose"
            fi
         fi

      elif [ "${PACKAGE_MANAGER}" = "yum" ]; then
      
         if ! command -v docker ; then
            h2 "Installing docker using yum ..."
            sudo yum install docker
         else
            if [ "${UPDATE_PKGS}" = true ]; then
               h2 "Upgrading docker ..."
               sudo yum install docker
            fi
         fi

         if ! command -v docker-compose ; then
            h2 "Installing docker-compose using yum ..."
            yum install docker-compose
         else
            if [ "${UPDATE_PKGS}" = true ]; then
               h2 "Upgrading docker-compose ..."
               yum install docker-compose
            fi
         fi

      fi # brew

   fi  # DOWNLOAD_INSTALL


   # Docker need not be running to obtain version:
   note "$( docker --version )"          # Docker version 19.03.5, build 633a0ea
   note "$( docker-compose --version )"  # docker-compose version 1.24.1, build 4667896b

   Stop_Docker(){   # function
         if [ "$OS_TYPE" = "macOS" ]; then  # it's on a Mac:
            note "-restarting Docker on macOS ..."
            osascript -e 'quit app "Docker"'
         else
            note "-restarting Docker on Linux ..."
            sudo systemctl stop docker
            sudo service docker stop
         fi
         sleep 3
   }
   Start_Docker(){   # function
      if [ "$OS_TYPE" = "macOS" ]; then  # it's on a Mac:
         note "Docker Desktop is starting on macOS ..."
         open "/Applications/Docker.app"  # 
         #open --background -a Docker   # 
         # /Applications/Docker.app/Contents/MacOS/Docker
      else
         note "Starting Docker daemon on Linux ..."
         sudo systemctl start docker
         sudo service docker start
      fi

      timer_start=$SECONDS
      # Docker Docker is starting ...
      while ( ! docker ps -q  2>/dev/null ); do
         sleep 5  # seconds
         duration=$(( SECONDS - timer_start ))
         # Docker takes a few seconds to initialize
         note "${duration} seconds waiting for Docker to begin running ..."
      done
 
   }  # Start_Docker
 
   Remove_Dangling_Docker(){   # function
      RESPONSE="$( docker images -qf dangling=true )"
      if [ -z "${RESPONSE}" ]; then
         RESPONSE=$( docker rmi -f "${RESPONSE}" )
      fi
      #   if [ -z `docker ps -q --no-trunc | grep $(docker-compose ps -q "$DOCKER_WEB_SVC_NAME")` ]; then
      # --no-trunc flag because docker ps shows short version of IDs by default.
      #.   note "If $DOCKER_WEB_SVC_NAME is not running, so run it..."
   }

   # https://medium.com/@valkyrie_be/quicktip-a-universal-way-to-check-if-docker-is-running-ffa6567f8426
   # ALTERNATIVE: curl -s --unix-socket /var/run/docker.sock http://ping
      # From https://gist.github.com/peterver/ca2d60abc015d334e1054302265b27d9
   IS_DOCKER_STARTED=true
   {
      docker ps -q  2>/dev/null  # -q = quiet
      # RESPONSE: Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
   } || {
      IS_DOCKER_STARTED=false
   }
   if [ "${IS_DOCKER_STARTED}" = false ]; then
      # Docker is not running. Starting Docker app ..."
      Start_Docker   # function defined in this file above.
   else   # Docker processes found running:
      if [ "${RESTART_DOCKER}" = true ]; then  # -r
         Stop_Docker   # function defined in this file above.
         Start_Docker   # function defined in this file above.
      else
         note "Docker already running ..."
      fi
   fi

   # Error response from daemon: dial unix docker.raw.sock: connect: connection refused

   if [ "${RUN_ACTUAL}" = true ]; then  # -a for actual usage

      Remove_Dangling_Docker   # function defined above.

      if [ "${BUILD_DOCKER_IMAGE}" = true ]; then   # -b
         h2 "Building docker images ..."
         docker build  #Dockerfile
      fi    # BUILD_DOCKER_IMAGE

      #h2 "node-prune to remove unnecessary files from the node_modules folder"
         # Test files, markdown files, typing files and *.map files in Npm packages are not required in prod.
         # See https://itsopensource.com/how-to-reduce-node-docker-image-size-by-ten-times/
      #npm prune --production

      if [ "${USE_DOCKER_COMPOSE}" = true ]; then  # -dc

         if [ ! -f "docker-compose.yml" ]; then
            error "docker-compose.yml file not found ..."
            pwd
            exit 9
         else
            # https://docs.docker.com/compose/reference/up/
            docker-compose up --detach --build
            # --build specifies rebuild of pip install image for changes in requirements.txt
            STATUS=$?
            if [ "${STATUS}" = "0" ]; then
               warning "Docker run ended with no issues."
            else
               if [ "${CONTINUE_ON_ERR}" = true ]; then  # -cont
                  warning "Docker run exit ${STATUS} error, being ignored."
               else
                  fatal "Docker run found issues : ${STATUS} "
                  # 217 = no license available.
                  exit 9
               fi
            fi
         # NOTE: detach with ^P^Q.
         # Creating network "snakeeyes_default" with the default driver
         # Creating volume "snakeeyes_redis" with default driver
         # Status: Downloaded newer image for node:12.14.0-buster-slim

         # runs scripts without launching "/Applications/Eggplant.app" functional GUI:
         # /Applications/Eggplant.app/Contents/MacOS/runscript  docker-test.script
         fi   # MY_FILE}" = "docker-compose.yml"
      fi  # USE_DOCKER_COMPOSE
   fi   # RUN_ACTUAL

   h2 "docker container ls ..."
   docker container ls
   # CONTAINER ID        IMAGE                COMMAND                  CREATED             STATUS                    PORTS                    NAMES
   # 3ee3e7ef6d75        snakeeyes_web        "/app/docker-entrypo…"   35 minutes ago      Up 35 minutes (healthy)   0.0.0.0:8000->8000/tcp   snakeeyes_web_1
   # fb64e7c95865        snakeeyes_worker     "/app/docker-entrypo…"   35 minutes ago      Up 35 minutes             8000/tcp                 snakeeyes_worker_1
   # bc68e7cb0f41        snakeeyes_webpack    "docker-entrypoint.s…"   About an hour ago   Up 35 minutes                                      snakeeyes_webpack_1
   # 52df7a11b666        redis:5.0.7-buster   "docker-entrypoint.s…"   About an hour ago   Up 35 minutes             6379/tcp                 snakeeyes_redis_1
   # 7b8aba1d860a        postgres             "docker-entrypoint.s…"   7 days ago          Up 7 days                 0.0.0.0:5432->5432/tcp   snoodle-postgres

   # TODO: Add run in local Kubernetes.

fi  # if [ "${USE_DOCKER}


### 48. RUN_ACTUAL within Docker
if [ "${RUN_ACTUAL}" = true ]; then   # -a

      if [ -z "${MY_FOLDER}" ]; then  # not defined:
         note "-Folder not specified. Working on root folder ..." 
      else
         if [ ! -d "${MY_FOLDER}" ]; then  # not exists:
            fatal "-Folder \"${MY_FOLDER}\" specified not found in $PWD ..."
            exit 9
         else
            note "cd into -Folder \"${MY_FOLDER}\" specified ..."
            cd "${MY_FOLDER}"
            note "Now at $PWD "
         fi
      fi
     
      if [ -z "${MY_FILE}" ]; then  # not filled:
         fatal "No -file specified ..."
         exit 9
      else ## filled:
         if [ ! -f "${MY_FILE}" ]; then  # not found
            fatal "-file specified not found in $PWD ..."
            exit 9

            #note "-file not specified. Using config.yml from repo ... "
            ## copy with -force to update:
            #cp -f ".circleci/config.yml" "$HOME/.circleci/config.yml"

         else
            note "-file ${MY_FILE} ... "
         fi
      fi

   # IMAGE                         PORTS                    NAMES
   # selenium/node-chrome-debug    0.0.0.0:9001->5900/tcp   eggplant-demo_chrome1_1
   # selenium/node-firefox-debug   0.0.0.0:9002->5900/tcp   eggplant-demo_chrome2_1
   # selenium/node-opera-debug     0.0.0.0:9003->5900/tcp   eggplant-demo_chrome3_1
   # selenium/hub                  0.0.0.0:4555->4444/tcp   eggplant-demo_hub_1
   if [ "${OPEN_CONSOLE}" = true ]; then  # -console
      docker exec -it eggplant-demo_chrome1_1 "/bin/bash"
      exit
   fi

   if [ "${RUN_EGGPLANT}" = true ]; then  # -O
      # Connect target browser to Eggplant license server: 
      if [ -z "${EGGPLANT_USERNAME}" ]; then
         echo "EGGPLANT_USERNAME=${EGGPLANT_USERNAME}"
      fi

      # ALT: EGGPLANT_SUT_IP=docker inspect -f "{{ .NetworkSettings.Networks.bridge.IPAddress }}" "${BROWSER_HOSTNAME}"
      EGGPLANT_SUT_IP=$( ipconfig getifaddr en0 )  # "192.168.1.10"
      EGGPLANT_SUT_PORT="9001"  # for chrome, 9002 for firefox, 9003 for opera 

      note "EGGPLANT_SUT_IP=${EGGPLANT_SUT_IP}, EGGPLANT_SUT_PORT=${EGGPLANT_SUT_PORT}"

#            "${MY_FOLDER}/${MY_FILE}" \
      if [ "${OS_TYPE}" = "macOS" ]; then  # it's on a Mac:
         "/Applications/Eggplant.app/Contents/MacOS/runscript" \
            "${MY_FILE}" \
            -LicenserHost "${EGGPLANT_HOST}" -host "${EGGPLANT_SUT_IP}" -port "${EGGPLANT_SUT_PORT}" \
            -password "secret" \
            -username "${EGGPLANT_USERNAME}" \
            -type VNC -DefaultHeight 1920 -DefaultWidth 1080 -CommandLineOutput yes
      elif [ "${OS_TYPE}" = "Windows" ]; then  # it's on a Mac:
         # TODO: Change Ritdhwaj to what's in the Docker image:
         #"C:\Program Files\eggPlant\eggPlant.bat"   "C:\Users\Alex\Documents\MyTests.suite\scripts\test3.script" \
         #-host 10.1.11.150 -port 5901 -password "secret"
         "Files\Eggplant\runscript.bat" \
            "C:\Users\Ritdhwaj Singh Chand\Desktop\cct_automation\eggplant_new_vi.suite\Scripts\test_runner.script" \
            -LicenserHost "${EGGPLANT_HOST}" -host "${BROWSER_HOSTNAME}" \
            -username "${EGGPLANT_USERNAME}" -port 9001 -password "${EGGPLANT_PASSWORD}" \
            -type RDP -DefaultHeight 1920 -DefaultWidth 1080 -CommandLineOutput yes
      fi
   fi 

   if [ -z "${APP1_PORT}" ]; then 
      if [ "${OS_TYPE}" = "macOS" ]; then  # it's on a Mac:
         sleep 3
         open "http://localhost:${APP1_PORT}"
      fi
#   else
#      curl -s -I -X POST http://localhost:8000/ 
#      curl -s       POST http://localhost:8000/ | head -n 10  # first 10 lines
   fi
fi  # RUN_ACTUAL



### 49. UPDATE_GITHUB
# Alternative: https://github.com/anshumanbh/git-all-secrets
if [ "${UPDATE_GITHUB}" = true ]; then  # -u
   if [ "${DOWNLOAD_INSTALL}" = true ]; then  # -I & -U
      if [ "${PACKAGE_MANAGER}" = "brew" ]; then
         if ! brew ls --versions git-secrets >/dev/null; then  # command not found, so:
            h2 "Brew installing git-secrets ..."
            brew install git-secrets
               #  /usr/local/Cellar/git-secrets/1.3.0: 8 files, 65.7KB
         else  # installed already:
            if [ "${UPDATE_PKGS}" = true ]; then
               note "Existing: $( brew ls --versions git-secrets )"  # 1.3.0
               h2 "Brew upgrading git-secrets ..."
               brew upgrade git-secrets
            fi
         fi
         note "$( brew ls --versions git-secrets )"
      fi
   fi

   h2 "Install Git hooks to current repo ..."
   if [ ! -d ".git" ]; then 
      error ".git folder not found. This is not a Git repo ..."
   else
      if [ -f ".git/hooks/commit-msg" ]; then
         note ".git/hooks/commit-msg already installed ..."
      else
         # See https://github.com/awslabs/git-secrets has 7,800 stars.
         note "git secrets --install"
         git secrets --install
            # ✓ Installed commit-msg hook to .git/hooks/commit-msg
            # ✓ Installed pre-commit hook to .git/hooks/pre-commit
            # ✓ Installed prepare-commit-msg hook to .git/hooks/prepare-commit-msg         
      fi
      
      if [ "${USE_AWS_CLOUD}" = true ]; then   # -w
         note "git secrets --register-aws"
         git secrets --register-aws
      fi

      note "git secrets --scan  # all files"
      git secrets --scan

      note "git secrets --scan-history"
      git secrets --scan-history
   fi
fi   # UPDATE_GITHUB


### 50. REMOVE_GITHUB_AFTER folder after run
if [ "$REMOVE_GITHUB_AFTER" = true ]; then  # -C
   h2 "Delete cloned GitHub at end ..."
   Delete_GitHub_clone    # defined above in this file.

   if [ "${RUN_PYTHON}" = true ]; then
      h2 "Remove files in ~/temp folder ..."
      rm bandit.console.log
      rm bandit.err.log
      rm pylint.console.log
      rm pylint.err.log
   fi
fi


### 51. KEEP_PROCESSES after run
if [ "${KEEP_PROCESSES}" = false ]; then  # -K

   if [ "${NODE_INSTALL}" = true ]; then  # -n
      if [ -n "${MONGO_PSID}" ]; then  # not found
         h2 "Kill_process ${MONGO_PSID} ..."
         Kill_process "${MONGO_PSID}"  # invoking function above.
      fi
   fi 
fi

if [ "${USE_DOCKER}" = true ]; then   # -k

   if [ "${KEEP_PROCESSES}" = true ]; then  # -K
      RESPONSE="$( docker images -qf dangling=true )"
      if [ -z "${RESPONSE}" ]; then
         docker rmi -f "${RESPONSE}"
      fi      

      Stop_Docker   # function defined in this file above.
   fi


   ### 52. Delete Docker containers in memory after run ...
   if [ "$DELETE_CONTAINER_AFTER" = true ]; then  # -D

      # TODO: if docker-compose.yml available:
      if [ "${RUN_EGGPLANT}" = true ]; then  # -O
         h2 "docker-compose down containers ..."
         docker-compose -f "docker-compose.yml" down
      else
         # https://www.thegeekdiary.com/how-to-list-start-stop-delete-docker-containers/
         h2 "Deleting docker-compose active containers ..."
         CONTAINERS_RUNNING="$( docker ps -a -q )"
         note "Active containers: $CONTAINERS_RUNNING"

         note "Stopping containers:"
         docker stop "$( docker ps -a -q )"

         note "Removing containers:"
         docker rm -v "$( docker ps -a -q )"
      fi # if [ "${RUN_EGGPLANT}" = true ]; then  # -O
   fi


   ### 53. REMOVE_DOCKER_IMAGES downloaded
   if [ "${REMOVE_DOCKER_IMAGES}" = true ]; then  # -M

      note "docker system df ..."
            docker system df
     
      DOCKER_IMAGES="$( docker images -a -q )"
      if [ -n "${DOCKER_IMAGES}" ]; then  # variable is NOT empty
         h2 "Removing all Docker images ..."
         docker rmi "$( docker images -a -q )"

         h2 "docker image prune -all ..."  # https://docs.docker.com/config/pruning/
         y | docker image prune -a
            # all stopped containers
            # all volumes not used by at least one container
            # all networks not used by at least one container
            # all images without at least one container associated to
            # y | docker system prune
      fi
   fi

   if [ "${RUN_VERBOSE}" = true ]; then
      h2 "docker images -a ..."
      note "$( docker images -a )"
   fi
fi    # USE_DOCKER

# EOF
