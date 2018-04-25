---
layout: post
title: "Install, configure, and test all on a MacOS laptop"
excerpt: "Everything you need to be a professional developer"
tags: [API, devops, evaluation]
Categories: Devops
filename: README.md
image:
  feature: https://cloud.githubusercontent.com/assets/300046/14612210/373cb4e2-0553-11e6-8a1a-4b5e1dabe181.jpg
  credit: And Beyond
  creditlink: http://www.andbeyond.com/chile/places-to-go/easter-island.htm
comments: true
---
<i>{{ page.excerpt }}</i>

The tagline of this repo is "Automatically install and configure the dozens of programs that a developer needs to work offline as a developer of several stacks on a Mac."

This script was created to help people cope with the large number of apps needed to be a "full stack" developer today. This installs several stacks with sample repositories: 
 
   * MEAN (MongoDB, Express, Angular, NodeJs) with the MeanJs sample app
   * JAM (Jekyll, APIs, Markup) with a sample Github.io website
   * MAMP (Macintosh, Apache/Nginx, MySQL, PHP) for WordPress websites
   * Python, etc.

Most tutorials on each of the above have you <strong>manually type</strong> or copy and paste commands, which can take hours, and be error-prone.

You will benefit most if you configure a <strong>new</strong> laptop for yourself or for other developers joining your organization. You'll skip wasted days installing everything one at a time (and doing it differently than colleagues).
This repo brings DevSecOps-style <strong>"immutable architecture"</strong> to MacOS laptops. Immutability means replacing the whole machine instance instead of upgrading or repairing faulty components.

But this script helps with updates too. You can, but don't have to, start from scratch. 
Although you may use Apple's Time Machine app to backup everything to a USB drive or AirPort Time Capsule, you may want a way to <strong>keep up with the latest changes</strong> in apps updated to the latest version, by running a single "upgrade" command. 

This bash script enables you to <strong>work offline</strong> by installing several servers. You manage allocation of port numbers in one place:

   <pre>
     GRAFANA_PORT="8089"    # VIZ_TOOLS from default 8080
     JEKYLL_PORT="4000"     # from default 4000
     JENKINS_PORT="8088"    # LOCALHOSTS from default 8080
     MYSQL_PORT="3060"      # DATA_TOOLS default 3060
     MEANJS_PORT="3000"     # from default 3000
     MINIKUBE_PORT="8083"   # from default 8080
     NEO4J_PORT="7474"      # DATA_TOOL default 7474 HTTPS: 7473
     NGINX_PORT="8086"      # LOCALHOSTS from default 8080
     POSTGRESQL_PORT="5432" # DATA_TOOLS default 5432
     PROMETHEUS_PORT="9090" # MON_TOOLS default 9090
     REDIS_PORT="6379"      # DATA_TOOLS default 6379
     SONAR_PORT="9000"      # DATA_TOOLS default 9000
     TOMCAT_PORT="8087"     # LOCALHOSTS from default 8080
   </pre>

You specify which port numbers and apps you want by editing the <strong>secrets.sh</strong> file in this repo.

* MAC_TOOLS mas, Ansible, 1Password, PowerShell, Kindle, etc.
* EDITORS Atom, Code, Eclipse, Emacs, IntelliJ, Macvim, STS, Sublime, Textmate, vim
* BROWSERS chrome, firefox, brave, phantomjs
* GIT_CLIENTS git, cola, github, gitkraken, smartgit, sourcetree, tower, magit, gitup
* GIT_TOOLS hooks, tig, lfs, diff-so-fancy, grip, p4merge, git-flow, signing, hub

* JAVA_TOOLS Maven, Ant, Gradle, TestNG, Cucumber, Junit4, Junit5, Yarn, dbunit, Mockito,
          JMeter, GCViewer, JProfiler, etc.
* PYTHON_TOOLS Virtualenv, jupyter, anaconda, ipython, numpy, scipy, matplotlib, pytest, robotframework, etc.
* NODE_TOOLS Bower, gulp, gulp-cli, npm-check, jscs, less, jshint, eslint, webpack, etc.

* DATA_TOOLS mongodb, postgresql
* TEST_TOOLS selenium, sikulix, golum, dbunit
* CLOUDS icloud, aws, gcp, azure, cf, heroku, docker, vagrant, terraform, serverless
* MON_TOOLS (for monitoring) WireShark, Prometheus, others
* VIZ_TOOLS (for visualization) Grafana, others (Prometheus, Kibana, Graphite)

* COLAB_TOOLS (for collaboration) google-hangouts, hipchat, joinme, keybase, microsoft-lync, skype, slack, teamviewer, whatsapp, sococo, zoom
* MEDIA_TOOLS Audacity, Camtasia, Snagit, etc.
<br /><br />

Yes, you can just run brew yourself. But logic in the script goes beyond what Homebrew does, and <strong>configures</strong> the component just installed:

   * Install dependent components where necessary
   * Display the version number installed (to a log)
   * Add alias and paths in <strong>.bash_profile</strong> (if needed)
   * Perform configuration (such as adding a missing file needed for mariadb to start)
   * Edit configuration settings (such as changing default port within Nginx within config.conf file)
   * Upgrade and uninstall if that is available
   * Run a demo using the component to ensure that what has been installed actually works. 
   <br /><br />

We also have Docker instances:

   <pre>
     PROMETHEUS_PORT="9090"  # from default 9090
   </pre>

## Make this work for you

1. The starting point (generic version) of these files are in a public GitHub repository you're reading right now:

   <a target="_blank" href="
   https://github.com/wilsonmar/mac-setup">
   https://github.com/wilsonmar/mac-setup</a>

   If you know what I'm talking about and have a GitHub account, you may Fork the repo under your own account and, while in a Teminal window at your Home folder, git clone it locally under your Home folder.
   This approach would enable you to save your changes back up to GitHub under your own account.

   Alternately, follow these steps to create an initial installation of what many developers use
   (but you won't be able to upload changes back to GitHub):

2. Triple-click this command and press command+C to copy to your invisible Clipboard:

   <pre><strong>sh -c "$(curl -fsSL https://raw.githubusercontent.com/wilsonmar/mac-setup/master/mac-setup-all.sh)"
   </strong></pre>

   This is why mac-setup-all.sh is called a <strong>"bootstrapping"</strong> script.

   This script references a folder in your Home folder named <strong>mac-setup</strong> (the name of this repo). The folder contains a configuration file named <strong>secrets.sh</strong> which you edit to specify what you want installed and run. The file's name is suffixed with ".sh" because it is run to establish variables for the script to reference. You don't run the file yourself.

   Technical techniques for the Bash shell scripting are described separtely at [Bash scripting page in this website](/bash-coding/).

2. Open a Terminal window.
2. Press command+V (at the same time on your keyboard) to paste it from Clipboard.
3. Press Enter to run it.

   If your home folder does not contain a folder named "mac-setup",
   the script will create one by Git cloning, using a Git client it first installs if there isn't one already.

   A folder is necessary to hold additional folders such as "hooks" used by Git (if marked for install.)
   File "mac-bash-profile.txt" contains starter entries to insert in ~/.bash_profile that is executed before MacOS opens a Terminal session. 
   Ignore the other files.

4. Wait for the script to finish.

   On a 4mbps network the run takes less than 5 minutes for a minimal install.

   PROTIP: A faster network or a proxy nexus server providing installers within the firewall would speed things up a lot and ensure that vetted installers are used.

   When the script ends it pops up a log file in the TextEdit program that comes with MacOS.

5. Within TextEdit, review the log file.
6. Close the log file.
7. click File and navigate to your Home folder then within <tt>mac-setup</tt> to 
   open file <strong>secrets.sh</strong> in the repo so you can customize what you want installed. 

   <pre><strong>textedit secrets.sh
   </strong></pre>

   PROTIP: The default specification in the file is for a "bare bones" minimal set of components.
   If you run it again, it will not install it again.

   There is a key (variable name) for each category (MAC_TOOLS, etc.).

8. Among the comments (which begin with a pound sige) look for keywords for programs you want.
   
   Keywords shown are for the most popular programs. The mac-setup-all.sh script contains logic go
   get it setup fully <a href="#Extras">(as summarized above)</a>.


   ### TRYOUT one at a time

8. Scroll to the bottom of the secrets.sh file and click between the double-quotes of <tt><strong>TRYOUT=""</strong></tt>.

   Paste or type the keyword of the components you want opened (invoked) by the script.

   We don't want to automatically open every component installed because that would be overwhelming.

   This way you have a choice.

9. Save the file. You need not exit the text editor completely if you want to re-run.
10. Run the script to carry out your changes:

    <pre><strong>chmod +x mac-setup-all.sh
    mac-setup-all.sh 
    </strong></pre>

    There are several variations possible:

    ### Update All Calling Arguement 

11. Upgrade to the latest versions of ALL components when "update" is added to the calling script:

    <pre><strong>chmod +x mac-setup-all.sh
    mac-setup-all.sh update
    </strong></pre>

    CAUTION: This often breaks things because some apps are not ready to use a newer dependency.

    NOTE: This script does NOT automatically uninstall modules.
    But if you're brave enough, invoke the script this way to remove components so you recover some disk space:

    <pre><strong>
    mac-setup-all.sh uninstall
    </strong></pre>

    This is not an option for components that add lines to ~/.bash_profile.
    It's quite dangerous because the script cannot differentiate whether customizations occured to what it installed.

    ### Edit mac-setup.sh for others

    There are lists of additional programs (components) you may elect to install.

12. At the Terminal, use TextEdit or a other text editor to view the script file:

    <pre><strong>textedit mac-setup.sh
    </strong></pre>

13. Press command+F to search for "others" (including the double-quotes).
 
    PROTIP: Several categories have a list of brew commands to install additional components.
    (MAC_TOOLS, PYTHON_TOOLS, NODE_TOOLS, etc.) 

14. For each additional component you want, delete the # to un-comment it.

    Remember that each component installed takes more disk space.


## Mac apps

Apps on Apple's App Store for Mac need to be installed manually. <a target="_blank" href="https://www.reddit.com/r/osx/comments/4hmgeh/list_of_os_x_tools_everyone_needs_to_know_about/">
Popular apps</a> include:

   * Office for Mac 2016
   * BitDefender for OSX
   * CrashPlan (for backups)
   * Amazon Music
   * <a target="_blank" href="https://wilsonmar.github.io/rdp/#microsoft-hockeyapp-remote-desktop-for-mac">HockeyApp RDP</a> (Remote Desktop Protocol client for controlling Microsoft Windows servers)
   * Colloquy IRC client (at https://github.com/colloquy/colloquy)
   * etc.

The brew "mas" manages Apple Store apps, but it only manages apps that have already been paid for. But mas does not install apps new to your Apple Store account.


<a name="JAVA_TOOLS"></a>

## Java tools via Maven, Ant

Apps added by specifying in JAVA_TOOLS are GUI apps.

Most other Java dependencies are specified by manually added in each custom app's <strong>pom.xml</strong> file
to specify what Maven downloads from the Maven Central online repository of installers at

   <a target="_blank" href="
   http://search.maven.org/#search%7Cga%7C1%7Cg%3A%22org.dbunit%22">
   http://search.maven.org/#search%7Cga%7C1%7Cg%3A%22org.dbunit%22</a>

Popular in the Maven Repository are:

   * <strong>yarn</strong> for code generation. JHipster uses it as an integrated tool in Java Spring development.
   * <strong>DbUnit</strong> extends the JUnit TestCase class to put databases into a known state between test runs. Written by Manuel Laflamme, DbUnit is added in the Maven pom.xml (or Ant) for download from Maven Central. See http://dbunit.wikidot.com/
   * <strong>mockito</strong> enables calls to be mocked as if they have been creted.
   Insert file java-mockito-maven.xml as a dependency to maven pom.xml
   See https://www.youtube.com/watch?v=GKUlQMrbtHE - May 28, 2016
   and https://zeroturnaround.com/rebellabs/rebel-labs-report-go-away-bugs-keeping-your-code-safe-with-junit-testng-and-mockito/9/

   * <strong>TestNG</strong> 
   See http://testng.org/doc/download.html
   and https://docs.mendix.com/howto/testing/create-automated-tests-with-testng
   
   When using Gradle, insert file java-testng-gradle as a dependency to gradle working within Eclipse plug-in
   Build from source git://github.com/cbeust/testng.git using ./build-with-gradle
   
TODO: The Python edition of this will insert specs such as this in pom.xml files.   

<a name="Logging"></a>

## Logging

The script outputs logs to a file.

This is so that during runs, what appears on the command console are only what is relevant to debugging the current issue.

At the end of the script, the log is shown in an editor to <strong>enable search</strong> through the whole log.


<a name="JenkinsStart"></a>

## Jenkins server

To start the Jenkins server to a specified port:

    <pre>jenkins --httpPort=$JENKINS_PORT  &</pre>

   The "&" puts the process in the background so that the script can continue running.

   The response is a bunch of lines ending with
   "INFO: Jenkins is fully up and running".

Several other methods (which don't work now) are presented on the internet:

   * <tt>sudo service jenkins start</tt>

   * <a target="_blank" href="https://three1415.wordpress.com/2014/12/29/changing-jenkins-port-on-mac-os-x/">
   This blog, on Dec 29, 2014</a> recommends

   <pre>sudo defaults write /Library/Preferences/org.jenkins-ci httpPort "$JENKINS_PORT"
   sudo launchctl unload /Library/LaunchDaemons/org.jenkins-ci.plist
   sudo launchctl load /Library/LaunchDaemons/org.jenkins-ci.plist
   </pre>


<a name="JenkinsJava"></a>

The command "jenkins" above is actually a bash script that invokes Java:

   <pre>#!/bin/bash
   JAVA_HOME="$(/usr/libexec/java_home --version 1.8)" \
   exec java  -jar /usr/local/Cellar/jenkins/2.113/libexec/jenkins.war "$@"
   </pre>

The code within "$(...)" is run to obtain the value. In this case, it's:

    <pre>/Library/Java/JavaVirtualMachines/jdk1.8.0_162.jdk/Contents/Home
    </pre>

   The link above is the folder where MacOS keeps the Java SDK.
   Java executables (java, javac, etc.) are in the bin folder below that location.

The path to jenkins.war and jenkins-cli.war executable files are physcally at:

   <pre>ls /usr/local/opt/jenkins/libexec</pre>


<a name="Jenkins"></a>

### Mac Plist file for Jenkins

Instead of specifying the port in the command, change the configuration file.

On MacOS, services are defined by <strong>plist</strong> files containing XML, 
such as this for Jenkins server:

   <pre>
&LT;?xml version="1.0" encoding="UTF-8"?>
&LT;!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
&LT;plist version="1.0">
  &LT;dict>
    &LT;key>Label&LT;/key>
    &LT;string>homebrew.mxcl.jenkins&LT;/string>
    &LT;key>ProgramArguments&LT;/key>
    &LT;array>
      &LT;string>/usr/libexec/java_home&LT;/string>
      &LT;string>-v&LT;/string>
      &LT;string>1.8&LT;/string>
      &LT;string>--exec&LT;/string>
      &LT;string>java&LT;/string>
      &LT;string>-Dmail.smtp.starttls.enable=true&LT;/string>
      &LT;string>-jar&LT;/string>
      &LT;string>/usr/local/opt/jenkins/libexec/jenkins.war&LT;/string>
      &LT;string>--httpListenAddress=127.0.0.1&LT;/string>
      &LT;string>--httpPort=8080&LT;/string>
    &LT;/array>
    &LT;key>RunAtLoad&LT;/key>
    &LT;true/>
  &LT;/dict>
&LT;/plist>
   </pre>

The "1.8" is the version of Java, <a href="#JenkinsJava"> described below</a>.

The "httpPort=8080" default is customized using this variable in secrets.sh:

      JENKINS_PORT="8082"  # default 8080

The above is file <tt>homebrew.mxcl.jenkins.plist</tt> within folder 
<tt>/usr/local/opt/jenkins</tt> installed by brew.
The folder is a symlink created by brew to the physical path where brew installed it:

      /usr/local/Cellar/Jenkins/2.113/homebrew.mxcl.jenkins.plist

The "2.113" means that several versions of Jenkins can be installed side-by-side.
This version number changes over time. So it is captured by command:

   <pre>JENKINS_VERSION=$(jenkins --version)  # 2.113</pre>

The folder is actually a symlnk which points to the physical folder defined by:
JENKINS_CONF="/usr/local/Cellar/Jenkins/$JENKINS_VERSION/homebrew.mxcl.jenkins.plist"

The path is defined in a variable so simplify the sed command to make the change:

         sed -i "s/httpPort=8080/httpPort=$JENKINS_PORT/g" $JENKINS_CONF
               # --httpPort=8080 is default.


<a name="JenkinsFirstTime"></a>

### Jenkins GUI in browser

The command to view the server in the default internet browser (such as Safari, Chrome, etc.) is:

   <pre>open "http://localhost:$JENKINS_PORT"</pre>

   It's "http" and not "https" because a certificate has not been established yet.

When executed the first time, Jenkins displays this screen:


However, we don't want to open it from the command line script, but from a GUI automation script.

<a name="JenkinsGUIAuto"></a>

### Jenkins GUI automation

The script invokes a GUI automation script that opens the file mentioned on the web page above:

   <pre>/Users/wilsonmar/.jenkins/secrets/initialAdminPassword</pre>

   "/Users/wilsonmar" is represented by the environment variable named $HOME or ~ symbol,
   which would be different for you, with your own MacOS account name.
   Thus, the generic coding is:

   <pre>JENKINS_SECRET=$(<$HOME/.jenkins/secrets/initialAdminPassword)</pre>

The file (and now $JENKINS_SECRET) contains a string in clear-text like "851ed535fd3249ab95a274d23242655c".

We then call a GUI automation script to get that string to paste it in the box labeled "Administrator Password"
based on the id "security-token" defined in this HTML:

   <pre>&LT;input id="security-token" class="form-control" type="password" name="j_password">
   </pre>

   This was determined by obtaining the outer HTML from Chrome Developer Tools.

The call is:

   <pre>python tests/jenkins_secret_chrome.py  chrome  $JENKINS_PORT  $JENKINS_SECRET
   </pre>

We use Selenium Python because it reads and writes system environment variables.

Use of Selenium and Python this way requires them to be installed before Jenkins and other web servers.


<a name="JenkinsShutdown"></a>

### Jenkins shutdown (kill)

To shut down Jenkins, 

   <pre>PID="ps -A | grep -m1 'jenkins' | awk '{print $1}'"
   fancy_echo "Shutting downn jenkins $PID ..."
   kill $PID</pre>

The above is the automated approach to the manual on recommended by many blogs on the internet:

   Some say in Finder look for Applications -> Utilities -> Activity Monitor
   
   Others say use command:

   <pre>ps -el | grep jenkins</pre>

   Two lines would appear. One is the bash command to do the ps command. 
   
   The PID desired is the one that lists the path used to invoke Jenkins, 
   <a href="#JenkinsJava">described above</a>:

   <pre>/usr/bin/java -jar /usr/local/Cellar/jenkins/2.113/libexec/jenkins.war</pre>

   <pre>kill <em>2134</em></pre>

   That is the equivalent of Windows command "taskkill /F /PID XXXX"

   There is also:

   <pre>sudo service jenkins stop</pre>

Either way, the response expected is:

   <pre>INFO: JVM is terminating. Shutting down Winstone</pre>


<a name="PythonGUI"></a>

## Python GUI Automation

If the title is not found an error message like this appears on the console:

   <pre>
  File "tests/jenkins_secret_chrome.py", line 30, in <module>
    assert "Jenkins [Jenkins]" in driver.title  # bail out if not found.
AssertionError
   </pre>


<a name="DelayToView"></a>

### Delay to view

Some put in a 5 second delay:

   <pre>time.sleep(5)</pre>

Use of this feature requires a library to be specified at the top of the file:

   <pre>import sys</pre>

<a name="ScreenShot"></a>

### Screen shot picture

Some also take a photo to "prove" that the result was achieved:

   <pre>driver.save_screenshot('jenkins_secret_chrome.py' +utc_offset_sec+ '.png')</pre>

We put the name of the script file in the picture name to trace back to its origin.
We put a time stamp in ISO 8601 format so that several png files sort by date.

utc_offset_sec = time.altzone if time.localtime().tm_isdst else time.timezone
datetime.datetime.now().replace(tzinfo=datetime.timezone(offset=utc_offset_sec)).isoformat()

The long explanation is https://docs.python.org/2/library/datetime.html


<a name="EndOfScript"></a>

### End of script

<a target="_blank" href="https://stackoverflow.com/questions/15067107/difference-between-webdriver-dispose-close-and-quit">
NOTE</a>:

   * webDriver.Close() - Close the browser window that currently has focus
   * webDriver.Quit() - Calls Dispose()
   * webDriver.Dispose() Closes all browser windows and safely ends the session

driver.quit() means that someone watching the script execute would only see the web app's screen for a split second. 

   We prefer to use id rather than name fields because the HTML standard states that id's are 
   supposed to be unique in each web page.

<hr />

<a name="Groovy"></a>

## Groovy

Other similar scripts (listed in "References" below) run

http://groovy-lang.org/install.html


<a name="CLOUD_TOOLS"></a>

## Cloud Sync

Dropbox, OneDrive, Google Drive, Amazon Drive


<a name="EclipsePlugins"></a>

## Eclips IDE plug-ins

http://download.eclipse.org/releases/juno

Within Eclipse IDE, get a list of plugins at Help -> Install New Software -> Select a repo -> select a plugin -> go to More -> General Information -> Identifier

   <pre>eclipse -application org.eclipse.equinox.p2.director \
-destination d:/eclipse/ \
-profile SDKProfile  \
-clean -purgeHistory  \
-noSplash \
-repository http://download.eclipse.org/releases/juno/ \
-installIU org.eclipse.cdt.feature.group, \
   org.eclipse.egit.feature.group
   </pre>

   "Equinox" is the runtime environment of Eclipse, which is the <a target="_blank" href="http://www.vogella.de/articles/OSGi/article.html">reference implementation of OSGI</a>.
   Thus, Eclipse plugins are architectually the same as bundles in OSGI.

   Notice that there are different versions of Eclipse repositories, such as "juno".

   PROTIP: Although one can install several at once, do it one at a time to see if you can actually use each one.
   Some of them:

   <pre>
   org.eclipse.cdt.feature.group, \
   org.eclipse.egit.feature.group, \
   org.eclipse.cdt.sdk.feature.group, \
   org.eclipse.linuxtools.cdt.libhover.feature.group, \
   org.eclipse.wst.xml_ui.feature.feature.group, \
   org.eclipse.wst.web_ui.feature.feature.group, \
   org.eclipse.wst.jsdt.feature.feature.group, \
   org.eclipse.php.sdk.feature.group, \
   org.eclipse.rap.tooling.feature.group, \
   org.eclipse.linuxtools.cdt.libhover.devhelp.feature.feature.group, \
   org.eclipse.linuxtools.valgrind.feature.group, \
   </pre>

   <a target="_blank" href="https://stackoverflow.com/questions/2692048/what-are-the-differences-between-plug-ins-features-and-products-in-eclipse-rcp">NOTE</a>:
   A feature group is a list of plugins and other features which can be understood as a logical separate project unit
   for the updates manager and for the build process.


<a name="FONTS"></a>

## Scape for Fonts in GitHub
 
Some developers have not put their stuff from GitHub into Homebrew. So we need to read (scrape) the website and see what is listed, then grab the text and URL to download.

Such is the situation with font files at 
https://github.com/adobe-fonts/source-code-pro/releases/tag/variable-fonts
The two files desired downloaded using the curl command are:

* https://github.com/adobe-fonts/source-code-pro/releases/download/variable-fonts/SourceCodeVariable-Italic.ttf
* https://github.com/adobe-fonts/source-code-pro/releases/download/variable-fonts/SourceCodeVariable-Roman.ttf

The files are downloaded into <a target="_blank" href="https://support.apple.com/en-us/HT201722">where MacOS holds fonts available to all users</a>: <tt>/Library/Fonts/</tt>

<a target="_blank" href="http://sourabhbajaj.com/mac-setup/iTerm/README.html">ITerm2 can make use of these font files</a>.

<a name="SayText"></a>

## Say text out loud

At the bottom of the script is a MacOS command that translates text into voice through the spearker:

say "script ended."  # through speaker

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