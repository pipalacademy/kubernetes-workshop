
resource "digitalocean_kubernetes_cluster" "k8s-workshop" {
  name    = "${var.k8s_cluster_name}"
  region  = "${var.region}"
  version = "${var.k8s_version}"
  tags    = []
  count   = "${var.k8s_enabled}"

  node_pool {
    name       = "${var.k8s_cluster_name}"
    size       = "${var.k8s_node_size}"
    node_count = "${var.k8s_node_count}"
  }
}

provider "kubernetes" {
  host = "${digitalocean_kubernetes_cluster.k8s-workshop.endpoint}"

  client_certificate     = "${base64decode(digitalocean_kubernetes_cluster.k8s-workshop.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(digitalocean_kubernetes_cluster.k8s-workshop.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.k8s-workshop.kube_config.0.cluster_ca_certificate)}"
}

resource "kubernetes_namespace" "ns" {
  metadata {
    name   = "${var.names[count.index]}"
  }
  count   = "${var.k8s_enabled * var.num_nodes}"

  depends_on = ["digitalocean_kubernetes_cluster.k8s-workshop"]
}

resource "kubernetes_service_account" "sa" {
  metadata {
    name = "${var.names[count.index]}"
    namespace = "${var.names[count.index]}"
  }

  count   = "${var.k8s_enabled * var.num_nodes}"
  depends_on = ["kubernetes_namespace.ns"]  
}


data "kubernetes_secret" "sa-secret" {
  metadata = {
    name      = "${element(kubernetes_service_account.sa.*.default_secret_name, count.index)}"
    namespace = "${var.names[count.index]}"
  }
  count   = "${var.k8s_enabled * var.num_nodes}"  
}

resource "kubernetes_cluster_role_binding" "k8s" {
    metadata {
      name = "${var.names[count.index]}"
    }
    role_ref {
        api_group = "rbac.authorization.k8s.io"
        kind = "ClusterRole"
        name = "cluster-admin"
    }
    subject {
        kind = "ServiceAccount"
        name = "${var.names[count.index]}"
        namespace = "${var.names[count.index]}"
    }
    count   = "${var.k8s_enabled * var.num_nodes}"  
}

resource "kubernetes_secret" "klickr" {
  metadata {
    name = "klickr"
    namespace = "${var.names[count.index]}"
  }

  data {
    "AWS_REGION_NAME" = "sgp1",
    "AWS_ENDPOINT_URL" = "https://sgp1.digitaloceanspaces.com"
    "AWS_ACCESS_KEY_ID" = "${var.digitalocean_spaces_key}"
    "AWS_SECRET_ACCESS_KEY" = "${var.digitalocean_spaces_secret}"
    "STORAGE_S3_BUCKET" = "${element(digitalocean_spaces_bucket.klickr.*.name, count.index)}"
    "STORAGE_S3_BASE_URL" = "https://${element(digitalocean_spaces_bucket.klickr.*.bucket_domain_name, count.index)}"
  }

  count   = "${var.k8s_enabled * var.num_nodes}"
}
