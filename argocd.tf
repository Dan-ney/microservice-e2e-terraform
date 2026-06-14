locals {
  argocd_namespace = "argocd"
}

# ArgoCD Helm Release + Root App Creation
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "6.7.0"
  namespace        = local.argocd_namespace
  create_namespace = true
  timeout          = 600

values = [
    file("${path.root}/files/argocd-values.yaml"),
    <<-EOT
    server:
      additionalApplications:
        - name: root
          namespace: argocd
          project: default
          source:
            repoURL: "https://github.com/Dan-ney/microservice-e2e-gitops.git"
            targetRevision: HEAD
            path: argo-apps
          destination:
            server: "https://kubernetes.default.svc"
            namespace: argocd
          syncPolicy:
            automated:
              prune: true
              selfHeal: true
    EOT
  ]

  depends_on = [
    module.gke,
    module.argocd_workload_identity
  ]
}

# Get Admin Password
data "kubernetes_secret" "argocd_admin_password" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = local.argocd_namespace
  }
  depends_on = [helm_release.argocd]
}

module "argocd_workload_identity" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"

  project_id          = var.project_id
  name                = var.argocd_workload_identity_name
  namespace           = local.argocd_namespace
  use_existing_k8s_sa = true
  use_existing_gcp_sa = false
  k8s_sa_name         = var.argocd_repo_sa_name
  annotate_k8s_sa     = false
  roles               = ["roles/artifactregistry.reader"]
}
