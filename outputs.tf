output "ec2_public_ip" {
  value = module.ec2-bastion.eip
}