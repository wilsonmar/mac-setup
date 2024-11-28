<!--
git commit -m"v027 + resume entry :README.md"
-->

Here is the quickest way to automate get a new macOS running with <a href="#UtilitiesInstalled">all the stacks of tools most developer wants</a> to work locally and in several clouds.

After you complete this, step by step, you can add to your resume or LinkedIn profile:

   <ul>Configured new Mac Mini M4, from scratch, a full set of utilities and AI apps and cloud services.
   Bash script automation was used to reduce the effort to within an hour.
   Documentation of each step were documented and validated by others.
   The entire team can now pair program together efficiently with a common set of tools.
   </ul>

This has been refined over several years. 
What was formerly at <a target="_blank" href="https://wilsonmar.github.io/mac-setup">wilsonmar.github.io/mac-setup</a> has been incorporated into this document.

## Summary of Stages

1. <a href="#Why">Know Why</a>: <a href="#ForTeamwork">For teamwork</a>, <a href="#FastChange">Fast Change!</a>.
1. <a href="#Hardware">Hardware selection and connection</a>.
1. <a href="#NewMachine">New Machine Manual Setup</a>.
1. <a href="#TimeMachine">Time Machine Backup</a>.
1. <a href="#ResetToFactorySettings">Reset to Factory Settings</a>.

1. <a href="#SystemSettings">Shortcut to System Settings</a>.
1. <a href="#LoginItems">Login items</a>.
1. <a href="#Passkey">Passkey</a>.
1. <a href="#GitHubAccount">Setup GitHub account</a>.

1. <a href="#Terminal">Learn the Terminal app</a>.
1. <a href="#Finder">Learn the Finder and Folders $PATH</a>.
1. <a href="#ViewREADME">View this README in Safari</a>.
1. <a href="#Bash">Get .bash_profile</a>.

1. <a href="#ForkAndClone">Load gh to fork & clone mac-setup automation folder</a>
1. <a href="#Homebrew">Use Homebrew</a>.
<!-- TODO: + Git fork & clone using gh utilitiy. https://www.youtube.com/watch?v=2WiBRNydhTk -->
1. <a href="#curl">Edit mac-setup.env settings in $HOME</a>.
1. <a href="#mac-setup.sh">View mac-setup.sh parameters</a>.

1. <a href="#Dotfiles">Configure using Apple Script in Dotfiles</a>.


1. <a href="#UtilitiesInstalled">Utilities Installed</a>.

1. <a href="#AppsInstalled">Apps Installed</a>.

1. <a href="#FinalSteps">Final Steps</a>.

<hr />


<a name="Why"></a>

## Why?

This repo enables you to get up and running on a new mac machine in a matter of minutes rather than days. Being able to get started quickly means that you can get working with applications.

This helps developers skip wasted days installing (and doing it differently than colleagues).

In contrast to most tutorials, docs, and videos that wastes your time to <strong>manually type</strong> or copy and paste strings (often with missing steps), automation here is less error-prone and faster because we've worked out the dependency clashes for you. In each stage, our script detects what has already been installed and verifies the success ofeach step. So it can perform workarounds for known issues.

You can use this script to <strong>upgrade</strong> or <strong>remove</strong> apps and modules by changing the list of apps in the script.


<a name="ForTeamwork"></a>

### For teamwork

This automation enables teamwork by providing a common set of tools for working together: keyboard shortcuts (aliases), apps, etc.

This implements what well-known DevOps practitioners Ernest Mueller and James Wickett advocate in their book "The DevOps Handbook" and <a target="_blank" href="https://devops-handbook.com/">The DevOps Handbook</a> (<a target="_blank" href="https://www.oreilly.com/library/view/the-devops-handbook/9781491922921/">on OReilly.com</a>): "focus on the core value of CAMS (culture, automation, measurement, and sharing)".


<a name="FastChange"></a>

### Fast Change!

Apps and modules can be installed by simply adding a keyword in a control file recognized by the automation, which installs and configures them quickly and reliably.

Instead of or in addition to the default apps, you can specify additional apps to install:

   * <a href="#SafariBrowser">Safari browser</a>: Google Chrome, Firefox, Microsoft Edge, Brave,etc.
   * <a href="#Terminal">Terminal.app</a>: iTerm2, Warp, etc.
   * <a href="#Editors">Editors vim</a>: VSCode, Windsurf, Cursor, etc.

Default apps can be specified for removal (to save disk space) by changing a list of apps in the script.

This automated approach also enables you to update all apps and modules to the latest version with a single command - on a daily basis if you want.This helps meet cybersecurity directives to keep software up-to-date.

Scripts here are <strong>modular</strong>. It installs only what you tell it to by adding a keyword in the control file.

This repo brings DevSecOps-style <strong>"immutable architecture"</strong> to MacOS laptops. Immutability means replacing the whole machine instance instead of upgrading or repairing individual components.

<hr />

<a name="Hardware"></a>

## Hardware selection and connection

1. See my article about considerations of different hardware at<br />
<a target="_blank" href="https://wilsonmar.github.io/apple-macbook-hardware/">Mac laptop hardware</a>,

1. Connect the computer to the monitor with (in order of preference): Thunderbot 4 or 5 cable; Display Port; HDMI 3; USB-C.

   The back of the Mac Mini has USB-C ports that supports <strong>Lightning 4</strong> cables, which transfers data at 40Gbps and powers up to 100W. 
   
   The front of the Mac Mini has USB-C ports that supports <strong>HDMI v3.2</strong> cables, which transfers data at 40Gbps and powers up to 100W.

   Although an HDMI cable can connect the Mac Mini to a TV,
   we recommend using a monitor with the version of HTMI cable it supports.

   Some TVs do not show the top of the screen where the menu bar and Mission Control are displayed. Mission Control is a built-in feature of macOS
   to switch between groups of open apps and windows (using control + up arrow) and control + down arrow).

1. If you have a Bluetooth keyboard, you can use the USB port for something else. 

   PROTIP: A keyboard with a "delete" key is useful especially if you are used to working with Windows.
   The macOS keyboard requires users to awarkly press "fn" key and then "delete" key to delete.

   Some <a target="_blank" href="https://www.logitech.com/en-us/products/keyboards/mice/keyboard-mice.html">Logitech USB keyboard and mouse models</a> come with a USB dongle.

   See my article about the <a target="_blank" href="https://wilsonmar.github.io/macos-keyboard/">macOS keyboards</a>.

1. Consider an ergonoic mouse. If you are right-handed, consider a left-handed mouse so that you write with your right hand while you use the mouse.


<a name="NewMachine"></a>

## New Machine Manual Setup

1. Press the power button on the monitor.

1. See my article about the <a target="_blank" href="https://wilsonmar.github.io/macos-bootup/">macOS boot-up process</a>.

1. After boot-up, select the new machine's language, time zone, keyboard layout, icloud email & password,user name & password are manual first steps.

1. When prompted to upgrade your Mac, choose to upgrade to the latest version (which may take several minutes) to get your Mac up to date.

Once keyboard and mouse control is available:

<a target="_blank" href="https://www.apple.com/support/keyboard/">Keyboards from Apple</a> are different from generic USB keyboards for Windows:
   * Some don't have a "delete" key. Instead hold down the "fn" key and press the "delete" key.
   * The button at the upper-right is a fingerprint reader and on/off button
   * The modifier keys Command is used instead of Control.


<a name="TimeMachine"></a>

### Time Machine Backup

The built-in Time Machine app backs up files and folders so you can completely restore the whole computer to the state when backup occured.

CAUTION PROTIP: Complete backups are often NOT restored when malware may have been added and thus present in the backup files restored.

PROTIP: Our automation scripts also copies specific folders and text files to an external USB drive so they can be used to build a new machine <strong>from scratch</strong> after examination.

1. Buy a new external USB NVMe SSD drive. They are $106 for 1TB at Costco.
1. Plug in the new USB drive for storing backups. This you keep at home.

1. Open Time Machine by clicking the Launchpad icon on the Dock for a list of apps, then click on the "Time Machine" app icon.

   The Dock is by default always visible on the bottom of the screen, but the automation script move it to the right side and appears when you hover over the right side of the screen.

1. Select a location to store backups.
1. Click "Add Backup Disk..." icon at the right side of the screen.
1. Select the drive you just plugged in.
1. Click "Add"
1. Name the backup drive.

   PROTIP: Name the drive such as "1TB-MacMini24" to designate the size of the drive and the year of the machine it is being installed on.

1. Encrypt the drive by clicking the "Encrypt" icon at the right side of the screen.
1. Enter a password for the drive.
1. Click "Encrypt"
1. Click "Done".
1. Click "Done" again.
1. Click "Start Backup" to begin the backup process.

PROTIP: Take a Backup again to establish a new baseline before and after you upgrade your machine.

NOTE: The automation script is installed, it can do a Time Machine backup.

<a name="ResetToFactorySettings"></a>

## Reset to Factory Settings

You can now confidently reset the machine to factory settings, which erases all data.

1. Shut down your Mac.
1. Turn it on and immediately press and hold the Command (⌘) + R keys.
1. Keep holding until you see the Apple logo or a spinning globe. This will boot your Mac into macOS Recovery.
1. Select Disk Utility and click Continue.
1. In Disk Utility, select your main drive (usually named Macintosh HD) from the list on the left.
1. Click the Erase button at the top of the window.
1. Name: You should leave it as "Macintosh HD" because it's the "Startup Volume"s.
1. Format: Choose APFS (for most modern Macs) or Mac OS Extended (Journaled) for older Macs.
1. Scheme: Choose GUID Partition Map.
1. Click Erase to wipe the drive.
1. Close Disk Utility to return to the macOS Utilities window.
1. Select Reinstall macOS and click Continue.
1. Follow the on-screen instructions to reinstall the operating system. This may take some time, depending on your internet speed and the version of macOS being installed.
1. Once the macOS installation is complete, your Mac will restart and you’ll see the Setup Assistant.

   A. If you're selling or giving away the Mac, don’t complete the setup process. Simply press Command + Q and select Shut Down. The new owner can complete the setup with their own information.

   B. If you want to restore your Mac, Shut down your Mac, plug in your backup media, and press the start button. When the boot-up screen appears, select the backup media and press the start button.


<hr />

<a name="SystemSettings"></a>

## Shortcut to System Settings

PROTIP:For some strange reason, Apple does not provide a default direct keyboard shortcut for System Settings. So create one:

   1. Click the Apple icon on the upper left corner of the screen. 
   1. Click the "System Settings...".
   1. Type "Keyboard shortcuts".
   1. Click Keyboard Shortcuts.
   1. Click "App Shortcuts" on the left menu and click the + button.
   1. For "Applications", select "System Settings".
   1. In Menu title at the right, type "System Settings..." (make sure to include the ellipsis).
   1. For Keyboard shortcut, press <strong>CommandCommand + Option + Shift + P</strong> 
   1. Click "Done" to save the shortcut.

   1. Try it out by clicking on the Apple icon on the upper left corner to see the keystrokes for "System Settings...". Try the keyboard sequence shown.


<a name="LoginItems"></a>

### Login items

PROTIP: Review this once a month to ensure that you have control of your machine. Here is where malicious software can get access.

1. Within Apple System Settings, click the "Search" text within the field at the upper-left corner.
1. Type "Login" on top of "Search".
1. If you don't want to have a program Open at Login, click on that app and click the "-" button.
1. If you want to have Allow in the Background a program, click on the toggle to its left.

<a name="Passkey"></a>

### TODO: Install Passkey


<a name="DefaultBrowser"></a>

## Default Browser

Safari is the default browser on MacOS.

The automation script will install other browsers if specified.

1. To ensure that cookies in the browser are not confused, open the browser you want to use. Select the browser profile you want to use.

   You may need tonavigate to that browser's settings and make that the default and profile. For example: chrome://settings/defaultBrowser
   


<a name="GitHubAccount"></a>

## GitHub account

If you have not yet obtained a GitHub account, 

1. In a web browser, sign up for one with your email address at 

   <a target="_blank" href="https://github.com/">https://github.com/</a>

1. We recommend installing Twillo's Authy app for two-factor authentication.

1. TODO: Configure SSH and GPG keys.



<a name="ViewREADME"></a>

## View this README in Safari

So you can click links within this README file on the target machine:

1. To open Safari, near the left among the default list of apps at the bottom of the screen, click on the "Safari" browser icon.

1. Click on the middle field to type on top of "Search or enter website name".

1. Type in this URL to reach this README file:

   <a target="_blank" href="https://github.com/wilsonmar/mac-setup/blob/main/README.md#ViewREADME">https://github.com/wilsonmar/mac-setup/blob/main/README.md#ViewREADME</a>

1. Scroll down to this section:


<a name="ViewSetup"></a>

## View the mac-setup.sh automation script in Safari

PROTIP: This approach is designed so that you can examine the script before running it.

1. To review the automation files to setup a new machine, click this link:

   <a target="_blank" href="https://github.com/wilsonmar/mac-setup/blob/main/mac-setup.sh">https://github.com/wilsonmar/mac-setup/blob/main/mac-setup.sh</a>

   CAUTION: The remainder of this article explains how to run the script. 

   That automation script is manually invoked several times using different parameters on the Terminal command line, each time for a different phase of installation.

   This script uses Bash (.sh) rather than Zsh (.zsh) in order for the script to possibly be adapted for work on Linux and Windows machines as well.

   However, script mac-setup.sh can upgrade Bash to the latest version.

1. Click "fork" to copy the script to your own GitHub account.

Next, let's get that script onto your machine using "Bash" CLI (Command Line Interface) commands within the Terminal app.


<a name="Terminal"></a>

## Learn the Terminal app

The built-inTerminal program is called a "Bash" shell, which is a contraction of the term "Bourne-agan shell", which is a play on words.

1. Hold down the <strong>Command</strong> key and press <strong>spacebar</strong> to pop up the Spotlight Search modal dialog.

1. Type on top of "Spotlight Search" <strong>Ter</strong> so enough of "Terminal.app" appears to press Enter to select it in the drop-down.

1. When "Terminal.app" is highlighted, click it with your mouse or press the <strong>return</strong> key to launch the Terminal.app program selected.

   The default Terminal CLI (Command Line Interface) prompt shown begins with the <strong>user name</strong>.
   
   We will later customize the prompt shown by changing the <tt>PS1</tt> variable.

1. Type <tt>pwd</tt> to see the "present working directory", which is the current folder you are in. The path shown is also stored in a variable named <tt>$HOME</tt>.

1. Type <tt>ls -al</tt> to see the default folders and files in your $HOME folder. The <tt>-al</tt> parameter specifies to show all folders and files as a list.

1. To reduce text wrapping the next line, expand the width of your Terminal window by dragging the right edge with your mouse.

   <a name="KeyboardAliases"></a>

   ### keyboard aliases (shortcuts)

   PROTIP: The automation script installs keyboard aliases (shortcuts) you can use to improve typing speed and accuracy. Examples:

   * <tt>alias ll="ls -al"</tt>
   * <tt>alias l="ls -l"</tt>
   * <tt>alias h="history"</tt>

   These aliases are stored in the <tt>aliases.sh</tt> file called by .bash_profile in the $HOME folder. 

   <a name="UserHomeFolders"></a>
   
   ### User $HOME folders

   The first part of each line defines its attributes (permissions and ownership). Lines beginning with "d" define directories (folders). 
   
   * .Trash
   * .zsh_sessions
   * Desktop
   * Documents
   * Downloads
   * Movies
   * Music
   * Pictures
   * Public


<a name="ForkAndClone"></a>

## Fork and Clone usingthe GH CLI

1. Open the Terminal app and type:
   ```
   gh auth login --web
   ```
   The response:
   ```
   ? What is your preferred protocol for Git operations on this host?  [Use arrows to move, type to filter]
   > HTTPS
   SSH
   ```
1. Press Enter to accept "HTTPS" as the preferred protocol.
   ```
   ? What is your preferred protocol for Git operations on this host? HTTPS
   ? Authenticate Git with your GitHub credentials? (Y/n) 
   ```
1. Press Enter to accept the default capitalized "Y" to authenticate Git with your GitHub credentials.
   The response:
   ```
   ! First copy your one-time code: 17B4-A882
   Press Enter to open https://github.com/login/device in your browser... 
   ```
1. Highlight the code and press Command+C to copy it to your invisible Clipboard.
1. Press Enter for GitHub "Device Activation" page to appear in whatever is set as default browser.

1. Click the button associated with the account you want to use, such as "Continue".
1. In the "Device Activation" page that appears, click on the first box and press command+V to paste the 8-digit code from your invisible Clipboard.
1. Click "Continue".
1. Click "Authorize github".
1. Click "Use passkey" and touch your fingerprint for "Congratulations, you're all set!"
1. Press command+W to close the "Device Activation" page.

1. Switch to the Terminal by holding down command and pressing Tab repeatedly until it rests on the Terminal icon.
   ```
   ✓ Authentication complete.
   - gh config set -h github.com git_protocol https
   ✓ Configured git protocol
   ✓ Logged in as wmjomt
   ```
1. Type the GitHub account name you want to fork to, such as:
   ```
   GH_ACCT="wmjomt"
   ```
1. Fork and clone in this one command:
   ```
   gh repo fork "https://github.com/wilsonmar/mac-setup" --clone
   ```
   The response at time of writing:
   ```
   ✓ Created fork wmjomt/mac-setup
   Cloning into 'mac-setup'...
   remote: Enumerating objects: 4255, done.
   remote: Counting objects: 100% (1303/1303), done.
   remote: Compressing objects: 100% (500/500), done.
   remote: Total 4255 (delta 821), reused 1268 (delta 789), pack-reused 2952 (from 1)
   Receiving objects: 100% (4255/4255), 13.01 MiB | 12.71 MiB/s, done.
   Resolving deltas: 100% (1125/1125), done.
   From https://github.com/wilsonmar/mac-setup
   * [new branch]      main       -> upstream/main
   * [new branch]      master     -> upstream/master
   ✓ Cloned fork
   ! Repository wilsonmar/mac-setup set as the default repository. To learn more about the default repository, run: gh repo set-default --help
   ```

<a name="Finder"></a>
   
### Learn Finder & Folders

The Finder app is the default app for opening files and folders.
So it is the one default app that can't be removed.

1. Open the Finder app.

1. Arrange the left panel to display the folders in the order you prefer.

1. From the $HOME folder, press <strong>command + up</strong> to display the previous level, where a "Shared" folder is shown.

1. The same can be done on the Terminal by typing:
   ```
   cd ..
   ```

1. Press <strong>command + up</strong> again to display the level containing folders referenced by the operating system:

    * Applications
    * <strong>Library</strong> folder holds application files
    * System
    * Users

1. Switch to the Terminal. To see the folder for each application:
   ```
   ls -al "$HOME/Library/Application Support"
   ```
   Notice that the the "$HOME" variable and the space within "Application Support" require double-quotation marks. 
   
   REMEMBER:The folder for an application is not deleted when the application is deleted.
   
1. Switch back to the Finder GUI.
1. Press <strong>command + up</strong> again to display the top level containing "Macintosh HD" and "Network" folders.

   PROTIP: Installers of apps being installed are shown in this folder.

1. Switch to the Terminal to get the disk space used by this folder using this command:
   ```
   du -sh "$HOME"
   ```
1. Switch back to the Finder GUI.
1. Press <strong>command + down</strong> to go down a level.

1. Manually arrange to your liking the sequence of folders on the left panel of Finder.

   ### Added in $HOME folder
   
   NOTE: Folder and file names beginning with a "." are hidden by default.
   Press <strong>command + shift + .</strong> to toggle the display of hidden files and folders.

   The macsetup.sh automation script adds these files:

   * mac-setup.env
   * aliases.sh

   * .bash_profile
   * .bashrc

   * .zshrc
   * .zshenv
   * .zprofile
   * .zshrc

   * keepa.kdbx (Keepass database)

   The mac-setup.sh script adds these folders:

   * Applications (to hold GUI .app tooling executables installed)

   * Projects (or other name to hold files not managed by Git)
   * (various folders to hold database files)

   * github-wilsonmar (or whatever is your user account on GitHub.com holding code)
   * gh-wmjtm (another user name on GitHub)
   
   * go
   * gopkgs

1. Switch to the Terminal by holding down the Command key and pressing Tab repeatedly until it rests on the Termial icon.



<a name="PhasesOfInstallation"></a>

## Phases of installation 

1. Download from GitHub mac-setup.sh automation script
1. Edit settings in mac-setup.env (using textedit or VSCode)
1. Install Homebrew and use it to install utilities Bash, Git, etc.
1. Install and configure apps


<a name="mac-setup.parms"></a>

### View mac-setup.sh parameters

1. We want to upgrade Bash to the latest version.


## secrets.sh

The above list is from the <strong>secrets.sh</strong> file in your $HOME folder, which
you edit to specify which port numbers and <strong>keywords to specify apps</strong> you want installed.

   The file's name is suffixed with ".sh" because it is a runnable script that establishes memory variables for a <a href="#MainScript">Setup script</a> to reference.



<a name="Homebrew"></a>

## Use of Homebrew

Most of the apps installed make use of installers defined in the Homebrew repository online. There is a file (of Ruby code) for each brew install formula at:<br />

   <a target="_blank" href="
   https://github.com/Homebrew/homebrew-core/blob/master/Formula/httpd.rb">
   https://github.com/Homebrew/homebrew-core/blob/master/Formula/httpd.rb</a>

   PROTIP: Before downloads a brew formula, we recommend that you look at its Ruby code to verify what really occurs and especially where files come from.

   <pre><strong>brew edit ___</strong></pre>

   We recommend that you install a binary repository proxy that supply you vetted files from a trusted server instead of retrieving whatever is the latest on the public Homebrew server.

   Homebrew has over 4,500 formulas the last time we checked.

To install and configure programs which don't have brew installation formulas,
various Libux utility commands such as curl, sed, cut, etc. are used in this automation script.

Yes, you can just run brew yourself, one at a time. But logic in the script goes beyond what Homebrew does, and <strong>configures</strong> the component just installed:

   * Undo a brew error (such as needing an unset)
   * Install dependent components where necessary
   * Display the version number installed (to a log)
   * Add alias and paths in <strong>.bash_profile</strong> (if needed)
   * Perform configuration (such as adding a missing file needed for mariadb to start)
   * Edit configuration settings (such as changing default port within Nginx within config.conf file)
   * Upgrade and uninstall if that is available
   * Run a demo using the component to ensure that what has been installed actually works.
   <br /><br />


<a name="MakeThisWorkForYou"></a>

## Make this work for you

The section below explains to someone relatively new to Mac machines the steps to automate installation of additional MacOS application programs. Along the way, we explore basic skills to use a command-line Terminal and common commands.

   <a name="VersionWithGap"></a>

   ### Bash Version with Grep

   Bash 4.0 was released in 2009, but Apple still ships version 3.x, which first released in 2007.

   Bash Version 4 is needed for <a href="#BashArrays">"associative arrays"
   needed in the script</a>.

1. Test if you have Bash updatedi by typing this:

   <pre><strong>bash --version | grep 'bash'
   </strong></pre>
 
   Hold the Shift key to press the | (called pipe) key at the upper-right of the keyboard.

   The <tt>grep 'bash'</tt> is needed to filter out lines that do not contain the word "bash" in the response such as:

   You have a recent version of Bash if you see:

   ```
   GNU bash, version 5.2.37(1)-release (aarch64-apple-darwin23.4.0)
   ```
   If instead you see you have bash v3 that comes with MacOS, <a target="_blank" href="https://www.admon.org/scripts/new-features-in-bash-4-0/">this blog describes what is improved by version 5+</a>.


   ### mac-bash4.sh initialization

2. Switch to back to this web page by holding down the command key and pressing Tab repeatedly until it rests on the browser icon.

3. Triple-click on the script line below to highlight it for copying:

   <pre>sh -c "$(curl -fsSL https://raw.githubusercontent.com/wilsonmar/mac-setup/master/mac-bash-up.sh)"</pre>

4. Press Command+C to copy it to your invisible Clipboard.
5. Switch to the Terminal by holding down command and pressing Tab repeatedly until it rests on the Termial icon.
6. At the Terminal, click on a Terminal window and paste in the command by holding down command then V. It doesn't matter what folder you're on at this point.
7. Press Enter to run the command, which upgrades Bash to version 4 and copies a file to your Home folder.

   The script first makes use of the Ruby program to install Homebrew which, in turn, installs Bash v4 using the brew command to download and configure packages.

8. After it runs, verify the version again <a href="#VersionWithGap">as described above</a> to ensure it's version 4.


   <a name="HomeFolder"></a>

   ### Home folder

9. The default location the Terminal command opens to by default is your "Home" folder, which you can reach anytime by:

   <pre><strong>cd
   </strong></pre>

9. The "~" (tilde character) prompt represents the $HOME folder, which is equivalent to a path that contains your user account, such as (if you were me):

   <pre>/Users/wilsonmar</pre>

1. You can also use this variable to reach your account's Home folder:

   <pre>cd $HOME</pre>

   In other words these commands all achieve the same result:

   <tt>cd = cd ~ = cd $HOME</tt>


   <a name="Secrets"></a>

   ### secrets.sh at Home

   It's wise to avoid storing secrets in GitHub or other public repository. Files stored in
   <strong>your user $HOME holder</strong> (outside a Git-managed folder) have no chance to be uploaded from the Git repository. The script references secrets there.

   And if the script doesn't see a secrets file in your $HOME folder,
   it copies one there from the repo's sample file.

   NOTE the secrets.sh is a clear-text file.

   ### Encrypting and Decrypting secrets

   Optionally, you may store secrets and configurations in an encrypted file
   after some initial configuration.

   Run script <tt>./secrets.edit.sh</tt> to decrypt the contents of <tt>secrets.sh</tt>
   for the mac-setup-all.sh script to use.

   Run script <tt>./secrets.lock.sh</tt> to encrypt the contents of <tt>secrets.sh</tt>.

   Utilities "blackbox" or "git-secret" can be used to handle


   ### Text edit secrets.sh

1. Use a text editor to edit the <tt>secrets.sh</tt> file using a text editor that comes pre-loaded on every Mac:

   <pre><strong>textedit ~/secrets.sh</strong></pre>

   The tilde character specifies that the file is in your Home folder.

   <a name="Shebang"></a>

   ### Top of file Shebang

   Looking in the file, consider the first line in the secrets.sh file:

   <pre>#!/bin/bash</pre>

   That is the "Bourne-compliant" path for the Bash v3.2 shell installed by default on MacOS up to High Sierra. BTW, other Linux flavors may alternately use this for portability:

   <pre>#!/usr/bin/env</pre>

   BTW, unlike Windows, which determines the program to open files based on the suffix (or extension) of the file name, Linux shell programs such as Bash reference the "shebang" on the first line inside the file.

1. Open another Terminal window.
1. View the above files to see that they are binary executable files, such as:

   <pre><strong>textedit /usr/bin/bash</strong></pre>

1. Exit the file.
1. Press the command key with the back-tick (`) at the upper-left of the keyboard to switch among textedit windows.

   ### Version 4 Shebang

   If you instead see this on the first line:

   <tt>#!/usr/local/bin/bash</tt>

   that is the Bash program associated with <a href="#Bash4">Bash v4</a>.

   This is why we needed to first upgrade Bash before running other scripts.


   ### App keywords

   The initial secrets.sh file does not have keywords which specify additional apps to install.

1. Scroll down or press command+F to type an app keyword to find its <a href="#Categories">category</a>.

   ### Edit port numbers

1. Scroll to the list of <a href="#Ports">ports (listed above)</a>.

1. May sure that none of the ports are the same (conflicts).

1. Save the file and exit the text editor.

   <a name="MainScript"></a>

   ### Setup all

1. Now copy, switch, click and paste in a Terminal window to run this command:

   <pre>sh -c "$(curl -fsSL https://raw.githubusercontent.com/wilsonmar/mac-setup/master/mac-setup-all.sh)"</pre>

   The script referenced in the command obtains more files needed by cloning from a public GitHub repository (<a target="_blank" href="https://github.com/wilsonmar/mac-setup/">
   https://github.com/wilsonmar/mac-setup</a>) to a folder under your home folder named "mac-setup".

4. Wait for the script to finish.

   On a 4mbps network the run takes less than 5 minutes for a minimal install.
   PROTIP: A faster network or a proxy Nexus server providing installers within the firewall would speed things up and ensure that vetted installers are used.

   When the script ends it pops up a log file in the TextEdit program that comes with MacOS.

5. Switch to the TextEdit window by clicking it.
6. Scroll to review the log file. Press command+F to input text to search.
6. Close the log file by clicking the red button.
7. Switch to a Finder window to your account's Home folder and delete log files.

   <a name="MacSetupFiles"></a>

   ### mac-setup files #

   The folder contains these files and folders:

   * Files within folder "hooks" are used by Git (if marked for install.)
   * File "mac-bash-profile.txt" contains starter entries to insert in ~/.bash_profile that is executed before MacOS opens a Terminal session.
   <br /><br />

   ### Subsequent runs

   To update what is installed on your Mac, re-run the mac-setup.zsh bash script.

1. cd into your Home folder to find the <strong>secrets.sh</strong> file.
1. Edit the file, then run again locally:

   <pre><strong>chmod +x mac-setup-all.sh
   ./mac-setup-all.sh
   </strong></pre>

   The <tt>chmod</tt> (pronounced "che-mod") changes the permissions for executing the file.

   Now let's look at the Bash coding techniques used in the scripts mentioned above, at: <a target="_blank" href="
   https://wilsonmar.github.io/bash-coding/">
   https://wilsonmar.github.io/bash-coding</a>

<hr />

<a name="mas"></a>

## Mas Mac apps

The brew formula "mas" manages Apple Store apps, but it only manages apps that have already been paid for.  mas does not install apps new to your Apple Store account.

Apps on Apple's App Store for Mac need to be installed manually. <a target="_blank" href="https://www.reddit.com/r/osx/comments/4hmgeh/list_of_os_x_tools_everyone_needs_to_know_about/">
Popular apps</a> include:

   * Office for Mac 2016
   * BitDefender for OSX
   * CrashPlan (for backups)
   * Amazon Music
   * <a target="_blank" href="https://wilsonmar.github.io/rdp/#microsoft-hockeyapp-remote-desktop-for-mac">HockeyApp RDP</a> (Remote Desktop Protocol client for controlling Microsoft Windows servers)
   * Colloquy IRC client (at https://github.com/colloquy/colloquy)
   * etc.
   <br /><br />

### .pkg and .dmg

.pkg and .dmg files can be downloaded to install apps.



<a name="CloudSync"></a>

## Cloud Sync

Apps for syncing to cloud providers are installed mostly for manual use:

Dropbox, OneDrive, Google Drive, Amazon Drive


## Additional apps

* <a target="_blank" href="https://answers.splunk.com/answers/223311/how-to-install-splunk-622-on-a-mac-os-x.html">Splunk</a> log analysis SPLUNK_PORT="8000"
 http://docs.splunk.com/Documentation/SplunkLight

* Kafka streams


<a name="More"></a>

## Wait, there's more

Lists of Mac programs:

   * https://github.com/paulirish/dotfiles/blob/master/brew-cask.sh
   (one of the earliest ones by a legend at Google)

   * https://github.com/andrewconnell/osx-install described at http://www.andrewconnell.com/blog/rapid-complete-install-reinstall-os-x-like-a-champ-in-three-ish-hours separates coreinstall.sh from myinstall.sh for personal preferences.

   * https://www.reddit.com/r/osx/comments/3u6mob/what_are_the_top_10_osx_applications_you_use/
   * https://github.com/siyelo/laptop
   * https://github.com/evanchiu/dotfiles
   * https://github.com/jeffreyjackson/mac-apps
   * https://github.com/jaywcjlove/awesome-mac/blob/master/README.md
   * https://medium.com/@ankushagarwal/maximize-developer-productivity-on-a-mac-a9ae6fbaedab
   * https://dotfiles.github.io/

   * https://www.mugo.ca/Blog/Turbo-charge-your-Mac-development-environment describes use of Vagrant

## Others like this

Here are other scripts to install on Mac:

* https://github.com/wilsonmar/git-utilities/blob/master/README.md was an early example just the bare basics,
   such as https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup
   and https://git-scm.com/docs/git-config
* https://github.com/monfresh/laptop
* https://github.com/18F/laptop
* https://dzone.com/articles/local-continuous-delivery-environment-with-docker
* https://medium.com/my-name-is-midori/how-to-prepare-your-fresh-mac-for-software-development-b841c05db18
* https://github.com/swoodford/osx/blob/master/setup-developer-environment.sh
* https://www.bonusbits.com/wiki/Reference:Mac_OS_DevOps_Workstation_Setup_Check_List
* More at https://github.com/thoughtbot/laptop/blob/master/mac
* https://github.com/ghaiklor/iterm-fish-fisherman-osx described at https://ghaiklor.github.io/iterm-fish-fisherman-osx/ and https://blog.ghaiklor.com/bootstrap-your-terminal-environment-in-macos-with-a-single-bash-script-ea1ca445f0a5
* https://github.com/why-jay/osx-init/blob/master/install.sh

