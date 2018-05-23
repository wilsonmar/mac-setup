kubernetes-gcp.sh

# kubernetes-gcp.sh in https://github.com/wilsonmar/kubernetes
# This performs the commands in:
# https://google-run.qwiklab.com/focuses/639?parent=catalog
# Instead of typing, copy this command to run in the console within the cloud:
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/wilsonmar/mac-setup/master/kubernetes-gcp.sh)"

#gcloud auth list
   #           Credentialed Accounts
   # ACTIVE  ACCOUNT
   #*       google462324_student@qwiklabs.net
   #To set the active account, run:
   #    $ gcloud config set account `ACCOUNT`

GCP_PROJECT=$(gcloud config list project | grep project | awk -F= '{print $2}' )
   # awk -F= '{print $2}'  extracts 2nd word in:
   # project = qwiklabs-gcp-9cf8961c6b431994
   # Your active configuration is: [cloudshell-19147]

# echo $GCP_PROJECT  # response: "qwiklabs-gcp-9cf8961c6b431994"
RESPONSE=$(gcloud compute project-info describe --project $GCP_PROJECT)
   # Extract from:
   #- key: google-compute-default-zone
   # value: us-central1-a
   #- key: google-compute-default-region
   # value: us-central1
#TODO: GCP_REGION=$(echo $RESPONSE | grep project | awk -F= '{print $2}' )

gcloud config set "$GCP_PROJECT"
   # Updated property [core/project].

gcloud config set compute/zone "$GCP_REGION"

GCP_REGION="us-west1-a"


git clone https://github.com/googlecodelabs/orchestrate-with-kubernetes.git
cd orchestrate-with-kubernetes/kubernetes

# Create a cluster with five n1-standard-1 nodes :
gcloud container clusters create bootcamp --num-nodes 5 \
   --scopes "https://www.googleapis.com/auth/projecthosting,storage-rw"

# TODO: (this will take a few minutes to complete)
#LOOP until process is done...

kubectl explain deployment

# See all fields:
kubectl explain deployment --recursive

# understand the structure of a Deployment object and understand what the individual fields do:
kubectl explain deployment.metadata.name

# Update deployments/auth.yaml cs file:
sed -i // deployments/auth.yaml
...
containers:
- name: auth
  image: kelseyhightower/auth:1.0.0
...

kubectl create -f deployments/auth.yaml

# Verify Deployments created:
kubectl get deployments

# Verify ReplicaSet created for the Deployment:
kubectl get replicasets

#  view the Pods that were created as part of our Deployment. 
# The single Pod is created by the Kubernetes when the ReplicaSet is created.
kubectl get pods

# create the auth service:
kubectl create -f services/auth.yaml

#  create and expose the hello Deployment:
kubectl create -f deployments/hello.yaml
kubectl create -f services/hello.yaml

# create and expose the frontend Deployment.

kubectl create secret generic tls-certs --from-file tls/
kubectl create configmap nginx-frontend-conf --from-file=nginx/frontend.conf
kubectl create -f deployments/frontend.yaml
kubectl create -f services/frontend.yaml

# Interact with the frontend by grabbing its external IP and then curling to it:
kubectl get services frontend
EXTERNAL-IP=$(kubectl get svc frontend -o=jsonpath="{.status.loadBalancer.ingress[0].ip}")
curl -ks "https://$EXTERNAL-IP"

# Scale a Deployment by updating the spec.replicas field. 
# Look at an explanation of this field using the kubectl explain command again.
kubectl explain deployment.spec.replicas

# The replicas field can be most easily updated using the kubectl scale command:
kubectl scale deployment hello --replicas=5

# After the Deployment is updated, Kubernetes will automatically update the associated ReplicaSet and start new Pods to make the total number of Pods equal 5.

# Verify that there are now 5 Pods for our auth running:
kubectl get pods | grep hello- | wc -l

# scale back the application:
kubectl scale deployment hello --replicas=3

# verify that you have the correct number of Pods:
kubectl get pods | grep hello- | wc -l

# You learned about Kubernetes deployments and how to manage & scale a group of Pods.

# Trigger a rolling update:
kubectl edit deployment hello
# TODO: ...
containers:
- name: hello
  image: kelseyhightower/hello:2.0.0
...

# See the new ReplicaSet that Kubernetes creates:
kubectl get replicaset

# See a new entry in the rollout history:
kubectl rollout history deployment/hello

#Pause a rolling update if you detect problems with a running rollout:
kubectl rollout pause deployment/hello

# Verify the current state of the rollout:
kubectl rollout status deployment/hello

# Cerify this on the Pods directly:
kubectl get pods -o jsonpath --template='{range .items[*]}{.metadata.name}{"\t"}{"\t"}{.spec.containers[0].image}{"\n"}{end}'

# Resume a paused rolling update, with some pods are at the new version and 
# some pods are at the older version:
kubectl rollout resume deployment/hello

# When the rollout is complete, you should see the following when running the status command.
kubectl rollout status deployment/hello
   # OUTPUT: deployment "hello" successfully rolled out

# Rollback an update if a bug was detected in your new version. 
# Since the new version is presumed to have problems, any users connected to the new Pods will experience those issues.
# You will want to roll back to the previous version so you can investigate and then release a version that is fixed properly.
kubectl rollout undo deployment/hello

# Verify the roll back in the history:
kubectl rollout history deployment/hello

# Verify that all the Pods have rolled back to their previous versions:
kubectl get pods -o jsonpath --template='{range .items[*]}{.metadata.name}{"\t"}{"\t"}{.spec.containers[0].image}{"\n"}{end}'

# In order to mitigate risk associated with new releases, use
# Canary deployments allow release of a change to a small subset of your users :
# create a new canary deployment for the new version:

cat deployments/hello-canary.yaml

#  create the canary deployment:
kubectl create -f deployments/hello-canary.yaml

# After the canary deployment is created, you should have two deployments, 
# hello and hello-canary. Verify this:
kubectl get deployments

# On the hello service, the selector uses the app:hello selector which will match pods in both the prod deployment and canary deployment. However, because the canary deployment has a fewer number of pods, it will be visible to fewer users.

# verify the hello version being served by the request:
curl -ks https://`kubectl get svc frontend -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version

# Run this several times and you should see that some of the requests are 
# served by hello 1.0.0 and a small subset (1/4 = 25%) are served by 2.0.0.


# Clean up. Delete it and the service we created:
kubectl delete deployment hello-canary

# A major downside of blue-green deployments is that you will need to have at least 
# 2x the resources in your cluster necessary to host your application. 
# Make sure you have enough resources in your cluster before deploying 
# both versions of the application at once.

# Create the green deployment:
kubectl create -f deployments/hello-green.yaml

# TODO: Once you have a green deployment and it has started up properly, 

# verify that the current version of 1.0.0 is still being used:
curl -ks https://`kubectl get svc frontend -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version

# update the service to point to the new version:
kubectl apply -f services/hello-green.yaml

# With the service is updated, the "green" deployment will be used immediately. 
# You can now verify that the new version is always being used.
curl -ks https://`kubectl get svc frontend -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version

# Create the green deployment:
kubectl create -f deployments/hello-green.yaml

# TODO: Once you have a green deployment and it has started up properly, 

# verify that the current version of 1.0.0 is still being used:
curl -ks https://`kubectl get svc frontend -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version

# update the service to point to the new version:
kubectl apply -f services/hello-green.yaml

# With the service is updated, the "green" deployment will be used immediately. 

# Verify that the new version is always being used:
curl -ks https://`kubectl get svc frontend -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version

