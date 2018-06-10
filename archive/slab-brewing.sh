#!/bin/bash

# From https://github.com/sanoakr/slab-scripts/blob/master/brewing.sh

# CASK directories
caskroom=/usr/local/Caskroom
#export HOMEBREW_CASK_OPTS="--caskroom=$caskroom"
#appdir=/Applications
#export HOMEBREW_CASK_OPTS="--appdir=$appdir --caskroom=$caskroom"

# packages
base=("ack" \
    "aspell --with-lang-en" \
    "bash-completion" \
    "bullet --with-double-precision --with-framework --with-shared" \
    "cmake" \
    "emacs --with-cocoa --japanese" \
    "fish" \
    "git" \
    "gnuplot --with-aquaterm --with-cairo --with-pdflib-lite --with-tex --with-x11" \
    "imagemagick" \
    "lv" \
    "nkf" \
    "openssl" \
    "pget" \
    "pyenv" \
    "python" \
    "python3" \
    "rename" \
    "rmtrash" \
    "tree" \
    "vim")
opt=("autoconf" \
    "automake" \
    "binutils" \
    "boost" \
    "boost-python" \
    "byobu" \
    "ddrescue" \
    "erlang" \
    "gnu-sed" \
    "grace" \
    "kindlegen" \
    "numpy" \
    "ode-drawstuff --enable-demos" \
    "opencv" \
    "pandoc" \
    "pkg-config" \
    "readline" \
    "ruby" \
    "syncthing" \
    "syncthing-inotify" \
    "terminal-notifier" \
    "tiger-vnc" \
    "unrar" \
    "w3m" \
    "webkit2png" \
    "wget" \
    "xz")
cask_base=("aquaterm" \
#    "atom" \
    "coteditor" \
    "flash-player" \
    "google-japanese-ime" \
    "inkscape" \
    "iterm2" \
    "itsycal" \
    "latexit" \
    "mactex" \
#    "menumeters"
#    "microsoft-office" \
# QuickLook Plugins
    "qlcolorcode" \
    "qlstephen" \
    "qlmarkdown" \
    "quicklook-json" \
    "qlprettypatch" \
    "quicklook-csv" \
    "betterzipql" \
    "qlimagesize" \
    "webpquicklook" \
    "suspicious-package" \
# QuickLook Plugins END
    "sublime-text" \
#    "spideroakone" \
    "texshop" \
    "the-unarchiver" \
    "timer" \
    "thyme" \
    "visual-studio-code" \
    "vlc" \
    "xquartz")
cask_opt=("alfred" \
    "appcleaner" \
#    "bathyscaphe" \      
    "caffeine" \
#    "displaylink" \
#    "dropbox" \
    "evernote" \
    "firefox" \
#    "flip4mac" \
    "github-desktop" \
#    "google-drive" \
    "google-chrome" \
#    "google-earth" \
#    "google-music" \
    "handbrake" \
#    "handbrakecli" \
#    "locko" \
    "mactracker" \
#    "name-mangler" \
#    "odrive" \
    "omnidazzle" \
#    "processing" \
    "radiant-player" \
    "skim" \
    "skype" \
    "sourcetree" \
    "syncthing-bar" \
#    "virtualbox" \
    "xbench")

# checked install
function ck_install() {
    pkg=$(echo $@ | cut -d " " -f 1)
    if [ -z $(echo "$installed" | grep -x $pkg) ]; then
	$PRT brew install $@
    else
	$PRT echo "$pkg is already installed"
    fi
}
# checked cask install
function ck_cask_install() {
    pkg=$(echo $@ | cut -d " " -f 1)
    if [ -z $(echo "$cask_installed" | grep -x $pkg) ] ; then
	$PRT brew cask install $FORCE $@
    else
	echo "$pkg is already installed"
    fi
}
# cleanup
function cleanup() {
    brew cleanup
    brew cask cleanup
}
# cleaned cask upgrade
function cask_upgrade() {
    apps=($(brew cask list))
    for a in ${apps[@]};do
	info=$(brew cask info $a)
	if echo "$info"| grep -q "Not installed";then
	    $PRT brew cask install $a
	fi

	current=$(brew cask info $a|grep "${a}: "|cut -d' ' -f2)
	echo -en "$a:\\tcurrent: $current"
	installed=$(brew cask info $a|grep "${caskroom}/${a}"|grep -v "wrapper" \
		| cut -d' ' -f1|cut -d'/' -f6)
	#installed=$(brew cask info $a|grep "${caskroom}/${a}"|cut -d' ' -f1|cut -d'/' -f6)
	echo -e ";\\tinstalled: $installed"

	if [ "$current" = "$installed" ]; then
	    if echo "$installed" | grep -q "latest"; then
		$PRT find ${caskroom}/${a} -name "${installed}" -maxdepth 1 -mtime +180 \
		     -exec echo "*force reinstall: ${a} (latest installed 180days before)" \; \
		     -exec brew cask reinstall ${a} \;
	    fi
	else
	    $PRT brew cask reinstall ${a}
	fi

	for dir in $(ls ${caskroom}/${a});do
	    if [ "$dir" != "$current" ];then
		$PRT rm -rf "${caskroom}/${a}/${dir}"
	    fi
	done
    done
}
# usage message
function usage_exit() {
    echo "usage: $0 [-uiapPlh]"
    echo "  -u  Only Update & Upgrade installed packages [Default]"
    echo "  -i  Install fundamental packages"
    echo "  -a  Install all (fundamental & optional) packages"
    echo "  -f  Force install cask packages"
    echo "  -p  Print brew tasks (for checking, not execute)"
#    echo "  -I  Install and setup Homebrew"
    echo "  -P  Set network proxy cache.st.ryukoku.ac.jp:8080"
    echo "  -l  Show own package list"
    echo "  -h  Show this help"
    exit 0
}
# pkg list
function print_pkgs() {
    echo "Fundamental pkgs:"
    echo ${base[@]}
    echo "Optional pkgs:"
    echo ${opt[@]}
    echo "Cask Fundamentals:"
    echo ${cask_base[@]}
    echo "Cask Optionals:"
    echo ${cask_opt[@]}
    exit 0
}

#INSTALL=0
PROXY=0
BASE=0
ALL=0
FORCE=""
PRT=""
while getopts uiapfPlh opt; do
    case $opt in
        u) BASE=0; ALL=0 ;;
        i) BASE=1 ;;
        a) ALL=1 ;;
        f) FORCE="--force" ;;
        p) PRT="echo" ;;
#        I) INSTALL=1 ;;
        P) PROXY=1 ;;
        l) print_pkgs ;;
        h) usage_exit ;;
        \?) usage_exit ;;
    esac
done

# set proxy
if [ $PROXY -eq 1 ]; then
    $PRT export ryukoku_proxy=http://cache.st.ryukoku.ac.jp:8080/
    $PRT export http_proxy=$ryukoku_proxy
    $PRT export https_proxy=$ryukoku_proxy
    $PRT export all_proxy=$ryukoku_proxy
fi
# install homebrew
#if [ $INSTALL -eq 1 ]; then
if [ ! $(which brew) ]; then 
    $PRT ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Add Repository
echo "* Tapping homebrew/binary"
$PRT brew tap homebrew/binary 2> /dev/null
echo "* Tapping homebrew/science"
$PRT brew tap homebrew/science 2> /dev/null
echo "* Tapping sanoakr/slab"
$PRT brew tap sanoakr/slab 2> /dev/null
echo "* Tapping Code-Hex/pget"
$PRT brew tap Code-Hex/pget 2> /dev/null
#brew tap hirocaster/homebrew-mozc-emacs-helper

# Cask install
if [ ! $(brew tap | grep "caskroom/cask") ]; then 
    echo "* Install cask"
    $PRT brew tap caskroom/cask 2> /dev/null
    #$PRT brew install caskroom/cask/brew-cask 2> /dev/null
fi

# list installed pkgs
installed=$(brew list)
cask_installed=$(brew cask list)

echo "* brew updating"
$PRT brew update -v | while read; do echo -n .; done
echo

outdated=$(brew outdated)
if [ -n "$outdated" ]; then
    cat << EOF
The following package(s) will upgrade.
$outdated

Are you sure?
If you do NOT want to upgrade, type Ctrl-c now. (will be upgraded after 15sec waiting)
EOF
	read -t 15 dummy
	$PRT brew upgrade
else
    echo No need upgrade packages.
fi

echo "* Check cask upgrade."
cask_upgrade

if [ $BASE -eq 1 ]; then
    # install
    for e in "${base[@]}"; do ck_install $e; done

    # install cask
    $PRT find -L $appdir -type l -d 1 -exec echo Delete broken link {} \; -exec rm -f {}\;
    for e in "${cask_base[@]}"; do ck_cask_install $e; done
    
    # optional install
    if [ $ALL -eq 1 ]; then
	for e in "${opt[@]}"; do ck_install $e; done
	for e in "${cask_opt[@]}"; do ck_cask_install $e; done
	#    brew cask alfred link
    fi
fi

cleanup

list=$(brew list)
if echo "$list"| grep -q "aspell"; then
    cat <<EOF
*** Add following lisp lines to your ~/.emacs
*** if you want to use aspell on emacs.
(setq-default ispell-program-name "/usr/local/bin/aspell")
(eval-after-load "ispell"
  '(add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))
EOF
fi
