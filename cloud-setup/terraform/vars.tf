
variable "digitalocean_api_token" {
  type = "string"
}

variable "digitalocean_spaces_key" {
  type = "string"
}

variable "digitalocean_spaces_secret" {
  type = "string"
}

variable "region" {
  type = "string"
  default = "blr1"
}

variable "names" {
  type = "list"
  default = [
    "alpha",
    "beta",
    "gamma",
    "delta",
    "epsilon",
    "zeta",
    "eta",
    "theta",
    "iota",
    "kappa",
    "lambda",
    "mu",
    "nu",
    "xi",
    "omicron",
    "pi",
    "rho",
    "sigma",
    "tau",
    "upsilon",
    "phi",
    "chi",
    "psi",
    "omega"
  ]
}

variable "num_nodes" {
  type = "string"
  default = "22"
}

variable "k8s_cluster_name" {
  type = "string"
  default = "k8s-workshop"
}

variable "k8s_node_count" {
  type = "string"
  default = "5"
}

variable "k8s_node_size" {
  type = "string"
  default = "s-1vcpu-2gb"
}

variable "k8s_version" {
  type = "string"
  default = "1.13.5-do.1"
}

variable "k8s_enabled" {
  description = "whether or not to create k8s cluster"
  default = 1
}

variable "lb_ip" {
  description = "IP addess of the load balancer"
  default = "139.59.50.40"
}
