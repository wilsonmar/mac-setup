---
lastchange: "v032 + headers & download zip steps :README.md"
---

<a target="_blank" href="https://github.com/wilsonmar/mac-setup/blob/main/README.md ">This article</a>
has been <a target="_blank" href="https://wilsonmar.github.io/mac-setup">
refined over several years</a> to provide the the <strong>fastest</strong> way to get a new macOS machine up and running.

After you complete the steps below, you can legitimately add to your resume or LinkedIn profile:

   <ul>Configured new Macs, from scratch, with a full set of
   <a href="#UtilitiesInstalled">utilities</a>, AI apps, and access to
   AWS, Azure, and Google cloud services.
   Our use of custom shell script automation reduced onboarding time
   <strong>from days to less than an hour</strong>
   Documentation of each step were documented and validated by others.
   With a common set of tools, the entire team can now pair program together efficiently.
   This declarative approach updates all apps and modules with a single command, which meets cybersecurity directives to keep software up-to-date frequently.
   </ul>

<a href="#Actions">Manual actions</a> described below have you customize configuration files that control automation scripts you run in a Terminal.

We make use of automation so it's less error-prone and faster because we've worked out the dependency clashes for you. In each stage, our script detects what has already been installed and verifies the success of each step. So it can perform workarounds for known issues.


<a name="Actions"></a>

## Stages of Action


1. <a href="#Hardware">Hardware selection and connection</a>
1. <a href="#NewMachine">New Machine Bootup</a>
1. <a href="#TimeMachine">Time Machine Backup</a>
1. <a href="#ResetToFactorySettings">Reset to Factory Settings</a>

1. <a href="#SystemSettings">Shortcut to System Settings</a>
1. <a href="#AltClick">Change Annoying Defaults</a>
1. <a href="#LoginItems">System Login items</a>

1. <a href="#DefaultBrowser">Default Browser</a>
1. <a href="#ViewREADME">View files in browser</a>
1. <a href="#GitHubAccount">GitHub Account</a>

1. <a href="#Finder">Learn the Finder app & Folders</a>

1. <a href="#Passkey">Passkey</a>

1. <a href="#DownloadZip">Download zip of mac-setup</a>
1. <a href="#BashVsZsh">Bash vs. Zsh</a>
1. <a href="#ViewMacSetupFolder">View mac-setup folder</a>

1. <a href="#TextEditors">Default Text Editors</a>

1. <a href="#Terminal">Learn the Terminal app</a>

1. <a href="#mac-setup.sh">View mac-setup folder</a>
1. <a href="#BashVsZsh">View .bash_profile</a>

1. <a href="#GitHubAccount">Setup GitHub account</a>

1. <a href="#Homebrew">Use Homebrew</a>
1. <a href="#ForkAndClone">Load gh to fork & clone mac-setup automation folder</a>
1. <a href="#AppsInstalled">Apps Installed</a>
1. <a href="#Dotfiles">Configure using AppleScript in a Dotfile</a>
1. <a href="#EditEnv">Edit mac-setup.env settings in $HOME</a>
1. <a href="#UtilitiesInstalled">Utilities Installed</a>

1. Move Home directory to External SSD?

1. <a href="#FinalSteps">Final Steps</a>

<hr />


<a name="FastChange"></a>

### Fast Change!

Apps and modules can be installed by simply adding a keyword in a control file recognized by the automation, which installs and configures them quickly and reliably.

Instead of or in addition to the default apps, you can specify additional apps to install:

   * <a href="#SafariBrowser">Safari browser</a>: Google Chrome, Firefox, Microsoft Edge, Brave,etc.
   * <a href="#Terminal">Terminal.app</a>: iTerm2, Warp, etc.
   * <a href="#Editors">Editors vim</a>: VSCode, Windsurf, Cursor, etc.

Default apps can be specified for removal (to save disk space) by changing a list of apps in the script.

Scripts here are <strong>modular</strong>. It installs only what you tell it to by adding a keyword in the control file.

This repo brings DevSecOps-style <strong>"immutable architecture"</strong> to MacOS laptops. Immutability means replacing the whole machine instance instead of upgrading or repairing individual components.

<hr />

<a name="Hardware"></a>

## Hardware selection and connection

1. See my article about considerations of different hardware at:<br />

   * <a target="_blank" href="https://bomonike.github.io/mac-mini/">Mac Mini hardware</a>
   * <a target="_blank" href="https://wilsonmar.github.io/apple-macbook-hardware/">Mac laptop hardware</a>

   ### Hubs 

   PROTIP: CAUTION: A hub may slow down the machine. Get a hub with its own power supply.

   [_] If you must use a hub, get one that supports the fastest connection:

   ### Monitor cables
   
   Use the appropriate type and version of cables. REMEMBER: If you have a Mac Mini:
   <a target="_blank" href="https://res.cloudinary.com/dcajqrroq/image/upload/v1731683979/mac-mini-front-back_fup4cz.png"><img src="https://res.cloudinary.com/dcajqrroq/image/upload/v1731683979/mac-mini-front-back_fup4cz.png"></a>

   The front panel has USB-C ports that supports <strong>USB-C</strong> cables which transfers data at 10Gbps and powers up to 100W.
   The back panel has Thunderbolt ports:
   * The Mac Mini base model supports <strong>Thunderbolt 4</strong> cables which transfers data at 40Gbps and powers up to 100W for dual 4K displays.
   * The Mac Mini Pro  model supports <strong>Thunderbolt 5</strong> cables which transfers data at 120Gbps and powers up to 250W for dual 6K displays. 
   
   * <strong>HDMI v3.2</strong> cables are needed to support 4K displays.

   Some TVs do not show the top of the screen where the menu bar and Mission Control are displayed. Mission Control is a built-in feature of macOS
   to switch between groups of open apps and windows (using control + up arrow) and control + down arrow).

   ### Keyboards

1. If you have a Bluetooth keyboard, you can use the USB port for something else. 

   PROTIP: A keyboard with a "delete" key is useful especially if you are used to working with Windows.
   The macOS keyboard requires users to awarkly press "fn" key and then "delete" key to delete.

   Some <a target="_blank" href="https://www.logitech.com/en-us/products/keyboards/mice/keyboard-mice.html">Logitech USB keyboard and mouse models</a> come with a USB dongle.

   See my article about the <a target="_blank" href="https://wilsonmar.github.io/macos-keyboard/">macOS keyboards</a>.

   <a target="_blank" href="https://www.apple.com/support/keyboard/">Keyboards from Apple</a> are different from generic USB keyboards for Windows:

   * Some don't have a "delete" key. Instead hold down the "fn" key and press the "delete" key.
   * The button at the upper-right is a fingerprint reader and on/off button
   * The modifier keys Command is used instead of Control.

1. Consider an ergonomic mouse. If you are right-handed, consider a left-handed mouse so that you write with your right hand while you use the mouse.


<a name="NewMachine"></a>

## New Machine & Account Setup

1. Connect the computer to power. Connect the monitor, keyboard, mouse, etc. 

1. [_] Connect to a UPS (Uninterruptible Power Supply) which ensures clean power and protects from power surges. Abrupt power loss is a common cause of data loss. A UPS also enables you to power on and off all components with one button. Press the power buttons.

1. See my article about the <a target="_blank" href="https://wilsonmar.github.io/macos-bootup/">macOS boot-up process</a>.

1. After boot-up, select the new machine's language, time zone, keyboard layout, icloud email & password,user name & password are manual first steps.

   PROTIP: Write down the secrets along with the computer's serial number, etc. to help you deal with insurance and replacements if needed.

1. When prompted to upgrade your Mac, choose to upgrade to the latest version (which may take several minutes) to get your Mac up to date.


<a name="TimeMachine"></a>

## Time Machine Backup

The built-in Time Machine app backs up files and folders so you can completely restore the whole computer to the state when backup occured.

CAUTION PROTIP: Complete backups are often NOT restored when malware may have been added and thus present in the backup files restored.

PROTIP: Our automation scripts also copies specific folders and text files to an external USB drive so they can be used to build a new machine <strong>from scratch</strong> after examination.

1. [_] Buy a new external USB NVMe SSD drive, which are more durable than magnetic (spinning) hard drives. P68 rated T7 are $126 for 2TB at Costco.
1. [_] Have a fire-resistant vault to store backup media.
1. [_] For lower cost than a spectrum analyzer to capture emissions on several frequencies, put a cell phone inside which has been installed with the <a target="_blank" href="https://velter.co/en-en/blogs/blog/shielding-tester-a-pocket-sized-faraday-cage-tester-for-android-and-ios">"Shielding Tester" app (from Velter KZ)</a> to detect Wi-Fi and cell signals.
1. [_] Get a "Faraday dry sack" to keep the USB drive dry, dust-free, and free from electromagnetic fields. <a target="_blank" href="https://www.youtube.com/watch?v=EPVQ8m_yBVA">VIDEO</a>:
   * Mylar blankets -8 dBm (not much protection)
   * Aluminum foil -17 dBm
   * Metal boxes (Ammo cans) -30 dBm
   * -40 dBm is minimal level needed to block WiFi signals
   * Mission Darkness bag -45 dBm
   * NEST Z-bag with zip closure -51 dBm <a target="_blank" href="https://www.youtube.com/watch?v=eyIl7FfwXbs">VIDEO</a>
   * Faraday Defense NX single-layer fold-over bag -60 dBm (99.9% of signals are blocked)
   * <a target="_blank" href="https://www.faradaydefense.com/products/nx3">Faraday Defense NX3</a> double-layer fold-over bag, <a target="_blank" href="https://www.amazon.com/Faraday-Defense-17L-Waterproof-Backpack/dp/B08TMYC3RY/">$175 dry bag</a>, tower bag: -80 dBm (all signals are blocked) 

1. Plug in the new USB drive for storing backups.


   ### Dock

   The default app icons displayed on the bottom of the screen is called the "Dock".

   Click on any icon to open that application.

1. Open Time Machine by clicking the Launchpad icon on the Dock displaying a list of apps, then click on the "Time Machine" app icon.

   The Dock is by default always visible on the bottom of the screen, but the automation script move it to the right side and appears when you hover over the right side of the screen.

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

Finishing this enables you to confirm your ability to restore your computer to the state when the backup was taken.

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
   1. For Keyboard shortcut, press <strong>Shift + Option + Command + P</strong> (use your left pinky finger to press Shift and right finger to press P).
   1. Click "Done" to save the shortcut.

   1. Try it out by clicking on the Apple icon on the upper left corner to see the keystrokes for "System Settings...". Try the keyboard sequence shown.

<a target="_blank" href="https://www.youtube.com/watch?v=dxjTPYUiLpQ">VIDEO</a>: Similarly, <strong>Shift + Option + Command + V</strong> performs "Paste and Match Style" shown in Finder > Edit. 


<a name="AltClick"></a>

## Change Annoying Defaults

Most System Settings can also be changed programmatically by commands in <a href="#Dotfiles">mydotfile</a> specification automation described later in this README file. 

However, some default settings are so annoying that most users want to change them right away:

1. Click the Apple icon on the upper left corner of the screen.
1. Click the "System Settings...".
1. Scroll down to click "Mouse".

1. For "Tracking speed", drag the dot closer to "Fast" on the right.
1. For "Secondary Click", select "Click Right Side" (which is why it's called "Right-Click").

1. Exit the dialog.


<a name="LoginItems"></a>

### System Login items

PROTIP: Review this once a month to ensure that you have control of your machine. Here is where malicious software can get access.

1. Within Apple System Settings, click the "Search" text within the field at the upper-left corner.
1. Type "Login" on top of "Search".
1. If you don't want to have a program Open at Login, click on that app and click the "-" button.
1. If you want to have Allow in the Background a program, click on the toggle to its left.


<a name="DefaultBrowser"></a>

## Default Browser

Safari is the default browser on MacOS.

The automation script will install other browsers if specified.

1. To ensure that cookies in the browser are not confused, open the browser you want to use. Select the browser profile you want to use.

   You may need tonavigate to that browser's settings and make that the default and profile. For example: chrome://settings/defaultBrowser


<a name="ViewREADME"></a>

## View files in browser

So you can click links within this README file on the target machine:

1. To open Safari, near the left among the default list of apps at the bottom of the screen, click on the "Safari" browser icon.

1. Click on the middle field to type on top of "Search or enter website name".

1. Type in this URL to reach this README file:

   <a target="_blank" href="https://github.com/wilsonmar/mac-setup/blob/main/README.md#ViewREADME">https://github.com/wilsonmar/mac-setup/blob/main/README.md#ViewREADME</a>

1. Read through to this section for manual instructions.


<a name="GitHubAccount"></a>

### GitHub Account

Repositories defined as "Public" can be downloaded without creating a GitHub account.

But if you have not yet obtained a GitHub account,

1. In a web browser, sign up for one with your email address at

   <a target="_blank" href="https://github.com/">https://github.com/</a>

1. We recommend installing Twillo's Authy app for two-factor authentication.

1. Define the GitHub account name and email you want the the automation script to use, such as:
   ```
   [user]
   email = John Doe
   name = johndoe+github@gmail.com
   ```

1. TODO: Configure SSH and GPG keys.


<a name="Finder"></a>

## Learn Finder app & Folders

The default GUI app for opening files and folders is the Finder GUI app.

It is the one default app that can't be removed.

1. Open the Finder app by clicking on the Finder icon (on the Dock).

1. To see what's in the invisible Clipboard, click on the Edit menu item, then "Show Clipboard".

1. Click the "Go" menu at the top.
   <a target="_blank" href="https://res.cloudinary.com/dcajqrroq/image/upload/v1732811817/macos-finder-keys_rsoadf.png"><img align="right" alt="macos-finder-keys.png" width="100" src="https://res.cloudinary.com/dcajqrroq/image/upload/v1732811817/macos-finder-keys_rsoadf.png" /></a>

1. Folders on the left panel may be rearranged by being dragged and dropped.

1. If you want the speed of using keyboard shortcuts Apple created,
   <strong>memorize</strong> the Go keyboard shortcut keys and right-click to remove each from the Folder's left menu Side Bar.

   Entries on the left Side Bar makes it convenient to drop files into that folder from another Finder folder.

1. As the "Go" menu show, click the shortcut keys to reach the "Computer": Press 
   
   <strong>Shift + Command + C</strong>

   This is the very top level. "Macintosh HD" not a folder but the drive.
   "Network".

1. Click on "Macintosh HD" to display the top "root" level folders defined by Apple, referenceable with a "/" slash character:

   * <tt>/Applications</tt> contain apps that can be opened by any user and also<br /><tt>/Applications/Utilities</tt> containing what Apple provides, such as the Terminal app.
   * <tt>/Library</tt> contains data for each application
   * <tt>/System</tt>
   * <tt>/Users</tt> contains a folder for <strong>each user account</strong> created.
   
1. Click on "Users", then your user name (such as "johndoe") to display the $HOME level folders Apple creates for each new user. Examples:

   * <tt>/Users/johndoe/</tt> contains apps that can only be used by a user hypothetically named "johndoe". An Application folder is automatically created for each user account.

1. Drag your user name folder (such as "johndoe") and drop it at the top of the left Side Bar.

1. Click the user name folder (such as "johndoe") to display the $HOME level folders Apple creates for each new user. Examples:

   * <tt>/Users/johndoe/Applications</tt> containing apps that can only be used by a user hypothetically named "johndoe". Other default folders:

   * Desktop
   * Documents
   * Downloads
   * Movies
   * Music
   * Pictures
   * Public

1. Create an folder within your $HOME folder by clicking the round icon with three dots, and select "New Folder" to create a new folder named "untitled folder".

1. Rename that name to contain "gh-" and your GitHub user account name. Here is where you Git clone into. For example, if your GitHub user account is "johndoe", create a folder named:

   <tt>gh-johndoe</tt>

1. Press <strong>shift + command + .</strong> (period key) to display <strong>hidden</strong> files and folders named with a "." character.

   Many 3rd-party modules (such as Git) install create a hidden folder such as ".git" to store application data related to the user.


<a name="Dotfiles"></a>

## Setup using AppleScript in a Dotfile

Most System Settings can also be changed programmatically by commands in the dotfilespecification script:

   <ul><a target="_blank" href="https://github.com/wilsonmar/mac-setup/blob/main/mydotfile.sh">https://github.com/wilsonmar/mac-setup/blob/main/mydotfile.sh</a>
   </ul>

The sequence of commands is the structure of the Apple System Setting app GUI tree.


<a name="Passkey"></a>

### Install Passkey

https://wilsonmar.github.io/passkeys/

Even complex passwords can easily be cracked within seconds.
So traditional passwords are replaced with biometric fingerprint Touch ID, Face ID, or Windows Hello to authenticate your identity. Biometrics are used instead of having to using an additional app such as Authy.

Passkeys was introduced in 2022 for Apple Safari on macOS 13 Ventura and later.

macOS 15 (Sequoia) introduced a standalone Passwords app, providing a more refined passkey management interface.
   1. Open the Passwords app from your Applications folder.
   1. Click on the Passkeys tab and select Add New Passkey.
   1. Follow the on-screen instructions to complete the setup, using biometric verification or your device password.
   1. Manage, edit, or delete your passkeys within this app.

Enable Two-Factor Authentication (2FA) for your Apple ID if not already activated1.

Google Chrome and Microsoft Edge support Passkeys.
But Passkeys created with Apple Safari are not compatible with other ecosystems (such as Google Chrome).

Instead of create a separate Passkey on Chrome and Edge,
if you’re logging in from a non-Apple device, you can use cross-device authentication through QR codes or Bluetooth.

To install passkeys on macOS, follow these steps:

Enable iCloud Keychain:
1. Open Apple System Settings
1. Click "Apple ID" at the top left. Click "iCloud".
1. Click "Passwords and Keychain".
1. Toggle on iCloud Keychain "Sync this Mac".

   https://medium.com/@corbado_tech/activate-apple-passkeys-on-macbooks-3cf5cc83bef7

   Create a passkey:

1. Visit a website or app that supports passkeys, such as PayPal.com.

1. Look for an option to create a passkey during account creation or in account settings.

1. Select "Create Passkey" when prompted.

1. Authenticate using Touch ID or your device passcode.

1. Use the standalone Passwords app in the Applications folder
1. Click on the Passkeys tab and select "Add New Passkey"
1. Follow on-screen instructions to complete setup.


<hr />


<a name="DownloadZip"></a>

## Download mac-setup zip

PROTIP: This approach is designed so that you can examine the script before running it.

1. In a browser window, click this link or highlight and copy the URL and paste in the browser URL address bar to navigate to the GitHub repository that contains the mac-setup files:

   <a target="_blank" href="https://github.com/wilsonmar/mac-setup/">https://github.com/wilsonmar/mac-setup/</a>

   <a target="_blank" href="https://res.cloudinary.com/dcajqrroq/image/upload/v1732937627/github-code-920x836_pff2d3.png"><img alt="github-code-920x836.png" src="https://res.cloudinary.com/dcajqrroq/image/upload/v1732937627/github-code-920x836_pff2d3.png"></a>

1. Click the green "Code" button to the right of the URL.

1. Select "Download ZIP" to see the animation to the your Downloads folder.

1. Specify the default "main" branch of the GitHub repository that contains the mac-setup files.

1. Click the "Downloads" icon at the lower-right of the screen to double-click "mac-setup-main".

1. In the Downloads folder, unzip the file and open the mac-setup folder by <strong>double-clicking</strong> the folder icon. Or, right-click and select "Open" to open the folder.

   Later in this document, this folder will replaced by a version-controlled folder created by the Git clone utility.


<a name="Bash"></a>

## Bash vs Zsh

File names ending with ".sh" uses the Bash interpreter.<br />File names ending with ".zsh" uses the Zsh interpreter. 

In this project, we use Bash rather than Zsh in order for the script to possibly be adapted for work on Linux and Windows machines as well. ".sh" is a contraction of the term "shell" based on the 
"Bash" language (aa contraction of the term "Bourne-agan shell" -- a play on words).
   
The automation script upgrades the "Bash" interpreter to the latest version because
Apple stopped upgrading Bash due to licensing issues and switched to Zsh as the default macOS shell interpreter since macOS 12 Monterey.


<a name="ViewMacSetupFolder"></a>

## View the mac-setup folder

The mac-setup folder contains the following Bash script files (among other files explained later):

   * <a href="#Bash">.bash_profile</a> contains what is executed before each Terminal session opens.
   * <a href="#Dotfiles">mydotfile.sh</a> contains the commands to change Apple System Settings.
   * <a href="#Aliases">aliases.sh</a> contains the keyboard aliases created before each Terminal session.

   * <a href="#mac-setup.sh">mac-setup.sh</a> is the main automation script that runs based on the specifications defined in the above files.

   * <a href="#EditEnv">mac-setup.env</a> contains the environment variables used by the mac-setup.sh script. The automation script can make a folder to hold the folder (GitHub repository) that can version control files, based on the folder name you specify in the mac-setup.env configuration file.


<a name="TextEditors"></a>

## Default Text Editors

There are several text editors that come pre-loaded with macOS, including TextEdit, Sublime Text, and Atom. You can use any of these editors to edit files.

However, you may prefer to use a more powerful text editor (VSCode, etc.) by first running the "mac-setup.sh" script to install them.


<a name="Terminal"></a>

## Learn the Terminal app

The built-in Terminal utility app is used to execute shell scripts like on Linux machines.


1. Hold down the <strong>Command</strong> key and press <strong>spacebar</strong> to pop up the Spotlight Search modal dialog.

1. Type on top of "Spotlight Search" <strong>Ter</strong> so enough of "Terminal.app" appears to press Enter to select it in the drop-down.

1. When "Terminal.app" is highlighted, click it with your mouse or press the <strong>return</strong> key to launch the Terminal.app program selected.

   The default Terminal CLI (Command Line Interface) prompt begins with the <strong>user name</strong> value
   defined in the <tt>PS1</tt> system variable that the automation script changes.

   ### Basic CLI commands

1. Type <tt>pwd</tt> to see the "present working directory", which is the current folder you are in. The path shown is also stored in a variable named <tt>$HOME</tt>.

1. Type <tt>ls -al</tt> to see the default folders and files in your $HOME folder. The <tt>-al</tt> parameter specifies to show all folders and files as a list.

1. To reduce <strong>text wrapping</strong> of long lines, expand the width of your Terminal window by dragging the right edge with your mouse.

1. To specify a folder containing a space character, add double-quote to the string:
   ```
   ls -al "/Library/Application Support"
   ```
   Alternately, if that space character is specified as an escape character using the "\" escape command:
   ```
   ls -al /Library/Application\ Support
   ```
   REMEMBER: Typing the "~" variable is the same as typing the "$HOME" variable.
   Typing a space character within "Application Support" require double-quotation marks unless
   that space is preceded by the "\" escape command.

   REMEMBER: The folder for an app is not deleted when the application is deleted.

   <a name="KeyboardAliases"></a>

   ### Keyboard aliases (shortcuts)

   PROTIP: The automation script installs keyboard aliases (shortcuts) you can use to improve typing speed and accuracy. Examples:

   * <tt>alias ll="ls -al"</tt>
   * <tt>alias l="ls -l"</tt>
   * <tt>alias h="history"</tt>

1. View all the aliases defined in the <tt>aliases.sh</tt> file called from within .bash_profile in the $HOME folder:

   <a target="_blank" href="https://github.com/wilsonmar/mac-setup/blob/main/aliases.sh">https://github.com/wilsonmar/mac-setup/blob/main/aliases.sh</a>


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



   ### PATH environment variable

   TODO: $PATH folders separated by semicolons
   
zzz

   <a target="_blank" href="https://github.com/wilsonmar/mac-setup/blob/main/mac-setup.sh">https://github.com/wilsonmar/mac-setup/blob/main/mac-setup.sh</a>

   CAUTION: The remainder of this article explains how to run the script.

   That automation script is manually invoked several times using different parameters on the Terminal command line, each time for a different phase of installation.

   However, script mac-setup.sh can upgrade Bash to the latest version.

1. Click "fork" to copy the script to your own GitHub account.

Next, let's get that script onto your machine using "Bash" CLI (Command Line Interface) commands within the Terminal app.


<a name="CreateFolders"></a>

## Create Folders

1. Define the .env files

1. Open the Terminal app and type:
   ```
   mkdir -p "$HOME/gh-wmjtm"
   ```



<a name="ForkAndClone"></a>

## Fork and Clone using the GH CLI

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

1. Press <strong>command + up</strong> again to display the top level containing "Macintosh HD" and "Network" folders.

   The Go menu shows the shortcut keys to reach this folder as: Command + Shift + G

   "Macintosh HD" contains the folder for the current user account, such as "Users/johndoe".

   PROTIP: Installers of apps being installed are shown in this folder.


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


<a name="mac-setup.parms"></a>

### View mac-setup.sh parameters

1. We want to upgrade Bash to the latest version.


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


<a name="secrets.sh"></a>

## secrets.sh

The above list is from the <strong>secrets.sh</strong> file in your $HOME folder, which
you edit to specify which port numbers and <strong>keywords to specify apps</strong> you want installed.

   The file's name is suffixed with ".sh" because it is a runnable script that establishes memory variables for a <a href="#MainScript">Setup script</a> to reference.


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

## Extras

1. Switch back to the Finder GUI.

1. To get the disk space used by this folder using this command:
   ```
   du -sh "$HOME"
   ```
1. Switch back to the Finder GUI.
1. Press <strong>command + down</strong> to go down a level.

