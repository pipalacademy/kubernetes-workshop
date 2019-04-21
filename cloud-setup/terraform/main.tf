
data "digitalocean_image" "docker-node" {
  name = "docker-node"
}

resource "digitalocean_droplet" "node" {
  image  = "${data.digitalocean_image.docker-node.image}"
  name   = "${var.names[count.index]}"
  region = "${var.digitalocean_region}"
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
