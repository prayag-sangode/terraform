provider "google" {
  credentials = file("/home/prayag/GCP-SA-key.json")
  project     = "gcpproject101"
  region      = "us-central1" 
}

# Backend configuration for storing tfstate in Google Cloud Storage (GCS)

terraform {
  backend "gcs" {
    bucket  = "gke-tf-19159-bkt"
    prefix  = "terraform/state"
  }
}

