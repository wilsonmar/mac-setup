#!/usr/bin/env zsh
# This is mac-setup.zsh from template https://github.com/wilsonmar/mac-setup/blob/main/mac-setup.zsh
# Coding of this shell script is explained in https://wilsonmar.github.io/mac-setup
# Shell scripting techniques are explained in https://wilsonmar.github.io/shell-scripts
# Like https://medium.com/@maxy_ermayank/developer-environment-setup-script-5fcb7b854acc

# shellcheck does not work on zsh, but 
# shellcheck disable=SC2001 # See if you can use ${variable//search/replace} instead.
# shellcheck disable=SC1090 # Can't follow non-constant source. Use a directive to specify location.
# shellcheck disable=SC2129  # Consider using { cmd1; cmd2; } >> file instead of individual redirects.

# After you obtain a Terminal (console) in your environment,
# cd to folder, copy this line (without the # comment character) and paste in the terminal so
# it installs utilities:
# zsh -c "$(curl -fsSL https://raw.githubusercontent.com/wilsonmar/mac-setup/main/mac-setup.zsh)" -v

# This downloads and installs all the utilities, then invokes programs to prove they work
# This was run on macOS Mojave and Ubuntu 16.04.

### 01. Capture time stamps to later calculate how long the script runs, no matter how it ends:
# See https://wilsonmar.github.io/mac-setup/#StartingTimes
THIS_PROGRAM="${0##*/}" # excludes the ./ in "$0" 
SCRIPT_VERSION="v1.130" # add -tenant selection : mac-setup.zsh"
# Install chrome extensions
# working github -aiac : mac-setup.zsh"
# Restruc github vars : mac-setup.zsh"
# TODO: Remove circleci from this script.
# TODO: Add test for duplicate run using flock https://www.baeldung.com/linux/bash-ensure-instance-running
# TODO: Add encryption of log output.

LOG_DATETIME=$( date +%Y-%m-%dT%H:%M:%S%z)-$((1 + RANDOM % 1000))  # 2023-09-21T05:07:45-0600-264
# clear  # screen (but not history)
echo "================ ${THIS_PROGRAM} ${SCRIPT_VERSION} ${LOG_DATETIME}"
EPOCH_START="$( date -u +%s )"  # such as 1572634619


### 02. Display a menu if no parameter is specified in the command line
# See https://wilsonmar.github.io/mac-setup/#Args
# See https://wilsonmar.github.io/mac-setup/#EchoFunctions
args_prompt() {
   echo "OPTIONS:"
   echo "   -cont         continue (NOT stop) on error"
   echo "   -v            run -verbose (list space use and images)"
   echo "   -vv           run -very verbose diagnostics (brew upgrade, update, doctor)"
   echo "   -x            set -x to trace command lines"
#  echo "   -x            set sudoers -e to stop on error"
   echo "   -q           -quiet heading h2 for each step"
   echo "   -trace       Trace using OpenTelemtry (Jaeger)"
   echo " "
   echo "   -envf \"/alt-folder\"   (alternate path to store/read env files)"
   echo "   -envc         Copy env files from env folders or GitHub.com"
   echo " "
   echo "   -I           -Install brew utilities, apps"
   echo "   -U           -Upgrade installed packages if already installed"
   echo "   -VSC \"vscode-ext\"  - VSCode extensions to install from/to file"
   echo "   -zsh         Convert from bash to Zsh"
   echo " "
   echo "   -N  \"Proj\"            Alternative name of Projects folder"
   echo "   -fn \"John Doe\"            user full name"
   echo "   -n  \"weirdo\"           -github.com account name"
   echo "   -e  \"john_doe@gmail.com\"  GitHub user -email"
   echo " "
   echo "   -a           -actually run server (not dry run)"
   echo "   -sd          -sd card initialize locally"
   echo " "
   echo "   -aws         -AWS cloud"
   echo "   -eks         -eks (Elastic Kubernetes Service) in AWS cloud"
   echo "   -azure       -Azure cloud"
   echo "   -quantum      Quantum computing within each cloud"
   echo "   -gcp         -Google cloud"
   echo "   -g \"abcdef...89\" -gcloud API credentials for calls"
   echo "   -p \"cp100\"   -project in gcloud"
   echo " "
#  echo "   -Consul       Install Hashicorp Consul in Docker"
#  echo "   -Doormat      install/use Hashicorp's doormat-cli & hcloud"
#  echo "   -Envoy        install/use Hashicorp's Envoy client"
   echo "   -HV           install/use -Hashicorp Vault secret manager"
   echo "   -m            Setup Vault SSH CA cert"
   echo "   -steampipe    Steampipe.io database"
   echo " "
   echo "   -d           -delete GitHub and pyenv from previous run"
   echo "   -c           -clone from GitHub"
   echo "   -gru \"acct/repo\"   GITHUB_REPO_URL to download from GitHub"
   echo "   -d1          --depth 1 during GitHub clone for main branch only"
   echo "   -ssh         use SSH to construct GITHUB_REPO_URL to download"
   echo "   -pfn         PROJECT_FOLDER_NAME folder to clone locally"
   echo "   -gfn         GITHUB_FOLDER_NAME folder to clone locally"
   echo "   -ghb \"v0.5\"     git checkout branch or tag"
   echo "   -F \"abc\"     -Folder inside repo"
   echo "   -f \"a9y.py\"  -file (program) to run"
   echo "   -P \"-v -x\"   -Parameters controlling program called"
   echo "   -u           -update GitHub (scan for secrets)"
   echo " "
   echo "   -docsify      install docsify locally"
#  echo "   -chezmoi      ???"
  #echo "   -circleci    Use CircleCI SaaS"
   echo " "
   echo "   -podman       install and use Podman (instead of Docker)"
   echo "   -k            install and use Docker"
   echo "   -b           -build Docker image"
   echo "   -dps \"dev1\"   override default name of a docker process"
   echo "   -dc           use docker-compose.yml file"
   echo "   -w           -write image to DockerHub"
   echo "   -k8s         -k8s (Kubernetes) minikube & OpenShift CLI"
   echo "   -r           -restart (Docker) before run"
   echo " "
   echo "   -golang       install Golang language"
   echo "   -ruby         install Ruby and Refinery"
   echo "   -js           install JavaScript (NodeJs) app (no MongoDB/PostgreSQL)"
   echo "   -java         install Java and __"
   echo " "
   echo "   -conda        install Miniconda to run Python (instead of VirtualEnv)"
   echo "   -venv         install Python to run in conda venv (pipenv is default)"
   echo "   -pyenv        install Python to run with Pyenv"
   echo "   -python       install Python interpreter stand-alone (no pyenv or conda)"
   echo "   -y            install Python Flask"
   echo "   -A            run with Python -Anaconda "
   echo "   -tsf         -tensorflow"
   echo " "
   echo "   -aiac \"ec2\"  - AI to create Terraform Infra as Code"
   echo "   -pike         determine min permissions on tf/IaC"
   echo "   -hp           Run HashiCorp Packer"
   echo "   -tf           Run terraform"
   echo "   -ts           setup -testserver to run tests"
   echo "   -o           -open/view app or web page in default browser"
   echo "   -of \"\"     output file (generate date/time if blank)"
   echo " "
   echo "   -C           remove -Cloned files after run (to save disk space)"
   echo "   -K           -Keep OS processes running at end of run (instead of killing them automatically)"
   echo "   -D           -Delete containers and other files after run (to save disk space)"
   echo "   -M           remove Docker iMages pulled from DockerHub (to save disk space)"
   echo "   -usage       usage commands"
   echo "# USAGE EXAMPLES:"
   echo "chmod +x mac-setup.zsh   # change permissions"
   echo "./mac-setup.zsh          # display this menu"
   echo "./mac-setup.zsh -usage   # display usage examples"
}  # args_prompt()

usage_examples() {
   echo "# USAGE EXAMPLES:"
   echo "chmod +x mac-setup.zsh   # change permissions"
   echo "# Using default configuration settings downloaed to \$HOME/mac-setup.env "
   echo "./mac-setup.zsh -v -I -U -golang  # Install brew, plus golang"
   echo "./mac-setup.zsh -v -Consul -k -a -K   # Use HashicorpVault in Docker for localhost Kept alive"
   echo "./mac-setup.zsh -v -Consul -podman -a -K   # Use HashicorpVault in Podman for localhost Kept alive"
   echo "./mac-setup.zsh -v -k -HV -a -K   # Use HashicorpVault in Docker for localhost Kept alive"
   echo "./mac-setup.zsh -v -HV -m -ts     # Use HashicorpVault -testserver"
   echo "./mac-setup.zsh -v -HV -s -ts     # Initiate Vault testserver"
   echo " "
   echo "./mac-setup.zsh -v -aws  # for Terraform"
   echo "./mac-setup.zsh -v -eks -D "
   echo "./mac-setup.zsh -v -g \"abcdef...89\" -p \"cp100-1094\"  # Google API call"
   echo " "
   echo "./mac-setup.zsh -v -I -U -c    -HV -G -N \"python-samples\" -f \"a9y-sample.py\" -P \"-v\" -t -AWS -C  # Python sample app using Vault"
   echo "./mac-setup.zsh -v -venv -c -T -F \"section_2\" -f \"2-1.ipynb\" -K  # Jupyter Conda Tensorflow in Venv"
   echo "./mac-setup.zsh -v -D -M -C"
   echo "./mac-setup.zsh -G -v -f \"challenge.py\" -P \"-v\"  # to run a program in my python-samples repo"
   echo "./mac-setup.zsh -v -I -U -c -s -y -r -a -aws   # Python Flask web app in Docker"
   echo " "
   echo "./mac-setup.zsh -v -n -a     # NodeJs app with MongoDB"
   echo "./mac-setup.zsh -v -ruby -o  # Ruby app"   
   echo "./mac-setup.zsh -v -venv -c -circleci -s    # Use CircLeci based on secrets"
   echo "./mac-setup.zsh -v -s -eggplant -k -a -console -dc -K -D  # eggplant use docker-compose of selenium-hub images"
   echo "./mac-setup.zsh -docsify -d -c -v "
   echo "./mac-setup.zsh -pike -c -gru \"alfonsof/terraform-azure-examples\" -d1 -gfn \"alonzo\" -F \"code/01-hello-world\" -o -v "
   echo "./mac-setup.zsh -tf -F \"tf-module1\" -d1 -c -v -I -U"
   echo "./mac-setup.zsh -steampipe -v -I -aws -c -d1 -gfn \"steampipe\" -of "
} # usage_examples()

# TODO: https://github.com/hashicorp/docker-consul/ to create a prod image from Dockerfile (for security)

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
# See https://wilsonmar.github.io/mac-setup/#TextColors
# \e ANSI color variables are defined in https://wilsonmar.github.io/bash-scripts#TextColors
h2() { if [ "${RUN_QUIET}" = false ]; then    # heading
   printf "\n\e[1m\e[33m\u2665 %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
   fi
}
info() {   # output on every run
   printf "\e[2m\n➜ %s\e[0m\n" "$(echo "$@" | sed '/./,$!d')"
}
note() { if [ "${SHOW_VERBOSE}" = true ]; then
   printf "\n\e[1m\e[36m \e[0m \e[36m%s\e[0m" "$(echo "$@" | sed '/./,$!d')"
   printf "\n"
   fi
}
echo_debug() { if [ "${SHOW_DEBUG}" = true ]; then
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

if [ "${SHOW_DEBUG}" = true ]; then  # -vv
   h2 "Header here"
   info "info"
   note "note"
   success "success!"
   error "error"
   warning "warning (warnNotice)"
   fatal "fatal (warnError)"
fi


### 04. Define variables for use as "feature flags"
# See https://wilsonmar.github.io/mac-setup/#FeatureFlags
# Normal:
   CONTINUE_ON_ERR=false         # -cont

   RUN_ACTUAL=false              # -a  (dry run is default)
   RUN_PARMS=""                  # -P
   SHOW_VERBOSE=false            # -v
   SHOW_DEBUG=false              # -vv
   VERIFY_ENV=false              # -V
   RUN_QUIET=false               # -q

   COPY_ENV_FILES=false           # -envc (false by default)   # to use default ENV_FOLDERPATH_BASE:
   ENV_FOLDERPATH=""              # -envf "/alt-folder" (away from GitHub)
   ENV_FOLDERPATH_DEFAULT="$HOME" # defined in ~/mac-setup.env

   VSCODE_FILE=""                 # -VSC "file"  Install/Upgrade VSCode extensions from/to file"
  
   CONVERT_TO_ZSH=false           # -zsh
   SET_TRACE=false                # -x
   RUN_TRACE=false                # -trace

   OPEN_CONSOLE=false             # -console
   USE_TEST_SERVER=false          # -ts
   USE_PROD_ENV=false             # -prod

# From secrets file mac-setup.env
SECRETS_FILE=".secrets.env.sample"
   #   AWS_ACCESS_KEY_ID=""
   #   AWS_SECRET_ACCESS_KEY=""
   #   AWS_USER_ARN=""
   #   AWS_MFA_ARN=""
      AWS_DEFAULT_REGION="us-east-2"
      EKS_CLUSTER_NAME="sample-k8s"
      EKS_KEY_FILE_PREFIX="eksctl-1"
      EKS_NODES="2"
      EKS_NODE_TYPE="m5.large"
   RUN_QUANTUM=false        # -quantum
   
# To be overridden by values defined within mac-setup.env:
   PROJECT_FOLDER_BASE="$HOME/Projects"       # -P
   PROJECT_FOLDER_NAME=""                     # -pfn
   PROJECT_NAME=""                            # -p

   GITHUB_REPO_NAME=""                        # -grn
#   GITHUB_REPO_PATH="$HOME/github-wilsonmar"  
#   GITHUB_REPO="wilsonmar.github.io"f
#   GITHUB_ACCOUNT_NAME="weirdo"              # -gan
#   GITHUB_USER_NAME="Wilson Mar"             # -n
#   GITHUB_USER_EMAIL="wilson_mar@gmail.com"  # -e
   #GITHUB_USER_EMAIL="WilsonMar+GitHub@gmail.com"

   USE_GITHUB_SSH=false         # -ssh
   GITHUB_REPO_URL=""           # -gru in https://github.com/wilsonmar/xxx.git

   CLONE_GITHUB=false           # -c
   DELETE_BEFORE=false          # -d
   GITHUB_DEPTH_1=false         # -d1
   GITHUB_FOLDER_BASE="$HOME/github-wilsonmar" # -gfb
  #GITHUB_FOLDER_NAME=""        # -gfn
   GITHUB_BRANCH=""             # -ghb

# Different for each app:
   MY_FOLDER=""                 # -F folder
   MY_FILE=""
     #MY_FILE="2-3.ipynb"
   APP1_HOST="127.0.0.1"   # default
   APP1_PORT="8200"        # default
   APP1_FOLDER=""          # custom specified
   OPEN_APP=false               # -o

   USE_STEAMPIPE=false          # -steampipe

   USE_ENVOY=false              # -Envoy
   USE_DOORMAT=false            # -Doormat
   RUN_CONSUL=false             # -Consul
   RUN_NOMAD=false              # -Nomad
   USE_VAULT=false              # -HV
       VAULT_HOST="localhost"  # default value
      #VAULT_ADDR="https://${VAULT_HOST}:8200"  # assembled in code below.
       VAULT_USER_TOKEN=""
       VAULT_USERNAME=""
       VAULT_RSA_FILENAME=""
       VAULT_CA_KEY_FULLPATH="$HOME/.ssh/ca_key"
       VAULT_PUT=false          # -hvput  # by app program
       VAULT_VERSION=""  # captured later by vault --version

# Cloud:
   RUN_VIRTUALENV=false         # -venv
   RUN_CONDA=false              # -conda
   RUN_PYTHON=false             # -python
   RUN_GOLANG=false             # -golang
   RUN_JAVA=false               # -java
   RUN_EGGPLANT=false           # -eggplant
   RUN_TENSORFLOW=false         # -tsf
   USE_AIAC=false               # -aiac  prompt
       AIAC_PROMPT=""
   RUN_TERRAFORM=false          # -tf
   RUN_PACKER=false             # -hp
   RUN_WEBGOAT=false            # -W

   SET_MACOS_SYSPREFS=false     # -macos

   UPDATE_GITHUB=false          # -u
   UPDATE_PKGS=false            # -U

   USE_DOCKER=false             # -k
   USE_PODMAN=false             # -podman

   USE_CIRCLECI=false           # -circleci
   USE_AWS_CLOUD=false          # -aws
   # From AWS Management Console https://console.aws.amazon.com/iam/
   #   AWS_OUTPUT_FORMAT="json"  # asked by aws configure CLI.
   # EKS_CLUSTER_FILE=""   # cluster.yaml instead
   USE_YUBIKEY=false            # -Y
   USE_PIKE=false               # -pike
   USE_DOCSIFY=false            # -docsify
   USE_CHEZMOI=false            # -chezmoi
   USE_K8S=false                # -k8s
   RUN_EKS=false                # -eks
       EKS_CRED_IS_LOCAL=true

   USE_AZURE_CLOUD=false        # -azure
   USE_GOOGLE_CLOUD=false       # -g
       GOOGLE_API_KEY=""  # manually copied from APIs & services > Credentials

   MOVE_SECURELY=false          # -m
      LOCAL_SSH_KEYFILE=""
      GITHUB_ORG=""

   RUBY_INSTALL=false           # -ruby
   NODE_INSTALL=false           # -js
   
   MONGO_DB_NAME=""

# Install?
   DOWNLOAD_INSTALL=false       # -I
   IMAGE_SD_CARD=false          # -sd

# Pre-processing:
   USE_QEMU=false               # -qemu
   RESTART_DOCKER=false         # -r
   DOCKER_IMAGE_FILE=""  # custom specified
   DOCKER_PS_NAME="dev1"        # -dps
   BUILD_DOCKER_IMAGE=false     # -b
   WRITE_TO_DOCKERHUB=false     # -w
   USE_DOCKER_COMPOSE=false     # -dc
   USE_PYENV=false              # -pyenv

   OUTPUT_FILENAME=""           # -of

# Post-processing:
   DELETE_CONTAINER_AFTER=false # -D
   REMOVE_DOCKER_IMAGES=false   # -M
   REMOVE_GITHUB_AFTER=false    # -R
   KEEP_PROCESSES=false         # -K


### 05. Overwrite vars with config settings file 

# See https://wilsonmar.github.io/mac-setup/#LoadConfigFile
# See https://wilsonmar.github.io/mac-setup/#SaveConfigFile
download_mac-setup_home(){
   # filename = $1
   # ENV_FOLDERPATH Should be found:
   if [ -f "$ENV_FOLDERPATH/$1" ]; then  # target file exists:
      if [ "${COPY_ENV_FILES}" = false ]; then  # -envc OVERWRITE!
         note "-envc not specified. File $HOME/$1 exists. Not downloaded..."
         return
      else
         warning "-envc specifies overwrite of file $HOME/$1 - first make bak..."
         cp -f "$HOME/$1" "$HOME/$1.bak"
      fi
   fi  # either way:

   if [ -f "$1" ]; then  # origin file exists:
      note "-envc cannot file $1 for copy to \"$ENV_FOLDERPATH\" ..."
      note "-envc copy from github.com repo..."
      if ! command -v curl ; then
         fatal "-envc from github failed. Please -I (install) curl first ..."
         exit 9
      else
         # pwd
         note "-envc file $1 downloading from GitHub ..."
         curl --create-dirs -O --output-dir $HOME \
            "https://raw.githubusercontent.com/wilsonmar/mac-setup/main/$1" 
         chmod +x "$HOME/$1"
         # ls -ltaT "$HOME/$1"
      fi
   fi
}

# See https://wilsonmar.github.io/mac-setup/#Load_Env_files
Define_Env_folder(){
   
   if [ -z "$ENV_FOLDERPATH" ]; then  # var needed not specified
      note "-envf \"$ENV_FOLDERPATH\" not specified in parms..."
      # Set to default if -envf not specified in parms:
      if [ -z "$ENV_FOLDERPATH_DEFAULT" ]; then  # not defined
         fatal "-envf default variable \"$ENV_FOLDERPATH_DEFAULT\" not defined..."
         exit 9
      else  # default specified:
         if [ ! -d "${ENV_FOLDERPATH_DEFAULT}" ]; then   # DEFAULT file defined NOT found:
            warning "-env default ${ENV_FOLDERPATH_DEFAULT} not found. Creating..."
            mkdir -p "${ENV_FOLDERPATH_DEFAULT}"
            # Do not cd to it.
         else
            note "-envf default \"$ENV_FOLDERPATH_DEFAULT\" found..."
            export ENV_FOLDERPATH="${ENV_FOLDERPATH_DEFAULT}"
         fi
      fi
   fi  # -envf specified in parms:

   if [ ! -d "${ENV_FOLDERPATH}" ]; then   # not found:
      warning "-envf folder \"$ENV_FOLDERPATH\" not found. Creating..."
      mkdir -p "${ENV_FOLDERPATH_DEFAULT}"
   else
      export ENV_FOLDERPATH="${ENV_FOLDERPATH_DEFAULT}"
      echo "-env from folder \"$ENV_FOLDERPATH\" default \"$ENV_FOLDERPATH_DEFAULT\" ..."
   fi

   if [ ! -d "${ENV_FOLDERPATH}" ]; then   # file specified found (so bak it up):
      echo "DEBUG inside  Load_Env_files $ENV_FOLDERPATH";exit
      warning "-envf ${ENV_FOLDERPATH} not found. Creating..."
      mkdir -p "${ENV_FOLDERPATH}"
      # Do not cd to it.
   fi
}
Define_Env_folder


Load_Env_files(){

   if [ "${COPY_ENV_FILES}" = false ]; then  # -envc for OVERWRITE!
      echo "-envc not specified. Not copying files from ${ENV_FOLDERPATH} ..."
   else  # -envc specified:
      if command -v curl ; then
         h2 "-envc specified. Copying files from ${ENV_FOLDERPATH} ..."
         # pwd
         download_mac-setup_home  "aliases.zsh"
         download_mac-setup_home  ".zshrc"
         download_mac-setup_home  "mac-setup.env"
      else
         fatal "-envc from github failed. Please -I (install) curl first ..."
         exit 9
      fi
   fi

   echo "-envc loading "${ENV_FOLDERPATH}/mac-setup.env" ..."
   # See https://pipenv-fork.readthedocs.io/en/latest/advanced.html#automatic-loading-of-env
   source "${ENV_FOLDERPATH}/mac-setup.env"  # run file containing variable definitions.

}
Load_Env_files


Read_Inputs_Manually(){

   # https://www.zshellcheck.net/wiki/SC2162: read without -r will mangle backslashes.
   read -r -p "Enter your GitHub user name [John Doe]: " GITHUB_USER_NAME
   GITHUB_USER_NAME=${GITHUB_USER_NAME:-"John Doe"}
   GITHUB_ACCOUNT_NAME=${GITHUB_ACCOUNT_NAME:-"john-doe"}

   read -r -p "Enter your GitHub user email [john_doe@gmail.com]: " GITHUB_USER_EMAIL
   GITHUB_USER_EMAIL=${GITHUB_USER_EMAIL:-"johb_doe@gmail.com"}

   if [ -z "${GITHUB_USER_EMAIL}" ]; then   # variable is blank
      Input_GitHub_User_Info  # function defined above.
   else
      note "-u \"${GITHUB_USER_NAME}\" -e \"${GITHUB_USER_EMAIL}\" ..."
      # since this is hard coded as "John Doe" above
   fi

   # TODO: Capture password manual input once for multiple shares 
   # (without saving password like expect command) 
   # See https://www.linuxcloudvps.com/blog/how-to-automate-shell-scripts-with-expect-command/
      # From https://askubuntu.com/a/711591
   #   read -p "Password: " -s szPassword
   #   printf "%s\n" "$szPassword" | sudo --stdin mount \
   #      -t cifs //192.168.1.1/home /media/$USER/home \
   #      -o username=$USER,password="$szPassword"
}
# Read_Inputs_Manually


### 06. Set variables dynamically based on each parameter flag
# See https://wilsonmar.github.io/mac-setup/#VariablesSet
while test $# -gt 0; do
  case "$1" in
    -a)
      export RUN_ACTUAL=true
      shift
      ;;
    -aiac)
      export USE_AIAC=true
      shift
             AIAC_PROMPT=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      export AIAC_PROMPT
      shift
      ;;
    -aws)
      export USE_AWS_CLOUD=true
      shift
      ;;
    -azure)
      export USE_AZURE_CLOUD=true
      shift
      ;;
    -b)
      export BUILD_DOCKER_IMAGE=true
      shift
      ;;
    -circleci)
      export USE_CIRCLECI=true
      export PROJECT_FOLDER_NAME="circleci_demo"
      export GITHUB_REPO_URL="https://github.com/fedekau/terraform-with-circleci-example"
      #GITHUB_REPO_URL="https://github.com/wilsonmar/circleci_demo.git"
      shift
      ;;
    -conda)
      export RUN_CONDA=true
      shift
      ;;
    -console)
      export OPEN_CONSOLE=true
      shift
      ;;
    -Consul)
      RUN_CONSUL=true
      DOCKER_IMAGE_FILE="consul"
         # https://hub.docker.com/_/consul
         # https://github.com/hashicorp/docker-consul
      # When -tf set:
      GITHUB_REPO_URL="git@github.com:hashicorp/learn-consul-terraform.git"
      MY_FOLDER="datacenter-deploy-ecs-hcp"
      GITHUB_BRANCH="v0.5"             # -ghb
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
    -d1)
      export GITHUB_DEPTH_1=true
      shift
      ;;
    -dc)
      export USE_DOCKER_COMPOSE=true
      shift
      ;;
    -docsify)
      export USE_DOCSIFY=true
      PROJECT_FOLDER_NAME="docsify"
      GITHUB_REPO_URL="https://github.com/liatrio/devops-bootcamp.git"
      shift
      ;;
    -Doormat)
      export USE_DOORMAT=true
      shift
      ;;
    -dps*)
      shift
             DOCKER_PS_NAME=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      export DOCKER_PS_NAME
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
    -envoy)
      export USE_ENVOY=true
      shift
      ;;
    -eggplant)
      RUN_EGGPLANT=true
      PROJECT_FOLDER_NAME="eggplant-demo"
      GITHUB_REPO_URL="https://github.com/wilsonmar/Eggplant.git"
      MY_FOLDER="docker-test.suite/Scripts"
      MY_FILE="openurl.script"
      EGGPLANT_HOST="10.190.70.30"
      APP1_PORT="80"
      shift
      ;;
    -envc)
      export COPY_ENV_FILES=true
      shift
      ;;
    -envf*)
      shift
             ENV_FOLDERPATH=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      export ENV_FOLDERPATH
      shift
      ;;
    -e*)
      shift
      GITHUB_USER_EMAIL=$( echo "$1" | sed -e 's/^[^=]*=//g' )
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
    -golang)
      export RUN_GOLANG=true
      shift
      ;;
    -gan*)
      shift
             GITHUB_ACCOUNT_NAME=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      export GITHUB_ACCOUNT_NAME
      shift
      ;;
    -ga*)
      shift
      export GITHUB_USER_ACCOUNT=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      shift
      ;;
    -gfb*)
      shift
             GITHUB_FOLDER_BASE=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      export GITHUB_FOLDER_BASE
      shift
      ;;
    -gfn*)
      shift
             GITHUB_FOLDER_NAME=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      export GITHUB_FOLDER_NAME
      shift
      ;;
    -ghb*)
      shift
      export GITHUB_BRANCH=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      shift
      ;;
    -grn*)
      shift
      export GITHUB_REPO_NAME=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      shift
      ;;
    -gru*)
      shift
      export GITHUB_REPO_URL=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      shift
      ;;
    -g*)
      shift
      export USE_GOOGLE_CLOUD=true
             GOOGLE_API_KEY=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      export GOOGLE_API_KEY
      shift
      ;;
    -hp)
      export RUN_PACKER=true
      shift
      ;;
    -HV)
      export USE_VAULT=true
      DOCKER_IMAGE_FILE="vault"
      # https://hub.docker.com/_/vault
      shift
      ;;
    -hvput)
      export VAULT_PUT=true
      shift
      ;;
    -ruby)
      export RUBY_INSTALL=true
      export GITHUB_REPO_URL="https://github.com/nickjj/build-a-saas-app-with-flask.git"
      export PROJECT_FOLDER_NAME="bsawf"
      #DOCKER_DB_NANE="snakeeyes-postgres"
      #DOCKER_WEB_SVC_NAME="snakeeyes_worker_1"  # from docker-compose ps  
      APPNAME="snakeeyes"
      shift
      ;;
    -I)
      export DOWNLOAD_INSTALL=true
      shift
      ;;
    -java)
      export RUN_JAVA=true
      shift
      ;;
    -js)
      export NODE_INSTALL=true
      export GITHUB_REPO_URL="https://github.com/wesbos/Learn-Node.git"
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
    -n*)
      shift
      # shellcheck disable=SC2034 # ... appears unused. Verify use (or export if used externally).
             GITHUB_USER_NAME=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      export GITHUB_USER_NAME
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
    -of*)
      shift
      export OUTPUT_FILENAME=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      shift
      ;;
    -pfn*)
      shift
      export PROJECT_FOLDER_NAME=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      shift
      ;;
    -pike)
      export USE_PIKE=true
      shift
      ;;
    -podman)
      export USE_PODMAN=true
      shift
      ;;
    -prod)
      export USE_PROD_ENV=true
      shift
      ;;
    -pyenv)
      export USE_PYENV=true
      shift
      ;;
    -python)
      export RUN_PYTHON=true
      GITHUB_REPO_URL="https://github.com/wilsonmar/python-samples.git"
      PROJECT_FOLDER_NAME="python-samples"
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
    -qemu)
      export USE_QEMU=true
      # https://medium.com/@AbhijeetKasurde/running-podman-machine-on-macos-1f3fb0dbf73d
      # https://wiki.qemu.org/Hosts/Mac
      shift
      ;;
    -q)
      export RUN_QUANTUM=true
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
    -scikit)
      export RUN_VIRTUALENV=true
      GITHUB_REPO_URL="https://github.com/PacktPublishing/Hands-On-Machine-Learning-with-Scikit-Learn-and-TensorFlow-2.0.git"
      export PROJECT_FOLDER_NAME="scikit"
      export APPNAME="scikit"
      #MY_FOLDER="section_2" # or ="section_3"
      shift
      ;;
    -sd)
      export IMAGE_SD_CARD=true
      shift
      ;;
    -ssh)
      export USE_GITHUB_SSH=true
      shift
      ;;
    -steampipe)
      export USE_STEAMPIPE=true
      shift
      ;;
    -tf)
      export RUN_TERRAFORM=true
      GITHUB_REPO_URL="https://github.com/wilsonmar/tf-module1"
      # GITHUB_BRANCH="main"
      # -gfn GITHUB_FOLDER_NAME "tf-module1"
      # -pfn PROJECT_FOLDER_NAME "tf-module1"
      shift
      ;;
    -tsf)
      export RUN_TENSORFLOW=true
      export RUN_CONDA=true
      shift
      ;;
    -T)
      export RUN_TENSORFLOW=true
      export RUN_CONDA=true
      shift
      ;;
    -u)
      export UPDATE_GITHUB=true
      shift
      ;;
    -usage)
      usage_examples  # local function
      shift
      ;;
    -U)
      export UPDATE_PKGS=true
      shift
      ;;
    -V)
      export VERIFY_ENV=true
      shift
      ;;
    -vv)
      export SHOW_DEBUG=true
      shift
      ;;
    -venv)
      export RUN_VIRTUALENV=true
      shift
      ;;
    -VSC*)
      shift
             VSCODE_FILE=$( echo "$1" | sed -e 's/^[^=]*=//g' )
      export VSCODE_FILE
      shift
      ;;
    -v)
      export SHOW_VERBOSE=true
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
      export GITHUB_REPO_URL="https://github.com/wilsonmar/WebGoat.git"
      export PROJECT_FOLDER_NAME="webgoat"
      export APPNAME="webgoat"
      export MY_FOLDER="Contrast"  # "ShiftLeft"
      export MY_FILE="docker-compose.yml"
      export APP1_PORT="8080"
      shift
      ;;
    -y)
      export GITHUB_REPO_URL="https://github.com/nickjj/build-a-saas-app-with-flask.git"
      export PROJECT_FOLDER_NAME="rockstar"
      export APPNAME="rockstar"
      shift
      ;;
    -Y)
      export USE_YUBIKEY=true
      shift
      ;;
    -zsh)
      export CONVERT_TO_ZSH=true
      shift
      ;;
    *)
      error "Parameter \"$1\" not recognized. Aborting."
      exit 0
      break
      ;;
  esac
done


### 07. Display run variables

# See https://wilsonmar.github.io/mac-setup/#DisplayRunVars
if [ "${SHOW_VERBOSE}" = true ]; then
   note "GITHUB_USER_NAME=" "${GITHUB_USER_NAME}"
   note "GITHUB_USER_ACCOUNT=" "${GITHUB_USER_ACCOUNT}"
   note "GITHUB_USER_EMAIL=" "${GITHUB_USER_EMAIL}"
   note "AWS_DEFAULT_REGION= " "${AWS_DEFAULT_REGION}"
fi

# TODO: print all command arguments submitted:
#while (( "$#" )); do 
#  echo $1 
#  shift 
#done 


### 08. Obtain and show information about the operating system in use to define which package manager to use

# See https://wilsonmar.github.io/mac-setup/#OSDetect
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



### 09. Set traps to display information if script is interrupted.

# See https://wilsonmar.github.io/mac-setup/#SetTraps
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
   # TODO: Delete stuff?
   success "$MSG"
   # note "Disk $FREE_DISKBLOCKS_START to $FREE_DISKBLOCKS_END"
}
sig_cleanup() {
    trap '' EXIT  # some shells call EXIT after the INT handler.
    false # sets $?
    this_ending
}



### 10. Set Continue on Error and Trace

# See https://wilsonmar.github.io/mac-setup/#StrictMode
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

note "Running $0 in $PWD"  # $0 = script being run in Present Wording Directory.
note "Apple macOS sw_vers = $(sw_vers -productVersion) / uname -r = $(uname -r)"  # example: 10.15.1 / 21.4.0

# See https://wilsonmar.github.io/mac-setup/#BashTraps
note "OS_TYPE=$OS_TYPE using $PACKAGE_MANAGER from $DISK_PCT_FREE disk free"
HOSTNAME="$( hostname )"
   note "on hostname=$HOSTNAME "
PUBLIC_IP=$( curl -s ifconfig.me )
INTERNAL_IP=$( ipconfig getifaddr en0 )
   # To protect privacy security, don't expose IP address for attackers to use:
   # note "at PUBLIC_IP=$PUBLIC_IP, internal $INTERNAL_IP"

# From https://vladiliescu.net/wiki/macos/
note $( sysctl vm.swapusage )
   # vm.swapusage: total = 2048.00M  used = 935.25M  free = 1112.75M  (encrypted)

if [ "$OS_TYPE" = "macOS" ]; then  # it's on a Mac:
   export MACHINE_TYPE="$(uname -m)"
   note "OS_TYPE=$OS_TYPE MACHINE_TYPE=$MACHINE_TYPE"
   if [[ "${MACHINE_TYPE}" == *"arm64"* ]]; then
      # On Apple M1 Monterey: /opt/homebrew/bin is where Zsh looks (instead of /usr/local/bin):
      export BREW_PATH="/opt/homebrew"
      export BREW_PATH_OPT="/opt/homebrew/opt"
      eval $( "${BREW_PATH}/bin/brew" shellenv)
   elif [[ "${MACHINE_TYPE}" == *"x86_64"* ]]; then
      export BREW_PATH="/usr/local/bin"
      export BREW_PATH_OPT="/usr/local/opt"
      # BASHFILE=~/.bash_profile ..."
      # BASHFILE="$HOME/.bash_profile"  # on Macs
      #note "BASHFILE=~/.bashrc ..."
      #BASHFILE="$HOME/.bashrc"  # on Linux
   fi  # MACHINE_TYPE
fi


### 12. Backup using macOS Time Machine via tmutil

if [ "${SHOW_VERBOSE}" = true ]; then
   h2 "Before changes, backup using macOS Time Machine via tmutil ..."
   # tmutil version
      # tmutil version 4.0.0 (built Jul  5 2023)
   # See https://www.hexnode.com/mobile-device-management/help/script-for-time-machine-backup-in-mac/
   #tmutil status
      #    ClientID = "com.apple.backupd";
      #    Running = 0;
   #tmutil destinationinfo
      # ====================================================
      # Name          : One Touch
      # Kind          : Local
      # ID            : D370D806-D01D-4600-AFD1-5F8E75C92D17   
   #sudo tmutil listlocalsnapshots /
      #com.apple.TimeMachine.2023-09-15-184333.local
      # x4
   # Identify backup_folder
   #BACKUP_FOLDER=$(tmutil machinedirectory)
   #echo "$BACKUP_FOLDER"
   #if NOT "No machine directory found for host."
      # Check if backup is needed:
      #tmutil calculatedrift "${BACKUP_FOLDER}"
      #tmutil listbackups
      #sudo tmutil enable 
   #echo "Plug in external backup drive and enter password to continue ..."
   #sudo tmutil startbackup
   # pause
fi



### 13. Upgrade Bash to Zsh

# Apple Directory Services database Command Line utility:
USER_SHELL_INFO="$( dscl . -read /Users/$USER UserShell )"
if [ "${SHOW_VERBOSE}" = true ]; then
   echo "SHELL=$SHELL"
   echo "USER_SHELL_INFO=$USER_SHELL_INFO"
fi
if [ "${CONVERT_TO_ZSH}" = true ]; then
   # Shell scripting NOTE: Double brackets and double dashes to compare strings, with space between symbols:
   if [[ "UserShell: /bin/bash" = *"${USER_SHELL_INFO}"* ]]; then
      if [ "${CONVERT_TO_ZSH}" = true ]; then
         warning "chsh -s /bin/zsh  # to switch to zsh from ${USER_SHELL_INFO}"
         #chsh -s /opt/homebrew/bin/zsh  # not allow because it is a non-standard shell.
         chsh -s /bin/zsh 
         # Password will be requested here.

         # TODO: read manual user input
         # exit 9  # to restart?
      fi
   else  # /opt/ on ARM computers:
      h2 "Install Apple Rosetta x86 emulator on M1"
      # See https://chrisjune-13837.medium.com/how-to-install-python-3-x-on-apple-m1-9e77ff94266a
      if ! command -v /usr/sbin/softwareupdate >/dev/null; then  # command not found, so:
         # Run this before installing Docker - https://javascript.plainenglish.io/which-docker-images-can-you-use-on-the-mac-m1-daba6bbc2dc5
         /usr/sbin/softwareupdate --install-rosetta agree-to-license
         # I have read and agree to the terms of the software license agreement. A list of Apple SLAs may be found here: http://www.apple.com/legal/sla/
         # Type A and press return to agree: A
         # 2022-05-04 16:02:21.810 softwareupdate[93057:1798710] Package Authoring Error: 002-79206: Package reference com.apple.pkg.RosettaUpdateAuto is missing installKBytes attribute
         # Install of Rosetta 2 finished successfully
      fi
   fi
   note "which zsh at $( which zsh )"  # Answer: "/opt/homebrew/bin/zsh"  (using homebrew or default one from Apple?)
                             # Answer: "/usr/local/bin/zsh" if still running Bash.
fi  # CONVERT_TO_ZSH



### 14. Define utility functions: kill process by name, etc.
###     Keep-alive: update existing `sudo` time stamp until `.osx` has finished

# See https://wilsonmar.github.io/mac-setup/#KeepAlive
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

ps_kill(){  # $1=process name
      PSID=$( pgrap -l "$1" )
      if [ -z "$PSID" ]; then
         h2 "Kill $1 PSID=$PSID ..."
         kill 2 "$PSID"
         sleep 2
      fi
}



### 15. Install installers (brew, apt-get), depending on operating system

# See https://wilsonmar.github.io/mac-setup/#InstallInstallers

# Bashism Internal Field Separator used by echo, read for word splitting to lines newline or tab (not spaces).
#IFS=$'\n\t'  
#BASHFILE="$HOME/.bash_profile"  # on Macs
# if ~/.bash_profile has not been defined, create it:
#if [ ! -f "$BASHFILE" ]; then #  NOT found:
#   note "Creating blank \"${BASHFILE}\" ..."
#   touch "$BASHFILE"
#   echo "PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin" >>"$BASHFILE"
#   # El Capitan no longer allows modifications to /usr/bin, and /usr/local/bin is preferred over /usr/bin, by default.
#else
#   LINES=$(wc -l < "${BASHFILE}")
#   note "\"${BASHFILE}\" already created with $LINES lines."
#   echo "Backing up file $BASHFILE to $BASHFILE-$LOG_DATETIME.bak ..."
#   cp "$BASHFILE" "$BASHFILE-$LOG_DATETIME.bak"
#fi

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

   h2 "-Install package managers ${PACKAGE_MANAGER} ..."
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
      # To uninstall Homebrew: 
         # /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)"

      if ! command -v brew >/dev/null; then  # NOT installed:
         if [ "$OS_TYPE" = "macOS" ]; then  # it's on a Mac:
            # /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

            h2 "Installing brew package manager ..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
            # mkdir homebrew && curl -L https://GitHub.com/Homebrew/brew/tarball/master \
            #   | tar xz --strip 1 -C homebrew
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

      brew install rbenv

      #brew is also used later in this script

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


if [ "${VERIFY_ENV}" = true ]; then  # -V  (upper case)
  if command -v brew >/dev/null; then  # command found, so:
      h2 "brew doctor for -V (Verify) (may error out script)..."
      brew doctor
         # "Your system is ready to brew."

      h2 "brew cleanup from previous install (may error out script)..."
      brew cleanup
         # RESPONSE: Pruned 4 symbolic links from /usr/local

      # https://superuser.com/questions/1759738/error-could-not-cleanup-old-kegs-fix-your-permissions-on
      #sudo chown -R $(whoami) $(brew --prefix)/*
         # Above command takes minutes to run.
   fi
fi



### 16. Install ShellCheck 

# See https://wilsonmar.github.io/mac-setup/#ShellCheck
# CAUTION: shellcheck does not work on zsh files (only bash files)
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



### 17. Trace execution of this script using otel-cli

if [ "${RUN_TRACE}" = true ]; then  # -trace
   # Python-based alternative to https://github.com/dell/opentelemetry-cli
   # See Go-based otel-cli https://github.com/equinix-labs/otel-cli#getting-started
      # https://deploy.equinix.com/labs/otel-cli/
      # https://blog.howardjohn.info/posts/shell-tracing/
   if [ "${DOWNLOAD_INSTALL}" = true ]; then  # -I
      if [ "${PACKAGE_MANAGER}" = "brew" ]; then # -U
         h2 "-I (install) otel-cli client for OpenTelemetry in CLI ..."
         # https://gist.github.com/howardjohn/60ed0a3ef4d7a79b043c153631bfb18f
         brew tap equinix-labs/otel-cli
         brew install otel-cli
         # Similar to System.Runtime.Metrics API in .NET
      fi
   fi
   # Use Docker container as OpenTelementry server:
      # https://dev.to/ashokan/otel-cli-push-otel-traces-with-ease-29al simple intuitive flexible
   # Alternatively
   if ! command -v otel-cli ; then
   else
      # Run a trace receiver simple demo server using https://github.com/equinix-labs/otel-cli
      otel-cli server tui &
      if [ -z "$OTEL_EXPORTER_OTLP_ENDPOINT" ]; then  # variable is found:
         warning "-trace using $OTEL_EXPORTER_OTLP_ENDPOINT ..."
         # dotnet tool install -g dotnet-monitor
         # Docker image: mcr.microsoft.com/dotnet/monitor:6.0.0
      else
         export OTEL_EXPORTER_OTLP_ENDPOINT="localhost:4317"
         warning "-trace using otel-cli on $OTEL_EXPORTER_OTLP_ENDPOINT ..."

         # Run a trace receiver simple local demo server in background:
         otel-cli server tui &
         
         # run a program inside a span:
         otel-cli exec --service my-service --name "curl google" curl https://google.com
            # The `server tui` shows traces:
            # Trace ID     | Span ID          | Parent | Name        | Kind   | Start | End | Elapsed
            # ddb...a5687c | f35df40a78a4d9a3 |        | curl google | client | 0     | 134 | 134
      fi
   fi
#   # Place at end of script:
#   if [ "${DELETE_CONTAINER_AFTER}" = true ]; then  # -D
#      # kill otel-cli server background process.
#   fi
fi  # RUN_TRACE



### 18. Configure VSCode

Loop_Thru_File(){
   h2 "-VSC \"${VSCODE_FILE}\" Loop_Thru_File ..."
   for line in ("${VSCODE_FILE}")
   do
      echo "${line}"   # debug
      # Skip blank lines and those whose first character is a # comment:
      # Examples: https://gist.github.com/matthiasott/1695ca6f1fe9ccfc18ff6748fb2767c1
      # Such as: https://marketplace.visualstudio.com/items?itemName=azure-ai.azure-ai
      # code --install-extension azure-ai.vscode-ai
      # code --install-extension "${line}"
   done
}

if [ -n "${VSCODE_FILE}" ]; then   # -VSC \"vscode-ext\" file specified:
   # For vscode CLI commands, see https://www.youtube.com/watch?v=uKCiAA4AJcI
   # https://code.visualstudio.com/docs/editor/extension-marketplace
   h2 "-VSC \"${VSCODE_FILE}\" at ${PWD}..."
      # Loop_Thru_File  # function defined above
   if [ -f "${VSCODE_FILE}" ]; then   # file found:
      # FIXME: Dir not found.
      # PROTIP: Use sed to strip out spaces before and after the file name:
      LINES_IN_FILE=$( wc -l < ${VSCODE_FILE} | sed 's/ //g' )
      echo "-VSC \"${VSCODE_FILE}\" ${LINES_IN_FILE} lines for code --install-extensions ..."
      # h2 "-vsc \"${VSCODE_FILE}\" entries used for -U code --uninstall-extensions ..."
      # TODO: Loop through file to install each extension: code --install-extension "${line from file}"
         # Ignore Duplicates:
   else  # file not found
      # h2 "-VSC \"${VSCODE_FILE}\" gen'd by code --list-extensions output ..."
      # This will not run if code --disable-extensions was run!
      code --list-extensions > "${VSCODE_FILE}"
         # [vscode-ai]: Couldn't find message for key azureml.internal.activate.title.
      LINES_IN_FILE=$( wc -l < "${VSCODE_FILE}" | sed 's/ //g' )
      echo "-VSC \"${VSCODE_FILE}\" file gen'd with ${LINES_IN_FILE} lines ..."
   fi
fi



### 19. Install basic utilities (git, jq, tree, etc.) used by many:

# See https://wilsonmar.github.io/mac-setup/#BasicUtils
if [ "${SHOW_DEBUG}" = true ]; then
   h2 "Apps installed using Apple App Store ..."
   find /Applications -path '*Contents/_MASReceipt/receipt' -maxdepth 4 -print |\sed 's#.app/Contents/_MASReceipt/receipt#.app#g; s#/Applications/##'

   h2 "Apps in /Applications ..."
   ls -ltaT /Applications/
      # drwxr-xr-x   3 wilsonmar  staff       96 Aug  7 19:32:02 2018 iTerm.app

   h2 "Apps in $HOME/Applications ..."
   ls -ltaT $HOME/Applications/

   h2 "brew list --cask ..."
   brew list --cask

   h2 "brew list ..."
   brew list
fi
if [ "${DOWNLOAD_INSTALL}" = true ]; then  # -I
   # CAUTION: Install only packages that you actually use and trust!

   if [ "${PACKAGE_MANAGER}" = "brew" ]; then
  
      ########## DOTHIS: remove apps you don't want removed: ##########
      # See https://wilsonmar.github.io/macos-homebrew/
      h2 "Remove apps pre-installed by Apple, taking up space if they are not used ..."
      # set comma as internal field separator for the string list
      #Field_Separator=$IFS
      #IFS=,
 
      # Excludes apps installed using Apple's App Store app: Amazon Prime Video, Textual, 
         # 1Password, Flash Player, "Grammerly Desktop.app", "Google Chrome", github, Kindle Classic, 
         # "Hidden Bar", "Home Assistant", HP Easy Scan, "Hotkey App",
         # Speedtest, Strongbox, Telegram, Whatsapp Desktop
         # Okta Verify, p4merge, TextEdit, XCode, zoom.us.app
      # Response: "Lensa AI: photo editor, video", The Unarchiver.app, Pixelmator.app, "Save to Pocket", 
          # TextWrangler.app, WriteRoom.app,
          # Texual.app, Twitter.app, Tweetdeck.app, Pocket.app, 

      h2 "-I removing Apple-created apps installed from Apple Store into /Applications/ ..."
      # APPLE_APPS_TO_REMOVE="iMovie GarageBand Keynote Numbers Pages"
      # convert to array space-separated string from mac-setup.env file:
      ARRAY=( $APPLE_APPS_TO_REMOVE )  
      ARRAY=(`echo ${APPLE_APPS_TO_REMOVE}`);
      for appname in "${ARRAY[@]}"; do
         if [ -d "/Applications/$appname.app:?}" ]; then   # file found:
            echo "$appname.app being removed..."
            h2 "/Applications/$appname.app being removed..."
            sudo rm -rf "/Applications/$appname.app"  # remove app folder 
            # Sudo and password needed to remove Numbers, Pages
            # TODO: Remove iMovie and others using the built-in uninstaller.
            # TODO: Also remove app data in "/Library/Application Support" and other folders
         else  # file not found:
            note "/Applications/$appname.app not found to remove ..."
         fi
      done

      h2 "-I brew install/upgrade --cask into /Applications/:"
      # ROOT_APPS_TO_INSTALL="Keybase  DiffMerge  NordVPN  Postman  PowerShell"
      ARRAY=(`echo ${ROOT_APPS_TO_INSTALL}`);
      for appname in "${ARRAY[@]}"; do
         if [ -d "/Applications/$appname.app:?}" ]; then   # app found:
            if [ "${UPDATE_PKGS}" = true ]; then
               note "-I brew reinstall --cask $appname.app within /Applications/ ..."
               brew uninstall --cask $appname --force
               brew install --cask $appname
                  # GIMP Error: Directory not empty @ dir_s_rmdir - /private/tmp/d20230916-90678-14otypx
            # else ignore
            fi
         else  # app not found:
            note "-I brew install --cask $appname within /Applications/ ..."
            brew install --cask $appname
            # Freeform.app not recognized
         fi
      done

      # For those with different brew names than app name:
         # Anki flashcard player
         # "GPG Keychain.app"
         # Karabiner-Elements to "Karabiner-Elements.app"
         # Karabiner-EventViewer to "Karabiner-EventViewer.app"
             # https://www.youtube.com/watch?v=j4b_uQX3Vu0
         # microsoft-edge to "Microsoft Edge.app"
         # Microsoft Remote Desktop, 
         # Microsoft Office, Microsoft PowerShell, Microsoft Teams, Microsoft Remote Desktop,
         # sublime-text to "Sublime Text.app"
      # Installed from vendor website: Keka, Adobe, Camtasia, DiffMerge, p4merge

      h2 "-I install/upgrade apps using brew --cask into $HOME/Applications/:"
      # HOME_APPS_TO_INSTALL="1Password  Docker Firefox google-cloud-sdk Hyper Macvim"
      # Exceptions: 
         # google-cloud-sdk does not create a "Google Cloud SDK.app"
            # See https://snark.github.io/jumpcut/ for more cut-and-paste.
         # hyper install stores a file in /usr/local/bin on ARM machines.
         # No longer supported? the-unarchiver
      # Not on my list but may be in yours: cakebrew, snowflake-snowsql, geekbench, spotify, 
         # pycharm, textmate, brave, opera, 
      # Installed separately: 1password (1Password7.app),
         # licensed "VMWare Fusion", "VMWare Horizon Client", "VMWare Remote Console",
      brew_update_app() {
         brewname=$1
         appname=$2
         if [ -d "$HOME/Applications/$appname.app:?}" ]; then   # app found:
            if [ "${UPDATE_PKGS}" = true ]; then
               note "brew reinstall --cask $brewname.app within $HOME/Applications/ ..."
               brew uninstall --cask $brewname --force
               brew install --cask $brewname
            # else ignore
            fi
         else  # app not found:
            note "-I install brew --cask $brewname within $HOME/Applications/ ..."
            brew install --cask $brewname
         fi
         # PROTIP: On Error: Directory not empty @ dir_s_rmdir - , sudo chown -R $(whoami) $(brew --prefix)/*
         # Then reboot the system
      }
      # HOME_APPS_TO_INSTALL="1Password  Docker Firefox google-cloud-sdk Hyper Macvim"
      ARRAY=(`echo ${HOME_APPS_TO_INSTALL}`);
      for appname in "${ARRAY[@]}"; do
         brew_update_app $appname $appname
      done
      
      # Not specified: Jumpcut  Sketch (licensed)
      # Exceptions:
         # Atom has been discontinued. Use VSCode instead.
         # Keybase (licensed) has error
         # anaconda to "Anaconda-Navigator.app" and can contain security vulnerabilities!
         # Microsoft O365, download from https://www.office.com/?auth=2&home=1
         
         brew install --cask elgato-stream-deck  # does not create a "StreamDeck.app"
         brew install --cask miniconda
            # miniconda ( to '/usr/local/bin/conda') does not create a "Miniconda3.app"

      # TODO: Until an array for those with different brew names than app name:
         brew_update_app "google-chrome" "Google Chrome"
         brew_update_app "github" "GitHub Desktop"
         # brew_update_app "iterm2" "iTerm"
         brew_update_app "microsoft-teams" "Microsoft Teams"
         brew_update_app "visual-studio-code" "Visual Studio Code"
         brew_update_app "zoom" "zoom.us"
         #brew_update_app "tor-browser" "Tor Browser"

      # TODO: Install Chrome Add-ons


      h2 "-I install brew CLI utilities ..."
      # TODO: CLI_APPS_TO_INSTALL=$( brew list )  # instead of brew upgrade # which does them all 
      # Defined in ~/mac-setup.env :
      # CLI_APPS_TO_INSTALL="curl wget jp jq yq htop tree git hub ncdu docker-compose hadolint 1password-cli keepassc"
         # * jq manipulates JSON
         # * yq manipulates YAML
      ARRAY=(`echo ${CLI_APPS_TO_INSTALL}`);  # from ~/mac-setup.env
      for brewname in "${ARRAY[@]}"; do
         brew install $brewname
         # NOTE: Brew updates if already installed.
      done

      # Exceptions:
      brew install jmespath/jmespath/jp
       # https://github.com/jmespath/jp
      
      # DEPRECATED: brew install docker-compose
         # Until Jul 2023 Compose was part of Docker Desktop on Mac. However,
            # See https://docs.docker.com/compose/install/
         # See https://www.upwork.com/resources/how-to-install-docker-compose
      # Verify:
         # docker compose version
            # Docker Compose version v2.2.3

      # https://the.exa.website/
      # Replacement for ls - see https://the.exa.website/#installation
      # brew install exa


      ### 18c. Define file extensions to edit using VSCode
      # https://superuser.com/questions/273756/how-to-change-default-app-for-all-files-of-particular-file-type-through-terminal
      brew install duti
      if command -v duti ; then
         FILE_EXT_BY_VSCODE=".json .md .py .sh .txt .yml .yaml .zsh" # exported from ~/mac-setup.env
         appid=$( osascript -e 'id of app "Visual Studio Code"' )  # "com.microsoft.VSCode"
         ARRAY=(`echo ${FILE_EXT_BY_VSCODE}`);
         for file_ext in "${ARRAY[@]}"; do
            echo_debug "duti -s \"$appid\" \"$file_ext\" all ..."
            duti -s "$appid" "$file_ext" all
         done
      fi


     #https://www.hashicorp.com/blog/announcing-hashicorp-homebrew-tap referencing https://github.com/hashicorp/homebrew-tap
      if [ "${USE_VAULT}" = true ]; then   # -HV
         brew install hashicorp/tap/vault
         which vault
      fi

      if [ "${USE_PACKER}" = true ]; then   # -HP
         brew install hashicorp/tap/packer
         which packer
         packer --version
      fi

      if [ "${RUN_CONSUL}" = true ]; then  # -tf
         brew install hashicorp/tap/consul
         which consul   # /usr/local/bin/consul
         brew install hashicorp/tap/envconsul
         which envconsul
      fi

      if [ "${RUN_TERRAFORM}" = true ]; then  # -tf
         h2 "brew install latest Terraform with tfenv ..."
         brew install tfenv
         # NO brew install hashicorp/tap/terraform
         brew install tfenv      
         tfenv install latest
            # https://releases.hashicorp.com/terraform/
         TF_VERSION=$( tfenv version-name )
            # Terraform v1.5.7
         note "TF_VERSION=$TF_VERSION"
         tfenv use "${TF_VERSION}"

         which terraform
            # On Apple Silicon: /opt/homebrew/bin//terraform
            # On Intel: /usr/local/bin/terraform

         brew install terraform-docs
         brew install tfsec
         brew install tflint
         brew install terragrunt
         brew install terrascan

         # brew install hashicorp/tap/sentinel
         # which sentinel
      fi

      h2 "brew install HashiCorp Consul:"
      if [ "${RUN_CONSUL}" = true ]; then  # -tf
         brew install hashicorp/tap/consul-k8s
         which consul-k8s
         # https://learning.oreilly.com/library/view/consul-up-and/9781098106133/ch03.html
         # minikube tunnel
         # y  consul-k8s install -config-file values.yaml
            #  --> Service does not have load balancer ingress IP address: consul/consul-ui
         #  Cannot install Consul. A Consul cluster is already installed in namespace consul with name consul.
         #Use the command `consul-k8s uninstall` to uninstall Consul from the cluster.
         # consul status
            #    NAME  | NAMESPACE |     STATUS      | CHART VERSION | APPVERSION | REVISION |      LAST UPDATED        
            # ---------+-----------+-----------------+---------------+------------+----------+--------------------------
            # consul | consul    | pending-install | 0.44.0        | 1.12.0     |        1 | 2022/06/05 17:47:57 MDT  
            # ✓ Consul servers healthy (1/1)
            # ✓ Consul clients healthy (1/1)
         # kubectl get daemonset,statefulset,deployment -n consul
      fi
     
      if [ "${RUN_NOMAD}" = true ]; then  # -tf
         brew install hashicorp/tap/nomad
         #brew install hashicorp/tap/packer
         which nomad
      fi

      # brew install --cask iterm2   # for use by .oh-my-zsh
      # Path to your oh-my-zsh installation:
      # export ZSH="$HOME/.oh-my-zsh"
      #if [ ! -d "$ZSH" ]; then # install:
      #   note "Creating ~/.oh-my-zsh and installing based on https://ohmyz.sh/ (NO brew install)"
      #   mkdir -p "${ZSH}"
      #   sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
      #else
         #if [ "${UPDATE_PKGS}" = true ]; then
            # upgrade_oh_my_zsh   # function.
         #fi
      #fi

      zsh --version  # Check the installed version
      # Custom theme from : git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
      # ZSH_THEME="powerlevel9k/powerlevel9k"
      # source ~/.zhrc  # source $ZSH/oh-my-zsh.sh

   fi  # PACKAGE_MANAGER

fi  # DOWNLOAD_INSTALL



### 19. Install chezmos (Chai's macOS dotfiles)

# See https://www.chezmoi.io/reference/concepts/
# See https://wilsonmar.github.io/dotfiles/
if [ "${USE_CHEZMOI}" = true ]; then  # -chezmoi
   #if [ "${DOWNLOAD_INSTALL}" = true ]; then  # -I
   if [ "${PACKAGE_MANAGER}" = "brew" ]; then
         if ! command -v chezmoi >/dev/null; then  # command not found, so:
            h2 "Brew installing chezmoi ..."
            brew install chezmoi
         else  # installed already:
            if [ "${UPDATE_PKGS}" = true ]; then
               h2 "Brew upgrading chezmoi ..."
               brew upgrade chezmoi
            fi
         fi
         note "$( chezmoi --version )"
            # chezmoi version v2.40.0, commit 6a8ca1634654734bb33a036ffb9c21e6b9f4d28d, built at 2023-09-19T08:14:08Z, built by Homebrew
   fi  # PACKAGE_MANAGER

   CHEZMOI_CONFIG_FILE="~/.config/chezmoi/chezmoi.toml"
   CHEZMOI_FOLDERPATH="~/.local/share/chezmoi"  # in ~/chmac-setup.env
   if [ ! -f "$CHEZMOI_FOLDERPATH" ]; then   # NOT found
      # Create a new git local repository to store its source state:
      chezmoi init
   fi
   ls -al "${CHEZMOI_FOLDERPATH}"
      # By default, chezmoi only modifies files in the working copy.
#fi  # DOWNLOAD_INSTALL

fi  # USE_CHEZMOI



### 20. Override defaults in Apple macOS System Preferences:"

# See https://wilsonmar.github.io/mac-setup/#SysPrefs
# See https://wilsonmar.github.io/dotfiles/

if [ "${SET_MACOS_SYSPREFS}" = true ]; then  # -macos
   h2 "16. Override defaults in Apple macOS System Preferences:"
   # https://www.youtube.com/watch?v=r_MpUP6aKiQ = "~/.dotfiles in 100 seconds"
   # Patrick McDonald's $12,99 Udemy course "Dotfiles from Start to Finish" at https://bit.ly/3anaaFh

   if [ "${SHOW_DEBUG}" = true ]; then  # -vv
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

   # See https://www.youtube.com/watch?v=8fFNVlpM-Tw
   # Changing the login screen image on Monterey.

   # Show the ~/Library Folder https://weibeld.net/mac/setup-new-mac.html
   chflags nohidden ~/Library

    # Mute Startup Sound - just before logout, and restores the previous volume just after login. 
   sudo defaults write com.apple.loginwindow LogoutHook "osascript -e 'set volume with output muted'"
   sudo defaults write com.apple.loginwindow LoginHook "osascript -e 'set volume without output muted'"

fi  # SET_MACOS_SYSPREFS



### 21. Hashicorp Cloud using Doormat

# Command-line interface for https://github.com/hetznercloud/cli

if [ "${USE_DOORMAT}" = true ]; then  # -Doormat

   if [ "${PACKAGE_MANAGER}" = "brew" ]; then
      if ! command -v doormat >/dev/null; then  # command not found, so:
         # brew install doormat-cli
         brew tap hashicorp/security git@github.com:hashicorp/homebrew-security.git
         brew install hashicorp/security/doormat-cli
      else  # installed already:
         if [ "${UPDATE_PKGS}" = true ]; then
            h2 "Brew upgrade doormat-cli ..."
            brew upgrade doormat-cli
         fi
      fi
      note "$( doormat -v )"  # v3.1.2  5 files 48.2MB

      #if ! command -v hcloud >/dev/null; then  # command not found, so:
      #   brew install hashicorp/internal/hcloud  # 9 files, 11.3MB
      #else
      #   if [ "${UPDATE_PKGS}" = true ]; then
      #      h2 "Brew upgrade internal/hcloud ..."
      #      brew upgrade hashicorp/internal/hcloud
      #   fi
      #fi
      # note "$( hcloud version )"  # v1.29.5

   fi  # "${PACKAGE_MANAGER}" = "brew"
   
   echo CURRENT_CLIENT_IP_ADDR="$(curl -s ifconfig.me)"
   # Manually make sure credentials (AWS_ACCESS_KEY and AWS_SECRET_ACCESS_KEY and AWS_SESSION_TOKEN)
   # are copied from https://doormat.hashicorp.services/
   # which is for your the IP address you used
   
   h2 "doormat login may open default Chrome browser window for Okta Verify ..."
   export DOORMAT_URL_HANDLER_ARGS="-b com.google.Chrome"
   doormat login --validate
      # INFO[0001] session expires on 2022-01-13 03:03:11 -0500 EST
   doormat login -f   # -f to refresh existing doormat credentials 
      # INFO[0001] logging into doormat...                      
      # INFO[0004] successfully logged into doormat!    
   # Browser Dashboard: https://doormat.hashicorp.services/
   # #proj-cloud-auth via Slack & @otterbot
   # See https://docs.prod.secops.hashicorp.services/doormat/cli/

fi  # USE_DOORMAT



### 22. Hashicorp Consul using Envoy

# https://learn.hashicorp.com/tutorials/consul/service-mesh-with-envoy-proxy
if [ "${USE_ENVOY}" = true ]; then  # -Envoy
   if [ "${PACKAGE_MANAGER}" = "brew" ]; then
      # https://func-e.io/  (pronounced "funky")
      if [[ "${MACHINE_TYPE}" == *"arm64"* ]]; then
         export FUNC_E_PLATFORM="darwin/amd64"
      fi
      if ! command -v func-e >/dev/null; then  # command not found, so:
         curl -L https://func-e.io/install.sh | bash -s -- -b /usr/local/bin
      else  # installed already:
         if [ "${UPDATE_PKGS}" = true ]; then
            h2 "Brew upgrade func-e ..."
            brew upgrade func-e
         fi
      fi
      note "$( func-e -v )"  # ???

      h2 "Download version 1.18.3 of Envoy."
      func-e use 1.18.3
   fi  # brew

   sudo cp ~/.func-e/versions/1.18.3/bin/envoy /usr/local/bin/
   
   note "$( envoy --version )"

   note "$( consul members )"
      #Node            Address         Status  Type    Build   Protocol  DC   Segment
      #hostname.local  127.0.0.1:8301  alive   server  1.10.0  2         dc1  <all>

fi  # USE_ENVOY



### 23. Image SD card 

image_sd_card(){
# See https://wilsonmar.github.io/mac-setup/#ImageSDCard
# See https://wilsonmar.github.io/iot-raspberry-install/
# To avoid selecting a hard drive and wiping it out,
# it's best to manually use https://www.sdcard.org/downloads/formatter/
# But this automation is meant for use in a production line creating many copies.
# Download image, format new SD chip, and flash the image, all in a single command.
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
      ls -ltaT "${IMAGE_XZ_FILENAME}"
      if [ ! -f "$IMAGE_FILENAME" ]; then   # file NOT found, so download from github:
         note "Decompressing ${IMAGE_XZ_FILENAME} using xz ..."
         xz "${IMAGE_XZ_FILENAME}"  # to "$IMAGE_FILENAME"
      fi
   fi

   if [ ! -f "$IMAGE_FILENAME" ]; then   # file NOT found, so download from github:
      error "xz de-compress of $IMAGE_XZ_FILENAME to $IMAGE_FILENAME failed!"
   else
      note "Verify ${IMAGE_FILENAME} ..."
      ls -ltaT "${IMAGE_FILENAME}"
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
}
if [ "${IMAGE_SD_CARD}" = true ]; then  # -sd
   image_sd_card
fi  # IMAGE_SD_CARD



### 24. Clone repository from GitHub into local folder

# For use at end of processing as well, regardless of -c CLONE
Delete_GITHUB_folder(){
   # https://www.zshellcheck.net/wiki/SC2115 Use "${var:?}" to ensure this never expands to / .
   if [ -z "${GITHUB_FOLDER_PATH}" ]; then   # path specified in function below
      if [ -d "${GITHUB_FOLDER_PATH:?}" ]; then  # path available.
         warning "Removing GITHUB_FOLDER_PATH ..."
         lls -ltaT "${GITHUB_FOLDER_PATH}"
         rm -rf "${GITHUB_FOLDER_PATH}"
      fi
   fi
}
Delete_PROJECT_folder(){
   if [ -z "${PROJECT_FOLDER_PATH}" ]; then   # path specified in function below
      if [ -d "${PROJECT_FOLDER_PATH:?}" ]; then  # path available.
         warning "Removing project folder $PROJECT_FOLDER_PATH ..."
         lls -ltaT "${PROJECT_FOLDER_PATH}"
         rm -rf "${PROJECT_FOLDER_PATH}"
      fi
   fi
}


# use curl installed above:
is_url_reachable(){
   # target_url=$1  # such as "https://google.com"
   the_url="$1"
   if curl -I "$the_url" 2>&1 | grep -w "200\|301" ; then
      #note "URL $the_url reachable ..."
      return 0
   else  # error
      #error "URL $the_url not reachable ..."
      return 1
   fi
}
# is_url_reachable "$URL" #  to call function


Identify_GITHUB_REPO_URL(){
   # See https://wilsonmar.github.io/mac-setup/#ObtainRepo
   # For use at end of processing as well:
      # Expected value of GITHUB_REPO_URL is "alfonsof/terraform-azure-examples"
   if [ -n "${GITHUB_REPO_URL}" ]; then   # path specified in parms
      if [[ "$1" == *"http"* ]]; then  # contains it:
         info "-gru (GITHUB_REPO_URL)=$GITHUB_REPO_URL"
      elif [[ "$1" == *"git@"* ]]; then  # contains it:
         info "-gru (GITHUB_REPO_URL)=$GITHUB_REPO_URL"
      else
         if [ "${USE_GITHUB_SSH}" = true ]; then   # -ssh specified:
            GITHUB_REPO_URL="git@github.com:${GITHUB_REPO_URL}.git"
         else
            GITHUB_REPO_URL="https://github.com/${GITHUB_REPO_URL}.git"
         fi
      fi
      is_url_reachable "${GITHUB_REPO_URL}"
      if [ $? -ne 0 ]; then   # return 1 received:
         fatal "-gru GITHUB_REPO_URL \"${GITHUB_REPO_URL}\" unreachable. Exiting ..."
      else
         h2 "-gru GITHUB_REPO_URL \"${GITHUB_REPO_URL}\" specified ..."
         # PROTIP: Extract repo_name from GITHUB_REPO_URL:
         basename="$(basename -s .git ${GITHUB_REPO_URL})"
         note "basename=$basename"
      fi
      # return 0
   else  # GITHUB_REPO_URL not specified in parms
      note "-gru GITHUB_REPO_URL not specified in parms ..."
      # Build target path from one or the other variables?
      if [ -n "${GITHUB_ACCOUNT_NAME}" ]; then   # NOT specified in parms
         info "-gan (GITHUB_ACCOUNT_NAME) = \"${GITHUB_ACCOUNT_NAME}\"  ..."
      else
         note "-gan GITHUB_ACCOUNT_NAME not specified to clone ..."
         # return 1
      fi
      if [ -z "${GITHUB_FOLDER_NAME}" ]; then   # NOT specified in parms
         note "-gfn GITHUB_FOLDER_NAME not specified to clone ..."
         # return 1
      else
         if [ "${USE_GITHUB_SSH}" = true ]; then   # -ssh specified:
            GITHUB_REPO_URL="git@github.com:${GITHUB_ACCOUNT_NAME}/${GITHUB_FOLDER_NAME}.git"
         else
            GITHUB_REPO_URL="https://github.com/${GITHUB_ACCOUNT_NAME}/${GITHUB_FOLDER_NAME}.git"
         fi
         info "-gru GITHUB_REPO_URL=$GITHUB_REPO_URL"
      fi
      # return 0
   fi
}  # Identify_GITHUB_REPO_URL


### 25. Clone into local GITHUB_REPO_BASE if a -gfn GITHUB_FOLDER_NAME was specified:

Clone_into_GITHUB_OR_PROJECT(){

   if [ -z "${GITHUB_FOLDER_NAME+x}" ]; then    # -gfn NOT specified 
      note "-gfn (GITHUB_FOLDER_NAME) not specified in parms ..."      
      if [ -z "${PROJECT_FOLDER_NAME}" ]; then   # -pfn not specified 
         note "-pfn (PROJECT_FOLDER_NAME) not specified in parms also ..."
         # fall through. return 1  # this function
      fi
   else  # -gfn specified:
      h2 "-gfn (GITHUB_FOLDER_NAME) \"${GITHUB_FOLDER_NAME}\" ..."
      # TODO: if GITHUB_FOLDER_NAME == PWD basename 
      #   fatal "-gru  \"$GITHUB_REPO_URL\" would wipe out existing folder \"$basename\". Exiting ..."
      if [ -z "${GITHUB_FOLDER_BASE}" ]; then   # not specified in mac-setup.env
         fatal "GITHUB_FOLDER_BASE not specified. Exiting..."
         return 1  # this function
      else
         if [ ! -d "${GITHUB_FOLDER_BASE:?}" ]; then  # path NOT available
            fatal "GITHUB_FOLDER_BASE not found. Exiting ..."
            return 1  # this function
         fi
      fi
      GITHUB_FOLDER_PATH="$GITHUB_FOLDER_BASE/$GITHUB_FOLDER_NAME"
      note "GITHUB_FOLDER_PATH=$GITHUB_FOLDER_PATH"
      if [ "${DELETE_BEFORE}" = true ]; then
         if [ ! -d "${GITHUB_FOLDER_PATH:?}" ]; then  # NOT found
            warning "${GITHUB_FOLDER_PATH} not found ..."
         else  # found:
            Delete_GITHUB_folder  # defined above in this file.
         fi
      fi
      if [ "${CLONE_GITHUB}" = true ]; then  # -c
         Identify_GITHUB_REPO_URL  # function defined above
         if [ -z "${GITHUB_REPO_URL}" ]; then   # not specified in mac-setup.env
            warning "-gru (GITHUB_REPO_URL) not identified for cloning ..."
            return 1
         else
            note "-gru GITHUB_REPO_URL=$GITHUB_REPO_URL identified for cloning ..."
            if [ -d "${GITHUB_FOLDER_PATH:?}" ]; then  # found
               warning "-gfn GITHUB_FOLDER_PATH=$GITHUB_FOLDER_PATH already exists ..."
            else
               cd /
               cd "${GITHUB_FOLDER_BASE}"
               if [ -d "${GITHUB_FOLDER_NAME:?}" ]; then  # found
                  warning "-gfn GITHUB_FOLDER_NAME=$GITHUB_FOLDER_NAME already exists ..."
               else
                  #if [ "${CLONE_GITHUB}" = true ]; then
                  git clone "${GITHUB_REPO_URL}" "${GITHUB_FOLDER_NAME}"
                  # fi
               fi
            fi
         fi
      else
         note "-c (CLONE_GITHUB) not specified for cloning ..."
      fi
      # whether cloned or not:
      cd /
      cd "${GITHUB_FOLDER_PATH}"
      note "At $PWD"
      if [ "${SHOW_VERBOSE}" = true ]; then
         ls -ltaT 
      fi
   fi


   ### 26. Clone to local Projects folder if -pfn PROJECT_FOLDER_NAME was specified:

   # See https://wilsonmar.github.io/mac-setup/#ProjFolder
   if [ -z "${PROJECT_FOLDER_NAME+x}" ]; then   # -pfn not specified 
      note "-pfn (PROJECT_FOLDER_NAME) not specified in parms ..."
      # But we need a project folder anyway...
      if [ -n "${GITHUB_REPO_URL}" ]; then  # speified in parms
         # PROTIP: Extract repo_name from URL: either git@github.com: or https://github.com...
         basename="$(basename -s .git ${GITHUB_REPO_URL})"
         PROJECT_FOLDER_NAME="$basename" # like NOT "mac-setup"
         warning "-pfn \"${PROJECT_FOLDER_NAME}\" obtained from -gru \"$GITHUB_REPO_URL\" ..."
      else
         PROJECT_FOLDER_NAME="$THIS_PROGRAM-$(date +%Y%m%dT%H%M%S%z)"  
                                   # like mac-setup-20231231T235959-0600 (24 hr format)
         warning "-pfn \"${PROJECT_FOLDER_NAME}\" assumed since -gru not specified..."
      fi
   fi

      if [ ! -d "${PROJECT_FOLDER_BASE:?}" ]; then  # base NOT available.
         fatal "PROJECT_FOLDER_BASE not found. Exiting ..."
         return 1  # this function
      fi
      PROJECT_FOLDER_PATH="$PROJECT_FOLDER_BASE/$PROJECT_FOLDER_NAME"
      if [ "${DELETE_BEFORE}" = true ]; then
         if [ ! -d "${PROJECT_FOLDER_PATH:?}" ]; then  # NOT found
            note "${PROJECT_FOLDER_PATH} does not exist ..."
         else  # found:
            note "-D specified to DELETE ${PROJECT_FOLDER_PATH} BEFORE ..."
            Delete_PROJECT_folder  # defined above in this file.
         fi
      fi
      if [ "${CLONE_GITHUB}" = false ]; then
         note "-c (CLONE_GITHUB) not specified for cloning into ${PROJECT_FOLDER_BASE}..."
         warning "Creating ${PROJECT_FOLDER_PATH}..."
         mkdir -p "${PROJECT_FOLDER_PATH}"
      else  # do it:
         Identify_GITHUB_REPO_URL  # function defined above
         if [ -z "${GITHUB_REPO_URL}" ]; then
            warning "-gru (GITHUB_REPO_URL) not specified. Not cloning ..."
            warning "PROJECT_FOLDER_PATH=$PROJECT_FOLDER_PATH being created..." 
            mkdir -p "${PROJECT_FOLDER_PATH}"
         else 
            note "-gru \"$GITHUB_REPO_URL\" being cloned ..."
            cd /
            cd "${PROJECT_FOLDER_BASE}"
            if [ -z "${GITHUB_DEPTH_1}" ]; then  # not specified
               git clone "${GITHUB_REPO_URL}" "${PROJECT_FOLDER_NAME}"
            else
               git clone "${GITHUB_REPO_URL}" "${PROJECT_FOLDER_NAME}" --depth 1
            fi
         fi
      fi
      cd /
      cd "${PROJECT_FOLDER_PATH}"
#   fi  # PROJECT_FOLDER_NAME
   note "At $PWD"
   if [ "${SHOW_VERBOSE}" = true ]; then
      ls -ltaT 
   fi
}
Clone_into_GITHUB_OR_PROJECT



### 27. git checkout git branch if -ghb was specified

if [ -z "${GITHUB_BRANCH}" ]; then   # variable not defined
   note "-ghb GITHUB_BRANCH not specified among parms. ..."
   if [ -z "${GITHUB_BRANCH_DEFAULT}" ]; then   # variable is NOT defined and not blank
      warning "GITHUB_BRANCH_DEFAULT not specified in $ENV_FOLDERPATH ..."
      warning "so no git checkout. Checkouts stays on default main or master."
   else
      note "GITHUB_BRANCH_DEFAULT=\"$GITHUB_BRANCH_DEFAULT\" ..."
   fi
else  # GITHUB_BRANCH defined:
   # from https://stackoverflow.com/questions/1593051/how-to-programmatically-determine-the-current-checked-out-git-branch
   cur_branch_name=$(git symbolic-ref -q HEAD)
   cur_branch_name=${cur_branch_name##refs/heads/}
   cur_branch_name=${cur_branch_name:-HEAD}
   note "git branch is current at \"${cur_branch_name}\" ..."

   if [ $(git branch --list "$GITHUB_BRANCH") ]; then
      note "-ghb GITHUB_BRANCH \"${GITHUB_BRANCH}\" checkout ..."
      git checkout "${GITHUB_BRANCH}"
   else
      # TODO: if cur_branch_name is same as requested branch:
      echo "-ghb (GITHUB_BRANCH) \"$GITHUB_BRANCH\" among parms does not exist in git repo..."
   fi   
fi  # GITHUB_BRANCH



### 28. Reveal secrets stored within .gitsecret folder 

# See https://wilsonmar.github.io/mac-setup/#UnencryptGitSecret
# within repo from GitHub (after installing gnupg and git-secret)
# See https://wilsonmar.github.io/mac-setup/#GitSecret

   # This script detects whether secrets are stored various ways:
   # This is https://github.com/AGWA/git-crypt      has 4,500 stars.
   # Whereas https://github.com/sobolevn/git-secret has 1,700 stars.

if [ -d "$HOME/.gitsecret:?}" ]; then   # found directory folder in repo
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
   fi  # .gitsecret
fi



### 28. Pipenv and Pyenv to install Python and its modules

# See https://wilsonmar.github.io/mac-setup/#Pipenv
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
# pipenv_install # call function defined above.



### 29. Connect to Google Cloud, if requested:

# See https://wilsonmar.github.io/mac-setup/#GCP
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

   if [ "${SHOW_VERBOSE}" = true ]; then
      h2 "gcloud info and versions ..."
      gcloud info
      gcloud version
         # git: [git version 2.11.0]
         docker --version  # Docker version 19.03.5, build 633a0ea838
         kubectl version --short
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
   curl -O -s "https://raw.githubusercontent.com/wilsonmar/DevSecOps/main/gcp/gcp-speech-to-text/request.json"
   cat request.json
   # Listen to it at: https://storage.cloud.google.com/speech-demo/brooklyn.wav
   
   curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json \
      "https://speech.googleapis.com/v1/speech:recognize?key=${GOOGLE_API_KEY}" > result.json
   cat result.json

# exit  # in dev

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


### 30. Connect to AWS

# See https://wilsonmar.github.io/mac-setup/#AWS
if [ "${USE_AWS_CLOUD}" = true ]; then   # -aws

   if [ "${PACKAGE_MANAGER}" = "brew" ]; then

      # For aws-cli commands, see http://docs.aws.amazon.com/cli/latest/userguide/ 
      if ! command -v aws >/dev/null; then
         h2 "brew install awscli ..."
         brew install awscli
      # TODO: else if -U 
      fi
      note "$( aws --version )"  # aws-cli/2.6.1 Python/3.9.12 Darwin/21.4.0 source/arm64 prompt/off
                     # previously: aws-cli/2.0.9 Python/3.8.2 Darwin/19.5.0 botocore/2.0.0dev13
      note "which aws at $( which aws )"  # /usr/local/bin/aws

      # h2 "aws version ..."  
      # SHELL TECHNIQUE: any error results in a long extraneous list, so send the err output to a file
      # so the first lines are visible. That file is then deleted.
      # TODO: Capture so not exit CLI
      #aws version 2>aws-err-response.txt
      #head -12 aws-err-response.txt
      #rm aws-err-response.txt
      if [ "${USE_K8S}" = true ]; then   # -k8s
         brew install eksctl
      fi

      if [ "${RUN_EKS}" = true ]; then   # -eks
         # TODO: USE_K8S
         # FIXME: fatal error: runtime: bsdthread_register error
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
      fi  # USE_EKS


      if [ "${RUN_VIRTUALENV}" = true ]; then   # -venv
         # awscli requires Python3
         # See https://docs.aws.amazon.com/cli/latest/userguide/cli-install-macos.html#awscli-install-osx-pip
         # PYTHON3_INSTALL  # function defined at top of this file.
         # :  # break out immediately. Not execute the rest of the if strucutre.
         # TODO: https://github.com/bonusbits/devops_bash_config_examples/blob/master/shared/.bash_aws

         h2 "-pipenv install awscli ..."
         if ! command -v pipenv >/dev/null; then
            brew install pipenv 
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
      fi  # RUN_VIRTUALENV

   fi  # "${PACKAGE_MANAGER}" = "brew" ]; then


   h2 "-aws config verification ..."
   if [ -z "${AWS_DEFAULT_REGION}" ]; then
      error "-AWS_DEFAULT_REGION var not defined ..."
   else
      note "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} var"
   fi

   if [ ! -f "$HOME/.aws/config" ]; then  # file NOT exists:
      error "-aws folder $HOME/.aws/config not found ..."
   else
      note "-aws $HOME/.aws/config contains:"
      #if [ "${SHOW_DEBUG}" = true ]; then
         note $( cat "$HOME/.aws/config" )
           # region = us-east-1
      #fi
      
   fi

   if [ -z "${AWS_ACCOUNT_ID}" ]; then
      error "-AWS_ACCOUNT_ID (INFO) var not defined ..."
   else
      note "AWS_ACCOUNT_ID=${AWS_ACCOUNT_ID} for manual https://aws.amazon.com/ console login"
      # PROTIP: This is not the preferred / secure approach.
   fi

   # TODO: Instead, Obtain credentials from a Vault.
   h2 "-aws credentials verification ..."
   # PROTIP: Prefer to use local variables:
   # See https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
   USE_AWS_CREDS=false
   if [ -z "${AWS_ACCESS_KEY_ID}" ]; then
      error "Required AWS_ACCESS_KEY_ID var not defined ..."
      USE_AWS_CREDS=true
   else
      note "AWS_ACCESS_KEY_ID var found. Not displayed for security"
         # [default]
         # aws_access_key_id = xxxx
         # aws_secret_access_key = xxxx
   fi
   if [ -z "${AWS_SECRET_ACCESS_KEY}" ]; then
      error "Required AWS_SECRET_ACCESS_KEY var not defined ..."
      USE_AWS_CREDS=true
   else
      note "AWS_SECRET_ACCESS_KEY var found. Not displayed for security"
   fi

   if [ "${USE_AWS_CREDS}" = true ]; then
      if [ ! -f "$HOME/.aws/credentials" ]; then  # file NOT exists:
         fatal "-aws folder $HOME/.aws/credentials not found ..."
         exit
      else
         note "-aws $HOME/.aws/credentials found ..."
         # WARNING: Do not violate security policy: not display credentials (especially for root accounts)
         # See https://wilsonmar.github.io/aws-onboarding
            # [default]
            # aws_access_key_id = 1234567674N4L4R3EVHC
            # aws_secret_access_key = 1234567q3KVzhRHjFrK4PXerAEbn9e4SLRNc93d/      
      fi
   fi

   # https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/describe-vpcs.html
   RESULT=$( aws ec2 describe-vpcs )
   if [[ "${RESULT}" == *"An error occured"* ]]; then
      h2 "-aws error ec2 describe-vpcs"
      error "${RESULT}"
         # An error occurred (AuthFailure) when calling the DescribeVpcs operation: AWS was not able to validate the provided access credentials
   else
      note "-aws ec2 describe-vpcs is good to go"
   fi
echo "DEBUG entering aws";exit

   h2 "-aws is good to use if this runs:"
   # Manually https://aws.amazon.com/


   #if [ -d "$HOME/.bash-my-aws:?}" ]; then   # folder is there
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




fi  # USE_AWS_CLOUD

echo "DEBUG before steampipe";exit



### 30b. steampipe for aws

if [ "${USE_STEAMPIPE}" = true ]; then  # -steampipe

   h2 "-steampipe ..."
   if [ "${PACKAGE_MANAGER}" = "brew" ]; then
   # CAUTION: Password required:
      brew tap turbot/tap
         # Cloning into /usr/local/Homebrew/Library/Taps/turbot/homebrew-tap
      if ! command -v steampipe >/dev/null; then  # command not found, so:
         brew install steampipe
      else  # installed already:
         if [ "${UPDATE_PKGS}" = true ]; then
            h2 "-U brew upgrade steampipe ..."
            brew upgrade steampipe
         fi
      note "$( steampipe -v )"
      # additional components are installed the first time steampipe query is run.
      fi #
   fi 

   # https://steampipe.io/docs
   if [ "${USE_AWS_CLOUD}" = true ]; then  # -aws

      # Steampipe Mods are collections of named queries, codified controls that can be used to test current configuration of your cloud resources against a desired configuration, and dashboards that organize and display key pieces of information.
      # See https://steampipe.io/docs/mods/overview
      # TODO: How to tell if plugin is already installed?
         steampipe plugin install aws
            # Installed plugin: aws@latest v0.121.1
            # Documentation:    https://hub.steampipe.io/plugins/turbot/aws
         # TODO: else steampipe plugin update aws
         # note "-U install AWS plug-in at $PWD ..."

      # List of mods at: https://hub.steampipe.io/mods/turbot/aws_insights
      note "-steampipe at $PWD before git clone ..."

      # Dashboards are available for 15+ services, including CloudTrail, EC2, IAM, RDS, S3, VPC, and more!
     if [ "${CLONE_GITHUB}" = true ]; then  # -c
         if [ -d "steampipe-mod-aws-compliance" ]; then  # file exists:
            note "-steampipe clone aws-compliance ..."
            git clone https://github.com/turbot/steampipe-mod-aws-compliance.git
         fi  # steampipe-mod-aws-compliance

         if [ -d "steampipe-mod-aws-insights" ]; then  # file exists:
            note "-steampipe clone aws-insights ..."
            git clone https://github.com/turbot/steampipe-mod-aws-insights.git
         fi
      fi
      note "-steampipe at $PWD after git clone ..."
      cd steampipe-mod-aws-compliance
      ls -ltaT

      # After mod file installed:
      # TODO: QUESTION: What is being checked?
      # TODO: QUESTION: Can checking be limited to a several level (just critical)
      # TODO: QUESTION: should check all run without AWS?
      # TODO: QUESTION: Limit output to only errors?
      if [ -z "${OUTPUT_FILENAME}" ]; then   # -of empty/not specified:
         OUTPUT_FILENAME=$( date +%Y-%m-%dT%H:%M:%S%z)-$((1 + RANDOM % 1000))
      fi
      note "-steampipe check all (to file, takes many minutes) to $OUTPUT_FILENAME ..."
      time steampipe check all > "$OUTPUT_FILENAME"
         # Initializing
         # ⠸ Running 9687 controls. (41 complete, 10 running, 9590 pending, 46 errors)
         # steampipe check all  166.60s user 46.88s system 19% cpu 18:33.20 total
      note $( ls "$OUTPUT_FILENAME" )

echo "found DEBUG";exit

         # cd steampipe-mod-aws-insights



: ' 
      # https://hub.steampipe.io/mods/turbot/aws_insights/dashboards
      # Before running any dashboards, generate your AWS credential report:
      aws iam generate-credential-report
      # if
         steampipe dashboard
'
   fi  # USE_AWS_CLOUD

   # Enter interactive mode:
   steampipe query

: '
   .tables
   
   .inspect aws_iam_role
   select name from aws_iam_role

   select
   r.name,
   policy_arn,
   p.is_aws_managed
   from
   aws_iam_role as r,
   jsonb_array_elements_text(attached_policy_arns) as policy_arn,
   aws_iam_policy as p
   where
   p.arn = policy_arn
   and p.is_aws_managed;
'

fi  # USE_STEAMPIPE



### 31. Install Azure

# See https://wilsonmar.github.io/mac-setup/#Azure
if [ "${USE_AZURE_CLOUD}" = true ]; then   # -azure

   do_install_azure(){
      # https://hossted.com/knowledge-base/using-homebrew-to-set-up-your-environment-kubectl-azure-cli/
     if [ "${DOWNLOAD_INSTALL}" = true ]; then   # -azure

         # TODO: Create in a function:
         AZURE_RESC_GROUP="rg-name"
         AZURE_RESC_NAME="rg-name"
         AZURE_WORKSPACE="my-workspace"
         AZURE_LOCATION="my-location"

         if [ "${PACKAGE_MANAGER}" = "brew" ]; then
            if command -v az >/dev/null; then  # found:
               az upgrade
               brew upgrade azure-cli
               az config set auto-upgrade.enable=yes
            else
               # https://docs.microsoft.com/cli/azure/overview
               # https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-macos
               brew install azure-cli
                  # Creates  ~/.azure
                  # Installs python@3.10, gdbm, openssl@1.1, readline, sqlite, xz, zlib
               # On Apple Silicon add to ~/.zshrc :
               # autoload bashcompinit && bashcompinit
               # source $(brew --prefix)/etc/bash_completion.d/az
               # See https://docs.microsoft.com/en-us/cli/azure/keyvault/secret?view=azure-cli-latest
               #note "TODO: Add Azure cloud coding ..."
               
               # brew install --cask azure-data-studio
                  # TODO: Error: azure-data-studio: It seems the App source '/Users/wilsonmar/Applications/Azure Data Studio.app' is not there.
                  # ==> Moving App 'Azure Data Studio.app' to '/Users/wilsonmar/Applications/Azure Data Studio.app'.
                  # ==> Linking Binary 'code' to '/usr/local/bin/azuredatastudio'

               # https://docs.microsoft.com/en-us/azure/key-vault/about-keys-secrets-and-certificates

               # https://github.com/Azure/homebrew-functions
               brew tap azure/functions
               brew install azure-functions-core-tools
               
               # See https://wilsonmar.github.io/azure-quickly#azcopy
               brew install azcopy

               # See https://wilsonmar.github.io/quantum
               if [ "${RUN_QUANTUM}" = true ]; then  # -quantum
                  note "az extension add --upgrade -n quantum ..."
                  az extension add --upgrade -n quantum
                  # CLI described at https://learn.microsoft.com/en-us/azure/quantum/install-overview-qdk?tabs=tabid-vscode%2Ctabid-conda#azure-cli

                  note "pip install ..."
                  pip install --upgrade azure-quantum
                  # For submitting a circuit with Qiskit
                  pip install --upgrade azure-quantum[qiskit]
                  pip install --upgrade azure-quantum[cirq]
               fi
            fi  # command -v az
         fi  # PACKAGE_MANAGER
      fi  # DOWNLOAD_INSTALL
   }
   # do_install_azure

   azure_login(){
      # See https://learn.microsoft.com/en-us/cli/azure/?view=azure-cli-latest#az_login
      if [ -n "${ARM_TENANT_ID}" ]; then  # not found or blank
         fatal "-azure ARM_TENANT_ID not defined. az login ..."
         az login
      else         
         note "-azure login with ARM_TENANT_ID ..."
         az login --tenant "${ARM_TENANT_ID}"
      fi
      # Pop up web page to login.

      if [ -n "${ARM_SUBSCRIPTION_ID}" ]; then  # not found or blank
         fatal "-azure ARM_SUBSCRIPTION_ID not defined. Exiting..."
         exit 9
      else
         note "-azure account set to ${ARM_SUBSCRIPTION_ID} ..."
         az account set --subscription "${ARM_SUBSCRIPTION_ID}"
      fi
   }
   # azure_login

   build_azure_location(){
      mylocation=$1
      # TODO:
      export AZURE_LOCATION=$mylocation
      note "AZURE_LOCATION=$AZURE_LOCATION ..."
   }
   # build_azure_location

   build_azure_resc_group(){
      mygroup=$1
      h2 "build az resc $1 ..."
      # TODO:
      export AZURE_RESC_GROUP=$mygroup
      note "AZURE_RESC_GROUP=$AZURE_RESC_GROUP ..."
   }
   # build_azure_resc_group

   build_azure_resc(){
      myresource3=$1
      h2 "build az resc $1 ..."
      # TODO:
      export AZURE_RESC_NAME=$myresource
      note "AZURE_RESC_NAME=$AZURE_RESC_NAME ..."
   }
   # build_azure_resc

   build_azure_workspace(){
      myworkspace=$1
      # https://hossted.com/knowledge-base/using-homebrew-to-set-up-your-environment-kubectl-azure-cli/
      h2 "build az workspace $1 ..."

      note "AZURE_WORKSPACE=$AZURE_WORKSPACE ..."
      note "AZURE_RESC_GROUP=$AZURE_RESC_GROUP ..."
      note "AZURE_WORKSPACE=$AZURE_WORKSPACE ..."
      note "AZURE_LOCATION=$AZURE_LOCATION ..."

      # TODO:
      export AZURE_WORKSPACE=$myworkspace

      note "az quantum workspace list ..."
      az quantum workspace list
         # The command requires the extension quantum. It will be installed first.
      # https://learn.microsoft.com/en-us/azure/quantum/how-to-submit-jobs?pivots=ide-azurecli

      note "az quantum workspace show ..."
      az quantum workspace show -g "${AZURE_RESC_GROUP}" \
         -w "${AZURE_WORKSPACE}" -l "${AZURE_LOCATION}" -o table
         #   Provider      Target-id    Current Availability  Average Queue Time (seconds)
         # ------------  -------------  --------------------  ------------------------------
         # ionq          ionq.qpu       Available             510467

      note "az quantum workspace set ..."
      az quantum workspace set -g "${AZURE_RESC_GROUP}" \
         -w "${AZURE_WORKSPACE}" -l "${AZURE_LOCATION}" -o table
   }
   # build_azure_workspace 

   logout_azure(){
      if [ "${DELETE_CONTAINER_AFTER}" = true ]; then  # -D
         h2 "az logout ..."
         az logout
      fi
   }
   # logout_azure

fi  # USE_AZURE_CLOUD


### 32. Install K8S minikube

# See https://wilsonmar.github.io/mac-setup/#Minikube
if [ "${USE_K8S}" = true ]; then  # -k8s
   h2 "brew install Kubernetes IBM/RedHat OpenShift:"
   brew install openshift-cli

   h2 "-k8s means minkube locally ..."

   # See https://kubernetes.io/docs/tasks/tools/install-minikube/
   RESPONSE="$( sysctl -a | grep -E --color 'machdep.cpu.features|VMX' )"
   if [[ "${RESPONSE}" == *"VMX"* ]]; then  # contains it:
      note "VT-x feature needed to run Kubernetes is available!"
   else
      fatal "VT-x feature needed to run Kubernetes is NOT available!"
      exit 9
   fi

   # TODO: https://www.freecodecamp.org/news/how-to-set-up-a-serious-kubernetes-terminal-dd07cab51cd4/

   if [ "${DOWNLOAD_INSTALL}" = true ]; then  # -I
      if [ "${PACKAGE_MANAGER}" = "brew" ]; then
         if ! command -v minikube >/dev/null; then  # command not found, so:
            # See https://minikube.sigs.k8s.io/docs/start/
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

      # See https://minikube.sigs.k8s.io/docs/start/
      # Run Docker
      KUBE_VERSION="1.23.3"
      h2 "minikube start with ${KUBE_VERSION} ..."
      time minikube start --driver=docker --kubernetes-version="${KUBE_VERSION}"
         # 😄  minikube v1.25.2 on Darwin 12.3.1 (arm64)
         # ✨  Automatically selected the docker driver. Other choices: ssh, podman (experimental)
         # 👍  Starting control plane node minikube in cluster minikube
         # 🚜  Pulling base image ...
         # 💾  Downloading Kubernetes v1.23.3 preload ...
         #     > preloaded-images-k8s-v17-v1...: 419.07 MiB / 419.07 MiB  100.00% 10.90 Mi
         #     > gcr.io/k8s-minikube/kicbase: 343.12 MiB / 343.12 MiB  100.00% 7.79 MiB p/
         # 🔥  Creating docker container (CPUs=2, Memory=4000MB) .../ 
         # 🐳  Preparing Kubernetes v1.23.3 on Docker 20.10.12 ...
         #     ▪ kubelet.housekeeping-interval=5m
         #     ▪ Generating certificates and keys ...
         #     ▪ Booting up control plane ...
         #     ▪ Configuring RBAC rules ...
         # 🔎  Verifying Kubernetes components...
         #     ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
         # 🌟  Enabled addons: storage-provisioner, default-storageclass
         # 🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
         # minikube start  1.80s user 1.11s system 17% cpu 17.048 total      
      minikube status
         # minikube
         # type: Control Plane
         # host: Running
         # kubelet: Running
         # apiserver: Running
         # kubeconfig: Configured

      kubectl get nodes
          # NAME       STATUS   ROLES                  AGE   VERSION
          # minikube   Ready    control-plane,master   30m   v1.23.3

      # Switch context to the minikube cluster (if it isn’t already):
      #kubectl config use-context minikube

      KUBE_DEPLOY_NAME="hello-minkiube"
      h2 "Create a ${KUBE_DEPLOY_NAME} deployment of echoserver with port 8080 ..."
      kubectl create deployment "${KUBE_DEPLOY_NAME}" --image=k8s.gcr.io/echoserver:1.4
         # Response: deployment.apps/hello-minikube created
         # TODO: error: failed to create deployment: deployments.apps "hello-minikube" already exists
      kubectl expose deployment "${KUBE_DEPLOY_NAME}" --type=NodePort --port=8080
          # Reponse: service/hello-minikube exposed

      # It may take a moment, but your deployment will soon show up when you run:
      kubectl get services hello-minikube
         # NAME             TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
         # hello-minikube   NodePort   10.101.75.182   <none>        8080:32486/TCP   29s

      # ps
         # 28282 ttys003    0:01.34 /opt/homebrew/bin/kubectl --context minikube proxy --port 0
   
      # h2 "Create tunnel (locking up Terminal window) to ensure load balancer services are allocated external IPs on minikube."
      #minikube tunnel
         # ✅  Tunnel successfully started
         # 📌  NOTE: Please do not close this terminal as this process must stay alive for the tunnel to be accessible ...
   
      minikube service "${KUBE_DEPLOY_NAME}" --url
      # See https://minikube.sigs.k8s.io/docs/handbook/accessing
      # Let minikube launch a web browser:
      
      #minikube service "${KUBE_DEPLOY_NAME}"
      # Alternatively, use kubectl to forward the port:
      kubectl port-forward service/hello-minikube 7080:8080
         # Forwarding from 127.0.0.1:7080 -> 8080
         # Forwarding from [::1]:7080 -> 8080
      # Your application should now available at http://localhost:7080/
      # FIXME: But it's not.

      # if NOT delete:
         h2 "Stop to restart the same cluster to continue work ..."
         minikube stop
            # ✋  Stopping node "minikube"  ...
            # 🛑  Powering off "minikube" via SSH ...
            # 🛑  1 node stopped.
#      else
         h2 "Fully re-create your cluster from scratch for some reason, you can delete it ..."
         minikube delete
            # 🔥  Deleting "minikube" in docker ...
            # 🔥  Removing /Users/wilsonmar/.minikube/machines/minikube ...
            # 💀  Removed all traces of the "minikube" cluster.

   fi  # DOWNLOAD_INSTALL

fi  # USE_K8S


### 33. Install EKS using eksctl

# See https://wilsonmar.github.io/mac-setup/#EKS
if [ "${RUN_EKS}" = true ]; then  # -EKS

   h2 "kubectl ${MACHINE_TYPE} client install ..."
   if [ "${PACKAGE_MANAGER}" = "brew" ]; then
      note $( brew info kubectl )
      # Avoid this need to specify version all the time, badly recommended
      # at https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/
      #      if [[ "${MACHINE_TYPE}" == *"arm64"* ]]; then
      #         curl -LO "https://dl.k8s.io/release/v1.24.0/bin/darwin/arm64/kubectl"
      #      else  # Intel
      #         curl -LO "https://dl.k8s.io/release/v1.24.0/bin/darwin/amd64/kubectl"
      #      fi
      # Use Homebrew instead of https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html
      # See https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
      # to communicate with the k8s cluster API server. 
      if [ "${PACKAGE_MANAGER}" = "brew" ]; then # -U
         if ! command -v kubectl >/dev/null; then  # not found:
         h2 "kubectl install ..."
            brew install kubectl
         else  # installed already:
            if [ "${UPDATE_PKGS}" = true ]; then
               h2 "Brew upgrading kubectl ..."
               note "kubectl before upgrade = $( kubectl version --short --client )"  # Client Version: v1.16.6-beta.0
               brew upgrade kubectl
            fi
         fi
         RESPONSE="$( kubectl version --short --client )"
            # Flag --short has been deprecated, and will be removed in the future. The --short output will become the default.
            # Client Version: v1.24.0
            # Kustomize Version: v4.5.4
         KUBECTL_VERSION="v1.24.0"  # CAUTION: HARD CODED!

         # iam-authenticator

         h2 "eksctl install ..."
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
      fi  # PACKAGE_MANAGER
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

fi  # EKS


### 34. Use Docsify to create a website from Markdown files

# See https://wilsonmar.github.io/mac-setup/#Docsify
if [ "${USE_DOCSIFY}" = true ]; then   # -docsify
   # Video of run at https://drive.google.com/file/d/17-mV8Q_cyIKDj9aNm8wXXYHm6yuwITqi/view?usp=drive_link
   # See https://docsify.js.org/#/quickstart
   if [ "${DOWNLOAD_INSTALL}" = true ]; then  # -I
      h2 "Installing Docsify to npm global folder ..."
      npm i docsify-cli -g
         # RESPONSE: added 205 packages in 10s
   fi
   
   if [ "${DELETE_BEFORE}" = false ]; then  # NOT -d
      # Based on https://stackoverflow.com/questions/16807876/how-to-check-if-another-instance-of-my-shell-script-is-running
      for pid in $(pidof -x docsify); do  # in case of multiple instances:
         if [ $pid != $$ ]; then
            warning "docsify process is already running as PID $pid. Using it..."
            if [ "${OPEN_APP}" = true ]; then   # -o
               warning "Opening http://localhost:3000 ..."
               open http://localhost:3000
               break  # out of for loop
            fi
         fi
      done
   else  # -delete process before run:
      for pid in $(pidof -x docsify); do
         if [ $pid != $$ ]; then
            warning "docsify process is already running as PID $pid, so killing it ..."
            pidof -k docsify
            break  # out of for loop
         fi
      done
   fi  # DELETE_BEFORE

   if [ "${OPEN_APP}" = true ]; then   # -o
      note "Opening http://localhost:3000 before starting server ..."
      # because the Terminal window will be locked up by the server in the next command
      open http://localhost:3000
   fi
   PROJECT_FOLDER_PATH="${PROJECT_FOLDER_PATH}/${PROJECT_FOLDER_NAME}"
   cd "${PROJECT_FOLDER_PATH}"
   if [ "${SHOW_VERBOSE}" = true ]; then
      note "At $(pwd)"
      note "$( ls -ltaT )"

      note "${PROJECT_FOLDER_PATH}/docs"
      note "$( ls -ltaT docs )"
   fi

   h2 "npm install docsify ..."
   npm install
   
   h2 "npm start docsify ..."
   npm start

   # Browser will refresh when the server starts?

   if [ "${DELETE_CONTAINER_AFTER}" = true ]; then  # -D
      note "Removing project folder \"${PROJECT_FOLDER_FULL_PATH}\" ..."
      rm -rf "${PROJECT_FOLDER_FULL_PATH}"   
   fi

fi  # USE_DOCIFY


### 35. Use CircleCI SaaS

# See https://wilsonmar.github.io/mac-setup/#CircleCI
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
      ls -ltaT "$HOME/.circleci/config.yml"
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


### 36. Use Yubikey

# See https://wilsonmar.github.io/mac-setup/#Yubikey
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


#### 37. Use GitHub

# See https://wilsonmar.github.io/mac-setup/#UseGitHub
if [ "${MOVE_SECURELY}" = true ]; then   # -m
   # See https://github.com/settings/keys 
   # See https://github.blog/2019-08-14-ssh-certificate-authentication-for-github-enterprise-cloud/

   pushd  "$HOME/.ssh"
   h2 "At temporary $PWD with VAULT_USERNAME=${VAULT_USERNAME}"
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
      note "$( ls -ltaT "${LOCAL_SSH_KEYFILE}" )"
   fi  # LOCAL_SSH_KEYFILE

fi  # MOVE_SECURELY



### 39. Use Hashicorp Vault

# See https://wilsonmar.github.io/mac-setup/#HashiVault
export USE_ALWAYS=false  # DEBUGGING
if [ USE_ALWAYS = true ]; then
# if [ "${USE_ALWAYS}" = false ]; then   # -HV

   if [ "${USE_VAULT}" = false ]; then   # -HV

      # STEP: Paste locally generated public key in GitHub UI:
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
      note "$( ls -ltaT "${VAULT_CA_KEY_FULLPATH}" )"

  else  # USE_VAULT = true

      # Instead of pbcopy and paste in GitHub.com GUI, obtain and use SSH certificate from a SSH CA:
      if [ -z "${VAULT_CA_KEY_FULLPATH}" ]; then  # is not empty
         VAULT_CA_KEY_FULLPATH="./ca_key"  # "~/.ssh/ca_key"  # "./ca_key" for current (project) folder  
      fi
      
      # STEP: Call Vault to sign public key and return it as a cert:
      h2 "Signing user ${GITHUB_ACCOUNT_NAME} public key file ${LOCAL_SSH_KEYFILE} ..."
      ssh-keygen -s "${VAULT_CA_KEY_FULLPATH}" -I "${GITHUB_ACCOUNT_NAME}" \
         -O "extension:login@github.com=${GITHUB_ACCOUNT_NAME}" "${LOCAL_SSH_KEYFILE}.pub"
         # RESPONSE: Signed user key test-ssh-cert.pub: id "wilson-mar" serial 0 valid forever

      SSH_CERT_PUB_KEYFILE="${LOCAL_SSH_KEYFILE}-cert.pub"
      if [ ! -f "${SSH_CERT_PUB_KEYFILE}" ]; then  # not exists
         error "File ${SSH_CERT_PUB_KEYFILE} not found ..."
      else
         note "File ${SSH_CERT_PUB_KEYFILE} found ..."
         note "$( ls -ltaT ${SSH_CERT_PUB_KEYFILE} )"
      fi
      # According to https://help.github.com/en/github/setting-up-and-managing-organizations-and-teams/about-ssh-certificate-authorities
      # To issue a certificate for someone who has different usernames for GitHub Enterprise Server and GitHub Enterprise Cloud, 
      # you can include two login extensions:
      # ssh-keygen -s ./ca-key -I KEY-IDENTITY \
      #    -O extension:login@github.com=CLOUD-USERNAME extension:login@
   fi  # USE_VAULT

   if [ "${USE_VAULT}" = false ]; then   # -HV
      h2 "Use GitHub extension to sign user public key with 1d Validity for ${GITHUB_ACCOUNT_NAME} ..."
      ssh-keygen -s "${VAULT_CA_KEY_FULLPATH}" -I "${GITHUB_ACCOUNT_NAME}" \
         -O "extension:login@github.com=${GITHUB_ACCOUNT_NAME}" -V '+1d' "${LOCAL_SSH_KEYFILE}.pub"
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

fi  # USE_ALWAYS, USE_VAULT



### 40. Install Hashicorp Vault

# See https://wilsonmar.github.io/hashicorp-vault
# See https://wilsonmar.github.io/mac-setup/#UseHashiVault
if [ "${USE_VAULT}" = true ]; then   # -HV

   h2 "-HV (HashicorpVault) being used ..."
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
   fi  # PACKAGE_MANAGER

   # Notice shell scripting technique to get 2nd column from "Vault v1.3.4"
   RESPONSE="$( vault --version | cut -d' ' -f2 )"
   export VAULT_VERSION="${RESPONSE:1}"   # remove first character.
   note "VAULT_VERSION=$VAULT_VERSION"   # Example: 1.10.1
   # Shell file .zshrc will load CLI completion for Vault

   # 40b. -golang RUN_GOLANG
   if [ "${RUN_GOLANG}" = true ]; then  # -golang
      if [ "${PACKAGE_MANAGER}" = "brew" ]; then
         h2 "Installing govaultenv ..."
         # https://github.com/jamhed/govaultenv  RUN_GOLANG
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
      fi  # Brew
   fi  # RUN_GOLANG

   
   # 40c. Define VAULT_ADDR from VAULT_HOST
   if [ -z "${VAULT_HOST}" ]; then  # it's blank:
      export VAULT_HOST="localhost"
      note "VAULT_HOST=localhost by default (not specified) ..."
      export VAULT_ADDR="http://${VAULT_HOST}:8200"
   fi

   if [ -n "${VAULT_HOST}" ]; then  # var filled
      if ping -c 1 "${VAULT_HOST}" &> /dev/null ; then 
         note "ping of ${VAULT_HOST} went fine."
      else
         error "${VAULT_HOST} ICMP ping failed. Aborting ..."
         info  "Is VPN (GlobalProtect) enabled for your account?"
         exit
      fi
   else 
      fatal "No VAULT_HOST, no VAULT_ADD, no work!"
      exit
   fi  # VAULT_HOST


   ### 40d. Obtain Vault Status

   # TODO: use production ADDR from secrets
   export VAULT_ADDR="https://${VAULT_HOST}:8200"
   note "VAULT_ADDR=${VAULT_ADDR} ..."

   if [ "${SHOW_DEBUG}" = true ]; then
      if [ -n "${VAULT_ADDR}" ]; then  # filled
   
            # Output to JSON instead & use jq to parse?
            # See https://stackoverflow.com/questions/2990414/echo-that-outputs-to-stderr
         h2 "vault status ${VAULT_ADDR} ..."
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
   fi  # SHOW_VERBOSE


   # 40e. Run Test Vault server
   if [ "${USE_TEST_SERVER}" = true ]; then   # -ts

      # If vault process is already running, use it:
      PS_NAME="vault"
      PSID=$( pgrep -l vault )
      note "Test PSID=$PSID"

      if [ -n "${PSID}" ]; then  # does not exist:
         h2 "Start up local Vault ..."
         # CAUTION: Vault dev server is insecure and stores all data in memory only!

         if [ "${DELETE_BEFORE}" = true ]; then  # -d 
            note "Stopping existing vault local process ..."  # https://learn.hashicorp.com/vault/getting-started/dev-server
            ps_kill "${PS_NAME}"  # bash function defined in this file.
         fi

         note "Starting $VAULT_ADDR ..."  # https://learn.hashicorp.com/vault/getting-started/dev-server
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

      else  # USE_TEST_SERVER}" = true
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

         export SSH_USER_ROLE="${GITHUB_USER_EMAIL}"
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
         if [ "${SHOW_DEBUG}" = true ]; then  # -vv
            code "${SSH_ROLE_FILENAME}"
         fi

         h2 "Create user role ${SSH_USER_ROLE} with GH mapping ..."
         vault write "${SSH_CLIENT_SIGNER_PATH}/roles/${SSH_USER_ROLE}" "@${SSH_ROLE_FILENAME}"

      fi  # PSID for vault exists
   fi  # USE_TEST_SERVER


   # 40f. Vault Server Username
   # on either test or prod Vault instance:
   # export VAULT_USERNAME="devservermode"  # custom specified
   if [ -n "${VAULT_USERNAME}" ]; then  # is not empty
      h2 "VAULT_USERNAME=${VAULT_USERNAME}  (token hidden for security)"
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

      h2 "pushd into ~/.ssh"
      pushd  "$HOME/.ssh"
      h2 "At temporary $PWD ..."
      if [ "${SHOW_DEBUG}" = true ]; then  # -vv
         note "$( ls -ltaT )"
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
   else
      h2 "No VAULT_USERNAME"
   fi  # VAULT_USERNAME
fi  # USE_VAULT


### TODO: 41. Put secret in Hashicorp Vault

# See https://wilsonmar.github.io/mac-setup/#PutInHashiVault
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



### 50. Install NodeJs

# See https://wilsonmar.github.io/mac-setup/#InstallNode
if [ "${NODE_INSTALL}" = true ]; then  # -js

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
         if [ -f "properties.json " ]; then
            note "npm install ..."
               npm install   # based on properties.json
            note "npm audit fix ..."
               npm audit fix
         fi
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
   # replace_1config "conf" "MAIL_USER" "${GITHUB_USER_EMAIL}"  # from 123
   # replace_1config "conf" "MAIL_HOST" "${GITHUB_USER_EMAIL}"  # from smpt.mailtrap.io
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



### 52. Install Virtualenv

   # See https://wilsonmar.github.io/mac-setup/#Virtualenv
   # See https://wilsonmar.github.io/pyenv/
   if [ "${RUN_VIRTUALENV}" = true ]; then  # -V  (not the default pipenv)

      if [ "${PACKAGE_MANAGER}" = "brew" ]; then # -U
         h2 "brew install -python"
         if ! command -v python3 ; then
            h2 "Installing python3 ..."
            brew install python3
         fi

         # See https://wilsonmar.github.io/pyenv/
         # to create isolated Python environments.
         #pipenv install virtualenvwrapper
         if ! command -v virtualenv ; then
            h2 "brew install virtualenv"  # https://levipy.com/virtualenv-and-virtualenvwrapper-tutorial
            brew install virtualenv
         fi

      elif [ "${PACKAGE_MANAGER}" = "apt-get" ]; then
         silent-apt-get-install "python3"
      fi
      note "$( python3 --version )"    # Python 3.8.9
      note "$( virtualenv --version )" # virtualenv 20.14.1 from /opt/homebrew/Cellar/virtualenv/20.14.1/libexec/lib/python3.10/site-packages/virtualenv/__init__.py
      note "$( pip3 --version )"       # pip 19.3.1 from /Library/Python/2.7/site-packages/pip (python 2.7)

         if [ -d "venv:?}" ]; then   # venv folder already there:
            note "venv folder being re-used ..."
         else
            h2 "virtualenv venv ..."
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


### 53. Configure Pyenv with virtualenv

# See https://wilsonmar.github.io/mac-setup/#VirtualPyenv
if [ "${USE_PYENV}" = true ]; then  # -pyenv

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


### 54. Install MiniConda (Anaconda has too many unknown vulnerabilities)

install_miniconda(){
# See https://wilsonmar.github.io/mac-setup/#Conda
# See https://betterprogramming.pub/how-to-use-miniconda-with-python-and-jupyterlab-5ce07845e818
if [ "${RUN_CONDA}" = true ]; then  # -conda

   h2 "-conda RUN_CONDA "
   if [ "${PACKAGE_MANAGER}" = "brew" ]; then # -U
      if ! command -v conda ; then
         h2 "brew install miniconda ..."
         brew install miniconda
      fi
   fi

   note "$( conda --version )"  # conda 4.11.0
   if [ "${SHOW_DEBUG}" = true ]; then
      note "$( conda info )"
      #      active environment : base
      #     active env location : /opt/homebrew/Caskroom/miniconda/base
      #             shell level : 1
      #        user config file : /Users/wilsonmar/.condarc
      #  populated config files : 
      #           conda version : 4.11.0      
   fi
   #export PREFIX="/usr/local/anaconda3"
   #export   PATH="/usr/local/anaconda3/bin:$PATH"
   # -vv
   # note "PATH=$( $PATH )"

   conda init zsh
      # no change     /opt/homebrew/Caskroom/miniconda/base/condabin/conda
   # stop and restart shell

   # TODO: Define in parameters
   export PYTHON_VER="3.9"
   export CONDA_ENV="jpy39"

   RESPONSE="$( conda info --envs )"
         # conda environments: 
         # base                  *  /opt/homebrew/Caskroom/miniconda/base   fi
         # jpy39                 *  /opt/homebrew/Caskroom/miniconda/base/envs/jpy39
   if [[ "${RESPONSE}" == *"${CONDA_ENV}"* ]]; then  # contains it:
      echo "using whatever"
   else
      # Creating CONDA_ENV=${CONDA_ENV} with PYTHON_VER=${PYTHON_VER}"
      # conda create -name PDSH python==3.9 --file requirements.txt
      yes | conda create --name "${CONDA_ENV}" python="${PYTHON_VER}"
      # conda create -name tf tensorflow
   fi
   conda activate "${CONDA_ENV}"
      # (jyp39) should show above the prompt.
   

   # Check if already installed:
   RESPONSE="$( conda list )"
      # For the latest: conda install numpy -n base -c conda-forge
   if [[ "${RESPONSE}" != *"numpy"* ]]; then  # NOT contains it:
      note "$( yes | conda install numpy )"
                   # conda remove  numpy -n base -c conda-forge
      # To use env in a Jupyter notebook:
   fi
   if [[ "${RESPONSE}" != *"ipykernel"* ]]; then  # NOT contains it:
      yes | conda install ipykernel
   fi

   # TODO: Check if needed:
   python -m ipykernel install --user --name "${CONDA_ENV}" --display-name "${CONDA_ENV} environment"
      # Installed kernelspec jpy39 in /Users/wilsonmar/Library/Jupyter/kernels/jpy39

   # Like conda list to file:
   conda env export --name "${CONDA_ENV}" > environment.yml
      # Now move the environment.yml file to your HPC using scp

   # Manually install https://marketplace.visualstudio.com/items?itemName=ms-toolsai.jupyter
   # ... Do what you need to do ...

   # LATER in this script:
   # source deactivate "${CONDA_ENV}"

   # LATER in this script:
   # conda env remove --name "${CONDA_ENV}"

fi  # RUN_CONDA
}
install_miniconda


### 55. RUN_JAVA

# See https://wilsonmar.github.io/java
# See https://wilsonmar.github.io/mac-setup/#Java
if [ "${DOWNLOAD_INSTALL}" = true ]; then  # -I
   if [ "${RUN_JAVA}" = true ]; then  # -java
      h2 "-Installing Java JDK openjdk@11 using brew ..."

      # For GitHub Voice:
      brew install openjdk@11
         # According to https://stackoverflow.com/questions/65601196/how-to-brew-install-java
         # symlink it:
      #if [[ "${MACHINE_TYPE}" == *"arm64"* ]]; then
      #   # On Apple M1 Monterey: /opt/homebrew/bin is where Zsh looks (instead of /usr/local/bin):
      #   sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk \
      #      /Library/Java/JavaVirtualMachines/openjdk-11.jdk
      #   # Password required.
      #elif [[ "${MACHINE_TYPE}" == *"x86_64"* ]]; then
      #   sudo ln -sfn /usr/local/opt/openjdk@11/libexec/openjdk.jdk \
      #      /Library/Java/JavaVirtualMachines/openjdk-11.jdk
      #   # Password required.
      #else
      #   fatal "MACHINE_TYPE=$MACHINE_TYPE not recognized."
      #   exit
      #fi
      # See all versions installed:
      /usr/libexec/java_home -V
         # Password required.
         # Matching Java Virtual Machines (4):
         # 11.0.20.1 (x86_64) "Homebrew" - "OpenJDK 11.0.20.1" /usr/local/Cellar/openjdk@11/11.0.20.1/libexec/openjdk.jdk/Contents/Home
         # Comes default with macOS:
         # 1.8.202.08 (x86_64) "Oracle Corporation" - "Java" /Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home
         # 1.8.0_202 (x86_64) "Oracle Corporation" - "Java SE 8" /Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home
         # 1.8.0_162 (x86_64) "Oracle Corporation" - "Java SE 8" /Library/Java/JavaVirtualMachines/jdk1.8.0_162.jdk/Contents/Home
         # /usr/local/Cellar/openjdk@11/11.0.20.1/libexec/openjdk.jdk/Contents/Home

      java -version
         # openjdk version "11.0.20.1" 2023-08-24
         # OpenJDK Runtime Environment Homebrew (build 11.0.20.1+0)
         # OpenJDK 64-Bit Server VM Homebrew (build 11.0.20.1+0, mixed mode)
   fi  # RUN_JAVA
fi  # DOWNLOAD_INSTALL   


### 56. RUN_GOLANG  

# See https://wilsonmar.github.io/golang
# See https://wilsonmar.github.io/mac-setup/#Golang
if [ "${RUN_GOLANG}" = true ]; then  # -Golang
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



### 57. Install Python

# See https://wilsonmar.github.io/mac-setup/#InstallPython
if [ "${RUN_PYTHON}" = true ]; then  # -python

   # https://docs.python-guide.org/dev/virtualenvs/

   PYTHON_VERSION="$( python3 -V )"   # "Python 3.9.11"
   # TRICK: Remove leading white space after removing first word
   PYTHON_SEMVER=$(sed -e 's/^[[:space:]]*//' <<<"${PYTHON_VERSION//Python/}")
   note "PYTHON_SEMVER=${PYTHON_SEMVER}"  #    =3.9.11"

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
   # pip
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

   #if [ "${RUN_PYTHON}" = true ]; then  # -python
      # Install image management CLI for https://www.youtube.com/watch?v=bNbN9yoEOdU
      # Instead of https://www.ffmpeg.org/download.html
      brew install FFMpeg
   #fi

fi  # RUN_PYTHON



### 58a. USE_AIAC to generate Terraform

do_aiac(){
# See https://wilsonmar.github.io/mac-setup/#Terraform
if [ "${USE_AIAC}" = true ]; then  # -tf
   h2 "aiac = Artificial Intelligence Infrastructure-as-Code Generator."
   # From https://www.firefly.ai/ with https://www.youtube.com/@firefly4183
   if ! command -v aiac >/dev/null; then  # command not found, so:
      if [ "${PACKAGE_MANAGER}" = "brew" ]; then # -U
         brew install gofireflyio/aiac/aiac
      fi

   fi

   if [ -z "${OPENAI_API_KEY}" ]; then  # not defined in ~/mac-setup.zsh
      fatal "-aiac OPENAI_API_KEY not defined. Breaking out..."
      return
   else
      # Insecure: note "OPENAI_API_KEY=${OPENAI_API_KEY}"
   fi

   if [ "${SHOW_VERBOSE}" = true ]; then  # -v
      note "aiac list-models ..."
      aiac list-models
         # --model=            Type        Maximum Tokens
         # gpt-3.5-turbo       chat        4096
         # gpt-3.5-turbo-0301  chat        4096
         # gpt-4               chat        8192
         # gpt-4-0314          chat        8192
         # gpt-4-32k           chat        32768
         # gpt-4-32k-0314      chat        32768
         # text-davinci-003    completion  4097
         # text-davinci-002    completion  4097      
   fi

   # docker run \
   # -it \
   # -e OPENAI_API_KEY=[PUT YOUR KEY HERE] \
   # ghcr.io/gofireflyio/aiac get terraform for ec2
   # hapex legomemnon

   # TODO: Loop
   if [ -z "${AIAC_PROMPT}" ]; then  # not defined:
      fatal "-aiac AIAC_PROMPT not defined. Breaking out..."
      return
   else
      # See https://github.com/gofireflyio/aiac
      note "AIAC_PROMPTS=${AIAC_PROMPT}"
      # eks, ec2, 
      FILE_DATETIME=$( date +%Y-%m-%dT%H:%M:%S%z)-$((1 + RANDOM % 1000))
      aiac get terraform for "${AIAC_PROMPT}" \
         --model="gpt-3.5-turbo" 
      #  --output-file="${AIAC_PROMPT}_${FILE_DATETIME}.tf"
   fi

   aiac get terraform for eks --output-file=eks.tf

   # docker pull ghcr.io/gofireflyio/aiac:latest
fi  # USE_AIAC
}
do_aiac  


# TODO: Exchange static refs with SHA references using 

### 58b. Use Pike to define permissions for TF/IAC

# See https://github.com/JamesWoolfenden/pike/tree/master
# TODO: https://wilsonmar.github.io/mac-setup/#Pike
do_pike(){
   if [ "${USE_PIKE}" = true ]; then   # -pike
      if command -v brew >/dev/null; then  # MacOS HomeBrew installed:
         if ! command -v pike >/dev/null; then  # not installed, so:
            h2 "Installing Pike ..."
            brew tap jameswoolfenden/homebrew-tap
            brew install jameswoolfenden/tap/pike
               # 🍺  /usr/local/Cellar/pike/0.2.105: 5 files, 20.2MB, built in 5 seconds
         #else  # installed already: Reinstall if -R
         fi
      # TODO: else on Windows use scoop.
      fi     

      # TODO: docker pull jameswoolfenden/pike
            # docker run --tty --volume /local/path/to/tf:/tf jameswoolfenden/pike scan -d /tf

      # TODO: if [ "${DELETE_BEFORE}" = false ]; then  # NOT -d 

#      PROJECT_FOLDER_PATH="$PROJECT_FOLDER_BASE/$PROJECT_FOLDER_NAME"
#      cd "${PROJECT_FOLDER_PATH}"
      note "At $(pwd)"
      note "$( ls -ltaT )"
         # aws_iam_role.terraform_pike.tf
         # pike.generated_policy.tf

      cd "code/01-hello-world"

      PROJECT_OUTPUT_FOLDERNAME=".pike"
      if [ ! -d "${PROJECT_OUTPUT_FOLDERNAME}" ]; then   # DEFAULT file defined NOT found:
         warning "-pike folder \"${PROJECT_OUTPUT_FOLDERNAME}\" not found. Creating..."
         mkdir "${PROJECT_OUTPUT_FOLDERNAME}"
      fi

      note "-F At $(pwd)"
      note "$( ls -ltaT )"

      h2 "Run pike scan -w -i -d ."
         # The -w flag has pike write out the role/policy required to build your project into the .pike folder:
            # 2022/09/17 13:50:51 terraform init at .
            # 2022/09/17 13:50:51 downloaded ip

      # TODO: Make, apply, remote, compare

      if [ "${OPEN_APP}" = true ]; then  # -o for -output
         h2 'pike scan -o terraform -d "${PROJECT_FOLDERPATH}"'
         pike scan -o terraform -d "${PROJECT_FOLDERPATH}"
      fi
      cd "${PROJECT_OUTPUT_FOLDERNAME}"
      note "$( ls -ltaT )"

   echo "DEBUG at pike ${PROJECT_FOLDER_PATH}";exit

      # Browser will refresh when the server starts?

      if [ "${DELETE_CONTAINER_AFTER}" = true ]; then  # -D
         note "Removing project folder \"${PROJECT_FOLDER_FULL_PATH}\" ..."
         rm -rf "${PROJECT_FOLDER_FULL_PATH}"
            # Files are in macOS Trash.
      fi

   fi  # USE_PIKE
}  # do_pike
do_pike


### 58c. RUN_TERRAFORM

# See https://wilsonmar.github.io/mac-setup/#Terraform
if [ "${RUN_TERRAFORM}" = true ]; then  # -tf
   if [ "${SET_TRACE}" = true ]; then   # -x
      if [ -z "${TF_LOG_PATH}" ]; then  # not defined:
         # mkidr -p "/tmp"
         export TF_LOG_PATH="tmp.tf.debug.${LOG_DATETIME}.txt"
      fi
      h2 "Running Terraform with TF_LOG=DEBUG to ${TF_LOG_PATH} ..."
      # https://www.khalidjhosein.net/2018/12/terraform-tips-and-tricks/
      export TF_LOG="DEBUG"
   else
      h2 "Running Terraform with TF_LOG file unset ..."
      unset TF_LOG
   fi

   note "At $PWD ..."

   h2 "terraform validate - syntax is good?"
   terraform validate
      # Success! The configuration is valid.
      # Error: Invalid resource type

   h2 "terraform fmt"
   # https://developer.hashicorp.com/terraform/cli/commands/fmt 
   terraform fmt -write=false -recursive -diff

   h2 "terraform plan "
   # See https://developer.hashicorp.com/terraform/cli/commands/apply
   terraform plan -no-color
   
   #h2 "Scan using NOT tfsec ..."
   #tfsec   # scan static tf code for security issues

   h2 "Generate docs (Markdown or JSON) from comments and variables in tf code..."
   terraform-docs
   
   h2 "terraform apply ..."
   terraform apply -auto-approve

   if [ "${SET_TRACE}" = true ]; then   # -x
      if [ "$DELETE_CONTAINER_AFTER" = true ]; then
         h2 "Terraform -Destroy ..."
         terraform destroy

         if [ -f "${TF_LOG_PATH}" ]; then  # file created:
            note "-D Deleting Logs at ${TF_LOG_PATH} ..."
            rm -rf "${TF_LOG_PATH}"
         fi
      fi
   fi
fi    # RUN_TERRAFORM


### 59. RUN_TENSORFLOW

# See https://wilsonmar.github.io/mac-setup/#Tensorflow
if [ "${RUN_TENSORFLOW}" = true ]; then  # -tsf

      if [ -f "$PWD/${MY_FOLDER}/${MY_FILE}" ]; then
         echo "$PWD/${MY_FOLDER}/${MY_FILE}"
         # See https://jupyter-notebook.readthedocs.io/en/latest/notebook.html?highlight=trust#signing-notebooks
         jupyter trust "${MY_FOLDER}/${MY_FILE}"
         # RESPONSE: Signing notebook: section_2/2-3.ipynb
      else
         echo "$PWD/${MY_FOLDER}/${MY_FILE} not found among ..."
         ls -ltaT "$PWD/${MY_FOLDER}"
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


### 60. Finish RUN_VIRTUALENV

# See https://wilsonmar.github.io/mac-setup/#RunVirtualenv
if [ "${RUN_VIRTUALENV}" = true ]; then  # -V
      h2 "Execute deactivate if the function exists (i.e. has been created by sourcing activate):"
      # per https://stackoverflow.com/a/57342256
      declare -Ff deactivate && deactivate
         #[I 16:03:18.236 NotebookApp] Starting buffering for db5328e3-...
         #[I 16:03:19.266 NotebookApp] Restoring connection for db5328e3-aa66-4bc9-94a1-3cf27e330912:84adb360adce4699bccffc00c7671793
fi


### 61. USE_TEST_SERVER

# See https://wilsonmar.github.io/mac-setup/#Testenv
if [ "${USE_TEST_SERVER}" = true ]; then  # -t

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

fi # if [ "${USE_TEST_SERVER}"


### 62. RUBY_INSTALL

# See https://wilsonmar.github.io/mac-setup/#InstallRuby
if [ "${RUBY_INSTALL}" = true ]; then  # -ruby

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

fi # RUBY_INSTALL


### 63. RUN_EGGPLANT

# See https://wilsonmar.github.io/mac-setup/#Eggplant
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


### 64. Use QEMU Podman

if [ "${USE_QEMU}" = true ]; then   # -qemu
   RESPONSE="$(podman ps -a)"
   if [[ "${RESPONSE}" == *"${/bin/qemu-system-aarch64}"* ]]; then  # contains it:
      note "podman already running"
      note "$RESPONSE"
   fi
   # https://www.qemu.org/download/#macos
fi  # USE_PODMAN


### 65. USE_DOCKER or USE_PODMAN (from RedHat, instead of Docker)

# See https://wilsonmar.github.io/mac-setup/#UseDocker

   #if [ ! -f "docker-compose.override.yml" ]; then
   #   cp docker-compose.override.example.yml  docker-compose.override.yml
   #else
   #   warning "no .yml file"
   #fi


if [ "${USE_PODMAN}" = true ]; then   # -podman
   # https://medium.com/@davutozcan87/podman-setup-for-mac-4b1ac9cd959
   h2 "-podman  TODO: USE_PODMAN"
   if ! command -v podman >/dev/null; then  # command not found, so:
      brew install podman
   fi

   h2 "podman machine init ..."
   RESPONSE=$( podman machine init )
   if [[ "${RESPONSE}" == *"${VM already exists}"* ]]; then  # contains:
      # Error: podman-machine-default: VM already exists
      note "$RESPONSE"
      # TODO: bring down and up again without "else"?
   else
      podman machine init
      
      podman ps -a

      h2 "podman machine start ..."
      # TODO: To avoid "Error: podman-machine-default: VM already exists
      podman machine start
   fi

   h2 " alias docker=podman ..."
   alias docker=podman
   # Verify podman is working
   h2 "podman version ..."
   note "$( docker -v )"
      # podman version 4.0.3

   h2 "podman run hello-world ..."
   podman run hello-world
      # !... Hello Podman World ...!
      # 
      #          .--"--.           
      #        / -     - \         
      #       / (O)   (O) \        
      #    ~~~| -=(,Y,)=- |         
      #     .---. /`  \   |~~      
      #  ~/  o  o \~~~~.----. ~~   
      #   | =(X)= |~  / (O (O) \   
      #    ~~~~~~~  ~| =(Y_)=-  |   
      #   ~~~~    ~~~|   U      |~~ 
      # 
      # Project:   https://github.com/containers/podman
      # Website:   https://podman.io
      # Documents: https://docs.podman.io
      # Twitter:   @Podman_io
      
   # hello-world stops on its own, so
   h2 "docker ps ..."
   podman ps
      # CONTAINER ID  IMAGE       COMMAND     CREATED     STATUS      PORTS       NAMES

   h2 "pip3 install podman-compose ..."
      # Collecting podman-compose
      #   Downloading podman_compose-1.0.3-py2.py3-none-any.whl (27 kB)
      # Collecting pyyaml
      #   Downloading PyYAML-6.0-cp39-cp39-macosx_11_0_arm64.whl (173 kB)
      #      |████████████████████████████████| 173 kB 1.5 MB/s 
      # Collecting python-dotenv
      #   Downloading python_dotenv-0.20.0-py3-none-any.whl (17 kB)
      # Installing collected packages: pyyaml, python-dotenv, podman-compose
      # Successfully installed podman-compose-1.0.3 python-dotenv-0.20.0 pyyaml-6.0

   h2 "podman-compose up ..."
   podman-compose up
      # ['podman', '--version', '']
      # using podman version: 4.0.3
      # no compose.yaml, docker-compose.yml or container-compose.yml file found, pass files with -f

   # TODO: Test if api is working fine
   # Verify print of version info:
   # curl -X GET — unix-socket /tmp/podman.sock 'http://localhost/version'
   # Set docker api address:
   # export DOCKER_HOST=unix:///tmp/podman.sock
fi


if [ "${USE_DOCKER}" = true ]; then   # -k

   h2 "-k = USE_DOCKER install ..."
   if [ "${DOWNLOAD_INSTALL}" = true ]; then  # -I & -U
      if [ "${PACKAGE_MANAGER}" = "brew" ]; then

         if ! command -v docker ; then
            h2 "Installing docker CLI ..."
            brew install docker
         else
            if [ "${UPDATE_PKGS}" = true ]; then
               h2 "Upgrading docker CLI ..."
               # https://www.weplayinternet.com/posts/error-it-seem-there-is-already-a-binary/
               brew remove docker
               brew install --cask docker
               brew upgrade docker
            fi
         fi

         if ! command -v docker.app ; then
            h2 "Installing docker ..."
            brew install --cask docker
            # Error: It seems there is already a Binary at '/opt/homebrew/share/zsh/site-functions/_docker'.
         else
            if [ "${UPDATE_PKGS}" = true ]; then
               h2 "Upgrading docker ..."
               brew upgrade --cask docker
            fi
         fi

         if ! command -v docker-compose ; then
            h2 "Installing docker-compose ..."
            brew install docker-compose
            if ! command -v docker-compose >/dev/null; then
               # Compose is now a Docker plugin. For Docker to find this plugin, symlink it:
               mkdir -p ~/.docker/cli-plugins
               ln -sfn /opt/homebrew/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose
            fi
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
   # note "$( docker --version )"          # Docker version 19.03.5, build 633a0ea
   note "$( docker-compose --version )"  # docker-compose version 2.5.0

   h2 "Starting Docker on \"${OS_TYPE}\" ..."
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
         open "$HOME/Applications/Docker.app"  # 
         #open --background -a Docker   # 
         # /Applications/Docker.app/Contents/MacOS/Docker
      else
         note "Starting Docker daemon on Linux ..."
         sudo systemctl start docker
         sudo service docker start
      fi

      timer_start="${SECONDS}"
      # Docker Docker is starting ...
      while ( ! docker ps -q  2>/dev/null ); do
         sleep 2  # seconds 
         duration=$(( SECONDS - timer_start ))
         # Docker takes a few seconds to initialize (drop off if longer to updating Docker, Update, and Relaunch)
         note "${duration} seconds waiting for Docker to begin running ..."
      done
 
   }  # Start_Docker
 
   Remove_Dangling_Docker(){   # function
      RESPONSE="$( docker images -qf dangling=true )"
      # note "Ignore \"Error: No such image\" "
      if [ -z "${RESPONSE}" ]; then  # there's something:
         RESPONSE=$( docker rmi -f "${RESPONSE}" >/dev/null )
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
   } || {   # or 
      IS_DOCKER_STARTED=false
   }
   if [ "${IS_DOCKER_STARTED}" = false ]; then
      # Docker is not running. Starting Docker app ..."
      Start_Docker   # function defined in this file above.
   else   # Docker processes found running:
      if [ "${RESTART_DOCKER}" = true ]; then  # -r
         note "Docker being restarted ..."
         Stop_Docker    # function defined in this file above.
         Start_Docker   # function defined in this file above.
      else
         note "Docker already running ..."
      fi
   fi
   # Error response from daemon: dial unix docker.raw.sock: connect: connection refused


   ### 66. RUN_ACTUAL

   if [ "${RUN_ACTUAL}" = true ]; then  # -a for actual usage

      h2 "Remove dangling docker ..."
      Remove_Dangling_Docker   # function defined above.
      if [ "${BUILD_DOCKER_IMAGE}" = true ]; then   # -b
         h2 "Building docker image (from Dockerfile) ..."
         docker build  #Dockerfile
      fi    # BUILD_DOCKER_IMAGE


      #h2 "node-prune to remove unnecessary files from the node_modules folder"
         # Test files, markdown files, typing files and *.map files in Npm packages are not required in prod.
         # See https://itsopensource.com/how-to-reduce-node-docker-image-size-by-ten-times/
      #npm prune --production

      if [ "${USE_DOCKER_COMPOSE}" = true ]; then  # -dc
         h2 "USE_DOCKER_COMPOSE"
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
      else  # NOT Docker compose .yaml

         if [ -n "${DOCKER_IMAGE_FILE}" ]; then  # known value:
            h2 "docker pull (image) \"${DOCKER_IMAGE_FILE}\" (from Dockerhub) as default ..."
            docker pull "${DOCKER_IMAGE_FILE}"
               # Error: No such image: 
               # Using default tag: latest
               # latest: Pulling from library/vault
               # Status: Downloaded newer image for vault:latest
               # docker.io/library/vault:latest
         # else
         fi
         docker images -f "reference=${DOCKER_IMAGE_FILE}"
            # REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
            # consul       latest    58fe9fa6a8a4   3 weeks ago   128MB
      fi  # USE_DOCKER_COMPOSE
   
      if [ "${SHOW_VERBOSE}" = true ]; then
         h2 "docker images downloaded, sorted by size ..."
         # Thanks to https://tunzor.github.io/posts/docker-list-images-by-size/
         docker image ls --format "{{.Repository}}:{{.Tag}} {{.Size}}" | \
         awk '{if ($2~/GB/) print substr($2, 1, length($2)-2) * 1000 "MB - " $1 ; else print $2 " - " $1 }' | \
         sed '/^0/d' | \
         sort -n
      fi


      # TODO: Add run in local Kubernetes.
      ### 67. RUN_ACTUAL within Docker

      # See https://wilsonmar.github.io/mac-setup/#RunDocker
      h2 "-a  RUN_ACTUAL ... (not dry run)"
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
      fi  # MY_FOLDER


   ### 68. Docker RUN_CONSUL

   if [ "${RUN_CONSUL}" = true ]; then  # -Consul

      # See https://learn.hashicorp.com/tutorials/consul/docker-container-agents 
      CONSUL_DOCKER_NAME="docker-badger"
      CONSUL_CLIENT_NODE1_NAME="client-1"
      CONSUL_SERVER_NODE1_NAME="server-1"
      CONSUL_CLIENT_NODE2_NAME="docker-weasel"
      CONSUL_SVC2_IMAGE="hashicorp/counting-service:0.0.2"
      CONSUL_SVC2_NAME="counting.service.consul"
      CONSUL_SVC2_NAME="counting-fox"

      # https://github.com/hashicorp/docker-consul

      # First check if already running: https://stackoverflow.com/questions/44731451/how-to-run-a-docker-container-if-not-already-running
      note "docker container list = docker ps ... "
      RESPONSE=$( docker ps -a -f status=running )
          # CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                                                                                    NAMES
         # 79399f38f301   consul    "docker-entrypoint.s…"   14 minutes ago   Up 14 minutes   8300-8302/tcp, 8600/tcp, 8301-8302/udp, 0.0.0.0:8500->8500/tcp, 0.0.0.0:8600->8600/udp   docker-badger
      if [[ "${RESPONSE}" == *"${CONSUL_DOCKER_NAME}"* ]]; then  # contains it:
          note "Docker name ${CONSUL_DOCKER_NAME} already running ..."
      else  
         note "docker run \"${CONSUL_DOCKER_NAME}\" node \"${CONSUL_SERVER_NODE1_NAME}\" ... "
         docker run -d --name="${CONSUL_DOCKER_NAME}" \
            -p 8500:8500 \
            -p 8600:8600/udp \
            consul agent -server -ui -node="${CONSUL_SERVER_NODE1_NAME}" \
               -bootstrap-expect=1 -client=0.0.0.0
         # -d = detached mode, meaning the process runs in the background.
         # If the container already is running, docker start will return 0 
         # If the container EXISTS but is not running, docker start will start it.
      fi

      # The Consul Docker image sets up the Consul configuration directory at /consul/config by default.
      # the agent, which loads configuration files into that directory.
      if [ ! -d "/consul/config" ]; then
         error "/consul/config not found"
         # exit 9
      else 
         note "$( ls -al /consul/config )"
      fi

      note "docker exec \"${CONSUL_DOCKER_NAME}\" consul members ... "
      # Discover the Server IP address:
      docker exec "${CONSUL_DOCKER_NAME}" consul members
         # Node       Address         Status    Type    Build  Protocol  DC   Segment
         # server-1  172.17.0.2:8301  alive     server  1.4.4  2         dc1  <all>
      # TODO: Capture CONSUL_SERVER_NODE1_IP
         # docker: Error response from daemon: Conflict. The container name "/docker-badger" is already in use by container 
         # "79399f38f301ea20ac95c4e10c4074cf16c69b1cf04e996d12454a69cfb989df". 
         # You have to remove (or rename) that container to be able to reuse that name.
      export CONSUL_SERVER_NODE1_IP="172.17.0.2"

      # Run Consul Client to the Server IP:
      note "docker run client node ${CONSUL_CLIENT_NODE1_NAME} ... "
      docker run --name="${CONSUL_CLIENT_NODE1_NAME}" \
         consul agent -node="${CONSUL_CLIENT_NODE1_NAME}" -join="${CONSUL_SERVER_NODE1_IP}"

      note "docker exec ${"${CONSUL_DOCKER_NAME}"} client members ... "
      docker exec "${CONSUL_DOCKER_NAME}" consul members
         # Node      Address          Status  Type    Build  Protocol  DC   Segment
         # server-1  172.17.0.2:8301  alive   server  1.4.3  2         dc1  <all>
         # client-1  172.17.0.3:8301  alive   client  1.4.3  2         dc1  <default>

      note "docker pull hashicorp/counting-service:0.0.2 ..."
      docker pull "${CONSUL_SVC2_IMAGE}"
         # This sample basic service increments a number every time it is accessed
         # and returns that number.

      note "Run container with port forwarding for access from a web browser ..."
      docker run \
         -p 9001:9001 \
         -d \
         --name="${CONSUL_CLIENT_NODE2_NAME}" \
         "${CONSUL_UI_NODE1_IMAGE}"

      note "Add svc definition file counting.json to register service \"${CONSUL_SVC2_NAME}\" ..."
      # with the Consul client by in the directory consul/config.
      docker exec "${CONSUL_SVC2_NAME}" /bin/sh \
         -c "echo '{\"service\": {\"name\": \"counting\", \"tags\": [\"go\"], \"port\": 9001}}' \
         >> /consul/config/counting.json"

      # Since the Consul client does not automatically detect changes in the configuration directory, 
      note "Issue a reload command for the same \"{CONSUL_SVC2_NAME}\" container ..."
      docker exec "${CONSUL_SVC2_NAME}" consul reload
         # RESPONSE: Configuration reload triggered
         # In the log:
            # [INFO] agent: Caught signal:  hangup
            # [INFO] agent: Reloading configuration...
            # [INFO] agent: Synced service "counting"

      # Query Consul for the location of your service using the following dig command against Consul's DNS.
      note "Use Consul DNS query to discover service ${CONSUL_SVC2_ID} ..."
      # See https://wilsonmar.github.io/hashicorp-consul/#dig_discover
      dig @127.0.0.1 -p 8600 "${CONSUL_SVC2_ID}"


      # TODO: For an in-memory reload, send a SIGHUP to the container.
      # docker kill --signal=HUP <container_id>

   fi


   ### 69. Docker RUN_EGGPLANT or container

   if [ "${RUN_EGGPLANT}" = true ]; then  # -O
      # Connect target browser to Eggplant license server: 
      if [ -z "${EGGPLANT_USERNAME}" ]; then
         echo "EGGPLANT_USERNAME=${EGGPLANT_USERNAME}"
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

      # ALT: EGGPLANT_SUT_IP=docker inspect -f "{{ .NetworkSettings.Networks.bridge.IPAddress }}" "${BROWSER_HOSTNAME}"
      EGGPLANT_SUT_IP=$( ipconfig getifaddr en0 )  # "192.168.1.10"
      EGGPLANT_SUT_PORT="9001"  # for chrome, 9002 for firefox, 9003 for opera 

      note "EGGPLANT_SUT_IP=${EGGPLANT_SUT_IP}, EGGPLANT_SUT_PORT=${EGGPLANT_SUT_PORT}"

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
   else
      # TODO: Get PS_ID of specific docker image:
      DOCKER_PS_RUNNING="$( docker ps -a -f status=running )"   # RESPONSE: 36edbff2d6eb209149006386360f821c07e14b2d2aa3a378ed0735ccd3921c8e
      note "docker ps -a -f status=running ..."
      note "$DOCKER_PS_RUNNING"
      # If just heading returned (CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES )
         # blank DOCKER_PS_NAME
      # fi

      Delete_running_containers(){
         # https://www.thegeekdiary.com/how-to-list-start-stop-delete-docker-containers/
         DOCKER_CONTAINERS_RUNNING="$( docker ps -a -f status=running )"
            # -as (instead of -a) to display container size as well.
            # To remove all containers that are NOT running
            # docker rm `docker ps -aq -f status=exited`
         note "docker ps -a -f status=running ..."
         note "$DOCKER_CONTAINERS_RUNNING"
         if [ "$DELETE_CONTAINER_AFTER" = true ]; then  # -D
            h2 "Stopping all docker containers:"
            docker stop "${DOCKER_CONTAINERS_RUNNING}"
               # –time/-t=1 is grace period seconds to wait before stopping the container.

            note "Removing all docker containers selected:"
            docker rm -v "${DOCKER_CONTAINERS_RUNNING}"
         fi
      }
      if [ "$DELETE_CONTAINER_AFTER" = true ]; then  # -D
         Delete_running_containers  # function defined above.
      fi

      if [[ "${DOCKER_PS_RUNNING}" == *"${DOCKER_PS_NAME}"* ]]; then  # contains text
         note "Docker ps image \"${DOCKER_IMAGE_FILE}\" as -name \"${DOCKER_PS_NAME}\" already running ..."
      else
         h2 "docker run image \"${DOCKER_IMAGE_FILE}\" as -name=\"${DOCKER_PS_NAME}\" ..."
         docker run --cap-add=IPC_LOCK -d --name="${DOCKER_PS_NAME}"  "${DOCKER_IMAGE_FILE}"
            # --cap-add=IPC_LOCK (mlock) prevents sensitive values in memory from being swapped to disk.
      fi
   fi

   if [ "${OS_TYPE}" = "macOS" ]; then  # it's on a Mac:
      note "Opening browser ${APP1_HOST}:${APP1_PORT}/${APP1_FOLDER}"
      sleep 3
      open "http://${APP1_HOST}:${APP1_PORT}/${APP1_FOLDER}"
      # To list ports listening: sudo lsof | grep localhost
#   else
#      curl -s -I -X POST http://localhost:8000/ 
#      curl -s       POST http://localhost:8000/ | head -n 10  # first 10 lines
   fi

   fi  # RUN_ACTUAL
fi  # USE_DOCKER


### 70. UPDATE_GITHUB

# See https://wilsonmar.github.io/mac-setup/#UpdateGitHub
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
   fi  # .git
fi   # UPDATE_GITHUB


### 71. REMOVE_GITHUB_AFTER folder after run

# See https://wilsonmar.github.io/mac-setup/#RemoveGitHub
if [ "$REMOVE_GITHUB_AFTER" = true ]; then  # -C
   h2 "Delete cloned GitHub at end ..."
   Delete_GitHub_clone    # defined above in this file.

   if [ "${RUN_PYTHON}" = true ]; then  # -python
      h2 "Remove files in ~/temp folder ..."
      rm bandit.console.log
      rm bandit.err.log
      rm pylint.console.log
      rm pylint.err.log
   fi
fi


### 72. KEEP_PROCESSES after run
# See https://wilsonmar.github.io/mac-setup/#KeepPS
if [ "${KEEP_PROCESSES}" = false ]; then  # -K

   if [ "${NODE_INSTALL}" = true ]; then  # -js
      if [ -n "${MONGO_PSID}" ]; then  # not found
         h2 "Kill_process ${MONGO_PSID} ..."
         Kill_process "${MONGO_PSID}"  # invoking function above.
      fi
   fi 
fi


### 76. Use Docker

if [ "${USE_DOCKER}" = true ]; then   # -k
   if [ "${KEEP_PROCESSES}" = true ]; then  # -K
      RESPONSE="$( docker images -qf dangling=true )"
      note "docker images -qf dangling=true ..."
      note "$RESPONSE"
      if [ -z "${RESPONSE}" ]; then
         note "docker rmi -f ${RESPONSE} ... "
         docker rmi -f "${RESPONSE}"
      fi      

      Stop_Docker   # function defined in this file above.
   fi


   # See https://wilsonmar.github.io/mac-setup/#DeleteDocker
   if [ "$DELETE_CONTAINER_AFTER" = true ]; then  # -D

      # TODO: if docker-compose.yml available:
      if [ "${RUN_EGGPLANT}" = true ]; then  # -O
         h2 "docker-compose down containers ..."
         docker-compose -f "docker-compose.yml" down
      else
         # https://www.thegeekdiary.com/how-to-list-start-stop-delete-docker-containers/
         h2 "Deleting active containers ..."

         # CONTAINER ID   IMAGE     COMMAND                  CREATED              STATUS              PORTS      NAMES
         # 9a9f5af3ee7a   vault     "docker-entrypoint.s…"   About a minute ago   Up About a minute   8200/tcp   dev-vault
         # CONTAINER ID        IMAGE                COMMAND                  CREATED             STATUS                    PORTS                    NAMES
         # 3ee3e7ef6d75        snakeeyes_web        "/app/docker-entrypo…"   35 minutes ago      Up 35 minutes (healthy)   0.0.0.0:8000->8000/tcp   snakeeyes_web_1
         # fb64e7c95865        snakeeyes_worker     "/app/docker-entrypo…"   35 minutes ago      Up 35 minutes             8000/tcp                 snakeeyes_worker_1
         # bc68e7cb0f41        snakeeyes_webpack    "docker-entrypoint.s…"   About an hour ago   Up 35 minutes                                      snakeeyes_webpack_1
         # 52df7a11b666        redis:5.0.7-buster   "docker-entrypoint.s…"   About an hour ago   Up 35 minutes             6379/tcp                 snakeeyes_redis_1
         # 7b8aba1d860a        postgres             "docker-entrypoint.s…"   7 days ago          Up 7 days                 0.0.0.0:5432->5432/tcp   snoodle-postgres

        #note "$( docker container ls -a )"  # same as:
         DOCKER_CONTAINERS_RUNNING="$( docker ps -a -f status=running )"
         note "Docker containers ..."
         note "${DOCKER_CONTAINERS_RUNNING}"
            # CONTAINER ID   IMAGE     COMMAND                  CREATED        STATUS                   PORTS      NAMES
            # 32114f5674e4   vault     "docker-entrypoint.s…"   5 hours ago    Up 5 hours               8200/tcp   dev1
            # 36edbff2d6eb   vault     "docker-entrypoint.s…"   14 hours ago   Exited (0) 6 hours ago              naughty_chatterjee
         
         note "Stopping all docker containers:"
         docker stop "${DOCKER_CONTAINERS_RUNNING}"
            # –time/-t=1 is grace period seconds to wait before stopping the container.

         note "Removing all docker containers:"
         docker rm -v "${DOCKER_CONTAINERS_RUNNING}"
      fi # if [ "${RUN_EGGPLANT}" = true ]; then  # -O
   fi


   ### 77. REMOVE_DOCKER_IMAGES downloaded

   # See https://wilsonmar.github.io/mac-setup/#RemoveImages
   if [ "${REMOVE_DOCKER_IMAGES}" = true ]; then  # -M

      h2 "docker system df  ..."
      note "$( docker system df )"
         # TYPE           TOTAL       ACTIVE      SIZE        RECLAIMABLE
         # Images         2           2           356.4MB     0B (0%)
         # Containers     6           0           460B        460B (100%)
         # Local Volumes  0           0           0B          0B (0%)
     
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

   if [ "${SHOW_VERBOSE}" = true ]; then
      h2 "At end of run: docker images -a ..."
      note "$( docker images -a )"
   fi
fi    # USE_DOCKER


### 78. Report Timings

# See https://wilsonmar.github.io/mac-setup/#ReportTimings


# END