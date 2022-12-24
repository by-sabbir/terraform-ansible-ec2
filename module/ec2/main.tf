data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "allow_tls_http_ssh" {
  name        = "bastion-sg-blog"
  description = "Allow all inbound traffic"
  vpc_id      = var.vpc_id

  ingress = [
    {
      description      = "TLS"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = var.allowed_cidr
      ipv6_cidr_blocks = [ "::/0" ]
      self = false
      security_groups = []
      prefix_list_ids = []
    },
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = var.allowed_cidr
      ipv6_cidr_blocks = [ "::/0" ]
      self = false
      security_groups = []
      prefix_list_ids = []
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = var.allowed_cidr
      ipv6_cidr_blocks = [ "::/0" ]
      self = false
      security_groups = []
      prefix_list_ids = []
    }
  ]

  egress = [
    {
      description = "Allow All for Egress"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = [ "0.0.0.0/0" ]
      ipv6_cidr_blocks = [ "::/0" ]
      self = false
      security_groups = []
      prefix_list_ids = []
    }
  ]
  tags = {
      Name = "bastion-sg-blog"
      Environment = "test"
      Terraform = "true"
      Project = "Learning Terraform"
    }
}

resource "aws_instance" "bastion" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = "t2.micro"
  key_name          = "blog-admin"
  security_groups   = [ aws_security_group.allow_tls_http_ssh.id ]
  subnet_id         = var.subnet_id

  tags = {
    Name = "bastion-blog-ec2"
    Terraform = "true"
    Environment = "test"
    Project = "Learning Terraform"
  }
  root_block_device {
    delete_on_termination = true
    volume_size = 8
    tags = {
      Name = "ebs-blog-bastion"
      Environment = "test"
      Terraform = "true"
      Project = "Learning Terraform"
    }
  }

  connection {
    type = "ssh"
    user        = "ubuntu"
    private_key = "${file(var.private_key_path)}"
    host = "${self.public_ip}"
  }

  provisioner "file" {
    source      = "./ansible/playbook.yaml"
    destination = "/home/ubuntu/playbook.yaml"
  }

  provisioner "file" {
    source      = "./ansible/install.sh"
    destination = "/home/ubuntu/install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/install.sh",
      "/home/ubuntu/install.sh",
    ]
  }
}

resource "aws_eip" "bastion" {
  vpc = true
  instance = aws_instance.bastion.id
  associate_with_private_ip = aws_instance.bastion.private_ip
  tags = {
    Name = "bastion-blog-eip"
    Terraform = "true"
    Environment = "test"
    Project = "Learning Terraform"
  }
}