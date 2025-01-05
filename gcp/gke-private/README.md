
## Install gcloud using below script

```bash
wget https://raw.githubusercontent.com/prayag-sangode/gcp/refs/heads/main/gcloud-install.sh
bash gcloud-install.sh
which gcloud
gcloud version
```

## Authenticate 
```bash
gcloud auth login
gsutil ls
gcloud storage buckets list
```

## Create service account and download json file
```bash
wget https://raw.githubusercontent.com/prayag-sangode/gcp/refs/heads/main/gcp-service-account.sh
bash gcp-service-account.sh
cat GCP-SA-key.json
```

## Create bucket for storing terraform state file
```bash
gcloud storage buckets create gs://gke-tf-19159-bkt --location=US
gsutil ls
```

## Remove service account and bucket
```bash
gcloud iam service-accounts delete GCP-SA@gcpproject101.iam.gserviceaccount.com --project=gcpproject101
gsutil rm -r gs://gke-tf-19159-bkt
```

## Terraform GCP authentication
```bash
export GOOGLE_APPLICATION_CREDENTIALS="/home/prayag/GCP-SA-key.json"
```


## List compute instances
```bash
gcloud compute instances list
```

## gcloud ssh
```bash
gcloud compute ssh bastion-host --zone=us-central1-a
```

# GCloud Installation and Setup for Bastion Host

This script installs and configures the necessary Google Cloud SDK components for GKE access on the Bastion host.

## Prerequisites
- A Bastion host with access to the Google Cloud environment.
- Google Cloud SDK installed. If not installed, please follow the instructions [here](https://cloud.google.com/sdk/docs/install) to install the Google Cloud SDK.

## Steps

### 1. Download the `gcloud-install.sh` Script
Download the installation script from GitHub:

```bash
curl -O https://raw.githubusercontent.com/prayag-sangode/gcp/refs/heads/main/gcloud-install.sh
```

### 2. Run the `gcloud-install.sh` Script
Execute the script to ensure the Google Cloud SDK and necessary components are installed:

```bash
bash gcloud-install.sh
```

### 3. Update the GCloud SDK
Once the SDK is installed, update it to the latest version:

```bash
./google-cloud-sdk/bin/gcloud components update
```

### 4. Install GKE Authentication Plugin
Install the `gke-gcloud-auth-plugin` for Kubernetes authentication:

```bash
./google-cloud-sdk/bin/gcloud components install gke-gcloud-auth-plugin
```

### 5. Update `kubectl` Component
Ensure that the `kubectl` component is up to date:

```bash
./google-cloud-sdk/bin/gcloud components update kubectl
```

## Acces GKE cluster
Once all components are installed and updated, you can use the `gcloud` and `kubectl` commands to interact with your Google Kubernetes Engine clusters from the Bastion host.
```bash
./google-cloud-sdk/bin/gcloud container clusters get-credentials my-gke-cluster --zone us-central1-a --project gcpproject101
./google-cloud-sdk/bin/kubectl get nodes
```
## Deployment
```bash
./google-cloud-sdk/bin/kubectl apply -f deployment.yaml
```

## Curl LB to access application
```bash
curl <LB-IP>
```
