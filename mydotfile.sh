#!/usr/bin/env sh
# This is https://github.com/wilsonmar/mac-setup/blob/main/mydotfile.sh
#
# git commit -m"v119 + no max-limits :mydotfile.sh"
#
# Use of this is file is explained at https://wilsonmar.github.io/dotfiles

# At the bottom of this file are configurations for commonly installed apps:
   # Thanks to Mathias Bynens! ~/.macos — https://mths.be/macos
   # See https://github.com/driesvints/dotfiles/blob/main/.macos

#### Preparations:

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change:
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront:
sudo -v

# Keep-alive: update existing `sudo` time stamp until this has finished:
# while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


#### Executing the CLI commands below is equivalent to clicking the Apple logo at the upper-left, then System Settings
   # or shift + option + command + P
   # See https://www.youtube.com/watch?v=Kft9Y33oc2I => Mac Settings That ACTUALLY Make A Difference

# Wi-Fi
# Bluetooth
      # Show Bluetooth icon on Apple's Control Center (Menu Bar at top of screen):
      # sudo defaults write /Library/Preferences/com.apple.Bluetooth ShowBluetoothInMenuBar -bool true
      # FIXME: "Not privileged to stop service" to Restart the Bluetooth daemon:
      # sudo launchctl stop com.apple.bluetoothd
      # sudo launchctl start com.apple.bluetoothd
# Network
      # Firewall enable, Options, Enable stealth mode.
# Battery

# General
# Accessibility
# Appearance:
   echo "Appearance: AppleInterfaceStyle –string "Dark" "
   defaults write AppleInterfaceStyle –string "Dark";

   # Set sidebar icon size to Small (2=Medium):
   defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1
   # Sidebar icon size - Small
   defaults write .GlobalPreferences NSTableViewDefaultSizeMode -int 1
   # - Medium (the default)
   # defaults write .GlobalPreferences NSTableViewDefaultSizeMode -int 2
   # - Large
   # defaults write .GlobalPreferences NSTableViewDefaultSizeMode -int 3
# Siri
# Control Center
# Desktop & Dock
   # Default web browser:
      # - Safari (default)
      # - Google Chrome
      # - Firefox https://www.youtube.com/watch?v=NH4DdXC0RFw
      # https://github.com/ulwlu/dotfiles/blob/master/system/macos.zsh has grep error.

      # Explained in https://wilsonmar.github.io/dotfiles/#Dock
      # Dock (icon) Size: "smallish"
      defaults write com.apple.dock tilesize -int 36;

      # (Dock) Size (small to large, default 3)
      defaults write com.apple.dock iconsize -integer 3

      # (Dock) Position on screen: left, right, or bottom (the default):
      defaults write com.apple.dock orientation right;

      # Automatically hide and show the Dock:
      defaults write com.apple.dock autohide-delay -float 0;

      # remove Dock show delay:
      defaults write com.apple.dock autohide -bool true;
      defaults write com.apple.dock autohide-time-modifier -float 0;

      # remove icons in Dock:
      defaults write com.apple.dock persistent-apps -array;

      # Show active apps in Dock as translucent:
      defaults write com.apple.Dock show-hidden -bool true;
# Displays
      # Explained in https://wilsonmar.github.io/dotfiles/#Battery
      # Show remaining battery time; hide percentage
      defaults write com.apple.menuextra.battery ShowPercent -string "YES"
      defaults write com.apple.menuextra.battery ShowTime -string "YES"

      # Display Time Machine icon on menu bar
# Screen Saver
# Spotlight
# Wallpaper

# Notifications
# Sound
    # Mute Startup Sound - just before logout, and restores the previous volume just after login.
   sudo defaults write com.apple.loginwindow LogoutHook "osascript -e 'set volume with output muted'"
   sudo defaults write com.apple.loginwindow LoginHook "osascript -e 'set volume without output muted'"

   # Disable sound effects on boot:
   sudo nvram SystemAudioVolume=" "
# Focus
# Screen Time

# Lock Screen
# Privacy & Security
   # To avoid battery charging to 100% (https://www.youtube.com/watch?v=f69rX730vl0&t=2m12s)
   # Allow Location Services. System Services: Details, only System Customization & Significant locations.
# Touch ID & Password
# Users & Groups

# Internet Accounts
# Game Center
# iCloud
    # ========== Allow Handoff between this Mac and your iCloud devices ==========
    # - Checked
    defaults -currentHost write com.apple.coreservices.useractivityd.plist ActivityReceivingAllowed -bool true
    defaults -currentHost write com.apple.coreservices.useractivityd.plist ActivityAdvertisingAllowed -bool true
    # - Unchecked (default)
    #defaults -currentHost write com.apple.coreservices.useractivityd.plist ActivityReceivingAllowed -bool false
    #defaults -currentHost write com.apple.coreservices.useractivityd.plist ActivityAdvertisingAllowed -bool false
# Wallet & Apple Pay

# Keyboard
   # See https://wilsonmar.github.io/apple-mac-osx-keyboard/#avoid-reaching-for-the-mouse
   # Tap to click: there is always a delay (between 1/4 - 3/4 second) before a tap actually does anything."3
# Mouse
   # Explained in https://wilsonmar.github.io/dotfiles/#Mouse
      RESULT=$( defaults read -g com.apple.mouse.scaling )
   echo "Mouse Tracking speed: ${RESULT} (default is 3 in GUI) fastest 5.0"
      defaults write -g com.apple.mouse.scaling 5.0

   echo "Mouse Un-natural scrolling like Windows (toward direction) ..."
      defaults write NSGlobalDomain com.apple.swipescrolldirection -bool FALSE
# Trackpad
   # Explained in https://wilsonmar.github.io/dotfiles/#Trackpad
      RESULT=$( defaults read -g com.apple.trackpad.scaling )
   echo "Trackpad Tracking speed: ${RESULT} (default is 1.5 in GUI) fastest 5.0"
      defaults write -g com.apple.trackpad.scaling 3.0
      # FIX: Output: 5.0\013
# Printers & Scanners
   # Expand print panel by default:
   defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
   defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
   # Automatically quit printer app once the print jobs complete:
   defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true


# GPG Suite

# Finder app:
   # Open a Finder window by clicking the Finder icon in the Dock.
   # Explained in https://wilsonmar.github.io/dotfiles/#Extensions
      # Show all filename extensions:
      defaults write NSGlobalDomain AppleShowAllExtensions -bool true;
      defaults write -g AppleShowAllExtensions -bool true
      # Show hidden files:
      defaults write com.apple.finder AppleShowAllFiles YES;
      # Show Path Bar at bottom of Finder:
      # From the Finder menu bar, click "View" and then select "Show Path Bar".
      defaults write com.apple.finder ShowPathbar -bool true
      # Show the ~/Library Folder https://weibeld.net/mac/setup-new-mac.html
      chflags nohidden ~/Library

################################### Where?

   # See https://www.youtube.com/watch?v=8fFNVlpM-Tw
   # Changing the login screen image on Monterey.

# END
# Passwords
   # For Sequoia after after, Passwords settings moved to a separate app.
   # (https://www.youtube.com/watch?v=5A6-htFEyTQ)
