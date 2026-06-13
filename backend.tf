terraform {
  backend "gcs" {
    bucket = "terraform-statefile-microservices"
  }
}
