Here is the quickest way to automate the install of a macOS machine with <a href="#UtilitiesInstalled">all the stacks of tools most developer wants</a> to work locally and in several clouds.

This has been refined over several years.What was formerly at <a target="_blank" href="https://wilsonmar.github.io/mac-setup">wilsonmar.github.io/mac-setup</a> has been incorporated into this document.


<a name="Why"></a>

## Why?

This repo enables you to get up and running on a new mac machine in a matter of minutes rather than days. Being able to get started quickly means that you can get working with applications.

This helps developers skip wasted days installing (and doing it differently than colleagues).

In contrast to most tutorials, docs, and videos that wastes your time to <strong>manually type</strong> or copy and paste strings (often with missing steps), automation here is less error-prone and faster because we've worked out the dependency clashes for you. In each stage, our script detects what has already been installed and verifies the success ofeach step. So it can perform workarounds for known issues.

You can use this script to <strong>upgrade</strong> or <strong>remove</strong> apps and modules by changing the list of apps in the script.


### For teamwork

This automation enables teamwork by providing a common set of tools for working together: keyboard shortcuts (aliases), apps, etc.

This implements what well-known DevOps practitioners Ernest Mueller and James Wickett advocate in their book "The DevOps Handbook" and <a target="_blank" href="https://devops-handbook.com/">The DevOps Handbook</a> (<a target="_blank" href="https://www.oreilly.com/library/view/the-devops-handbook/9781491922921/">on OReilly.com</a>): "focus on the core value of CAMS (culture, automation, measurement, and sharing)".


<a name="FastChange"></a>

### Fast Change!

Apps and modules can be installed by simply adding a keyword in a control file recognized by the automation, which installs and configures them quickly and reliably.

This automated approach also enables you to update all apps and modules to the latest version with a single command - on a daily basis if you want.This helps meet cybersecurity directives to keep software up-to-date.

Scripts here are <strong>modular</strong>. Its default setting is to not install everything. It installs only what you tell it to by adding a keyword in the control file.

This repo brings DevSecOps-style <strong>"immutable architecture"</strong> to MacOS laptops. Immutability means replacing the whole machine instance instead of upgrading or repairing individual components.

<hr />

## Summary of stages

Here is a summary of the stages of the script.

1. <a href="#NewMachine">New Machine Manual Setup</a>.
1. <a href="#TimeMachine">Time Machine Backup</a>.
1. <a href="#ViewREADME">View this README in Safari</a>.
1. <a href="#mac-setup.sh">View mac-setup.sh automation script</a>
1. <a href="#Terminal">Open Terminal app</a>.
1. <a href="#mac-setup.parms">View mac-setup.sh parameters</a>.

1. <a href="#mac-setup.sh">Use of Bash vs Zsh script mac-setup.sh</a>.

1. <a href="#UtilitiesInstalled">Utilities Installed</a>.
1. <a href="#AppsInstalled">Apps Installed</a>.
1. <a href="#FinalSteps">Final Steps</a>.

<hr />

<a name="NewMachine"></a>

## New Machine Manual Setup

1. See my article about considerations of different hardware at<br />
<a target="_blank" href="https://wilsonmar.github.io/apple-macbook-hardware/">Mac laptop hardware</a>,

1. See my article about the <a target="_blank" href="https://wilsonmar.github.io/macos-bootup/">macOS boot-up process</a>.

1. After boot-up, select the new machine's language, time zone, keyboard layout, icloud email & password,user name & password are manual first steps.

1. When prompted to upgrade your Mac, choose to upgrade to the latest version (which may take several minutes) to get your Mac up to date.

Once keyboard and mouse control is available:

We use apps and utilities installed by default to install and configure apps and modules that may replace the ones installed by default.

   * Instead of <a href="#SafariBrowser">Safari browser</a>: Google Chrome, Firefox, Microsoft Edge, Brave,etc.
   * Instead of <a href="#Terminal">Terminal</a>: iTerm2, Warp, etc.
   * Instead of vim: VSCode, Windsurf, Cursor, etc.

Default apps can be specified for removal (to save disk space) by changing a list of apps in the script.


<a name="TimeMachine"></a>

### Time Machine Backup

Backups are used to completely restore a computer to the state captured  by Time Machine. 

CAUTION PROTIP: Complete backups are often NOT restored when malware may have been added and thus present in the backup files restored.

PROTIP: Our automation scripts also copies specific folders and text files to an external USB drive so they can be used to build a new machine <strong>from scratch</strong> after examination.

1. Buy a new external USB NVMe SSD drive. They are $106 for 1TB at Costco.
1. Plug in the new USB drive for storing backups. This you keep at home.

1. Open Time Machine by clicking the Launchpad icon for a list of apps.
1. Type "Time" to click on the "Time Machine" app icon.
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

PROTIP: Tak a Backup again to establish a new baseline before and after you upgrade your machine.

<hr />

<a name="ViewREADME"></a>

## View this README in Safari

1. To open Safara, near the left among the default list of apps at the bottom of the screen, click on the "Safari" browser icon.

1. Click on the middle field to type on top of "Search or enter website name".

1. Type in this URL to reach this README file:

   <a target="_blank" href="https://github.com/wilsonmar/mac-setup/blob/main/README.md#ViewREADME">https://github.com/wilsonmar/mac-setup/blob/main/README.md#ViewREADME</a>

1. Scroll down to this section:


<a name="ViewREADME"></a>

## View this README in Safari

1. Type in this URL to reach the automation to setup a new machine:

   <a target="_blank" href="https://github.com/wilsonmar/mac-setup/blob/main/mac-setup.sh">https://github.com/wilsonmar/mac-setup/blob/main/mac-setup.sh</a>

   CAUTION: The remainder of this article explains how to run the script. 

   PROTIP: Use of such a powerful technique should be preceded by a thorough vetting of that script.
   Before actual execution, read through the steps below and examine the script.

   That automation script is manually invoked several times using different parameters on the Terminal command line, each time for a different phase of installation.

   This script uses Bash (.sh) rather than Zsh (.zsh) in order for the script to possibly be adapted for work on Linux and Windows machines as well.

   However, we can use script mac-setup.sh to upgrade Bash to the latest Bash version.

1. Switch to the Terminal by holding down command and pressing Tab repeatedly until it rests on the Termial icon.


<a name="mac-setup.parms"></a>

### View mac-setup.sh parameters

1. We want to upgrade Bash to the latest version.


<a name="Terminal"></a>

## Open Terminal app

To invoke the built-in Terminal.app:

1. Hold down the <strong>Command</strong> key and press <strong>spacebar</strong> to pop up the Spotlight Search modal dialog.

1. Type on top of "Spotlight Search" <strong>Ter</strong> so enough of "Terminal.app" appears to press Enter to select it in the drop-down.

1. When "Terminal.app" is highlighted, click it with your mouse or press the <strong>return</strong> key to launch the Terminal program.

   The prompt shown is the <tt>$HOME</tt> variable's value.
   
   We will see later in this article how to customize the prompt shown. 

1. Type <tt>pwd</tt> to see the "present working directory", which is the current folder you are in. The path shown is also stored in a variable named <tt>$HOME</tt>.

1. Type <tt>ls -al</tt> to see the default folders and files in your $HOME folder. The <tt>-al</tt> parameter specifies to show all folders and files as a list.

   PROTIP: Automation scripts will install use keyboard aliases to reduce typing.

   The first part of each line defines its attribures (permissions and ownership).

   Lines beginning with "d" define directories (folders). 
   Default folders:

   * .Trash
   * .zsh_sessions
   * Desktop
   * Documents
   * Downloads
   * Movies
   * Music
   * Pictures
   * Public

   NOTE: Folder and file names beginning with a "." are hidden by default.

1. Switch from and back to the Terminal by holding down the Command key and pressing Tab repeatedly until it rests on the Termial icon.



<a name="mac-setup.parms"></a>

### View mac-setup.sh parameters

1. We want to upgrade Bash to the latest version.

<a name="PhasesOfInstallation"></a>

## Phases of installation 

zzz


## secrets.sh

The above list is from the <strong>secrets.sh</strong> file in your $HOME folder, which
you edit to specify which port numbers and <strong>keywords to specify apps</strong> you want installed.

   The file's name is suffixed with ".sh" because it is a runnable script that establishes memory variables for a <a href="#MainScript">Setup script</a> to reference.



<a name="Homebrew"></a>

## Homebrew

Most of the apps installed make use of installation code defined in the Homebrew repository online. There is a file (of Ruby code) for each brew install formula at:<br />

   <a target="_blank" href="
   https://github.com/Homebrew/homebrew-core/blob/master/Formula/httpd.rb">
   https://github.com/Homebrew/homebrew-core/blob/master/Formula/httpd.rb</a>

   PROTIP: Before downloads a brew formula, we recommend that you look at its Ruby code to verify what really occurs and especially where files come from.

   <pre><strong>brew edit wget</strong></pre>


   In fact, we recommend that you install a binary repository proxy that supply you vetted files from a trusted server instead of retrieving whatever is the latest on the public Homebrew server.

   Homebrew currently has over 4,500 formulas.

To install and configure programs which don't have brew installation formulas,
various commands such as curl, sed, cut, etc. are used in the script.

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

## Make this work for you

The section below explains to someone relatively new to Mac machines the steps to automate installation of additional MacOS application programs. Along the way, we explore basic skills to use a command-line Terminal and common commands.

1. Obtain the Mac's Launch bar by positioning your mouse at the bottom edge of the screen until it appears.

2. If you don't see an icon for the <a target="_blank" href="https://wilsonmar.github.io/mac-osx-terminal/">Terminal program</a>, click the magnifying glass icon always at the upper-right corner and type in Term until "Terminal app" is highlighted, then press Enter to accept it.

3. Click menu Shell then click New Window for a Terminal session.

   PROTIP: More experienced people hover the mouse over New Window and click on one of the options.

   The Terminal program is called a "Bash" shell, which is a contraction of the term "Bourne-agan shell", which is a play on words.


   <a name="VersionWithGap"></a>

   ### Version with Grep

1. Test if you have Bash v4 installed by typing this:

   <pre><strong>bash --version | grep 'bash'
   </strong></pre>

   Bash 4.0 was released in 2009, but Apple still ships version 3.x, which first released in 2007.

   You have a recent version of Bash if you see:

   <pre>GNU bash, version 4.4.19(1)-release (x86_64-apple-darwin17.3.0)
   </pre>

   PROTIP: The attribute to obtain the version can vary among different commands.
   "--version" or "-v" or "version" may be used.

   Hold the Shift key to press the | (called pipe) key at the upper-right of the keyboard.

   The <tt>grep 'bash'</tt> is needed to filter out lines that do not contain the word "bash" in the response such as:

   <pre>GNU bash, version 4.4.19(1)-release (x86_64-apple-darwin17.3.0)
   Copyright (C) 2016 Free Software Foundation, Inc.
   License GPLv3+: GNU GPL version 3 or later &LT;http://gnu.org/licenses/gpl.html>
   &nbsp;
   This is free software; you are free to change and redistribute it.
   There is NO WARRANTY, to the extent permitted by law.</pre>

   If you have bash v3 that comes with MacOS, <a target="_blank" href="https://www.admon.org/scripts/new-features-in-bash-4-0/">this blog describes what is improved by version 4</a>.

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

   Version 4 is needed for <a href="#BashArrays">"associative arrays"
   needed in the script</a>.

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
