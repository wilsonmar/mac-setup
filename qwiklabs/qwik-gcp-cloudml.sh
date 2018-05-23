#!/usr/local/bin/bash

# qwik-gcp-cloudml.sh in https://github.com/wilsonmar/DevSecOps/tree/master/qwiklabs
# by Wilson Mar, Wisdom Hambolu, and others.
# This performs the commands in "Cloud ML Engine: Qwik Start" at
#    https://google-run.qwiklab.com/focuses/725?parent=catalog
# Instead of typing, copy this command to run in the console within the cloud:
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/wilsonmar/DevSecOps/master/qwiklabs/qwik-gcp-cloudml.sh)"
# This adds steps to grep values into variables and verifications

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

# NOTE: It's not necessary to look at the Python code to run this lab, but if you are interested, 
# you can poke around the repo in the Cloud Shell editor.
cloudshell_open --repo_url "https://github.com/googlecloudplatform/cloudml-samples" \
   --page "editor" --open_in_editor "census/estimator"
   # QUESTION: Why --open_in_editor "census/estimator" in a new browser tab?
cd census/estimator

# TODO: Verify I'm in pwd = /home/google462324_student/cloudml-samples/census/estimator

# Download from Cloud Storage into new data folder:
mkdir data
gsutil -m cp gs://cloudml-public/census/data/* data/
   # Copying gs://cloudml-public/census/data/adult.data.csv...
   # Copying gs://cloudml-public/census/data/adult.test.csv...
   # \ [2/2 files][  5.7 MiB/  5.7 MiB] 100% Done
   # Operation completed over 2 objects/5.7 MiB.

# Set the TRAIN_DATA and EVAL_DATA variables to your local file paths by running the following commands:
TRAIN_DATA=$(pwd)/data/adult.data.csv
EVAL_DATA=$(pwd)/data/adult.test.csv

# View data:
head data/adult.data.csv

# Install dependencies (Tensorflow):
sudo pip install tensorflow==1.4.1  # yeah, I know it's old
   # PROTIP: This takes several minutes:
   #   Found existing installation: tensorflow 1.8.0
   # Successfully installed tensorflow-1.4.1 tensorflow-tensorboard-0.4.0

# Run a local trainer in Cloud Shell to load your Python training program and starts a training process in an environment that's similar to that of a live Cloud ML Engine cloud training job.
MODEL_DIR=output  # folder name
# Delete the contents of the output directory in case data remains from a previous training run:
rm -rf $MODEL_DIR/*

gcloud ml-engine local train \
    --module-name trainer.task \
    --package-path trainer/ \
    -- \
    --train-files $TRAIN_DATA \
    --eval-files $EVAL_DATA \
    --train-steps 1000 \
    --job-dir $MODEL_DIR \
    --eval-steps 100
# The above trains a census model to predict income category given some information about a person.

# Launch the TensorBoard server to view jobs running:
# tensorboard --logdir=output --port=8080    
# Now manually Select "Preview on port 8080" from the Web Preview menu at the top of the Cloud Shell.
# Manually shut down TensorBoard at any time by typing ctrl+c on the command-line.

#The output/export/census directory holds the model exported as a result of running training locally. List that directory to see the generated timestamp subdirectory:
ls output/export/census/

# TODO: Copy the timestamp that is generated. Then edit the following command to use that timestamp:

gcloud ml-engine local predict \
  --model-dir output/export/census/<timestamp> \
  --json-instances ../test.json

# You should see a result that looks something like the following:
# CLASS_IDS  CLASSES  LOGISTIC                LOGITS                PROBABILITIES
# [0]        [u'0']   [0.06775551289319992]  [-2.6216893196105957]  [0.9322444796562195, 0.06775551289319992]
# Where class 0 means income \<= 50k and class 1 means income >50k.

