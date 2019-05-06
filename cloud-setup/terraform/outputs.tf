
# output "kubeconfig-alpha" {
#   value = <<KUBECONFIG
# apiVersion: v1
# clusters:
# - cluster:
#     server: ${digitalocean_kubernetes_cluster.k8s-workshop.kube_config.0.host}
#     certificate-authority-data: ${digitalocean_kubernetes_cluster.k8s-workshop.kube_config.0.cluster_ca_certificate}
#   name: kubernetes
# contexts:
# - context:
#     cluster: kubernetes
#     user: alpha
#   name: alpha
# current-context: alpha
# kind: Config
# preferences: {}
# users:
# - name: alpha
#   user:
#     token: ${lookup(data.kubernetes_secret.sa-secret.0.data, "token", "")}
# KUBECONFIG
# }

locals {
  tokens = "${data.kubernetes_secret.sa-secret.*.data}"
}

output "kubeconfig-tokens" {
  value = "${jsonencode(local.tokens)}"
}

output "kubeconfig-admin" {
  value = "${digitalocean_kubernetes_cluster.k8s-workshop.kube_config.0.raw_config}"
}
