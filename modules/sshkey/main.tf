resource "aws_key_pair" "blog-admin" {
  key_name = "blog-admin"
  public_key = var.public_key
  tags = {
    Name = "pubkey-blog-admin"
    Terraform = "true"
    Project = "blog.com"
  }
}
