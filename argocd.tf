locals {
  argocd_namespace = "argocd"
}

# ArgoCD Service Account
resource "google_service_account" "argocd" {
  account_id   = "${var.environment}-argocd-sa"
  display_name = "ArgoCD Service Account"
  project      = var.project_id
}

resource "google_project_iam_member" "argocd_ar_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.argocd.email}"
}

resource "google_service_account_iam_member" "argocd_workload_identity" {
  service_account_id = google_service_account.argocd.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[argocd/argocd-repo-server]"
}

# ArgoCD Helm Release
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "6.7.0"
  namespace        = local.argocd_namespace
  create_namespace = true

  values = [file("${path.root}/files/argocd-values.yaml")]

  lifecycle {
    ignore_changes = [metadata]
  }

  depends_on = [
    module.gke,
    google_service_account.argocd
  ]
}

# App of Apps
resource "kubernetes_manifest" "argocd_root_app" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "root"
      namespace = local.argocd_namespace
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/Dan-ney/microservice-e2e-gitops.git"
        targetRevision = "HEAD"
        path           = "argo-apps"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = local.argocd_namespace
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
      }
    }
  }
  depends_on = [helm_release.argocd]
}

# Get Admin Password
data "kubernetes_secret" "argocd_admin_password" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = local.argocd_namespace
  }
  depends_on = [helm_release.argocd]
}
