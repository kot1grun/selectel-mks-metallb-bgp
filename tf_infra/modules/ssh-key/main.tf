# SSH-ключ из файла
data "local_file" "ssh_pubkey" {
  filename = pathexpand("~/.ssh/id_ed25519.pub")
}

resource "openstack_compute_keypair_v2" "default_ssh_keypair" {
  name       = var.ssh_keypair_name
  region     = var.region_name
  public_key = data.local_file.ssh_pubkey.content
}
