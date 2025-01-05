
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
