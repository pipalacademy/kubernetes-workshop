terraform {
  backend "pg" {}
}

provider "digitalocean" {
  token = "${var.digitalocean_api_token}"

  spaces_access_id  = "${var.digitalocean_spaces_key}"
  spaces_secret_key = "${var.digitalocean_spaces_secret}"
}

data "digitalocean_image" "docker-node" {
  name = "docker-node"
}

resource "digitalocean_droplet" "node" {
  image  = "${data.digitalocean_image.docker-node.image}"
  name   = "${var.names[count.index]}"
  region = "${var.region}"
  size   = "s-1vcpu-1gb"
  count  = "${var.num_nodes}"  
}

resource "digitalocean_record" "subdomain" {
  domain = "pipal.in"
  type   = "A"
  name   = "${var.names[count.index]}.docker"
  value  = "${element(digitalocean_droplet.node.*.ipv4_address, count.index)}"
  count  = "${var.num_nodes}"  
}

# resource "digitalocean_record" "lb" {
#   domain = "pipal.in"
#   type   = "A"
#   name   = "k8s"
#   value  = "${var.lb_ip}"
# }

resource "digitalocean_record" "wildcard" {
  domain = "pipal.in"
  type   = "CNAME"
  name   = "*.k8s"
  value  = "k8s.pipal.in."
}

resource "digitalocean_record" "wildcard-subdomain" {
  domain = "pipal.in"
  type   = "CNAME"
  name   = "*.${var.names[count.index]}.k8s"
  value  = "k8s.pipal.in."
  count  = "${var.num_nodes}"
}

# resource "digitalocean_spaces_bucket" "klickr" {
#   name   = "klickr-${var.names[count.index]}"
#   region = "sgp1"
#   acl = "public-read"

#   force_destroy = "true"
#   count  = "${var.num_nodes}"
# }

# Create a new database cluster
# resource "digitalocean_database_cluster" "klickr" {
#   name       = "klickr"
#   engine     = "pg"
#   version    = "11"
#   size       = "db-s-1vcpu-1gb"
#   region     = "blr1"
#   node_count = 1
# }

# resource "digitalocean_record" "klickr-db" {
#   domain = "pipal.in"
#   name   = "klickr-db"

# ## DO is refusing to create CNAME to their own domans
# #  type   = "CNAME"
# #  value  = "${digitalocean_database_cluster.klickr.host}."
#   type = "A"
#   value = "68.183.90.205"
# }


# provider "postgresql" {
#   host            = "${digitalocean_database_cluster.klickr.host}"
#   port            = "${digitalocean_database_cluster.klickr.port}"
#   database        = "${digitalocean_database_cluster.klickr.database}"
#   username        = "${digitalocean_database_cluster.klickr.user}"
#   password        = "${digitalocean_database_cluster.klickr.password}"
#   sslmode         = "require"
#   superuser = false
#   connect_timeout = 15
# }

# resource "postgresql_role" "pipal" {
#   name     = "pipal"
#   login    = true
#   password = "${var.db_password}"
# #  superuser = false
#   depends_on = ["digitalocean_database_cluster.klickr"]
# }

# resource "postgresql_database" "klickr-db" {
#   name              = "${var.names[count.index]}"
#   owner             = "${postgresql_role.pipal.name}"
#   template          = "template0"
#   lc_collate        = "C"
#   connection_limit  = -1
#   allow_connections = true

#   count  = "${var.num_nodes}"

# }
