# Jenkins Service Account
module "jenkins_sa" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 4.0"

  project_id   = var.project_id
  names        = ["${var.environment}-jenkins-sa"]
  display_name = "Jenkins Service Account"
  description  = "SA attached to Jenkins GCE VM"

  project_roles = [
    "${var.project_id}=>roles/artifactregistry.writer",
    "${var.project_id}=>roles/artifactregistry.reader",
    "${var.project_id}=>roles/container.developer",
    "${var.project_id}=>roles/secretmanager.secretAccessor",
    "${var.project_id}=>roles/logging.logWriter",
    "${var.project_id}=>roles/monitoring.metricWriter",
  ]
}

# Firewall Rules
module "jenkins_firewall" {
  source  = "terraform-google-modules/network/google//modules/firewall-rules"
  version = "~> 9.0"

  project_id   = var.project_id
  network_name = module.vpc.vpc_name

  rules = [
    {
      name                    = "${var.environment}-jenkins-http"
      description             = "Allow HTTP and HTTPS to Jenkins"
      direction               = "INGRESS"
      priority                = 1000
      ranges                  = ["0.0.0.0/0"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = ["jenkins"]
      target_service_accounts = null
      allow = [
        {
          protocol = "tcp"
          ports    = ["80", "443"]
        }
      ]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name                    = "${var.environment}-jenkins-ssh"
      description             = "Allow SSH to Jenkins"
      direction               = "INGRESS"
      priority                = 1000
      ranges                  = ["0.0.0.0/0"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = ["jenkins"]
      target_service_accounts = null
      allow = [
        {
          protocol = "tcp"
          ports    = ["22"]
        }
      ]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    }
  ]
}

# Static Public IP
resource "google_compute_address" "jenkins" {
  name    = "${var.environment}-jenkins-ip"
  project = var.project_id
  region  = var.region
}

# Jenkins VM
resource "google_compute_instance" "jenkins" {
  name         = "${var.environment}-jenkins"
  machine_type = "e2-standard-2"
  zone         = var.zone
  project      = var.project_id

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 50
      type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = module.vpc.subnet_name
    access_config {
      nat_ip = google_compute_address.jenkins.address
    }
  }

  service_account {
    email  = module.jenkins_sa.service_accounts_map["${var.environment}-jenkins-sa"].email
    scopes = ["cloud-platform"]
  }

  metadata = {
    startup-script = file("${path.root}/scripts/jenkins-startup.sh")
  }

  tags = ["jenkins"]

  labels = {
    environment = var.environment
  }

  depends_on = [
    module.jenkins_sa,
    module.jenkins_firewall,
    google_project_service.required_apis,
    module.vpc
  ]
}
