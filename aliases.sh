#!/usr/bin/env bash
# This is ~/aliases.sh from template https://github.com/wilsonmar/mac-setup/blob/main/aliases.sh
echo "ali.sh"
if command -v minikube >/dev/null; then  # installed:
   response=$( minikube status )
   search="kubelet: Running"
   if [[ "$response" == *"$search"* ]]; then
      echo "kubelet: Running!"
      export use_minikube="True"
   else
      export use_minikube="False"
      echo "kubelet: NOT Running! Run mk8s"
      alias mk8s="minikube delete;minikube start --driver=docker --memory=4096"
      alias k="kubectl"
   fi
else
   export use_minikube="False"
   echo "minikube not installed!"
fi

if [[ "$use_minikube" == "True" ]]; then
   echo "Use minikube!"
else
   echo "DO NOT Use minikube!"
fi