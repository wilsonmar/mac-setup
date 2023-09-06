#!/usr/bin/env bash
# mac-ec2-client.sh - Install VNC on mac client within AWS EC2 intance.
# from a remote developer on a Mac laptop 
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/wilsonmar/mac-setup/main/mac-ec2-client.zsh)"
# Based on https://aws.amazon.com/premiumsupport/knowledge-center/ec2-mac-instance-gui-access/

set -euxo pipefail

# Install and start VNC (macOS screen sharing SSH):
sudo defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing \
   -dict Disabled -bool false
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist
# Provide password for sudo.

# Set a password for ec2-user:
sudo /usr/bin/dscl . -passwd /Users/ec2-user

# Create an SSH tunnel to the VNC port:
# Replace keypair_file with your SSH key path and 
# 192.0.2.0 with your instance's IP address or DNS name:
export EC2_USER_IP=192.0.2.0
ssh -i keypair_file -L 5900:localhost:5900 "ec2-user@$EC2_USER_IP"

# To encrypt communication, the SSH session should be 
# running while you're in the remote session.

# Using a VNC client, connect to localhost:5900.
# On macOS, use its built-in VNC client.
# On Windows, use RealVNC viewer for Windows.
#    TightVNC running on Windows don't work with this resolution.
# On Linux, use Remmina. 

# When the GUI of the macOS launches,
# connect to the remote session of the Mac instance 
# as ec2-user using the password that you set in step 3.

