variable "allowed_cidr" {
  type = list(string)
  default = [ "0.0.0.0/0" ]
}

variable "subnet_id" {
  default = "subnet-02c0a29574f0e18fd"
}

variable "vpc_id" {
  default = "vpc-002fc5fa915a6dfec"
}

variable "private_key_path" {
  default = "/home/vagrant/id_ed25519_test"
}